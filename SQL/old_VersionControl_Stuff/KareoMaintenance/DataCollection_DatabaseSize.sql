
	SET XACT_ABORT ON
GO
	
	
	SET NOCOUNT ON
DECLARE @CurrentDB  INT,            --Current RowNum we're working on in the #DBInfo table
        @DBCount    INT,            --Total count of rows in the #DBInfo table
        @DBName	VARCHAR(50)
        
        
CREATE TABLE #DBInfo
        (
        RowNum      INT             IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
        [DatabaseID]      INT             NOT NULL,
        DBName      VARCHAR(128)    NOT NULL,
        DBSizeMB    DECIMAL(19,4)   NOT NULL,
        DBGroup     TINYINT         NOT NULL DEFAULT 0
       
        )
;        
        

INSERT INTO #DBInfo
SELECT	  dp.DatabaseID ,
		  dp.DatabaseName ,
          dp.DataMB,
          dp.GroupId
       
FROM KareoMaintenance.dbo.Database_Partitions AS dp
INNER JOIN SHAREDSERVER.superbill_shared.dbo.customer AS customer ON dp.DatabaseName = customer.DatabaseName
WHERE dp.DatabaseName like'%superbill%' And dp.DatabaseName Not like '%shared%'
ORDER BY DataMB DESC
;

DECLARE @Date DATETIME
SET @Date=GETDATE()
SET @Date=CAST(@Date AS VARCHAR(16))


--===== Preset the variables
 SELECT @DBCount    = MAX(RowNum),
        @CurrentDB  = 1
   FROM #DBInfo

;

DECLARE @SQL VARCHAR(MAX)

 WHILE @CurrentDB <= @DBCount
	BEGIN
  
  

		Select @DBName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB); 
		
PRINT @DBName
SET @SQL=('select
	[FileSizeMB]	=
		convert(numeric(10,2),sum(round(a.size/128.,2))),
        [UsedSpaceMB]	=
		convert(numeric(10,2),sum(round(fileproperty( a.name,''SpaceUsed'')/128.,2))) ,
        [UnusedSpaceMB]	=
		convert(numeric(10,2),sum(round((a.size-fileproperty( a.name,''SpaceUsed''))/128.,2))) ,
	[Type] =
		case when a.groupid is null then '''' when a.groupid = 0 then ''Log'' else ''Data'' end,
	[DBFileName]	= isnull(a.name,''*** Total for all files ***''),
	
	[DatabaseName]= '''+@DBName+'''
	
	
	
from
	sysfiles a
group by
	groupid,
	a.name
	with rollup
having
	a.groupid is null or
	a.name is not null
order by
	case when a.groupid is null then 99 when a.groupid = 0 then 0 else 1 end,
	a.groupid,
	case when a.name is null then 99 else 0 end,
	a.name
')

INSERT INTO SHAREDSERVER.KareoMaintenance.dbo.Manage_DatabaseSpace(FileSizeMB, UsedSpaceMB, UnusedSpaceMB,FileType, DBFileName, DatabaseName)
		EXEC('USE '+@DBName +'; '+ @SQL );

		 --===== Get ready to read the next file row
		 SELECT @CurrentDB = @CurrentDB + 1
;

	END

UPDATE s
SET PercentUnusedSpace=UnusedSpaceMB/FileSizeMB, Servername=c.DatabaseServerName
FROM SHAREDSERVER.KareoMaintenance.dbo.Manage_DatabaseSpace s
INNER JOIN SHAREDSERVER.superbill_shared.dbo.Customer AS c ON s.DatabaseName=c.DatabaseName
WHERE PercentUnusedSpace IS Null

DROP TABLE  #DBInfo

SET XACT_ABORT OFF
GO

--CREATE  TABLE Manage_DatabaseSpace(FileSizeMB DECIMAL(12,2), UsedSpaceMB DECIMAL(12,2), UnusedSpaceMB Decimal(12,2),PercentUnusedSpace Decimal(12,2), FileType VARCHAR(10), DBFileName VARCHAR(32), DatabaseName VARCHAR(32), DateChecked DateTime DEFAULT Getdate())
--SELECT *
--FROM Manage_DatabaseSpace
--WHERE FileType='Data' AND (PercentUnusedSpace>.7 OR PercentUnusedSpace<.2)
--ORDER BY PercentUnusedSpace DESC


--UPDATE s
--SET s.ServerName=c.DatabaseServerName
