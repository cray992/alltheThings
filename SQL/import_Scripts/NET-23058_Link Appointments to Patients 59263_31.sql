----Appointments Import Template

----update servicelocationnames in Appointments and Other Appointments

----Update DOBs from backup----
--BEGIN TRANSACTION
--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_59263_restore.dbo.patient rp 
--INNER JOIN superbill_59263_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID

USE superbill_59263_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--DELETE FROM dbo.AppointmentToAppointmentReason WHERE vendorimportid = 20
--DELETE FROM dbo.AppointmentReason WHERE vendorimportid = 20
--DELETE FROM appointmenttoresource WHERE vendorimportid = 20
--DELETE FROM dbo.Appointment WHERE vendorimportid = 20

--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo.Appointmenttoresource ADD vendorimportid INT 
--ALTER TABLE dbo.Appointmentreason ADD vendorimportid INT 
--ALTER TABLE dbo.Appointmenttoappointmentreason ADD vendorimportid INT 

DECLARE @sourcepracticeID INT 
DECLARE @targetPracticeID INT
DECLARE @VendorImportID INT

SET @sourcepracticeID = 1
SET @targetPracticeID = 31
SET @VendorImportID = 19

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
		  221,  -- ServiceLocationID - int
          i.startdate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime , -- StartDate - datetime
          i.enddate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime,  -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.reasons , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int

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

		  --SELECT * FROM dbo.ServiceLocation WHERE PracticeID = 31
		  --SELECT * FROM dbo.Doctor WHERE PracticeID = 31
		  --SELECT distinct i.*
FROM _import_18_31_PatientAppointments i 
	--INNER JOIN dbo._import_44_61_PatientDemographics d ON 
	--	d.chartnumber = i.chartnumber
	INNER JOIN dbo.Patient p ON 
		i.lastname = p.LastName AND 
		i.firstname = p.FirstName AND 	
		CAST(i.dob AS DATE) = CAST(p.DOB AS DATE) AND 
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
--rollback

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
		--SELECT * FROM dbo.PracticeResource WHERE PracticeID = 31
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
		  1, -- AppointmentResourceTypeID - int
			CASE 
				WHEN i.doctorlastname = 'Raden' THEN 1670
				WHEN i.doctorlastname = 'Bauer' THEN 1671
				WHEN i.doctorlastname = 'GREEN' THEN 1672
			ELSE '' END ,
          GETDATE(),  -- ModifiedDate - datetime
          @targetPracticeID,  -- PracticeID - int
		  @VendorImportID
	--SELECT i.*
FROM _import_18_31_PatientAppointments i 
	--INNER JOIN dbo._import_44_61_PatientDemographics d ON 
	--	d.chartnumber = i.chartnumber
	INNER JOIN dbo.Patient p ON 
		i.lastname = p.LastName AND 
		i.firstname = p.FirstName AND 
		CAST(i.dob AS DATE) = CAST(p.DOB AS DATE) AND 
		p.PracticeID = 31 		
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		a.StartDate = i.startdate 
		--a.EndDate = i.enddate AND 
		--a.PracticeID = 31
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--rollback
--commit
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
    '',        -- Description - varchar(256)
    GETDATE(), -- ModifiedDate - datetime
	@VendorImportID
	--SELECT *
FROM _import_18_31_PatientAppointments ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.reasons
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
FROM _import_18_31_PatientAppointments iapt
	--INNER JOIN dbo._import_38_61_PatientDemographics pd ON 
	--	pd.chartnumber = iapt.chartnumber
	INNER JOIN dbo.AppointmentReason ar ON 
		ar.Name = iapt.reasons
	INNER JOIN dbo.Patient p ON 
		iapt.lastname = p.LastName AND 
		iapt.firstname = p.FirstName AND 
		CAST(iapt.dob AS DATE) = CAST(p.DOB AS DATE) AND 
		p.PracticeID = @targetPracticeID 
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		CAST(a.StartDate AS DATETIME) = CAST(iapt.startdate AS DATETIME) AND 
		CAST(a.EndDate AS DATETIME) = CAST(iapt.enddate AS DATETIME) AND 
		a.PracticeID = @targetPracticeID    --CONVERT(VARCHAR,CAST(iapt.appointmentdate AS DATETIME),120)+ CAST(iapt.appointmentstarttime AS DATETIME)
WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
GROUP BY a.AppointmentID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
--	--SELECT * 
--FROM _import_37_61_OtherAppointments i 
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
--FROM _import_37_61_OtherAppointments i
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
--FROM _import_37_61_OtherAppointments ip
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
--FROM _import_37_61_OtherAppointments iapt
--	--INNER JOIN dbo._import_38_61_PatientDemographics pd ON 
--	--	pd.chartnumber = iapt.chartnumber
--	INNER JOIN dbo.AppointmentReason ar ON 
--		ar.Name = iapt.subject
--	--INNER JOIN dbo.Patient p ON 
--	--	p.LastName = pd.lastname AND 
--		--p.FirstName = pd.firstname 
--	INNER JOIN dbo.Appointment a ON 
--		--a.PatientID = p.PatientID AND 
--		a.StartDate = iapt.startdate    --CONVERT(VARCHAR,CAST(iapt.appointmentdate AS DATETIME),120)+ CAST(iapt.appointmentstarttime AS DATETIME)
--WHERE a.CreatedDate > DATEADD(mi,-3,GETDATE())
--GROUP BY a.AppointmentID

--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

----commit
----rollback
