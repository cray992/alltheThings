alter table practice drop column Metric
GO

Alter table practice add MetricDRO decimal(9,2) default 0
GO

update practice
SET MetricDRO = 23.0
Go