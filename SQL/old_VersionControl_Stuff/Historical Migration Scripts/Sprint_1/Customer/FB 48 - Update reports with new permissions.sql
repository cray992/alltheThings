-- Fogbugs 48 - Add new permissions used for reports
UPDATE	Report
SET		PermissionValue = 'ReadAppointmentSummaryReport',
		ModifiedDate = getdate()
WHERE	Name = 'Appointments Summary'

UPDATE	Report
SET		PermissionValue = 'ReadMissedEncountersReport',
		ModifiedDate = getdate()
WHERE	Name = 'Missed Encounters'

UPDATE	Report
SET		PermissionValue = 'ReadSettledChargesSummaryReport',
		ModifiedDate = getdate()
WHERE	Name = 'Settled Charges Summary'

UPDATE	Report
SET		PermissionValue = 'ReadMissingDocumentsReport',
		ModifiedDate = getdate()
WHERE	Name = 'Missing Documents'

UPDATE	Report
SET		PermissionValue = 'ReadChargesExport',
		ModifiedDate = getdate()
WHERE	Name = 'Charges Export'

UPDATE	Report
SET		PermissionValue = 'ReadPatientInsuranceAuthorizationReport',
		ModifiedDate = getdate()
WHERE	Name = 'Patient Insurance Authorization'

UPDATE	Report
SET		PermissionValue = 'ReadProviderUtilizationReport',
		ModifiedDate = getdate()
WHERE	Name = 'Provider Utilization'

UPDATE	Report
SET		PermissionValue = 'ReadUnscheduledAnalysisReport',
		ModifiedDate = getdate()
WHERE	Name = 'Unscheduled Analysis'
