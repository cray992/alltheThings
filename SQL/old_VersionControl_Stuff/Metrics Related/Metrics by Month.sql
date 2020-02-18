DECLARE @StartDt VARCHAR(20)
DECLARE @EndDt VARCHAR(20)

SET @StartDt='8-1-06'
SET @EndDt='5-22-07'

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

SET @StartDate=CAST(@StartDt AS DATETIME)
SET @EndDate=CAST(@EndDt AS DATETIME)

--EClaim Calculation support
CREATE TABLE #Submissions(Dt DATETIME, BillBatchID INT, CustomerID INT, PracticeID INT, BillID INT, ReferenceID INT, PayerNumber VARCHAR(30), ZNumber BIT)
CREATE TABLE #PGR_ClaimData(Dt DATETIME, PayerGatewayResponseID INT, CustomerID INT, PracticeID INT, ReferenceID INT, PayerNumber VARCHAR(30), ZNumber BIT)

DECLARE @EClaimSql VARCHAR(MAX)
DECLARE @EClaimExecSql VARCHAR(MAX)

SET @EClaimSql='
INSERT INTO #Submissions(Dt, BillBatchID, CustomerID, PracticeID, BillID, ReferenceID, PayerNumber, ZNumber)
EXEC {4}BC_CompanyMetrics_Billing_EClaimsSubmissions2 {1},{2}{3}

INSERT INTO #PGR_ClaimData(Dt, PayerGatewayResponseID, CustomerID, PracticeID, ReferenceID, PayerNumber, ZNumber)
EXEC {4}BC_CompanyMetrics_Billing_EClaimsRejections2 {1},{2}{3}
'


SET @EClaimExecSql=REPLACE(@EClaimSql,'{1}', ''''+@StartDt+'''')
SET @EClaimExecSql=REPLACE(@EClaimExecSql,'{2}',''''+@EndDt+' 23:59''')
SET @EClaimExecSql=REPLACE(@EClaimExecSql,'{3}',',''122''')
SET @EClaimExecSql=REPLACE(@EClaimExecSql,'{4}','BIZCLAIMSDBSERVER.Kareobizclaims..')

EXEC(@EClaimExecSql)

	DECLARE @Loop INT
	DECLARE @Count INT

	CREATE TABLE #DBs(TID INT IDENTITY(1,1), CustomerID INT, DatabaseServerName VARCHAR(50), DatabaseName VARCHAR(50), Customer VARCHAR(128), CreatedDate DATETIME)
	INSERT INTO #DBs(CustomerID, DatabaseServerName, DatabaseName, Customer, CreatedDate)
	SELECT CustomerID, DatabaseServerName, DatabaseName, CompanyName, CreatedDate
	FROM Customer
	WHERE Metrics=1 AND DBActive=1 AND CustomerType='N' AND CustomerID IN (122)

	SET @Loop=@@ROWCOUNT
	SET @Count=0

	DECLARE @DatabaseServerName VARCHAR(50)
	DECLARE @DatabaseName VARCHAR(50)
	DECLARE @CustomerID INT

	DECLARE @SQL VARCHAR(MAX)
	DECLARE @ExecSQL VARCHAR(MAX)

	SET @ExecSQL=''

	SET @SQL='

	DECLARE @CustomerID INT
	SET @CustomerID={0}

	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME
	SET @StartDate=''{1}''
	SET @EndDate=''{2} 23:59''


	SELECT ''DMS'' Metric, P.Name Practice, EditionTypeCaption SubscriptionLevel, DATEPART(MM,DD.CreatedDate) Mnth, CAST(ROUND(SUM(DF.SizeInBytes)/1048576,0) AS INT) MB
	FROM {3}DMSDocument DD INNER JOIN {3}DMSFileInfo DF
	ON DD.DMSDocumentID=DF.DMSDocumentID
	INNER JOIN {3}Practice P
	ON DD.PracticeID=P.PracticeID
	LEFT JOIN EditionType ET
	ON P.EditionTypeID=ET.EditionTypeID
	WHERE P.Metrics=1 AND P.Active=1 AND DD.CreatedDate BETWEEN @StartDate AND @EndDate AND SizeInBytes IS NOT NULL AND ISNUMERIC(SizeInBytes)=1 AND DD.PracticeID IS NOT NULL
	GROUP BY P.Name, EditionTypeCaption, DATEPART(MM,DD.CreatedDate)

	SELECT ''ERA'' Metric, P.Name Practice, DATEPART(MM,CR.FileReceiveDate) Mnth, COUNT(CR.ClearinghouseResponseID) ERAs
	FROM {3}ClearinghouseResponse CR
	INNER JOIN {3}Practice P
	ON CR.PracticeID=P.PracticeID
	WHERE CR.FileReceiveDate BETWEEN @StartDate AND @EndDate AND CR.ResponseType = 33 AND CR.ClearinghouseResponseReportTypeID = 2
	GROUP BY P.Name, DATEPART(MM,CR.FileReceiveDate)

	SELECT ''APP'' Metric, P.Name Practice, COALESCE(D.LastName+'' ,'','''')+D.Firstname+'' ''+ISNULL(D.Degree,'''') Provider,
	EditionTypeCaption SubscriptionLevel, PT.ProviderTypeName, DATEPART(MM,A.CreatedDate) Mnth, 
	COUNT(ATR.AppointmentID) Appointments
	FROM {3}Appointment A INNER JOIN {3}AppointmentToResource ATR
	ON A.AppointmentID=ATR.AppointmentID AND A.AppointmentResourceTypeID=ATR.AppointmentResourceTypeID
	INNER JOIN {3}Practice P
	ON A.PracticeID=P.PracticeID
	LEFT JOIN EditionType ET
	ON P.EditionTypeID=ET.EditionTypeID
	INNER JOIN {3}Doctor D
	ON ATR.ResourceID=D.DoctorID
	LEFT JOIN ProviderType PT
	ON D.ProviderTypeID=PT.ProviderTypeID
	WHERE A.CreatedDate BETWEEN @StartDate AND @EndDate AND A.AppointmentResourceTypeID=1
	GROUP BY P.Name, COALESCE(D.LastName+'' ,'','''')+D.Firstname+'' ''+ISNULL(D.Degree,''''),
	EditionTypeCaption, PT.ProviderTypeName, DATEPART(MM,A.CreatedDate)

	CREATE TABLE #EClaimsMetrics_PartI(Mnth INT, PracticeID INT, DoctorID INT, EClaims INT)
	INSERT INTO #EClaimsMetrics_PartI(Mnth, PracticeID, DoctorID, EClaims)
	SELECT DATEPART(MM,S.Dt) Mnth, S.PracticeID, CA.ProviderID DoctorID, COUNT(S.ReferenceID) EClaims
	FROM #Submissions S INNER JOIN {3}ClaimAccounting CA
	ON S.PracticeID=CA.PracticeID AND S.ReferenceID=CA.ClaimID AND CA.ClaimTransactionTypeCode=''CST''
	WHERE S.CustomerID=@CustomerID AND S.ZNumber=0
	GROUP BY DATEPART(MM,S.Dt), S.PracticeID, CA.ProviderID

	INSERT INTO #EClaimsMetrics_PartI(Mnth, PracticeID, DoctorID, EClaims)
	SELECT DATEPART(MM,S.Dt) Mnth, S.PracticeID, E.DoctorID, COUNT(S.ReferenceID) EClaims
	FROM #Submissions S INNER JOIN {3}Encounter E
	ON S.PracticeID=E.PracticeID AND S.ReferenceID=E.EncounterID
	WHERE S.CustomerID=@CustomerID AND S.ZNumber=1
	GROUP BY DATEPART(MM,S.Dt), S.PracticeID, E.DoctorID

	INSERT INTO #EClaimsMetrics_PartI(Mnth, PracticeID, DoctorID, EClaims)
	SELECT DATEPART(MM,R.Dt), R.PracticeID, CA.ProviderID DoctorID, COUNT(R.PayerGatewayResponseID)*-1 EClaims
	FROM #PGR_ClaimData R INNER JOIN {3}ClaimAccounting CA
	ON R.PracticeID=CA.PracticeID AND R.ReferenceID=CA.ClaimID AND CA.ClaimTransactionTypeCode=''CST''
	WHERE R.CustomerID=@CustomerID AND R.ZNumber=0
	GROUP BY DATEPART(MM,R.Dt), R.PracticeID, CA.ProviderID

	INSERT INTO #EClaimsMetrics_PartI(Mnth, PracticeID, DoctorID, EClaims)
	SELECT DATEPART(MM,R.Dt), R.PracticeID, E.DoctorID, COUNT(R.PayerGatewayResponseID)*-1 EClaims
	FROM #PGR_ClaimData R INNER JOIN {3}Encounter E
	ON R.PracticeID=E.PracticeID AND R.ReferenceID=E.EncounterID
	WHERE R.CustomerID=@CustomerID AND R.ZNumber=1
	GROUP BY DATEPART(MM,R.Dt), R.PracticeID, E.DoctorID

	SELECT ''EClaim'' Metric, P.Name Practice, COALESCE(D.LastName+'' ,'','''')+D.Firstname+'' ''+ISNULL(D.Degree,'''') Provider,
	EditionTypeCaption SubscriptionLevel, PT.ProviderTypeName, Mnth, SUM(E.EClaims) EClaims
	FROM #EClaimsMetrics_PartI E INNER JOIN {3}Practice P
	ON E.PracticeID=P.PracticeID
	LEFT JOIN EditionType ET
	ON P.EditionTypeID=ET.EditionTypeID
	INNER JOIN {3}Doctor D
	ON E.DoctorID=D.DoctorID
	LEFT JOIN ProviderType PT
	ON D.ProviderTypeID=PT.ProviderTypeID
	GROUP BY P.Name, COALESCE(D.LastName+'' ,'','''')+D.Firstname+'' ''+ISNULL(D.Degree,''''),
	EditionTypeCaption, PT.ProviderTypeName, Mnth

	CREATE TABLE #PS(PracticeID INT, Mnth INT, BillBatchID INT, PatientID INT, Bills INT)
	INSERT INTO #PS(PracticeID, Mnth, BillBatchID, PatientID, Bills)
	SELECT BB.PracticeID, DATEPART(MM,BB.ConfirmedDate) Mnth, BB.BillBatchID, BS.PatientID, COUNT(BS.BillID) Bills
	FROM {3}BillBatch BB INNER JOIN {3}Bill_Statement BS
	ON BB.BillBatchID=BS.BillBatchID
	WHERE BB.ConfirmedDate BETWEEN @StartDate AND @EndDate AND BB.BillBatchTypeCode=''S''
	AND BS.Active=1 
	AND EXISTS ( SELECT * FROM {3}BillTransmission BT
		ON BB.BillBatchID=BT.ReferenceID AND BT.BillTransmissionFileTypeCode=''P''
		AND LEFT(BT.FileName,4)<>''test'' )
	GROUP BY BB.PracticeID, DATEPART(MM,BB.ConfirmedDate), BB.BillBatchID, BS.PatientID

	SELECT ''PS_1'' Metric, P.Name Practice, Mnth, SUM(CASE WHEN Bills>1 THEN 1 ELSE Bills END) FirstPages,
	SUM(CASE WHEN Bills>1 THEN Bills-1 ELSE 0 END) AddlPages
	FROM #PS PS INNER JOIN {3}Practice P
	ON PS.PracticeID=P.PracticeID
	GROUP BY P.Name, Mnth

	DROP TABLE #PS
	'

	WHILE @Count<@Loop
	BEGIN
		SET @Count=@Count+1

		SELECT @DatabaseServerName=DatabaseServerName, @DatabaseName=DatabaseName, @CustomerID=CustomerID
		FROM #DBs
		WHERE TID=@Count

		SET @ExecSQL=REPLACE(@SQL,'{0}',CAST(@CustomerID AS VARCHAR))
		SET @ExecSQL=REPLACE(@ExecSQL,'{1}',@StartDt)
		SET @ExecSQL=REPLACE(@ExecSQL,'{2}',@EndDt)
		SET @ExecSQL=REPLACE(@ExecSQL,'{3}','['+@DatabaseServerName+'].'+@DatabaseName+'.dbo.')

		PRINT @DatabaseName

		EXEC(@ExecSQL)
	END

	DROP TABLE #DBs


DROP TABLE #Submissions
DROP TABLE #PGR_ClaimData
