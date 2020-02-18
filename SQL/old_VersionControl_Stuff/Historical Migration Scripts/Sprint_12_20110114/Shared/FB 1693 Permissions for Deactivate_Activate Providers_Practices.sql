
/***MANAGE PROVIDER***********/
DECLARE @OldNewProviderPermissionGroup INT
DECLARE @NewProviderPermissionID INT
DECLARE @NewNewProviderPermissionGroup INT

SELECT @NewProviderPermissionID = PermissionID, @OldNewProviderPermissionGroup = PermissionGroupID
FROM Permissions
WHERE PermissionValue = 'NewProvider'

SELECT @NewNewProviderPermissionGroup = PermissionGroupID
FROM Permissions
WHERE PermissionValue = 'ManageAccount'

UPDATE Permissions
SET 
	PermissionGroupID = @NewNewProviderPermissionGroup,
	Name = 'Manage Provider',
	Description = 'Activate/deactivate/reactivate Providers.',
	PermissionValue = 'ManageProvider'
WHERE PermissionGroupID = @OldNewProviderPermissionGroup 
AND PermissionID = @NewProviderPermissionID


/***MANAGE PRACTICE***********/
DECLARE @OldNewPracticePermissionGroup INT
DECLARE @NewPracticePermissionID INT
DECLARE @NewNewPracticePermissionGroup INT

SELECT @NewPracticePermissionID = PermissionID, @OldNewPracticePermissionGroup = PermissionGroupID
FROM Permissions
WHERE PermissionValue = 'NewPractice'

SELECT @NewNewPracticePermissionGroup = PermissionGroupID
FROM Permissions
WHERE PermissionValue = 'ManageAccount'

UPDATE Permissions
SET 
	PermissionGroupID = @NewNewPracticePermissionGroup,
	Name = 'Manage Practice',
	Description = 'Activate/deactivate/reactivate Practices.',
	PermissionValue = 'ManagePractice'
WHERE PermissionGroupID = @OldNewPracticePermissionGroup 
AND PermissionID = @NewPracticePermissionID
