IF EXISTS(SELECT * FROM Sys.objects AS o WHERE o.name='ClaimAccounting_AssignmentsHistory' AND type='U')
DROP TABLE ClaimAccounting_AssignmentsHistory 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ClaimAccounting_AssignmentsHistory](
	[PracticeID] [int] NULL,
	[ClaimID] [int] NULL,
	[ClaimTransactionID] [int] NULL,
	[InsurancePolicyID] [int] NULL,
	[InsuranceCompanyPlanID] [int] NULL,
	[PatientID] [int] NULL,
	[LastAssignment] [bit] NULL,
	[Status] [bit] NULL,
	[PostingDate] [datetime] NOT NULL,
	[EndPostingDate] [datetime] NULL,
	[LastAssignmentOfEndPostingDate] [bit] NULL,
	[EndClaimTransactionID] [int] NULL,
	[DKPostingDateID] [int] NULL,
	[DKEndPostingDateID] [int] NULL,
	[RelativePrecedence] [int] NULL,
	[DateDeleted] DateTime DEFAULT (GETDATE())
) ON [PRIMARY]

GO
