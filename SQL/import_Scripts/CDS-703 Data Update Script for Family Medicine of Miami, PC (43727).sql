USE superbill_43727_dev
--USE superbill_43727_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Inserting into Temptable where InsuranceCompany and Plans match 1:1...'
CREATE TABLE #tempinsco (insurancecompanyid INT, InsuranceCompanyName VARCHAR(128), ClearingHousePayerID INT)
INSERT INTO #tempinsco
        ( insurancecompanyid , InsuranceCompanyName , ClearingHousePayerID)
SELECT DISTINCT  
		  ic.InsuranceCompanyID , -- insurancecompanyid - int
          ic.InsuranceCompanyName , -- InsuranceCompanyName - varchar(128)
		  ic.ClearinghousePayerID
FROM dbo.InsuranceCompany ic
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	ic.InsuranceCompanyName = icp.PlanName AND 
	ic.AddressLine1 = icp.AddressLine1 AND 
	ic.AddressLine2 = icp.AddressLine2 AND
	ic.[State] = icp.[State] AND 
	ic.ZipCode = icp.ZipCode
WHERE icp.InsuranceCompanyPlanID IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


-- This will insert Insurance Company records from the plan table where not already matched 1:1 to plan
PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
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
		  icp.PlanName ,
          'Created from Insurance Plan - ' + CHAR(13) + CHAR(10) + 
		  'Insurance Plan Name: ' + icp.PlanName + CHAR(13) + CHAR(10) + 
		  'Insurance Plan ID: ' + CAST(icp.InsuranceCompanyPlanID AS VARCHAR) + CHAR(13) + CHAR(10) + 
		  + CONVERT(VARCHAR(10),GETDATE(),101) ,
          icp.AddressLine1 ,
          icp.AddressLine2 ,
          icp.City ,
          icp.State ,
          icp.Country ,
          icp.ZipCode ,
          icp.ContactPrefix ,
          icp.ContactFirstName ,
          icp.ContactMiddleName ,
          icp.ContactLastName ,
          icp.ContactSuffix ,
          icp.Phone ,
          icp.PhoneExt ,
          icp.Fax ,
          icp.FaxExt ,
          1 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
          icp.CreatedPracticeID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          13 ,
          icp.InsuranceCompanyID ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18
FROM dbo.InsuranceCompanyPlan icp
LEFT JOIN dbo.InsuranceCompany ic ON 
	icp.PlanName = ic.InsuranceCompanyName AND 
	icp.AddressLine1 = ic.AddressLine1 AND 
	icp.[State] = ic.[State] AND 
	icp.ZipCode = ic.ZipCode
LEFT JOIN #tempinsco tico ON 
	ic.InsuranceCompanyID = tico.insurancecompanyid 
WHERE ic.InsuranceCompanyID IS NULL OR tico.insurancecompanyid IS NULL --icp.AddressLine1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- Updating the existing plans to their newly imported company record
PRINT ''
PRINT 'Updating Insurance Company Plan - InsuranceCompany'
UPDATE dbo.InsuranceCompanyPlan 
	SET InsuranceCompanyID = ic.InsuranceCompanyID
FROM dbo.InsuranceCompanyPlan icp 
INNER JOIN dbo.InsuranceCompany ic ON
	icp.PlanName = ic.InsuranceCompanyName AND 
	icp.AddressLine1 = ic.AddressLine1 AND 
	icp.[State] = ic.[State] AND 
	icp.ZipCode = ic.ZipCode
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

-- Originally there were Company records that were not linked to a Plan. This will insert the additional Company records into the plan table where the companyid does not exist.
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
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReviewCode ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  ic.InsuranceCompanyName , -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
          ic.AddressLine2 , -- AddressLine2 - varchar(256)
          ic.City , -- City - varchar(128)
          ic.[State] , -- State - varchar(2)
          ic.Country , -- Country - varchar(32)
          ic.ZipCode , -- ZipCode - varchar(9)
          ic.ContactPrefix , -- ContactPrefix - varchar(16)
          ic.ContactFirstName , -- ContactFirstName - varchar(64)
          ic.ContactMiddleName , -- ContactMiddleName - varchar(64)
          ic.ContactLastName , -- ContactLastName - varchar(64)
          ic.ContactSuffix , -- ContactSuffix - varchar(16)
          ic.Phone , -- Phone - varchar(10)
          ic.PhoneExt , -- PhoneExt - varchar(10)
          'Created from Insurance Company ' + CONVERT(VARCHAR(10),GETDATE(),101) , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          ic.Fax , -- Fax - varchar(10)
          ic.FaxExt , -- FaxExt - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.InsuranceCompanyID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany ic
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	ic.InsuranceCompanyID = icp.InsuranceCompanyID
WHERE icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- This creates the Eclaim settings from the original insurance company record. This saves the customer time.
PRINT ''
PRINT 'Inserting Into Practice to Insurance Company...'
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
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ptic.EClaimsProviderID , -- EClaimsProviderID - varchar(32)
          ptic.EClaimsEnrollmentStatusID , -- EClaimsEnrollmentStatusID - int
          ptic.EClaimsDisable , -- EClaimsDisable - int
          ptic.AcceptAssignment , -- AcceptAssignment - bit
          ptic.UseSecondaryElectronicBilling , -- UseSecondaryElectronicBilling - bit
          ptic.UseCoordinationOfBenefits , -- UseCoordinationOfBenefits - bit
          ptic.ExcludePatientPayment , -- ExcludePatientPayment - bit
          ptic.BalanceTransfer  -- BalanceTransfer - bit
FROM dbo.InsuranceCompany ic 
INNER JOIN dbo.PracticeToInsuranceCompany ptic ON
	ic.VendorID = ptic.InsuranceCompanyID AND 
	ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Insurance Company...'
UPDATE dbo.InsuranceCompany
	SET ClearinghousePayerID = tempco.ClearinghousePayerID
FROM dbo.InsuranceCompany ic
	INNER JOIN #tempinsco tempco ON 
		ic.VendorID = tempco.InsuranceCompanyID AND
        ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


-- Remaining is 12 plan records that will need to be merged in the app. These are duplicated from the original import but had unique VendorIDs.
DROP TABLE #tempinsco


--ROLLBACK
--COMMIT
