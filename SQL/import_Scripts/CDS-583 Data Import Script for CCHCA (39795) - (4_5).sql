USE superbill_39795_dev
--USE superbill_39795_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

PRINT ''
PRINT 'Inserting Into Patient Journal Note Practice 5...'
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
	SELECT    CASE WHEN PJN.CreatedDate IS NULL THEN GETDATE() ELSE PJN.CreatedDate END , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          PAT.PatientID , -- PatientID - int
	          CASE WHEN PJN.UserName IS NULL THEN 'Kareo' ELSE UserName END  , -- UserName - varchar(128)
	          'K' , -- SoftwareApplicationID - char(1)
	          0 , -- Hidden - bit
	          PJN.NoteMessage , -- NoteMessage - varchar(max)
	          0 , -- AccountStatus - bit
	          1 , -- NoteTypeCode - int
	          0  -- LastNote - bit
	FROM dbo.[_import_13_5_PatientJournalNote] PJN
	INNER JOIN dbo.Patient PAT ON
		PJN.ChartNumber = PAT.VendorID AND
		PAT.PracticeID = 5
	WHERE pjn.notemessage <> ''		
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Journal Note Practice 4...'
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
	SELECT    CASE WHEN PJN.CreatedDate IS NULL THEN GETDATE() ELSE PJN.CreatedDate END , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          PAT.PatientID , -- PatientID - int
	          CASE WHEN PJN.UserName IS NULL THEN 'Kareo' ELSE UserName END  , -- UserName - varchar(128)
	          'K' , -- SoftwareApplicationID - char(1)
	          0 , -- Hidden - bit
	          PJN.NoteMessage , -- NoteMessage - varchar(max)
	          0 , -- AccountStatus - bit
	          1 , -- NoteTypeCode - int
	          0  -- LastNote - bit
	FROM dbo.[_import_14_4_PatientJournalNote] PJN
	INNER JOIN dbo.Patient PAT ON
		PJN.ChartNumber = PAT.VendorID AND
		PAT.PracticeID = 4
	WHERE pjn.notemessage <> ''		
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Appointment Notes...'
UPDATE dbo.Appointment 
	SET	Notes = ''
FROM dbo.Appointment 
WHERE CAST(Notes AS VARCHAR) = 'None' AND PracticeID IN (4,5)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT


