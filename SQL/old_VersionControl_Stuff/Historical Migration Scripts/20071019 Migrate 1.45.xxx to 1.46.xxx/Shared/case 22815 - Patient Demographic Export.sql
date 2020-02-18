
/*-----------------------------------------------------------------------------
Case 20921:   Implement new Contract Management Summary
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Patient Demographic Export',
	@Description='Export the patient demographic.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPatientDemographicExport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPatientContactListReport',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO


