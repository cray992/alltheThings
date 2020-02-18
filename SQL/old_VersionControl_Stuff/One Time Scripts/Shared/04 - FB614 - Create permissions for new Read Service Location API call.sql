DECLARE @PermissionID INT

DECLARE @PermissionName VARCHAR(128)
DECLARE @PermissionDescription VARCHAR(500)
DECLARE @PermissionValue VARCHAR(128)

SET @PermissionName='Read Service Location Data'
SET @PermissionDescription='Read service location data via Kareo web services.'
SET @PermissionValue='WebServiceReadServiceLocation'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=26, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='WebServiceReadPatient',
@PermissionToApplyID=@PermissionID