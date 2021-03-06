USE [superbill_0001_dev]
GO
/****** Object:  Index [CI_EncounterProcedure_PracticeID_EncounterProcedureID_EncounterID]    Script Date: 03/09/2006 15:59:02 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EncounterProcedure]') AND name = N'CI_EncounterProcedure_PracticeID_EncounterProcedureID_EncounterID')
DROP INDEX [CI_EncounterProcedure_PracticeID_EncounterProcedureID_EncounterID] ON [dbo].[EncounterProcedure] WITH ( ONLINE = OFF )

GO

CREATE UNIQUE CLUSTERED INDEX CI_EncounterProcedure
ON EncounterProcedure (PracticeID, EncounterID, EncounterProcedureID)

--CREATE UNIQUE CLUSTERED INDEX CI_EncounterProcedure_PracticeID_EncounterProcedureID_EncounterID
--ON EncounterProcedure (PracticeID, EncounterProcedureID, EncounterID)

DROP INDEX Claim.CI_Claim_PracticeID_ClaimID
GO

CREATE INDEX IX_Claim_CurrentPayerProcessingStatusTypeCode
ON Claim (CurrentPayerProcessingStatusTypeCode)

CREATE UNIQUE CLUSTERED INDEX CI_Claim
ON Claim (PracticeID, EncounterProcedureID, ClaimID)

GO