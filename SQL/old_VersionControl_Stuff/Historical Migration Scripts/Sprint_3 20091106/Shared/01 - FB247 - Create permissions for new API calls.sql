DECLARE @PermissionID INT

DECLARE @PermissionName VARCHAR(128)
DECLARE @PermissionDescription VARCHAR(500)
DECLARE @PermissionValue VARCHAR(128)

SET @PermissionName='Create Customer'
SET @PermissionDescription='Create a new Kareo Customer via Kareo web services (integrator specific endpoint).'
SET @PermissionValue='WebServiceCreateCustomer'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=0, @ViewInServiceManager=1, 
@PermissionGroupID=26, @PermissionValue=@PermissionValue
