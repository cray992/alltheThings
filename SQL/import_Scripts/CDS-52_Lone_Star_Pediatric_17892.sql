--USE superbill_17892_dev
USE superbill_17892_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))



DELETE FROM dbo.InsurancePolicy WHERE (PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Policy records deleted '
DELETE FROM dbo.PatientCase WHERE PatientID IN (SELECT patientid FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient Case records deleted '
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient Alert records deleted '
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient records deleted '
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS VARCHAR(10)) + ' Doctor records deleted '
DELETE FROM dbo.Employers 
PRINT '   ' + CAST(@@rowcount AS VARCHAR(10)) + ' Employer records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Companies records deleted '

PRINT ''
PRINT 'Inserting into Insurance Company ....'
INSERT INTO dbo.InsuranceCompany
        ( 
			InsuranceCompanyName ,
			AddressLine1 ,
			AddressLine2 ,
			City ,
			State ,
			ZipCode ,
			Phone ,
			PhoneExt ,
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
			ins.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
			ins.insuranceaddress1 ,
			ins.insuranceaddress2 ,
			ins.insurancecity ,
			ins.insurancestate ,
			LEFT(REPLACE(ins.insurancezip, '-', ''), 9) ,
			ins.insurancephone ,
			ins.insurancephoneextension ,
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
			ins.insurancecompanynumber , -- VendorID - varchar(50)
			@VendorImportID , -- VendorImportID - int
			1 , -- NDCFormat - int
			1 , -- UseFacilityID - bit
			'U' , -- AnesthesiaType - varchar(1)
			18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_InsuranceList] AS ins
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Company Plan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( 
			PlanName ,
			AddressLine1 ,
			AddressLine2 ,
			City ,
			State ,
			ZipCode ,
			Phone ,
			PhoneExt ,
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
			InsuranceCompanyName , -- PlanName - varchar(128)
			AddressLine1 ,
			AddressLine2 ,
			City ,
			State ,
			ZipCode ,
			Phone ,
			PhoneExt ,
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



PRINT ''
PRINT 'Inserting into Employer ...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
          emp.employer , -- EmployerName - varchar(128)
          emp.employeraddress1 , -- AddressLine1 - varchar(256)
          emp.employeraddress2 , -- AddressLine2 - varchar(256)
          emp.employercity , -- City - varchar(128)
          emp.employerstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          emp.employerzip , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_1_PatientDemographics] emp
WHERE emp.employer <> ''
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into Patient ...'
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
          Country ,
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          EmployerID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PrimaryProviderID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence 
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.patientfirstname , -- FirstName - varchar(64)
          pat.patientmiddlename , -- MiddleName - varchar(64)
          pat.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.address1 , -- AddressLine1 - varchar(256)
          pat.address2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(pat.zip, 9) , -- ZipCode - varchar(9)
          CASE WHEN pat.gender = 'U' THEN 'U'
				WHEN pat.gender = 'M' THEN 'M'
				WHEN pat.gender = 'F' THEN 'F'
				WHEN pat.gender = 'O' THEN 'U'
				WHEN pat.gender = 'N' THEN 'U'
				WHEN pat.gender = '' THEN 'U' end , -- Gender - varchar(1)
		  CASE pat.patmaritalstatus WHEN 0 THEN 'S'
									WHEN 1 THEN 'S'
									WHEN 2 THEN 'M'
									WHEN 3 THEN 'S' END ,
          LEFT(REPLACE(REPLACE(REPLACE(pat.homephone, '(', ''), ')', ''), '-', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pat.workphone, '(', ''), ')', ''), '-', ''), 10) , -- WorkPhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pat.workphoneextension, '(', ''), ')', ''), '-', ''), 10) , --- WorkPhoneExt 
          pat.dateofbirth , -- DOB - datetime
          pat.ssn , -- SSN - char(9)
          pat.email , -- EmailAddress - varchar(256)
          emp.employerid , 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          doc.DoctorID , -- PrimaryProviderID - int
          pat.chartnumber , -- MedicalRecordNumber - varchar(128)
          pat.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          CASE WHEN pat.email <> '' THEN 1 ELSE 0 end  -- SendEmailCorrespondence - bit
FROM dbo.[_import_2_1_PatientDemographics] pat
LEFT JOIN dbo.Doctor doc ON 
	pat.defaultrendprovfirstname = doc.FirstName AND
	pat.defaultrendprovlastname = doc.LastName 
left JOIN dbo.Employers emp ON
	emp.EmployerName = pat.employer AND
	emp.AddressLine1 = pat.employeraddress1
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Patient Case ...'
INSERT INTO dbo.PatientCase
        ( 
			PatientID ,
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
SELECT DISTINCT
			PAT.PatientID , -- PatientID - int
			'Default Case' , -- Name - varchar(128)
			1 , -- Active - bit
			5 , -- PayerScenarioID - int (5 is 'Commercial')
			'Created via data import, please review.' , -- Notes - text
			GETDATE() , -- CreatedDate - datetime
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			@PracticeID , -- PracticeID - int
			pat.VendorID, -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.Patient PAT
WHERE PAT.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT''
PRINT'Inserting into Insurance Policy ...'
INSERT INTO dbo.InsurancePolicy
        ( 
			PatientCaseID ,
			InsuranceCompanyPlanID ,
			Precedence ,
			PolicyNumber ,
			GroupNumber ,
			PatientRelationshipToInsured ,
			CreatedDate ,
			CreatedUserID ,
			ModifiedDate ,
			ModifiedUserID ,
			Active ,
			PracticeID ,
			VendorID ,
			VendorImportID
        )
SELECT  DISTINCT  
			pc.PatientCaseID , -- PatientCaseID - int
			icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
			ip.precedence , -- Precedence - int
			ip.policynumber , -- PolicyNumber - varchar(32)
			ip.groupnumber , -- GroupNumber - varchar(32)
			'S' ,
			GETDATE() , -- CreatedDate - datetime 
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			1 , -- Active - bit
			@PracticeID , -- PracticeID - int
			ip.AutoTempID  , -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.[_import_2_1_PolicyInformation2] AS ip
INNER JOIN dbo.PatientCase pc ON 
	ip.patientnumber = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.insurancecompanynumber = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- CLEAN UP TASKS --

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
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records update'


COMMIT TRAN