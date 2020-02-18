USE superbill_63463_dev;
GO

BEGIN TRANSACTION;
--rollback
--commit
DECLARE @PracticeID INT;
DECLARE @OldVendorImportID INT;
DECLARE @VendorImportID INT;

SET @PracticeID = 1;
SET @VendorImportID = 10;
SET @OldVendorImportID = 1;

SET NOCOUNT ON;

--ALTER TABLE dbo.Appointment
--ADD vendorimportid VARCHAR(10)


PRINT '';
PRINT 'Inserting into Appointments...';

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
    p.PatientID,                                                           -- PatientID - int
    @PracticeID,                                                           -- PracticeID - int
    1,                                                                     -- ServiceLocationID - int
    CONVERT(VARCHAR, CAST(i.startdate AS DATETIME), 120) AS startdatetime, -- StartDate - datetime  
    CONVERT(VARCHAR, CAST(i.enddate AS DATETIME), 120) AS enddatetime,
    'P',                                                                   -- AppointmentType - varchar(1)
    NULL,                                                                  --       -- Subject - varchar(64)
    i.note,                                                                -- Notes - text
    GETDATE(),                                                             -- CreatedDate - datetime
    0,                                                                     -- CreatedUserID - int
    GETDATE(),                                                             -- ModifiedDate - datetime
    0,                                                                     -- ModifiedUserID - int
    1,                                                                     -- AppointmentResourceTypeID - int
    'S',                                                                   -- AppointmentConfirmationStatusCode - char(1)
    DK.DKPracticeID,                                                       -- StartDKPracticeID - int
    DK.DKPracticeID,                                                       -- EndDKPracticeID - int
    LEFT(REPLACE(CAST(i.startdate AS TIME), ':', ''), 4),                  -- StartTm - smallint
    LEFT(REPLACE(CAST(i.enddate AS TIME), ':', ''), 4),                    -- EndTm - smallint
    @VendorImportID                                                        -- VendorImportID

FROM dbo._import_10_1_newsheet i
    INNER JOIN dbo.Patient p
        ON (i.lastname = p.LastName)
           AND (i.firstname = p.FirstName)
           AND p.PracticeID = @PracticeID
    LEFT JOIN dbo.PatientCase pc
        ON pc.PatientCaseID =
        (
            SELECT MAX(pc2.PatientCaseID)
            FROM dbo.PatientCase pc2
            WHERE pc2.PracticeID = @PracticeID
                  AND pc2.PatientID = p.PatientID
                  AND pc2.Name <> 'Balance Forward'
        )
    INNER JOIN dbo.DateKeyToPractice DK
        ON DK.PracticeID = @PracticeID
           AND (DK.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME))
    LEFT JOIN dbo.Appointment a
        ON p.PatientID = a.PatientID
           AND (CAST(i.startdate AS DATETIME) = a.StartDate)
           AND (CAST(i.enddate AS DATETIME) = a.EndDate)
           AND a.PracticeID = @PracticeID
WHERE a.AppointmentID IS NULL;
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';


PRINT '';
PRINT 'Inserting Into Appointment to Resource...';
INSERT INTO dbo.AppointmentToResource
(
    AppointmentID,
    AppointmentResourceTypeID,
    ResourceID,
    ModifiedDate,
    PracticeID
)
SELECT DISTINCT
    a.AppointmentID, -- AppointmentID - int
    1,               -- AppointmentResourceTypeID - int
    1,               -- ResourceID - int
    GETDATE(),       -- ModifiedDate - datetime
    @PracticeID      -- PracticeID - int
FROM dbo._import_10_1_newsheet i
    INNER JOIN dbo.Patient p
        ON (
               i.lastname = p.LastName
               AND i.firstname = p.FirstName
           )
           AND p.PracticeID = @PracticeID
    INNER JOIN dbo.Appointment a
        ON p.PatientID = a.PatientID
           AND a.PracticeID = @PracticeID
           AND (CAST(i.startdate AS DATETIME) = a.StartDate)
           AND (CAST(i.enddate AS DATETIME) = a.EndDate);

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
    ModifiedDate
--AppointmentReasonGuid
)
SELECT DISTINCT
    @PracticeID,                                -- PracticeID - int
    ip.reason,                                  -- Name - varchar(128)
    DATEDIFF(MINUTE, ip.startdate, ip.enddate), -- DefaultDurationMinutes - int
    NULL,                                       -- DefaultColorCode - int
    ip.reason,                                  -- Description - varchar(256)
    GETDATE()                                   -- ModifiedDate - datetime
--NULL       -- AppointmentReasonGuid - uniqueidentifier
FROM dbo._import_10_1_newsheet ip
    LEFT JOIN dbo.AppointmentReason ar
        ON ar.Name = ip.reason
WHERE ar.Name IS NULL;

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';
