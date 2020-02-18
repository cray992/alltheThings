

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DoctorHistory_DeactivationResponse]') AND parent_object_id = OBJECT_ID(N'[dbo].[DoctorHistory]'))
ALTER TABLE [dbo].[DoctorHistory] DROP CONSTRAINT [FK_DoctorHistory_DeactivationResponse]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DoctorHistory_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DoctorHistory] DROP CONSTRAINT [DF_DoctorHistory_CreatedDate]
END

GO


/****** Object:  Table [dbo].[DoctorHistory]    Script Date: 01/11/2011 10:14:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DoctorHistory]') AND type in (N'U'))
DROP TABLE [dbo].[DoctorHistory]
GO

/****** Object:  Table [dbo].[DoctorHistory]    Script Date: 01/11/2011 10:14:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DoctorHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DoctorID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PracticeID] [int] NULL,
	[ModifiedUserID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ActiveDoctor] [bit] NOT NULL,
	[ResponseID] [int] NULL,
 CONSTRAINT [PK_DoctorHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[DoctorHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_DoctorHistory_DeactivationResponse] FOREIGN KEY([ResponseID])
REFERENCES [dbo].[DeactivationResponse] ([ResponseID])
GO

ALTER TABLE [dbo].[DoctorHistory] CHECK CONSTRAINT [FK_DoctorHistory_DeactivationResponse]
GO

ALTER TABLE [dbo].[DoctorHistory] ADD  CONSTRAINT [DF_DoctorHistory_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO


