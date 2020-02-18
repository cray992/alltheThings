USE superbill_56908_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
	INSERT INTO dbo.PatientJournalNote
	        ( CreatedDate ,
	          CreatedUserID ,
	          ModifiedDate ,
	          ModifiedUserID ,
	          PatientID ,
	          UserName ,
	          SoftwareApplicationID ,
	          Hidden ,
	          NoteMessage ,
	          AccountStatus ,
	          NoteTypeCode ,
	          LastNote
	        )
	SELECT    CASE WHEN PJN.[date]  = '' THEN GETDATE() ELSE CAST(PJN.[date] AS DATETIME) + CAST(PJN.[time] AS DATETIME) END , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          PAT.PatientID , -- PatientID - int
	          CASE WHEN PJN.Initials = '' THEN 'Kareo' ELSE Initials END  , -- UserName - varchar(128)
	          'K' , -- SoftwareApplicationID - char(1)
	          0 , -- Hidden - bit
	          PJN.correspondence , -- NoteMessage - varchar(max)
	          0 , -- AccountStatus - bit
	          1 , -- NoteTypeCode - int
	          0  -- LastNote - bit
	FROM dbo._import_2_1_PatientJournalNoteNumbered PJN
	INNER JOIN dbo.Patient PAT ON
		PJN.patientaccount = PAT.VendorID AND
		PAT.PracticeID = @PracticeID
	WHERE pjn.correspondence <> ''	
	ORDER BY CAST(PJN.[date] AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- ROLLBACK
-- COMMIT

