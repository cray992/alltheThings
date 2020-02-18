DECLARE @DBCustomerID INT
SET @DBCustomerID=-1

DECLARE @StartDt VARCHAR(20)
DECLARE @EndDt VARCHAR(20)

SET @StartDt='6-25-07'
SET @EndDt=CONVERT(VARCHAR(10),GETDATE(),110)

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

SET @StartDate=CAST(@StartDt AS DATETIME)
SET @EndDate=CAST(@EndDt+' 23:59' AS DATETIME)

--EClaim Calculation support
CREATE TABLE #BCLog(BillBatchID INT, CustomerID INT, PracticeID INT, BillID INT, ReferenceID INT, PayerNumber VARCHAR(30), ZNumber BIT, TranType VARCHAR(10))
INSERT INTO #BCLog(BillBatchID, CustomerID, PracticeID, BillID, ReferenceID, PayerNumber, ZNumber, TranType)
EXEC BIZCLAIMSDBSERVER.Kareobizclaims..BC_CompanyMetrics_Billing_EClaimsTransacations @StartDate, @EndDate,@DBCustomerID

CREATE TABLE #Submissions(CustomerID INT, PracticeID INT, BillBatchID INT, ConfirmedDate DATETIME, BillID INT)

DECLARE @Loop INT
DECLARE @Count INT

CREATE TABLE #DBs(TID INT IDENTITY(1,1), CustomerID INT, DatabaseServerName VARCHAR(50), DatabaseName VARCHAR(50), Customer VARCHAR(128), CreatedDate DATETIME)
INSERT INTO #DBs(CustomerID, DatabaseServerName, DatabaseName, Customer, CreatedDate)
SELECT CustomerID, DatabaseServerName, DatabaseName, CompanyName, CreatedDate
FROM Customer
WHERE Metrics=1 AND DBActive=1 AND CustomerType='N' AND (@DBCustomerID=-1 OR CustomerID=@DBCustomerID)

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

INSERT INTO #Submissions(CustomerID, PracticeID, BillBatchID, ConfirmedDate, BillID)
SELECT @CustomerID, BB.PracticeID, BB.BillBatchID, BB.ConfirmedDate, BE.BillID
FROM {3}BillBatch BB INNER JOIN {3}Bill_EDI BE
ON BB.BillBatchID=BE.BillBatchID
WHERE BB.BillBatchTypeCode=''E'' AND BB.ConfirmedDate>=@StartDate
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

CREATE TABLE #Detail(CustomerID INT, BillBatchID INT, ConfirmedDate DATETIME, NotInBizClaims INT, Validated INT, Sent INT, CHResponse INT, PayerResponse INT)
INSERT INTO #Detail(CustomerID, BillBatchID, ConfirmedDate, NotInBizClaims, Validated, Sent, CHResponse, PayerResponse)
SELECT S.CustomerID, S.BilLBatchID, S.ConfirmedDate, COUNT(CASE WHEN BL.BillID IS NULL THEN 1 ELSE NULL END) NotInBizClaims,
COUNT(CASE WHEN BL.TranType='VLD' THEN 1 ELSE NULL END) Validated,
COUNT(CASE WHEN BL.TranType='SNT' THEN 1 ELSE NULL END) Sent,
COUNT(CASE WHEN BL.TranType='CRS' THEN 1 ELSE NULL END) CHResponse,
COUNT(CASE WHEN BL.TranType='PRS' THEN 1 ELSE NULL END) PayerResponse
FROM #Submissions S LEFT JOIN #BCLog BL
ON S.CustomerID=BL.CustomerID AND S.PracticeID=BL.PracticeID AND S.BillBatchID=BL.BillBatchID AND S.BillID=Bl.BillID
GROUP BY S.CustomerID, S.BillBatchID, S.ConfirmedDate

SELECT SUM(NotInBizClaims) TotalBackLog
FROM #Detail

SELECT CAST(CONVERT(CHAR(10),ConfirmedDate,110) AS DATETIME) Dt, SUM(NotInBizClaims) BackLog
FROM #Detail
WHERE NotInBizClaims>0
GROUP BY CAST(CONVERT(CHAR(10),ConfirmedDate,110) AS DATETIME)
ORDER BY CAST(CONVERT(CHAR(10),ConfirmedDate,110) AS DATETIME)

SELECT D.CustomerID, CompanyName, SUM(NotInBizClaims) BackLog
FROM #Detail D INNER JOIN Customer C
ON D.CustomerID=C.CustomerID
GROUP BY D.CustomerID, CompanyName
HAVING SUM(NotInBizClaims)>0
ORDER BY SUM(NotInBizClaims) DESC, CompanyName

DROP TABLE #Submissions
DROP TABLE #BCLog
DROP TABLE #Detail