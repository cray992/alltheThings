USE superbill_59263_dev
GO

--ALTER TABLE dbo.PatientJournalNote ADD vendorimportid INT 

INSERT INTO dbo.PatientJournalNote
(
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    PatientID,
    UserName,
    SoftwareApplicationID,
    Hidden,
    NoteMessage,
    AccountStatus,
    NoteTypeCode,
    LastNote,
	vendorimportid
)
SELECT DISTINCT 
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    a.id,         -- PatientID - int
    '',        -- UserName - varchar(128)
    'K',        -- SoftwareApplicationID - char(1)
    0,      -- Hidden - bit
    a.notemessage,        -- NoteMessage - varchar(max)
    0,      -- AccountStatus - bit
    1,         -- NoteTypeCode - int
    0,       -- LastNote - bit
	9
     
--SELECT * 
FROM dbo._import_14_31_journalnotes a 
 INNER JOIN dbo.Patient p ON 
	p.PatientID = a.id AND 
	p.PracticeID = 31

