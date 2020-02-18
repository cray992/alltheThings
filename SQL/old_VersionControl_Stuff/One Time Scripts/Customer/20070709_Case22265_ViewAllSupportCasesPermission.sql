--case 22265

DECLARE @ViewAllSupportCasesPermissionID INT

EXEC @ViewAllSupportCasesPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='View All Support Cases',
	@Description='View and comment on all Kareo support cases for your company.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=5,
	@PermissionValue='ViewAllSupportCases'
 
EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='NewPractice',
	@PermissionToApplyID=@ViewAllSupportCasesPermissionID
GO