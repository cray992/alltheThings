
------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- Master Script For Setting Up Hadoop Import --------------------------------------------
-------------------------------------------- Modified: Jan 15, 2018                     --------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------


BEGIN


    --------------------------------- REPORTING LOG ---------------------------------

    USE [ReportingLog]

    SET QUOTED_IDENTIFIER ON
    SET ANSI_PADDING ON
    SET ANSI_NULLS ON

  /****** Object:  Table [dbo].[HDP_IngestionJob] ******/

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

    /****** Object:  Table [dbo].[HDP_DbType] ******/

    IF OBJECT_ID('dbo.HDP_DbType', 'U') IS NOT NULL
        DROP TABLE dbo.HDP_DbType
    CREATE TABLE ReportingLog.dbo.HDP_DbType (
        DbTypeId int NOT NULL IDENTITY(1,1),
        DbType varchar(50) NOT NULL,
    CONSTRAINT PK__HDP_DbTypeId PRIMARY KEY (DbTypeId)
    )

    INSERT INTO dbo.HDP_DbType(DbType) VALUES('Customer')
    INSERT INTO dbo.HDP_DbType(DbType) VALUES('Shared')
    INSERT INTO dbo.HDP_DbType(DbType) VALUES('Salesforce')

    /****** Object:  Table [dbo].[HDP_IngestionGroup] ******/

    IF OBJECT_ID('dbo.HDP_IngestionGroup', 'U') IS NOT NULL
        DROP TABLE dbo.HDP_IngestionGroup
    CREATE TABLE ReportingLog.dbo.HDP_IngestionGroup (
        IngestionGroupId int NOT NULL IDENTITY(1,1),
        Name varchar(50) NOT NULL,
    CONSTRAINT PK__HDP_IngegestionGroupId PRIMARY KEY (IngestionGroupId)
    )

    INSERT INTO dbo.HDP_IngestionGroup(Name) VALUES('KareoAnalytics')
    INSERT INTO dbo.HDP_IngestionGroup(Name) VALUES('KMB')

    /****** Object:  Table [dbo].[HDP_SourceDbConf] ******/
    IF OBJECT_ID('dbo.HDP_SourceDbConf', 'U') IS NOT NULL
        DROP TABLE dbo.HDP_SourceDbConf
    CREATE TABLE ReportingLog.dbo.HDP_SourceDbConf (
        SourceDbConfId int NOT NULL IDENTITY(1,1),
        SourceDbName varchar(50) NOT NULL,
        SourceDbServer varchar(50) NOT NULL,
        SourceDbPort varchar(5) NOT NULL,
    CONSTRAINT PK_HDP_Source_EF04CF073B5113EB PRIMARY KEY (SourceDbConfId)
    )

    INSERT INTO dbo.HDP_SourceDbConf(SourceDbName, SourceDbServer, SourceDbPort) VALUES('superbill_shared', 'sna-sgw-db-01.kareoprod.ent', '4402')
    INSERT INTO dbo.HDP_SourceDbConf(SourceDbName, SourceDbServer, SourceDbPort) VALUES('sfdc_sesame', 'sna-sgw-db-01.kareoprod.ent', '4401')

    /****** Object:  Table [dbo].[HDP_IngestibleDb] ******/

    IF OBJECT_ID('dbo.HDP_IngestibleDb', 'U') IS NOT NULL
        DROP TABLE dbo.HDP_IngestibleDb
    CREATE TABLE ReportingLog.dbo.HDP_IngestibleDb (
        IngestibleDbId int NOT NULL IDENTITY(1,1),
        IngestionGroupId int NOT NULL,
        TargetDbName varchar(50) NOT NULL,
        DbTypeId int NOT NULL,
        SourceDbConfId int,

    CONSTRAINT PK__HDP_IngestibleDbId PRIMARY KEY (IngestibleDbId),
    CONSTRAINT FK_HDP_IngesIngestionGroup_14270015 FOREIGN KEY (IngestionGroupId) REFERENCES ReportingLog.dbo.HDP_IngestionGroup(IngestionGroupId),
    CONSTRAINT FK_HDP_IngesDbType_14270015 FOREIGN KEY (DbTypeId) REFERENCES ReportingLog.dbo.HDP_DbType(DbTypeId)
    )

    INSERT INTO dbo.HDP_IngestibleDb(IngestionGroupId, TargetDbName, DbTypeId, SourceDbConfId) VALUES(1, 'customer_ka', 1, null)
    INSERT INTO dbo.HDP_IngestibleDb(IngestionGroupId, TargetDbName, DbTypeId, SourceDbConfId) VALUES(2, 'customer_kmb', 1, null)
    INSERT INTO dbo.HDP_IngestibleDb(IngestionGroupId, TargetDbName, DbTypeId, SourceDbConfId) VALUES(1, 'shared_ka', 2, 1)
    INSERT INTO dbo.HDP_IngestibleDb(IngestionGroupId, TargetDbName, DbTypeId, SourceDbConfId) VALUES(2, 'shared_kmb', 2, 1)
    INSERT INTO dbo.HDP_IngestibleDb(IngestionGroupId, TargetDbName, DbTypeId, SourceDbConfId) VALUES(2, 'salesforce_kmb', 3, 2)

    /****** Object:  Table [dbo].[HDP_ColumnsToImport] ******/

    CREATE TABLE [dbo].[HDP_ColumnsToImport](
        [ColumnID] [int] NOT NULL IDENTITY(1,1),
        [ColumnName] [varchar](100) NOT NULL,
        [TableID] [int] NOT NULL,
        [ColumnType] [varchar](50) NOT NULL,
        [ColumnLength] [int] NULL,
        [ColumnPrecision] [int] NULL,
        [ColumnScale] [int] NULL,
        [CreatedDate] [smalldatetime] NOT NULL,
        [ModifiedDate] [smalldatetime] NOT NULL,
        [ColumnImportFlag] [BIT] NOT NULL DEFAULT 1,
        [isMergeMatch] [BIT] NOT NULL DEFAULT 0,
        [isPartition] [BIT] NOT NULL DEFAULT 0,

     CONSTRAINT [PK_HDP_ColumnsToImport] PRIMARY KEY CLUSTERED
    (
        [ColumnID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

    /****** Object:  Table [dbo].[HDP_TablesToImport] ******/

    CREATE TABLE [dbo].[HDP_TablesToImport](
        [TableID] [int] NOT NULL IDENTITY(1,1),
        [TableName] [varchar](100) NOT NULL,
        [SourceID] [smallint] NOT NULL,
        [ImportTypeID] [smallint] NOT NULL,
        [Deleted] [smallint] NOT NULL,
        [CreatedDate] [smalldatetime] NOT NULL,
        [ModifiedDate] [smalldatetime] NOT NULL,
     CONSTRAINT [PK_HDP_TablesToImport] PRIMARY KEY CLUSTERED
    (
        [TableID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

    /****** Object:  Table [dbo].[HDP_DatabasesToImport] ******/

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


    /* TODO: Remove after moving to incremental ingestion. This is only used by the old ingestion (non incremental) ***/
    /****** Object:  Table [dbo].[HDP_CustomerMappingType] ******/

    CREATE TABLE [dbo].[HDP_CustomerMappingType](
      [CustomerMappingTypeID] [SMALLINT] NOT NULL,
      [CustomerMappingTypeName] [VARCHAR](50) NOT NULL,
      [MemoryAmount] [INT] NOT NULL,
      [Reducers]     [INT] NOT NULL,
      [CreatedDate] [SMALLDATETIME] NOT NULL,
      [ModifiedDate] [SMALLDATETIME] NOT NULL
    ) ON [PRIMARY]


    INSERT INTO HDP_CustomerMappingType (CustomerMappingTypeID, CustomerMappingTypeName,
                                         MemoryAmount, Reducers, CreatedDate, ModifiedDate)
    VALUES (1, 'kareo_analytics', 4096, 20, GETDATE(), getdate())

    INSERT INTO HDP_CustomerMappingType (CustomerMappingTypeID, CustomerMappingTypeName,
                                         MemoryAmount, Reducers, CreatedDate, ModifiedDate)
    VALUES (2, 'kmb', 4096, 20, GETDATE(), getdate())


    /****** Object:  Table [dbo].[HDP_DbCategory] ******/

    CREATE TABLE [dbo].[HDP_DbCategory](
      [DbCategoryID] [SMALLINT] NOT NULL,
      [DbCategoryName] [VARCHAR](50) NOT NULL,
      [MinTableSizeMB] [INT] NOT NULL,
      [MaxTableSizeMB] [INT] NOT NULL,
      [NumWorkers] [INT] NOT NULL,
      [NumExecutors] [INT] NOT NULL,
      [ExecutorMemory] [INT] NOT NULL,
      [ExecutorCores] [INT] NOT NULL,
      [DriverMemory] [INT] NOT NULL,
      [DriverCores] [INT] NOT NULL,
      [CreateTime] [SMALLDATETIME] NOT NULL,
      [UpdateTime] [SMALLDATETIME] NOT NULL
    ) ON [PRIMARY]

    INSERT INTO HDP_DbCategory
    (DbCategoryId, DbCategoryName, MinTableSizeMB, MaxTableSizeMB, NumWorkers, NumExecutors, ExecutorMemory, ExecutorCores, DriverMemory,
    DriverCores, CreateTime, UpdateTime)
    VALUES
     (1,  'S',      0,       1000, 18,  1,  4096, 1, 1024, 1, GETDATE(), GETDATE()),
     (2,  'M',   1000,       2000,  1,  1,  8192, 1, 1024, 1, GETDATE(), GETDATE()),
     (3,  'L',   2000, 2147483647,  1,  1, 16384, 1, 1024, 1, GETDATE(), GETDATE())

END




