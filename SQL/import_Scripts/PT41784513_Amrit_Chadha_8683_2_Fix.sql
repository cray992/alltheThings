

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[_import_2_2_CaseInformation2](
	[ID] [int] NOT NULL,
	[insurancecompany] [varchar](max) NULL,
	[name] [varchar](max) NULL,
	[insname] [varchar](max) NULL,
	[relation] [varchar](max) NULL,
	[precedence] [varchar](max) NULL,
	[addr1] [varchar](max) NULL,
	[addr2] [varchar](max) NULL,
	[city] [varchar](max) NULL,
	[hmphone] [varchar](max) NULL,
	[dayphone] [varchar](max) NULL,
	[gen] [varchar](max) NULL,
	[birthdt] [varchar](max) NULL,
	[patage] [varchar](max) NULL,
	[act] [varchar](max) NULL,
	[coperc] [varchar](max) NULL,
	[poleff] [varchar](max) NULL,
	[defcob] [varchar](max) NULL,
	[encratelib] [varchar](max) NULL,
	[insfirstname] [varchar](64) NULL,
	[insmiddlename] [varchar](64) NULL,
	[inslastname] [varchar](64) NULL,
	[firstname] [varchar](64) NULL,
	[middlename] [varchar](64) NULL,
	[lastname] [varchar](64) NULL,
	[inscity] [varchar](64) NULL,
	[insstate] [varchar](64) NULL,
	[inszip] [varchar](64) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO






INSERT INTO dbo.[_import_2_2_CaseInformation2]
        ( ID ,
          insurancecompany ,
          name ,
          insname ,
          relation ,
          precedence ,
          addr1 ,
          addr2 ,
          city ,
          hmphone ,
          dayphone ,
          gen ,
          birthdt ,
          patage ,
          act ,
          coperc ,
          poleff ,
          defcob ,
          encratelib
        )
SELECT    pol.ID , -- ID - nchar(10)
          pol.insurancecompany , -- insurancecompany - nchar(10)
          pol.name , -- name - nchar(10)
          pol.insname , -- insname - nchar(10)
          pol.relation , -- relation - nchar(10)
          ROW_NUMBER() OVER (PARTITION BY pol.name ORDER BY pol.name, pol.defcob) , -- encob - nchar(10)
          pol.addr1, -- addr1 - nchar(10)
          pol.addr2 , -- addr2 - nchar(10)
          pol.city , -- city - nchar(10)
          pol.hmphone , --hmphone - nchar(10)
          pol.dayphone , -- dayphone - nchar(10)
          pol.gen , -- gen - nchar(10)
          pol.birthdt , -- birthdt - nchar(10)
          pol.patage , -- patage - nchar(10)
          pol.act , -- act - nchar(10)
          pol.coperc , -- coperc - nchar(10)
          pol.poleff , -- poleff - nchar(10)
          pol.defcob , -- defcob - nchar(10)
          pol.encratelib  -- encratelib - nchar(10)
FROM dbo.[_import_2_2_CaseInformation] pol

SELECT * FROM dbo.[_import_2_2_CaseInformation2]

--- Insurance Company

IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'payercity'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_InsuranceList'))
BEGIN	
	ALTER TABLE [_import_2_2_InsuranceList] ADD payercity VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'payerstate'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_InsuranceList'))
BEGIN	
	ALTER TABLE [_import_2_2_InsuranceList] ADD payerstate VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'payerzip'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_InsuranceList'))
BEGIN	
	ALTER TABLE [_import_2_2_InsuranceList] ADD payerzip VARCHAR(64) NULL
END 

UPDATE dbo.[_import_2_2_InsuranceList]
	SET payercity = city,
		payerstate = pstate,
		payerzip = zip
FROM(
	SELECT id, city, 
		REPLACE(SUBSTRING(REST, 1,3), ' ', '') AS pstate , 
		dbo.fn_RemoveNonNumericCharacters(rest) AS zip		
	FROM (
		SELECT id, REPLACE(SUBSTRING(citystatezip,1, CHARINDEX(',', citystatezip)), ',', '') AS city,
					REPLACE(LTRIM(SUBSTRING(citystatezip,CHARINDEX(',',citystatezip), 255)), ',', '') AS REST,
					citystatezip
					FROM dbo.[_import_2_2_InsuranceList]
		)ptStart
	)ptaddress
WHERE ptaddress.ID = dbo.[_import_2_2_InsuranceList].ID 


UPDATE dbo.[_import_2_2_PatientDemographics]
SET patname = patname+ ' '


---Patient Demos

IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'patfirstname'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_PatientDemographics'))
BEGIN	
	ALTER TABLE [_import_2_2_PatientDemographics] ADD patfirstname VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'patmiddlename'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_PatientDemographics'))
BEGIN	
	ALTER TABLE [_import_2_2_PatientDemographics] ADD patmiddlename VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'patlastname'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_PatientDemographics'))
BEGIN	
	ALTER TABLE [_import_2_2_PatientDemographics] ADD patlastname VARCHAR(64) NULL
END 


UPDATE dbo.[_import_2_2_PatientDemographics]
	SET patfirstname = firstname,
		patmiddlename = middlename,
		patlastname = lastname
FROM(
	SELECT id, lastname, rest, 
		SUBSTRING(LTRIM(rest), 1, CHARINDEX(' ', rest)) AS firstname,
		REPLACE(SUBSTRING(rest, CHARINDEX(' ', rest), 2), ' ', '') AS middlename
	FROM (
		SELECT id, REPLACE(SUBSTRING(patname, 1, CHARINDEX(',', patname)), ',', '') AS lastname,
			LTRIM(REPLACE(SUBSTRING(patname, CHARINDEX(',', patname), 250), ',', '')) AS rest,
			patname
		FROM dbo.[_import_2_2_PatientDemographics]
		)alpha
	)beta
WHERE beta.id = dbo.[_import_2_2_PatientDemographics].id


----Referring Doctors

IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'reffirstname'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_ReferringPhysician'))
BEGIN	
	ALTER TABLE [_import_2_2_ReferringPhysician] ADD reffirstname VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'reflastname'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_ReferringPhysician'))
BEGIN	
	ALTER TABLE [_import_2_2_ReferringPhysician] ADD reflastname VARCHAR(64) NULL
END 


UPDATE dbo.[_import_2_2_ReferringPhysician]
	SET reffirstname = firstname,
		reflastname = lastname
FROM(
	SELECT id, REPLACE(SUBSTRING(name, 1, CHARINDEX(',', name)), ',', '') AS lastname,
		LTRIM(REPLACE(SUBSTRING(name, CHARINDEX(',', name), 250), ',', '')) AS firstname ,
		name
	FROM dbo.[_import_2_2_ReferringPhysician]
	)beta
WHERE beta.id = dbo.[_import_2_2_ReferringPhysician].id





---Policy INS
UPDATE dbo.[_import_2_2_CaseInformation2]
SET insname = insname+ ' ',
	name = name + ' '

IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'insfirstname'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_CaseInformation2'))
BEGIN	
	ALTER TABLE [_import_2_2_CaseInformation2] ADD insfirstname VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'insmiddlename'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_CaseInformation2'))
BEGIN	
	ALTER TABLE [_import_2_2_CaseInformation2] ADD insmiddlename VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'inslastname'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_CaseInformation2'))
BEGIN	
	ALTER TABLE [_import_2_2_CaseInformation2] ADD inslastname VARCHAR(64) NULL
END 


UPDATE dbo.[_import_2_2_CaseInformation2]
	SET insfirstname = fname,
		insmiddlename = mname,
		inslastname = lname
FROM(
	SELECT id, lname, rest, 
		SUBSTRING(LTRIM(rest), 1, CHARINDEX(' ', rest)) AS fname,
		REPLACE(SUBSTRING(rest, CHARINDEX(' ', rest), 2), ' ', '') AS mname
	FROM (
		SELECT id, REPLACE(SUBSTRING(insname, 1, CHARINDEX(',', insname)), ',', '') AS lname,
			LTRIM(REPLACE(SUBSTRING(insname, CHARINDEX(',', insname), 250), ',', '')) AS rest,
			insname
		FROM dbo.[_import_2_2_CaseInformation2]
		)alpha
	)beta
WHERE beta.id = dbo.[_import_2_2_CaseInformation2].id



IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'firstname'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_CaseInformation2'))
BEGIN	
	ALTER TABLE [_import_2_2_CaseInformation2] ADD firstname VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'middlename'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_CaseInformation2'))
BEGIN	
	ALTER TABLE [_import_2_2_CaseInformation2] ADD middlename VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'lastname'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_CaseInformation2'))
BEGIN	
	ALTER TABLE [_import_2_2_CaseInformation2] ADD lastname VARCHAR(64) NULL
END 

UPDATE dbo.[_import_2_2_CaseInformation2]
	SET firstname = fname,
		middlename = mname,
		lastname = lname
FROM(
	SELECT id, lname, rest, 
		SUBSTRING(LTRIM(rest), 1, CHARINDEX(' ', rest)) AS fname,
		REPLACE(SUBSTRING(rest, CHARINDEX(' ', rest), 2), ' ', '') AS mname
	FROM (
		SELECT id, REPLACE(SUBSTRING(name, 1, CHARINDEX(',', name)), ',', '') AS lname,
			LTRIM(REPLACE(SUBSTRING(name, CHARINDEX(',', name), 250), ',', '')) AS rest,
			name
		FROM dbo.[_import_2_2_CaseInformation2]
		)alpha
	)beta
WHERE beta.id = dbo.[_import_2_2_CaseInformation2].id




IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'inscity'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_CaseInformation2'))
BEGIN	
	ALTER TABLE [_import_2_2_CaseInformation2] ADD inscity VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'insstate'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_CaseInformation2'))
BEGIN	
	ALTER TABLE [_import_2_2_CaseInformation2] ADD insstate VARCHAR(64) NULL
END 
IF NOT EXISTS(SELECT * FROM sys.columns  WHERE name = N'inszip'
	AND OBJECT_ID = OBJECT_ID(N'_import_2_2_CaseInformation2'))
BEGIN	
	ALTER TABLE [_import_2_2_CaseInformation2] ADD inszip VARCHAR(64) NULL
END 

UPDATE dbo.[_import_2_2_CaseInformation2]
	SET inscity = incity,
		insstate = istate,
		inszip = zip
FROM(
	SELECT id, incity, 
		REPLACE(SUBSTRING(REST, 1,3), ' ', '') AS istate , 
		dbo.fn_RemoveNonNumericCharacters(rest) AS zip		
	FROM (
		SELECT id, REPLACE(SUBSTRING(city,1, CHARINDEX(',', city)), ',', '') AS incity,
					REPLACE(LTRIM(SUBSTRING(city,CHARINDEX(',',city), 255)), ',', '') AS REST,
					city
					FROM dbo.[_import_2_2_CaseInformation2]
		)ptStart
	)ptaddress
WHERE ptaddress.ID = dbo.[_import_2_2_CaseInformation2].ID 


