IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EncounterProcedure]') AND name = N'IX_EncounterProcedure_PracticeIDProcedureDateOfService')
	DROP INDEX [IX_EncounterProcedure_PracticeIDProcedureDateOfService] ON [dbo].[EncounterProcedure] WITH ( ONLINE = OFF )
GO


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EncounterProcedure]') AND name = N'IX_EncounterProcedure_PracticeID_ProcedureDateOfService_EncounterID_EncounterProcedureID')
	CREATE NONCLUSTERED INDEX [IX_EncounterProcedure_PracticeID_ProcedureDateOfService_EncounterID_EncounterProcedureID] ON [dbo].[EncounterProcedure] 
	(
		[PracticeID] ASC,
		[ProcedureDateOfService] DESC,
		[EncounterID] DESC,
		[EncounterProcedureID] ASC
	)

GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EncounterProcedure]') AND name = N'IX_PracticeID_EncounterProcedureID')
	DROP INDEX [IX_PracticeID_EncounterProcedureID] ON [dbo].[EncounterProcedure] WITH ( ONLINE = OFF )
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EncounterProcedure]') AND name = N'IX_EncounterProcedure_PracticeID_EncounterProcedureID_INC_EncounterID_ProcedureDateOfService')
	CREATE NONCLUSTERED INDEX [IX_EncounterProcedure_PracticeID_EncounterProcedureID_INC_EncounterID_ProcedureDateOfService] ON [dbo].[EncounterProcedure] 
	(
		[PracticeID] ASC,
		[EncounterProcedureID] ASC
	)
	INCLUDE ([EncounterID], [ProcedureDateOfService])
GO

