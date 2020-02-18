/*-----------------------------------------------------------------------------
 Case 22761 Change practice & provider cancellation policy through tweaks to application
-----------------------------------------------------------------------------*/
DECLARE @DeletePracticeWithoutWarningPermissionID INT

EXEC @DeletePracticeWithoutWarningPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Delete Practice Without Warning',
	@Description='Delete a practice record without being stopped by an attrition warning.', 
	@ViewInKareo=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=12,
	@PermissionValue='DeletePracticeWithoutWarning'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='EditMetricsForPractice',
	@PermissionToApplyID=@DeletePracticeWithoutWarningPermissionID
GO

DECLARE @DeleteProviderWithoutWarningPermissionID INT

EXEC @DeleteProviderWithoutWarningPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Delete Provider Without Warning',
	@Description='Delete a provider record without being stopped by an attrition warning.', 
	@ViewInKareo=0,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='DeleteProviderWithoutWarning'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='EditMetricsForPractice',
	@PermissionToApplyID=@DeleteProviderWithoutWarningPermissionID
GO

