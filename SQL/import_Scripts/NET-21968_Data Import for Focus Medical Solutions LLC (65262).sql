--Focus Med

USE superbill_65262_prod;
GO
--rollback
--commit
SET XACT_ABORT ON;

BEGIN TRANSACTION;

--ALTER TABLE dbo.AppointmentToResource ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentReason ADD vendorimportid INT 
--ALTER TABLE dbo.AppointmentToAppointmentReason ADD vendorimportid INT 
--ALTER TABLE dbo._import_4_2_appointments ADD plastname VARCHAR(30),pfirstname VARCHAR(30)
--ALTER TABLE dbo._import_4_2_appointments ADD appointmentreason VARCHAR(30)

-----------------------------------------------------------------------------------------------------------------

DECLARE @TargetPracticeID INT;
DECLARE @SourcePracticeID INT;
DECLARE @VendorImportID INT;

SET @TargetPracticeID = 2;
SET @SourcePracticeID = 1;
SET @VendorImportID = 9;

SET NOCOUNT ON;

PRINT 'Source PracticeID = ' + CAST(@SourcePracticeID AS VARCHAR);
PRINT 'Target PracticeID = ' + CAST(@TargetPracticeID AS VARCHAR);
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR);


PRINT '';
PRINT 'Inserting Into Appointments...';
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
    Recurrence,
    StartDKPracticeID,
    EndDKPracticeID,
    StartTm,
    EndTm,
    vendorimportid
)
SELECT DISTINCT 
	   p.PatientID,
       2,                                                                      -- PracticeID - int
       2,                                                                      --sl.ServiceLocationID,  -- ServiceLocationID - int
       CONVERT(DATETIME, CAST(i.appointmentdate AS DATETIME) + CAST(i.appointmentstarttime AS DATETIME) ,108),                                                            -- StartDate - datetime
       CONVERT(DATETIME, CAST(i.appointmentdate AS DATETIME) + CAST(i.appointmentendtime AS DATETIME) ,108),                                                              -- EndDate - datetime
       'P',                                                                    -- AppointmentType - varchar(1)
       '',                                                                     -- Subject - varchar(64)
       i.examreason,                                                                -- Notes - text
       GETDATE(),                                                              -- CreatedDate - datetime
       0,                                                                      -- CreatedUserID - int
       GETDATE(),                                                              -- ModifiedDate - datetime
       0,                                                                      -- ModifiedUserID - int
       1,                                                                      -- AppointmentResourceTypeID - int
       cs.AppointmentConfirmationStatusCode,                                   -- AppointmentConfirmationStatusCode - char(1)
       0,
       DK.DKPracticeID,                                                        -- StartDKPracticeID - int
       DK.DKPracticeID,                                                        -- EndDKPracticeID - int
       CAST(REPLACE(i.appointmentstarttime,':','') AS SMALLINT), --CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME), ':', ''), 4) AS SMALLINT), --CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
       CAST(REPLACE(i.appointmentendtime,':','') AS SMALLINT), --CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME), ':', ''), 4) AS SMALLINT),   --CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)  -- EndTm - smallint
       @VendorImportID
--SELECT * 
FROM dbo._import_4_2_appointments i
    INNER JOIN dbo.Patient p
        ON i.LastName = p.LastName
           AND i.FirstName = p.FirstName --AND 
    --	--i.MiddleName = p.MiddleName
    INNER JOIN dbo.DateKeyToPractice DK
        ON DK.PracticeID = 2
           AND DK.Dt = CAST(CAST(i.appointmentdate AS DATE) AS DATETIME)
    INNER JOIN dbo.AppointmentConfirmationStatus cs
        ON cs.Name = i.appointmentstatus
WHERE p.PracticeID = @TargetPracticeID;
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';


PRINT '';
PRINT 'Inserting Into Appointment to Resource...';
INSERT INTO dbo.AppointmentToResource
(
    AppointmentID,
    AppointmentResourceTypeID,
    ResourceID,
    ModifiedDate,
    PracticeID,
    vendorimportid
)
SELECT DISTINCT
    b.AppointmentID,   -- AppointmentID - int
    1,                 --CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
    CASE WHEN i.assignedphysician = 'Bruce Gollub, M.D.' THEN 2 ELSE '' END ,
    GETDATE(),         -- ModifiedDate - datetime
    @TargetPracticeID, -- PracticeID - int
    @VendorImportID
--SELECT * 
FROM dbo._import_4_2_appointments i
    INNER JOIN dbo.Patient p
        ON p.LastName = i.LastName
           AND p.FirstName = i.FirstName --AND 
    --p.DOB=i.dob
    INNER JOIN dbo.Appointment b
        ON b.PatientID = p.PatientID
           AND b.StartDate = CONVERT(DATETIME, CAST(i.appointmentdate AS DATETIME) + CAST(i.appointmentstarttime AS DATETIME) ,108)
		   --AND b.StartTm = i.appointmentstarttime
           AND p.PracticeID = @TargetPracticeID
WHERE b.CreatedDate > DATEADD(mi, -3, GETDATE());
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';

PRINT '';
PRINT 'Inserting Appointment Reasons...';

INSERT INTO dbo.AppointmentReason
(
    PracticeID,
    Name,
    DefaultDurationMinutes,
    DefaultColorCode,
    Description,
    ModifiedDate,
    dbo.VendorImportid
)
SELECT DISTINCT
    @TargetPracticeID,         -- PracticeID - int
    ip.appointmenttype,                   -- Name - varchar(128)
    ar.DefaultDurationMinutes, -- DefaultDurationMinutes - int
    ar.DefaultColorCode,       -- DefaultColorCode - int
    ar.Description,            -- Description - varchar(256)
    GETDATE(),                 -- ModifiedDate - datetime
    @VendorImportID
--SELECT * 
FROM dbo._import_4_2_appointments ip
    LEFT JOIN dbo.AppointmentReason ar
        ON ar.Name = ip.appointmenttype
           AND ar.PracticeID = @TargetPracticeID
WHERE ar.Name IS NULL;
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';


PRINT '';
PRINT 'Inserting into Appointment to Appointment Reasons...';

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
    apt.AppointmentID,      -- AppointmentID - int
    ar.AppointmentReasonID, -- AppointmentReasonID - int
    1,                      -- PrimaryAppointment - bit
    GETDATE(),              -- ModifiedDate - datetime
    @TargetPracticeID,      -- PracticeID - int
    @VendorImportID
--SELECT *
FROM dbo._import_4_2_appointments imp
    INNER JOIN dbo.Patient p
        ON imp.LastName = p.LastName
           AND imp.FirstName = p.FirstName
           AND
        --imp.MiddleName = p.MiddleName AND
        p.PracticeID = 2
    INNER JOIN dbo.Appointment apt
        ON apt.PatientID = p.PatientID
           AND apt.StartDate = CONVERT(DATETIME, CAST(imp.appointmentdate AS DATETIME) + CAST(imp.appointmentstarttime AS DATETIME) ,108)
		   AND apt.PracticeID = 2
    INNER JOIN dbo.AppointmentReason ar
        ON ar.Name = imp.appointmenttype
		AND ar.PracticeID = 2
WHERE p.PracticeID = 2 AND imp.appointmenttype<>''
      AND apt.CreatedDate > DATEADD(mi, -3, GETDATE());
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';
--rollback
--commit

--------For use only in dev----
--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_4873_restore.dbo.patient rp 
--INNER JOIN superbill_4873_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID

--USE superbill_63317_dev
--GO
--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_63317_restore.dbo.patient rp 
--INNER JOIN superbill_63317_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID
