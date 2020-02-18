DECLARE @Loop INT
DECLARE @Count INT
DECLARE @CustomerID INT
DECLARE @CompanyName VARCHAR(128)
DECLARE @DatabaseName VARCHAR(50)
DECLARE @DatabaseServerName VARCHAR(50)

CREATE TABLE #Providers(RID INT IDENTITY(1,1), CustomerID INT, CompanyName VARCHAR(128), PracticeID INT, PracticeName VARCHAR(128), DoctorID INT, ProviderFullName VARCHAR(256),
						Queried BIT)

DECLARE @SQL VARCHAR(MAX)
DECLARE @ExecSQL VARCHAR(MAX)

SET @SQL='
INSERT INTO #Providers(CustomerID, CompanyName, PracticeID, PracticeName, DoctorID, ProviderFullName, Queried)
SELECT {2} CustomerID, ''{3}'' CompanyName, P.PracticeID, P.Name PracticeName, D.DoctorID, D.FirstName+COALESCE('' ''+D.MiddleName+'' '','' '')+D.LastName ProviderFullName, 0 Queried
FROM [{0}].{1}.dbo.Doctor D INNER JOIN [{0}].{1}.dbo.Practice P
ON D.PracticeID=P.PracticeID
WHERE D.[External]=0 AND D.ActiveDoctor=1 AND P.Active=1 AND P.Metrics=1'

CREATE TABLE #DBs(RID INT IDENTITY(1,1), DatabaseServerName VARCHAR(50), DatabaseName VARCHAR(50), CustomerID INT, CompanyName VARCHAR(128))
INSERT INTO #DBs(DatabaseServerName, DatabaseName, CustomerID, CompanyName)
SELECT DatabaseServerName, DatabaseName, CustomerID, CompanyName
FROM Customer
WHERE DBActive=1 AND CustomerType='N' AND Metrics=1

SET @Loop=@@ROWCOUNT
SET @Count=0

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @CustomerID=CustomerID, @CompanyName=CompanyName,
	@DatabaseName=DatabaseName, @DatabaseServerName=DatabaseServerName
	FROM #DBs
	WHERE RID=@Count

	SET @ExecSQL=REPLACE(@SQL,'{0}',@DatabaseServerName)
	SET @ExecSQL=REPLACE(@ExecSQL,'{1}',@DatabaseName)
	SET @ExecSQL=REPLACE(@ExecSQL,'{2}',@CustomerID)
	SET @ExecSQL=REPLACE(@ExecSQL,'{3}',REPLACE(@CompanyName,'''',''''''))

	PRINT @DatabaseName

	EXEC(@ExecSQL)
END

SELECT @Loop=COUNT(*) FROM #Providers
SET @Count=0

DECLARE @DoctorID INT
DECLARE @PracticeName VARCHAR(128)
DECLARE @ProviderFullName VARCHAR(256)

DECLARE @KareoProviderID INT

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @CustomerID=CustomerID, @DoctorID=DoctorID, @CompanyName=CompanyName, @PracticeName=PracticeName,
	@ProviderFullName=ProviderFullName
	FROM #Providers
	WHERE RID=@Count

	IF NOT EXISTS(SELECT * FROM KareoProviderToDoctor KPD INNER JOIN KareoProvider KP
						   ON KPD.KareoProviderID=KP.KareoProviderID
						   WHERE KP.CustomerID=@CustomerID AND KPD.DoctorID=@DoctorID)
	BEGIN
		INSERT INTO KareoProvider(CustomerID, ProviderFullName)
		VALUES(@CustomerID, @ProviderFullName)

		SET @KareoProviderID=SCOPE_IDENTITY()

		INSERT INTO KareoProviderToDoctor(KareoProviderID, CustomerID, DoctorID)
		VALUES(@KareoProviderID, @CustomerID, @DoctorID)

		INSERT INTO KareoProviderToDoctor(KareoProviderID, CustomerID, DoctorID)
		SELECT @KareoProviderID, @CustomerID, DoctorID
		FROM #Providers
		WHERE CustomerID=@CustomerID AND DoctorID<>@DoctorID AND dbo.fn_MatchPercent(ProviderFullName,@ProviderFullName,1)>=80

		UPDATE P SET Queried=1
		FROM #Providers P INNER JOIN KareoProvider KP
		ON P.CustomerID=KP.CustomerID
		INNER JOIN KareoProviderToDoctor KPD
		ON KP.KareoProviderID=KPD.KareoProviderID AND P.DoctorID=KPD.DoctorID
		WHERE P.CustomerID=@CustomerID AND KP.KareoProviderID=@KareoProviderID
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT * FROM #Providers WHERE DoctorID=@DoctorID AND CustomerID=@CustomerID AND Queried=1)
		BEGIN
			SELECT @KareoProviderID=KP.KareoProviderID
			FROM KareoProvider KP INNER JOIN KareoProviderToDoctor KPD
			ON KP.KareoProviderID=KPD.KareoProviderID
			WHERE KP.CustomerID=@CustomerID AND KPD.DoctorID=@DoctorID

			INSERT INTO KareoProviderToDoctor(KareoProviderID, CustomerID, DoctorID)
			SELECT @KareoProviderID, @CustomerID, P.DoctorID
			FROM #Providers P LEFT JOIN KareoProviderToDoctor KPD
			ON P.DoctorID=KPD.DoctorID AND KPD.KareoProviderID=@KareoProviderID
			WHERE CustomerID=@CustomerID AND dbo.fn_MatchPercent(ProviderFullName,@ProviderFullName,1)>=80
			AND Queried=0 AND KPD.DoctorID IS NULL

			UPDATE P SET Queried=1
			FROM #Providers P INNER JOIN KareoProvider KP
			ON P.CustomerID=KP.CustomerID
			INNER JOIN KareoProviderToDoctor KPD
			ON KP.KareoProviderID=KPD.KareoProviderID AND P.DoctorID=KPD.DoctorID
			WHERE P.CustomerID=@CustomerID AND KP.KareoProviderID=@KareoProviderID AND P.Queried=0
		END
	END
	

	PRINT CAST(@CustomerID AS VARCHAR)+' -['+@CompanyName
END

DROP TABLE #DBs
DROP TABLE #Providers



