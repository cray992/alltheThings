USE superbill_6804_dev;
GO

BEGIN TRANSACTION;
--rollback
--commit
DECLARE @PracticeID INT;
DECLARE @VendorImportID INT;

SET @PracticeID = 1;
SET @VendorImportID = 4;

SET NOCOUNT ON;

--ALTER TABLE appointment 
--ADD vendorimportid varchar(10)

--ALTER TABLE dbo.AppointmentToResource 
--ADD vendorimportid varchar(10)

--ALTER TABLE appointmentreason 
--ADD vendorimportid varchar(10)


----For DB13 use only!
--UPDATE dp 
--SET dp.DOB = rp.DOB
--FROM superbill_6804_restore.dbo.patient rp 
--INNER JOIN superbill_6804_dev.dbo.Patient dp
--	ON rp.PatientID = dp.PatientID


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


SELECT 
    p.PatientID,                                                                                     -- PatientID - int
    1,                                                                                     -- PracticeID - int
    1,                                                                                               -- ServiceLocationID - int
    CONVERT(VARCHAR, CAST(i.startdate AS DATETIME), 120) AS startdatetime, -- StartDate - datetime  
    CONVERT(VARCHAR, CAST(i.enddate AS DATETIME), 120) AS enddatetime,
    'P',                                                                                             -- AppointmentType - varchar(1)
    null,						                                                                     -- Subject - varchar(64)
    i.note,                                                                                          -- Notes - text
    GETDATE(),                                                                                       -- CreatedDate - datetime
    0,                                                                                               -- CreatedUserID - int
    GETDATE(),                                                                                       -- ModifiedDate - datetime
    0,                                                                                               -- ModifiedUserID - int
	1,                                                                                               -- AppointmentResourceTypeID - int
    i.status,                                                                                        -- AppointmentConfirmationStatusCode - char(1)

    dk.DKPracticeID,                                                                                 -- StartDKPracticeID - int
    dk.DKPracticeID,                                                                                 -- EndDKPracticeID - int
    CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME),':',''),4) AS SMALLINT),                                                                       -- StartTm - smallint
    CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME),':',''),4) AS SMALLINT),                                                                       -- EndTm - smallint
    @VendorImportID                                                                                 -- VendorImportID

FROM dbo._import_4_1_PatientAppointments i
	INNER JOIN dbo._import_4_1_PatientDemographics pd 
		ON pd.chartnumber = i.chartnumber
    INNER JOIN dbo.Patient p
        ON pd.lastname = p.LastName
			AND pd.firstname = p.FirstName
			AND dbo.fn_DateOnly(pd.dateofbirth) = dbo.fn_DateOnly(p.DOB)
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
           AND DK.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
    LEFT JOIN dbo.Appointment a
        ON p.PatientID = a.PatientID
           AND CAST(i.StartDate AS DATETIME) = a.StartDate
           AND CAST(i.EndDate AS DATETIME) = a.EndDate
           AND a.PracticeID = @PracticeID
WHERE (
          i.chartnumber <> ''
          OR i.chartnumber IS NOT NULL
      )
      AND a.AppointmentID IS NULL;
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';
--rollback
--SELECT * FROM dbo.Appointment --WHERE vendorimportid=5

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
    a.AppointmentID, -- AppointmentID - int
    1,             -- AppointmentResourceTypeID - int
    1,             -- ResourceID - int
    GETDATE(),       -- ModifiedDate - datetime
    @PracticeID,      -- PracticeID - int
	@vendorimportid
FROM dbo._import_4_1_PatientAppointments i
	INNER JOIN dbo._import_4_1_PatientDemographics pd 
		ON pd.chartnumber = i.chartnumber
    INNER JOIN dbo.Patient p
        ON pd.lastname = p.LastName
			AND pd.firstname = p.FirstName
			AND dbo.fn_DateOnly(pd.dateofbirth) = dbo.fn_DateOnly(p.DOB)
            AND p.PracticeID = @PracticeID
    INNER JOIN dbo.Appointment a
        ON p.PatientID = a.PatientID
           AND CAST(i.StartDate AS DATETIME) = a.StartDate
           AND CAST(i.EndDate AS DATETIME) = a.EndDate
           AND a.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi, -1, GETDATE());
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
    vendorimportid
)
SELECT DISTINCT
    @PracticeID,                                  -- PracticeID - int
    ip.reasons,                                    -- Name - varchar(128)
    DATEDIFF(MINUTE, ip.startdate, ip.enddate), -- DefaultDurationMinutes - int
    NULL,                                         -- DefaultColorCode - int
    ip.reasons,                                    -- Description - varchar(256)
    GETDATE(),                                    -- ModifiedDate - datetime
    @VendorImportID

FROM dbo._import_4_1_PatientAppointments ip
    LEFT JOIN dbo.AppointmentReason ar
        ON ar.Name = ip.reasons
WHERE ar.Name IS NULL AND reasons<>'';

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted';