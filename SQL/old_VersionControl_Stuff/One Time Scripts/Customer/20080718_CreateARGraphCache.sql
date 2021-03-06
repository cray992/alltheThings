IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ARGraphCache]') AND type in (N'U'))
DROP TABLE [dbo].[ARGraphCache]
GO

CREATE TABLE [dbo].[ARGraphCache](
	[PracticeId] [int] NOT NULL,
	[ARPeriodId] [int] NOT NULL,
	[Amount] [money] NULL,
	[DaysInARText] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]

GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ARGraphCache]') AND name = N'CI_ARGraphCache')
DROP INDEX [CI_ARGraphCache] ON [dbo].[ARGraphCache] WITH ( ONLINE = OFF )
GO

CREATE CLUSTERED INDEX [CI_ARGraphCache] ON [dbo].[ARGraphCache] 
(
	[PracticeId] ASC,
	[ARPeriodId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
GO