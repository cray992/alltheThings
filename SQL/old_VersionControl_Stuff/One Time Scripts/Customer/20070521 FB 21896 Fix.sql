IF EXISTS (
	SELECT	*
	FROM	sys.objects
	WHERE	Name = 'PaymentDataProvider_SavePayment'
	AND	TYPE = 'P'
)
	DROP PROCEDURE PaymentDataProvider_SavePayment
GO

CREATE PROCEDURE PaymentDataProvider_SavePayment
@PaymentXML XML, @NodeListXML XML, @UserID INT, @BusinessRuleLog VARBINARY(MAX) = null,
@overrideClosingDate BIT = 0

AS


BEGIN

	CREATE TABLE #PaymentXML(PaymentXML XML)
	INSERT INTO #PaymentXML(PaymentXML)
	VALUES(@PaymentXML)

	DECLARE @PracticeID INT
	DECLARE @PaymentID INT
	DECLARE @PayerTypeCode CHAR(1)
	DECLARE @OtherPayerName VARCHAR(250)
	DECLARE @PaymentSnippet XML
	DECLARE @DraftModePaymentID INT	-- Stores the payment id if this needs to be reopened in draft mode
	DECLARE @ReopenMaxTran table( RID INT, ClaimTransactionID INT)

	--Define Temp Tables
	CREATE TABLE #Payment (PaymentID INT, PracticeID INT, PostingDate DATETIME, PaymentAmount MONEY, PaymentMethodCode CHAR(1),
	PayerTypeCode CHAR(1), PayerID INT, PATIENTPayerID INT, INSURANCEPayerID INT, OTHERPayerID INT, PaymentNumber VARCHAR(30), Description VARCHAR(250), AppliedPaymentAMount MONEY,
	RefundsTotalAmount MONEY, CapitatedTotalAmount MONEY, BatchID VARCHAR(50), PaymentAppliedToCharges MONEY,
	PaymentRelatedAdjustments MONEY, TotalUnappliedAmount MONEY, DefaultAdjustmentCode VARCHAR(10), OTHERPAYERName VARCHAR(250),
	AdjudicationDate DATETIME, ClearinghouseResponseID INT, ERAErrors XML, AppointmentID INT, AppointmentStartDate DateTime,
	PaymentCategoryID INT)

	CREATE TABLE #Patients(PatientID INT, PaymentParticipatingAmount MONEY, Operation CHAR(1), IsModified BIT, IsNew BIT, IsDeleted BIT, AlreadyExists BIT)

	CREATE TABLE #Encounters(PatientID INT, EncounterID INT, EOBXml XML, PaymentRawEOBID INT,
							 Operation CHAR(1), IsModified BIT, IsNew BIT, IsDeleted BIT, AlreadyExists BIT)

	CREATE TABLE #PayClaims(PaymentClaimID INT, PaymentID INT, PracticeID INT, PatientID INT, EncounterID INT,
							ClaimID INT, EOBXml XML, PaymentRawEOBID INT, Notes VARCHAR(MAX), Operation CHAR(1), 
							IsModified BIT, IsNew BIT, IsDeleted BIT, HasError BIT, ErrorMsg VARCHAR(500))

	CREATE TABLE #ClaimTrans(RID INT, ClaimID INT, ClaimTransactionID INT, ClaimTransactionTypeCode CHAR(3),
						     Amount MONEY, Notes VARCHAR(MAX), Operation CHAR(1), InsPlanID INT, 
							 AdjustmentCode VARCHAR(50), Reversible BIT, IsModified BIT, IsNew BIT, IsDeleted BIT, PostingDate DATETIME, Code varchar(50) )

	CREATE TABLE #LastTrans(ClaimID INT, ClaimTransactionID INT)

	DECLARE @nodelistdoc INT

	EXEC sp_xml_preparedocument @nodelistdoc OUTPUT, @NodeListXML

	CREATE TABLE #NodeList(ElementName VARCHAR(128), ID VARCHAR(15))
	INSERT INTO #NodeList(ElementName, ID)
	SELECT ElementName, ID
	FROM OPENXML (@nodelistdoc,'//elementitem',1)
	WITH (ElementName VARCHAR(128) '@name',
		  ID VARCHAR(15) '@id')

	EXEC sp_xml_removedocument @nodelistdoc

	--Get NodeList Definitions
	DECLARE @E_PAYMENTDETAIL VARCHAR(15)
	DECLARE @E_PAYMENT VARCHAR(15)
	DECLARE @E_PATIENTS VARCHAR(15)
	DECLARE @E_ENCOUNTERS VARCHAR(15)
	DECLARE @E_PAYMENTCLAIMS VARCHAR(15)
	DECLARE @E_CLAIMTRANSACTIONS VARCHAR(15)
	DECLARE @E_LASTCLAIMTRANSACTIONIDS VARCHAR(15)
	DECLARE @E_PaymentID VARCHAR(15)
	DECLARE @E_PracticeID VARCHAR(15)
	DECLARE @E_PostingDate VARCHAR(15)
	DECLARE @E_PaymentAmount VARCHAR(15)
	DECLARE @E_PaymentMethodCode VARCHAR(15)
	DECLARE @E_PayerTypeCode VARCHAR(15)
	DECLARE @E_PATIENTPayerID VARCHAR(15)
	DECLARE @E_INSURANCEPayerID VARCHAR(15)
	DECLARE @E_OTHERPayerID VARCHAR(15)
	DECLARE @E_PaymentNumber VARCHAR(15)
	DECLARE @E_Description VARCHAR(15)
	DECLARE @E_AppliedPaymentAmount VARCHAR(15)
	DECLARE @E_RefundsTotalAmount VARCHAR(15)
	DECLARE @E_CapitatedTotalAmount VARCHAR(15)
	DECLARE @E_BatchID VARCHAR(15)
	DECLARE @E_PaymentAppliedToCharges VARCHAR(15)
	DECLARE @E_PaymentRelatedAdjustments VARCHAR(15)
	DECLARE @E_TotalUnappliedAmount VARCHAR(15)
	DECLARE @E_DefaultAdjustmentCode VARCHAR(15)
	DECLARE @E_OTHERPAYERName VARCHAR(15)
	DECLARE @E_AdjudicationDate VARCHAR(15)
	DECLARE @E_ClearinghouseResponseID VARCHAR(15)
	DECLARE @E_ERAErrors VARCHAR(15)
	DECLARE @E_AppointmentID VARCHAR(15)
	DECLARE @E_AppointmentStartDate VARCHAR(15)
	DECLARE @E_PatientID VARCHAR(15)
	DECLARE @E_PaymentParticipatingAmount VARCHAR(15)
	DECLARE @E_IsModified VARCHAR(15)
	DECLARE @E_IsNew VARCHAR(15)
	DECLARE @E_IsDeleted VARCHAR(15)
	DECLARE @E_EncounterID VARCHAR(15)
	DECLARE @E_EOBXml VARCHAR(15)
	DECLARE @E_PaymentRawEOBID VARCHAR(15)
	DECLARE @E_PaymentClaimID VARCHAR(15)
	DECLARE @E_ClaimID VARCHAR(15)
	DECLARE @E_Notes VARCHAR(15)
	DECLARE @E_HasError VARCHAR(15)
	DECLARE @E_ErrorMsg VARCHAR(15)
	DECLARE @E_RID VARCHAR(15)
	DECLARE @E_ClaimTransactionID VARCHAR(15)
	DECLARE @E_ClaimTransactionTypeCode VARCHAR(15)
	DECLARE @E_Amount VARCHAR(15)
	DECLARE @E_InsPlanID VARCHAR(15)
	DECLARE @E_AdjustmentCode VARCHAR(15)
	DECLARE @E_Reversible VARCHAR(15)
	DECLARE @E_PaymentCategoryID VARCHAR(15)
	DECLARE @E_Code VARCHAR(15)

	--Update element node placeholder codes
	SELECT @E_PAYMENTDETAIL=ID FROM #NodeList WHERE ElementName='PAYMENTDETAIL'
	SELECT @E_PAYMENT=ID FROM #NodeList WHERE ElementName='PAYMENT'
	SELECT @E_PATIENTS=ID FROM #NodeList WHERE ElementName='PATIENTS'
	SELECT @E_ENCOUNTERS=ID FROM #NodeList WHERE ElementName='ENCOUNTERS'
	SELECT @E_PAYMENTCLAIMS=ID FROM #NodeList WHERE ElementName='PAYMENTCLAIMS'
	SELECT @E_CLAIMTRANSACTIONS=ID FROM #NodeList WHERE ElementName='CLAIMTRANSACTIONS'
	SELECT @E_LASTCLAIMTRANSACTIONIDS=ID FROM #NodeList WHERE ElementName='LASTCLAIMTRANSACTIONIDS'
	SELECT @E_PaymentID=ID FROM #NodeList WHERE ElementName='PaymentID'
	SELECT @E_PracticeID=ID FROM #NodeList WHERE ElementName='PracticeID'
	SELECT @E_PostingDate=ID FROM #NodeList WHERE ElementName='PostingDate'
	SELECT @E_PaymentAmount=ID FROM #NodeList WHERE ElementName='PaymentAmount'
	SELECT @E_PaymentMethodCode=ID FROM #NodeList WHERE ElementName='PaymentMethodCode'
	SELECT @E_PayerTypeCode=ID FROM #NodeList WHERE ElementName='PayerTypeCode'
	SELECT @E_PATIENTPayerID=ID FROM #NodeList WHERE ElementName='PATIENTPayerID'
	SELECT @E_INSURANCEPayerID=ID FROM #NodeList WHERE ElementName='INSURANCEPayerID'
	SELECT @E_OTHERPayerID=ID FROM #NodeList WHERE ElementName='OTHERPayerID'
	SELECT @E_PaymentNumber=ID FROM #NodeList WHERE ElementName='PaymentNumber'
	SELECT @E_Description=ID FROM #NodeList WHERE ElementName='Description'
	SELECT @E_AppliedPaymentAmount=ID FROM #NodeList WHERE ElementName='AppliedPaymentAmount'
	SELECT @E_RefundsTotalAmount=ID FROM #NodeList WHERE ElementName='RefundsTotalAmount'
	SELECT @E_CapitatedTotalAmount=ID FROM #NodeList WHERE ElementName='CapitatedTotalAmount'
	SELECT @E_BatchID=ID FROM #NodeList WHERE ElementName='BatchID'
	SELECT @E_PaymentAppliedToCharges=ID FROM #NodeList WHERE ElementName='PaymentAppliedToCharges'
	SELECT @E_PaymentRelatedAdjustments=ID FROM #NodeList WHERE ElementName='PaymentRelatedAdjustments'
	SELECT @E_TotalUnappliedAmount=ID FROM #NodeList WHERE ElementName='TotalUnappliedAmount'
	SELECT @E_DefaultAdjustmentCode=ID FROM #NodeList WHERE ElementName='DefaultAdjustmentCode'
	SELECT @E_OTHERPAYERName=ID FROM #NodeList WHERE ElementName='OTHERPAYERName'
	SELECT @E_AdjudicationDate=ID FROM #NodeList WHERE ElementName='AdjudicationDate'
	SELECT @E_ClearinghouseResponseID=ID FROM #NodeList WHERE ElementName='ClearinghouseResponseID'
	SELECT @E_ERAErrors=ID FROM #NodeList WHERE ElementName='ERAErrors'
	SELECT @E_AppointmentID=ID FROM #NodeList WHERE ElementName='AppointmentID'
	SELECT @E_AppointmentStartDate=ID FROM #NodeList WHERE ElementName='AppointmentStartDate'
	SELECT @E_PatientID=ID FROM #NodeList WHERE ElementName='PatientID'
	SELECT @E_PaymentParticipatingAmount=ID FROM #NodeList WHERE ElementName='PaymentParticipatingAmount'
	SELECT @E_IsModified=ID FROM #NodeList WHERE ElementName='IsModified'
	SELECT @E_IsNew=ID FROM #NodeList WHERE ElementName='IsNew'
	SELECT @E_IsDeleted=ID FROM #NodeList WHERE ElementName='IsDeleted'
	SELECT @E_EncounterID=ID FROM #NodeList WHERE ElementName='EncounterID'
	SELECT @E_EOBXml=ID FROM #NodeList WHERE ElementName='EOBXml'
	SELECT @E_PaymentRawEOBID=ID FROM #NodeList WHERE ElementName='PaymentRawEOBID'
	SELECT @E_PaymentClaimID=ID FROM #NodeList WHERE ElementName='PaymentClaimID'
	SELECT @E_ClaimID=ID FROM #NodeList WHERE ElementName='ClaimID'
	SELECT @E_Notes=ID FROM #NodeList WHERE ElementName='Notes'
	SELECT @E_HasError=ID FROM #NodeList WHERE ElementName='HasError'
	SELECT @E_ErrorMsg=ID FROM #NodeList WHERE ElementName='ErrorMsg'
	SELECT @E_RID=ID FROM #NodeList WHERE ElementName='RID'
	SELECT @E_ClaimTransactionID=ID FROM #NodeList WHERE ElementName='ClaimTransactionID'
	SELECT @E_ClaimTransactionTypeCode=ID FROM #NodeList WHERE ElementName='ClaimTransactionTypeCode'
	SELECT @E_Amount=ID FROM #NodeList WHERE ElementName='Amount'
	SELECT @E_InsPlanID=ID FROM #NodeList WHERE ElementName='InsPlanID'
	SELECT @E_AdjustmentCode=ID FROM #NodeList WHERE ElementName='AdjustmentCode'
	SELECT @E_Reversible=ID FROM #NodeList WHERE ElementName='Reversible'
	SELECT @E_PaymentCategoryID = ID FROM #NodeList WHERE ElementName='PaymentCategoryID'
	SELECT @E_Code = ID FROM #NodeList WHERE ElementName='Code'

	--Guard against null values - append variable name if null placeholder cod
	SELECT @E_PaymentID=ISNULL(@E_PaymentID,'E_PaymentID'), @E_PracticeID=ISNULL(@E_PracticeID,'E_PracticeID'),
	@E_PostingDate=ISNULL(@E_PostingDate,'E_PostingDate'), @E_PaymentAmount=ISNULL(@E_PaymentAmount,'E_PaymentAmount'),
	@E_PaymentMethodCode=ISNULL(@E_PaymentMethodCode,'E_PaymentMethodCode'), @E_PayerTypeCode=ISNULL(@E_PayerTypeCode,'E_PayerTypeCode'),
	@E_PATIENTPayerID=ISNULL(@E_PATIENTPayerID,'E_PATIENTPayerID'), @E_INSURANCEPayerID=ISNULL(@E_INSURANCEPayerID,'E_INSURANCEPayerID'),
	@E_OTHERPayerID=ISNULL(@E_OTHERPayerID,'E_OTHERPayerID'), @E_PaymentNumber=ISNULL(@E_PaymentNumber,'E_PaymentNumber'),
	@E_Description=ISNULL(@E_Description,'E_Description'), @E_AppliedPaymentAmount=ISNULL(@E_AppliedPaymentAmount,'E_AppliedPaymentAmount'),
	@E_RefundsTotalAmount=ISNULL(@E_RefundsTotalAmount,'E_RefundsTotalAmount'), @E_CapitatedTotalAmount=ISNULL(@E_CapitatedTotalAmount,'E_CapitatedTotalAmount'),
	@E_BatchID=ISNULL(@E_BatchID,'E_BatchID'), @E_PaymentAppliedToCharges=ISNULL(@E_PaymentAppliedToCharges,'E_PaymentAppliedToCharges'),
	@E_PaymentRelatedAdjustments=ISNULL(@E_PaymentRelatedAdjustments,'E_PaymentRelatedAdjustments'), @E_TotalUnappliedAmount=ISNULL(@E_TotalUnappliedAmount,'E_TotalUnappliedAmount'),
	@E_DefaultAdjustmentCode=ISNULL(@E_DefaultAdjustmentCode,'E_DefaultAdjustmentCode'), @E_OTHERPAYERName=ISNULL(@E_OTHERPAYERName,'E_OTHERPAYERName'),
	@E_AdjudicationDate=ISNULL(@E_AdjudicationDate,'E_AdjudicationDate'), @E_ClearinghouseResponseID=ISNULL(@E_ClearinghouseResponseID,'E_ClearinghouseResponseID'),
	@E_ERAErrors=ISNULL(@E_ERAErrors,'E_ERAErrors'),
	@E_AppointmentID=ISNULL(@E_AppointmentID,'E_AppointmentID'), @E_AppointmentStartDate=ISNULL(@E_AppointmentStartDate,'E_AppointmentStartDate'),
	@E_PatientID=ISNULL(@E_PatientID,'E_PatientID'), @E_PaymentParticipatingAmount=ISNULL(@E_PaymentParticipatingAmount,'E_PaymentParticipatingAmount'),
	@E_IsModified=ISNULL(@E_IsModified,'E_IsModified'), @E_IsNew=ISNULL(@E_IsNew,'E_IsNew'),
	@E_IsDeleted=ISNULL(@E_IsDeleted,'E_IsDeleted'), @E_EncounterID=ISNULL(@E_EncounterID,'E_EncounterID'),
	@E_EOBXml=ISNULL(@E_EOBXml,'E_EOBXml'), @E_PaymentRawEOBID=ISNULL(@E_PaymentRawEOBID,'E_PaymentRawEOBID'), 
	@E_PaymentClaimID=ISNULL(@E_PaymentClaimID,'E_PaymentClaimID'), @E_ClaimID=ISNULL(@E_ClaimID,'E_ClaimID'),
	@E_Notes=ISNULL(@E_Notes,'E_Notes'), @E_HasError=ISNULL(@E_HasError,'E_HasError'),
	@E_ErrorMsg=ISNULL(@E_ErrorMsg,'E_ErrorMsg'), @E_RID=ISNULL(@E_RID,'E_RID'),
	@E_ClaimTransactionID=ISNULL(@E_ClaimTransactionID,'E_ClaimTransactionID'), @E_ClaimTransactionTypeCode=ISNULL(@E_ClaimTransactionTypeCode,'E_ClaimTransactionTypeCode'),
	@E_Amount=ISNULL(@E_Amount,'E_Amount'), @E_InsPlanID=ISNULL(@E_InsPlanID,'E_InsPlanID'),
	@E_AdjustmentCode=ISNULL(@E_AdjustmentCode,'E_AdjustmentCode'), @E_Reversible=ISNULL(@E_Reversible,'E_Reversible'),
	@E_PaymentCategoryID=ISNULL(@E_PaymentCategoryID, 'E_PaymentCategoryID')

	DECLARE @SQL VARCHAR(MAX)
	SET @SQL='
	DECLARE @DynamicPaymentXML XML
	DECLARE @xdoc INT

	SELECT @DynamicPaymentXML=PaymentXML FROM #PaymentXML 

	EXEC sp_xml_preparedocument @xdoc OUTPUT, @DynamicPaymentXML

	INSERT INTO #Payment(PaymentID, PracticeID, PostingDate, PaymentAmount, PaymentMethodCode, PayerTypeCode, PayerID, PATIENTPayerID, 
				    INSURANCEPayerID, OTHERPayerID, PaymentNumber,
					Description, AppliedPaymentAmount, RefundsTotalAmount, CapitatedTotalAmount, BatchID, PaymentAppliedToCharges,
					PaymentRelatedAdjustments, TotalUnappliedAmount, DefaultAdjustmentCode, OTHERPAYERName, AdjudicationDate,
					ClearinghouseResponseID, AppointmentID, ERAErrors, AppointmentStartDate, PaymentCategoryID)
	SELECT PaymentID, PracticeID, 
		   CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(CAST(LEFT(PostingDate,10)+'' ''+SUBSTRING(PostingDate,CHARINDEX(''T'',PostingDate)+1,8) AS DATETIME)) AS DATETIME),110) AS DATETIME), 
		   PaymentAmount, PaymentMethodCode, PayerTypeCode, 
		   CASE WHEN PATIENTPayerID<>0 THEN PATIENTPayerID
				WHEN INSURANCEPayerID<>0 THEN INSURANCEPayerID
				WHEN OTHERPayerID<>0 THEN OTHERPayerID END PayerID, PATIENTPayerID, INSURANCEPayerID, OTHERPayerID, PaymentNumber,
		   Description, AppliedPaymentAmount, RefundsTotalAmount, CapitatedTotalAmount, BatchID, PaymentAppliedToCharges,
		   PaymentRelatedAdjustments, TotalUnappliedAmount, DefaultAdjustmentCode, OTHERPAYERName, 
		   CAST(LEFT(AdjudicationDate,10) AS DATETIME), ClearinghouseResponseID, AppointmentID, 
		   CAST(REPLACE(ERAErrors,''"utf-16"'',''"utf-8"'') AS XML) ERAErrors,
		   CAST(LEFT(AppointmentStartDate,10) AS DATETIME),
		   PaymentCategoryID
	FROM OPENXML (@xdoc, ''/'+@E_PAYMENTDETAIL+'/'+@E_PAYMENT+''', 2)
	WITH (PaymentID INT '''+@E_PaymentID+''',
		  PracticeID INT '''+@E_PracticeID+''',
		  PostingDate VARCHAR(25) '''+@E_PostingDate+''',
		  PaymentAmount MONEY '''+@E_PaymentAmount+''',
		  PaymentMethodCode CHAR(1) '''+@E_PaymentMethodCode+''',
		  PayerTypeCode CHAR(1) '''+@E_PayerTypeCode+''',
		  PATIENTPayerID INT '''+@E_PATIENTPayerID+''',
		  INSURANCEPayerID INT '''+@E_INSURANCEPayerID+''',
		  OTHERPayerID INT '''+@E_OTHERPayerID+''',
		  PaymentNumber VARCHAR(30) '''+@E_PaymentNumber+''',
		  Description VARCHAR(250) '''+@E_Description+''',
		  AppliedPaymentAmount MONEY '''+@E_AppliedPaymentAmount+''',
		  RefundsTotalAmount MONEY '''+@E_RefundsTotalAmount+''',
		  CapitatedTotalAmount MONEY '''+@E_CapitatedTotalAmount+''',
		  BatchID VARCHAR(50) '''+@E_BatchID+''',
		  PaymentAppliedToCharges MONEY '''+@E_PaymentAppliedToCharges+''',
		  PaymentRelatedAdjustments MONEY '''+@E_PaymentRelatedAdjustments+''',
		  TotalUnappliedAmount MONEY '''+@E_TotalUnappliedAmount+''',
		  DefaultAdjustmentCode VARCHAR(10) '''+@E_DefaultAdjustmentCode+''',
		  OTHERPAYERName VARCHAR(250) '''+@E_OTHERPAYERName+''',
		  AdjudicationDate VARCHAR(25) '''+@E_AdjudicationDate+''',
		  ClearinghouseResponseID INT '''+@E_ClearinghouseResponseID+''',
		  ERAErrors VARCHAR(MAX) '''+@E_ERAErrors+''',
		  AppointmentID INT '''+@E_AppointmentID+''',
		  AppointmentStartDate VARCHAR(25) '''+@E_AppointmentStartDate+''',
		  PaymentCategoryID INT '''+@E_PaymentCategoryID+''')

	INSERT INTO #Patients(PatientID, PaymentParticipatingAmount, IsModified, IsNew, IsDeleted, AlreadyExists)
	SELECT PatientID, PaymentParticipatingAmount, IsModified, IsNew, IsDeleted, 0
	FROM OPENXML (@xdoc, ''//'+@E_PATIENTS+''', 2)
	WITH (PatientID INT '''+@E_PatientID+''',
		  PaymentParticipatingAmount MONEY '''+@E_PaymentParticipatingAmount+''',
		  IsModified BIT '''+@E_IsModified+''',
		  IsNew BIT '''+@E_IsNew+''',
		  IsDeleted BIT '''+@E_IsDeleted+''')

	INSERT INTO #Encounters(PatientID, EncounterID, EOBXml, PaymentRawEOBID, IsModified, IsNew, IsDeleted, AlreadyExists)
	SELECT PatientID, EncounterID, CAST(REPLACE(EOBXml,''"utf-16"'',''"utf-8"'') AS XML), PaymentRawEOBID,
		   IsModified, IsNew, IsDeleted, 0
	FROM OPENXML (@xdoc, ''//'+@E_ENCOUNTERS+''',2)
	WITH (PatientID INT '''+@E_PatientID+''',
		  EncounterID INT '''+@E_EncounterID+''',
		  EOBXml VARCHAR(MAX) '''+@E_EOBXml+''',
		  PaymentRawEOBID INT '''+@E_PaymentRawEOBID+''',
		  IsModified BIT '''+@E_IsModified+''',
		  IsNew BIT '''+@E_IsNew+''',
		  IsDeleted BIT '''+@E_IsDeleted+''')

	INSERT INTO #PayClaims(PaymentClaimID, PaymentID, PracticeID, PatientID, EncounterID, ClaimID, EOBXml, PaymentRawEOBID, Notes,
					  HasError, ErrorMsg, IsModified, IsNew, IsDeleted)
	SELECT PaymentClaimID, PaymentID, PracticeID, PatientID, EncounterID, ClaimID, CAST(REPLACE(EOBXml,''"utf-16"'',''"utf-8"'') AS XML),
		   PaymentRawEOBID, Notes, HasError, ErrorMsg, IsModified, IsNew, IsDeleted
	FROM OPENXML (@xdoc, ''//'+@E_PAYMENTCLAIMS+''', 2)
	WITH (PaymentClaimID INT '''+@E_PaymentClaimID+''',
		  PaymentID INT '''+@E_PaymentID+''',
		  PracticeID INT '''+@E_PracticeID+''',
		  PatientID INT '''+@E_PatientID+''',
		  EncounterID INT '''+@E_EncounterID+''',
		  ClaimID INT '''+@E_ClaimID+''',
		  EOBXml VARCHAR(MAX) '''+@E_EOBXml+''',
		  PaymentRawEOBID INT '''+@E_PaymentRawEOBID+''',
		  Notes VARCHAR(MAX) '''+@E_Notes+''',
		  HasError BIT '''+@E_HasError+''',
		  ErrorMsg VARCHAR(500) '''+@E_ErrorMsg+''',
		  IsModified BIT '''+@E_IsModified+''',
		  IsNew BIT '''+@E_IsNew+''',
		  IsDeleted BIT '''+@E_IsDeleted+''')

	INSERT INTO #ClaimTrans(RID, ClaimID, ClaimTransactionID, ClaimTransactionTypeCode, 
					        Amount, Notes, InsPlanID, AdjustmentCode, Reversible, IsModified, IsNew, IsDeleted, PostingDate, Code)
	SELECT RID, ClaimID, ClaimTransactionID, ClaimTransactionTypeCode, 
		   Amount, Notes, InsPlanID, CASE WHEN LTRIM(RTRIM(AdjustmentCode))='''' THEN ''0'' ELSE LTRIM(RTRIM(AdjustmentCode)) END, Reversible, IsModified, IsNew, IsDeleted, 
			PostingDate = CASE when ClaimTransactionTypeCode in (''ASN'', ''BLL'', ''RAS'')
							THEN CONVERT( VARCHAR, GETDATE(), 101)
							ELSE CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(CAST(LEFT(PostingDate,10)+'' ''+SUBSTRING(PostingDate,CHARINDEX(''T'',PostingDate)+1,8) AS DATETIME)) AS DATETIME),110) AS DATETIME)
							END,
			Code
	FROM OPENXML(@xdoc,''//'+@E_CLAIMTRANSACTIONS+''',2)
	WITH (RID INT '''+@E_RID+''',
		  ClaimID INT '''+@E_ClaimID+''',
		  ClaimTransactionID INT '''+@E_ClaimTransactionID+''',
		  ClaimTransactionTypeCode CHAR(3) '''+@E_ClaimTransactionTypeCode+''',
		  Amount MONEY '''+@E_Amount+''',
		  Notes VARCHAR(MAX) '''+@E_Notes+''',
		  InsPlanID INT '''+@E_InsPlanID+''',
		  AdjustmentCode VARCHAR(50) '''+@E_AdjustmentCode+''',
		  Reversible BIT '''+@E_Reversible+''',
		  IsModified BIT '''+@E_IsModified+''',
		  IsNew BIT '''+@E_IsNew+''',
		  IsDeleted BIT '''+@E_IsDeleted+''',
		  PostingDate VARCHAR(25) ''' +  @E_PostingDate + ''',
		  Code VARCHAR(50) ''' +  @E_Code + '''
		  )

	INSERT INTO #LastTrans(ClaimID, ClaimTransactionID)
	SELECT ClaimID, ClaimTransactionID
	FROM OPENXML (@xdoc,''//'+@E_LASTCLAIMTRANSACTIONIDS+''',2)
	WITH (ClaimID INT '''+@E_ClaimID+''',
		  ClaimTransactionID INT '''+@E_ClaimTransactionID+''')

	EXEC sp_xml_removedocument @xdoc		  '

	EXEC (@SQL)

	SELECT @PracticeID=PracticeID, @PaymentID=PaymentID, @PayerTypeCode=PayerTypeCode, @OtherPayerName=OTHERPAYERName
	FROM #Payment




	--Update Operation Flag on each table
	UPDATE #Patients SET Operation=CASE WHEN IsNew=1 THEN 'A'
										WHEN IsModified=1 THEN 'M'										
										WHEN IsDeleted=1 THEN 'D'
								   ELSE 'U' END

	UPDATE #Encounters SET Operation=CASE WHEN IsNew=1 THEN 'A'
										WHEN IsModified=1 THEN 'M'										
										WHEN IsDeleted=1 THEN 'D'
								   ELSE 'U' END

	UPDATE #PayClaims SET Operation=CASE WHEN IsNew=1 THEN 'A'
										WHEN IsModified=1 THEN 'M'										
										WHEN IsDeleted=1 THEN 'D'
								   ELSE 'U' END

	UPDATE #ClaimTrans SET Operation=CASE WHEN IsNew=1 THEN 'A'
										WHEN IsModified=1 THEN 'M'										
										WHEN IsDeleted=1 THEN 'D'
								   ELSE 'U' END

	CREATE TABLE #ClaimsChanged(ClaimID INT)
	INSERT INTO #ClaimsChanged(ClaimID)
	SELECT ClaimID
	FROM #PayClaims
	WHERE Operation<>'U'
	UNION
	SELECT ClaimID
	FROM #ClaimTrans
	WHERE Operation<>'U'

	--Check For VoidedClaims
	DECLARE @VoidClaims TABLE(ClaimID INT)
	INSERT @VoidClaims(ClaimID)
	SELECT CC.ClaimID
	FROM #ClaimsChanged CC INNER JOIN VoidedClaims VC
	ON CC.ClaimID=VC.ClaimID

	--IF Voided Claims exist remove appropriate records from process to prevent insertion
	--at necessary points in a claims payment structure
	
	IF EXISTS(SELECT * FROM @VoidClaims)
	BEGIN
		--Determine Encounters affected
		DECLARE @Void_Encounters TABLE(EncounterID INT, Voids INT)
		INSERT @Void_Encounters(EncounterID, Voids)
		SELECT EncounterID, COUNT(*) Voids
		FROM #PayClaims PC INNER JOIN @VoidClaims VC
		ON PC.ClaimID=VC.ClaimID
		GROUP BY EncounterID

		--Determine if Encounters Service lines count is equal to # of voids
		--if it is then prevent EncounterPayment record from being created
		DECLARE @EncountersToRemove TABLE(EncounterID INT)
		INSERT @EncountersToRemove(EncounterID)
		SELECT EP.EncounterID
		FROM @Void_Encounters VE INNER JOIN EncounterProcedure EP
		ON VE.EncounterID=EP.EncounterID
		GROUP BY EP.EncounterID
		HAVING COUNT(EncounterProcedureID)=MIN(VE.Voids)

		--Determine Patient records affected, if all Patients encounter records in payment voided, prevent paymentpatient
		--record from being inserted
		DECLARE @Void_Patients TABLE(PatientID INT, Voids INT)
		INSERT @Void_Patients(PatientID, Voids)
		SELECT E.PatientID, COUNT(*) Voids
		FROM @EncountersToRemove ETR INNER JOIN #Encounters E
		ON ETR.EncounterID=E.EncounterID
		GROUP BY E.PatientID
		
		DECLARE @PatientsToRemove TABLE(PatientID INT)
		INSERT @PatientsToRemove(PatientID)
		SELECT E.PatientID
		FROM @Void_Patients VP INNER JOIN #Encounters E
		ON VP.PatientID=E.PatientID
		GROUP BY E.PatientID
		HAVING COUNT(E.EncounterID)=MIN(VP.Voids)

		--Begin Clean Up for voided claims
		DELETE CC
		FROM @VoidClaims VC INNER JOIN #ClaimsChanged CC
		ON VC.ClaimID=CC.ClaimID
		
		DELETE CT
		FROM @VoidClaims VC INNER JOIN #ClaimTrans CT
		ON VC.ClaimID=CT.ClaimID
		
		DELETE PC
		FROM @VoidClaims VC INNER JOIN #PayClaims PC
		ON VC.ClaimID=PC.ClaimID

		--IF this is a new payment prevent appropriate PaymentEncounter and PaymentPatient record generation
		IF @PaymentID=0
		BEGIN
			DELETE E
			FROM @EncountersToRemove ETR INNER JOIN #Encounters E
			ON ETR.EncounterID=E.EncounterID

			DELETE P
			FROM @PatientsToRemove PTR INNER JOIN #Patients P
			ON PTR.PatientID=P.PatientID
		END

	END	

	CREATE TABLE #ValidationExceptions(ClaimID INT)
	INSERT INTO #ValidationExceptions(ClaimID)
	SELECT DISTINCT CT.ClaimID
	FROM ClaimTransaction CT INNER JOIN #LastTrans LT
	ON CT.ClaimID=LT.ClaimID AND CT.ClaimTransactionID>LT.ClaimTransactionID
	INNER JOIN #ClaimsChanged CC
	ON LT.ClaimID=CC.ClaimID
	WHERE CT.PracticeID=@PracticeID AND CT.ClaimTransactionTypeCode NOT IN ('MEM','BLL','RAS','EDI')

	--Calculate MAX of First BLL and or ASN if BLL not present
	CREATE TABLE #ClaimPayers(ClaimID INT, InsurancePolicyID INT)
	INSERT INTO #ClaimPayers(ClaimID, InsurancePolicyID)
	SELECT ClaimID, EOBXml.value('(/eob/insurancePolicyID)[1]','INT') InsurancePolicyID
	FROM #PayClaims

	--Insert first BLL date for existing PayClaim records
	IF @PaymentID<>0
	BEGIN
		INSERT INTO #ClaimPayers(ClaimID, InsurancePolicyID)
		SELECT ClaimID, EOBXml.value('(/eob/insurancePolicyID)[1]','INT') InsurancePolicyID
		FROM PaymentClaim
		WHERE PaymentID=@PaymentID AND PracticeID=@PracticeID
	END
 
	CREATE TABLE #Claim_Dates(ClaimID INT, PostingDate DATETIME)

	--Insert first BLL date
	INSERT INTO #Claim_Dates(ClaimID, PostingDate)
	SELECT CAB.ClaimID, MIN(CAB.PostingDate) PostingDate
	FROM #ClaimPayers CP INNER JOIN ClaimAccounting_Assignments CAA
	ON CAA.PracticeID=@PracticeID AND CP.ClaimID=CAA.ClaimID AND CP.InsurancePolicyID=CAA.InsurancePolicyID
	INNER JOIN ClaimAccounting_Billings CAB
	ON CAA.PracticeID=CAB.PracticeID AND CAA.ClaimID=CAB.ClaimID
	AND (CAB.ClaimTransactionID BETWEEN CAA.ClaimTransactionID AND CAA.EndClaimTransactionID
		 OR CAB.ClaimTransactionID>CAA.ClaimTransactionID AND CAA.EndClaimTransactionID IS NULL)
	GROUP BY CAB.ClaimID

	--Insert first ASN for those claims where a first BLL date was not found
	INSERT INTO #Claim_Dates(ClaimID, PostingDate)
	SELECT CAA.ClaimID, MIN(CAA.PostingDate) PostingDate
	FROM #ClaimPayers CP LEFT JOIN #Claim_Dates CD
	ON CP.ClaimID=CD.ClaimID
	INNER JOIN ClaimAccounting_Assignments CAA
	ON CAA.PracticeID=@PracticeID AND CP.ClaimID=CAA.ClaimID
	WHERE CD.ClaimID IS NULL
	GROUP BY CAA.ClaimID

	DECLARE @PostingDate DATETIME
	DECLARE @PostingDateChanged BIT
	DECLARE @ClosingDate DATETIME

	SELECT @ClosingDate=CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(ClosingDate) AS DATETIME),110) AS DATETIME)
	FROM PracticeToClosingDate
	WHERE PracticeID=@PracticeID AND LastAssignment=1	
	
	SET @PostingDateChanged=0

	--Check for closing date change which would require posting date to be applied after closing
	IF @PaymentID=0
	BEGIN
		UPDATE #Payment SET PostingDate=CASE WHEN @ClosingDate>PostingDate THEN @ClosingDate ELSE PostingDate END	
	END

	IF @PaymentID<>0 AND EXISTS(SELECT P.* 
								FROM Payment P INNER JOIN #Payment TP 
								ON P.PaymentID=TP.PaymentID
								WHERE CAST(CONVERT(CHAR(10),P.PostingDate,110) AS DATETIME)<>
									  CAST(CONVERT(CHAR(10),TP.PostingDate,110) AS DATETIME))
	BEGIN
		SET @PostingDateChanged=1		

		UPDATE #Payment SET PostingDate=CASE WHEN @ClosingDate>PostingDate THEN @ClosingDate ELSE PostingDate END	
	END			

	SELECT @PostingDate=PostingDate FROM #Payment			

	CREATE TABLE #CT_PostingDateToUpdate(ClaimID INT, ClaimTransactionID INT)




	IF @PostingDateChanged=1
	BEGIN	
		INSERT #CT_PostingDateToUpdate(ClaimID,ClaimTransactionID)
		SELECT ClaimID, ClaimTransactionID
		FROM ClaimTransaction
		WHERE PracticeID=@PracticeID AND PaymentID=@PaymentID AND ClaimTransactionTypeCode <> 'ASN' AND PostingDate<>@PostingDate
		      AND (@ClosingDate IS NULL OR PostingDate>@ClosingDate)
		UNION
		SELECT ClaimID, ClaimTransactionID
		FROM ClaimTransaction CT
		WHERE CT.PaymentID=@PaymentID AND CT.PracticeID=@PracticeID AND ClaimTransactionTypeCode='END' AND PostingDate<>@PostingDate AND CT.PaymentID IS NULL
		      AND (@ClosingDate IS NULL OR PostingDate>@ClosingDate)
	END




--	-------------- Removed because Client is figuring out postingDate ------------------------
--	UPDATE CT SET PostingDate=CASE WHEN CD.PostingDate>@PostingDate AND @ClosingDate IS NULL THEN CD.PostingDate
--								   WHEN CD.PostingDate>@PostingDate AND CD.PostingDate <= @ClosingDate THEN @ClosingDate+1
--								   WHEN CD.PostingDate>@PostingDate AND CD.PostingDate>@ClosingDate THEN CD.PostingDate
--								   WHEN CD.PostingDate<@PostingDate AND @PostingDate<@ClosingDate THEN convert(varchar, getdate(), 101)
--								   ELSE @PostingDate END
--	FROM #ClaimTrans CT LEFT JOIN #Claim_Dates CD
--	ON CT.ClaimID=CD.ClaimID

	

	--Get New and or saved PaymentClaim records
	CREATE TABLE #PaymentClaim(PracticeID INT, PaymentID INT, PatientID INT, EncounterID INT, ClaimID INT, Denial BIT)
	INSERT INTO #PaymentClaim(PracticeID, PaymentID, PatientID, EncounterID, ClaimID, Denial)
	SELECT @PracticeID, @PaymentID, PatientID, EncounterID, ClaimID, 
	CASE WHEN EOBXml.value('(eob/denial)[1]','BIT')=1 OR EOBXml.value('(eob/items/denial)[1]','BIT')=1 THEN 1 ELSE 0 END Denial
	FROM #PayClaims

	CREATE TABLE #ClaimChangesPaymentClaims(PracticeID INT, PaymentID INT, PatientID INT, EncounterID INT, ClaimID INT, Denial BIT)
	INSERT INTO #ClaimChangesPaymentClaims(PracticeID, PaymentID, PatientID, EncounterID, ClaimID, Denial)
	SELECT PC.PracticeID, PC.PaymentID, PC.PatientID, PC.EncounterID, PC.ClaimID,
	CASE WHEN PC.EOBXml.value('(eob/denial)[1]','BIT')=1 OR PC.EOBXml.value('(eob/items/denial)[1]','BIT')=1 THEN 1 ELSE 0 END Denial
	FROM #ClaimsChanged CC INNER JOIN PaymentClaim PC
	ON PC.PracticeID=@PracticeID AND PC.PaymentID=@PaymentID AND CC.ClaimID=PC.ClaimID	

	INSERT INTO #PaymentClaim(PracticeID, PaymentID, PatientID, EncounterID, ClaimID, Denial)
	SELECT CCPC.PracticeID, CCPC.PaymentID, CCPC.PatientID, CCPC.EncounterID, CCPC.ClaimID, CCPC.Denial
	FROM #ClaimChangesPaymentClaims CCPC LEFT JOIN #PaymentClaim PC
	ON CCPC.PracticeID=PC.PracticeID AND CCPC.PaymentID=PC.PaymentID AND CCPC.ClaimID=PC.ClaimID	
	WHERE PC.ClaimID IS NULL

	--Check for existing DEN transactions
	CREATE TABLE #ExistingDenialTrans(ClaimID INT, ClaimTransactionID INT, ClaimTransactionTypeCode char(3) )
	INSERT INTO #ExistingDenialTrans(ClaimID, ClaimTransactionID, ClaimTransactionTypeCode)
	SELECT CT.ClaimID, ClaimTransactionID, CT.ClaimTransactionTypeCode
	FROM #PaymentClaim PC INNER JOIN ClaimTransaction CT
	ON PC.PracticeID=CT.PracticeID AND PC.ClaimID=CT.ClaimID AND PC.PaymentID=CT.PaymentID
	WHERE CT.ClaimTransactionTypeCode IN ('DEN', 'PAY')

	--Check for applied payments. This should NOT generate a DEN
	INSERT INTO #ExistingDenialTrans(ClaimID, ClaimTransactionID, ClaimTransactionTypeCode)
	SELECT CT.ClaimID, ct.ClaimTransactionID, ClaimTransactionTypeCode
	FROM #PaymentClaim PC INNER JOIN #ClaimTrans CT
	ON PC.ClaimID=CT.ClaimID
	WHERE CT.ClaimTransactionTypeCode='PAY'

	CREATE TABLE #DenialsToInsert(ClaimID INT, PostingDate DATETIME)
	INSERT INTO #DenialsToInsert(ClaimID)
	SELECT PC.ClaimID
	FROM #PaymentClaim PC LEFT JOIN #ExistingDenialTrans ED
	ON PC.ClaimID=ED.ClaimID
	WHERE PC.Denial=1 AND ED.ClaimID IS NULL

	CREATE TABLE #DenialsToDelete(ClaimTransactionID INT)
	INSERT INTO #DenialsToDelete(ClaimTransactionID)
	SELECT ED.ClaimTransactionID
	FROM #ExistingDenialTrans ED LEFT JOIN #PaymentClaim PC
	ON ED.ClaimID=PC.ClaimID AND ed.ClaimTransactionTypeCode = 'DEN'
	WHERE PC.Denial=0 

	--Associate a PostingDate to Denial Transactions to be inserted
	UPDATE DTI SET PostingDate=CT.PostingDate
	FROM #DenialsToInsert DTI INNER JOIN #ClaimTrans CT
	ON DTI.ClaimID=CT.ClaimID

	--Update PostingDate for those Claims where ClaimTransaction records will not be posted
	UPDATE DTI SET PostingDate=CASE WHEN CD.PostingDate>@PostingDate AND @ClosingDate IS NULL THEN CD.PostingDate
							   WHEN CD.PostingDate>@PostingDate AND CD.PostingDate <= @ClosingDate THEN @ClosingDate+1
							   WHEN CD.PostingDate>@PostingDate AND CD.PostingDate>@ClosingDate THEN CD.PostingDate
							   ELSE @PostingDate END
	FROM #DenialsToInsert DTI INNER JOIN #Claim_Dates CD
	ON DTI.ClaimID=CD.ClaimID
	WHERE DTI.PostingDate IS NULL

	--Get Claim_ProviderID for CT Inserts
	CREATE TABLE #ClaimProviders(ClaimID INT, PatientID INT, Claim_ProviderID INT)
	INSERT INTO #ClaimProviders(ClaimID, PatientID, Claim_ProviderID)
	SELECT PC.ClaimID, PC.PatientID, E.DoctorID Claim_ProviderID
	FROM #PaymentClaim PC 
	INNER JOIN Encounter E
	ON PC.EncounterID=E.EncounterID	

	--Set Up ClaimStatus setting table
	CREATE TABLE #Claim_LastStatusSettingIDs(ClaimID INT, RID INT, ClaimTransactionTypeCode CHAR(3))
	INSERT INTO #Claim_LastStatusSettingIDs(ClaimID, RID)
	SELECT CT.ClaimID, MAX(RID) RID
	FROM #ClaimTrans CT
	WHERE CT.ClaimTransactionTypeCode NOT IN ('ADJ','PAY','MEM','EDI','PRC','RES','CLS','RJT','DEN')
	GROUP BY CT.ClaimID

	UPDATE CLS SET ClaimTransactionTypeCode=CT.ClaimTransactionTypeCode
	FROM #Claim_LastStatusSettingIDs CLS INNER JOIN #ClaimTrans CT
	ON CLS.RID=CT.RID	
	WHERE CT.ClaimTransactionTypeCode <> 'REO'

	-- in the case where the last transaction is a REO, then SET the Status based on last valid transaction
	INSERT @ReopenMaxTran (CLS.RID, ClaimTransactionID)
	SELECT CLS.RID, max(ca.ClaimTransactionID)
	FROM #Claim_LastStatusSettingIDs CLS 
		INNER JOIN #ClaimTrans CT ON CLS.RID=CT.RID
		INNER JOIN ClaimTransaction ca ON ca.PracticeID = @practiceID AND ca.ClaimID = ct.ClaimID
	WHERE CT.ClaimTransactionTypeCode = 'REO'
		AND ca.ClaimTransactionTypeCode NOT IN ('ADJ','PAY','MEM','EDI','PRC','RES','CLS', 'REO', 'END', 'RJT', 'DEN')
	GROUP BY CLS.RID

	UPDATE CLS SET ClaimTransactionTypeCode=ca.ClaimTransactionTypeCode
	FROM #Claim_LastStatusSettingIDs CLS 
		INNER JOIN @ReopenMaxTran CT ON CLS.RID=CT.RID	
		INNER JOIN ClaimTransaction ca ON ca.ClaimTransactionID = ct.ClaimTransactionID


	--Set Up to update PatientResp in EncounterProcedure
	CREATE TABLE #PRCUpdate(ClaimID INT, CopayDelta MONEY)
	INSERT INTO #PRCUpdate(ClaimID, CopayDelta)
	SELECT ClaimID, SUM(Amount) CopayDelta
	FROM #ClaimTrans
	WHERE Operation='A' AND ClaimTransactionTypeCode='PRC'
	GROUP BY ClaimID

	-- Set the Draft Mode Payment ID if we have any validation errors that were marked as draft mode
	SELECT	@DraftModePaymentID = CASE WHEN count(*) > 0 THEN @PaymentID ELSE -1 END
	FROM	#ValidationExceptions

	--Validate PaymentPatient and PaymentEncounter records that are to be added to assure no duplicate
	--insert is attempted
	IF @PaymentID<>0
	BEGIN
		UPDATE P SET AlreadyExists=1
		FROM #Patients P INNER JOIN PaymentPatient PP
		ON @PracticeID=PP.PracticeID AND @PaymentID=PP.PaymentID AND P.PatientID=PP.PatientID

		UPDATE E SET AlreadyExists=1
		FROM #Encounters E INNER JOIN PaymentEncounter PE
		ON @PracticeID=PE.PracticeID AND @PaymentID=PE.PaymentID AND E.EncounterID=PE.EncounterID
	END

	CREATE TABLE #EncountersToDelete(EncounterID INT, PatientID INT)
	INSERT INTO #EncountersToDelete(EncounterID, PatientID)
	SELECT EncounterID, NULL PatientID
	FROM #Encounters
	WHERE Operation='D'
	UNION
	SELECT NULL EncounterID, PatientID
	FROM #Patients
	WHERE Operation='D'

	--Check those claims without related RES for payment
	CREATE TABLE #ClaimsWithRES(ClaimID INT)
	INSERT INTO #ClaimsWithRES(ClaimID)
	SELECT CC.ClaimID
	FROM ClaimTransaction CT INNER JOIN #ClaimsChanged CC
	ON CT.ClaimID=CC.ClaimID
	WHERE PracticeID=@PracticeID AND PaymentID=@PaymentID AND ClaimTransactionTypeCode='RES'

	CREATE TABLE #NoRES(RID INT IDENTITY(1,1), ClaimID INT, PostingDate DATETIME, InsurancePolicyID INT, ReferenceID INT)
	INSERT INTO #NoRES(ClaimID)
	SELECT CC.ClaimID
	FROM #ClaimsChanged CC LEFT JOIN #ClaimsWithRES CLR
	ON CC.ClaimID=CLR.ClaimID
	WHERE CLR.ClaimID IS NULL

	--Update PostingDate for those Claims where ClaimTransaction records are to be inserted
	UPDATE NR SET PostingDate=CT.PostingDate
	FROM #NoRES NR INNER JOIN #ClaimTrans CT
	ON NR.ClaimID=CT.ClaimID

	--Update PostingDate for those Claims where ClaimTransaction records will not be posted
	UPDATE NR SET PostingDate=CASE WHEN CD.PostingDate>@PostingDate AND @ClosingDate IS NULL THEN CD.PostingDate
							   WHEN CD.PostingDate>@PostingDate AND CD.PostingDate <= @ClosingDate THEN @ClosingDate+1
							   WHEN CD.PostingDate>@PostingDate AND CD.PostingDate>@ClosingDate THEN CD.PostingDate
							   ELSE @PostingDate END
	FROM #NoRES NR INNER JOIN #Claim_Dates CD
	ON NR.ClaimID=CD.ClaimID
	WHERE NR.PostingDate IS NULL

	UPDATE NR SET InsurancePolicyID=CP.InsurancePolicyID
	FROM #NoRES NR INNER JOIN #ClaimPayers CP
	ON NR.ClaimID=CP.ClaimID

	CREATE TABLE #RES_References(RID INT, ReferenceID INT)
	INSERT INTO #RES_References(RID, ReferenceID)
	SELECT NR.RID, MAX(CAB.ClaimTransactionID) ReferenceID
	FROM #NoRES NR INNER JOIN ClaimAccounting_Billings CAB
	ON @PracticeID=CAB.PracticeID AND NR.ClaimID=CAB.ClaimID
	INNER JOIN ClaimAccounting_Assignments CAA
	ON CAB.PracticeID=CAA.PracticeID AND CAB.ClaimID=CAA.ClaimID AND NR.InsurancePolicyID=CAA.InsurancePolicyID AND NR.PostingDate>=CAB.PostingDate
	AND ((CAB.ClaimTransactionID>CAA.ClaimTransactionID AND CAB.ClaimTransactionID<CAA.EndClaimTransactionID)
	OR (CAA.EndClaimTransactionID IS NULL AND CAB.ClaimTransactionID>CAA.ClaimTransactionID))
	GROUP BY NR.RID

	INSERT INTO #RES_References(RID, ReferenceID)
	SELECT NR.RID, MAX(CAB.ClaimTransactionID) ReferenceID
	FROM #NoRES NR INNER JOIN ClaimAccounting_Billings CAB
	ON @PracticeID=CAB.PracticeID AND NR.ClaimID=CAB.ClaimID
	INNER JOIN ClaimAccounting_Assignments CAA
	ON CAB.PracticeID=CAA.PracticeID AND CAB.ClaimID=CAA.ClaimID 
	AND @PayerTypeCode=CASE WHEN BatchType<>'S' OR BatchType IS NULL THEN 'I' ELSE 'P' END
	AND NR.PostingDate>=CAB.PostingDate																				
	AND ((CAB.ClaimTransactionID>CAA.ClaimTransactionID AND CAB.ClaimTransactionID<CAA.EndClaimTransactionID)
	OR (CAA.EndClaimTransactionID IS NULL AND CAB.ClaimTransactionID>CAA.ClaimTransactionID))
	LEFT JOIN #RES_References RR
	ON NR.RID=RR.RID
	WHERE RR.RID IS NULL
	GROUP BY NR.RID

	UPDATE NR SET ReferenceID=RR.ReferenceID
	FROM #NoRES NR INNER JOIN #RES_References RR
	ON NR.RID=RR.RID

	CREATE TABLE #MAX_ResponsePostingDate(ReferenceID INT, ResponsePostingDate DATETIME)
	INSERT INTO #MAX_ResponsePostingDate(ReferenceID, ResponsePostingDate)
	SELECT RR.ReferenceID, MAX(NR.PostingDate) PostingDate
	FROM #NoRES NR INNER JOIN #RES_References RR
	ON NR.RID=RR.RID
	GROUP BY RR.ReferenceID

	DROP TABLE #RES_References

	DECLARE @ErrorCode INT
	SET @ErrorCode=0
	DECLARE @ErrorMsg VARCHAR(1000)
	SET @ErrorMsg=''

	BEGIN TRAN

	--Create Other, if other payer.
	DECLARE @other_payer_id INT

	--New Payment
	IF @PaymentID=0
	BEGIN
		IF (@PayerTypeCode = 'O')
		BEGIN
			INSERT	Other (OtherName)
			VALUES	(@OtherPayerName)

			SET @ErrorCode=@@Error

			SET @other_payer_id = SCOPE_IDENTITY()

			IF @ErrorCode<>0
				GOTO ROLLBACK_TRAN
		END

		INSERT INTO Payment(PracticeID, PaymentAmount, PaymentMethodCode, PayerTypeCode, PayerID, PaymentNumber, Description,
							PostingDate, DefaultAdjustmentCode, BatchID, AdjudicationDate, ClearinghouseResponseID, ERAErrors, CreatedUserID, ModifiedUserID,
							 SourceAppointmentID, AppointmentID, AppointmentStartDate, PaymentCategoryID, overrideClosingDate)
		SELECT PracticeID, PaymentAmount, PaymentMethodCode, PayerTypeCode, 
		CASE WHEN PayerTypeCode='O' THEN @other_payer_id ELSE PayerID END PayerID, 
		PaymentNumber, Description, 
		CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(PostingDate) AS DATETIME),110) AS DATETIME) PostingDate,
		CASE WHEN DefaultAdjustmentCode='' THEN NULL ELSE DefaultAdjustmentCode END, BatchID, 
		CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(AdjudicationDate) AS DATETIME),110) AS DATETIME) AdjudicationDate, 
		ClearinghouseResponseID, ERAErrors, @UserID, @UserID, 
		AppointmentID, AppointmentID, AppointmentStartDate, PaymentCategoryID, @overrideClosingDate
		FROM #Payment

		SET @ErrorCode=@@Error

		SET @PaymentID=SCOPE_IDENTITY()

		PRINT 'PAYMENT RECORD ADDED - '+CAST(@PaymentID AS VARCHAR)

		IF @ErrorCode<>0
			GOTO ROLLBACK_TRAN
	END
	ELSE --Update Payment
	BEGIN
		IF (@PayerTypeCode = 'O')
		BEGIN
			IF NOT EXISTS(SELECT * FROM Payment WHERE PayerTypeCode='O' AND PaymentID=@PaymentID)
			BEGIN
				INSERT	Other (OtherName)
				VALUES	(@OtherPayerName)

				SET @ErrorCode=@@Error

				SET @other_payer_id = SCOPE_IDENTITY()

				IF @ErrorCode<>0
					GOTO ROLLBACK_TRAN
			END
			ELSE
			BEGIN
				UPDATE O SET OtherName=@OtherPayerName
				FROM Payment P INNER JOIN Other O
				ON P.PayerID=O.OtherID
				WHERE P.PaymentID=@PaymentID

				SET @ErrorCode=@@Error

				IF @ErrorCode<>0
					GOTO ROLLBACK_TRAN
			END 
		END



		UPDATE	Payment
		SET	PostingDate = CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(TP.PostingDate) AS DATETIME),110) AS DATETIME), 
			PaymentAmount = TP.PaymentAmount,
			PaymentMethodCode = TP.PaymentMethodCode,
			PayerTypeCode = @PayerTypeCode,
			PayerID = case when @other_payer_id is null then TP.PayerID else @other_payer_id end,
			PaymentNumber = TP.PaymentNumber,
			Description = TP.Description,
			ModifiedDate = GETDATE(),
			ModifiedUserID = @UserID,
			DefaultAdjustmentCode=TP.DefaultAdjustmentCode,
			BatchID=TP.BatchID,
			AdjudicationDate=CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(TP.AdjudicationDate) AS DATETIME),110) AS DATETIME),
			ClearinghouseResponseID=TP.ClearinghouseResponseID,
			SourceAppointmentID=TP.AppointmentID,
			AppointmentID=TP.AppointmentID,
			AppointmentStartDate=TP.AppointmentStartDate,
			PaymentCategoryID = TP.PaymentCategoryID
			, overrideClosingDate = @overrideClosingDate
		FROM #Payment TP INNER JOIN Payment P
		ON TP.PaymentID=P.PaymentID

		SET @ErrorCode=@@Error

		IF @ErrorCode<>0
			GOTO ROLLBACK_TRAN
	END

	--If ERA mark update ClearinghouseResponse Record with PaymentID and mark as reviewed
	UPDATE CLR SET PaymentID=@PaymentID, ReviewedFlag=1
	FROM ClearinghouseResponse CLR INNER JOIN #Payment P
	ON CLR.ClearinghouseResponseID=P.ClearinghouseResponseID	

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	IF @BusinessRuleLog IS NOT NULL
	BEGIN
		INSERT INTO PaymentBusinessRuleLog(PaymentID, PracticeID, BusinessRuleLog, CreatedDate, CreatedUserID)
		SELECT @PaymentID, PracticeID, @BusinessRuleLog, GETDATE(), @UserID
		FROM #Payment
	END

	--Add any new PaymentPatient records needed
	IF EXISTS(SELECT * FROM #Patients WHERE Operation='A' AND AlreadyExists=0)
		INSERT INTO PaymentPatient(PracticeID, PaymentID, PatientID)
		SELECT @PracticeID, @PaymentID, PatientID
		FROM #Patients
		WHERE Operation='A' AND AlreadyExists=0

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Add any new PaymentEncounter records needed
	IF EXISTS(SELECT @PaymentID, @PracticeID, E.PatientID, E.EncounterID, EOBXml, PaymentRawEOBID
			  FROM #Encounters E LEFT JOIN #Patients P
			  ON E.PatientID=P.PatientID
			  WHERE E.Operation='A' AND E.AlreadyExists=0 AND (P.Operation<>'D' OR P.PatientID IS NULL))
	BEGIN
		INSERT INTO PaymentEncounter(PaymentID, PracticeID, PatientID, EncounterID, EOBXml, PaymentRawEOBID)
		SELECT @PaymentID, @PracticeID, E.PatientID, E.EncounterID, EOBXml, PaymentRawEOBID
		FROM #Encounters E LEFT JOIN #Patients P
		ON E.PatientID=P.PatientID
		WHERE E.Operation='A' AND E.AlreadyExists=0 AND (P.Operation<>'D' OR P.PatientID IS NULL)
	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Add any new PaymentClaim records needed
	IF EXISTS(SELECT @PaymentID, @PracticeID, PC.PatientID, PC.EncounterID, PC.ClaimID, PC.EOBXml, PC.Notes, PC.PaymentRawEOBID,
			  CASE WHEN VE.ClaimID IS NOT NULL THEN 1 ELSE 0 END Draft, PC.HasError, PC.ErrorMsg
			  FROM #PayClaims PC LEFT JOIN #Encounters E
			  ON PC.EncounterID=E.EncounterID
			  LEFT JOIN #Patients P
			  ON PC.PatientID=P.PatientID
			  LEFT JOIN #ValidationExceptions VE
			  ON PC.ClaimID=VE.ClaimID
			  WHERE PC.Operation='A' AND ((E.Operation<>'D' OR E.EncounterID IS NULL) AND (P.Operation<>'D' OR P.PatientID IS NULL)))
	BEGIN
		INSERT INTO PaymentClaim(PaymentID, PracticeID, PatientID, EncounterID, ClaimID, EOBXml, Notes, PaymentRawEOBID, Draft, HasError, ErrorMsg)
		SELECT @PaymentID, @PracticeID, PC.PatientID, PC.EncounterID, PC.ClaimID, PC.EOBXml, PC.Notes, PC.PaymentRawEOBID,
		CASE WHEN VE.ClaimID IS NOT NULL THEN 1 ELSE 0 END Draft, PC.HasError, PC.ErrorMsg
		FROM #PayClaims PC LEFT JOIN #Encounters E
		ON PC.EncounterID=E.EncounterID
		LEFT JOIN #Patients P
		ON PC.PatientID=P.PatientID
		LEFT JOIN #ValidationExceptions VE
		ON PC.ClaimID=VE.ClaimID
		WHERE PC.Operation='A' AND ((E.Operation<>'D' OR E.EncounterID IS NULL) AND (P.Operation<>'D' OR P.PatientID IS NULL))
	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Update PaymentClaim records needed
	IF EXISTS(SELECT * FROM #PayClaims WHERE Operation='M')
	BEGIN
		UPDATE PC SET EOBXml=TPC.EOBXml, HasError=TPC.HasError, ErrorMsg=TPC.ErrorMsg, Notes=TPC.Notes
		FROM #PayClaims TPC INNER JOIN PaymentClaim PC
		ON @PaymentID=PC.PaymentID AND @PracticeID=PC.PracticeID AND TPC.ClaimID=PC.ClaimID
		WHERE TPC.Operation='M'
	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Remove any structures flagged as deletions
	IF EXISTS(SELECT * FROM #EncountersToDelete)
	BEGIN
		DELETE PE
		FROM #EncountersToDelete E INNER JOIN PaymentEncounter PE
		ON @PaymentID=PE.PaymentID AND @PracticeID=PE.PracticeID AND 
		((E.EncounterID=PE.EncounterID) OR E.EncounterID IS NULL AND E.PatientID=PE.PatientID)
	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	IF EXISTS(SELECT * FROM #Patients WHERE Operation='D')
	BEGIN
		DELETE PP
		FROM #Patients P INNER JOIN PaymentPatient PP
		ON @PaymentID=PP.PaymentID AND @PracticeID=PP.PracticeID AND P.PatientID=PP.PatientID
		WHERE P.Operation='D'
	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	IF @PostingDateChanged=1
	BEGIN	
		--Update ClaimTransaction Posting Dates where possible
		UPDATE CT SET PostingDate=CASE WHEN CD.PostingDate>@PostingDate AND @ClosingDate IS NULL THEN CD.PostingDate
								   WHEN CD.PostingDate>@PostingDate AND CD.PostingDate <= @ClosingDate THEN @ClosingDate+1
								   WHEN CD.PostingDate>@PostingDate AND CD.PostingDate>@ClosingDate THEN CD.PostingDate
								   ELSE @PostingDate END,
				overrideClosingDate=@overrideClosingDate
		FROM ClaimTransaction CT INNER JOIN #CT_PostingDateToUpdate CTU
		ON CT.ClaimTransactionID=CTU.ClaimTransactionID
		INNER JOIN #Claim_Dates CD
		ON CTU.ClaimID=CD.ClaimID

		SET @ErrorCode=@@Error

		IF @ErrorCode<>0
			GOTO ROLLBACK_TRAN

		-- Update the refund and capitated posting dates
		UPDATE	R
		SET		R.PostingDate = @PostingDate
		FROM	RefundToPayments R
		WHERE	R.PaymentID = @PaymentID

		SET @ErrorCode=@@Error

		IF @ErrorCode<>0
			GOTO ROLLBACK_TRAN

		UPDATE	C
		SET		C.PostingDate = @PostingDate
		FROM	CapitatedAccountToPayment C
		WHERE	C.PaymentID = @PaymentID

		SET @ErrorCode=@@Error

		IF @ErrorCode<>0
			GOTO ROLLBACK_TRAN
	END

	IF EXISTS(SELECT * FROM #DenialsToDelete)
	BEGIN

		DELETE CT 
		FROM ClaimTransaction CT INNER JOIN #DenialsToDelete DTD
		ON CT.ClaimTransactionID=DTD.ClaimTransactionID

	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	-- Update the End to CLS
	IF EXISTS(SELECT * FROM #Claim_LastStatusSettingIDs)
	BEGIN
		UPDATE CT SET ClaimTransactionTypeCode='CLS'
		FROM #Claim_LastStatusSettingIDs CLS 
			INNER JOIN @ReopenMaxTran RMT ON CLS.RID=RMT.RID	
			INNER JOIN ClaimTransaction CT ON CT.ClaimID = cls.ClaimID
		WHERE CT.ClaimTransactionTypeCode = 'END'
	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Update Last ResponsePostingDate to those BLL trans that this response pertains to
	IF EXISTS(SELECT * FROM #MAX_ResponsePostingDate)
	BEGIN
		UPDATE CAB SET ResponsePostingDate=MR.ResponsePostingDate
		FROM #MAX_ResponsePostingDate MR INNER JOIN ClaimAccounting_Billings CAB
		ON MR.ReferenceID=CAB.ClaimTransactionID
	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	IF EXISTS(SELECT * FROM #ClaimTrans WHERE Operation='M' AND ClaimTransactionTypeCode='CLS')
	BEGIN
		--Update END CT Trans that were reopened
		UPDATE CT SET ClaimTransactionTypeCode=MCT.ClaimTransactionTypeCode,
			overrideClosingDate=@overrideClosingDate
		FROM #ClaimTrans MCT INNER JOIN ClaimTransaction CT
		ON @PracticeID=CT.PracticeID AND MCT.ClaimTransactionID=CT.ClaimTransactionID
		WHERE MCT.Operation='M' AND MCT.ClaimTransactionTypeCode='CLS'
	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Insert RES Transactions	
	IF EXISTS(SELECT * FROM #NoRES)
	BEGIN
		INSERT INTO ClaimTransaction(ClaimTransactionTypeCode, ClaimID, PostingDate, PaymentID, PracticeID, 
									 PatientID, Claim_ProviderID, CreatedUserID, ModifiedUserID, overrideClosingDate,
									 ReferenceID)
		SELECT DISTINCT 'RES', NR.ClaimID, NR.PostingDate, 
			   @PaymentID PaymentID, @PracticeID PracticeID, CP.PatientID, Claim_ProviderID, 
			   @UserID CreatedUserID, @UserID ModifiedUserID, @overrideClosingDate, NR.ReferenceID
		FROM #NoRes NR INNER JOIN #ClaimProviders CP
		ON NR.ClaimID=CP.ClaimID
		INNER JOIN PaymentClaim PC
		ON @PracticeID=PC.PracticeID AND NR.ClaimID=PC.ClaimID AND PC.PaymentID=@PaymentID
	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Insert DEN Transactions	
	IF EXISTS(SELECT * FROM #DenialsToInsert)
	BEGIN
		INSERT INTO ClaimTransaction(ClaimTransactionTypeCode, ClaimID, PostingDate, PaymentID, PracticeID, 
									 PatientID, Claim_ProviderID, CreatedUserID, ModifiedUserID, overrideClosingDate)
		SELECT DISTINCT 'DEN', DTI.ClaimID, DTI.PostingDate, 
			   @PaymentID PaymentID, @PracticeID PracticeID, CP.PatientID, Claim_ProviderID, 
			   @UserID CreatedUserID, @UserID ModifiedUserID, @overrideClosingDate
		FROM #DenialsToInsert DTI INNER JOIN #ClaimProviders CP
		ON DTI.ClaimID=CP.ClaimID
		INNER JOIN PaymentClaim PC
		ON @PracticeID=PC.PracticeID AND DTI.ClaimID=PC.ClaimID AND PC.PaymentID=@PaymentID
	END

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Insert ClaimTransactions
	INSERT INTO ClaimTransaction(ClaimTransactionTypeCode, ClaimID, PostingDate, Amount, Quantity, Code, ReferenceID,
								 Notes, AdjustmentCode, PaymentID, PracticeID, 
								 PatientID, Claim_ProviderID, CreatedUserID, ModifiedUserID, overrideClosingDate)
	SELECT ClaimTransactionTypeCode, CT.ClaimID, PostingDate, 
		CASE WHEN ClaimTransactionTypeCode='ASN' THEN NULL ELSE Amount END Amount, CASE WHEN ClaimTransactionTypeCode='PAY' THEN 1 ELSE NULL END Quantity,
		   Code = CASE ClaimTransactionTypeCode
				WHEN 'ASN' THEN Code 
				WHEN 'END' THEN AdjustmentCode
				WHEN 'RAS' THEN Code
				WHEN 'REO' THEN Code
				ELSE NULL 
				END ,
		   CASE WHEN ClaimTransactionTypeCode='ASN' THEN InsPlanID ELSE NULL END ReferenceID, CT.Notes,
		   CASE WHEN ClaimTransactionTypeCode='ADJ' THEN AdjustmentCode ELSE NULL END AdjustmentCode,
		   @PaymentID PaymentID, @PracticeID PracticeID, CP.PatientID, Claim_ProviderID, 
		   @UserID CreatedUserID, @UserID ModifiedUserID, @overrideClosingDate overrideClosingDate
	FROM #ClaimTrans CT INNER JOIN #ClaimProviders CP
	ON CT.ClaimID=CP.ClaimID
	INNER JOIN PaymentClaim PC
	ON @PracticeID=PC.PracticeID AND CT.ClaimID=PC.ClaimID AND PC.PaymentID=@PaymentID
	LEFT JOIN #ValidationExceptions VE
	ON CT.ClaimID=VE.ClaimID
	WHERE Operation='A' AND VE.ClaimID IS NULL
	ORDER BY CT.ClaimID, RID

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Set Claim Status
	UPDATE C SET ClaimStatusCode=
				 CASE WHEN ClaimTransactionTypeCode IN ('ASN','CST','RAS', 'CLS') THEN 'R'
					  WHEN ClaimTransactionTypeCode IN ('END','XXX') THEN 'C'
					  WHEN ClaimTransactionTypeCode='BLL' THEN 'P' END
	FROM #Claim_LastStatusSettingIDs CLS INNER JOIN Claim C
	ON CLS.ClaimID=C.ClaimID

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Update EncounterProcedure PatientResp
	UPDATE EP SET PatientResp=PatientResp+CopayDelta
	FROM #PRCUpdate PRC INNER JOIN Claim C
	ON PRC.ClaimID=C.ClaimID
	INNER JOIN EncounterProcedure EP
	ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
	WHERE C.PracticeID=@PracticeID

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	--Add record to VoidedClaims for any claims now in void state
	INSERT INTO VoidedClaims(ClaimID)
	SELECT DISTINCT ClaimID
	FROM #ClaimTrans
	WHERE Operation='A' AND ClaimTransactionTypeCode='XXX'

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	IF dbo.BusinessRule_PaymentUnappliedAmount(@PaymentID)<=0
		--Remove from UnappliedPayments if Payment becomes fully applied
		DELETE UnappliedPayments
		WHERE PracticeID=@PracticeID AND PaymentID=@PaymentID 
	ELSE
		IF NOT EXISTS(SELECT * FROM UnappliedPayments WHERE PracticeID=@PracticeID AND PaymentID=@PaymentID)
			INSERT INTO UnappliedPayments
			VALUES(@PracticeID, @PaymentID)

	SET @ErrorCode=@@Error

	IF @ErrorCode<>0
		GOTO ROLLBACK_TRAN

	
	IF @OverrideClosingDate = 1
	BEGIN
		Update Payment
		SET OverrideClosingDate = 0
		WHERE PracticeID = @PracticeID AND PaymentID = @PaymentID

		Update ClaimTransaction
		SET OverrideClosingDate = 0
		WHERE PaymentID = @PaymentID AND OverrideClosingDate = 1
	END

	COMMIT TRAN

	PRINT @PaymentID

	RETURN @DraftModePaymentID
	
ROLLBACK_TRAN:
	SET @ErrorMsg = 'Rolling back transaction - PaymentDataProvider_SavePayment - ' + CONVERT(varchar(30), GETDATE(), 121) + ' [Error '+CAST(@ErrorCode AS VARCHAR)+']'

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@ErrorMsg, 16,1)

	RETURN

DROP TABLE #XMLVar
DROP TABLE #NodeList
DROP TABLE #Payment
DROP TABLE #Patients
DROP TABLE #Encounters
DROP TABLE #PayClaims
DROP TABLE #ClaimTrans
DROP TABLE #LastTrans
DROP TABLE #ClaimsChanged
DROP TABLE #ValidationExceptions 
DROP TABLE #ClaimPayers
DROP TABLE #Claim_Dates
DROP TABLE #CT_PostingDateToUpdate
DROP TABLE #ClaimProviders
DROP TABLE #Claim_LastStatusSettingIDs
DROP TABLE #PRCUpdate
DROP TABLE #EncountersToDelete
DROP TABLE #ClaimsWithRES
DROP TABLE #NoRES
DROP TABLE #MAX_ResponsePostingDate
DROP TABLE #PaymentXML 
DROP TABLE #PaymentClaim
DROP TABLE #ClaimChangesPaymentClaims
DROP TABLE #ExistingDenialTrans
DROP TABLE #DenialsToInsert
DROP TABLE #DenialsToDelete

END

