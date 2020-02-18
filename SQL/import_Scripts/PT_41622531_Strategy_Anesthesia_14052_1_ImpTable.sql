

IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'pat_FirstName'
	AND OBJECT_ID = OBJECT_ID(N'_import_1_1_PatientGuarantorsandInsur'))
BEGIN	
	ALTER TABLE [_import_1_1_PatientsGuarantorsandInsur] ADD pat_FirstName VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'pat_LastName'
	AND OBJECT_ID = OBJECT_ID(N'_import_1_1_PatientGuarantorsandInsur'))
BEGIN	
	ALTER TABLE [_import_1_1_PatientsGuarantorsandInsur] ADD pat_LastName VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'pat_Middle'
	AND OBJECT_ID = OBJECT_ID(N'_import_1_1_PatientGuarantorsandInsur'))
BEGIN	
	ALTER TABLE [_import_1_1_PatientsGuarantorsandInsur] ADD pat_Middle VARCHAR(64) NULL
END 

UPDATE dbo.[_import_1_1_PatientsGuarantorsandInsur]
	SET pat_FirstName = FirstName,
		pat_Middle = MiddleName,
		pat_LastName = LastName
FROM(
	SELECT id, LastName,
		SUBSTRING(REST, 1,2) AS MiddleName, 
		REPLACE(SUBSTRING(RIGHT(REST, LEN(REST)-2)  , 1, 50), ' ', '') AS FirstName		
	FROM (
		SELECT id, REPLACE(SUBSTRING(patientname,1, CHARINDEX(',', patientname)), ',', '') AS LastName,
					REPLACE(LTRIM(SUBSTRING(patientname,CHARINDEX(',',patientname), 255)), ',', '') AS REST,
					patientname
					FROM dbo.[_import_1_1_PatientsGuarantorsandInsur]
		)ptStart
	)ptFullName
WHERE ptFullName.ID = dbo.[_import_1_1_PatientsGuarantorsandInsur].ID 




IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'insured1First'
	AND OBJECT_ID = OBJECT_ID(N'_import_1_1_PatientGuarantorsandInsur'))
BEGIN	
	ALTER TABLE [_import_1_1_PatientsGuarantorsandInsur] ADD insured1First VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'insured1Last'
	AND OBJECT_ID = OBJECT_ID(N'_import_1_1_PatientGuarantorsandInsur'))
BEGIN	
	ALTER TABLE [_import_1_1_PatientsGuarantorsandInsur] ADD insured1Last VARCHAR(64) NULL
END 


UPDATE dbo.[_import_1_1_PatientsGuarantorsandInsur]
	SET insured1First = FirstName,
		insured1Last = LastName
FROM(
	SELECT id, REPLACE(SUBSTRING([1insuredname],1, CHARINDEX(',', [1insuredname])), ',', '') AS LastName,
				REPLACE(LTRIM(SUBSTRING([1insuredname],CHARINDEX(',',[1insuredname]), 255)), ',', '') AS FirstName,
				[1insuredname]
				FROM dbo.[_import_1_1_PatientsGuarantorsandInsur]
	)ptFullName
WHERE ptFullName.[1insuredname] <> '' AND ptFullName.ID = dbo.[_import_1_1_PatientsGuarantorsandInsur].ID






IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'insured2First'
	AND OBJECT_ID = OBJECT_ID(N'_import_1_1_PatientGuarantorsandInsur'))
BEGIN	
	ALTER TABLE [_import_1_1_PatientsGuarantorsandInsur] ADD insured2First VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'insured2Last'
	AND OBJECT_ID = OBJECT_ID(N'_import_1_1_PatientGuarantorsandInsur'))
BEGIN	
	ALTER TABLE [_import_1_1_PatientsGuarantorsandInsur] ADD insured2Last VARCHAR(64) NULL
END 


UPDATE dbo.[_import_1_1_PatientsGuarantorsandInsur]
	SET insured2First = FirstName,
		insured2Last = LastName
FROM(
	SELECT id, REPLACE(SUBSTRING([2insuredname],1, CHARINDEX(',', [2insuredname])), ',', '') AS LastName,
				REPLACE(LTRIM(SUBSTRING([2insuredname],CHARINDEX(',',[2insuredname]), 255)), ',', '') AS FirstName,
				[2insuredname]
				FROM dbo.[_import_1_1_PatientsGuarantorsandInsur]
	)ptFullName
WHERE ptFullName.[2insuredname] <> '' AND ptFullName.ID = dbo.[_import_1_1_PatientsGuarantorsandInsur].ID
