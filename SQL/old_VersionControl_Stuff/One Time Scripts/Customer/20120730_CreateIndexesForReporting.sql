
IF Exists(Select *
from Sys.indexes where name='IX_ClaimAcounting_Billings_Posting_Date_INC_PracticeID_ClaimID_ClaimTransactionID_BatchType')
Return


CREATE NONCLUSTERED INDEX [IX_ClaimAcounting_Billings_Posting_Date_INC_PracticeID_ClaimID_ClaimTransactionID_BatchType]
ON [dbo].[ClaimAccounting_Billings] ([PostingDate])
INCLUDE ([PracticeID],[ClaimID],[ClaimTransactionID],[BatchType])
GO


IF Exists(Select *
from Sys.indexes where name='IX_ClaimAccount_Assignments_LastAssignment_PostingDate_INC_PracticeID_ClaimID_InsurancePolicyId_InsuranceCompanyPlanID')
Return

CREATE NONCLUSTERED INDEX [IX_ClaimAccount_Assignments_LastAssignment_PostingDate_INC_PracticeID_ClaimID_InsurancePolicyId_InsuranceCompanyPlanID]
ON [dbo].[ClaimAccounting_Assignments] ([LastAssignment],[PostingDate])
INCLUDE ([PracticeID],[ClaimID],[InsurancePolicyID],[InsuranceCompanyPlanID])
GO

