	CREATE TABLE #results (CustomerID int, CustomerName varchar(100), PracticeName varchar(100), FullName varchar(200), FirstName varchar(100), MiddleName varchar(100), LastName varchar(100), Degree varchar(100), FirstEncounterDate datetime, LastEncounterDate datetime, FirstNonReadyClaimDate datetime)
	
	DECLARE @CustomerID int
	DECLARE @CustomerName varchar(100)
	DECLARE @DatabaseName varchar(128)
	DECLARE @sql varchar(8000)
	
	DECLARE cross_report_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.CustomerID, C.CompanyName, C.DatabaseName
			FROM dbo.Customer C
			WHERE DBActive = 1 AND CustomerType = 'N' --AND CustomerID=14

	OPEN cross_report_cursor
	
	FETCH NEXT FROM cross_report_cursor INTO @CustomerID, @CustomerName, @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			PRINT 'Processing for database: ' + @DatabaseName
					--update the records that are common and have changed

			SET @sql = 'INSERT INTO #results 
				     SELECT ' + CAST(@CustomerID as varchar) + ', ''' + REPLACE(@CustomerName,'''','''''') +''',
					P.Name,
					' + @DatabaseName + '.dbo.fn_FormatFirstMiddleLast(D.FirstName,D.MiddleName,D.LastName) + COALESCE('', ''+D.Degree,'''') AS FullName,
					D.FirstName,
					COALESCE(D.MiddleName,''''),
					D.LastName,
					COALESCE(D.Degree,''''),
					MIN(E.CreatedDate),
					MAX(E.CreatedDate),
					MIN(C.CreatedDate)
				    FROM ' + @DatabaseName + '.dbo.Doctor D
					INNER JOIN ' + @DatabaseName + '.dbo.Practice P on D.PracticeID = P.PracticeID
					LEFT OUTER JOIN ' + @DatabaseName + '.dbo.Encounter E on E.DoctorID = D.DoctorID
					LEFT OUTER JOIN ' + @DatabaseName + '.dbo.EncounterProcedure EP on EP.EncounterID = E.EncounterID
					LEFT OUTER JOIN ' + @DatabaseName + '.dbo.Claim C on C.EncounterProcedureID = EP.EncounterProcedureID
				    WHERE D.[External] = 0 AND P.Active = 1 AND P.Name <> ''American Medicine Associates''
					AND C.ClaimID IS NULL OR C.ClaimStatusCode <> ''R''
				    GROUP BY P.Name, D.FirstName,D.MiddleName,D.LastName,D.Degree ORDER BY P.Name'

			--PRINT 'Cust ' + CAST(@CustomerID as varchar) + ':' + @sql

			EXEC (@sql)

		END
		FETCH NEXT FROM cross_report_cursor INTO @CustomerID, @CustomerName, @DatabaseName
	END
	CLOSE cross_report_cursor
	DEALLOCATE cross_report_cursor

	SELECT * FROM #results

	DROP TABLE #results
