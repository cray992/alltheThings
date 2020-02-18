/*----------------------------------

DATABASE UPDATE SCRIPT SHARED

v1.34.xxxx to v1.35.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------


--------------------------------------------------
--case 8136: Add security permissions for attorney
--------------------------------------------------
declare
	@groupID8136 int,

	@Find8136 int,
	@New8136 int,
	@Read8136 int,
	@Edit8136 int,
	@Delete8136 int

INSERT INTO [dbo].[PermissionGroup]([Name], [Description])
VALUES('Managing Attorneys','Managing Attorney Records')
set @groupID8136=Scope_Identity()

--CREATE FIND ATTORNEY PERMISSION
---------------------------------
INSERT INTO [dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES(
'Find Attorney',
'Display and search a list of Attorney records.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID8136,'FindAttorney')
set @Find8136=Scope_Identity()

--CREATE NEW ATTORNEY PERMISSION
---------------------------------
INSERT INTO [dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES(
'New Attorney',
'Create a new Attorney record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID8136,'NewAttorney')
set @New8136=Scope_Identity()

--CREATE READ ATTORNEY PERMISSION
---------------------------------
INSERT INTO [dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES(
'Read Attorney',
'Read Attorney record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID8136,'ReadAttorney')
set @Read8136=Scope_Identity()

--CREATE EDIT ATTORNEY PERMISSION
---------------------------------
INSERT INTO [dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES(
'Edit Attorney',
'Edit Attorney record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID8136,'EditAttorney')
set @Edit8136=Scope_Identity()


--CREATE DELETE ATTORNEY PERMISSION
---------------------------------
INSERT INTO [dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES(
'Delete Attorney',
'Delete an Attorney record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID8136,'DeleteAttorney')
set @Delete8136=Scope_Identity()

-- assign attorney-related permissions to users
declare
	@EditPatient8136 int,
	@SignOnAdmin8136 int

SELECT @EditPatient8136=PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'EditPatient'

SELECT @SignOnAdmin8136=PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'SignOnToAdministrator'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@Find8136,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @EditPatient8136

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@New8136,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @EditPatient8136

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@Read8136,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @EditPatient8136

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@Edit8136,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @SignOnAdmin8136

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@Delete8136,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @SignOnAdmin8136



--------------------------------------------------------------------------------------------------------------
-- case 8181 - Patient Statements from PSC

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PatientStatementsVendor]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PatientStatementsVendor]
GO

CREATE TABLE PatientStatementsVendor (
	[PatientStatementsVendorId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_PatientStatementsVendor_PatientStatementsVendorID 
		PRIMARY KEY NONCLUSTERED,
	[VendorName] varchar(128), 
	[Active] bit, 
	[FtpServerOut] varchar(128), 
	[FtpServerIn] varchar(128), 
	[FtpReportsFolder] varchar(128), 
	[FtpDirOutTesting] varchar(128), 
	[FtpDirOutProduction] varchar(128), 
	[DoEncrypt] bit, 
	[DoDecrypt] bit, 
	[EncryptionOriginator] varchar(128), 
	[EncryptionRecipient] varchar(128), 
	[EncryptionPassphrase] text, 
	[DecryptionOriginator] varchar(128), 
	[DecryptionRecipient] varchar(128), 
	[DecryptionPassphrase] text,
	[Notes] text
)

GO

INSERT PatientStatementsVendor (VendorName, Active, FtpServerOut, FtpServerIn,
				FtpReportsFolder, FtpDirOutTesting, FtpDirOutProduction, DoEncrypt, DoDecrypt,
				EncryptionOriginator, EncryptionRecipient, EncryptionPassphrase,
				DecryptionOriginator, DecryptionRecipient, DecryptionPassphrase)
			VALUES ('ProxyMed', 1, 'claimsatl.proxymed.com', 'claimsatl.proxymed.com',
				'outgoing', 'testing', 'incoming', 1, 1,
				'sergei@kareo.com', 'gwooden@proxymed.com', 'the kareo software is best', 
				'gwooden@proxymed.com', 'sergei@kareo.com', 'the kareo software is best')

INSERT PatientStatementsVendor (VendorName, Active, FtpServerOut, FtpServerIn,
				FtpReportsFolder, FtpDirOutTesting, FtpDirOutProduction, DoEncrypt, DoDecrypt,
				EncryptionOriginator, EncryptionRecipient, EncryptionPassphrase,
				DecryptionOriginator, DecryptionRecipient, DecryptionPassphrase)
			VALUES ('PSC Info Group', 1, 'ftp.pscinfogroup.com', 'ftp.pscinfogroup.com',
				'outgoing', 'testing', 'incoming', 1, 1,
				'sergei@kareo.com', 'dataexpress@pscinfogroup.com', 'the kareo software is best', 
				'dataexpress@pscinfogroup.com', 'sergei@kareo.com', 'the kareo software is best')

INSERT PatientStatementsVendor (VendorName, Active, FtpServerOut, FtpServerIn,
				FtpReportsFolder, FtpDirOutTesting, FtpDirOutProduction, DoEncrypt, DoDecrypt,
				EncryptionOriginator, EncryptionRecipient, EncryptionPassphrase,
				DecryptionOriginator, DecryptionRecipient, DecryptionPassphrase)
			VALUES ('KDB01 for Testing', 1, 'kdb01', 'kdb01',
				'outgoing', 'testing', 'incoming', 1, 1,
				'sergei@kareo.com', 'dataexpress@pscinfogroup.com', 'the kareo software is best', 
				'dataexpress@pscinfogroup.com', 'sergei@kareo.com', 'the kareo software is best')

GO

---------------------------------------------------------------------------------------
-- Case 8248 - Add Permissions for the Business Rules
---------------------------------------------------------------------------------------

DECLARE @permGroupID int
DECLARE @newBRPerm int
DECLARE @kareoAdminSecurityGroup int

-- Get the permission group to associate with the new permission
SELECT	@permGroupID = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Managing Practices'

-- Get the kareo admin security group
SELECT	@kareoAdminSecurityGroup = SecurityGroupID
FROM	SecurityGroup
WHERE	SecurityGroupName = 'Kareo Admin'

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Find Business Rule','Display and search a list of Business Rule records.',0,0,0,1,@permGroupID,'FindBusinessRule')

SET @newBRPerm = SCOPE_IDENTITY()

-- Only grant the Kareo Admin group permission to this new permission
INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
VALUES	(@kareoAdminSecurityGroup,
	@newBRPerm,
	1,
	0)

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('New Business Rule','Create a new Business Rule record.',0,0,0,1,@permGroupID,'NewBusinessRule')

SET @newBRPerm = SCOPE_IDENTITY()

-- Only grant the Kareo Admin group permission to this new permission
INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
VALUES	(@kareoAdminSecurityGroup,
	@newBRPerm,
	1,
	0)

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Read Business Rule','Read Business Rule record.',0,0,0,1,@permGroupID,'ReadBusinessRule')

SET @newBRPerm = SCOPE_IDENTITY()

-- Only grant the Kareo Admin group permission to this new permission
INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
VALUES	(@kareoAdminSecurityGroup,
	@newBRPerm,
	1,
	0)

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Edit Business Rule','Modify Business Rule record.',0,0,0,1,@permGroupID,'EditBusinessRule')

SET @newBRPerm = SCOPE_IDENTITY()

-- Only grant the Kareo Admin group permission to this new permission
INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
VALUES	(@kareoAdminSecurityGroup,
	@newBRPerm,
	1,
	0)

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Delete Business Rule','Delete an Business Rule record.',0,0,0,1,@permGroupID,'DeleteBusinessRule')

SET @newBRPerm = SCOPE_IDENTITY()

-- Only grant the Kareo Admin group permission to this new permission
INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
VALUES	(@kareoAdminSecurityGroup,
	@newBRPerm,
	1,
	0)

GO
---------------------------------------------------------------------------------------------------------
--          CASE 8137
----------------------------------------------------------------------------------------------------------

--- EMPLOYER SECURITY PERMISSIONS
--------------------------------------------------------------------------------------------------------------
--CREATE EMPLOYER PERMISSION GROUP
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[PermissionGroup]([Name], [Description])
VALUES('Manage Employers','Manage employers including adding and updating employer records.')
GO
----------------------------------------------------------------------------------------------





--****************************************
--------------------------------------------------------------------------------------------------------------
--KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
DECLARE @manageEmployersGroupID INT
DECLARE @kareoAdminGroupID INT
DECLARE @kareoUserGroupID INT
DECLARE @newEmployerPermissionID INT

SET @manageEmployersGroupID = (SELECT PermissionGroupID FROM PermissionGroup WHERE name='Manage Employers')
SET @kareoAdminGroupID = (SELECT securityGroupID FROM dbo.SecurityGroup WHERE SecurityGroupName = 'Kareo Admin' AND CustomerID is null)
SET @kareoUserGroupID = (SELECT securityGroupID FROM dbo.SecurityGroup WHERE SecurityGroupName = 'Kareo User' AND CustomerID is null)

--------------------------------------------------------------------------------------------------------------
-- CREATE FIND EMPLOYER PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES(
'Find Employer',
'Display and search a list of Employer records.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@manageEmployersGroupID,'FindEmployer')

SET @newEmployerPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoAdminGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoUserGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)



--------------------------------------------------------------------------------------------------------------
-- CREATE NEW EMPLOYER PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES('New Employer',	
'Create a new Employer record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@manageEmployersGroupID,
'NewEmployer')

SET @newEmployerPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoAdminGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoUserGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)


--------------------------------------------------------------------------------------------------------------
-- CREATE READ EMPLOYER PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES('Read Employer',	
'Show the details of a Employer record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@manageEmployersGroupID,
'ReadEmployer')

SET @newEmployerPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoAdminGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoUserGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)

--------------------------------------------------------------------------------------------------------------
--CREATE EDIT EMPLOYER PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES('Edit Employer',	
'Modify the details of a Employer record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@manageEmployersGroupID,
'EditEmployer')


SET @newEmployerPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoAdminGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoUserGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)

--------------------------------------------------------------------------------------------------------------
--CREATE PRINT EMPLOYER PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES('Print Employer',	
'Print the details of a Employer record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@manageEmployersGroupID,
'PrintEmployer')

SET @newEmployerPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoAdminGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoUserGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)

--------------------------------------------------------------------------------------------------------------
-- CREATE DELETE EMPLOYER PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES('Delete Employer',	
'Delete a Employer record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@manageEmployersGroupID,
'DeleteEmployer')

SET @newEmployerPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoAdminGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@kareoUserGroupID, @newEmployerPermissionID,1,GetDate(),0,GetDate(),0,0)

GO

--****************************************

----------------------------------------------------------------------------------------------------------

--- WORKERSCOMP SECURITY PERMISSIONS
--------------------------------------------------------------------------------------------------------------
--CREATE WORKERSCOMP PERMISSION GROUP
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--CREATE WORKERSCOMP PERMISSION GROUP
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[PermissionGroup]([Name], [Description])
VALUES('Managing Workers Comp Offices','Manage Workers Comp Offices, including adding and updating Workers Comp Office records.')
GO
----------------------------------------------------------------------------------------------





--****************************************
--------------------------------------------------------------------------------------------------------------
--KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
DECLARE @groupID INT
DECLARE @securityGroupID INT
DECLARE @UsersecurityGroupID INT
DECLARE @newPermissionID INT

SET @groupID = (SELECT PermissionGroupID FROM PermissionGroup WHERE name='Manage Workers Comp Offices')
SET @securityGroupID = (SELECT securityGroupID FROM dbo.SecurityGroup WHERE SecurityGroupName = 'Kareo Admin' AND CustomerID is null)
SET @UsersecurityGroupID = (SELECT securityGroupID FROM dbo.SecurityGroup WHERE SecurityGroupName = 'Kareo User' AND CustomerID is null)

--------------------------------------------------------------------------------------------------------------
-- CREATE FIND WORKERSCOMP PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES(
'Find Workers Comp Offices',
'Display and search a list of Workers Comp Office records.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID,'FindWorkersCompContact')

SET @newPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@securityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@UsersecurityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)



--------------------------------------------------------------------------------------------------------------
-- CREATE NEW WORKERSCOMP PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES('New Workers Comp Office',	
'Create a new Workers Comp Office record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID,
'NewWorkersCompContact')

SET @newPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@securityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@UsersecurityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)

--------------------------------------------------------------------------------------------------------------
-- CREATE READ WORKERSCOMP PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES('Read Workers Comp Office',	
'Show the details of a Workers Comp Office record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID,
'ReadWorkersCompContact')

SET @newPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@securityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@UsersecurityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)
--------------------------------------------------------------------------------------------------------------
--CREATE EDIT WORKERSCOMP PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES('Edit Workers Comp Office',	
'Modify the details of a Workers Comp Office record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID,
'EditWorkersCompContact')


SET @newPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@securityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@UsersecurityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)
--------------------------------------------------------------------------------------------------------------
--CREATE PRINT WORKERSCOMP PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES('Print Workers Comp Office',	
'Print the details of a Workers Comp Office record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID,
'PrintWorkersCompContact')

SET @newPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@securityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@UsersecurityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)
--------------------------------------------------------------------------------------------------------------
-- CREATE DELETE WORKERSCOMP PERMISSION KAREO ADMIN
--------------------------------------------------------------------------------------------------------------
INSERT INTO [superbill_shared].[dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES('Delete Workers Comp Office',	
'Delete a Workers Comp Office record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID,
'DeleteWorkersCompContact')

SET @newPermissionID = SCOPE_IDENTITY()


INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@securityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)

INSERT INTO [superbill_shared].[dbo].[SecurityGroupPermissions]
([SecurityGroupID], 
[PermissionID], 
[Allowed], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[Denied])
VALUES(
@UsersecurityGroupID, @newPermissionID,1,GetDate(),0,GetDate(),0,0)

GO

--------------------------------------------------------------------------------------------------------------
--CASE 8306 - Change Schema of Procedure and Diagnosis Code Dictionaries
--------------------------------------------------------------------------------------------------------------
ALTER TABLE ProcedureCodeDictionary ADD OfficialName VARCHAR(300), LocalName VARCHAR(100), OfficialDescription VARCHAR(500)
GO

UPDATE ProcedureCodeDictionary SET OfficialName=ProcedureName, LocalName=LEFT(Description,100)

ALTER TABLE ProcedureCodeDictionary DROP COLUMN ProcedureName, Description
GO

ALTER TABLE DiagnosisCodeDictionary ADD OfficialName VARCHAR(300), LocalName VARCHAR(100), OfficialDescription VARCHAR(500)
GO

UPDATE DiagnosisCodeDictionary SET OfficialName=DiagnosisName, LocalName=LEFT(Description,100)

ALTER TABLE DiagnosisCodeDictionary DROP COLUMN DiagnosisName, Description

GO

--------------------------------------------------------------------------------------------------------------
--CASE 8317 - Change text for Accounting Options permission area
--------------------------------------------------------------------------------------------------------------

UPDATE PermissionGroup 
SET 
	Name = 'Managing Accounting Options',  
	Description = 'Managing accounting options relating to closing the books.'
WHERE Name = 'Manage Accounting Options'

GO

--ROLLBACK
--COMMIT
