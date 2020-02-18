IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HandheldEncounterDetail]') AND name = N'PK_dbo.HandheldEncounterDetail')
ALTER TABLE [dbo].[HandheldEncounterDetail] DROP CONSTRAINT [PK_dbo.HandheldEncounterDetail]

GO

ALTER TABLE HandheldEncounterDetail 
ADD  CONSTRAINT PK_HandheldEncounterDetail PRIMARY KEY CLUSTERED 
(
	HandheldEncounterDetailID ASC
)

GO