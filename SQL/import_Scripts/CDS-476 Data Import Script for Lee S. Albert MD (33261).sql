USE superbill_33261_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


--DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
--DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
		  inscompanyname ,
          0 ,
          0 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
          @PracticeID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          13 ,
          companyid ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18
FROM dbo.[_import_2_1_Sheet1]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' rows inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID ,
		  Fax
        )
SELECT DISTINCT
	      i.insuranceplanname , -- PlanName - varchar(128)
          i.planaddress1 , -- AddressLine1 - varchar(256)
          i.planaddress2 , -- AddressLine2 - varchar(256)
          i.plancity , -- City - varchar(128)
          i.planstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(i.planzip5) = 4 THEN '0' + i.planzip5 WHEN LEN(i.planzip5) = 5 THEN i.planzip5 ELSE '' END , -- ZipCode - varchar(9)
          i.planphone1 , -- Phone - varchar(10)
          CASE WHEN i.planphone2 = '' THEN '' ELSE 'Plan Phone 2: ' + i.planphone2 END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.planid , -- VendorID - varchar(50)
          1 ,  -- VendorImportID - int
		  i.planfax 
FROM dbo.[_import_2_1_Sheet1] i
	INNER JOIN dbo.InsuranceCompany ic ON
		i.companyid = ic.VendorID AND
		ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' rows inserted'


--COMMIT
--ROLLBACK

