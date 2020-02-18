IF EXISTS(SELECT 1
		FROM sys.objects so INNER JOIN sys.columns sc
		ON so.object_id=sc.object_id
		WHERE so.name='Practice' AND sc.name='ExternalID')
BEGIN

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_Practice_ExternalID')
		DROP INDEX Practice.IX_Practice_ExternalID

	ALTER TABLE Practice DROP COLUMN ExternalID

END

GO

ALTER TABLE Practice ADD ExternalID VARCHAR(25) NULL

GO 

CREATE NONCLUSTERED INDEX IX_Practice_ExternalID ON Practice (ExternalID)

GO

IF EXISTS(SELECT 1
		FROM sys.objects so INNER JOIN sys.columns sc
		ON so.object_id=sc.object_id
		WHERE so.name='Patient' AND sc.name='ExternalID')
BEGIN

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_Patient_ExternalID')
		DROP INDEX Patient.IX_Patient_ExternalID

	ALTER TABLE Patient DROP COLUMN ExternalID

END

GO

ALTER TABLE Patient ADD ExternalID VARCHAR(25) NULL

GO 

CREATE NONCLUSTERED INDEX IX_Patient_ExternalID ON Patient (ExternalID)

GO

IF EXISTS(SELECT 1
		FROM sys.objects so INNER JOIN sys.columns sc
		ON so.object_id=sc.object_id
		WHERE so.name='Doctor' AND sc.name='ExternalID')
BEGIN

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_Doctor_ExternalID')
		DROP INDEX Doctor.IX_Doctor_ExternalID

	ALTER TABLE Doctor DROP COLUMN ExternalID

END

GO

ALTER TABLE Doctor ADD ExternalID VARCHAR(25) NULL

GO 

CREATE NONCLUSTERED INDEX IX_Doctor_ExternalID ON Doctor (ExternalID)

GO

IF EXISTS(SELECT 1
		FROM sys.objects so INNER JOIN sys.columns sc
		ON so.object_id=sc.object_id
		WHERE so.name='PatientCase' AND sc.name='ExternalID')
BEGIN

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_PatientCase_ExternalID')
		DROP INDEX PatientCase.IX_PatientCase_ExternalID

	ALTER TABLE PatientCase DROP COLUMN ExternalID

END

GO

ALTER TABLE PatientCase ADD ExternalID VARCHAR(25) NULL

GO 

CREATE NONCLUSTERED INDEX IX_PatientCase_ExternalID ON PatientCase (ExternalID)

GO

IF EXISTS(SELECT 1
		FROM sys.objects so INNER JOIN sys.columns sc
		ON so.object_id=sc.object_id
		WHERE so.name='InsurancePolicy' AND sc.name='ExternalID')
BEGIN

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_InsurancePolicy_ExternalID')
		DROP INDEX InsurancePolicy.IX_InsurancePolicy_ExternalID

	ALTER TABLE InsurancePolicy DROP COLUMN ExternalID

END

GO

ALTER TABLE InsurancePolicy ADD ExternalID VARCHAR(25) NULL

GO 

CREATE NONCLUSTERED INDEX IX_InsurancePolicy_ExternalID ON InsurancePolicy (ExternalID)

GO

IF EXISTS(SELECT 1
		FROM sys.objects so INNER JOIN sys.columns sc
		ON so.object_id=sc.object_id
		WHERE so.name='Encounter' AND sc.name='ExternalID')
BEGIN

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_Encounter_ExternalID')
		DROP INDEX Encounter.IX_Encounter_ExternalID

	ALTER TABLE Encounter DROP COLUMN ExternalID

END

GO

ALTER TABLE Encounter ADD ExternalID VARCHAR(25) NULL

GO 

CREATE NONCLUSTERED INDEX IX_Encounter_ExternalID ON Encounter (ExternalID)

GO

IF EXISTS(SELECT 1
		FROM sys.objects so INNER JOIN sys.columns sc
		ON so.object_id=sc.object_id
		WHERE so.name='EncounterProcedure' AND sc.name='ExternalID')
BEGIN

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_EncounterProcedure_ExternalID')
		DROP INDEX EncounterProcedure.IX_EncounterProcedure_ExternalID

	ALTER TABLE EncounterProcedure DROP COLUMN ExternalID

END

GO

ALTER TABLE EncounterProcedure ADD ExternalID VARCHAR(25) NULL

GO 

CREATE NONCLUSTERED INDEX IX_EncounterProcedure_ExternalID ON EncounterProcedure (ExternalID)

GO

IF EXISTS(SELECT 1
		FROM sys.objects so INNER JOIN sys.columns sc
		ON so.object_id=sc.object_id
		WHERE so.name='Appointment' AND sc.name='ExternalID')
BEGIN

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_Appointment_ExternalID')
		DROP INDEX Appointment.IX_Appointment_ExternalID

	ALTER TABLE Appointment DROP COLUMN ExternalID

END

GO

ALTER TABLE Appointment ADD ExternalID VARCHAR(25) NULL

GO 

CREATE NONCLUSTERED INDEX IX_Appointment_ExternalID ON Appointment (ExternalID)

GO