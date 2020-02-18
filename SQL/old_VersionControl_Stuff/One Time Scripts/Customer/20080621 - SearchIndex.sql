
IF EXISTS(Select 1 from sys.columns c inner join sys.tables t on t.object_id=c.object_id where c.name='SearchIndex' and t.name='claim')
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_SearchIndex')
		DROP INDEX [IX_Claim_SearchIndex] ON [dbo].[Claim] WITH ( ONLINE = OFF )

	ALTER TABLE CLAIM DROP COLUMN SearchIndex
END
GO
	alter table claim ADD SearchIndex as 
		isnull(ClearinghousePayer, '')
		+';'+isnull(ClearinghousePayerReported, '')
		+';'+isnull(ClearinghouseProcessingStatus, '')
		+';'+isnull(PayerProcessingStatus, '')
		+';'+isnull(PayerTrackingNumber, '')
		+';'+isnull(ClearinghouseTrackingNumber, '')


GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_SearchIndex')
	DROP INDEX [IX_Claim_SearchIndex] ON [dbo].[Claim] WITH ( ONLINE = OFF )
GO
CREATE NONCLUSTERED INDEX [IX_Claim_SearchIndex] ON [dbo].[Claim] 
(
	[SearchIndex] ASC
)



IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EncounterProcedure]') AND name = N'IX_EncounterProcedure_PracticeIDProcedureServiceDate')
	DROP INDEX IX_EncounterProcedure_PracticeIDProcedureServiceDate ON [dbo].[EncounterProcedure] 




IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Encounter]') AND name = N'IX_Encounter_PracticeIDDateOfService')
	DROP INDEX IX_Encounter_PracticeIDDateOfService ON [dbo].[Encounter] 
GO
CREATE NONCLUSTERED INDEX IX_Encounter_PracticeIDDateOfService ON [dbo].[Encounter] 
(
	[PracticeID] ASC,
	DateOfService DESC,
	EncounterID DESC
)
