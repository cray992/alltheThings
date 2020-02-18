USE [Superbill_Shared]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DeactivationResponse_DeactivationTopic]') AND parent_object_id = OBJECT_ID(N'[dbo].[DeactivationResponse]'))
ALTER TABLE [dbo].[DeactivationResponse] DROP CONSTRAINT [FK_DeactivationResponse_DeactivationTopic]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DeactivationResponse_BillingLead]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DeactivationResponse] DROP CONSTRAINT [DF_DeactivationResponse_BillingLead]
END

GO

USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[DeactivationResponse]    Script Date: 12/28/2010 12:27:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeactivationResponse]') AND type in (N'U'))
DROP TABLE [dbo].[DeactivationResponse]
GO

USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[DeactivationResponse]    Script Date: 12/28/2010 12:27:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DeactivationResponse](
	[ResponseID] [int] IDENTITY(1,1) NOT NULL,
	[TopicID] [int] NOT NULL,
	[QuestionResponse] [varchar](max) NOT NULL,
	[RetentionOfferResponse] [bit] NOT NULL,
	[BillingLead] [bit] NOT NULL,
 CONSTRAINT [PK_DeactivationResponse] PRIMARY KEY CLUSTERED 
(
	[ResponseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[DeactivationResponse]  WITH CHECK ADD  CONSTRAINT [FK_DeactivationResponse_DeactivationTopic] FOREIGN KEY(TopicID)
REFERENCES [dbo].[DeactivationTopic] ([TopicID])
GO

ALTER TABLE [dbo].[DeactivationResponse] CHECK CONSTRAINT [FK_DeactivationResponse_DeactivationTopic]
GO

ALTER TABLE [dbo].[DeactivationResponse] ADD  CONSTRAINT [DF_DeactivationResponse_BillingLead]  DEFAULT ((0)) FOR [BillingLead]
GO

