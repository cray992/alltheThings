IF NOT EXISTS(select * from sys.columns where Name = N'EStatementsBillingSequenceID'  
            AND Object_ID = Object_ID(N'Practice'))
BEGIN

	ALTER TABLE Practice
	ADD EStatementsBillingSequenceID int NULL,
		EStatementsBillingDelay INT NULL
	
	ALTER TABLE [dbo].[Practice]  WITH CHECK ADD  CONSTRAINT [FK_Practice_BillingSequence] FOREIGN KEY([EStatementsBillingSequenceID])
	REFERENCES [dbo].[BillingSequence] ([BillingSequenceID])

END
GO
