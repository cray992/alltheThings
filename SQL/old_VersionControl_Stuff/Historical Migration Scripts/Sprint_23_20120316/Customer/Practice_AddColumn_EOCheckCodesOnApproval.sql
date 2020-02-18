IF Not Exists(select * from sys.columns where Name = N'EOCheckCodesOnApproval' and Object_ID = Object_ID(N'Practice'))
BEGIN
	ALTER TABLE dbo.Practice ADD EOCheckCodesOnApproval BIT NULL DEFAULT 1 WITH VALUES
END
	