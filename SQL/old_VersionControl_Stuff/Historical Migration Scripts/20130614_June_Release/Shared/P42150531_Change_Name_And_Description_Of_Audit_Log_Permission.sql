UPDATE dbo.UserAccount_Permissions
SET [Name] = 'Master Audit Log',
	[Description] = 'Allows a user to view the entries in the Master Audit logs for tracking Encounter, User, Patient Record, Provider, and Claim changes. The Master Audit logs track key changes made to records by users within the system.'
WHERE PermissionID = 16