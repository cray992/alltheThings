
GO
SET NOCOUNT ON
DECLARE @CurrentDB  INT,            --Current RowNum we're working on in the #DBInfo table
        @DBCount    INT,            --Total count of rows in the #DBInfo table
        @DBName	VARCHAR(50)
        
        
        
CREATE TABLE #DBInfo
        (
        RowNum      INT             IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
        [DatabaseID]      INT             NOT NULL,
        DBName      VARCHAR(128)    NOT NULL
       
        )
;        
        

INSERT INTO #DBInfo(DatabaseID,DBName)
SELECT	d.database_id, d.name
       
FROM Sys.databases AS d
WHERE d.is_quoted_identifier_on=0
AND d.name NOT IN ('Master','Tempdb','MSDB', 'Model')
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
		
		EXEC('ALTER DATABASE '+@DBName + ' SET QUOTED_IDENTIFIER ON WITH NO_WAIT'
);

		 --===== Get ready to read the next file row
		 SELECT @CurrentDB = @CurrentDB + 1
;

	END


DROP TABLE  #DBInfo

