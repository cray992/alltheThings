USE superbill_64796_prod;
GO
--rollback
--commit

--ALTER TABLE dbo.PatientJournalNote ADD vendorimportid INT 

SET XACT_ABORT ON;
BEGIN TRAN;
SET NOCOUNT ON;

DECLARE @practiceid INT;
DECLARE @vendorimportid INT;

SET @vendorimportid = 2;
SET @practiceid = 1;
--DELETE FROM dbo.PatientJournalNote WHERE vendorimportid=2
PRINT '';
PRINT 'Inserting into PatientJournalNote...';
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
SELECT n.createddate, -- CreatedDate - datetime
       0,             -- CreatedUserID - int
       GETDATE(),     -- ModifiedDate - datetime
       0,             -- ModifiedUserID - int
       p.PatientID,   -- PatientID - int
       '',            -- UserName - varchar(128)
       'K',           -- SoftwareApplicationID - char(1)
       '',            -- Hidden - bit
       n.notemessage, -- NoteMessage - varchar(max)
       0,          -- AccountStatus - bit
       1,          -- NoteTypeCode - int
       NULL,          -- LastNote - bit
       @vendorimportid

--SELECT * 
FROM dbo.Patient p
    INNER JOIN dbo._import_2_1_PatientJournalNote n
        ON n.chartnumber = p.VendorID 
WHERE p.PracticeID = @practiceid ORDER BY patientid 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted ';

UPDATE a SET 
a.Hidden =1
--SELECT * 
FROM dbo.PatientJournalNote a
WHERE a.CreatedDate<'2016-01-01 00:00:00.000'