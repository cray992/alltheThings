IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EncounterProcedure]') AND name = N'IX_EncounterProcedure_TypeOfServiceCode')
	DROP INDEX [IX_EncounterProcedure_TypeOfServiceCode] ON [dbo].[EncounterProcedure] WITH ( ONLINE = OFF )
GO
	
CREATE NONCLUSTERED INDEX [IX_EncounterProcedure_TypeOfServiceCode] ON [dbo].[EncounterProcedure] 
(
	[TypeOfServiceCode]
)
GO

