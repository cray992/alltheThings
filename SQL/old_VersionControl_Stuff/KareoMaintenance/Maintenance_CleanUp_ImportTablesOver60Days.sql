USE KareoMaintenance
GO
IF EXISTS(SELECT * FROM sys.objects AS o WHERE name='Maintenance_CleanUp_ImportTablesOver60Days' AND type='p')
DROP PROC Maintenance_CleanUp_ImportTablesOver60Days
GO

CREATE PROCEDURE Maintenance_CleanUp_ImportTablesOver60Days



AS 
/*
This procedure checks all databases to see if there are tables created over 60 days ago that are named _import_


*/

SET NOCOUNT ON
DECLARE @CurrentDB  INT,            --Current RowNum we're working on in the #DBInfo table
        @DBCount    INT,            --Total count of rows in the #DBInfo table
        @DBName	VARCHAR(50),
        @Command Varchar(512)
        
        
CREATE TABLE #DBInfo
        (
        RowNum      INT             IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
        DBName      VARCHAR(128)    NOT NULL,
                )
;        
        

INSERT INTO #DBInfo
SELECT	dp.DatabaseName
FROM KareoMaintenance.dbo.Database_Partitions AS dp
INNER JOIN SHAREDSERVER.Superbill_Shared.dbo.Customer AS c WITH (NOLOCK) ON dp.DatabaseName = c.DatabaseName
WHERE c.Cancelled=0 AND c.DBActive=1
ORDER BY dp.DatabaseName
;

--===== Preset the variables
 SELECT @DBCount    = MAX(RowNum),
        @CurrentDB  = 1
   FROM #DBInfo

;

 WHILE @CurrentDB <= @DBCount
	BEGIN
  
  

		Select @DBName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB); 
			PRINT @DBName

			CREATE TABLE #DBS(DatabaseName VARCHAR(128), TableName VARCHAR(64))
				INSERT INTO #DBs
					EXEC('USE '+@DBName +'; '+ 'SELECT Distinct db_name(), o.name
								FROM Sys.objects AS o
								WHERE name LIKE ''_import%'' AND type=''U'' AND o.create_date<DATEADD(dd,-60,GETDATE())
								');
				
								

			IF EXISTS(SELECT * FROM #DBs)
			BEGIN 
			CREATE TABLE #Command(Command VARCHAR(512))


			INSERT INTO #Command
			EXEC('SELECT ''USE '' +DatabaseName+ '' Drop Table ''+ TableName FROM #DBS')
			


						
			SET @Command=(SELECT TOP 1 Command FROM #Command ORDER BY #Command.Command)		
					WHILE  @Command IS NOT NULL
						BEGIN 
						EXECUTE(@Command)
						
						DELETE #Command WHERE #Command.Command=@Command
						SET @Command=(SELECT TOP 1 Command FROM #Command ORDER BY #Command.Command)
						END 

			DROP TABLE #Command
			END
			DROP TABLE #DBS
					 --===== Get ready to read the next file row
					 SELECT @CurrentDB = @CurrentDB + 1
			;

	END



DROP TABLE  #DBInfo


GO
