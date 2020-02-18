USE superbill_61518_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
SET @PracticeID = 2

SET NOCOUNT ON 

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
	SELECT    CASE WHEN PJN.CreatedDate  = '' THEN GETDATE() ELSE PJN.CreatedDate END , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          PAT.PatientID , -- PatientID - int
	          CASE WHEN PJN.UserName = '' THEN 'Kareo' ELSE UserName END  , -- UserName - varchar(128)
	          'K' , -- SoftwareApplicationID - char(1)
	          0 , -- Hidden - bit
	          PJN.NoteMessage , -- NoteMessage - varchar(max)
	          0 , -- AccountStatus - bit
	          1 , -- NoteTypeCode - int
	          0  -- LastNote - bit
	FROM dbo.[_import_2_2_PatientJournalNote] PJN
	INNER JOIN dbo.Patient PAT ON
		PJN.ChartNumber = PAT.VendorID AND
		PAT.PracticeID = @PracticeID
	WHERE pjn.notemessage <> ''	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT