CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Assignments_PracticeID_LastAssignment_Status_InsurancePolicyID_INC_ClaimID_InsuranceCompanyPlanID_PatientID
ON [dbo].[ClaimAccounting_Assignments] ([PracticeID], [LastAssignment], [Status], [InsurancePolicyID])
INCLUDE ([ClaimID], [InsuranceCompanyPlanID], [PatientID])
GO