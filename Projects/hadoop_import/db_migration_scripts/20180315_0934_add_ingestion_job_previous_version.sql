Use ReportingLog;

IF NOT EXISTS(SELECT *
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'HDP_IngestionJob'
                  AND COLUMN_NAME = 'PreviousVersion')
ALTER TABLE HDP_IngestionJob
  ADD [PreviousVersion] [INT] NOT NULL DEFAULT 0;
