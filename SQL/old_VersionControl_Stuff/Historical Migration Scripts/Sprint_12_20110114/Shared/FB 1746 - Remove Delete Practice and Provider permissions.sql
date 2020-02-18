-- Remove all permissions that begin with DeletePractice
DELETE FROM dbo.SecurityGroupPermissions WHERE PermissionID IN (
SELECT PermissionID FROM Permissions WHERE PermissionValue LIKE 'DeletePractice%')

DELETE FROM Permissions WHERE PermissionValue LIKE 'DeletePractice%'

-- Remove all permissions that begin with DeleteProvider
DELETE FROM dbo.SecurityGroupPermissions WHERE PermissionID IN (
SELECT PermissionID FROM Permissions WHERE PermissionValue LIKE 'DeleteProvider%')

DELETE FROM Permissions WHERE PermissionValue LIKE 'DeleteProvider%'
