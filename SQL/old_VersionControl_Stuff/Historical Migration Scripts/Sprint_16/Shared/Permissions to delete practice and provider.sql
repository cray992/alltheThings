  
	 /*New permissions to delete a provider and practice available to Kareo Admins only */
	 
	 DECLARE @DeleteProviderPermissionID INT
	 DECLARE @DeletePracticePermissionID INT

	  /* Delete Provider */
	  SELECT @DeleteProviderPermissionID = PermissionID 
	  FROM dbo.Permissions WHERE PermissionValue = 'Delete Provider'; 
	  IF @DeleteProviderPermissionID IS NULL OR @DeleteProviderPermissionID <= 0
	  BEGIN
		  EXEC @DeleteProviderPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
		  @Name='Delete Provider',
		  @Description= 'Delete an inactive provider from a practice.', 
		  @ViewInKareo=0,
		  @ViewInServiceManager=1,
		  @PermissionGroupID=33,
		  @PermissionValue='DeleteProvider'

		  /*  Give Kareo Admins Rights */
		  EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
		  @CheckPermissionValue='KareoAdminAccountManagement',
		  @PermissionToApplyID=@DeleteProviderPermissionID
		END
	  
	  SELECT @DeletePracticePermissionID = PermissionID 
	  FROM dbo.Permissions WHERE PermissionValue = 'Delete Practice'; 
	  IF @DeletePracticePermissionID IS NULL OR @DeletePracticePermissionID <= 0
	  BEGIN
		  /* Delete Practice */
		  EXEC @DeletePracticePermissionID=Shared_AuthenticationDataProvider_CreatePermission 
		  @Name='Delete Practice',
		  @Description= 'Delete an inactive practice.', 
		  @ViewInKareo=0,
		  @ViewInServiceManager=1,
		  @PermissionGroupID=12,
		  @PermissionValue='DeletePractice'

		  /*  Give Kareo Admins Rights*/
		  EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
		  @CheckPermissionValue='KareoAdminAccountManagement',
		  @PermissionToApplyID=@DeletePracticePermissionID
	 END
		  
