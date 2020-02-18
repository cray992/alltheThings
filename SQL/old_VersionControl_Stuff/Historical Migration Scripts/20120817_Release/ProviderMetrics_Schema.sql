USE [KareoReportingDB]
GO

/****** Object:  Table [dbo].[ProviderChange]    Script Date: 08/07/2012 14:50:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProviderMetrics]') AND type in (N'U'))
Begin
Drop Table ProviderMetrics
End

CREATE TABLE [dbo].[ProviderMetrics](
	[CustomerID] [int] NULL,
	[Customer] [varchar](128) NOT NULL,
	[BeginningProviders] [int] NULL,
	[EndingProviders] [int] NULL,
	[NetChange] [int] NULL,
	[Category] [varchar](33) NOT NULL,
	[PricingModel] [varchar](13) NOT NULL,
	[StartDate] [nvarchar](10) NULL,
	[EndDate] [nvarchar](10) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDuringPeriod] [varchar](21) NOT NULL,
	[CancelledChange] [varchar](25) NOT NULL,
	[Partner] [varchar](100) NULL,
	[Paying] [int] NOT NULL,
	[promocode] [varchar](50) NULL,
	[effectivebillingstartdate] [datetime] NULL,
	[Conversion] [int] NOT NULL,
	[LeadType] [varchar](100) NULL,
	[Channel] [varchar](8) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


