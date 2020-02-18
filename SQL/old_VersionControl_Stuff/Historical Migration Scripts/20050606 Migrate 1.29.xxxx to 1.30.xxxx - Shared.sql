/*

SHARED DATABASE UPDATE SCRIPT

v1.29.xxxx to v1.30.xxxx		
*/
----------------------------------

--BEGIN TRAN 

----------------------------------

---------------------------------------------------------------------------------------
-- Case 3634 - Add Permissions for ClearinghouseConnection
---------------------------------------------------------------------------------------
DECLARE @PermissionGroupID int

INSERT INTO PermissionGroup
(
	Name,
	Description
)
VALUES
(
	'Managing Clearinghouse Connections',
	'Managing Clearinghouse Connections including adding and updating Clearinghouse Connection information.'
)
set @PermissionGroupID = @@identity

-- New
INSERT INTO Permissions
(
	Name,
	Description,
	ViewInMedicalOffice,
	ViewInBusinessManager,
	ViewInAdministrator,
	ViewInServiceManager,
	PermissionGroupID,
	PermissionValue
)
VALUES
(
	'New Clearinghouse Connection',
	'Create a new Clearinghouse Connection record.',
	0,
	0,
	0,
	1,
	@PermissionGroupID,
	'NewClearinghouseConnection'
)

-- Read
INSERT INTO Permissions
(
	Name,
	Description,
	ViewInMedicalOffice,
	ViewInBusinessManager,
	ViewInAdministrator,
	ViewInServiceManager,
	PermissionGroupID,
	PermissionValue
)
VALUES
(
	'Read Clearinghouse Connection',
	'Show the details of a Clearinghouse Connection record.',
	0,
	0,
	0,
	1,
	@PermissionGroupID,
	'ReadClearinghouseConnection'
)

-- Edit
INSERT INTO Permissions
(
	Name,
	Description,
	ViewInMedicalOffice,
	ViewInBusinessManager,
	ViewInAdministrator,
	ViewInServiceManager,
	PermissionGroupID,
	PermissionValue
)
VALUES
(
	'Edit Clearinghouse Connection',
	'Modify the details of a Clearinghouse Connection record.',
	0,
	0,
	0,
	1,
	@PermissionGroupID,
	'EditClearinghouseConnection'
)

-- Delete
INSERT INTO Permissions
(
	Name,
	Description,
	ViewInMedicalOffice,
	ViewInBusinessManager,
	ViewInAdministrator,
	ViewInServiceManager,
	PermissionGroupID,
	PermissionValue
)
VALUES
(
	'Delete Clearinghouse Connection',
	'Delete a Clearinghouse Connection record.',
	0,
	0,
	0,
	1,
	@PermissionGroupID,
	'DeleteClearinghouseConnection'
)

-- Find
INSERT INTO Permissions
(
	Name,
	Description,
	ViewInMedicalOffice,
	ViewInBusinessManager,
	ViewInAdministrator,
	ViewInServiceManager,
	PermissionGroupID,
	PermissionValue
)
VALUES
(
	'Find ClearinghouseConnection',
	'Search and display the details of a ClearinghouseConnection record.',
	0,
	0,
	0,
	1,
	@PermissionGroupID,
	'FindClearinghouseConnection'
)

GO
---------------------------------------------------------------------------------------
--case 5446 - Modify data model to include InsuranceCompany table

--Create InsuranceCompany Table:
CREATE TABLE InsuranceCompany (
	-- fields that belong to this table:
	[InsuranceCompanyID] [int] IDENTITY (1, 1) NOT NULL,
	[InsuranceCompanyName] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	-- fields that are describing the Company:
	[AddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Country] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactPrefix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactFirstName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactMiddleName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactLastName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactSuffix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FaxExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	-- HCFA and EClaims properties:
	[BillSecondaryInsurance] [bit] NOT NULL ,
	[EClaimsAccepts] [bit] NOT NULL ,
	[BillingFormID] INT NOT NULL,
	[InsuranceProgramCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HCFADiagnosisReferenceFormatCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HCFASameAsInsuredFormatCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LocalUseFieldTypeCode] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ProviderNumberTypeID] [int] NULL ,
	[GroupNumberTypeID] [int] NULL ,
	[LocalUseProviderNumberTypeID] [int] NULL ,

	-- migration convenience fields:
	[CompanyTextID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	-- linkage:
	[ClearinghousePayerID] [int] NULL ,

	-- service fields:
	[CreatedPracticeID] [int] NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE InsuranceCompany ADD CONSTRAINT PK_InsuranceCompany 
PRIMARY KEY CLUSTERED (InsuranceCompanyID)
GO

ALTER TABLE [InsuranceCompanyPlan] ADD 
	[InsuranceCompanyID] [int] NULL,
	CONSTRAINT [FK_InsuranceCompany_ClearinghousePayersList] FOREIGN KEY 
	(
		[ClearinghousePayerID]
	) REFERENCES [ClearinghousePayersList] (
		[ClearinghousePayerID]
	),
	CONSTRAINT [FK_InsuranceCompanyPlan_InsuranceCompany] FOREIGN KEY 
	(
		[InsuranceCompanyID]
	) REFERENCES [InsuranceCompany] (
		[InsuranceCompanyID]
	)
GO

/*
ALTER TABLE [InsuranceCompanyPlan] DROP FK_InsuranceCompanyPlan_InsuranceCompany
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN InsuranceCompanyID
ALTER TABLE [InsuranceCompany] DROP PK_InsuranceCompany
DROP TABLE InsuranceCompany
*/
GO

---------------------------------------------------------------------------------------
--case 5383 - Added CopayAmount and Deductible fields to the InsuranceCompanyPlan

ALTER TABLE [InsuranceCompanyPlan] 
DROP
	DF_InsuranceCompanyPlan_CoPay,
	COLUMN Copay

ALTER TABLE [InsuranceCompanyPlan]
ADD 
	Copay MONEY NOT NULL CONSTRAINT [DF_InsuranceCompanyPlan_Copay] DEFAULT (0),
	Deductible MONEY NOT NULL CONSTRAINT [DF_InsuranceCompanyPlan_Deductible] DEFAULT (0)

GO

---------------------------------------------------------------------------------------
--case 2856 - Create tables for the licensing model

CREATE TABLE [dbo].[CustomerLicense] (
	[CustomerLicenseID] [int] IDENTITY (1, 1) NOT NULL ,
	[LicenseID] [int] NOT NULL ,
	[CustomerID] [int] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[License] (
	[LicenseID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[LicensePermission] (
	[LicensePermissionID] [int] IDENTITY (1, 1) NOT NULL ,
	[LicenseID] [int] NOT NULL ,
	[PermissionID] [int] NOT NULL ,
	[Allowed] [bit] NOT NULL ,
	[Denied] [bit] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomerLicense] WITH NOCHECK ADD 
	CONSTRAINT [PK_CustomerLicense] PRIMARY KEY  CLUSTERED 
	(
		[CustomerLicenseID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[License] WITH NOCHECK ADD 
	CONSTRAINT [PK_License] PRIMARY KEY  CLUSTERED 
	(
		[LicenseID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LicensePermission] WITH NOCHECK ADD 
	CONSTRAINT [PK_LicensePermission] PRIMARY KEY  CLUSTERED 
	(
		[LicensePermissionID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CustomerLicense] ADD 
	CONSTRAINT [DF_CustomerLicense_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_CustomerLicense_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_CustomerLicense_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_CustomerLicense_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

CREATE  INDEX [IX_CustomerLicense_CustomerID] ON [dbo].[CustomerLicense]([CustomerID]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[License] ADD 
	CONSTRAINT [DF_License_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_License_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_License_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_License_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

ALTER TABLE [dbo].[LicensePermission] ADD 
	CONSTRAINT [DF_LicensePermission_Allowed] DEFAULT (0) FOR [Allowed],
	CONSTRAINT [DF_LicensePermission_Denied] DEFAULT (0) FOR [Denied],
	CONSTRAINT [DF_LicensePermission_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_LicensePermission_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_LicensePermission_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_LicensePermission_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

CREATE  INDEX [IX_LicensePermission_LicenseID] ON [dbo].[LicensePermission]([LicenseID]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomerLicense] ADD 
	CONSTRAINT [FK_CustomerLicense_Customer] FOREIGN KEY 
	(
		[CustomerID]
	) REFERENCES [dbo].[Customer] (
		[CustomerID]
	),
	CONSTRAINT [FK_CustomerLicense_License] FOREIGN KEY 
	(
		[LicenseID]
	) REFERENCES [dbo].[License] (
		[LicenseID]
	)
GO

ALTER TABLE [dbo].[LicensePermission] ADD 
	CONSTRAINT [FK_LicensePermission_License] FOREIGN KEY 
	(
		[LicenseID]
	) REFERENCES [dbo].[License] (
		[LicenseID]
	),
	CONSTRAINT [FK_LicensePermission_Permissions] FOREIGN KEY 
	(
		[PermissionID]
	) REFERENCES [dbo].[Permissions] (
		[PermissionID]
	)
GO


---------------------------------------------------------------------------------------
--case 5892:   EClaims: insurance plan names are taken from the wrong record 

ALTER TABLE ClearinghousePayersList ADD [NameTransmitted] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

-- Migrate data to the new field:
UPDATE ClearinghousePayersList SET [NameTransmitted] = UPPER(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Name],'+',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' '),1,35))
GO


---------------------------------------------------------------------------------------
--case 6368 - Add licensed capability to hide document management tabs from application

--Add new permission, and auto-allow it for all non-Kareo groups

DECLARE @newPermID int
DECLARE @newPermGroupID int

INSERT INTO permissiongroup (name,description) VALUES ('Managing Documents','Using the Document Management System')

SET @newPermGroupID = SCOPE_IDENTITY()

INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Manage Documents','Use the Document Management System',0,0,1,1,@NewPermGroupID,'ManageDocuments')

SET @newPermID = SCOPE_IDENTITY()

DECLARE @currentSecurityGroupID int

DECLARE curse CURSOR
READ_ONLY
FOR 
	SELECT SecurityGroupID
	FROM dbo.SecurityGroup
	WHERE CustomerID IS NOT NULL

OPEN curse

FETCH NEXT FROM curse INTO @currentSecurityGroupID
WHILE (@@fetch_status = 0)
BEGIN
	INSERT INTO SecurityGroupPermissions
		(SecurityGroupID, PermissionID, Allowed,Denied)
	VALUES
		(@currentSecurityGroupID, @newPermID, 1, 0)
FETCH NEXT FROM curse INTO @currentSecurityGroupID
END

CLOSE curse
DEALLOCATE curse

GO


---------------------------------------------------------------------------------------
--case XXXX - Description
---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
