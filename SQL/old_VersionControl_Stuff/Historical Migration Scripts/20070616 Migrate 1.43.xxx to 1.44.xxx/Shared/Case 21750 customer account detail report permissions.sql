/*-----------------------------------------------------------------------------
 Case 21750 customer account detail report 
-----------------------------------------------------------------------------*/
DECLARE @CustomerAccountDetailRptPermissionID INT

EXEC @CustomerAccountDetailRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Customer Account Detail',
	@Description='Display, print, and save the customer account detail report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadCustomerAccountDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadCompanyIndicatorsSummary',
	@PermissionToApplyID=@CustomerAccountDetailRptPermissionID
GO