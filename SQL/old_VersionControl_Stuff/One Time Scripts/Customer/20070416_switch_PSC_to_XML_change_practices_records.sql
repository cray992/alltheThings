/*	THIS ACTION IS BEING DUPLICATED IN A MIGRATION SCRIPT

	USE superbill_shared

	DECLARE @UserEmailAddress varchar(64)
	SET @UserEmailAddress = 'bizclaims@kareo.com'

	DECLARE @UserId int

	-- see what Customer DBs are within User's reach:
	SELECT @UserId = U.UserID
	FROM dbo.Users U
	WHERE U.EmailAddress = @UserEmailAddress

	DECLARE @t_customers TABLE (
		UserID int,
		CustomerID int,
		CompanyName varchar(256)
	)

--	DECLARE @t_PatientStatementsPassword TABLE (
--		[AccountId] varchar(128), 
--		[Password] varchar(128),
--		[CustomerID] int,
--		[PracticeID] int
--	)

	DECLARE @sqlCmd varchar(8000)
	SET @sqlCmd = 'dbo.Shared_AuthenticationDataProvider_GetUserCustomers ' + CAST(@UserId AS varchar(30))

	INSERT @t_customers --( UserID, CustomerID, CompanyName )
	exec(@sqlCmd)

	-- SELECT * FROM @t_customers ORDER BY CustomerID

	DECLARE @t_values TABLE (
		CustomerID int,
		CompanyName varchar(256)
	)

	INSERT @t_values (CustomerID, CompanyName)
		 (SELECT TC.CustomerID, TC.CompanyName FROM @t_customers TC
				 LEFT OUTER JOIN Customer C ON C.CustomerID = TC.CustomerID
				 LEFT OUTER JOIN ClearinghouseConnection CC ON C.ClearinghouseConnectionID =  CC.ClearinghouseConnectionID)


	DECLARE @EFormatId int
	SELECT TOP 1 @EFormatId=PatientStatementsFormatId FROM PatientStatementsFormat WHERE PatientStatementsVendorId=3 AND GoodForElectronic=1

	print '@EFormatId=' + CAST(@EFormatId AS varchar)

	DECLARE @DatabaseName varchar(128)
	DECLARE @DatabaseServerName varchar(128)
	DECLARE @DatabasePath varchar(256)

	DECLARE cust_cursor CURSOR READ_ONLY
	FOR	
		SELECT DISTINCT C.CustomerId, C.DatabaseServerName, C.DatabaseName
		FROM @t_customers TC
		JOIN dbo.Customer C ON C.CustomerID = TC.CustomerID --AND C.CustomerID > 979
		WHERE C.DBActive = 1

	OPEN cust_cursor

	DECLARE @CustomerId int

	FETCH NEXT FROM cust_cursor INTO @CustomerId, @DatabaseServerName, @DatabaseName

	WHILE (@@FETCH_STATUS = 0)
	BEGIN	
		IF (@@fetch_status <> -2)
		BEGIN
			SET @DatabasePath = '[' + COALESCE(@DatabaseServerName + '].','') + COALESCE(@DatabaseName + '.dbo','')
			PRINT 'Processing for database: ' + @DatabasePath

--			SET @sqlCmd = '
--				SELECT    ' + CAST(@CustomerId AS VARCHAR(100)) + ' as CustomerID, PR.PracticeID, PR.EStatementsLogin, PR.Name, EStatementsPreferredPrintFormatId, EStatementsPreferredElectronicFormatId' 
--				+ ' FROM  ' + @DatabasePath + '.Practice PR WHERE PR.EnrolledForEStatements=1 AND PR.EStatementsVendorId=3 AND PR.Active=1'

			SET @sqlCmd = 'UPDATE ' + @DatabasePath + '.Practice SET EStatementsPreferredElectronicFormatId=' + CAST(@EFormatId AS varchar) + ' WHERE EStatementsVendorId=3'

			--PRINT 'SQL: ' + @sqlCmd
			exec(@sqlCmd)

		END
		FETCH NEXT FROM cust_cursor INTO @CustomerId, @DatabaseServerName, @DatabaseName
	END

	CLOSE cust_cursor
	DEALLOCATE cust_cursor

*/