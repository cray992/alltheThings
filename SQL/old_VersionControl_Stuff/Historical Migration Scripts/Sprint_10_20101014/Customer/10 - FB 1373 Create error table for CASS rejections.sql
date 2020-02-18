IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bill_StatementCassError')
BEGIN

	CREATE TABLE [dbo].[Bill_StatementCassError](
		[Bill_StatementCassErrorID] [int] IDENTITY(1,1) NOT NULL, 
		[PracticeID] [int] NOT NULL,
		[PatientID] [int] NOT NULL,
		[CreatedDate] [datetime] NOT NULL,
		[RejectedDate] [datetime] NOT NULL
	)
	
	ALTER TABLE [dbo].[Bill_StatementCassError]  ADD CONSTRAINT [PK_Bill_StatementCaseError]
	PRIMARY KEY NONCLUSTERED ([Bill_StatementCassErrorID])
	
	ALTER TABLE [dbo].[Bill_StatementCassError]  WITH CHECK ADD  CONSTRAINT [FK_Bill_StatementCassError_Patient]
	FOREIGN KEY([PatientID])
	REFERENCES [dbo].[Patient] ([PatientID])

	ALTER TABLE [dbo].[Bill_StatementCassError] CHECK CONSTRAINT [FK_Bill_StatementCassError_Patient]
	
	CREATE CLUSTERED INDEX [CI_PracticeID] ON [dbo].[Bill_StatementCassError] 
	(
		[PracticeID] ASC
	)
	
END