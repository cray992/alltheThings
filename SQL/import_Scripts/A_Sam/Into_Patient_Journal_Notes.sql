USE superbill__dev
GO
rollback
SET XACT_ABORT ON

--BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @VendorImportID INT

SET @VendorImportID = 1

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
	VendorImportID
)
SELECT DISTINCT	
    ijn.createddate, -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    ijn.chartnumber,         -- PatientID - int
    ijn.username,        -- UserName - varchar(128)
    'K',        -- SoftwareApplicationID - char(1)
    '',      -- Hidden - bit
    ijn.notemessage,        -- NoteMessage - varchar(max)
    NULL,      -- AccountStatus - bit
    0,         -- NoteTypeCode - int
    NULL,       -- LastNote - bit
    @VendorImportID -- VendorImportID

FROM dbo._import_1_1_PatientJournalNote ijn
INNER JOIN dbo.Patient p ON p.PatientID = ijn.chartnumber
LEFT JOIN dbo.PatientJournalNote pjn ON pjn.PatientID = ijn.chartnumber
WHERE pjn.NoteMessage IS null



--ALTER TABLE dbo.PatientJournalNote
--ADD vendorimportid VARCHAR(10)


SELECT * FROM dbo.PatientJournalNote
SELECT * FROM dbo._import_1_1_PatientJournalNote
SELECT * FROM dbo._import_1_1_PatientDemographics

SELECT * FROM patient p INNER JOIN dbo.PatientJournalNote pj ON pj.PatientID = p.PatientID
SELECT * FROM patient p INNER JOIN dbo._import_1_1_PatientJournalNote pj ON pj.chartnumber = p.PatientID

