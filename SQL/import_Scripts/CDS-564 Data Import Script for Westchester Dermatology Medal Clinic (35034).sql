USE superbill_35034_dev
--USE superbill_35034_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

PRINT ''
PRINT 'Inserting Into PCD...'
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
		  NOC ,
          CustomCode ,
		  BillableCode
		  
        )
SELECT DISTINCT
		  REPLACE(i.productcode,'-','') , -- ProcedureCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '1' , -- TypeOfServiceCode - char(1)
          1 , -- Active - bit
          i.productname  , -- OfficialName - varchar(300)
          i.productname , -- LocalName - varchar(100)
          0 , 
		  1 , -- CustomCode - bit
		  REPLACE(i.productcode,'-','')
FROM dbo.[_import_2_1_Sheet1] i 
WHERE i.productcode <> '' AND NOT EXISTS (SELECT * FROM dbo.ProcedureCodeDictionary pcd WHERE i.productcode = pcd.ProcedureCode)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--COMMIT
--ROLLBACK

