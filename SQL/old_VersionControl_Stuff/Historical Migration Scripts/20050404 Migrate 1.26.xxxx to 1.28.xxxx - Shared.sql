/*

SHARED DATABASE UPDATE SCRIPT

v1.26.1914 to v1.28.xxxx		// .27 was a quick fix post-release and has no migration script
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 3634:  Figure out how to support multiple customers with ProxyMed

CREATE TABLE [dbo].[ClearinghouseConnection] (
	[ClearinghouseConnectionID] [int] IDENTITY (1, 1)  NOT NULL,

	[ProductionFlag] [bit]	NOT NULL,

	[ClearinghouseConnectionName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SubmitterName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SubmitterEtin] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SubmitterContactName]  [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SubmitterContactPhone] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SubmitterContactEmail] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SubmitterContactFax]   [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,

	[ReceiverName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ReceiverEtin] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,

	[ClaimLogin]    [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClaimPassword] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, 
	[Notes] [text] NULL,

	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedUserID] [int] NOT NULL,
	[RecordTimeStamp] [TIMESTAMP] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClearinghouseConnection] ADD 
	CONSTRAINT [DF_ClearinghouseConnection_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_ClearinghouseConnection_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_ClearinghouseConnection_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_ClearinghouseConnection_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID],
	CONSTRAINT [PK_ClearinghouseConnection] PRIMARY KEY  NONCLUSTERED 
		(
		    [ClearinghouseConnectionID]
		)   ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Customer] ADD 
	ClearinghouseConnectionID int NULL
GO

ALTER TABLE [dbo].[ClearinghouseConnection] ADD 
	CONSTRAINT [FK_Customer_ClearinghouseConnection] FOREIGN KEY 
	(
		[ClearinghouseConnectionID]
	) REFERENCES [dbo].[ClearinghouseConnection] (
		[ClearinghouseConnectionID]
	)
GO

INSERT INTO ClearinghouseConnection (ProductionFlag, ClearinghouseConnectionName,
			SubmitterName, SubmitterEtin,
			SubmitterContactName,
			SubmitterContactPhone,
			SubmitterContactEmail,
			SubmitterContactFax,
			ReceiverName,
			ReceiverEtin,
			ClaimLogin, ClaimPassword)
 VALUES (1, 'Kareo Connection',
			'KAREO', '650721495',
			'KAREO Contact',
			'8886097281',
			'sergei@kareo.com',
			'5617767411',
			'PROXYMED',
			'650202059',
			'50296151', '24jfortnoa')
GO

INSERT INTO ClearinghouseConnection (ProductionFlag, ClearinghouseConnectionName,
			SubmitterName, SubmitterEtin,
			SubmitterContactName,
			SubmitterContactPhone,
			SubmitterContactEmail,
			SubmitterContactFax,
			ReceiverName,
			ReceiverEtin,
			ClaimLogin, ClaimPassword)
 VALUES (1, 'PM&R Resources Connection',
			'PM&R RESOURCES', '650721495',
			'PMR Contact',
			'8886097281',
			'sergei@kareo.com',
			'5617767411',
			'PROXYMED',
			'650202059',
			'50296151', '24jfortnoa')
GO


---------------------------------------------------------------------------------------
--case 3272 - Multiple ST envelopes for ANSI-837

INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(39, 'EDI Submitter Number', 'SN', 200)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(40, 'EDI Submitter Name', 'SM', 210)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(41, 'EDI Receiver Number', 'RN', 220)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(42, 'EDI Receiver Name', 'RM', 230)


---------------------------------------------------------------------------------------
--case 3840 - Add flag to InsuranceCompanyPlan table to determine if the secondary insurance is automatically billed
ALTER TABLE
	InsuranceCompanyPlan
ADD
	BillSecondaryInsurance BIT NOT NULL DEFAULT 0
GO

---------------------------------------------------------------------------------------
--case 3890 - Medi-Cal rejections due to SBR09 code hardcoded to '09'

ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [FK_InsuranceCompanyPlan_InsuranceProgram]
GO
ALTER TABLE [dbo].[InsuranceProgram] DROP CONSTRAINT [PK_InsuranceProgram]
GO

ALTER TABLE
	[dbo].[InsuranceProgram]
ALTER COLUMN
	[InsuranceProgramCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO

ALTER TABLE [dbo].[InsuranceProgram] WITH NOCHECK ADD
	CONSTRAINT [PK_InsuranceProgram] PRIMARY KEY CLUSTERED
	(
		[InsuranceProgramCode]
	) ON [PRIMARY]
GO

ALTER TABLE
	[dbo].[InsuranceCompanyPlan]
ALTER COLUMN
	[InsuranceProgramCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO

ALTER TABLE
	[dbo].[InsuranceProgram]
ADD
	[Comment] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortOrder] [int] NULL
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD
	CONSTRAINT [FK_InsuranceCompanyPlan_InsuranceProgram] FOREIGN KEY
	(
		[InsuranceProgramCode]
	) REFERENCES [dbo].[InsuranceProgram] (
		[InsuranceProgramCode]
	)
GO

INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('09', 'Self-pay', NULL, 10)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('10', 'Central Certification', 'NSF Reference: CA0-23.0 (K), DA0-05.0 (K)', 20)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('11', 'Other Non-Federal Programs', NULL, 30)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('12', 'Preferred Provider Organization (PPO)', NULL, 40)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('13', 'Point of Service (POS)', NULL, 50)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('14', 'Exclusive Provider Organization (EPO)', NULL, 60)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('15', 'Indemnity Insurance', NULL, 70)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('16', 'Health Maintenance Organization (HMO) Medicare Risk', NULL, 80)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('AM', 'Automobile Medical', NULL, 90)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('BL', 'Blue Cross/Blue Shield', 'NSF Reference: CA0-23.0 (G), DA0-05.0 (G), CA0-23.0 (P), DA0-05.0 (P)', 100)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('CH', 'Champus', 'NSF Reference: CA0-23.0 (H), DA0-05.0 (H)', 110)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('CI', 'Commercial Insurance Co.', 'NSF Reference: CA0-23.0 (F), DA0-05.0 (F)', 120)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('DS', 'Disability', NULL, 130)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('HM', 'Health Maintenance Organization', 'NSF Reference: CA0-23.0 (I), DA0-05.0 (I)', 140)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('LI', 'Liability', NULL, 150)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('LM', 'Liability Medical', NULL, 160)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('MB', 'Medicare Part B', 'NSF Reference: CA0-23.0 (C), DA0-05.0 (C)', 170)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('MC', 'Medicaid', 'NSF Reference: CA0-23.0 (D), DA0-05.0 (D)', 180)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('OF', 'Other Federal Program', 'NSF Reference: CA0-23.0 (E), DA0-05.0 (E)', 190)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('TV', 'Title V', 'NSF Reference: DA0-05.0 (T)', 200)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('VA', 'Veteran Administration Plan', 'Refers to Veteran’s Affairs Plan. NSF Reference: DA0-05.0 (V)', 210)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('WC', 'Workers Compensation Health Claim', 'NSF Reference: CA0-23.0 (B), DA0-05.0 (B)', 220)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('ZZ', 'Mutually Defined / Unknown', 'NSF Reference: CA0-23.0 (Z), DA0-05.0 (Z)', 230)
GO

UPDATE [dbo].[InsuranceCompanyPlan] SET [InsuranceProgramCode] = '09'
GO

DELETE [dbo].[InsuranceProgram] WHERE SortOrder IS NULL 
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [DF_InsuranceCompanyPlan_InsuranceProgramCode]
ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD CONSTRAINT [DF_InsuranceCompanyPlan_InsuranceProgramCode] DEFAULT ('09') FOR [InsuranceProgramCode]
GO

---------------------------------------------------------------------------------------
--case 3034 - Renamed the permission description for UnapproveEncounter

UPDATE	Permissions
SET	Description = 'Unapprove an unbilled, approved encounter.'
WHERE	PermissionValue = 'UnapproveEncounter'

---------------------------------------------------------------------------------------
--case 3928 - Remove one of the duplicated Edit Contact Information permissions

-- This is to ensure that the permission we are deleting has the correct id
declare @EditContactPermissionID int
select @EditContactPermissionID = PermissionID
from Permissions
where Description like '%contact%'
and PermissionID = 179

delete from SecurityGroupPermissions
where PermissionID = @EditContactPermissionID

delete from Permissions
where PermissionID = @EditContactPermissionID

---------------------------------------------------------------------------------------
--case 3858 - Add permission required for printing a Superbill

DECLARE @PermissionID INT
DECLARE @PermissionGroupID INT

SELECT	@PermissionGroupID = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Scheduling Appointments'

INSERT INTO	Permissions(	
			Name, 
			Description, 
			ViewInMedicalOffice,
			ViewInBusinessManager,
			ViewInAdministrator,
			ViewInServiceManager,
			PermissionGroupID,
			PermissionValue
		)
VALUES		('Print Encounter Form',
		'Print an Encounter Form', 
		1,
		1,
		1,
		1,
		@PermissionGroupID,
		'PrintEncounterForm')

SET @PermissionID = scope_identity()

-- Insert into security groups where FindAppointment is allowed
INSERT INTO 	SecurityGroupPermissions(
		SecurityGroupID,
		PermissionID,
		Allowed,
		Denied)
SELECT		SecurityGroupID,
		@PermissionID,
		Allowed,
		Denied
FROM		SecurityGroupPermissions
WHERE		PermissionID = (SELECT PermissionID FROM Permissions WHERE PermissionValue = 'FindAppointment')


---------------------------------------------------------------------------------------
--case XXXX - Description
---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
