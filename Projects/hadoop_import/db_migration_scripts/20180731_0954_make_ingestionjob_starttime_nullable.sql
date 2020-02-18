USE ReportingLog
ALTER TABLE dbo.HDP_IngestionJob ALTER COLUMN StartTime datetime NULL

IF NOT EXISTS(
        SELECT *
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'HDP_IngestionJob'
        AND COLUMN_NAME = 'CreateTime')
    ALTER TABLE dbo.HDP_IngestionJob ADD CreateTime [DATETIME] NOT NULL DEFAULT(getdate())

DECLARE @sql NVARCHAR(255)

SELECT @sql = 'ALTER TABLE dbo.HDP_IngestionJob DROP CONSTRAINT ' + d.NAME
FROM
     sys.tables t
     join sys.default_constraints d on d.parent_object_id = t.object_id
     join sys.columns c on c.object_id = t.object_id and c.column_id = d.parent_column_id
WHERE t.name = 'HDP_IngestionJob'
AND c.name = 'StartTime'

IF @sql is not null
    EXEC sp_executesql @sql
