
SET NOCOUNT ON
DECLARE @CurrentDB  INT,            --Current RowNum we're working on in the #DBInfo table
        @DBCount    INT,            --Total count of rows in the #DBInfo table
        @DBName	VARCHAR(50),
		@ServerName VARCHAR(128),
		@SQL VARCHAR(MAX)

CREATE TABLE #DBInfo
        (
        RowNum      INT             IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
        DBName      VARCHAR(128)    NOT NULL,
		ServerName	VARCHAR(128) NOT NULL     
        )
;        
  
INSERT INTO #DBInfo
        ( DBName, ServerName)
SELECT DISTINCT DatabaseName, Servername
FROM SharedServer.superbill_shared.dbo.ReportCustomersToUpdate




 SELECT @DBCount    = MAX(RowNum),
        @CurrentDB  = 1
   FROM #DBInfo

;


 WHILE @CurrentDB <= @DBCount
 BEGIN 

 	Select @DBName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB); 
	Select @ServerName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB); 


SET @SQL=(
'UPDATE R
SET Reportparameters=rctu.GoodParams
FROM SharedServer.superbill_shared.dbo.ReportCustomersToUpdate RCTU WITH (NOLOCK)
INNER JOIN '+ @ServerName+'.'+@DbName+'dbo.Report R ON R.Name=RCTu.ReportName AND Rctu.BadParams=CAST(R.ReportParameters AS VARCHAR(Max))
AND'+ @DbName+'=rctu.databasename')



 SELECT @CurrentDB = @CurrentDB + 1
;

	END

