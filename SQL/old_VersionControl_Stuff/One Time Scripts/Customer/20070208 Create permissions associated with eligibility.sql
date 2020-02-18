----------------------------------------------------------------
-- CASE 17937 permissions associated with checking eligibility 
----------------------------------------------------------------
/* Create new 'Check Patient Eligibility' permission ... */
DECLARE @CheckPatientEligibilityPermissionID INT

EXEC @CheckPatientEligibilityPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Check Patient Eligibility',
	@Description='Request a patient eligibility report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=6,
	@PermissionValue='CheckPatientEligibility'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@CheckPatientEligibilityPermissionID
GO

/* Create new 'Find Patient Eligibility Report' permission ... */
DECLARE @FindPatientEligibilityReportPermissionID INT

EXEC @FindPatientEligibilityReportPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Find Patient Eligibility Report',
	@Description='Display a list of patient eligibility reports.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=6,
	@PermissionValue='FindPatientEligibilityReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@FindPatientEligibilityReportPermissionID
GO


/* Create new 'Read Patient Eligibility Report' permission ... */
DECLARE @ReadPatientEligibilityReportPermissionID INT

EXEC @ReadPatientEligibilityReportPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Patient Eligibility Report',
	@Description='Show the details of a patient eligibility report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=6,
	@PermissionValue='ReadPatientEligibilityReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@ReadPatientEligibilityReportPermissionID
GO

