IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_PracticeIntegration_PracticeFusionStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[PracticeIntegration]'))
ALTER TABLE [dbo].[PracticeIntegration] DROP CONSTRAINT [CK_PracticeIntegration_PracticeFusionStatus]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PracticeIntegration_PracticeFusionStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PracticeIntegration] DROP CONSTRAINT [DF_PracticeIntegration_PracticeFusionStatus]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__PracticeI__Pract__4390BE7E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PracticeIntegration] DROP CONSTRAINT [DF__PracticeI__Pract__4390BE7E]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__PracticeI__Pract__4484E2B7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PracticeIntegration] DROP CONSTRAINT [DF__PracticeI__Pract__4484E2B7]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__PracticeI__Pract__457906F0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PracticeIntegration] DROP CONSTRAINT [DF__PracticeI__Pract__457906F0]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PracticeIntegration_HL7PartnerID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PracticeIntegration] DROP CONSTRAINT [DF_PracticeIntegration_HL7PartnerID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PracticeIntegration_HL7PartnerActive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PracticeIntegration] DROP CONSTRAINT [DF_PracticeIntegration_HL7PartnerActive]
END

GO

USE [superbill_0028_dev]
GO

/****** Object:  Table [dbo].[PracticeIntegration]    Script Date: 05/25/2011 12:49:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PracticeIntegration]') AND type in (N'U'))
DROP TABLE [dbo].[PracticeIntegration]
GO

USE [superbill_0028_dev]
GO

/****** Object:  Table [dbo].[PracticeIntegration]    Script Date: 05/25/2011 12:49:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PracticeIntegration](
	[PracticeID] [int] NOT NULL,
	[PracticeFusionID] [varchar](100) NULL,
	[PracticeFusionStatus] [char](1) NULL,
	[Notes] [varchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedUserID] [int] NOT NULL,
	[ModifiedUserID] [int] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[PracticeFusionIgnoreCases] [bit] NOT NULL,
	[PracticeFusionAutoPopulateG8Code] [bit] NOT NULL,
	[PracticeFusionG8Code] [char](7) NULL,
	[HL7PartnerID] [int] NOT NULL,
	[HL7PartnerActive] [bit] NOT NULL,
	[HL7PartnerApplicationName] [varchar](180) NOT NULL,
	[HL7PartnerFacilityName] [varchar](180) NOT NULL,
	[HL7KareoApplicationName] [varchar](180) NOT NULL,
	[HL7KareoFacilityName] [varchar](180) NOT NULL,
 CONSTRAINT [PK_PracticeIntegration] PRIMARY KEY CLUSTERED 
(
	[PracticeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[PracticeIntegration]  WITH CHECK ADD  CONSTRAINT [CK_PracticeIntegration_PracticeFusionStatus] CHECK  (([PracticeFusionStatus]='N' OR [PracticeFusionStatus]='C'))
GO

ALTER TABLE [dbo].[PracticeIntegration] CHECK CONSTRAINT [CK_PracticeIntegration_PracticeFusionStatus]
GO

ALTER TABLE [dbo].[PracticeIntegration] ADD  CONSTRAINT [DF_PracticeIntegration_PracticeFusionStatus]  DEFAULT ('N') FOR [PracticeFusionStatus]
GO

ALTER TABLE [dbo].[PracticeIntegration] ADD  CONSTRAINT [DF__PracticeI__Pract__4390BE7E]  DEFAULT ((0)) FOR [PracticeFusionIgnoreCases]
GO

ALTER TABLE [dbo].[PracticeIntegration] ADD  CONSTRAINT [DF__PracticeI__Pract__4484E2B7]  DEFAULT ((0)) FOR [PracticeFusionAutoPopulateG8Code]
GO

ALTER TABLE [dbo].[PracticeIntegration] ADD  CONSTRAINT [DF__PracticeI__Pract__457906F0]  DEFAULT ('G8447') FOR [PracticeFusionG8Code]
GO

ALTER TABLE [dbo].[PracticeIntegration] ADD  CONSTRAINT [DF_PracticeIntegration_HL7PartnerID]  DEFAULT ((0)) FOR [HL7PartnerID]
GO

ALTER TABLE [dbo].[PracticeIntegration] ADD  CONSTRAINT [DF_PracticeIntegration_HL7PartnerActive]  DEFAULT ((0)) FOR [HL7PartnerActive]
GO


