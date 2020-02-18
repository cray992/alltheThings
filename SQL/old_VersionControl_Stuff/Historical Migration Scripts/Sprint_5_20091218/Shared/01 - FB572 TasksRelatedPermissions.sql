
declare @GroupID int
insert into PermissionGroup(Name, [Description]) values ('Managing Tasks', 'Managing Tasks')
set @GroupID=Scope_Identity()

-- Create Permissions
DECLARE @PermissionID INT

DECLARE @PermissionName VARCHAR(128)
DECLARE @PermissionDescription VARCHAR(500)
DECLARE @PermissionValue VARCHAR(128)

SET @PermissionName='Read Task'
SET @PermissionDescription='Read the Task.'
SET @PermissionValue='ReadUserTask'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='SignOnToKareo',
@PermissionToApplyID=@PermissionID

---
SET @PermissionName='Edit Task'
SET @PermissionDescription='Edit the Task.'
SET @PermissionValue='EditUserTask'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='SignOnToKareo',
@PermissionToApplyID=@PermissionID

---
SET @PermissionName='Create Task'
SET @PermissionDescription='Create the Task.'
SET @PermissionValue='NewUserTask'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='SignOnToKareo',
@PermissionToApplyID=@PermissionID


---
SET @PermissionName='Delete Task'
SET @PermissionDescription='Delete the Task.'
SET @PermissionValue='DeleteUserTask'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='SignOnToKareo',
@PermissionToApplyID=@PermissionID


---
SET @PermissionName='Find Task'
SET @PermissionDescription='Find the Task.'
SET @PermissionValue='FindUserTask'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='SignOnToKareo',
@PermissionToApplyID=@PermissionID


-- delete permissions that were assigned to Kareo User group
delete SecurityGroupPermissions where SecurityGroupID=27 and PermissionID in (
select PermissionID from permissions where name like '%task')
