IF NOT EXISTS ( SELECT  * FROM information_schema.columns WHERE   table_name = 'Patient' AND column_name = 'PhonecallRemindersEnabled' ) 
BEGIN
	ALTER TABLE dbo.Patient ADD PhonecallRemindersEnabled BIT NOT NULL DEFAULT (0) WITH VALUES	
END
