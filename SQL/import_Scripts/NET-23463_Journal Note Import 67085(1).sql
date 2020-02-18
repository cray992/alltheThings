USE superbill_67085_prod
GO

BEGIN TRAN 
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
    pjn.createddate, -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    p.PatientID,         -- PatientID - int
    '',        -- UserName - varchar(128)
    'K',        -- SoftwareApplicationID - char(1)
    0,      -- Hidden - bit
    pjn.notemessage,        -- NoteMessage - varchar(max)
    0,      -- AccountStatus - bit
    1,         -- NoteTypeCode - int
    0,       -- LastNote - bit
	9
    
--SELECT * 
FROM dbo._import_3_1_PatientJournalNote pjn
	INNER JOIN dbo._import_4_1_PatientDemographics pd ON 
		pd.chartnumber = pjn.chartnumber
	INNER JOIN dbo.Patient p ON 
		p.LastName = pd.lastname AND 
		p.FirstName = pd.firstname

--rollback
--commit

--SELECT * FROM dbo.PatientJournalNote
