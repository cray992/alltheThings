DECLARE @StartDate DATETIME, @EndDate DATETIME
DECLARE @CustomerID INT
SET @StartDate='1-1-10'
SELECT @CustomerID=CASE WHEN CHARINDEX('demo',DB_NAME())<>0 THEN 14 ELSE CAST(SUBSTRING(DB_NAME(),11,4) AS INT) END

WHILE @StartDate<=GETDATE()
BEGIN
	SET @EndDate=DATEADD(D,-1,DATEADD(M,1,@StartDate))

	SELECT @StartDate, @EndDate
	
	EXEC dbo.BillDataProvider_RecordBillRejections @CustomerID, @StartDate, @EndDate	

	SET @StartDate=DATEADD(M,1,@StartDate)
END

