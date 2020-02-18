----------------------------------------------------------------------------
--FB 2852 - Create MerchantAccountConfig table 
----------------------------------------------------------------------------
/****** Object:  Table [dbo].[MerchantAccountConfig]    Scrip Date: 07/28/2011 15:55:45 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MerchantAccountConfig]') AND type in (N'U'))
BEGIN

	CREATE TABLE [dbo].[MerchantAccountConfig](
		[MerchantAccountConfigID] [int] IDENTITY(1,1) NOT NULL,
		[CustomerID] [int] NOT NULL,
		[PracticeID] [int] NOT NULL,
		[MerchantID] [varchar](50) NULL,
		[UserID] [varchar](50) NULL,
		[Password] [varchar](50) NULL,
		[CPMerchantID] [varchar](50) NULL,
		[CPStoreID] [varchar](50) NULL,
		[CPTerminalID] [varchar](50) NULL,
		[CNPMerchantID] [varchar](50) NULL,
		[CNPStoreID] [varchar](50) NULL,
		[CNPTerminalID] [varchar](50) NULL,
		[PatientPaymentID] [int] NULL,
		[PortalAlias] [varchar](50) NULL,
		[ClientID] VARCHAR(50) NULL,
		[PortalMerchantID] [varchar](50) NULL,
		[PortalStoreID] [varchar](50) NULL,
		[PortalTerminalID] [varchar](50) NULL,
		[PatientPaymentEnabledDate] [datetime] NULL,
	 CONSTRAINT [PK_MerchantAccountConfig] PRIMARY KEY CLUSTERED 
	(
		[MerchantAccountConfigID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END