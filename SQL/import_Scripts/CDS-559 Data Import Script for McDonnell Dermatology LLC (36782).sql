USE superbill_36782_dev
--USE superbill_36782_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
*/

PRINT ''
PRINT 'Insert Into Insurance Company Plane 1 of 2...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , 
	Phone , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	icp.insurancename  , -- PlanName - varchar(128)
	LEFT(ICP.insuranceAddress1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.insuranceAddress2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.insuranceCity,128) , -- City - varchar(128)
	LEFT(ICP.[insuranceState],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.insurancezipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.insurancezipcode)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.insurancezipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.insurancezipcode)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.insurancephone),10) , -- Phone - varchar(10)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insurancename,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo._import_1_1_InsuranceList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.insurancename = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	IICL.insurancename  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
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
	LEFT(IICL.insurancename, 50) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_1_1_InsuranceList AS IICL
WHERE insurancename <> '' AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.insurancename AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan 2 of 2...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode ,  
	Phone , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	icp.insurancename  , -- PlanName - varchar(128)
	LEFT(ICP.insuranceAddress1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.insuranceAddress2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.insuranceCity,128) , -- City - varchar(128)
	LEFT(ICP.[insuranceState],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.insurancezipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.insurancezipcode)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.insurancezipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.insurancezipcode)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.insurancephone),10) , -- Phone - varchar(10)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	LEFT(insurancename,50),  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo._import_1_1_InsuranceList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.insurancename, 50) AND
	ICP.insurancename = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.insurancename = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient...'
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
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          FirstName ,
          MiddleName ,
          LastName ,
          '' ,
          Address1 ,
          Address2 ,
          City ,
          [State] ,
          '' ,
		  LEFT(CASE 
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zipcode)
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(zipcode)
		  ELSE '' END,9)   ,
          gender ,
          '' ,
          HomePhone ,
          CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(workphone),10)
		  ELSE '' END ,
		  CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(workphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(homephone))),10)
		  ELSE NULL END ,
          CASE WHEN ISDATE(birthdate) = 1 THEN birthdate ELSE NULL END ,
          CASE WHEN LEN(SSN) >= 6 THEN RIGHT('000' + ssn, 9) ELSE '' END ,
          email ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          1 ,
          mrn ,
          LEFT(mobile,10) ,
          mrn ,
          @VendorImportID ,
          1 ,
          1 ,
          0 ,
          0 
FROM dbo.[_import_1_1_PatientDemographics]
WHERE mrn <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case..'
INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	PAT.PatientID , -- PatientID - int
	'Default Case' , -- Name - varchar(128)
	1 , -- Active - bit
	5 , -- PayerScenarioID - int
	NULL , -- ReferringPhysicianID - int
	0 , -- EmploymentRelatedFlag - bit
	0, -- AutoAccidentRelatedFlag - bit
	0, -- OtherAccidentRelatedFlag - bit
	0, -- AbuseRelatedFlag - bit
	NULL , -- AutoAccidentRelatedState - char(2)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	1 , -- ShowExpiredInsurancePolicies - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- PracticeID - int
	NULL , -- CaseNumber - varchar(128)
	NULL , -- WorkersCompContactInfoID - int
	PAT.VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.[_import_1_1_PatientDemographics] pd
	INNER JOIN dbo.Patient AS PAT ON VendorImportID = @VendorImportID AND VendorID = pd.mrn
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Policies...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Copay ,
          Deductible ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.precedence , -- Precedence - int
          i.insurancesubscriberid , -- PolicyNumber - varchar(32)
          i.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.effectivedate) = 1 THEN i.effectivedate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.terminationdate) = 1 THEN i.terminationdate ELSE NULL END , -- PolicyEndDate - datetime
          1 , -- CardOnFile - bit
          CASE i.insuredrelationshiptopatient WHEN 'Spouse' THEN 'U' WHEN 'Other' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN i.insuredfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN i.insuredmiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN i.insuredlastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN CASE WHEN ISDATE(i.insuredbirthdate) = 1 THEN i.insuredbirthdate ELSE NULL END ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN i.insuredssn END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN CASE WHEN i.insuredgender = '' THEN 'U' ELSE i.insuredgender END END , -- HolderGender - char(1)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN i.insuredaddress1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN i.insuredaddress2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN i.insuredcity END , -- HolderCity - varchar(128)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN i.insuredstate END , -- HolderState - varchar(2)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN LEFT(CASE 
																		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.insuredzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.insuredzipcode)
																		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.insuredzipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.insuredzipcode)
																  ELSE '' END,9)  END  , -- HolderZipCode - varchar(9)
          CASE WHEN i.insuredrelationshiptopatient <> 'Self' THEN i.insurancesubscriberid END , -- DependentPolicyNumber - varchar(32)
          i.copay , -- Copay - money
          i.deductible , -- Deductible - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID + i.insurancesubscriberid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname,14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_PatientInsurances] i
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = i.mrn AND
        pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorID = LEFT(i.insurancename,50) AND
        icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Cases...'
UPDATE dbo.PatientCase SET Name = 'Self Pay' , PayerScenarioID = 11 
FROM dbo.PatientCase pc
LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND pc.VendorImportID = @VendorImportID
WHERE ip.PatientCaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



--ROLLBACK
--COMMIT





