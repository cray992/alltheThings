/*----------------------------------

DATABASE UPDATE SCRIPT - SHARED

v1.36.xxxx to v1.37.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------


/*-----------------------------------------------------------------------------
Case 10604 - Add new report "Provider Number"
-----------------------------------------------------------------------------*/
DECLARE @ProviderNumberRptPermissionID INT

EXEC @ProviderNumberRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Provider Numbers Report',
	@Description='Display, print, and save the provider numbers report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadProviderNumbersReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadProvider',
	@PermissionToApplyID=@ProviderNumberRptPermissionID

GO

/*-----------------------------------------------------------------------------
Case 10681 - Add new report "Payment by Procedure"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Payment by Procedure Report',
	@Description='Display, print, and save the payment by procedure report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPaymentByProcedureReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPaymentsSummary',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO


/*-----------------------------------------------------------------------------
Case 10613 - Add new report "Payer Mix Summary"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Payer Mix Summary Report',
	@Description='Display, print, and save the payer mix summary report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPayerMixSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPaymentsSummary',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO




/*-----------------------------------------------------------------------------
Case 10610 - Add new report "Service Locations"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Service Locations Report',
	@Description='Display, print, and save the service locations report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadServiceLocationsReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindServiceLocation',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO


/*-----------------------------------------------------------------------------
Case 10605 - Add new report "Group Numbers"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Group Numbers Report',
	@Description='Display, print, and save the group numbers report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadGroupNumbersReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindGroupNumber',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO



/*-----------------------------------------------------------------------------
Case 10611 - Add new report "Providers Report"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Providers Report',
	@Description='Display, print, and save the providers report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadProvidersReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindProvider',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID

GO



/*-----------------------------------------------------------------------------
Case 10608 - Add new report "Referring Physicians"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Referring Physicians Report',
	@Description='Display, print, and save the referring physicians report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadReferringPhysiciansReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindReferringPhysician',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID

GO


--ROLLBACK
--COMMIT


