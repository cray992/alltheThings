
GO

SET ANSI_PADDING ON


GO
IF EXISTS(Select * From Sys.Indexes where name='IX_BillClaim_ClaimID_BillID_BillBatchTypeCode_ClaimTransactionID')
Return
ELSE


CREATE NONCLUSTERED INDEX [IX_BillClaim_ClaimID_BillID_BillBatchTypeCode_ClaimTransactionID] ON [dbo].[BillClaim]
(
	[ClaimID] ASC
)
INCLUDE ( 	[BillID],
	[BillBatchTypeCode],
	[ClaimTransactionID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

IF EXISTS(Select * From Sys.Indexes where name='IX_ClaimAccounting_PracticeID_ClaimTransactionTypeCode_INC_ClaimID_Amount_PostingDate_PaymentId')
Return
ELSE


CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_PracticeID_ClaimTransactionTypeCode_INC_ClaimID_Amount_PostingDate_PaymentId] ON [dbo].[ClaimAccounting]
(
	[PracticeID] ASC,
	[ClaimTransactionTypeCode]ASC

)
INCLUDE ( 	[Amount], 
			[PostingDate], 
			[PaymentID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
IF EXISTS(Select * From Sys.Indexes where name='IX_ClaimAccounting_Assignments_LastAssignment_INC_PracticeID_ClaimID_InsuranceCompanyPlanID_InsurancePolicyID')
Return
ELSE
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_Assignments_LastAssignment_INC_PracticeID_ClaimID_InsuranceCompanyPlanID_InsurancePolicyID] ON [dbo].[ClaimAccounting_Assignments]
(
	[LastAssignment] ASC


)
INCLUDE ( 	[PracticeID], [ClaimID], [InsurancePolicyID], [InsuranceCompanyPlanID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

IF EXISTS(Select * From Sys.Indexes where name='IX_ClaimTransaction_ClaimTransactionTypeCode_CreatedDate')
Begin
Drop index [IX_ClaimTransaction_ClaimTransactionTypeCode_CreatedDate] ON ClaimTransaction
END
CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_ClaimTransactionTypeCode_CreatedDate] ON [dbo].[ClaimTransaction]
(
	[ClaimTransactionTypeCode] ASC,
	[CreatedDate] ASC
)
INCLUDE ( 	[ClaimID],
	[PracticeID],
	[PostingDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]

GO
IF EXISTS(Select * From Sys.Indexes where name='IX_ClaimTransaction_ClaimTransactionTypeCode_INC_ClaimTransactionID_ClaimID_PracticeID_PostingDate')
Return
Else


CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_ClaimTransactionTypeCode_INC_ClaimTransactionID_ClaimID_PracticeID_PostingDate] ON [dbo].[ClaimTransaction]
(
	[ClaimTransactionTypeCode] ASC
	
)
INCLUDE ( 	
	[ClaimTransactionID],
	[ClaimID],
	[PracticeID],
	[PostingDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]

GO
IF EXISTS(Select * From Sys.Indexes where name='IX_ClaimTransaction_PaymentID_overrideClosingDate_INC_ClaimTransactionID_ClaimID_PracticeID')
Return
Else


CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_PaymentID_overrideClosingDate_INC_ClaimTransactionID_ClaimID_PracticeID] ON [dbo].[ClaimTransaction]
(
	PaymentID ASC,
	overrideClosingDate ASC
	
)
INCLUDE ( 	
	[ClaimTransactionID],
	[ClaimID],
	[PracticeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]

GO

IF EXISTS(Select * From Sys.Indexes where name='IX_DMSDocument_PracticeID_INC_DMSDocumentID_DocumentName_DocumentLabelTypeID_DocumentStatusTypeID_CreatedDate')
Return
Else

CREATE NONCLUSTERED INDEX [IX_PracticeID_INC_DMSDocumentID_DocumentName_DocumentLabelTypeID_DocumentStatusTypeID_CreatedDate] ON [dbo].[DMSDocument]
(
	[PracticeID] ASC
)
INCLUDE ( 	[DMSDocumentID],
	[DocumentName],
	[DocumentLabelTypeID],
	[DocumentStatusTypeID],
	[CreatedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO



IF EXISTS(Select * From Sys.Indexes where name='IX_DMSDocumentToRecordAssociation_DMSDocumentID')
Return
Else

CREATE NONCLUSTERED INDEX [IX_DMSDocumentToRecordAssociation_DMSDocumentID] ON [dbo].[DMSDocumentToRecordAssociation]
(
	[DMSDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)




GO

IF EXISTS(Select * From Sys.Indexes where name='IX_Payment_PracticeID_PayerTypeCode_INC_PaymentID_PaymentAmount_PayerID')
Return
Else

CREATE NONCLUSTERED INDEX IX_Payment_PracticeID_PayerTypeCode_INC_PaymentID_PaymentAmount_PayerID ON [dbo].[Payment]
(
	[PracticeID] ASC,
	[PayerTypeCode] ASC,
	[PostingDate] ASC
)
INCLUDE ( 	[PaymentID],
	[PaymentAmount],
	[PayerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

IF EXISTS(Select * From Sys.Indexes where name='IX_Payment_SourceEncounterID_AppointmentID_SourceAppointmentID_INC_PaymentID_AppointmentStartDate')
Return
Else

CREATE NONCLUSTERED INDEX [IX_Payment_SourceEncounterID_AppointmentID_SourceAppointmentID_INC_PaymentID_AppointmentStartDate] ON [dbo].[Payment]
(
	[SourceEncounterID] ASC,
	[AppointmentID] ASC,
	[SourceAppointmentID] ASC
)
INCLUDE ( 	[PaymentID],
	[AppointmentStartDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

