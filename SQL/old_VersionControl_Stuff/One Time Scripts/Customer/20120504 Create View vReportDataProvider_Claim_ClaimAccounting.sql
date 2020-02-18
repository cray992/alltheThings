



SET ARITHABORT ON
GO

SET CONCAT_NULL_YIELDS_NULL ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_WARNINGS ON
GO

SET NUMERIC_ROUNDABORT OFF
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vReportDataProvider_Claim_ClaimAccounting]'))
Begin
Drop View vReportDataProvider_Claim_ClaimAccounting
End
Go

Create View [dbo].vReportDataProvider_Claim_ClaimAccounting
WITH SCHEMABINDING
as

Select  C.ClaimID, C.PracticeId,C.EncounterProcedureID, CA.ProviderID, CA.ClaimTransactionID, CA.ClaimTransactionTypeCode,CA.ProcedureCount, 
CA.Amount, CA.ARAmount, CA.PostingDate as CA_PostingDate, CA.PaymentID
from dbo.Claim AS C  
Inner Join dbo.ClaimAccounting AS ca On Ca.ClaimId=c.ClaimId And CA.PracticeId=c.PracticeID
 
GO



/****** Object:  Index [CX_vwReporting_Claim_ClaimAccounting_ClaimID_PracticeID_ClaimTransactionID]    Script Date: 05/04/2012 10:20:29 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[vReportDataProvider_Claim_ClaimAccounting]') AND name = N'CX_vReportDataProvider_Claim_ClaimAccounting_ClaimID_PracticeID_ClaimTransactionID')
Begin
Drop Index [IX_vReportDataProvider_Claim_ClaimAccounting_ClaimTransactionTypeCode_Posting_Date_INC_ClaimID_PracticeID] ON [dbo].[vReportDataProvider_Claim_ClaimAccounting] 
End

CREATE UNIQUE CLUSTERED INDEX [CX_vReportDataProvider_Claim_ClaimAccounting_ClaimID_PracticeID_ClaimTransactionID] ON [dbo].[vReportDataProvider_Claim_ClaimAccounting] 
(
	[ClaimID] ASC,
	[PracticeId] ASC,
	[ClaimTransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


SET ARITHABORT ON
GO

SET CONCAT_NULL_YIELDS_NULL ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_WARNINGS ON
GO

SET NUMERIC_ROUNDABORT OFF
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[vReportDataProvider_Claim_ClaimAccounting]') AND name = N'IX_vReportDataProvider_Claim_ClaimAccounting_ClaimTransactionTypeCode_Posting_Date_INC_ClaimID_PracticeID')
Begin
Drop Index [IX_vReportDataProvider_Claim_ClaimAccounting_ClaimTransactionTypeCode_Posting_Date_INC_ClaimID_PracticeID] ON [dbo].[vReportDataProvider_Claim_ClaimAccounting] 
End




CREATE NONCLUSTERED INDEX [IX_vReportDataProvider_Claim_ClaimAccounting_ClaimTransactionTypeCode_Posting_Date_INC_ClaimID_PracticeID] ON [dbo].[vReportDataProvider_Claim_ClaimAccounting] 
(
	[ClaimTransactionTypeCode] ASC,
	[CA_PostingDate] ASC
)
INCLUDE ( [ClaimID],
[PracticeId],
[EncounterProcedureID],
[Amount],
[PaymentID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

