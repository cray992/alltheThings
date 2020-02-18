
CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_PatientID_PracticeID_INC_ClaimTransactionTypeCode_ClaimID] on [dbo].[ClaimTransaction]
(
	[PatientID] ASC,
	[PracticeID]
)
INCLUDE ([ClaimTransactionTypeCode], [ClaimID])