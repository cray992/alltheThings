/****** Object:  Table [dbo].[DeactivationTopic]    Script Date: 12/27/2010 14:33:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeactivationTopic]') AND type in (N'U'))
DROP TABLE [dbo].[DeactivationTopic]
GO
/****** Object:  Table [dbo].[DeactivationTopic]    Script Date: 12/27/2010 14:34:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DeactivationTopic](
	[TopicID] [int] IDENTITY(1,1) NOT NULL,
	[ReasonOption] [nvarchar](450) NOT NULL,
	[Question] [nvarchar](450) NOT NULL,
	[RetentionOffer] [nvarchar](450) NOT NULL,
	[TopicType] [varchar](150) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[InternalMessage] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_DeactivationTopics] PRIMARY KEY CLUSTERED 
(
	[TopicID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

