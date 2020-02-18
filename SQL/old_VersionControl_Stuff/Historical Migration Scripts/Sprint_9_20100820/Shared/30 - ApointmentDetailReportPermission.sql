DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
      @Name='Read Appointment Detail Report',
      @Description='Display, print, and save the appointment detail report.', 
      @ViewInKareo=1,
      @ViewInServiceManager=1,
      @PermissionGroupID=10,
      @PermissionValue='ReadAppointmentDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
      @CheckPermissionValue='ReadAppointmentSummaryReport',
      @PermissionToApplyID=@PaymentByProcedureRptPermissionID

