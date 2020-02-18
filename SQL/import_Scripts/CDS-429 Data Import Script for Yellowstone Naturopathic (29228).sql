USE superbill_29228_dev
--USE superbill_29228_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting Into ProcedureCodeDictionary...'
INSERT INTO dbo.ProcedureCodeDictionary
        ( ProcedureCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          TypeOfServiceCode ,
          Active ,
          OfficialName ,
          LocalName ,
          CustomCode ,
		  BillableCode ,
		  DefaultUnits
        )
SELECT DISTINCT
		  i.productcode , -- ProcedureCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          '1' , -- TypeOfServiceCode - char(1)
          1 , -- Active - bit
          i.productname , -- OfficialName - varchar(300)
          i.productname , -- LocalName - varchar(100)
          1 , -- CustomCode - bit
		  i.productcode ,
		  '1.0000'
FROM dbo.[_import_3_1_CustomCPT] i
WHERE NOT EXISTS (SELECT * FROM dbo.ProcedureCodeDictionary pcd WHERE i.productcode = pcd.ProcedureCode)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT