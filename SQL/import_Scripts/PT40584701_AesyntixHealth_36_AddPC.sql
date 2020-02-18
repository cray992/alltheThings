--USE superbill_2039_dev
USE superbill_2039_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 36
SET @VendorImportID = 50 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


--Patient Case
PRINT 'Inserting Records into PatientCase 1....'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    realP.PatientID , -- PatientID - int
          'INS-' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeId, -- PracticeID - int
          realP.PatientID  , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
From dbo.Patient realP 
WHERE realP.PracticeID = @PracticeID
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

	
--Patient Case
PRINT 'Inserting Records into PatientCase 2....'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    realP.PatientID , -- PatientID - int
          'SELF PAY - COS' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          'Created via data import, please review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeId, -- PracticeID - int
          realP.PatientID  , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
From dbo.Patient realP 
WHERE realP.PracticeID = @PracticeID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

	
--Patient Case
PRINT 'Inserting Records into PatientCase 3....'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    realP.PatientID , -- PatientID - int
          'SELF PAY - FFS' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          'Created via data import, please review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeId, -- PracticeID - int
          realP.PatientID  , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
From dbo.Patient realP 
WHERE realP.PracticeID = @PracticeID
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT 
