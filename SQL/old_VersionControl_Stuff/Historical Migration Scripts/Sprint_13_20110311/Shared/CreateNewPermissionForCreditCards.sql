-- create a new permission for Credit Card / ECheck payments

declare @GroupID int
select @GroupID=32 -- Payments & Refunds

-- Create Permissions
DECLARE @PermissionID INT

DECLARE @PermissionName VARCHAR(128)
DECLARE @PermissionDescription VARCHAR(500)
DECLARE @PermissionValue VARCHAR(128)

SET @PermissionName='Authorize Credit Cards and Electronic Checks'
SET @PermissionDescription='Perform Credit Card Authorization.'
SET @PermissionValue='CreditCardECheckAuthorization'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='NewPayment',
@PermissionToApplyID=@PermissionID
