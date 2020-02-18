USE ReportingLog;

DROP TABLE [dbo].[HDP_DbCategory];

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
) ON [PRIMARY];

INSERT INTO HDP_DbCategory
(DbCategoryId, DbCategoryName, MinTableSizeMB, MaxTableSizeMB, NumWorkers, NumExecutors, ExecutorMemory, ExecutorCores, DriverMemory,
DriverCores, CreateTime, UpdateTime)
VALUES
 (1,  'S',      0,       1000, 18,  1,  4096, 1, 1024, 1, GETDATE(), GETDATE()),
 (2,  'M',   1000,       2000,  1,  1,  8192, 1, 1024, 1, GETDATE(), GETDATE()),
 (3,  'L',   2000, 2147483647,  1,  1, 16384, 1, 1024, 1, GETDATE(), GETDATE());