IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Active'  
            and Object_ID = Object_ID(N'Patient'))
BEGIN
	ALTER TABLE dbo.Patient
	DROP Column Active
END
GO

BEGIN TRAN

ALTER TABLE dbo.Patient
ADD Active BIT NOT NULL CONSTRAINT [DF_Patient_Active] DEFAULT(1) WITH VALUES

COMMIT TRAN

GO