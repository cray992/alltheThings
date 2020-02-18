DECLARE @Loop INT
DECLARE @Count INT
DECLARE @CustomerID INT
DECLARE @DoctorID INT
DECLARE @ProviderTypeID INT
DECLARE @DatabaseName VARCHAR(50)
DECLARE @DatabaseServerName VARCHAR(50)

DECLARE @SQL VARCHAR(MAX)
DECLARE @ExecSQL VARCHAR(MAX)

SET @SQL='
UPDATE [{0}].{1}.dbo.Doctor SET ProviderTypeID={3}
WHERE DoctorID={2}
'

CREATE TABLE #DBs(RID INT IDENTITY(1,1), DatabaseServerName VARCHAR(50), DatabaseName VARCHAR(50), CustomerID INT, CompanyName VARCHAR(128))
INSERT INTO #DBs(DatabaseServerName, DatabaseName, CustomerID, CompanyName)
SELECT DatabaseServerName, DatabaseName, CustomerID, CompanyName
FROM Customer
WHERE DBActive=1 AND CustomerType='N' AND Metrics=1

SET @Loop=@@ROWCOUNT
SET @Count=0

DECLARE @InnerLoop INT
DECLARE @InnerCount INT

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @CustomerID=CustomerID, 
	@DatabaseName=DatabaseName, @DatabaseServerName=DatabaseServerName
	FROM #DBs
	WHERE RID=@Count

	CREATE TABLE #Providers(RID INT IDENTITY(1,1), DoctorID INT, ProviderTypeID INT)
	INSERT INTO #Providers(DoctorID, ProviderTypeID)
	SELECT DoctorID, ProviderTypeID
	FROM ProviderTypeSettingsImportII
	WHERE CustomerID=@CustomerID

	SET @InnerLoop=@@ROWCOUNT
	SET @InnerCount=0

	WHILE @InnerCount<@InnerLoop
	BEGIN
		SET @InnerCount=@InnerCount+1
		SELECT @DoctorID=DoctorID, @ProviderTypeID=ProviderTypeID
		FROM #Providers
		WHERE RID=@InnerCount

		SET @ExecSQL=REPLACE(@SQL,'{0}',@DatabaseServerName)
		SET @ExecSQL=REPLACE(@ExecSQL,'{1}',@DatabaseName)
		SET @ExecSQL=REPLACE(@ExecSQL,'{2}',@DoctorID)
		SET @ExecSQL=REPLACE(@ExecSQL,'{3}',@ProviderTypeID)

		PRINT @DatabaseName
		EXEC(@ExecSQL)
	END

	DROP TABLE #Providers

END

DROP TABLE #DBs