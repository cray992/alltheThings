/* ------------------------------------------------------------

   DESCRIPTION:  Structure Definition Script for Object(s) 

	TABLEs: [dbo].[ClearinghousePayersList], [dbo].[DiagnosisCodeDictionary], [dbo].[ProcedureCodeDictionary]
	[dbo].[ProcedureModifier]


     Database:  k0.kareo.ent.superbill_0001_dev

   AUTHOR:	

   DATE:	12/6/2004 16:35:15

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

CREATE TABLE [dbo].[ClearinghousePayersList] (
    [ClearinghousePayerID] int IDENTITY(1,1) CONSTRAINT [PK_ClearinghousePayersList] PRIMARY KEY,
    [ClearinghouseID] int NULL,
    [PayerNumber] varchar(32) NULL,
    [Name] varchar(1000) NULL,
    [Notes] varchar(1000) NULL,
    [StateSpecific] varchar(16) NULL,
    [IsPaperOnly] bit NOT NULL,
    [IsGovernment] bit NOT NULL,
    [IsCommercial] bit NOT NULL,
    [IsParticipating] bit NOT NULL,
    [IsProviderIdRequired] bit NOT NULL,
    [IsEnrollmentRequired] bit NOT NULL,
    [IsAuthorizationRequired] bit NOT NULL,
    [IsTestRequired] bit NOT NULL,
    [ResponseLevel] int NULL,
    [IsNewPayer] bit NOT NULL,
    [DateNewPayerSince] datetime NULL,
    [CreatedDate] datetime NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [TIMESTAMP] timestamp NULL,
    [Active] bit NOT NULL,
    [IsModifiedPayer] bit NOT NULL,
    [DateModifiedPayerSince] datetime NULL
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

CREATE TABLE [dbo].[DiagnosisCodeDictionary] (
    [DiagnosisCodeDictionaryID] int IDENTITY(1,1) CONSTRAINT [PK_DiagnosisCodeDictionary] PRIMARY KEY,
    [DiagnosisCode] varchar(16) NOT NULL,
    [DiagnosisName] varchar(100) NULL,
    [Description] varchar(64) NULL,
    [CreatedDate] datetime NOT NULL,
    [CreatedUserID] int NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [ModifiedUserID] int NOT NULL,
    [RecordTimeStamp] timestamp NOT NULL
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

CREATE TABLE [dbo].[ProcedureCodeDictionary] (
    [ProcedureCodeDictionaryID] int IDENTITY(1,1) CONSTRAINT [PK_ProcedureCodeDictionary] PRIMARY KEY,
    [ProcedureCode] varchar(16) NOT NULL,
    [ProcedureName] varchar(100) NULL,
    [Description] varchar(64) NULL,
    [CreatedDate] datetime NOT NULL,
    [CreatedUserID] int NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [ModifiedUserID] int NOT NULL,
    [RecordTimeStamp] timestamp NOT NULL,
    [TypeOfServiceCode] char(2) NOT NULL
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

CREATE TABLE [dbo].[ProcedureModifier] (
    [ProcedureModifierCode] varchar(16) CONSTRAINT [PK_ProcedureModifier] PRIMARY KEY,
    [ModifierName] varchar(250) NOT NULL,
    [TIMESTAMP] timestamp NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


-- =======================================================
-- SCRIPT ORDERED OBJECTS AND TABLE FOREIGN KEYS
-- =======================================================

-- -------------------------------------------------------
-- Script for Table: [dbo].[ClearinghousePayersList]
-- -------------------------------------------------------
Print 'Script for Table: [dbo].[ClearinghousePayersList] '
GO

ALTER TABLE [dbo].[ClearinghousePayersList] ADD
   CONSTRAINT [DF_ClearinghousePayersList_IsPaperOnly] DEFAULT (0) FOR [IsPaperOnly],
   CONSTRAINT [DF_ClearinghousePayersList_IsGovernment] DEFAULT (0) FOR [IsGovernment],
   CONSTRAINT [DF_ClearinghousePayersList_IsCommercial] DEFAULT (0) FOR [IsCommercial],
   CONSTRAINT [DF_ClearinghousePayersList_IsParticipating] DEFAULT (0) FOR [IsParticipating],
   CONSTRAINT [DF_ClearinghousePayersList_IsProviderIdRequired] DEFAULT (0) FOR [IsProviderIdRequired],
   CONSTRAINT [DF_ClearinghousePayersList_IsEnrollmentRequired] DEFAULT (0) FOR [IsEnrollmentRequired],
   CONSTRAINT [DF_ClearinghousePayersList_IsAuthorizationRequired] DEFAULT (0) FOR [IsAuthorizationRequired],
   CONSTRAINT [DF_ClearinghousePayersList_IsTestRequired] DEFAULT (0) FOR [IsTestRequired],
   CONSTRAINT [DF_ClearinghousePayersList_IsNewPayer] DEFAULT (0) FOR [IsNewPayer],
   CONSTRAINT [DF_ClearinghousePayersList_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
   CONSTRAINT [DF_ClearinghousePayersList_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
   CONSTRAINT [DF_ClearinghousePayersList_Active] DEFAULT (1) FOR [Active],
   CONSTRAINT [DF_ClearinghousePayersList_IsModifiedPayer] DEFAULT (0) FOR [IsModifiedPayer]
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


-- -------------------------------------------------------
-- Script for Table: [dbo].[DiagnosisCodeDictionary]
-- -------------------------------------------------------
Print 'Script for Table: [dbo].[DiagnosisCodeDictionary] '
GO

ALTER TABLE [dbo].[DiagnosisCodeDictionary] ADD
   CONSTRAINT [DF_DiagnosisCodeDictionary_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
   CONSTRAINT [DF_DiagnosisCodeDictionary_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
   CONSTRAINT [DF_DiagnosisCodeDictionary_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
   CONSTRAINT [DF_DiagnosisCodeDictionary_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


-- -------------------------------------------------------
-- Script for Table: [dbo].[ProcedureCodeDictionary]
-- -------------------------------------------------------
Print 'Script for Table: [dbo].[ProcedureCodeDictionary] '
GO

ALTER TABLE [dbo].[ProcedureCodeDictionary] ADD
   CONSTRAINT [DF_ProcedureCodeDictionary_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
   CONSTRAINT [DF_ProcedureCodeDictionary_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
   CONSTRAINT [DF_ProcedureCodeDictionary_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
   CONSTRAINT [DF_ProcedureCodeDictionary_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID],
   CONSTRAINT [DF_ProcedureCodeDictionary_TypeOfServiceCode] DEFAULT ('01') FOR [TypeOfServiceCode]
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


