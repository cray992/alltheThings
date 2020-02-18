--USE superbill_18783_dev
USE superbill_18783_prod
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
			ins.insaddl1 ,
			ins.insaddl2 ,
			ins.insaddcity ,
			ins.insaddstate ,
			ins.insaddzip ,
			ins.insaddphone ,
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
			ins.AutoTempID , -- VendorID - varchar(50)
			@VendorImportID , -- VendorImportID - int
			1 , -- NDCFormat - int
			1 , -- UseFacilityID - bit
			'U' , -- AnesthesiaType - varchar(1)
			18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceList] AS ins
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
			icp.insuredplanname , -- PlanName - varchar(128)
			icp.insaddl1 ,
			icp.insaddl2 ,
			icp.insaddcity ,
			icp.insaddstate ,
			icp.insaddzip ,
			icp.insaddphone ,
			GETDATE() , -- CreatedDate - datetime
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			@PracticeID , -- CreatedPracticeID - int
			ic.InsuranceCompanyID , -- InsuranceCompanyID - int
			icp.AutoTempID , -- VendorID - varchar(50)
			@VendorImportID  -- VendorImportID - int       
FROM dbo.[_import_1_1_InsuranceList] icp
INNER JOIN dbo.InsuranceCompany ic ON
	icp.AutoTempID = ic.VendorID AND
	ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Patient ...'
INSERT INTO dbo.Patient
        ( 
			PracticeID ,
			Prefix ,
			FirstName ,
			MiddleName ,
			LastName ,
			Suffix ,
			AddressLine1 ,
			City ,
			State ,
			ZipCode ,
			Country,
			Gender ,
			DOB ,
			MaritalStatus ,
			HomePhone ,
			WorkPhone ,
			EmailAddress ,
			SSN ,
			CreatedDate ,
			CreatedUserID ,
			ModifiedDate ,
			ModifiedUserID ,
			MedicalRecordNumber ,
			VendorID ,
			VendorImportID ,
			Active ,
			SendEmailCorrespondence ,
			PhonecallRemindersEnabled 
        )  
SELECT DISTINCT   
			@PracticeID , -- PracticeID - int
			'' , -- Prefix - varchar(16)
			[first] , -- FirstName - varchar(64)
			[middle] , -- MiddleName - varchar(64)
			[last] , -- LastName - varchar(64)
			'' , -- Suffix - varchar(16)
			[patientaddress] , -- AddressLine1 - varchar(256)
			[city] , -- City - varchar(128)
			[state] , -- State - varchar(2)
			LEFT(REPLACE([zip], '-', ''), 9) , -- ZipCode - varchar(9)
			'' , -- Country
			[gender] , -- Gender - varchar(1)
			[birthdate] ,
			[maritalstatus] ,
			LEFT(REPLACE(REPLACE(REPLACE(REPLACE([phone], ' ', ''), '(', ''), ')', ''), '-', ''), 10), -- HomePhone - varchar(10)
			LEFT(REPLACE(REPLACE(REPLACE(REPLACE([workphone], ' ', ''), '(', ''), ')', ''), '-', ''), 10), -- HomePhone - varchar(10)
			[email] ,
			REPLACE([ssn], '-', '') , -- SSN - char(9)
			GETDATE() , -- CreatedDate - datetime
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			[patientid] , -- MedicalRecordNumber
			[patientid] , -- VendorID - varchar(50)
			@VendorImportID , -- VendorImportID - int
			1 , -- Active - bit
			0 , -- SendEmailCorrespondence - bit
			1  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_1_1_PatientDemographics] 
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
			PAT.VendorID, -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.Patient PAT  
WHERE VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT''
PRINT'Inserting into Insurance Policy 1...'
INSERT INTO dbo.InsurancePolicy
        ( 
			PatientCaseID ,
			InsuranceCompanyPlanID ,
			Precedence ,
			PolicyNumber ,
			GroupNumber ,
			Notes ,
			Copay ,
			PatientRelationshipToInsured ,
			HolderFirstName ,
			HolderMiddleName ,
			HolderLastName ,
			HolderAddressLine1 ,
			HolderAddressLine2 ,
			HolderCity ,
			HolderState ,
			HolderZipCode ,
			HolderPhone ,
			HolderDOB ,
			DependentPolicyNumber ,
			CreatedDate ,
			CreatedUserID ,
			ModifiedDate ,
			ModifiedUserID ,
			Active ,
			PracticeID ,
			VendorID ,
			VendorImportID
        )
SELECT  distinct  
			pc.PatientCaseID , -- PatientCaseID - int
			icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
			1 , -- Precedence - int
			ip.insuredidno , -- PolicyNumber - varchar(32)
			ip.insuredgroupno ,
			ip.insurace1notes ,
			ip.copay ,
			CASE WHEN ip.patientrel = 1 THEN 'S'
				 WHEN ip.patientrel = 2 THEN 'U'
				 WHEN ip.patientrel = 3 THEN 'C'
				 ELSE 'O' END  , -- PatientRelationshipToInsured - varchar(1)
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insuredfirstname END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insuredmiddleinitial END ,	
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insuredlastname END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insaddl1 END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insaddl2 END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insaddcity END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insaddstate END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insaddzip END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insaddphone END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insuredsdob END ,
			ip.insuredidno ,
			GETDATE() , -- CreatedDate - datetime
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			1 , -- Active - bit
			@PracticeID , -- PracticeID - int
			ip.patientid + 1, -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemographics] AS ip
INNER JOIN dbo.PatientCase AS pc ON 
	pc.vendorID = ip.patientid AND
	pc.VendorImportID = @VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON 
	icp.planname = ip.insuredplanname AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT''
PRINT'Inserting into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( 
			PatientCaseID ,
			InsuranceCompanyPlanID ,
			Precedence ,
			PolicyNumber ,
			GroupNumber ,
			Notes ,
			Copay ,
			PatientRelationshipToInsured ,
			HolderFirstName ,
			HolderMiddleName ,
			HolderLastName ,
			HolderAddressLine1 ,
			HolderAddressLine2 ,
			HolderCity ,
			HolderState ,
			HolderZipCode ,
			HolderPhone ,
			HolderDOB ,
			DependentPolicyNumber ,
			CreatedDate ,
			CreatedUserID ,
			ModifiedDate ,
			ModifiedUserID ,
			Active ,
			PracticeID ,
			--VendorID ,
			VendorImportID
        )
SELECT  distinct  
			pc.PatientCaseID , -- PatientCaseID - int
			icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
			2 , -- Precedence - int
			ip.insuredidno2 , -- PolicyNumber - varchar(32)
			ip.insuredgroupno2 ,
			ip.insurance2notes ,
			ip.copay2 ,
			CASE WHEN ip.patientrel = 1 THEN 'S'
				 WHEN ip.patientrel = 2 THEN 'U'
				 WHEN ip.patientrel = 3 THEN 'C'
				 ELSE 'O' END  , -- PatientRelationshipToInsured - varchar(1)
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insuredfirstname2 END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insuredmiddleinitial2 END ,	
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insuredlastname2 END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.ins2addl1 END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.ins2addl2 END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.ins2addcity END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.ins2addstate END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.ins2addzip END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.ins2addphone END ,
			CASE WHEN ip.patientrel <> 1 THEN 
				ip.insureds2dob END ,
			ip.insuredidno2 , 
			GETDATE() , -- CreatedDate - datetime
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			1 , -- Active - bit
			--ip.insuredidno2 ,
			@PracticeID , -- PracticeID - int
			--ip.patientid + 1, -- VendorID - varchar(50)
			@VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemographics] AS ip
INNER JOIN dbo.PatientCase AS pc ON 
	pc.vendorID = ip.patientid AND
	pc.VendorImportID = @VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON 
	icp.planname = ip.insuredplanname2 AND
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