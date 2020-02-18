DISABLE TRIGGER TR_Patient_HL7_IUD ON Patient
GO


UPDATE Patient
SET Gender = 'U'
WHERE Gender IS NULL OR Gender = ''

DELETE FROM dbo.Gender
WHERE Gender = ''


GO
ENABLE TRIGGER TR_Patient_HL7_IUD ON Patient