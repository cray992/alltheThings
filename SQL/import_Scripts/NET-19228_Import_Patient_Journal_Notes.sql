USE superbill_64299_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--ROLLBACK

SET NOCOUNT ON

DECLARE @VendorImportID INT

SET @VendorImportID = 1

--ALTER TABLE dbo.PatientJournalNote
--ADD vendorimportid VARCHAR(10)

PRINT ''
PRINT 'Inserting into Patient Journal Notes...'

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
    p.PatientID,         -- PatientID - int
    ijn.username,        -- UserName - varchar(128)
    'K',        -- SoftwareApplicationID - char(1)
    0,      -- Hidden - bit
    ijn.notemessage,        -- NoteMessage - varchar(max)
    1,      -- AccountStatus - bit
    1,         -- NoteTypeCode - int
    1,       -- LastNote - bit
    @VendorImportID -- VendorImportID

FROM dbo._import_1_1_PatientJournalNote ijn
INNER JOIN dbo.Patient p ON p.MedicalRecordNumber = ijn.chartnumber AND p.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientJournalNote pjn ON pjn.PatientID = ijn.chartnumber

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--SELECT * FROM dbo.PatientJournalNote
--SELECT * FROM dbo._import_1_1_PatientJournalNote
--SELECT * FROM dbo._import_1_1_PatientDemographics