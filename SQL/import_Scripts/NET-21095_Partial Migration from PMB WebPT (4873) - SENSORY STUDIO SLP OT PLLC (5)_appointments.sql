USE superbill_63317_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

SELECT * FROM dbo.Patient WHERE FirstName='olivia'
SELECT * FROM dbo.PatientCase WHERE PatientID=416
SELECT * FROM dbo.Appointment WHERE PatientID=416
SELECT * FROM dbo.InsurancePolicy WHERE PatientCaseID=207

------Run all of the commented out scripts beforehand------

--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToResource ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentReason ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToAppointmentReason ADD vendorimportid INT 
--ALTER TABLE dbo._import_3_2_Appointments ADD plastname VARCHAR(30),pfirstname VARCHAR(30)
--ALTER TABLE dbo._import_3_2_Appointments ADD appointmentreason VARCHAR(30)

--UPDATE a SET 
--a.plastname=d.LastName,
--a.pfirstname=d.FirstName
--FROM dbo._import_3_2_Appointmenttoresource ar 
--INNER JOIN dbo._import_3_2_Appointments a ON 
--a.appointmentid = ar.appointmentid
--INNER JOIN dbo.Doctor d ON 
--d.DoctorID=ar.resourceid
--UPDATE a SET 
--a.appointmentreason=ar.name
--FROM dbo._import_3_2_Appointments a 
--INNER JOIN dbo._import_3_2_Appointmenttoappointmentreason atar ON 
--atar.AppointmentID = a.appointmentid
--INNER JOIN dbo._import_3_2_ApointmentReason ar ON 
--ar.AppointmentReasonID=atar.appointmentreasonid


DECLARE @sourcepracticeID INT 
DECLARE @targetPracticeID INT
DECLARE @VendorImportID INT

SET @sourcepracticeID = 2
SET @targetPracticeID = 2
SET @VendorImportID = 19

PRINT 'PracticeID = ' + CAST(@targetPracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting Into Appointments...'
INSERT INTO dbo.Appointment
        ( 
		  PatientID,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
		  Recurrence,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm,
		  vendorimportid
        )

SELECT 
		  
		  p.PatientID,
          2 , -- PracticeID - int
          2,--sl.ServiceLocationID,  -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.EndDate,  -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          cs.AppointmentConfirmationStatusCode , -- AppointmentConfirmationStatusCode - char(1)
		  0,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME),':',''),4) AS SMALLINT) , --CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME),':',''),4) AS SMALLINT), --CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)  -- EndTm - smallint
		  19  
		  --SELECT * 
FROM _import_3_2_appointments i 
	INNER JOIN dbo.Patient p ON 
		i.LastName = p.LastName AND 
		i.FirstName = p.FirstName --AND 
	--	--i.MiddleName = p.MiddleName
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = 2 AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	--INNER JOIN dbo.ServiceLocation sl ON 
	--	sl.ServiceLocationID = i.servicelocationid AND 
	--	sl.PracticeID=2 
	INNER JOIN dbo.AppointmentConfirmationStatus cs ON 
		cs.AppointmentConfirmationStatusCode = i.appointmentconfirmationstatuscode
WHERE p.PracticeID = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( 
		  AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID,
		  vendorimportid
        )
SELECT DISTINCT	
		 
		  b.appointmentid , -- AppointmentID - int
          1,--CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          d.DoctorID, 
          GETDATE(),  -- ModifiedDate - datetime
          @targetPracticeID , -- PracticeID - int
		  @VendorImportID
	--SELECT * 
FROM dbo._import_3_2_Appointments i
	INNER JOIN dbo.Patient p ON 
		p.LastName=i.lastname AND 
		p.FirstName=i.firstname --AND 
		--p.DOB=i.dob
	INNER JOIN dbo.Appointment b ON 
		b.PatientID=p.PatientID AND 
		b.StartDate=i.startdate AND 
		p.PracticeID=2
	INNER JOIN dbo.Doctor d ON 
		d.LastName = i.plastname AND
        d.FirstName = i.pfirstname
		AND d.PracticeID=2
--WHERE p.CreatedDate > DATEADD(mi,-3,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--SELECT * FROM dbo.Appointment

PRINT ''
PRINT 'Inserting Appointment Reasons...'

INSERT INTO dbo.AppointmentReason
(
    PracticeID,
    Name,
    DefaultDurationMinutes,
    DefaultColorCode,
    Description,
    ModifiedDate

)
SELECT DISTINCT	
    @targetPracticeID,         -- PracticeID - int
    ip.Name,        -- Name - varchar(128)
    ar.DefaultDurationMinutes,         -- DefaultDurationMinutes - int
    ar.DefaultColorCode,      -- DefaultColorCode - int
    ar.Description,        -- Description - varchar(256)
    GETDATE() -- ModifiedDate - datetime
	--SELECT * 
FROM dbo._import_3_2_ApointmentReason ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.Name
AND ar.PracticeID = @targetPracticeID
WHERE ar.name IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT''
PRINT'Inserting into Appointment to Appointment Reasons...'

INSERT INTO dbo.AppointmentToAppointmentReason
(
    AppointmentID,
    AppointmentReasonID,
    PrimaryAppointment,
    ModifiedDate,
    PracticeID
)
SELECT DISTINCT 
    apt.AppointmentID,         -- AppointmentID - int
    ar.AppointmentReasonID,         -- AppointmentReasonID - int
    1,      -- PrimaryAppointment - bit
    GETDATE(), -- ModifiedDate - datetime
    @targetPracticeID          -- PracticeID - int
     
	 --SELECT * FROM dbo.AppointmentReason WHERE PracticeID=2
	 --SELECT *
FROM dbo._import_3_2_Appointments imp
	INNER JOIN dbo.Patient p ON 
		imp.LastName = p.LastName AND 
		imp.FirstName = p.FirstName AND 
		--imp.MiddleName = p.MiddleName AND
	p.PracticeID = @targetPracticeID
INNER JOIN dbo.Appointment apt ON
	apt.PatientID = p.PatientID AND
	apt.StartDate = imp.startdate AND 
	apt.EndDate = imp.enddate
INNER JOIN dbo.AppointmentReason ar ON
	ar.Name = imp.appointmentreason
WHERE p.PracticeID = 2 
AND apt.CreatedDate > DATEADD(mi,-3,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



