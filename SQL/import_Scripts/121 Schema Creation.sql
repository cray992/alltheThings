if exists (select * from dbo.sysobjects where id = object_id(N'[insurance-carrier-list]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [insurance-carrier-list]
GO

CREATE TABLE [insurance-carrier-list] (
	[VendorID] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PlanName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Address] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Zip] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Attention] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ElectronicBillingNo] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col011] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[new-fee-schedule]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [new-fee-schedule]
GO

CREATE TABLE [new-fee-schedule] (
	[FeeID] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Description] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FeeAmount] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PracticeName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PracticeID] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Gender] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col007] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col008] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col009] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col010] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col011] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col012] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Col013] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[patient-list-lambrecht]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [patient-list-lambrecht]
GO


CREATE TABLE [patient-list-lambrecht] (
	[VendorID] [int] NULL ,
	[LastName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FirstName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MiddleName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Address] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Zip] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HomePhone] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BusinessPhone] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InsuranceID] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SecondaryID] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InsuranceCode] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PatientAccountNo] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SecondaryInsuranceCode] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProviderID] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BirthDate] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Status] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SocialSecurityNo] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Gender] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[patient-list-martin]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [patient-list-martin]
GO

CREATE TABLE [patient-list-martin] (
	[VendorID] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LastName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FirstName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MiddleName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Address] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Zip] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HomePhone] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BusinessPhone] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InsuranceID] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SecondaryID] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InsuranceCode] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PatientAccountNo] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SecondaryInsuranceCode] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProviderID] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BirthDate] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Status] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SocialSecurityNo] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Gender] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO