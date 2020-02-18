--courtney's journal notes ticket

USE superbill_65857_prod
GO
SET TRAN ISOLATION LEVEL READ UNCOMMITTED

USE superbill_65857_dev
GO

SET XACT_ABORT ON 
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
SELECT 
   GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    p.PatientID,         -- PatientID - int
    '',        -- UserName - varchar(128)
    'K',        -- SoftwareApplicationID - char(1)
    0,      -- Hidden - bit
    jn.notemessage,        -- NoteMessage - varchar(max)
    0,      -- AccountStatus - bit
    1,         -- NoteTypeCode - int
    0,       -- LastNote - bit
	9       --vendorimportid
 
 --select * 
FROM dbo._import_1_5_PatientJournalNote jn
	INNER JOIN patient p ON p.VendorID = jn.chartnumber
WHERE p.PracticeID = 5
--commit 
--rollback

	