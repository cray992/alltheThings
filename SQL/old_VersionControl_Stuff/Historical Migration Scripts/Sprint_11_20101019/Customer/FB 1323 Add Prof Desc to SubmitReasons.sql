IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SubmitReason' AND COLUMN_NAME = 'ProfessionalName')
BEGIN
	ALTER TABLE SubmitReason
	ADD ProfessionalName varchar(255) NULL
END
GO
 
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SubmitReason' AND COLUMN_NAME = 'InstitutionalName')
BEGIN
	EXEC sp_rename @objname = N'SubmitReason.Name',
		@newname = N'InstitutionalName',
		@objtype = N'COLUMN'
END
GO

UPDATE SubmitReason
SET ProfessionalName = 'Original Claim'

UPDATE SubmitReason
SET ProfessionalName = 'Replacement of Prior Claim'
WHERE Code = '7'

UPDATE SubmitReason
SET ProfessionalName = 'Void/Cancel of Prior Claim'
WHERE Code = '8'
