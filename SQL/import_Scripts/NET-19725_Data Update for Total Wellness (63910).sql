
--Please run the 2 commented out scripts at the top first
--(Validation query is at the bottom)


------------------------------
----change all existing start and end times to 70 years ago
--PRINT''
--PRINT'Updating all past appointments to 70 yrs ago...'
--UPDATE a SET
--a.StartDate = DATEADD(YEAR,-70,a.StartDate),
--a.EndDate = DATEADD(YEAR,-70,a.EndDate)
--FROM appointment a
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

------add vendorimportid field to appointments table
--ALTER TABLE dbo.Appointment
--ADD vendorimportid VARCHAR(10)

USE superbill_63910_dev
GO
SET XACT_ABORT ON
 
BEGIN TRANSACTION
 --rollback
 --commit
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3

USE superbill_63910_dev
SELECT * FROM dbo.AppointmentToAppointmentReason
SELECT * FROM dbo._import_3_1_UpdatedAppointments
SELECT * FROM dbo.AppointmentReason


PRINT ''
PRINT 'Inserting Appointments...'

INSERT INTO dbo.Appointment
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
    AppointmentResourceTypeID,
    AppointmentConfirmationStatusCode,
    StartDKPracticeID,
    EndDKPracticeID,
    StartTm,
    EndTm,
	vendorimportid
)

SELECT DISTINCT 
		p.PatientID,         -- PatientID - int
		@PracticeID,         -- PracticeID - int
		1,         -- ServiceLocationID - int
		CONVERT(VARCHAR,CAST(i.starttime AS DATETIME),120), -- StartDate 
		CONVERT(VARCHAR,CAST(i.endtime AS DATETIME),120), -- enddate
		'P',        -- AppointmentType - varchar(1)
		NULL,        -- Subject - varchar(64)
		i.apptnote,        -- Notes - text
		GETDATE(), -- CreatedDate - datetime
		0,         -- CreatedUserID - int
		GETDATE(), -- ModifiedDate - datetime
		0,         -- ModifiedUserID - int
		1,--CASE WHEN d.ActiveDoctor = 1 THEN 1 ELSE 2 END , -- AppointmentResourceTypeID - int
		'S' ,      -- AppointmentConfirmationStatusCode - char(1)

		dk.DKPracticeID,         -- StartDKPracticeID - int
		dk.DKPracticeID,         -- EndDKPracticeID - int
		CAST(LEFT(REPLACE(CAST(i.starttime AS TIME),':',''),4) AS SMALLINT),       -- StartTm - smallint
		CAST(LEFT(REPLACE(CAST(i.endtime AS TIME),':',''),4) AS SMALLINT),         -- EndTm - smallint
		@VendorImportID   -- VendorImportID
	


FROM dbo._import_3_1_updatedappointments i 
	INNER JOIN dbo.Patient p ON 	
		i.patientid = p.MedicalRecordNumber AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		dbo.fn_DateOnly(DK.dt) = dbo.fn_DateOnly(i.starttime)
	LEFT JOIN dbo.Appointment a ON 
		p.MedicalRecordNumber = a.PatientID AND 
		CAST(i.starttime AS DATETIME) = a.StartDate AND
        CAST(i.endtime AS DATETIME) = a.EndDate 
WHERE p.MedicalRecordNumber NOT IN(
1699,
187,
1879,
1908,
1927,
1944,
274,
322,
325,
377,
952)

PRINT CAST(@@ROWCOUNT AS varchar)+' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
          a.AppointmentResourceTypeID , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          1  -- PracticeID - int


FROM dbo._import_3_1_UpdatedAppointments i
	INNER JOIN dbo.Patient p ON	
		p.MedicalRecordNumber = i.patientid AND 
		p.PracticeID = 1
	INNER JOIN dbo.Appointment a ON
		p.PatientID = a.PatientID AND 
		a.PracticeID = 1 and
        CAST(i.starttime AS DATETIME) = CAST(a.StartDate AS DATETIME) 
		--AND CAST(i.endtime AS DATETIME) = CAST(a.EndDate AS DATETIME)
WHERE a.CreatedDate > DATEADD(mi,-9,GETDATE())AND i.starttime<>'#VALUE!'

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

ALTER TABLE dbo.AppointmentToAppointmentReason
ADD vendorimportid VARCHAR(10)

INSERT INTO dbo.AppointmentToAppointmentReason
(
    AppointmentID,
    AppointmentReasonID,
    PrimaryAppointment,
    ModifiedDate,
    PracticeID,
	vendorimportid
)
SELECT DISTINCT 
    a.AppointmentID,         -- AppointmentID - int
    MAX(ar.AppointmentReasonID),         -- AppointmentReasonID - int
    1,      -- PrimaryAppointment - bit
    GETDATE(), -- ModifiedDate - datetime
    1 ,         -- PracticeID - int
	3
	--SELECT distinct a.AppointmentID 
FROM dbo.Appointment a 
INNER JOIN dbo.Patient p ON p.PatientID = a.PatientID
INNER JOIN dbo._import_3_1_UpdatedAppointments ia ON ia.patientid = p.MedicalRecordNumber AND CONVERT(VARCHAR,CAST(ia.starttime AS DATETIME),120)=CONVERT(VARCHAR,CAST(a.StartDate AS DATETIME),120) AND a.vendorimportid=3
 JOIN dbo.AppointmentReason ar ON ar.Name=ia.appttype
WHERE ia.starttime<>'#VALUE!'
GROUP BY a.AppointmentID

----Validation
--SELECT DISTINCT ia.patientid,ia.starttime,ia.endtime,ia.apptnote FROM dbo._import_3_1_UpdatedAppointments ia
--INNER JOIN dbo.Patient p ON p.MedicalRecordNumber=ia.patientid
--WHERE p.PracticeID=1 AND ia.patientid NOT IN(
--1699,
--187,
--1879,
--1908,
--1927,
--1944,
--274,
--322,
--325,
--377,
--952)

