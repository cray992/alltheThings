IF NOT EXISTS (select * from information_schema.columns WHERE table_name = 'EnrollmentOrder' and column_name = 'AssistedEnrollments')
BEGIN
	ALTER TABLE [dbo].[EnrollmentOrder] ADD [AssistedEnrollments] BIT CONSTRAINT DF_EnrollmentOrder_AssistedEnrollments DEFAULT 0 NOT NULL
END
GO