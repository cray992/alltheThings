

----------------------------------------------------------
--  Case 17933:   No permission for Patient Detail report
----------------------------------------------------------

DECLARE @PaymentByProcedureRptPermissionID INT
EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Patient Detail Report',
	@Description='Display, print, and save the patient detail report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPatientDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPatient',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO


----------------------------------------------------------
-- Case 17934:   No permission for Missed Encounters report
----------------------------------------------------------
DECLARE @PaymentByProcedureRptPermissionID INT
EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Missed Encounters Report',
	@Description='Display, print, and save the missed encounters report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadMissedEncountersReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='PrintAppointments',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID

GO


----------------------------------------------------------
--  No permission for Appointment Summary report
----------------------------------------------------------
DECLARE @PaymentByProcedureRptPermissionID INT
EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Appointment Summary Report',
	@Description='Display, print, and save the appointments summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadAppointmentsSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='PrintAppointments',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID

GO



