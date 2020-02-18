
/*-----------------------------------------------------------------------------
 Case 20990:   Implement new Insurance Collections Detail report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Insurance Collections Detail Report',
	@Description='Display, print, and save the insurance collections detail report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadInsuranceCollectionsDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadARAgingByInsurance',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO
