IF EXISTS(select * from sys.columns where Name = N'EncounterDiagnosisID5'  
            AND Object_ID = Object_ID(N'EncounterProcedure'))
BEGIN
	ALTER TABLE dbo.EncounterProcedure
	DROP COLUMN
	EncounterDiagnosisID5
	,EncounterDiagnosisID6
	,EncounterDiagnosisID7
	,EncounterDiagnosisID8
END