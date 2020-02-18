USE superbill_29290_dev
-- USE superbill_29290_dev 
GO


SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 
-- Clear out any existing records for this import, (makes the script safe to run multiple times)
--PRINT ''
--PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Insert Into Procedure Code Dictionary...'
INSERT INTO dbo.ProcedureCodeDictionary
        ( ProcedureCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
		  ModifiedUserID ,
          TypeOfServiceCode ,
          Active ,
          OfficialName ,
          CustomCode
        )
SELECT DISTINCT
		  i.procedurecode , -- ProcedureCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          '1' , -- TypeOfServiceCode - char(1)
          1 , -- Active - bit
          i.officialname , -- OfficialName - varchar(300)
          0  -- CustomCode - bit
FROM dbo.[_import_1_1_Sheet1] i
WHERE procedurecode <> '' AND NOT EXISTS (SELECT * FROM dbo.ProcedureCodeDictionary pcd WHERE pcd.ProcedureCode = i.procedurecode)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted'

--ROLLBACK
--COMMIT

