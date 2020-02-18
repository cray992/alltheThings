BEGIN TRAN

DECLARE @PracticeToCopyFrom  INT
DECLARE @PracticeToCopyTo INT
SET @PracticeToCopyFrom=115
SET @PracticeToCopyTo=116

DECLARE @TotalTemplates INT
DECLARE @TemplateCount INT

DECLARE @Templates TABLE(TID INT IDENTITY(1,1), EncounterTemplateID INT, Name VARCHAR(64), Description TEXT, PracticeID INT,
						 EncounterFormTypeID INT, ProcedureSortByCode BIT, DiagnosisSortByCode BIT)
INSERT @Templates(EncounterTemplateID, Name, Description, PracticeID, EncounterFormTypeID,
				  ProcedureSortByCode, DiagnosisSortByCode)
SELECT EncounterTemplateID, Name, Description, @PracticeToCopyTo PracticeID, EncounterFormTypeID, ProcedureSortByCode, DiagnosisSortByCode
FROM EncounterTemplate
WHERE PracticeID=@PracticeToCopyFrom

SET @TotalTemplates=@@ROWCOUNT
SET @TemplateCount=0

DECLARE @ExistingEncounterTemplateID INT
DECLARE @NewEncounterTemplateID INT

DECLARE @CPTCategories INT
DECLARE @CPTCategoryCount INT
DECLARE @ICD9Categories INT
DECLARE @ICD9CategoryCount INT

DECLARE @ExistingCPTCategoryID INT
DECLARE @NewCPTCategoryID INT
DECLARE @ExistingICD9CategoryID INT
DECLARE @NewICD9CategoryID INT

WHILE @TemplateCount<@TotalTemplates
BEGIN
	SET @TemplateCount=@TemplateCount+1

	SELECT @ExistingEncounterTemplateID=EncounterTemplateID
	FROM @Templates
	WHERE TID=@TemplateCount

	INSERT INTO EncounterTemplate(Name, Description, PracticeID, EncounterFormTypeID, ProcedureSortByCode, DiagnosisSortByCode)
	SELECT Name, Description, PracticeID, EncounterFormTypeID, ProcedureSortByCode, DiagnosisSortByCode
	FROM @Templates
	WHERE TID=@TemplateCount

	SET @NewEncounterTemplateID=@@IDENTITY

	CREATE TABLE #CPTCategories(TID INT IDENTITY(1,1), ProcedureCategoryID INT, Name VARCHAR(64))
	INSERT INTO #CPTCategories(ProcedureCategoryID, Name)
	SELECT ProcedureCategoryID, Name
	FROM ProcedureCategory
	WHERE EncounterTemplateID=@ExistingEncounterTemplateID

	SET @CPTCategories=@@ROWCOUNT
	SET @CPTCategoryCount=0

	WHILE @CPTCategoryCount<@CPTCategories
	BEGIN
		SET @CPTCategoryCount=@CPTCategoryCount+1

		SELECT @ExistingCPTCategoryID=ProcedureCategoryID
		FROM #CPTCategories
		WHERE TID=@CPTCategoryCount

		INSERT INTO ProcedureCategory(EncounterTemplateID, Name)
		SELECT @NewEncounterTemplateID, Name
		FROM #CPTCategories
		WHERE TID=@CPTCategoryCount

		SET @NewCPTCategoryID=@@IDENTITY

		INSERT INTO ProcedureCategoryToProcedureCodeDictionary(ProcedureCategoryID, ProcedureCodeDictionaryID)
		SELECT @NewCPTCategoryID, ProcedureCodeDictionaryID
		FROM ProcedureCategoryToProcedureCodeDictionary
		WHERE ProcedureCategoryID=@ExistingCPTCategoryID
	END

	DROP TABLE #CPTCategories
	
	CREATE TABLE #ICD9Categories(TID INT IDENTITY(1,1), DiagnosisCategoryID INT, Name VARCHAR(64))
	INSERT INTO #ICD9Categories(DiagnosisCategoryID, Name)
	SELECT DiagnosisCategoryID, Name
	FROM DiagnosisCategory
	WHERE EncounterTemplateID=@ExistingEncounterTemplateID

	SET @ICD9Categories=@@ROWCOUNT
	SET @ICD9CategoryCount=0

	WHILE @ICD9CategoryCount<@ICD9Categories
	BEGIN
		SET @ICD9CategoryCount=@ICD9CategoryCount+1
		
		SELECT @ExistingICD9CategoryID=DiagnosisCategoryID
		FROM #ICD9Categories
		WHERE TID=@ICD9CategoryCount

		INSERT INTO DiagnosisCategory(EncounterTemplateID, Name)
		SELECT @NewEncounterTemplateID, Name
		FROM #ICD9Categories
		WHERE TID=@ICD9CategoryCount

		SET @NewICD9CategoryID=@@IDENTITY

		INSERT INTO DiagnosisCategoryToDiagnosisCodeDictionary(DiagnosisCategoryID, DiagnosisCodeDictionaryID)
		SELECT @NewICD9CategoryID, DiagnosisCodeDictionaryID
		FROM DiagnosisCategoryToDiagnosisCodeDictionary
		WHERE DiagnosisCategoryID=@ExistingICD9CategoryID
	END

	DROP TABLE #ICD9Categories

	UPDATE Doctor SET DefaultEncounterTemplateID=@NewEncounterTemplateID
	WHERE PracticeID=@PracticeToCopyTo AND DefaultEncounterTemplateID=@ExistingEncounterTemplateID
END

--COMMIT TRAN
--ROLLBACK



