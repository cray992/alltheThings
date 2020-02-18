IF NOT EXISTS(select * from sys.columns where Name = N'PreferredPayerSourceID'  
            AND Object_ID = Object_ID(N'Practice'))
BEGIN

	ALTER TABLE Practice
	ADD PreferredPayerSourceID int null
	
END
GO