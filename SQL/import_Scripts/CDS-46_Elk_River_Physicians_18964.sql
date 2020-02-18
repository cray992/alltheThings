--USE superbill_18964_dev
USE superbill_18964_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
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
			ins.insuranceaddress ,
			ins.insuranceaddress2 ,
			ins.city ,
			ins.state ,
			LEFT(REPLACE(ins.zip + ins.zipplus4, '-', ''), 9) ,
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
			ins.insurancecode , -- VendorID - varchar(50)
			@VendorImportID , -- VendorImportID - int
			1 , -- NDCFormat - int
			1 , -- UseFacilityID - bit
			'U' , -- AnesthesiaType - varchar(1)
			18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_InsuranceList] AS ins
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

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
VALUES (
			'Aetna' ,
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
			'Aetna' ,
			@VendorImportID ,
			1 ,
			1 ,
			'U' ,
			18
)

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
VALUES (
			'Aerospace Contractors Trust' ,
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
			'Aerospace Contractors Trust' ,
			@VendorImportID ,
			1 ,
			1 ,
			'U' ,
			18
)


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
PRINT 'Inserting into Doctor ...'
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
          Country ,
          ZipCode ,
          WorkPhone ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          ref.referringphysicianfirstname , -- FirstName - varchar(64)
          ref.referringphysicianmiddlename , -- MiddleName - varchar(64)
          ref.referringphysicianlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          ref.address1 , -- AddressLine1 - varchar(256)
          ref.address2 , -- AddressLine2 - varchar(256)
          ref.city , -- City - varchar(128)
          ref.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ref.zip , -- ZipCode - varchar(9)
          ref.phone , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ref.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          ref.fax , -- FaxNumber - varchar(10)
          1 , -- External - bit
          ref.npi  -- NPI - varchar(10)
FROM dbo.[_import_2_1_ReferringPhysicians] ref
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient ...'
INSERT INTO dbo.Patient
        ( PracticeID ,
          ReferringPhysicianID ,
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
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PrimaryProviderID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          ref.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          pat.patientfirstname , -- FirstName - varchar(64)
          pat.patientmiddleinitial , -- MiddleName - varchar(64)
          pat.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.address1 , -- AddressLine1 - varchar(256)
          pat.address2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(pat.zip, 9) , -- ZipCode - varchar(9)
          CASE WHEN pat.gender = 'Unkown' THEN ''
				WHEN pat.gender = 'M' THEN 'M'
				WHEN pat.gender = 'F' THEN 'F' end , -- Gender - varchar(1)
          CASE pat.maritalstatus WHEN 'Married' THEN 'M'
								WHEN 'Legally Separated' THEN 'L'
								WHEN 'Divorced' THEN 'D'
								WHEN 'Widowed' THEN 'W'
								ELSE 'S' END , -- MaritalStatus - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(pat.homephone, '(', ''), ')', ''), '-', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pat.workphone, '(', ''), ')', ''), '-', ''), 10) , -- WorkPhone - varchar(10)
          pat.dateofbirth , -- DOB - datetime
          pat.ssn , -- SSN - char(9)
          pat.emailaddress , -- EmailAddress - varchar(256)
          CASE WHEN pat.responsible = 'Self' THEN NULL	
				ELSE 1 END , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pat.responsible = 'Self' THEN NULL	
				ELSE pat.responsible END , -- ResponsibleFirstName - varchar(64)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          doc.DoctorID , -- PrimaryProviderID - int
          pat.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(REPLACE(REPLACE(REPLACE(pat.mobilephone, '(', ''), ')', ''), '-', ''), 10) , -- MobilePhone - varchar(10)
          pat.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          CASE WHEN pat.emailaddress <> '' THEN 1 ELSE 0 end , -- SendEmailCorrespondence - bit
          pat.emergencycontact , -- EmergencyName - varchar(128)
          LEFT(REPLACE(REPLACE(REPLACE(pat.emergencycontactphone, '(', ''), ')', ''), '-', ''), 10)  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_2_1_PatientDemographics] pat
LEFT JOIN dbo.Doctor ref ON 
	pat.defaultreferringphysicianfirstname = ref.FirstName AND
	pat.defaultreferringphysicianlastname = ref.LastName AND
	ref.VendorImportID = @VendorImportID  
LEFT JOIN dbo.Doctor doc ON  
	pat.defaultrenderingproviderfirstname = doc.FirstName AND
	pat.defaultrenderingproviderlastname = doc.LastName AND
	ref.[External] = 0 AND
	ref.PracticeID = @PracticeID      
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Patient Alert ...'
INSERT INTO dbo.PatientAlert
        ( 
			PatientID ,
			AlertMessage ,
			ShowInPatientFlag ,
			ShowInAppointmentFlag ,
			ShowInEncounterFlag ,
			CreatedDate ,
			CreatedUserID ,
			ModifiedDate ,
			ModifiedUserID ,
			ShowInClaimFlag ,
			ShowInPaymentFlag ,
			ShowInPatientStatementFlag
        )
SELECT  	PatientID , -- PatientID - int
			pat.alert , -- AlertMessage - text
			1 , -- ShowInPatientFlag - bit
			1 , -- ShowInAppointmentFlag - bit
			1 , -- ShowInEncounterFlag - bit
			GETDATE() , -- CreatedDate - datetime
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			1 , -- ShowInClaimFlag - bit
			1 , -- ShowInPaymentFlag - bit
			1   -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_2_1_PatientDemographics] pat
INNER JOIN dbo.Patient p ON 
	pat.chartnumber = p.MedicalRecordNumber AND
	p.VendorImportID = @VendorImportID
WHERE pat.alert <> ''
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
			impCase.chartnumber, -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.[_import_2_1_CaseInformation] impCase
INNER JOIN dbo.Patient PAT ON 
	PAT.VendorImportID = @VendorImportID AND
	impCase.chartnumber = PAT.VendorID
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
			HolderFirstName,
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
			1 , -- Precedence - int
			impCase.primarypolicynumber , -- PolicyNumber - varchar(32)
			impCase.primarygroupnumber , -- GroupNumber - varchar(32)
			CASE impCase.primaryinsuredrelationship WHEN 'Child' THEN 'C'
													WHEN 'Other' THEN 'O'
													WHEN 'Self' THEN 'S'
													WHEN 'Spouse' THEN 'U'
													ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
			CASE WHEN impCase.primaryinsuredrelationship = 'Self' THEN ''
				ELSE impCase.primaryinsured END , 
			GETDATE() , -- CreatedDate - datetime 
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			1 , -- Active - bit
			@PracticeID , -- PracticeID - int
			impCase.chartnumber  , -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.[_import_2_1_CaseInformation] AS impCase
INNER JOIN dbo.PatientCase pc ON 
	CAST(impCase.chartnumber AS VARCHAR) = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	impCase.primaryinsurancecompany = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
WHERE impcase.primarypolicynumber <> ''
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
			HolderFirstName,
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
			2 , -- Precedence - int
			impCase.secondarypolicynumber , -- PolicyNumber - varchar(32)
			impCase.secondarygroupnumber , -- GroupNumber - varchar(32)
			CASE impCase.secondaryinsuredrelationship WHEN 'Child' THEN 'C'
													WHEN 'Other' THEN 'O'
													WHEN 'Self' THEN 'S'
													WHEN 'Spouse' THEN 'U'
													ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
			CASE WHEN impCase.secondaryinsuredrelationship = 'Self' THEN ''
				ELSE impCase.secondaryinsured END , 
			GETDATE() , -- CreatedDate - datetime 
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			1 , -- Active - bit
			@PracticeID , -- PracticeID - int
			impCase.chartnumber , -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.[_import_2_1_CaseInformation] AS impCase
INNER JOIN dbo.PatientCase pc ON 
	CAST(impCase.chartnumber AS VARCHAR) = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	impCase.secondaryinsurancecompany = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
WHERE impcase.secondarypolicynumber <> ''
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
			HolderFirstName,
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
			3 , -- Precedence - int
			impCase.tertiarypolicynumber , -- PolicyNumber - varchar(32)
			impCase.tertiarygroupnumber , -- GroupNumber - varchar(32)
			CASE impCase.tertiaryinsuredrelationship WHEN 'Child' THEN 'C'
													WHEN 'Other' THEN 'O'
													WHEN 'Self' THEN 'S'
													WHEN 'Spouse' THEN 'U'
													ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
			CASE WHEN impCase.tertiaryinsuredrelationship = 'Self' THEN ''
				ELSE impCase.tertiaryinsured END , 
			GETDATE() , -- CreatedDate - datetime 
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			1 , -- Active - bit
			@PracticeID , -- PracticeID - int
			impCase.chartnumber , -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.[_import_2_1_CaseInformation] AS impCase
INNER JOIN dbo.PatientCase pc ON 
	CAST(impCase.chartnumber AS VARCHAR) = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	impCase.tertiaryinsurancecompany = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
WHERE impcase.tertiarypolicynumber <> ''
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