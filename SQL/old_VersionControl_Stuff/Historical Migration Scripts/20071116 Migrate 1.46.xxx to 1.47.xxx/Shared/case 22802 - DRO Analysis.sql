
/*-----------------------------------------------------------------------------
Case 20921:   Implement new Contract Management Summary
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Days Revenue Outstanding Analysis Report',
	@Description='Display, print, and save the Days Revenue Outstanding Analysis Report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadDaysRevenueOutstandingAnalysisReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadKeyIndicatorsSummary',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO


