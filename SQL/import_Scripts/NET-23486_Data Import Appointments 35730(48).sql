USE superbill_35730_prod
GO

--BEGIN TRANSACTION
--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_59263_restore.dbo.patient rp 
--INNER JOIN superbill_59263_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID

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
SET @targetPracticeID = 48
SET @VendorImportID = 9

PRINT 'PracticeID = ' + CAST(@targetPracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
(
    PracticeID,
    Prefix,
    FirstName,
    MiddleName,
    LastName,
    Suffix,
    DOB,
    EmailAddress,
    Notes,
    ActiveDoctor,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    VendorID,
    VendorImportID,
    FaxNumber,
    FaxNumberExt,
    OrigReferringPhysicianID,
    [External],
    NPI,
    ProviderTypeID,
    ProviderPerformanceReportActive
)
SELECT DISTINCT 
    @targetPracticeID,         -- PracticeID - int
    '',        -- Prefix - varchar(16)
    ia.doctorfirstname,        -- FirstName - varchar(64)
    '',        -- MiddleName - varchar(64)
    ia.doctorlastname,        -- LastName - varchar(64)
	'',
    GETDATE(), -- DOB - datetime
    '',        -- EmailAddress - varchar(256)
    '',        -- Notes - text
    1,      -- ActiveDoctor - bit
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    '',        -- VendorID - varchar(50)
    @VendorImportID,         -- VendorImportID - int
    '',        -- FaxNumber - varchar(10)
    '',        -- FaxNumberExt - varchar(10)
    0,         -- OrigReferringPhysicianID - int
    NULL,      -- External - bit
    '',        -- NPI - varchar(10)
    0,         -- ProviderTypeID - int
    NULL      -- ProviderPerformanceReportActive - bit

    --SELECT  ia.*
FROM _import_2_48_patientappointments3 ia 
	LEFT JOIN dbo.Doctor d ON 
		d.LastName = ia.doctorlastname AND 
		d.FirstName = ia.doctorfirstname AND 
        d.PracticeID = @targetPracticeID
WHERE d.LastName IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--SELECT doctorlastname,* FROM dbo._import_2_48_patientappointments3 
--SELECT DISTINCT DoctorID,LastName,FirstName FROM dbo.Doctor WHERE PracticeID =48

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
		--SELECT * FROM dbo.ServiceLocation WHERE PracticeID =8
SELECT DISTINCT
		  p.PatientID,
          @targetPracticeID , -- PracticeID - int
		  
		  --CASE 
		  --WHEN i.servicelocationname = 'Southwest ENT Consultant' THEN 407
		  --WHEN i.servicelocationname = 'Sierra Medical Center Hospital' THEN 427
		  --WHEN i.servicelocationname = 'Providence Memorial Hospital' THEN 426
		  --WHEN i.servicelocationname = 'Las Palmas Hospital' THEN 425
		  --WHEN i.servicelocationname = 'El Paso Day Surgery' THEN 442
		  --WHEN i.servicelocationname = 'Del Sol Medical Center Hospital' THEN 423
		  --WHEN i.servicelocationname = 'El Paso Childrens Hospital' THEN 422
		  --ELSE '287' END ,
		  370,--i.servicelocationid,  -- ServiceLocationID - int
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
			WHEN 'check-out' THEN 'O'
			WHEN 'tentative' THEN 'T'
			ELSE'' END , -- AppointmentConfirmationStatusCode - char(1)
		  0,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.startdate AS TIME),':',''),4) AS SMALLINT), -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.enddate AS TIME),':',''),4) AS SMALLINT),  -- EndTm - smallint
		  @VendorImportID
		  --SELECT * FROM dbo.AppointmentConfirmationStatus
		  --select * FROM dbo.ServiceLocation
		  --SELECT distinct i.*
FROM dbo._import_2_48_patientappointments3 i 
	INNER JOIN dbo._import_2_48_PatientDemographics d ON 
		d.id = i.id
	INNER JOIN dbo.Patient p ON 
		d.lastname = p.LastName AND 
		d.firstname = p.FirstName AND 
		--CAST(d.dateofbirth AS DATE) = CAST(p.DOB AS DATE) AND 
		--d.chartnumber = p.VendorID AND 
		p.PracticeID = @targetPracticeID 
	--INNER JOIN dbo.ServiceLocation sl ON 
	--	sl.Name = i.name AND 
	--	sl.PracticeID = @targetPracticeID
--SELECT * FROM dbo.ServiceLocation WHERE practiceid=61
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @targetPracticeID AND
		DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
WHERE p.PracticeID = @targetPracticeID
		--AND p.lastname = 'ordaz'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--UPDATE sl SET 
--sl.RevenueCode = '0521', 
--sl.TimeZoneID = 15

--FROM dbo.ServiceLocation sl WHERE billingname = 'Cardiovascular Medical Specialists LLC'--PracticeID IN (8,1)




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
				WHEN i.doctorlastname = 'Mendoza' THEN 4290
				WHEN i.doctorlastname = 'Castillo' THEN 4288
				WHEN i.doctorlastname = 'Wadiwala' THEN 910
				WHEN i.doctorlastname = 'Lopez' THEN 4292
				WHEN i.doctorlastname = 'Escobar' THEN 4293
				WHEN i.doctorlastname = 'Rosewater' THEN 4291
				WHEN i.doctorlastname = 'Barrios' THEN 4287
				WHEN i.doctorlastname = 'Niaki' THEN 4289
			ELSE '' END ,
		  --910,
          GETDATE(),  -- ModifiedDate - datetime
          @targetPracticeID,  -- PracticeID - int
		  @VendorImportID

	--SELECT *
FROM dbo._import_2_48_patientappointments3 i 
	INNER JOIN dbo._import_2_48_PatientDemographics d ON 
		d.id = i.id
	INNER JOIN dbo.Patient p ON 
		d.lastname = p.LastName AND 
		d.firstname = p.FirstName AND 
		--CAST(d.dateofbirth AS DATE) = CAST(p.DOB AS DATE) AND 
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
    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    ip.reasons,        -- Description - varchar(256)
    GETDATE(), -- ModifiedDate - datetime
	@VendorImportID
	--SELECT *
FROM dbo._import_2_48_patientappointments3 ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.reasons
--AND ar.PracticeID = 8
--WHERE ar.name IS NULL 

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


FROM dbo._import_2_48_patientappointments3 iapt
	INNER JOIN dbo._import_2_48_PatientDemographics pd ON 
		pd.id = iapt.id
	INNER JOIN dbo.AppointmentReason ar ON 
		ar.Name = iapt.reasons
	INNER JOIN dbo.Patient p ON 
		--pd.chartnumber = p.medicalrecordnumber
		pd.lastname = p.LastName AND 
        pd.firstname = p.FirstName
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		CAST(a.StartDate AS DATETIME) = CAST(iapt.startdate AS DATETIME) AND 
		CAST(a.EndDate AS DATETIME) = CAST(iapt.enddate AS DATETIME) AND 
		a.PracticeID = @targetPracticeID    --CONVERT(VARCHAR,CAST(iapt.appointmentdate AS DATETIME),120)+ CAST(iapt.appointmentstarttime AS DATETIME)
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
GROUP BY a.AppointmentID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--rollback

------"Other Appts"

--PRINT ''
--PRINT 'Inserting Into Other Appointments...'
--INSERT INTO dbo.Appointment
--        ( --PatientID,
--          PracticeID ,
--          ServiceLocationID ,
--          StartDate ,
--          EndDate ,
--          AppointmentType ,
--          Subject ,
--          Notes ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          AppointmentResourceTypeID ,
--          AppointmentConfirmationStatusCode ,
--		  Recurrence,
--          StartDKPracticeID ,
--          EndDKPracticeID ,
--          StartTm ,
--          EndTm,
--		  vendorimportid
--        )


--SELECT DISTINCT
--		  --p.PatientID,
--          @targetPracticeID , -- PracticeID - int
--		  CASE 
--		  WHEN i.servicelocationname = 'Southwest ENT Consultants' THEN 407
--		  WHEN i.servicelocationname = 'Op-Sierra Medical Center' THEN 427
--		  WHEN i.servicelocationname = 'Op-Providence Hospital' THEN 426
--		  WHEN i.servicelocationname = 'Op-Las Palmas Medical Center' THEN 425
--		  WHEN i.servicelocationname = 'Op-El Paso Day Surgery' THEN 442
--		  WHEN i.servicelocationname = 'Op-Del Sol Medical Center' THEN 423
--		  WHEN i.servicelocationname = 'El Paso Childrens Hospital' THEN 422
--		  ELSE 407 END 
--		  ,  -- ServiceLocationID - int
--          i.startdate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime , -- StartDate - datetime
--          i.enddate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime,  -- EndDate - datetime
--          'O' , -- AppointmentType - varchar(1)
--          '' , -- Subject - varchar(64)
--          i.note , -- Notes - text
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          1 , -- AppointmentResourceTypeID - int

--          CASE i.status
--			WHEN 'cancelled' THEN 'X'
--			WHEN 'check-In' THEN 'I'
--			WHEN 'confirmed' THEN 'C'
--			WHEN 'no-show' THEN 'N'
--			WHEN 'rescheduled' THEN 'R'
--			WHEN 'scheduled' THEN 'S'
--			ELSE'' END , -- AppointmentConfirmationStatusCode - char(1)
--		  0,
--          dk.DKPracticeID , -- StartDKPracticeID - int
--          dk.DKPracticeID , -- EndDKPracticeID - int
--          CAST(LEFT(REPLACE(CAST(i.startdate AS TIME),':',''),4) AS SMALLINT), -- StartTm - smallint
--          CAST(LEFT(REPLACE(CAST(i.enddate AS TIME),':',''),4) AS SMALLINT),  -- EndTm - smallint
--		  @VendorImportID
--	--SELECT  i.*
--	--SELECT * 
--FROM _import_43_61_OtherAppointments i 
--	INNER JOIN dbo.DateKeyToPractice DK ON
--		DK.PracticeID = @targetPracticeID AND
--		DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Inserting Into Other Appointment to Resource...'
--INSERT INTO dbo.AppointmentToResource
--        ( AppointmentID ,
--          AppointmentResourceTypeID ,
--          ResourceID ,
--          ModifiedDate ,
--          PracticeID,
--		  vendorimportid
--        )
--SELECT DISTINCT	
--		  a.AppointmentID , -- AppointmentID - int
--		  1, -- AppointmentResourceTypeID - int
--		  d.DoctorID,
--          GETDATE(),  -- ModifiedDate - datetime
--          @targetPracticeID,  -- PracticeID - int
--		  @VendorImportID
--	--SELECT *
--FROM _import_43_61_OtherAppointments i
--	INNER JOIN dbo.Appointment a ON 
--		a.StartDate = i.startdate AND 
--		a.EndDate = i.enddate AND 
--		a.PracticeID = @targetPracticeID
--    INNER JOIN dbo.Doctor d
--        ON d.LastName = i.doctorlastname
--           --on d.FirstName = i.doctorfirstname
--           AND d.PracticeID = @targetPracticeID
--WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Other Appointment Reasons...'

--INSERT INTO dbo.AppointmentReason
--(
--    PracticeID,
--    Name,
--    DefaultDurationMinutes,
--    DefaultColorCode,
--    Description,
--    ModifiedDate,
--	vendorimportid

--)
--SELECT DISTINCT	
--    @targetPracticeID,         -- PracticeID - int
--    ip.subject,        -- Name - varchar(128)
--    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
--    null,      -- DefaultColorCode - int
--    '',        -- Description - varchar(256)
--    GETDATE(), -- ModifiedDate - datetime
--	@VendorImportID
--	--SELECT *
--FROM _import_43_61_OtherAppointments ip
--LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.subject
--AND ar.PracticeID = @targetPracticeID
--WHERE ar.name IS NULL 

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT''
--PRINT'Inserting into Other Appointment to Appointment Reasons...'

--INSERT INTO dbo.AppointmentToAppointmentReason
--(
--    AppointmentID,
--    AppointmentReasonID,
--    PrimaryAppointment,
--    ModifiedDate,
--    PracticeID,
--	vendorimportid
--)

--SELECT DISTINCT a.AppointmentID, 
--MIN(ar.AppointmentReasonID) AS AppointmentReasonID, 
--1 ,
--GETDATE() ,
--@targetPracticeID,
--@VendorImportID
----select * 
--FROM _import_43_61_OtherAppointments iapt
--	--INNER JOIN dbo._import_44_61_PatientDemographics pd ON 
--	--	pd.chartnumber = iapt.chartnumber
--	INNER JOIN dbo.AppointmentReason ar ON 
--		ar.Name = iapt.subject
--	--INNER JOIN dbo.Patient p ON 
--	--	p.LastName = pd.lastname AND 
--		--p.FirstName = pd.firstname 
--	INNER JOIN dbo.Appointment a ON 
--		--a.PatientID = p.PatientID AND 
--		a.StartDate = iapt.startdate    --CONVERT(VARCHAR,CAST(iapt.appointmentdate AS DATETIME),120)+ CAST(iapt.appointmentstarttime AS DATETIME)
--WHERE a.CreatedDate > DATEADD(mi,-2,GETDATE())
--GROUP BY a.AppointmentID

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

----commit
----rollback
