

/******DELETE PERMISSIONS FOR UPDATING CLEARINGHOUSE REPORTS ******/

DECLARE @PermissionID INT
SELECT @PermissionID = PermissionID 
FROM Permissions
WHERE PermissionValue = 'UpdateClearingHouseReport' /*PermissionID = 241*/

IF @PermissionID > 0 
BEGIN
	BEGIN TRAN
	DELETE FROM SecurityGroupPermissions
	WHERE PermissionID = @PermissionID
	
	DELETE FROM Permissions
	WHERE PermissionID = @PermissionID
	
	COMMIT TRAN;
	
END;
