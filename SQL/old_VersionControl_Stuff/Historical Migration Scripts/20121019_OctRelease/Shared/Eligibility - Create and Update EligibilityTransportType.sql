USE [Superbill_Shared]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EligibilityTransport_EligibilityTransportTypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[EligibilityTransportType]'))
ALTER TABLE [dbo].[EligibilityTransportType] DROP CONSTRAINT [FK_EligibilityTransport_EligibilityTransportTypeID]
GO

USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[EligibilityTransportType]    Script Date: 09/30/2012 17:11:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EligibilityTransportType]') AND type in (N'U'))
DROP TABLE [dbo].[EligibilityTransportType]
GO

USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[EligibilityTransportType]    Script Date: 09/30/2012 17:11:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EligibilityTransportType](
	[EligibilityTransportTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TransportTypeDescription] [varchar](100) NOT NULL,
 CONSTRAINT [PK_EligibilityTransportType] PRIMARY KEY CLUSTERED 
(
	[EligibilityTransportTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[EligibilityTransportType]  WITH CHECK ADD  CONSTRAINT [FK_EligibilityTransport_EligibilityTransportTypeID] FOREIGN KEY([EligibilityTransportTypeID])
REFERENCES [dbo].[EligibilityTransportType] ([EligibilityTransportTypeID])
GO

ALTER TABLE [dbo].[EligibilityTransportType] CHECK CONSTRAINT [FK_EligibilityTransport_EligibilityTransportTypeID]
GO




INSERT dbo.EligibilityTransportType
        ( TransportTypeDescription )
VALUES  ( 'Clearinghouse')

GO

INSERT dbo.EligibilityTransportType
        ( TransportTypeDescription )
VALUES  ( 'EligibleAPI')
