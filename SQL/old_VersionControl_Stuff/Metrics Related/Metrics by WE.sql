SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_CompanyWeeklyMetrics]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_CompanyWeeklyMetrics]
GO


--===========================================================================
-- SRS Patient Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_CompanyWeeklyMetrics
	@StartDt  VARCHAR(20) = NULL,
	@EndDt VARCHAR(20) = NULL
AS


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME



-- If NULL, then we'll Just set it to the previous week.
IF @StartDt IS NULL OR @EndDt IS NULL OR isdate(@StartDt) = 0 OR isdate(@EndDt) = 0
BEGIN

	SET @StartDt='7-8-07'
	SET @EndDt='7-14-07'

END
ELSE 

	SET @StartDate=CAST(@StartDt AS DATETIME)
	SET @EndDate=CAST(@EndDt AS DATETIME)

END


CREATE TABLE #WE_EndDt(WID INT IDENTITY(1,1), Dt DATETIME)
INSERT INTO #WE_EndDt(Dt)
SELECT Dt
FROM DateKey
WHERE Dt BETWEEN @StartDate AND @EndDate AND WD=7

CREATE TABLE #WE_StartDt(WID INT IDENTITY(1,1), Dt DATETIME)
INSERT INTO #WE_StartDt(Dt)
SELECT Dt
FROM DateKey
WHERE Dt BETWEEN @StartDate AND @EndDate AND WD=1

CREATE TABLE #WE(WE DATETIME, StartDt DATETIME, EndDt DATETIME)
INSERT INTO #WE(WE, StartDt, EndDt)
SELECT WEE.Dt-5, WES.Dt, WEE.Dt
FROM #WE_EndDt WEE INNER JOIN #WE_StartDt WES
ON WEE.WID=WES.WID 

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

CREATE TABLE #EncountersI(CustomerID INT, WE DATETIME, Doctors INT, Encounters INT)
CREATE TABLE #DMS(CustomerID INT, WE DATETIME, Doctors INT, MB INT)
CREATE TABLE #Faxes(CustomerID INT, WE DATETIME, Doctors INT, Pages INT)
CREATE TABLE #AppsI(CustomerID INT, WE DATETIME, Doctors INT, Appointments INT)
CREATE TABLE #ERA(CustomerID INT, WE DATETIME, Doctors INT, ERAs INT)
CREATE TABLE #EClaimMetrics(CustomerID INT, WE DATETIME, Doctors INT, EClaims INT)
CREATE TABLE #EligibilitySummary(CustomerID INT, WE DATETIME, Eligibility INT)

	DECLARE @Loop INT
	DECLARE @Count INT

	CREATE TABLE #DBs(TID INT IDENTITY(1,1), CustomerID INT, DatabaseServerName VARCHAR(50), DatabaseName VARCHAR(50), Customer VARCHAR(128), CreatedDate DATETIME)
	INSERT INTO #DBs(CustomerID, DatabaseServerName, DatabaseName, Customer, CreatedDate)
	SELECT CustomerID, DatabaseServerName, DatabaseName, CompanyName, CreatedDate
	FROM Customer
	WHERE Metrics=1 AND DBActive=1 AND CustomerType='N' --AND CustomerID IN (108,1,122,327,114,622)

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

	INSERT INTO #EncountersI(CustomerID, WE, Doctors, Encounters)
	SELECT @CustomerID, 
	WE, COUNT(DISTINCT DoctorID) Doctors, COUNT(EncounterID) Encounters
	FROM {3}Encounter E INNER JOIN {3}Practice P
	ON E.PracticeID=P.PracticeID
	INNER JOIN #WE WE
	ON CAST(CONVERT(CHAR(10),E.CreatedDate,110) AS DATETIME) BETWEEN WE.StartDt AND WE.EndDt
	WHERE P.Metrics=1 AND P.Active=1
	GROUP BY WE

	CREATE TABLE #TDMS(CustomerID INT, WE DATETIME, PracticeID INT, MB INT)
	INSERT INTO #TDMS(CustomerID, WE, PracticeID, MB)
	SELECT @CustomerID, WE, DD.PracticeID, CAST(ROUND(SUM(DF.SizeInBytes)/1048576,0) AS INT) MB
	FROM {3}DMSDocument DD INNER JOIN {3}DMSFileInfo DF
	ON DD.DMSDocumentID=DF.DMSDocumentID
	INNER JOIN {3}Practice P
	ON DD.PracticeID=P.PracticeID
	INNER JOIN #WE WE
	ON CAST(CONVERT(CHAR(10),DD.CreatedDate,110) AS DATETIME) BETWEEN WE.StartDt AND WE.EndDt
	WHERE P.Metrics=1 AND P.Active=1 AND DD.CreatedDate BETWEEN @StartDate AND @EndDate AND SizeInBytes IS NOT NULL AND ISNUMERIC(SizeInBytes)=1 AND DD.PracticeID IS NOT NULL
	GROUP BY WE, DD.PracticeID

	CREATE TABLE #TFaxes(CustomerID INT, WE DATETIME, PracticeID INT, Pages INT)
	INSERT INTO #TFaxes(CustomerID, WE, PracticeID, Pages)
	SELECT @CustomerID, WE, DD.PracticeID, COUNT(DF.DMSFileInfoID) Pages
	FROM {3}DMSDocument DD INNER JOIN {3}DMSFileInfo DF
	ON DD.DMSDocumentID=DF.DMSDocumentID
	INNER JOIN {3}Practice P
	ON DD.PracticeID=P.PracticeID
	INNER JOIN #WE WE
	ON CAST(CONVERT(CHAR(10),DD.CreatedDate,110) AS DATETIME) BETWEEN WE.StartDt AND WE.EndDt
	WHERE P.Metrics=1 AND P.Active=1 AND DD.CreatedDate BETWEEN @StartDate AND @EndDate AND DD.CreatedUserID = 1526 AND DD.PracticeID IS NOT NULL
	GROUP BY WE, DD.PracticeID

	CREATE TABLE #Doctors(PracticeID INT, Doctors INT)
	INSERT INTO #Doctors(PracticeID, Doctors)
	SELECT PracticeID, COUNT(DoctorID)
	FROM {3}Doctor
	WHERE [External]=0 AND ActiveDoctor=1
	GROUP BY PracticeID

	INSERT INTO #DMS(CustomerID, WE, Doctors, MB)
	SELECT CustomerID, WE, SUM(Doctors) Doctors, SUM(MB) MB 
	FROM #TDMS T INNER JOIN #Doctors D
	ON T.PracticeID=D.PracticeID
	GROUP BY CustomerID, WE

	INSERT INTO #Faxes(CustomerID, WE, Doctors, Pages)
	SELECT CustomerID, WE, SUM(Doctors) Doctors, SUM(Pages) Pages 
	FROM #TFaxes T INNER JOIN #Doctors D
	ON T.PracticeID=D.PracticeID
	GROUP BY CustomerID, WE

	DROP TABLE #TDMS
	DROP TABLE #TFaxes

	CREATE TABLE #TERA(PracticeID INT, WE DATETIME, ERAs INT)
	INSERT INTO #TERA(PracticeID, WE, ERAs)
	SELECT PracticeID, WE, COUNT(CR.ClearinghouseResponseID) ERAs
	FROM {3}ClearinghouseResponse CR
	INNER JOIN #WE WE
	ON CAST(CONVERT(CHAR(10),CR.FileReceiveDate,110) AS DATETIME) BETWEEN WE.StartDt AND WE.EndDt
	WHERE CR.FileReceiveDate BETWEEN @StartDate AND @EndDate AND CR.ResponseType = 33 AND CR.ClearinghouseResponseReportTypeID = 2
	GROUP BY PracticeID, WE

	INSERT INTO #ERA(CustomerID, WE, Doctors, ERAs)
	SELECT @CustomerID, WE, SUM(Doctors) Doctors, SUM(ERAs) ERAs
	FROM #TERA T INNER JOIN #Doctors D
	ON T.PracticeID=D.PracticeID
	GROUP BY WE
	
	DROP TABLE #TERA

	INSERT INTO #AppsI(CustomerID, WE, Doctors, Appointments)
	SELECT @CustomerID, WE, COUNT(DISTINCT ATR.ResourceID) Doctors, COUNT(ATR.AppointmentID) Appointments
	FROM {3}Appointment A INNER JOIN {3}AppointmentToResource ATR
	ON A.AppointmentID=ATR.AppointmentID AND A.AppointmentResourceTypeID=ATR.AppointmentResourceTypeID
	INNER JOIN #WE WE
	ON CAST(CONVERT(CHAR(10),A.CreatedDate,110) AS DATETIME) BETWEEN WE.StartDt AND WE.EndDt
	WHERE A.CreatedDate BETWEEN @StartDate AND @EndDate AND A.AppointmentResourceTypeID=1
	GROUP BY WE


	CREATE TABLE #EClaimsMetrics_PartI(WE DATETIME, PracticeID INT, DoctorID INT, EClaims INT)
	INSERT INTO #EClaimsMetrics_PartI(WE, PracticeID, DoctorID, EClaims)
	SELECT WE, S.PracticeID, CA.ProviderID DoctorID, COUNT(S.ReferenceID) EClaims
	FROM #Submissions S INNER JOIN {3}ClaimAccounting CA
	ON S.PracticeID=CA.PracticeID AND S.ReferenceID=CA.ClaimID AND CA.ClaimTransactionTypeCode=''CST''
	INNER JOIN #WE WE
	ON CAST(CONVERT(CHAR(10),S.Dt,110) AS DATETIME) BETWEEN WE.StartDt AND WE.EndDt
	WHERE S.CustomerID=@CustomerID AND S.ZNumber=0
	GROUP BY WE, S.PracticeID, CA.ProviderID

	INSERT INTO #EClaimsMetrics_PartI(WE, PracticeID, DoctorID, EClaims)
	SELECT WE, S.PracticeID, E.DoctorID, COUNT(S.ReferenceID) EClaims
	FROM #Submissions S INNER JOIN {3}Encounter E
	ON S.PracticeID=E.PracticeID AND S.ReferenceID=E.EncounterID
	INNER JOIN #WE WE
	ON CAST(CONVERT(CHAR(10),S.Dt,110) AS DATETIME) BETWEEN WE.StartDt AND WE.EndDt
	WHERE S.CustomerID=@CustomerID AND S.ZNumber=1
	GROUP BY WE, S.PracticeID, E.DoctorID

	INSERT INTO #EClaimsMetrics_PartI(WE, PracticeID, DoctorID, EClaims)
	SELECT WE, R.PracticeID, CA.ProviderID DoctorID, COUNT(R.PayerGatewayResponseID)*-1 EClaims
	FROM #PGR_ClaimData R INNER JOIN {3}ClaimAccounting CA
	ON R.PracticeID=CA.PracticeID AND R.ReferenceID=CA.ClaimID AND CA.ClaimTransactionTypeCode=''CST''
	INNER JOIN #WE WE
	ON CAST(CONVERT(CHAR(10),R.Dt,110) AS DATETIME) BETWEEN WE.StartDt AND WE.EndDt
	WHERE R.CustomerID=@CustomerID AND R.ZNumber=0
	GROUP BY WE, R.PracticeID, CA.ProviderID

	INSERT INTO #EClaimsMetrics_PartI(WE, PracticeID, DoctorID, EClaims)
	SELECT WE, R.PracticeID, E.DoctorID, COUNT(R.PayerGatewayResponseID)*-1 EClaims
	FROM #PGR_ClaimData R INNER JOIN {3}Encounter E
	ON R.PracticeID=E.PracticeID AND R.ReferenceID=E.EncounterID
	INNER JOIN #WE WE
	ON CAST(CONVERT(CHAR(10),R.Dt,110) AS DATETIME) BETWEEN WE.StartDt AND WE.EndDt
	WHERE R.CustomerID=@CustomerID AND R.ZNumber=1
	GROUP BY WE, R.PracticeID, E.DoctorID

	INSERT INTO #EClaimMetrics(CustomerID, WE, Doctors, EClaims)
	SELECT @CustomerID, WE, COUNT(DISTINCT DoctorID) Doctors, SUM(E.EClaims) EClaims
	FROM #EClaimsMetrics_PartI E
	GROUP BY WE

	--Eligibility Checks
	CREATE TABLE #Eligibility(WE DATETIME, CustomerID INT, PracticeID INT, PatientID INT, PatientCaseID INT, InsurancePolicyID INT, InsuranceCompanyID INT, InsuranceCompanyPlanID INT)
	INSERT INTO #Eligibility(WE, CustomerID, PracticeID, PatientID, PatientCaseID, InsurancePolicyID, InsuranceCompanyID, InsuranceCompanyPlanID)
	SELECT WE, CustomerID, PracticeID, PatientID, CaseID PatientCaseID, InsurancePolicyID, InsuranceCompanyID, InsuranceCompanyPlanID
	FROM EligibilityTransactionLog EL
	INNER JOIN #WE WE
	ON CAST(CONVERT(CHAR(10),EL.TransactionDate,110) AS DATETIME) BETWEEN WE.StartDt AND WE.EndDt
	WHERE EL.CustomerID=@CustomerID AND EL.TransactionDate BETWEEN @StartDate AND @EndDate

	--Check for Association with PatientCase
	UPDATE E SET PracticeID=PC.PracticeID
	FROM #Eligibility E INNER JOIN {3}PatientCase PC
	ON E.PatientCaseID=PC.PatientCaseID
	WHERE E.PracticeID IS NULL

	--Check for Association with Patient
	UPDATE E SET PracticeID=P.PracticeID
	FROM #Eligibility E INNER JOIN {3}Patient P
	ON E.PatientID=P.PatientID
	WHERE E.PracticeID IS NULL

	--Check for Association with InsurancePolicy
	UPDATE E SET PracticeID=IP.PracticeID
	FROM #Eligibility E INNER JOIN {3}InsurancePolicy IP
	ON E.InsurancePolicyID=IP.InsurancePolicyID
	WHERE E.PracticeID IS NULL

	INSERT INTO #EligibilitySummary(CustomerID, WE, Eligibility)
	SELECT @CustomerID, WE, COUNT(*) Eligibility
	FROM #Eligibility
	WHERE PracticeID IS NOT NULL
	GROUP BY WE

	DROP TABLE #Eligibility
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

DROP TABLE #WE_StartDt
DROP TABLE #WE_EndDt
DROP TABLE #WE

SELECT 'Encounters' Metric, COUNT(CustomerID) Customers, SUM(Doctors) Providers, SUM(Encounters) Measure
FROM #EncountersI
UNION
SELECT 'DMS' Metric, COUNT(CustomerID) Customers, SUM(Doctors) Providers, SUM(MB) Measure 
FROM #DMS
UNION
SELECT 'Faxes' Metric, COUNT(CustomerID) Customers, SUM(Doctors) Providers, SUM(Pages) Measure 
FROM #Faxes
UNION
SELECT 'Appointments' Metric, COUNT(CustomerID) Customers, SUM(Doctors) Providers, SUM(Appointments) Measure 
FROM #AppsI
UNION
SELECT 'ERA' Metric, COUNT(CustomerID) Customeres, SUM(Doctors) Providers, SUM(ERAs) Measure 
FROM #ERA
UNION
SELECT 'EClaims' Metric, COUNT(CustomerID) Customers, SUM(Doctors) Providers, SUM(EClaims) Measure 
FROM #EClaimMetrics
UNION
SELECT 'Eligibility' Metric, COUNT(CustomerID) Customers, NULL Providers, SUM(Eligibility) Measure 
FROM #EligibilitySummary

UNION ALL

SELECT 'ClaimsSentCount', 0, 0,
	count(DISTINCT CMT.ClaimMessageId) AS ClaimsSentCount
FROM BIZCLAIMSDBSERVER_REPORTING.KareoBizclaims.dbo.ClaimMessageTransaction CMT WITH(NOLOCK)
	JOIN BIZCLAIMSDBSERVER_REPORTING.KareoBizclaims.dbo.ClaimMessage CM WITH(NOLOCK) ON CMT.ClaimMessageId = CM.ClaimMessageId
WHERE CMT.ClaimMessageTransactionTypeCode = 'SNT'
AND CMT.CreatedDate between @StartDate AND @EndDate

UNION ALL

SELECT 'ClaimsSentDollars', 0, 0,
	ISNULL(CAST(SUM(CM.ClaimTotalAmount) AS Money),0) AS ClaimsSentDollars
FROM BIZCLAIMSDBSERVER_REPORTING.KareoBizclaims.dbo.ClaimMessageTransaction CMT WITH(NOLOCK)
	JOIN BIZCLAIMSDBSERVER_REPORTING.KareoBizclaims.dbo.ClaimMessage CM WITH(NOLOCK) ON CMT.ClaimMessageId = CM.ClaimMessageId
WHERE CMT.ClaimMessageTransactionTypeCode = 'SNT'
	AND CMT.CreatedDate between @StartDate AND @EndDate


UNION ALL

SELECT  'ClaimsRejected', 0, 0,
	count(PGR.PayerGatewayResponseId) as ClaimsRejected
FROM         BIZCLAIMSDBSERVER_REPORTING.KareoBizclaims.dbo.PayerGatewayResponse PGR WITH(NOLOCK)
WHERE (PGR.PayerGatewayResponseTypeCode = 'ch-prc') AND (CAST(PGR.PayerProcessingStatus AS varchar) = 'REJ')
AND PGR.CreatedDate between @StartDate AND @EndDate


UNION ALL

SELECT  'ClaimsRejectedDollars', 0, 0,
	ISNULL(CAST(SUM(PGR.Charge) AS Money),0) AS ClaimsRejectedDollars
FROM         BIZCLAIMSDBSERVER_REPORTING.KareoBizclaims.dbo.PayerGatewayResponse PGR WITH(NOLOCK)
WHERE (PGR.PayerGatewayResponseTypeCode = 'ch-prc') AND (CAST(PGR.PayerProcessingStatus AS varchar) = 'REJ')
AND PGR.CreatedDate between @StartDate AND @EndDate


UNION ALL


SELECT 'PayerAcceptedChargesCount', 0, 0,
	COUNT(PGR.Charge)  AS PayerAcceptedChargesCount
FROM         BIZCLAIMSDBSERVER_REPORTING.KareoBizclaims.dbo.PayerGatewayResponse PGR WITH(NOLOCK)
WHERE (PGR.PayerGatewayResponseTypeCode = 'pr-prc') AND PGR.PayerProcessingStatusTypeCode like 'A%'
AND PGR.CreatedDate between @StartDate AND @EndDate


UNION ALL


SELECT 'PayerAcceptedChargesDollars', 0, 0,
	ISNULL(CAST(SUM(PGR.Charge) AS Money),0) AS PayerAcceptedChargesDollars
FROM  BIZCLAIMSDBSERVER_REPORTING.KareoBizclaims.dbo.PayerGatewayResponse PGR WITH(NOLOCK)
WHERE (PGR.PayerGatewayResponseTypeCode = 'pr-prc') AND PGR.PayerProcessingStatusTypeCode like 'A%'
AND PGR.CreatedDate between @StartDate AND @EndDate


UNION ALL



SELECT 'PayerRejectedChargesCount', 0, 0,
		COUNT(PGR.Charge) AS PayerRejectedChargesCount
	FROM BIZCLAIMSDBSERVER_REPORTING.KareoBizclaims.dbo.PayerGatewayResponse PGR WITH(NOLOCK)
	WHERE (PGR.PayerGatewayResponseTypeCode = 'pr-prc') AND PGR.PayerProcessingStatusTypeCode not like 'A%'
	AND PGR.CreatedDate between @StartDate AND @EndDate

UNION ALL


SELECT 'PayerRejectedChargesDollars', 0, 0,
		ISNULL(CAST(SUM(PGR.Charge) AS Money),0) AS PayerRejectedChargesDollars
	FROM BIZCLAIMSDBSERVER_REPORTING.KareoBizclaims.dbo.PayerGatewayResponse PGR WITH(NOLOCK)
	WHERE (PGR.PayerGatewayResponseTypeCode = 'pr-prc') AND PGR.PayerProcessingStatusTypeCode not like 'A%'
	AND PGR.CreatedDate between @StartDate AND @EndDate


DROP TABLE #EncountersI
DROP TABLE #DMS
DROP TABLE #AppsI
DROP TABLE #ERA
DROP TABLE #EClaimMetrics
DROP TABLE #EligibilitySummary

DROP TABLE #Submissions
DROP TABLE #PGR_ClaimData

