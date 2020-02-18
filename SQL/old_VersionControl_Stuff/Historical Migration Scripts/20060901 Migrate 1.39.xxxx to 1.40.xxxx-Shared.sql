/*----------------------------------

DATABASE UPDATE SCRIPT

v1.39.xxxx to v1.40.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------

ALTER TABLE dbo.SecurityGroup
	DROP CONSTRAINT DF_SecurityGroup_ViewInMedicalOffice
GO

ALTER TABLE dbo.SecurityGroup
	DROP CONSTRAINT DF_SecurityGroup_ViewInBusinessManager
GO

ALTER TABLE dbo.SecurityGroup
	DROP CONSTRAINT DF_SecurityGroup_ViewInAdministrator
GO

ALTER TABLE dbo.[Permissions] ADD
	ViewInKareo bit NOT NULL DEFAULT 0
GO

UPDATE dbo.[Permissions]
SET
	ViewInKareo = 1
WHERE
	( ViewInMedicalOffice = 1 ) 
	OR ( ViewInBusinessManager = 1 ) 
	OR ( ViewInAdministrator = 1 )
GO

ALTER TABLE dbo.SecurityGroup ADD
	ViewInKareo bit NOT NULL DEFAULT 0
GO

UPDATE dbo.SecurityGroup
SET
	ViewInKareo = 1
WHERE
	( ViewInMedicalOffice = 1 ) 
	OR ( ViewInBusinessManager = 1 ) 
	OR ( ViewInAdministrator = 1 )
GO

ALTER TABLE dbo.SecurityGroup
	DROP COLUMN ViewInMedicalOffice, ViewInBusinessManager, ViewInAdministrator
GO

ALTER TABLE dbo.[Permissions]
	DROP CONSTRAINT DF_Permissions_ViewInMedicalOffice
GO

ALTER TABLE dbo.[Permissions]
	DROP CONSTRAINT DF_Permissions_ViewInBusinessManager
GO

ALTER TABLE dbo.[Permissions]
	DROP CONSTRAINT DF_Permissions_ViewInAdministrator
GO

ALTER TABLE dbo.[Permissions]
	DROP COLUMN ViewInMedicalOffice, ViewInBusinessManager, ViewInAdministrator
GO

/* Merge Security Policy Settings */
ALTER TABLE dbo.SecuritySetting ADD
	UILockMinutesKareo int NOT NULL CONSTRAINT DF_SecuritySetting_UILockMinutesKareo DEFAULT 30
GO

/* Update Kareo's UI lockout minutes with the longest of the existing lockout minutes ...  */
UPDATE	dbo.SecuritySetting
SET		UILockMinutesKareo = CASE
			WHEN UILockMinutesAdministrator > UILockMinutesKareo THEN UILockMinutesAdministrator 
			ELSE UILockMinutesKareo END
GO

UPDATE	dbo.SecuritySetting
SET		UILockMinutesKareo = CASE
			WHEN UILockMinutesBusinessManager > UILockMinutesKareo THEN UILockMinutesBusinessManager 
			ELSE UILockMinutesKareo END
GO

UPDATE	dbo.SecuritySetting
SET		UILockMinutesKareo = CASE
			WHEN UILockMinutesMedicalOffice > UILockMinutesKareo THEN UILockMinutesMedicalOffice 
			ELSE UILockMinutesKareo END
GO

/* Remove obsolete UI lockout minutes columns ... */
ALTER TABLE dbo.SecuritySetting
	DROP CONSTRAINT DF_SecuritySetting_UILockMinutesAdministrator
GO

ALTER TABLE dbo.SecuritySetting
	DROP CONSTRAINT DF_SecuritySetting_UILockMinutesBusinessManager
GO

ALTER TABLE dbo.SecuritySetting
	DROP CONSTRAINT DF_SecuritySetting_UILockMinutesMedicalOffice
GO

ALTER TABLE dbo.SecuritySetting
	DROP COLUMN UILockMinutesAdministrator, UILockMinutesBusinessManager, UILockMinutesMedicalOffice
GO

/* Create new 'Sign on to Kareo' permission ... */
INSERT INTO [dbo].[Permissions] ( 
	[Name]
	, [Description]
	, [CreatedDate]
	, [CreatedUserID]
	, [ModifiedDate]
	, [ModifiedUserID]
	, [ViewInKareo]
	, [ViewInServiceManager]
	, [PermissionGroupID]
	, [PermissionValue])
VALUES (
	'Sign on to Kareo'
	, 'Sign on to Kareo.'
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 1
	, 1
	, 5
	, 'SignOnToKareo' )

/* Link existing security groups to the new permission ... */
DECLARE @PermissionID INT

SET @PermissionID = SCOPE_IDENTITY()

INSERT INTO [dbo].[SecurityGroupPermissions] ( 
	[SecurityGroupID]
	,[PermissionID]
	,[Allowed]
	,[CreatedDate]
	,[CreatedUserID]
	,[ModifiedDate]
	,[ModifiedUserID]
	,[Denied] )
SELECT
	DISTINCT SecurityGroupID
	, @PermissionID
	, 1
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 0
FROM
	SecurityGroupPermissions SGP
	JOIN [Permissions] P ON P.PermissionID = SGP.PermissionID
WHERE
	P.[Name] IN ( 'Sign on to Medical Office'
		, 'Sign on to Business Manager'
		, 'Sign on to Administrator' )
GO

/* Create new 'View and administer all insurance companies' permission ... */
INSERT INTO [dbo].[Permissions] ( 
	[Name]
	, [Description]
	, [CreatedDate]
	, [CreatedUserID]
	, [ModifiedDate]
	, [ModifiedUserID]
	, [ViewInKareo]
	, [ViewInServiceManager]
	, [PermissionGroupID]
	, [PermissionValue])
VALUES (
	'Find All Insurance Companies'
	, 'View and administer all insurance companies.'
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 1
	, 1
	, 14
	, 'FindAllInsuranceCompanies' )
GO

/* Link existing security groups to the new permission ... */
DECLARE @PermissionID INT

SELECT	@PermissionID = P.PermissionID
FROM	[Permissions] P
WHERE	P.PermissionValue = 'FindAllInsuranceCompanies'

INSERT INTO [dbo].[SecurityGroupPermissions] ( 
	[SecurityGroupID]
	,[PermissionID]
	,[Allowed]
	,[CreatedDate]
	,[CreatedUserID]
	,[ModifiedDate]
	,[ModifiedUserID]
	,[Denied] )
SELECT
	SG.SecurityGroupID
	, @PermissionID
	, 1
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 0
FROM
	SecurityGroup SG
WHERE
	SG.SecurityGroupID IN (
		SELECT
			SG1.SecurityGroupID
		FROM
			SecurityGroup SG1
			JOIN SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG1.SecurityGroupID
			JOIN [Permissions] P ON P.PermissionID = SGP.PermissionID
		WHERE
			P.[Name] = 'Sign on to Administrator'
			AND SGP.Allowed = 1
			AND SGP.Denied = 0 )
	AND SG.SecurityGroupID IN (
		SELECT
			SG2.SecurityGroupID
		FROM
			SecurityGroup SG2
			JOIN SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG2.SecurityGroupID
			JOIN [Permissions] P ON P.PermissionID = SGP.PermissionID
		WHERE
			P.[Name] = 'Find Insurance Company' 
			AND SGP.Allowed = 1
			AND SGP.Denied = 0 )
ORDER BY
	SG.SecurityGroupID
GO

/* Create new 'View and administer all insurance plans' permission ... */
INSERT INTO [dbo].[Permissions] ( 
	[Name]
	, [Description]
	, [CreatedDate]
	, [CreatedUserID]
	, [ModifiedDate]
	, [ModifiedUserID]
	, [ViewInKareo]
	, [ViewInServiceManager]
	, [PermissionGroupID]
	, [PermissionValue])
VALUES (
	'Find All Insurance Plans'
	, 'View and administer all insurance plans.'
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 1
	, 1
	, 14
	, 'FindAllInsurancePlans' )
GO

/* Link existing security groups to the new permission ... */
DECLARE @PermissionID INT

SELECT	@PermissionID = P.PermissionID
FROM	[Permissions] P
WHERE	P.PermissionValue = 'FindAllInsurancePlans'

INSERT INTO [dbo].[SecurityGroupPermissions] ( 
	[SecurityGroupID]
	,[PermissionID]
	,[Allowed]
	,[CreatedDate]
	,[CreatedUserID]
	,[ModifiedDate]
	,[ModifiedUserID]
	,[Denied] )
SELECT
	SG.SecurityGroupID
	, @PermissionID
	, 1
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 0
FROM
	SecurityGroup SG
WHERE
	SG.SecurityGroupID IN (
		SELECT
			SG1.SecurityGroupID
		FROM
			SecurityGroup SG1
			JOIN SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG1.SecurityGroupID
			JOIN [Permissions] P ON P.PermissionID = SGP.PermissionID
		WHERE
			P.[Name] = 'Sign on to Administrator'
			AND SGP.Allowed = 1
			AND SGP.Denied = 0 )
	AND SG.SecurityGroupID IN (
		SELECT
			SG2.SecurityGroupID
		FROM
			SecurityGroup SG2
			JOIN SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG2.SecurityGroupID
			JOIN [Permissions] P ON P.PermissionID = SGP.PermissionID
		WHERE
			P.[Name] = 'Find Insurance Plan' 
			AND SGP.Allowed = 1
			AND SGP.Denied = 0 )
ORDER BY
	SG.SecurityGroupID
GO

/* Create new 'View Enrollment Status of All Practices' permission ... */
INSERT INTO [dbo].[Permissions] ( 
	[Name]
	, [Description]
	, [CreatedDate]
	, [CreatedUserID]
	, [ModifiedDate]
	, [ModifiedUserID]
	, [ViewInKareo]
	, [ViewInServiceManager]
	, [PermissionGroupID]
	, [PermissionValue])
VALUES (
	'Find Enrollment Status of All Practices'
	, 'View enrollment status of all practices.'
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 1
	, 1
	, 14
	, 'FindAllPracticeEnrollmentStatuses' )
GO

/* Link existing security groups to the new permission ... */
DECLARE @PermissionID INT

SELECT	@PermissionID = P.PermissionID
FROM	[Permissions] P
WHERE	P.PermissionValue = 'FindAllPracticeEnrollmentStatuses'

INSERT INTO [dbo].[SecurityGroupPermissions] ( 
	[SecurityGroupID]
	,[PermissionID]
	,[Allowed]
	,[CreatedDate]
	,[CreatedUserID]
	,[ModifiedDate]
	,[ModifiedUserID]
	,[Denied] )
SELECT
	SG.SecurityGroupID
	, @PermissionID
	, 1
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 0
FROM
	SecurityGroup SG
WHERE
	SG.SecurityGroupID IN (
		SELECT
			SG1.SecurityGroupID
		FROM
			SecurityGroup SG1
			JOIN SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG1.SecurityGroupID
			JOIN [Permissions] P ON P.PermissionID = SGP.PermissionID
		WHERE
			P.[Name] = 'Sign on to Administrator'
			AND SGP.Allowed = 1
			AND SGP.Denied = 0 )
	AND SG.SecurityGroupID IN (
		SELECT
			SG2.SecurityGroupID
		FROM
			SecurityGroup SG2
			JOIN SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG2.SecurityGroupID
			JOIN [Permissions] P ON P.PermissionID = SGP.PermissionID
		WHERE
			P.[Name] = 'Find Practice' 
			AND SGP.Allowed = 1
			AND SGP.Denied = 0 )
ORDER BY
	SG.SecurityGroupID
GO

/*=============================================================================
Case 14808 - Add permission to handle report closing date
=============================================================================*/

/* Create new 'Override Report Closing Date Restrictions' permission ... */
INSERT INTO [dbo].[Permissions] ( 
	[Name]
	, [Description]
	, [CreatedDate]
	, [CreatedUserID]
	, [ModifiedDate]
	, [ModifiedUserID]
	, [ViewInKareo]
	, [ViewInServiceManager]
	, [PermissionGroupID]
	, [PermissionValue])
VALUES (
	'Override Report Closing Date Restrictions'
	, 'Override restrictions on viewing reports, specifically related to closing the books date'
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 1
	, 1
	, 19
	, 'OverrideReportClosingDateRestrictions' )
GO

/* Link existing security groups to the new permission ... */
DECLARE @Permission14808ID INT

SELECT	@Permission14808ID = P.PermissionID
FROM	[Permissions] P
WHERE	P.PermissionValue = 'OverrideReportClosingDateRestrictions'

INSERT INTO [dbo].[SecurityGroupPermissions] ( 
	[SecurityGroupID]
	,[PermissionID]
	,[Allowed]
	,[CreatedDate]
	,[CreatedUserID]
	,[ModifiedDate]
	,[ModifiedUserID]
	,[Denied] )
SELECT
	SG.SecurityGroupID
	, @Permission14808ID
	, 1
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 0
FROM
	SecurityGroup SG
WHERE
	SG.SecurityGroupID IN (
		SELECT
			SG1.SecurityGroupID
		FROM
			SecurityGroup SG1
			JOIN SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG1.SecurityGroupID
			JOIN [Permissions] P ON P.PermissionID = SGP.PermissionID
		WHERE
			P.[Name] = 'Sign on to Administrator'
			AND SGP.Allowed = 1
			AND SGP.Denied = 0 )
	AND SG.SecurityGroupID IN (
		SELECT
			SG2.SecurityGroupID
		FROM
			SecurityGroup SG2
			JOIN SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG2.SecurityGroupID
			JOIN [Permissions] P ON P.PermissionID = SGP.PermissionID
		WHERE
			P.[Name] = 'Find Practice' 
			AND SGP.Allowed = 1
			AND SGP.Denied = 0 )
ORDER BY
	SG.SecurityGroupID
GO


/*=============================================================================
Case 14011 - Merge Business Manager, Medical Office, and Administrator
=============================================================================*/

/* Update the CreatePermission stored procedure so we can use it */
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_AuthenticationDataProvider_CreatePermission'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_CreatePermission
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_CreatePermission
@Name VARCHAR(128), 
@Description VARCHAR(500),
@ViewInKareo BIT,
@ViewInServiceManager BIT = 1,
@PermissionGroupID INT,
@PermissionValue VARCHAR(128)

AS

BEGIN
	INSERT dbo.[Permissions] ( 
		[Name]
		, Description
		, ViewInKareo
		, ViewInServiceManager
		, PermissionGroupID
		, PermissionValue )
	VALUES (
		@Name
		, @Description
		, @ViewInKareo
		, @ViewInServiceManager
		, @PermissionGroupID
		, @PermissionValue )

	RETURN SCOPE_IDENTITY()
END
GO



/* Create new [DashboardType] look-up table ... */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DashboardType]') AND type in (N'U'))
DROP TABLE [dbo].[DashboardType]
GO

CREATE TABLE dbo.DashboardType
	(
	DashboardTypeID int NOT NULL,
	DashboardTypeName varchar(30) NOT NULL,
	SortOrder int NOT NULL
	)  ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DashboardType]') AND name = N'PK_DashboardType')
ALTER TABLE [dbo].[DashboardType] DROP CONSTRAINT [PK_DashboardType]
GO

ALTER TABLE dbo.DashboardType ADD CONSTRAINT
	PK_DashboardType PRIMARY KEY CLUSTERED 
	(
	DashboardTypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

INSERT INTO [dbo].[DashboardType] (
	[DashboardTypeID]
	,[DashboardTypeName]
	,[SortOrder] )
VALUES (
	1
	, 'Medical Office'
	, 1 )

INSERT INTO [dbo].[DashboardType] (
	[DashboardTypeID]
	,[DashboardTypeName]
	,[SortOrder] )
VALUES (
	2
	, 'Business Office'
	, 2 )
GO

/* Add new DashboardTypeCode column to store practice dashboard preference ... */
ALTER TABLE dbo.Users ADD
	DashboardTypeID int NULL
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_DashboardTypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [FK_Users_DashboardTypeID]
GO

ALTER TABLE dbo.Users ADD CONSTRAINT
	FK_Users_DashboardTypeID FOREIGN KEY
	(
	DashboardTypeID
	) REFERENCES dbo.DashboardType
	(
	DashboardTypeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

/* Update DashboardTypeCode based on existing user permissions ... */
UPDATE 
	dbo.Users
SET 
	DashboardTypeID = 1
GO

UPDATE 
	dbo.Users
SET 
	DashboardTypeID = 2
WHERE
	UserID IN (
		SELECT 
			DISTINCT U.UserID
		FROM
			dbo.Users U
			JOIN dbo.UsersSecurityGroup USG ON USG.UserID = U.UserID
			JOIN dbo.SecurityGroup SG ON SG.SecurityGroupID = USG.SecurityGroupID
			JOIN dbo.SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG.SecurityGroupID
			JOIN dbo.[Permissions] P ON P.PermissionID = SGP.PermissionID
		WHERE
			P.[Name] = 'Sign on to Business Manager'
			AND SGP.Allowed = 1
			AND SGP.Denied = 0 )
GO

/* Case 14808 - Implement permission for viewing override of report closing date */
DECLARE @Case14808ID INT
EXEC @Case14808ID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Override Report Closing Date Restrictions',
	@Description='Override restrictions on viewing reports for dates past the report closing date.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='OverrideReportClosingDateRestrictions'

-- Give anyone who has access to Business Manager the override report closing date restrictions access
INSERT INTO [dbo].[SecurityGroupPermissions] ( 
	[SecurityGroupID]
	,[PermissionID]
	,[Allowed]
	,[CreatedDate]
	,[CreatedUserID]
	,[ModifiedDate]
	,[ModifiedUserID]
	,[Denied] )
SELECT
	SG.SecurityGroupID
	, @Case14808ID
	, 1
	, GETDATE()
	, 0
	, GETDATE()
	, 0
	, 0
FROM
	SecurityGroup SG
WHERE
	SG.SecurityGroupID IN (
		SELECT
			SG1.SecurityGroupID
		FROM
			SecurityGroup SG1
			JOIN SecurityGroupPermissions SGP ON SGP.SecurityGroupID = SG1.SecurityGroupID
			JOIN [Permissions] P ON P.PermissionID = SGP.PermissionID
		WHERE
			P.[Name] = 'Sign on to Business Manager'
			AND SGP.Allowed = 1
			AND SGP.Denied = 0 )
GO

/* Remove links to obsolete sign-on permissions ... */
DELETE 
FROM SecurityGroupPermissions
WHERE
	PermissionID IN (
		SELECT	PermissionID
		FROM	[Permissions] P 
		WHERE	P.[Name] IN ( 'Sign on to Medical Office'
				, 'Sign on to Business Manager'
				, 'Sign on to Administrator' ) )
GO

DELETE 
FROM LicensePermission
WHERE
	PermissionID IN (
		SELECT	PermissionID
		FROM	[Permissions] P 
		WHERE	P.[Name] IN ( 'Sign on to Medical Office'
				, 'Sign on to Business Manager'
				, 'Sign on to Administrator' ) )
GO

/* Remove obsolete sign-on permissions ... */
DELETE
FROM	[Permissions]
WHERE	[Name] IN ( 'Sign on to Medical Office'
		, 'Sign on to Business Manager'
		, 'Sign on to Administrator' )
GO

/*-----------------------------------------------------------------------------
Case 12242:   Implement new Missed Encounter report 
-----------------------------------------------------------------------------*/
--The report was deployed with its permission value set to the existing permsionvalue of PrintAppointments
--We can do a correction to this later, to expidite deployment Dan said use an existing permission


--DECLARE @PaymentByProcedureRptPermissionID INT
--
--EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
--	@Name='Read Missed Encounters Report',
--	@Description='Display, print, and save the missed encounters report.', 
--	@ViewInMedicalOffice=1,
--	@ViewInBusinessManager=1,
--	@ViewInAdministrator=1,
--	@ViewInServiceManager=1,
--	@PermissionGroupID=10,
--	@PermissionValue='ReadMissedEncountersReport'
-- 
--
--EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
--	@CheckPermissionValue='PrintAppointments',
--	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
--
--
--GO


/*-----------------------------------------------------------------------------
Case 14030:   Implement new Adjustments Detail report  
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Adjustments Detail Report',
	@Description='Display, print, and save the adjustments detail report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadAdjustmentsDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPaymentApplication',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO

/*-----------------------------------------------------------------------------
Case 14029:   Implement new Adjustments Summary report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Adjustments Summary Report',
	@Description='Display, print, and save the adjustments summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadAdjustmentsSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPaymentApplication',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO
/*-----------------------------------------------------------------------------
 Case 14031:   Implement new Charges Summary report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Charges Summary Report',
	@Description='Display, print, and save the charges summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadChargesSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadEncountersDetailReport',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO

/*-----------------------------------------------------------------------------
 Case 14032:   Implement new Charges Detail report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Charges Detail Report',
	@Description='Display, print, and save the charges detail report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadChargesDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadEncountersDetailReport',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID


GO


/*-----------------------------------------------------------------------------
 Case 14039:   Implement new Denials Summary report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Denials Summary Report',
	@Description='Display, print, and save the denials summary report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadDenialsSummaryReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadAdjustmentsSummaryReport',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO

/*-----------------------------------------------------------------------------
 Case 14040:   Implement new Denials Detail report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Denials Detail Report',
	@Description='Display, print, and save the denials over a period of time.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadDenialsDetailReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadAdjustmentsDetailReport',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID
GO


/*-----------------------------------------------------------------------------
Case 14038:   Implement new User Productivity report 
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read User Productivity Report',
	@Description='Display, print, and save the user productivity report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadUserProductivityReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadKeyIndicatorsSummary',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID

	-- view needed for sproc
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vDatabaseUsers]'))
	DROP VIEW [dbo].[vDatabaseUsers]
	GO

	CREATE view [dbo].[vDatabaseUsers]
	AS

		select DatabaseName, u.UserID, FirstName, LastName, emailAddress
		from Customer c
			INNER JOIN CustomerUsers cu on cu.CustomerID = c.CUstomerID
			INNER JOIN Users u on u.UserID = cu.UserID

	GO

/*-----------------------------------------------------------------------------
 Case 14690:   User Productivity Report for all Practice ( Company User Productivity Report)
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Company User Productivity Report',
	@Description='Display, print, and save the company user productivity report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadCompanyUserProductivityReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadKeyIndicatorsSummary',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID

GO



ALTER TABLE dbo.ClearinghousePayersList ADD
	SupportsPatientEligibilityRequests bit NOT NULL DEFAULT 0
GO


/*-----------------------------------------------------------------------------
Case 14090:   Implement transport for Eligibility (X12/270) handshakes 
-----------------------------------------------------------------------------*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EligibilityTransport]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EligibilityTransport]
GO

CREATE TABLE EligibilityTransport (
	[EligibilityTransportId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_EligibilityTransport_EligibilityTransportID 
		PRIMARY KEY NONCLUSTERED,
	[TransportName] varchar(128), 
	[TransportType] varchar(32),		-- like 'FTP' or 'HTTP' - for factory to know what object to create
	[InProduction] bit, 

	[ParametersXml] ntext,

	[Notes] ntext
)
GO

INSERT EligibilityTransport (TransportName, TransportType, InProduction, ParametersXml)
VALUES ('MedAvant HTTP', 'HTTP', 1,
'<Parameters>
  <Http>
    <Url>https://b2b.medavanthealth.net/b2b/X12Transaction</Url>
	<Login>kirvin6</Login>
	<Password>pitkirvin6</Password>
  </Http>
  <AnsiX12>
	<SubmitterName>KAREO</SubmitterName>
	<SubmitterEtin>00739220</SubmitterEtin>
	<SubmitterContactName>Kareo Inc Eligibility</SubmitterContactName>
	<SubmitterContactPhone>1-888-775-2736</SubmitterContactPhone>
	<SubmitterContactEmail>sergei@kareo.com</SubmitterContactEmail>
	<SubmitterContactFax>949-209-3473</SubmitterContactFax>
	<ReceiverName>MEDAVANT</ReceiverName>
	<ReceiverEtin>770545613</ReceiverEtin>
  </AnsiX12>
</Parameters>')
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EligibilityVendor]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EligibilityVendor]
GO

CREATE TABLE EligibilityVendor (
	[EligibilityVendorId] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_EligibilityVendor_EligibilityVendorID 
		PRIMARY KEY NONCLUSTERED,
	[VendorName] varchar(128), 
	[Active] bit, 
	[EligibilityTransportId] int,
	[Notes] ntext
)

GO

ALTER TABLE [dbo].[EligibilityVendor] ADD
	CONSTRAINT [FK_EligibilityVendor_EligibilityTransportId] FOREIGN KEY 
	(
		[EligibilityTransportId]
	) REFERENCES [EligibilityTransport] (
		[EligibilityTransportId]
	)
GO

INSERT EligibilityVendor (VendorName, Active, EligibilityTransportId)
			VALUES ('MedAvant', 1, 1)
GO

/*-----------------------------------------------------------------------------
Case 14529: Add custom procedure groups to define procedure category for reporting 
-----------------------------------------------------------------------------*/
--CREATE TABLE [dbo].[ProcedureCategory](
--	[ProcedureCategoryID] INT NOT NULL IDENTITY(1,1) 
--	CONSTRAINT [PK_ProcedureCategory] PRIMARY KEY NONCLUSTERED ,
--	[Name] varchar(64) NOT NULL,
--	[Description] varchar(500) NULL,
--	[Notes] [text] NULL,
--	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
--	[CreatedUserID] [int] NOT NULL DEFAULT ((0)),
--	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
--	[ModifiedUserID] [int] NOT NULL DEFAULT ((0)),
--	[RecordTimeStamp] [timestamp] NOT NULL,
--) 
--GO
----INSERT A SINGLE RECORD SO FOREIGN KEY POINTING TO THIS TABLE COULD BE SET
--INSERT INTO [Superbill_Shared].[dbo].[ProcedureCategory]
--           ([Name]
--           ,[Description]
--           ,[Notes])
--     VALUES
--           ('General'
--           ,'General Category'
--           ,'All purpose category')
--GO
--
--ALTER TABLE dbo.ProcedureCodeDictionary ADD
--	ProcedureCategoryID INT NOT NULL DEFAULT 1,
--	CONSTRAINT [FK_ProcedureCodeDictionary_ProcedureCategory] FOREIGN KEY 
--	(
--		ProcedureCategoryID
--	) REFERENCES  dbo.ProcedureCategory(
--		ProcedureCategoryID
--	)
--GO



/*-----------------------------------------------------------------------------
Case 16568: Add COB options to application
-----------------------------------------------------------------------------*/

ALTER TABLE ClearinghousePayersList ADD
	SupportsSecondaryElectronicBilling bit NOT NULL DEFAULT 0,
	SupportsCoordinationOfBenefits bit NOT NULL DEFAULT 1
GO


/*-----------------------------------------------------------------------------
Case 17350: Implement Special Kareo Users
-----------------------------------------------------------------------------*/

ALTER TABLE Users ADD
	AccountHidden bit NOT NULL DEFAULT 0

INSERT INTO [Permissions] ([Name], Description, ViewInServiceManager, PermissionGroupID, PermissionValue, ViewInKareo)
VALUES ('Access to all practices', 'Allow access to all practices', 1, 12, 'AccessAllPractices', 0) 



/*-----------------------------------------------------------------------------
 Case 17917:   Create receipt report
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Payment Receipt report',
	@Description='Display, print, and save the payment receipt report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadPaymentReceiptReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPatientStatementReport',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID

GO


/*-----------------------------------------------------------------------------
 Case 14530:   Create new "itemization of charges" report using existing SP
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptPermissionID INT

EXEC @PaymentByProcedureRptPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Itemization of Charges report',
	@Description='Display, print, and save the itemization of charges report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=10,
	@PermissionValue='ReadItemizationOfChargesReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='ReadPatientBalanceDetail',
	@PermissionToApplyID=@PaymentByProcedureRptPermissionID

GO





INSERT INTO AttachConditionsType
           (AttachConditionsTypeID
           ,AttachConditionsTypeName)
     VALUES
           (5,'Eligibility Checks Only Additional')

----------------------------------------------------------------
-- CASE 17937 permissions associated with checking eligibility 
----------------------------------------------------------------
/* Create new 'Check Patient Eligibility' permission ... */
DECLARE @CheckPatientEligibilityPermissionID INT

EXEC @CheckPatientEligibilityPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Check Patient Eligibility',
	@Description='Request a patient eligibility report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=6,
	@PermissionValue='CheckPatientEligibility'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@CheckPatientEligibilityPermissionID
GO

/* Create new 'Find Patient Eligibility Report' permission ... */
DECLARE @FindPatientEligibilityReportPermissionID INT

EXEC @FindPatientEligibilityReportPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Find Patient Eligibility Report',
	@Description='Display a list of patient eligibility reports.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=6,
	@PermissionValue='FindPatientEligibilityReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@FindPatientEligibilityReportPermissionID
GO


/* Create new 'Read Patient Eligibility Report' permission ... */
DECLARE @ReadPatientEligibilityReportPermissionID INT

EXEC @ReadPatientEligibilityReportPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Patient Eligibility Report',
	@Description='Show the details of a patient eligibility report.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=6,
	@PermissionValue='ReadPatientEligibilityReport'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@ReadPatientEligibilityReportPermissionID
GO



----------------------------------------------------------------
-- CASE 17935 permissions for the new Procedure Categories 
----------------------------------------------------------------
/* Create new 'New Procedure Category' permission ... */
DECLARE @NewProcedureCategoryPermissionID INT

EXEC @NewProcedureCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='New Procedure Category',
	@Description='Create a new procedure category record.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=15,
	@PermissionValue='NewProcedureCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@NewProcedureCategoryPermissionID
GO

/* Create new 'Edit Procedure Category' permission ... */
DECLARE @EditProcedureCategoryPermissionID INT

EXEC @EditProcedureCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Edit Procedure Category',
	@Description='Modify the details of a procedure category record.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=15,
	@PermissionValue='EditProcedureCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@EditProcedureCategoryPermissionID
GO

/* Create new 'Read Procedure Category' permission ... */
DECLARE @ReadProcedureCategoryPermissionID INT

EXEC @ReadProcedureCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Read Procedure Category',
	@Description='Show the details of a procedure category record.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=15,
	@PermissionValue='ReadProcedureCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@ReadProcedureCategoryPermissionID
GO

/* Create new 'Find Procedure Category' permission ... */
DECLARE @FindProcedureCategoryPermissionID INT

EXEC @FindProcedureCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Find Procedure Category',
	@Description='Display and search a list of procedure category records.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=15,
	@PermissionValue='FindProcedureCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='FindPatient',
	@PermissionToApplyID=@FindProcedureCategoryPermissionID
GO

/* Create new 'Delete Procedure Category' permission ... */
DECLARE @DeleteProcedureCategoryPermissionID INT

EXEC @DeleteProcedureCategoryPermissionID=Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Delete Procedure Category',
	@Description='Delete a procedure category record.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=15,
	@PermissionValue='DeleteProcedureCategory'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='DeletePatient',
	@PermissionToApplyID=@DeleteProcedureCategoryPermissionID
GO


--ROLLBACK
--COMMIT
