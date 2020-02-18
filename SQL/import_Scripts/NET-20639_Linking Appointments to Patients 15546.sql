USE superbill_15546_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--SELECT * FROM appointment

----add vendorimportid to appointments table
--ALTER TABLE dbo.Appointment ADD vendorimportid INT 

DECLARE @sourcepracticeID INT 
DECLARE @targetPracticeID INT
DECLARE @VendorImportID INT

SET @sourcepracticeID = 1
SET @targetPracticeID = 1
SET @VendorImportID = 2

PRINT 'PracticeID = ' + CAST(@targetPracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
PRINT ''
PRINT 'Inserting Into Appointments...'
INSERT INTO dbo.Appointment
        ( PatientID,
          PracticeID ,
          ServiceLocationID ,
          startdate ,
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
SELECT DISTINCT
		  p.PatientID,
          @targetpracticeid , -- PracticeID - int
          CASE WHEN sl.ServiceLocationID<>'' THEN sl.ServiceLocationID
		  ELSE ''
		  END ,  -- ServiceLocationID - int
          i.start_date , -- start_date - datetime
          i.End_Date,  -- End_Date - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.Note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          i.Status , -- AppointmentConfirmationStatusCode - char(1)
		  0,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.Start_Date AS TIME),':',''),4) AS SMALLINT) , --CAST(REPLACE(RIGHT(i.start_date,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.End_Date AS TIME),':',''),4) AS SMALLINT), --CAST(REPLACE(RIGHT(i.End_Date,5), ':','') AS SMALLINT)  -- EndTm - smallint
		  @VendorImportID
		  --SELECT * 
FROM dbo.[Appointments$] i 
	INNER JOIN dbo.Patient p ON 
		i.Chart_Number = p.PatientID
		--i.LastName = p.LastName AND 
		--i.FirstName = p.FirstName --AND 
		--i.MiddleName = p.MiddleName
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = 1 AND
		DK.dt = CAST(CAST(i.Start_Date AS DATE) AS DATETIME)
	INNER JOIN dbo.ServiceLocation sl ON 
		sl.Name = i.servicelocationname AND 
		sl.PracticeID=1 
	--	SELECT * FROM dbo.ServiceLocation
	--INNER JOIN dbo.AppointmentConfirmationStatus cs ON 
	--	cs.Name = i.Status
WHERE p.PracticeID = @targetpracticeid


	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
		--SELECT * FROM doctor
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
          1,--CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          d.DoctorID, -- ResourceID - int
          GETDATE(),  -- ModifiedDate - datetime
          1  -- PracticeID - int
	--SELECT * 
FROM dbo.[Appointments$] i
	INNER JOIN dbo.Appointment a ON 
		a.startdate = i.Start_Date AND 
		a.EndDate = i.End_Date AND 
		a.PatientID = i.Chart_Number
		--a.PracticeID = 1
	INNER JOIN dbo.Doctor d ON 
		d.LastName = i.practiceresource 
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE()) AND doctorid<>1
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
    ip.reasons,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.start_date,ip.End_Date),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    ip.note,        -- Description - varchar(256)
    GETDATE() -- ModifiedDate - datetime
	--SELECT * 
FROM dbo.[Appointments$] ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.Reasons
AND ar.PracticeID = @targetpracticeid
WHERE ar.name IS NULL AND ip.Reasons IS NOT NULL 

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
    @targetPracticeID   -- PracticeID - int
     

	 --SELECT *
FROM dbo.[Appointments$] imp
	INNER JOIN dbo.Patient p ON 
		imp.Chart_Number = p.PatientID AND 
		--imp.LastName = p.LastName AND 
		--imp.FirstName = p.FirstName AND 
		--imp.MiddleName = p.MiddleName AND
	p.PracticeID = @targetPracticeID
INNER JOIN dbo.Appointment apt ON
	apt.PatientID = p.PatientID AND
	apt.startdate = imp.start_date and 
	apt.EndDate = imp.End_Date
INNER JOIN dbo.AppointmentReason ar ON
	ar.Name = imp.reasons
WHERE p.PracticeID = @targetPracticeID AND ar.PracticeID=@targetPracticeID
AND apt.CreatedDate > DATEADD(mi,-3,GETDATE())

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

