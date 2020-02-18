USE [Superbill_Shared]
GO

--RENAME ELIGIBILITY VENDORE TABLE

--Drop constraints 
IF EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'dbo.FK_EligibilityVendor_EligibilityTransportID')
   AND parent_object_id = OBJECT_ID(N'dbo.EligibilityVendor')
)
ALTER TABLE dbo.EligibilityVendor DROP CONSTRAINT FK_EligibilityVendor_EligibilityTransportID


--RENAME EligibilityVendor TABLE
IF EXISTs(
	SELECT 1 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME='EligibilityVendor')
BEGIN
    EXEC sys.sp_rename @objname = N'EligibilityVendor', -- nvarchar(1035)
        @newname = 'EligibilityVendor_Old'
   
END

GO


--CREATE ELIGIBILITYTRANSPORT TABLE

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EligibilityTransportType_TransportType]') AND parent_object_id = OBJECT_ID(N'[dbo].[EligibilityTransport]'))
ALTER TABLE [dbo].[EligibilityTransport] DROP CONSTRAINT [FK_EligibilityTransportType_TransportType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Partner_PartnerID]') AND parent_object_id = OBJECT_ID(N'[dbo].[EligibilityTransport]'))
ALTER TABLE [dbo].[EligibilityTransport] DROP CONSTRAINT [FK_Partner_PartnerID]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EligibilityTransport_ClearinghouseID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EligibilityTransport] DROP CONSTRAINT [DF_EligibilityTransport_ClearinghouseID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_EligibilityTransport_PartnerID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EligibilityTransport] DROP CONSTRAINT [DF_EligibilityTransport_PartnerID]
END

GO
   
USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[EligibilityTransport]    Script Date: 09/30/2012 17:13:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EligibilityTransport]') AND type in (N'U'))
DROP TABLE [dbo].[EligibilityTransport]
GO

USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[EligibilityTransport]    Script Date: 09/30/2012 17:13:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EligibilityTransport](
	[EligibilityTransportID] [int] NOT NULL,
	[TransportName] [varchar](128) NULL,
	[TransportType] [int] NULL,
	[Active] [bit] NULL,
	[ParametersXml] [ntext] NULL,
	[Notes] [ntext] NULL,
	[ClearinghouseID] [int] NOT NULL,
	[PartnerID] [int] NULL,
 CONSTRAINT [PK_EligibilityTransport_EligibilityTransportID] PRIMARY KEY CLUSTERED 
(
	[EligibilityTransportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[EligibilityTransport]  WITH CHECK ADD  CONSTRAINT [FK_EligibilityTransportType_TransportType] FOREIGN KEY([TransportType])
REFERENCES [dbo].[EligibilityTransportType] ([EligibilityTransportTypeID])
GO

ALTER TABLE [dbo].[EligibilityTransport] CHECK CONSTRAINT [FK_EligibilityTransportType_TransportType]
GO

ALTER TABLE [dbo].[EligibilityTransport]  WITH CHECK ADD  CONSTRAINT [FK_Partner_PartnerID] FOREIGN KEY([PartnerID])
REFERENCES [dbo].[Partner] ([PartnerID])
GO

ALTER TABLE [dbo].[EligibilityTransport] CHECK CONSTRAINT [FK_Partner_PartnerID]
GO

ALTER TABLE [dbo].[EligibilityTransport] ADD  CONSTRAINT [DF_EligibilityTransport_ClearinghouseID]  DEFAULT ((0)) FOR [ClearinghouseID]
GO

ALTER TABLE [dbo].[EligibilityTransport] ADD  CONSTRAINT [DF_EligibilityTransport_PartnerID]  DEFAULT ((1)) FOR [PartnerID]
GO


