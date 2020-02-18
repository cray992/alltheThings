USE [master]
GO


/****** Object:  Database [FlowMessages]    Script Date: 11/01/2007 15:08:47 ******/
CREATE DATABASE [FlowMessages] 
---- Use defaults
GO

USE [FlowMessages]
GO
/****** Object:  Table [dbo].[FlowDebug]    Script Date: 11/01/2007 15:10:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FlowDebug](
	[FlowDebugId] [int] IDENTITY(1,1) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[Transport] [varchar](50) NOT NULL,
	[TransportId] [varchar](50) NOT NULL,
	[Request] [xml] NULL,
	[FlowName] [varchar](50) NULL,
	[StepName] [varchar](50) NULL,
	[FlowDefinition] [xml] NULL,
	[CmdDefinition] [xml] NULL,
	[Inputs] [xml] NULL,
	[Context] [xml] NULL,
	[Response] [xml] NULL,
 CONSTRAINT [PK_FlowDebug] PRIMARY KEY CLUSTERED 
(
	[FlowDebugId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF



USE [FlowMessages]
GO
/****** Object:  Table [dbo].[QueueMsg]    Script Date: 11/01/2007 15:10:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QueueMsg](
	[QueueMsgId] [int] IDENTITY(1,1) NOT NULL,
	[MsgStatus] [char](10) NOT NULL,
	[Msg] [xml] NOT NULL,
	[MsgHistory] [xml] NOT NULL,
	[Error] [varchar](max) NULL,
	[Response] [xml] NULL,
	[Diagnostics] [xml] NULL,
 CONSTRAINT [PK_QueueMsg] PRIMARY KEY CLUSTERED 
(
	[QueueMsgId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

