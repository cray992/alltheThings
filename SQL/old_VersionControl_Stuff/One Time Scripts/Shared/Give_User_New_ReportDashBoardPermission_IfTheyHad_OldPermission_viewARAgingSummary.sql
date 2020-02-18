-- Migrate permission
-- Give users who have permission view_ARAgingSummary, new permission view_KeyIndicatorsReportingDashboard
-- TODO: Code Review -- how can this run efficiently while avoiding dups (in case of rerun)

-- Get New Permission ID
DECLARE @NewPermissionID INT
SET @NewPermissionID = (SELECT PermissionID FROM dbo.UserAccount_Permissions WHERE PermissionValue = 'view_KeyIndicatorsReportingDashboard')

-- Get Old Permission ID
DECLARE @OldPermissionID INT
SET @OldPermissionID = (SELECT PermissionID FROM dbo.UserAccount_Permissions WHERE PermissionValue = 'view_ARAgingSummary')

INSERT INTO dbo.UserAccount_UserPermissions
        ( UserID, PermissionID, CustomerID )
SELECT UserID, @NewPermissionID, CustomerID
FROM dbo.UserAccount_UserPermissions
WHERE PermissionID = @OldPermissionID


