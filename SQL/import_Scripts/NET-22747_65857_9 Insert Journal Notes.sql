USE superbill_65857_prod
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
SELECT 
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    p.PatientID,         -- PatientID - int
    pj.username,        -- UserName - varchar(128)
    'K',        -- SoftwareApplicationID - char(1)
    0,      -- Hidden - bit
    pj.notemessage,        -- NoteMessage - varchar(max)
    0,      -- AccountStatus - bit
    1,         -- NoteTypeCode - int
    0,       -- LastNote - bit
	11
     
--SELECT * 
FROM _import_28_4_PatientJournalNote pj
	INNER JOIN dbo.Patient p ON 
		p.VendorID = pj.chartnumber
WHERE p.PracticeID = 4

--SELECT * FROM dbo.Patient WHERE PracticeID = 9
--SELECT * FROM dbo.PatientJournalNote
--SELECT * FROM _import_24_9_PatientJournalNote pj 