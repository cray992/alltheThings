--USE superbill_12741_dev
USE superbill_12741_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''

--PatientJournalNote
PRINT 'Inserting records into PatientJournalNote ...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          UserName ,
          PatientID ,
          SoftwareApplicationID ,
          NoteMessage 
        )
SELECT    GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' ,
          pat.patientID , -- PatientID - int
          'K' , -- SoftwareApplicationID - char(1)
          'Balance Forward :  ' + note.nettotal  -- NoteMessage - varchar(max)
FROM dbo.[_import_3_2_Sheet2] note
INNER JOIN dbo.Patient pat ON 
	note.[30days] = pat.MedicalRecordNumber
WHERE note.patientname <> 'Total'

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT 

