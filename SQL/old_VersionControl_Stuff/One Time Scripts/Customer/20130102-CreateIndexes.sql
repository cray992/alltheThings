IF NOT EXISTS(SELECT * FROM sys.indexes AS i WHERE name='IX_vrep_CEEP_PracticeID_ClaimStatusCode')

CREATE NONCLUSTERED INDEX IX_vrep_CEEP_PracticeID_ClaimStatusCode
ON [dbo].[vReportDataProvider_Claim_Encounter_EncounterProcedure] ([PracticeID],[ClaimStatusCode])
INCLUDE ([EncounterID],[EncounterProcedureID],[PatientCaseID],[EncounterDate],[PatientID],[LocationID],[BatchID],[SchedulingProviderID],[ProcedureCodeDictionaryID],[ProcedureModifier1],[ProcedureModifier2],[ProcedureModifier3],[ProcedureModifier4],[DateOfService],[DoctorID],[ServiceUnitCount],[ClaimID])
GO

