	  DECLARE @CopyERAPermissionID INT
	  DECLARE @MoveERAPermissionID INT

	  /* Add Copy ERA Permission */
	  EXEC @CopyERAPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	  @Name='Copy ERA',
	  @Description= 'Copy an ERA from one practice to another.', 
	  @ViewInKareo=0,
	  @ViewInServiceManager=1,
	  @PermissionGroupID=28,
	  @PermissionValue='CopyERA'

	  /*  Give Kareo Admins Rights to Copy */
	  EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	  @CheckPermissionValue='KareoAdminAccountManagement',
	  @PermissionToApplyID=@CopyERAPermissionID

	  /* Add Move ERA Permission */
	  EXEC @MoveERAPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	  @Name='Move ERA',
	  @Description= 'Move an ERA from one practice to another.', 
	  @ViewInKareo=1,
	  @ViewInServiceManager=1,
	  @PermissionGroupID=28,
	  @PermissionValue='MoveERA'

	  /*  Give Company Admins Rights to Copy */
	  EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	  @CheckPermissionValue='ManageAccount',
	  @PermissionToApplyID=@MoveERAPermissionID
	  
	  	  /*  Give Kareo Admins Rights to Move */
	  EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	  @CheckPermissionValue='KareoAdminAccountManagement',
	  @PermissionToApplyID=@MoveERAPermissionID
