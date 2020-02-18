IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='Guid' AND COLUMNS.TABLE_NAME='Patient')
BEGIN
EXECUTE sp_rename N'dbo.Patient.Guid', N'PatientGuid', 'COLUMN'
END