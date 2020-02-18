-- Fogbugs 48 - Add new permissions used for reports
DECLARE @NewPermission INT

-- Appointment Summary Report permission
EXEC @NewPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Appointment Summary Report',
	@Description='Display, print, and save the appointment summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadAppointmentSummaryReport'
 
EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='PrintAppointments',
	@PermissionToApplyID=@NewPermission

-- Missed Encounters Report permission
EXEC @NewPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Missed Encounters Report',
	@Description='Display, print, and save the missed encounters report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadMissedEncountersReport'
 
EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='PrintAppointments',
	@PermissionToApplyID=@NewPermission

-- Settled Charges Summary permission
EXEC @NewPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Settled Charges Summary Report',
	@Description='Display, print, and save the settled charges summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadSettledChargesSummaryReport'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadChargesSummaryReport',
	@PermissionToApplyID=@NewPermission

-- Missing Documents permission
EXEC @NewPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Missing Documents Report',
	@Description='Display, print, and save the missed documents report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadMissingDocumentsReport'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadChargesSummaryReport',
	@PermissionToApplyID=@NewPermission

-- Charges Export permission
EXEC @NewPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Charges Export',
	@Description='Export the charges data.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadChargesExport'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPatientDemographicExport',
	@PermissionToApplyID=@NewPermission

-- Patient Insurance Authorization Report permission
EXEC @NewPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Patient Insurance Authorization Report',
	@Description='Display, print, and save the patient insurance authorization report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPatientInsuranceAuthorizationReport'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPatientDemographicExport',
	@PermissionToApplyID=@NewPermission

-- Provider Utilization Report permission
EXEC @NewPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Provider Utilization Report',
	@Description='Display, print, and save the provider utilization report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadProviderUtilizationReport'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadAppointmentSummaryReport',
	@PermissionToApplyID=@NewPermission

-- Provider Utilization Report permission
EXEC @NewPermission=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Unscheduled Analysis Report',
	@Description='Display, print, and save the unscheduled analysis report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadUnscheduledAnalysisReport'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadAppointmentSummaryReport',
	@PermissionToApplyID=@NewPermission