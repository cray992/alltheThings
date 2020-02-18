USE Superbill_Shared
/*FB Case 1737*/

/*a) Create a new permission group named "Company" with a description of 
"Manage company-wide options"*/

DECLARE @CompanyPermissionGroupID INT
EXEC @CompanyPermissionGroupID = 
Shared_AuthenticationDataProvider_CreatePermissionGroup 
@Name = 'Company', 
@Description = 'Manage company-wide options'

/* 
b] Move the existing "Edit Support Plan" under the "Practices" permission 
group to the new "Company" permission group
c] Rename the existing "Edit Support Plan" to "Manage Account" changing 
the description to "Edit account information, change plans and cancel account.
*/

DECLARE @PracticePermissionGroup INT
DECLARE @EditSupportPlanPermissionID INT

SELECT @EditSupportPlanPermissionID = PermissionID
FROM Permissions
WHERE PermissionValue = 'EditSupportPlan'

SELECT @PracticePermissionGroup = PermissionGroupID
FROM PermissionGroup
WHERE Name = 'Practices'

UPDATE Permissions
SET 
	PermissionGroupID = @CompanyPermissionGroupID,
	Name = 'Manage Account',
	Description = 'Edit account information, change plans and cancel account.',
	PermissionValue = 'ManageAccount'
WHERE PermissionGroupID = @PracticePermissionGroup 
AND PermissionID = @EditSupportPlanPermissionID


/* 
I] If user currently has “Read Customer Account Summary” permission, then automatically 
grant them the “Manage account” permission.
*/

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadCustomerAccountSummary',
@PermissionToApplyID=@EditSupportPlanPermissionID


/*
II] Allow the “Manage account” permission to the standard “Company Administrator” 
security group that we create for new customer accounts
III] Make sure the default security groups that get created upon a new customer signup 
grants the stock Administrator group access to the "Manage Account" permission. 
Check with Alex for more information about the default security groups. 
*/

-- copy permissions for stock permission groups
DECLARE @SecurityGroupID INT
SELECT @SecurityGroupID = SecurityGroupID 
	FROM SecurityGroup 
	WHERE CustomerID is null 
	and ViewInKareo=0 
	and ViewInServiceManager=0 
	and SecurityGroupName like '%Admin%'
IF NOT EXISTS
(
	SELECT * FROM SecurityGroupPermissions 
	WHERE SecurityGroupID = @SecurityGroupID AND PermissionID = @EditSupportPlanPermissionID
)
BEGIN
	INSERT INTO SecurityGroupPermissions 
	(
		SecurityGroupID, 
		PermissionID, 
		Allowed, 
		Denied, 
		CreatedDate, 
		CreatedUserID, 
		ModifiedDate, 
		ModifiedUserID
	)	
	VALUES
	(
		@SecurityGroupID, 
		@EditSupportPlanPermissionID, 
		1, 
		0, 
		GetDate(), 
		0, 
		GetDate(), 
		0
	)
END