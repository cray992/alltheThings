-- instead of permission we need this as a setting on customer account

/*
IF NOT EXISTS (SELECT * FROM Permissions WHERE PermissionValue='ActivateInstitutionalBilling')
BEGIN
	DECLARE @PermissionID INT
	DECLARE @PermissionGroupID INT

	DECLARE @PermissionName VARCHAR(128)
	DECLARE @PermissionDescription VARCHAR(500)
	DECLARE @PermissionValue VARCHAR(128)

	SELECT	@PermissionGroupID = PermissionGroupID
	FROM	PermissionGroup
	WHERE	Name = 'Setting Up Practices'

	SET @PermissionName='Activate Institutional Billing'
	SET @PermissionDescription='Show users the Instituional Billing features.'
	SET @PermissionValue='ActivateInstitutionalBilling'

	EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
	@Description=@PermissionDescription, @ViewInKareo=0, @ViewInServiceManager=1, 
	@PermissionGroupID=@PermissionGroupID, @PermissionValue=@PermissionValue

	--Grant this permission to KareoAdmins.
	EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='WebServiceAccessAllCustomers',
	@PermissionToApplyID=@PermissionID
END
*/


alter table Customer add InstitutionalBillingEnabled bit default 0
GO
update Customer set InstitutionalBillingEnabled=0

