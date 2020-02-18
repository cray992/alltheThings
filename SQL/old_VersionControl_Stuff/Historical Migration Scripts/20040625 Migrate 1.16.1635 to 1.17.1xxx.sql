/*

DATABASE UPDATE SCRIPT

v1.16.1635 to v.1.17.xxxx
*/
----------------------------------
EXEC sp_change_users_login @Action = 'Update_One', @UserNamePattern = 'dev', @LoginName = 'dev'

BEGIN TRAN 

-- Case 2075

ALTER TABLE [dbo].[PracticeFeeSchedule]  ADD
	[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO


----------------------------------


-- Case 2076

ALTER TABLE [dbo].[ReferringPhysician]  ADD
	[FaxPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[FaxPhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

----------------------------------


-- Case 2073

ALTER TABLE [dbo].[ServiceLocation]  ADD
	[Phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[PhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[FaxPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[FaxPhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

----------------------------------


-- Case 2090

ALTER TABLE [dbo].[Practice]  ADD
	[EmailAddress] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[AdministrativeContactAddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[AdministrativeContactAddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[AdministrativeContactCity] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[AdministrativeContactState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[AdministrativeContactCountry] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[AdministrativeContactZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[AdministrativeContactFax] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[AdministrativeContactFaxExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[BillingContactPrefix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[BillingContactFirstName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[BillingContactMiddleName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[BillingContactLastName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[BillingContactSuffix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[BillingFax] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
	[BillingFaxExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

----------------------------------

-- Case 2031 (Electronic Claims submission to ProxyMed)  
--This column already exists
--ALTER TABLE [dbo].[GroupNumberType]  ADD
--	[ANSIReferenceIdentificationQualifier] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

IF NOT EXISTS (SELECT * FROM GroupNumberType WHERE	ANSIReferenceIdentificationQualifier = '0B')
INSERT	GroupNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('State License Number', '0B')

IF NOT EXISTS (SELECT * FROM GroupNumberType WHERE	ANSIReferenceIdentificationQualifier = '1A')
INSERT	GroupNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('Blue Cross Provider Number', '1A')

IF NOT EXISTS (SELECT * FROM GroupNumberType WHERE	ANSIReferenceIdentificationQualifier = '1B')
INSERT	GroupNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('Blue Shield Provider Number', '1B')

IF NOT EXISTS (SELECT * FROM GroupNumberType WHERE	ANSIReferenceIdentificationQualifier = '1C')
INSERT	GroupNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('Medicare Provider Number', '1C')

IF NOT EXISTS (SELECT * FROM GroupNumberType WHERE	ANSIReferenceIdentificationQualifier = '1D')
INSERT	GroupNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('Medicaid Provider Number', '1D')

IF NOT EXISTS (SELECT * FROM GroupNumberType WHERE	ANSIReferenceIdentificationQualifier = '1H')
INSERT	GroupNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('CHAMPUS Identification Number', '1H')

IF NOT EXISTS (SELECT * FROM GroupNumberType WHERE	ANSIReferenceIdentificationQualifier = 'G2')
INSERT	GroupNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('Provider Commercial Number', 'G2')

IF NOT EXISTS (SELECT * FROM GroupNumberType WHERE	ANSIReferenceIdentificationQualifier = 'X5')
INSERT	GroupNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('State Industrial Accident Provider Number', 'X5')

--This Column already existed
--ALTER TABLE [dbo].[ProviderNumberType]  ADD
--	[ANSIReferenceIdentificationQualifier] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

IF NOT EXISTS (SELECT * FROM ProviderNumberType WHERE	ANSIReferenceIdentificationQualifier = '0B')
INSERT	ProviderNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('State License Number', '0B')

IF NOT EXISTS (SELECT * FROM ProviderNumberType WHERE	ANSIReferenceIdentificationQualifier = '1A')
INSERT	ProviderNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('Blue Cross Provider Number', '1A')

IF NOT EXISTS (SELECT * FROM ProviderNumberType WHERE	ANSIReferenceIdentificationQualifier = '1B')
INSERT	ProviderNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('Blue Shield Provider Number', '1B')

IF NOT EXISTS (SELECT * FROM ProviderNumberType WHERE	ANSIReferenceIdentificationQualifier = '1C')
INSERT	ProviderNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('Medicare Provider Number', '1C')

IF NOT EXISTS (SELECT * FROM ProviderNumberType WHERE	ANSIReferenceIdentificationQualifier = '1D')
INSERT	ProviderNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('Medicaid Provider Number', '1D')

IF NOT EXISTS (SELECT * FROM ProviderNumberType WHERE	ANSIReferenceIdentificationQualifier = '1H')
INSERT	ProviderNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('CHAMPUS Identification Number', '1H')

IF NOT EXISTS (SELECT * FROM ProviderNumberType WHERE	ANSIReferenceIdentificationQualifier = 'G2')
INSERT	ProviderNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('Provider Commercial Number', 'G2')

IF NOT EXISTS (SELECT * FROM ProviderNumberType WHERE	ANSIReferenceIdentificationQualifier = 'X5')
INSERT	ProviderNumberType (TypeName, ANSIReferenceIdentificationQualifier) VALUES ('State Industrial Accident Provider Number', 'X5')

----------------------------------

-- the tables and colums below are obsolete and replaced by Provider/Group Numbers logic:

DROP TABLE DoctorIdentifier

ALTER TABLE [dbo].[InsuranceCompanyPlan] 
DROP CONSTRAINT [FK_InsuranceCompanyPlan_DoctorIdentifierTypeI] 
ALTER TABLE [dbo].[InsuranceCompanyPlan]
  DROP COLUMN [DoctorIndividualIdentifierTypeCode]
ALTER TABLE [dbo].[InsuranceCompanyPlan] 
DROP CONSTRAINT [FK_InsuranceCompanyPlan_DoctorIdentifierTypeG] 
ALTER TABLE [dbo].[InsuranceCompanyPlan]
  DROP COLUMN [DoctorGroupIdentifierTypeCode]
ALTER TABLE [dbo].[InsuranceCompanyPlan] 
DROP CONSTRAINT [FK_InsuranceCompanyPlan_DoctorIdentifierTypeLU] 

DROP TABLE DoctorIdentifierType
GO
----------------------------------

-- Case 2088:

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClearinghouseEnrollmentStatusType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClearinghouseEnrollmentStatusType]
GO

CREATE TABLE [dbo].[ClearinghouseEnrollmentStatusType] (
	[PK_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[EnrollmentStatusID] [int] NOT NULL ,
	[EnrollmentStatusName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM ClearinghouseEnrollmentStatusType WHERE	EnrollmentStatusID = 0)
INSERT	ClearinghouseEnrollmentStatusType (EnrollmentStatusID, EnrollmentStatusName) VALUES (0, 'Not enrolled')

IF NOT EXISTS (SELECT * FROM ClearinghouseEnrollmentStatusType WHERE	EnrollmentStatusID = 1)
INSERT	ClearinghouseEnrollmentStatusType (EnrollmentStatusID, EnrollmentStatusName) VALUES (1, 'Enrollment pending')

IF NOT EXISTS (SELECT * FROM ClearinghouseEnrollmentStatusType WHERE	EnrollmentStatusID = 2)
INSERT	ClearinghouseEnrollmentStatusType (EnrollmentStatusID, EnrollmentStatusName) VALUES (2, 'Enrolled')

ALTER TABLE [dbo].[Practice] DROP CONSTRAINT [DF_EnrolledForEClaims]
ALTER TABLE [dbo].[Practice] DROP COLUMN [EnrolledForEClaims]

ALTER TABLE [dbo].[Practice]  ADD [EClaimsEnrollmentStatusID] [int] NOT NULL DEFAULT 0 WITH VALUES
ALTER TABLE [dbo].[Practice]  ADD [EClaimsNotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

UPDATE [dbo].[Practice]	SET [EClaimsEnrollmentStatusID] = 2 WHERE PracticeID = 37
GO


----------------------------------

-- from testing latest build

ALTER TABLE Doctor ALTER COLUMN firstname varchar(64) NOT NULL
ALTER TABLE Doctor ALTER COLUMN middlename varchar(64) NOT NULL
ALTER TABLE Doctor ALTER COLUMN lastname varchar(64) NOT NULL
GO


----------------------------------
----------------------------------
--ROLLBACK
--COMMIT
