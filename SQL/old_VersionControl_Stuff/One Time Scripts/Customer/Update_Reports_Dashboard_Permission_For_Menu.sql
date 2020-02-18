-- Change permission needed for Reports Dashboard menu to display
UPDATE dbo.Report
SET PermissionValue = 'KeyIndicatorsReportingDashboard'
WHERE MenuName = 'Re&porting Dashboard'