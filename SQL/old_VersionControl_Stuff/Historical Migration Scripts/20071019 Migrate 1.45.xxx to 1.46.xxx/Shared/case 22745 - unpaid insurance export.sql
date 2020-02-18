
/*-----------------------------------------------------------------------------
Case 20921:   Implement new Unpaid Insurance Export
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Unpaid Insurance Claims Export',
	@Description='Export the unpaid insurance claims report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadUnpaidInsuranceClaimsExport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadUnpaidInsuranceClaimsReport',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO

