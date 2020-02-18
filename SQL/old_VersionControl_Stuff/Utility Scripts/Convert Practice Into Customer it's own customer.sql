-------- Objective is to take a practice from the Source Customer and restore OVER an existing table
-------- Requirement
--------		1. Create a new Customer Account with appropriate information
--------		2. Clean the security settings (if needed) use. C:\SVN\Superbill\Software\Data\Script\Utility Scripts\20070808 Security - Remove Users from accessing a practice.sql
--------		SELECT * FROM practice
/*


select databaseServerName, * from sharedserver.superbill_shared.dbo.customer where customerId in (902, 4104 )

*/


DECLARE 
	@SourceCustomerID INT,
	@TargetCustomerID INT,
	@PracticeID INT,
	@Backup_Path VARCHAR(MAX),
	@TargetDatabaseFile_Data_Path VARCHAR(MAX),
	@TargetDatabaseFile_Log_Path VARCHAR(MAX),
	@backupSourceDB BIT,
	@restorSourceDB BIT,
	@deleteOtherPractices BIT,
	@migrationXdbName VARCHAR(MAX),
	@useRedGateBackup BIT,
	@dropNonStandardTables BIT,
	@copySecuritySettings BIT,
	@updateBizClaimCustomerMap BIT,
	@SetDBActive bit,
	@RemoveUserPractices BIT,
	@setFaxNumber bit

declare @setClaimSettingEdition int

-- kprod-db11				K:\kprod_db11_data01\SqlData, SqlLog
-- kprod-db12				L:\kprod_db12_data01\SqlData, SqlLog
-- kprod-db10, kprod-db09	J:\sqlData, K:\sqlLog

SELECT 	
	@SourceCustomerID = 902,			
	@TargetCustomerID = 4104,		-- MD BILLING SERVICE
	@PracticeID = 8,				-- select * from practice
	@Backup_Path = 'D:\StageDataCopies',
	@TargetDatabaseFile_Data_Path = 'K:\SqlData',
	@TargetDatabaseFile_Log_Path = 'K:\SqlLog',

	@backupSourceDB = 0,
	@restorSourceDB = 0,
	@updateBizClaimCustomerMap = 1,
	@setFaxNumber  = 1,
	@setClaimSettingEdition = 1,
	
	@useRedGateBackup=1,
	@dropNonStandardTables = 0,
	@copySecuritySettings = 0,
	@deleteOtherPractices = 0,
	@SetDBActive = 0,
	@RemoveUserPractices = 0,
	@migrationXdbName = 'migrationX'


DECLARE
	@SourceDatabaseName VARCHAR(MAX),
	@TargetDatabaseName VARCHAR(MAX),
	@SourceServerName varchar(max)



select databaseserverName, customerId, companyName, 'select count(*) from [' + databaseServerName + '].[' + databaseName + '].dbo.practice'
from sharedserver.superbill_shared.dbo.customer
where customerID in (@SourceCustomerID, @TargetCustomerID)



---------------------------PHASE 1 -  Backup source & restore -----------
-------------------------------------------------------------------------

		SELECT @SourceDatabaseName = DatabaseName, @SourceServerName = DatabaseServerName
		FROM [SHAREDSERVER].superbill_shared.dbo.customer
		WHERE CustomerID = @SourceCustomerID

		SELECT @TargetDatabaseName = DatabaseName
		FROM [SHAREDSERVER].superbill_shared.dbo.customer
		WHERE CustomerID = @TargetCustomerID

if @SourceServerName='kprod-db12'
	set @SourceServerName = 'kprod-db12\db12'
if @TargetDatabaseName='kprod-db12'
	set @TargetDatabaseName = 'kprod-db12\db12'

if @SourceServerName='kprod-db11'
	set @SourceServerName = 'kprod-db11\db11'
if @TargetDatabaseName='kprod-db11'
	set @TargetDatabaseName = 'kprod-db11\db11'


		DECLARE 
			@Logical_Data VARCHAR(500), 
			@Logical_Log VARCHAR(500),
			@SQL VARCHAR(8000),
			@EXSQL VARCHAR(8000),
			@currentDate DATETIME

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SET @currentDate = GETDATE()


		CREATE TABLE #Files(Type CHAR(1), Name VARCHAR(128))

		SET @SQL='INSERT INTO #Files(Type, Name) 
				  SELECT CASE WHEN Type=0 THEN ''D'' ELSE ''L'' END Type, Name
				  FROM [{1}].{0}.sys.database_files'

		SET @EXSQL=REPLACE(@SQL,'{0}',@SourceDatabaseName)
		SET @EXSQL=REPLACE(@EXSQL,'{1}',@SourceServerName)
		EXEC(@EXSQL)

		SELECT @Logical_Data=Name
		FROM #Files
		WHERE Type='D'

		SELECT @Logical_Log=Name
		FROM #Files
		WHERE Type='L'

		DROP TABLE #Files


		IF @useRedGateBackup = 1
			BEGIN

					----------------- RED GATE BACKUP ---------------
					SET @SQL='master..sqlbackup ''-SQL "BACKUP DATABASE [{DBNAME}]  
							TO DISK = ''''{dbBackupFileLocation}\{DBNAME}.sqb'''' 
							WITH NAME = ''''Database ({DBNAME}) {DATE}'''',  
							DESCRIPTION = ''''Backup on {DATE}  Database: {DBNAME}  Server: KPROD-DB08'''', 
							COMPRESSION = 2, COPY_ONLY, INIT " '''
					
							
							SET @EXSQL = REPLACE(@SQL,'{DBNAME}',@SourceDatabaseName)
							SET @EXSQL = REPLACE(@EXSQL,'{dbBackupFileLocation}',@Backup_Path)
							SET @EXSQL = REPLACE(@EXSQL,'{DATE}',CONVERT(varchar(40),GETDATE(),109))
							set @EXSQL = REPLACE(@EXSQL,CHAR(13)+CHAR(10),' ')
							set @EXSQL = REPLACE(@EXSQL,CHAR(9),' ')

			END

		ELSE
			BEGIN
					------------------- Regular SQL Backup -------------------
					SET @SQL='	BACKUP DATABASE {1}
								TO DISK=N''{0}\{1}.bak''
								WITH INIT, COPY_ONLY'

					SET @EXSQL=REPLACE(@SQL,'{0}',@Backup_Path)
					SET @EXSQL=REPLACE(@EXSQL,'{1}',@SourceDatabaseName)	

			END



-------- backup source
IF @backupSourceDB = 1 
BEGIN
	EXEC(@EXSQL)
END


		IF @useRedGateBackup = 1
			BEGIN
			----------------------- RED GATE RESTORE -------------
					SET @sql='master..sqlbackup ''-sql "RESTORE DATABASE [{DBTarget}] 
							FROM disk = [{dbBackupFileLocation}\{DBNAME}.sqb] 
							WITH	MOVE [{dbDataFile}] TO [{dbDataFileLocation}\{DBTarget}_data.mdf], 
									MOVE [{dbLogFile}] TO [{dbLogFileLocation}\{DBTarget}_log.ldf],
									REPLACE "'''
			
			
							SET @EXSQL = REPLACE(@sql,'{DBNAME}',@SourceDatabaseName)
							SET @EXSQL = REPLACE(@EXSQL,'{DBTarget}',@TargetDatabaseName)
							SET @EXSQL = REPLACE(@EXSQL,'{dbBackupFileLocation}',@Backup_Path)
							SET @EXSQL = REPLACE(@EXSQL,'{dbDataFile}',@Logical_Data)
							SET @EXSQL = REPLACE(@EXSQL,'{dbLogFile}',@Logical_Log)
							SET @EXSQL = REPLACE(@EXSQL,'{dbDataFileLocation}',@TargetDatabaseFile_Data_Path)
							SET @EXSQL = REPLACE(@EXSQL,'{dbLogFileLocation}',@TargetDatabaseFile_Log_Path)
							SET @EXSQL = REPLACE(@EXSQL,'{DATE}',CONVERT(varchar(40),GETDATE(),109))
							set @EXSQL = REPLACE(@EXSQL,CHAR(13)+CHAR(10),' ')
							set @EXSQL = REPLACE(@EXSQL,CHAR(9),' ')


			END
		ELSE 
			BEGIN
					SET	@SQL = 'RESTORE DATABASE {0}
							FROM DISK=''{1}\{2}.bak''
							WITH MOVE ''{3}'' TO ''{5}\{0}_data.mdf'', MOVE ''{4}'' TO ''{6}\{0}_log.ldf'', REPLACE'

					SET @EXSQL = @SQL
					SET @EXSQL = REPLACE(@EXSQL,'{0}',@TargetDatabaseName)
					SET @EXSQL = REPLACE(@EXSQL,'{1}',@Backup_Path)
					SET @EXSQL = REPLACE(@EXSQL,'{2}',@SourceDatabaseName)
					SET @EXSQL = REPLACE(@EXSQL,'{3}',@Logical_Data)
					SET @EXSQL = REPLACE(@EXSQL,'{4}',@Logical_Log)
					SET @EXSQL = REPLACE(@EXSQL,'{5}',@TargetDatabaseFile_Data_Path)
					SET @EXSQL = REPLACE(@EXSQL,'{6}',@TargetDatabaseFile_Log_Path)
			END






--------- restores target (OVERWRITES)
IF @restorSourceDB = 1
BEGIN

print @EXSQL
	EXEC(@EXSQL)

END

--------- Removes users who don't belong in the practice --------
IF @RemoveUserPractices = 1
BEGIN
	SET @SQL = 'delete {dbName}.dbo.UserPractices
				WHERE PracticeID <> {PracticeID}'
	SET @EXSQL = @SQL
	SET @EXSQL = REPLACE(@EXSQL,'{dbName}',@TargetDatabaseName)
	SET @EXSQL = REPLACE(@EXSQL,'{PracticeID}',@PracticeID)

	print @EXSQL
	EXEC( @EXSQL )
END




--------- Makes Copy of Security Settings --------
IF @copySecuritySettings = 1
	EXEC [SHAREDSERVER].superbill_shared.dbo.Shared_AuthenticationDataProvider_CopySecuritySettings @SourceCustomerID, @TargetCustomerID, @PracticeID



-------- Drop non-standard tables -------------
-------------------------------------------------------------------------



			DECLARE @i INT, @cntPracticeID INT, @count INT


			-- get rid of some stupid tables
			CREATE TABLE #TableToDrop( rowID INT IDENTITY(1,1), tableName VARCHAR(8000), create_date datetime )
			DECLARE @tableName VARCHAR(8000)


			IF @dropNonStandardTables =1
			BEGIN
				SET @EXSQL = '
					INSERT INTO #TableToDrop( tableName, create_Date )
					SELECT s.NAME, s.create_Date
					FROM {0}.sys.tables s
						LEFT JOIN [SHAREDSERVER].[CustomerModelPrepopulated].sys.tables c on c.Name = s.Name AND c.Type = ''U''
					WHERE (s.NAME like ''%_1'' AND s.TYPE = ''U'')
						OR c.Name is NULL
					ORDER BY s.create_Date DESC
					'
				
				SET @EXSQL = REPLACE(@EXSQL,'{0}',@TargetDatabaseName)
				EXEC (@EXSQL)

				SELECT @count = COUNT(*) FROM #TableToDrop
				SELECT @i = 0, @count=ISNULL(@count, 0)
				SELECT @SQL = 'drop table {0}.dbo.[{1}]'

				WHILE @i < @count
				BEGIN
						SET @i = @i + 1

						SELECT @tableName = tableName
						FROM  #TableToDrop
						WHERE rowID = @i

						SET @EXSQL = @SQL
						SET @EXSQL = REPLACE(@EXSQL,'{0}',@TargetDatabaseName)
						SET @EXSQL = REPLACE(@EXSQL,'{1}',@tableName)	

						PRINT @EXSQL
						EXEC ( @EXSQL )
				END
			END 

			DROP TABLE #TableToDrop


---------------------------------------------------
---------------------------------------------------
------------ Need to create a table???? -----------
			
	IF @updateBizClaimCustomerMap = 1
	BEGIN

				-- Migration Encounter so that bizClaim knows about the new DB target
					SET @SQL = 
					'INSERT INTO [SharedServer].[superbill_Shared].dbo.CustomerMapEncounter( FromCustomerID, EncounterID, ClaimID, ToCustomerID )
					SELECT {1} AS FromCustomerID, e.EncounterID, c.ClaimID, {2} ToCustomerID 
					FROM {0}.dbo.encounter e
					INNER JOIN {0}.dbo.encounterProcedure ep 
						ON e.practiceID = ep.PracticeID 
						AND e.EncounterID = ep.EncounterID
					INNER JOIN {0}.dbo.claim c 
						ON c.[PracticeID] = ep.[PracticeID]
						AND c.[EncounterProcedureID] = ep.[EncounterProcedureID]
					LEFT JOIN [SharedServer].[superbill_Shared].dbo.CustomerMapEncounter b
						on b.FromCustomerID = {1}
						AND b.EncounterID = e.EncounterID
						AND c.ClaimID = b.ClaimID
					WHERE e.pRacticeID = {3}
						AND b.FromCustomerID is null'


				SET @EXSQL = @SQL
				SET @EXSQL = REPLACE(@EXSQL,'{0}',@TargetDatabaseName)
				SET @EXSQL = REPLACE(@EXSQL,'{1}',@SourceCustomerID)
				SET @EXSQL = REPLACE(@EXSQL,'{2}',@TargetCustomerID)
				SET @EXSQL = REPLACE(@EXSQL,'{3}',@PracticeID)
				SET @EXSQL = REPLACE(@EXSQL,'{4}',@migrationXdbName)

		PRINT @EXSQL
		EXEC( @EXSQL )





				-- Migrate the Bill EDI Stuff
					SET @SQL = 
					'INSERT INTO [SharedServer].[superbill_Shared].dbo.CustomerMapBillEDI( FromCustomerID,  [BillBatchID], [BillID], ToCustomerID )
					SELECT {1} AS FromCustomerID, bb.BillBatchID, bedi.BillID, {2} AS ToCustomerID
					FROM {0}.dbo.Bill_EDI bedi
						INNER JOIN {0}.dbo.BillBatch bb 
							ON bb.[BillBatchID] = bedi.[BillBatchID]
						LEFT JOIN [SharedServer].[superbill_Shared].dbo.CustomerMapBillEDI b 
							on b.FromCustomerID = {1} 
							and bb.BillBatchID =b.BillBatchID
							AND bedi.BillID = b.BillID		
					WHERE bb.[PracticeID] = {3}
						AND b.FromCustomerID IS NULL'


				SET @EXSQL = @SQL
				SET @EXSQL = REPLACE(@EXSQL,'{0}',@TargetDatabaseName)
				SET @EXSQL = REPLACE(@EXSQL,'{1}',@SourceCustomerID)
				SET @EXSQL = REPLACE(@EXSQL,'{2}',@TargetCustomerID)
				SET @EXSQL = REPLACE(@EXSQL,'{3}',@PracticeID)
				SET @EXSQL = REPLACE(@EXSQL,'{4}',@migrationXdbName)

		PRINT @EXSQL
		EXEC( @EXSQL )







				-- Migrate the Practice Mapping.
					SET @SQL = 
					'INSERT INTO [SharedServer].[superbill_Shared].dbo.CustomerMapPractice( FromCustomerID,  practiceID, ToCustomerID )
					SELECT {1} AS FromCustomerID, p.PracticeID, {2} AS ToCustomerID
					FROM {0}.dbo.Practice p
						LEFT JOIN [SharedServer].[superbill_Shared].dbo.CustomerMapPractice b on b.PracticeID = p.practiceID AND b.FromCustomerID = {1}
					WHERE 
						p.PracticeID = {3}
						AND b.FromCustomerID IS NULL
					'


				SET @EXSQL = @SQL
				SET @EXSQL = REPLACE(@EXSQL,'{0}',@TargetDatabaseName)
				SET @EXSQL = REPLACE(@EXSQL,'{1}',@SourceCustomerID)
				SET @EXSQL = REPLACE(@EXSQL,'{2}',@TargetCustomerID)
				SET @EXSQL = REPLACE(@EXSQL,'{3}',@PracticeID)
				SET @EXSQL = REPLACE(@EXSQL,'{4}',@migrationXdbName)

		PRINT @EXSQL
		EXEC( @EXSQL )



	END


--------Strip target DB of all practices except @PracticeID -------------
-------------------------------------------------------------------------



					SET @SQL = '{0}.dbo.GeneralDataProvider_DeleteAllPractice {3}, 0'
					SET @EXSQL = @SQL
					SET @EXSQL = REPLACE(@EXSQL,'{0}',@TargetDatabaseName)
					SET @EXSQL = REPLACE(@EXSQL,'{3}',@PracticeID)



IF @deleteOtherPractices = 1 
	EXEC( @EXSQL )
			








IF @setDBActive = 1 
begin
	SET @SQL = 'update sharedserver.superbill_shared.dbo.customer
				SET DBActive = 1
				WHERE CustomerID = {3}'
	SET @EXSQL = @SQL
	SET @EXSQL = REPLACE(@EXSQL,'{3}',@TargetCustomerID)

	print @EXSQL
	EXEC( @EXSQL )
END
			
IF @setFaxNumber=1
	AND exists(select * 
				from sharedserver.superbill_shared.dbo.FaxDNISCustomerPractice 	
				WHERE customerID=@SourceCustomerID
					and practiceID=@practiceID
		) 
BEGIN



	-- Insert the DNIS we are about to reassign to the history table
	INSERT INTO sharedserver.superbill_shared.dbo.FaxDNISHistory (DateDeleted, DNIS, CustomerID, PracticeID)
	SELECT getdate(), DNIS, CustomerID, PracticeID
	FROM sharedserver.superbill_shared.dbo.FaxDNISCustomerPractice
	WHERE customerID=@SourceCustomerID
		and practiceID=@practiceID

	-- Reassign the DNIS to the new customer
	UPDATE sharedserver.superbill_shared.dbo.FaxDNISCustomerPractice
	SET CustomerID = @TargetCustomerID, CreatedDate=getdate()
	WHERE customerID=@SourceCustomerID
		and practiceID=@practiceID


	-- Associate the k-fax account with the new customer
	INSERT INTO sharedserver.superbill_shared.dbo.CustomerUsers (CustomerID, UserID)
	SELECT CustomerID, 1526 as UserID
	FROM sharedserver.superbill_shared.dbo.Customer c
	WHERE CustomerID = @TargetCustomerID
		AND NOT exists(select * from sharedserver.superbill_shared.dbo.CustomerUsers cu 
				where c.customerID=cu.customerID and userID=1526)
		

END


IF @setClaimSettingEdition=1
BEGIN

	declare @claimSettingEdition int

	select @claimSettingEdition=claimSettingEdition
	from sharedserver.superbill_shared.dbo.customer
	where customerID=@SourceCustomerID

	update sharedserver.superbill_shared.dbo.customer
	set claimSettingEdition=@claimSettingEdition
	where customerID = @TargetCustomerID

END



print '==================================================='
print '=====Complete: ' + @TargetDatabaseName + ' ================='
print '==================================================='


