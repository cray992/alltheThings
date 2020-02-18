/*

DATABASE UPDATE SCRIPT

v1.19.1719 to v1.20.xxxx
*/
----------------------------------

EXEC sp_change_users_login @Action = 'Update_One', @UserNamePattern = 'dev', @LoginName = 'dev'

--BEGIN TRAN 
----------------------------------

--case 2513

---- Create AppointmentReason

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_Appointment_AppointmentReason'
)
ALTER TABLE dbo.Appointment
DROP CONSTRAINT FK_Appointment_AppointmentReason

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_AppointmentReason_Practice'
)
ALTER TABLE dbo.AppointmentReason
DROP CONSTRAINT FK_AppointmentReason_Practice

GO


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_AppointmentToAppointmentReason_AppointmentReason'
)
ALTER TABLE dbo.AppointmentToAppointmentReason
DROP CONSTRAINT FK_AppointmentToAppointmentReason_AppointmentReason

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'AppointmentReason'
)
DROP TABLE dbo.AppointmentReason

GO
--===========================================================================

CREATE TABLE dbo.AppointmentReason (
	AppointmentReasonID INT IDENTITY(1,1) NOT NULL,
	PracticeID INT NOT NULL,

	Name varchar(128) NOT NULL,   
	DefaultDurationMinutes int NULL, 
	DefaultColorCode int NULL, 
	Description varchar(256) NULL, 

	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	TIMESTAMP
)

ALTER TABLE dbo.AppointmentReason
ADD CONSTRAINT PK_AppointmentReason
PRIMARY KEY (AppointmentReasonID)

ALTER TABLE dbo.AppointmentReason
ADD CONSTRAINT FK_AppointmentReason_Practice
FOREIGN KEY (PracticeID)
REFERENCES Practice(PracticeID)

GO

---- Create AppointmentToAppointmentReason

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_AppointmentToAppointmentReason_Appointment'
)
ALTER TABLE dbo.AppointmentToAppointmentReason
DROP CONSTRAINT FK_AppointmentToAppointmentReason_Appointment

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'AppointmentToAppointmentReason'
)
DROP TABLE dbo.AppointmentToAppointmentReason

GO
--===========================================================================

CREATE TABLE dbo.AppointmentToAppointmentReason (
	AppointmentToAppointmentReasonID INT IDENTITY(1,1) NOT NULL,
	AppointmentID INT NOT NULL,
	AppointmentReasonID INT NOT NULL,

	PrimaryAppointment bit NULL, 

	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	TIMESTAMP
)

ALTER TABLE dbo.AppointmentToAppointmentReason
ADD CONSTRAINT PK_AppointmentToAppointmentReason
PRIMARY KEY (AppointmentToAppointmentReasonID)

ALTER TABLE dbo.AppointmentToAppointmentReason
ADD CONSTRAINT FK_AppointmentToAppointmentReason_Appointment
FOREIGN KEY (AppointmentID)
REFERENCES Appointment(AppointmentID)

ALTER TABLE dbo.AppointmentToAppointmentReason
ADD CONSTRAINT FK_AppointmentToAppointmentReason_AppointmentReason
FOREIGN KEY (AppointmentReasonID)
REFERENCES AppointmentReason(AppointmentReasonID)

GO

---- Create AppointmentToResource

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_AppointmentToResource_Appointment'
)
ALTER TABLE dbo.AppointmentToResource
DROP CONSTRAINT FK_AppointmentToResource_Appointment

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_AppointmentToResource_AppointmentResourceType'
)
ALTER TABLE dbo.AppointmentToResource
DROP CONSTRAINT FK_AppointmentToResource_AppointmentResourceType

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'AppointmentToResource'
)
DROP TABLE dbo.AppointmentToResource

GO
--===========================================================================

CREATE TABLE dbo.AppointmentToResource (
	AppointmentToResourceID INT IDENTITY(1,1) NOT NULL,
	AppointmentID INT NOT NULL,
	AppointmentResourceTypeID INT NOT NULL, 
	ResourceID INT NOT NULL,

	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	TIMESTAMP
)

ALTER TABLE dbo.AppointmentToResource
ADD CONSTRAINT PK_AppointmentToResource
PRIMARY KEY (AppointmentToResourceID)

ALTER TABLE dbo.AppointmentToResource
ADD CONSTRAINT FK_AppointmentToResource_Appointment
FOREIGN KEY (AppointmentID)
REFERENCES Appointment(AppointmentID)

ALTER TABLE dbo.AppointmentToResource
ADD CONSTRAINT FK_AppointmentToResource_AppointmentResourceType
FOREIGN KEY (AppointmentResourceTypeID)
REFERENCES AppointmentResourceType(AppointmentResourceTypeID)

GO

---- Remove DoctorID from Appointment table, populate AppointmentToResource with info

INSERT AppointmentToResource
	(AppointmentID, AppointmentResourceTypeID, ResourceID)
SELECT	AppointmentID, 1, DoctorID
FROM	Appointment
WHERE	AppointmentResourceTypeID = 1

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_Appointment_Doctor'
)
ALTER TABLE dbo.Appointment
DROP CONSTRAINT FK_Appointment_Doctor

GO

IF EXISTS (
	SELECT	*
	FROM	SYSINDEXES
	WHERE	Name = 'IX_Appointment_DoctorID'
)
DROP INDEX Appointment.IX_Appointment_DoctorID

GO

IF EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Appointment'
	AND	COLUMN_NAME = 'DoctorID'
)
ALTER TABLE dbo.Appointment
DROP COLUMN DoctorID


GO

---- Remove PracticeResourceID & AppointmentResourceTypeID from Appointment table, populate AppointmentToResource with info

INSERT AppointmentToResource
	(AppointmentID, AppointmentResourceTypeID, ResourceID)
SELECT	AppointmentID, 2, PracticeResourceID
FROM	Appointment
WHERE	AppointmentResourceTypeID = 2

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_Appointment_PracticeResource'
)
ALTER TABLE dbo.Appointment
DROP CONSTRAINT FK_Appointment_PracticeResource

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_Appointment_AppointmentResourceType'
)
ALTER TABLE dbo.Appointment
DROP CONSTRAINT FK_Appointment_AppointmentResourceType

GO

IF EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Appointment'
	AND	COLUMN_NAME = 'PracticeResourceID'
)
ALTER TABLE dbo.Appointment
DROP COLUMN PracticeResourceID


GO
-------------- !!!!!!!!!!!!! this doesn't work yet
/*IF EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Appointment'
	AND	COLUMN_NAME = 'AppointmentResourceTypeID'
)
ALTER TABLE dbo.Appointment
DROP COLUMN AppointmentResourceTypeID
*/

GO

---- Remove AppointmentReasonID from Appointment table, populate AppointmentToAppointmentReason with info

INSERT AppointmentToAppointmentReason
	(AppointmentID, AppointmentReasonID, PrimaryAppointment)
SELECT	AppointmentID, AppointmentReasonID, 1
FROM	Appointment
WHERE	not AppointmentReasonID is null

GO

IF EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Appointment'
	AND	COLUMN_NAME = 'AppointmentReasonID'
)
ALTER TABLE dbo.Appointment
DROP COLUMN AppointmentReasonID


GO

---- Remove AdminNotes column, concat with existing Notes data

UPDATE	Appointment
SET	Notes = cast(Notes as varchar(8000)) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + cast(AdminNotes as varchar(8000))

GO

IF EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Appointment'
	AND	COLUMN_NAME = 'AdminNotes'
)
ALTER TABLE dbo.Appointment
DROP COLUMN AdminNotes


GO

---- Remove NoAuthorizationRequired column

IF EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Appointment'
	AND	COLUMN_NAME = 'NoAuthorizationRequired'
)
ALTER TABLE dbo.Appointment
DROP COLUMN NoAuthorizationRequired


GO

---- Create AppointmentConfirmationStatus table

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'AppointmentConfirmationStatus'
)
DROP TABLE dbo.AppointmentConfirmationStatus


GO

--===========================================================================

CREATE TABLE dbo.AppointmentConfirmationStatus (
	AppointmentConfirmationStatusCode CHAR(1) NOT NULL,
	Name VARCHAR(64) NOT NULL,

	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	TIMESTAMP
)

ALTER TABLE dbo.AppointmentConfirmationStatus
ADD CONSTRAINT PK_AppointmentConfirmationStatus
PRIMARY KEY (AppointmentConfirmationStatusCode)

INSERT 	AppointmentConfirmationStatus
	(AppointmentConfirmationStatusCode, 
	Name, 
	ModifiedDate)
VALUES	('S', 
	'Scheduled',
	GetDate())

INSERT 	AppointmentConfirmationStatus
	(AppointmentConfirmationStatusCode, 
	Name, 
	ModifiedDate)
VALUES	('C', 
	'Confirmed',
	GetDate())

INSERT 	AppointmentConfirmationStatus
	(AppointmentConfirmationStatusCode, 
	Name, 
	ModifiedDate)
VALUES	('X', 
	'Cancelled',
	GetDate())

INSERT 	AppointmentConfirmationStatus
	(AppointmentConfirmationStatusCode, 
	Name, 
	ModifiedDate)
VALUES	('I', 
	'Check-in',
	GetDate())

INSERT 	AppointmentConfirmationStatus
	(AppointmentConfirmationStatusCode, 
	Name, 
	ModifiedDate)
VALUES	('O', 
	'Check-out',
	GetDate())

INSERT 	AppointmentConfirmationStatus
	(AppointmentConfirmationStatusCode, 
	Name, 
	ModifiedDate)
VALUES	('N', 
	'No-show',
	GetDate())

GO

---- Add AppointmentConfirmationStatusCode to Appointment table

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_Appointment_AppointmentConfirmationStatus'
)
ALTER TABLE dbo.Appointment
DROP CONSTRAINT FK_Appointment_AppointmentConfirmationStatus

GO

IF NOT EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Appointment'
	AND	COLUMN_NAME = 'AppointmentConfirmationStatusCode'
)
ALTER TABLE dbo.Appointment
ADD AppointmentConfirmationStatusCode char(1) NULL

GO

-- Update old appointments with a confirmation status code
UPDATE	Appointment
SET	AppointmentConfirmationStatusCode = 'C'

GO

-- Make the AppointmentConfirmationStatusCode a non nullable field
ALTER TABLE dbo.Appointment
ALTER COLUMN AppointmentConfirmationStatusCode char(1) NOT NULL

-- Add the foreign key constraint
ALTER TABLE dbo.Appointment
ADD CONSTRAINT FK_Appointment_AppointmentConfirmationStatus
FOREIGN KEY (AppointmentConfirmationStatusCode)
REFERENCES AppointmentConfirmationStatus(AppointmentConfirmationStatusCode)

GO

---- Add AllDay to Appointment table

IF NOT EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Appointment'
	AND	COLUMN_NAME = 'AllDay'
)
ALTER TABLE dbo.Appointment
ADD AllDay BIT NULL

GO

-- Update old appointments with a confirmation status code
UPDATE	Appointment
SET	AllDay = 0

GO

-- Make the AppointmentConfirmationStatusCode a non nullable field
ALTER TABLE dbo.Appointment
ALTER COLUMN AllDay BIT NOT NULL

-- Add a default constraint
ALTER TABLE dbo.Appointment
ADD CONSTRAINT DF_Appointment_AllDay DEFAULT(0) FOR AllDay

GO

---- Remove NOT NULL constraint for ModifiedUserID and CreatedUserID in Appointment table

-- Make the ModifiedUserID a nullable field
ALTER TABLE dbo.Appointment
ALTER COLUMN ModifiedUserID INT NULL

-- Make the CreatedUserID a nullable field
ALTER TABLE dbo.Appointment
ALTER COLUMN CreatedUserID INT NULL

GO

---- Create AppointmentReasonDefaultResource

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'FK_AppointmentReasonDefaultResource_AppointmentReason'
)
ALTER TABLE dbo.AppointmentReasonDefaultResource
DROP CONSTRAINT FK_AppointmentReasonDefaultResource_AppointmentReason

GO


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'AppointmentReasonDefaultResource'
)
DROP TABLE dbo.AppointmentReasonDefaultResource

GO
--===========================================================================

CREATE TABLE dbo.AppointmentReasonDefaultResource (
	AppointmentReasonDefaultResourceID INT IDENTITY(1,1) NOT NULL,
	AppointmentReasonID INT NOT NULL,
	AppointmentResourceTypeID INT NOT NULL, 
	ResourceID INT NOT NULL,

	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	TIMESTAMP
)

ALTER TABLE dbo.AppointmentReasonDefaultResource
ADD CONSTRAINT PK_AppointmentReasonDefaultResource
PRIMARY KEY (AppointmentReasonDefaultResourceID)

ALTER TABLE dbo.AppointmentReasonDefaultResource
ADD CONSTRAINT FK_AppointmentReasonDefaultResource_AppointmentReason
FOREIGN KEY (AppointmentReasonID)
REFERENCES AppointmentReason(AppointmentReasonID)

GO

--===========================================================================
-- case 2273:

update report set displayorder = 1 where name = 'Key Indicators Detail'

GO

--===========================================================================
-- case 2321:
ALTER TABLE [dbo].[PatientInsurance] ADD [Phone] [varchar](10) NULL
ALTER TABLE [dbo].[PatientInsurance] ADD [PhoneExt] [varchar](10) NULL
ALTER TABLE [dbo].[PatientInsurance] ADD [Fax] [varchar](10) NULL
ALTER TABLE [dbo].[PatientInsurance] ADD [FaxExt] [varchar](10) NULL
GO

--===========================================================================
-- case 2507:
ALTER TABLE [dbo].[Encounter] ADD [ConditionNotes] TEXT
GO

UPDATE EncounterStatus SET EncounterStatusDescription = 'Draft' WHERE EncounterStatusDescription = 'In Progress'
GO

--===========================================================================
-- case 2508:

CREATE TABLE dbo.EncounterStatusMobile
(
	EncounterStatusID int IDENTITY(1,1) NOT NULL,
	EncounterStatusDescription varchar (50)
)
GO

ALTER TABLE dbo.EncounterStatusMobile
ADD CONSTRAINT PK_EncounterStatusMobile
PRIMARY KEY (EncounterStatusID)
GO

INSERT INTO  dbo.EncounterStatusMobile (EncounterStatusDescription) VALUES ('For Review')
INSERT INTO  dbo.EncounterStatusMobile (EncounterStatusDescription) VALUES ('Processed')

ALTER TABLE [dbo].[HandheldEncounter] ADD EncounterStatusID int NOT NULL DEFAULT (1)
ALTER TABLE [dbo].[HandheldEncounter] ADD CreatedUserID int
ALTER TABLE [dbo].[HandheldEncounter] ADD ModifiedUserID int
ALTER TABLE [dbo].[HandheldEncounter] ADD TIMESTAMP

ALTER TABLE dbo.HandheldEncounter
ADD CONSTRAINT FK_HandheldEncounter_EncounterStatusID
FOREIGN KEY (EncounterStatusID)
REFERENCES EncounterStatusMobile(EncounterStatusID)

--===========================================================================
-- case 2539:

CREATE TABLE dbo.SecuritySetting
(
	SecuritySettingID int IDENTITY(1,1) NOT NULL,
        PasswordMinimumLength int NOT NULL DEFAULT (4),
        PasswordRequireAlphaNumeric bit NOT NULL DEFAULT (0),
        PasswordRequireMixedCase bit NOT NULL DEFAULT (0),
        PasswordRequireNonAlphaNumeric bit NOT NULL DEFAULT (0),
        PasswordRequireDifferentPassword bit NOT NULL DEFAULT (1),
        PasswordRequireDifferentPasswordCount int NOT NULL DEFAULT (3),
        PasswordExpiration bit NOT NULL DEFAULT (1),
        PasswordExpirationDays int NOT NULL DEFAULT (180),
        LockoutAttempts int NOT NULL DEFAULT (5),
        LockoutPhone varchar(10) NULL,
        LockoutEmail varchar(100) NULL,
        UILockMinutesAdministrator int NOT NULL DEFAULT (30),
        UILockMinutesBusinessManager int NOT NULL DEFAULT (30),
        UILockMinutesMedicalOffice int NOT NULL DEFAULT (30),
        UILockMinutesPractitioner int NOT NULL DEFAULT (30)
)
GO

ALTER TABLE dbo.SecuritySetting
ADD CONSTRAINT PK_SecuritySetting
PRIMARY KEY (SecuritySettingID)
GO

CREATE TABLE dbo.UserPassword
(
	UserPasswordID int IDENTITY(1,1) NOT NULL,
	UserID int NOT NULL,
	Password varchar(40) NOT NULL,
	SecretQuestion varchar(255) NULL,
	SecretAnswer varchar(40) NULL,
	CreatedDate datetime NOT NULL DEFAULT (GETDATE()),
	Expired bit NOT NULL DEFAULT (0)
)
GO

ALTER TABLE dbo.UserPassword
ADD CONSTRAINT PK_UserPassword
PRIMARY KEY (UserPasswordID)
GO

ALTER TABLE dbo.Users ADD AccountLockCounter int NOT NULL DEFAULT (0)
ALTER TABLE dbo.Users ADD AccountLocked bit NOT NULL DEFAULT(0)
ALTER TABLE dbo.Users ADD UserPasswordID int NULL

ALTER TABLE dbo.Users ALTER COLUMN NtlmName varchar(64) NULL
ALTER TABLE dbo.Users ALTER COLUMN Password varchar(64) NULL
GO

ALTER TABLE dbo.Users
ADD CONSTRAINT FK_Users_UserPassword
FOREIGN KEY (UserPasswordID)
REFERENCES UserPassword(UserPasswordID)
GO

INSERT INTO SecuritySetting DEFAULT VALUES
GO

--===========================================================================
-- case 2539: Adding columns relating to medical office calendar options to the practice table

--CalendarStartTime
IF NOT EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Practice'
	AND	COLUMN_NAME = 'CalendarStartTime'
)
ALTER TABLE dbo.Practice
ADD CalendarStartTime datetime NULL

GO

-- Update existing records with a default start time
UPDATE	Practice
SET	CalendarStartTime = '1-1-2000 08:00:00'

GO

-- Make the CalendarStartTime a non nullable field
ALTER TABLE dbo.Practice
ALTER COLUMN CalendarStartTime datetime NOT NULL

-- Add a default constraint
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'DF_Practice_CalendarStartTime'
)
ALTER TABLE dbo.Practice
DROP CONSTRAINT DF_Practice_CalendarStartTime

GO

ALTER TABLE dbo.Practice
ADD CONSTRAINT DF_Practice_CalendarStartTime DEFAULT(cast('1-1-2000 08:00:00' as datetime)) FOR CalendarStartTime

GO

--CalendarEndTime
IF NOT EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Practice'
	AND	COLUMN_NAME = 'CalendarEndTime'
)
ALTER TABLE dbo.Practice
ADD CalendarEndTime datetime NULL

GO

-- Update existing records with a default end time
UPDATE	Practice
SET	CalendarEndTime = '1-1-2000 17:00:00'

GO

-- Make the CalendarEndTime a non nullable field
ALTER TABLE dbo.Practice
ALTER COLUMN CalendarEndTime datetime NOT NULL

-- Add a default constraint
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'DF_Practice_CalendarEndTime'
)
ALTER TABLE dbo.Practice
DROP CONSTRAINT DF_Practice_CalendarEndTime

GO
ALTER TABLE dbo.Practice
ADD CONSTRAINT DF_Practice_CalendarEndTime DEFAULT(cast('1-1-2000 17:00:00' as datetime)) FOR CalendarEndTime

GO

--CalendarIntervalMinutes
IF NOT EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Practice'
	AND	COLUMN_NAME = 'CalendarIntervalMinutes'
)
ALTER TABLE dbo.Practice
ADD CalendarIntervalMinutes int NULL

GO

-- Update existing records with a default end time
UPDATE	Practice
SET	CalendarIntervalMinutes = 15

GO

-- Make the CalendarIntervalMinutes a non nullable field
ALTER TABLE dbo.Practice
ALTER COLUMN CalendarIntervalMinutes int NOT NULL

-- Add a default constraint
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'DF_Practice_CalendarIntervalMinutes'
)
ALTER TABLE dbo.Practice
DROP CONSTRAINT DF_Practice_CalendarIntervalMinutes

GO
ALTER TABLE dbo.Practice
ADD CONSTRAINT DF_Practice_CalendarIntervalMinutes DEFAULT(15) FOR CalendarIntervalMinutes

GO

--CalendarUseAppointmentPrimaryReasonColor
IF NOT EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Practice'
	AND	COLUMN_NAME = 'CalendarUseAppointmentPrimaryReasonColor'
)
ALTER TABLE dbo.Practice
ADD CalendarUseAppointmentPrimaryReasonColor bit NULL

GO

-- Update existing records with a default end time
UPDATE	Practice
SET	CalendarUseAppointmentPrimaryReasonColor = 1

GO

-- Make the CalendarUseAppointmentPrimaryReasonColor a non nullable field
ALTER TABLE dbo.Practice
ALTER COLUMN CalendarUseAppointmentPrimaryReasonColor bit NOT NULL

-- Add a default constraint
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'DF_Practice_CalendarUseAppointmentPrimaryReasonColor'
)
ALTER TABLE dbo.Practice
DROP CONSTRAINT DF_Practice_CalendarUseAppointmentPrimaryReasonColor

GO
ALTER TABLE dbo.Practice
ADD CONSTRAINT DF_Practice_CalendarUseAppointmentPrimaryReasonColor DEFAULT(1) FOR CalendarUseAppointmentPrimaryReasonColor

GO

--===========================================================================
-- case 2514: Adding column to practice table to determine what the max date the medical office uses to view reports

--MedicalOfficeReportMaxDate
IF NOT EXISTS (
	SELECT 	*
	FROM 	INFORMATION_SCHEMA.COLUMNS 
	WHERE	TABLE_NAME = 'Practice'
	AND	COLUMN_NAME = 'MedicalOfficeReportMaxDate'
)
ALTER TABLE dbo.Practice
ADD MedicalOfficeReportMaxDate datetime NULL

GO

-- Update existing records with a default date
UPDATE	Practice
SET	MedicalOfficeReportMaxDate = '10-1-2004'

GO

-- Make the MedicalOfficeReportEndDate a non nullable field
ALTER TABLE dbo.Practice
ALTER COLUMN MedicalOfficeReportMaxDate datetime NOT NULL

GO

-- Add a default constraint
ALTER TABLE dbo.Practice
ADD CONSTRAINT DF_Practice_MedicalOfficeReportMaxDate 
DEFAULT(cast(cast(month(GetDate()) as varchar(2)) + '/' + cast(day(GetDate()) as varchar(2)) + '/' + cast(year(GetDate()) as varchar(4)) as datetime)) 
FOR MedicalOfficeReportMaxDate

GO

--===========================================================================
-- case 2691: Modify the ProcedureModifierCode to be a varchar(16) instead of char(2)

-- Drop the PK constrant
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'PK_ProcedureModifier'
)
ALTER TABLE dbo.ProcedureModifier
DROP CONSTRAINT PK_ProcedureModifier

GO

-- Change the ProcedureModifierCode to be varchar(16)
ALTER TABLE dbo.ProcedureModifier
ALTER COLUMN ProcedureModifierCode varchar(16) NOT NULL

GO

-- Re-add the primary key
ALTER TABLE dbo.ProcedureModifier
ADD CONSTRAINT PK_ProcedureModifier
PRIMARY KEY (ProcedureModifierCode)

GO

--===========================================================================
-- case 2703: Switch the display order for the Patient Referrals Summary and the Patient Referrals Detail reports

update	Report
set	DisplayOrder = 10
where	Name = 'Patient Referrals Detail'

update	Report
set	DisplayOrder = 9
where	Name = 'Patient Referrals Summary'

GO

--===========================================================================
INSERT INTO ReportCategory (DisplayOrder, Image, Name, Description, TaskName) values (
	6, '[[image[Practice.Reports.Images.reports.gif]]]', 'Refunds', 'Refunds', 'Report List'
)
GO
-- 'Refunds' --------------------------------------------------------------------
DECLARE @category int
DECLARE @server varchar(65)
SET @server = 'k0'
set @category = 6
delete from report where ReportCategoryID = @category

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 1, '[[image[Practice.Reports.Images.reports.gif]]]', 'Refunds Summary', 'This report provides a summary of all refunds, summed by payment type, received over a period of time.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptRefundsSummary', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
</parameters>' )

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 2, '[[image[Practice.Reports.Images.reports.gif]]]', 'Refunds Detail', 'This report provides a detailed list of refunds, grouped by payment type, received over a period of time.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptRefundsDetail', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Type:" default="0" ignore="0"/>
	</extendedParameters>
</parameters>' )

        
----------------------------------

--AR Aging Detail
-- 'Accounts Receivable' --------------------------------------------------------------------
--DECLARE @category int
--DECLARE @server varchar(65)
SET @server = 'k0'
set @category = 3
--delete from report where ReportCategoryID = @category

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 14, '[[image[Practice.Reports.Images.reports.gif]]]', 'A/R Aging Detail', 'This report provides a detailed accounts receivable aging schedule showing the outstanding balance on open claims, grouped by age range.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptARAgingDetail', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="RespType" text="Type:" description="Limits the report by payer." default="A">
			<value displayText="All" value="A" />
			<value displayText="Patient" value="P" />
			<value displayText="Insurance" value="I" />
		</extendedParameter>
	        <extendedParameter type="Patient" parameterName="RespID" text="Patient:" default="-1" ignore="-1"  enabledBasedOnParameter="RespType" enabledBasedOnValue="P"/>
		<extendedParameter type="Insurance" parameterName="RespID" text="Insurance:" default="-1" ignore="-1"  enabledBasedOnParameter="RespType" enabledBasedOnValue="I"/>
	</extendedParameters>
</parameters>' )

---------------------------------------------------------------------------------------

--===========================================================================
-- case 2676: Add an Appointments report category as well as an Appointments Summary report entry

-- 'Appointments' --------------------------------------------------------------------
--DECLARE @category int
delete from ReportCategory where Name = 'Appointments'
insert into ReportCategory 
(DisplayOrder, Image, Name, Description, TaskName)
values
(7, '[[image[Practice.Reports.Images.reports.gif]]]', 'Appointments', 'Appointments', 'Report List')

select @category = ReportCategoryID from ReportCategory where Name = 'Appointments'

--Appointments Summary
--DECLARE @server varchar(65)
SET @server = 'k0'
--delete from report where ReportCategoryID = @category

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 1, '[[image[Practice.Reports.Images.reports.gif]]]', 'Appointments Summary', 'This report provides a summary of all appointments over a period of time.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptAppointmentsSummary', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="Today" forceDefault="true" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" overrideMaxDate="true" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="AppointmentResourceTypeID" text="Type:" description="Limits the report by resource type." default="A" ignore="A">
			<value displayText="All" value="A" />
			<value displayText="Practice Resource" value="2" />
			<value displayText="Provider" value="1" />
		</extendedParameter>
		<extendedParameter type="PracticeResources" parameterName="ResourceID" text="Practice Resource:" default="-1" ignore="-1"  enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="2" />
	        <extendedParameter type="Provider" parameterName="ResourceID" text="Provider:" default="-1" ignore="-1" enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="1" />
	</extendedParameters>
</parameters>' )

GO
---------------------------------------------------------------------------------------

--===========================================================================
-- case 2732: Update Key Indicators Summary Compare Previous Year report description

update	Report
set	Description = 'This report compares key indicators for a period in the current year with key indicators for the same period in the previous year.'
where	Name = 'Key Indicators Summary Compare Previous Year'


--===========================================================================
-- case 2733: Update Key Indicators Summary YTD Review report description

update	Report
set	Description = 'This report provides a summary list of key indicators for three periods: month-to-date, quarter-to-date, and year-to-date.'
where	Name = 'Key Indicators Summary YTD Review'


--===========================================================================
-- case 2734: Update A/R Aging Summary report description

update	Report
set	Description = 'This report provides a summary accounts receivable aging schedule for every patient and insurance with an outstanding balance.'
where	Name = 'A/R Aging Summary'


--===========================================================================
-- case 2735: Update A/R Aging Detail report description

update	Report
set	Description = 'This report provides a detailed accounts receivable aging schedule showing the outstanding balance on open claims, grouped by age range.'
where	Name = 'A/R Aging Detail'


--===========================================================================
-- case 2736: Update Patient Referrals Summary report description

update	Report
set	Description = 'This report lists the referring providers, the number of patients referred, and the total charges generated by those patients for a period of time.'
where	Name = 'Patient Referrals Summary'


--===========================================================================
-- case 2737: Update Patient Referrals Detail report description

update	Report
set	Description = 'This report lists the patients referred by referring providers and the total charges generated by those patients grouped by provider, then by service location, then by referring provider, for a period of time.'
where	Name = 'Patient Referrals Detail'


--===========================================================================
-- case 2738: Update Refunds Summary report description

update	Report
set	Description = 'This report provides a summary of all refunds, summed by payment type, issued over a period of time.'
where	Name = 'Refunds Summary'


--===========================================================================
-- case 2739: Update Refunds Detail report description

update	Report
set	Description = 'This report provides a detailed list of refunds, grouped by payment type, issued over a period of time.'
where	Name = 'Refunds Detail'



--===========================================================================
-- cases 2656, 2658 (dashboard related)

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardARAgingDisplay]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DashboardARAgingDisplay]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardARAgingVolatile]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DashboardARAgingVolatile]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardKeyIndicatorDisplay]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DashboardKeyIndicatorDisplay]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardKeyIndicatorVolatile]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DashboardKeyIndicatorVolatile]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardReceiptsDisplay]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DashboardReceiptsDisplay]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardReceiptsVolatile]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DashboardReceiptsVolatile]
GO

CREATE TABLE [dbo].[DashboardARAgingDisplay] (
	[PracticeID] [int] NOT NULL ,
	[ID] [int] NOT NULL ,
	[Amount] [int] NULL ,
	[DaysInARText] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DashboardARAgingVolatile] (
	[PracticeID] [int] NOT NULL ,
	[ID] [int] NOT NULL ,
	[Amount] [int] NULL ,
	[DaysInARText] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DashboardKeyIndicatorDisplay] (
	[PracticeID] [int] NOT NULL ,
	[ComparePeriodType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Procedures] [int] NULL ,
	[PercentOfProcedures] [decimal](10, 6) NULL ,
	[Charges] [money] NULL ,
	[PercentOfCharges] [decimal](10, 6) NULL ,
	[Adjustments] [money] NULL ,
	[PercentOfAdjustments] [decimal](10, 6) NULL ,
	[Receipts] [money] NULL ,
	[PercentOfReceipts] [decimal](10, 6) NULL ,
	[Refunds] [money] NULL ,
	[PercentOfRefunds] [decimal](10, 6) NULL ,
	[ARBalance] [money] NULL ,
	[PercentOfARBalance] [decimal](10, 6) NULL ,
	[DaysInAR] [decimal](10, 6) NULL ,
	[PercentOfDaysInAR] [decimal](10, 6) NULL ,
	[DaysRevenueOutstanding] [decimal](10, 6) NULL ,
	[PercentOfDaysRevenueOutstanding] [decimal](10, 6) NULL ,
	[DaysToSubmission] [decimal](10, 6) NULL ,
	[PercentOfDaysToSubmission] [decimal](10, 6) NULL ,
	[DaysToBill] [decimal](10, 6) NULL ,
	[PercentOfDaysToBill] [decimal](10, 6) NULL ,
	[CreatedDate] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DashboardKeyIndicatorVolatile] (
	[PracticeID] [int] NOT NULL ,
	[ComparePeriodType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Procedures] [int] NULL ,
	[PercentOfProcedures] [decimal](10, 6) NULL ,
	[Charges] [money] NULL ,
	[PercentOfCharges] [decimal](10, 6) NULL ,
	[Adjustments] [money] NULL ,
	[PercentOfAdjustments] [decimal](10, 6) NULL ,
	[Receipts] [money] NULL ,
	[PercentOfReceipts] [decimal](10, 6) NULL ,
	[Refunds] [money] NULL ,
	[PercentOfRefunds] [decimal](10, 6) NULL ,
	[ARBalance] [money] NULL ,
	[PercentOfARBalance] [decimal](10, 6) NULL ,
	[DaysInAR] [decimal](10, 6) NULL ,
	[PercentOfDaysInAR] [decimal](10, 6) NULL ,
	[DaysRevenueOutstanding] [decimal](10, 6) NULL ,
	[PercentOfDaysRevenueOutstanding] [decimal](10, 6) NULL ,
	[DaysToSubmission] [decimal](10, 6) NULL ,
	[PercentOfDaysToSubmission] [decimal](10, 6) NULL ,
	[DaysToBill] [decimal](10, 6) NULL ,
	[PercentOfDaysToBill] [decimal](10, 6) NULL ,
	[CreatedDate] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DashboardReceiptsDisplay] (
	[PracticeID] [int] NOT NULL ,
	[ID] [int] NOT NULL ,
	[Amount] [int] NULL ,
	[Period] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DashboardReceiptsVolatile] (
	[PracticeID] [int] NOT NULL ,
	[ID] [int] NOT NULL ,
	[Amount] [int] NULL ,
	[Period] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DashboardARAgingDisplay] ADD 
	CONSTRAINT [DF_DashboardARAgingDisplay_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [PK_DashboardARAgingDisplay] PRIMARY KEY  CLUSTERED 
	(
		[PracticeID],
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DashboardARAgingVolatile] ADD 
	CONSTRAINT [DF_DashboardARAgingVolatile_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [PK_DashboardARAgingVolatile] PRIMARY KEY  CLUSTERED 
	(
		[PracticeID],
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DashboardKeyIndicatorDisplay] ADD 
	CONSTRAINT [DF_DashboardKeyIndicatorDisplay_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [PK_DashboardKeyIndicatorDisplay] PRIMARY KEY  CLUSTERED 
	(
		[PracticeID],
		[ComparePeriodType]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DashboardKeyIndicatorVolatile] ADD 
	CONSTRAINT [DF_DashboardKeyIndicatorVolatile_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [PK_DashboardKeyIndicatorVolatile] PRIMARY KEY  CLUSTERED 
	(
		[PracticeID],
		[ComparePeriodType]
	)  ON [PRIMARY] 
GO

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT

