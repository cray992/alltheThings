/*-----------------------------------------------------------------------------
 Case 22687  Support: Update Help.kareo.com & Invoicing with new Support Plan
-----------------------------------------------------------------------------*/
DECLARE @EditSupportPlanPermissionID INT

EXEC @EditSupportPlanPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Edit Support Plan',
	@Description='Change the support plan for the entire company.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=12,
	@PermissionValue='EditSupportPlan'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='DeletePractice',
	@PermissionToApplyID=@EditSupportPlanPermissionID
GO

