-- DB 0837
-- Practice : Full Solution Services
-- FogBugz Case ID : 14142

-- Tables Populated.
-- =================

-- AppointmentReason
-- Appointment
-- AppointmentToAppointmentReason

USE superbill_0801_prod -- %%%%%%%%%%%%%%%%%   CHANGE DATABASE   %%%%%%%%%%%%%%%%%

SET NOCOUNT ON

IF OBJECT_ID('tempdb..#Vars') IS NOT NULL
	DROP TABLE [#Vars]

CREATE TABLE #Vars(VarName varchar(50), VarValue varchar(200))

-- %%%%%%%%%%%  SET VARIABLES    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INSERT INTO #Vars (VarName, VarValue) VALUES ('PracticeID',			'6')
INSERT INTO #Vars (VarName, VarValue) VALUES ('x_Appt', 'ZZZZ_AdamsWood')
INSERT INTO #Vars (VarName, VarValue) VALUES ('TestDataType',		0)
INSERT INTO #Vars (VarName, VarValue) VALUES ('VendorName',			'Medical Recovery Services')
INSERT INTO #Vars (VarName, VarValue) VALUES ('PracticeName',		'Refer to Practice ID')

-- ==================================================================
IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_Appt')
	DROP SYNONYM [dbo].[x_Appt]
GO
-- ==================================================================
DECLARE @x_Appt varchar(50)
SELECT @x_Appt = VarValue FROM #Vars WHERE VarName = 'x_Appt'
EXEC ('Create Synonym x_Appt For ' + @x_Appt)
--===================================================================
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Appointment') and name='VendorID')
	ALTER TABLE Appointment ADD VendorID int
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Appointment') and name='VendorImportID')
	ALTER TABLE Appointment ADD VendorImportID int

IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('AppointmentReason') and name='VendorID')
	ALTER TABLE AppointmentReason ADD VendorID int
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('AppointmentReason') and name='VendorImportID')
	ALTER TABLE AppointmentReason ADD VendorImportID int

IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Patient') and name='VendorID')
	ALTER TABLE Patient ADD VendorID int
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Patient') and name='VendorImportID')
	ALTER TABLE Patient ADD VendorImportID int
GO
----==================================================================

DECLARE @VendorImportID int
DECLARE @PracticeID int
DECLARE @Rows Int
DECLARE @Message Varchar(75)

BEGIN TRANSACTION
BEGIN

INSERT INTO VendorImport (VendorName, VendorFormat, DateCreated, Notes)
VALUES ('Chuck Bagby', 'csv', GETDATE(), 'None')

SET @VendorImportID = SCOPE_IDENTITY()

SELECT @PracticeID = VarValue FROM #Vars WHERE VarName = 'PracticeID'

----************************* Appointment Reason table
-- Import into AppointmentReason
INSERT INTO AppointmentReason 
(
	PracticeID,					-- Not Null
	[Name],						-- Not Null
	DefaultDurationMinutes, 
--	DefaultColorCode,			-- Leave Null
--	Description, 
--	ModifiedDate,				-- Not Null, Use Default
--	[TIMESTAMP],				-- Leave Null
--	VendorID, 
	VendorImportID
)
SELECT DISTINCT
	@PracticeID,
	CONVERT(VARCHAR(128), Reason),
	30,
--	ApptID,
	@VendorImportID
FROM x_Appt

Select @Rows = @@RowCount
PRINT 'Rows Added in AppointmentReason Table ' + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


INSERT INTO Appointment
(
	PatientID, 
	PracticeID, 
	ServiceLocationID, 
	StartDate, 
	EndDate, 
	AppointmentType, 
	Subject, 
	Notes, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID, 
--	RecordTimeStamp, 
	AppointmentResourceTypeID, 
	AppointmentConfirmationStatusCode, 
	AllDay, 
	InsurancePolicyAuthorizationID, 
	PatientCaseID, 
	Recurrence, 
	RecurrenceStartDate, 
	RangeEndDate, 
	RangeType, 
	StartDKPracticeID, 
	EndDKPracticeID, 
	StartTm, 
	EndTm,
	VendorID,
	VendorImportID
)
SELECT DISTINCT
dbo.Patient.PatientID,		--PatientID, 
@PracticeID,		--PracticeID, 
NULL,				--ServiceLocationID, 
x_Appt.StartTm,
x_Appt.EndTm,
'P',			--AppointmentType, 
NULL,			--Subject, 
NULL,			--Notes, 
GetDate(),		--CreatedDate, 
0,				--CreatedUserID, 
GetDate(),		--ModifiedDate, 
0,				--ModifiedUserID, 
--RecordTimeStamp, Allow default
1,			--AppointmentResourceTypeID, 
'C',		--AppointmentConfirmationStatusCode, 
0,			--AllDay, 
NULL,		--InsurancePolicyAuthorizationID, 
NULL,		--PatientCaseID, 
NULL,		--Recurrence, 
NULL,		--RecurrenceStartDate, 
NULL,		--RangeEndDate, 
NULL,		--RangeType, 
NULL,		--StartDKPracticeID, 
NULL,		--EndDKPracticeID, 
NULL,		--StartTm, 
NULL,		--EndTm
NULL,		--VendorID,
@VendorImportID	 --VendorImportID
FROM x_Appt 
INNER JOIN Patient 
ON x_Appt.LastName = Patient.LastName AND LEFT(x_Appt.FirstName, 3) = LEFT(Patient.FirstName, 3) LEFT OUTER JOIN Appointment 
ON Patient.PatientID = Appointment.PatientID 
AND x_Appt.StartTm = Appointment.StartDate 
AND x_Appt.EndTm = Appointment.EndDate
WHERE (Appointment.PatientID IS NULL)

Select @Rows = @@RowCount
Select @Message = 'Rows Added in Appointment Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [x_Appt]
Select @Message = 'Rows in original x_Appt Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT 
x_Appt.StartTm, 
x_Appt.EndTm, 
x_Appt.PatientName, 
x_Appt.Reason, 
x_Appt.Dr, 
x_Appt.Len, 
x_Appt.WorkPhone, 
x_Appt.LastName, 
x_Appt.FirstName
FROM x_Appt 
LEFT OUTER JOIN Patient 
ON x_Appt.LastName = Patient.LastName 
AND LEFT(x_Appt.FirstName, 3) = LEFT(Patient.FirstName, 3)
WHERE (Patient.LastName IS NULL)

--*************************** AppointmentToAppointmentReason
INSERT INTO dbo.AppointmentToAppointmentReason
(
	AppointmentID, 
	AppointmentReasonID, 
	--PrimaryAppointment, 
	--ModifiedDate, 
	--[TIMESTAMP], 
	PracticeID
)
SELECT Appointment.AppointmentID, 
MIN(AppointmentReason.AppointmentReasonID) AS AppointmentReasonID, 
@PracticeID AS PracticeID
FROM Appointment 
INNER JOIN AppointmentReason 
ON AppointmentReason.PracticeID = Appointment.PracticeID 
INNER JOIN Patient 
ON Appointment.PatientID = Patient.PatientID 
INNER JOIN x_Appt 
ON Patient.FirstName = x_Appt.FirstName 
AND Patient.LastName = x_Appt.LastName 
AND Appointment.StartDate = x_Appt.StartTm 
AND Appointment.EndDate = x_Appt.EndTm 
AND AppointmentReason.[Name] = x_Appt.Reason
WHERE dbo.Appointment.VendorImportID = @VendorImportID
GROUP BY Appointment.AppointmentID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in AppointmentToAppointmentReason Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

END
-- ROLLBACK
-- COMMIT TRANSACTION