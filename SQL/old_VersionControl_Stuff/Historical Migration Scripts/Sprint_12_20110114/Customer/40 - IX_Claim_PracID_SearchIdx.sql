IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_SearchIndex')
DROP INDEX [IX_Claim_SearchIndex] ON [dbo].[Claim] WITH ( ONLINE = OFF )


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_PracticeID_SearchIndex')
BEGIN

	CREATE NONCLUSTERED INDEX [IX_Claim_PracticeID_SearchIndex] ON [dbo].[Claim]
	(
		[PracticeID],
		[SearchIndex]	
	)
	
END