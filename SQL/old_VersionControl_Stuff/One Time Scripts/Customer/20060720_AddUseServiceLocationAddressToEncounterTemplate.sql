IF charindex('_0108_', db_name()) > 0
BEGIN
	ALTER TABLE EncounterTemplate
	ADD UseServiceLocationAddress BIT NOT NULL CONSTRAINT DF_EncounterTemplate_UseServiceLocationAddress DEFAULT (1)
END
ELSE
BEGIN
	ALTER TABLE EncounterTemplate
	ADD UseServiceLocationAddress BIT NOT NULL CONSTRAINT DF_EncounterTemplate_UseServiceLocationAddress DEFAULT (0)
END