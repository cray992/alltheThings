
IF Exists(Select * from sys.Indexes where name='IX_ClaimAccounting_Assignments_PostingDate_INC_PracticeID_ClaimID_ClaimTransactionID_InsPolicyID_InsCompanyPlanID')
Drop Index IX_ClaimAccounting_Assignments_PostingDate ON [dbo].[ClaimAccounting_Assignments]

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Assignments_PostingDate_INC_PracticeID_ClaimID_ClaimTransactionID_InsPolicyID_InsCompanyPlanID
ON [dbo].[ClaimAccounting_Assignments] ([PostingDate])
INCLUDE ([PracticeID],[ClaimID],[ClaimTransactionID],[InsurancePolicyID],[InsuranceCompanyPlanID])
GO

