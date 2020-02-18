--===========================================================================
--
-- PAYMENT DATA PROVIDER
--
--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'PaymentDataProvider_GetPaymentDetailsFromERA'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.PaymentDataProvider_GetPaymentDetailsFromERA
GO

--===========================================================================
-- GET PAYMENT DETAILS FROM ERA
-- Parses out the ERA and brings back data required for the payment screen to create a new payment record.
-- exec PaymentDataProvider_GetPaymentDetailsFromERA 101374  
-- exec PaymentDataProvider_GetPaymentDetailsFromERA 103944 
-- exec PaymentDataProvider_GetPaymentDetailsFromERA 98441 
-- exec PaymentDataProvider_GetPaymentDetailsFromERA 84777
-- exec PaymentDataProvider_GetPaymentDetailsFromERA 87200
-- exec PaymentDataProvider_GetPaymentDetailsFromERA 261
--===========================================================================
CREATE PROCEDURE dbo.PaymentDataProvider_GetPaymentDetailsFromERA
	@ClearinghouseResponseID INT
AS
BEGIN
	SET NOCOUNT ON

	--Get ERA Response XML
	DECLARE @ERAXml XML
	DECLARE @PaymentNotes VARCHAR(100)
	SELECT @ERAXml=CAST(FileContents AS VARCHAR(MAX)),
	@PaymentNotes=[Title]
	FROM ClearinghouseResponse
	WHERE ClearinghouseResponseID=@ClearinghouseResponseID

	DECLARE @PayerName VARCHAR(256)
	DECLARE @PayerAddress VARCHAR(256)
	DECLARE @PayerCity VARCHAR(128)
	DECLARE @PayerState VARCHAR(2)
	DECLARE @PayerZip VARCHAR(20)
	DECLARE @PayerNumber VARCHAR(20)
	DECLARE @PayerPhone VARCHAR(20)

	DECLARE @PayeeName VARCHAR(256)
	DECLARE @PayeeIDNumber VARCHAR(50)
	DECLARE @PayeeAddress1 VARCHAR(256)
	DECLARE @PayeeAddress2 VARCHAR(256)
	DECLARE @PayeeCity VARCHAR(128)
	DECLARE @PayeeState VARCHAR(2)
	DECLARE @PayeeZip VARCHAR(20)

	DECLARE @Loop2100Count INT
	DECLARE @Loop2110Count INT

	DECLARE @AdjudicationDate DATETIME
	SET @AdjudicationDate=@ERAXml.value('(/loop/segment[@name="DTM"]/DTM02)[1]','DATETIME')

	--Build Trace tables to associate 2100 and 2110 loops
	DECLARE @xdoc INT

	EXEC sp_xml_preparedocument @xdoc OUTPUT, @ERAXml

	CREATE TABLE #GeneralPaymentInfo(PaymentMethod VARCHAR(10), PaymentDate VARCHAR(20), PaymentAmount MONEY, CheckNumber VARCHAR(100))
	INSERT INTO #GeneralPaymentInfo(PaymentMethod, PaymentDate, PaymentAmount, CheckNumber)
	SELECT PaymentMethod, PaymentDate, PaymentAmount, CheckNumber
	FROM OPENXML (@xdoc, '/loop[@name="ST"]',1)
	WITH (PaymentMethod VARCHAR(10) './segment[@name="BPR" and @qual="I"]/BPR04/text()',
		  PaymentDate VARCHAR(20) './segment[@name="BPR" and @qual="I"]/BPR16/text()',
		  PaymentAmount MONEY './segment[@name="BPR" and @qual="I"]/BPR02/text()',
		  CheckNumber VARCHAR(100) './segment[@name="TRN" and @qual="1"]/TRN02/text()')

	CREATE TABLE #PayerInfo(PayerName VARCHAR(256), PayerAddress VARCHAR(256), PayerCity VARCHAR(128), PayerState VARCHAR(2),
							PayerZip VARCHAR(20), PayerNumber VARCHAR(20), PayerPhone VARCHAR(20))
	INSERT INTO #PayerInfo(PayerName, PayerAddress, PayerCity, PayerState, PayerZip, PayerNumber, PayerPhone)
	SELECT PayerName, PayerAddress, PayerCity, PayerState, PayerZip, PayerNumber, PayerPhone
	FROM OPENXML (@xdoc, '//loop[@name="1000A"]', 1)
	WITH (PayerName VARCHAR(256) 'segment[@name="N1"]/N102/text()',
		  PayerAddress VARCHAR(256) 'segment[@name="N3"]/N301/text()',
		  PayerCity VARCHAR(128) 'segment[@name="N4"]/N401/text()',
		  PayerState VARCHAR(2) 'segment[@name="N4"]/N402/text()',
		  PayerZip VARCHAR(20) 'segment[@name="N4"]/N403/text()',
		  PayerNumber VARCHAR(20) 'segment[@name="REF"]/REF02/text()',
		  PayerPhone VARCHAR(20) 'segment[@name="PER"]/PER04/text()')

	CREATE TABLE #PayeeInfo(PayeeName VARCHAR(256), PayeeIDNumber VARCHAR(50), PayeeAddress1 VARCHAR(256), 
							PayeeAddress2 VARCHAR(256), PayeeCity VARCHAR(128), PayeeState VARCHAR(2), PayeeZip VARCHAR(20))
	INSERT INTO #PayeeInfo(PayeeName, PayeeIDNumber, PayeeAddress1, PayeeAddress2, PayeeCity, PayeeState, PayeeZip)
	SELECT PayeeName, PayeeIDNumber, PayeeAddress1, PayeeAddress2, PayeeCity, PayeeState, PayeeZip
	FROM OPENXML (@xdoc, '//loop[@name="1000B"]', 1)
	WITH (PayeeName VARCHAR(256) 'segment[@name="N1"]/N102/text()',
		  PayeeIDNumber VARCHAR(256) 'segment[@name="N1"]/N104/text()',
		  PayeeAddress1 VARCHAR(256) 'segment[@name="N3"]/N302/text()',
		  PayeeAddress2 VARCHAR(256) 'segment[@name="N3"]/N301/text()',
		  PayeeCity VARCHAR(128) 'segment[@name="N4"]/N401/text()',
		  PayeeState VARCHAR(2) 'segment[@name="N4"]/N402/text()',
		  PayeeZip VARCHAR(20) 'segment[@name="N4"]/N403/text()'
		 )

	CREATE TABLE #Segments(RID INT, Loop2100 BIT, SvcRID INT, Ln INT, SegName VARCHAR(20), SegQual VARCHAR(20),
									ItemName VARCHAR(100), ItemValue VARCHAR(500))
	INSERT INTO #Segments(Loop2100, Ln, SegName, SegQual, ItemName, ItemValue)
	SELECT 0, ln, name, qual, ItemName, ItemValue
	FROM OPENXML (@xdoc, '//loop[@name="2100" or @name="2110"]/segment[@name="SVC" or @name="CLP" or @name="NM1" or @name="DTM" or @name="REF"]
						  /*[local-name(.)="SVC01" or local-name(.)="CLP01" or local-name(.)="NM104" or local-name(.)="NM103" or local-name(.)="NM109" or
							 local-name(.)="DTM02" or local-name(.)="SVC02" or local-name(.)="SVC05" or local-name(.)="SVC07" or local-name(.)="REF02"
							 or local-name(.)="CLP02" or local-name(.)="CLP04"]',1)
	WITH (ln INT '../@ln',
		  name VARCHAR(20) '../@name',
		  qual VARCHAR(20) '../@qual',
		  ItemName VARCHAR(20) '@mp:localname',
		  ItemValue VARCHAR(500) 'text()'
		  )

	CREATE TABLE #Trace2100(RID INT IDENTITY(1,1), StartLoop INT, EndElement INT, EndLoop INT, 
							CLP01 VARCHAR(50), FirstName VARCHAR(64),
							LastName VARCHAR(64), ProviderNumber VARCHAR(50), ReceivedDate DATETIME, PaymentParticipationAmount MONEY, 
							Reversal BIT, Matched BIT, EOBXml XML, EOBXmlAppended BIT, ServiceLineCount INT, Stage INT)
	INSERT INTO #Trace2100(StartLoop, EndElement, EndLoop, Reversal, Matched, EOBXml, EOBXmlAppended)
	SELECT StartLoop, EndElement, EndLoop, 0, 0, EOBXml, 0 EOBXmlAppended
	FROM OPENXML(@xdoc, '//loop[@name="2100"]', 2)
	WITH (StartLoop INT './segment[1]/@ln',
		  EndElement INT './segment[position()=last()]/@ln',
		  EndLoop INT './loop[position()=last()]/segment[position()=last()]/@ln',
		  EOBXml XML '@mp:xmltext')

	CREATE TABLE #Trace2110_EOBXml(Ln INT, EOBXml XML, SvcRID INT, EOBXmlAppended BIT, Reversal BIT)
	INSERT INTO #Trace2110_EOBXml(Ln, EOBXml, EOBXmlAppended, Reversal)
	SELECT Ln, EOBXml, 0 EOBXmlAppended, 0 Reversal
	FROM OPENXML(@xdoc, '//loop[@name="2110"]',2)
	WITH (Ln INT './segment[1]/@ln',
		  EOBXml XML '@mp:xmltext')

	SET @Loop2100Count=@@ROWCOUNT

	EXEC sp_xml_removedocument @xdoc

	SELECT @PayerName=PayerName, @PayerAddress=PayerAddress, @PayerCity=PayerCity, @PayerState=PayerState, @PayerZip=PayerZip,
	@PayerNumber=PayerNumber, @PayerPhone=PayerPhone 
	FROM #PayerInfo

	SELECT @PayeeName=PayeeName, @PayeeIDNumber=PayeeIDNumber, @PayeeAddress1=PayeeAddress1, @PayeeAddress2=PayeeAddress2, 
	@PayeeCity=PayeeCity, @PayeeState=PayeeState, @PayeeZip=PayeeZip
	FROM #PayeeInfo

	UPDATE S SET RID=T.RID, Loop2100=CASE WHEN S.Ln<=T.EndElement THEN 1 ELSE 0 END
	FROM #Segments S INNER JOIN #Trace2100 T
	ON S.Ln BETWEEN T.StartLoop AND ISNULL(T.EndLoop,T.EndElement)

	DECLARE @LastLn INT
	SELECT @LastLn=MAX(Ln)
	FROM #Segments

	CREATE TABLE #Trace2110(SvcRID INT IDENTITY(1,1), RID INT, StartLoop INT, EndLoop INT, SVC01 VARCHAR(50), Charge MONEY, Units VARCHAR(12),
							ProcedureDateOfService DATETIME, ControlNumber VARCHAR(50), MedicareProviderNumber VARCHAR(50),
							ProcedureCode VARCHAR(16), Mod1 VARCHAR(16), Mod2 VARCHAR(16), Mod3 VARCHAR(16), Mod4 VARCHAR(16), Matched BIT, Reversal BIT,
							ProcedureCodeDictionaryID INT)
	INSERT INTO #Trace2110(RID, StartLoop, Matched, Reversal)
	SELECT RID, Ln, 0, 0
	FROM #Segments
	WHERE Loop2100=0 AND SegName='SVC' AND ItemName='SVC01'
	ORDER BY RID, Ln

	SET @Loop2110Count=@@ROWCOUNT

	UPDATE T1 SET EndLoop=T2.StartLoop-1
	FROM #Trace2110 T1 INNER JOIN #Trace2110 T2
	ON T1.SvcRID+1=T2.SvcRID

	UPDATE #Trace2110 SET EndLoop=@LastLn
	WHERE EndLoop IS NULL

	UPDATE S SET SvcRID=T.SvcRID
	FROM #Segments S INNER JOIN #Trace2110 T
	ON S.RID=T.RID AND S.Ln BETWEEN T.StartLoop AND T.EndLoop
	WHERE S.Loop2100=0

	UPDATE TE SET SvcRID=T.SvcRID
	FROM #Trace2110_EOBXml TE INNER JOIN #Trace2110 T
	ON TE.Ln BETWEEN T.StartLoop AND T.EndLoop

	UPDATE T SET CLP01=S.ItemValue
	FROM #Trace2100 T INNER JOIN #Segments S
	ON T.RID=S.RID
	WHERE S.Loop2100=1 AND SegName='CLP' AND ItemName='CLP01'

	UPDATE T SET Stage=CASE WHEN ItemValue IN ('1','2','3') THEN CAST(ItemValue AS INT)
							WHEN ItemValue='19' THEN 1
							WHEN ItemValue='20' THEN 2
						    WHEN ItemValue='21' THEN 3 END
	FROM #Trace2100 T INNER JOIN #Segments S
	ON T.RID=S.RID
	WHERE S.Loop2100=1 AND SegName='CLP' AND ItemName='CLP02' AND ItemValue IN ('1','2','3','19','20','21')

	UPDATE T SET Reversal=1
	FROM #Trace2100 T INNER JOIN #Segments S
	ON T.RID=S.RID
	WHERE S.Loop2100=1 AND SegName='CLP' AND ItemName='CLP02' AND ItemValue='22'

	UPDATE T SET PaymentParticipationAmount=CAST(S.ItemValue AS MONEY)
	FROM #Trace2100 T INNER JOIN #Segments S
	ON T.RID=S.RID
	WHERE S.Loop2100=1 AND SegName='CLP' AND ItemName='CLP04'

	UPDATE T SET FirstName=S.ItemValue
	FROM #Trace2100 T INNER JOIN #Segments S
	ON T.RID=S.RID
	WHERE S.Loop2100=1 AND SegName='NM1' AND SegQual='QC' AND ItemName='NM104'

	UPDATE T SET LastName=S.ItemValue
	FROM #Trace2100 T INNER JOIN #Segments S
	ON T.RID=S.RID
	WHERE S.Loop2100=1 AND SegName='NM1' AND SegQual='QC' AND ItemName='NM103'

	UPDATE T SET ProviderNumber=S.ItemValue
	FROM #Trace2100 T INNER JOIN #Segments S
	ON T.RID=S.RID
	WHERE S.Loop2100=1 AND SegName='NM1' AND SegQual='82' AND ItemName='NM109'

	UPDATE T SET ReceivedDate=CAST(ItemValue AS DATETIME)
	FROM #Trace2100 T INNER JOIN #Segments S
	ON T.RID=S.RID
	WHERE S.Loop2100=1 AND SegName='DTM' AND SegQual='050' AND ItemName='DTM02' AND ISDATE(ItemValue)=1

	UPDATE T SET Reversal=1
	FROM #Trace2110 T INNER JOIN #Trace2100 T2100
	ON T.RID=T2100.RID
	WHERE T2100.Reversal=1

	UPDATE T SET Reversal=1
	FROM #Trace2110_EOBXml T INNER JOIN #Trace2110 T2110
	ON T.SvcRID=T2110.SvcRID
	WHERE T2110.Reversal=1

	UPDATE T SET SVC01=S.ItemValue
	FROM #Trace2110 T INNER JOIN #Segments S
	ON T.SvcRID=S.SvcRID
	WHERE S.Loop2100=0 AND SegName='SVC' AND ItemName='SVC01'

	UPDATE T SET Charge=CAST(S.ItemValue AS MONEY)
	FROM #Trace2110 T INNER JOIN #Segments S
	ON T.SvcRID=S.SvcRID
	WHERE S.Loop2100=0 AND SegName='SVC' AND ItemName='SVC02'

	UPDATE T SET Units=S.ItemValue
	FROM #Trace2110 T INNER JOIN #Segments S
	ON T.SvcRID=S.SvcRID
	WHERE (S.Loop2100=0 AND SegName='SVC' AND ItemName='SVC05' AND ItemValue<>'0') OR
		  (S.Loop2100=0 AND SegName='SVC' AND ItemName='SVC07' AND ItemValue<>'0')

	UPDATE T SET ProcedureDateOfService=CAST(SUBSTRING(ItemValue,5,2)+'-'+RIGHT(ItemValue,2)+'-'+LEFT(ItemValue,4) AS DATETIME)
	FROM #Trace2110 T INNER JOIN #Segments S
	ON T.SvcRID=S.SvcRID
	WHERE S.Loop2100=0 AND SegName='DTM' AND SegQual IN ('472','150') AND ItemName='DTM02' AND LEN(ItemValue)=8

	UPDATE T SET ControlNumber=S.ItemValue
	FROM #Trace2110 T INNER JOIN #Segments S
	ON T.SvcRID=S.SvcRID
	WHERE S.Loop2100=0 AND SegName='REF' AND SegQual='6R' AND ItemName='REF02'

	UPDATE T SET MedicareProviderNumber=S.ItemValue
	FROM #Trace2110 T INNER JOIN #Segments S
	ON T.SvcRID=S.SvcRID
	WHERE S.Loop2100=0 AND SegName='REF' AND SegQual='1C' AND ItemName='REF02'

	UPDATE #Trace2110 SET ProcedureCode=
	CASE WHEN CHARINDEX(':',REPLACE(SVC01,'HC:',''))<>0 
		 THEN LEFT(REPLACE(SVC01,'HC:',''),CHARINDEX(':',REPLACE(SVC01,'HC:',''))-1)
	ELSE REPLACE(SVC01,'HC:','') END

	UPDATE #Trace2110 SET Mod1=LEFT(REPLACE(RIGHT(SVC01,LEN(SVC01)-(3+LEN(ProcedureCode))),':',''),2)
	WHERE LEN(SVC01)>(3+LEN(ProcedureCode))

	UPDATE #Trace2110 SET Mod2=LEFT(REPLACE(RIGHT(SVC01,LEN(SVC01)-(6+LEN(ProcedureCode))),':',''),2)
	WHERE LEN(SVC01)>(6+LEN(ProcedureCode))

	UPDATE #Trace2110 SET Mod3=LEFT(REPLACE(RIGHT(SVC01,LEN(SVC01)-(9+LEN(ProcedureCode))),':',''),2)
	WHERE LEN(SVC01)>(9+LEN(ProcedureCode))

	UPDATE #Trace2110 SET Mod4=LEFT(REPLACE(RIGHT(SVC01,LEN(SVC01)-(12+LEN(ProcedureCode))),':',''),2)
	WHERE LEN(SVC01)>(12+LEN(ProcedureCode))

	UPDATE #Trace2110 SET Mod1=ISNULL(Mod1,''), Mod2=ISNULL(Mod2,''), Mod3=ISNULL(Mod3,''), Mod4=ISNULL(Mod4,'')

	CREATE TABLE #ProcedureCodeDictionary(ProcedureCode VARCHAR(16), ProcedureCodeDictionaryID INT)
	INSERT INTO #ProcedureCodeDictionary(ProcedureCode, ProcedureCodeDictionaryID)
	SELECT DISTINCT T.ProcedureCode, PCD.ProcedureCodeDictionaryID
	FROM #Trace2110 T INNER JOIN ProcedureCodeDictionary PCD
	ON T.ProcedureCode=PCD.ProcedureCode OR T.ProcedureCode=PCD.BillableCode

	UPDATE T SET ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	FROM #Trace2110 T INNER JOIN #ProcedureCodeDictionary PCD
	ON T.ProcedureCode=PCD.ProcedureCode

	--Case 17594
	CREATE TABLE #Trace2100LoopsWithCAS(RID INT)
	INSERT INTO #Trace2100LoopsWithCAS(RID)
	SELECT DISTINCT RID
	FROM #Segments
	WHERE Loop2100=1 AND SegName='CAS'

	CREATE TABLE #Trace2110LoopsWithoutSVC(RID INT, SvcRID INT)
	INSERT INTO #Trace2110LoopsWithoutSVC(RID, SvcRID)
	SELECT RID, SvcRID
	FROM #Segments
	WHERE Loop2100=0
	GROUP BY RID, SvcRID
	HAVING COUNT(CASE WHEN SegName='SVC' THEN 1 ELSE NULL END)=0

	CREATE TABLE #Trace2100LoopsWithout2110(RID INT)
	INSERT INTO #Trace2100LoopsWithout2110(RID)
	SELECT S.RID
	FROM #Segments S LEFT JOIN #Trace2100LoopsWithout2110 T
	ON S.RID=T.RID
	WHERE T.RID IS NULL
	GROUP BY S.RID
	HAVING COUNT(CASE WHEN SegName='SVC' THEN 1 ELSE NULL END)=0

	CREATE TABLE #DistinctServiceLines(RID INT, ProcedureCodeDictionaryID INT, Mod1 VARCHAR(16), Mod2 VARCHAR(16),
									   Mod3 VARCHAR(16), Mod4 VARCHAR(16), ProcedureDateOfService DATETIME)
	INSERT INTO #DistinctServiceLines(RID, ProcedureCodeDictionaryID, Mod1, Mod2, Mod3, Mod4, ProcedureDateOfService)
	SELECT DISTINCT RID, ProcedureCodeDictionaryID, Mod1, Mod2, Mod3, Mod4, ProcedureDateOfService
	FROM #Trace2110

	CREATE TABLE #ServiceLineCounts(RID INT, ServiceLineCount INT)
	INSERT INTO #ServiceLineCounts(RID, ServiceLineCount)
	SELECT RID, COUNT(ProcedureCodeDictionaryID) ServiceLineCount
	FROM #DistinctServiceLines
	GROUP BY RID

	UPDATE T SET ServiceLineCount=SLC.ServiceLineCount
	FROM #Trace2100 T INNER JOIN #ServiceLineCounts SLC
	ON T.RID=SLC.RID

	--Get those items with Z numbers
	DECLARE @Znumbers TABLE(RID INT, EncounterID INT)
	INSERT @Znumbers(RID, EncounterID)
	SELECT RID, CAST(LEFT(CLP01,CHARINDEX('Z',CLP01)-1) AS INT)
	FROM #Trace2100
	WHERE CHARINDEX('Z',CLP01)<>0 AND ISNUMERIC(LEFT(CLP01,CHARINDEX('Z',CLP01)-1))=1

	--Parse K9 numbers and new Z numbers
	CREATE TABLE #RepClaims(RID INT, SvcRID INT, RepresentativeClaimID INT, PracticeID INT, PatientID INT, EncounterID INT,
							ProcedureCode VARCHAR(16), Mod1 VARCHAR(16), Mod2 VARCHAR(16), Mod3 VARCHAR(16), Mod4 VARCHAR(16),
							Charge MONEY, Units VARCHAR(12), ProcedureDateOfService DATETIME, Match BIT, ProcedureCodeDictionaryID INT,
							PatientCaseID INT, ControlNumberMatched BIT)
	INSERT INTO #RepClaims(RID, RepresentativeClaimID, Match, ControlNumberMatched)
	SELECT RID, SUBSTRING(CLP01,CHARINDEX('-',CLP01)+1, CHARINDEX('-',CLP01,CHARINDEX('-',CLP01)+1)-(CHARINDEX('-',CLP01)+1)) RepresentativeClaimID, 0 Match, 0 ControlNumberMatched
	FROM #Trace2100
	WHERE CHARINDEX('-',CLP01)<>0 AND CHARINDEX('-',CLP01,CHARINDEX('-',CLP01)+1)<>0
	AND ISNUMERIC(SUBSTRING(CLP01,CHARINDEX('-',CLP01)+1, CHARINDEX('-',CLP01,CHARINDEX('-',CLP01)+1)-(CHARINDEX('-',CLP01)+1)))=1
	UNION
	SELECT RID, SUBSTRING(CLP01,CHARINDEX('K',CLP01)+1, CHARINDEX('K',CLP01,CHARINDEX('K',CLP01)+1)-(CHARINDEX('K',CLP01)+1)) RepresentativeClaimID, 0 Match, 0 ControlNumberMatched
	FROM #Trace2100
	WHERE CHARINDEX('K',CLP01)<>0 AND CHARINDEX('K',CLP01,CHARINDEX('K',CLP01)+1)<>0
	AND ISNUMERIC(SUBSTRING(CLP01,CHARINDEX('K',CLP01)+1, CHARINDEX('K',CLP01,CHARINDEX('K',CLP01)+1)-(CHARINDEX('K',CLP01)+1)))=1
	UNION
	SELECT RID, MIN(C.ClaimID) RepresentativeClaimID, 0, 0
	FROM @Znumbers Z INNER JOIN EncounterProcedure EP
	ON Z.EncounterID=EP.EncounterID
	INNER JOIN Claim C
	ON EP.EncounterProcedureID=C.EncounterProcedureID
	GROUP BY RID

	--Fill in procedure info from db, which will be used to match against info parsed from ERA
	UPDATE RC SET PracticeID=EP.PracticeID, PatientID=C.PatientID, EncounterID=EP.EncounterID,
	ProcedureCode=PCD.ProcedureCode, Mod1=ISNULL(EP.ProcedureModifier1,''), Mod2=ISNULL(EP.ProcedureModifier2,''),
	Mod3=ISNULL(EP.ProcedureModifier3,''), Mod4=ISNULL(EP.ProcedureModifier4,''),
	Charge=[dbo].[fn_RoundUpToPenny]( ISNULL(EP.ServiceUnitCount,1) * ISNULL(EP.ServiceChargeAmount,0) ),
	Units=EP.ServiceUnitCount, ProcedureDateOfService=CAST(CONVERT(CHAR(10),EP.ProcedureDateOfService,110) AS DATETIME),
	ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID,
	PatientCaseID=E.PatientCaseID
	FROM #RepClaims RC INNER JOIN Claim C
	ON RC.RepresentativeClaimID=C.ClaimID
	INNER JOIN EncounterProcedure EP
	ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
	INNER JOIN ProcedureCodeDictionary PCD
	ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	INNER JOIN Encounter E
	ON EP.EncounterID=E.EncounterID

	--Representative Claims 
	--1st match
	UPDATE RC SET Match=1, ControlNumberMatched=1, SvcRID=T.SvcRID
	FROM #RepClaims RC INNER JOIN #Trace2110 T
	ON RC.RID=T.RID AND RC.ProcedureDateOfService=T.ProcedureDateOfService
	INNER JOIN #ProcedureCodeDictionary PCD
	ON T.ProcedureCode=PCD.ProcedureCode AND RC.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID

	--Determine if all 2100 loop items have been matched
	DECLARE @Matches INT
	DECLARE @NonMatches INT

	SELECT @Matches=COUNT(CASE WHEN Match=1 THEN 1 ELSE NULL END),
	@NonMatches=COUNT(CASE WHEN Match=0 THEN 1 ELSE NULL END)
	FROM #RepClaims

	--We only want good matches to be used going forward
	DELETE #RepClaims
	WHERE Match=0

	--Mark matched 2100 loops
	UPDATE T SET Matched=1
	FROM #Trace2100 T INNER JOIN #RepClaims RC
	ON T.RID=RC.RID

	--If any matches populate @PracticeID variable
	DECLARE @PracticeID INT
	SELECT DISTINCT @PracticeID=PracticeID FROM #RepClaims WHERE PracticeID IS NOT NULL

	CREATE TABLE #ServiceLines(SvcRID INT, ClaimID INT, PracticeID INT, PatientID INT, EncounterID INT,
							   ProcedureCode VARCHAR(16), Mod1 VARCHAR(16), Mod2 VARCHAR(16), Mod3 VARCHAR(16), Mod4 VARCHAR(16),
							   Charge MONEY, Units VARCHAR(12), ProcedureDateOfService DATETIME, Match BIT,
							   ProcedureCodeDictionaryID INT, PatientCaseID INT)

	--If any matches found, chances are good that control numbers are usable
	--attempt to match unmatched service lines
	IF @Matches>1
	BEGIN
		INSERT INTO #ServiceLines(SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
								  Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
		SELECT SvcRID, RepresentativeClaimID ClaimID, PracticeID, PatientID, EncounterID, ProcedureCOde, Mod1, Mod2, Mod3, Mod4, Charge, Units,
			   ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID
		FROM #RepClaims

		--Mark already matched service lines
		UPDATE T SET Matched=1
		FROM #Trace2110 T INNER JOIN #RepClaims RC
		ON T.SvcRID=RC.SvcRID

		INSERT INTO #ServiceLines(SvcRID, ClaimID, Match)
		SELECT SvcRID, SUBSTRING(ControlNumber,CHARINDEX('-',ControlNumber)+1, CHARINDEX('-',ControlNumber,CHARINDEX('-',ControlNumber)+1)-(CHARINDEX('-',ControlNumber)+1)) ClaimID, 0 Match
		FROM #Trace2110
		WHERE CHARINDEX('-',ControlNumber)<>0 AND CHARINDEX('-',ControlNumber,CHARINDEX('-',ControlNumber)+1)<>0 AND Matched=0
		UNION
		SELECT SvcRID, REPLACE(REPLACE(ControlNumber,'S',''),'Z','') ClaimID, 0 Match
		FROM #Trace2110
		WHERE CHARINDEX('S',ControlNumber)<>0 AND CHARINDEX('Z',ControlNumber)<>0 AND Matched=0

		--Fill in procedure info from db, which will be used to match against info parsed from ERA
		UPDATE SL SET PracticeID=EP.PracticeID, PatientID=C.PatientID, EncounterID=EP.EncounterID,
		ProcedureCode=PCD.ProcedureCode, Mod1=ISNULL(EP.ProcedureModifier1,''), Mod2=ISNULL(EP.ProcedureModifier2,''),
		Mod3=ISNULL(EP.ProcedureModifier3,''), Mod4=ISNULL(EP.ProcedureModifier4,''),
		Charge=[dbo].[fn_RoundUpToPenny]( ISNULL(EP.ServiceUnitCount,1) * ISNULL(EP.ServiceChargeAmount,0) ),
		Units=EP.ServiceUnitCount, ProcedureDateOfService=CAST(CONVERT(CHAR(10),EP.ProcedureDateOfService,110) AS DATETIME),
		ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID,
		PatientCaseID=E.PatientCaseID
		FROM #ServiceLines SL INNER JOIN Claim C
		ON SL.ClaimID=C.ClaimID
		INNER JOIN EncounterProcedure EP
		ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN ProcedureCodeDictionary PCD
		ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
		INNER JOIN Encounter E
		ON EP.EncounterID=E.EncounterID
		WHERE SL.Match=0

		--Service Line Verification
		--1st Match
		UPDATE SL SET Match=1
		FROM #ServiceLines SL INNER JOIN #Trace2110 T
		ON SL.SvcRID=T.SvcRID AND SL.ProcedureDateOfService=T.ProcedureDateOfService
		INNER JOIN #ProcedureCodeDictionary PCD
		ON T.ProcedureCode=PCD.ProcedureCode AND SL.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID

		--Check if further levels of matching are needed
		--no DOS check and representative claim successfully matched
		IF EXISTS(SELECT * FROM #ServiceLines WHERE Match=0)
		BEGIN
			--Service Line Verification
			--2nd Match
			DECLARE @SL_2ndMatchSet TABLE(SvcRID INT)
			INSERT @SL_2ndMatchSet(SvcRID)
			SELECT SL.SvcRID
			FROM #ServiceLines SL INNER JOIN #Trace2110 T
			ON SL.SvcRID=T.SvcRID
			INNER JOIN #ProcedureCodeDictionary PCD
			ON T.ProcedureCode=PCD.ProcedureCode AND SL.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
			INNER JOIN #RepClaims RC
			ON T.RID=RC.RID
			WHERE SL.Match=0
			GROUP BY SL.SvcRID
			HAVING COUNT(T.SvcRID)=1

			UPDATE SL SET Match=1
			FROM #ServiceLines SL INNER JOIN @SL_2ndMatchSet SL2
			ON SL.SvcRID=SL2.SvcRID
		END

		DELETE #ServiceLines WHERE Match=0

		--Mark matched service lines
		UPDATE T SET Matched=1
		FROM #Trace2110 T INNER JOIN #ServiceLines SL
		ON T.SvcRID=SL.SvcRID
		WHERE T.Matched=0 AND SL.Match=1
	END

	CREATE TABLE #MatchedEncounterIDs(RID INT, PracticeID INT, PatientID INT, EncounterID INT)
	INSERT INTO #MatchedEncounterIDs(RID, PracticeID, PatientID, EncounterID)
	SELECT T.RID, SL.PracticeID, SL.PatientID, SL.EncounterID
	FROM #Trace2110 T INNER JOIN #ServiceLines SL
	ON T.SvcRID=SL.SvcRID
	WHERE T.Matched=1

	IF EXISTS(SELECT * FROM #Trace2110 WHERE Matched=0)
	BEGIN

		--Matching without control numbers
		--Try to get Doctor and Patient IDs and what practices they might possibly belong to
		DECLARE @DistinctPN TABLE(ProviderNumber VARCHAR(50))
		INSERT @DistinctPN(ProviderNumber)
		SELECT DISTINCT ProviderNumber
		FROM #Trace2100
		WHERE ProviderNumber<>''

		DECLARE @ProviderNumberDoctors TABLE(ProviderNumber VARCHAR(50), DoctorID INT, PracticeID INT)
		INSERT @ProviderNumberDoctors(ProviderNumber, DoctorID, PracticeID)
		SELECT DISTINCT PN.ProviderNumber, PN.DoctorID, D.PracticeID
		FROM ProviderNumber PN INNER JOIN @DistinctPN DPN
		ON PN.ProviderNumber=DPN.ProviderNumber
		INNER JOIN Doctor D
		ON PN.DoctorID=D.DoctorID

		--Represented Patients
		--1st match
		DECLARE @Patients TABLE(RID INT, ProviderNumber VARCHAR(50), PatientID INT, PracticeID INT)
		INSERT @Patients(RID, ProviderNumber, PatientID, PracticeID)
		SELECT T.RID, T.ProviderNumber, ME.PatientID, ME.PracticeID
		FROM #Trace2100 T INNER JOIN #MatchedEncounterIDs ME
		ON T.RID=ME.RID
		UNION
		SELECT T.RID, T.ProviderNumber, PatientID, PracticeID
		FROM Patient P INNER JOIN #Trace2100 T
		ON P.FirstName=T.FirstName AND P.LastName=T.LastName
		WHERE T.Matched=0

		--Determine PracticeID
		IF @PracticeID IS NULL
		BEGIN
			DECLARE @PracticeCount INT

			DECLARE @Practices TABLE(PracticeID INT)
			INSERT @Practices(PracticeID)
			SELECT PracticeID
			FROM @ProviderNumberDoctors
			UNION ALL
			SELECT PracticeID
			FROM @Patients

			SET @PracticeCount=@@ROWCOUNT

			--Rank practices by the # of occurences
			DECLARE @CandidatePractices TABLE(TID INT IDENTITY(1,1), PracticeID INT, PercentageOfOccurences REAL)
			INSERT @CandidatePractices(PracticeID, PercentageOfOccurences)
			SELECT PracticeID, CAST(COUNT(PracticeID) AS REAL)/CAST(@PracticeCount AS REAL)
			FROM @Practices
			GROUP BY PracticeID
			ORDER BY CAST(COUNT(PracticeID) AS REAL)/CAST(@PracticeCount AS REAL) DESC

			--Rank practices by attempting fuzzy matches
			DECLARE @PracticeMatchScoring TABLE(TID INT IDENTITY(1,1), PracticeID INT, PayeeIDMatchScore INT, MatchScore INT)
			INSERT @PracticeMatchScoring(PracticeID, PayeeIDMatchScore, MatchScore)
			SELECT P.PracticeID, 
			dbo.fn_MatchPercent(@PayeeIDNumber,P.EIN,0) PayeeIDMatchScore,
			dbo.fn_MatchPercent(@PayeeAddress1,P.AddressLine1,0) +
			dbo.fn_MatchPercent(@PayeeAddress2,P.AddressLine2,0) +
			dbo.fn_MatchPercent(@PayeeCity,P.City,0) + dbo.fn_MatchPercent(@PayeeState,P.State,0)+
			dbo.fn_MatchPercent(@PayeeZip,P.ZipCode,0) MatchScore
			FROM Practice P INNER JOIN @CandidatePractices CP
			ON P.PracticeID=CP.PracticeID
			ORDER BY dbo.fn_MatchPercent(@PayeeIDNumber,P.EIN,0) DESC,
			dbo.fn_MatchPercent(@PayeeAddress1,P.AddressLine1,0) +
			dbo.fn_MatchPercent(@PayeeAddress2,P.AddressLine2,0) +
			dbo.fn_MatchPercent(@PayeeCity,P.City,0) + dbo.fn_MatchPercent(@PayeeState,P.State,0)+
			dbo.fn_MatchPercent(@PayeeZip,P.ZipCode,0) DESC

			--Determine which practice ranks best as being the practice that this payment belongs to 
			SELECT @PracticeID=CASE WHEN PMS.PayeeIDMatchScore=100 THEN PMS.PracticeID
									WHEN CP.PracticeID=PMS.PracticeID THEN CP.PracticeID				
							   ELSE PMS.PracticeID END
			FROM @CandidatePractices CP INNER JOIN @PracticeMatchScoring PMS
			ON CP.TID=PMS.TID
			WHERE CP.TID=1 AND MatchScore<>0
		END

		--Represented Patients
		--2nd match
		IF EXISTS(SELECT * FROM #Trace2100 T LEFT JOIN @Patients TP
						   ON T.RID=TP.RID
						   WHERE TP.RID IS NULL)
		BEGIN
			INSERT @Patients(RID, ProviderNumber, PatientID, PracticeID)
			SELECT T.RID, T.ProviderNumber, P.PatientID, P.PracticeID
			FROM #Trace2100 T LEFT JOIN @Patients TP
			ON T.RID=TP.RID
			INNER JOIN Patient P
			ON (P.FirstName=T.FirstName AND P.LastName LIKE '%'+T.LastName+'%')
			OR (P.LastName=T.LastName AND P.FirstName LIKE '%'+T.FirstName+'%')
			WHERE T.Matched=0 AND P.PracticeID=@PracticeID AND TP.RID IS NULL
		END

		--Represented Patients
		--3rd match
		IF EXISTS(SELECT * FROM #Trace2100 T LEFT JOIN @Patients TP
						   ON T.RID=TP.RID
						   WHERE TP.RID IS NULL)
		BEGIN
			INSERT @Patients(RID, ProviderNumber, PatientID, PracticeID)
			SELECT T.RID, T.ProviderNumber, P.PatientID, P.PracticeID
			FROM #Trace2100 T LEFT JOIN @Patients TP
			ON T.RID=TP.RID
			INNER JOIN Patient P
			ON (P.FirstName LIKE '%'+T.FirstName+'%' AND P.LastName LIKE '%'+T.LastName+'%')
			OR (P.LastName LIKE '%'+T.LastName+'%' AND P.FirstName LIKE '%'+T.FirstName+'%')
			WHERE T.Matched=0 AND P.PracticeID=@PracticeID AND TP.RID IS NULL
		END

		--Get Rid of info that are not affiliated with selected primary practice
		DELETE @ProviderNumberDoctors
		WHERE PracticeID<>@PracticeID

		DELETE @Patients
		WHERE PracticeID<>@PracticeID

		--Get Matches for RepresentativeClaims first - for those not already matched
		--In this case assume first service line is representative claim
		CREATE TABLE #UnMatchedRepClaims(RID INT, SvcRID INT)
		INSERT INTO #UnMatchedRepClaims(RID, SvcRID)
		SELECT T.RID, MIN(SvcRID) SvcRID
		FROM #Trace2110 T LEFT JOIN #MatchedEncounterIDs ME
		ON T.RID=ME.RID
		WHERE ME.RID IS NULL
		GROUP BY T.RID

		--NCNM - Non Control Number Representative Claim Matching
		--1st Match
		CREATE TABLE #NCNM_RC1stMatchSet(RID INT, SvcRID INT, ClaimID INT, PracticeID INT, PatientID INT, EncounterID INT,
							   ProcedureCode VARCHAR(16), Mod1 VARCHAR(16), Mod2 VARCHAR(16), Mod3 VARCHAR(16), Mod4 VARCHAR(16),
							   Charge MONEY, Units VARCHAR(12), ProcedureDateOfService DATETIME, Match BIT, ProcedureCodeDictionaryID INT,
							   PatientCaseID INT)
		INSERT INTO #NCNM_RC1stMatchSet(RID, SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
								 Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
		SELECT T.RID, T.SvcRID, C.ClaimID, E.PracticeID, E.PatientID, E.EncounterID, T.ProcedureCode, T.Mod1, T.Mod2, T.Mod3, T.Mod4,
			   T.Charge, T.Units, T.ProcedureDateOfService, 1 Match, EP.ProcedureCodeDictionaryID, E.PatientCaseID
		FROM @Patients P INNER JOIN @ProviderNumberDoctors PND
		ON P.ProviderNumber=PND.ProviderNumber
		INNER JOIN #Trace2110 T
		ON P.RID=T.RID
		INNER JOIN #UnMatchedRepClaims URC
		ON T.SvcRID=URC.SvcRID
		INNER JOIN #ProcedureCodeDictionary PCD
		ON T.ProcedureCode=PCD.ProcedureCode
		INNER JOIN Encounter E
		ON P.PracticeID=E.PracticeID AND P.PatientID=E.PatientID AND PND.DoctorID=E.DoctorID
		INNER JOIN EncounterProcedure EP
		ON E.PracticeID=EP.PracticeID AND E.EncounterID=EP.EncounterID AND PCD.ProcedureCodeDictionaryID=EP.ProcedureCodeDictionaryID
		AND T.Mod1=ISNULL(Ep.ProcedureModifier1,'') AND T.Mod2=ISNULL(Ep.ProcedureModifier2,'')
		AND T.Mod3=ISNULL(Ep.ProcedureModifier3,'') AND T.Mod4=ISNULL(Ep.ProcedureModifier4,'')
		AND T.ProcedureDateOfService=CAST(CONVERT(CHAR(10),EP.ProcedureDateOfService,110) AS DATETIME)
		INNER JOIN Claim C
		ON EP.EncounterProcedureID=C.EncounterProcedureID

		--Get the service line count of each encounter
		CREATE TABLE #NCNM_RC1stMatchSet_SLCount(SvcRID INT, EncounterID INT, ServiceLineCount INT)
		INSERT INTO #NCNM_RC1stMatchSet_SLCount(SvcRID, EncounterID, ServiceLineCount)
		SELECT NCNMRC.SvcRID, NCNMRC.EncounterID, COUNT(EncounterProcedureID) ServiceLineCount
		FROM #NCNM_RC1stMatchSet NCNMRC INNER JOIN EncounterProcedure EP
		ON NCNMRC.PracticeID=EP.PracticeID AND NCNMRC.EncounterID=EP.EncounterID
		GROUP BY NCNMRC.SvcRID, NCNMRC.EncounterID

		--Delete any record whose encounter's service line count does not match that of the era Big Claim service line count
		DELETE NCNMRC
		FROM #NCNM_RC1stMatchSet NCNMRC INNER JOIN #NCNM_RC1stMatchSet_SLCount SLC
		ON NCNMRC.SvcRID=SLC.SvcRID AND NCNMRC.EncounterID=SLC.EncounterID
		INNER JOIN #Trace2100 T2100
		ON NCNMRC.RID=T2100.RID
		WHERE SLC.ServiceLineCount<>T2100.ServiceLineCount

		--Select 1st EncounterID per representative service line ID - Need this step to eliminate possiblility of dups
		CREATE TABLE #NCNM_RC1st_FirstID(SvcRID INT, EncounterID INT)
		INSERT INTO #NCNM_RC1st_FirstID(SvcRID, EncounterID)
		SELECT SvcRID, MIN(EncounterID) EncounterID
		FROM #NCNM_RC1stMatchSet
		GROUP BY SvcRID

		--Delete any record whose EncounterID is not the first ID per service line match
		DELETE NCNMRC
		FROM #NCNM_RC1stMatchSet NCNMRC LEFT JOIN #NCNM_RC1st_FirstID NCNFID
		ON NCNMRC.SvcRID=NCNFID.SvcRID AND NCNMRC.EncounterID=NCNFID.EncounterID
		WHERE NCNFID.EncounterID IS NULL

		--Insert validated representative claim data
		INSERT INTO #RepClaims(RID, SvcRID, RepresentativeClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
							   Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
		SELECT RID, SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
			   Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID
		FROM #NCNM_RC1stMatchSet

		--Insert Matched Service Line data
		INSERT INTO #ServiceLines(SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
								  Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
		SELECT SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCOde, Mod1, Mod2, Mod3, Mod4, Charge, Units,
			   ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID
		FROM #NCNM_RC1stMatchSet

		--Remove those items successfully matched from #UnMatchedRepClaims
		DELETE UMRC
		FROM #NCNM_RC1stMatchSet NCNMRC INNER JOIN #UnMatchedRepClaims UMRC
		ON NCNMRC.RID=UMRC.RID AND NCNMRC.SvcRID=UMRC.SvcRID

		UPDATE T SET Matched=1
		FROM #Trace2110 T INNER JOIN #NCNM_RC1stMatchSet NCNM1
		ON T.SvcRID=NCNM1.SvcRID

		DROP TABLE #NCNM_RC1stMatchSet
		DROP TABLE #NCNM_RC1stMatchSet_SLCount
		DROP TABLE #NCNM_RC1st_FirstID

		--Check if further Representative Claim Matching is necessary
		IF EXISTS(SELECT * FROM #UnMatchedRepClaims)
		BEGIN
			
			--NCNM - Non Control Number Representative Claim Matching
			--2nd Match - No provider number matching
			CREATE TABLE #NCNM_RC2ndMatchSet(RID INT, SvcRID INT, ClaimID INT, PracticeID INT, PatientID INT, EncounterID INT,
								   ProcedureCode VARCHAR(16), Mod1 VARCHAR(16), Mod2 VARCHAR(16), Mod3 VARCHAR(16), Mod4 VARCHAR(16),
								   Charge MONEY, Units VARCHAR(12), ProcedureDateOfService DATETIME, Match BIT, ProcedureCodeDictionaryID INT,
								   PatientCaseID INT)
			INSERT INTO #NCNM_RC2ndMatchSet(RID, SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
									 Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
			SELECT T.RID, T.SvcRID, C.ClaimID, E.PracticeID, E.PatientID, E.EncounterID, T.ProcedureCode, T.Mod1, T.Mod2, T.Mod3, T.Mod4,
				   T.Charge, T.Units, T.ProcedureDateOfService, 1 Match, EP.ProcedureCodeDictionaryID, E.PatientCaseID
			FROM @Patients P INNER JOIN #Trace2110 T
			ON P.RID=T.RID
			INNER JOIN #UnMatchedRepClaims URC
			ON T.SvcRID=URC.SvcRID
			INNER JOIN #ProcedureCodeDictionary PCD
			ON T.ProcedureCode=PCD.ProcedureCode
			INNER JOIN Encounter E
			ON P.PracticeID=E.PracticeID AND P.PatientID=E.PatientID
			INNER JOIN EncounterProcedure EP
			ON E.PracticeID=EP.PracticeID AND E.EncounterID=EP.EncounterID AND PCD.ProcedureCodeDictionaryID=EP.ProcedureCodeDictionaryID
			AND T.Mod1=ISNULL(Ep.ProcedureModifier1,'') AND T.Mod2=ISNULL(Ep.ProcedureModifier2,'')
			AND T.Mod3=ISNULL(Ep.ProcedureModifier3,'') AND T.Mod4=ISNULL(Ep.ProcedureModifier4,'')
			AND T.ProcedureDateOfService=CAST(CONVERT(CHAR(10),EP.ProcedureDateOfService,110) AS DATETIME)
			INNER JOIN Claim C
			ON EP.EncounterProcedureID=C.EncounterProcedureID

			--Get the service line count of each encounter
			CREATE TABLE #NCNM_RC2ndMatchSet_SLCount(SvcRID INT, EncounterID INT, ServiceLineCount INT)
			INSERT INTO #NCNM_RC2ndMatchSet_SLCount(SvcRID, EncounterID, ServiceLineCount)
			SELECT NCNMRC.SvcRID, NCNMRC.EncounterID, COUNT(EncounterProcedureID) ServiceLineCount
			FROM #NCNM_RC2ndMatchSet NCNMRC INNER JOIN EncounterProcedure EP
			ON NCNMRC.PracticeID=EP.PracticeID AND NCNMRC.EncounterID=EP.EncounterID
			GROUP BY NCNMRC.SvcRID, NCNMRC.EncounterID

			--Delete any record whose encounter's service line count does not match that of the era Big Claim service line count
			DELETE NCNMRC
			FROM #NCNM_RC2ndMatchSet NCNMRC INNER JOIN #NCNM_RC2ndMatchSet_SLCount SLC
			ON NCNMRC.SvcRID=SLC.SvcRID AND NCNMRC.EncounterID=SLC.EncounterID
			INNER JOIN #Trace2100 T2100
			ON NCNMRC.RID=T2100.RID
			WHERE SLC.ServiceLineCount<>T2100.ServiceLineCount

			--Select 1st EncounterID per representative service line ID - Need this step to eliminate possiblility of dups
			CREATE TABLE #NCNM_RC2nd_FirstID(SvcRID INT, EncounterID INT)
			INSERT INTO #NCNM_RC2nd_FirstID(SvcRID, EncounterID)
			SELECT SvcRID, MIN(EncounterID) EncounterID
			FROM #NCNM_RC2ndMatchSet
			GROUP BY SvcRID

			--Delete any record whose EncounterID is not the first ID per service line match
			DELETE NCNMRC
			FROM #NCNM_RC2ndMatchSet NCNMRC LEFT JOIN #NCNM_RC2nd_FirstID NCNFID
			ON NCNMRC.SvcRID=NCNFID.SvcRID AND NCNMRC.EncounterID=NCNFID.EncounterID
			WHERE NCNFID.EncounterID IS NULL

			--Insert validated representative claim data
			INSERT INTO #RepClaims(RID, SvcRID, RepresentativeClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
								   Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
			SELECT RID, SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
				   Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID
			FROM #NCNM_RC2ndMatchSet

			--Insert Matched Service Line data
			INSERT INTO #ServiceLines(SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
									  Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
			SELECT SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCOde, Mod1, Mod2, Mod3, Mod4, Charge, Units,
				   ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID
			FROM #NCNM_RC2ndMatchSet

			UPDATE T SET Matched=1
			FROM #Trace2110 T INNER JOIN #NCNM_RC2ndMatchSet NCNM2
			ON T.SvcRID=NCNM2.SvcRID

			DROP TABLE #NCNM_RC2ndMatchSet
			DROP TABLE #NCNM_RC2ndMatchSet_SLCount
			DROP TABLE #NCNM_RC2nd_FirstID

		END

		DROP TABLE #UnMatchedRepClaims

		--mark successfully matched 2100 loops if any additional item matched
		UPDATE T SET Matched=1
		FROM #Trace2100 T INNER JOIN #RepClaims RC
		ON T.RID=RC.RID
		WHERE Matched=0

		--All further matching will exclude those 2100 loops whose Representative Claim could not be validated		

		--NCNM - Non Control Number Matching
		--1st Match 
		CREATE TABLE #NCNM_1stMatchSet(SvcRID INT, ClaimID INT, PracticeID INT, PatientID INT, EncounterID INT,
							   ProcedureCode VARCHAR(16), Mod1 VARCHAR(16), Mod2 VARCHAR(16), Mod3 VARCHAR(16), Mod4 VARCHAR(16),
							   Charge MONEY, Units VARCHAR(12), ProcedureDateOfService DATETIME, Match BIT, ProcedureCodeDictionaryID INT,
							   PatientCaseID INT)
		INSERT INTO #NCNM_1stMatchSet(SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
								 Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
		SELECT T.SvcRID, C.ClaimID, RC.PracticeID, RC.PatientID, RC.EncounterID, T.ProcedureCode, T.Mod1, T.Mod2, T.Mod3, T.Mod4,
			   T.Charge, T.Units, T.ProcedureDateOfService, 1 Match, EP.ProcedureCodeDictionaryID, RC.PatientCaseID
		FROM #Trace2110 T INNER JOIN #RepClaims RC
		ON T.RID=RC.RID
		INNER JOIN #ProcedureCodeDictionary PCD
		ON T.ProcedureCode=PCD.ProcedureCode
		INNER JOIN EncounterProcedure EP
		ON RC.PracticeID=EP.PracticeID AND RC.EncounterID=EP.EncounterID AND PCD.ProcedureCodeDictionaryID=EP.ProcedureCodeDictionaryID
		AND T.Mod1=ISNULL(EP.ProcedureModifier1,'') AND T.Mod2=ISNULL(EP.ProcedureModifier2,'')
		AND T.Mod3=ISNULL(EP.ProcedureModifier3,'') AND T.Mod4=ISNULL(EP.ProcedureModifier4,'')
		AND T.ProcedureDateOfService=CAST(CONVERT(CHAR(10),EP.ProcedureDateOfService,110) AS DATETIME)
		INNER JOIN Claim C
		ON EP.EncounterProcedureID=C.EncounterProcedureID
		WHERE T.Matched=0

		INSERT INTO #ServiceLines(SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
								  Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
		SELECT SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCOde, Mod1, Mod2, Mod3, Mod4, Charge, Units,
			   ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID
		FROM #NCNM_1stMatchSet

		UPDATE T SET Matched=1
		FROM #Trace2110 T INNER JOIN #NCNM_1stMatchSet NCNM1
		ON T.SvcRID=NCNM1.SvcRID

		DROP TABLE #NCNM_1stMatchSet

		--Check if further levels of matching are needed
		--no modifier matching
		IF EXISTS(SELECT * FROM #Trace2110 T INNER JOIN #RepClaims RC ON T.RID=RC.RID WHERE T.Matched=0)
		BEGIN
			--NCNM - Non Control Number Matching
			--2nd Match
			CREATE TABLE #NCNM_2ndMatchSet(SvcRID INT, ClaimID INT, PracticeID INT, PatientID INT, EncounterID INT,
								   ProcedureCode VARCHAR(16), Mod1 VARCHAR(16), Mod2 VARCHAR(16), Mod3 VARCHAR(16), Mod4 VARCHAR(16),
								   Charge MONEY, Units VARCHAR(12), ProcedureDateOfService DATETIME, Match BIT, ProcedureCodeDictionaryID INT,
								   PatientCaseID INT)
			INSERT INTO #NCNM_2ndMatchSet(SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
									 Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
			SELECT T.SvcRID, C.ClaimID, RC.PracticeID, RC.PatientID, RC.EncounterID, T.ProcedureCode, T.Mod1, T.Mod2, T.Mod3, T.Mod4,
				   T.Charge, T.Units, T.ProcedureDateOfService, 1 Match, EP.ProcedureCodeDictionaryID, RC.PatientCaseID
			FROM #Trace2110 T INNER JOIN #RepClaims RC
			ON T.RID=RC.RID
			INNER JOIN #ProcedureCodeDictionary PCD
			ON T.ProcedureCode=PCD.ProcedureCode
			INNER JOIN EncounterProcedure EP
			ON RC.PracticeID=EP.PracticeID AND RC.EncounterID=EP.EncounterID AND PCD.ProcedureCodeDictionaryID=EP.ProcedureCodeDictionaryID
			AND T.ProcedureDateOfService=CAST(CONVERT(CHAR(10),EP.ProcedureDateOfService,110) AS DATETIME)
			INNER JOIN Claim C
			ON EP.EncounterProcedureID=C.EncounterProcedureID
			WHERE T.Matched=0

			INSERT INTO #ServiceLines(SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
									  Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
			SELECT SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCOde, Mod1, Mod2, Mod3, Mod4, Charge, Units,
				   ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID
			FROM #NCNM_2ndMatchSet

			UPDATE T SET Matched=1
			FROM #Trace2110 T INNER JOIN #NCNM_2ndMatchSet NCNM2
			ON T.SvcRID=NCNM2.SvcRID

			DROP TABLE #NCNM_2ndMatchSet
		END

		--Check if further levels of matching are needed
		--no modifier or DOS matching
		IF EXISTS(SELECT * FROM #Trace2110 T INNER JOIN #RepClaims RC ON T.RID=RC.RID WHERE T.Matched=0)
		BEGIN
			--NCNM - Non Control Number Matching
			--3rd Match 
			CREATE TABLE #NCNM_3rdMatchSet(SvcRID INT, ClaimID INT, PracticeID INT, PatientID INT, EncounterID INT,
								   ProcedureCode VARCHAR(16), Mod1 VARCHAR(16), Mod2 VARCHAR(16), Mod3 VARCHAR(16), Mod4 VARCHAR(16),
								   Charge MONEY, Units VARCHAR(12), ProcedureDateOfService DATETIME, Match BIT, ProcedureCodeDictionaryID INT,
								   PatientCaseID INT)
			INSERT INTO #NCNM_3rdMatchSet(SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
									 Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
			SELECT T.SvcRID, C.ClaimID, RC.PracticeID, RC.PatientID, RC.EncounterID, T.ProcedureCode, T.Mod1, T.Mod2, T.Mod3, T.Mod4,
				   T.Charge, T.Units, T.ProcedureDateOfService, 1 Match, EP.ProcedureCodeDictionaryID, RC.PatientCaseID
			FROM #Trace2110 T INNER JOIN #RepClaims RC
			ON T.RID=RC.RID
			INNER JOIN #ProcedureCodeDictionary PCD
			ON T.ProcedureCode=PCD.ProcedureCode
			INNER JOIN EncounterProcedure EP
			ON RC.PracticeID=EP.PracticeID AND RC.EncounterID=EP.EncounterID AND PCD.ProcedureCodeDictionaryID=EP.ProcedureCodeDictionaryID
			INNER JOIN Claim C
			ON EP.EncounterProcedureID=C.EncounterProcedureID
			WHERE T.Matched=0

			INSERT INTO #ServiceLines(SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCode, Mod1, Mod2, Mod3, Mod4,
									  Charge, Units, ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID)
			SELECT SvcRID, ClaimID, PracticeID, PatientID, EncounterID, ProcedureCOde, Mod1, Mod2, Mod3, Mod4, Charge, Units,
				   ProcedureDateOfService, Match, ProcedureCodeDictionaryID, PatientCaseID
			FROM #NCNM_3rdMatchSet

			UPDATE T SET Matched=1
			FROM #Trace2110 T INNER JOIN #NCNM_3rdMatchSet NCNM3
			ON T.SvcRID=NCNM3.SvcRID

			DROP TABLE #NCNM_3rdMatchSet
		END
	END
	
	--Populate Error Message table
	--1 - The claim contained duplicate, unbundling, and or information which could not be processed
	--2 - Control number matched, but one or more service line's data does not correlate
	--3 - Claim information reported by the payer could not be matched to a claim currently in the system.
	--4 - No control number match, and one or more service lines could not be correlated
	--5 - The claim cannot be processed due to missing service line information.
	CREATE TABLE #Errors(RID INT, ErrorType INT)
	CREATE TABLE #SortedErrors(RID INT)

	--Populate Errors Type 3
	INSERT INTO #Errors(RID, ErrorType)
	SELECT RID, 3
	FROM #Trace2100
	WHERE Matched=0

	--Populate Errors Type 1
	CREATE TABLE #ItemsWithMultipleLoops(ClaimID INT, Reversal BIT, LoopCount INT)
	INSERT INTO #ItemsWithMultipleLoops(ClaimID, Reversal, LoopCount)
	SELECT SL.ClaimID, T.Reversal, COUNT(SL.SvcRID) LoopCount
	FROM #ServiceLines SL INNER JOIN #Trace2110 T
	ON SL.SvcRID=T.SvcRID
	GROUP BY SL.ClaimID, T.Reversal
	HAVING COUNT(SL.SvcRID)>1

	CREATE TABLE #ItemsWithMultipleLoops_RIDs(RID INT)
	INSERT INTO #ItemsWithMultipleLoops_RIDs(RID)
	SELECT DISTINCT T.RID
	FROM #ItemsWithMultipleLoops IWM INNER JOIN #ServiceLines SL
	ON IWM.ClaimID=SL.ClaimID
	INNER JOIN #Trace2110 T
	ON SL.SvcRID=T.SvcRID

	INSERT INTO #Errors(RID, ErrorType)
	SELECT RID, 1
	FROM #ItemsWithMultipleLoops_RIDs

	--Populate Errors Type 2
	CREATE TABLE #ControlNumberMatch_SLNoMatch(RID INT)
	INSERT INTO #ControlNumberMatch_SLNoMatch(RID)
	SELECT RC.RID
	FROM #RepClaims RC INNER JOIN #Trace2110 T
	ON RC.RID=T.RID
	WHERE ControlNumberMatched=1 AND T.Matched=0
	GROUP BY RC.RID
	HAVING COUNT(T.SvcRID)>0

	INSERT INTO #Errors(RID, ErrorType)
	SELECT RID, 2
	FROM #ControlNumberMatch_SLNoMatch

	--Populate Errors Type 4
	CREATE TABLE #NoControlNumberMatch_SLNoMatch(RID INT)
	INSERT INTO #NoControlNumberMatch_SLNoMatch(RID)
	SELECT RC.RID
	FROM #RepClaims RC INNER JOIN #Trace2110 T
	ON RC.RID=T.RID
	WHERE ControlNumberMatched=0 AND T.Matched=0
	GROUP BY RC.RID
	HAVING COUNT(T.SvcRID)>0

	INSERT INTO #Errors(RID, ErrorType)
	SELECT RID, 4
	FROM #NoControlNumberMatch_SLNoMatch

	INSERT INTO #Errors(RID, ErrorType)
	SELECT DISTINCT RID, 5
	FROM #Trace2110LoopsWithoutSVC
	UNION
	SELECT RID, 5
	FROM #Trace2100LoopsWithout2110

	DROP TABLE #ItemsWithMultipleLoops
	DROP TABLE #ItemsWithMultipleLoops_RIDs
	DROP TABLE #ControlNumberMatch_SLNoMatch
	DROP TABLE #NoControlNumberMatch_SLNoMatch

	DECLARE @ERA_ErrorsXML VARCHAR(MAX)

	IF EXISTS(SELECT * FROM #Errors)
	BEGIN
		--Get all related EncounterID loops and remove from output for placement in error xml
		CREATE TABLE #Err_Encounters(EncounterID INT)
		INSERT INTO #Err_Encounters(EncounterID)
		SELECT DISTINCT EncounterID
		FROM #RepClaims RC INNER JOIN #Errors E
		ON RC.RID=E.RID

		--Error Type 0 - some associated 2100 loop had errors
		INSERT INTO #Errors(RID, ErrorType)
		SELECT RC.RID, 0
		FROM #RepClaims RC INNER JOIN #Err_Encounters EE
		ON RC.EncounterID=EE.EncounterID
		LEFT JOIN #Errors E
		ON RC.RID=E.RID
		WHERE E.RID IS NULL

		--Update XML with error descriptions

		--Update Error Type 0 error description
		UPDATE T SET EOBXml.modify('insert <error>This claim contains one or more errors</error>
										   after (/loop[@name="2100"]/segment[last()])[1]')
		FROM #Trace2100 T INNER JOIN #Errors E
		ON T.RID=E.RID
		WHERE ErrorType=0
		
		--Update Error Type 1 error description
		UPDATE T SET EOBXml.modify('insert <error>The claim contained duplicate, unbundling, and or information which could not be processed</error>
										   after (/loop[@name="2100"]/segment[last()])[1]')
		FROM #Trace2100 T INNER JOIN #Errors E
		ON T.RID=E.RID
		WHERE ErrorType=1

		--Update Error Type 2 error description
		UPDATE T SET EOBXml.modify('insert <error>Control number matched, but one or more service lines data does not correlate</error>
										   after (/loop[@name="2100"]/segment[last()])[1]')
		FROM #Trace2100 T INNER JOIN #Errors E
		ON T.RID=E.RID
		WHERE ErrorType=2

		--Update Error Type 3 error description
		UPDATE T SET EOBXml.modify('insert <error>Claim information reported by the payer could not be matched to a claim currently in the system.</error>
										   after (/loop[@name="2100"]/segment[last()])[1]')
		FROM #Trace2100 T INNER JOIN #Errors E
		ON T.RID=E.RID
		WHERE ErrorType=3

		--Update Error Type 4 error description
		UPDATE T SET EOBXml.modify('insert <error>No control number match, and one or more service lines could not be correlated</error>
										   after (/loop[@name="2100"]/segment[last()])[1]')
		FROM #Trace2100 T INNER JOIN #Errors E
		ON T.RID=E.RID
		WHERE ErrorType=4

		--Update Error Type 5 error description
		UPDATE T SET EOBXml.modify('insert <error>The claim cannot be processed due to missing service line information.</error>
										   after (/loop[@name="2100"]/segment[last()])[1]')
		FROM #Trace2100 T INNER JOIN #Errors E
		ON T.RID=E.RID
		WHERE ErrorType=5

		--Case 17594 Receive Payment: Implement Loop 2100 error when there are Claim-level adjustments 
		--This is a soft error, for information purposes only, it does not fail the claim as do the other type of errors
		UPDATE T SET EOBXml.modify('insert <error>This claim contains claim-level adjustments and may not have been processed correctly. Please review it for posting errors.</error>
										   after (/loop[@name="2100"]/segment[last()])[1]')
		FROM #Trace2100 T INNER JOIN #Trace2100LoopsWithCAS TA
		ON T.RID=TA.RID

		SELECT @ERA_ErrorsXML='<loop name="ST">'+CAST(@ERAXml.query('/loop/*[local-name()!="loop"]') AS VARCHAR(MAX))
		+CAST(@ERAXml.query('/loop/loop[@name!="2000"]') AS VARCHAR(MAX))
		+'<loop name="2000">'

		INSERT INTO #SortedErrors
		SELECT DISTINCT RID
		FROM #Errors
		ORDER BY RID

		SELECT @ERA_ErrorsXML=@ERA_ErrorsXML+CAST(EOBXml AS VARCHAR(MAX))
		FROM #Trace2100 T INNER JOIN #SortedErrors E
		ON T.RID=E.RID

		SET @ERA_ErrorsXML=@ERA_ErrorsXML+'</loop>'

		DROP TABLE #SortedErrors
		DROP TABLE #Err_Encounters
	END

	DECLARE @TotalClaims INT

	CREATE TABLE #UniqueServiceLines(PracticeID INT, PatientID INT, EncounterID INT, PatientCaseID INT, ClaimID INT, RawEOBXml VARCHAR(MAX), RawEOBStarted BIT, ReversalStarted BIT, SelectedInsPolicyID INT)
	INSERT INTO #UniqueServiceLines(PracticeID, PatientID, EncounterID, PatientCaseID, ClaimID, RawEOBStarted, ReversalStarted)
	SELECT DISTINCT PracticeID, PatientID, EncounterID, PatientCaseID, ClaimID, 0 , 0 
	FROM #ServiceLines

	SET @TotalClaims=@@ROWCOUNT

	-- Get the payers for the claim
	CREATE TABLE #ClaimPayers(ClaimID INT, InsurancePolicyID INT, Precedence INT, InsuranceCompanyPlanID INT,
							  PlanName VARCHAR(128), ExpectedAllowed DECIMAL, ExpectedReimbursement DECIMAL,
							  DefaultAdjustmentCode VARCHAR(10), ClearinghousePayerID INT)
	INSERT INTO #ClaimPayers(ClaimID, InsurancePolicyID, Precedence, InsuranceCompanyPlanID, PlanName, 
							 ExpectedAllowed, ExpectedReimbursement, DefaultAdjustmentCode, ClearinghousePayerID)
	SELECT	USL.ClaimID as ClaimID,
			IP.InsurancePolicyID as InsurancePolicyID, 
			IP.Precedence, 
			IP.InsuranceCompanyPlanID,
			ICP.PlanName,
			cast(0 as decimal) as ExpectedAllowed,
			cast(0 as decimal) as ExpectedReimbursement,
			IC.DefaultAdjustmentCode,
		    IC.ClearinghousePayerID
	FROM	#UniqueServiceLines USL
	INNER JOIN
			InsurancePolicy IP
	ON		   USL.PracticeID=IP.PracticeID AND USL.PatientCaseID = IP.PatientCaseID
	INNER JOIN
			InsuranceCompanyPlan ICP
	ON		   IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
	INNER JOIN
			InsuranceCompany IC
	ON		   IC.InsuranceCompanyID = ICP.InsuranceCompanyID
	ORDER BY
			USL.ClaimID, IP.Precedence

	DECLARE @CandidateInsPlans TABLE(TID INT IDENTITY(1,1), InsuranceCompanyPlanID INT, PercentageOfClaims REAL)
	INSERT @CandidateInsPlans(InsuranceCompanyPlanID, PercentageOfClaims)
	SELECT InsuranceCompanyPlanID, CAST(COUNT(InsuranceCompanyPlanID) AS REAL)/CAST(@TotalClaims AS REAL)
	FROM #ClaimPayers
	GROUP BY InsuranceCompanyPlanID
	ORDER BY CAST(COUNT(InsuranceCompanyPlanID) AS REAL)/CAST(@TotalClaims AS REAL) DESC

	DECLARE @PlanMatchScoring TABLE(TID INT IDENTITY(1,1), InsuranceCompanyPlanID INT, PayerNumberMatchScore INT, MatchScore INT, PlanName VARCHAR(128))
	INSERT @PlanMatchScoring(InsuranceCompanyPlanID, PayerNumberMatchScore, MatchScore, PlanName)
	SELECT ICP.InsuranceCompanyPlanID, 
	dbo.fn_MatchPercent(@PayerNumber,PayerNumber,0) PayerNumberMatchScore,
	dbo.fn_MatchPercent(@PayerAddress,ICP.AddressLine1,0) +
	dbo.fn_MatchPercent(@PayerName,ICP.PlanName,0) +
	dbo.fn_MatchPercent(@PayerCity,ICP.City,0) + dbo.fn_MatchPercent(@PayerState,ICP.State,0)+
	dbo.fn_MatchPercent(@PayerZip,ICP.ZipCode,0) + dbo.fn_MatchPercent(@PayerPhone,ICP.Phone,0) MatchScore,
	ICP.PlanName
	FROM InsuranceCompanyPlan ICP INNER JOIN @CandidateInsPlans CIP
	ON ICP.InsuranceCompanyPlanID=CIP.InsuranceCompanyPlanID
	INNER JOIN InsuranceCompany IC
	ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
	LEFT JOIN ClearinghousePayersList CPL
	ON IC.ClearinghousePayerID=CPL.ClearinghousePayerID
	ORDER BY CASE WHEN dbo.fn_MatchPercent(@PayerNumber,PayerNumber,0)=100 THEN 1 ELSE 0 END DESC,
	dbo.fn_MatchPercent(@PayerAddress,ICP.AddressLine1,0) +
	dbo.fn_MatchPercent(@PayerName,ICP.PlanName,0) +
	dbo.fn_MatchPercent(@PayerCity,ICP.City,0) + dbo.fn_MatchPercent(@PayerState,ICP.State,0)+
	dbo.fn_MatchPercent(@PayerZip,ICP.ZipCode,0) + dbo.fn_MatchPercent(@PayerPhone,ICP.Phone,0) DESC

	DECLARE @PayerID INT
	SELECT @PayerID=CASE WHEN CIP.InsuranceCompanyPlanID=PMS.InsuranceCompanyPlanID THEN CIP.InsuranceCompanyPlanID
	ELSE PMS.InsuranceCompanyPlanID END
	FROM @CandidateInsPlans CIP INNER JOIN @PlanMatchScoring PMS
	ON CIP.TID=PMS.TID
	WHERE CIP.TID=1 AND MatchScore<>0 OR CIP.TID=1 AND PayerNumberMatchScore=100

	--Remove error related service line data from work tables
	DELETE RC
	FROM #RepClaims RC INNER JOIN #Errors E
	ON RC.RID=E.RID

	DELETE CP
	FROM #ServiceLines SL INNER JOIN #Trace2110 T
	ON SL.SvcRID=T.SvcRID
	INNER JOIN #Errors E
	ON T.RID=E.RID
	INNER JOIN #ClaimPayers CP
	ON SL.ClaimID=CP.ClaimID

	DELETE USL
	FROM #ServiceLines SL INNER JOIN #Trace2110 T
	ON SL.SvcRID=T.SvcRID
	INNER JOIN #Errors E
	ON T.RID=E.RID
	INNER JOIN #UniqueServiceLines USL
	ON SL.ClaimID=USL.ClaimID

	DELETE SL
	FROM #ServiceLines SL INNER JOIN #Trace2110 T
	ON SL.SvcRID=T.SvcRID
	INNER JOIN #Errors E
	ON T.RID=E.RID

	IF EXISTS(SELECT * FROM #Errors)
	BEGIN
		IF NOT EXISTS(SELECT * FROM #RepClaims)
			SET @ERA_ErrorsXML=@ERA_ErrorsXML+'<error>No claims from this ERA could be matched to claims currently in the system</error></loop>'

		IF EXISTS(SELECT * FROM #RepClaims) AND @PayerID IS NULL
			SET @ERA_ErrorsXML=@ERA_ErrorsXML+'<error>The system could not match the ERA payer to an insurance company in the system.  Please select a payer on the General tab.</error></loop>'

		IF EXISTS(SELECT * FROM #RepClaims) AND @PayerID IS NOT NULL
			SET @ERA_ErrorsXML=@ERA_ErrorsXML+'</loop>'

		DROP TABLE #Errors
	END
	ELSE
	BEGIN
		IF @PayerID IS NULL
		BEGIN
			SELECT @ERA_ErrorsXML='<loop name="ST">'+CAST(@ERAXml.query('/loop/*[local-name()!="loop"]') AS VARCHAR(MAX))
			+CAST(@ERAXml.query('/loop/loop[@name!="2000"]') AS VARCHAR(MAX))
			+'<error>The system could not match the ERA payer to an insurance company in the system.  Please select a payer on the General tab.</error></loop>'
		END
	END

	DECLARE @PaymentAmount MONEY
	DECLARE @CheckNumber VARCHAR(100)
	SELECT @PaymentAmount=PaymentAmount, @CheckNumber=CheckNumber FROM #GeneralPaymentInfo

	CREATE TABLE #UniqueEncountersList(PracticeID INT, PatientID INT, EncounterID INT, RawEOBXml VARCHAR(MAX), RawEOBStarted BIT, ReversalStarted BIT)
	INSERT INTO #UniqueEncountersList(PracticeID, PatientID, EncounterID, RawEOBStarted, ReversalStarted)
	SELECT DISTINCT PracticeID, PatientID, EncounterID, 0 , 0
	FROM #UniqueServiceLines

	CREATE TABLE #UniqueEncounterToRIDList(RID INT, EncounterID INT)
	INSERT INTO #UniqueEncounterToRIDList(RID, EncounterID) 
	SELECT DISTINCT T.RID, SL.EncounterID
	FROM #Trace2110 T INNER JOIN #ServiceLines SL
	ON T.SvcRID=SL.SvcRID

	DECLARE @LoopXMLToBuild INT

	CREATE TABLE #Encounter_RawEOBXml(EncounterID INT, MIN_RID INT, MIN_ReversalRID INT, Loops INT, NonReversals INT, Reversals INT)
	INSERT INTO #Encounter_RawEOBXml(EncounterID, MIN_RID, MIN_ReversalRID, Loops, NonReversals, Reversals)
	SELECT UE.EncounterID, MIN(CASE WHEN Reversal=0 THEN UE.RID ELSE NULL END) MIN_RID, 
	MIN(CASE WHEN Reversal=1 THEN UE.RID ELSE NULL END) MIN_ReversalRID, 
	CASE WHEN COUNT(UE.RID)>0 THEN COUNT(UE.RID)-1 ELSE 0 END Loops, 
	CASE WHEN COUNT(CASE WHEN Reversal=0 THEN UE.RID ELSE NULL END)>0 THEN COUNT(CASE WHEN Reversal=0 THEN UE.RID ELSE NULL END)-1 ELSE 0 END NonReversals,
	CASE WHEN COUNT(CASE WHEN Reversal=1 THEN UE.RID ELSE NULL END)>0 THEN COUNT(CASE WHEN Reversal=1 THEN UE.RID ELSE NULL END)-1 ELSE 0 END Reversals
	FROM #UniqueEncounterToRIDList UE INNER JOIN #Trace2100 T
	ON UE.RID=T.RID
	GROUP BY UE.EncounterID

	SET @LoopXMLToBuild=@@ROWCOUNT

	WHILE @LoopXMLToBuild>0
	BEGIN
		IF EXISTS(SELECT * FROM #Encounter_RawEOBXml WHERE MIN_RID IS NOT NULL)
		BEGIN
			DELETE #Encounter_RawEOBXml WHERE MIN_RID IS NULL

			UPDATE UE SET RawEOBXml=ISNULL(RawEOBXml,'')+CASE WHEN UE.RawEOBStarted=0 THEN '<rawEOB><nonreversal>' ELSE '' END+
									CONVERT(VARCHAR(MAX),EOBXml)+
									CASE WHEN ERXML.NonReversals=0 THEN '</nonreversal>' ELSE '' END +
									CASE WHEN ERXML.Loops=0 THEN '</rawEOB>' ELSE '' END,
						  RawEOBStarted=1
			FROM #UniqueEncountersList UE INNER JOIN #Encounter_RawEOBXml ERXML
			ON UE.EncounterID=ERXML.EncounterID
			INNER JOIN #Trace2100 T
			ON ERXML.MIN_RID=T.RID

			UPDATE T SET EOBXmlAppended=1
			FROM #UniqueEncountersList UE INNER JOIN #Encounter_RawEOBXml ERXML
			ON UE.EncounterID=ERXML.EncounterID
			INNER JOIN #Trace2100 T
			ON ERXML.MIN_RID=T.RID
		END
		ELSE
		BEGIN
			UPDATE UE SET RawEOBXml=ISNULL(RawEOBXml,'')+CASE WHEN UE.RawEOBStarted=0 THEN '<rawEOB>' ELSE '' END+
									CASE WHEN UE.ReversalStarted=0 THEN '<reversal>' ELSE '' END+
									CONVERT(VARCHAR(MAX),EOBXml)+
									CASE WHEN ERXML.Reversals=0 THEN '</reversal>' ELSE '' END+
									CASE WHEN ERXML.Loops=0 THEN '</rawEOB>' ELSE '' END,
						  RawEOBStarted=1,
						  ReversalStarted=1
			FROM #UniqueEncountersList UE INNER JOIN #Encounter_RawEOBXml ERXML
			ON UE.EncounterID=ERXML.EncounterID
			INNER JOIN #Trace2100 T
			ON ERXML.MIN_ReversalRID=T.RID
			WHERE MIN_RID IS NULL 

			UPDATE T SET EOBXmlAppended=1
			FROM #UniqueEncountersList UE INNER JOIN #Encounter_RawEOBXml ERXML
			ON UE.EncounterID=ERXML.EncounterID
			INNER JOIN #Trace2100 T
			ON ERXML.MIN_ReversalRID=T.RID
			WHERE MIN_RID IS NULL 
		END

		DELETE #Encounter_RawEOBXml

		INSERT INTO #Encounter_RawEOBXml(EncounterID, MIN_RID, MIN_ReversalRID, Loops, NonReversals, Reversals)
		SELECT UE.EncounterID, MIN(CASE WHEN Reversal=0 THEN UE.RID ELSE NULL END) MIN_RID, 
		MIN(CASE WHEN Reversal=1 THEN UE.RID ELSE NULL END) MIN_ReversalRID, 
		CASE WHEN COUNT(UE.RID)>0 THEN COUNT(UE.RID)-1 ELSE 0 END Loops, 
		CASE WHEN COUNT(CASE WHEN Reversal=0 THEN UE.RID ELSE NULL END)>0 THEN COUNT(CASE WHEN Reversal=0 THEN UE.RID ELSE NULL END)-1 ELSE 0 END NonReversals,
		CASE WHEN COUNT(CASE WHEN Reversal=1 THEN UE.RID ELSE NULL END)>0 THEN COUNT(CASE WHEN Reversal=1 THEN UE.RID ELSE NULL END)-1 ELSE 0 END Reversals
		FROM #UniqueEncounterToRIDList UE INNER JOIN #Trace2100 T
		ON UE.RID=T.RID
		WHERE EOBXmlAppended=0	
		GROUP BY UE.EncounterID

		SET @LoopXMLToBuild=@@ROWCOUNT
	END

	--Build service line rawEOBXml
	CREATE TABLE #ServiceLine_RawEOBXml(ClaimID INT, MIN_SvcRID INT, MIN_ReversalSvcRID INT, Loops INT, NonReversals INT, Reversals INT)
	INSERT INTO #ServiceLine_RawEOBXml(ClaimID, MIN_SvcRID, MIN_ReversalSvcRID, Loops, NonReversals, Reversals)
	SELECT US.ClaimID, MIN(CASE WHEN Reversal=0 THEN US.SvcRID ELSE NULL END) MIN_SvcRID, 
	MIN(CASE WHEN Reversal=1 THEN US.SvcRID ELSE NULL END) MIN_ReversalSvcRID, 
	CASE WHEN COUNT(US.SvcRID)>0 THEN COUNT(US.SvcRID)-1 ELSE 0 END Loops, 
	CASE WHEN COUNT(CASE WHEN Reversal=0 THEN US.SvcRID ELSE NULL END)>0 THEN COUNT(CASE WHEN Reversal=0 THEN US.SvcRID ELSE NULL END)-1 ELSE 0 END NonReversals,
	CASE WHEN COUNT(CASE WHEN Reversal=1 THEN US.SvcRID ELSE NULL END)>0 THEN COUNT(CASE WHEN Reversal=1 THEN US.SvcRID ELSE NULL END)-1 ELSE 0 END Reversals
	FROM #ServiceLines US INNER JOIN #Trace2110_EOBXml T
	ON US.SvcRID=T.SvcRID
	GROUP BY US.ClaimID

	SET @LoopXMLToBuild=@@ROWCOUNT

	WHILE @LoopXMLToBuild>0
	BEGIN
		IF EXISTS(SELECT * FROM #ServiceLine_RawEOBXml WHERE MIN_SvcRID IS NOT NULL)
		BEGIN
			DELETE #ServiceLine_RawEOBXml WHERE MIN_SvcRID IS NULL

			UPDATE US SET RawEOBXml=ISNULL(RawEOBXml,'')+CASE WHEN US.RawEOBStarted=0 THEN '<rawEOB><nonreversal>' ELSE '' END+
									CONVERT(VARCHAR(MAX),EOBXml)+
									CASE WHEN SRXML.NonReversals=0 THEN '</nonreversal>' ELSE '' END +
									CASE WHEN SRXML.Loops=0 THEN '</rawEOB>' ELSE '' END,
						  RawEOBStarted=1
			FROM #UniqueServiceLines US INNER JOIN #ServiceLine_RawEOBXml SRXML
			ON US.ClaimID=SRXML.ClaimID
			INNER JOIN #Trace2110_EOBXml T
			ON SRXML.MIN_SvcRID=T.SvcRID

			UPDATE T SET EOBXmlAppended=1
			FROM #UniqueServiceLines US INNER JOIN #ServiceLine_RawEOBXml SRXML
			ON US.ClaimID=SRXML.ClaimID
			INNER JOIN #Trace2110_EOBXml T
			ON SRXML.MIN_SvcRID=T.SvcRID

		END
		ELSE
		BEGIN
			UPDATE US SET RawEOBXml=ISNULL(RawEOBXml,'')+CASE WHEN US.RawEOBStarted=0 THEN '<rawEOB>' ELSE '' END+
									CASE WHEN US.ReversalStarted=0 THEN '<reversal>' ELSE '' END+
									CONVERT(VARCHAR(MAX),EOBXml)+
									CASE WHEN SRXML.Reversals=0 THEN '</reversal>' ELSE '' END+
									CASE WHEN SRXML.Loops=0 THEN '</rawEOB>' ELSE '' END,
						  RawEOBStarted=1,
						  ReversalStarted=1
			FROM #UniqueServiceLines US INNER JOIN #ServiceLine_RawEOBXml SRXML
			ON US.ClaimID=SRXML.ClaimID
			INNER JOIN #Trace2110_EOBXml T
			ON SRXML.MIN_ReversalSvcRID=T.SvcRID
			WHERE MIN_SvcRID IS NULL 

			UPDATE T SET EOBXmlAppended=1
			FROM #UniqueServiceLines US INNER JOIN #ServiceLine_RawEOBXml SRXML
			ON US.ClaimID=SRXML.ClaimID
			INNER JOIN #Trace2110_EOBXml T
			ON SRXML.MIN_ReversalSvcRID=T.SvcRID
			WHERE MIN_SvcRID IS NULL 
		END

		DELETE #ServiceLine_RawEOBXml

		INSERT INTO #ServiceLine_RawEOBXml(ClaimID, MIN_SvcRID, MIN_ReversalSvcRID, Loops, NonReversals, Reversals)
		SELECT US.ClaimID, MIN(CASE WHEN Reversal=0 THEN US.SvcRID ELSE NULL END) MIN_SvcRID, 
		MIN(CASE WHEN Reversal=1 THEN US.SvcRID ELSE NULL END) MIN_ReversalSvcRID, 
		CASE WHEN COUNT(US.SvcRID)>0 THEN COUNT(US.SvcRID)-1 ELSE 0 END Loops, 
		CASE WHEN COUNT(CASE WHEN Reversal=0 THEN US.SvcRID ELSE NULL END)>0 THEN COUNT(CASE WHEN Reversal=0 THEN US.SvcRID ELSE NULL END)-1 ELSE 0 END NonReversals,
		CASE WHEN COUNT(CASE WHEN Reversal=1 THEN US.SvcRID ELSE NULL END)>0 THEN COUNT(CASE WHEN Reversal=1 THEN US.SvcRID ELSE NULL END)-1 ELSE 0 END Reversals
		FROM #ServiceLines US INNER JOIN #Trace2110_EOBXml T
		ON US.SvcRID=T.SvcRID
		WHERE EOBXmlAppended=0
		GROUP BY US.ClaimID

		SET @LoopXMLToBuild=@@ROWCOUNT
	END

	--Persist RawEOB XML for both the Encounter and Service Lines
	--Check what encounter entries will be populated (not already persisted)
	CREATE TABLE #PaymentRawEOBExclusions_Encounters(EncounterID INT)
	INSERT INTO #PaymentRawEOBExclusions_Encounters(EncounterID)
	SELECT EncounterID
	FROM PaymentRawEOB
	WHERE PracticeID=@PracticeID AND ClearinghouseResponseID=@ClearinghouseResponseID AND ParseType='E'

	CREATE TABLE #PaymentRawEOBExclusions_Claims(ClaimID INT)
	INSERT INTO #PaymentRawEOBExclusions_Claims(ClaimID)
	SELECT ClaimID
	FROM PaymentRawEOB
	WHERE PracticeID=@PracticeID AND ClearinghouseResponseID=@ClearinghouseResponseID AND ParseType='S'

	INSERT INTO PaymentRawEOB(PracticeID, ClearinghouseResponseID, ParseType, EncounterID, ClaimID, RawEOBXML)
	SELECT PracticeID, @ClearinghouseResponseID, 'E', UEL.EncounterID, NULL, RawEOBXml
	FROM #UniqueEncountersList UEL LEFT JOIN #PaymentRawEOBExclusions_Encounters PE
	ON UEL.EncounterID=PE.EncounterID
	WHERE PE.EncounterID IS NULL

	INSERT INTO PaymentRawEOB(PracticeID, ClearinghouseResponseID, ParseType, EncounterID, ClaimID, RawEOBXML)
	SELECT PracticeID, @ClearinghouseResponseID, 'S', EncounterID, USL.ClaimID, RawEOBXml
	FROM #UniqueServiceLines USL LEFT JOIN #PaymentRawEOBExclusions_Claims PC
	ON USL.ClaimID=PC.ClaimID
	WHERE PC.ClaimID IS NULL

	DROP TABLE #PaymentRawEOBExclusions_Encounters
	DROP TABLE #PaymentRawEOBExclusions_Claims

	CREATE TABLE #ASN ( 
		ASNID INT IDENTITY(1,1), 
		CID INT,
		ClaimID INT, 
		InsurancePolicyID INT, 
		InsuranceCompanyPlanID INT, 
		PostingDate DATETIME, 
		Precedence TINYINT, 
		InsuranceCompanyName VARCHAR(128), 
		ClaimTransactionID INT, 
		EndClaimTransactionID INT,
		Code VARCHAR(50),
		PreviousType CHAR(1) )

	INSERT INTO #ASN ( 
		ClaimID, 
		InsurancePolicyID, 
		InsuranceCompanyPlanID, 
		PostingDate, 
		ClaimTransactionID, 
		EndClaimTransactionID,
		Code )
	SELECT 
		CAA.ClaimID, 
		CAA.InsurancePolicyID, 
		CAA.InsuranceCompanyPlanID, 
		CAA.PostingDate, 
		CAA.ClaimTransactionID, 
		CAA.EndClaimTransactionID,
		Code
	FROM #UniqueServiceLines USL INNER JOIN ClaimAccounting_Assignments CAA 
		ON USL.PracticeID=CAA.PracticeID AND USL.ClaimID=CAA.ClaimID
		INNER JOIN ClaimTransaction CT
		ON CAA.PracticeID=CT.PracticeID AND CAA.ClaimTransactionID=CT.ClaimTransactionID
	ORDER BY 
		CAA.ClaimID, CAA.ClaimTransactionID

	UPDATE A 
	SET 
		Precedence = IP.Precedence, 
		InsuranceCompanyName = IC.InsuranceCompanyName
	FROM 
		#ASN A 
		INNER JOIN InsurancePolicy IP 
			ON A.InsurancePolicyID = IP.InsurancePolicyID
		INNER JOIN InsuranceCompanyPlan ICP
			ON IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
		INNER JOIN InsuranceCompany IC
			ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID

	CREATE TABLE #ASN_MinClaimASNID(ClaimID INT, MinASNID INT)
	INSERT INTO #ASN_MinClaimASNID(ClaimID, MinASNID)
	SELECT ClaimID, MIN(ASNID)
	FROM #ASN
	GROUP BY ClaimID

	UPDATE A SET CID=ASNID-(MinASNID-1)
	FROM #ASN A INNER JOIN #ASN_MinClaimASNID AMA
	ON A.ClaimID=AMA.ClaimID

	UPDATE A SET PreviousType=CASE WHEN A2.InsuranceCompanyPlanID IS NULL THEN 'P' ELSE 'I' END
	FROM #ASN A INNER JOIN #ASN A2
	ON A.ClaimID=A2.ClaimID AND A.CID=A2.CID+1

	CREATE TABLE #BLL( 
		ASNID INT, 
		ClaimID INT,
		ClaimTransactionID INT, 
		BatchType CHAR(1), 
		PostingDate DATETIME )

	INSERT INTO #BLL (
		ASNID, 
		ClaimID,
		ClaimTransactionID, 
		BatchType, 
		PostingDate )
	SELECT 
		ASNID, 
		CAB.ClaimID,
		CAB.ClaimTransactionID, 
		BatchType, 
		CAB.PostingDate
	FROM 
		ClaimAccounting_Billings CAB 
		INNER JOIN #ASN A
			ON CAB.ClaimID = A.ClaimID 
			AND CAB.ClaimTransactionID BETWEEN A.ClaimTransactionID AND A.EndClaimTransactionID
			OR CAB.ClaimID = A.ClaimID 
			AND CAB.ClaimTransactionID > A.ClaimTransactionID 
			AND A.EndClaimTransactionID IS NULL
	WHERE CAB.PracticeID=@PracticeID

	CREATE TABLE #CTs( 
		ASNID INT, 
		PracticeID INT, 
		ClaimID INT, 
		ClaimTransactionID INT, 
		ClaimTransactionTypeCode CHAR(3), 
		Amount MONEY, 
		Code VARCHAR(50),
		PostingDate DATETIME, 
		AdjustmentCode VARCHAR(10), 
		AdjustmentReasonCode VARCHAR(5),
		Notes TEXT, 
		PaymentID INT, 
		Reversible BIT,
		InsuranceCompanyName VARCHAR(128), 
		PayerTypeCode CHAR(1) )

	INSERT INTO #CTs (
		PracticeID, 
		ClaimID, 
		ClaimTransactionID, 
		ClaimTransactionTypeCode, 
		Amount, 
		Code,
		PostingDate, 
		AdjustmentCode, 
		AdjustmentReasonCode,
		Notes, 
		PaymentID, 
		Reversible )
	SELECT 
		CT.PracticeID, 
		CT.ClaimID, 
		ClaimTransactionID, 
		ClaimTransactionTypeCode, 
		Amount, 
		Code, 
		PostingDate, 
		AdjustmentCode, 
		AdjustmentReasonCode,
		Notes, 
		PaymentID, 
		Reversible
	FROM 
		#UniqueServiceLines USL INNER JOIN ClaimTransaction CT
		ON USL.PracticeID=CT.PracticeID AND USL.ClaimID=CT.ClaimID

	CREATE TABLE #LastCTIDs(ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #LastCTIDs(ClaimID, ClaimTransactionID)
	SELECT ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM #CTs
	GROUP BY ClaimID

	DELETE #CTs
	WHERE ClaimTransactionTypeCode IN ('BLL','ASN','EDI','CLS')

	--UPDATE RAS trans with association to ASN
	UPDATE CT 
	SET 
		ASNID = A.ASNID
	FROM 
		#CTs CT 
		INNER JOIN #ASN A
			ON CT.ClaimID = A.ClaimID 
			AND CT.ClaimTransactionID BETWEEN A.ClaimTransactionID AND A.EndClaimTransactionID
			OR CT.ClaimID = A.ClaimID 
			AND CT.ClaimTransactionID > A.ClaimTransactionID 
			AND A.EndClaimTransactionID IS NULL
	WHERE 
		CT.ClaimTransactionTypeCode = 'RAS'

	UPDATE CT 
	SET 
		ASNID = A.ASNID, 
		InsuranceCompanyName = IC.InsuranceCompanyName, 
		PayerTypeCode = P.PayerTypeCode
	FROM 
		#CTs CT 
		INNER JOIN Payment P
			ON CT.PaymentID = P.PaymentID
		LEFT JOIN #ASN A
			ON P.PayerTypeCode = 'I' 
			AND P.PayerID=A.InsuranceCompanyPlanID
		LEFT JOIN InsuranceCompanyPlan ICP
			ON P.PayerTypeCode = 'I' 
			AND P.PayerID=ICP.InsuranceCompanyPlanID
		LEFT JOIN InsuranceCompany IC
			ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
	WHERE 
		P.PracticeID=@PracticeID AND CT.ClaimTransactionTypeCode IN ('PAY','ADJ')

	CREATE TABLE #ASNBalances(
		ASNID INT, Balance MONEY )

	INSERT INTO #ASNBalances (
		ASNID, 
		Balance )
	SELECT 
		A.ASNID, 
		SUM( CASE 
			WHEN ClaimTransactionTypeCode = 'CST' THEN Amount
			WHEN ClaimTransactionTypeCode IN ('PAY','ADJ') THEN -1*Amount 
			ELSE 0 END )
	FROM 
		#CTs CT 
		INNER JOIN #ASN A
			ON CT.ClaimID=A.ClaimID AND CT.ClaimTransactionID <= A.ClaimTransactionID
	GROUP BY 
		A.ASNID

	CREATE TABLE #Results(
		RID INT IDENTITY(1,1), 
		CID INT,
		ClaimID INT,
		ClaimTransactionID INT, 
		ClaimTransactionTypeCode CHAR(3), 
		PaymentID INT, 
		[Type] CHAR(1), 
		Reversible BIT,
		AdjustmentCode VARCHAR(10), 
		AdjustmentReasonCode VARCHAR(5), 
		PostingDate DATETIME, 
		Precedence TINYINT, 
		InsuranceCompanyName VARCHAR(128),
		InsPlanID INT, 
		BatchType CHAR(1), 
		Amount MONEY, 
		Code VARCHAR(50),
		PatResp MONEY, 
		TotalBalance MONEY, 
		Notes TEXT,
		Sort TINYINT,
		IsModified BIT DEFAULT (0),
		IsNew BIT DEFAULT (0),
		IsDeleted BIT DEFAULT (0),
		IsPosted BIT DEFAULT (0) )

	INSERT INTO #Results( 
		ClaimID,
		ClaimTransactionID, 
		ClaimTransactionTypeCode, 
		PaymentID, 
		[Type], 
		Reversible,
		AdjustmentCode,
		AdjustmentReasonCode,
		PostingDate, 
		Precedence, 
		InsuranceCompanyName, 
		InsPlanID,
		BatchType, 
		Amount, 
		Code,
		Sort,
		IsPosted )
	SELECT
		CT.ClaimID, 
		CT.ClaimTransactionID, 
		ClaimTransactionTypeCode, 
		PaymentID, 
		PayerTypeCode, 
		Reversible,  
		AdjustmentCode,
		AdjustmentReasonCode,
		CT.PostingDate, 
		A.Precedence, 
		ISNULL(A.InsuranceCompanyName, CT.InsuranceCompanyName), 
		A.InsurancePolicyID, 
		NULL BatchType, 
		ISNULL(Amount, 0) Amount,
		CT.Code, 
		CASE 
			WHEN ClaimTransactionTypeCode='CST' THEN 0
			WHEN ClaimTransactionTypeCode='ASN' THEN 1
			WHEN ClaimTransactionTypeCode='PRC' THEN 2
			WHEN ClaimTransactionTypeCode IN ('BLL','RAS') THEN 3
			WHEN ClaimTransactionTypeCode IN ('PAY','ADJ') THEN 4
			WHEN ClaimTransactionTypeCode='END' THEN 100 
			ELSE 5 END Sort,
		1
	FROM 
		#CTs CT 
		LEFT JOIN #ASN A
			ON CT.ASNID=A.ASNID
	UNION
	SELECT 
		BLL.ClaimID,
		BLL.ClaimTransactionID, 
		'BLL' ClaimTransactionTypeCode, 
		NULL PaymentID, 
		NULL [Type], 
		0 Reversible,  
		NULL AdjustmentCode, 
		NULL AdjustmentReasonCode,
		BLL.PostingDate, 
		A.Precedence, 
		A.InsuranceCompanyName, 
		A.InsurancePolicyID, 
		BatchType, 
		0 Amount, 
		A.Code, 
		3 Sort,
		1 IsPosted
	FROM 
		#BLL BLL 
		INNER JOIN #ASN A
			ON BLL.ASNID=A.ASNID
	UNION
	SELECT 
		A.ClaimID,
		ClaimTransactionID, 
		'ASN' 
		ClaimTransactionTypeCode, 
		NULL PaymentID, 
		CASE 
			WHEN InsuranceCompanyPlanID IS NULL THEN 'P' 
			ELSE 'I' END [Type],
		0 Reversible,  
		A.Code AdjustmentCode, 
		NULL AdjustmentReasonCode,
		A.PostingDate, 
		Precedence, 
		InsuranceCompanyName,
		A.InsurancePolicyID,  
		NULL BatchType, 
		Balance Amount,
		A.Code,  
		1 Sort,
		1 IsPosted
	FROM 
		#ASN A 
		INNER JOIN #ASNBalances AB
			ON A.ASNID=AB.ASNID
	ORDER BY 
		ClaimID, ClaimTransactionID-- PostingDate, Sort

	UPDATE R 
		SET [Type] = CASE WHEN A.InsuranceCompanyPlanID IS NULL THEN 'P' 
			ELSE 'I' END
	FROM 
		#Results R 
			INNER JOIN #ASN A
				ON R.ClaimID=A.ClaimID AND R.ClaimTransactionID BETWEEN A.ClaimTransactionID AND A.EndClaimTransactionID
				OR R.ClaimID=A.ClaimID AND R.ClaimTransactionID > A.ClaimTransactionID 
				AND A.EndClaimTransactionID IS NULL
	WHERE 
		R.[Type] IS NULL

	UPDATE R 
	SET 
		PatResp = CASE 
			WHEN ClaimTransactionTypeCode='ASN' AND [Type] = 'P' THEN Amount
			WHEN ClaimTransactionTypeCode='ASN' AND Type='I' AND (PreviousType IS NULL OR PreviousType='P') THEN -1*Amount
			WHEN ClaimTransactionTypeCode='PRC' THEN Amount
			WHEN ClaimTransactionTypeCode='CST' THEN Amount
			WHEN Type='P' THEN -1*Amount
			WHEN Type='I' THEN 0 ELSE 0 END,
		TotalBalance = CASE 
			WHEN ClaimTransactionTypeCode='CST' THEN Amount
			WHEN ClaimTransactionTypeCode='PRC' THEN 0
			WHEN ClaimTransactionTypeCode IN ('PAY','ADJ') THEN -1*Amount
			ELSE 0 END	
	FROM #Results R LEFT JOIN #ASN A
	ON R.ClaimTransactionID=A.ClaimTransactionID

	CREATE TABLE #Result_MinClaimRID(ClaimID INT, MinRID INT)
	INSERT INTO #Result_MinClaimRID(ClaimID, MinRID)
	SELECT ClaimID, MIN(RID)
	FROM #Results
	GROUP BY ClaimID

	UPDATE R SET CID=RID-(MinRID-1)
	FROM #Results R INNER JOIN #Result_MinClaimRID RMR
	ON R.ClaimID=RMR.ClaimID

	CREATE TABLE #RunningTotals( 
		RID INT, 
		Amount MONEY, 
		PatResp MONEY, 
		TotalBalance MONEY)
	
	INSERT INTO #RunningTotals (
		RID, 
		Amount, 
		PatResp, 
		TotalBalance )
	SELECT 
		R2.RID, 
		R2.Amount, 
		SUM(R1.PatResp) PatResp, 
		SUM(R1.TotalBalance) TotalBalance
	FROM 
		#Results R1 
		INNER JOIN #Results R2
			ON R1.ClaimID=R2.ClaimID AND R1.CID<=R2.CID
	GROUP BY 
		R2.RID, R2.Amount

	UPDATE R 
	SET PatResp = RT.PatResp, 
		TotalBalance = RT.TotalBalance,
		Notes = CT.Notes
	FROM #Results R 
		INNER JOIN #RunningTotals RT
			ON R.RID=RT.RID
		LEFT JOIN #CTs CT
			ON CT.ClaimTransactionID = R.ClaimTransactionID

	DECLARE @InsurancePayerID INT
	DECLARE @InsurancePayerName AS VARCHAR(256)

	SELECT @InsurancePayerID=InsuranceCompanyPlanID, @InsurancePayerName=PlanName
	FROM @PlanMatchScoring
	WHERE InsuranceCompanyPlanID=@PayerID

	SELECT ISNULL(@PaymentAmount,0) PaymentAmount, @InsurancePayerID InsurancePayerID, @InsurancePayerName InsurancePayerName,
		   @AdjudicationDate AdjudicationDate, CONVERT(XML,@ERA_ErrorsXML) ERAErrors, @ClearinghouseResponseID ClearinghouseResponseID,
		   @CheckNumber PaymentNumber, @PaymentNotes Description
		   

	SELECT UEL.PatientID, 
	RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName, '') + ISNULL(' ' + P.MiddleName, '')) PatientFullName,
	SUM(PaymentParticipationAmount) PaymentParticipatingAmount
	FROM #UniqueEncountersList UEL INNER JOIN Patient P
	ON UEL.PatientID=P.PatientID
	INNER JOIN #UniqueEncounterToRIDList UERL
	ON UEL.EncounterID=UERL.EncounterID
	INNER JOIN #Trace2100 T
	ON UERL.RID=T.RID
	GROUP BY UEL.PatientID, 
	RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName, '') + ISNULL(' ' + P.MiddleName, ''))

	SELECT UEL.EncounterID, UEL.PatientID, E.DateOfService, NULL EOBXml, CONVERT(XML, UEL.RawEOBXml) RawEOBXml, PRE.PaymentRawEOBID
	FROM #UniqueEncountersList UEL INNER JOIN Encounter E
	ON UEL.PracticeID=E.PracticeID AND UEL.EncounterID=E.EncounterID
	INNER JOIN PaymentRawEOB PRE
	ON UEL.PracticeID=PRE.PracticeID AND PRE.ClearinghouseResponseID=@ClearinghouseResponseID AND ParseType='E'
	AND UEL.EncounterID=PRE.EncounterID

	CREATE TABLE #UniqueServiceLineDetail(ClaimID INT, DateOfService DATETIME, ProcedureCode VARCHAR(16), ProcedureCodeDictionaryID INT,
										  Mod1 VARCHAR(16), OrigAmount MONEY)
	INSERT INTO #UniqueServiceLineDetail(ClaimID, DateOfService, ProcedureCode, ProcedureCodeDictionaryID, Mod1, OrigAmount)
	SELECT ClaimID, ProcedureDateOfService, ProcedureCode, ProcedureCodeDictionaryID, Mod1, MAX(Charge) OrigAmount
	FROM #ServiceLines
	GROUP BY ClaimID, ProcedureDateOfService, ProcedureCode, ProcedureCodeDictionaryID, Mod1

	CREATE TABLE #ServiceLineFinancial(ClaimID INT, Charges MONEY, ExternalPayment MONEY, ExternalAdjustment MONEY, Receipts MONEY, Balance MONEY)
	INSERT INTO #ServiceLineFinancial(ClaimID, Charges, ExternalPayment, ExternalAdjustment, Receipts, Balance)
	SELECT ClaimID, 
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount END) Charges,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' THEN Amount END) ExternalPayment,
	SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN ISNULL(Amount,0) END) ExternalAdjustment,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' THEN Amount END) Receipts,
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN ISNULL(Amount,0) ELSE -1*ISNULL(Amount,0) END) Balance
	FROM #CTs
	WHERE ClaimTransactionTypeCode IN ('PAY','ADJ','CST')
	GROUP BY ClaimID

	SELECT SL.ClaimID, USL.PatientID, SL.DateOfService, 
	SL.ProcedureCode+' - '+ISNULL(PCD.LocalName,PCD.OfficialName) ProcedureCode,
	CAST(ISNULL(SLF.Charges,0) AS MONEY) OrigAmount, CAST(ISNULL(SLF.Charges,0) AS MONEY) Charges, CAST(0 AS MONEY) Payment, CAST(0 AS MONEY) Adjustment, CAST(0 AS MONEY) OtherAdjustment,
	CAST(ISNULL(SLF.ExternalPayment,0) AS MONEY) ExternalPayment, CAST(ISNULL(SLF.ExternalAdjustment,0) AS MONEY) ExternalAdjustment, 
	CAST(ISNULL(SLF.Receipts,0) AS MONEY) Receipts, CAST(ISNULL(SLF.Balance,0) AS MONEY) Balance, SL.ProcedureCodeDictionaryID ProcedureCodeDictionary, SL.Mod1 ProcedureModifier,
	USL.EncounterID, NULL EOBXml, CONVERT(XML,USL.RawEOBXml) RawEOBXml, PRE.PaymentRawEOBID
	FROM #UniqueServiceLines USL INNER JOIN #UniqueServiceLineDetail SL 
	ON USL.ClaimID=SL.ClaimID
	INNER JOIN #ServiceLineFinancial SLF
	ON SL.ClaimID=SLF.ClaimID
	INNER JOIN ProcedureCodeDictionary PCD
	ON SL.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	INNER JOIN PaymentRawEOB PRE 
	ON USL.PracticeID=PRE.PracticeID AND PRE.ClearinghouseResponseID=@ClearinghouseResponseID AND ParseType='S'
	AND USL.ClaimID=PRE.ClaimID

	SELECT r.*, ep.EncounterID as EncounterID 
		FROM #Results r
			INNER JOIN Claim c ON c.ClaimID = r.ClaimID
			INNER JOIN EncounterProcedure ep ON ep.EncounterProcedureID = c.EncounterProcedureID AND ep.PracticeID = c.PracticeID

	-- Get the last claim transaction id for the claim
	SELECT	ClaimID, ClaimTransactionID
	FROM	#LastCTIDs
	
	SELECT ClaimID as ClaimID, InsurancePolicyID as InsurancePolicyID, Precedence, PlanName, ExpectedAllowed, ExpectedReimbursement, DefaultAdjustmentCode
	FROM #ClaimPayers

	--Set the selected Insurance Policy
	UPDATE USL SET SelectedInsPolicyID=CP.InsurancePolicyID
	FROM #UniqueServiceLines USL INNER JOIN #ClaimPayers CP
	ON USL.ClaimID=CP.ClaimID
	WHERE CP.InsuranceCompanyPlanID=@PayerID

	UPDATE USL SET SelectedInsPolicyID=CP.InsurancePolicyID
	FROM #UniqueServiceLines USL INNER JOIN #ClaimPayers CP
	ON USL.ClaimID=CP.ClaimID
	INNER JOIN ClearinghousePayersList CPL
	ON CP.ClearinghousePayerID=CPL.ClearinghousePayerID
	WHERE USL.SelectedInsPolicyID IS NULL AND CPL.PayerNumber=@PayerNumber

	UPDATE USL SET SelectedInsPolicyID=CP.InsurancePolicyID
	FROM #UniqueServiceLines USL INNER JOIN #UniqueEncounterToRIDList UERL
	ON USL.EncounterID=UERL.EncounterID
	INNER JOIN #Trace2100 T
	ON UERL.RID=T.RID
	INNER JOIN #ClaimPayers CP
	ON USL.ClaimID=CP.ClaimID AND T.Stage=CP.Precedence
	WHERE USL.SelectedInsPolicyID IS NULL AND T.Stage IS NOT NULL

	--Update USL if not with SelectedInsPolicyID if not populated above
	CREATE TABLE #LastPolicyBilled(ClaimID INT, PracticeID INT, ClaimTransactionID INT)
	INSERT INTO #LastPolicyBilled(ClaimID, PracticeID, ClaimTransactionID)
	SELECT CAA.ClaimID, CAA.PracticeID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM #UniqueServiceLines USL INNER JOIN ClaimAccounting_Assignments CAA
	ON USL.PracticeID=CAA.PracticeID AND USL.ClaimID=CAA.ClaimID
	WHERE USL.SelectedInsPolicyID IS NULL AND InsurancePolicyID IS NOT NULL
	GROUP BY CAA.ClaimID, CAA.PracticeID

	UPDATE USL SET SelectedInsPolicyID=CAA.InsurancePolicyID
	FROM #UniqueServiceLines USL INNER JOIN #LastPolicyBilled LPB
	ON USL.ClaimID=LPB.ClaimID
	INNER JOIN ClaimAccounting_Assignments CAA
	ON LPB.PracticeID=CAA.PracticeID AND LPB.ClaimTransactionID=CAA.ClaimTransactionID
	
	DROP TABLE #LastPolicyBilled

	-- Claim Details information
	SELECT	C.ClaimID					as ClaimID,
			E.EncounterID				as EncounterID, 
			P.Prefix					as PatientPrefix,
			P.FirstName					as PatientFirstName,
			P.MiddleName				as PatientMiddleName,
			P.LastName					as PatientLastName,
			P.Suffix					as PatientSuffix,
			convert(varchar, EP.ProcedureDateOfService, 101)
										as ServiceDate,
			D.Prefix					as ProviderPrefix,
			D.FirstName					as ProviderFirstName,
			D.MiddleName				as ProviderMiddleName,
			D.LastName					as ProviderLastName,
			D.Suffix					as ProviderSuffix,
			D.Degree					as ProviderDegree,
			SL.Name						as Location,
			D2.Prefix					as ReferringPrefix,
			D2.FirstName				as ReferringFirstName,
			D2.MiddleName				as ReferringMiddleName,
			D2.LastName					as ReferringLastName,
			D2.Suffix					as ReferringSuffix,
			D2.Degree					as ReferringDegree, 
			PCD.ProcedureCode			as ProcedureCode,
			coalesce(PCD.LocalName, PCD.OfficialName)
										as Name, 
			EP.ProcedureModifier1		as Modifier,
			dbo.fn_ClaimDataProvider_GetDiagnoses(C.ClaimID)
										as Diagnoses,
			cast(EP.ServiceUnitCount as varchar) + ' x ' + cast(EP.ServiceChargeAmount as varchar)
										as UnitCharge,
			EP.ServiceUnitCount * EP.ServiceChargeAmount
										as TotalCharges,
			EP.ApplyCopay				as CopayRequired,
			EP.CopayAmount				as CopayAmount,
			USL.SelectedInsPolicyID		as SelectedInsPolicyID
	FROM	Claim C
	INNER JOIN
			#UniqueServiceLines USL
	ON		   USL.PracticeID = C.PracticeID
	AND		   USL.ClaimID = C.ClaimID
	INNER JOIN
			Patient P
	ON		   P.PatientID = C.PatientID
	INNER JOIN
			EncounterProcedure EP
	ON		   EP.EncounterProcedureID = C.EncounterProcedureID
	INNER JOIN
			Encounter E
	ON		   E.EncounterID = EP.EncounterID
	INNER JOIN
			Doctor D
	ON		   D.DoctorID = E.DoctorID
	INNER JOIN
			ServiceLocation SL
	ON		   SL.ServiceLocationID = E.LocationID
	LEFT OUTER JOIN
			Doctor D2
	ON		   D2.DoctorID = E.ReferringPhysicianID
	INNER JOIN
			ProcedureCodeDictionary PCD
	ON		   PCD.ProcedureCodeDictionaryID = EP.ProcedureCodeDictionaryID
	LEFT OUTER JOIN
			EncounterDiagnosis ED1
	ON		   ED1.EncounterDiagnosisID = EP.EncounterDiagnosisID1
	LEFT OUTER JOIN
			DiagnosisCodeDictionary DCD1
	ON		   DCD1.DiagnosisCodeDictionaryID = ED1.DiagnosisCodeDictionaryID

	-- Claim Assignment Options
	declare @ClaimIDsString varchar(max)
	SET		@ClaimIDsString = ''
	SELECT	@ClaimIDsString = @ClaimIDsString + cast(ClaimID as varchar) + ', '
	FROM	#UniqueServiceLines

	EXEC ClaimDataProvider_GetClaimsAssignmentOptions @ClaimIDsString

	-- Payment Claim details data
	SELECT 
		PC.PaymentClaimID, 
		PC.PaymentID, 
		PC.PracticeID, 
		PC.PatientID, 
		PC.EncounterID, 
		PC.ClaimID, 
		PC.EOBXml, 
		PC.Notes,
		PC.Reversed,
		cast('D' as char(1))	as AssignmentCode,
		cast('0' as char(1))	as StatusReasonCode,
		cast(0 as decimal)		as PatientAccountPaid, 
		cast(0 as decimal)		as PatientCopayPaid,
		cast(0 as bit)			as IsModified,
		cast(0 as bit)			as IsNew,
		cast(0 as bit)			as IsDeleted
	FROM
		PaymentClaim PC
	INNER JOIN
			#UniqueServiceLines USL
	ON		   USL.PracticeID = PC.PracticeID
	AND		   USL.ClaimID = PC.ClaimID

	DROP TABLE #GeneralPaymentInfo
	DROP TABLE #PayerInfo
	DROP TABLE #PayeeInfo
	DROP TABLE #Trace2100
	DROP TABLE #Trace2110_EOBXml
	DROP TABLE #Segments
	DROP TABLE #Trace2110
	DROP TABLE #DistinctServiceLines
	DROP TABLE #ServiceLineCounts
	DROP TABLE #RepClaims
	DROP TABLE #ServiceLines
	DROP TABLE #MatchedEncounterIDs
	DROP TABLE #UniqueServiceLines
	DROP TABLE #UniqueEncountersList
	DROP TABLE #UniqueEncounterToRIDList
	DROP TABLE #UniqueServiceLineDetail
	DROP TABLE #ServiceLineFinancial
	DROP TABLE #Encounter_RawEOBXml
	DROP TABLE #ServiceLine_RawEOBXml
	DROP TABLE #ASN
	DROP TABLE #ASN_MinClaimASNID
	DROP TABLE #BLL
	DROP TABLE #CTs
	DROP TABLE #LastCTIDs
	DROP TABLE #ASNBalances
	DROP TABLE #Results
	DROP TABLE #Result_MinClaimRID
	DROP TABLE #RunningTotals
	DROP TABLE #ClaimPayers

	DROP TABLE #ProcedureCodeDictionary
	DROP TABLE #Trace2100LoopsWithCAS
	DROP TABLE #Trace2110LoopsWithoutSVC
	DROP TABLE #Trace2100LoopsWithout2110
END


