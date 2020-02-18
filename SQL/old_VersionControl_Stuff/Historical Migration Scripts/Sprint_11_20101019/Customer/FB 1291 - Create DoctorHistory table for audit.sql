
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DoctorHistory_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DoctorHistory] DROP CONSTRAINT [DF_DoctorHistory_CreatedDate]
END

GO

/****** Object:  Table [dbo].[DoctorHistory]    Script Date: 11/06/2010 22:25:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DoctorHistory]') AND type in (N'U'))
DROP TABLE [dbo].[DoctorHistory]
GO

/****** Object:  Table [dbo].[DoctorHistory]    Script Date: 11/06/2010 22:25:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DoctorHistory](
	[DoctorID] [int] NOT NULL,
	[PracticeID] [int] NOT NULL,
	[ModifiedUserID] [int] NOT NULL,
	[External] [bit] NULL,
	[ActiveDoctor] [bit] NULL,
	[ModificationType] [char](10) NOT NULL,
	[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


ALTER TABLE [dbo].[DoctorHistory] ADD  CONSTRAINT [DF_DoctorHistory_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO


