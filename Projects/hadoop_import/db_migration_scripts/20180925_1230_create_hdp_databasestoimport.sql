USE ReportingLog

IF EXISTS (SELECT 1 from [dbo].[HDP_DatabasesToImport]) DROP TABLE [dbo].[HDP_DatabasesToImport]

CREATE TABLE [dbo].[HDP_DatabasesToImport] (
    [DatabaseID] [int] NOT NULL IDENTITY(1,1),
    [HostServer] [varchar](255) NOT NULL,
    [DatabaseName] [varchar](100) NOT NULL,
    [dbEnabled] [bit] NOT NULL DEFAULT(0),
    [CreatedDate] [smalldatetime] NOT NULL DEFAULT(getdate()),
    [ModifiedDate] [smalldatetime] NOT NULL
    CONSTRAINT [PK_HDP_DatabasesToImport] PRIMARY KEY CLUSTERED
    (
        [DatabaseID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE INDEX IX_HDP_DatabasesToImport_CreatedDate_HostServer_TableName ON [dbo].[HDP_DatabasesToImport] (CreatedDate DESC,HostServer,DatabaseName)
CREATE INDEX IX_HDP_DatabasesToImport_dbEnabled_CreatedDate_HostServer_TableName ON [dbo].[HDP_DatabasesToImport] (dbEnabled,CreatedDate DESC,HostServer,DatabaseName)
