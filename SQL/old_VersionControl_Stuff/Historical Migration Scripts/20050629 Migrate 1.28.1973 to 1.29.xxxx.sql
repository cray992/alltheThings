/*

DATABASE UPDATE SCRIPT

v1.28.1973 to v1.29.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------


---------------------------------------------------------------------------------------
--case 5615 - Add DefaultCodingTemplateID to the Doctor table

-- Add the default coding template id to use for this doctor
ALTER TABLE [dbo].[Doctor] ADD 
	[DefaultCodingTemplateID] [int] NULL
GO

-- Add a foreign key for the default coding template id
ALTER TABLE [dbo].[Doctor] ADD
	CONSTRAINT [FK_Doctor_CodingTemplate] FOREIGN KEY 
	(
		[DefaultCodingTemplateID]
	) REFERENCES [CodingTemplate] (
		[CodingTemplateID]
	)
GO

---------------------------------------------------------------------------------------
--case 5640 - Add and populate PatientReferralSource table, add foreign key to Patient table

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PatientReferralSource]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PatientReferralSource]
GO

CREATE TABLE [dbo].[PatientReferralSource] (
	[PatientReferralSourceID] [int] NOT NULL IDENTITY(1,1),
	[PatientReferralSourceCaption] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PatientReferralSource] ADD 
	CONSTRAINT [PK_PatientReferralSource] PRIMARY KEY  CLUSTERED 
	(
		[PatientReferralSourceID]
	)  ON [PRIMARY] 
GO

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Attorney')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Brochure')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Case Manager')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Friend / Family')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Insurance')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Nurse')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Patient Seminar')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Previous Patient')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Print Ad')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Online Ad')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Radio Ad')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Physician')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Search Engine')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Website')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Workers Comp')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Yellow Pages')

INSERT [dbo].[PatientReferralSource]
(PatientReferralSourceCaption)
VALUES	('Other')

-- Add the patient referral source id to the Patient table
ALTER TABLE [dbo].[Patient] ADD 
	[PatientReferralSourceID] [int] NULL
GO

-- Add a foreign key for the patient referral source
ALTER TABLE [dbo].[Patient] ADD
	CONSTRAINT [FK_Patient_PatientReferralSource] FOREIGN KEY 
	(
		[PatientReferralSourceID]
	) REFERENCES [PatientReferralSource] (
		[PatientReferralSourceID]
	)
GO

---------------------------------------------------------------------------------------
--case 5641 - Add PrimaryProviderID to patient table

-- Add the primary provider id to the patient table
ALTER TABLE [dbo].[Patient] ADD 
	[PrimaryProviderID] [int] NULL
GO

-- Add a foreign key for the primary provider id
ALTER TABLE [dbo].[Patient] ADD
	CONSTRAINT [FK_Patient_Doctor] FOREIGN KEY 
	(
		[PrimaryProviderID]
	) REFERENCES [Doctor] (
		[DoctorID]
	)
GO

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
