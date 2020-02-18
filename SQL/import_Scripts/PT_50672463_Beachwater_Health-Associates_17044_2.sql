--USE superbill_17044_dev
USE superbill_17044_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))



DELETE FROM dbo.InsurancePolicy WHERE (PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Policy records deleted '

DELETE FROM dbo.PatientCase WHERE PatientID IN (SELECT patientid FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient Case records deleted '

DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient records deleted '

DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '

DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Companies records deleted '




PRINT''
PRINT'Inserting into Insurance Company ....'
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
SELECT	  ins.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          ins.autotempid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_2_InsuranceCOMPANYPLANList] AS ins
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Company Plan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          City ,
          State ,
          ZipCode ,
          ContactFirstName ,
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
SELECT    InsuranceCompanyName , -- PlanName - varchar(128)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          ZipCode , -- ZipCode - varchar(9)
          ContactFirstName , -- ContactFirstName - varchar(64)
          Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int       
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Patient ...'
INSERT INTO dbo.Patient
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
          Gender ,
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )  
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middleinitial , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          street1 , -- AddressLine1 - varchar(256)
          street2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          LEFT(REPLACE(zipcode, '-', ''), 9) , -- ZipCode - varchar(9)
          gender , -- Gender - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(homephone, ' ', ''), '(', ''), '(', ''), '-', ''), 10), -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(workphone, ' ', ''), '(', ''), '(', ''), '-', ''), 10) , -- WorkPhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(workextension, ' ', ''), '(', ''), '(', ''), '-', ''), 10) ,
          CASE WHEN ISDATE(dateofbirth) > 0 THEN dateofbirth END , -- DOB - datetime
          socialsecuritynumber , -- SSN - char(9)
          email ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(cellphone, ' ', ''), '(', ''), '(', ''), '-', ''), 10) , -- MobilePhone - varchar(10)
          LEFT(lastname + CAST(AutoTempID AS VARCHAR(10)), 50) , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          CASE email WHEN '' THEN 0
		                         ELSE 1
		  END , -- SendEmailCorrespondence - bit
          1  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_1_2_PatientDemographics] 
WHERE firstname <> '' AND
	  lastname <> '' AND
	  (firstname NOT IN (SELECT firstname FROM dbo.Patient) AND
	  lastname NOT IN (SELECT lastname FROM dbo.Patient))
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

UPDATE dbo.Patient	
	SET AddressLine1 = (SELECT street1 FROM dbo.[_import_1_2_PatientDemographics] WHERE pat.firstname = firstname AND pat.lastname = lastname),
		AddressLine2 = (SELECT street2 FROM dbo.[_import_1_2_PatientDemographics] WHERE pat.firstname = firstname AND pat.lastname = lastname),
		City = (SELECT city FROM dbo.[_import_1_2_PatientDemographics] WHERE pat.firstname = firstname AND pat.lastname = lastname),
		State = (SELECT state FROM dbo.[_import_1_2_PatientDemographics] WHERE pat.firstname = firstname AND pat.lastname = lastname),
		SSN = (SELECT SSN FROM dbo.[_import_1_2_PatientDemographics] WHERE pat.firstname = firstname AND pat.lastname = lastname),
		HomePhone = (SELECT homephone FROM dbo.[_import_1_2_PatientDemographics] WHERE pat.firstname = firstname AND pat.lastname = lastname),
		MobilePhone = (SELECT cellphone FROM dbo.[_import_1_2_PatientDemographics] WHERE pat.firstname = firstname AND pat.lastname = lastname),
		EmailAddress = (SELECT email FROM dbo.[_import_1_2_PatientDemographics] WHERE pat.firstname = firstname AND pat.lastname = lastname),
		VendorID = CAST(pat.PatientID AS VARCHAR)
	FROM dbo.Patient pat
		WHERE pat.PracticeID= 2
		AND VendorImportID IS NULL


PRINT''
PRINT'Inserting into Patient Case ...'
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
SELECT    PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.Patient

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Policy ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pol.policynumber1 , -- PolicyNumber - varchar(32)
          pol.groupnumber1 , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.chartnumber , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_2_PatientDemographics] AS pol
JOIN dbo.PatientCase AS pc ON 
	pc.vendorID= LEFT(lastname + CAST(AutoTempID AS VARCHAR(10)), 50) AND 
	pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp ON 
	icp.PlanName = pol.insuranceplanname1
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Insurance Policy a...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pol.policynumber1 , -- PolicyNumber - varchar(32)
          pol.groupnumber1 , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.chartnumber , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_2_PatientDemographics] AS pol
INNER JOIN dbo.Patient pat ON 
	pol.firstname = pat.FirstName AND
	pol.lastname = pat.LastName AND
	pat.VendorImportID IS NULL 
JOIN dbo.PatientCase AS pc ON 
	pat.PatientID = pc.PatientID and
	pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp ON 
	icp.PlanName = pol.insuranceplanname1
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pol.policynumber2 , -- PolicyNumber - varchar(32)
          pol.groupnumber2 , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.chartnumber , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_2_PatientDemographics] AS pol
JOIN dbo.PatientCase AS pc ON 
	pc.vendorID= LEFT(lastname + CAST(AutoTempID AS VARCHAR(10)), 50) AND 
	pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp ON 
	icp.PlanName = pol.insuranceplanname2
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Insurance Policy 2a...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pol.policynumber2 , -- PolicyNumber - varchar(32)
          pol.groupnumber2 , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pol.chartnumber , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_2_PatientDemographics] AS pol
INNER JOIN dbo.Patient pat ON 
	pol.firstname = pat.FirstName AND
	pol.lastname = pat.LastName AND
	pat.VendorImportID IS NULL 
JOIN dbo.PatientCase AS pc ON 
	pat.PatientID = pc.PatientID and
	pc.VendorImportID=@VendorImportID
JOIN dbo.InsuranceCompanyPlan AS icp ON 
	icp.PlanName = pol.insuranceplanname2
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

	


PRINT ''
PRINT 'Updating PatientCase'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	@VendorImportID = VendorImportID AND 
	@PracticeID = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy) AND
	PayerScenarioID <> 11
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT TRAN