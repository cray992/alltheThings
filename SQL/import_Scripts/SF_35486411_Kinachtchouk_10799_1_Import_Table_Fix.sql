USE superbill_10799_prod
go

-- Add a column for the doctorid
IF NOT EXISTS(select * from sys.columns where Name = N'PCPDoctorID' AND Object_ID = Object_ID(N'_import_3_1_PatientDemos'))
BEGIN
    -- Column doesn't exist
    ALTER TABLE [_import_3_1_PatientDemos] ADD PCPDoctorID INT NULL
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ref_Doctor_Fname' AND Object_ID = Object_ID(N'_import_3_1_ReferringProviders'))
BEGIN
	ALTER TABLE [_import_3_1_ReferringProviders] ADD ref_Doctor_Fname VARCHAR(64) NULL
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ref_Doctor_Lname' AND Object_ID = Object_ID(N'_import_3_1_ReferringProviders'))
BEGIN
	ALTER TABLE [_import_3_1_ReferringProviders] ADD ref_Doctor_Lname VARCHAR(64) NULL
END


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ref_Doctor_Mi' AND Object_ID = Object_ID(N'_import_3_1_ReferringProviders'))
BEGIN
	ALTER TABLE [_import_3_1_ReferringProviders] ADD ref_Doctor_Mi VARCHAR(64) NULL
END

SELECT * FROM dbo._import_3_1_ReferringProviders

SELECT * FROM dbo._import_3_1_PatientDemos
