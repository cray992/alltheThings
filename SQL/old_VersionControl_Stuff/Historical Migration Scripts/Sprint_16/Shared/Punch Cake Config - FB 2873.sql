-----------------CREATE PatientPaymentEODErrorLog TABLE------------ 

/****** Object:  Table [dbo].[PatientPaymentEODErrorLog]    Script Date: 08/03/2011 17:05:57 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PatientPaymentEODErrorLog]') AND name = N'PK_PatientPaymentEODErrorLog')
ALTER TABLE [dbo].PatientPaymentEODErrorLog DROP CONSTRAINT [PK_PatientPaymentEODErrorLog]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PatientPaymentEODErrorLog]') AND type in (N'U'))
DROP TABLE [dbo].[PatientPaymentEODErrorLog]
GO

/****** Object:  Table [dbo].[PatientPaymentEODLog]    Script Date: 08/03/2011 17:05:57 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PatientPaymentEODLog]') AND name = N'PK_PatientPaymentEODLog')
ALTER TABLE [dbo].PatientPaymentEODLog DROP CONSTRAINT [PK_PatientPaymentEODLog]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PatientPaymentEODLog]') AND type in (N'U'))
DROP TABLE [dbo].[PatientPaymentEODLog]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/****** Object:  Table [dbo].[PatientPaymentEODErrorLog]    Script Date: 08/03/2011 17:05:57 ******/
CREATE TABLE [dbo].[PatientPaymentEODErrorLog](
	ErrorLogID int IDENTITY(1,1) NOT NULL,
	[EODLogID] INT,
	[CreatedDate] [datetime] NOT NULL,
	[RawPatientPaymentLine] VARCHAR(MAX) NOT NULL,
	[PatientFirstName] VARCHAR(128) NULL,
	[PatientLastName] VARCHAR(128) NULL,
	[PatientID] INT NULL,
	[TransactionID] VARCHAR(64) NULL,
	[ErrorMessage] varchar(max) NULL,
 CONSTRAINT [PK_PatientPaymentEODErrorLog] PRIMARY KEY CLUSTERED 
(
	ErrorLogID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PatientPaymentEODErrorLog_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PatientPaymentEODErrorLog] DROP CONSTRAINT DF_PatientPaymentEODErrorLog_CreatedDate
END

ALTER TABLE [dbo].[PatientPaymentEODErrorLog] ADD  CONSTRAINT DF_PatientPaymentEODErrorLog_CreatedDate  
DEFAULT (GETDATE()) FOR CreatedDate

--------CREATE [PatientPaymentEODLog] TABLE---------------
/****** Object:  Table [dbo].[PatientPaymentEODLog]    Script Date: 08/03/2011 17:05:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].PatientPaymentEODLog(
	[EODLogID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PracticeID] [int] NOT NULL,
	[Filename] [varchar](100) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ErrorMessage] [varchar](max) NULL,
 CONSTRAINT [PK_PatientPaymentEODLog] PRIMARY KEY CLUSTERED 
(
	[EODLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PatientPaymentEODLog_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].PatientPaymentEODLog DROP CONSTRAINT [DF_PatientPaymentEODLog_CreatedDate]
END

ALTER TABLE [dbo].PatientPaymentEODLog ADD  CONSTRAINT [DF_PatientPaymentEODLog_CreatedDate]  
DEFAULT (GETDATE()) FOR CreatedDate

ALTER TABLE [dbo].[PatientPaymentEODErrorLog]  WITH CHECK ADD CONSTRAINT [FK_PatientPaymentEODErrorLog_EODLogID] FOREIGN KEY([EODLogID])
REFERENCES [dbo].PatientPaymentEODLog ([EODLogID])






