--===========================================================================
-- MOD: PATIENT INSURANCE TABLE
--===========================================================================
ALTER TABLE dbo.PatientInsurance
ALTER COLUMN HolderEmployerName VARCHAR(128) NULL


--===========================================================================
-- MOD: PATIENT EMPLOYER TABLE
--===========================================================================
ALTER TABLE dbo.PatientEmployer
ALTER COLUMN EmployerName VARCHAR(128) NOT NULL
