
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Doctor_Fname'
	AND object_id = Object_id(N'_import_2_2_ReferringProviders'))
BEGIN 
	ALTER TABLE [dbo].[_import_2_2_ReferringProviders] ADD Doctor_Fname VARCHAR(64) NULL 
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Doctor_Lname'
	AND object_id = Object_id(N'_import_2_2_ReferringProviders'))
BEGIN 
	ALTER TABLE [dbo].[_import_2_2_ReferringProviders] ADD Doctor_Lname VARCHAR(64) NULL 
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Doctor_Mname'
	AND object_id = Object_id(N'_import_2_2_ReferringProviders'))
BEGIN 
	ALTER TABLE [dbo].[_import_2_2_ReferringProviders] ADD Doctor_Mname VARCHAR(64) NULL 
END 	

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Doctor_Degree'
	AND object_id = Object_id(N'_import_2_2_ReferringProviders'))
BEGIN 
	ALTER TABLE [dbo].[_import_2_2_ReferringProviders] ADD Doctor_Degree VARCHAR(64) NULL 
END



UPDATE [dbo].[_import_2_2_ReferringProviders]
	SET Doctor_Fname = FirstName,
		Doctor_Lname = CASE WHEN LastName = '' THEN MiddleName ELSE LastName END ,
		Doctor_Mname = Case when LastName = '' THEN '' else MiddleName END ,
		Doctor_Degree = Degree
	FROM( 
		SELECT code, FirstName, MiddleName,
			SUBSTRING(LastNameStart,1,CHARINDEX(',', LastNameStart)) AS LastName,
			LTRIM(SUBSTRING(LastNameStart,CHARINDEX(',', LastNameStart)+1, 128)) AS Degree
		FROM (
			SELECT code, FirstName,
				SUBSTRING(MiddleNameStart, 1, CHARINDEX(' ', MiddleNameStart)) AS MiddleName,
				LTRIM(SUBSTRING(MiddleNameStart, CHARINDEX(' ', MiddleNameStart)+1,128)) AS LastNameStart 
			FROM(
				SELECT code, SUBSTRING(referringdocname, 1, CHARINDEX(' ', referringdocname)) AS FirstName,
					LTRIM(SUBSTRING(referringdocname, CHARINDEX(' ', referringdocname)+1,128)) AS MiddleNameStart
				From dbo.[_import_2_2_ReferringProviders]
				)fnStart
			 )mnStart
		)lnStart
WHERE lnStart.code = dbo.[_import_2_2_ReferringProviders].code AND
	dbo.[_import_2_2_ReferringProviders].Doctor_Lname IS NULL
	
		
UPDATE dbo.[_import_2_2_ReferringProviders]
	SET Doctor_Lname = REPLACE(Doctor_Lname, ',', '')
	WHERE Doctor_Lname IS NOT NULL 
	
	
	
