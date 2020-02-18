-- create permissions for Patient Referral Source

declare @GroupID int
select @GroupID=11 -- setting up practices

-- Create Permissions
DECLARE @PermissionID INT

DECLARE @PermissionName VARCHAR(128)
DECLARE @PermissionDescription VARCHAR(500)
DECLARE @PermissionValue VARCHAR(128)

SET @PermissionName='New Patient Referral Source'
SET @PermissionDescription='Create a new patient referral source.'
SET @PermissionValue='NewPatientReferralSource'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='EditPatient',
@PermissionToApplyID=@PermissionID



SET @PermissionName='Read Patient Referral Source'
SET @PermissionDescription='Show the details of a patient referral source.'
SET @PermissionValue='ReadPatientReferralSource'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='EditPatient',
@PermissionToApplyID=@PermissionID



SET @PermissionName='Edit Patient Referral Source'
SET @PermissionDescription='Modify the details of a patient referral source.'
SET @PermissionValue='EditPatientReferralSource'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='EditPatient',
@PermissionToApplyID=@PermissionID



SET @PermissionName='Delete Patient Referral Source'
SET @PermissionDescription='Delete a patient referral source.'
SET @PermissionValue='DeletePatientReferralSource'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='EditPatient',
@PermissionToApplyID=@PermissionID



SET @PermissionName='Find Patient Referral Source'
SET @PermissionDescription='Display and search a list of patient referral sources.'
SET @PermissionValue='FindPatientReferralSource'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='EditPatient',
@PermissionToApplyID=@PermissionID



