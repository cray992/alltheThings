IF EXISTS (SELECT 1 from [dbo].[HDP_DbCategory]) DROP TABLE [dbo].[HDP_DbCategory];

CREATE TABLE [dbo].[HDP_DbCategory](
  [DbCategoryId] [SMALLINT] NOT NULL,
  [DbCategoryName] [VARCHAR](50) NOT NULL,
  [MinTableSizeMB] [INT] NOT NULL,
  [MaxTableSizeMB] [INT] NOT NULL,
  [NumWorkers] [INT] NOT NULL,
  [WorkerMemory] [INT] NOT NULL,
  [WorkerCores] [INT] NOT NULL,
  [CreateTime] [SMALLDATETIME] NOT NULL,
  [UpdateTime] [SMALLDATETIME] NOT NULL
) ON [PRIMARY];

INSERT INTO HDP_DbCategory (DbCategoryId, DbCategoryName, MinTableSizeMB, MaxTableSizeMB,
                                    NumWorkers, WorkerMemory, WorkerCores, CreateTime, UpdateTime)
VALUES (1, 'XS', 0, 2500, 16, 2048, 1, GETDATE(), GETDATE()),
 (2, 'S', 2500, 5000, 8, 4096, 1, GETDATE(), GETDATE()),
 (3, 'M', 5000, 7500, 4, 8192, 1, GETDATE(), GETDATE()),
 (4, 'L', 7500, 10000, 2, 16384, 1, GETDATE(), GETDATE()),
 (5, 'XL', 10000, 2147483647, 1, 32768, 1, GETDATE(), GETDATE());
