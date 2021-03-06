--
-- Add ClaimTransaction.FollowUpDate column
--
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ClaimTransaction' AND COLUMN_NAME = 'FollowUpDate')
BEGIN
	ALTER TABLE [dbo].[ClaimTransaction] ADD FollowUpDate [DATETIME] NULL
END

--
-- Insert 'FUP' (Follow Up) ClaimTransactionTypeCode
--
IF NOT EXISTS (SELECT TypeName FROM ClaimTransactionType WHERE ClaimTransactionTypeCode = 'FUP')
BEGIN
	INSERT INTO ClaimTransactionType (ClaimTransactionTypeCode, TypeName)
	VALUES ('FUP', 'Follow-Up')
END

--
-- Create the ClaimAccounting_FollowUp table
--
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ClaimAccounting_FollowUp')
BEGIN
	CREATE TABLE [dbo].[ClaimAccounting_FollowUp](
		[PracticeID] [int] NOT NULL,
		[ClaimID] [int] NOT NULL,
		[ClaimTransactionID] [int] NOT NULL,
		[FollowUpDate] [datetime] NOT NULL,
	 CONSTRAINT [PK_ClaimAccounting_FollowUp] PRIMARY KEY CLUSTERED 
	(
		[PracticeID] ASC,
		[ClaimID] ASC
	)
	)
	
	CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_FollowUp_ClaimTransactionID] ON [dbo].[ClaimAccounting_FollowUp] 
	(
		[ClaimTransactionID] ASC
	)
END