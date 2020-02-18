Use ReportingLog;

TRUNCATE TABLE HDP_IngestionJob;

IF NOT EXISTS(SELECT *
              FROM INFORMATION_SCHEMA.COLUMNS
              WHERE TABLE_NAME = 'HDP_IngestionJob'
                    AND COLUMN_NAME = 'IngestionJobType')
  ALTER TABLE HDP_IngestionJob ADD [IngestionJobType] NUMERIC(2,0) NOT NULL;