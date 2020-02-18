-- Populate initial sequences
IF NOT EXISTS (SELECT * FROM dbo.BillingSequence WHERE [Description] = 'Email then print after delay')
	INSERT INTO dbo.BillingSequence(Description) VALUES ('Email then print after delay')
	
IF NOT EXISTS (SELECT * FROM dbo.BillingSequence WHERE [Description] = 'Email and print concurrently')
	INSERT INTO dbo.BillingSequence(Description) VALUES ('Email and print concurrently')
	
IF NOT EXISTS (SELECT * FROM dbo.BillingSequence WHERE [Description] = 'Print only')
	INSERT INTO dbo.BillingSequence(Description) VALUES ('Print only')

IF NOT EXISTS (SELECT * FROM dbo.BillingSequence WHERE [Description] = 'Email only')
	INSERT INTO dbo.BillingSequence(Description) VALUES ('Email only')