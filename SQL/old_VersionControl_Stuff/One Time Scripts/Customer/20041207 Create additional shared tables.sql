/* ------------------------------------------------------------

   DESCRIPTION:  Structure Definition Script for Object(s) 

	TABLEs: 
	[dbo].[BillingForm], 
	[dbo].[GroupNumberType], 
	[dbo].[HCFADiagnosisReferenceFormat], 
	[dbo].[HCFASameAsInsuredFormat]
	[dbo].[InsuranceProgram], 
	[dbo].[ProviderNumberType], 
	[dbo].[TypeOfService]


     Database:  k0.kareo.ent.superbill_shared

   AUTHOR:	Rolland Zeleznik

   DATE:	12/7/2004 11:29:58

   ------------------------------------------------------------ */

-- =======================================================
-- SCRIPT HEADER
-- =======================================================

SET NOEXEC OFF
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- BEGINNING TRANSACTION
BEGIN TRANSACTION
GO

-- =======================================================
-- SCRIPT NON-ORDERED OBJECTS
-- =======================================================

SET ANSI_PADDING OFF
SET ANSI_NULLS ON
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

CREATE TABLE [dbo].[BillingForm] (
    [BillingFormID] int IDENTITY(1,1) CONSTRAINT [PK_BillingForm] PRIMARY KEY,
    [FormType] varchar(50) NOT NULL,
    [FormName] varchar(50) NOT NULL,
    [Transform] text NULL,
    [TIMESTAMP] timestamp NOT NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


SET ANSI_PADDING OFF
SET ANSI_NULLS ON
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

CREATE TABLE [dbo].[GroupNumberType] (
    [GroupNumberTypeID] int IDENTITY(1,1) CONSTRAINT [PK_GroupNumberType] PRIMARY KEY,
    [TypeName] varchar(50) NOT NULL,
    [ANSIReferenceIdentificationQualifier] char(2) NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


SET ANSI_PADDING OFF
SET ANSI_NULLS ON
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

CREATE TABLE [dbo].[HCFADiagnosisReferenceFormat] (
    [HCFADiagnosisReferenceFormatCode] char(1) CONSTRAINT [PK_HCFADiagnosisReferenceFormat] PRIMARY KEY,
    [FormatName] varchar(100) NOT NULL,
    [TIMESTAMP] timestamp NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


SET ANSI_PADDING OFF
SET ANSI_NULLS ON
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

CREATE TABLE [dbo].[HCFASameAsInsuredFormat] (
    [HCFASameAsInsuredFormatCode] char(1) CONSTRAINT [PK_HCFASameAsInsuredFormat] PRIMARY KEY,
    [FormatName] varchar(100) NOT NULL,
    [TIMESTAMP] timestamp NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


SET ANSI_PADDING OFF
SET ANSI_NULLS ON
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

CREATE TABLE [dbo].[InsuranceProgram] (
    [InsuranceProgramCode] char(1) CONSTRAINT [PK_InsuranceProgram] PRIMARY KEY,
    [ProgramName] varchar(150) NOT NULL,
    [TIMESTAMP] timestamp NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


SET ANSI_PADDING OFF
SET ANSI_NULLS ON
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

CREATE TABLE [dbo].[ProviderNumberType] (
    [ProviderNumberTypeID] int IDENTITY(1,1) CONSTRAINT [PK_BillingIdentifier] PRIMARY KEY,
    [TypeName] varchar(50) NOT NULL,
    [ANSIReferenceIdentificationQualifier] char(2) NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


SET ANSI_PADDING OFF
SET ANSI_NULLS ON
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

CREATE TABLE [dbo].[TypeOfService] (
    [TypeOfServiceCode] char(2) CONSTRAINT [PK_TypeOfService] PRIMARY KEY,
    [Description] varchar(100) NOT NULL,
    [TIMESTAMP] timestamp NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

-- =======================================================
-- SCRIPT FOOTER
-- =======================================================

-- COMMITTING TRANSACTION
PRINT 'Script successfully completed'
COMMIT TRANSACTION
GO
SET NOEXEC OFF
GO


