USE Superbill_Shared
/**/

/*Setting permissions for kareo admin to view internal message when 
cancelling a customer account or reactivating within 30 days of decativation*/
DECLARE @KareoAdminDeactivationPermissionID INT


--Find
EXEC @KareoAdminDeactivationPermissionID= Shared_AuthenticationDataProvider_CreatePermission 
	@Name = 'Deactivating and reactivation related permssions for Kareo admin',
    @Description = 'Permission that gives the ability to reactivate within 30 days as well as view internal messages for Kareo admin', 
    @ViewInKareo = 0,
    @ViewInServiceManager = 1, @PermissionGroupID = 24,--Internal Systems
    @PermissionValue = 'KareoAdminAccountManagement'
 
--Kareo Admin Permission Allowed
INSERT  dbo.SecurityGroupPermissions
        ( 
          SecurityGroupID ,
          PermissionID ,
          Allowed,
          Denied,
	      CreatedDate, 
		  CreatedUserID, 
		  ModifiedDate, 
		  ModifiedUserID
          
        )
VALUES  ( 26 ,
          @KareoAdminDeactivationPermissionID ,
          1,
          0,
          GetDate(),
          0,
          GetDate(),
          0
        )
