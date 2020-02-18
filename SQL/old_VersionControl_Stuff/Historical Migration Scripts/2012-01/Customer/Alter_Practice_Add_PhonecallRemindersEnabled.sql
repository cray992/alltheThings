IF NOT EXISTS ( SELECT  * FROM information_schema.columns WHERE   table_name = 'Practice' AND column_name = 'PhonecallRemindersEnabled' ) 
BEGIN
	ALTER TABLE dbo.Practice ADD PhonecallRemindersEnabled BIT NOT NULL DEFAULT (0) WITH VALUES	
END

