if exists (select * from dbo.sysindexes where name=('IX_Claim_PracticeID_EncounterProcedureID'))
RETURN

ELSE 

/****** Object:  Index [IX_Claim_PracticeID_EncounterProcedureID]    Script Date: 04/05/2012 08:35:23 ******/
CREATE NONCLUSTERED INDEX [IX_Claim_PracticeID_EncounterProcedureID] ON [dbo].[Claim] 
(
	[PracticeID] ASC,
	[EncounterProcedureID] ASC
)
INCLUDE ( [ClaimID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


