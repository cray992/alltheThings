--for shared only

BEGIN TRAN

DECLARE @PermissionGroupID int
SET @PermissionGroupID = (SELECT PermissionGroupID FROM PermissionGroup WHERE Name = 'Managing Workers Comp Offices')

UPDATE 
	Permissions
SET 
	PermissionGroupID = @PermissionGroupID
WHERE 
	PermissionValue IN 
		('FindWorkersCompContact','NewWorkersCompContact','ReadWorkersCompContact','EditWorkersCompContact','PrintWorkersCompContact','DeleteWorkersCompContact')

--COMMIT