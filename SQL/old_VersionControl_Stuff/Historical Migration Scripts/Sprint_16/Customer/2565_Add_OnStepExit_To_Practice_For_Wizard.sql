IF NOT EXISTS(select * from sys.columns where Name = N'OnStepExit'  
            AND Object_ID = Object_ID(N'Practice'))
BEGIN

	ALTER TABLE Practice
	ADD OnStepExit varchar(max) null
	
END
GO