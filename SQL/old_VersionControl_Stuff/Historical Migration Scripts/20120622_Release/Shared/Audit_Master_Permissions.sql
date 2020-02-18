

/*Create permissions for master audit log*/

USE Superbill_Shared

DECLARE @MasterAuditPermissionID INT
DECLARE @PracticeSettingsPermissionGrp INT

/* Get Permission Group ID*/
SELECT @PracticeSettingsPermissionGrp = PermissionGroupID 
FROM dbo.PermissionGroup 
WHERE Name = 'Practice Settings'

IF @PracticeSettingsPermissionGrp = 0
RETURN

IF NOT EXISTS(SELECT * FROM dbo.Permissions AS p WHERE p.PermissionValue = 'ViewMasterAuditLog')
BEGIN
	
--Create Permission
EXEC @MasterAuditPermissionID = Shared_AuthenticationDataProvider_CreatePermission 
	@Name = 'View Master Audit log',
    @Description = 'View the master audit log for a practice.', 
    @ViewInKareo = 1,
    @ViewInServiceManager = 1, 
    @PermissionGroupID = @PracticeSettingsPermissionGrp,--Internal Systems
    @PermissionValue = 'ViewMasterAuditLog'
 
--Create sercurity group permission
EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ManagePractice', --system admin
	@PermissionToApplyID = @MasterAuditPermissionID

END

GO
