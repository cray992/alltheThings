if EXISTS (select * from information_schema.columns where table_name = 'Report' and column_name = 'ReportConfigID')
BEGIN

ALTER TABLE dbo.Report
DROP CONSTRAINT DF_Report_ReportConfigID

ALTER TABLE dbo.Report
DROP CONSTRAINT [CK_Report_ReportConfig]

ALTER TABLE dbo.Report
DROP COLUMN ReportConfigID

END
go

IF NOT EXISTS ( SELECT TOP 1 1 FROM dbo.CustomerProperties AS CP WHERE [Key] = 'ReportPartitionID' )
INSERT INTO dbo.CustomerProperties
        ( [Key], Value )
VALUES  ( 'ReportPartitionID', -- Key - varchar(50)
          '1'  -- Value - varchar(max)
          )

ALTER TABLE dbo.Report
ADD [ReportConfigID] INT NOT NULL
CONSTRAINT [DF_Report_ReportConfigID] DEFAULT 1
go

ALTER TABLE [dbo].[Report]  WITH CHECK ADD CONSTRAINT [CK_Report_ReportConfig] CHECK (
dbo.fn_ReportDataProvider_CheckReportConfigConstraint(ReportConfigID)=1 )

go
