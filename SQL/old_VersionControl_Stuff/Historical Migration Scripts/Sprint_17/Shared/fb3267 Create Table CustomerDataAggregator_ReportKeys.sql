
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CustomerDataAggregator_ReportKeys]
(
	[ReportKeyID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [int] NOT NULL CONSTRAINT [FK_CustomerDataAggregator_ReportKeys_CustomerDataAggregator_ReportType] FOREIGN KEY REFERENCES [dbo].[CustomerDataAggregator_ReportType]([ReportTypeID]),
	[CreatedDate] [datetime] NULL,
	[ProcessComplete] [bit] NULL CONSTRAINT [DF_CustomerDataAggregator_ReportKeys_ProcessComplete]  DEFAULT ((0)),
	[ErrorMessage] [varchar](max) NULL
 CONSTRAINT [PK_CustomerDataAggregator_ReportKeys] PRIMARY KEY CLUSTERED 
(
	[ReportKeyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

GO
