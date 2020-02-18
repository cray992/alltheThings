-- EN-12121
USE ReportingLog

DECLARE @sql NVARCHAR(255)

IF EXISTS(
        SELECT *
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'HDP_IngestionJob'
        AND COLUMN_NAME = 'CrateTime')
  BEGIN
    SELECT @sql = 'ALTER TABLE dbo.HDP_IngestionJob DROP CONSTRAINT ' + d.NAME
    FROM
      sys.tables t
      join sys.default_constraints d on d.parent_object_id = t.object_id
      join sys.columns c on c.object_id = t.object_id and c.column_id = d.parent_column_id
    WHERE t.name = 'HDP_IngestionJob'
    AND c.name = 'CrateTime';

    IF @sql is not null
      EXEC sp_executesql @sql

    ALTER TABLE HDP_IngestionJob DROP COLUMN CrateTime;
  END