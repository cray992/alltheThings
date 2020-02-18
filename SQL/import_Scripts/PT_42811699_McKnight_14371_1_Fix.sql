UPDATE dbo.[_import_3_1_AppointmentSchedule]
SET begtm = REPLACE(begtm, 'A/P', ''),
	endtm = REPLACE(endtm, 'A/P', '')

DELETE FROM dbo.[_import_3_1_PolicyHolder] WHERE autotempid = 1894
DELETE FROM dbo.[_import_3_1_PolicyHolder] WHERE autotempid = 313


UPDATE dbo.[_import_3_1_PatientDemo]
SET patname = patname+ ' '

IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'patfirstname'
	AND OBJECT_ID = OBJECT_ID(N'_import_3_1_PatientDemo'))
BEGIN	
	ALTER TABLE [_import_3_1_PatientDemo] ADD patfirstname VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'patmiddlename'
	AND OBJECT_ID = OBJECT_ID(N'_import_3_1_PatientDemo'))
BEGIN	
	ALTER TABLE [_import_3_1_PatientDemo] ADD patmiddlename VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'patlastname'
	AND OBJECT_ID = OBJECT_ID(N'_import_3_1_PatientDemo'))
BEGIN	
	ALTER TABLE [_import_3_1_PatientDemo] ADD patlastname VARCHAR(64) NULL
END 


UPDATE dbo.[_import_3_1_PatientDemo]
	SET patfirstname = firstname,
		patmiddlename = middlename,
		patlastname = lastname
FROM(
	SELECT AutoTempid, lastname, rest, 
		SUBSTRING(LTRIM(rest), 1, CHARINDEX(' ', rest)) AS firstname,
		REPLACE(SUBSTRING(rest, CHARINDEX(' ', rest), 2), ' ', '') AS middlename
	FROM (
		SELECT AutoTempid, REPLACE(SUBSTRING(patname, 1, CHARINDEX(',', patname)), ',', '') AS lastname,
			LTRIM(REPLACE(SUBSTRING(patname, CHARINDEX(',', patname), 250), ',', '')) AS rest,
			patname
		FROM dbo.[_import_3_1_PatientDemo]
		)alpha
	)beta
WHERE beta.AutoTempid = dbo.[_import_3_1_PatientDemo].AutoTempid







---Policy Demos

IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'patfirstname'
	AND OBJECT_ID = OBJECT_ID(N'_import_3_1_PolicyHolder'))
BEGIN	
	ALTER TABLE [_import_3_1_PolicyHolder] ADD patfirstname VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'patmiddlename'
	AND OBJECT_ID = OBJECT_ID(N'_import_3_1_PolicyHolder'))
BEGIN	
	ALTER TABLE [_import_3_1_PolicyHolder] ADD patmiddlename VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'patlastname'
	AND OBJECT_ID = OBJECT_ID(N'_import_3_1_PolicyHolder'))
BEGIN	
	ALTER TABLE [_import_3_1_PolicyHolder] ADD patlastname VARCHAR(64) NULL
END 

UPDATE dbo.[_import_3_1_PolicyHolder]
SET name = name+ ' '

IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'polfirstname'
	AND OBJECT_ID = OBJECT_ID(N'_import_3_1_PolicyHolder'))
BEGIN	
	ALTER TABLE [_import_3_1_PolicyHolder] ADD polfirstname VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'polmiddlename'
	AND OBJECT_ID = OBJECT_ID(N'_import_3_1_PolicyHolder'))
BEGIN	
	ALTER TABLE [_import_3_1_PolicyHolder] ADD polmiddlename VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'pollastname'
	AND OBJECT_ID = OBJECT_ID(N'_import_3_1_PolicyHolder'))
BEGIN	
	ALTER TABLE [_import_3_1_PolicyHolder] ADD pollastname VARCHAR(64) NULL
END 


UPDATE dbo.[_import_3_1_PolicyHolder]
	SET polfirstname = firstname,
		polmiddlename = middlename,
		pollastname = lastname
FROM(
	SELECT AutoTempid, lastname, rest, 
		SUBSTRING(LTRIM(rest), 1, CHARINDEX(' ', rest)) AS firstname,
		REPLACE(SUBSTRING(rest, CHARINDEX(' ', rest), 2), ' ', '') AS middlename
	FROM (
		SELECT AutoTempid, REPLACE(SUBSTRING(name, 1, CHARINDEX(',', name)), ',', '') AS lastname,
			LTRIM(REPLACE(SUBSTRING(name, CHARINDEX(',', name), 250), ',', '')) AS rest,
			name
		FROM dbo.[_import_3_1_PolicyHolder]
		)alpha
	)beta
WHERE beta.AutoTempid = dbo.[_import_3_1_PolicyHolder].AutoTempid