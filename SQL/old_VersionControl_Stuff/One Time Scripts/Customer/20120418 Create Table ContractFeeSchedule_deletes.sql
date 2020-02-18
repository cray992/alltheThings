


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ContractFeeSchedule_deletes]
 (
	[ContractFeeScheduleID] [int]  NOT NULL,
	[RecordTimeStamp] [varchar](256) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedUserID] [int] NOT NULL,
	[ContractID] [int] NOT NULL,
	[Modifier] [varchar](16) NULL,
	[Gender] [char](1) NULL,
	[StandardFee] [money] NULL,
	[Allowable] [money] NULL,
	[ExpectedReimbursement] [money] NULL,
	[RVU] [decimal](18, 3) NOT NULL,
	[ProcedureCodeDictionaryID] [int] NULL,
	[DiagnosisCodeDictionaryID] [int] NULL,
	[PracticeRVU] [decimal](18, 3) NOT NULL,
	[MalpracticeRVU] [decimal](18, 3) NOT NULL,
	[BaseUnits] [int] NOT NULL,
	[DeleteDate] DATETIME DEFAULT GETDATE()
)



