-- New Permission ID
DECLARE @PermissionID INT
SET @PermissionID = (SELECT PermissionID FROM dbo.UserAccount_Permissions WHERE PermissionValue = 'view_KeyIndicatorsReportingDashboard')

-- Legacy Permission ID
DECLARE @Legacy_PermissionID INT
SET @Legacy_PermissionID = (SELECT PermissionID FROM Permissions WHERE PermissionValue = 'KeyIndicatorsReportingDashboard')

-- Cleanup in case of re-run
DELETE dbo.UserAccount_RolePermissions
WHERE PermissionID = @PermissionID

-- Legacy cleanup
DELETE SecurityGroupPermissions
WHERE PermissionID = @Legacy_PermissionID

-- Add new permission view_KeyIndicatorsReportingDashboard to 'Billing Manager' Role
INSERT INTO dbo.UserAccount_RolePermissions
        ( RoleID, PermissionID )
SELECT RoleID, @PermissionID 
FROM dbo.UserAccount_Roles ur
WHERE ur.[Name] = 'Billing Manager'

-- Add new permission view_KeyIndicatorsReportingDashboard to 'Office Manager' Role
INSERT INTO dbo.UserAccount_RolePermissions
        ( RoleID, PermissionID )
SELECT RoleID, @PermissionID 
FROM dbo.UserAccount_Roles ur
WHERE ur.[Name] = 'Office Manager'

-- Add new permission view_KeyIndicatorsReportingDashboard to 'Provider' Role
INSERT INTO dbo.UserAccount_RolePermissions
        ( RoleID, PermissionID )
SELECT RoleID, @PermissionID 
FROM dbo.UserAccount_Roles ur
WHERE ur.[Name] = 'Provider'

-- Add new permission view_KeyIndicatorsReportingDashboard to 'Administrator' Role
INSERT INTO dbo.UserAccount_RolePermissions
        ( RoleID, PermissionID )
SELECT RoleID, @PermissionID 
FROM dbo.UserAccount_Roles ur
WHERE ur.[Name] = 'Administrator' OR [Name] = 'Quest Admin' OR [Name] = 'Care360 Administrator'

-- Add new permission view_KeyIndicatorsReportingDashboard to 'Biller' Role
INSERT INTO dbo.UserAccount_RolePermissions
        ( RoleID, PermissionID )
SELECT RoleID, @PermissionID 
FROM dbo.UserAccount_Roles ur
WHERE ur.[Name] = 'Biller'

-- Add new permission KeyIndicatorsReportingDashboard to * LEGACY * 'Office Manager' Role
INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          Denied
        )
SELECT SecurityGroupID, @Legacy_PermissionID, 1, '2013-05-13 20:30:55', 0, '2013-05-13 20:30:55', 0, NULL, 0
FROM dbo.SecurityGroup
WHERE SecurityGroupName = 'Office Manager'


-- Add new permission KeyIndicatorsReportingDashboard to * LEGACY * 'Billing Manager' Role
INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          Denied
        )
SELECT SecurityGroupID, @Legacy_PermissionID, 1, '2013-05-13 20:30:55', 0, '2013-05-13 20:30:55', 0, NULL, 0
FROM dbo.SecurityGroup
WHERE SecurityGroupName = 'Billing Manager'

-- Add new permission KeyIndicatorsReportingDashboard to * LEGACY * 'Biller' Role
INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          Denied
        )
SELECT SecurityGroupID, @Legacy_PermissionID, 1, '2013-05-13 20:30:55', 0, '2013-05-13 20:30:55', 0, NULL, 0
FROM dbo.SecurityGroup
WHERE SecurityGroupName = 'Biller'

-- Add new permission KeyIndicatorsReportingDashboard to * LEGACY * 'Provider' Role
INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          Denied
        )
SELECT SecurityGroupID, @Legacy_PermissionID, 1, '2013-05-13 20:30:55', 0, '2013-05-13 20:30:55', 0, NULL, 0
FROM dbo.SecurityGroup
WHERE SecurityGroupName = 'Provider'

-- Add new permission KeyIndicatorsReportingDashboard to * LEGACY * 'Admin' Role
INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          Denied
        )
SELECT SecurityGroupID, @Legacy_PermissionID, 1, '2013-05-13 20:30:55', 0, '2013-05-13 20:30:55', 0, NULL, 0
FROM dbo.SecurityGroup
WHERE SecurityGroupName = 'Administrator' OR [SecurityGroupName] = 'Quest Admin' OR [SecurityGroupName] = 'Care360 Administrator'