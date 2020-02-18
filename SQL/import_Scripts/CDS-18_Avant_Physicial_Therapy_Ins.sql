--USE superbill_17989_dev
USE superbill_17989_prod
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
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '

DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Companies records deleted '


PRINT ''
PRINT 'Inserting into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT 
		  ic.inscompanyname , -- InsuranceCompanyName - varchar(128)
          '' , -- Notes - text
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID, -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          ic.inscompanyname , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
 FROM dbo.[_import_1_1_Sheet1] ic
 WHERE ic.inscompanyname NOT IN (SELECT InsuranceCompanyName FROM dbo.InsuranceCompany )
 PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
 
 PRINT ''
 PRINT 'Inserting into InsuranceCompanyPlan'
 INSERT INTO dbo.InsuranceCompanyPlan
         ( PlanName ,
           AddressLine1 ,
           AddressLine2 ,
           City ,
           State ,
           Country ,
           ZipCode ,
           Phone ,
           CreatedDate ,
           CreatedUserID ,
           ModifiedDate ,
           ModifiedUserID ,
           CreatedPracticeID ,
           InsuranceCompanyID ,
           VendorID ,
           VendorImportID 
         )
SELECT     icp.insplanname , -- PlanName - varchar(128)
           icp.street1 , -- AddressLine1 - varchar(256)
           icp.street2 , -- AddressLine2 - varchar(256)
           icp.city, -- City - varchar(128)
           icp.state , -- State - varchar(2)
           '' , -- Country - varchar(32)
           icp.zip , -- ZipCode - varchar(9)
           icp.phone , -- Phone - varchar(10)
           GETDATE() , -- CreatedDate - datetime
           0 , -- CreatedUserID - int
           GETDATE() , -- ModifiedDate - datetime
           0 , -- ModifiedUserID - int
           @PracticeID, -- CreatedPracticeID - int
           ic.InsuranceCompanyID , -- InsuranceCompanyID - int
           icp.inscompanyname , -- VendorID - varchar(50)
           @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Sheet1] icp
INNER JOIN dbo.InsuranceCompany ic  ON
	ic.InsuranceCompanyName = icp.inscompanyname
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

COMMIT

--