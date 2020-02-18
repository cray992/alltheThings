/*----------------------------------

DATABASE UPDATE SCRIPT

v1.40.xxxx to v1.41.xxxx
----------------------------------*/

/*----------------------------------------------------------------------------- 
Case 19200 - Practice Details: Add Subscription Edition, Support Plan dropdowns  
-----------------------------------------------------------------------------*/

/* Change edit practice permission name ... */
UPDATE [Permissions]
SET [Name] = 'Edit Practice Information'
WHERE [Name] = 'Edit Contact Information'
GO



/*-----------------------------------------------------------------------------
Case 19576
-----------------------------------------------------------------------------*/
DROP TABLE UserRole

CREATE TABLE UserRole(
	UserRoleID int IDENTITY(1,1) NOT NULL,
	UserRoleName nchar(64)  NOT NULL,
	Description nchar(256)  NULL,
	CreatedDate datetime NOT NULL,
	CreatedUserID int NOT NULL,
	ModifiedDate datetime NULL,
	ModifiedUserID int NULL,
	RecordTimeStamp timestamp NOT NULL,
	DashboardTypeID int NOT NULL,
	CustomerID int NOT NULL,
 CONSTRAINT PK_UserPracticeRole PRIMARY KEY  
(
	UserRoleID ASC
)) 
GO

ALTER TABLE UserRole  
ADD  CONSTRAINT FK_UserRole_DashboardType 
FOREIGN KEY(DashboardTypeID)
REFERENCES DashboardType (DashboardTypeID)
GO

ALTER TABLE dbo.UserRole  
ADD  CONSTRAINT FK_UserRole_Customer 
FOREIGN KEY(CustomerID)
REFERENCES dbo.Customer (CustomerID)
GO

ALTER TABLE Users 
ADD UserRoleID int NULL,
CONSTRAINT FK_Users_UserRole 
FOREIGN KEY(UserRoleID)
REFERENCES UserRole (UserRoleID)
GO

ALTER TABLE CustomerUsers 
ADD UserRoleID int NULL,
CONSTRAINT FK_CustomerUsers_UserRole 
FOREIGN KEY(UserRoleID)
REFERENCES UserRole (UserRoleID)
GO
----------------------------------------------------------------
-- Cpermissions for the user role 
----------------------------------------------------------------
/* Create new 'New User Role' permission ... */
DECLARE @NewUserRolePermissionID INT

EXEC @NewUserRolePermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='New User Role',
	@Description='Create a new user role record.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=13,
	@PermissionValue='NewUserRole'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='NewPatient',
	@PermissionToApplyID=@NewUserRolePermissionID
GO

/* Create new 'Edit User Role' permission ... */
DECLARE @EditUserRolePermissionID INT

EXEC @EditUserRolePermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Edit User Role',
	@Description='Modify the details of a user role record.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=13,
	@PermissionValue='EditUserRole'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='EditPatient',
	@PermissionToApplyID=@EditUserRolePermissionID
GO

/* Create new 'Read User Role' permission ... */
DECLARE @ReadUserRolePermissionID INT

EXEC @ReadUserRolePermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read User Role',
	@Description='Show the details of a user role record.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=13,
	@PermissionValue='ReadUserRole'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@ReadUserRolePermissionID
GO

/* Create new 'Find User Role' permission ... */
DECLARE @FindUserRolePermissionID INT

EXEC @FindUserRolePermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Find User Role',
	@Description='Display and search a list of user role records.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=13,
	@PermissionValue='FindUserRole'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@FindUserRolePermissionID
GO

/* Create new 'Delete User Role' permission ... */
DECLARE @DeleteUserRolePermissionID INT

EXEC @DeleteUserRolePermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Delete User Role',
	@Description='Delete a user role record.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=13,
	@PermissionValue='DeleteUserRole'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='DeletePatient',
	@PermissionToApplyID=@DeleteUserRolePermissionID
GO

--migrate existing dashboard setup
INSERT INTO UserRole
           (UserRoleName
           ,Description
           ,CreatedDate
           ,CreatedUserID
           ,ModifiedDate
           ,ModifiedUserID
           ,DashboardTypeID
           ,CustomerID)
SELECT 'Medical Office User','The user has access to medical office functionality', GETDATE(),0,NULL,NULL,1,CustomerID
FROM Customer
WHERE DBActive=1

INSERT INTO UserRole
           (UserRoleName
           ,Description
           ,CreatedDate
           ,CreatedUserID
           ,ModifiedDate
           ,ModifiedUserID
           ,DashboardTypeID
           ,CustomerID)
SELECT 'Business Office User', 'The user has access to business office functionality', GETDATE(),0,NULL,NULL,2,CustomerID
FROM Customer
WHERE DBActive=1

UPDATE CU SET UserRoleID=UR.UserRoleID
FROM Users U INNER JOIN CustomerUsers CU
ON U.UserID=CU.UserID
INNER JOIN UserRole UR
ON CU.CustomerID=UR.CustomerID AND U.DashboardTypeID=UR.DashboardTypeID

GO

-- Make User Role Available in view. Used for customer reports.
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vDatabaseUsers]'))
DROP VIEW [dbo].[vDatabaseUsers]

GO

	CREATE view [dbo].[vDatabaseUsers]
	AS

		select DatabaseName, u.UserID, FirstName, LastName, emailAddress, ur.UserRoleName
		from Customer c
			INNER JOIN CustomerUsers cu on cu.CustomerID = c.CUstomerID
			INNER JOIN Users u on u.UserID = cu.UserID
			LEFT JOIN UserRole ur ON ur.UserRoleID = cu.UserRoleID


Go


/*-----------------------------------------------------------------------------
-- Case 19950:   Create support for record-specific Categories
-----------------------------------------------------------------------------*/

--permissions for categories

/* Create new 'New Category' permission ... */
DECLARE @NewCategoryPermissionID INT

EXEC @NewCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='New Category',
	@Description='Create a record category.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='NewCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='NewProcedureCategory',
	@PermissionToApplyID=@NewCategoryPermissionID
GO

/* Create new 'Edit Category' permission ... */
DECLARE @EditCategoryPermissionID INT

EXEC @EditCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Edit Category',
	@Description='Modify the details of a record category.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='EditCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='EditProcedureCategory',
	@PermissionToApplyID=@EditCategoryPermissionID
GO

/* Create new 'Read Category' permission ... */
DECLARE @ReadCategoryPermissionID INT

EXEC @ReadCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Category',
	@Description='Show the details of a record category.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='ReadCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='SignOnToKareo',
	@PermissionToApplyID=@ReadCategoryPermissionID
GO

/* Create new 'Find Category' permission ... */
DECLARE @FindCategoryPermissionID INT

EXEC @FindCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Find Category',
	@Description='Display and search a list of record categories.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='FindCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='SignOnToKareo',
	@PermissionToApplyID=@FindCategoryPermissionID
GO

/* Create new 'Delete Category' permission ... */
DECLARE @DeleteCategoryPermissionID INT

EXEC @DeleteCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Delete Category',
	@Description='Delete a category record.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=11,
	@PermissionValue='DeleteCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='DeleteProcedureCategory',
	@PermissionToApplyID=@DeleteCategoryPermissionID
GO


/*-----------------------------------------------------------------------------
-- Case XXXXX:   
-----------------------------------------------------------------------------*/
