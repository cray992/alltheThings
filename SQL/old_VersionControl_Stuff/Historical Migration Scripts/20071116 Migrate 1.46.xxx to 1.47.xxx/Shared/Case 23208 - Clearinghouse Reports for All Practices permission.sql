/*-----------------------------------------------------------------------------
Case 23208 - Clearinghouse Reports: Add separate permission for company level access
-----------------------------------------------------------------------------*/
DECLARE @FindClearinghouseReportAllPractices INT

EXEC @FindClearinghouseReportAllPractices=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Find Clearinghouse Report for All Practices',
	@Description='Display and search a list of clearinghouse reports for all practices.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=9,
	@PermissionValue='FindClearinghouseReportAllPractices'
 
EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='NewPractice',
	@PermissionToApplyID=@FindClearinghouseReportAllPractices

GO
