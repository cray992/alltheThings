-- Delete old index
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Assignments]') AND name = N'IX_ClaimAccounting_Assignments_PracticeID_LastAssignment_Status_InsurancePolicyID_INC_ClaimID_InsuranceCompanyPlanID_PatientID')
BEGIN
	DROP INDEX [IX_ClaimAccounting_Assignments_PracticeID_LastAssignment_Status_InsurancePolicyID_INC_ClaimID_InsuranceCompanyPlanID_PatientID] ON [dbo].[ClaimAccounting_Assignments] WITH ( ONLINE = OFF )
END

-- Delete new index, should it already exist
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Assignments]') AND name = N'IX_ClaimAccounting_Assignments_PracticeID_ClaimID_LastAssignment_INC_Status_InsuranceCompanyPlanID_InsurancePolicyID_PatientID')
BEGIN
	DROP INDEX [IX_ClaimAccounting_Assignments_PracticeID_ClaimID_LastAssignment_INC_Status_InsuranceCompanyPlanID_InsurancePolicyID_PatientID] ON [dbo].[ClaimAccounting_Assignments] WITH ( ONLINE = OFF )
END


CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_Assignments_PracticeID_ClaimID_LastAssignment_INC_Status_InsuranceCompanyPlanID_InsurancePolicyID_PatientID] ON [dbo].[ClaimAccounting_Assignments] 
(
	[PracticeID] ASC,
	[ClaimID] ASC,
	[LastAssignment] ASC
)
INCLUDE ([Status], [InsuranceCompanyPlanID], [InsurancePolicyID], [PatientID])

