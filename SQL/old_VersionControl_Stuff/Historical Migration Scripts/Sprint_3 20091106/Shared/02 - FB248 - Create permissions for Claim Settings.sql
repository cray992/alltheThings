DECLARE @PermissionID INT

DECLARE @PermissionName VARCHAR(128)
DECLARE @PermissionDescription VARCHAR(500)
DECLARE @PermissionValue VARCHAR(128)

SET @PermissionName='Edit Claim Settings Mode'
SET @PermissionDescription='Edit the Claim Settings mode for all practices.'
SET @PermissionValue='EditClaimSettingsMode'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=13, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='EditSecurityGroup',
@PermissionToApplyID=@PermissionID

SET @PermissionName='Read Claim Settings Mode'
SET @PermissionDescription='Read the Claim Settings mode for all practices.'
SET @PermissionValue='ReadClaimSettingsMode'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=13, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadCustomer',
@PermissionToApplyID=@PermissionID
