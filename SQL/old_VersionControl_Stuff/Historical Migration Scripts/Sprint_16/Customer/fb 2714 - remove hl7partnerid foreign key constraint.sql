GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_HL7_PartnerEvent_PracticeIntegration]') AND parent_object_id = OBJECT_ID(N'[dbo].[HL7_PartnerEvent]'))
ALTER TABLE [dbo].[HL7_PartnerEvent] DROP CONSTRAINT [FK_HL7_PartnerEvent_PracticeIntegration]
GO


GO

ALTER TABLE [dbo].[HL7_PartnerEvent]  WITH CHECK ADD  CONSTRAINT [FK_HL7_PartnerEvent_PracticeIntegration] FOREIGN KEY( [PracticeID])
REFERENCES [dbo].[PracticeIntegration] ( [PracticeID])
GO