--Remove Prior implemenation of ExternalID
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

--New ExternalID objects
IF EXISTS(SELECT 1 FROM sys.objects so WHERE name='ExternalVendor' AND type='U')
	DROP TABLE ExternalVendor
GO

CREATE TABLE ExternalVendor(ExternalVendorID INT IDENTITY(6,6)
							CONSTRAINT PK_ExternalVendor PRIMARY KEY CLUSTERED,
							ExternalVendorName VARCHAR(128) NOT NULL
							CONSTRAINT ux_ExternalVendor UNIQUE,
							CreatedDate DATETIME NOT NULL CONSTRAINT DF_ExternalVendor_CreatedDate DEFAULT GETDATE(),
							CreatedUserID INT NOT NULL,
							ModifiedDate DATETIME NOT NULL,
							ModifiedUserID INT NOT NULL)

GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NCI_ExternalIDToPatientMap_PatientID')
	DROP INDEX ExternalIDToPatientMap.NCI_ExternalIDToPatientMap_PatientID

GO

IF EXISTS(SELECT 1 FROM sys.objects so WHERE name='ExternalIDToPatientMap' AND type='U')
	DROP TABLE ExternalIDToPatientMap
GO

CREATE TABLE ExternalIDToPatientMap(ExternalVendorID INT NOT NULL, ExternalID VARCHAR(25) NOT NULL,
									CONSTRAINT ux_ExternalIDToPatientMap UNIQUE (ExternalVendorID, ExternalID),
									PatientID INT NOT NULL, 
									CONSTRAINT PK_ExternalIDToPatientMap PRIMARY KEY CLUSTERED(ExternalVendorID, ExternalID, PatientID),
									CreatedDate DATETIME NOT NULL CONSTRAINT DF_ExternalIDToPatientMap_CreatedDate DEFAULT GETDATE())

GO

CREATE INDEX NCI_ExternalIDToPatientMap_PatientID ON ExternalIDToPatientMap (PatientID)

GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NCI_ExternalIDToPracticeMap_PracticeID')
	DROP INDEX ExternalIDToPracticeMap.NCI_ExternalIDToPracticeMap_PracticeID

GO

IF EXISTS(SELECT 1 FROM sys.objects so WHERE name='ExternalIDToPracticeMap' AND type='U')
	DROP TABLE ExternalIDToPracticeMap
GO

CREATE TABLE ExternalIDToPracticeMap(ExternalVendorID INT NOT NULL, ExternalID VARCHAR(25) NOT NULL,
									CONSTRAINT ux_ExternalIDToPracticeMap UNIQUE (ExternalVendorID, ExternalID),
									PracticeID INT NOT NULL, 
									CONSTRAINT PK_ExternalIDToPracticeMap PRIMARY KEY CLUSTERED(ExternalVendorID, ExternalID, PracticeID),
									CreatedDate DATETIME NOT NULL CONSTRAINT DF_ExternalIDToPracticeMap_CreatedDate DEFAULT GETDATE())

GO

CREATE INDEX NCI_ExternalIDToPracticeMap_PracticeID ON ExternalIDToPracticeMap (PracticeID)

GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NCI_ExternalIDToDoctorMap_DoctorID')
	DROP INDEX ExternalIDToDoctorMap.NCI_ExternalIDToDoctorMap_DoctorID

GO

IF EXISTS(SELECT 1 FROM sys.objects so WHERE name='ExternalIDToDoctorMap' AND type='U')
	DROP TABLE ExternalIDToDoctorMap
GO

CREATE TABLE ExternalIDToDoctorMap(ExternalVendorID INT NOT NULL, ExternalID VARCHAR(25) NOT NULL,
									CONSTRAINT ux_ExternalIDToDoctorMap UNIQUE (ExternalVendorID, ExternalID),
									DoctorID INT NOT NULL, 
									CONSTRAINT PK_ExternalIDToDoctorMap PRIMARY KEY CLUSTERED(ExternalVendorID, ExternalID, DoctorID),
									CreatedDate DATETIME NOT NULL CONSTRAINT DF_ExternalIDToDoctorMap_CreatedDate DEFAULT GETDATE())

GO

CREATE INDEX NCI_ExternalIDToDoctorMap_DoctorID ON ExternalIDToDoctorMap (DoctorID)

GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NCI_ExternalIDToPatientCaseMap_PatientCaseID')
	DROP INDEX ExternalIDToPatientCaseMap.NCI_ExternalIDToPatientCaseMap_PatientCaseID

GO

IF EXISTS(SELECT 1 FROM sys.objects so WHERE name='ExternalIDToPatientCaseMap' AND type='U')
	DROP TABLE ExternalIDToPatientCaseMap
GO

CREATE TABLE ExternalIDToPatientCaseMap(ExternalVendorID INT NOT NULL, ExternalID VARCHAR(25) NOT NULL,
									CONSTRAINT ux_ExternalIDToPatientCaseMap UNIQUE (ExternalVendorID, ExternalID),
									PatientCaseID INT NOT NULL, 
									CONSTRAINT PK_ExternalIDToPatientCaseMap PRIMARY KEY CLUSTERED(ExternalVendorID, ExternalID, PatientCaseID),
									CreatedDate DATETIME NOT NULL CONSTRAINT DF_ExternalIDToPatientCaseMap_CreatedDate DEFAULT GETDATE())

GO

CREATE INDEX NCI_ExternalIDToPatientCaseMap_PatientCaseID ON ExternalIDToPatientCaseMap (PatientCaseID)

GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NCI_ExternalIDToInsurancePolicyMap_InsurancePolicyID')
	DROP INDEX ExternalIDToInsurancePolicyMap.NCI_ExternalIDToInsurancePolicyMap_InsurancePolicyID

GO

IF EXISTS(SELECT 1 FROM sys.objects so WHERE name='ExternalIDToInsurancePolicyMap' AND type='U')
	DROP TABLE ExternalIDToInsurancePolicyMap
GO

CREATE TABLE ExternalIDToInsurancePolicyMap(ExternalVendorID INT NOT NULL, ExternalID VARCHAR(25) NOT NULL,
									CONSTRAINT ux_ExternalIDToInsurancePolicyMap UNIQUE (ExternalVendorID, ExternalID),
									InsurancePolicyID INT NOT NULL, 
									CONSTRAINT PK_ExternalIDToInsurancePolicyMap PRIMARY KEY CLUSTERED(ExternalVendorID, ExternalID, InsurancePolicyID),
									CreatedDate DATETIME NOT NULL CONSTRAINT DF_ExternalIDToInsurancePolicyMap_CreatedDate DEFAULT GETDATE())

GO

CREATE INDEX NCI_ExternalIDToInsurancePolicyMap_InsurancePolicyID ON ExternalIDToInsurancePolicyMap (InsurancePolicyID)

GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NCI_ExternalIDToEncounterMap_EncounterID')
	DROP INDEX ExternalIDToEncounterMap.NCI_ExternalIDToEncounterMap_EncounterID

GO

IF EXISTS(SELECT 1 FROM sys.objects so WHERE name='ExternalIDToEncounterMap' AND type='U')
	DROP TABLE ExternalIDToEncounterMap
GO

CREATE TABLE ExternalIDToEncounterMap(ExternalVendorID INT NOT NULL, ExternalID VARCHAR(25) NOT NULL,
									CONSTRAINT ux_ExternalIDToEncounterMap UNIQUE (ExternalVendorID, ExternalID),
									EncounterID INT NOT NULL, 
									CONSTRAINT PK_ExternalIDToEncounterMap PRIMARY KEY CLUSTERED(ExternalVendorID, ExternalID, EncounterID),
									CreatedDate DATETIME NOT NULL CONSTRAINT DF_ExternalIDToEncounterMap_CreatedDate DEFAULT GETDATE())

GO

CREATE INDEX NCI_ExternalIDToEncounterMap_EncounterID ON ExternalIDToEncounterMap (EncounterID)

GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NCI_ExternalIDToEncounterProcedureMap_EncounterProcedureID')
	DROP INDEX ExternalIDToEncounterProcedureMap.NCI_ExternalIDToEncounterProcedureMap_EncounterProcedureID

GO

IF EXISTS(SELECT 1 FROM sys.objects so WHERE name='ExternalIDToEncounterProcedureMap' AND type='U')
	DROP TABLE ExternalIDToEncounterProcedureMap
GO

CREATE TABLE ExternalIDToEncounterProcedureMap(ExternalVendorID INT NOT NULL, ExternalID VARCHAR(25) NOT NULL,
									CONSTRAINT ux_ExternalIDToEncounterProcedureMap UNIQUE (ExternalVendorID, ExternalID),
									EncounterProcedureID INT NOT NULL, 
									CONSTRAINT PK_ExternalIDToEncounterProcedureMap PRIMARY KEY CLUSTERED(ExternalVendorID, ExternalID, EncounterProcedureID),
									CreatedDate DATETIME NOT NULL CONSTRAINT DF_ExternalIDToEncounterProcedureMap_CreatedDate DEFAULT GETDATE())

GO

CREATE INDEX NCI_ExternalIDToEncounterProcedureMap_EncounterProcedureID ON ExternalIDToEncounterProcedureMap (EncounterProcedureID)

GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='NCI_ExternalIDToAppointmentMap_AppointmentID')
	DROP INDEX ExternalIDToAppointmentMap.NCI_ExternalIDToAppointmentMap_AppointmentID

GO

IF EXISTS(SELECT 1 FROM sys.objects so WHERE name='ExternalIDToAppointmentMap' AND type='U')
	DROP TABLE ExternalIDToAppointmentMap
GO

CREATE TABLE ExternalIDToAppointmentMap(ExternalVendorID INT NOT NULL, ExternalID VARCHAR(25) NOT NULL,
									CONSTRAINT ux_ExternalIDToAppointmentMap UNIQUE (ExternalVendorID, ExternalID),
									AppointmentID INT NOT NULL, 
									CONSTRAINT PK_ExternalIDToAppointmentMap PRIMARY KEY CLUSTERED(ExternalVendorID, ExternalID, AppointmentID),
									CreatedDate DATETIME NOT NULL CONSTRAINT DF_ExternalIDToAppointmentMap_CreatedDate DEFAULT GETDATE())

GO

CREATE INDEX NCI_ExternalIDToAppointmentMap_AppointmentID ON ExternalIDToAppointmentMap (AppointmentID)

GO