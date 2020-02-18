USE superbill_18706_prod

SELECT * FROM dbo.[_import_1_1_PatientDemographics] ORDER BY AutoTempID
SELECT * FROM dbo.[_import_1_1_Guarantor]
SELECT * FROM dbo.[_import_1_1_Appointments]

UPDATE dbo.[_import_1_1_Appointments]
	SET starttime = starttime + 'M',
		endtime = endtime + 'M'

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_1_1_PatientDemographics' AND COLUMN_NAME = 'patientFirstName')
BEGIN

  ALTER TABLE [dbo].[_import_1_1_PatientDemographics]  ADD patientFirstName varchar(128) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_1_1_PatientDemographics' AND COLUMN_NAME = 'patientMiddleName')
BEGIN

  ALTER TABLE [dbo].[_import_1_1_PatientDemographics]  ADD patientMiddleName varchar(128) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_1_1_PatientDemographics' AND COLUMN_NAME = 'patientLastName')
BEGIN

  ALTER TABLE [dbo].[_import_1_1_PatientDemographics]  ADD patientLastName varchar(128) NULL
END




UPDATE dbo.[_import_1_1_PatientDemographics]
	SET patientFirstName = FirstName,
		patientMiddleName = MiddleName,
		patientLastName = LastName 
	FROM (SELECT chartnumber, LastName, 
				CASE WHEN CHARINDEX(' ', rest, 0) = 0 THEN rest else	REPLACE(LEFT(rest, CHARINDEX(' ', rest, 0)), ' ', '') END AS FirstName, 
				case when charindex(' ', rest, 0) = 0 THEN '' ELSE LTRIM(SUBSTRING(rest, CHARINDEX(' ', rest, 0)+1, 255)) END AS MiddleName, patientfullname
			FROM(Select chartnumber, 
				   REPLACE(LEFT(patientFullName, CHARINDEX(',', patientFullName, 0)), ',', '') AS LastName, 
				   LTRIM(SUBSTRING(patientFullName, CHARINDEX(',', patientFullName, 0)+1, 255)) AS rest,   patientFullName
			     FROM dbo.[_import_1_1_PatientDemographics] WHERE patientFullName <> ''
			 )blah
		)Blahblah
	WHERE blahblah.chartnumber= dbo.[_import_1_1_PatientDemographics].chartnumber 




IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_1_1_Guarantor' AND COLUMN_NAME = 'guarantorfirst')
BEGIN

  ALTER TABLE [dbo].[_import_1_1_Guarantor]  ADD guarantorfirst varchar(128) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_1_1_Guarantor' AND COLUMN_NAME = 'guarantormiddle')
BEGIN

  ALTER TABLE [dbo].[_import_1_1_Guarantor]  ADD guarantormiddle varchar(128) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_1_1_Guarantor' AND COLUMN_NAME = 'guarantorlast')
BEGIN

  ALTER TABLE [dbo].[_import_1_1_Guarantor]  ADD guarantorlast varchar(128) NULL
END




UPDATE dbo.[_import_1_1_Guarantor]
	SET guarantorfirst = FirstName,
		guarantormiddle = MiddleName,
		guarantorlast = LastName 
	FROM (SELECT patientchartnumber, LastName, 
				CASE WHEN CHARINDEX(' ', rest, 0) = 0 THEN rest else	REPLACE(LEFT(rest, CHARINDEX(' ', rest, 0)), ' ', '') END AS FirstName, 
				case when charindex(' ', rest, 0) = 0 THEN '' ELSE LTRIM(SUBSTRING(rest, CHARINDEX(' ', rest, 0)+1, 255)) END AS MiddleName, guarantorlastname
			FROM(Select patientchartnumber, 
				   REPLACE(LEFT(guarantorlastname, CHARINDEX(',', guarantorlastname, 0)), ',', '') AS LastName, 
				   LTRIM(SUBSTRING(guarantorlastname, CHARINDEX(',', guarantorlastname, 0)+1, 255)) AS rest,   guarantorlastname
			     FROM dbo.[_import_1_1_Guarantor] WHERE guarantorlastname <> ''
			 )blah
		)Blahblah
	WHERE blahblah.patientchartnumber= dbo.[_import_1_1_Guarantor].patientchartnumber 
