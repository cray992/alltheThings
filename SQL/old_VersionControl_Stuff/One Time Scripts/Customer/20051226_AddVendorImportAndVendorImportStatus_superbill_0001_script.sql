USE superbill_0001_dev
GO

-- Add VendorFormat column to VendorImport table

ALTER Table VendorImport
ADD VendorFormat varchar(50)		NULL
GO 

-- Set VendorFormat field for VendorImportID = 1 to "MedicalManager"

UPDATE VendorImport
SET VendorFormat = 'MedicalManager'
WHERE VendorImportID = 1
GO

-- Alter VendorImport table to disallow NULL in VendorFormat column

ALTER Table VendorImport
	ALTER COLUMN VendorFormat varchar(50)	NOT NULL
GO 


-- Create new table to keep track of VendorImportStatus for each imported record

CREATE TABLE VendorImportStatus
(
	VendorImportStatusID int IDENTITY(1,1)	NOT NULL,
	VendorImportID 		int		NOT NULL,	-- VendorImportID in VendorImport table
	VendorID		int		NOT NULL,	-- record id, e.g. TrackID in Medi-EMR
	Status 			bit		NOT NULL,	-- 1 - success; 0 - failure;
	DateCreated		datetime	NOT NULL
		DEFAULT GETDATE()
)
GO

-- Patient					**** this table already has VendorID and VendorImportID columns


-- PatientCase

IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
	  on so.id=sc.id
	  WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='PatientCase')
   BEGIN
	ALTER TABLE PatientCase 
	ADD VendorImportID int NULL
   END
ELSE
   BEGIN
	ALTER TABLE PatientCase 
	ADD VendorID varchar(50) NULL, 
	VendorImportID int NULL
   END
GO


-- InsuranceCompany				**** this table already has VendorID and VendorImportID columns


-- InsuranceCompanyPlan				**** this table already has VendorID and VendorImportID columns


-- InsurancePolicy

IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
	  on so.id=sc.id
	  WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='InsurancePolicy')
   BEGIN
	ALTER TABLE InsurancePolicy 
	ADD VendorImportID int NULL
   END
ELSE
   BEGIN
	ALTER TABLE InsurancePolicy 
	ADD VendorID varchar(50) NULL, 
	VendorImportID int NULL
   END
GO

-- ReferringPhysician				**** this table already has VendorID and VendorImportID columns ?


-- Doctor

IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
	  on so.id=sc.id
	  WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='Doctor')
   BEGIN
	ALTER TABLE Doctor 
	ADD VendorImportID int NULL
   END
ELSE
   BEGIN
	ALTER TABLE Doctor 
	ADD VendorID varchar(50) NULL, 
	VendorImportID int NULL
   END
GO


-- Encounter

IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
	  on so.id=sc.id
	  WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='Encounter')
   BEGIN
	ALTER TABLE Encounter
	ADD VendorImportID int NULL
   END
ELSE
   BEGIN
	ALTER TABLE Encounter 
	ADD VendorID varchar(50) NULL, 
	VendorImportID int NULL
   END
GO


-- EncounterDiagnosis

IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
	  on so.id=sc.id
	  WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='EncounterDiagnosis')
   BEGIN
	ALTER TABLE EncounterDiagnosis
	ADD VendorImportID int NULL
   END
ELSE
   BEGIN
	ALTER TABLE EncounterDiagnosis 
	ADD VendorID varchar(50) NULL, 
	VendorImportID int NULL
   END
GO


-- EncounterProcedure

IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
	  on so.id=sc.id
	  WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='EncounterProcedure')
   BEGIN
	ALTER TABLE EncounterProcedure 
	ADD VendorImportID int NULL
   END
ELSE
   BEGIN
	ALTER TABLE EncounterProcedure 
	ADD VendorID varchar(50) NULL, 
	VendorImportID int NULL
   END
GO


