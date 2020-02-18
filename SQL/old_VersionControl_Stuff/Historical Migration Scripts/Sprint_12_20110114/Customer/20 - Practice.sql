IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CustomNameText'  
            AND Object_ID = Object_ID(N'Practice'))

BEGIN

	ALTER TABLE dbo.Practice
	ADD CustomNameText varchar(255) NULL;

END

