-- Delete security groups with the read claim settings mode permission
DELETE	FROM SecurityGroupPermissions
WHERE	PermissionID IN (	SELECT	PermissionID
							FROM	Permissions
							WHERE	PermissionValue='ReadClaimSettingsMode'
						)

-- Delete the permissions ReadClaimSettingsMode
DELETE FROM Permissions
WHERE PermissionValue = 'ReadClaimSettingsMode'


