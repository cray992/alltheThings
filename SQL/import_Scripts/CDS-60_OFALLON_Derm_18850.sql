--USE superbill_18850_dev
USE superbill_18850_prod
go

SET XACT_ABORT ON 

BEGIN TRAN

SET NOCOUNT ON 

DECLARE @PracticeID INT
DECLARE @VendorImportID int

SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS VARCHAR(10)) + ' Doctor records deleted '
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'

PRINT ''
PRINT 'Inserting into Insurance Company ...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
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
          KareoLastModifiedDate ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
          ic.insurancecompanyname  , -- InsuranceCompanyName - varchar(128)
          ic.insuranceaddress1 , -- AddressLine1 - varchar(256)
          ic.insuranceaddress2 , -- AddressLine2 - varchar(256) 
          ic.city , -- City - varchar(128)
          ic.state , -- State - varchar(2)
          ic.zipcode + ic.zip4 , -- ZipCode - varchar(9)
          ic.planphonenumber , -- Phone - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE()  , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          GETDATE() , -- KareoLastModifiedDate - datetime
          13 , -- SecondaryPrecedenceBillingFormID - int
          ic.lyteccode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceList] ic
WHERE ic.insurancecompanyname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Insurance Company Plan ...'
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
SELECT DISTINCT
          CAST(icp.insuranceplanname AS VARCHAR) , -- PlanName - varchar(128)
          icp.insuranceaddress1 , -- AddressLine1 - varchar(256)
          icp.insuranceaddress2 , -- AddressLine2 - varchar(256)
          icp.city , -- City - varchar(128)
          icp.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          icp.zipcode + icp.zip4 , -- ZipCode - varchar(9)
          icp.planphonenumber , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID, -- InsuranceCompanyID - int
          icp.lyteccode , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_InsuranceList] icp 
JOIN dbo.InsuranceCompany ic ON 
	ic.VendorID = icp.lyteccode AND
	ic.CreatedPracticeID = @practiceid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Doctors ...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
		  Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          WorkPhone ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          '' ,
          doc.[first] , -- FirstName - varchar(64)
          doc.[middle] , -- MiddleName - varchar(64)
          doc.[last] , -- LastName - varchar(64)
          '' ,
          doc.address1 , -- AddressLine1 - varchar(256)
          doc.address2 , -- AddressLine2 - varchar(256)
          doc.city , -- City - varchar(128)
          doc.state , -- State - varchar(2)
          doc.zipcode , -- ZipCode - varchar(9)
          doc.phone , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          doc.degree , -- Degree - varchar(8)
          doc.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          doc.fax , -- FaxNumber - varchar(10)
          1  -- External - bit
FROM dbo.[_import_1_1_ReferringPhysicians]doc 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

COMMIT