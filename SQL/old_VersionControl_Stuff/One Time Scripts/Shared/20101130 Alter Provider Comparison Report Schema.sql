ALTER TABLE CompanyMetrics_ProviderComparisonRptKeys ADD StartDate DATETIME, EndDate DATETIME
GO
ALTER TABLE CompanyMetrics_ProviderComparisonRptKeys ADD ProcessComplete BIT CONSTRAINT DF_ProviderComparisonRptKeys_ProcessComplete DEFAULT 0 WITH VALUES