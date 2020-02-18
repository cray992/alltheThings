Use ReportingLog;

TRUNCATE TABLE HDP_IngestionJob;

IF NOT EXISTS(SELECT *
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'HDP_IngestionJob'
                  AND COLUMN_NAME = 'TableName')
ALTER TABLE HDP_IngestionJob
  ADD [TableName] VARCHAR(128) NOT NULL;

IF NOT EXISTS(SELECT *
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'HDP_IngestionJob'
                  AND COLUMN_NAME = 'DbTypeId')
ALTER TABLE HDP_IngestionJob
  ADD [DbTypeId] NUMERIC(2,0) NOT NULL CHECK (DbTypeId IN(2, 1, 0));

