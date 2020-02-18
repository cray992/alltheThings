



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vReportDataProvider_Claim_Payments]'))
Drop View vReportDataProvider_Claim_Payments
Go


SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO

Create View [dbo].[vReportDataProvider_Claim_Payments]
WITH SCHEMABINDING
as





Select  C.ClaimID, C.PracticeId,C.EncounterProcedureID, CA.ProviderID, CA.ClaimTransactionID, CA.ClaimTransactionTypeCode,CA.ProcedureCount, CA.Amount, CA.ARAmount, CA.PostingDate as CA_PostingDate, 
 P.PaymentId, P.PaymentAmount, P.PayerTypeCode, P.PayerID, P.PostingDate Pay_PostingDate, P.BatchID
from dbo.Claim AS C  
Inner Join dbo.ClaimAccounting AS ca On Ca.ClaimId=c.ClaimId And CA.PracticeId=c.PracticeID
Inner Join dbo.Payment AS P on ca.PracticeID=P.PracticeId And Ca.PaymentId=p.PaymentID
 
GO




/****** Object:  Index [CX_vwReporting_Claim_Payments_ClaimID_PracticeID_ClaimTransactionID]    Script Date: 05/04/2012 10:15:07 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[vReportDataProvider_Claim_Payments]') AND name = N'CX_vwReporting_Claim_Payments_ClaimID_PracticeID_ClaimTransactionID')
CREATE UNIQUE CLUSTERED INDEX [CX_vReportDataProvider_Claim_Payments_ClaimID_PracticeID_ClaimTransactionID] ON [dbo].[vReportDataProvider_Claim_Payments] 
(
	[ClaimID] ASC,
	[PracticeId] ASC,
	[ClaimTransactionID] ASC,
	[PaymentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


/****** Object:  Index [IX_Reporting_Claim_Payments_ClaimTransactionTypeCode_INC_PracticeID_Amount_PostingDate_PaymentID_Pay_PostingDate]    Script Date: 05/04/2012 10:15:15 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[vReportDataProvider_Claim_Payments]') AND name = N'IX_Reporting_Claim_Payments_ClaimTransactionTypeCode_INC_PracticeID_Amount_PostingDate_PaymentID_Pay_PostingDate')
CREATE NONCLUSTERED INDEX [IX_vReportDataProvider_Claim_Payments_ClaimTransactionTypeCode_INC_PracticeID_Amount_PostingDate_PaymentID_Pay_PostingDate] ON [dbo].[vReportDataProvider_Claim_Payments] 
(
	[ClaimTransactionTypeCode] ASC
)
INCLUDE ( [PracticeId],
[Amount],
[CA_PostingDate],
[PaymentId],
[Pay_PostingDate]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


/****** Object:  Index [IX_Reporting_Claim_Payments_ClaimTransactionTypeCode_PaymentAmount]    Script Date: 05/04/2012 10:16:56 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[vReportDataProvider_Claim_Payments]') AND name = N'IX_vReportDataProvider_Claim_Payments_ClaimTransactionTypeCode_PaymentAmount')
CREATE NONCLUSTERED INDEX [IX_vReportDataProvider_Claim_Payments_ClaimTransactionTypeCode_PaymentAmount] ON [dbo].[vReportDataProvider_Claim_Payments] 
(
	[ClaimTransactionTypeCode] ASC,
	[PaymentAmount] ASC
)
INCLUDE ( [PracticeId],
[Amount],
[CA_PostingDate],
[PaymentId],
[Pay_PostingDate]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

