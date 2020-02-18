/******DELETE PERMISSIONS FOR KI SUMMARY YTD REPORT - SPRINT 11 ******/

DECLARE @PermissionID INT
SELECT @PermissionID = PermissionID 
FROM Permissions
WHERE PermissionValue = 'ReadKeyIndicatorsSummaryYTDReview' /*PermissionID = 156*/

IF @PermissionID > 0 
BEGIN
	BEGIN TRAN
	DELETE FROM SecurityGroupPermissions
	WHERE PermissionID = @PermissionID
	
	DELETE FROM Permissions
	WHERE PermissionID = @PermissionID
	
	COMMIT TRAN;
	
END;