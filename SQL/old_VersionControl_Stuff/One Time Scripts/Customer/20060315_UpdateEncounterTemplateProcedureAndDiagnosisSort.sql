-- Add new columns to the encounter template table
ALTER TABLE dbo.EncounterTemplate ADD
	ProcedureSortByCode BIT NULL
	CONSTRAINT DF_EncounterTemplate_ProcedureSortByCode
	DEFAULT 1 WITH VALUES,
	DiagnosisSortByCode BIT NULL
	CONSTRAINT DF_EncounterTemplate_DiagnosisSortByCode
	DEFAULT 0 WITH VALUES

GO	

