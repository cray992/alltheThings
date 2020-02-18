IF NOT EXISTS(SELECT * FROM Sys.indexes AS i WHERE name ='IX_ClaimTransactionTypeCode_INC_PracticeID_ClaimID_Amount')

CREATE NONCLUSTERED INDEX IX_ClaimTransactionTypeCode_INC_PracticeID_ClaimID_Amount
ON [dbo].[ClaimAccounting] ([ClaimTransactionTypeCode])
INCLUDE ([PracticeID],[ClaimID],PatientID,[Amount],[PostingDate],[PaymentID],[EncounterProcedureID])
GO

