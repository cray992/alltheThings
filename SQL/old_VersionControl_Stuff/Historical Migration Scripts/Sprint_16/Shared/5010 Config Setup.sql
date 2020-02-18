
/********   FB 3103: 5010 CONFIG SETUP       *********/


/****** Object:  Table [dbo].[ClearinghousePayerEDIVersion]    Script Date: 09/14/2011 19:06:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClearinghousePayerEDIVersion]') AND type in (N'U'))
DROP TABLE [dbo].[ClearinghousePayerEDIVersion]
GO

/****** Object:  Table [dbo].[ClearinghousePayerEDIVersion]    Script Date: 09/14/2011 19:06:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDIVersion]') AND type in (N'U'))
DROP TABLE [dbo].[EDIVersion]
GO


/****** Object:  Table [dbo].[ClearinghousePayerEDIVersion]    Script Date: 09/14/2011 19:06:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE dbo.[EDIVersion]
	(
	EDIVersionID INT NOT NULL IDENTITY (1, 1),
	Name VARCHAR(50) NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE dbo.[EDIVersion] ADD CONSTRAINT
	PK_EDIVersion PRIMARY KEY CLUSTERED 
	(
	EDIVersionID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

CREATE TABLE [dbo].[ClearinghousePayerEDIVersion](
	[PayerNumber] [varchar](50) NOT NULL,
	[ClearinghouseID] [int] NOT NULL,
	[ClaimEDIVersionID] [int] NOT NULL, --Making it an int if we switch to 6010
	[RemitEDIVersionID] [int] NOT NULL,
	[EligibilityEDIVersionID] [int] NOT NULL
  CONSTRAINT [PK_ClearinghousePayerEDIVersion] PRIMARY KEY CLUSTERED 
(
	[PayerNumber] ASC,
	[ClearinghouseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO


INSERT INTO EDIVersion
SELECT '4010'
UNION ALL
SELECT '5010'