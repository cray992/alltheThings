Use ReportingLog;

TRUNCATE TABLE HDP_DbCategory;

IF NOT EXISTS(SELECT *
              FROM INFORMATION_SCHEMA.COLUMNS
              WHERE TABLE_NAME = 'HDP_DbCategory'
                    AND COLUMN_NAME = 'DriverMemory')
  ALTER TABLE HDP_DbCategory ADD [DriverMemory] INT NOT NULL;

IF NOT EXISTS(SELECT *
              FROM INFORMATION_SCHEMA.COLUMNS
              WHERE TABLE_NAME = 'HDP_DbCategory'
                    AND COLUMN_NAME = 'DriverCores')
ALTER TABLE HDP_DbCategory ADD [DriverCores] INT NOT NULL;

INSERT INTO HDP_DbCategory
(DbCategoryId, DbCategoryName, MinTableSizeMB, MaxTableSizeMB, NumWorkers, WorkerMemory, WorkerCores, DriverMemory,
DriverCores, CreateTime, UpdateTime)
VALUES
(1, 'XS',      0,       2500, 16,  1024, 1, 1024, 1, GETDATE(), GETDATE()),
(2,  'S',   2500,       5000,  8,  2048, 1, 1024, 1, GETDATE(), GETDATE()),
(3,  'M',   5000,       7500,  4,  4096, 1, 1024, 1, GETDATE(), GETDATE()),
(4,  'L',   7500,      10000,  2,  8192, 1, 1024, 1, GETDATE(), GETDATE()),
(5,  'XL', 10000, 2147483647,  1, 16384, 1, 1024, 1, GETDATE(), GETDATE());
