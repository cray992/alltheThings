-- create a new permission for Encounter Layout editing

declare @GroupID int
select @GroupID=8 -- entering and tracking encounters

-- Create Permissions
DECLARE @PermissionID INT

DECLARE @PermissionName VARCHAR(128)
DECLARE @PermissionDescription VARCHAR(500)
DECLARE @PermissionValue VARCHAR(128)

SET @PermissionName='Customize Encounter Layout'
SET @PermissionDescription='Customize the layout of fields when entering and editing an encounter.'
SET @PermissionValue='EncounterLayout'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='EditEncounter',
@PermissionToApplyID=@PermissionID
