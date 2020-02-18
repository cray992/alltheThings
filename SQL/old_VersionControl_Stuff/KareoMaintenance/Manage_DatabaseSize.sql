USE [KareoMaintenance]
GO

/****** Object:  StoredProcedure [dbo].[Manage_DatabaseSize]    Script Date: 05/25/2012 08:21:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Manage_DatabaseSize]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Manage_DatabaseSize]
GO


/****** Object:  StoredProcedure [dbo].[Manage_DatabaseSize]    Script Date: 05/25/2012 08:21:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET XACT_ABORT ON	
GO	
CREATE PROC [dbo].[Manage_DatabaseSize] 

AS 	
	
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
SET  Servername=c.DatabaseServerName
FROM SHAREDSERVER.KareoMaintenance.dbo.Manage_DatabaseSpace s
INNER JOIN SHAREDSERVER.superbill_shared.dbo.Customer AS c ON s.DatabaseName=c.DatabaseName
WHERE s.ServerName IS Null

DROP TABLE  #DBInfo


GO


