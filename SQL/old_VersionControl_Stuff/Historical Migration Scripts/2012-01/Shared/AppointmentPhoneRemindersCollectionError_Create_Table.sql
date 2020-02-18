/****** Object:  Table [dbo].[AppointmentPhoneRemindersCollectionError]    Script Date: 01/04/2012 13:57:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppointmentPhoneRemindersCollectionError]') AND type in (N'U'))
DROP TABLE [dbo].[AppointmentPhoneRemindersCollectionError]
GO

/****** Object:  Table [dbo].[AppointmentPhoneRemindersCollectionError]    Script Date: 01/04/2012 13:57:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AppointmentPhoneRemindersCollectionError](
	[CollectionErrorID] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Error] [varchar](max) NOT NULL,
	[JobID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AppointmentPhoneRemindersCollectionError] PRIMARY KEY CLUSTERED 
(
	[CollectionErrorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


