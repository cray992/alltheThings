/*----------------------------------

DATABASE UPDATE SCRIPT - SHARED

v1.35.xxxx to v1.36.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------

-------------------------------------------------------------------------------
-- Case 8793: Implement cobranding support for client applications
-------------------------------------------------------------------------------

ALTER TABLE
	Customer
ADD 
	CustomizationDMSFile uniqueidentifier NULL

GO


--------------------------------------------------
--case 8564: Add security permissions for procedure macros
--------------------------------------------------
declare
	@groupID8564 int,

	@Find8564 int,
	@New8564 int,
	@Read8564 int,
	@Edit8564 int,
	@Delete8564 int

INSERT INTO [dbo].[PermissionGroup]([Name], [Description])
VALUES('Managing Procedure Macros','Managing Procedure Macros Records')
set @groupID8564=Scope_Identity()

--CREATE FIND PROCEDURE MACRO PERMISSION
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
'Find Procedure Macro',
'Display and search a list of Procedure Macro Records.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID8564,'FindProcedureMacro')
set @Find8564=Scope_Identity()

--CREATE NEW PROCEDURE MACRO PERMISSION
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
'New Proceudure Macro',
'Create a new Procedure Macro Record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID8564,'NewProcedureMacro')
set @New8564=Scope_Identity()

--CREATE READ PROCEDURE MACRO PERMISSION
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
'Read Procedure Macro',
'Read Procedure Macro record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID8564,'ReadProcedureMacro')
set @Read8564=Scope_Identity()


--CREATE EDIT PROCEDURE MACRO PERMISSION
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
'Edit Procedure Macro',
'Edit Procedure Macro record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID8564,'EditProcedureMacro')
set @Edit8564=Scope_Identity()


--CREATE DELETE PROCEDURDE MACRO PERMISSION
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
'Delete Procedure Macro',
'Delete an Procedure Mactro record.',
GetDate(),
0,
GetDate(),
0,
1,1,1,1,@groupID8564,'DeleteProcedureMacro')
set @Delete8564=Scope_Identity()


-- Assign default Procedure macro Related permissions
-- assign attorney-related permissions to users
declare
	@EditEncounter8564 int,
	@EditProcedure8564 int

SELECT @EditEncounter8564=PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'EditEncounter'

SELECT @EditProcedure8564=PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'EditProcedure'
--print	@EditEncounter8564
--print 	@EditProcedure8564

SELECT PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'FindProcedureMacro'


-- allow all users:

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@Find8564,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @EditEncounter8564


INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@New8564,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @EditEncounter8564

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@Read8564,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @EditEncounter8564

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@Edit8564,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @EditEncounter8564

INSERT	SecurityGroupPermissions(
	SecurityGroupID,
	PermissionID,
	Allowed,
	Denied)
SELECT	SecurityGroupID,
	@Delete8564,
	Allowed,
	Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @EditEncounter8564



---------------------------------------------------------------------------------------
-- Case 8565: Add department table
---------------------------------------------------------------------------------------

DECLARE @permGroupID8565 int
DECLARE @newReportPerm8565 int
DECLARE @transactionsDetailPerm8565 int

-- Get the permission id to copy security group permissions for
SELECT	@transactionsDetailPerm8565 = PermissionID
FROM	Permissions 
WHERE 	PermissionValue = 'ReadProvider'

-- Get the permission group to associate with the new permission
SELECT	@permGroupID8565 = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Setting Up Practices'

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Read Department','Show the details of a department.',1,1,1,1,@permGroupID8565,'ReadDepartment')

SET @newReportPerm8565 = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the Read Provider permission
INSERT	SecurityGroupPermissions(SecurityGroupID, PermissionID, Allowed, Denied)
SELECT	SecurityGroupID, @newReportPerm8565, Allowed, Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @transactionsDetailPerm8565

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Edit Department','Modify the details of a department.',1,1,1,1,@permGroupID8565,'EditDepartment')

SET @newReportPerm8565 = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the Read Provider permission
INSERT	SecurityGroupPermissions(SecurityGroupID, PermissionID, Allowed, Denied)
SELECT	SecurityGroupID, @newReportPerm8565, Allowed, Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @transactionsDetailPerm8565

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('New Department','Create a new department.',1,1,1,1,@permGroupID8565,'NewDepartment')

SET @newReportPerm8565 = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the Read Provider permission
INSERT	SecurityGroupPermissions(SecurityGroupID, PermissionID, Allowed, Denied)
SELECT	SecurityGroupID, @newReportPerm8565, Allowed, Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @transactionsDetailPerm8565

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Find Department','Display and search a list of departments.',1,1,1,1,@permGroupID8565,'FindDepartment')

SET @newReportPerm8565 = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the Read Provider permission
INSERT	SecurityGroupPermissions(SecurityGroupID, PermissionID, Allowed, Denied)
SELECT	SecurityGroupID, @newReportPerm8565, Allowed, Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @transactionsDetailPerm8565

-- Insert the new permission
INSERT INTO permissions (name,description,viewinmedicaloffice,viewinbusinessmanager,viewinadministrator,viewinservicemanager,permissiongroupid,permissionvalue)
VALUES ('Delete Department','Delete a department.',1,1,1,1,@permGroupID8565,'DeleteDepartment')

SET @newReportPerm8565 = SCOPE_IDENTITY()

-- Grant or deny access to this permission by copying the groups granted or denied access to the Read Provider permission
INSERT	SecurityGroupPermissions(SecurityGroupID, PermissionID, Allowed, Denied)
SELECT	SecurityGroupID, @newReportPerm8565, Allowed, Denied
FROM	SecurityGroupPermissions
WHERE	PermissionID = @transactionsDetailPerm8565

GO

---------------------------------------------------------------------------------------
-- Case 8586: Insert code correct input/result definitions, adds permission for code correct
---------------------------------------------------------------------------------------
ALTER TABLE SharedSystemPropertiesAndValues
ALTER COLUMN Value varchar(max)

INSERT	SharedSystemPropertiesAndValues(
		PropertyName,
		Value,
		PropertyDescription)
VALUES	('CodeCorrectInputDefinition',
		'<packet id="0" ccName="packet">
	<Username ccName="Username" desc="Code Correct login name"/>
	<Userpassword ccName="Userpassword"  desc="Code Correct login password" />
	<physician_upin ccName="physician_upin"  desc="This is a unique physician identifier (UPIN) for this claim."/>
	<state ccName="state"  desc="The state identifier that was passed to the server" />
	<Contractor_id ccName="Contractor_id"  desc="The contractor identifier that was passed to the server"/>
	<svcdate ccName ="svcdate"  desc="The date-of-service that was passed to the server" />
	<othernotes ccName="othernotes"  desc="miscellaneous information regarding the claim." />
	<dob ccName="dob" desc="Date-of-birth in YYYYMMDD format. Used for CPT and ICD9 age edits. If missing or invalid, age edit will not be done."/>
	<gender ccName="gender" desc="Must be M or F. Used for gender edits. If missing or not M or F, gender edit will not be done."/>
	<maternity ccName="maternity" desc="Must be Y or N. Y would indicate the patient is pregnant.  If this field is missing, maternity edit will not be done."/>
	<item ccName="item">
		<uniqueid ccName="uniqueid{0}" desc="uniquely identifies this item within the packet"/>
		<cptcode ccName="cptcode{0}" desc="CPT code that was sent to the server"/>
		<modifier id="1" ccName="modifier{0}" desc="CPT modifier 1 to be validated with cptcode1 against the CodeCorrect database. NOT REQUIRED."/>
		<modifier id="2" ccName="modifier{0}b" desc="CPT modifier 2 to be validated with cptcode1 against the CodeCorrect database. NOT REQUIRED."/>
		<modifier id="3" ccName="modifier{0}c" desc="CPT modifier 3 to be validated with cptcode1 against the CodeCorrect database. NOT REQUIRED."/>
		<DX id="1" ccName="primdx{0}"  desc=""/>
		<DX id="2" ccName="secdx{0}"  desc=""/>
		<DX id="3" ccName="thirddx{0}"  desc=""/>
		<DX id="4" ccName="fourthdx{0}"  desc=""/>
	</item>
</packet>',
		'Defines code correct input data structure and content')

INSERT	SharedSystemPropertiesAndValues(
		PropertyName,
		Value,
		PropertyDescription)
VALUES	('CodeCorrectResultDefinition',
		'<packet id="0" ccName="packet">
	<statuscode id="0.1"  ccName="statuscode">
		<output_value value="0.0" success="true" desc="Sufficient data was passed in and the queries were successful." />
		<output_value value="1.0" desc="No data was passed to the validator." />
		<output_value value="2.0" desc="The data passed to the validator was not a structure." />
		<output_value value="3.0" desc="Invalid CodeCorrect login information." />
		<output_value value="4.0" desc="Data was not a WDDX packet." />
		<output_value value="99.0" desc="Failed insert on the unique number table." />
	</statuscode>
	<statusdesc id="0.2"  ccName="statusdesc"  desc="Error related information if insufficient data was passed in or a query failed.">
		<output_value value="All OK" success="true" />
	</statusdesc>
	<Contractor_id id="0.4"  ccName="Contractor_id"  desc="The contractor identifier that was passed to the server.">
		<Contractorstatesstatus id="0.4.1"  ccName="Contractorstatesstatus">
			<output_value value="0" success="true" desc="No Contractor ID provided in input packet" />
			<output_value value="1" success="true" desc="Contractor ID provided in input packet and contractor_id covers state." />
			<output_value value="2" desc="Contractor ID provided does not cover state specified." />
		</Contractorstatesstatus>
	</Contractor_id>
	<item id="0.7" ccName="item">
		<uniqueid id="0.7.1" success="true" ccName="uniqueid{0}" desc="Uniquely identifies this item within the packet." />
		<cptcode id="0.7.2" success="true" ccName="cptcode{0}" desc="CPT code that was sent to the server.">
			<cptcoderesult id="0.7.2.1" ccName="cptcode{0}result" desc="">
				<output_value success="true" value="0.0" desc="Valid CPT code." />
				<output_value value="1.0" desc="Invalid CPT code." />
				<output_value value="2.0" desc="Expired CPT code." />
			</cptcoderesult>
			<age_issue id="0.7.2.13" ccName="age_issue{0}" desc="">
				<output_value success="true" value="0.0" desc="No age issues." />
				<output_value value="2.0" desc="ICD9 issue with age." />
			</age_issue>
			<gender_issue id="0.7.2.14" ccName="gender_issue{0}" desc="">
				<output_value value="0.0" success="true" desc="No gender issues." />
				<output_value value="1.0" desc="CPT issue with gender." />
				<output_value value="2.0" desc="ICD9 issue with gender." />
				<output_value value="3.0" desc="CPT and ICD9 issue with gender." />
			</gender_issue>
		</cptcode>
		<ccistatus id="0.7.3" ccName="ccistatus{0}" desc="">
			<output_value value="-1.0" success="true"  desc="Does not apply." />
			<output_value value="1.0" success="true"  desc="Bundling issue and modifier is allowed." />
			<output_value value="0.0" desc="Bundling code cannot be used." />
			<output_value value="9.0" success="true"  desc="No bundling issues." />
			<ccicpt id="0.7.2.17.1" ccName="ccicpt{0}" desc="" />
		</ccistatus>
		<modifier id="0.7.4" success="true" ccName="modifier{0}" desc="">
			<modifierresult id="0.7.4.1"  ccName="modifier{0}result"  sequence=",b,c">
				<output_value value="0.0" success="true"  desc="Valid Modifier / CPT combination." />
				<output_value value="1.0" desc="Invalid Modifier / CPT combination." />
				<output_value value="2.0" desc="Modifier is missing and may be required. The claim contains non E and M codes and this CPT code is an E and M code and does not have a modifier." />
			</modifierresult>
		</modifier>
		<modifier id="b.0.7.4" success="true" ccName="modifier{0}b" desc="">
			<modifierresult id="b.0.7.4.1"  ccName="modifier{0}bresult"  sequence=",b,c">
				<output_value value="0.0" success="true"  desc="Valid Modifier / CPT combination." />
				<output_value value="1.0" desc="Invalid Modifier / CPT combination." />
				<output_value value="2.0" desc="Modifier is missing and may be required. The claim contains non E and M codes and this CPT code is an E and M code and does not have a modifier." />
			</modifierresult>
		</modifier>
		<modifier id="c.0.7.4" success="true" ccName="modifier{0}c" desc="">
			<modifierresult id="c.0.7.4.1"  ccName="modifier{0}cresult"  sequence=",b,c">
				<output_value value="0.0" success="true"  desc="Valid Modifier / CPT combination." />
				<output_value value="1.0" desc="Invalid Modifier / CPT combination." />
				<output_value value="2.0" desc="Modifier is missing and may be required. The claim contains non E and M codes and this CPT code is an E and M code and does not have a modifier." />
			</modifierresult>
		</modifier>
		<DX id="primdx.0.7.5" success="true" ccName="primdx{0}"  desc="">
			<result id="primdx.0.7.5.1" ccName="primdx{0}result" desc=""  >
				<output_value value="0.0" success="true"  desc="Valid Dx Code." />
				<output_value value="1.0" desc="Invalid diagnosis code." />
				<output_value value="2.0" desc="Not coded to highest level." />
				<output_value value="3.0" desc="Unspecified Code (possibility of denied claim)." />
				<output_value value="4.0" desc="Nonspecific Code (possibility of denied claim)." />
				<output_value value="5.0" desc="Manifestation Code." />
			</result>
		</DX>
		<DX id="secdx.0.7.6" success="true" ccName="secdx{0}"  desc="">
			<result id="secdx.0.7.6.1" ccName="secdx{0}result" desc=""  >
				<output_value value="0.0" success="true"  desc="Valid Dx Code." />
				<output_value value="1.0" desc="Invalid diagnosis code." />
				<output_value value="2.0" desc="Not coded to highest level." />
				<output_value value="3.0" desc="Unspecified Code (possibility of denied claim)." />
				<output_value value="4.0" desc="Nonspecific Code (possibility of denied claim)." />
				<output_value value="5.0" desc="Manifestation Code." />
			</result>
		</DX>
		<DX id="thirddx.0.7.7" success="true" ccName="thirddx{0}"  desc="">
			<result id="thirddx.0.7.7.1" ccName="thirddx{0}result" desc=""  >
				<output_value value="0.0" success="true"  desc="Valid Dx Code." />
				<output_value value="1.0" desc="Invalid diagnosis code." />
				<output_value value="2.0" desc="Not coded to highest level." />
				<output_value value="3.0" desc="Unspecified Code (possibility of denied claim)." />
				<output_value value="4.0" desc="Nonspecific Code (possibility of denied claim)." />
				<output_value value="5.0" desc="Manifestation Code." />
			</result>
		</DX>
		<DX id="fourthdx.0.7.8" success="true" ccName="fourthdx{0}"  desc="">
			<result id="fourthdx.0.7.8.1" ccName="fourthdx{0}result" desc=""  >
				<output_value value="0.0" success="true"  desc="Valid Dx Code." />
				<output_value value="1.0" desc="Invalid diagnosis code." />
				<output_value value="2.0" desc="Not coded to highest level." />
				<output_value value="3.0" desc="Unspecified Code (possibility of denied claim)." />
				<output_value value="4.0" desc="Nonspecific Code (possibility of denied claim)." />
				<output_value value="5.0" desc="Manifestation Code." />
			</result>
		</DX>
	</item>
</packet>',
		'Defines code correct result data structure and content')

-- Add the permission for code correct
DECLARE @PermissionGroupID8586 INT
DECLARE @PermissionID8586 INT

SELECT	@PermissionGroupID8586 = PermissionGroupID
FROM	PermissionGroup
WHERE	Name = 'Entering and Tracking Encounters'

EXEC @PermissionID8586 = Shared_AuthenticationDataProvider_CreatePermission
@Name='Perform Code Check', 
@Description='Validates an encounter by performing a code check',
@ViewInMedicalOffice=1,
@ViewInBusinessManager=1,
@ViewInAdministrator=1,
@ViewInServiceManager=1,
@PermissionGroupID=@PermissionGroupID8586,
@PermissionValue='PerformCodeCheck'
 
EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='SubmitEncounter',
@PermissionToApplyID=@PermissionID8586

GO

-------------------------------------------------------------------------------
-- Case 8771: Clearinghouse variety support 
-------------------------------------------------------------------------------

CREATE TABLE [dbo].Clearinghouse(
	[ClearinghouseID] [int] IDENTITY(1,1) NOT NULL,
	[ClearinghouseName] varchar(32) NOT NULL,
	[RoutingName] varchar(32) NOT NULL
) ON [PRIMARY]
GO

INSERT INTO [dbo].Clearinghouse ( ClearinghouseName, RoutingName ) VALUES ('MedAvant, formerly ProxyMed', 'PROXYMED')
INSERT INTO [dbo].Clearinghouse ( ClearinghouseName, RoutingName ) VALUES ('OfficeAlly', 'OFFICEALLY')
GO

-------------------------------------------------------------------------------
-- Case 0000: New Report Permissions 
-------------------------------------------------------------------------------

DECLARE @AcctActivityRptPermissionID INT

EXEC @AcctActivityRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
@Name='Read Account Activity Report',
@Description='Display, print, and save the Account Activity Report',
@ViewInMedicalOffice=1,
@ViewInBusinessManager=1,
@ViewInAdministrator=1,
@ViewInServiceManager=1,
@PermissionGroupID=10,
@PermissionValue='ReadAccountActivityReport'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadDailyReport',
@PermissionToApplyID=@AcctActivityRptPermissionID

GO

DECLARE @MissedCopaysRptPermissionID INT

EXEC @MissedCopaysRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
@Name='Read Missed Copays Report',
@Description='Display, print, and save the Missed Copays Report',
@ViewInMedicalOffice=1,
@ViewInBusinessManager=1,
@ViewInAdministrator=1,
@ViewInServiceManager=1,
@PermissionGroupID=10,
@PermissionValue='ReadMissedCopays'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadPaymentsSummary',
@PermissionToApplyID=@MissedCopaysRptPermissionID

GO

DECLARE @UnpaidInsuranceClaimsRptPermissionID INT

EXEC @UnpaidInsuranceClaimsRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
@Name='Read Unpaid Insurance Claims Report',
@Description='Display, print, and save the Unpaid Insurance Claims Report',
@ViewInMedicalOffice=1,
@ViewInBusinessManager=1,
@ViewInAdministrator=1,
@ViewInServiceManager=1,
@PermissionGroupID=10,
@PermissionValue='ReadUnpaidInsuranceClaimsReport'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadARAgingSummary',
@PermissionToApplyID=@UnpaidInsuranceClaimsRptPermissionID

GO

DECLARE @PatientContactListRptPermissionID INT

EXEC @PatientContactListRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
@Name='Read Patient Contact List Report',
@Description='Display, print, and save the PatientContactList Report',
@ViewInMedicalOffice=1,
@ViewInBusinessManager=1,
@ViewInAdministrator=1,
@ViewInServiceManager=1,
@PermissionGroupID=10,
@PermissionValue='ReadPatientContactListReport'

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ReadPatient',
@PermissionToApplyID=@PatientContactListRptPermissionID

GO

--Add property to facilitate proper splitting of data and log file when creating new
--databases

INSERT INTO SharedSystemPropertiesAndValues(PropertyName, Value)
VALUES('DefaultNewCustomer_LogPath','E:\sqllogs\')

UPDATE SharedSystemPropertiesAndValues SET Value='KDB04'
WHERE PropertyName='DefaultNewCustomer_DBServerName'

GO

--ROLLBACK
--COMMIT
