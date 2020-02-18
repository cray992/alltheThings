/*----------------------------------

DATABASE UPDATE SCRIPT - SHARED

v1.36.xxxx to v1.37.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------

/*---------------------------------------------------------------------------
Case 9798: Schedule enhancements - timeblock portion
---------------------------------------------------------------------------*/

DECLARE @PermissionID INT

EXEC @PermissionID = Shared_AuthenticationDataProvider_CreatePermission
	@Name = 'Find Timeblock',
	@Description = 'Display and search a list of timeblocks.',
	@ViewInMedicalOffice = 1,
	@ViewInBusinessManager = 1,
	@ViewInAdministrator = 1,
	@ViewInServiceManager = 1,
	@PermissionGroupID = 7, /* Scheduling Appointments */
	@PermissionValue = 'FindTimeblock'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue = 'EditResource',
	@PermissionToApplyID = @PermissionID

EXEC @PermissionID = Shared_AuthenticationDataProvider_CreatePermission
	@Name = 'New Timeblock',
	@Description = 'Create a new timeblock.',
	@ViewInMedicalOffice = 1,
	@ViewInBusinessManager = 1,
	@ViewInAdministrator = 1,
	@ViewInServiceManager = 1,
	@PermissionGroupID = 7, /* Scheduling Appointments */
	@PermissionValue = 'NewTimeblock'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue = 'EditResource',
	@PermissionToApplyID = @PermissionID

EXEC @PermissionID = Shared_AuthenticationDataProvider_CreatePermission
	@Name = 'Read Timeblock',
	@Description = 'Show the details of a timeblock.',
	@ViewInMedicalOffice = 1,
	@ViewInBusinessManager = 1,
	@ViewInAdministrator = 1,
	@ViewInServiceManager = 1,
	@PermissionGroupID = 7, /* Scheduling Appointments */
	@PermissionValue = 'ReadTimeblock'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue = 'EditResource',
	@PermissionToApplyID = @PermissionID

EXEC @PermissionID = Shared_AuthenticationDataProvider_CreatePermission
	@Name = 'Edit Timeblock',
	@Description = 'Modify the details of a timeblock.',
	@ViewInMedicalOffice = 1,
	@ViewInBusinessManager = 1,
	@ViewInAdministrator = 1,
	@ViewInServiceManager = 1,
	@PermissionGroupID = 7, /* Scheduling Appointments */
	@PermissionValue = 'EditTimeblock'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue = 'EditResource',
	@PermissionToApplyID = @PermissionID

EXEC @PermissionID = Shared_AuthenticationDataProvider_CreatePermission
	@Name = 'Delete Timeblock',
	@Description = 'Delete a timeblock record.',
	@ViewInMedicalOffice = 1,
	@ViewInBusinessManager = 1,
	@ViewInAdministrator = 1,
	@ViewInServiceManager = 1,
	@PermissionGroupID = 7, /* Scheduling Appointments */
	@PermissionValue = 'DeleteTimeblock'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue = 'EditResource',
	@PermissionToApplyID = @PermissionID

EXEC @PermissionID = Shared_AuthenticationDataProvider_CreatePermission
	@Name = 'Read Daily Timeblock Calendar',
	@Description = 'Display the daily calendar of timeblocks.',
	@ViewInMedicalOffice = 1,
	@ViewInBusinessManager = 1,
	@ViewInAdministrator = 1,
	@ViewInServiceManager = 1,
	@PermissionGroupID = 7, /* Scheduling Appointments */
	@PermissionValue = 'ReadDailyTimeblockCalendar'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue = 'EditResource',
	@PermissionToApplyID = @PermissionID

EXEC @PermissionID = Shared_AuthenticationDataProvider_CreatePermission
	@Name = 'Read Weekly Timeblock Calendar',
	@Description = 'Display the weekly calendar of timeblocks.',
	@ViewInMedicalOffice = 1,
	@ViewInBusinessManager = 1,
	@ViewInAdministrator = 1,
	@ViewInServiceManager = 1,
	@PermissionGroupID = 7, /* Scheduling Appointments */
	@PermissionValue = 'ReadWeeklyTimeblockCalendar'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue = 'EditResource',
	@PermissionToApplyID = @PermissionID

GO


-----------------------------------------------------------------------------------------
-- CASE 9796 Capitated Account Permission
------------------------------------------------------------------------------------------
DECLARE @PermissionGroupID9796 INT
DECLARE @PermissionID9796 INT

 

SELECT            @PermissionGroupID9796 = PermissionGroupID
FROM   PermissionGroup
WHERE            Name = 'Managing the Billing Process'

--=================================================================================

-----------
EXEC @PermissionID9796 = Shared_AuthenticationDataProvider_CreatePermission
@Name='Find Capitated Account', 
@Description='Display and search a list of Capitated Accounts.',
@ViewInMedicalOffice=1,
@ViewInBusinessManager=1,
@ViewInAdministrator=1,
@ViewInServiceManager=1,
@PermissionGroupID=@PermissionGroupID9796,
@PermissionValue='FindCapitatedAccount'

 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadRefund',
@PermissionToApplyID=@PermissionID9796
-----------
EXEC @PermissionID9796 = Shared_AuthenticationDataProvider_CreatePermission
@Name='New Capitated Account', 
@Description='Create a new Capitated Account.',
@ViewInMedicalOffice=1,
@ViewInBusinessManager=1,
@ViewInAdministrator=1,
@ViewInServiceManager=1,
@PermissionGroupID=@PermissionGroupID9796,
@PermissionValue='NewCapitatedAccount'

 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadRefund',
@PermissionToApplyID=@PermissionID9796
-----------
EXEC @PermissionID9796 = Shared_AuthenticationDataProvider_CreatePermission
@Name='Read Capitated Account', 
@Description='Show the details of a Capitated Account.',
@ViewInMedicalOffice=1,
@ViewInBusinessManager=1,
@ViewInAdministrator=1,
@ViewInServiceManager=1,
@PermissionGroupID=@PermissionGroupID9796,
@PermissionValue='ReadCapitatedAccount'

 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadRefund',
@PermissionToApplyID=@PermissionID9796

-----------
EXEC @PermissionID9796 = Shared_AuthenticationDataProvider_CreatePermission
@Name='Edit Capitated Account', 
@Description='Modify the details of a Capitated Account.',
@ViewInMedicalOffice=1,
@ViewInBusinessManager=1,
@ViewInAdministrator=1,
@ViewInServiceManager=1,
@PermissionGroupID=@PermissionGroupID9796,
@PermissionValue='EditCapitatedAccount'

 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadRefund',
@PermissionToApplyID=@PermissionID9796

-----------
EXEC @PermissionID9796 = Shared_AuthenticationDataProvider_CreatePermission
@Name='Delete Capitated Account', 
@Description='Delete a Capitated Account.',
@ViewInMedicalOffice=1,
@ViewInBusinessManager=1,
@ViewInAdministrator=1,
@ViewInServiceManager=1,
@PermissionGroupID=@PermissionGroupID9796,
@PermissionValue='DeleteCapitatedAccount'

 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadRefund',
@PermissionToApplyID=@PermissionID9796

-----------
--EXEC @PermissionID9796 = Shared_AuthenticationDataProvider_CreatePermission
--@Name='Override Delete Capitated Account Restrictions', 
--@Description='Restrictions Override restrictions on deleting Capitated Accounts, specifically related to closing the books date',
--@ViewInMedicalOffice=1,
--@ViewInBusinessManager=1,
--@ViewInAdministrator=1,
--@ViewInServiceManager=1,
--@PermissionGroupID=@PermissionGroupID9796,
--@PermissionValue='OverrideDeleteCapitatedAccountRestrictions'

 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadRefund',
@PermissionToApplyID=@PermissionID9796



/*---------------------------------------------------------------------------
Case 10231: New Report: Patient Statement
---------------------------------------------------------------------------*/

DECLARE @PatientStatementRptPermissionID INT

EXEC @PatientStatementRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Patient Statement Report',
	@Description='Display, print, and save the patient statement report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPatientStatementReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPatient',
	@PermissionToApplyID=@PatientStatementRptPermissionID

go
------------------------------------------------------------------------------------------------
-- CASE 9521 
------------------------------------------------------------------------------------------------
update [Permissions] 
set Description ='Delete a Procedure Macro record.'
where [name] = 'Delete Procedure Macro' 

GO

--------------------------------------------------
--case 6987: Add security permissions read/write Patient Journal Notes
--------------------------------------------------
declare
	@groupID6987 int,

	@canhide6987 int,
	@showhidden6987 int


SELECT @groupID6987=PermissionGroupID FROM PermissionGroup WHERE Name = 'Managing Patients'

--CREATE Hide Journal Notes permissions
---------------------------------
INSERT INTO [dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES(
'Hide Patient Journal Notes',
'Can hide the Patient Journal Notes.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID6987,'HidePatientJournalNotes')
set @canhide6987=Scope_Identity()


--CREATE Show hidden Patient Journal Notes permissions
---------------------------------
INSERT INTO [dbo].[Permissions]
(
[Name], 
[Description], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID], 
[ViewInMedicalOffice], 
[ViewInBusinessManager], 
[ViewInAdministrator], 
[ViewInServiceManager], 
[PermissionGroupID], 
[PermissionValue])
VALUES(
'Show Hidden Patient Journal Notes',
'Can access hidden Patient Journal Notes.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID6987,'ShowHiddenPatientJournalNotes')
set @showhidden6987=Scope_Identity()

-- assign default permissions
declare
	@EditPatient6987 int,
	@ReadPatient6987 int

SELECT @EditPatient6987=PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'EditPatient'

SELECT @ReadPatient6987=PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'ReadPatient'

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@canhide6987,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @EditPatient6987

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@showhidden6987,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @ReadPatient6987




/*---------------------------------------------------------------------------
Case 10290: New Report: Encounter Detail
---------------------------------------------------------------------------*/

DECLARE @EncountersDetailRptPermissionID INT

EXEC @EncountersDetailRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Encounters Detail Report',
	@Description='Display, print, and save the encounters detail report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10, --???
	@PermissionValue='ReadEncountersDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadEncounter',
	@PermissionToApplyID=@EncountersDetailRptPermissionID

go



/*---------------------------------------------------------------------------
Case 10292: New Report: Encounter Summary
---------------------------------------------------------------------------*/

DECLARE @EncountersSummaryRptPermissionID INT

EXEC @EncountersSummaryRptPermissionID =Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Encounters Summary Report',
	@Description='Display, print, and save the encounters summary report.', 
	@ViewInMedicalOffice=1,
	@ViewInBusinessManager=1,
	@ViewInAdministrator=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10, --???
	@PermissionValue='ReadEncountersSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadEncounter',
	@PermissionToApplyID=@EncountersSummaryRptPermissionID

GO

--CASE 10417

UPDATE Permissions SET ViewInMedicalOffice=0, ViewInBusinessManager=0, 
ViewInAdministrator=0
WHERE PermissionID IN (362,363,364,365,366,367)
GO

/*---------------------------------------------------------------------------
Case 10426: Clean up permission errors in shared database
---------------------------------------------------------------------------*/
UPDATE permissions SET description = 'Modify the details of a service location.' WHERE name = 'Edit Service Location'
UPDATE permissions SET description = 'Show the details of a service location.' WHERE name = 'Read Service Location'
GO


--ROLLBACK
--COMMIT


