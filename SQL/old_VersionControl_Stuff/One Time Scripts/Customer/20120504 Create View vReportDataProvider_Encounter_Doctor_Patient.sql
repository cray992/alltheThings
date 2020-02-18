IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vReportDataProvider_Encounter_Doctor_Patient]'))
Drop View vReportDataProvider_Encounter_Doctor_Patient
Go

Create View [dbo].[vReportDataProvider_Encounter_Doctor_Patient]
WITH SCHEMABINDING
as

Select ep.PracticeID, e.EncounterID,ep.EncounterProcedureID, d.DoctorID, pc.PatientCaseID,
 ep.ProcedureDateOfService, e.PostingDate EncounterDate, e.PatientID
from dbo.EncounterProcedure ep
				INNER JOIN dbo.Encounter e  ON e.PracticeID = ep.PracticeID AND e.EncounterID = ep.EncounterID
				INNER JOIN dbo.Doctor d  ON d.PracticeID = ep.PracticeID AND d.DoctorID = e.DoctorID
				INNER JOIN dbo.PatientCase pc  ON pc.PracticeID = ep.PracticeID AND pc.PatientCaseID = e.PatientCaseID
				
				
				
				
GO				
Create Unique Clustered Index CX_PracticeID_EncounterProcedureID On vReportDataProvider_Encounter_Doctor_Patient(PracticeID, EncounterProcedureID)


				
				
		
				
				
				
				
				
				