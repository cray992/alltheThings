USE superbill_68630_prod
GO
--rollback
--commit
SET XACT_ABORT ON

--BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @VendorImportID INT

SET @VendorImportID = 9

--ALTER TABLE dbo.patientjournalnote  ADD VendorImportID INT 

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
    '',      -- Hidden - bit
    ijn.notemessage,        -- NoteMessage - varchar(max)
    NULL,      -- AccountStatus - bit
    1,         -- NoteTypeCode - int
    NULL ,      -- LastNote - bit
    @VendorImportID -- VendorImportID
	--SELECT p.vendorid,* 
FROM dbo._import_3_2_PatientJournalNote ijn
INNER JOIN dbo.Patient p ON p.VendorID = ijn.chartnumber



