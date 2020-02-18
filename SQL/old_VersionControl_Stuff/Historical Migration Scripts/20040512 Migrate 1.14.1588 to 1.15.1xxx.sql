/*

DATABASE UPDATE SCRIPT

v1.14.1588 to v.1.15.1xxx
*/

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

BEGIN TRAN

/*
SELECT @@TRANCOUNT
ROLLBACK
*/


-- case 1848 changes:

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PracticeClearinghouseInfo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PracticeClearinghouseInfo]
GO

CREATE TABLE [dbo].[PracticeClearinghouseInfo] (
	[PK_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[PracticeID] [int] NOT NULL ,
	[PracticeEtin] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ClaimLogin] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ClaimPassword] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[StatementsLogin] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[StatementsPassword] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [TIMESTAMP] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PracticeClearinghouseInfo] ADD 
	CONSTRAINT [DF_PracticeClearinghouseInfo_PracticeEtin] DEFAULT (0) FOR [PracticeEtin],
	CONSTRAINT [DF_PracticeClearinghouseInfo_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_PracticeClearinghouseInfo_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_PracticeClearinghouseInfo_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_PracticeClearinghouseInfo_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID],
	CONSTRAINT [PK_PracticeClearinghouseInfo] PRIMARY KEY  NONCLUSTERED 
	(
		[PK_ID]
	)  ON [PRIMARY] 
GO

--------

CREATE TABLE [dbo].[ClearinghouseResponse] (
	[ClearinghouseResponseID] [int] IDENTITY (1, 1) NOT NULL ,
	[ResponseType] [int] NULL ,
	[PracticeID] [int] NULL ,
	[SourceAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileReceiveDate] [datetime] NULL ,
	[FileContents] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewedFlag] [bit] NULL ,
	[TIMESTAMP] [TIMESTAMP] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClearinghouseResponse] ADD 
	CONSTRAINT [DF_TransmissionReceipt_ReviewedFlag] DEFAULT (0) FOR [ReviewedFlag]
GO

------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PaymentAdvice]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PaymentAdvice]
GO

CREATE TABLE [dbo].[PaymentAdvice] (
	[PaymentAdviceID] [int] IDENTITY (1, 1) NOT NULL ,
	[PaymentAdviceFileTypeCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PracticeID] [int] NULL ,
	[SourceAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FileReceiveDate] [datetime] NULL ,
	[FileContents] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewedFlag] [bit] NOT NULL ,
	[TIMESTAMP] [TIMESTAMP] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PaymentAdvice] ADD 
	CONSTRAINT [DF_PaymentAdvice_ReviewedFlag] DEFAULT (0) FOR [ReviewedFlag],
	CONSTRAINT [PK_PaymentAdvice] PRIMARY KEY  CLUSTERED 
	(
		[PaymentAdviceID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PaymentAdvice] ADD 
	CONSTRAINT [FK_PaymentAdvice_PaymentAdviceFileType] FOREIGN KEY 
	(
		[PaymentAdviceFileTypeCode]
	) REFERENCES [dbo].[PaymentAdviceFileType] (
		[PaymentAdviceFileTypeCode]
	)
GO

-------

  -- can we add the column below right after the BillTransmissionID?
ALTER TABLE [dbo].[BillTransmission]  ADD [PracticeID] [int]
GO

--ALTER TABLE [dbo].[PaymentAdvice]  ADD
--	[PracticeID] [int],
--	SourceAddress [varchar] (100)
GO

-- fill PaymentAdviceFileType:
INSERT INTO PaymentAdviceFileType (PaymentAdviceFileTypeCode, Description) VALUES ('I', 'Print Image')

-- set ProxyMed payer numbers according to proxymed_payer_list.xls:
UPDATE InsuranceCompanyPlan SET EDIPayerNumber = 'BS032' WHERE (InsuranceCompanyPlanID = 6976)
UPDATE InsuranceCompanyPlan SET EDIPayerNumber = 'MR015' WHERE (InsuranceCompanyPlanID = 18340)
UPDATE InsuranceCompanyPlan SET EDIPayerNumber = 'MR034' WHERE (InsuranceCompanyPlanID = 18382)
GO

-- fill PracticeClearinghouseInfo for first two practices to try EDI:
INSERT INTO PracticeClearinghouseInfo (PracticeID, PracticeEtin, ClaimLogin, ClaimPassword, StatementsLogin, StatementsPassword)
 VALUES (24, 621693307, '50296151', '24jfortnoa', 'pmrr00', '111003')
INSERT INTO PracticeClearinghouseInfo (PracticeID, PracticeEtin, ClaimLogin, ClaimPassword, StatementsLogin, StatementsPassword)
 VALUES (37, 621613625, '50296151', '24jfortnoa', 'pmrr04', '111003')
GO

-- fill PracticeClearinghouseInfo:


----------------------------------


-- case 1855 changes


ALTER TABLE
	InsuranceCompanyPlan
DROP 
	CONSTRAINT DF_InsuranceCompanyPlan_InsuranceCompanyID,
	COLUMN InsuranceCompanyID
GO

DROP TABLE
	InsuranceCompany
GO

----------------------------------

ALTER TABLE [dbo].[Claim]  ADD
	[NonElectronicOverrideFlag] [bit]
GO

ALTER TABLE [dbo].[Claim] ADD 
	CONSTRAINT [DF_NonElectronicOverrideFlag] DEFAULT (0) FOR [NonElectronicOverrideFlag]
GO


UPDATE [dbo].[Claim]
SET [NonElectronicOverrideFlag] = 0
GO

----------------------------------


-- case 1795 changes:

ALTER TABLE [dbo].[ReferringPhysician]  ADD
	[AddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Country] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

----------------------------------

-- case 2058 changes:

ALTER TABLE [dbo].[PatientInsurance]  ADD
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

----------------------------------

-- case 2034 changes

--At this point issue the following command:

--
--textcopy /S k0.dc.kareo.com /U dev /P /D pmr_stage /T BillingForm /C Transform /W "WHERE BillingFormID = 1" /F c:\cvsroot_kareo\PMR\Software\Billing\Libraries\PMR.Billing.ServiceImplementation\Bill_RAW-HCFA.xsl /I

--replace 10.0.0.10 with database ip, pmr_copy with database name, and ensure path is valid


--At this point issue the following command:

--textcopy /S k0.dc.kareo.com /U dev /P /D pmr_stage /T BillingForm /C Transform /W "WHERE BillingFormID = 2" /F c:\cvsroot\PMR\Software\Billing\Libraries\PMR.Billing.ServiceImplementation\Bill_RAW-HCFA-MedicaidOhio.xsl /I
--textcopy /S k0.dc.kareo.com /U dev /P /D pmr_stage /T BillingForm /C Transform /W "WHERE BillingFormID = 2" /F c:\cvsroot_kareo\PMR\Software\Billing\Libraries\PMR.Billing.ServiceImplementation\Bill_RAW-HCFA-MedicaidOhio.xsl /I
--replace 10.0.0.10 with database ip, pmr_copy with database name, and ensure path is valid



----------------------------------

-- Case 2029 start:

ALTER TABLE [dbo].[Practice]  ADD
	[EnrolledForEClaims] [bit]
GO

ALTER TABLE [dbo].[Practice] ADD 
	CONSTRAINT [DF_EnrolledForEClaims] DEFAULT (0) FOR [EnrolledForEClaims]
GO

UPDATE [dbo].[Practice]	SET [EnrolledForEClaims] = 0
GO
UPDATE [dbo].[Practice]	SET [EnrolledForEClaims] = 1 WHERE PracticeID = 37
GO

----



ALTER TABLE [dbo].[Practice]  ADD
	[EnrolledForEStatements] [bit]
GO

ALTER TABLE [dbo].[Practice] ADD 
	CONSTRAINT [DF_EnrolledForEStatements] DEFAULT (0) FOR [EnrolledForEStatements]
GO

UPDATE [dbo].[Practice]	SET [EnrolledForEStatements] = 0
GO
UPDATE [dbo].[Practice]	SET [EnrolledForEStatements] = 1 WHERE PracticeID = 37
GO

----

ALTER TABLE [dbo].[InsuranceCompanyPlan]  ADD
	[IsGovernment] [bit],
	[StateSpecific] [varchar] (2),
	[EClaimsRequiresEnrollment] [bit],
	[EClaimsRequiresAuthorization] [bit],
	[EClaimsRequiresProviderID] [bit],
	[EClaimsResponseLevel] [int]
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD 
	CONSTRAINT [DF_EClaimsRequiresEnrollment] DEFAULT (0) FOR [EClaimsRequiresEnrollment]
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD 
	CONSTRAINT [DF_EClaimsRequiresAuthorization] DEFAULT (0) FOR [EClaimsRequiresAuthorization]
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD 
	CONSTRAINT [DF_EClaimsRequiresProviderID] DEFAULT (0) FOR [EClaimsRequiresProviderID]
GO


UPDATE [dbo].[InsuranceCompanyPlan]	SET [EClaimsRequiresEnrollment] = 0
GO
UPDATE [dbo].[InsuranceCompanyPlan]	SET [EClaimsRequiresAuthorization] = 0
GO
UPDATE [dbo].[InsuranceCompanyPlan]	SET [EClaimsRequiresProviderID] = 0
GO

----

ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan]  ADD
	[EClaimsPracticeIsEnrolled] [bit],
	[EStatementsPracticeIsEnrolled] [bit],
	[EClaimsProviderID] [varchar] (32)
GO

ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan] ADD
	CONSTRAINT [DF_EClaimsPracticeIsEnrolled] DEFAULT (0) FOR [EClaimsPracticeIsEnrolled]
GO

ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan] ADD
	CONSTRAINT [DF_EStatementsPracticeIsEnrolled] DEFAULT (0) FOR [EStatementsPracticeIsEnrolled]
GO


UPDATE [dbo].[PracticeToInsuranceCompanyPlan]	SET [EClaimsPracticeIsEnrolled] = 0
GO
UPDATE [dbo].[PracticeToInsuranceCompanyPlan]	SET [EStatementsPracticeIsEnrolled] = 0
GO

-- Case 2029 end

---------------------------------------------

/*
Script created by SQL Compare from Red Gate Software Ltd at 6/10/2004 16:36:13
Run this script on k0.dc.kareo.com.pmr_stage to make it the same as k0.dc.kareo.com.pmr_stage_old
Please back up your database before running this script
*/


ALTER TABLE [dbo].[GroupPermissions] DROP
CONSTRAINT [FK_GroupPermissions_Groups],
CONSTRAINT [FK_GroupPermissions_Permissions]
GO
ALTER TABLE [dbo].[UserGroups] DROP
CONSTRAINT [FK_UserGroups_Groups],
CONSTRAINT [FK_UserGroups_Users]
GO
ALTER TABLE [dbo].[UserPractices] DROP
CONSTRAINT [FK_UserPractices_Users],
CONSTRAINT [FK_UserPractices_Practice]
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [PK_Users]
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [DF_Users_CreatedDate]
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [DF_Users_CreatedUserID]
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [DF_Users_ModifiedDate]
GO
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [DF_Users_ModifiedUserID]
GO
ALTER TABLE [dbo].[Permissions] DROP CONSTRAINT [PK_Permissions]
GO
ALTER TABLE [dbo].[Permissions] DROP CONSTRAINT [DF_Permissions_CreatedDate]
GO
ALTER TABLE [dbo].[Permissions] DROP CONSTRAINT [DF_Permissions_CreatedUserID]
GO
ALTER TABLE [dbo].[Permissions] DROP CONSTRAINT [DF_Permissions_ModifiedDate]
GO
ALTER TABLE [dbo].[Permissions] DROP CONSTRAINT [DF_Permissions_ModifiedUserID]
GO
ALTER TABLE [dbo].[SecurityGroup] DROP CONSTRAINT [PK_SecurityGroup]
GO
ALTER TABLE [dbo].[SecurityGroup] DROP CONSTRAINT [DF_SecurityGroup_CreatedDate]
GO
ALTER TABLE [dbo].[SecurityGroup] DROP CONSTRAINT [DF_SecurityGroup_ModifiedDate]
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [PK_GroupPermissions]
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [IX_GroupPermissions]
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [DF_GroupPermissions_CreatedDate]
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [DF_GroupPerm_CreatedUserID]
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [DF_GroupPermissions_ModifiedDate]
GO
ALTER TABLE [dbo].[GroupPermissions] DROP CONSTRAINT [DF_GroupPerm_ModifiedUserID]
GO
ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [PK_Groups]
GO
ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [DF_Groups_CreatedDate]
GO
ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [DF_Groups_CreatedUserID]
GO
ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [DF_Groups_ModifiedDate]
GO
ALTER TABLE [dbo].[Groups] DROP CONSTRAINT [DF_Groups_ModifiedUserID]
GO
ALTER TABLE [dbo].[SubApplications] DROP CONSTRAINT [PK_Functionality]
GO
ALTER TABLE [dbo].[SubApplications] DROP CONSTRAINT [DF_Functionality_Enabled]
GO
ALTER TABLE [dbo].[SubApplications] DROP CONSTRAINT [DF_SubApplications_CreatedDate]
GO
ALTER TABLE [dbo].[SubApplications] DROP CONSTRAINT [DF_SubApplications_ModifiedDate]
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [PK_UserGroups]
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [IX_UserGroups]
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [DF_UserGroups_CreatedDate]
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [DF_UserGroups_CreatedUserID]
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [DF_UserGroups_ModifiedDate]
GO
ALTER TABLE [dbo].[UserGroups] DROP CONSTRAINT [DF_UserGroups_ModifiedUserID]
GO
ALTER TABLE [dbo].[UserPractices] DROP CONSTRAINT [PK_UserPractices]
GO
ALTER TABLE [dbo].[UserPractices] DROP CONSTRAINT [IX_UserPractices]
GO
ALTER TABLE [dbo].[UserPractices] DROP CONSTRAINT [DF_UserPractices_CreatedDate]
GO
ALTER TABLE [dbo].[UserPractices] DROP CONSTRAINT [DF_UserPrac_CreatedUserID]
GO
ALTER TABLE [dbo].[UserPractices] DROP CONSTRAINT [DF_UserPractices_ModifiedDate]
GO
ALTER TABLE [dbo].[UserPractices] DROP CONSTRAINT [DF_UserPrac_ModifiedUserID]
GO
ALTER TABLE [dbo].[Tokens] DROP CONSTRAINT [PK_Tokens]
GO
DROP STATISTICS [dbo].[PatientInsurance].[hind_1501964427_1A_3A]
GO
DROP INDEX [dbo].[Tokens].[TokensToken]
GO
DROP STATISTICS [dbo].[UserGroups].[Statistic_UserId]
GO
DROP STATISTICS [dbo].[UserGroups].[Statistic_GroupId]
GO
DROP TABLE [dbo].[Temp_ProcedureImport]
GO
DROP TABLE [dbo].[TEMP_PracticeFee]
GO
DROP TABLE [dbo].[TEMP_NewBillClaim]
GO
DROP TABLE [dbo].[TEMP_ClaimTransaction]
GO
DROP TABLE [dbo].[TEMP_Claim]
GO
DROP TABLE [dbo].[TEMP_BillClaim]
GO
CREATE TABLE [dbo].[tmp_rg_xx_Tokens]
(
[TokenID] [int] NOT NULL IDENTITY(1, 1),
[Token] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [int] NOT NULL,
[PracticeID] [int] NOT NULL,
[Created] [datetime] NOT NULL,
[Expires] [datetime] NOT NULL,
[RecordTimeStamp] [timestamp] NOT NULL
)

GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_Tokens] ON
GO
INSERT INTO [dbo].[tmp_rg_xx_Tokens]([TokenID], [Token], [UserID], [PracticeID], [Created], [Expires]) SELECT [TokenId], [Token], [UserId], [PracticeID], [Created], [Expires] FROM [dbo].[Tokens]
GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_Tokens] OFF
GO
DROP TABLE [dbo].[Tokens]
GO
sp_rename N'[dbo].[tmp_rg_xx_Tokens]', N'Tokens'
GO
ALTER TABLE [dbo].[Tokens] ADD CONSTRAINT [PK_Tokens] PRIMARY KEY CLUSTERED  ([TokenID])
CREATE NONCLUSTERED INDEX [TokensToken] ON [dbo].[Tokens] ([Token])
GO
CREATE TABLE [dbo].[tmp_rg_xx_Groups]
(
[GroupID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Groups_CreatedDate] DEFAULT (getdate()),
[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_Groups_CreatedUserID] DEFAULT (0),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Groups_ModifiedDate] DEFAULT (getdate()),
[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_Groups_ModifiedUserID] DEFAULT (0),
[RecordTimeStamp] [timestamp] NOT NULL
)

GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_Groups] ON
GO
INSERT INTO [dbo].[tmp_rg_xx_Groups]([GroupID], [Name], [Description], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) SELECT [GroupId], [Name], [Description], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID] FROM [dbo].[Groups]
GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_Groups] OFF
GO
DROP TABLE [dbo].[Groups]
GO
sp_rename N'[dbo].[tmp_rg_xx_Groups]', N'Groups'
GO
ALTER TABLE [dbo].[Groups] ADD CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED  ([GroupID])
GO
CREATE TABLE [dbo].[tmp_rg_xx_UserGroups]
(
[LinkID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[GroupID] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_UserGroups_CreatedDate] DEFAULT (getdate()),
[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_UserGroups_CreatedUserID] DEFAULT (0),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_UserGroups_ModifiedDate] DEFAULT (getdate()),
[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_UserGroups_ModifiedUserID] DEFAULT (0),
[RecordTimeStamp] [timestamp] NOT NULL
)

GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_UserGroups] ON
GO
INSERT INTO [dbo].[tmp_rg_xx_UserGroups]([LinkID], [UserID], [GroupID], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) SELECT [LinkId], [UserId], [GroupId], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID] FROM [dbo].[UserGroups]
GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_UserGroups] OFF
GO
DROP TABLE [dbo].[UserGroups]
GO
sp_rename N'[dbo].[tmp_rg_xx_UserGroups]', N'UserGroups'
GO
ALTER TABLE [dbo].[UserGroups] ADD CONSTRAINT [PK_UserGroups] PRIMARY KEY CLUSTERED  ([LinkID])
CREATE STATISTICS [Statistic_UserId] ON [dbo].[UserGroups] ([UserID])
CREATE STATISTICS [Statistic_GroupId] ON [dbo].[UserGroups] ([GroupID])
GO
CREATE TABLE [dbo].[tmp_rg_xx_GroupPermissions]
(
[LinkID] [int] NOT NULL IDENTITY(1, 1),
[GroupID] [int] NOT NULL,
[PermissionID] [int] NOT NULL,
[Allowed] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_GroupPermissions_CreatedDate] DEFAULT (getdate()),
[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_GroupPerm_CreatedUserID] DEFAULT (0),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_GroupPermissions_ModifiedDate] DEFAULT (getdate()),
[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_GroupPerm_ModifiedUserID] DEFAULT (0),
[RecordTimeStamp] [timestamp] NOT NULL
)

GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_GroupPermissions] ON
GO
INSERT INTO [dbo].[tmp_rg_xx_GroupPermissions]([LinkID], [GroupID], [PermissionID], [Allowed], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) SELECT [LinkId], [GroupId], [PermissionId], [Allowed], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID] FROM [dbo].[GroupPermissions]
GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_GroupPermissions] OFF
GO
DROP TABLE [dbo].[GroupPermissions]
GO
sp_rename N'[dbo].[tmp_rg_xx_GroupPermissions]', N'GroupPermissions'
GO
ALTER TABLE [dbo].[GroupPermissions] ADD CONSTRAINT [PK_GroupPermissions] PRIMARY KEY CLUSTERED  ([LinkID])
GO
CREATE TABLE [dbo].[tmp_rg_xx_UserPractices]
(
[LinkID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[PracticeID] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_UserPractices_CreatedDate] DEFAULT (getdate()),
[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_UserPrac_CreatedUserID] DEFAULT (0),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_UserPractices_ModifiedDate] DEFAULT (getdate()),
[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_UserPrac_ModifiedUserID] DEFAULT (0),
[RecordTimeStamp] [timestamp] NOT NULL
)

GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_UserPractices] ON
GO
INSERT INTO [dbo].[tmp_rg_xx_UserPractices]([LinkID], [UserID], [PracticeID], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) SELECT [LinkId], [UserId], [PracticeID], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID] FROM [dbo].[UserPractices]
GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_UserPractices] OFF
GO
DROP TABLE [dbo].[UserPractices]
GO
sp_rename N'[dbo].[tmp_rg_xx_UserPractices]', N'UserPractices'
GO
ALTER TABLE [dbo].[UserPractices] ADD CONSTRAINT [PK_UserPractices] PRIMARY KEY CLUSTERED  ([LinkID])
GO
CREATE TABLE [dbo].[tmp_rg_xx_Permissions]
(
[PermissionID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Permissions_CreatedDate] DEFAULT (getdate()),
[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_Permissions_CreatedUserID] DEFAULT (0),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Permissions_ModifiedDate] DEFAULT (getdate()),
[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_Permissions_ModifiedUserID] DEFAULT (0),
[RecordTimeStamp] [timestamp] NOT NULL
)

GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_Permissions] ON
GO
INSERT INTO [dbo].[tmp_rg_xx_Permissions]([PermissionID], [Name], [Description], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) SELECT [PermissionId], [Name], [Description], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID] FROM [dbo].[Permissions]
GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_Permissions] OFF
GO
DROP TABLE [dbo].[Permissions]
GO
sp_rename N'[dbo].[tmp_rg_xx_Permissions]', N'Permissions'
GO
ALTER TABLE [dbo].[Permissions] ADD CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED  ([PermissionID])
GO
CREATE TABLE [dbo].[tmp_rg_xx_SubApplications]
(
[SubApplicationID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MenuText] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TooltipText] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AssemblyUrl] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TypeName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [tinyint] NOT NULL CONSTRAINT [DF_Functionality_Enabled] DEFAULT (1),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_SubApplications_CreatedDate] DEFAULT (getdate()),
[CreatedUserID] [int] NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SubApplications_ModifiedDate] DEFAULT (getdate()),
[ModifiedUserID] [int] NOT NULL,
[RecordTimeStamp] [timestamp] NOT NULL
)

GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_SubApplications] ON
GO
INSERT INTO [dbo].[tmp_rg_xx_SubApplications]([SubApplicationID], [Name], [MenuText], [TooltipText], [AssemblyUrl], [TypeName], [Enabled], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) SELECT [SubApplicationId], [Name], [MenuText], [TooltipText], [AssemblyUrl], [TypeName], [Enabled], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID] FROM [dbo].[SubApplications]
GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_SubApplications] OFF
GO
DROP TABLE [dbo].[SubApplications]
GO
sp_rename N'[dbo].[tmp_rg_xx_SubApplications]', N'SubApplications'
GO
ALTER TABLE [dbo].[SubApplications] ADD CONSTRAINT [PK_Functionality] PRIMARY KEY CLUSTERED  ([SubApplicationID])
GO
CREATE TABLE [dbo].[tmp_rg_xx_Users]
(
[UserID] [int] NOT NULL IDENTITY(1, 1),
[NtlmName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Users_CreatedDate] DEFAULT (getdate()),
[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_Users_CreatedUserID] DEFAULT (0),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Users_ModifiedDate] DEFAULT (getdate()),
[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_Users_ModifiedUserID] DEFAULT (0),
[RecordTimeStamp] [timestamp] NOT NULL,
[Prefix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkPhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternativePhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternativePhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_Users] ON
GO
INSERT INTO [dbo].[tmp_rg_xx_Users]([UserID], [NtlmName], [Password], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID], [Prefix], [FirstName], [MiddleName], [LastName], [Suffix], [AddressLine1], [AddressLine2], [City], [State], [Country], [ZipCode], [WorkPhone], [WorkPhoneExt], [AlternativePhone], [AlternativePhoneExt], [EmailAddress], [Notes]) SELECT [UserId], [NtlmName], [Password], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID], [Prefix], [FirstName], [MiddleName], [LastName], [Suffix], [AddressLine1], [AddressLine2], [City], [State], [Country], [ZipCode], [WorkPhone], [WorkPhoneExt], [AlternativePhone], [AlternativePhoneExt], [EmailAddress], [Notes] FROM [dbo].[Users]
GO
SET IDENTITY_INSERT [dbo].[tmp_rg_xx_Users] OFF
GO
DROP TABLE [dbo].[Users]
GO
sp_rename N'[dbo].[tmp_rg_xx_Users]', N'Users'
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED  ([UserID])
GO
CREATE TABLE [dbo].[tmp_rg_xx_SecurityGroup]
(
[GroupName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_SecurityGroup_CreatedDate] DEFAULT (getdate()),
[CreatedUserID] [int] NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SecurityGroup_ModifiedDate] DEFAULT (getdate()),
[ModifiedUserID] [int] NOT NULL,
[RecordTimeStamp] [timestamp] NOT NULL
)

GO
INSERT INTO [dbo].[tmp_rg_xx_SecurityGroup]([CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) SELECT [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID] FROM [dbo].[SecurityGroup]
GO
DROP TABLE [dbo].[SecurityGroup]
GO
sp_rename N'[dbo].[tmp_rg_xx_SecurityGroup]', N'SecurityGroup'
GO
ALTER TABLE [dbo].[SecurityGroup] ADD CONSTRAINT [PK_SecurityGroup] PRIMARY KEY CLUSTERED  ([GroupName])
GO
ALTER TABLE [dbo].[GroupPermissions] ADD CONSTRAINT [IX_GroupPermissions] UNIQUE NONCLUSTERED  ([GroupID], [PermissionID])
GO
ALTER TABLE [dbo].[UserGroups] ADD CONSTRAINT [IX_UserGroups] UNIQUE NONCLUSTERED  ([UserID], [GroupID])
GO
ALTER TABLE [dbo].[UserPractices] ADD CONSTRAINT [IX_UserPractices] UNIQUE NONCLUSTERED  ([UserID], [PracticeID])
GO
ALTER TABLE [dbo].[GroupPermissions] ADD
CONSTRAINT [FK_GroupPermissions_Groups] FOREIGN KEY ([GroupID]) REFERENCES [dbo].[Groups] ([GroupID]),
CONSTRAINT [FK_GroupPermissions_Permissions] FOREIGN KEY ([PermissionID]) REFERENCES [dbo].[Permissions] ([PermissionID])
ALTER TABLE [dbo].[UserGroups] ADD
CONSTRAINT [FK_UserGroups_Groups] FOREIGN KEY ([GroupID]) REFERENCES [dbo].[Groups] ([GroupID]),
CONSTRAINT [FK_UserGroups_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
ALTER TABLE [dbo].[UserPractices] ADD
CONSTRAINT [FK_UserPractices_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID]),
CONSTRAINT [FK_UserPractices_Practice] FOREIGN KEY ([PracticeID]) REFERENCES [dbo].[Practice] ([PracticeID])
GO

--===========================================================================
-- TR -- IU -- ENCOUNTER -- CHANGE TIME
--===========================================================================
ALTER TRIGGER tr_IU_Encounter_ChangeTime ON dbo.Encounter
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(DateCreated)
	BEGIN
		UPDATE E
			SET DateCreated =  dbo.fn_ReplaceTimeInDate(i.DateCreated)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(DatePosted)
	BEGIN
		UPDATE E
			SET DatePosted =  dbo.fn_ReplaceTimeInDate(i.DatePosted)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(DateOfService)
	BEGIN
		UPDATE E
			SET DateOfService =  dbo.fn_ReplaceTimeInDate(i.DateOfService)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(DateOfInjury)
	BEGIN
		UPDATE E
			SET DateOfInjury =  dbo.fn_ReplaceTimeInDate(i.DateOfInjury)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	
	IF UPDATE(InitialTreatmentDate)
	BEGIN
		UPDATE E
			SET InitialTreatmentDate =  dbo.fn_ReplaceTimeInDate(i.InitialTreatmentDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(SimilarIllnessDate)
	BEGIN
		UPDATE E
			SET SimilarIllnessDate =  dbo.fn_ReplaceTimeInDate(i.SimilarIllnessDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(LastWorkedDate)
	BEGIN
		UPDATE E
			SET LastWorkedDate =  dbo.fn_ReplaceTimeInDate(i.LastWorkedDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(ReturnToWorkDate)
	BEGIN
		UPDATE E
			SET ReturnToWorkDate =  dbo.fn_ReplaceTimeInDate(i.ReturnToWorkDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(DisabilityBeginDate)
	BEGIN
		UPDATE E
			SET DisabilityBeginDate =  dbo.fn_ReplaceTimeInDate(i.DisabilityBeginDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(DisabilityEndDate)
	BEGIN
		UPDATE E
			SET DisabilityEndDate =  dbo.fn_ReplaceTimeInDate(i.DisabilityEndDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(HospitalizationBeginDate)
	BEGIN
		UPDATE E
			SET HospitalizationBeginDate =  dbo.fn_ReplaceTimeInDate(i.HospitalizationBeginDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(HospitalizationEndDate)
	BEGIN
		UPDATE E
			SET HospitalizationEndDate =  dbo.fn_ReplaceTimeInDate(i.HospitalizationEndDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	



	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END



GO

--===========================================================================
-- TR -- IU -- CLAIM TRANSACTION -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_ClaimTransaction_ChangeTime ON dbo.ClaimTransaction
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(ReferenceDate)
	BEGIN
		UPDATE CT
			SET ReferenceDate =  dbo.fn_ReplaceTimeInDate(i.ReferenceDate)
		FROM dbo.ClaimTransaction CT INNER JOIN
			inserted i ON
				CT.ClaimTransactionID = i.ClaimTransactionID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END


	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END



GO

--===========================================================================
-- TR -- IU -- ENCOUNTER PROCEDURE -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_EncounterProcedure_ChangeTime ON dbo.EncounterProcedure
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(ProcedureDateOfService)
	BEGIN
		UPDATE EP
			SET ProcedureDateOfService =  dbo.fn_ReplaceTimeInDate(i.ProcedureDateOfService)
		FROM dbo.EncounterProcedure EP INNER JOIN
			inserted i ON
				EP.EncounterProcedureID = i.EncounterProcedureID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END


	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END



GO

--===========================================================================
-- TR -- IU -- HANDHELD ENCOUNTER -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_HandheldEncounter_ChangeTime ON dbo.HandheldEncounter
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(DateCreated)
	BEGIN
		UPDATE HE
			SET DateCreated =  dbo.fn_ReplaceTimeInDate(i.DateCreated)
		FROM dbo.HandheldEncounter HE INNER JOIN
			inserted i ON
				HE.HandheldEncounterID = i.HandheldEncounterID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(DateOfService)
	BEGIN
		UPDATE HE
			SET DateOfService =  dbo.fn_ReplaceTimeInDate(i.DateOfService)
		FROM dbo.HandheldEncounter HE INNER JOIN
			inserted i ON
				HE.HandheldEncounterID = i.HandheldEncounterID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END



GO

--===========================================================================
-- TR -- IU -- PATIENT -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_Patient_ChangeTime ON dbo.Patient
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(DOB)
	BEGIN
		UPDATE P
			SET DOB =  dbo.fn_ReplaceTimeInDate(i.DOB)
		FROM dbo.Patient P INNER JOIN
			inserted i ON
				P.PatientID = i.PatientID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END



GO

--===========================================================================
-- TR -- IU -- PATIENT AUTHORIZATION -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_PatientAuthorization_ChangeTime ON dbo.PatientAuthorization
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(StartDate)
	BEGIN
		UPDATE PA
			SET StartDate =  dbo.fn_ReplaceTimeInDate(i.StartDate)
		FROM dbo.PatientAuthorization PA INNER JOIN
			inserted i ON
				PA.PatientAuthorizationID = i.PatientAuthorizationID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(EndDate)
	BEGIN
		UPDATE PA
			SET EndDate =  dbo.fn_ReplaceTimeInDate(i.EndDate)
		FROM dbo.PatientAuthorization PA INNER JOIN
			inserted i ON
				PA.PatientAuthorizationID = i.PatientAuthorizationID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END



GO

--===========================================================================
-- TR -- IU -- PATIENT INSURANCE -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_PatientInsurance_ChangeTime ON dbo.PatientInsurance
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(PolicyStartDate)
	BEGIN
		UPDATE PI
			SET PolicyStartDate =  dbo.fn_ReplaceTimeInDate(i.PolicyStartDate)
		FROM dbo.PatientInsurance PI INNER JOIN
			inserted i ON
				PI.PatientInsuranceID = i.PatientInsuranceID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(PolicyEndDate)
	BEGIN
		UPDATE PI
			SET PolicyEndDate =  dbo.fn_ReplaceTimeInDate(i.PolicyEndDate)
		FROM dbo.PatientInsurance PI INNER JOIN
			inserted i ON
				PI.PatientInsuranceID = i.PatientInsuranceID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END



GO

--===========================================================================
-- TR -- IU -- PAYMENT -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_Payment_ChangeTime ON dbo.Payment
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(PaymentDate)
	BEGIN
		UPDATE P
			SET PaymentDate =  dbo.fn_ReplaceTimeInDate(i.PaymentDate)
		FROM dbo.Payment P INNER JOIN
			inserted i ON
				P.PaymentID = i.PaymentID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END


	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END



GO
/*
update referringphysician set prefix = '' where prefix is null 
update referringphysician set firstname = '' where firstname is null 
update referringphysician set middlename = '' where middlename is null 
update referringphysician set lastname = '' where lastname is null 
update referringphysician set suffix = '' where suffix is null 
 
alter table referringphysician alter column prefix varchar(16) not null  
alter table referringphysician alter column firstname varchar(64) not null 
alter table referringphysician alter column middlename varchar(64) not null 
alter table referringphysician alter column lastname varchar(64) not null 
alter table referringphysician alter column suffix varchar(16) not null 
*/


--COMMIT
