--USE superbill_16830_dev
USE superbill_16830_prod
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
PRINT '   ' + CAST(@@ROWCOUNT AS varchar(10)) + ' Insurance Company Plans records deleted '
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID 
PRINT '   ' + CAST(@@ROWCOUNT AS varchar(10)) + ' Current Insurance Company Plans records deleted '
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = @PracticeID AND InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID)
PRINT '   ' + CAST(@@ROWCOUNT AS varchar(10)) + ' PracticeToInsuranceCompany records deleted '
DELETE FROM dbo.EnrollmentDoctor WHERE DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE PracticeID = @PracticeID) 
PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' EnrollmentDoctor records deleted'
DELETE FROM dbo.EnrollmentPayer WHERE PracticeID = @PracticeID AND InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID)
PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' EnrollmentPayer records deleted'
DELETE FROM dbo.ClaimSettings WHERE InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID)
PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ClaimSettings records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@ROWCOUNT AS varchar(10)) + ' Insurance Companies records deleted '
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID
PRINT '   ' + CAST(@@ROWCOUNT AS varchar(10)) + ' Current Insurance Companies records deleted '



SET IDENTITY_INSERT dbo.InsuranceCompany ON 
PRINT ''
PRINT 'Inserting into InsuranceCompany ....'
INSERT INTO dbo.InsuranceCompany

        ( InsuranceCompanyID , 
          InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          ClearinghousePayerID ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT    ins.insurancecompanyid ,
		  ins.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
          '' , -- Notes - text
          ins.addressline1 , -- AddressLine1 - varchar(256)
          ins.addressline2 , -- AddressLine2 - varchar(256)
          ins.city , -- City - varchar(128)
          ins.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ins.zipcode, '-', ''), 9) , -- ZipCode - varchar(9)
          0 , -- BillSecondaryInsurance - bit
          1 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          CASE WHEN ins.insurancecompanyname LIKE '%blue%' THEN 'BL' 
			   WHEN ins.insurancecompanyname LIKE '%Medicare%' THEN 'MB'
			   ELSE 'CI' END , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          ins.clearinghousepayerid , -- ClearinghousePayerID - int
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          insurancecompanyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceInfo] ins 
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.InsuranceCompany OFF 


PRINT ''
PRINT 'Insert into PracticeToInsuranceCompany ...'
INSERT INTO dbo.PracticeToInsuranceCompany
        ( PracticeID ,
          InsuranceCompanyID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EClaimsProviderID ,
          EClaimsEnrollmentStatusID ,
          EClaimsDisable ,
          AcceptAssignment ,
          UseSecondaryElectronicBilling ,
          UseCoordinationOfBenefits ,
          ExcludePatientPayment ,
          BalanceTransfer
        )
SELECT    @PracticeID , -- PracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- EClaimsProviderID - varchar(32)
          CASE WHEN ic.insurancecompanyname = '2' THEN 1 ELSE 2 END , -- EClaimsEnrollmentStatusID - int
          0 , -- EClaimsDisable - int
          1 , -- AcceptAssignment - bit
          0 , -- UseSecondaryElectronicBilling - bit
          1 , -- UseCoordinationOfBenefits - bit
          0 , -- ExcludePatientPayment - bit
          1  -- BalanceTransfer - bit
FROM dbo.InsuranceCompany ic 
WHERE ic.CreatedPracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Insert into EnrollmentPayer ...'
INSERT INTO dbo.EnrollmentPayer
        ( PracticeID ,
          ClearinghousePayerID ,
          InsuranceProgramCode ,
          Ptan ,
          EclaimsSelected ,
          EligibilitySelected ,
          EraSelected ,
          CreatedDateTime ,
          CreatedUserID ,
          ModifiedDateTime ,
          ModifiedUserID ,
          InsuranceCompanyID
        )
SELECT    @PracticeID , -- PracticeID - int
          ic.ClearinghousePayerID , -- ClearinghousePayerID - int
          ic.InsuranceProgramCode , -- InsuranceProgramCode - char(2)
          CASE WHEN ic.ClearinghousePayerID = 844 THEN 'DL278A' ELSE NULL END , -- Ptan - varchar(100)
          1 , -- EclaimsSelected - bit
          CASE WHEN ic.ClearinghousePayerID IN (135, 844, 6318, 1431, 11458) THEN 1 ELSE 0 END , -- EligibilitySelected - bit
          CASE WHEN ic.ClearinghousePayerID IN (135, 844, 6318, 1431, 11458, 509, 17512) THEN 1 ELSE 0 END  , -- EraSelected - bit
          GETDATE() , -- CreatedDateTime - smalldatetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDateTime - smalldatetime
          0 , -- ModifiedUserID - int
          ic.InsuranceCompanyID  -- InsuranceCompanyID - int
FROM dbo.InsuranceCompany ic
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records insereted'


PRINT ''
PRINT 'Insert into EnrollmentDoctor ...'
INSERT INTO dbo.EnrollmentDoctor
        ( EnrollmentPayerID, DoctorID, Ptan )
SELECT   ep.EnrollmentPayerID,
		 doc.doctorid,
		 ep.Ptan
FROM dbo.EnrollmentPayer ep
LEFT JOIN dbo.Doctor doc ON
	ep.PracticeID = doc.PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
	
	
PRINT ''
PRINT 'Insert into ClaimSettings ...'
INSERT INTO dbo.ClaimSettings 
        ( DoctorID ,
          InsuranceCompanyID ,
          ClaimSettingsTaxIDTypeID ,
          ClaimSettingsNPITypeID ,
          ShowAdvancedSettings ,
          Field33bNumberType ,
          Field33bValue ,
          ProviderNumberType1 ,
          ProviderNumber1 ,
          GroupNumberType1 ,
          GroupNumber1 ,
          EligibilityOverride ,
          EligibilityNPITypeID ,
          EligibilityTaxIDTypeID ,
          OverridePracticeNameFlag ,
          OverridePracticeAddressFlag ,
          OverridePayToAddressFlag 
        )
SELECT    doc.DoctorID , -- DoctorID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          1 , -- ClaimSettingsTaxIDTypeID - int
          1 , -- ClaimSettingsNPITypeID - int
          1 , -- ShowAdvancedSettings - bit
          24 , -- Field33bNumberType - int
          'DL278A' , -- Field33bValue - varchar(50)
          CASE WHEN doc.DoctorID = 1 THEN 23 END , -- ProviderNumberType1 - int
          CASE WHEN doc.DoctorID = 1 THEN 'DL297Z' END , -- ProviderNumber1 - varchar(50)
          24 , -- GroupNumberType1 - int
          'DL278A' , -- GroupNumber1 - varchar(50)
          0 , -- EligibilityOverride - bit
          1 , -- EligibilityNPITypeID - int
          1 , -- EligibilityTaxIDTypeID - int
          0 , -- OverridePracticeNameFlag - bit
          0 , -- OverridePracticeAddressFlag - bit
          0  -- OverridePayToAddressFlag - bit
FROM dbo.InsuranceCompany ic
LEFT JOIN dbo.Doctor doc ON
	ic.CreatedPracticeID = doc.PracticeID
WHERE ic.InsuranceCompanyID = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
		  AddressLine1 ,
		  city ,
		  State ,
		  ZipCode ,
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
		  ic.planname, -- PlanName - varchar(128)
		  ic.addressline11 ,
		  ic.city1 ,
		  ic.[State1] ,
		  LEFT(REPLACE(ic.zipcode1, '-', ''), 9) ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          icp.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.[AutoTempID] , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany icp 
JOIN [dbo].[_import_1_1_InsuranceInfo] ic ON
	icp.VendorID = ic.insurancecompanyid
WHERE icp.CreatedPracticeID = @PracticeID AND 
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT 
