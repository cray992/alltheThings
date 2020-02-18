/*

SHARED DATABASE UPDATE SCRIPT

v1.32.xxxx to v1.33.xxxx		
*/
----------------------------------

--BEGIN TRAN 

----------------------------------


---------------------------------------------------------------------------------------

--case 7108 - Contract Browser
---------------------------------------------------------------------------------------

declare
	@permEditContract7108 int,
	@permDeleteContract7108 int,
	@permCreateContract7108 int,
	@permFindContract7108 int,
	@permViewContract7108 int

insert into permissions (
	Name, Description, 
	ViewInMedicalOffice, ViewInBusinessManager, ViewInAdministrator,
	PermissionGroupID, PermissionValue)
values ('Edit Contract', 'Modify the details of a contract',
	1, 1, 1,
	11, 'EditContract')
set @permEditContract7108=Scope_Identity()

insert into permissions (
	Name, Description, 
	ViewInMedicalOffice, ViewInBusinessManager, ViewInAdministrator,
	PermissionGroupID, PermissionValue)
values ('Delete Contract', 'Delete a contract',
	1, 1, 1,
	11, 'DeleteContract')
set @permDeleteContract7108=Scope_Identity()

insert into permissions (
	Name, Description, 
	ViewInMedicalOffice, ViewInBusinessManager, ViewInAdministrator,
	PermissionGroupID, PermissionValue)
values ('New Contract', 'Create a new contract',
	1, 1, 1,
	11, 'NewContract')
set @permCreateContract7108=Scope_Identity()

insert into permissions (
	Name, Description, 
	ViewInMedicalOffice, ViewInBusinessManager, ViewInAdministrator,
	PermissionGroupID, PermissionValue)
values ('Find Contract', 'Display a list of contracts',
	1, 1, 1,
	11, 'FindContract')
set @permFindContract7108=Scope_Identity()

insert into permissions (
	Name, Description, 
	ViewInMedicalOffice, ViewInBusinessManager, ViewInAdministrator,
	PermissionGroupID, PermissionValue)
values ('Read Contract', 'Show the details of a contract',
	1, 1, 1,
	11, 'ReadContract')
set @permViewContract7108=Scope_Identity()

-- Grant or deny access to this permission by copying the groups granted or denied access to the Practice Fee
DECLARE @Fee7108 int

SELECT	@Fee7108 = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'FindFeeSchedule'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@permFindContract7108,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @Fee7108
-------

SELECT	@Fee7108 = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'NewFeeSchedule'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@permCreateContract7108,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @Fee7108
-------

SELECT	@Fee7108 = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'ReadFeeSchedule'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@permViewContract7108,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @Fee7108
-------

SELECT	@Fee7108 = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'EditFeeSchedule'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@permEditContract7108,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @Fee7108
-------

SELECT	@Fee7108 = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'DeleteFeeSchedule'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@permDeleteContract7108,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @Fee7108


GO

---------------------------------------------------------------------------------------

--case 6333 - Implement Permissions for Insurance Companies

---------------------------------------------------------------------------------------

DECLARE @NewInsCompanyPerm TABLE 
	( [Name] VARCHAR(128),
	[Description] VARCHAR(500),
	[PermissionValue] VARCHAR(128),
	[OldPermissionValue] VARCHAR(128) )

DECLARE @PermGroupID INT, 
	@NewInsCompanyPermID INT,
	@NewPermName VARCHAR(128),
	@NewPermDescription VARCHAR(500),
	@NewPermissionValue VARCHAR(128),
	@OldPermissionValue VARCHAR(128)

/* Get the permission group associated with the new insurance company permissions */
SELECT	@PermGroupID = PermissionGroupID
FROM	PermissionGroup pg
WHERE	pg.[Name] = 'Setting Up Payers'

/* Create the list of new insurance company permissions to be added */

/* Add new "Find Insurance Company" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'Find Insurance Company', 
	'Display and search a list of insurance companies.', 
	'FindInsuranceCompany', 
	'FindInsurancePlan' )

/* Add new "New Insurance Company" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'New Insurance Company', 
	'Create a new insurance company.', 
	'NewInsuranceCompany', 
	'NewInsurancePlan' )

/* Add new "Read Insurance Company" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'Read Insurance Company', 
	'Show the details of an insurance company.', 
	'ReadInsuranceCompany', 
	'ReadInsurancePlan' )

/* Add new "Edit Insurance Company" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'Edit Insurance Company', 
	'Modify the details of an insurance company.', 
	'EditInsuranceCompany', 
	'EditInsurancePlan' )

/* Add new "Delete Insurance Company" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'Delete Insurance Company', 
	'Delete an insurance company.', 
	'DeleteInsuranceCompany', 
	'DeleteInsurancePlan' )

/* Add new "Merge Insurance Companies" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'Merge Insurance Companies', 
	'Combine one or more insurance companies and update references throughout system.', 
	'MergeInsuranceCompanies', 
	'MergeInsurancePlans' )

/* Add new "Find Shared Insurance Company" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'Find Shared Insurance Company', 
	'Display and search a list of shared insurance companies.', 
	'FindSharedInsuranceCompany', 
	'FindSharedInsurancePlan' )

/* Add new "New Shared Insurance Company" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'New Shared Insurance Company', 
	'Create a shared insurance company.', 
	'NewSharedInsuranceCompany', 
	'NewSharedInsurancePlan' )

/* Add new "Read Shared Insurance Company" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'Read Shared Insurance Company', 
	'Show the details of a shared insurance company.', 
	'ReadSharedInsuranceCompany', 
	'ReadSharedInsurancePlan' )

/* Add new "Edit Shared Insurance Company" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'Edit Shared Insurance Company', 
	'Modify the details of a shared insurance company.', 
	'EditSharedInsuranceCompany', 
	'EditSharedInsurancePlan' )

/* Add new "Delete Shared Insurance Company" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'Delete Shared Insurance Company', 
	'Delete a shared insurance company.', 
	'DeleteSharedInsuranceCompany', 
	'DeleteSharedInsurancePlan' )

/* Add new "Merge Shared Insurance Companies" permission */
INSERT INTO @NewInsCompanyPerm 
	( [Name], 
	[Description], 
	PermissionValue, 
	OldPermissionValue )
VALUES	( 'Merge Shared Insurance Companies', 
	'Combine one or more shared insurance companies and update references throughout system.', 
	'MergeSharedInsuranceCompanies', 
	'MergeSharedInsurancePlans' )

/* Insert the new permissions */
DECLARE perm_cursor CURSOR FOR
SELECT [Name], [Description], PermissionValue, OldPermissionValue
FROM @NewInsCompanyPerm

OPEN perm_cursor

FETCH NEXT FROM perm_cursor
INTO @NewPermName, @NewPermDescription, @NewPermissionValue, @OldPermissionValue

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO [Permissions] 
		( [Name],
		[Description],
		ViewInMedicalOffice,
		ViewInBusinessManager,
		ViewInAdministrator,
		ViewInServiceManager,
		PermissionGroupID,
		PermissionValue )
	VALUES ( @NewPermName, 
		@NewPermDescription, 
		1,
		1,
		1,
		1,
		@PermGroupID,
		@NewPermissionValue )

	SET @NewInsCompanyPermID = SCOPE_IDENTITY()

	/* Grant or deny access to this permission by copying the groups granted or denied access to the old permission value */
	INSERT	SecurityGroupPermissions
		( SecurityGroupID,
		PermissionID,
		Allowed,
		Denied )
	SELECT	SecurityGroupID,
		@NewInsCompanyPermID,
		Allowed,
		Denied
	FROM	SecurityGroupPermissions
	WHERE	PermissionID = 	( SELECT PermissionID 
				FROM [Permissions] 
				WHERE PermissionValue = @OldPermissionValue )

	/* Get the next permission to be added */
	FETCH NEXT FROM perm_cursor
	INTO @NewPermName, @NewPermDescription, @NewPermissionValue, @OldPermissionValue
END

CLOSE perm_cursor
DEALLOCATE perm_cursor

GO


---------------------------------------------------------------------------------------
--casE 5268 Load all Provider taxonomy codes
---------------------------------------------------------------------------------------
--Execute Taxonomy Import DTS package First!!

INSERT INTO TaxonomyType(TaxonomyTypeCode, TaxonomyTypeName)
VALUES('00','Unknown')

INSERT INTO TaxonomySpecialty(TaxonomySpecialtyCode, TaxonomyTypeCode, TaxonomySpecialtyName)
VALUES('00','00','Unknown')

INSERT INTO TaxonomyCode(TaxonomyCode, TaxonomyTypeCode, TaxonomySpecialtyCode)
VALUES('0000000001','00','00')

GO

---------------------------------------------------------------------------------------
-- Case 6711 - Remove diagnosis/procedure/etc. codes from "Setting up Payers"
---------------------------------------------------------------------------------------

/* Remove child SecurityGroupPermission rows */
DELETE SecurityGroupPermissions
WHERE PermissionID IN ( 
	SELECT 	PermissionID
	FROM 	[Permissions]
	WHERE 	PermissionGroupID = (
		SELECT	PermissionGroupID 
		FROM	PermissionGroup 
		WHERE	[Name] = 'Setting Up Payers' )
	AND	[Name] IN ( 
		'Find Shared Diagnosis',
		'Find Shared Procedure',
		'Find Shared Procedure Modifier', 
		'New Shared Diagnosis',
		'New Shared Procedure',
		'New Shared Procedure Modifier',
		'Read Shared Diagnosis',
		'Read Shared Procedure',
		'Read Shared Procedure Modifier' ) )

/* Remove incorrectly linked permissions */
DELETE 	[Permissions]
WHERE 	PermissionID IN ( 
	SELECT 	PermissionID
	FROM 	[Permissions]
	WHERE 	PermissionGroupID = (
		SELECT	PermissionGroupID 
		FROM	PermissionGroup 
		WHERE	[Name] = 'Setting Up Payers' )
	AND	[Name] IN ( 
		'Find Shared Diagnosis',
		'Find Shared Procedure',
		'Find Shared Procedure Modifier', 
		'New Shared Diagnosis',
		'New Shared Procedure',
		'New Shared Procedure Modifier',
		'Read Shared Diagnosis',
		'Read Shared Procedure',
		'Read Shared Procedure Modifier' ) )

GO

---------------------------------------------------------------------------------------
--case 3842 - Add permission for the Daily Report
---------------------------------------------------------------------------------------

DECLARE @permGroupID int
DECLARE @newReportPerm int

-- Get the permission group to associate with the new permission
SELECT	@permGroupID = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Generating Reports'

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Read Daily Report','Display, print, and save the Daily Report.',1,1,1,1,@permGroupID,'ReadDailyReport')

SET @newReportPerm = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the Daily Report
DECLARE @transactionsDetailPerm int

SELECT	@transactionsDetailPerm = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'ReadProviderProductivity'

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
