
/*-----------------------------------------------------------------------------
Case 20921:   Implement new Contract Management Summary
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Unapplied Analysis Report',
	@Description='Display, print, and save the unapplied analysis report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadUnappliedAnalysisReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPaymentsApplicationSummaryReport',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO
