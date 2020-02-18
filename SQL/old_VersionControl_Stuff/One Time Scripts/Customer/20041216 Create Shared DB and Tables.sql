CREATE DATABASE [superbill_shared] ON (NAME = N'superbill_shared_Data', FILENAME = N'C:\database\superbill_shared\superbill_shared_Data.mdf' , SIZE = 5, FILEGROWTH = 10%) LOG ON (NAME = N'superbill_shared_Log', FILENAME = N'C:\database\superbill_shared\superbill_shared_Log.LDF' , SIZE = 1, FILEGROWTH = 10%)
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO

exec sp_dboption N'superbill_shared', N'autoclose', N'false'
GO

exec sp_dboption N'superbill_shared', N'bulkcopy', N'false'
GO

exec sp_dboption N'superbill_shared', N'trunc. log', N'false'
GO

exec sp_dboption N'superbill_shared', N'torn page detection', N'true'
GO

exec sp_dboption N'superbill_shared', N'read only', N'false'
GO

exec sp_dboption N'superbill_shared', N'dbo use', N'false'
GO

exec sp_dboption N'superbill_shared', N'single', N'false'
GO

exec sp_dboption N'superbill_shared', N'autoshrink', N'false'
GO

exec sp_dboption N'superbill_shared', N'ANSI null default', N'false'
GO

exec sp_dboption N'superbill_shared', N'recursive triggers', N'false'
GO

exec sp_dboption N'superbill_shared', N'ANSI nulls', N'false'
GO

exec sp_dboption N'superbill_shared', N'concat null yields null', N'false'
GO

exec sp_dboption N'superbill_shared', N'cursor close on commit', N'false'
GO

exec sp_dboption N'superbill_shared', N'default to local cursor', N'false'
GO

exec sp_dboption N'superbill_shared', N'quoted identifier', N'false'
GO

exec sp_dboption N'superbill_shared', N'ANSI warnings', N'false'
GO

exec sp_dboption N'superbill_shared', N'auto create statistics', N'true'
GO

exec sp_dboption N'superbill_shared', N'auto update statistics', N'true'
GO

if( ( (@@microsoftversion / power(2, 24) = 8) and (@@microsoftversion & 0xffff >= 724) ) or ( (@@microsoftversion / power(2, 24) = 7) and (@@microsoftversion & 0xffff >= 1082) ) )
exec sp_dboption N'superbill_shared', N'db chaining', N'false'
GO

USE [superbill_shared]
GO

CREATE TABLE [dbo].[BillingForm] (
	[BillingFormID] [int] IDENTITY (1, 1) NOT NULL ,
	[FormType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FormName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Transform] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TIMESTAMP] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[ClearinghousePayersList] (
	[ClearinghousePayerID] [int] IDENTITY (1, 1) NOT NULL ,
	[ClearinghouseID] [int] NULL ,
	[PayerNumber] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Name] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Notes] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StateSpecific] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[IsPaperOnly] [bit] NOT NULL ,
	[IsGovernment] [bit] NOT NULL ,
	[IsCommercial] [bit] NOT NULL ,
	[IsParticipating] [bit] NOT NULL ,
	[IsProviderIdRequired] [bit] NOT NULL ,
	[IsEnrollmentRequired] [bit] NOT NULL ,
	[IsAuthorizationRequired] [bit] NOT NULL ,
	[IsTestRequired] [bit] NOT NULL ,
	[ResponseLevel] [int] NULL ,
	[IsNewPayer] [bit] NOT NULL ,
	[DateNewPayerSince] [datetime] NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[TIMESTAMP] [timestamp] NULL ,
	[Active] [bit] NOT NULL ,
	[IsModifiedPayer] [bit] NOT NULL ,
	[DateModifiedPayerSince] [datetime] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Country] (
	[Country] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ShortName] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DemographicAnnualCompanyRevenue] (
	[AnnualCompanyRevenueID] [int] NOT NULL ,
	[AnnualCompanyRevenueCaption] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DemographicMarketingSource] (
	[MarketingSourceID] [int] NOT NULL ,
	[MarketingSourceCaption] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DemographicNumOfEmployees] (
	[NumOfEmployeesID] [int] NOT NULL ,
	[NumOfEmployeesCaption] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DemographicNumOfPhysicians] (
	[NumOfPhysiciansID] [int] NOT NULL ,
	[NumOfPhysiciansCaption] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DemographicNumOfUsers] (
	[NumOfUsersID] [int] NOT NULL ,
	[NumOfUsersCaption] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DiagnosisCodeDictionary] (
	[DiagnosisCodeDictionaryID] [int] IDENTITY (1, 1) NOT NULL ,
	[DiagnosisCode] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DiagnosisName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Description] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Gender] (
	[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LongName] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[GroupNumberType] (
	[GroupNumberTypeID] [int] IDENTITY (1, 1) NOT NULL ,
	[TypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ANSIReferenceIdentificationQualifier] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[HCFADiagnosisReferenceFormat] (
	[HCFADiagnosisReferenceFormatCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FormatName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[TIMESTAMP] [timestamp] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[HCFASameAsInsuredFormat] (
	[HCFASameAsInsuredFormatCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FormatName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[TIMESTAMP] [timestamp] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[InsuranceProgram] (
	[InsuranceProgramCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ProgramName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[TIMESTAMP] [timestamp] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PermissionGroup] (
	[PermissionGroupID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ProcedureModifier] (
	[ProcedureModifierCode] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ModifierName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CreatedDate] [datetime] NULL ,
	[CreatedUserID] [int] NULL ,
	[ModifiedDate] [datetime] NULL ,
	[ModifiedUserID] [int] NULL ,
	[RecordTimeStamp] [timestamp] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ProviderNumberType] (
	[ProviderNumberTypeID] [int] IDENTITY (1, 1) NOT NULL ,
	[TypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ANSIReferenceIdentificationQualifier] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SecurityGroup] (
	[SecurityGroupID] [int] IDENTITY (1, 1) NOT NULL ,
	[CustomerID] [int] NULL ,
	[SecurityGroupName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SecurityGroupDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL ,
	[ViewInMedicalOffice] [bit] NOT NULL ,
	[ViewInBusinessManager] [bit] NOT NULL ,
	[ViewInAdministrator] [bit] NOT NULL ,
	[ViewInServiceManager] [bit] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SharedSystemPropertiesAndValues] (
	[PropertyName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Value] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PropertyDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ValueType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[State] (
	[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LongName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SubscriptionLastRun] (
	[TableName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LastUpdatedDate] [datetime] NOT NULL ,
	[ManuallyMaintained] [bit] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TypeOfService] (
	[TypeOfServiceCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[TIMESTAMP] [timestamp] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Customer] (
	[CustomerID] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Zip] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumOfEmployeesID] [int] NOT NULL ,
	[NumOfUsersID] [int] NOT NULL ,
	[NumOfPhysiciansID] [int] NOT NULL ,
	[AnnualCompanyRevenueID] [int] NOT NULL ,
	[ContactPrefix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactFirstName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactMiddleName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactLastName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactSuffix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactTitle] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactPhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactEmail] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MarketingSourceID] [int] NOT NULL ,
	[CustomerType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AccountLocked] [bit] NOT NULL ,
	[DatabaseServerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DatabaseName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DatabaseUsername] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DatabasePassword] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DBActive] [bit] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[Comments] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE TABLE [dbo].[InsuranceCompanyPlan] (
	[InsuranceCompanyPlanID] [int] IDENTITY (1, 1) NOT NULL ,
	[PlanName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
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
	[CoPay] [bit] NOT NULL ,
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MM_CompanyID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL ,
	[InsuranceProgramCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HCFADiagnosisReferenceFormatCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HCFASameAsInsuredFormatCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EDIPayerNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LocalUseFieldTypeCode] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ProviderNumberTypeID] [int] NULL ,
	[GroupNumberTypeID] [int] NULL ,
	[LocalUseProviderNumberTypeID] [int] NULL ,
	[BillingFormID] [int] NOT NULL ,
	[IsGovernment] [bit] NULL ,
	[StateSpecific] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EClaimsRequiresEnrollment] [bit] NOT NULL ,
	[EClaimsRequiresAuthorization] [bit] NOT NULL ,
	[EClaimsRequiresProviderID] [bit] NOT NULL ,
	[EClaimsResponseLevel] [int] NULL ,
	[EClaimsPaperOnly] [bit] NOT NULL ,
	[EClaimsRequiresTest] [bit] NOT NULL ,
	[EClaimsAccepts] [bit] NOT NULL ,
	[CreatedPracticeID] [int] NULL ,
	[Fax] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FaxExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] WITH NOCHECK ADD
	CONSTRAINT [PK_InsuranceCompanyPlan] PRIMARY KEY CLUSTERED
	(
		[InsuranceCompanyPlanID]
	) ON [PRIMARY]
GO
/*
ALTER TABLE [dbo].[InsuranceCompanyPlan] WITH NOCHECK ADD 
	CONSTRAINT [DF_InsuranceCompanyPlan_CoPay] DEFAULT (0) FOR [CoPay] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_CreatedUserID] DEFAULT (0) FOR [CreatedUserID] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID] ,
	CONSTRAINT [DF__Insurance__Insur__1B34BBAE] DEFAULT ('O') FOR [InsuranceProgramCode] ,
	CONSTRAINT [DF__Insurance__HCFAD__3E53DAB9] DEFAULT ('C') FOR [HCFADiagnosisReferenceFormatCode] ,
	CONSTRAINT [DF__Insurance__HCFAS__3F47FEF2] DEFAULT ('D') FOR [HCFASameAsInsuredFormatCode] ,
	CONSTRAINT [DF__Insurance__Revie__1650D657] DEFAULT ('') FOR [ReviewCode] ,
	CONSTRAINT [DF__Insurance__Billi__09EBCAC9] DEFAULT (1) FOR [BillingFormID] ,
	CONSTRAINT [DF_EClaimsRequiresEnrollment] DEFAULT (0) FOR [EClaimsRequiresEnrollment] ,
	CONSTRAINT [DF_EClaimsRequiresAuthorization] DEFAULT (0) FOR [EClaimsRequiresAuthorization] ,
	CONSTRAINT [DF_EClaimsRequiresProviderID] DEFAULT (0) FOR [EClaimsRequiresProviderID] ,
	CONSTRAINT [DF__Insurance__EClai__75B09349] DEFAULT (0) FOR [EClaimsPaperOnly] ,
	CONSTRAINT [DF__Insurance__EClai__76A4B782] DEFAULT (0) FOR [EClaimsRequiresTest] ,
	CONSTRAINT [DF__Insurance__EClai__7798DBBB] DEFAULT (0) FOR [EClaimsAccepts]
GO

 CREATE NONCLUSTERED INDEX [IX_InsuranceCompanyPlan_InsuranceCompanyPlanID_EDIPayerNumber] ON [dbo].[InsuranceCompanyPlan]([InsuranceCompanyPlanID] , [EDIPayerNumber] ) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] WITH NOCHECK ADD
	CONSTRAINT [FK_InsuranceCompanyPlan_HCFADiagnosisReferenceFormat] FOREIGN KEY
	(
		[HCFADiagnosisReferenceFormatCode]
	) REFERENCES [dbo].[HCFADiagnosisReferenceFormat] (
		[HCFADiagnosisReferenceFormatCode]
	) ,
	CONSTRAINT [FK_InsuranceCompanyPlan_HCFASameAsInsuredFormat] FOREIGN KEY
	(
		[HCFASameAsInsuredFormatCode]
	) REFERENCES [dbo].[HCFASameAsInsuredFormat] (
		[HCFASameAsInsuredFormatCode]
	) ,
	CONSTRAINT [FK_InsuranceCompanyPlan_GroupNumberType] FOREIGN KEY
	(
		[GroupNumberTypeID]
	) REFERENCES [dbo].[GroupNumberType] (
		[GroupNumberTypeID]
	) ,
	CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType] FOREIGN KEY
	(
		[ProviderNumberTypeID]
	) REFERENCES [dbo].[ProviderNumberType] (
		[ProviderNumberTypeID]
	) ,
	CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType_LocalUse] FOREIGN KEY
	(
		[LocalUseProviderNumberTypeID]
	) REFERENCES [dbo].[ProviderNumberType] (
		[ProviderNumberTypeID]
	)
GO

IF EXISTS (
	SELECT	*
	FROM	dbo.sysobjects
	WHERE	id = object_id(N'[dbo].[InsuranceCompanyPlan]')
	AND	OBJECTPROPERTY(id, N'IsTable') = 1)

DROP TABLE [dbo].[InsuranceCompanyPlan]

*/


CREATE TABLE [dbo].[Permissions] (
	[PermissionID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL ,
	[ViewInMedicalOffice] [bit] NOT NULL ,
	[ViewInBusinessManager] [bit] NOT NULL ,
	[ViewInAdministrator] [bit] NOT NULL ,
	[ViewInServiceManager] [bit] NOT NULL ,
	[PermissionGroupID] [int] NULL ,
	[PermissionValue] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ProcedureCodeDictionary] (
	[ProcedureCodeDictionaryID] [int] IDENTITY (1, 1) NOT NULL ,
	[ProcedureCode] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ProcedureName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Description] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL ,
	[TypeOfServiceCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SecurityGroupPermissions] (
	[SecurityGroupID] [int] NOT NULL ,
	[PermissionID] [int] NOT NULL ,
	[Allowed] [bit] NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL ,
	[Denied] [bit] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SecuritySetting] (
	[SecuritySettingID] [int] IDENTITY (1, 1) NOT NULL ,
	[CustomerID] [int] NULL ,
	[PasswordMinimumLength] [int] NOT NULL ,
	[PasswordRequireAlphaNumeric] [bit] NOT NULL ,
	[PasswordRequireMixedCase] [bit] NOT NULL ,
	[PasswordRequireNonAlphaNumeric] [bit] NOT NULL ,
	[PasswordRequireDifferentPassword] [bit] NOT NULL ,
	[PasswordRequireDifferentPasswordCount] [int] NOT NULL ,
	[PasswordExpiration] [bit] NOT NULL ,
	[PasswordExpirationDays] [int] NOT NULL ,
	[LockoutAttempts] [int] NOT NULL ,
	[LockoutPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LockoutEmail] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UILockMinutesAdministrator] [int] NOT NULL ,
	[UILockMinutesBusinessManager] [int] NOT NULL ,
	[UILockMinutesMedicalOffice] [int] NOT NULL ,
	[UILockMinutesPractitioner] [int] NOT NULL ,
	[UILockMinutesServiceManager] [int] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CustomerUsers] (
	[CustomerID] [int] NOT NULL ,
	[UserID] [int] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UserPassword] (
	[UserPasswordID] [int] IDENTITY (1, 1) NOT NULL ,
	[UserID] [int] NOT NULL ,
	[Password] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SecretQuestion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SecretAnswer] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[Expired] [bit] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Users] (
	[UserID] [int] IDENTITY (1, 1) NOT NULL ,
	[NtlmName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL ,
	[Prefix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FirstName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MiddleName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LastName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Suffix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Country] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WorkPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WorkPhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AlternativePhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AlternativePhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailAddress] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AccountLockCounter] [int] NOT NULL ,
	[AccountLocked] [bit] NOT NULL ,
	[UserPasswordID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[UsersSecurityGroup] (
	[UserID] [int] NOT NULL ,
	[SecurityGroupID] [int] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BillingForm] ADD
	CONSTRAINT [PK_BillingForm] PRIMARY KEY CLUSTERED
	(
		[BillingFormID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClearinghousePayersList] ADD
	CONSTRAINT [PK_ClearinghousePayersList] PRIMARY KEY CLUSTERED
	(
		[ClearinghousePayerID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Country] ADD
	CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED
	(
		[Country]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DemographicAnnualCompanyRevenue] ADD
	CONSTRAINT [PK_DemographicAnnualCompanyRevenue] PRIMARY KEY CLUSTERED
	(
		[AnnualCompanyRevenueID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DemographicMarketingSource] ADD
	CONSTRAINT [PK_DemographicMarketingSource] PRIMARY KEY CLUSTERED
	(
		[MarketingSourceID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DemographicNumOfEmployees] ADD
	CONSTRAINT [PK_DemographicNumOfEmployees] PRIMARY KEY CLUSTERED
	(
		[NumOfEmployeesID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DemographicNumOfPhysicians] ADD
	CONSTRAINT [PK_DemographicNumOfPhysicians] PRIMARY KEY CLUSTERED
	(
		[NumOfPhysiciansID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DemographicNumOfUsers] ADD
	CONSTRAINT [PK_DemographicNumOfUsers] PRIMARY KEY CLUSTERED
	(
		[NumOfUsersID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DiagnosisCodeDictionary] ADD
	CONSTRAINT [PK_DiagnosisCodeDictionary] PRIMARY KEY CLUSTERED
	(
		[DiagnosisCodeDictionaryID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Gender] ADD
	CONSTRAINT [PK_Gender] PRIMARY KEY CLUSTERED
	(
		[Gender]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[GroupNumberType] ADD
	CONSTRAINT [PK_GroupNumberType] PRIMARY KEY CLUSTERED
	(
		[GroupNumberTypeID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[HCFADiagnosisReferenceFormat] ADD
	CONSTRAINT [PK_HCFADiagnosisReferenceFormat] PRIMARY KEY CLUSTERED
	(
		[HCFADiagnosisReferenceFormatCode]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[HCFASameAsInsuredFormat] ADD
	CONSTRAINT [PK_HCFASameAsInsuredFormat] PRIMARY KEY CLUSTERED
	(
		[HCFASameAsInsuredFormatCode]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InsuranceProgram] ADD
	CONSTRAINT [PK_InsuranceProgram] PRIMARY KEY CLUSTERED
	(
		[InsuranceProgramCode]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PermissionGroup] ADD
	CONSTRAINT [PK_PermissionGroup] PRIMARY KEY CLUSTERED
	(
		[PermissionGroupID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProcedureModifier] ADD
	CONSTRAINT [PK_ProcedureModifier] PRIMARY KEY CLUSTERED
	(
		[ProcedureModifierCode]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProviderNumberType] ADD
	CONSTRAINT [PK_BillingIdentifier] PRIMARY KEY CLUSTERED
	(
		[ProviderNumberTypeID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SecurityGroup] ADD
	CONSTRAINT [PK_SecurityGroup] PRIMARY KEY CLUSTERED
	(
		[SecurityGroupID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SharedSystemPropertiesAndValues] ADD
	CONSTRAINT [PK_SharedSystemPropertiesAndValues] PRIMARY KEY CLUSTERED
	(
		[PropertyName]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[State] ADD
	CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED
	(
		[State]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SubscriptionLastRun] ADD
	CONSTRAINT [PK_SubscriptionLastRun] PRIMARY KEY CLUSTERED
	(
		[TableName]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TypeOfService] ADD
	CONSTRAINT [PK_TypeOfService] PRIMARY KEY CLUSTERED
	(
		[TypeOfServiceCode]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Customer] ADD
	CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED
	(
		[CustomerID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD
	CONSTRAINT [PK_InsuranceCompanyPlan] PRIMARY KEY CLUSTERED
	(
		[InsuranceCompanyPlanID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Permissions] ADD
	CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED
	(
		[PermissionID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProcedureCodeDictionary] ADD
	CONSTRAINT [PK_ProcedureCodeDictionary] PRIMARY KEY CLUSTERED
	(
		[ProcedureCodeDictionaryID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SecurityGroupPermissions] ADD
	CONSTRAINT [PK_SecurityGroupPermissions] PRIMARY KEY CLUSTERED
	(
		[SecurityGroupID] ,
		[PermissionID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SecuritySetting] ADD
	CONSTRAINT [PK_SecuritySetting] PRIMARY KEY CLUSTERED
	(
		[SecuritySettingID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomerUsers] ADD
	CONSTRAINT [PK_CUSTOMERUSERS] PRIMARY KEY CLUSTERED
	(
		[CustomerID] ,
		[UserID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserPassword] ADD
	CONSTRAINT [PK_UserPassword] PRIMARY KEY CLUSTERED
	(
		[UserPasswordID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Users] ADD
	CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED
	(
		[UserID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UsersSecurityGroup] ADD
	CONSTRAINT [PK_UsersSecurityGroup] PRIMARY KEY CLUSTERED
	(
		[UserID] ,
		[SecurityGroupID]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClearinghousePayersList] ADD 
	CONSTRAINT [DF_ClearinghousePayersList_IsPaperOnly] DEFAULT (0) FOR [IsPaperOnly] ,
	CONSTRAINT [DF_ClearinghousePayersList_IsGovernment] DEFAULT (0) FOR [IsGovernment] ,
	CONSTRAINT [DF_ClearinghousePayersList_IsCommercial] DEFAULT (0) FOR [IsCommercial] ,
	CONSTRAINT [DF_ClearinghousePayersList_IsParticipating] DEFAULT (0) FOR [IsParticipating] ,
	CONSTRAINT [DF_ClearinghousePayersList_IsProviderIdRequired] DEFAULT (0) FOR [IsProviderIdRequired] ,
	CONSTRAINT [DF_ClearinghousePayersList_IsEnrollmentRequired] DEFAULT (0) FOR [IsEnrollmentRequired] ,
	CONSTRAINT [DF_ClearinghousePayersList_IsAuthorizationRequired] DEFAULT (0) FOR [IsAuthorizationRequired] ,
	CONSTRAINT [DF_ClearinghousePayersList_IsTestRequired] DEFAULT (0) FOR [IsTestRequired] ,
	CONSTRAINT [DF_ClearinghousePayersList_IsNewPayer] DEFAULT (0) FOR [IsNewPayer] ,
	CONSTRAINT [DF_ClearinghousePayersList_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_ClearinghousePayersList_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_ClearinghousePayersList_Active] DEFAULT (1) FOR [Active] ,
	CONSTRAINT [DF_ClearinghousePayersList_IsModifiedPayer] DEFAULT (0) FOR [IsModifiedPayer]
GO

ALTER TABLE [dbo].[Country] ADD 
	CONSTRAINT [DF_Country_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_Country_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [dbo].[DiagnosisCodeDictionary] ADD 
	CONSTRAINT [DF_DiagnosisCodeDictionary_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_DiagnosisCodeDictionary_CreatedUserID] DEFAULT (0) FOR [CreatedUserID] ,
	CONSTRAINT [DF_DiagnosisCodeDictionary_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_DiagnosisCodeDictionary_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

ALTER TABLE [dbo].[Gender] ADD 
	CONSTRAINT [DF_Gender_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_Gender_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [dbo].[ProcedureModifier] ADD 
	CONSTRAINT [DF_ProcedureModifier_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_ProcedureModifier_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [dbo].[SecurityGroup] ADD 
	CONSTRAINT [DF_SecurityGroup_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_SecurityGroup_CreatedUserID] DEFAULT (0) FOR [CreatedUserID] ,
	CONSTRAINT [DF_SecurityGroup_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_SecurityGroup_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID] ,
	CONSTRAINT [DF_SecurityGroup_ViewInMedicalOffice] DEFAULT (1) FOR [ViewInMedicalOffice] ,
	CONSTRAINT [DF_SecurityGroup_ViewInBusinessManager] DEFAULT (1) FOR [ViewInBusinessManager] ,
	CONSTRAINT [DF_SecurityGroup_ViewInAdministrator] DEFAULT (1) FOR [ViewInAdministrator] ,
	CONSTRAINT [DF_SecurityGroup_ViewInServiceManager] DEFAULT (1) FOR [ViewInServiceManager]
GO

 CREATE UNIQUE NONCLUSTERED INDEX [UX_SecurityGroup_Customer_SecurityGroupName] ON [dbo].[SecurityGroup]([CustomerID] , [SecurityGroupName] ) ON [PRIMARY]
GO

ALTER TABLE [dbo].[State] ADD 
	CONSTRAINT [DF_State_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_State_CreatedUserID] DEFAULT (0) FOR [CreatedUserID] ,
	CONSTRAINT [DF_State_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_State_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

ALTER TABLE [dbo].[SubscriptionLastRun] ADD 
	CONSTRAINT [DF_SubscriptionLastRun_LastUpdatedDate] DEFAULT ('1/1/2000') FOR [LastUpdatedDate] ,
	CONSTRAINT [DF_SubscriptionLastRun_ManuallyMaintained] DEFAULT (0) FOR [ManuallyMaintained]
GO

ALTER TABLE [dbo].[Customer] ADD 
	CONSTRAINT [DF_Customer_NumOfEmployeesID] DEFAULT (0) FOR [NumOfEmployeesID] ,
	CONSTRAINT [DF_Customer_NumOfUsersID] DEFAULT (0) FOR [NumOfUsersID] ,
	CONSTRAINT [DF_Customer_NumOfPhysiciansID] DEFAULT (0) FOR [NumOfPhysiciansID] ,
	CONSTRAINT [DF_Customer_AnnualCompanyRevenueID] DEFAULT (0) FOR [AnnualCompanyRevenueID] ,
	CONSTRAINT [DF_Customer_MarketingSourceID] DEFAULT (0) FOR [MarketingSourceID] ,
	CONSTRAINT [DF_Customer_CustomerType] DEFAULT ('T') FOR [CustomerType] ,
	CONSTRAINT [DF_Customer_AccountLocked] DEFAULT (0) FOR [AccountLocked] ,
	CONSTRAINT [DF_Customer_DBActive] DEFAULT (0) FOR [DBActive] ,
	CONSTRAINT [DF_Customer_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_Customer_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [CK_Customer_CustomerType] CHECK ([CustomerType] = 'T' or [CustomerType] = 'N')
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD 
	CONSTRAINT [DF_InsuranceCompanyPlan_CoPay] DEFAULT (0) FOR [CoPay] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_CreatedUserID] DEFAULT (0) FOR [CreatedUserID] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_InsuranceProgramCode] DEFAULT ('O') FOR [InsuranceProgramCode] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_HCFADiagnosisReferenceFormatCode] DEFAULT ('C') FOR [HCFADiagnosisReferenceFormatCode] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_HCFASameAsInsuredFormatCode] DEFAULT ('D') FOR [HCFASameAsInsuredFormatCode] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_ReviewCode] DEFAULT ('') FOR [ReviewCode] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_BillingFormID] DEFAULT (1) FOR [BillingFormID] ,
	CONSTRAINT [DF_InsuranceCompanyPlan_EClaimsAccepts] DEFAULT (0) FOR [EClaimsAccepts]
GO

ALTER TABLE [dbo].[Permissions] ADD 
	CONSTRAINT [DF_Permissions_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_Permissions_CreatedUserID] DEFAULT (0) FOR [CreatedUserID] ,
	CONSTRAINT [DF_Permissions_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_Permissions_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID] ,
	CONSTRAINT [DF_Permissions_ViewInMedicalOffice] DEFAULT (1) FOR [ViewInMedicalOffice] ,
	CONSTRAINT [DF_Permissions_ViewInBusinessManager] DEFAULT (1) FOR [ViewInBusinessManager] ,
	CONSTRAINT [DF_Permissions_ViewInAdministrator] DEFAULT (1) FOR [ViewInAdministrator] ,
	CONSTRAINT [DF_Permissions_ViewInServiceManager] DEFAULT (1) FOR [ViewInServiceManager] ,
	CONSTRAINT [DF_Permissions_PermissionValue] DEFAULT ('') FOR [PermissionValue]
GO

ALTER TABLE [dbo].[ProcedureCodeDictionary] ADD 
	CONSTRAINT [DF_ProcedureCodeDictionary_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_ProcedureCodeDictionary_CreatedUserID] DEFAULT (0) FOR [CreatedUserID] ,
	CONSTRAINT [DF_ProcedureCodeDictionary_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_ProcedureCodeDictionary_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID] ,
	CONSTRAINT [DF_ProcedureCodeDictionary_TypeOfServiceCode] DEFAULT ('01') FOR [TypeOfServiceCode]
GO

ALTER TABLE [dbo].[SecurityGroupPermissions] ADD 
	CONSTRAINT [DF_SecurityGroupPermissions_Allowed] DEFAULT (0) FOR [Allowed] ,
	CONSTRAINT [DF_SecurityGroupPermissions_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_SecurityGroupPermissions_CreatedUserID] DEFAULT (0) FOR [CreatedUserID] ,
	CONSTRAINT [DF_SecurityGroupPermissions_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_SecurityGroupPermissions_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID] ,
	CONSTRAINT [DF_SecurityGroupPermissions_Denied] DEFAULT (0) FOR [Denied]
GO

ALTER TABLE [dbo].[SecuritySetting] ADD 
	CONSTRAINT [DF_SecuritySetting_PasswordMinimumLength] DEFAULT (4) FOR [PasswordMinimumLength] ,
	CONSTRAINT [DF_SecuritySetting_PasswordRequireAlphaNumeric] DEFAULT (0) FOR [PasswordRequireAlphaNumeric] ,
	CONSTRAINT [DF_SecuritySetting_PasswordRequireMixedCase] DEFAULT (0) FOR [PasswordRequireMixedCase] ,
	CONSTRAINT [DF_SecuritySetting_PasswordRequireNonAlphaNumeric] DEFAULT (0) FOR [PasswordRequireNonAlphaNumeric] ,
	CONSTRAINT [DF_SecuritySetting_PasswordRequireDifferentPassword] DEFAULT (1) FOR [PasswordRequireDifferentPassword] ,
	CONSTRAINT [DF_SecuritySetting_PasswordRequireDifferentPasswordCount] DEFAULT (3) FOR [PasswordRequireDifferentPasswordCount] ,
	CONSTRAINT [DF_SecuritySetting_PasswordExpiration] DEFAULT (1) FOR [PasswordExpiration] ,
	CONSTRAINT [DF_SecuritySetting_PasswordExpirationDays] DEFAULT (180) FOR [PasswordExpirationDays] ,
	CONSTRAINT [DF_SecuritySetting_LockoutAttempts] DEFAULT (5) FOR [LockoutAttempts] ,
	CONSTRAINT [DF_SecuritySetting_UILockMinutesAdministrator] DEFAULT (30) FOR [UILockMinutesAdministrator] ,
	CONSTRAINT [DF_SecuritySetting_UILockMinutesBusinessManager] DEFAULT (30) FOR [UILockMinutesBusinessManager] ,
	CONSTRAINT [DF_SecuritySetting_UILockMinutesMedicalOffice] DEFAULT (30) FOR [UILockMinutesMedicalOffice] ,
	CONSTRAINT [DF_SecuritySetting_UILockMinutesPractitioner] DEFAULT (30) FOR [UILockMinutesPractitioner] ,
	CONSTRAINT [DF_SecuritySetting_UILockMinutesServiceManager] DEFAULT (30) FOR [UILockMinutesServiceManager]
GO

ALTER TABLE [dbo].[UserPassword] ADD 
	CONSTRAINT [DF_UserPassword_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_UserPassword_Expired] DEFAULT (0) FOR [Expired]
GO

ALTER TABLE [dbo].[Users] ADD 
	CONSTRAINT [DF_Users_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_Users_CreatedUserID] DEFAULT (0) FOR [CreatedUserID] ,
	CONSTRAINT [DF_Users_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_Users_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID] ,
	CONSTRAINT [DF_Users_AccountLockCounter] DEFAULT (0) FOR [AccountLockCounter] ,
	CONSTRAINT [DF_Users_AccountLocked] DEFAULT (0) FOR [AccountLocked] ,
	CONSTRAINT [UX_UsersEmailAddress] UNIQUE NONCLUSTERED 
	(
		[EmailAddress]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UsersSecurityGroup] ADD 
	CONSTRAINT [DF_UsersSecurityGroup_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate] ,
	CONSTRAINT [DF_UsersSecurityGroup_CreatedUserID] DEFAULT (0) FOR [CreatedUserID] ,
	CONSTRAINT [DF_UsersSecurityGroup_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate] ,
	CONSTRAINT [DF_UsersSecurityGroup_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

ALTER TABLE [dbo].[Customer] ADD
	CONSTRAINT [FK_Customer_DemographicAnnualCompanyRevenue] FOREIGN KEY
	(
		[AnnualCompanyRevenueID]
	) REFERENCES [dbo].[DemographicAnnualCompanyRevenue] (
		[AnnualCompanyRevenueID]
	) ,
	CONSTRAINT [FK_Customer_DemographicMarketingSource] FOREIGN KEY
	(
		[MarketingSourceID]
	) REFERENCES [dbo].[DemographicMarketingSource] (
		[MarketingSourceID]
	) ,
	CONSTRAINT [FK_Customer_DemographicNumOfEmployees] FOREIGN KEY
	(
		[NumOfEmployeesID]
	) REFERENCES [dbo].[DemographicNumOfEmployees] (
		[NumOfEmployeesID]
	) ,
	CONSTRAINT [FK_Customer_DemographicNumOfPhysicians] FOREIGN KEY
	(
		[NumOfPhysiciansID]
	) REFERENCES [dbo].[DemographicNumOfPhysicians] (
		[NumOfPhysiciansID]
	) ,
	CONSTRAINT [FK_CustomerDemographicNumOfUsers] FOREIGN KEY
	(
		[NumOfUsersID]
	) REFERENCES [dbo].[DemographicNumOfUsers] (
		[NumOfUsersID]
	)
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD
	CONSTRAINT [FK_InsuranceCompanyPlan_BillForm] FOREIGN KEY
	(
		[BillingFormID]
	) REFERENCES [dbo].[BillingForm] (
		[BillingFormID]
	) ,
	CONSTRAINT [FK_InsuranceCompanyPlan_ClearinghousePayersList] FOREIGN KEY
	(
		[ClearinghousePayerID]
	) REFERENCES [dbo].[ClearinghousePayersList] (
		[ClearinghousePayerID]
	) ,
	CONSTRAINT [FK_InsuranceCompanyPlan_GroupNumberType] FOREIGN KEY
	(
		[GroupNumberTypeID]
	) REFERENCES [dbo].[GroupNumberType] (
		[GroupNumberTypeID]
	) ,
	CONSTRAINT [FK_InsuranceCompanyPlan_HCFADiagnosisIsReferenceFormat] FOREIGN KEY
	(
		[HCFADiagnosisReferenceFormatCode]
	) REFERENCES [dbo].[HCFADiagnosisReferenceFormat] (
		[HCFADiagnosisReferenceFormatCode]
	) ,
	CONSTRAINT [FK_InsuranceCompanyPlan_HCFASameAsInsuredFormat] FOREIGN KEY
	(
		[HCFASameAsInsuredFormatCode]
	) REFERENCES [dbo].[HCFASameAsInsuredFormat] (
		[HCFASameAsInsuredFormatCode]
	) ,
	CONSTRAINT [FK_InsuranceCompanyPlan_InsuranceProgram] FOREIGN KEY
	(
		[InsuranceProgramCode]
	) REFERENCES [dbo].[InsuranceProgram] (
		[InsuranceProgramCode]
	) ,
	CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType] FOREIGN KEY
	(
		[ProviderNumberTypeID]
	) REFERENCES [dbo].[ProviderNumberType] (
		[ProviderNumberTypeID]
	)
GO

ALTER TABLE [dbo].[Permissions] ADD
	CONSTRAINT [FK_Permission_PermissionGroup] FOREIGN KEY
	(
		[PermissionGroupID]
	) REFERENCES [dbo].[PermissionGroup] (
		[PermissionGroupID]
	)
GO

ALTER TABLE [dbo].[ProcedureCodeDictionary] ADD
	CONSTRAINT [FK_ProcedureCodeDictionary_TypeOfService] FOREIGN KEY
	(
		[TypeOfServiceCode]
	) REFERENCES [dbo].[TypeOfService] (
		[TypeOfServiceCode]
	)
GO

ALTER TABLE [dbo].[SecurityGroupPermissions] ADD
	CONSTRAINT [FK_SecurityGroupPermissions_SecurityGroup] FOREIGN KEY
	(
		[SecurityGroupID]
	) REFERENCES [dbo].[SecurityGroup] (
		[SecurityGroupID]
	) ,
	CONSTRAINT [FK_SecurityGroup_Permissions] FOREIGN KEY
	(
		[PermissionID]
	) REFERENCES [dbo].[Permissions] (
		[PermissionID]
	)
GO

ALTER TABLE [dbo].[SecuritySetting] ADD
	CONSTRAINT [FK_SecuritySetting_Customer] FOREIGN KEY
	(
		[CustomerID]
	) REFERENCES [dbo].[Customer] (
		[CustomerID]
	)
GO

ALTER TABLE [dbo].[CustomerUsers] ADD
	CONSTRAINT [FK_CustomerUsers_Customer] FOREIGN KEY
	(
		[CustomerID]
	) REFERENCES [dbo].[Customer] (
		[CustomerID]
	) ,
	CONSTRAINT [FK_CustomerUsers_Users] FOREIGN KEY
	(
		[UserID]
	) REFERENCES [dbo].[Users] (
		[UserID]
	)
GO

ALTER TABLE [dbo].[UserPassword] ADD
	CONSTRAINT [FK_Users_UserPassword_UserID] FOREIGN KEY
	(
		[UserID]
	) REFERENCES [dbo].[Users] (
		[UserID]
	)
GO


ALTER TABLE [dbo].[UsersSecurityGroup] ADD
	CONSTRAINT [FK_UsersSecurityGroup_Roles] FOREIGN KEY
	(
		[SecurityGroupID]
	) REFERENCES [dbo].[SecurityGroup] (
		[SecurityGroupID]
	) ,
	CONSTRAINT [FK_UsersSecurityGroup_Users] FOREIGN KEY
	(
		[UserID]
	) REFERENCES [dbo].[Users] (
		[UserID]
	)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- DIAGNOSIS IS VALID
--===========================================================================
CREATE FUNCTION dbo.Shared_BusinessRule_DiagnosisIsValid (@diagnosis_id INT, @code VARCHAR(16))
RETURNS BIT
AS
BEGIN
	--Not valid if another diagnosis exists with same Code.
	IF EXISTS (
		SELECT	*
		FROM	DIAGNOSISCODEDICTIONARY
		WHERE	LTRIM(RTRIM(DiagnosisCode)) = LTRIM(RTRIM(@code))
		AND	DiagnosisCodeDictionaryID <> @diagnosis_id
	)
		RETURN 0
	
	RETURN 1
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- PROCEDURE IS DUPLICATE
--===========================================================================
CREATE FUNCTION dbo.Shared_BusinessRule_ProcedureIsDuplicate (
	@procedure_id INT,
	@code VARCHAR(16))
RETURNS BIT
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	PROCEDURECODEDICTIONARY
		WHERE	LTRIM(RTRIM(ProcedureCode)) = LTRIM(RTRIM(@code))
		AND	ProcedureCodeDictionaryID <> @procedure_id
	)
		RETURN 1

	RETURN 0
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- PROCEDURE IS VALID
--===========================================================================
CREATE FUNCTION dbo.Shared_BusinessRule_ProcedureIsValid (@tos CHAR(2))
RETURNS BIT
AS
BEGIN
	--Not valid if type of service not correct.
	IF NOT EXISTS (
		SELECT	*
		FROM	TYPEOFSERVICE
		WHERE	TypeOfServiceCode = @tos
	)
		RETURN 0

	RETURN 1
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- PROCEDURE MODIFIER IS DUPLICATE
--===========================================================================
CREATE FUNCTION dbo.Shared_BusinessRule_ProcedureModifierIsDuplicate (@code varchar(16))
RETURNS BIT
AS
BEGIN
	IF EXISTS (
		SELECT	*
		FROM	ProcedureModifier
		WHERE	ProcedureModifierCode = @code
	)
		RETURN 1
	
	RETURN 0
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- SECURITY GROUP IS VALID
--===========================================================================
CREATE FUNCTION dbo.Shared_BusinessRule_SecurityGroupIsValid(@CustomerID int, @SecurityGroupID int, @SecurityGroupName varchar(32))
RETURNS BIT
AS
BEGIN
	--Not valid if another security group exists for the same customer with the same name.
	IF EXISTS (
		SELECT	*
		FROM	SecurityGroup
		WHERE	SecurityGroupName = @SecurityGroupName
		AND	SecurityGroupID <> @SecurityGroupID
		AND 	CustomerID = @CustomerID
	)
		RETURN 0
	
	RETURN 1
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- USER IS VALID
--===========================================================================
CREATE FUNCTION dbo.Shared_BusinessRule_UserIsValid (@UserID INT, @EmailAddress VARCHAR(256))
RETURNS BIT
AS
BEGIN
	--Not valid if another user exists with the same Name.
	IF EXISTS (
		SELECT	*
		FROM	USERS
		WHERE	EmailAddress = @EmailAddress
		AND	UserID <> @UserID
	)
		RETURN 0

	RETURN 1
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- SET USER CUSTOMER 
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_AddUserCustomerAssociation
	@UserID int,
	@CustomerID int
AS
BEGIN
	IF NOT EXISTS (
		SELECT	*
		FROM	dbo.CustomerUsers
		WHERE	UserID = @UserID
		AND	CustomerID = @CustomerID
	)
		INSERT	CustomerUsers (
			UserID, 
			CustomerID
		)
		VALUES	(
			@UserID, 
			@CustomerID
		)
		
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_Authenticate
	@UserName varchar(256),
	@PasswordHash varchar(40)
AS
BEGIN
	--check if user exists
	DECLARE @UserID int
	SET @UserID = (SELECT UserID FROM Users WHERE EmailAddress = @UserName)
	
	IF @UserID IS NULL
	BEGIN
		SELECT 'NoAuth'
		RETURN
	END

	--check if locked out
	IF EXISTS 
		(
			SELECT * FROM Users WHERE AccountLocked = 1 AND UserID = @UserID
		)
	BEGIN
		SELECT 'LockedOut'
		RETURN
	END

	--incremenet login attempts for lockout
	UPDATE Users 
	SET AccountLockCounter = AccountLockCounter + 1
	WHERE UserID = @UserID
	
	--check if authenticates
	DECLARE @UserPasswordID int
	
	SET @UserPasswordID = 
		(
			SELECT 
				UP.UserPasswordID
			FROM 
				UserPassword UP
				INNER JOIN Users U ON U.UserPasswordID = UP.UserPasswordID
			WHERE
				U.UserID = @UserID
				AND UP.Password = @PasswordHash
		)

	IF @UserPasswordID IS NULL
	BEGIN
	
		--lock out if too many attempts

		DECLARE @MaxLockCounter int
		DECLARE @CurrentLockCounter int

		SET @MaxLockCounter = (
			SELECT MIN(SS.LockoutAttempts) 
			FROM dbo.SecuritySetting SS
				INNER JOIN dbo.CustomerUsers CU
				ON SS.CustomerID = CU.CustomerID
			WHERE CU.UserID = @UserID)
			
		SET @CurrentLockCounter = (SELECT AccountLockCounter FROM Users WHERE UserID = @UserID)

		IF (@CurrentLockCounter >= @MaxLockCounter)
		BEGIN
			UPDATE Users SET AccountLocked = 1 WHERE UserID = @UserID
			SELECT 'LockedOutNow'
			RETURN
		END
	
	
		SELECT 'NoAuth'
		RETURN
	END
	
	--reset lockout counter
	
	UPDATE Users SET AccountLockCounter = 0 WHERE UserID = @UserID

	--expire password if needed

	DECLARE @PasswordExpiration bit
	DECLARE @PasswordExpirationDays int

	SELECT 
		@PasswordExpiration = MAX(CAST(SS.PasswordExpiration AS int)), 
		@PasswordExpirationDays = MIN(SS.PasswordExpirationDays)
	FROM 
		dbo.SecuritySetting SS
		INNER JOIN dbo.CustomerUsers CU
		ON SS.CustomerID = CU.CustomerID
	WHERE CU.UserID = @UserID
	

	IF @PasswordExpiration = 1
	BEGIN
		DECLARE @DaysSincePassword INT
		SET @DaysSincePassword =  
			(
				SELECT 
					DATEDIFF(d,GETDATE(),CreatedDate) 
				FROM 
					UserPassword 
				WHERE 
					UserPasswordID = @UserPasswordID
			)

		IF (@DaysSincePassword >= @PasswordExpirationDays)
		BEGIN
			UPDATE UserPassword SET Expired = 1 WHERE UserPasswordID = @UserPasswordID
		END
	END

	--check if password expired

	IF EXISTS
		(
			SELECT 
				UserPasswordID
			FROM 
				UserPassword
			WHERE
				UserPasswordID = @UserPasswordID
				AND Expired = 1
		)
	BEGIN
		SELECT 'PasswordExpired'
		RETURN
	END
	
	--if we got this far, we're authenticated successfully
	
	SELECT 'OK'

	RETURN	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_AuthenticateSecretAnswer
	@UserName varchar(256),
	@SecretAnswerHash varchar(40)
AS
BEGIN
	--check if user exists
	
	DECLARE @UserID int
	SET @UserID = (SELECT UserID FROM Users WHERE EmailAddress = @UserName)
	
	IF @UserID IS NULL
	BEGIN
		SELECT 'NoAuth'
		RETURN
	END

	--check if locked out
	
	IF EXISTS 
		(
			SELECT * FROM Users WHERE AccountLocked = 1 AND UserID = @UserID
		)
	BEGIN
		SELECT 'LockedOut'
		RETURN
	END


	--incremenet login attempts for lockout
	
	UPDATE Users 
	SET AccountLockCounter = AccountLockCounter + 1
	WHERE UserID = @UserID


	
	--check if authenticates
	
	DECLARE @UserPasswordID int
	
	SET @UserPasswordID = 
		(
			SELECT 
				UP.UserPasswordID
			FROM 
				UserPassword UP
				INNER JOIN Users U ON U.UserPasswordID = UP.UserPasswordID
			WHERE
				U.UserID = @UserID
				AND UP.SecretAnswer = @SecretAnswerHash
		)

	IF @UserPasswordID IS NULL
	BEGIN
	
		--lock out if too many attempts

		DECLARE @MaxLockCounter int
		DECLARE @CurrentLockCounter int
		
		SET @MaxLockCounter = (
			SELECT MIN(SS.LockoutAttempts) 
			FROM dbo.SecuritySetting SS
				INNER JOIN dbo.CustomerUsers CU
				ON SS.CustomerID = CU.CustomerID
			WHERE CU.UserID = @UserID)
		
		SET @CurrentLockCounter = (SELECT AccountLockCounter FROM Users WHERE UserID = @UserID)

		IF (@CurrentLockCounter >= @MaxLockCounter)
		BEGIN
			UPDATE Users SET AccountLocked = 1 WHERE UserID = @UserID
			SELECT 'LockedOutNow'
			RETURN
		END
	
	
		SELECT 'NoAuth'
		RETURN
	END
	
	--reset lockout counter
	
	UPDATE Users SET AccountLockCounter = 0 WHERE UserID = @UserID

	--expire password if needed

	DECLARE @PasswordExpiration bit
	DECLARE @PasswordExpirationDays int

	SELECT 
		@PasswordExpiration = MAX(CAST(SS.PasswordExpiration AS int)), 
		@PasswordExpirationDays = MIN(SS.PasswordExpirationDays)
	FROM 
		dbo.SecuritySetting SS
		INNER JOIN dbo.CustomerUsers CU
		ON SS.CustomerID = CU.CustomerID
	WHERE CU.UserID = @UserID

	IF @PasswordExpiration = 1
	BEGIN
		DECLARE @DaysSincePassword INT
		SET @DaysSincePassword =  
			(
				SELECT 
					DATEDIFF(d,GETDATE(),CreatedDate) 
				FROM 
					UserPassword 
				WHERE 
					UserPasswordID = @UserPasswordID
			)

		IF (@DaysSincePassword >= @PasswordExpirationDays)
		BEGIN
			UPDATE UserPassword SET Expired = 1 WHERE UserPasswordID = @UserPasswordID
		END
	END

	--check if password expired

	IF EXISTS
		(
			SELECT 
				UserPasswordID
			FROM 
				UserPassword
			WHERE
				UserPasswordID = @UserPasswordID
				AND Expired = 1
		)
	BEGIN
		SELECT 'PasswordExpired'
		RETURN
	END
	
	--if we got this far, we're authenticated successfully
	
	SELECT 'OK'

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- CREATE GROUP
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_CreateSecurityGroup
	@CustomerID int,
	@SecurityGroupName VARCHAR(32),
	@SecurityGroupDescription VARCHAR(500),
	@ViewInMedicalOffice bit = 0,
	@ViewInBusinessManager bit = 0,
	@ViewInAdministrator bit = 0,
	@ViewInServiceManager bit = 0,
	@ModifiedUserID int
AS
BEGIN

	IF @CustomerID = 0
		SET @CustomerID = NULL

	INSERT	
		dbo.SecurityGroup
		(
			CustomerID,
			SecurityGroupName, 
			SecurityGroupDescription, 
			ViewInMedicalOffice, 
			ViewInBusinessManager, 
			ViewInAdministrator,
			ViewInServiceManager,
			CreatedUserID,
			ModifiedUserID
		)
	VALUES	
		(
			@CustomerID,
			@SecurityGroupName, 
			@SecurityGroupDescription,
			@ViewInMedicalOffice,
			@ViewInBusinessManager,
			@ViewInAdministrator,
			@ViewInServiceManager,
			@ModifiedUserID,
			@ModifiedUserID
		)

	RETURN SCOPE_IDENTITY()
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- CREATE USER
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_CreateUser
	@CustomerID int,
	@prefix VARCHAR(16),
	@first_name VARCHAR(32),
	@middle_name VARCHAR(32),
	@last_name VARCHAR(32),
	@suffix VARCHAR(16),
	@AccountLocked BIT,
	@address_1 VARCHAR(128) = NULL,
	@address_2 VARCHAR(128) = NULL,
	@city VARCHAR(32) = NULL,
	@state VARCHAR(2) = NULL,
	@country VARCHAR(32) = NULL,
	@zip VARCHAR(9) = NULL,
	@work_phone VARCHAR(10) = NULL,
	@work_phone_x VARCHAR(10) = NULL,
	@alternative_phone VARCHAR(10) = NULL,
	@alternative_phone_x VARCHAR(10) = NULL,
	@EmailAddress VARCHAR(256) = NULL,
	@notes TEXT = NULL,
	@ModifiedUserID int
AS
BEGIN
	DECLARE @NewUserID int
	
	DECLARE @SPECIAL_KAREO_USERS_GROUPID int
	
	SELECT @SPECIAL_KAREO_USERS_GROUPID = SSPV.Value
	FROM dbo.SharedSystemPropertiesAndValues SSPV
	WHERE SSPV.PropertyName = 'KareoDefaultUserSecurityGroupID'
	
	SELECT @NewUserID = U.UserID
	FROM dbo.Users U
	WHERE U.EmailAddress = @EmailAddress
	
	IF @NewUserID IS NULL
	BEGIN
		INSERT	USERS (
			Prefix,
			FirstName,
			MiddleName,
			LastName,
			Suffix,
			AddressLine1,
			AddressLine2,
			City,
			State,
			Country,
			ZipCode,
			WorkPhone,
			WorkPhoneExt,
			AlternativePhone,
			AlternativePhoneExt,
			EmailAddress,
			Notes,
			AccountLocked,
			UserPasswordID,
			CreatedUserID,
			ModifiedUserID
		)
		VALUES (
			@prefix,
			@first_name,
			@middle_name,
			@last_name,
			@suffix,
			@address_1,
			@address_2,
			@city,
			@state,
			@country,
			@zip,
			@work_phone,
			@work_phone_x,
			@alternative_phone,
			@alternative_phone_x,
			@EmailAddress,
			@notes,
			@AccountLocked,
			NULL,
			@ModifiedUserID,
			@ModifiedUserID
		)
		
		SET @NewUserID = SCOPE_IDENTITY()
	END
		
	--Either way associate the user WITH the customer unless it is customer 0
	IF @CustomerID <> 0
	BEGIN
		INSERT dbo.CustomerUsers(
			CustomerID,
			UserID
		)
		VALUES (
			@CustomerID,
			@NewUserID
		)
	END
	
	IF NOT EXISTS(
		SELECT * 
		FROM dbo.UsersSecurityGroup USG
		WHERE USG.UserID = @NewUserID
			AND USG.SecurityGroupID = @SPECIAL_KAREO_USERS_GROUPID
		)
	BEGIN
		INSERT dbo.UsersSecurityGroup(
			UserID, 
			SecurityGroupID, 
			CreatedUserID, 
			ModifiedUserID 
		)
		VALUES (
			@NewUserID,
			@SPECIAL_KAREO_USERS_GROUPID,
			@ModifiedUserID,
			@ModifiedUserID
		)
	END
		
	RETURN @NewUserID
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- DELETE GROUP
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_DeleteSecurityGroup
	@SecurityGroupID int
AS
BEGIN
	--Remove permission associations.
	DELETE	dbo.SecurityGroupPermissions
	WHERE	SecurityGroupID = @SecurityGroupID

	--Remove user associations.
	DELETE	dbo.UsersSecurityGroup
	WHERE	SecurityGroupID = @SecurityGroupID

	--Remove group.
	DELETE	dbo.SecurityGroup
	WHERE	SecurityGroupID = @SecurityGroupID
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- DELETE USER
--
-- This deletes the user from the user table and removes all associations to
-- customers.
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_DeleteUser
	@UserID INT
AS
BEGIN
	--Remove group associations.
	DELETE	USG
	FROM dbo.UsersSecurityGroup USG
	WHERE	USG.UserID = @UserID

/*
This should get moved INTO a local customer database procedure
and then that procedure would call the shared procedure to DELETE the user
	--Remove practice associations.
	DELETE	UserPractices
	WHERE	UserID = @UserID
*/	

	--Set UserPassword to NULL
	UPDATE	Users
	SET	UserPasswordID = NULL
	WHERE	UserID = @UserID
	
	--Remove user passwords
	DELETE	UserPassword
	WHERE	UserID = @UserID

	--Remove user association with customers
	DELETE 	CustomerUsers
	WHERE	UserID = @UserID

	--Remove user.
	DELETE	Users
	WHERE	UserID = @UserID

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- DELETE USER
--
-- This deletes the user from the user table and removes all associations to
-- customers.
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_DeleteUserCustomerAssocation
	@UserID INT,
	@CustomerID int
AS
BEGIN
	--Remove group associations.
	DELETE	USG
	FROM dbo.UsersSecurityGroup USG
		INNER JOIN dbo.SecurityGroup SG
		ON USG.SecurityGroupID = SG.SecurityGroupID
	WHERE	USG.UserID = @UserID
		AND SG.CustomerID = @CustomerID

/*
This should get moved INTO a local customer database procedure
and then that procedure would call the shared procedure to DELETE the user
	--Remove practice associations.
	DELETE	UserPractices
	WHERE	UserID = @UserID
*/	

	--Remove user association with customers
	DELETE 	CustomerUsers
	WHERE	UserID = @UserID
	AND	CustomerID = @CustomerID

	--Get the count of how many customers are now associated with this user
	SELECT	Count(*)
	FROM	CustomerUsers
	WHERE	UserID = @UserID

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET USERS
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetAllUsers
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

	CREATE TABLE #t_users(
		UserID int,
		Prefix varchar(16), 
		FirstName varchar(64), 
		MiddleName varchar(64), 
		LastName varchar(64), 
		Suffix varchar(16), 
		AddressLine1 varchar(256), 
		AddressLine2 varchar(256), 
		City varchar(128), 
		State char(2), 
		Country varchar(32), 
		ZipCode varchar(9), 
		WorkPhone varchar(10), 
		WorkPhoneExt varchar(10), 
		AlternativePhone varchar(10), 
		AlternativePhoneExt varchar(10), 
		EmailAddress varchar(256), 
		AccountLocked bit,
		PasswordExpired bit,
		RID int IDENTITY(0,1)
	)

	INSERT INTO #t_users(
		UserID,
		Prefix, 
		FirstName, 
		MiddleName, 
		LastName, 
		Suffix, 
		AddressLine1, 
		AddressLine2, 
		City, 
		State,
		Country, 
		ZipCode, 
		WorkPhone, 
		WorkPhoneExt, 
		AlternativePhone, 
		AlternativePhoneExt, 
		EmailAddress,
		AccountLocked,
		PasswordExpired
	)
	SELECT	U.UserID,
		U.Prefix,
		U.FirstName,
		U.MiddleName,
		U.LastName,
		U.Suffix,
		U.AddressLine1,
		U.AddressLine2,
		U.City,
		U.State,
		U.Country,
		U.ZipCode,
		U.WorkPhone,
		U.WorkPhoneExt,
		U.AlternativePhone,
		U.AlternativePhoneExt,
		U.EmailAddress,
		U.AccountLocked,
		COALESCE(UP.Expired,0)
	FROM dbo.Users U
		LEFT OUTER JOIN dbo.UserPassword UP 
		ON U.UserPasswordID = UP.UserPasswordID
	WHERE	(	(@query_domain IS NULL OR @query IS NULL)
		OR	((@query_domain = 'UserName' OR @query_domain = 'All')
			  AND (Prefix LIKE '%' + @query + '%' 
			  OR   FirstName LIKE '%' + @query + '%'
			  OR   MiddleName LIKE '%' + @query + '%'
			  OR   LastName LIKE '%' + @query + '%' 
			  OR   Suffix LIKE '%' + @query + '%'))
		OR	((@query_domain = 'UserPrimaryPhone' OR @query_domain = 'All')
			  AND (WorkPhone LIKE '%' + @query + '%'
			  OR   WorkPhoneExt LIKE '%' + @query + '%'))
		OR	((@query_domain = 'UserSecondaryPhone' OR @query_domain = 'All')
			  AND (AlternativePhone LIKE '%' + @query + '%'
			  OR   AlternativePhoneExt LIKE '%' + @query + '%'))
		OR	((@query_domain = 'UserEmail' OR @query_domain = 'All')
			  AND (EmailAddress LIKE '%' + @query + '%'))
		)
	ORDER BY
		U.LastName,
		U.FirstName

	SELECT @totalRecords = COUNT(*)
	FROM #t_users
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_users
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_users

	RETURN

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetPermissionDetailsByGroups
	@selection_xml TEXT
AS
BEGIN

	DECLARE @x_doc INT
	EXEC sp_xml_preparedocument @x_doc OUTPUT, @selection_xml

	DECLARE @t table (
		PermissionID int, 
		Name varchar(128), 
		Description varchar(500), 
		PermissionGroupID int,
		Allowed bit default(0),
		Denied bit default(0), 
		ViewInMedicalOffice bit, 
		ViewInBusinessManager bit, 
		ViewInAdministrator bit, 
		ViewInServiceManager bit
		)

	DECLARE @duplicates table (
		PermissionID int
		)

	INSERT INTO @t
	SELECT	P.PermissionID,
		P.Name,
		P.Description,
		P.PermissionGroupID,
		isnull(SGP.Allowed, 0), 
		isnull(SGP.Denied, 0), 
		ViewInMedicalOffice,
		ViewInBusinessManager,
		ViewInAdministrator,
		ViewInServiceManager
	FROM	
		Permissions P
	INNER JOIN 
		PermissionGroup PG 
	ON 	   PG.PermissionGroupID = P.PermissionGroupID
	LEFT OUTER JOIN
		SecurityGroupPermissions SGP
	ON	   SGP.SecurityGroupID IN (SELECT	GroupID
				  FROM		OPENXML(@x_doc, 'selections/selection')
				  WITH 		(GroupID INT))
		AND SGP.PermissionID = P.PermissionID
	GROUP BY
		P.PermissionID,
		P.Name,
		P.Description,
		P.PermissionGroupID,
		Allowed, 
		Denied, 
		ViewInMedicalOffice,
		ViewInBusinessManager,
		ViewInAdministrator,
		ViewInServiceManager


	-- Gets all of the duplicated permissions
	INSERT INTO @duplicates
	SELECT	PermissionID
	FROM	@t
	GROUP BY
		PermissionID
	HAVING	Count(PermissionID) > 1

	-- Removes any duplicated records where allowed and denied permissions are set to 0 
	-- when there is obviously another record that is set for that permission
	DELETE FROM T
	FROM	@t T
	INNER JOIN
		@duplicates D
	ON	   D.PermissionID = T.PermissionID
	WHERE	T.Allowed = 0
	AND	T.Denied = 0

	-- Get the duplicates now that the 0s are taken out
	DELETE 	@duplicates

	INSERT INTO @duplicates
	SELECT	PermissionID
	FROM	@t
	GROUP BY
		PermissionID
	HAVING	Count(PermissionID) > 1


	-- Removes any allowed permission when there is a duplicated denied permission
	DELETE FROM T
	FROM	@t T
	INNER JOIN
		@duplicates D
	ON	   D.PermissionID = T.PermissionID
	WHERE	T.Allowed = 1

	SELECT	*
	FROM	@t

	EXEC sp_xml_removedocument @x_doc
		
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetPermissionDetailsByUser
	@userName VARCHAR(256)
AS
BEGIN

	DECLARE @t table (
		PermissionID int, 
		Name varchar(128), 
		Description varchar(500), 
		PermissionGroupID int,
		Allowed bit default(0),
		Denied bit default(0), 
		ViewInMedicalOffice bit, 
		ViewInBusinessManager bit, 
		ViewInAdministrator bit, 
		ViewInServiceManager bit
		)

	DECLARE @duplicates table (
		PermissionID int
		)

	INSERT INTO @t
	SELECT	P.PermissionID,
		P.Name,
		P.Description,
		P.PermissionGroupID,
		isnull(SGP.Allowed, 0), 
		isnull(SGP.Denied, 0), 
		ViewInMedicalOffice,
		ViewInBusinessManager,
		ViewInAdministrator,
		ViewInServiceManager
	FROM	
		Permissions P
	INNER JOIN 
		PermissionGroup PG 
	ON 	   PG.PermissionGroupID = P.PermissionGroupID
	LEFT OUTER JOIN
		Users U ON U.EmailAddress = @userName
	LEFT OUTER JOIN
		UsersSecurityGroup USG ON U.UserID = USG.UserID
	LEFT OUTER JOIN
		SecurityGroupPermissions SGP
	ON	   USG.SecurityGroupID = SGP.SecurityGroupID AND SGP.PermissionID = P.PermissionID
	GROUP BY
		P.PermissionID,
		P.Name,
		P.Description,
		P.PermissionGroupID,
		Allowed, 
		Denied, 
		ViewInMedicalOffice,
		ViewInBusinessManager,
		ViewInAdministrator,
		ViewInServiceManager


	-- Gets all of the duplicated permissions
	INSERT INTO @duplicates
	SELECT	PermissionID
	FROM	@t
	GROUP BY
		PermissionID
	HAVING	Count(PermissionID) > 1

	-- Removes any duplicated records where allowed and denied permissions are set to 0 
	-- when there is obviously another record that is set for that permission
	DELETE FROM T
	FROM	@t T
	INNER JOIN
		@duplicates D
	ON	   D.PermissionID = T.PermissionID
	WHERE	T.Allowed = 0
	AND	T.Denied = 0

	-- Get the duplicates now that the 0s are taken out
	DELETE 	@duplicates

	INSERT INTO @duplicates
	SELECT	PermissionID
	FROM	@t
	GROUP BY
		PermissionID
	HAVING	Count(PermissionID) > 1


	-- Removes any allowed permission when there is a duplicated denied permission
	DELETE FROM T
	FROM	@t T
	INNER JOIN
		@duplicates D
	ON	   D.PermissionID = T.PermissionID
	WHERE	T.Allowed = 1

	SELECT	*
	FROM	@t

		
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetPermissionGroups
AS
BEGIN

	SELECT
		PermissionGroupID,
		Name,
		Description
	FROM
		PermissionGroup
	ORDER BY
		Name

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET PERMISSIONS
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetPermissions
AS
BEGIN
	SELECT	PermissionID,
		Name,
		Description,
		PermissionGroupID,
		ViewInMedicalOffice,
		ViewInBusinessManager,
		ViewInAdministrator,
		ViewInServiceManager
	FROM	
		Permissions
	ORDER BY
		Name
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetPermissionsByUser
	@UserName VARCHAR(256),
	@CustomerID int
AS
BEGIN

	IF @CustomerID = 0
		SET @CustomerID = NULL


	DECLARE @t table (PermissionValue varchar(128), Allowed int default(0), Denied int default(0))
	
	INSERT INTO @t
	SELECT	
		P.PermissionValue,
		SGP.Allowed,
		SGP.Denied
	FROM	
		dbo.Permissions P
		INNER JOIN dbo.SecurityGroupPermissions SGP 
		ON P.PermissionID = SGP.PermissionID
		INNER JOIN dbo.UsersSecurityGroup USG 
		ON SGP.SecurityGroupID = USG.SecurityGroupID
		INNER JOIN [dbo].[SecurityGroup] SG
		ON SGP.SecurityGroupID = SG.SecurityGroupID
		INNER JOIN dbo.Users U
		ON USG.UserID = U.UserID
	WHERE	
		U.EmailAddress = @userName
		AND (SG.CustomerID = @CustomerID OR SG.CustomerID IS NULL)
			

	DELETE FROM
		T
	FROM
		@t T
		INNER JOIN @t T2 
		ON T.PermissionValue = T2.PermissionValue
	WHERE
		T2.Denied = 1

	DELETE FROM
		@t
	WHERE
		Allowed <> 1

	SELECT DISTINCT PermissionValue FROM @t ORDER BY PermissionValue

	RETURN		
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetSecretQuestion
	@UserName varchar(256)
AS
BEGIN

	SELECT
		UP.SecretQuestion
	FROM
		dbo.UserPassword UP
		INNER JOIN dbo.Users U 
		ON UP.UserPasswordID = U.UserPasswordID
	WHERE
		U.EmailAddress = @UserName

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET GROUP
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetSecurityGroup
	@SecurityGroupID int
AS
BEGIN
	SELECT	SecurityGroupID,
		SecurityGroupName,
		SecurityGroupDescription,
		ViewInBusinessManager,
		ViewInAdministrator,
		ViewInMedicalOffice,
		ViewInServiceManager
	FROM	dbo.SecurityGroup
	WHERE	SecurityGroupID = @SecurityGroupID
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET GROUP PERMISSIONS
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetSecurityGroupPermissions
	@SecurityGroupID int
AS
BEGIN
	SELECT	@SecurityGroupID AS SecurityGroupID,
		P.PermissionID,
		P.Name,
		P.Description,
		P.PermissionGroupID,
		SGP.Allowed,
		SGP.Denied,
		P.ViewInMedicalOffice,
		P.ViewInBusinessManager,
		P.ViewInAdministrator,
		P.ViewInServiceManager		
	FROM	
		dbo.Permissions P
		INNER JOIN dbo.SecurityGroupPermissions SGP 
		ON P.PermissionID = SGP.PermissionID
	WHERE
		SGP.SecurityGroupID = @SecurityGroupID
		
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--TEST
DECLARE @CustomerID int
DECLARE @AppName varchar(30)
DECLARE @query_domain varchar(50)
DECLARE @query varchar(50)
DECLARE @startRecord int
DECLARE @maxRecords int
DECLARE @totalRecords int

SET @CustomerID = 1

SET @AppName = 'BusinessManager'
SET @query_domain = NULL
SET @query = NULL
SET @startRecord = 0 
SET @maxRecords = 25

EXECUTE [dbo].[Shared_AuthenticationDataProvider_GetSecurityGroups] @CustomerID, @AppName, @query_domain, @query, @startRecord, @maxRecords, @totalRecords OUTPUT

SELECT @totalRecords

*/

--===========================================================================
-- GET GROUPS
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetSecurityGroups
	@CustomerID int,
	@AppName varchar(30),
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL, 
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN
	--AppName Must be one of the following
	--  ServiceManager
	--	MedicalOffice
	--	Administrator
	--	BusinessManager
	IF @AppName NOT IN ('ServiceManager', 'MedicalOffice', 'Administrator', 'BusinessManager')
	BEGIN
		DECLARE @sql_error varchar(255)
		SET @sql_error = 'The AppName of ' + ISNULL(@AppName,'NULL') + ' must be valid'
		RAISERROR(@sql_error, 16, 1)
		RETURN 1
	END
	
	IF @CustomerID = 0
		SET @CustomerID = NULL
	
	CREATE TABLE #t_groups(
		SecurityGroupID int,
		SecurityGroupName varchar(32),
		SecurityGroupDescription varchar(500),
		ViewInMedicalOffice bit,
		ViewInBusinessManager bit,
		ViewInAdministrator bit,
		ViewInServiceManager bit,
		CompanyName varchar(128),
		RID int IDENTITY(0,1)
	)

	INSERT INTO #t_groups(
		SecurityGroupID,
		SecurityGroupName,
		SecurityGroupDescription,
		ViewInMedicalOffice,
		ViewInBusinessManager,
		ViewInAdministrator,
		ViewInServiceManager,
		CompanyName
	)
	SELECT	SecurityGroupID,
		SecurityGroupName,
		SecurityGroupDescription,
		ViewInMedicalOffice,
		ViewInBusinessManager,
		ViewInAdministrator,
		ViewInServiceManager,
		COALESCE(C.CompanyName,'Kareo')
	FROM	
		dbo.SecurityGroup SG
		LEFT OUTER JOIN dbo.Customer C ON
		SG.CustomerID = C.CustomerID
	WHERE
		(SG.CustomerID = @CustomerID OR (@CustomerID IS NULL AND SG.CustomerID IS NULL))
		AND
			(	
			(@query_domain IS NULL OR @query IS NULL)
			OR	(	(@query_domain = 'GroupName' OR @query_domain = 'All')
					AND	(SecurityGroupName LIKE '%' + @query + '%')
				)
			OR	(	(@query_domain = 'Description' OR @query_domain = 'All')
					AND	(SecurityGroupDescription LIKE '%' + @query + '%')
				)
			)
		AND 
			(
				(@AppName = 'ServiceManager' AND SG.ViewInServiceManager = 1)
				OR 
				(@AppName = 'MedicalOffice' AND SG.ViewInMedicalOffice = 1)
				OR 
				(@AppName = 'Administrator' AND SG.ViewInAdministrator = 1)
				OR 
				(@AppName = 'BusinessManager' AND SG.ViewInBusinessManager = 1)
			)
	ORDER BY SG.SecurityGroupName

	SELECT @totalRecords = COUNT(*)
	FROM #t_groups
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_groups
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_groups
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET GROUP USERS
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetSecurityGroupUsers
	@SecurityGroupID INT
AS
BEGIN
	SELECT	USG.SecurityGroupID,
		U.UserID,
		U.Prefix, 
		U.FirstName, 
		U.MiddleName, 
		U.LastName, 
		U.Suffix,
		U.EmailAddress
	FROM	
		dbo.Users U
		INNER JOIN dbo.UsersSecurityGroup USG 
		ON U.UserID = USG.UserID
	WHERE
		USG.SecurityGroupID = @SecurityGroupID
	ORDER BY
		U.LastName,
		U.FirstName

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetSecuritySettingsByUsername
	@EmailAddress varchar(128)
AS
BEGIN
	--Returns the first customer and lockout information
	--but the most limiting security settings
	
	--check if user exists
	DECLARE @UserID int
	DECLARE @CustomerCountForUser int
	SET @CustomerCountForUser = 0
	SET @UserID = (SELECT UserID FROM Users WHERE EmailAddress = @EmailAddress)

	IF @UserID IS NOT NULL
	BEGIN
		SET @CustomerCountForUser = (SELECT COUNT(0) FROM CustomerUsers WHERE UserID = @UserID)
	END
	
	IF @UserID IS NOT NULL AND @CustomerCountForUser > 0
	BEGIN
		SELECT
			MIN(SS.CustomerID) AS CustomerID,
			MAX(PasswordMinimumLength) AS PasswordMinimumLength,
			CAST(MAX(CAST(PasswordRequireAlphaNumeric AS int)) AS bit) AS PasswordRequireAlphaNumeric,
			CAST(MAX(CAST(PasswordRequireMixedCase AS int)) AS bit) AS PasswordRequireMixedCase,
			CAST(MAX(CAST(PasswordRequireNonAlphaNumeric AS int)) AS bit) AS PasswordRequireNonAlphaNumeric,
			CAST(MAX(CAST(PasswordRequireDifferentPassword AS int)) AS bit) AS PasswordRequireDifferentPassword,
			MAX(PasswordRequireDifferentPasswordCount) AS PasswordRequireDifferentPasswordCount,
			CAST(MAX(CAST(PasswordExpiration AS int)) AS bit) AS PasswordExpiration,
			MIN(PasswordExpirationDays) AS PasswordExpirationDays,
			MIN(LockoutAttempts) AS LockoutAttempts,
			(SELECT LockoutPhone
			FROM dbo.SecuritySetting SS1
			WHERE SS1.CustomerID = MIN(SS.CustomerID)) AS LockoutPhone,
			(SELECT SS2.LockoutEmail
			FROM dbo.SecuritySetting SS2
			WHERE SS2.CustomerID = MIN(SS.CustomerID)) AS LockoutEmail,
			MIN(UILockMinutesAdministrator) AS UILockMinutesAdministrator,
			MIN(UILockMinutesBusinessManager) AS UILockMinutesBusinessManager,
			MIN(UILockMinutesMedicalOffice) AS UILockMinutesMedicalOffice,
			MIN(UILockMinutesPractitioner) AS UILockMinutesPractitioner,
			MIN(UILockMinutesServiceManager) AS UILockMinutesServiceManager
		FROM
			dbo.SecuritySetting SS
			INNER JOIN dbo.CustomerUsers CU ON SS.CustomerID = CU.CustomerID
			INNER JOIN dbo.Users U ON U.UserID = CU.UserID 
		WHERE U.EmailAddress = @EmailAddress
	END
	ELSE
	BEGIN
		SELECT
			MIN(SS.CustomerID) AS CustomerID,
			MAX(PasswordMinimumLength) AS PasswordMinimumLength,
			CAST(MAX(CAST(PasswordRequireAlphaNumeric AS int)) AS bit) AS PasswordRequireAlphaNumeric,
			CAST(MAX(CAST(PasswordRequireMixedCase AS int)) AS bit) AS PasswordRequireMixedCase,
			CAST(MAX(CAST(PasswordRequireNonAlphaNumeric AS int)) AS bit) AS PasswordRequireNonAlphaNumeric,
			CAST(MAX(CAST(PasswordRequireDifferentPassword AS int)) AS bit) AS PasswordRequireDifferentPassword,
			MAX(PasswordRequireDifferentPasswordCount) AS PasswordRequireDifferentPasswordCount,
			CAST(MAX(CAST(PasswordExpiration AS int)) AS bit) AS PasswordExpiration,
			MIN(PasswordExpirationDays) AS PasswordExpirationDays,
			MIN(LockoutAttempts) AS LockoutAttempts,
			(SELECT LockoutPhone
			FROM dbo.SecuritySetting SS1
			WHERE SS1.CustomerID = MIN(SS.CustomerID)) AS LockoutPhone,
			(SELECT SS2.LockoutEmail
			FROM dbo.SecuritySetting SS2
			WHERE SS2.CustomerID = MIN(SS.CustomerID)) AS LockoutEmail,
			MIN(UILockMinutesAdministrator) AS UILockMinutesAdministrator,
			MIN(UILockMinutesBusinessManager) AS UILockMinutesBusinessManager,
			MIN(UILockMinutesMedicalOffice) AS UILockMinutesMedicalOffice,
			MIN(UILockMinutesPractitioner) AS UILockMinutesPractitioner,
			MIN(UILockMinutesServiceManager) AS UILockMinutesServiceManager
		FROM
			dbo.SecuritySetting SS
		WHERE SS.CustomerID IS NULL
	END
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetSecuritySettingsForCustomer
	@CustomerID int
AS
BEGIN

	IF @CustomerID = 0
		SET @CustomerID = NULL


	SELECT
		SecuritySettingID,
		CustomerID,
		PasswordMinimumLength,
		PasswordRequireAlphaNumeric,
		PasswordRequireMixedCase,
		PasswordRequireNonAlphaNumeric,
		PasswordRequireDifferentPassword,
		PasswordRequireDifferentPasswordCount,
		PasswordExpiration,
		PasswordExpirationDays,
		LockoutAttempts,
		LockoutPhone,
		LockoutEmail,
		UILockMinutesAdministrator,
		UILockMinutesBusinessManager,
		UILockMinutesMedicalOffice,
		UILockMinutesPractitioner,
		UILockMinutesServiceManager
	FROM
		dbo.SecuritySetting SS
	WHERE 
		SS.CustomerID = @CustomerID OR (@CustomerID IS NULL AND SS.CustomerID IS NULL)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetSecuritySettingsForUser
	@UserID int
AS
BEGIN
	--Returns the first customer and lockout information
	--but the most limiting security settings
	
	SELECT
		MIN(SS.CustomerID) AS CustomerID,
		MAX(PasswordMinimumLength) AS PasswordMinimumLength,
		MAX(CAST(PasswordRequireAlphaNumeric AS int)) AS PasswordRequireAlphaNumeric,
		MAX(CAST(PasswordRequireMixedCase AS int)) AS PasswordRequireMixedCase,
		MAX(CAST(PasswordRequireNonAlphaNumeric AS int)) AS PasswordRequireNonAlphaNumeric,
		MAX(CAST(PasswordRequireDifferentPassword AS int)) AS PasswordRequireDifferentPassword,
		MAX(PasswordRequireDifferentPasswordCount) AS PasswordRequireDifferentPasswordCount,
		MAX(CAST(PasswordExpiration AS int)) AS PasswordExpiration,
		MIN(PasswordExpirationDays) AS PasswordExpirationDays,
		MIN(LockoutAttempts) AS LockoutAttempts,
		(SELECT LockoutPhone
		FROM dbo.SecuritySetting SS1
		WHERE SS1.CustomerID = MIN(SS.CustomerID)) AS LockoutPhone,
		(SELECT SS2.LockoutEmail
		FROM dbo.SecuritySetting SS2
		WHERE SS2.CustomerID = MIN(SS.CustomerID)) AS LockoutEmail,
		MIN(UILockMinutesAdministrator) AS UILockMinutesAdministrator,
		MIN(UILockMinutesBusinessManager) AS UILockMinutesBusinessManager,
		MIN(UILockMinutesMedicalOffice) AS UILockMinutesMedicalOffice,
		MIN(UILockMinutesPractitioner) AS UILockMinutesPractitioner,
		MIN(UILockMinutesServiceManager) AS UILockMinutesServiceManager
	FROM
		dbo.SecuritySetting SS
		INNER JOIN dbo.CustomerUsers CU
		ON SS.CustomerID = CU.CustomerID
	WHERE CU.UserID = @UserID
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET USER
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetUser
	@UserID INT
AS
BEGIN
	SELECT	UserID,
		Prefix,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		AddressLine1,
		AddressLine2,
		City,
		State,
		Country,
		ZipCode,
		WorkPhone,
		WorkPhoneExt,
		AlternativePhone,
		AlternativePhoneExt,
		EmailAddress,
		Notes,
		AccountLocked
	FROM	Users
	WHERE	UserID = @UserID
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET USER
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetUserCustomers
	@UserID int
AS
BEGIN

	SELECT
		CU.UserID, 
		C.CustomerID,
		CompanyName
	FROM  dbo.CustomerUsers CU
		INNER JOIN dbo.Customer C
		ON CU.CustomerID = C.CustomerID
	WHERE CU.UserID = @UserID
	ORDER BY CompanyName
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET USER
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetUserForUsername
	@Username varchar(128)
AS
BEGIN
	DECLARE @CustomerCount int
	DECLARE @CustomerID int
		
	SELECT @CustomerCount = COUNT(*)
	FROM dbo.CustomerUsers CU
		INNER JOIN dbo.Users U
		ON CU.UserID = U.UserID
	WHERE U.EmailAddress = @Username
	
	/*
		if user belongs to no customers, 
			CustomerID = 0
		
		if user belongs to exactly one customer
			CustomerID is the ID of that customer
		
		if user belongs to more than one customer
			CustomerID = -1
	*/
	
	IF @CustomerCount = 1
	BEGIN
		SELECT @CustomerID = CustomerID
		FROM dbo.CustomerUsers CU
			INNER JOIN dbo.Users U
			ON CU.UserID = U.UserID
		WHERE U.EmailAddress = @Username
	END
	ELSE IF @CustomerCount = 0
		SET @CustomerID = 0
	ELSE IF @CustomerCount > 1
		SET @CustomerID = -1
	
	SELECT	UserID,
		Prefix,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		AddressLine1,
		AddressLine2,
		City,
		State,
		Country,
		ZipCode,
		WorkPhone,
		WorkPhoneExt,
		AlternativePhone,
		AlternativePhoneExt,
		EmailAddress,
		Notes,
		AccountLocked,
		@CustomerID AS CustomerID	
	FROM	dbo.Users U
	WHERE	U.EmailAddress = @Username
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET USERS
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetUsers
	@CustomerID int,
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

	CREATE TABLE #t_users(
		UserID int,
		Prefix varchar(16), 
		FirstName varchar(64), 
		MiddleName varchar(64), 
		LastName varchar(64), 
		Suffix varchar(16), 
		AddressLine1 varchar(256), 
		AddressLine2 varchar(256), 
		City varchar(128), 
		State char(2), 
		Country varchar(32), 
		ZipCode varchar(9), 
		WorkPhone varchar(10), 
		WorkPhoneExt varchar(10), 
		AlternativePhone varchar(10), 
		AlternativePhoneExt varchar(10), 
		EmailAddress varchar(256), 
		AccountLocked bit,
		PasswordExpired bit,
		RID int IDENTITY(0,1)
	)

	INSERT INTO #t_users(
		UserID,
		Prefix, 
		FirstName, 
		MiddleName, 
		LastName, 
		Suffix, 
		AddressLine1, 
		AddressLine2, 
		City, 
		State,
		Country, 
		ZipCode, 
		WorkPhone, 
		WorkPhoneExt, 
		AlternativePhone, 
		AlternativePhoneExt, 
		EmailAddress,
		AccountLocked,
		PasswordExpired
	)
	SELECT	U.UserID,
		U.Prefix,
		U.FirstName,
		U.MiddleName,
		U.LastName,
		U.Suffix,
		U.AddressLine1,
		U.AddressLine2,
		U.City,
		U.State,
		U.Country,
		U.ZipCode,
		U.WorkPhone,
		U.WorkPhoneExt,
		U.AlternativePhone,
		U.AlternativePhoneExt,
		U.EmailAddress,
		U.AccountLocked,
		COALESCE(UP.Expired,0)
	FROM dbo.Users U
		INNER JOIN dbo.CustomerUsers CU
		ON U.UserID = CU.UserID
		LEFT OUTER JOIN dbo.UserPassword UP 
		ON U.UserPasswordID = UP.UserPasswordID
	WHERE	(	(@query_domain IS NULL OR @query IS NULL)
		OR	((@query_domain = 'UserName' OR @query_domain = 'All')
			  AND (Prefix LIKE '%' + @query + '%' 
			  OR   FirstName LIKE '%' + @query + '%'
			  OR   MiddleName LIKE '%' + @query + '%'
			  OR   LastName LIKE '%' + @query + '%' 
			  OR   Suffix LIKE '%' + @query + '%'))
		OR	((@query_domain = 'UserPrimaryPhone' OR @query_domain = 'All')
			  AND (WorkPhone LIKE '%' + @query + '%'
			  OR   WorkPhoneExt LIKE '%' + @query + '%'))
		OR	((@query_domain = 'UserSecondaryPhone' OR @query_domain = 'All')
			  AND (AlternativePhone LIKE '%' + @query + '%'
			  OR   AlternativePhoneExt LIKE '%' + @query + '%'))
		OR	((@query_domain = 'UserEmail' OR @query_domain = 'All')
			  AND (EmailAddress LIKE '%' + @query + '%'))
		)
		AND CU.CustomerID = @CustomerID
	ORDER BY
		U.LastName,
		U.FirstName

	SELECT @totalRecords = COUNT(*)
	FROM #t_users
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_users
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_users

	RETURN

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET USER GROUPS
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_GetUserSecurityGroups
	@UserID int,
	@CustomerID int
AS
BEGIN
	--Only shows the 
	IF @CustomerID = 0
		SET @CustomerID = NULL

	SELECT	USG.UserID,
		SG.CustomerID,
		SG.SecurityGroupID,
		SG.SecurityGroupName,
		SG.ViewInMedicalOffice,
		SG.ViewInBusinessManager,
		SG.ViewInAdministrator,
		SG.ViewInServiceManager
	FROM	
		dbo.SecurityGroup SG
		INNER JOIN dbo.UsersSecurityGroup USG 
			ON SG.SecurityGroupID = USG.SecurityGroupID
	WHERE	
		USG.UserID = @UserID
		AND (SG.CustomerID = @CustomerID or (@CustomerID is null and SG.CustomerID is null))
	ORDER BY 
		SG.SecurityGroupName
		
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_SetPassword
	@UserID int,
	@PasswordHash varchar(40)
AS
BEGIN
	--get old password
	
	DECLARE @UserPasswordID int
	
	SET @UserPasswordID = 
		(
			SELECT 
				UserPasswordID
			FROM 
				Users 
			WHERE
				UserID = @UserID
		)

	
	--check password for similarity to old passwords

	DECLARE @PasswordRequireDifferentPassword bit
	DECLARE @PasswordRequireDifferentPasswordCount int

	SELECT 
		@PasswordRequireDifferentPassword = MAX(CAST(PasswordRequireDifferentPassword AS int)), 
		@PasswordRequireDifferentPasswordCount = MAX(PasswordRequireDifferentPasswordCount)
	FROM 
		dbo.SecuritySetting SS
		INNER JOIN dbo.CustomerUsers CU
		ON SS.CustomerID = CU.CustomerID
	WHERE CU.UserID = @UserID
	
	IF @PasswordRequireDifferentPassword = 1
	BEGIN
		DECLARE @ExistingPassword varchar(40)
		DECLARE @MaxCount int
		DECLARE @CurrentCount int
		DECLARE @MatchFound bit
		SET @MaxCount = @PasswordRequireDifferentPasswordCount
		SET @CurrentCount = 0
		SET @MatchFound = 0

		DECLARE password_cursor CURSOR READ_ONLY
		FOR
			SELECT	
				[Password]
			FROM	
				UserPassword
			WHERE
				UserID = @UserID
			ORDER BY
				CreatedDate DESC

		OPEN password_cursor

		FETCH NEXT FROM password_cursor
		INTO	@ExistingPassword

		WHILE (@@FETCH_STATUS = 0 AND @CurrentCount < @MaxCount AND @MatchFound = 0)
		BEGIN

			SET @CurrentCount = @CurrentCount + 1

			--SELECT @FirstName 

			IF (@ExistingPassword = @PasswordHash) 
			BEGIN
				SET @MatchFound = 1
			END

			FETCH NEXT FROM password_cursor
			INTO	@ExistingPassword
		END

		CLOSE password_cursor
		DEALLOCATE password_cursor

		IF (@MatchFound = 1)
		BEGIN
			SELECT 'PasswordMatch'
			RETURN
		END
	END
	
	--create new password

	IF @PasswordHash IS NULL
	BEGIN
		SELECT 'BadPassword'
		RETURN
	END
	
	INSERT INTO 
		UserPassword
		(
			UserID,
			Password,
			CreatedDate,
			Expired
		)
		VALUES
		(
			@UserID,
			@PasswordHash,
			GETDATE(),
			1
		)
	
	DECLARE @NewUserPasswordID int
	SET @NewUserPasswordID = SCOPE_IDENTITY()

	IF @NewUserPasswordID IS NULL
	BEGIN
		SELECT 'BadPassword'
		RETURN
	END

	--expire old password and update user record with the new one
	
	IF @UserPasswordID IS NOT NULL
	BEGIN
		UPDATE UserPassword SET Expired = 1 WHERE UserPasswordID = @UserPasswordID
	END

	
	UPDATE
		Users
	SET
		UserPasswordID = @NewUserPasswordID
	WHERE
		UserID = @UserID

	--reset lockout counter
	
	UPDATE Users SET AccountLockCounter = 0 WHERE UserID = @UserID

	
	--if we got this far, we've correctly changed the password
	
	SELECT 'OK'

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_SetPasswordWithOldPassword
	@UserName varchar(256),
	@OldPasswordHash varchar(40),
	@PasswordHash varchar(40), 
	@SecretQuestion varchar(255) = NULL, 
	@SecretAnswerHash varchar(40) = NULL
AS
BEGIN

	--check if user exists
	
	DECLARE @UserID int
	SET @UserID = (SELECT UserID FROM Users WHERE EmailAddress = @UserName)
	
	IF @UserID IS NULL
	BEGIN
		SELECT 'NoAuth'
		RETURN
	END

	--check if locked out
	
	IF EXISTS 
		(
			SELECT * FROM Users WHERE AccountLocked = 1 AND UserID = @UserID
		)
	BEGIN
		SELECT 'LockedOut'
		RETURN
	END


	--incremenet login attempts for lockout
	
	UPDATE Users 
	SET AccountLockCounter = AccountLockCounter + 1
	WHERE UserID = @UserID


	
	--check if authenticates
	
	DECLARE @UserPasswordID int
	
	SET @UserPasswordID = 
		(
			SELECT 
				UP.UserPasswordID
			FROM 
				dbo.UserPassword UP
				INNER JOIN Users U 
				ON U.UserPasswordID = UP.UserPasswordID
			WHERE
				U.UserID = @UserID
				AND UP.Password = @OldPasswordHash
		)

	IF @UserPasswordID IS NULL
	BEGIN
	
		--lock out if too many attempts

		DECLARE @MaxLockCounter int
		DECLARE @CurrentLockCounter int

		SET @MaxLockCounter = (
			SELECT MIN(SS.LockoutAttempts) 
			FROM dbo.SecuritySetting SS
				INNER JOIN dbo.CustomerUsers CU
				ON SS.CustomerID = CU.CustomerID
			WHERE CU.UserID = @UserID)
			
		SET @CurrentLockCounter = (SELECT AccountLockCounter FROM Users WHERE UserID = @UserID)

		IF (@CurrentLockCounter >= @MaxLockCounter)
		BEGIN
			UPDATE Users SET AccountLocked = 1 WHERE UserID = @UserID
			SELECT 'LockedOutNow'
			RETURN
		END
	
	
		SELECT 'NoAuth'
		RETURN
	END
	
	--reset lockout counter
	
	UPDATE Users SET AccountLockCounter = 0 WHERE UserID = @UserID

	--check password for similarity to old passwords

	DECLARE @PasswordRequireDifferentPassword bit
	DECLARE @PasswordRequireDifferentPasswordCount int

	SELECT 
		@PasswordRequireDifferentPassword = MAX(CAST(PasswordRequireDifferentPassword AS int)), 
		@PasswordRequireDifferentPasswordCount = MAX(PasswordRequireDifferentPasswordCount)
	FROM 
		dbo.SecuritySetting SS
		INNER JOIN dbo.CustomerUsers CU
		ON SS.CustomerID = CU.CustomerID
	WHERE CU.UserID = @UserID

	IF @PasswordRequireDifferentPassword = 1
	BEGIN
		DECLARE @ExistingPassword varchar(40)
		DECLARE @MaxCount int
		DECLARE @CurrentCount int
		DECLARE @MatchFound bit
		SET @MaxCount = @PasswordRequireDifferentPasswordCount
		SET @CurrentCount = 0
		SET @MatchFound = 0

		DECLARE password_cursor CURSOR READ_ONLY
		FOR
			SELECT	
				[Password]
			FROM	
				UserPassword
			WHERE
				UserID = @UserID
			ORDER BY
				CreatedDate DESC

		OPEN password_cursor

		FETCH NEXT FROM password_cursor
		INTO	@ExistingPassword

		WHILE (@@FETCH_STATUS = 0 AND @CurrentCount < @MaxCount AND @MatchFound = 0)
		BEGIN

			SET @CurrentCount = @CurrentCount + 1

			--SELECT @FirstName 

			IF (@ExistingPassword = @PasswordHash) 
			BEGIN
				SET @MatchFound = 1
			END

			FETCH NEXT FROM password_cursor
			INTO	@ExistingPassword
		END

		CLOSE password_cursor
		DEALLOCATE password_cursor

		IF (@MatchFound = 1)
		BEGIN
			SELECT 'PasswordMatch'
			RETURN
		END
	END

	--create new password

	IF @PasswordHash IS NULL
	BEGIN
		SELECT 'BadPassword'
		RETURN
	END
	
	INSERT INTO 
		UserPassword
		(
			UserID,
			Password,
			SecretQuestion,
			SecretAnswer,
			CreatedDate
		)
		VALUES
		(
			@UserID,
			@PasswordHash,
			@SecretQuestion,
			@SecretAnswerHash,
			GETDATE()
		)
	
	DECLARE @NewUserPasswordID int
	SET @NewUserPasswordID = SCOPE_IDENTITY()

	IF @NewUserPasswordID IS NULL
	BEGIN
		SELECT 'BadPassword'
		RETURN
	END

	--expire old password and update user record with the new one

	UPDATE UserPassword SET Expired = 1 WHERE UserPasswordID = @UserPasswordID

	
	UPDATE
		Users
	SET
		UserPasswordID = @NewUserPasswordID
	WHERE
		UserID = @UserID
	
	--if we got this far, we've correctly changed the password
	
	SELECT 'OK'

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_SetPasswordWithOldSecretAnswer
	@UserName varchar(256),
	@OldSecretAnswerHash varchar(40),
	@PasswordHash varchar(40), 
	@SecretQuestion varchar(255) = NULL, 
	@SecretAnswerHash varchar(40) = NULL
AS
BEGIN

	--check if user exists
	DECLARE @UserID int
	SET @UserID = (SELECT UserID FROM Users WHERE EmailAddress = @UserName)
	
	IF @UserID IS NULL
	BEGIN
		SELECT 'NoAuth'
		RETURN
	END

	--check if locked out
	IF EXISTS 
		(
			SELECT * FROM Users WHERE AccountLocked = 1 AND UserID = @UserID
		)
	BEGIN
		SELECT 'LockedOut'
		RETURN
	END

	--incremenet login attempts for lockout
	UPDATE Users 
	SET AccountLockCounter = AccountLockCounter + 1
	WHERE UserID = @UserID

	--check if authenticates
	DECLARE @UserPasswordID int
	
	SET @UserPasswordID = 
		(
			SELECT 
				UP.UserPasswordID
			FROM 
				dbo.UserPassword UP
				INNER JOIN dbo.Users U 
				ON U.UserPasswordID = UP.UserPasswordID
			WHERE
				U.UserID = @UserID
					AND UP.SecretAnswer = @OldSecretAnswerHash
		)

	IF @UserPasswordID IS NULL
	BEGIN	
		--lock out if too many attempts
		DECLARE @MaxLockCounter int
		DECLARE @CurrentLockCounter int

		SET @MaxLockCounter = (
			SELECT MIN(SS.LockoutAttempts) 
			FROM dbo.SecuritySetting SS
				INNER JOIN dbo.CustomerUsers CU
				ON SS.CustomerID = CU.CustomerID
			WHERE CU.UserID = @UserID)
			
		SET @CurrentLockCounter = (SELECT AccountLockCounter FROM Users WHERE UserID = @UserID)

		IF (@CurrentLockCounter >= @MaxLockCounter)
		BEGIN
			UPDATE Users SET AccountLocked = 1 WHERE UserID = @UserID
			SELECT 'LockedOutNow'
			RETURN
		END
	
	
		SELECT 'NoAuth'
		RETURN
	END
	
	--reset lockout counter
	UPDATE Users SET AccountLockCounter = 0 WHERE UserID = @UserID

	--check password for similarity to old passwords

	DECLARE @PasswordRequireDifferentPassword bit
	DECLARE @PasswordRequireDifferentPasswordCount int

	SELECT 
		@PasswordRequireDifferentPassword = MAX(CAST(PasswordRequireDifferentPassword AS int)), 
		@PasswordRequireDifferentPasswordCount = MAX(PasswordRequireDifferentPasswordCount)
	FROM 
		dbo.SecuritySetting SS
		INNER JOIN dbo.CustomerUsers CU
		ON SS.CustomerID = CU.CustomerID
	WHERE CU.UserID = @UserID

	IF @PasswordRequireDifferentPassword = 1
	BEGIN
		DECLARE @ExistingPassword varchar(40)
		DECLARE @MaxCount int
		DECLARE @CurrentCount int
		DECLARE @MatchFound bit
		SET @MaxCount = @PasswordRequireDifferentPasswordCount
		SET @CurrentCount = 0
		SET @MatchFound = 0

		DECLARE password_cursor CURSOR READ_ONLY
		FOR
			SELECT	
				[Password]
			FROM	
				UserPassword
			WHERE
				UserID = @UserID
			ORDER BY
				CreatedDate DESC

		OPEN password_cursor

		FETCH NEXT FROM password_cursor
		INTO	@ExistingPassword

		WHILE (@@FETCH_STATUS = 0 AND @CurrentCount < @MaxCount AND @MatchFound = 0)
		BEGIN

			SET @CurrentCount = @CurrentCount + 1

			--SELECT @FirstName 

			IF (@ExistingPassword = @PasswordHash) 
			BEGIN
				SET @MatchFound = 1
			END

			FETCH NEXT FROM password_cursor
			INTO	@ExistingPassword
		END

		CLOSE password_cursor
		DEALLOCATE password_cursor

		IF (@MatchFound = 1)
		BEGIN
			SELECT 'PasswordMatch'
			RETURN
		END
	END

	--create new password

	IF @PasswordHash IS NULL
	BEGIN
		SELECT 'BadPassword'
		RETURN
	END
	
	INSERT INTO 
		UserPassword
		(
			UserID,
			Password,
			SecretQuestion,
			SecretAnswer,
			CreatedDate
		)
		VALUES
		(
			@UserID,
			@PasswordHash,
			@SecretQuestion,
			@SecretAnswerHash,
			GETDATE()
		)
	
	DECLARE @NewUserPasswordID int
	SET @NewUserPasswordID = SCOPE_IDENTITY()

	IF @NewUserPasswordID IS NULL
	BEGIN
		SELECT 'BadPassword'
		RETURN
	END

	--expire old password and update user record with the new one

	UPDATE UserPassword SET Expired = 1 WHERE UserPasswordID = @UserPasswordID

	
	UPDATE
		Users
	SET
		UserPasswordID = @NewUserPasswordID
	WHERE
		UserID = @UserID
	
	--if we got this far, we've correctly changed the password
	
	SELECT 'OK'

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- SET USER CUSTOMER 
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_SetUserCustomer
	@UserID int,
	@CustomerID int
AS
BEGIN
	IF NOT EXISTS (
		SELECT	*
		FROM	dbo.CustomerUsers
		WHERE	UserID = @UserID
		AND	CustomerID = @CustomerID
	)
		INSERT	CustomerUsers (
			UserID, 
			CustomerID
		)
		VALUES	(
			@UserID, 
			@CustomerID
		)
		
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- SET USER GROUP
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_SetUserSecurityGroup
	@UserID int,
	@SecurityGroupID int,
	@ModifiedUserID int
AS
BEGIN
	IF NOT EXISTS (
		SELECT	*
		FROM	dbo.UsersSecurityGroup
		WHERE	UserID = @UserID
			AND	SecurityGroupID = @SecurityGroupID
	)
		INSERT	UsersSecurityGroup (
			UserID, 
			SecurityGroupID,
			ModifiedDate,
			CreatedUserID,
			ModifiedUserID
		)
		VALUES	(
			@UserID, 
			@SecurityGroupID,
			GETDATE(),
			@ModifiedUserID,
			@ModifiedUserID
		)
		
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- UNSET USER GROUP
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_UnsetUserSecurityGroup
	@UserID int,
	@SecurityGroupID int
AS
BEGIN
	DELETE	dbo.UsersSecurityGroup
	WHERE	UserID = @UserID
		AND	SecurityGroupID = @SecurityGroupID
		
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- UPDATE GROUP
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_UpdateSecurityGroup
	@SecurityGroupID int,
	@SecurityGroupName VARCHAR(32),
	@SecurityGroupDescription VARCHAR(500),
	@ViewInMedicalOffice bit,
	@ViewInBusinessManager bit,
	@ViewInAdministrator bit,
	@ViewInServiceManager bit,
	@ModifiedUserID int
AS
BEGIN
	UPDATE	dbo.SecurityGroup
	SET	SecurityGroupName = @SecurityGroupName,
		SecurityGroupDescription = @SecurityGroupDescription,
		ViewInMedicalOffice = @ViewInMedicalOffice,
		ViewInBusinessManager = @ViewInBusinessManager,
		ViewInAdministrator = @ViewInAdministrator,
		ViewInServiceManager = @ViewInServiceManager,
		ModifiedDate = GETDATE(),
		ModifiedUserID = @ModifiedUserID
	WHERE	SecurityGroupID = @SecurityGroupID
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_UpdateSecurityGroupPermission
	@SecurityGroupID int,
	@PermissionID int,
	@Allowed bit,
	@Denied bit,
	@ModifiedUserID int
AS
BEGIN
	--if a record like this already exists, update it; otherwise create a new record
	IF EXISTS(
		SELECT * 
		FROM dbo.SecurityGroupPermissions 
		WHERE SecurityGroupID = @SecurityGroupID 
			AND PermissionID = @PermissionID
		)
	BEGIN
		IF (@Allowed = 1 OR @Denied = 1)
		BEGIN
			UPDATE SecurityGroupPermissions 
				SET Allowed = @Allowed, 
					Denied = @Denied,
					ModifiedDate = GETDATE(),
					ModifiedUserID = @ModifiedUserID
			WHERE SecurityGroupID = @SecurityGroupID
				AND PermissionID = @PermissionID
		END
		ELSE
		BEGIN
			DELETE SecurityGroupPermissions 
			WHERE SecurityGroupID = @SecurityGroupID
				AND PermissionID = @PermissionID
		END
	END
	ELSE
	BEGIN
		IF (@Allowed = 1 OR @Denied = 1)
		BEGIN
			INSERT INTO 
				SecurityGroupPermissions 
				(
					SecurityGroupID, 
					PermissionID, 
					Allowed, 
					Denied,
					CreatedUserID,
					ModifiedUserID
				)
			VALUES
				(
					@SecurityGroupID,
					@PermissionID,
					@Allowed,
					@Denied,
					@ModifiedUserID,
					@ModifiedUserID
				)
		END
	END

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_UpdateSecuritySettings
	@SecuritySettingID int,
	@CustomerID int,
	@PasswordMinimumLength int,
	@PasswordRequireAlphaNumeric bit,
	@PasswordRequireMixedCase bit,
	@PasswordRequireNonAlphaNumeric bit,
	@PasswordRequireDifferentPassword bit,
	@PasswordRequireDifferentPasswordCount int,
	@PasswordExpiration bit,
	@PasswordExpirationDays int,
	@LockoutAttempts int,
	@LockoutPhone varchar(10),
	@LockoutEmail varchar(100),
	@UILockMinutesAdministrator int,
	@UILockMinutesBusinessManager int,
	@UILockMinutesMedicalOffice int,
	@UILockMinutesPractitioner int, 
	@UILockMinutesServiceManager int
AS
BEGIN

	IF (@CustomerID = 0)
	BEGIN
		SET @CustomerID = NULL
	END

	UPDATE
		dbo.SecuritySetting
	SET
		PasswordMinimumLength = @PasswordMinimumLength,
		PasswordRequireAlphaNumeric = @PasswordRequireAlphaNumeric,
		PasswordRequireMixedCase = @PasswordRequireMixedCase,
		PasswordRequireNonAlphaNumeric = @PasswordRequireNonAlphaNumeric,
		PasswordRequireDifferentPassword = @PasswordRequireDifferentPassword,
		PasswordRequireDifferentPasswordCount = @PasswordRequireDifferentPasswordCount,
		PasswordExpiration = @PasswordExpiration,
		PasswordExpirationDays = @PasswordExpirationDays,
		LockoutAttempts = @LockoutAttempts,
		LockoutPhone = @LockoutPhone,
		LockoutEmail = @LockoutEmail,
		UILockMinutesAdministrator = @UILockMinutesAdministrator,
		UILockMinutesBusinessManager = @UILockMinutesBusinessManager,
		UILockMinutesMedicalOffice = @UILockMinutesMedicalOffice,
		UILockMinutesPractitioner = @UILockMinutesPractitioner, 
		UILockMinutesServiceManager = @UILockMinutesServiceManager
	WHERE	
		(CustomerID = @CustomerID OR (@CustomerID IS NULL AND CustomerID IS NULL))
		AND SecuritySettingID = @SecuritySettingID
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- UPDATE USER
--===========================================================================
CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_UpdateUser
	@user_id INT,
	@prefix VARCHAR(16),
	@first_name VARCHAR(32),
	@middle_name VARCHAR(32),
	@last_name VARCHAR(32),
	@suffix VARCHAR(16),
	@AccountLocked BIT,
	@address_1 VARCHAR(128) = NULL,
	@address_2 VARCHAR(128) = NULL,
	@city VARCHAR(32) = NULL,
	@state VARCHAR(2) = NULL,
	@country VARCHAR(32) = NULL,
	@zip VARCHAR(9) = NULL,
	@work_phone VARCHAR(10) = NULL,
	@work_phone_x VARCHAR(10) = NULL,
	@alternative_phone VARCHAR(10) = NULL,
	@alternative_phone_x VARCHAR(10) = NULL,
	@EmailAddress VARCHAR(256) = NULL,
	@notes TEXT = NULL,
	@ModifiedUserID int
AS
BEGIN

	DECLARE @OldAccountLocked BIT
	
	SET @OldAccountLocked = (SELECT AccountLocked FROM Users WHERE UserID = @user_id)
	

	UPDATE	
		Users
	SET	
		Prefix = @prefix,
		FirstName = @first_name,
		MiddleName = @middle_name,
		LastName = @last_name,
		Suffix = @suffix,
		AddressLine1 = @address_1,
		AddressLine2 = @address_2,
		City = @city,
		State = @state,
		Country = @country,
		ZipCode = @zip,
		WorkPhone = @work_phone,
		WorkPhoneExt = @work_phone_x,
		AlternativePhone = @alternative_phone,
		AlternativePhoneExt = @alternative_phone_x,
		EmailAddress = @EmailAddress,
		Notes = @notes,
		AccountLocked = @AccountLocked,
		ModifiedDate = GETDATE(),
		ModifiedUserID = @ModifiedUserID
	WHERE	UserID = @user_id
	
	--if unlocking, reset the lock counter
	IF (@AccountLocked = 0 AND @AccountLocked <> @OldAccountLocked)
	BEGIN
		UPDATE 
			Users
		SET 
			AccountLockCounter = 0
		WHERE
			UserID = @user_id
	END
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- PROCEDURE MODIFIER IS DELETABLE
--===========================================================================
CREATE PROCEDURE dbo.Shared_BusinessRule_DiagnosisIsDeletable --4597
	@diagnosis_id INT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @DatabaseName varchar(128)
	DECLARE @sql varchar(8000)
	DECLARE @NotFound bit
	SET @NotFound = 1
	
	--temp TABLE to hold the result FROM the search	
	CREATE TABLE #diagnosis_is_deletable(id int)

	DECLARE diagnosis_is_deletable_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.DatabaseName
			FROM dbo.Customer C
	
	OPEN diagnosis_is_deletable_cursor
	
	FETCH NEXT FROM diagnosis_is_deletable_cursor INTO @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			PRINT 'Processing for database: ' + @DatabaseName
			SET @sql = 'IF EXISTS (
							SELECT	*
							FROM	' + @DatabaseName + '.dbo.ENCOUNTERDIAGNOSIS EP
							INNER JOIN ' + @DatabaseName + '.dbo.DiagnosisCodeDictionary D
							ON D.KareoDiagnosisCodeDictionaryID = ' + CAST(@diagnosis_id AS varchar(10)) + '
							WHERE	EP.DiagnosisCodeDictionaryID = D.DiagnosisCodeDictionaryID
							)
							BEGIN
								INSERT #diagnosis_is_deletable VALUES(1)
							END'
	
			EXEC(@sql)
			
			SET @sql = 'IF EXISTS (
							SELECT	*
							FROM	' + @DatabaseName + '.dbo.DIAGNOSISCODEDICTIONARYTOCODINGTEMPLATE DC
							INNER JOIN ' + @DatabaseName + '.dbo.DiagnosisCodeDictionary D
							ON D.KareoDiagnosisCodeDictionaryID = ' + CAST(@diagnosis_id AS varchar(10)) + '
							WHERE	DC.DiagnosisCodeDictionaryID = D.DiagnosisCodeDictionaryID
							)
							BEGIN
								INSERT #diagnosis_is_deletable VALUES(1)
							END'
	
			EXEC(@sql)

			IF EXISTS(SELECT * FROM #diagnosis_is_deletable)
			BEGIN
				SET @NotFound = 0
				BREAK
			END
		END
		FETCH NEXT FROM diagnosis_is_deletable_cursor INTO @DatabaseName
	END
	CLOSE diagnosis_is_deletable_cursor
	DEALLOCATE diagnosis_is_deletable_cursor

	DROP TABLE #diagnosis_is_deletable
	
	SELECT @NotFound
	
	RETURN 
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
TEST

Shared_BusinessRule_ElectronicPayerConnectionIsDeletable 1 --Returns false
Shared_BusinessRule_ElectronicPayerConnectionIsDeletable 2 --Returns true

*/
--===========================================================================
-- IS ELECTRONIC PAYER CONNECTION DELETABLE
--===========================================================================
CREATE PROCEDURE dbo.Shared_BusinessRule_ElectronicPayerConnectionIsDeletable 
	@ConnID int
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @DatabaseName varchar(128)
	DECLARE @DatabaseServerName varchar(128)
	DECLARE @DatabasePath varchar(256)
	DECLARE @sql varchar(8000)
	DECLARE @NotFound bit
	SET @NotFound = 1
	
	--temp TABLE to hold the result FROM the search	
	CREATE TABLE #epc_is_deletable(id int)

	DECLARE epc_is_deletable_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.DatabaseServerName, C.DatabaseName
			FROM dbo.Customer C
			WHERE C.DBActive = 1

	OPEN epc_is_deletable_cursor
	
	FETCH NEXT FROM epc_is_deletable_cursor INTO @DatabaseServerName, @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			SET @DatabasePath = COALESCE(@DatabaseServerName + '.','') + COALESCE(@DatabaseName + '.','')
				PRINT 'Processing for database: ' + @DatabasePath

			--Not deletable if these are insurance plans associated.
			SET @sql = 'IF EXISTS (
						SELECT	*
						FROM ' + @DatabasePath + 'dbo.InsuranceCompanyPlan ICP
						WHERE ICP.ClearinghousePayerID = ' + CAST(@ConnID AS varchar(10)) + '
					      )
						BEGIN
							INSERT #epc_is_deletable VALUES(1)
						END'
	
			EXEC(@sql)

			IF EXISTS(SELECT * FROM #epc_is_deletable)
			BEGIN
				SET @NotFound = 0
				BREAK
			END
		END
		FETCH NEXT FROM epc_is_deletable_cursor INTO @DatabaseServerName, @DatabaseName
	END
	CLOSE epc_is_deletable_cursor
	DEALLOCATE epc_is_deletable_cursor

	DROP TABLE #epc_is_deletable
	
	SELECT @NotFound
	
	RETURN 
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
TEST

Shared_BusinessRule_InsurancePlanIsDeletable 1 --Returns true
Shared_BusinessRule_InsurancePlanIsDeletable 19736 --Returns false

*/
--===========================================================================
-- INSURANCECOMPANYPLAN IS DELETABLE
--===========================================================================
CREATE PROCEDURE dbo.Shared_BusinessRule_InsurancePlanIsDeletable 
	@InsuranceCompanyPlanID int
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @DatabaseName varchar(128)
	DECLARE @DatabaseServerName varchar(128)
	DECLARE @DatabasePath varchar(256)
	DECLARE @sql varchar(8000)
	DECLARE @NotFound bit
	SET @NotFound = 1
	
	--temp TABLE to hold the result FROM the search	
	CREATE TABLE #icp_is_deletable(id int)

	DECLARE icp_is_deletable_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.DatabaseServerName, C.DatabaseName
			FROM dbo.Customer C
			WHERE C.DBActive = 1

	OPEN icp_is_deletable_cursor
	
	FETCH NEXT FROM icp_is_deletable_cursor INTO @DatabaseServerName, @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			SET @DatabasePath = COALESCE(@DatabaseServerName + '.','') + COALESCE(@DatabaseName + '.','')
				PRINT 'Processing for database: ' + @DatabasePath

			SET @sql = 'IF EXISTS (
							SELECT	*
							FROM ' + @DatabasePath + 'dbo.PatientInsurance IP 
								INNER JOIN ' + @DatabasePath + 'dbo.InsuranceCompanyPlan ICP
								ON IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
							WHERE ICP.KareoInsuranceCompanyPlanID = ' + CAST(@InsuranceCompanyPlanID AS varchar(10)) + '
							)
							BEGIN
								INSERT #icp_is_deletable VALUES(1)
							END'
	
			EXEC(@sql)

			IF EXISTS(SELECT * FROM #icp_is_deletable)
			BEGIN
				SET @NotFound = 0
				BREAK
			END
			
			SET @sql = 'IF EXISTS (
							SELECT	*
							FROM ' + @DatabasePath + 'dbo.PracticeToInsuranceCompanyPlan PIP 
								INNER JOIN ' + @DatabasePath + 'dbo.InsuranceCompanyPlan ICP
								ON PIP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
							WHERE ICP.KareoInsuranceCompanyPlanID = ' + CAST(@InsuranceCompanyPlanID AS varchar(10)) + '
							)
							BEGIN
								INSERT #icp_is_deletable VALUES(1)
							END'
	
			EXEC(@sql)

			IF EXISTS(SELECT * FROM #icp_is_deletable)
			BEGIN
				SET @NotFound = 0
				BREAK
			END

			SET @sql = 'IF EXISTS (
							SELECT	*
							FROM ' + @DatabasePath + 'dbo.ProviderNumber PN 
								INNER JOIN ' + @DatabasePath + 'dbo.InsuranceCompanyPlan ICP
								ON PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
							WHERE ICP.KareoInsuranceCompanyPlanID = ' + CAST(@InsuranceCompanyPlanID AS varchar(10)) + '
							)
							BEGIN
								INSERT #icp_is_deletable VALUES(1)
							END'
	
			EXEC(@sql)

			SET @sql = 'IF EXISTS (
							SELECT	*
							FROM ' + @DatabasePath + 'dbo.PracticeInsuranceGroupNumber PIGN 
								INNER JOIN ' + @DatabasePath + 'dbo.InsuranceCompanyPlan ICP
								ON PIGN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
							WHERE ICP.KareoInsuranceCompanyPlanID = ' + CAST(@InsuranceCompanyPlanID AS varchar(10)) + '
							)
							BEGIN
								INSERT #icp_is_deletable VALUES(1)
							END'
	
			EXEC(@sql)

			IF EXISTS(SELECT * FROM #icp_is_deletable)
			BEGIN
				SET @NotFound = 0
				BREAK
			END
		END
		FETCH NEXT FROM icp_is_deletable_cursor INTO @DatabaseServerName, @DatabaseName
	END
	CLOSE icp_is_deletable_cursor
	DEALLOCATE icp_is_deletable_cursor

	DROP TABLE #icp_is_deletable
	
	SELECT @NotFound
	
	RETURN 
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- PROCEDURE IS DELETABLE
--===========================================================================
CREATE PROCEDURE dbo.Shared_BusinessRule_ProcedureIsDeletable 
	@procedure_id int
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @DatabaseName varchar(128)
	DECLARE @sql varchar(8000)
	DECLARE @NotFound bit
	SET @NotFound = 1
	
	--temp TABLE to hold the result FROM the search	
	CREATE TABLE #proc_is_deletable(id int)

	DECLARE proc_is_deletable_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.DatabaseName
			FROM dbo.Customer C
	
	OPEN proc_is_deletable_cursor
	
	FETCH NEXT FROM proc_is_deletable_cursor INTO @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			PRINT 'Processing for database: ' + @DatabaseName
			SET @sql = 'IF EXISTS (
							SELECT	*
							FROM ' + @DatabaseName + '.dbo.EncounterProcedure EP 
								INNER JOIN ' + @DatabaseName + '.dbo.ProcedureCodeDictionary PCD
								ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
							WHERE PCD.KareoProcedureCodeDictionaryID = ' + CAST(@procedure_id AS varchar(10)) + '
							)
							BEGIN
								INSERT #proc_is_deletable VALUES(1)
							END'
	
			EXEC(@sql)
			
			IF EXISTS(SELECT * FROM #proc_is_deletable)
			BEGIN
				SET @NotFound = 0
				BREAK
			END
		END
		FETCH NEXT FROM proc_is_deletable_cursor INTO @DatabaseName
	END
	CLOSE proc_is_deletable_cursor
	DEALLOCATE proc_is_deletable_cursor

	DROP TABLE #proc_is_deletable
	
	SELECT @NotFound
	
	RETURN 
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- PROCEDURE MODIFIER IS DELETABLE
--===========================================================================
CREATE PROCEDURE dbo.Shared_BusinessRule_ProcedureModifierIsDeletable
	@procedure_modifier_code varchar(16)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @DatabaseName varchar(128)
	DECLARE @sql varchar(8000)
	DECLARE @NotFound bit
	SET @NotFound = 1
	
	--temp TABLE to hold the result FROM the search	
	CREATE TABLE #proc_modifier_is_deletable(id int)

	DECLARE proc_modifier_is_deletable_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.DatabaseName
			FROM dbo.Customer C
	
	OPEN proc_modifier_is_deletable_cursor
	
	FETCH NEXT FROM proc_modifier_is_deletable_cursor INTO @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			PRINT 'Processing for database: ' + @DatabaseName
			SET @sql = 'IF EXISTS (
							SELECT	*
							FROM	' + @DatabaseName + '.dbo.EncounterProcedure EP
							INNER JOIN ' + @DatabaseName + '.dbo.ProcedureModifier PM
							ON PM.KareoProcedureModifierCode = ''' + @procedure_modifier_code + '''
							WHERE	EP.ProcedureModifier1 = PM.ProcedureModifierCode
							OR	EP.ProcedureModifier2 = PM.ProcedureModifierCode
							OR	EP.ProcedureModifier3 = PM.ProcedureModifierCode
							OR	EP.ProcedureModifier4 = PM.ProcedureModifierCode
							)
							BEGIN
								INSERT #proc_modifier_is_deletable VALUES(1)
							END'
	
			EXEC(@sql)
			
			IF EXISTS(SELECT * FROM #proc_modifier_is_deletable)
			BEGIN
				SET @NotFound = 0
				BREAK
			END
		END
		FETCH NEXT FROM proc_modifier_is_deletable_cursor INTO @DatabaseName
	END
	CLOSE proc_modifier_is_deletable_cursor
	DEALLOCATE proc_modifier_is_deletable_cursor

	DROP TABLE #proc_modifier_is_deletable
	
	SELECT @NotFound
	
	RETURN 
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
TEST

Shared_BusinessRule_UserIsDeletable 1 --Returns FALSE
Shared_BusinessRule_UserIsDeletable 197 --Returns TRUE

*/
--===========================================================================
-- USER IS DELETABLE
--===========================================================================
CREATE PROCEDURE dbo.Shared_BusinessRule_UserIsDeletable 
	@UserID int, 
	@CustomerID int = null
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @DatabaseName varchar(128)
	DECLARE @DatabaseServerName varchar(128)
	DECLARE @DatabasePath varchar(256)
	DECLARE @sql varchar(8000)
	DECLARE @VAL varchar(40)
	SET @VAL = @UserID

	DECLARE @sql_outside varchar(8000)
	CREATE TABLE #tx(id int)

	DECLARE @NotFound bit
	SET @NotFound = 1

	DECLARE user_is_deletable_cursor CURSOR
	READ_ONLY
	FOR 	
			SELECT CAST('' AS varchar(128)) AS DatabaseServerName,
				CAST('superbill_shared' AS varchar(128)) AS DatabaseName
			UNION
			SELECT DISTINCT C.DatabaseServerName, C.DatabaseName
			FROM dbo.Customer C
			WHERE C.DBActive = 1
			AND (C.CustomerID = @CustomerID or @CustomerID is null)

	OPEN user_is_deletable_cursor
	
	FETCH NEXT FROM user_is_deletable_cursor INTO @DatabaseServerName, @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			SET @DatabasePath = COALESCE(@DatabaseServerName + '.','') + COALESCE(@DatabaseName + '.','')
			PRINT 'Processing for database: ' + @DatabasePath

			SET @sql_outside = 
			'DECLARE @sql varchar(8000)
			DECLARE @TBL varchar(128)
			DECLARE @COL varchar(128)
			DECLARE col_search_cursor CURSOR
			READ_ONLY
			FOR SELECT ''['' + C.TABLE_NAME + '']'' AS TBL,
				''['' + C.COLUMN_NAME + '']'' AS COL
			FROM ' + @DatabasePath + 'Information_Schema.Columns C
			WHERE C.COLUMN_NAME LIKE ''%UserID%''
			AND C.TABLE_NAME NOT IN (''CustomerUsers'', ''Users'', ''UserPassword'', ''UsersSecurityGroup'') 
			ORDER BY C.TABLE_NAME, C.COLUMN_NAME
			
			OPEN col_search_cursor
			
			FETCH NEXT FROM col_search_cursor INTO @TBL, @COL
			WHILE (@@fetch_status <> -1)
			BEGIN
				IF (@@fetch_status <> -2)
				BEGIN
					SET @sql = ''IF EXISTS(SELECT * FROM ' + @DatabasePath + 'dbo.'' + @TBL + '' WHERE '' + @COL  + '' = '' + CAST(' + @VAL + ' AS varchar(40))
					SET @sql = @sql + '') BEGIN ''
					SET @sql = @sql + '' INSERT INTO #tx(id) VALUES(1) '' + CHAR(13) + CHAR(10)
					SET @sql = @sql + '' END ''
					SET NOCOUNT ON
					EXEC( @sql)
					
					IF EXISTS(SELECT * FROM #tx)
					BEGIN
						PRINT ''FOUND IN '' + @TBL + ''.'' + @COL
						BREAK
					END						
						
					DELETE #tx
				END
				FETCH NEXT FROM col_search_cursor INTO @TBL, @COL
			END
			
			CLOSE col_search_cursor
			DEALLOCATE col_search_cursor'
			
			--PRINT LEN(@sql_outside)
			
			EXEC(@sql_outside)
			
			IF EXISTS(SELECT * FROM #tx)
			BEGIN
				PRINT 'FOUND'
				SET @NotFound = 0
				BREAK
			END
			ELSE
				PRINT 'NOT FOUND'
		END
		FETCH NEXT FROM user_is_deletable_cursor INTO @DatabaseServerName, @DatabaseName
	END
	CLOSE user_is_deletable_cursor
	DEALLOCATE user_is_deletable_cursor

	DROP TABLE #tx
	
	SELECT @NotFound
	
	RETURN 
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomer
	@CompanyName varchar(128), 
	@AddressLine1 varchar(256),
	@AddressLine2 varchar(256),
	@City varchar(128), 
	@State varchar(2), 
	@ZipCode varchar(9), 
	@NumOfEmployeesID int, 
	@NumOfUsersID int, 
	@NumOfPhysiciansID int, 
	@AnnualCompanyRevenueID int, 
	@ContactPrefix varchar(16), 
	@ContactFirstName varchar(64), 
	@ContactMiddleName varchar(64), 
	@ContactLastName varchar(64), 
	@ContactSuffix varchar(16), 
	@ContactTitle varchar(65), 
	@ContactPhone varchar(10), 
	@ContactPhoneExt varchar(10), 
	@ContactEmail varchar(128), 
	@MarketingSourceID int, 
	@CustomerType char(1), 
	@AccountLocked bit, 
	@DatabaseServerName varchar(50), 
	@DatabaseName varchar(50), 
	@DatabaseUsername varchar(50), 
	@DatabasePassword varchar(50), 
	@Notes text, 
	@Comments text, 
	@ModifiedUserID int
AS
BEGIN

	INSERT
		Customer 
		(CompanyName, 
		AddressLine1,
		AddressLine2,
		City, 
		State, 
		Zip, 
		NumOfEmployeesID, 
		NumOfUsersID, 
		NumOfPhysiciansID, 
		AnnualCompanyRevenueID, 
		ContactPrefix, 
		ContactFirstName, 
		ContactMiddleName, 
		ContactLastName, 
		ContactSuffix, 
		ContactTitle, 
		ContactPhone, 
		ContactPhoneExt, 
		ContactEmail, 
		MarketingSourceID, 
		CustomerType, 
		AccountLocked, 
		DatabaseServerName, 
		DatabaseName, 
		DatabaseUsername, 
		DatabasePassword, 
		Notes, 
		Comments, 
		CreatedDate, 
		CreatedUserID, 
		ModifiedUserID)
	VALUES
		(@CompanyName, 
		@AddressLine1,
		@AddressLine2,
		@City, 
		@State, 
		@ZipCode, 
		@NumOfEmployeesID, 
		@NumOfUsersID, 
		@NumOfPhysiciansID, 
		@AnnualCompanyRevenueID, 
		@ContactPrefix, 
		@ContactFirstName, 
		@ContactMiddleName, 
		@ContactLastName, 
		@ContactSuffix, 
		@ContactTitle, 
		@ContactPhone, 
		@ContactPhoneExt, 
		@ContactEmail, 
		@MarketingSourceID, 
		@CustomerType, 
		@AccountLocked, 
		@DatabaseServerName, 
		@DatabaseName, 
		@DatabaseUsername, 
		@DatabasePassword, 
		@Notes, 
		@Comments, 
		getdate(), 
		@ModifiedUserID, 
		@ModifiedUserID)

	RETURN SCOPE_IDENTITY()

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_DeleteCustomer
	@CustomerID INT
AS
BEGIN
	DELETE
		Customer
	WHERE	CustomerID = @CustomerID

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetAnnualCompanyRevenue
AS
BEGIN
	SELECT * 
	FROM dbo.DemographicAnnualCompanyRevenue D
	ORDER BY D.AnnualCompanyRevenueID

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerDatabases
AS
BEGIN

	SELECT
		CustomerID,
		DatabaseServerName,
		DatabaseName,
		DatabaseUsername,
		DatabasePassword
	FROM
		Customer
	WHERE
		DBActive = 1
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerDetail
	@CustomerID int
AS
BEGIN

	SELECT
		CustomerID,
		CompanyName, 
		AddressLine1,
		AddressLine2,
		City, 
		State, 
		Zip, 
		NumOfEmployeesID, 
		NumOfUsersID, 
		NumOfPhysiciansID, 
		AnnualCompanyRevenueID, 
		ContactPrefix, 
		ContactFirstName, 
		ContactMiddleName, 
		ContactLastName, 
		ContactSuffix, 
		ContactTitle, 
		ContactPhone, 
		ContactPhoneExt, 
		ContactEmail, 
		MarketingSourceID, 
		CustomerType, 
		AccountLocked, 
		DatabaseServerName, 
		DatabaseName, 
		DatabaseUsername, 
		DatabasePassword, 
		Notes, 
		CreatedDate, 
		Comments
	FROM
		Customer
	WHERE
		CustomerID = @CustomerID
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET List of customers
--===========================================================================
CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerList
AS
BEGIN
	SELECT C.CustomerID, C.CompanyName, CAST('default' AS varchar(128)) AS ServerName, CAST('default' AS varchar(128)) AS DBName 
	FROM dbo.Customer C

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomers
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

	CREATE TABLE #t_customer(
		CustomerID int,
		CompanyName varchar(128), 
		AddressLine1 varchar(256),
		AddressLine2 varchar(256),
		City varchar(128), 
		State varchar(2), 
		ZipCode varchar(9), 
		NumOfEmployeesID int, 
		NumOfUsersID int, 
		NumOfPhysiciansID int, 
		AnnualCompanyRevenueID int, 
		ContactPrefix varchar(16), 
		ContactFirstName varchar(64), 
		ContactMiddleName varchar(64), 
		ContactLastName varchar(64), 
		ContactSuffix varchar(16), 
		ContactTitle varchar(65), 
		ContactPhone varchar(10), 
		ContactPhoneExt varchar(10), 
		ContactEmail varchar(128), 
		MarketingSourceID int, 
		CustomerType varchar(16), 
		AccountLocked bit, 
		DatabaseServerName varchar(50), 
		DatabaseName varchar(50), 
		DatabaseUsername varchar(50), 
		DatabasePassword varchar(50), 
		Notes text, 
		CreatedDate datetime, 
		Comments text, 
		Deletable bit, 
		RID int IDENTITY(0,1)
	)

	--Main Query
	INSERT
	INTO #t_customer(
		CustomerID,
		CompanyName, 
		AddressLine1,
		AddressLine2,
		City, 
		State, 
		ZipCode, 
		NumOfEmployeesID, 
		NumOfUsersID, 
		NumOfPhysiciansID, 
		AnnualCompanyRevenueID, 
		ContactPrefix, 
		ContactFirstName, 
		ContactMiddleName, 
		ContactLastName, 
		ContactSuffix, 
		ContactTitle, 
		ContactPhone, 
		ContactPhoneExt, 
		ContactEmail, 
		MarketingSourceID, 
		CustomerType, 
		AccountLocked, 
		DatabaseServerName, 
		DatabaseName, 
		DatabaseUsername, 
		DatabasePassword, 
		Notes, 
		CreatedDate, 
		Comments,
		Deletable 
	)
	SELECT
		CustomerID,
		CompanyName, 
		AddressLine1,
		AddressLine2,
		City, 
		State, 
		Zip, 
		NumOfEmployeesID, 
		NumOfUsersID, 
		NumOfPhysiciansID, 
		AnnualCompanyRevenueID, 
		ContactPrefix, 
		ContactFirstName, 
		ContactMiddleName, 
		ContactLastName, 
		ContactSuffix, 
		ContactTitle, 
		ContactPhone, 
		ContactPhoneExt, 
		ContactEmail, 
		MarketingSourceID, 
		case CustomerType
			when 'T' then 'Trial'
			when 'N' then 'Normal'
		end as CustomerType,  
		AccountLocked, 
		DatabaseServerName, 
		DatabaseName, 
		DatabaseUsername, 
		DatabasePassword, 
		Notes, 
		CreatedDate, 
		Comments,
		CAST(1 AS BIT) as Deletable	-- update this when we can tell if this is deletable
	FROM
		Customer
	WHERE
		((@query_domain IS NULL OR @query IS NULL)
		OR	((@query_domain = 'ID' OR @query_domain = 'All')
			AND CAST(CustomerID AS VARCHAR(50)) LIKE '%' + @query + '%')
		OR	((@query_domain = 'CompanyName' OR @query_domain = 'All')
			AND CompanyName LIKE '%' + @query + '%')
		OR	((@query_domain = 'Address' 
				OR @query_domain = 'All')
			AND	(AddressLine1 LIKE '%' + @query + '%'
				OR AddressLine2 LIKE '%' + @query + '%'
				OR City LIKE '%' + @query + '%'
				OR State LIKE '%' + @query + '%'
				OR Zip LIKE '%' + @query + '%')
		OR	((@query_domain = 'ContactName' OR @query_domain = 'All')
			AND (ContactFirstName LIKE '%' + @query + '%' OR ContactLastName LIKE '%' + @query + '%'))
		OR	((@query_domain = 'ContactName' OR @query_domain = 'All')
			AND 	(ContactFirstName LIKE '%' + @query + '%' 
				OR ContactLastName LIKE '%' + @query + '%'
				OR (ContactFirstName + ContactLastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
				OR (ContactLastName + ContactFirstName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'))
		OR 	((@query_domain = 'ContactPhone'
				OR @query_domain = 'All')
				AND (ContactPhone LIKE '%' + @query + '%'
				OR  ContactPhoneExt LIKE '%' + @query + '%'))
		OR 	((@query_domain = 'Type'
				OR @query_domain = 'All')
				AND  (case CustomerType when 'T' then 'Trial' when 'N' then 'Normal' end LIKE '%' + @query + '%'))
		OR 	((@query_domain = 'ContactEmail'
				OR @query_domain = 'All')
				AND (ContactEmail LIKE '%' + @query + '%'))
		))
/*	WHERE
		A.PracticeID = @practice_id
		-- This is to limit by the start and end dates.
		AND ((A.StartDate >= @start_date OR @start_date IS NULL)
		AND (A.EndDate <= @end_date OR @end_date IS NULL)
		OR  (A.StartDate <= @start_date AND A.EndDate >= @start_date AND A.EndDate <= @end_date)-- gets appointments starting in previous day
		OR  (A.StartDate <= @end_date AND A.EndDate >= @end_date)) 				-- gets appointments starting in previous day
		AND ((@ResourceFound = 1 AND not ATR.AppointmentID is null)
		OR   @ResourceFound = 0)
		AND 
		(
			(@query_domain IS NULL OR @query IS NULL OR @ResourceFound = 1)
			OR (
				(@query_domain = 'Patient' OR @query_domain = 'All')
				AND (
					P.FirstName LIKE '%' + @query + '%' 
					OR P.LastName LIKE '%' + @query + '%'
					OR P.MiddleName LIKE '%' + @query + '%' 
					OR P.Prefix LIKE '%' + @query + '%' 
					OR P.Suffix LIKE '%' + @query + '%' 
				        OR (P.FirstName + P.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
					OR (P.LastName + P.FirstName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
				        OR (P.FirstName + P.MiddleName + P.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
				)
			)
			OR (
				(@query_domain = 'Subject' OR @query_domain = 'All')
				AND (
					A.Subject LIKE '%' + @query + '%'
				)
			)
			OR (
				(@query_domain = 'Location' OR @query_domain = 'All')
				AND (
					SL.Name LIKE '%' + @query + '%'
				)
			)
			OR (
				(@query_domain = 'Notes' OR @query_domain = 'All')
				AND (
					A.Notes LIKE '%' + @query + '%'
				)
			)
			OR (
				(@query_domain = 'Reason' OR @query_domain = 'All')
				AND (
					AR.Name LIKE '%' + @query + '%'
				)
			)
		)
*/	ORDER BY
		CompanyName

	SELECT @totalRecords = COUNT(*)
	FROM #t_customer

	SELECT * 
	FROM #t_customer
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_customer
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetMarketingSource
AS
BEGIN
	SELECT * 
	FROM dbo.DemographicMarketingSource D
	ORDER BY D.MarketingSourceID

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetNumOfEmployees
AS
BEGIN
	SELECT * 
	FROM dbo.DemographicNumOfEmployees D
	ORDER BY D.NumOfEmployeesID

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetNumOfPhysicians
AS
BEGIN
	SELECT * 
	FROM dbo.DemographicNumOfPhysicians D
	ORDER BY D.NumOfPhysiciansID

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetNumOfUsers
AS
BEGIN
	SELECT * 
	FROM dbo.DemographicNumOfUsers D
	ORDER BY D.NumOfUsersID

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_UpdateCustomer
	@CustomerID int, 
	@CompanyName varchar(128), 
	@AddressLine1 varchar(256),
	@AddressLine2 varchar(256),
	@City varchar(128), 
	@State varchar(2), 
	@ZipCode varchar(9), 
	@NumOfEmployeesID int, 
	@NumOfUsersID int, 
	@NumOfPhysiciansID int, 
	@AnnualCompanyRevenueID int, 
	@ContactPrefix varchar(16), 
	@ContactFirstName varchar(64), 
	@ContactMiddleName varchar(64), 
	@ContactLastName varchar(64), 
	@ContactSuffix varchar(16), 
	@ContactTitle varchar(65), 
	@ContactPhone varchar(10), 
	@ContactPhoneExt varchar(10), 
	@ContactEmail varchar(128), 
	@MarketingSourceID int, 
	@CustomerType char(1), 
	@AccountLocked bit, 
	@DatabaseServerName varchar(50), 
	@DatabaseName varchar(50), 
	@DatabaseUsername varchar(50), 
	@DatabasePassword varchar(50), 
	@Notes text, 
	@Comments text,
	@ModifiedUserID int
AS
BEGIN

	UPDATE 
		Customer
	SET
		CompanyName = @CompanyName, 
		AddressLine1 = @AddressLine1,
		AddressLine2 = @AddressLine2,
		City = @City, 
		State = @State, 
		Zip = @ZipCode, 
		NumOfEmployeesID = @NumOfEmployeesID, 
		NumOfUsersID = @NumOfUsersID, 
		NumOfPhysiciansID = @NumOfPhysiciansID, 
		AnnualCompanyRevenueID = @AnnualCompanyRevenueID, 
		ContactPrefix = @ContactPrefix, 
		ContactFirstName = @ContactFirstName, 
		ContactMiddleName = @ContactMiddleName, 
		ContactLastName = @ContactLastName, 
		ContactSuffix = @ContactSuffix, 
		ContactTitle = @ContactTitle, 
		ContactPhone = @ContactPhone, 
		ContactPhoneExt = @ContactPhoneExt, 
		ContactEmail = @ContactEmail, 
		MarketingSourceID = @MarketingSourceID, 
		CustomerType = @CustomerType, 
		AccountLocked = @AccountLocked, 
		DatabaseServerName = @DatabaseServerName, 
		DatabaseName = @DatabaseName, 
		DatabaseUsername = @DatabaseUsername, 
		DatabasePassword = @DatabasePassword, 
		ModifiedDate = GETDATE(),
		ModifiedUserID = @ModifiedUserID,
		Notes = @Notes, 
		Comments = @Comments
    	WHERE
    		CustomerID = @CustomerID

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- CREATE DIAGNOSIS
--===========================================================================
CREATE PROCEDURE dbo.Shared_DiagnosisDataProvider_CreateDiagnosis
	@code VARCHAR(16),
	@name VARCHAR(32),
	@description VARCHAR(64)
AS
BEGIN
	INSERT	dbo.DiagnosisCodeDictionary (
		DiagnosisCode,
		DiagnosisName,
		Description)
	VALUES	(
		@code,
		@name,
		@description)

	RETURN SCOPE_IDENTITY()
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- DELETE DIAGNOSIS
--===========================================================================
CREATE PROCEDURE dbo.Shared_DiagnosisDataProvider_DeleteDiagnosis
	@diagnosis_id INT
AS
BEGIN
/*	--Delete template associations.
	DELETE	dbo.DiagnosisCodeDictionaryToCodingTemplate
	WHERE	DiagnosisCodeDictionaryID = @diagnosis_id
*/
	--Delete diagnosis.
	DELETE	dbo.DiagnosisCodeDictionary
	WHERE	DiagnosisCodeDictionaryID = @diagnosis_id
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET DIAGNOSES
--===========================================================================
CREATE PROCEDURE dbo.Shared_DiagnosisDataProvider_GetDiagnoses
	@template_id INT = NULL,
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@template_id = 0)
		SET @template_id = NULL

	CREATE TABLE #t_diagnosis(
		DiagnosisCodeDictionaryID int, 
		DiagnosisCode varchar(16), 
		DiagnosisName varchar(100), 
		RID int IDENTITY(0,1)
	)
		
	INSERT #t_diagnosis(
		DiagnosisCodeDictionaryID,
		DiagnosisCode,
		DiagnosisName
	)
	SELECT	DiagnosisCodeDictionaryID,
		DiagnosisCode,
		DiagnosisName
	FROM	dbo.DiagnosisCodeDictionary
	WHERE	(	(@query_domain IS NULL OR @query IS NULL)
		OR	((@query_domain = 'DiagnosisCode' OR @query_domain = 'All')
			  AND (DiagnosisCode LIKE '%' + @query + '%'))
		OR	((@query_domain = 'DiagnosisName' OR @query_domain = 'All')
			  AND (DiagnosisName LIKE '%' + @query + '%'))
		)
/*	AND	(@template_id IS NULL
		OR DiagnosisCodeDictionaryID IN (
			SELECT	TCDT.DiagnosisCodeDictionaryID
			FROM	DiagnosisCodeDictionaryToCodingTemplate TCDT
			WHERE	TCDT.CodingTemplateID = @template_id))*/
	ORDER BY DiagnosisCode
	
	--Get the count and clean up
	SELECT @totalRecords = COUNT(*)
	FROM #t_diagnosis
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
			
	SELECT *
	FROM #t_diagnosis
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_diagnosis
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET DIAGNOSIS
--===========================================================================
CREATE PROCEDURE dbo.Shared_DiagnosisDataProvider_GetDiagnosis
	@diagnosis_id INT
AS
BEGIN
	SELECT	DiagnosisCodeDictionaryID,
		DiagnosisCode,
		DiagnosisName,
		Description
	FROM	dbo.DiagnosisCodeDictionary
	WHERE	DiagnosisCodeDictionaryID = @diagnosis_id
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- UPDATE DIAGNOSIS
--===========================================================================
CREATE PROCEDURE dbo.Shared_DiagnosisDataProvider_UpdateDiagnosis
	@diagnosis_id INT,
	@code VARCHAR(16),
	@name VARCHAR(32),
	@description VARCHAR(64)
AS
BEGIN
	UPDATE	dbo.DiagnosisCodeDictionary
	SET	DiagnosisName = @name,
		DiagnosisCode = @code,
		Description = @description,
		ModifiedDate = GETDATE()
	WHERE	DiagnosisCodeDictionaryID = @diagnosis_id
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET COUNTRIES
--===========================================================================
CREATE PROCEDURE dbo.Shared_GeneralDataProvider_GetCountries
AS
BEGIN	
	SELECT	ShortName AS Code,
		Country AS LongName
	FROM	Country
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET GROUP NUMBER TYPES
--===========================================================================
CREATE PROCEDURE dbo.Shared_GeneralDataProvider_GetGroupNumberTypes
AS
BEGIN
	SELECT	
		GroupNumberTypeID AS TypeID,
		TypeName
	FROM	
		GroupNumberType
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET HCFA DIAGNOSIS REFERENCE FORMATS
--===========================================================================
CREATE PROCEDURE dbo.Shared_GeneralDataProvider_GetHCFADiagnosisReferenceFormats
AS
BEGIN
	SELECT	HCFADiagnosisReferenceFormatCode AS Code,
		FormatName AS Description
	FROM	HCFADiagnosisReferenceFormat
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET HCFA SAME AS INSURED FORMATS
--===========================================================================
CREATE PROCEDURE dbo.Shared_GeneralDataProvider_GetHCFASameAsInsuredFormats
AS
BEGIN
	SELECT	HCFASameAsInsuredFormatCode AS Code,
		FormatName AS Description
	FROM	HCFASameAsInsuredFormat
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET PROVIDER NUMBER TYPES
--===========================================================================
CREATE PROCEDURE dbo.Shared_GeneralDataProvider_GetProviderNumberTypes
AS
BEGIN
	SELECT	
		ProviderNumberTypeID AS TypeID,
		TypeName
	FROM	
		ProviderNumberType
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET StateS
--===========================================================================
CREATE PROCEDURE dbo.Shared_GeneralDataProvider_GetStates
AS
BEGIN
	SELECT	State AS Code,
		LongName AS LongName
	FROM	State
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET TYPES OF SERVICE
--===========================================================================
CREATE PROCEDURE dbo.Shared_GeneralDataProvider_GetTypesOfService
AS
BEGIN
	SELECT	TypeOfServiceCode AS Code,
		Description
	FROM	TYPEOFSERVICE
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET USER
--===========================================================================
CREATE PROCEDURE dbo.Shared_Handheld_AuthenticationDataProvider_GetUserForUsername
	@Username varchar(128)
AS
BEGIN
	DECLARE @CustomerCount int
	DECLARE @CustomerID int
		
	SELECT @CustomerCount = COUNT(*)
	FROM dbo.CustomerUsers CU
		INNER JOIN dbo.Users U
		ON CU.UserID = U.UserID
	WHERE U.EmailAddress = @Username
	
	/*
		if user belongs to no customers, 
			CustomerID = 0
		
		if user belongs to exactly one customer
			CustomerID is the ID of that customer
		
		if user belongs to more than one customer
			CustomerID is first customer id
	*/
	
	IF @CustomerCount = 1
	BEGIN
		SELECT @CustomerID = CustomerID
		FROM dbo.CustomerUsers CU
			INNER JOIN dbo.Users U
			ON CU.UserID = U.UserID
		WHERE U.EmailAddress = @Username
	END
	ELSE IF @CustomerCount = 0
		SET @CustomerID = 0
	ELSE IF @CustomerCount > 1
	BEGIN
		SELECT top 1 @CustomerID = CustomerID
		FROM dbo.CustomerUsers CU
			INNER JOIN dbo.Users U
			ON CU.UserID = U.UserID
		WHERE U.EmailAddress = @Username
	END
	
	SELECT	UserID,
		Prefix,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		AddressLine1,
		AddressLine2,
		City,
		State,
		Country,
		ZipCode,
		WorkPhone,
		WorkPhoneExt,
		AlternativePhone,
		AlternativePhoneExt,
		EmailAddress,
		Notes,
		AccountLocked,
		@CustomerID AS CustomerID	
	FROM	dbo.Users U
	WHERE	U.EmailAddress = @Username
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- CREATE CLEARINGHOUSE PAYER
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_CreateClearinghousePayer
	@ClearinghouseID INT,
	@PayerNumber VARCHAR(32),
	@Name VARCHAR(1000),
	@Notes VARCHAR(1000) = NULL,
	@StateSpecific VARCHAR(16) = NULL,
	@PayerType INT = 0,
	@IsParticipating BIT = 0,
	@IsProviderIdRequired BIT = 0,
	@IsEnrollmentRequired BIT = 0,
	@IsAuthorizationRequired BIT = 0,
	@IsTestRequired BIT = 0,
	@ResponseLevel INT = NULL,
	@IsNewPayer BIT = 0,
	@DateNewPayerSince DATETIME = NULL,
	@Active INT = 1
AS
BEGIN
	DECLARE @ClearinghousePayerID INT

	INSERT ClearinghousePayersList
	(
		ClearinghouseID,
		PayerNumber,
		[Name],
		Notes,
		StateSpecific,
		IsGovernment,
		IsCommercial,
		IsParticipating,
		IsProviderIdRequired,
		IsEnrollmentRequired,
		IsAuthorizationRequired,
		IsTestRequired,
		ResponseLevel,
		IsNewPayer,
		DateNewPayerSince,
		Active,
		ModifiedDate
	)
	VALUES	(
		@ClearinghouseID,
		@PayerNumber,
		@Name,
		@Notes,
		@StateSpecific,
		CAST((CASE (@PayerType) WHEN 1 THEN 1 ELSE  0 END) AS BIT),
		CAST((CASE (@PayerType) WHEN 2 THEN 1 ELSE  0 END) AS BIT),
		@IsParticipating,
		@IsProviderIdRequired,
		@IsEnrollmentRequired,
		@IsAuthorizationRequired,
		@IsTestRequired,
		@ResponseLevel,
		@IsNewPayer,
		@DateNewPayerSince,
		@Active,
		GETDATE()
	)

	SET @ClearinghousePayerID = SCOPE_IDENTITY()

	RETURN @ClearinghousePayerID 
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- CREATE INSURANCE PLAN
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_CreateInsurancePlan
	@name VARCHAR(64),
	@street_1 VARCHAR(64),
	@street_2 VARCHAR(64),
	@city VARCHAR(32),
	@state CHAR(2),
	@country VARCHAR(32),
	@zip VARCHAR(9),
	@contact_prefix VARCHAR(16),
	@contact_first_name VARCHAR(32),
	@contact_middle_name VARCHAR(32),
	@contact_last_name VARCHAR(32),
	@contact_suffix VARCHAR(16),
	@phone VARCHAR(10),
	@phone_x VARCHAR(10),
	@fax VARCHAR(10),
	@fax_x VARCHAR(10),
	@copay_flag BIT,
	@program_code CHAR(1) = 'O',
	@provider_number_type_id INT = NULL,
	@group_number_type_id INT = NULL,
	@local_use_provider_number_type_id INT = NULL,
	@hcfa_diag_code CHAR(1) = 'C',
	@hcfa_same_code CHAR(1) = 'D',
	@review_code CHAR(1) = '',
	@EClaimsAccepts BIT = 0,
	@ClearinghousePayerID INT = NULL,
	@notes TEXT,
	@eclaims_enrollment_status_id INT = NULL,
	@eclaims_disable BIT = NULL
AS
BEGIN
	DECLARE @plan_id INT

	INSERT	INSURANCECOMPANYPLAN (
		PlanName,
		AddressLine1,
		AddressLine2,
		City,
		State,
		Country,
		ZipCode,
		ContactPrefix,
		ContactFirstName,
		ContactMiddleName,
		ContactLastName,
		ContactSuffix,
		Phone,
		PhoneExt,
		Fax,
		FaxExt,
		CoPay,
		InsuranceProgramCode,
		ProviderNumberTypeID,
		GroupNumberTypeID,
		LocalUseProviderNumberTypeID,
		HCFADiagnosisReferenceFormatCode,
		HCFASameAsInsuredFormatCode,
		ReviewCode,
		EClaimsAccepts,
		ClearinghousePayerID,
		Notes)
	VALUES	(
		@name,
		@street_1,
		@street_2,
		@city,
		@state,
		@country,
		@zip,
		@contact_prefix,
		@contact_first_name,
		@contact_middle_name,
		@contact_last_name,
		@contact_suffix,
		@phone,
		@phone_x,
		@fax,
		@fax_x,
		@copay_flag,
		@program_code,
		@provider_number_type_id,
		@group_number_type_id,
		@local_use_provider_number_type_id,
		@hcfa_diag_code,
		@hcfa_same_code,
		@review_code,
		@EClaimsAccepts,
		@ClearinghousePayerID,
		@notes)

	SET @plan_id = SCOPE_IDENTITY()

	DECLARE @EClaimsRequiresEnrollment BIT

	SELECT @EClaimsRequiresEnrollment = CPL.IsEnrollmentRequired
	FROM	dbo.InsuranceCompanyPlan IP
		LEFT OUTER JOIN dbo.ClearinghousePayersList CPL
		  ON IP.ClearinghousePayerID = CPL.ClearinghousePayerID
	WHERE IP.InsuranceCompanyPlanID = @plan_id

	RETURN @plan_id 
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- DELETE CLEARINGHOUSE PAYER
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_DeleteClearinghousePayer
	@ClearinghousePayerID INT
AS
BEGIN
	--Delete the payer.
	DELETE	ClearinghousePayersList
	WHERE	ClearinghousePayerID = @ClearinghousePayerId
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- DELETE INSURANCE PLAN
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_DeleteInsurancePlan
	@plan_id INT
AS
BEGIN
	--Delete the plan.
	DELETE	dbo.InsuranceCompanyPlan
	WHERE	InsuranceCompanyPlanID = @plan_id
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET CLEARINGHOUSE PAYER
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_GetClearinghousePayer
	@ClearinghousePayerId INT
AS
BEGIN
	SELECT	CAST(CPL.ClearinghousePayerID AS INT) AS ClearinghousePayerID,      -- loose the identity
		CPL.ClearinghouseID,
		'ProxyMed' AS ClearinghouseName,
		CPL.PayerNumber,
		CPL.[Name],
		CPL.Notes,
		CPL.StateSpecific,
		CAST((CASE (CPL.IsGovernment) WHEN 1 THEN 1 ELSE (CASE (CPL.IsCommercial) WHEN 1 THEN 2 ELSE 0 END) END) AS INT) AS PayerType,
		CPL.IsParticipating,
		CPL.IsProviderIdRequired,
		CPL.IsEnrollmentRequired,
		CPL.IsAuthorizationRequired,
		CPL.IsTestRequired,
		CPL.ResponseLevel,
		CPL.IsNewPayer,
		CPL.DateNewPayerSince,
		CPL.ModifiedDate,
		CPL.Active
	INTO 
		#t_ClearinghousePayer
	FROM	ClearinghousePayersList CPL
	WHERE	CPL.ClearinghousePayerID = @ClearinghousePayerId
	
	SELECT *
	FROM #t_ClearinghousePayer
	
	DROP TABLE #t_ClearinghousePayer
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET Clearinghouse Payers
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_GetClearinghousePayers
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

	SELECT	CAST(CPL.ClearinghousePayerID AS INT) AS ClearinghousePayerID,      -- loose the identity
		CPL.[Name],
		CPL.PayerNumber,
		CPL.Notes,
		'ProxyMed' AS Clearinghouse,
		(CASE (CPL.IsEnrollmentRequired)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS IsEnrollmentRequired,
		(CASE (CPL.IsAuthorizationRequired)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS IsAuthorizationRequired,
		(CASE (CPL.IsProviderIdRequired)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS IsProviderIdRequired,
		(CASE (CPL.IsTestRequired)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS IsTestRequired,
		(CASE (CPL.IsParticipating)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS IsParticipating,
		CPL.StateSpecific,
		COALESCE((CASE (CPL.IsGovernment) WHEN 1 THEN 'Government ' ELSE '' END), '')
			+ COALESCE((CASE (CPL.IsCommercial) WHEN 1 THEN 'Comm ' ELSE '' END), '')
			AS PayerType,
		CPL.ResponseLevel,
		IDENTITY(int, 0, 1) as RID
	INTO 
		#t_ClearinghousePayers
	FROM	
		dbo.ClearinghousePayersList CPL
	WHERE
		(	(@query_domain IS NULL OR @query IS NULL)
			OR	((@query_domain = 'ClearinghousePayerID' OR @query_domain = 'All')
				AND CAST(CPL.ClearinghousePayerID AS VARCHAR(50)) LIKE '%' + @query + '%')
			OR	((@query_domain = 'Name' OR @query_domain = 'All')
				AND CPL.[Name] LIKE '%' + @query + '%')
			OR	((@query_domain = 'PayerNumber' OR @query_domain = 'All')
				AND CPL.PayerNumber LIKE '%' + @query + '%')
			OR	((@query_domain = 'Clearinghouse' OR @query_domain = 'All')
				AND 'ProxyMed' LIKE '%' + @query + '%')
			OR	((@query_domain = 'StateSpecific' OR @query_domain = 'All')
				AND CPL.StateSpecific LIKE '%' + @query + '%')
			OR	((@query_domain = 'IsEnrollmentRequired' OR @query_domain = 'All')
				AND ((CPL.IsEnrollmentRequired = 1 AND (@query = 'yes' OR @query = '')) OR (CPL.IsEnrollmentRequired = 0 AND @query = 'no')))
			OR	((@query_domain = 'IsProviderIdRequired' OR @query_domain = 'All')
				AND ((CPL.IsProviderIdRequired = 1 AND (@query = 'yes' OR @query = '')) OR (CPL.IsProviderIdRequired = 0 AND @query = 'no')))
			OR	((@query_domain = 'IsTestRequired' OR @query_domain = 'All')
				AND ((CPL.IsTestRequired = 1 AND (@query = 'yes' OR @query = '')) OR (CPL.IsTestRequired = 0 AND @query = 'no')))
			OR	((@query_domain = 'IsParticipating' OR @query_domain = 'All')
				AND ((CPL.IsParticipating = 1 AND (@query = 'yes' OR @query = '')) OR (CPL.IsParticipating = 0 AND @query = 'no')))
			OR	((@query_domain = 'PayerType' OR @query_domain = 'All')
				AND ((CPL.IsGovernment = 1 AND ('Government' LIKE '%' + @query + '%')) OR ((CPL.IsCommercial = 1 AND ('Comm' LIKE '%' + @query + '%')))))
		)
	ORDER BY Name

	SELECT @totalRecords = COUNT(*)
	FROM #t_ClearinghousePayers
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_ClearinghousePayers
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_ClearinghousePayers
	RETURN
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET INSURANCE PLAN
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_GetInsurancePlan
	@insurance_plan_id int
AS
BEGIN
	SELECT	IP.InsuranceCompanyPlanID,
		IP.PlanName,
		IP.AddressLine1,
		IP.AddressLine2,
		IP.City,
		IP.State,
		IP.Country,
		IP.ZipCode,
		IP.ContactPrefix,
		IP.ContactFirstName,
		IP.ContactMiddleName,
		IP.ContactLastName,
		IP.ContactSuffix,
		IP.Phone,
		IP.PhoneExt,
		IP.Fax,
		IP.FaxExt,
		IP.CoPay,
		IP.InsuranceProgramCode,
		IP.ProviderNumberTypeID,
		IP.GroupNumberTypeID,
		IP.LocalUseProviderNumberTypeID,
		IP.HCFADiagnosisReferenceFormatCode,
		IP.HCFASameAsInsuredFormatCode,
		CPL.PayerNumber AS EDIPayerNumber,
		IP.Notes,
		IP.ReviewCode,
		IP.ClearinghousePayerID,
		CASE WHEN CPL.ClearinghousePayerID IS NULL THEN '' ELSE 'ProxyMed' END AS ClearinghouseDisplayName,
		(CPL.[Name] + '   (' + CAST(CPL.ClearinghousePayerID AS VARCHAR) + ')') AS ClearinghousePayerDisplayName,
		COALESCE(CPL.Notes,'') AS ClearinghouseNotes,
		CAST (CPL.IsGovernment AS INT) AS IsGovernment,
		CPL.StateSpecific,
		CAST (ISNULL(CPL.IsEnrollmentRequired,0) AS BIT) AS EClaimsRequiresEnrollment,
		CAST (ISNULL(CPL.IsAuthorizationRequired,0) AS BIT) AS EClaimsRequiresAuthorization,
		CAST (ISNULL(CPL.IsProviderIdRequired,0) AS BIT) AS EClaimsRequiresProviderID,
		CAST (ISNULL(CPL.IsTestRequired,0) AS BIT) AS EClaimsRequiresTest,
		CAST (ISNULL(CPL.IsPaperOnly,0) AS BIT) AS EClaimsPaperOnly,
		CAST (ISNULL(CPL.ResponseLevel,0) AS INT) AS EClaimsResponseLevel,
		IP.EClaimsAccepts,
		'Not approved' AS ApprovalStatus,
		'Administrator' AS CreatorPractice, 
		CAST (1 AS BIT) AS Deletable,
		CAST (0 AS INT) AS EClaimsEnrollmentStatusID,
		CAST (0 AS BIT) AS EClaimsDisable
	INTO 
		#t_InsuranceCompanyPlan
	FROM	InsuranceCompanyPlan IP
			LEFT OUTER JOIN ClearinghousePayersList CPL
			ON IP.ClearinghousePayerID = CPL.ClearinghousePayerID
	WHERE	IP.InsuranceCompanyPlanID = @insurance_plan_id

	UPDATE #t_InsuranceCompanyPlan
	SET ApprovalStatus = 'Approved' WHERE ReviewCode = 'R'
	
	SELECT *
	FROM #t_InsuranceCompanyPlan
	
	DROP TABLE #t_InsuranceCompanyPlan
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET INSURANCE PLANS
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_GetInsurancePlans
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@review_code CHAR(1) = NULL,
	@show_code CHAR(1) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

	SELECT	IP.InsuranceCompanyPlanID,
		IP.PlanName,
		IP.AddressLine1,
		IP.AddressLine2,
		IP.City,
		IP.State,
		IP.Country,
		IP.ZipCode,
		IP.ContactPrefix,
		IP.ContactFirstName,
		IP.ContactMiddleName,
		IP.ContactLastName,
		IP.ContactSuffix,
		IP.Phone,
		IP.PhoneExt,
		IP.Fax,
		IP.FaxExt,
		IP.CoPay,
		IP.InsuranceProgramCode,
		IP.ProviderNumberTypeID,
		IP.GroupNumberTypeID,
		IP.LocalUseProviderNumberTypeID,
		IP.HCFADiagnosisReferenceFormatCode,
		IP.HCFASameAsInsuredFormatCode,
		CPL.PayerNumber AS EDIPayerNumber,
		CASE WHEN CPL.ClearinghousePayerID IS NULL THEN '' ELSE 'ProxyMed' END AS ClearinghouseDisplayName,
		(CPL.[Name] + '   (' + CAST(CPL.ClearinghousePayerID AS VARCHAR) + ')') AS ClearinghousePayerDisplayName,
		COALESCE(CPL.Notes,'') AS ClearinghouseNotes,
		IP.Notes,
		IP.ReviewCode,
		IP.ClearinghousePayerID,
		CAST (CPL.IsGovernment AS INT) AS IsGovernment,
		CPL.StateSpecific,
		CAST (ISNULL(CPL.IsEnrollmentRequired,0) AS BIT) AS EClaimsRequiresEnrollment,
		CAST (ISNULL(CPL.IsAuthorizationRequired,0) AS BIT) AS EClaimsRequiresAuthorization,
		CAST (ISNULL(CPL.IsProviderIdRequired,0) AS BIT) AS EClaimsRequiresProviderID,
		CAST (ISNULL(CPL.IsTestRequired,0) AS BIT) AS EClaimsRequiresTest,
		CAST (ISNULL(CPL.IsPaperOnly,0) AS BIT) AS EClaimsPaperOnly,
		CAST (ISNULL(CPL.ResponseLevel,0) AS INT) AS EClaimsResponseLevel,
		IP.EClaimsAccepts,
		'Administrator' AS CreatorPractice,
		CAST('No' AS VARCHAR (10)) AS EClaimsStatus,
		'Not approved' AS ApprovalStatus,
		CAST(1 AS BIT) AS Deletable,
		IDENTITY(int, 0, 1) as RID
	INTO 
		#t_InsuranceCompanyPlan
	FROM	
		dbo.InsuranceCompanyPlan IP
		LEFT OUTER JOIN ClearinghousePayersList CPL
		  ON IP.ClearinghousePayerID = CPL.ClearinghousePayerID
	WHERE
		(	(@query_domain IS NULL OR @query IS NULL)
			OR	((@query_domain = 'PlanName' OR @query_domain = 'All')
				AND IP.PlanName LIKE '%' + @query + '%')
			OR	((@query_domain = 'PlanAddress' OR @query_domain = 'All')
				AND	(IP.AddressLine1 LIKE '%' + @query + '%'
					OR IP.AddressLine2 LIKE '%' + @query + '%'
					OR IP.City LIKE '%' + @query + '%'
					OR IP.State LIKE '%' + @query + '%'
					OR IP.ZipCode LIKE '%' + @query + '%'))
			OR	((@query_domain = 'PlanPhone' OR @query_domain = 'All')
				AND	(IP.Phone LIKE '%' + REPLACE(REPLACE(REPLACE(@query,'-',''),'(',''),')','') + '%'))
		)
		AND	((@review_code IS NULL)
			  OR	(@review_code IS NOT NULL
				AND IP.ReviewCode = @review_code))
		AND	((@show_code IS NULL)
			  OR	(@show_code = '1' AND IP.EClaimsAccepts = 1)
			  OR	(@show_code = '0' AND IP.EClaimsAccepts = 0))
	ORDER BY PlanName

	UPDATE #t_InsuranceCompanyPlan
	SET EClaimsStatus = 'Yes' WHERE EClaimsAccepts = 1
	
	UPDATE #t_InsuranceCompanyPlan
	SET ApprovalStatus = 'Approved' WHERE ReviewCode = 'R'
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_InsuranceCompanyPlan
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_InsuranceCompanyPlan
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_InsuranceCompanyPlan
	RETURN
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--TEST
BEGIN TRAN 
EXEC Shared_InsurancePlanDataProvider_MergeInsurancePlans 1,
'<selections>
<selection>
2
</selection>
</selections>'

SELECT @@TRANCOUNT

ROLLBACK

*/

--===========================================================================
-- MERGE INSURANCE PLANS
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_MergeInsurancePlans
	@plan_id INT,
	@selection_xml TEXT
AS
BEGIN
	DECLARE @doc INT
	EXEC sp_xml_preparedocument @doc OUTPUT, @selection_xml

	CREATE TABLE #selection(InsuranceCompanyPlanID int PRIMARY KEY)

	--Get a temp TABLE that can be passed INTO the dynamic sql
	INSERT #selection(InsuranceCompanyPlanID)
	SELECT	InsuranceCompanyPlanID
	FROM	OPENXML(@doc, '/selections/selection')
			WITH (InsuranceCompanyPlanID INT)
	WHERE	InsuranceCompanyPlanID <> @plan_id
			
	EXEC sp_xml_removedocument @doc
	
	BEGIN TRAN 
		
	DECLARE @DatabaseName varchar(128)
	DECLARE @DatabaseServerName varchar(128)
	DECLARE @DatabasePath varchar(256)
	
	DECLARE @sql varchar(8000)
	
	DECLARE sync_merge_insurance_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.DatabaseServerName, C.DatabaseName
			FROM dbo.Customer C
			WHERE C.DBActive = 1
	OPEN sync_merge_insurance_cursor
	
	FETCH NEXT FROM sync_merge_insurance_cursor INTO @DatabaseServerName, @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			SET @DatabasePath = COALESCE(@DatabaseServerName + '.','') + COALESCE(@DatabaseName + '.','')
			
			PRINT 'Processing for database: ' + @DatabasePath
			--Redirect practice Relationships.
			SET @sql = 	'DELETE ' + @DatabasePath + 'dbo.PracticeToInsuranceCompanyPlan
						WHERE	InsuranceCompanyPlanID IN (
									SELECT	InsuranceCompanyPlanID
									FROM #selection
								)'
			EXEC(@sql)

						--Redirect patient insurance associations.
			SET @sql = 	'UPDATE	' + @DatabasePath + 'dbo.PatientInsurance
						SET	InsuranceCompanyPlanID = ' + CAST(@plan_id AS varchar(10)) + ' ' +
						'WHERE	InsuranceCompanyPlanID IN (
									SELECT	InsuranceCompanyPlanID
									FROM #selection
								)'
			EXEC(@sql)

						--Redirect provider numbers insurance associations.
			SET @sql = 	'UPDATE	' + @DatabasePath + 'dbo.ProviderNumber
						SET	InsuranceCompanyPlanID = ' + CAST(@plan_id AS varchar(10)) + ' ' +
						'WHERE	InsuranceCompanyPlanID IN (
									SELECT	InsuranceCompanyPlanID
									FROM #selection
								)'
			EXEC(@sql)

						--Redirect practice insurance numbers insurance associations.
			SET @sql = 	'UPDATE	' + @DatabasePath + 'dbo.PracticeInsuranceGroupNumber
						SET	InsuranceCompanyPlanID = ' + CAST(@plan_id AS varchar(10)) + ' ' +
						'WHERE	InsuranceCompanyPlanID IN (
									SELECT	InsuranceCompanyPlanID
									FROM #selection
								)'

			EXEC(@sql)
		END
		FETCH NEXT FROM sync_merge_insurance_cursor INTO @DatabaseServerName, @DatabaseName
	END
	CLOSE sync_merge_insurance_cursor
	DEALLOCATE sync_merge_insurance_cursor

	--Remove duplicate plans.
	DELETE dbo.InsuranceCompanyPlan
	WHERE	InsuranceCompanyPlanID IN (
				SELECT	InsuranceCompanyPlanID
				FROM #selection
			)
	
		
	COMMIT
		
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- UPDATE CLEARINGHOUSE PAYER
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_UpdateClearinghousePayer
	@ClearinghousePayerID INT,
	@ClearinghouseID INT,
	@PayerNumber VARCHAR(32),
	@Name VARCHAR(1000),
	@Notes VARCHAR(1000) = NULL,
	@StateSpecific VARCHAR(16) = NULL,
	@PayerType INT = 0,
	@IsParticipating BIT = 0,
	@IsProviderIdRequired BIT = 0,
	@IsEnrollmentRequired BIT = 0,
	@IsAuthorizationRequired BIT = 0,
	@IsTestRequired BIT = 0,
	@ResponseLevel INT = NULL,
	@IsNewPayer BIT = 0,
	@DateNewPayerSince DATETIME = NULL,
	@Active INT = 1

AS
BEGIN
	UPDATE	
		ClearinghousePayersList
	SET	
		ClearinghouseID = @ClearinghouseID,
		PayerNumber = @PayerNumber,
		[Name] = @Name,
		Notes = @Notes,
		StateSpecific = @StateSpecific,
		IsGovernment = CAST((CASE (@PayerType) WHEN 1 THEN 1 ELSE  0 END) AS BIT),
		IsCommercial = CAST((CASE (@PayerType) WHEN 2 THEN 1 ELSE  0 END) AS BIT),
		IsParticipating = @IsParticipating,
		IsProviderIdRequired = @IsProviderIdRequired,
		IsEnrollmentRequired = @IsEnrollmentRequired,
		IsAuthorizationRequired = @IsAuthorizationRequired,
		IsTestRequired = @IsTestRequired,
		ResponseLevel = @ResponseLevel,
		IsNewPayer = @IsNewPayer,
		DateNewPayerSince = @DateNewPayerSince,
		Active = @Active,
		ModifiedDate = GETDATE()
	WHERE	ClearinghousePayerID = @ClearinghousePayerID

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- UPDATE INSURANCE PLAN
--===========================================================================
CREATE PROCEDURE dbo.Shared_InsurancePlanDataProvider_UpdateInsurancePlan
	@plan_id INT,
	@name VARCHAR(64),
	@street_1 VARCHAR(64),
	@street_2 VARCHAR(64),
	@city VARCHAR(32),
	@state CHAR(2),
	@country VARCHAR(32),
	@zip VARCHAR(9),
	@contact_prefix VARCHAR(16),
	@contact_first_name VARCHAR(32),
	@contact_middle_name VARCHAR(32),
	@contact_last_name VARCHAR(32),
	@contact_suffix VARCHAR(16),
	@phone VARCHAR(10),
	@phone_x VARCHAR(10),
	@fax VARCHAR(10),
	@fax_x VARCHAR(10),
	@copay_flag BIT,
	@program_code CHAR(1) = 'O',
	@provider_number_type_id INT = NULL,
	@group_number_type_id INT = NULL,
	@local_use_provider_number_type_id INT = NULL,
	@hcfa_diag_code CHAR(1) = 'C',
	@hcfa_same_code CHAR(1) = 'D',
	@review_code CHAR(1) = '',
	@EClaimsAccepts BIT = 0,
	@ClearinghousePayerID INT = NULL,
	@notes TEXT,
	@eclaims_enrollment_status_id INT = NULL,
	@eclaims_disable BIT = NULL

AS
BEGIN
	UPDATE	
		InsuranceCompanyPlan
	SET	
		PlanName = @name,
		AddressLine1 = @street_1,
		AddressLine2 = @street_2,
		City = @city,
		State = @state,
		Country = @country,
		ZipCode = @zip,
		ContactPrefix = @contact_prefix,
		ContactFirstName = @contact_first_name,
		ContactMiddleName = @contact_middle_name,
		ContactLastName = @contact_last_name,
		ContactSuffix = @contact_suffix,
		Phone = @phone,
		PhoneExt = @phone_x,
		Fax = @fax,
		FaxExt = @fax_x,
		CoPay = @copay_flag,
		InsuranceProgramCode = @program_code,
		ProviderNumberTypeID = @provider_number_type_id,
		GroupNumberTypeID = @group_number_type_id,
		LocalUseProviderNumberTypeID = @local_use_provider_number_type_id,
		HCFADiagnosisReferenceFormatCode = @hcfa_diag_code,
		HCFASameAsInsuredFormatCode = @hcfa_same_code,
		ReviewCode = @review_code,
		EClaimsAccepts = @EClaimsAccepts,
		ClearinghousePayerID = @ClearinghousePayerID,
		Notes = @notes,
		ModifiedDate = GETDATE()
	WHERE	InsuranceCompanyPlanID = @plan_id

	DECLARE @EClaimsRequiresEnrollment BIT

	SELECT @EClaimsRequiresEnrollment = CPL.IsEnrollmentRequired
	FROM	dbo.InsuranceCompanyPlan IP
		LEFT OUTER JOIN dbo.ClearinghousePayersList CPL
		  ON IP.ClearinghousePayerID = CPL.ClearinghousePayerID
	WHERE IP.InsuranceCompanyPlanID = @plan_id

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- CREATE PROCEDURE
--===========================================================================
CREATE PROCEDURE dbo.Shared_ProcedureDataProvider_CreateProcedure
	@ProcedureCode varchar(16),
	@ProcedureName varchar(64),
	@Description varchar(64),
	@TypeOfServiceCode CHAR(2)
AS
BEGIN
	INSERT dbo.ProcedureCodeDictionary (
		ProcedureCode,
		ProcedureName,
		Description,
		TypeOfServiceCode)
	VALUES	(
		@ProcedureCode,
		@ProcedureName,
		@Description,
		@TypeOfServiceCode)

	RETURN SCOPE_IDENTITY()
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- DELETE PROCEDURE
--===========================================================================
CREATE PROCEDURE dbo.Shared_ProcedureDataProvider_DeleteProcedure
	@ProcedureCodeDictionaryID int
AS
BEGIN
	--Remove procedure.
	DELETE dbo.ProcedureCodeDictionary
	WHERE	ProcedureCodeDictionaryID = @ProcedureCodeDictionaryID
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET PROCEDURE
--===========================================================================
CREATE PROCEDURE dbo.Shared_ProcedureDataProvider_GetProcedure
	@ProcedureCodeDictionaryID int
AS
BEGIN
	--dbo.BusinessRule_ProcedureIsDeletable(PCD.ProcedureCodeDictionaryID) AS Deletable
	SELECT	PCD.ProcedureCodeDictionaryID,
		PCD.ProcedureCode,
		PCD.ProcedureName,
		PCD.Description,
		PCD.TypeOfServiceCode,
		CAST(1 AS bit) AS Deletable
	FROM dbo.ProcedureCodeDictionary PCD
		INNER JOIN dbo.TypeOfService TOS
		ON PCD.TypeOfServiceCode = TOS.TypeOfServiceCode
	WHERE PCD.ProcedureCodeDictionaryID = @ProcedureCodeDictionaryID
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET PROCEDURES
--===========================================================================
CREATE PROCEDURE dbo.Shared_ProcedureDataProvider_GetProcedures
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #t_procedures(
		ProcedureCodeDictionaryID int, 
		ProcedureCode varchar(16), 
		ProcedureName varchar(100), 
		ProcedureDescription varchar(64),   
		TypeOfServiceCode char(2),   
		RID int IDENTITY(0,1)
	)
	
	INSERT #t_procedures(
		ProcedureCodeDictionaryID, 
		ProcedureCode, 
		ProcedureName,
		ProcedureDescription,
		TypeOfServiceCode
	)
	SELECT	PCD.ProcedureCodeDictionaryID,
		PCD.ProcedureCode,
		PCD.ProcedureName,
		PCD.[Description],
		PCD.TypeOfServiceCode
	FROM	dbo.ProcedureCodeDictionary PCD
	WHERE	(	(@query_domain IS NULL OR @query IS NULL)
		OR	((@query_domain = 'ProcedureCode' OR @query_domain = 'All')
			  AND (ProcedureCode LIKE '%' + @query + '%'))
		OR	((@query_domain = 'ProcedureName' OR @query_domain = 'All')
			  AND (ProcedureName LIKE '%' + @query + '%'))
		)
	ORDER BY ProcedureCode
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_procedures
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_procedures
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_procedures
	RETURN
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- UPDATE PROCEDURE 
--===========================================================================
CREATE PROCEDURE dbo.Shared_ProcedureDataProvider_UpdateProcedure
	@ProcedureCodeDictionaryID int,
	@ProcedureCode varchar(16),
	@ProcedureName varchar(64),
	@Description varchar(64),
	@TypeOfServiceCode CHAR(2)
AS
BEGIN
	UPDATE dbo.ProcedureCodeDictionary
	SET	ProcedureCode = @ProcedureCode,	
		ProcedureName = @ProcedureName,
		Description = @Description,
		TypeOfServiceCode = @TypeOfServiceCode,
		ModifiedDate = GETDATE()
	WHERE	ProcedureCodeDictionaryID = @ProcedureCodeDictionaryID
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- CREATE PROCEDURE MODIFIER
--===========================================================================
CREATE PROCEDURE dbo.Shared_ProcedureModifierDataProvider_CreateProcedureModifier
	@modifier_code VARCHAR(16),
	@name VARCHAR(250)
AS
BEGIN
	INSERT	ProcedureModifier (ProcedureModifierCode, ModifierName)
	VALUES	(@modifier_code, @name)

	RETURN SCOPE_IDENTITY()
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- DELETE PROCEDURE MODIFIER
--===========================================================================
CREATE PROCEDURE dbo.Shared_ProcedureModifierDataProvider_DeleteProcedureModifier
	@modifier_code VARCHAR(16)
AS
BEGIN
	DELETE	ProcedureModifier
	WHERE	ProcedureModifierCode = @modifier_code
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET PROCEDURE MODIFIER
--===========================================================================
CREATE PROCEDURE dbo.Shared_ProcedureModifierDataProvider_GetProcedureModifier
	@modifier_code VARCHAR(16)
AS
BEGIN
	SELECT	ProcedureModifierCode,
		ModifierName
	FROM	ProcedureModifier
	WHERE	ProcedureModifierCode = @modifier_code
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- GET PROCEDURE MODIFIERS
--===========================================================================
CREATE PROCEDURE dbo.Shared_ProcedureModifierDataProvider_GetProcedureModifiers
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #t_ProcedureModifier(
		ProcedureModifierCode varchar(16),
		ModifierName varchar(250), 
		RID int IDENTITY(0,1)
	)
	
	INSERT INTO #t_ProcedureModifier(
		ProcedureModifierCode, 
		ModifierName
	)
	SELECT	ProcedureModifierCode,
		ModifierName
	FROM	dbo.ProcedureModifier
	WHERE	(	(@query_domain IS NULL OR @query IS NULL)
		OR	((@query_domain = 'ProcedureModifierCode' OR @query_domain = 'All')
			  AND (ProcedureModifierCode LIKE '%' + @query + '%'))
		OR	((@query_domain = 'ProcedureModifierName' OR @query_domain = 'All')
			  AND (ModifierName LIKE '%' + @query + '%'))
		)
	ORDER BY ProcedureModifierCode
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_ProcedureModifier

	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_ProcedureModifier
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_ProcedureModifier
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- UPDATE PROCEDURE MODIFIER
--===========================================================================
CREATE PROCEDURE dbo.Shared_ProcedureModifierDataProvider_UpdateProcedureModifier
	@modifier_code VARCHAR(16),
	@name VARCHAR(250)
AS
BEGIN
	UPDATE	ProcedureModifier
	SET	ModifierName = @name, 
		ModifiedDate = GETDATE()
	WHERE	ProcedureModifierCode = @modifier_code
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Appointments Summary
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_AppointmentsSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@AppointmentResourceTypeID int = NULL, 
	@ResourceID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL, 
	@TimeOffset int = 0
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_AppointmentsSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@TimeOffset = ' + CAST(@TimeOffset AS varchar(10))

	IF @AppointmentResourceTypeID IS NOT NULL
		SET @sql = @sql + ',@AppointmentResourceTypeID = ' + CAST(@AppointmentResourceTypeID AS varchar(10))

	IF @ResourceID IS NOT NULL
		SET @sql = @sql + ',@ResourceID = ' + CAST(@ResourceID AS varchar(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS AR Aging Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_ARAgingDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@EndDate datetime = NULL,
	@RespType char(1) = I,
	@RespID int = 0
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_ARAgingDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@RespType = ''' + CAST(@RespType AS varchar(1)) + ''''
	SET @sql = @sql + ',@RespID = ' + CAST(@RespID AS varchar(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS AR Aging Summary
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_ARAgingSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@PayerTypeCode char(1) = 'I', --Can be I, P, O, or A for all
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_ARAgingSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@PayerTypeCode = ''' + CAST(@PayerTypeCode AS varchar(1)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Key Indicators Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_KeyIndicatorsDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@SummarizeAllProviders bit = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_KeyIndicatorsDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@SummarizeAllProviders = ' + CAST(@SummarizeAllProviders AS varchar(1))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Key Indicators Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_KeyIndicatorsDetailAdjustments
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@SummarizeAllProviders bit = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_KeyIndicatorsDetailAdjustments] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@SummarizeAllProviders = ' + CAST(@SummarizeAllProviders AS varchar(1))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Key Indicators Summary
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_KeyIndicatorsSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@SummarizeAllProviders bit = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_KeyIndicatorsSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@SummarizeAllProviders = ' + CAST(@SummarizeAllProviders AS varchar(1))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Key Indicators Summary Compare Previous Year
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_KeyIndicatorsSummaryComparePreviousYear
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@SummarizeAllProviders bit = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_KeyIndicatorsSummaryComparePreviousYear] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@SummarizeAllProviders = ' + CAST(@SummarizeAllProviders AS varchar(1))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Patient Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientDetail
	@CustomerID int,
	@PatientID INT
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientDetail] '
	SET @sql = @sql + '@PatientID = ' + CAST(@PatientID AS varchar(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Patient Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientDetailAuthorization
	@CustomerID int,
	@PatientID INT
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientDetailAuthorization] '
	SET @sql = @sql + '@PatientID = ' + CAST(@PatientID AS varchar(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Patient Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientDetailEmployer
	@CustomerID int,
	@PatientID INT
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientDetailEmployer] '
	SET @sql = @sql + '@PatientID = ' + CAST(@PatientID AS varchar(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Patient Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientDetailInsurance
	@CustomerID int,
	@PatientID INT
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientDetailInsurance] '
	SET @sql = @sql + '@PatientID = ' + CAST(@PatientID AS varchar(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Patient History
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientHistory
	@CustomerID int,
	@PracticeID int = NULL,
	@PatientID int = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientHistory] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@PatientID = ' + CAST(@PatientID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Patient Referrals Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientReferralsDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@ServiceLocationID int = NULL,
	@ReferringProviderID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientReferralsDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@ReferringProviderID = ' + CAST(@ReferringProviderID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	IF @ServiceLocationID IS NOT NULL
		SET @sql = @sql + ',@ServiceLocationID = ' + CAST(@ServiceLocationID AS varchar(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Patient Referrals Summary
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientReferralsSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@ServiceLocationID int = NULL,
	@GroupByLocation bit = 1,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientReferralsSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@GroupByLocation = ' + CAST(@GroupByLocation AS varchar(40))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	IF @ServiceLocationID IS NOT NULL
		SET @sql = @sql + ',@ServiceLocationID = ' + CAST(@ServiceLocationID AS varchar(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Patient Transaction Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientTransactionsDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@PatientID int = NULL, 
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientTransactionsDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''

	IF @PatientID IS NOT NULL
		SET @sql = @sql + ',@PatientID = ' + CAST(@PatientID AS varchar(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Payment Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientTransactionsSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientTransactionsSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Payment Application Report
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PaymentApplicationReport
	@CustomerID int,
	@PracticeID int = NULL,
	@PaymentID int = 0
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PaymentApplicationReport] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@PaymentID = ' + CAST(@PaymentID AS varchar(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Payment Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PaymentsDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = ''
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PaymentsDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	IF @PaymentMethodCode IS NOT NULL
		SET @sql = @sql + ',@PaymentMethodCode = ''' + CAST(@PaymentMethodCode AS varchar(40)) + ''''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Payment Summary
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PaymentsSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = ''
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PaymentsSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''

	IF @PaymentMethodCode <> ''
		SET @sql = @sql + ',@PaymentMethodCode = ''' + CAST(@PaymentMethodCode AS varchar(1)) + ''''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Provider Productivity
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_ProviderProductivity
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@ServiceLocationID int = 0,
	@GroupByLocation bit = 1,
	@GroupByProvider bit = 1,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_ProviderProductivity] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@ServiceLocationID = ' + CAST(@ServiceLocationID AS varchar(10))
	SET @sql = @sql + ',@GroupByLocation = ' + CAST(@GroupByLocation AS varchar(1))
	SET @sql = @sql + ',@GroupByProvider = ' + CAST(@GroupByProvider AS varchar(1))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Refunds Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_RefundsDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = ''
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_RefundsDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''

	IF @PaymentMethodCode <> ''
		SET @sql = @sql + ',@PaymentMethodCode = ''' + CAST(@PaymentMethodCode AS varchar(1)) + ''''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--===========================================================================
-- SRS Refunds Summary
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_RefundsSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = ''
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_RefundsSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''

	IF @PaymentMethodCode <> ''
		SET @sql = @sql + ',@PaymentMethodCode = ' + CAST(@PaymentMethodCode AS varchar(1))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
--
--===========================================================================
CREATE PROCEDURE dbo.Shared_SyncJob_DiagnosisCodeDictionary 
AS
BEGIN
	DECLARE @LastUpdated datetime
	
	SELECT @LastUpdated = SLR.LastUpdatedDate
	FROM dbo.SubscriptionLastRun SLR
	WHERE SLR.TableName = 'DiagnosisCodeDictionary'

	DECLARE @DatabaseName varchar(128)
	DECLARE @sql varchar(8000)
	
	DECLARE sync_proc_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.DatabaseName
			FROM dbo.Customer C
	
	OPEN sync_proc_cursor
	
	FETCH NEXT FROM sync_proc_cursor INTO @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			PRINT 'Processing for database: ' + @DatabaseName
					--update the records that are common and have changed
			SET @sql = 'UPDATE	C_PCD
						SET	[DiagnosisCode] = S_PCD.DiagnosisCode,
							[DiagnosisName] = S_PCD.DiagnosisName,
							[Description] = S_PCD.Description,
							[ModifiedDate] = S_PCD.ModifiedDate,
							[ModifiedUserID] = S_PCD.ModifiedUserID,
							KareoLastModifiedDate = GETDATE()
						FROM ' + @DatabaseName + '.dbo.DiagnosisCodeDictionary C_PCD
							INNER JOIN dbo.DiagnosisCodeDictionary S_PCD
							ON C_PCD.KareoDiagnosisCodeDictionaryID = S_PCD.DiagnosisCodeDictionaryID
						WHERE S_PCD.ModifiedDate >= ''' + CAST(@LastUpdated AS varchar(40)) + ''''
						
			EXEC(@sql)	
						--insert the records that do NOT exist in the customer database
			SET @sql = 'INSERT INTO ' + @DatabaseName + '.[dbo].[DiagnosisCodeDictionary] (
							[DiagnosisCode],
							[DiagnosisName],
							[Description],
							[KareoDiagnosisCodeDictionaryID],
							[CreatedDate],
							[CreatedUserID],
							[ModifiedDate],
							[ModifiedUserID],
							[KareoLastModifiedDate])
						SELECT 	[DiagnosisCode],
							[DiagnosisName],
							[Description],
							[DiagnosisCodeDictionaryID],
							[CreatedDate],
							[CreatedUserID],
							[ModifiedDate],
							[ModifiedUserID],
							GETDATE()
						FROM dbo.DiagnosisCodeDictionary S_PCD
						WHERE S_PCD.DiagnosisCodeDictionaryID NOT IN
							(	SELECT KareoDiagnosisCodeDictionaryID
								FROM ' + @DatabaseName + '.dbo.DiagnosisCodeDictionary
								WHERE KareoDiagnosisCodeDictionaryID IS NOT NULL
							)'
							
			EXEC(@sql)
						--Delete the customer database records that are no longer in the shared database
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[DiagnosisCodeDictionary] 
						WHERE KareoDiagnosisCodeDictionaryID IS NOT NULL
							AND KareoDiagnosisCodeDictionaryID NOT IN
							(	SELECT DiagnosisCodeDictionaryID
								FROM dbo.DiagnosisCodeDictionary
							)'	
	
			EXEC(@sql)	
		END
		FETCH NEXT FROM sync_proc_cursor INTO @DatabaseName
	END
	CLOSE sync_proc_cursor
	DEALLOCATE sync_proc_cursor

	--Update the last push subscription last run
	UPDATE dbo.SubscriptionLastRun
		SET LastUpdatedDate = GETDATE()
	WHERE TableName = 'DiagnosisCodeDictionary'

END
--SELECT @@TRANCOUNT
--SELECT *
--FROM SubscriptionLastRun
--ROLLBACK


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
--
--===========================================================================
CREATE PROCEDURE dbo.Shared_SyncJob_InsuranceCompanyPlan 
AS
BEGIN
	DECLARE @LastUpdated datetime
	
	SELECT @LastUpdated = SLR.LastUpdatedDate
	FROM dbo.SubscriptionLastRun SLR
	WHERE SLR.TableName = 'InsuranceCompanyPlan'

	DECLARE @DatabaseName varchar(128)
	DECLARE @sql varchar(8000)
	
	DECLARE sync_proc_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.DatabaseName
			FROM dbo.Customer C
	
	OPEN sync_proc_cursor
	
	FETCH NEXT FROM sync_proc_cursor INTO @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			PRINT 'Processing for database: ' + @DatabaseName
			--BillingForm
			SET @sql = 'UPDATE	C_BF
						SET	[FormType] = S_BF.FormType,
							[FormName] = S_BF.FormName,
							[Transform] = S_BF.Transform
						FROM ' + @DatabaseName + '.[dbo].[BillingForm] C_BF
							INNER JOIN dbo.BillingForm S_BF
							ON C_BF.BillingFormID = S_BF.BillingFormID'

			EXEC(@sql)	

			SET @sql = 'INSERT INTO ' + @DatabaseName + '.dbo.[BillingForm] (
							[BillingFormID],
							[FormType],
							[FormName],
							[Transform])
						SELECT
							[BillingFormID] ,
							[FormType],
							[FormName],
							[Transform]
						FROM dbo.BillingForm S_BF
						WHERE S_BF.BillingFormID NOT IN
							(	SELECT BillingFormID
								FROM ' + @DatabaseName + '.dbo.BillingForm
								WHERE BillingFormID IS NOT NULL
							)'
			EXEC(@sql)	
						
			--[dbo].[ClearinghousePayersList]
			SET @sql = 'UPDATE	C_CPL
						SET	[ClearinghouseID] = S_CPL.ClearinghouseID,
							[PayerNumber] = S_CPL.PayerNumber,
							[Name] = S_CPL.Name,
							[Notes] = S_CPL.Notes,
							[StateSpecific] = S_CPL.StateSpecific,
							[IsPaperOnly] = S_CPL.IsPaperOnly,
							[IsGovernment] = S_CPL.IsGovernment,
							[IsCommercial] = S_CPL.IsCommercial,
							[IsParticipating] = S_CPL.IsParticipating,
							[IsProviderIdRequired] = S_CPL.IsProviderIdRequired,
							[IsEnrollmentRequired] = S_CPL.IsEnrollmentRequired,
							[IsAuthorizationRequired] = S_CPL.IsAuthorizationRequired,
							[IsTestRequired] = S_CPL.IsTestRequired,
							[ResponseLevel] = S_CPL.ResponseLevel,
							[IsNewPayer] = S_CPL.IsNewPayer,
							[DateNewPayerSince] = S_CPL.DateNewPayerSince,
							[CreatedDate] = S_CPL.CreatedDate,
							[ModifiedDate] = S_CPL.ModifiedDate,
							[Active] = S_CPL.Active,
							[IsModifiedPayer] = S_CPL.IsModifiedPayer,
							[DateModifiedPayerSince] = S_CPL.DateModifiedPayerSince,
							[KareoLastModifiedDate] = GETDATE() 
						FROM ' + @DatabaseName + '.dbo.ClearinghousePayersList C_CPL
							INNER JOIN dbo.ClearinghousePayersList S_CPL
							ON C_CPL.KareoClearinghousePayersListID = S_CPL.ClearinghousePayerID
						WHERE S_CPL.ModifiedDate >= ''' + CAST(@LastUpdated AS varchar(40)) + ''''

			EXEC(@sql)	
			SET @sql = 'INSERT INTO ' + @DatabaseName + '.[dbo].[ClearinghousePayersList] (
							[ClearinghousePayerID],
							[KareoClearinghousePayersListID],
							[ClearinghouseID],
							[PayerNumber],
							[Name],
							[Notes],
							[StateSpecific],
							[IsPaperOnly],
							[IsGovernment],
							[IsCommercial],
							[IsParticipating],
							[IsProviderIdRequired],
							[IsEnrollmentRequired],
							[IsAuthorizationRequired],
							[IsTestRequired],
							[ResponseLevel],
							[IsNewPayer],
							[DateNewPayerSince],
							[CreatedDate],
							[ModifiedDate],
							[Active],
							[IsModifiedPayer],
							[DateModifiedPayerSince],
							[KareoLastModifiedDate])
						SELECT
							[ClearinghousePayerID],
							[ClearinghousePayerID],
							[ClearinghouseID],
							[PayerNumber],
							[Name],
							[Notes],
							[StateSpecific],
							[IsPaperOnly],
							[IsGovernment],
							[IsCommercial],
							[IsParticipating],
							[IsProviderIdRequired],
							[IsEnrollmentRequired],
							[IsAuthorizationRequired],
							[IsTestRequired],
							[ResponseLevel],
							[IsNewPayer],
							[DateNewPayerSince],
							[CreatedDate],
							[ModifiedDate],
							[Active],
							[IsModifiedPayer],
							[DateModifiedPayerSince],
							GETDATE()
						FROM dbo.ClearinghousePayersList S_CPL
						WHERE S_CPL.ClearinghousePayerID NOT IN
							(	SELECT KareoClearinghousePayersListID
								FROM ' + @DatabaseName + '.dbo.ClearinghousePayersList
								WHERE KareoClearinghousePayersListID IS NOT NULL
							)'
							
			EXEC(@sql)

	
			--[dbo].[GroupNumberType]	
			SET @sql = 'UPDATE	C_GNT
						SET	[TypeName] = S_GNT.[TypeName],
							[ANSIReferenceIdentificationQualifier] = S_GNT.[ANSIReferenceIdentificationQualifier]
						FROM ' + @DatabaseName + '.[dbo].[GroupNumberType] C_GNT
							INNER JOIN [dbo].[GroupNumberType] S_GNT
							ON C_GNT.GroupNumberTypeID = S_GNT.GroupNumberTypeID'

			EXEC(@sql)	

			SET @sql = 'INSERT INTO ' + @DatabaseName + '.dbo.[GroupNumberType] (
							[GroupNumberTypeID],
							[TypeName],
							[ANSIReferenceIdentificationQualifier])
						SELECT
							[GroupNumberTypeID],
							[TypeName],
							[ANSIReferenceIdentificationQualifier]
						FROM dbo.GroupNumberType S_GNT
						WHERE S_GNT.GroupNumberTypeID NOT IN
							(	SELECT GroupNumberTypeID
								FROM ' + @DatabaseName + '.dbo.GroupNumberType
								WHERE GroupNumberTypeID IS NOT NULL
							)'
			EXEC(@sql)	
					
			--[dbo].[HCFADiagnosisReferenceFormat]
			SET @sql = 'UPDATE	C_DRF
						SET	[FormatName] = S_DRF.FormatName
						FROM ' + @DatabaseName + '.[dbo].[HCFADiagnosisReferenceFormat] C_DRF
							INNER JOIN [dbo].[HCFADiagnosisReferenceFormat] S_DRF
							ON C_DRF.HCFADiagnosisReferenceFormatCode = S_DRF.HCFADiagnosisReferenceFormatCode'

			EXEC(@sql)	

			SET @sql = 'INSERT INTO ' + @DatabaseName + '.dbo.[HCFADiagnosisReferenceFormat] (
							[HCFADiagnosisReferenceFormatCode],
							[FormatName]
							)
						SELECT [HCFADiagnosisReferenceFormatCode],
							[FormatName]
						FROM dbo.HCFADiagnosisReferenceFormat S_DRF
						WHERE S_DRF.HCFADiagnosisReferenceFormatCode NOT IN
							(	SELECT HCFADiagnosisReferenceFormatCode
								FROM ' + @DatabaseName + '.dbo.HCFADiagnosisReferenceFormat
								WHERE HCFADiagnosisReferenceFormatCode IS NOT NULL
							)'
			EXEC(@sql)	
			
			--[dbo].[HCFASameAsInsuredFormat]
			SET @sql = 'UPDATE	C_SIF
						SET	[FormatName] = S_SIF.FormatName
						FROM ' + @DatabaseName + '.[dbo].[HCFASameAsInsuredFormat] C_SIF
							INNER JOIN [dbo].[HCFASameAsInsuredFormat] S_SIF
							ON C_SIF.HCFASameAsInsuredFormatCode = S_SIF.HCFASameAsInsuredFormatCode'

			EXEC(@sql)	

			SET @sql = 'INSERT INTO ' + @DatabaseName + '.dbo.[HCFASameAsInsuredFormat] (
							[HCFASameAsInsuredFormatCode],
							[FormatName]
							)
						SELECT	[HCFASameAsInsuredFormatCode],
							[FormatName]
						FROM dbo.HCFASameAsInsuredFormat S_SIF
						WHERE S_SIF.HCFASameAsInsuredFormatCode NOT IN
							(	SELECT HCFASameAsInsuredFormatCode
								FROM ' + @DatabaseName + '.dbo.HCFASameAsInsuredFormat
								WHERE HCFASameAsInsuredFormatCode IS NOT NULL
							)'
			EXEC(@sql)				

			--InsuranceProgram
			SET @sql = 'UPDATE	C_IP
						SET	[ProgramName] = S_IP.ProgramName
						FROM ' + @DatabaseName + '.[dbo].[InsuranceProgram] C_IP
							INNER JOIN [dbo].[InsuranceProgram] S_IP
							ON C_IP.InsuranceProgramCode = S_IP.InsuranceProgramCode'

			EXEC(@sql)	

			SET @sql = 'INSERT INTO ' + @DatabaseName + '.dbo.[InsuranceProgram] (
							[InsuranceProgramCode],
							[ProgramName]
							)
						SELECT	[InsuranceProgramCode],
							[ProgramName]
						FROM dbo.InsuranceProgram S_IP
						WHERE S_IP.InsuranceProgramCode NOT IN
							(	SELECT InsuranceProgramCode
								FROM ' + @DatabaseName + '.dbo.InsuranceProgram
								WHERE InsuranceProgramCode IS NOT NULL
							)'
			EXEC(@sql)	

			--[dbo].[ProviderNumberType]
			SET @sql = 'UPDATE	C_PNT
						SET	[TypeName] = S_PNT.TypeName,
							ANSIReferenceIdentificationQualifier = C_PNT.ANSIReferenceIdentificationQualifier
						FROM ' + @DatabaseName + '.[dbo].[ProviderNumberType] C_PNT
							INNER JOIN [dbo].[ProviderNumberType] S_PNT
							ON C_PNT.ProviderNumberTypeID = S_PNT.ProviderNumberTypeID'

			EXEC(@sql)	

			SET @sql = 'INSERT INTO ' + @DatabaseName + '.dbo.[ProviderNumberType] (
							[ProviderNumberTypeID],
							[TypeName],
							ANSIReferenceIdentificationQualifier
							)
						SELECT [ProviderNumberTypeID],
							[TypeName],
							ANSIReferenceIdentificationQualifier
						FROM dbo.ProviderNumberType S_PNT
						WHERE S_PNT.ProviderNumberTypeID NOT IN
							(	SELECT ProviderNumberTypeID
								FROM ' + @DatabaseName + '.dbo.ProviderNumberType
								WHERE ProviderNumberTypeID IS NOT NULL
							)'
			EXEC(@sql)				

			
			--update the records that are common and have changed
			SET @sql = 'UPDATE	C_ICP
						SET	
							[PlanName] = S_ICP.PlanName,
							[AddressLine1] = S_ICP.AddressLine1,
							[AddressLine2] = S_ICP.AddressLine2,
							[City] = S_ICP.City,
							[State] = S_ICP.State,
							[Country] = S_ICP.Country,
							[ZipCode] = S_ICP.ZipCode,
							[ContactPrefix] = S_ICP.ContactPrefix,
							[ContactFirstName] = S_ICP.ContactFirstName,
							[ContactMiddleName] = S_ICP.ContactMiddleName,
							[ContactLastName] = S_ICP.ContactLastName,
							[ContactSuffix] = S_ICP.ContactSuffix,
							[Phone] = S_ICP.Phone,
							[PhoneExt] = S_ICP.PhoneExt,
							[CoPay] = S_ICP.CoPay,
							[Notes] = S_ICP.Notes,
							[MM_CompanyID] = S_ICP.MM_CompanyID,
							[ModifiedDate] = S_ICP.ModifiedDate,
							[ModifiedUserID] = S_ICP.ModifiedUserID,
							[InsuranceProgramCode] = S_ICP.InsuranceProgramCode,
							[HCFADiagnosisReferenceFormatCode] = S_ICP.HCFADiagnosisReferenceFormatCode,
							[HCFASameAsInsuredFormatCode] = S_ICP.HCFASameAsInsuredFormatCode,
							[LocalUseFieldTypeCode] = S_ICP.LocalUseFieldTypeCode,
							[ReviewCode] = S_ICP.ReviewCode,
							[ProviderNumberTypeID] = S_ICP.ProviderNumberTypeID,
							[GroupNumberTypeID] = S_ICP.GroupNumberTypeID,
							[LocalUseProviderNumberTypeID] = S_ICP.LocalUseProviderNumberTypeID,
							[BillingFormID] = S_ICP.BillingFormID,
							[EClaimsAccepts] = S_ICP.EClaimsAccepts,
							[CreatedPracticeID] = NULL,
							[Fax] = S_ICP.Fax,
							[FaxExt] = S_ICP.FaxExt,
							[ClearinghousePayerID] = S_ICP.ClearinghousePayerID,
							[KareoLastModifiedDate] = GETDATE()
						FROM ' + @DatabaseName + '.dbo.InsuranceCompanyPlan C_ICP
							INNER JOIN dbo.InsuranceCompanyPlan S_ICP
							ON C_ICP.KareoInsuranceCompanyPlanID = S_ICP.InsuranceCompanyPlanID
						WHERE S_ICP.ModifiedDate >= ''' + CAST(@LastUpdated AS varchar(40)) + ''''

			EXEC(@sql)	

						--insert the records that do NOT exist in the customer database
			SET @sql = 'INSERT INTO ' + @DatabaseName + '.[dbo].[InsuranceCompanyPlan] (
							[KareoInsuranceCompanyPlanID],
							[PlanName],
							[AddressLine1],
							[AddressLine2],
							[City],
							[State],
							[Country],
							[ZipCode],
							[ContactPrefix],
							[ContactFirstName],
							[ContactMiddleName],
							[ContactLastName],
							[ContactSuffix],
							[Phone],
							[PhoneExt],
							[CoPay],
							[Notes],
							[MM_CompanyID],
							[CreatedDate],
							[CreatedUserID],
							[ModifiedDate],
							[ModifiedUserID],
							[InsuranceProgramCode],
							[HCFADiagnosisReferenceFormatCode],
							[HCFASameAsInsuredFormatCode],
							[LocalUseFieldTypeCode],
							[ReviewCode],
							[ProviderNumberTypeID],
							[GroupNumberTypeID],
							[LocalUseProviderNumberTypeID],
							[BillingFormID],
							[EClaimsAccepts],
							[CreatedPracticeID],
							[Fax],
							[FaxExt],
							[ClearinghousePayerID],
							[KareoLastModifiedDate]
							)
						SELECT 	
							InsuranceCompanyPlanID,
							[PlanName],
							[AddressLine1],
							[AddressLine2],
							[City],
							[State],
							[Country],
							[ZipCode],
							[ContactPrefix],
							[ContactFirstName],
							[ContactMiddleName],
							[ContactLastName],
							[ContactSuffix],
							[Phone],
							[PhoneExt],
							[CoPay],
							[Notes],
							[MM_CompanyID],
							[CreatedDate],
							[CreatedUserID],
							[ModifiedDate],
							[ModifiedUserID],
							[InsuranceProgramCode],
							[HCFADiagnosisReferenceFormatCode],
							[HCFASameAsInsuredFormatCode],
							[LocalUseFieldTypeCode],
							[ReviewCode],
							[ProviderNumberTypeID],
							[GroupNumberTypeID],
							[LocalUseProviderNumberTypeID],
							[BillingFormID],
							[EClaimsAccepts],
							NULL,
							[Fax],
							[FaxExt],
							[ClearinghousePayerID],
							GETDATE()
						FROM dbo.InsuranceCompanyPlan S_ICP
						WHERE S_ICP.InsuranceCompanyPlanID NOT IN
							(	SELECT KareoInsuranceCompanyPlanID
								FROM ' + @DatabaseName + '.dbo.InsuranceCompanyPlan
								WHERE KareoInsuranceCompanyPlanID IS NOT NULL
							)'
							
			EXEC(@sql)
	
						--Delete the customer database records that are no longer in the shared database
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[InsuranceCompanyPlan] 
						WHERE KareoInsuranceCompanyPlanID IS NOT NULL
							AND KareoInsuranceCompanyPlanID NOT IN
							(	SELECT InsuranceCompanyPlanID
								FROM dbo.InsuranceCompanyPlan
							)'	
	
			EXEC(@sql)	
			
			--BillingForm
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[BillingForm] 
						WHERE BillingFormID IS NOT NULL
							AND BillingFormID NOT IN
							(	SELECT BillingFormID
								FROM dbo.BillingForm
							)'	
	
			EXEC(@sql)	
			
			--[dbo].[ClearinghousePayersList]
			--Delete the customer database records that are no longer in the shared database
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[ClearinghousePayersList] 
						WHERE KareoClearinghousePayersListID IS NOT NULL
							AND KareoClearinghousePayersListID NOT IN
							(	SELECT ClearinghousePayerID
								FROM dbo.ClearinghousePayersList
							)'	
	
			EXEC(@sql)	
			
			--[dbo].[GroupNumberType]			
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[GroupNumberType] 
						WHERE GroupNumberTypeID IS NOT NULL
							AND GroupNumberTypeID NOT IN
							(	SELECT GroupNumberTypeID
								FROM dbo.GroupNumberType
							)'	
	
			EXEC(@sql)	
			
			--[dbo].[HCFADiagnosisReferenceFormat]
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[HCFADiagnosisReferenceFormat] 
						WHERE HCFADiagnosisReferenceFormatCode IS NOT NULL
							AND HCFADiagnosisReferenceFormatCode NOT IN
							(	SELECT HCFADiagnosisReferenceFormatCode
								FROM dbo.HCFADiagnosisReferenceFormat
							)'	
	
			EXEC(@sql)	
			
			--[dbo].[HCFASameAsInsuredFormat]
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[HCFASameAsInsuredFormat] 
						WHERE HCFASameAsInsuredFormatCode IS NOT NULL
							AND HCFASameAsInsuredFormatCode NOT IN
							(	SELECT HCFASameAsInsuredFormatCode
								FROM dbo.HCFASameAsInsuredFormat
							)'	
	
			EXEC(@sql)	
			
			--InsuranceProgram
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[InsuranceProgram] 
						WHERE InsuranceProgramCode IS NOT NULL
							AND InsuranceProgramCode NOT IN
							(	SELECT InsuranceProgramCode
								FROM dbo.InsuranceProgram
							)'	
	
			EXEC(@sql)	
			
			--[dbo].[ProviderNumberType]
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[ProviderNumberType] 
						WHERE ProviderNumberTypeID IS NOT NULL
							AND ProviderNumberTypeID NOT IN
							(	SELECT ProviderNumberTypeID
								FROM dbo.ProviderNumberType
							)'	
	
			EXEC(@sql)	
	

		END
		FETCH NEXT FROM sync_proc_cursor INTO @DatabaseName
	END
	CLOSE sync_proc_cursor
	DEALLOCATE sync_proc_cursor

	--Update the last push subscription last run
	UPDATE dbo.SubscriptionLastRun
		SET LastUpdatedDate = GETDATE()
	WHERE TableName = 'InsuranceCompanyPlan'

	UPDATE dbo.SubscriptionLastRun
		SET LastUpdatedDate = GETDATE()
	WHERE TableName = 'BillingForm'

	UPDATE dbo.SubscriptionLastRun
		SET LastUpdatedDate = GETDATE()
	WHERE TableName = 'GroupNumberType'

	UPDATE dbo.SubscriptionLastRun
		SET LastUpdatedDate = GETDATE()
	WHERE TableName = 'HCFADiagnosisReferenceFormat'

	UPDATE dbo.SubscriptionLastRun
		SET LastUpdatedDate = GETDATE()
	WHERE TableName = 'HCFASameAsInsuredFormat'

	UPDATE dbo.SubscriptionLastRun
		SET LastUpdatedDate = GETDATE()
	WHERE TableName = 'InsuranceProgram'

	UPDATE dbo.SubscriptionLastRun
		SET LastUpdatedDate = GETDATE()
	WHERE TableName = 'ProviderNumberType'

END
--SELECT @@TRANCOUNT
--SELECT *
--FROM SubscriptionLastRun
--ROLLBACK

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
--
--===========================================================================
CREATE PROCEDURE dbo.Shared_SyncJob_ProcedureCodeDictionary 
AS
BEGIN
	DECLARE @LastUpdated datetime
	
	SELECT @LastUpdated = SLR.LastUpdatedDate
	FROM dbo.SubscriptionLastRun SLR
	WHERE SLR.TableName = 'ProcedureCodeDictionary'

	DECLARE @DatabaseName varchar(128)
	DECLARE @sql varchar(8000)
	
	DECLARE sync_proc_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.DatabaseName
			FROM dbo.Customer C
	
	OPEN sync_proc_cursor
	
	FETCH NEXT FROM sync_proc_cursor INTO @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			PRINT 'Processing for database: ' + @DatabaseName
					--update the records that are common and have changed
			SET @sql = 'UPDATE	C_PCD
						SET	[ProcedureCode] = S_PCD.ProcedureCode,
							[ProcedureName] = S_PCD.ProcedureName,
							[Description] = S_PCD.Description,
							[ModifiedDate] = S_PCD.ModifiedDate,
							[ModifiedUserID] = S_PCD.ModifiedUserID,
							[TypeOfServiceCode] = S_PCD.TypeOfServiceCode,
							KareoLastModifiedDate = GETDATE()
						FROM ' + @DatabaseName + '.dbo.ProcedureCodeDictionary C_PCD
							INNER JOIN dbo.ProcedureCodeDictionary S_PCD
							ON C_PCD.KareoProcedureCodeDictionaryID = S_PCD.ProcedureCodeDictionaryID
						WHERE S_PCD.ModifiedDate >= ''' + CAST(@LastUpdated AS varchar(40)) + ''''
						
			EXEC(@sql)	
						--insert the records that do NOT exist in the customer database
			SET @sql = 'INSERT INTO ' + @DatabaseName + '.[dbo].[ProcedureCodeDictionary] (
							[KareoProcedureCodeDictionaryID],
							[ProcedureCode],
							[ProcedureName],
							[Description],
							[CreatedDate],
							[CreatedUserID],
							[ModifiedDate],
							[ModifiedUserID],
							[TypeOfServiceCode],
							[KareoLastModifiedDate])
						SELECT 	[ProcedureCodeDictionaryID],
							[ProcedureCode],
							[ProcedureName],
							[Description],
							[CreatedDate],
							[CreatedUserID],
							[ModifiedDate],
							[ModifiedUserID],
							[TypeOfServiceCode],
							GETDATE()
						FROM dbo.ProcedureCodeDictionary S_PCD
						WHERE S_PCD.ProcedureCodeDictionaryID NOT IN
							(	SELECT KareoProcedureCodeDictionaryID
								FROM ' + @DatabaseName + '.dbo.ProcedureCodeDictionary
								WHERE KareoProcedureCodeDictionaryID IS NOT NULL
							)'
							
			EXEC(@sql)
			
			--Insert records back INTO shared that were recently deleted, but then used
			--but the customer
			
			SET @sql =	'SET IDENTITY_INSERT dbo.ProcedureCodeDictionary ON 
									
						INSERT INTO [dbo].[ProcedureCodeDictionary] (
							[ProcedureCodeDictionaryID] /* Identity Field */ ,
							[ProcedureCode],
							[ProcedureName],
							[Description],
							[CreatedDate],
							[CreatedUserID],
							[ModifiedDate],
							[ModifiedUserID],
							[TypeOfServiceCode]
						)
						SELECT
							[KareoProcedureCodeDictionaryID] /* Identity Field */ ,
							[ProcedureCode],
							[ProcedureName],
							[Description],
							[CreatedDate],
							[CreatedUserID],
							[ModifiedDate],
							[ModifiedUserID],
							[TypeOfServiceCode]
						FROM ' + @DatabaseName + '.[dbo].[ProcedureCodeDictionary] 
						WHERE KareoProcedureCodeDictionaryID IS NOT NULL
							AND KareoProcedureCodeDictionaryID NOT IN
							(	SELECT ProcedureCodeDictionaryID
								FROM dbo.ProcedureCodeDictionary
							)	
			SET IDENTITY_INSERT dbo.ProcedureCodeDictionary OFF'
			
			EXEC(@sql)
				
						--Delete the customer database records that are no longer in the shared database
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[ProcedureCodeDictionary] 
						WHERE KareoProcedureCodeDictionaryID IS NOT NULL
							AND KareoProcedureCodeDictionaryID NOT IN
							(	SELECT ProcedureCodeDictionaryID
								FROM dbo.ProcedureCodeDictionary
							)'	
	
			EXEC(@sql)	
		END
		FETCH NEXT FROM sync_proc_cursor INTO @DatabaseName
	END
	CLOSE sync_proc_cursor
	DEALLOCATE sync_proc_cursor

	PRINT 'Update SubscriptionLastRun'
	--Update the last push subscription last run
	UPDATE dbo.SubscriptionLastRun
		SET LastUpdatedDate = GETDATE()
	WHERE TableName = 'ProcedureCodeDictionary'

END
--SELECT @@TRANCOUNT
--SELECT *
--FROM SubscriptionLastRun
--ROLLBACK

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
--
--===========================================================================
CREATE PROCEDURE dbo.Shared_SyncJob_ProcedureModifier 
AS
BEGIN
	DECLARE @LastUpdated datetime
	
	SELECT @LastUpdated = SLR.LastUpdatedDate
	FROM dbo.SubscriptionLastRun SLR
	WHERE SLR.TableName = 'ProcedureModifier'

	DECLARE @DatabaseName varchar(128)
	DECLARE @sql varchar(8000)
	
	DECLARE sync_proc_cursor CURSOR
	READ_ONLY
	FOR 	SELECT DISTINCT C.DatabaseName
			FROM dbo.Customer C
	
	OPEN sync_proc_cursor
	
	FETCH NEXT FROM sync_proc_cursor INTO @DatabaseName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			PRINT 'Processing for database: ' + @DatabaseName
					--update the records that are common and have changed
			SET @sql = 'UPDATE	C_PCD
						SET	[ProcedureModifierCode] = S_PCD.ProcedureModifierCode,
							[ModifierName] = S_PCD.ModifierName,
							[ModifiedDate] = S_PCD.ModifiedDate,
							[ModifiedUserID] = S_PCD.ModifiedUserID,
							KareoLastModifiedDate = GETDATE()
						FROM ' + @DatabaseName + '.dbo.ProcedureModifier C_PCD
							INNER JOIN dbo.ProcedureModifier S_PCD
							ON C_PCD.KareoProcedureModifierCode = S_PCD.ProcedureModifierCode
						WHERE S_PCD.ModifiedDate >= ''' + CAST(@LastUpdated AS varchar(40)) + ''''
						
			EXEC(@sql)	
						--insert the records that do NOT exist in the customer database
			SET @sql = 'INSERT INTO ' + @DatabaseName + '.[dbo].[ProcedureModifier] (
							[ProcedureModifierCode],
							[KareoProcedureModifierCode],
							[ModifierName],
							[CreatedDate],
							[CreatedUserID],
							[ModifiedDate],
							[ModifiedUserID],
							[KareoLastModifiedDate])
						SELECT 	[ProcedureModifierCode],
							[ProcedureModifierCode],
							[ModifierName],
							[CreatedDate],
							[CreatedUserID],
							[ModifiedDate],
							[ModifiedUserID],
							GETDATE()
						FROM dbo.ProcedureModifier S_PCD
						WHERE S_PCD.ProcedureModifierCode NOT IN
							(	SELECT KareoProcedureModifierCode
								FROM ' + @DatabaseName + '.dbo.ProcedureModifier
								WHERE KareoProcedureModifierCode IS NOT NULL
							)'
							
			EXEC(@sql)
						--Delete the customer database records that are no longer in the shared database
			SET @sql = 'DELETE ' + @DatabaseName + '.[dbo].[ProcedureModifier] 
						WHERE KareoProcedureModifierCode IS NOT NULL
							AND KareoProcedureModifierCode NOT IN
							(	SELECT ProcedureModifierCode
								FROM dbo.ProcedureModifier
							)'	
	
			EXEC(@sql)	
		END
		FETCH NEXT FROM sync_proc_cursor INTO @DatabaseName
	END
	CLOSE sync_proc_cursor
	DEALLOCATE sync_proc_cursor

	--Update the last push subscription last run
	UPDATE dbo.SubscriptionLastRun
		SET LastUpdatedDate = GETDATE()
	WHERE TableName = 'ProcedureModifier'

END
--SELECT @@TRANCOUNT
--SELECT *
--FROM SubscriptionLastRun
--ROLLBACK


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC usp_CONFIGURE_ReplicationSizeForBlobs 

   @NewSize int = 100000000

/*
* Sets the 'max text repl size' instance wide configuration setting
* that governs the maximum size of an image, text, or ntext column
* in a replicated table.
*
* Example:
exec usp_CONFIGURE_ReplicationSizeForBlobs default
**********************************************************************/
AS 

    print 'Old size'
    exec sp_configure 'max text repl size' 
    
    print ' Setting new size'
    exec sp_configure 'max text repl size', @NewSize
    
    print 'Reconfiguring'
    RECONFIGURE WITH OVERRIDE
    
    print 'New size'
    exec sp_configure 'max text repl size'

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO


/*
ALTER TABLE [dbo].[Users] ADD
	CONSTRAINT [FK_Users_UserPassword_UserPasswordID] FOREIGN KEY
	(
		[UserPasswordID]
	) REFERENCES [dbo].[UserPassword] (
		[UserPasswordID]
	)
GO
*/

