
/*-----------------------------------------------------------------------------
 Case 20989:   Implement new Insurance Collections Summary report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Insurance Collections Summary Report',
	@Description='Display, print, and save the insurance collections summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadInsuranceCollectionsSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadARAgingByInsurance',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO
