USE superbill_12509_dev
GO

BEGIN TRANSACTION
--rollback
--commit

DECLARE @targetpracticeid INT 
DECLARE @sourcePracticeID INT
DECLARE @VendorImportID INT
 
SET @targetpracticeid = 2
SET @sourcePracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON	

------------------------------------

----Appointments Export for Migration
--USE superbill_12509_prod
--GO 

--SELECT --*
--a.AppointmentID,sl.Name AS slname,p.PatientID,p.LastName,p.FirstName,p.DOB,a.StartDate,a.EndDate,
--DATEDIFF(MINUTE,a.StartDate,a.EndDate)AS apptduration,a.AppointmentType,ar.Name AS appointmentreason1,a.Notes,
--d.LastName AS doclastname, d.FirstName AS docfirstname, ar.DefaultColorCode, a.AppointmentConfirmationStatusCode
--FROM appointment a 
--INNER JOIN dbo.AppointmentToAppointmentReason atar ON 
--	atar.AppointmentID = a.AppointmentID
--INNER JOIN dbo.AppointmentReason ar ON 
--	ar.AppointmentReasonID = atar.AppointmentReasonID
--INNER JOIN dbo.AppointmentToResource atr ON 
--	atr.AppointmentID = a.AppointmentID
--INNER JOIN dbo.Patient p ON 
--	p.PatientID = a.PatientID
--INNER JOIN dbo.ServiceLocation sl ON 
--	sl.ServiceLocationID = a.ServiceLocationID
--INNER JOIN dbo.Doctor d ON 
--	d.DoctorID = atr.ResourceID
--WHERE a.StartDate>'2018-01-01 09:00:00.000'


------------------------------------
--Update DOB between DB FOR Dev Use

--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_12509_dev_v2.dbo.patient rp 
--INNER JOIN superbill_12509_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID

------------------------------------

PRINT ''
PRINT 'Inserting Into Appointments...'
INSERT INTO dbo.Appointment
        ( PatientID,
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
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm,
		  vendorimportid
        )
SELECT DISTINCT
		  p.PatientID,
          @targetPracticeID , -- PracticeID - int
          sl.ServiceLocationID , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.EndDate , -- EndDate - datetime
          i.appointmenttype, -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.Notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          i.AppointmentConfirmationStatusCode , -- AppointmentConfirmationStatusCode - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME),':',''),4) AS SMALLINT) , --CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME),':',''),4) AS SMALLINT), --CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)  -- EndTm - smallint
		  @VendorImportID
		  
		  --SELECT * 
FROM dbo._import_10_2_AppointmentData1 i 
	INNER JOIN dbo.Patient p ON 
		p.LastName = i.lastname AND 
		p.FirstName = i.firstname AND
		CAST(dbo.fn_DateOnly(p.DOB)AS DATE) = CAST(i.dob AS DATE) AND 
		--p.AddressLine1 = i.address1 AND 
        p.PracticeID = 2
		--p.patientid = i.patientid
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = 2 AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	INNER JOIN dbo.ServiceLocation sl ON 
		sl.Name = i.slname AND 
		sl.PracticeID = 2
	--rollback

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--SELECT * FROM dbo._import_10_2_AppointmentData1

--SELECT * FROM dbo.Doctor WHERE PracticeID=2
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
          1,--CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          628,--CASE WHEN i.resource = 'Nurse' THEN (SELECT PracticeResourceID FROM dbo.PracticeResource WHERE ResourceName = 'Nurse' AND PracticeID = @PracticeID)
		  --ELSE (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Irene' AND LastName = 'Edwards' AND PracticeID = @PracticeID AND [External] = 0) 
		  --END  , -- ResourceID - int
          GETDATE(),  -- ModifiedDate - datetime
          @targetpracticeid  -- PracticeID - int
	--SELECT * 
FROM dbo._import_10_2_AppointmentData1 i
	INNER JOIN dbo.Appointment a ON 
		a.StartDate = i.startdate AND 
		a.EndDate = i.enddate AND 
		a.PracticeID = @targetpracticeid
	--INNER JOIN dbo.Doctor d ON 
	--	d.
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



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
    @targetpracticeid,         -- PracticeID - int
    ip.appointmentreason1,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
    ip.defaultcolorcode ,      -- DefaultColorCode - int
    ip.notes,        -- Description - varchar(256)
    GETDATE() -- ModifiedDate - datetime
	--SELECT * 
FROM dbo._import_10_2_AppointmentData1 ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.appointmentreason1

WHERE ar.name IS NULL AND ip.appointmentreason1<>''

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--UPDATE a SET 
--a.apptduration=
--DATEDIFF(MINUTE,a.startdate,a.enddate)
--FROM dbo._import_10_2_AppointmentData1 a 

--BEGIN TRAN 
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
    2          -- PracticeID - int
     
	 --SELECT *
FROM dbo._import_10_2_AppointmentData1 imp
	INNER JOIN dbo.Patient p ON 
		--p.PatientID = imp.patientid 
		imp.LastName = p.LastName AND 
		imp.FirstName = p.FirstName AND 
		CAST(dbo.fn_DateOnly(p.DOB)AS DATE) = CAST(imp.dob AS DATE) AND 
		--imp.address1 = p.AddressLine1 AND 
		--imp.MiddleName = p.MiddleName AND
	p.PracticeID = 2
INNER JOIN dbo.Appointment apt ON
	apt.PatientID = p.PatientID AND
	apt.StartDate = imp.startdate AND 
	apt.EndDate = imp.enddate AND 
	apt.practiceid=2
INNER JOIN dbo.AppointmentReason ar ON
	ar.Name = imp.appointmentreason1 AND 
	ar.PracticeID =2
and apt.CreatedDate > DATEADD(mi,-3,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--UPDATE a SET
--a.DefaultColorCode = '-16711936'
--FROM dbo.AppointmentReason a
--WHERE a.AppointmentReasonID =105

--DELETE 
----SELECT * 
--FROM dbo.AppointmentReason WHERE AppointmentReasonID IN(
--'106','107','108')AND practiceId=2

--SELECT * FROM dbo.AppointmentReason

--commit
--rollback



