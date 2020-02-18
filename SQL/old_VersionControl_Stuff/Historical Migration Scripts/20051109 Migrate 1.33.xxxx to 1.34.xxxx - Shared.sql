/*

SHARED DATABASE UPDATE SCRIPT

v1.33.xxxx to v1.34.xxxx		
*/
----------------------------------

--BEGIN TRAN 

----------------------------------

/*---------------------------------------------------------------------------------------

Case 5176: Migrate "Coding Forms" terminology to "Encounter Forms"
---------------------------------------------------------------------------------------*/

UPDATE 	[Permissions]
SET 	[Name] = 'Find Encounter Form',
	[Description] = 'Display and search a list of encounter forms.',
	[ModifiedDate] = GETDATE(),
	[PermissionValue] = 'FindEncounterForm'
WHERE 	[Name] = 'Find Coding Form'

UPDATE 	[Permissions]
SET 	[Name] = 'New Encounter Form',
	[Description] = 'Create a new encounter form.',
	[ModifiedDate] = GETDATE(),
	[PermissionValue] = 'NewEncounterForm'
WHERE 	[Name] = 'New Coding Form'

UPDATE 	[Permissions]
SET 	[Name] = 'Read Encounter Form',
	[Description] = 'Show the details of an encounter form.',
	[ModifiedDate] = GETDATE(),
	[PermissionValue] = 'ReadEncounterForm'
WHERE 	[Name] = 'Read Coding Form'

UPDATE 	[Permissions]
SET 	[Name] = 'Edit Encounter Form',
	[Description] = 'Modify the details of an encounter form.',
	[ModifiedDate] = GETDATE(),
	[PermissionValue] = 'EditEncounterForm'
WHERE 	[Name] = 'Edit Coding Form'

UPDATE 	[Permissions]
SET 	[Name] = 'Delete Encounter Form',
	[Description] = 'Delete an encounter form.',
	[ModifiedDate] = GETDATE(),
	[PermissionValue] = 'DeleteEncounterForm'
WHERE 	[Name] = 'Delete Coding Form'

GO

---------------------------------------------------------------------------------------
-- Case 7678, 7679 - Add Permissions for the A/R Aging by Insurance and by Patient reports
---------------------------------------------------------------------------------------

DECLARE @permGroupID int
DECLARE @newReportPerm int

-- Get the permission group to associate with the new permission
SELECT	@permGroupID = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Generating Reports'

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Read A/R Aging by Insurance','Display, print, and save the A/R Aging by Insurance Report.',1,1,1,1,@permGroupID,'ReadARAgingByInsurance')

SET @newReportPerm = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the AR Aging Detail report
DECLARE @transactionsDetailPerm int

SELECT	@transactionsDetailPerm = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'ReadARAgingDetail'

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

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Read A/R Aging by Patient','Display, print, and save the A/R Aging by Patient Report.',1,1,1,1,@permGroupID,'ReadARAgingByPatient')

SET @newReportPerm = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the AR Aging Detail report
SELECT	@transactionsDetailPerm = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'ReadARAgingDetail'

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
-- Case 7526 - Add Permissions for the Patient Balance Summary and Detail reports
---------------------------------------------------------------------------------------

DECLARE @permGroupID2 int
DECLARE @newReportPerm2 int

-- Get the permission group to associate with the new permission
SELECT	@permGroupID2 = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Generating Reports'

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Read Patient Balance Summary','Display, print, and save the Patient Balance Summary Report.',1,1,1,1,@permGroupID2,'ReadPatientBalanceSummary')

SET @newReportPerm2 = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the Daily Report
DECLARE @transactionsDetailPerm2 int

SELECT	@transactionsDetailPerm2 = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'ReadPatientTransactionsDetail'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@newReportPerm2,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @transactionsDetailPerm2

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Read Patient Balance Detail','Display, print, and save the Patient Balance Detail Report.',1,1,1,1,@permGroupID2,'ReadPatientBalanceDetail')

SET @newReportPerm2 = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the Daily Report
SELECT	@transactionsDetailPerm2 = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'ReadPatientTransactionsDetail'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@newReportPerm2,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @transactionsDetailPerm2

GO

---------------------------------------------------------------------------------------
--case 6610 - adding active flag to procedures, diagnoses
---------------------------------------------------------------------------------------

--procedure
ALTER TABLE 
	ProcedureCodeDictionary
ADD
	Active bit NOT NULL 
CONSTRAINT
	DF_ProcedureCodeDictionary_Active DEFAULT 1
GO



--diagnoses

ALTER TABLE 
	DiagnosisCodeDictionary
ADD
	Active bit NOT NULL
CONSTRAINT
	DF_DiagnosisCodeDictionary_Active DEFAULT 1
GO

---------------------------------------------------------------------------------------
--case XXXX - Update HCPCS CPTs TypeOfServiceCode and TypeOfServiceCodes Table
---------------------------------------------------------------------------------------

CREATE TABLE #DBs(TID INT IDENTITY(1,1), DB VARCHAR(100))

INSERT INTO #DBs(DB)
VALUES('CustomerModel')

INSERT INTO #DBs(DB)
VALUES('CustomerModelPrepopulated')

INSERT INTO #DBs(DB)
VALUES('Superbill_Shared')

INSERT INTO #DBs(DB)
SELECT DatabaseName
FROM Customer
WHERE DBActive=1

DECLARE @Loop INT
DECLARE @Count INT
DECLARE @CurrentDBName VARCHAR(100)

SELECT @Loop=COUNT(TID) FROM #DBs
SET @Count=0
SET @CurrentDBName=''

DECLARE @NewSchemaScript VARCHAR(8000)
DECLARE @CopyScript VARCHAR(8000)
DECLARE @ExecuteSQL VARCHAR(8000)

SET @NewSchemaScript='INSERT INTO {0}..TypeOfService(TypeOfServiceCode, Description)
SELECT NewCode, Description
FROM Superbill_Shared..IMPORTEDTOS

UPDATE PCD SET TypeOfServiceCode=NewCode
FROM {0}..ProcedureCodeDictionary PCD
INNER JOIN Superbill_Shared..IMPORTEDTOS IT
ON PCD.TypeOfServiceCode=IT.CurrentCode

UPDATE PCD SET TypeOfServiceCode=TOS
FROM {0}..ProcedureCodeDictionary PCD INNER JOIN Superbill_Shared..HCPCSCodes HC
ON PCD.ProcedureCode=HC.HCPCSCode

DELETE TOS
FROM {0}..TypeOfService TOS LEFT JOIN Superbill_Shared..IMPORTEDTOS IT
ON TOS.TypeOfServiceCode=IT.NewCode
WHERE IT.NewCode IS NULL'


WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @CurrentDBName=DB
	FROM #DBs
	WHERE TID=@Count

	--Create Taxonomy Schemas
	SET @ExecuteSQL=REPLACE(@NewSchemaScript,'{0}',@CurrentDBName)
	EXEC(@ExecuteSQL)

END

DROP TABLE #DBs

GO

---------------------------------------------------------------------------------------
--case 8048 - Fixing TypeOfService code to be one character only
---------------------------------------------------------------------------------------

ALTER TABLE [dbo].[ProcedureCodeDictionary] 
DROP CONSTRAINT [DF_ProcedureCodeDictionary_TypeOfServiceCode]
GO

INSERT INTO TypeOfService (TypeOfServiceCode, Description) VALUES ('_', 'Not a HCPCS service')
GO

UPDATE
	ProcedureCodeDictionary
SET
	TypeOfServiceCode = '_' 
WHERE
	TypeOfServiceCode = '99'
GO

ALTER TABLE [dbo].[ProcedureCodeDictionary] DROP CONSTRAINT [FK_ProcedureCodeDictionary_TypeOfService]
GO

ALTER TABLE
	ProcedureCodeDictionary
ALTER COLUMN
	TypeOfServiceCode char(1) not null
GO

ALTER TABLE [dbo].[ProcedureCodeDictionary] 
ADD CONSTRAINT [DF_ProcedureCodeDictionary_TypeOfServiceCode] 
DEFAULT ('1') FOR [TypeOfServiceCode]
GO

ALTER TABLE [dbo].[TypeOfService] 
DROP CONSTRAINT [PK_TypeOfService]
GO

ALTER TABLE
	TypeOfService
ALTER COLUMN
	TypeOfServiceCode char(1) not null
GO

ALTER TABLE [dbo].[TypeOfService] ADD CONSTRAINT [PK_TypeOfService] PRIMARY KEY  CLUSTERED 
	(
		[TypeOfServiceCode]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ProcedureCodeDictionary] ADD CONSTRAINT [FK_ProcedureCodeDictionary_TypeOfServiceCode] FOREIGN KEY 
	(
		[TypeOfServiceCode]
	) REFERENCES [TypeOfService] (
		[TypeOfServiceCode]
	)
GO


---------------------------------------------------------------------------------------
-- Case 6521 - Add Permissions for the Fee Schedule Detail report
---------------------------------------------------------------------------------------

DECLARE @permGroupID2 int
DECLARE @newReportPerm2 int

-- Get the permission group to associate with the new permission
SELECT	@permGroupID2 = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Generating Reports'

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Read Fee Schedule Detail','Display, print, and save the Fee Schedule Detail Report.',1,1,1,1,@permGroupID2,'ReadFeeScheduleDetail')

SET @newReportPerm2 = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to ReadContract
DECLARE @transactionsDetailPerm2 int

SELECT	@transactionsDetailPerm2 = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'ReadContract'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@newReportPerm2,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @transactionsDetailPerm2

---------------------------------------------------------------------------------------
--case XXXX - Description
---------------------------------------------------------------------------------------


--ROLLBACK
--COMMIT