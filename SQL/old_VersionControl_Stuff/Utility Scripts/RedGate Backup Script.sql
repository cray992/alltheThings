DECLARE @Loop INT
DECLARE @Count INT

DECLARE @AllDBs TABLE(DatabaseName VARCHAR(128), CustomerID INT)
INSERT INTO @AllDBs(DatabaseName, CustomerID)
SELECT ISNULL(DatabaseName,sd.Name) DatabaseName, C.CustomerID
FROM sys.databases sd LEFT JOIN superbill_shared..Customer C
ON sd.Name=C.DatabaseName
WHERE (C.DatabaseName IS NULL OR (C.DatabaseName IS NOT NULL AND DBActive=1)) AND sd.Name<>'tempdb'

--If its Sat then do all dbs, otherwise don't do any customer dbs which have not been logged into within a day
IF DATEPART(DW,GETDATE())<>7
BEGIN
	DECLARE @LastLogin TABLE(CustomerID INT)
	INSERT @LastLogin(CustomerID)
	SELECT CustomerID
	FROM superbill_shared..LoginHistory
	GROUP BY CustomerID
	HAVING DATEDIFF(D,GETDATE(),MAX(LoginDate))<1

	DELETE DB
	FROM @AllDBs DB LEFT JOIN @LastLogin LL
	ON DB.CustomerID=LL.CustomerID
	WHERE LL.CustomerID IS NULL AND DB.CustomerID IS NOT NULL
END

DECLARE @DBs TABLE(TID INT IDENTITY(1,1), DatabaseName VARCHAR(128))
INSERT INTO @DBs(DatabaseName)
SELECT DatabaseName
FROM @AllDBs

SET @Loop=@@ROWCOUNT
SET @Count=0

DECLARE @DatabaseName VARCHAR(128)
DECLARE @Type CHAR(1)

DECLARE @SQL VARCHAR(8000)
DECLARE @ExSQL VARCHAR(8000)
SET @ExSQL=''
SET @SQL='master..sqlbackup ''-SQL "BACKUP DATABASE [{DBNAME}]  
		TO DISK = ''''G:\Backup_SQL\<AUTO>'''' 
		WITH NAME = ''''Database ({DBNAME}) {DATE}'''',  
		DESCRIPTION = ''''Backup on {DATE}  Database: {DBNAME}  Server: KPROD-DB06'''', 
		MIRRORFILE = ''''\\kprod-nas01\backup\production_sql_daily_full\<AUTO>'''',
		PASSWORD = ''''<ENCRYPTEDPASSWORD>cwM6aNLmZ3RgsQYwm1Y=</ENCRYPTEDPASSWORD>'''', KEYSIZE = 256, 
		MAILTO_ONERROR = ''''secalerts@kareo.com'''', 
		ERASEFILES_ATSTART = 5,
		COMPRESSION = 2" '''

WHILE @COUNT<@LOOP
BEGIN
	SET @COUNT=@COUNT+1

	SELECT @DatabaseName=DatabaseName
	FROM @DBs
	WHERE TID=@COUNT

	SET @ExSQL=REPLACE(REPLACE(REPLACE(REPLACE(@SQL,'{DBNAME}',@DatabaseName),'{DATE}',CONVERT(varchar(40),GETDATE(),109)),CHAR(13)+CHAR(10),' '),CHAR(9),' ')

	EXEC(@ExSQL)
END

