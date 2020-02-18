USE Superbill_Shared
/**/

/*Setting permissions for kareo admin/Quest Admin to view and edit HL7 Integration Options
*/

IF NOT EXISTS ( SELECT * FROM dbo.Permissions AS P WHERE PermissionValue = 'EditHL7IntegratonOptions' )
BEGIN

DECLARE @EditHL7IntegratonOptions INT


DECLARE @KareoAdminUserSecurityGroupID INT
SET @KareoAdminUserSecurityGroupID = dbo.Shared_GeneralDataProvider_GetPropertyValue('KareoAdminUserSecurityGroupID')

DECLARE @QuestAdminUserSecurityGroupID INT
SET @QuestAdminUserSecurityGroupID = dbo.Shared_GeneralDataProvider_GetPropertyValue('QuestAdminUserSecurityGroupID')

--Find
EXEC @EditHL7IntegratonOptions= Shared_AuthenticationDataProvider_CreatePermission 
	@Name = 'Edit the HL7 Integration Options',
    @Description = 'Permission that gives the ability to edit a practice''s HL7 integration options.', 
    @ViewInKareo = 0,
    @ViewInServiceManager = 1, @PermissionGroupID = 24,--Internal Systems
    @PermissionValue = 'EditHL7IntegratonOptions'
     
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
VALUES  ( @KareoAdminUserSecurityGroupID ,
          @EditHL7IntegratonOptions,
          1,
          0,
          GetDate(),
          0,
          GetDate(),
          0
        )
        
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
VALUES  ( @QuestAdminUserSecurityGroupID ,
          @EditHL7IntegratonOptions,
          1,
          0,
          GetDate(),
          0,
          GetDate(),
          0
        )
END
SELECT * FROM dbo.Permissions AS P WHERE PermissionValue = 'EditHL7IntegratonOptions'