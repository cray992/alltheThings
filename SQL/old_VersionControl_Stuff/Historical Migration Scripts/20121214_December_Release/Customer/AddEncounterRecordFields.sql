IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='PatientCheckedIn' AND COLUMNS.TABLE_NAME='Encounter')
BEGIN
	ALTER TABLE dbo.Encounter
	ADD PatientCheckedIn BIT NULL DEFAULT(0)
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='RoomNumber' AND COLUMNS.TABLE_NAME='Encounter')
BEGIN
	ALTER TABLE dbo.Encounter
	ADD RoomNumber VARCHAR(32) NULL
END