UPDATE [dbo].[Permissions]
SET [Name] = 'Save Encounter for Review',
	[Description] = 'Save encounter for review.'
WHERE PermissionID = 145
  
UPDATE [dbo].[Permissions]
SET [Name] = 'Save Encounter as Draft',
	[Description] = 'Save encounter as a draft.'
WHERE PermissionID = 139