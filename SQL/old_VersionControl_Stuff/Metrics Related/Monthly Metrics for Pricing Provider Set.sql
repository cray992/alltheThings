DECLARE @StartDt VARCHAR(20)
DECLARE @EndDt VARCHAR(20)

SET @StartDt='5-27-07'
SET @EndDt='6-27-07'

CREATE TABLE #Results(CustomerID INT, PracticeID INT, PracticeName VARCHAR(225), DoctorID INT, ProviderName VARCHAR(225), Subscription VARCHAR(50), SupportPlan VARCHAR(50), 
					  ProviderType VARCHAR(50), EClaims INT)
CREATE TABLE #DRO(CustomerID INT, ProviderID INT, DaysRevenueOutstanding DECIMAL(10,2))

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
SET @EClaimExecSql=REPLACE(@EClaimExecSql,'{3}','')
SET @EClaimExecSql=REPLACE(@EClaimExecSql,'{4}','BIZCLAIMSDBSERVER.Kareobizclaims..')

EXEC(@EClaimExecSql)


	DECLARE @Loop INT
	DECLARE @Count INT

	CREATE TABLE #DBs(TID INT IDENTITY(1,1), CustomerID INT, DatabaseServerName VARCHAR(50), DatabaseName VARCHAR(50), Customer VARCHAR(128), CreatedDate DATETIME)
	INSERT INTO #DBs(CustomerID, DatabaseServerName, DatabaseName, Customer, CreatedDate)
	SELECT C.CustomerID, DatabaseServerName, DatabaseName, CompanyName, C.CreatedDate
	FROM Customer C 
	WHERE DBActive=1 AND CustomerType='N' AND Metrics=1

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

	CREATE TABLE #Practices(PracticeID INT, PracticeName VARCHAR(225), Edition VARCHAR(50), SupportPlan VARCHAR(50))
	INSERT INTO #Practices(PracticeID, PracticeName, Edition, SupportPlan)
	SELECT PracticeID, P.Name PracticeName, EditionTypeCaption Edition, SupportTypeCaption SupportPlan
	FROM {3}Practice P INNER JOIN EditionType ET
	ON ISNULL(P.EditionTypeID,1)=ET.EditionTypeID
	INNER JOIN SupportType ST
	ON ISNULL(P.SupportTypeID,1)=ST.SupportTypeID
	WHERE P.Active=1 AND P.Metrics=1

	CREATE TABLE #Providers(PracticeID INT, DoctorID INT, ProviderName VARCHAR(228), ProviderType VARCHAR(50))
	INSERT INTO #Providers(PracticeID, DoctorID, ProviderName, ProviderType)
	SELECT D.PracticeID, D.DoctorID, COALESCE(D.LastName+'' ,'','''')+D.Firstname+'' ''+ISNULL(D.Degree,'''') ProviderName, 
	ProviderTypeName ProviderType
	FROM {3}Doctor D INNER JOIN ProviderType PT
	ON ISNULL(D.ProviderTypeID,1)=PT.ProviderTypeID
	WHERE D.[External]=0 AND ActiveDoctor=1

	CREATE TABLE #EClaimsMetrics_PartI(PracticeID INT, DoctorID INT, EClaims INT)
	INSERT INTO #EClaimsMetrics_PartI(PracticeID, DoctorID, EClaims)
	SELECT S.PracticeID, CA.ProviderID DoctorID, COUNT(S.ReferenceID) EClaims
	FROM #Submissions S INNER JOIN {3}ClaimAccounting CA
	ON S.PracticeID=CA.PracticeID AND S.ReferenceID=CA.ClaimID AND CA.ClaimTransactionTypeCode=''CST''
	WHERE S.CustomerID=@CustomerID AND S.ZNumber=0
	GROUP BY S.PracticeID, CA.ProviderID

	INSERT INTO #EClaimsMetrics_PartI(PracticeID, DoctorID, EClaims)
	SELECT S.PracticeID, E.DoctorID, COUNT(S.ReferenceID) EClaims
	FROM #Submissions S INNER JOIN {3}Encounter E
	ON S.PracticeID=E.PracticeID AND S.ReferenceID=E.EncounterID
	WHERE S.CustomerID=@CustomerID AND S.ZNumber=1
	GROUP BY S.PracticeID, E.DoctorID

	INSERT INTO #EClaimsMetrics_PartI(PracticeID, DoctorID, EClaims)
	SELECT R.PracticeID, CA.ProviderID DoctorID, COUNT(R.PayerGatewayResponseID)*-1 EClaims
	FROM #PGR_ClaimData R INNER JOIN {3}ClaimAccounting CA
	ON R.PracticeID=CA.PracticeID AND R.ReferenceID=CA.ClaimID AND CA.ClaimTransactionTypeCode=''CST''
	WHERE R.CustomerID=@CustomerID AND R.ZNumber=0
	GROUP BY R.PracticeID, CA.ProviderID

	INSERT INTO #EClaimsMetrics_PartI(PracticeID, DoctorID, EClaims)
	SELECT R.PracticeID, E.DoctorID, COUNT(R.PayerGatewayResponseID)*-1 EClaims
	FROM #PGR_ClaimData R INNER JOIN {3}Encounter E
	ON R.PracticeID=E.PracticeID AND R.ReferenceID=E.EncounterID
	WHERE R.CustomerID=@CustomerID AND R.ZNumber=1
	GROUP BY R.PracticeID, E.DoctorID

	CREATE TABLE #EClaimMetrics(CustomerID INT, DoctorID INT, EClaims INT)
	INSERT INTO #EClaimMetrics(CustomerID, DoctorID, EClaims)
	SELECT @CustomerID, DoctorID, SUM(E.EClaims) EClaims
	FROM #EClaimsMetrics_PartI E
	GROUP BY DoctorID

	INSERT INTO #Results(CustomerID, PracticeID, PracticeName, DoctorID, ProviderName, Subscription, SupportPlan, ProviderType, EClaims)
	SELECT @CustomerID, Pr.PracticeID, Pr.PracticeName, P.DoctorID, P.ProviderName, Pr.Edition, Pr.SupportPlan, P.ProviderType, EClaims
	FROM #Practices Pr LEFT JOIN #Providers P
	ON Pr.PracticeID=P.PracticeID
	LEFT JOIN #EClaimMetrics EC
	ON P.DoctorID=EC.DoctorID

	SET @EndDate=CAST(CONVERT(CHAR(10),@EndDate,110) AS DATETIME)

	EXEC {3}MetricsDataProvider_GetDRO @CustomerID, ''4-1-07'', ''6-27-07 23:59'', ''D''

	DROP TABLE #Practices
	DROP TABLE #Providers
	DROP TABLE #EClaimsMetrics_PartI
	DROP TABLE #EClaimMetrics
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

		INSERT INTO #DRO(CustomerID, ProviderID, DaysRevenueOutstanding)
		EXEC(@ExecSQL)
	END

SELECT DB.CustomerID, DB.Customer, PracticeName, ProviderName, Subscription, SupportPlan, ProviderType, EClaims, DaysRevenueOutStanding DRO
FROM #Results R INNER JOIN #DBs DB
ON R.CustomerID=DB.CustomerID
LEFT JOIN #DRO D
ON R.CustomerID=D.CustomerID AND R.DoctorID=D.ProviderID

DROP TABLE #Results
DROP TABLE #DBs
DROP TABLE #DRO

DROP TABLE #Submissions
DROP TABLE #PGR_ClaimData