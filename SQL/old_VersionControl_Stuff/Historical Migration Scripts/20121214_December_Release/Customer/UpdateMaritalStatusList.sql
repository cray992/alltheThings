
DISABLE TRIGGER TR_Patient_HL7_IUD ON Patient
GO

UPDATE dbo.MaritalStatus
SET LongName = 'Never Married'
WHERE MaritalStatus = 'S'

UPDATE dbo.MaritalStatus
SET LongName = 'Polygamous'
WHERE MaritalStatus = 'P'

UPDATE dbo.Patient
SET MaritalStatus = 'S'
WHERE MaritalStatus IN ('','U')
OR MaritalStatus IS NULL

DELETE FROM dbo.MaritalStatus 
WHERE MaritalStatus IN ('','U')

GO
ENABLE TRIGGER TR_Patient_HL7_IUD ON Patient