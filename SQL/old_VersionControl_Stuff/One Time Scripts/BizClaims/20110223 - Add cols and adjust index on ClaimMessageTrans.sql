
IF NOT EXISTS(select * from sys.columns where Name = N'ForwardingPickupDateTime' and Object_ID = Object_ID(N'[ClaimMessageTransaction]'))
BEGIN
	ALTER TABLE [ClaimMessageTransaction] ADD [ForwardingPickupDateTime] DATETIME, [ForwardingAttempts] INT NOT NULL DEFAULT(0) WITH VALUES
END

CREATE NONCLUSTERED INDEX [IX_ClaimMessageTransaction_Forwarded_CreatedDate_ClaimMessageTransactionTypeCode] ON [dbo].[ClaimMessageTransaction] 
(
	[Forwarded] ASC,
	[CreatedDate] DESC,
	[ClaimMessageTransactionTypeCode] ASC
)
INCLUDE ( [ClaimMessageTransactionId], [ForwardingPickupDateTime]) 
WITH (DROP_EXISTING = ON)

GO

