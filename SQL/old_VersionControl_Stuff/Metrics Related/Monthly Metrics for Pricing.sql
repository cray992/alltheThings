DECLARE @StartDt VARCHAR(20)
DECLARE @EndDt VARCHAR(20)

SET @StartDt='5-27-07'
SET @EndDt='6-27-07'

CREATE TABLE #Results(CustomerID INT, PracticeID INT, PracticeName VARCHAR(225), Subscription VARCHAR(50), SupportPlan VARCHAR(50), Providers INT,
					  ERAs INT, PS INT)

CREATE TABLE #DRO(CustomerID INT, PracticeID INT, DaysRevenueOutstanding DECIMAL(10,2))

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

SET @StartDate=CAST(@StartDt AS DATETIME)
SET @EndDate=CAST(@EndDt AS DATETIME)

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

	CREATE TABLE #ProviderCounts(PracticeID INT, Doctors INT)
	INSERT INTO #ProviderCounts(PracticeID, Doctors)
	SELECT PracticeID, COUNT(DoctorID) Doctors
	FROM #Providers
	GROUP BY PracticeID

	--ERAs
	CREATE TABLE #ERAs(PracticeID INT, ERAs INT)
	INSERT INTO #ERAs(PracticeID, ERAs)
	SELECT CR.PracticeID, COUNT(CR.ClearinghouseResponseID) ERAs
	FROM {3}ClearinghouseResponse CR
	WHERE CR.FileReceiveDate BETWEEN @StartDate AND @EndDate AND CR.ResponseType = 33 AND CR.ClearinghouseResponseReportTypeID = 2
	GROUP BY CR.PracticeID

	--Patient Statements
	CREATE TABLE #PSMetrics_PartI(PracticeID INT, BillBatchID INT, PatientID INT, Bills INT)
	INSERT INTO #PSMetrics_PartI(PracticeID, BillBatchID, PatientID, Bills)
	SELECT BB.PracticeID, BB.BillBatchID, BS.PatientID, COUNT(BS.BillID) Bills
	FROM {3}BillBatch BB INNER JOIN {3}Bill_Statement BS
	ON BB.BillBatchID=BS.BillBatchID
	WHERE BB.ConfirmedDate BETWEEN @StartDate AND @EndDate AND BB.BillBatchTypeCode=''S''
	AND BS.Active=1
	AND EXISTS ( SELECT * FROM {3}BillTransmission BT
		ON BB.BillBatchID=BT.ReferenceID AND BT.BillTransmissionFileTypeCode=''P''
		AND LEFT(BT.FileName,4)<>''test'' )
	GROUP BY BB.PracticeID, BB.BillBatchID, BS.PatientID

	CREATE TABLE #PS(PracticeID INT, PS INT)
	INSERT INTO #PS(PracticeID, PS)
	SELECT PS.PracticeID, COUNT(PatientID) PS
	FROM #PSMetrics_PartI PS INNER JOIN {3}Practice P
	ON PS.PracticeID=P.PracticeID
	WHERE P.Metrics=1 AND P.Active=1
	GROUP BY PS.PracticeID


	INSERT INTO #Results(CustomerID, PracticeID, PracticeName, Subscription, SupportPlan, Providers, ERAs, PS)
	SELECT @CustomerID, Pr.PracticeID, Pr.PracticeName, Pr.Edition Subscription, Pr.SupportPlan, Doctors, ERAs, PS
	FROM #Practices Pr INNER JOIN #ProviderCounts PC
	ON Pr.PracticeID=PC.PracticeID
	LEFT JOIN #ERAs E
	ON Pr.PracticeID=E.PracticeID
	LEFT JOIN #PS PS
	ON Pr.PracticeID=PS.PracticeID

	SET @EndDate=CAST(CONVERT(CHAR(10),@EndDate,110) AS DATETIME)

	EXEC {3}MetricsDataProvider_GetDRO @CustomerID, ''4-1-07'', ''6-27-07 23:59'', ''P''

	DROP TABLE #Practices
	DROP TABLE #Providers
	DROP TABLE #ProviderCounts
	DROP TABLE #ERAs
	DROP TABLE #PSMetrics_PartI
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
		INSERT INTO #DRO(CustomerID, PracticeID, DaysRevenueOutstanding)
		EXEC(@ExecSQL)
	END

SELECT DB.CustomerID, DB.Customer, PracticeName, Subscription, SupportPlan, Providers, ERAs, PS,
DaysRevenueOutstanding DRO
FROM #Results R INNER JOIN #DBs DB
ON R.CustomerID=DB.CustomerID
LEFT JOIN #DRO D
ON R.CustomerID=D.CustomerID AND R.PracticeID=D.PracticeID

DROP TABLE #Results
DROP TABLE #DBs
DROP TABLE #DRO