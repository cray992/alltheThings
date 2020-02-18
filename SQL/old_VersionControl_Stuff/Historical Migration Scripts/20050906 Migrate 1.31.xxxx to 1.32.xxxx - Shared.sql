/*

SHARED DATABASE UPDATE SCRIPT

v1.31.xxxx to v1.32.xxxx		
*/
----------------------------------

--BEGIN TRAN 

----------------------------------

---------------------------------------------------------------------------------------
--case 6584 - Add "closing the books" task to Business Manager (also case 6734)
---------------------------------------------------------------------------------------


DECLARE @newPerm1ID int
DECLARE @newPerm2ID int
DECLARE @newPerm3ID int
DECLARE @newPerm4ID int
DECLARE @newPerm5ID int
DECLARE @newPerm6ID int
DECLARE @newPerm7ID int
DECLARE @newPermGroupID int

INSERT INTO permissiongroup (name,description)
VALUES ('Manage Accounting Options','Manage accounting options relating to closing the books.')

SET @newPermGroupID = SCOPE_IDENTITY()

INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Change Closing Date','Update the accounting closing date for a practice',0,0,1,1,@newPermGroupID,'ChangeClosingDate')

SET @newPerm1ID = SCOPE_IDENTITY()

INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Change Closing the Books Options','Toggle the closing date from on to off, and other closing the books options',0,0,1,1,@newPermGroupID,'ChangeClosingBooksOptions')

SET @newPerm2ID = SCOPE_IDENTITY()

INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Override Void Claim Restrictions','Override restrictions on voiding claims, specifically related to closing the books date',0,0,1,1,@newPermGroupID,'OverrideVoidClaimRestrictions')

SET @newPerm3ID = SCOPE_IDENTITY()

INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Override Claim Charge Edit Restrictions','Override restrictions on editing claim charges, specifically related to closing the books date',0,0,1,1,@newPermGroupID,'OverrideClaimChargeEditRestrictions')

SET @newPerm4ID = SCOPE_IDENTITY()

INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Override Delete Last Claim Transaction Restrictions','Override restrictions on deleting the last claim transaction, specifically related to closing the books date',0,0,1,1,@newPermGroupID,'OverrideDeleteLastClaimTransactionRestrictions')

SET @newPerm5ID = SCOPE_IDENTITY()

INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Override Delete Payment Restrictions','Override restrictions on deleting payments, specifically related to closing the books date',0,0,1,1,@newPermGroupID,'OverrideDeletePaymentRestrictions')

SET @newPerm6ID = SCOPE_IDENTITY()

INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Override Delete Refund Restrictions','Override restrictions on deleting refunds, specifically related to closing the books date',0,0,1,1,@newPermGroupID,'OverrideDeleteRefundRestrictions')

SET @newPerm7ID = SCOPE_IDENTITY()

DECLARE @targetPermissionID int
SET @targetPermissionID = (SELECT PermissionID FROM Permissions WHERE PermissionValue='SignOnToAdministrator')


DECLARE @currentSecurityGroupID int

DECLARE curse CURSOR
READ_ONLY
FOR 
	SELECT SecurityGroupID
	FROM dbo.SecurityGroup
	WHERE SecurityGroupID IN 
		(SELECT DISTINCT SecurityGroupID FROM SecurityGroupPermissions WHERE PermissionID = @targetPermissionID)

OPEN curse

FETCH NEXT FROM curse INTO @currentSecurityGroupID
WHILE (@@fetch_status = 0)
BEGIN
	INSERT INTO SecurityGroupPermissions
		(SecurityGroupID, PermissionID, Allowed,Denied)
	VALUES
		(@currentSecurityGroupID, @newPerm1ID, 1, 0)

	INSERT INTO SecurityGroupPermissions
		(SecurityGroupID, PermissionID, Allowed,Denied)
	VALUES
		(@currentSecurityGroupID, @newPerm2ID, 1, 0)
		
	INSERT INTO SecurityGroupPermissions
		(SecurityGroupID, PermissionID, Allowed,Denied)
	VALUES
		(@currentSecurityGroupID, @newPerm3ID, 1, 0)

	INSERT INTO SecurityGroupPermissions
		(SecurityGroupID, PermissionID, Allowed,Denied)
	VALUES
		(@currentSecurityGroupID, @newPerm4ID, 1, 0)
		
	INSERT INTO SecurityGroupPermissions
		(SecurityGroupID, PermissionID, Allowed,Denied)
	VALUES
		(@currentSecurityGroupID, @newPerm5ID, 1, 0)

	INSERT INTO SecurityGroupPermissions
		(SecurityGroupID, PermissionID, Allowed,Denied)
	VALUES
		(@currentSecurityGroupID, @newPerm6ID, 1, 0)

	INSERT INTO SecurityGroupPermissions
		(SecurityGroupID, PermissionID, Allowed,Denied)
	VALUES
		(@currentSecurityGroupID, @newPerm7ID, 1, 0)

FETCH NEXT FROM curse INTO @currentSecurityGroupID
END

CLOSE curse
DEALLOCATE curse


GO

---------------------------------------------------------------------------------------
--case 6287 - Add permission for the Patient Financial History report
---------------------------------------------------------------------------------------

DECLARE @permGroupID int
DECLARE @newReportPerm int

-- Get the permission group to associate with the new permission
SELECT	@permGroupID = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Generating Reports'

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Read Patient Financial History','Display, print, and save the Patient Financial History report.',1,1,1,1,@permGroupID,'ReadPatientFinancialHistory')

SET @newReportPerm = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the Patient Transactions Detail report
DECLARE @transactionsDetailPerm int

SELECT	@transactionsDetailPerm = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'ReadPatientTransactionsDetail'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@newReportPerm,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @transactionsDetailPerm

GO

---------------------------------------------------------------------------------------
--case XXXX - Description
---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
