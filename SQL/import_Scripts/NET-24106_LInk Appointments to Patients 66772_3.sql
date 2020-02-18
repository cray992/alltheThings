USE superbill_66772_prod
GO

SET TRAN ISOLATION LEVEL READ UNCOMMITTED
SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--DELETE FROM dbo.AppointmentToAppointmentReason WHERE vendorimportid = 9
--DELETE FROM dbo.AppointmentReason WHERE vendorimportid = 9
--DELETE FROM appointmenttoresource WHERE vendorimportid = 9
--DELETE FROM dbo.Appointment WHERE vendorimportid = 9

--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo.Appointmenttoresource ADD vendorimportid INT 
--ALTER TABLE dbo.Appointmentreason ADD vendorimportid INT 
--ALTER TABLE dbo.Appointmenttoappointmentreason ADD vendorimportid INT 

DECLARE @sourcepracticeID INT 
DECLARE @targetPracticeID INT
DECLARE @VendorImportID INT

SET @sourcepracticeID = 1
SET @targetPracticeID = 3
SET @VendorImportID = 9

PRINT 'PracticeID = ' + CAST(@targetPracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

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
		  Recurrence,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm,
		  vendorimportid
        )
		--SELECT * FROM dbo.Appointment WHERE PracticeID =8
		--SELECT * FROM dbo.ServiceLocation WHERE PracticeID =3
		--SELECT * FROM dbo.Patient WHERE  VendorID = '140144'
SELECT DISTINCT
		  p.PatientID,
          @targetPracticeID , -- PracticeID - int
		  --CASE 
		  --WHEN i.servicelocationname = 'ALO' THEN 202
		  --WHEN i.servicelocationname = 'AEO' THEN 203
		  --ELSE '' END ,
		  3, --i.servicelocationid,  -- ServiceLocationID - int
          i.startdate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime , -- StartDate - datetime
          i.enddate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime,  -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
		  --i.status,
          CASE i.status
			WHEN 'cancelled' THEN 'X'
			WHEN 'check-In' THEN 'I'
			WHEN 'confirmed' THEN 'C'
			WHEN 'no-show' THEN 'N'
			WHEN 'rescheduled' THEN 'R'
			WHEN 'scheduled' THEN 'S'
			WHEN 'seen' THEN 'E'
			ELSE'' END , -- AppointmentConfirmationStatusCode - char(1)
		  0,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.startdate AS TIME),':',''),4) AS SMALLINT), -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.enddate AS TIME),':',''),4) AS SMALLINT),  -- EndTm - smallint
		  @VendorImportID
		  --rollback

		  --SELECT * FROM dbo.AppointmentConfirmationStatus
		  --SELECT *
FROM dbo._import_11_3_Sheet1 i 
	--INNER JOIN dbo._import_44_61_PatientDemographics d ON 
	--	d.chartnumber = i.chartnumber
	INNER JOIN dbo.Patient p ON 
		i.last = p.LastName AND 
		i.first = p.FirstName AND 
		--CAST(i.dateofbirth AS DATE) = CAST(p.DOB AS DATE) AND 
		--d.chartnumber = p.VendorID AND 
		p.PracticeID = @targetPracticeID 
	--INNER JOIN dbo.ServiceLocation sl ON 
	--	sl.Name = i.servicelocationname AND 
	--	sl.PracticeID = @targetPracticeID
--SELECT * FROM dbo.ServiceLocation WHERE practiceid=61
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @targetPracticeID AND
		DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
WHERE p.PracticeID = @targetPracticeID
		--AND p.lastname = 'ordaz'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--SELECT * FROM dbo.Patient WHERE LastName = 'Djendi'

--SELECT * FROM dbo.ServiceLocation WHERE PracticeID = 22
--UPDATE sl SET 
--sl.RevenueCode = '0521', 
--sl.TimeZoneID = 15

--FROM dbo.ServiceLocation sl WHERE billingname = 'Cardiovascular Medical Specialists LLC'--PracticeID IN (8,1)

--SELECT * FROM servicelocation WHERE PracticeID = 22`
--SELECT * FROM dbo.Doctor WHERE practiceid = 3

PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID,
		  vendorimportid
        )
		--SELECT * FROM dbo.PracticeResource WHERE PracticeID = 61
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
		  1, -- AppointmentResourceTypeID - int
			CASE 
				WHEN i.doctorlastname = 'Kessinger' THEN 7
				WHEN i.doctorlastname = 'Jones' THEN 6
			ELSE '' END ,
		  --2261,
          GETDATE(),  -- ModifiedDate - datetime
          @targetPracticeID,  -- PracticeID - int
		  @VendorImportID
		
	--SELECT *
FROM _import_11_3_Sheet1 i 
	--INNER JOIN dbo._import_44_61_PatientDemographics d ON 
	--	d.chartnumber = i.chartnumber
	INNER JOIN dbo.Patient p ON 
		i.last = p.LastName AND 
		i.first = p.FirstName AND 
		--CAST(i.dateofbirth AS DATE) = CAST(p.DOB AS DATE) AND 
		p.PracticeID = @targetPracticeID 		
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		a.StartDate = i.startdate AND 
		a.EndDate = i.enddate AND 
		a.PracticeID = @targetPracticeID
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE()) 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--SELECT * FROM dbo.Appointment WHERE PracticeID = 8
--SELECT * FROM dbo.Patient WHERE patientid=13055
--SELECT * FROM dbo.AppointmentReason WHERE PracticeID = 22
PRINT ''
PRINT 'Inserting Appointment Reasons...'


INSERT INTO dbo.AppointmentReason
(
    PracticeID,
    Name,
    DefaultDurationMinutes,
    DefaultColorCode,
    Description,
    ModifiedDate,
	vendorimportid

)
SELECT DISTINCT	
    @targetPracticeID,         -- PracticeID - int
    ip.reasons,        -- Name - varchar(128)
    cast(DATEDIFF(MINUTE,ip.startdate,ip.enddate)AS int ),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    ip.reasons,        -- Description - varchar(256)
    GETDATE(), -- ModifiedDate - datetime
	@VendorImportID
	--SELECT *
FROM dbo._import_11_3_Sheet1 ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.reasons
AND ar.PracticeID = @targetPracticeID
WHERE ar.name IS NULL 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--SELECT * FROM dbo.AppointmentToResource WHERE PracticeID = 8

PRINT''
PRINT'Inserting into Appointment to Appointment Reasons...'

INSERT INTO dbo.AppointmentToAppointmentReason
(
    AppointmentID,
    AppointmentReasonID,
    PrimaryAppointment,
    ModifiedDate,
    PracticeID,
	vendorimportid
)

SELECT DISTINCT a.AppointmentID, 
MIN(ar.AppointmentReasonID) AS AppointmentReasonID, 
1 ,
GETDATE() ,
@targetPracticeID,
@VendorImportID
--select * 
FROM _import_11_3_Sheet1 iapt
	--INNER JOIN dbo._import_44_61_PatientDemographics pd ON 
	--	pd.chartnumber = iapt.chartnumber
	INNER JOIN dbo.AppointmentReason ar ON 
		ar.Name = iapt.reasons
	INNER JOIN dbo.Patient p ON 
		--pd.chartnumber = p.medicalrecordnumber
		p.LastName = iapt.last AND 
        p.FirstName = iapt.first 
		--CAST(iapt.dateofbirth AS DATE) = CAST(p.DOB AS DATE)
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		CAST(a.StartDate AS DATETIME) = CAST(iapt.startdate AS DATETIME) AND 
		CAST(a.EndDate AS DATETIME) = CAST(iapt.enddate AS DATETIME) AND 
		a.PracticeID = @targetPracticeID    --CONVERT(VARCHAR,CAST(iapt.appointmentdate AS DATETIME),120)+ CAST(iapt.appointmentstarttime AS DATETIME)
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
GROUP BY a.AppointmentID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--rollback