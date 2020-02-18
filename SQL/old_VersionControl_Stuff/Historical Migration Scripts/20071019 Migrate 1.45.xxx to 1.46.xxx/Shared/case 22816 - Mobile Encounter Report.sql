
/*-----------------------------------------------------------------------------
Case 22816:   Reports: Create mobile encounters report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Mobile Encounters Summary Report',
	@Description='Display, print, and save the mobile encounters summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadMobileEncountersSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadEncountersSummaryReport',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO


DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Mobile Encounters Detail Report',
	@Description='Display, print, and save the mobile encounters detail report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadMobileEncountersDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadEncountersDetailReport',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO



