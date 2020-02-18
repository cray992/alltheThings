
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CustomerDataAggregator_ReportType](
	[ReportTypeID] INT NOT NULL IDENTITY (1, 1),
	[Name] VARCHAR(100) NOT NULL
 CONSTRAINT [PK_CustomerDataAggregator_ReportType] PRIMARY KEY CLUSTERED 
(
	[ReportTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT INTO dbo.CustomerDataAggregator_ReportType
        ( Name )
VALUES  ( 'Key Performance Indicators'  -- Name - varchar(100)
          )