   
INSERT INTO
	Permissions
	(Name, Description,ViewInMedicalOffice,ViewInBusinessManager,ViewInAdministrator,ViewInServiceManager,PermissionGroupID,PermissionValue)
VALUES
	('Read Own User Account','Show the details of a user''s own account.',0,0,0,1,13,'ReadOwnUserAccount');
GO

INSERT INTO
	Permissions
	(Name, Description,ViewInMedicalOffice,ViewInBusinessManager,ViewInAdministrator,ViewInServiceManager,PermissionGroupID,PermissionValue)
VALUES
	('Edit Own User Account','Modify the details of a user''s own account.',0,0,0,1,13,'EditOwnUserAccount');
GO



DECLARE @ReadOwnUserPermissionID int
DECLARE @EditOwnUserPermissionID int
SET @ReadOwnUserPermissionID = (SELECT PermissionID FROM Permissions WHERE PermissionValue = 'ReadOwnUserAccount')
SET @EditOwnUserPermissionID = (SELECT PermissionID FROM Permissions WHERE PermissionValue = 'EditOwnUserAccount')

DECLARE @KareoUserSecurityGroupID int
SET @KareoUserSecurityGroupID = dbo.Shared_GeneralDataProvider_GetPropertyValue('KareoDefaultUserSecurityGroupID')

INSERT INTO 
	SecurityGroupPermissions
	(SecurityGroupID, PermissionID, Allowed, Denied)
VALUES
	(@KareoUserSecurityGroupID, @ReadOwnUserPermissionID, 1, 0)

INSERT INTO 
	SecurityGroupPermissions
	(SecurityGroupID, PermissionID, Allowed, Denied)
VALUES
	(@KareoUserSecurityGroupID, @EditOwnUserPermissionID, 1, 0)


GO
