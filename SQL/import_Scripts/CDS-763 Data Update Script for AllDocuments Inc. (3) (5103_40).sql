--USE superbill_5103_dev
USE superbill_5103_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @SourcePracticeID INT
DECLARE @TargetPracticeID INT
DECLARE @VendorImportID INT

SET @SourcePracticeID = 18
SET @TargetPracticeID = 40
SET @VendorImportID = 128

PRINT 'TargetPracticeID: ' + CAST(@TargetPracticeID AS VARCHAR)
PRINT 'VendorImportID: ' + CAST(@VendorImportID AS VARCHAR)

SET NOCOUNT ON 

CREATE TABLE #tempisnco (InsuranceCompanyID INT )
CREATE TABLE #tempinscoplan (InsuranceCompanyPlanID INT , InsuranceCompanyID INT)

PRINT ''
PRINT 'Inserting Into #tempinsco'
INSERT INTO #tempisnco	( InsuranceCompanyID)
SELECT DISTINCT ic.InsuranceCompanyID 
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID AND
    ip.PracticeID = @TargetPracticeID
INNER JOIN dbo.InsuranceCompany ic ON 
	icp.InsuranceCompanyID = ic.InsuranceCompanyID 
WHERE ip.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into #tempinscoplan'
INSERT INTO #tempinscoplan	( InsuranceCompanyPlanID  , InsuranceCompanyID)
SELECT DISTINCT icp.InsuranceCompanyPlanID , icp.InsuranceCompanyID
FROM dbo.InsurancePolicy ip 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
WHERE ip.PracticeID = @TargetPracticeID AND ip.VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( 
		  InsuranceCompanyName ,
          --Notes ,
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
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          LocalUseFieldTypeCode ,
          --ReviewCode ,
          CompanyTextID ,
          ClearinghousePayerID ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          --DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  
	      i.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
          --i.notes , -- Notes - text
          i.addressline1 , -- AddressLine1 - varchar(256)
          i.addressline2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.state , -- State - varchar(2)
          i.country , -- Country - varchar(32)
          i.zipcode , -- ZipCode - varchar(9)
          i.contactprefix , -- ContactPrefix - varchar(16)
          i.contactfirstname , -- ContactFirstName - varchar(64)
          i.contactmiddlename , -- ContactMiddleName - varchar(64)
          i.contactlastname , -- ContactLastName - varchar(64)
          i.contactsuffix , -- ContactSuffix - varchar(16)
          i.phone , -- Phone - varchar(10)
          i.phoneext , -- PhoneExt - varchar(10)
          i.fax , -- Fax - varchar(10)
          i.faxext , -- FaxExt - varchar(10)
          i.billsecondaryinsurance , -- BillSecondaryInsurance - bit
          i.eclaimsaccepts , -- EClaimsAccepts - bit
          i.billingformid , -- BillingFormID - int
          i.insuranceprogramcode , -- InsuranceProgramCode - char(2)
          i.hcfadiagnosisreferenceformatcode , -- HCFADiagnosisReferenceFormatCode - char(1)
          i.hcfasameasinsuredformatcode  , -- HCFASameAsInsuredFormatCode - char(1)
          i.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
          --i.reviewcode , -- ReviewCode - char(1)
          i.companytextid , -- CompanyTextID - varchar(10)
          i.clearinghousepayerid , -- ClearinghousePayerID - int
          @TargetPracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
          i.insurancecompanyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          --a.AdjustmentCode , -- DefaultAdjustmentCode - varchar(10)
          i.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int	
          1 , -- UseFacilityID - bit
          i.anesthesiatype , -- AnesthesiaType - varchar(1)
          i.institutionalbillingformid  -- InstitutionalBillingFormID - int
FROM dbo.[InsuranceCompany] i
	INNER JOIN #tempisnco ti ON 
		i.InsuranceCompanyID = ti.InsuranceCompanyID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Updating Insurance Company Notes...'
UPDATE dbo.InsuranceCompany
	SET Notes = ic.Notes
FROM dbo.InsuranceCompany ic 
	INNER JOIN #tempisnco i ON
		ic.VendorID = i.InsuranceCompanyID AND
		ic.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into PracticetoInsurance Company...'
INSERT INTO dbo.PracticeToInsuranceCompany
        (
		  PracticeID ,
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
          @TargetPracticeID , -- PracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ptic.EClaimsProviderID , -- EClaimsProviderID - varchar(32)
          ptic.EClaimsProviderID , -- EClaimsEnrollmentStatusID - int
          ptic.EClaimsDisable , -- EClaimsDisable - int
          ptic.acceptassignment  , -- AcceptAssignment - bit
          ptic.usesecondaryelectronicbilling , -- UseSecondaryElectronicBilling - bit
          ptic.usesecondaryelectronicbilling  , -- UseCoordinationOfBenefits - bit
          ptic.excludepatientpayment  , -- ExcludePatientPayment - bit
          ptic.balancetransfer  -- BalanceTransfer - bit
FROM dbo.[PracticeToInsuranceCompany] ptic
	INNER JOIN dbo.InsuranceCompany ic ON
		ptic.insurancecompanyid = ic.VendorID AND
		ic.VendorImportID = @VendorImportID AND
        ic.CreatedPracticeID = @TargetPracticeID
WHERE ptic.PracticeID = @SourcePracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( 
		  PlanName ,
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
          --Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          --ReviewCode ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
          KareoInsuranceCompanyPlanID ,
          KareoLastModifiedDate ,
          InsuranceCompanyID ,
          Copay ,
          Deductible ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT 
          
		  i.PlanName ,
          i.AddressLine1 ,
          i.AddressLine2 ,
          i.City ,
          i.State ,
          i.Country ,
          i.ZipCode ,
          i.ContactPrefix ,
          i.ContactFirstName ,
          i.ContactMiddleName ,
          i.ContactLastName ,
          i.ContactSuffix ,
          i.Phone ,
          i.PhoneExt ,
          --i.Notes ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          --i.ReviewCode ,
          @TargetPracticeID,
          i.Fax ,
          i.FaxExt ,
          i.KareoInsuranceCompanyPlanID ,
          CASE WHEN ISDATE(i.KareoLastModifiedDate) = 1 THEN i.kareolastmodifieddate ELSE NULL END ,
          ic.InsuranceCompanyID ,
          i.Copay ,
          i.Deductible ,
          i.InsuranceCompanyPlanID ,
          @VendorImportID 
FROM dbo.[InsuranceCompanyPlan] i
	INNER JOIN dbo.InsurancePolicy ip ON 
		i.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID AND
        ip.PracticeID = @TargetPracticeID AND 
		ip.VendorImportID = @VendorImportID 
	INNER JOIN #tempinscoplan ti ON
		i.InsuranceCompanyPlanID = ti.InsuranceCompanyPlanID 
	INNER JOIN dbo.InsuranceCompany ic ON 
		ti.InsuranceCompanyID = ic.VendorID AND 
		ic.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Insurance Company Plan Notes...'
UPDATE dbo.InsuranceCompanyPlan
	SET Notes = icp.Notes
FROM dbo.InsuranceCompanyPlan icp 
	INNER JOIN #tempinscoplan i ON
		icp.VendorID = i.InsuranceCompanyPlanID AND
		icp.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Updating Insurance Policy to Practice Specific Insurance Company Plan...'
UPDATE dbo.InsurancePolicy 
	SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
FROM dbo.InsurancePolicy ip 
	INNER JOIN #tempinscoplan ti ON 
		ip.InsuranceCompanyPlanID = ti.InsuranceCompanyPlanID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		CAST(ti.InsuranceCompanyPlanID AS VARCHAR) = icp.VendorID AND
        icp.CreatedPracticeID = @TargetPracticeID AND 
		icp.VendorImportID = @VendorImportID
WHERE ip.PracticeID = @TargetPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Company Review Code...'
UPDATE dbo.InsuranceCompany 
	SET ReviewCode = ''
FROM dbo.InsuranceCompany ic 
	INNER JOIN #tempisnco tempco ON
		ic.InsuranceCompanyID = tempco.InsuranceCompanyID
WHERE ic.ReviewCode = 'R'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Company Plan Review Code...'
UPDATE dbo.InsuranceCompanyPlan
	SET ReviewCode = ''
FROM dbo.InsuranceCompanyPlan icp 
	INNER JOIN #tempinscoplan tempplanco ON
		icp.InsuranceCompanyPlanID = tempplanco.InsuranceCompanyPlanID
WHERE icp.ReviewCode = 'R'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #tempisnco 
DROP TABLE #tempinscoplan

--ROLLBACK
--COMMIT
