USE superbill_38686_dev
--USE superbill_38686_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR)
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'

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
		  MobilePhone ,
          EmailAddress ,
		  DOB ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          DefaultServiceLocationID ,
		  PrimaryProviderID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
		  MedicalRecordNumber
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
		  '' ,
          i.patientfirstname ,
          i.patientmiddleinitial ,
          i.patientLastName ,
          '' ,
          i.address1 ,
          i.Address2 ,
          i.City ,
          i.Statecode ,
          '' ,
          i.zipcode ,
          CASE i.gender WHEN 'Female' THEN 'F' WHEN 'Male' THEN 'M' ELSE 'U' END ,
          CASE i.maritalstatus WHEN 'Domestic Partner' THEN 'T' WHEN 'Married' THEN 'M' WHEN 'Single' THEN 'S' WHEN 'Widowed' THEN 'W' WHEN 'Single' THEN 'S' ELSE '' END,
          dbo.fn_RemoveNonNumericCharacters(i.primaryphone) ,
		  dbo.fn_RemoveNonNumericCharacters(i.secondaryphone) ,
          i.email ,
		  i.dob ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CASE i.employmentstatus WHEN 'Employed' THEN 'E' WHEN 'Retired' THEN 'R' ELSE 'U' END ,
          1 ,
          1 ,
		  i.chartnumber ,
          @VendorImportID ,
          1 ,
          1 ,
          0 ,
          0 ,
          i.emergencycontactname ,
		  i.chartnumber
FROM dbo.[_import_1_1_Patientsc902c1ba0873429ebf9] i
WHERE i.exisitingpatientid = '#N/A'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	p.PatientID , -- PatientID - int
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
	0, -- ShowExpiredInsurancePolicies - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- PracticeID - int
	NULL , -- CaseNumber - varchar(128)
	NULL , -- WorkersCompContactInfoID - int
	p.VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient p 
INNER JOIN dbo.[_import_1_1_Patientsc902c1ba0873429ebf9] i ON
	i.patientfirstname = p.FirstName AND i.patientlastname = p.LastName AND DATEADD(hh,12,CAST(i.dob AS DATETIME)) = p.DOB	
WHERE p.PracticeID = @PracticeID AND i.defaultpayer <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          InstitutionalBillingFormID ,
		  Notes
        )
SELECT DISTINCT		  
		  i.defaultpayer , -- InsuranceCompanyName - varchar(128)
          1 , -- EClaimsAccepts - bit
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
          i.defaultpayer , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  ,-- InstitutionalBillingFormID - int
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import.'
FROM dbo.[_import_1_1_Patientsc902c1ba0873429ebf9] i
WHERE i.defaultpayer <> '' AND i.membernumber <> '' AND NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE i.defaultpayer = ic.InsuranceCompanyName)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID ,
		  Notes
        )
SELECT 
		  InsuranceCompanyName ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          @PracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          @VendorImportID ,
		  Notes
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 1 of 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
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
          1 , -- Precedence - int
          i.membernumber , -- PolicyNumber - varchar(32)
          i.groupnumber ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 ,
          @PracticeID ,
          pc.VendorID + i.membernumber ,
          @VendorImportID ,
          LEFT(i.groupname ,14) ,
          'Y' 
FROM dbo.[_import_1_1_Patientsc902c1ba0873429ebf9] i
INNER JOIN dbo.Patient p ON 
	i.patientfirstname = p.FirstName AND i.patientlastname = p.LastName AND DATEADD(hh,12,CAST(i.dob AS DATETIME)) = p.DOB
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.defaultpayer = icp.PlanName
WHERE NOT EXISTS (SELECT * FROM dbo.InsurancePolicy ip WHERE pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2 of 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
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
          2 , -- Precedence - int
          i.secondarymembernumber , -- PolicyNumber - varchar(32)
          i.secondarygroupnumber ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 ,
          @PracticeID ,
          pc.VendorID + i.membernumber ,
          @VendorImportID ,
          LEFT(i.secondarygroupname ,14) ,
          'Y' 
FROM dbo.[_import_1_1_Patientsc902c1ba0873429ebf9] i
INNER JOIN dbo.Patient p ON 
	i.patientfirstname = p.FirstName AND i.patientlastname = p.LastName AND DATEADD(hh,12,CAST(i.dob AS DATETIME)) = p.DOB
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.defaultsecondarypayer = icp.PlanName
WHERE NOT EXISTS (SELECT * FROM dbo.InsurancePolicy ip WHERE pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 2)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
 

--ROLLBACK
--COMMIT