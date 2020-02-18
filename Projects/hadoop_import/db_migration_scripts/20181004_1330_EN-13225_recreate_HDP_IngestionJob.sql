Use ReportingLog

DROP TABLE [dbo].[HDP_IngestionJob]

CREATE TABLE [dbo].[HDP_IngestionJob](
    [IngestionJobID] [INT] NOT NULL IDENTITY(1,1),
    [CustomerId] [INT],
    [DbTypeId] [NUMERIC](2,0) NOT NULL,
    [DbName] [VARCHAR](50) NOT NULL,
    [TableName] [VARCHAR](128) NOT NULL,
    [IngestionType] [NUMERIC](2,0) NOT NULL,
    [IngestionJobType] [NUMERIC](2,0) NOT NULL,
    [Status] [NUMERIC](2,0) NOT NULL,
    [StartTime] [DATETIME],
    [CreateTime] [DATETIME] NOT NULL DEFAULT(getdate()),
    [UpdateTime] [DATETIME] NOT NULL DEFAULT(getdate()),
    [Version] [INT] NOT NULL,
    [PreviousVersion] [INT] NOT NULL
   CONSTRAINT [PK_HDP_IngestionJob] PRIMARY KEY CLUSTERED
(
    [IngestionJobID] ASC
)WITH (STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX ix_DbNameTableNameStatus ON dbo.HDP_IngestionJob (DbName, TableName, Status)
WITH (STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
