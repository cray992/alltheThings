USE superbill_55599_dev

BEGIN TRANSACTION
rollback
commit
DECLARE @PracticeID INT
DECLARE @OldVendorImportID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 4
SET @OldVendorImportID = 1

SET NOCOUNT ON	

----seperate first and last names
--ALTER TABLE dbo._import_4_1_1026existingpatients
--ADD lastname VARCHAR(20),firstname VARCHAR(20)
--UPDATE dbo._import_4_1_1026existingpatients SET	
--lastname=SUBSTRING(iep.patient,1,CHARINDEX(',',iep.patient)-1)  ,
--firstname=SUBSTRING(iep.patient,CHARINDEX(',',iep.patient)+1,8000)
--FROM dbo._import_4_1_1026existingpatients iep

----seperate first and last names
--ALTER TABLE dbo._import_4_1_1026newpatients
--ADD lastname VARCHAR(20),firstname VARCHAR(20)
--UPDATE dbo._import_4_1_1026newpatients SET	
--lastname=SUBSTRING(inp.patient,1,CHARINDEX(',',inp.patient)-1)  ,
--firstname=SUBSTRING(inp.patient,CHARINDEX(',',inp.patient)+1,8000)
--FROM dbo._import_4_1_1026newpatients inp

--ALTER TABLE dbo.Appointment
--ADD vendorimportid VARCHAR(10)


---- Add Starttime to Import table --existing
--ALTER TABLE dbo._import_4_1_1026existingpatients
--ADD startdate VARCHAR(max),enddate VARCHAR(max)
--UPDATE ie SET 
--ie.startdate = CONVERT(VARCHAR,CAST(ie.aptdate AS DATETIME)+ CAST(ie.ampmtbegin AS DATETIME),121),
--ie.enddate = CONVERT(VARCHAR,CAST(ie.aptdate AS DATETIME)+ CAST(ie.ampmtend AS DATETIME),121)
--FROM _import_4_1_1026existingpatients ie



---- Add Starttime to Import table --new
--ALTER TABLE dbo._import_4_1_1026newpatients
--ADD startdate VARCHAR(max),enddate VARCHAR(max),
--btime2 varchar(max),etime2 varchar(max)
--UPDATE inp SET
--btime2 = CAST(inp.aptbegin AS DATETIME2),
--etime2 = CAST(inp.aptend AS DATETIME2)
--FROM dbo._import_4_1_1026newpatients inp

--UPDATE inp SET 
--btime2 = CAST(inp.startdate
--FROM dbo._import_4_1_1026newpatients inp


--SELECT * FROM dbo._import_4_1_1026existingpatients
--SELECT * FROM dbo._import_4_1_1026newpatients

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
		CONVERT(VARCHAR,CAST(i.aptdate AS DATETIME),120)+ CAST(i.ampmtbegin AS DATETIME) as startdatetime, -- StartDate - datetime  
		CONVERT(VARCHAR,CAST(i.aptdate AS DATETIME),120)+ CAST(i.ampmtend AS DATETIME) AS enddatetime,
		'P',        -- AppointmentType - varchar(1)
		i.patient,        -- Subject - varchar(64)
		i.notes,        -- Notes - text
		GETDATE(), -- CreatedDate - datetime
		0,         -- CreatedUserID - int
		GETDATE(), -- ModifiedDate - datetime
		0,         -- ModifiedUserID - int
		CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
		'S',        -- AppointmentConfirmationStatusCode - char(1)

		dk.DKPracticeID,         -- StartDKPracticeID - int
		dk.DKPracticeID,         -- EndDKPracticeID - int
		REPLACE(i.ampmtbegin,':',''),       -- StartTm - smallint
		REPLACE(i.ampmtend,':',''),         -- EndTm - smallint
		@VendorImportID   -- VendorImportID
FROM dbo._import_4_1_1026existingpatients i 
	INNER JOIN dbo.Patient p ON 	
		i.chartnumber = p.MedicalRecordNumber AND 
		p.PracticeID = @PracticeID 
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2 
							WHERE pc2.PracticeID = @PracticeID AND pc2.PatientID = p.PatientID AND pc2.Name <> 'Balance Forward')
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.aptdate AS DATE) AS DATETIME)
	LEFT JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND 
		CAST(i.startdate AS DATETIME) = a.StartDate AND
        CAST(i.EndDate AS DATETIME) = a.EndDate AND 
		a.PracticeID = @PracticeID
WHERE (i.chartnumber <> '' OR i.chartnumber IS NOT NULL) AND a.AppointmentID IS NULL
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
          CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          CASE WHEN i.resource = 'Nurse' THEN (SELECT PracticeResourceID FROM dbo.PracticeResource WHERE ResourceName = 'Nurse' AND PracticeID = @PracticeID)
		  ELSE (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Irene' AND LastName = 'Edwards' AND PracticeID = @PracticeID AND [External] = 0) 
		  END  , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_4_1_1026existingpatients i
	INNER JOIN dbo.Patient p ON	
		p.MedicalRecordNumber = i.chartnumber AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.Appointment a ON
		p.PatientID = a.PatientID AND 
		a.PracticeID = @PracticeID and
        CAST(i.StartDate AS DATETIME) = a.StartDate AND 
		CAST(i.EndDate AS DATETIME) = a.EndDate
--WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointments - Other 1 of 2...'
INSERT INTO dbo.Appointment
        ( 
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
          EndTm 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.EndDate , -- EndDate - datetime
          'O' , -- AppointmentType - varchar(1)
          i.Patient , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME),':',''),4) AS SMALLINT) , --CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME),':',''),4) AS SMALLINT) --CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_4_1_1026existingpatients i
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
WHERE i.chartnumber = '' OR i.chartnumber IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointments - Other 2 of 2...'
INSERT INTO dbo.Appointment
        ( 
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
          EndTm 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.EndDate , -- EndDate - datetime
          'O' , -- AppointmentType - varchar(1)
          i.Patient , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME),':',''),4) AS SMALLINT) , --CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME),':',''),4) AS SMALLINT) --CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_4_1_1026existingpatients i
	LEFT JOIN dbo.Patient P ON 
		p.MedicalRecordNumber = i.chartnumber AND 
		p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2 
							WHERE pc2.PracticeID = @PracticeID AND pc2.PatientID = p.PatientID AND pc2.Name <> 'Balance Forward')
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
WHERE (i.chartnumber <> '' AND i.chartnumber IS NOT NULL) AND p.PatientID IS NULL
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
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
          CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          CASE WHEN i.resource = 'Nurse' THEN (SELECT PracticeResourceID FROM dbo.PracticeResource WHERE ResourceName = 'Nurse' AND PracticeID = @PracticeID)
		  ELSE (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Irene' AND LastName = 'Edwards' AND PracticeID = @PracticeID AND [External] = 0) 
		  END  , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_4_1_1026existingpatients i
	INNER JOIN dbo.Appointment a ON
		a.PracticeID = @PracticeID AND
        CAST(i.StartDate AS DATETIME) = a.StartDate AND 
		CAST(i.EndDate AS DATETIME) = a.EndDate AND
        i.Patient = a.[Subject]
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE()) AND a.AppointmentType = 'O' AND a.CreatedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT
