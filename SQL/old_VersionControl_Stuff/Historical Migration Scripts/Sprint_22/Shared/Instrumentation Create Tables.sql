IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Action]') AND type in (N'U'))
DROP TABLE [dbo].[Action]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Control]') AND type in (N'U'))
DROP TABLE [dbo].[Control]


/****** Object:  Table [dbo].[Control]    Script Date: 12/21/2011 10:18:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Control](
      [ControlID] [bigint] IDENTITY(1,1) NOT NULL,
      [Signature] UNIQUEIDENTIFIER NOT NULL,
      [FullName] [varchar](max) NOT NULL,
      [Name] [varchar](200) NOT NULL,
      [ControlText] [varchar](200) NULL,
      [DisplayName] [varchar](200) NULL,
      [Description] [varchar](500) NULL,
      [CreatedDate] [datetime] NOT NULL,
CONSTRAINT [PK_Control] PRIMARY KEY CLUSTERED 
(
      [ControlID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ix_Control_Signature] ON [dbo].[Control] 
(
	[Signature] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
GO
/****** Object:  Table [dbo].[Action]    Script Date: 12/21/2011 10:18:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Action](
      [ActionId] [bigint] IDENTITY(1,1) NOT NULL,
      [Source] [varchar](50) NOT NULL,
      [ActionType] [varchar](50) NOT NULL,
      [ControlID] [bigint] NULL,
      [CustomerID] [bigint] NOT NULL,
      [PracticeID] [bigint] NULL,
      [UserID] [bigint] NULL,
      [StartDate] [datetime] NULL,
      [EndDate] [datetime] NULL,
      [CreatedDate] [datetime]  NOT NULL,
 CONSTRAINT [PK_Action] PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO