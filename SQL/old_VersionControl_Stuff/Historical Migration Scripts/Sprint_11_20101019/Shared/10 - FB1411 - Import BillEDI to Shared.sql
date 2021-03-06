DECLARE cust_cursor CURSOR READ_ONLY
FOR	
	SELECT DISTINCT C.CustomerId, C.DatabaseServerName, C.DatabaseName
	FROM dbo.Customer C
	WHERE C.DBActive = 1
	ORDER BY CustomerID

OPEN cust_cursor

DECLARE @CustomerId int
DECLARE @DatabaseName varchar(128)
DECLARE @DatabaseServerName varchar(128)
DECLARE @DatabasePath varchar(256)

DECLARE @sqlCmd varchar(8000)

FETCH NEXT FROM cust_cursor INTO @CustomerId, @DatabaseServerName, @DatabaseName

WHILE (@@FETCH_STATUS = 0)
BEGIN	
	IF (@@fetch_status <> -2)
	BEGIN
		SET @DatabasePath = COALESCE('[' + @DatabaseServerName + '].','') + COALESCE(@DatabaseName + '.','')
		--SET @DatabasePath = COALESCE(@DatabaseName + '.','')
		--PRINT 'Processing for database: ' + @DatabasePath

		SET @sqlCmd = '
		INSERT [SharedServer].[superbill_Shared].[dbo].[BizClaimsEDIBill] (
			CustomerID,
			BillID,
			BillStateCode,
			CreatedDate,
			ConfirmedDate)
		SELECT ' + CAST(@CustomerId AS varchar(20)) + ', EDI.BillId, EDI.BillStateCode, BB.CreatedDate, BB.ConfirmedDate
		FROM ' + @DatabasePath + '[dbo].[Bill_EDI] EDI
			INNER JOIN ' + @DatabasePath + '[dbo].[BillBatch] BB ON EDI.BillBatchID = BB.BillBatchID
		WHERE BillStateCode = ''R'' AND ConfirmedDate IS NOT NULL'
		
		exec(@sqlCmd)
		
	END
	FETCH NEXT FROM cust_cursor INTO @CustomerId, @DatabaseServerName, @DatabaseName
END

CLOSE cust_cursor
DEALLOCATE cust_cursor

