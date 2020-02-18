/*-----------------------------------------------------------------------------
 Case 21749:   Customer account center: customer account summary report 
-----------------------------------------------------------------------------*/
DECLARE @CustomerAccountSummaryRptPermissionID INT

EXEC @CustomerAccountSummaryRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Customer Account Summary',
	@Description='Display, print, and save the customer account summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadCustomerAccountSummary'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadCompanyIndicatorsSummary',
	@PermissionToApplyID=@CustomerAccountSummaryRptPermissionID
GO