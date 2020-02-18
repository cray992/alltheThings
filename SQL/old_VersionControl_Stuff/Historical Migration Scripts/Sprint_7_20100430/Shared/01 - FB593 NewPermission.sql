
-- find permission group
declare @GroupID int
select @GroupID=PermissionGroupID from PermissionGroup where Name='Managing Tasks'
print @GroupID


-- Create Permissions
DECLARE @PermissionID INT

DECLARE @PermissionName VARCHAR(128)
DECLARE @PermissionDescription VARCHAR(500)
DECLARE @PermissionValue VARCHAR(128)

SET @PermissionName='Assign Task To User'
SET @PermissionDescription='Assign task to a user.'
SET @PermissionValue='AssignTaskToUser'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='EditUserTask',
@PermissionToApplyID=@PermissionID
