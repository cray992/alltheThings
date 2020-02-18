IF EXISTS(SELECT * FROM Sys.objects AS o WHERE o.name='ClaimHistory' AND type='U')
DROP TABLE ClaimHistory 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ARITHABORT ON
GO

CREATE TABLE [dbo].[ClaimHistory](
	[ClaimID] [int]  NOT NULL PRIMARY KEY,
	[PracticeID] [int] NOT NULL,
	[ClaimStatusCode] [char](1) NOT NULL,
	[PatientID] [int] NULL,
	[ReleaseSignatureSourceCode] [char](1) NULL,
	[EncounterProcedureID] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[TIMESTAMP] [timestamp] NULL,
	[LocalUseData] [varchar](25) NULL,
	[ReferringProviderIDNumber] [varchar](32) NULL,
	[NonElectronicOverrideFlag] [bit] NULL,
	[ClearinghouseTrackingNumber] [varchar](64) NULL,
	[PayerTrackingNumber] [varchar](64) NULL,
	[ClearinghouseProcessingStatus] [varchar](1) NULL,
	[PayerProcessingStatus] [varchar](256) NULL,
	[ClearinghousePayer] [varchar](64) NULL,
	[ClearinghousePayerReported] [varchar](64) NULL,
	[PayerProcessingStatusTypeCode] [char](3) NULL,
	[CurrentPayerProcessingStatusTypeCode] [char](3) NULL,
	[CurrentClearinghouseProcessingStatus] [varchar](1) NULL,
	[CreatedUserID] [int] NULL,
	[ModifiedUserID] [int] NULL,
	[DKProcedureDateOfServiceID] [int] NULL,
	[SearchIndex] VARCHAR(256),
    [DateDeleted] DateTime DEFAULT (GETDATE()))
