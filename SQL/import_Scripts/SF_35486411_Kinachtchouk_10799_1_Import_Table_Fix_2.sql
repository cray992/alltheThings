USE superbill_10799_dev
--USE superbill_10799_prod
go

DBCC CHECKIDENT('dbo.Patient', RESEED, 0)
DBCC CHECKIDENT('dbo.PatientCase', RESEED, 0)
DBCC CHECKIDENT('dbo.InsuranceCompany', RESEED, 0)
DBCC CHECKIDENT('dbo.InsuranceCompanyPlan', RESEED, 0)
DBCC CHECKIDENT('dbo.InsurancePolicy', RESEED, 0)
DBCC CHECKIDENT('dbo.Doctor', RESEED, 3)

--SELECT * FROM dbo.Doctor
--SELECT * FROM dbo.InsurancePolicy
--SELECT * FROM dbo.InsuranceCompanyPlan
--SELECT * FROM dbo.InsuranceCompany
--SELECT * FROM dbo.PatientCase
--SELECT * FROM dbo.Patient

--Add columns to break apart name

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ref_Doctor_Fname' 
	AND Object_ID = Object_ID(N'_import_4_1_ReferringProviders'))
BEGIN
	ALTER TABLE [_import_4_1_ReferringProviders] ADD ref_Doctor_Fname VARCHAR(64) NULL
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ref_Doctor_Lname' 
	AND Object_ID = Object_ID(N'_import_4_1_ReferringProviders'))
BEGIN
	ALTER TABLE [_import_4_1_ReferringProviders] ADD ref_Doctor_Lname VARCHAR(64) NULL
END


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ref_Doctor_Mi' 
	AND Object_ID = Object_ID(N'_import_4_1_ReferringProviders'))
BEGIN
	ALTER TABLE [_import_4_1_ReferringProviders] ADD ref_Doctor_Mi VARCHAR(64) NULL
END


--Fixing the referring providers table
UPDATE dbo.[_import_4_1_ReferringProviders]
	SET ref_provider_name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ref_provider_name, 
	' II ', ''), ' MD ', ''), ' DO ', ''), ' JR ', ''), ' DPM ', '')
	
--insert the name into specific columns
	
UPDATE dbo.[_import_4_1_ReferringProviders]
      SET 
		ref_Doctor_Lname = LastName,
		ref_Doctor_Fname = FirstName,
		ref_Doctor_Mi = CASE WHEN LEN(MiStart) = 1 THEN MiStart ELSE '' END 
   FROM (
         SELECT ID, LastName,
				SUBSTRING(FirstNameStart,1,ISNULL(NULLIF(CHARINDEX('   ',FirstNameStart),0),254))  AS FirstName, 
                REPLACE(LTRIM(SUBSTRING(FirstNameStart,NULLIF(CHARINDEX(' ',FirstNameStart),0),254)),' ','') AS MiStart
           FROM (
                 SELECT ID, SUBSTRING(ref_provider_name,1,CHARINDEX(' ',ref_provider_name)) AS LastName,
                        LTRIM(SUBSTRING(ref_provider_name,CHARINDEX(' ',ref_provider_name)+1,254)) AS FirstNameStart
                   FROM dbo.[_import_4_1_ReferringProviders]
                ) dtStart
        ) dtFullName
   WHERE dtFullName.ID = dbo.[_import_4_1_ReferringProviders].ID AND
	dbo.[_import_4_1_ReferringProviders].ref_Doctor_Lname is NULL 
       



UPDATE dbo.[_import_5_1_PatientDemos]
	SET Provider_code = 1211
	WHERE Provider_code = 1221
	
UPDATE dbo.[_import_5_1_PatientDemos]
	SET Provider_code  = 1211
	WHERE Provider_code  = 1299



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Doctor_Fname' 
	AND Object_ID = Object_ID(N'_import_4_1_PrimaryCarePhysician'))
BEGIN
	ALTER TABLE [_import_4_1_PrimaryCarePhysician] ADD Doctor_Fname VARCHAR(64) NULL
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Doctor_Lname' 
	AND Object_ID = Object_ID(N'_import_4_1_PrimaryCarePhysician'))
BEGIN
	ALTER TABLE [_import_4_1_PrimaryCarePhysician] ADD Doctor_Lname VARCHAR(64) NULL
END



UPDATE dbo.[_import_4_1_PrimaryCarePhysician]
	SET provider_name = REPLACE(provider_name, 'pa ', '')
	WHERE ID IS NOT NULL 



DELETE FROM dbo.[_import_4_1_primarycarephysician]
	WHERE primary_care_physician_code = 1299 OR
		primary_care_physician_code = 1221
			
			
UPDATE dbo.[_import_4_1_PrimaryCarePhysician]
      SET 
		Doctor_Lname = LastName,
		Doctor_Fname = FirstName
  FROM (
         SELECT ID, LastName,
				SUBSTRING(FirstNameStart,1,ISNULL(NULLIF(CHARINDEX('   ',FirstNameStart),0),254))  AS FirstName, 
                REPLACE(LTRIM(SUBSTRING(FirstNameStart,NULLIF(CHARINDEX(' ',FirstNameStart),0),254)),' ','') AS MiStart
           FROM (
                 SELECT ID, SUBSTRING([provider_name],1,CHARINDEX(' ',[provider_name])) AS LastName,
                        LTRIM(SUBSTRING([provider_name],CHARINDEX(' ',[provider_name])+1,254)) AS FirstNameStart
                   FROM dbo.[_import_4_1_PrimaryCarePhysician]
                ) dtStart
        ) dtFullName
   WHERE dtFullName.ID = dbo.[_import_4_1_PrimaryCarePhysician].ID AND
	dbo.[_import_4_1_PrimaryCarePhysician].Doctor_Lname is NULL 
       


--Set vendorID for doctors already in kareo

UPDATE dbo.Doctor
	SET vendorID =
		(SELECT 
			[primary_care_physician_code]
		 FROM
			dbo.[_import_4_1_PrimaryCarePhysician]
		WHERE dbo.Doctor.FirstName = Doctor_Fname AND
			dbo.Doctor.LastName = Doctor_Lname
		)
	WHERE vendorimportid IS NULL
		


