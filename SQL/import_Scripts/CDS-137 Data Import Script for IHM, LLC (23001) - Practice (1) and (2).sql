USE superbill_23001_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @PracticeID2 INT
DECLARE @VendorImportID INT
 

SET @PracticeID = 1
SET @PracticeID2 = 2
SET @VendorImportID = 7

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in detination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID2 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID2 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID2 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID2 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'

PRINT ''
PRINT 'Updating Insurance Import Sheet VendorID...'
UPDATE dbo.[_import_7_2_Ins]
SET chgpriinscode = 6
WHERE chgpriinscode = '0006'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Referring Doctor for Practice 1...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
		  Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          City ,
          [State] ,
          ZipCode ,
          WorkPhone ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
		  '' , -- Prefix
          imp.firstname , -- FirstName - varchar(64)
          imp.middlename , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          imp.suffx , -- Suffix - varchar(16)
          imp.referringphysaddline2 , -- AddressLine1 - varchar(256)
          imp.referringphyscity , -- City - varchar(128)
          imp.[referringphysstate] , -- State - varchar(2)
          imp.displayedreferringphyszip , -- ZipCode - varchar(9)
          imp.phone , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          REPLACE(imp.degree,' ','') , -- Degree - varchar(8)
          imp.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          imp.fax , -- FaxNumber - varchar(10)
          1 , -- External - bit
          imp.referringphysnpi  -- NPI - varchar(10)
FROM dbo.[_import_7_2_Referring] imp
WHERE imp.firstname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Referring Doctor for Practice 2...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
		  Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          City ,
          [State] ,
          ZipCode ,
          WorkPhone ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI )
SELECT DISTINCT
		  @PracticeID2 , -- PracticeID - int
		  '' , -- Prefix
          imp.firstname , -- FirstName - varchar(64)
          imp.middlename , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          imp.suffx , -- Suffix - varchar(16)
          imp.referringphysaddline2 , -- AddressLine1 - varchar(256)
          imp.referringphyscity , -- City - varchar(128)
          imp.[referringphysstate] , -- State - varchar(2)
          imp.displayedreferringphyszip , -- ZipCode - varchar(9)
          imp.phone , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          REPLACE(imp.degree,' ','') , -- Degree - varchar(8)
          imp.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          imp.fax , -- FaxNumber - varchar(10)
          1 , -- External - bit
          imp.referringphysnpi  -- NPI - varchar(10)
FROM dbo.[_import_7_2_Referring] imp
WHERE imp.firstname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
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
		  ReviewCode
        )
SELECT DISTINCT
		  imp.name , -- InsuranceCompanyName - varchar(128)
          imp.addr , -- AddressLine1 - varchar(256)
          imp.addr2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          imp.zip , -- ZipCode - varchar(9)
          imp.insareacodephone , -- Phone - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          CASE imp.chgpriinsclassdesc WHEN 'COMMERCIAL' THEN 'CI'
									  WHEN 'BCBS' THEN 'BL'
									  WHEN 'WORK/COMP' THEN 'WC'
									  WHEN 'MEDICARE' THEN 'MB'
									  ELSE 'CI' END  , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          imp.chgpriinscode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          '' , -- DefaultAdjustmentCode - varchar(10)
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U'  -- AnesthesiaType - varchar(1)
		  'R'  -- ReviewCode - char(1)
FROM dbo.[_import_7_2_Ins] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReviewCode ,
          CreatedPracticeID ,
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
          '' , -- Country - varchar(32)
          ic.ZipCode , -- ZipCode - varchar(9)
          ic.Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'R' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany ic
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Patient for Practice 1...'
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
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
		  SendEmailCorrespondence
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
		  CASE WHEN imp.patrefphysicianname <> '' THEN doc.DoctorID ELSE NULL END , --ReferringPhysicianID
          '' , -- Prefix - varchar(16)
          imp.ptfirstname , -- FirstName - varchar(64)
          imp.ptmi , -- MiddleName - varchar(64)
          imp.ptlastname , -- LastName - varchar(64)
          imp.suffix , -- Suffix - varchar(16)
          imp.addline1 , -- AddressLine1 - varchar(256)
          imp.addline2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          imp.zipcode , -- ZipCode - varchar(9)
          imp.patsex , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          imp.pthomephone , -- HomePhone - varchar(10)
          imp.patdateofbirth , -- DOB - datetime
          imp.patsocialsecuritynumber , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          imp.ptmobilephone , -- MobilePhone - varchar(10)
          imp.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
		  0 -- SendEmailCorrespondence
FROM dbo.[_import_7_2_PatientDemoIns] imp
LEFT JOIN dbo.Doctor doc ON 
	doc.FirstName = imp.patrefphysicianname AND
	doc.MiddleName = imp.patrefmiddlename AND
	doc.LastName = imp.patreflastname AND
	VendorImportID = @VendorImportID AND
	PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient for Practice 2...'
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
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
		  SendEmailCorrespondence
        )
SELECT DISTINCT
		  @PracticeID2 , -- PracticeID - int
		  CASE WHEN imp.patrefphysicianname <> '' THEN doc.DoctorID ELSE NULL END , --ReferringPhysicianID
          '' , -- Prefix - varchar(16)
          imp.ptfirstname , -- FirstName - varchar(64)
          imp.ptmi , -- MiddleName - varchar(64)
          imp.ptlastname , -- LastName - varchar(64)
          imp.suffix , -- Suffix - varchar(16)
          imp.addline1 , -- AddressLine1 - varchar(256)
          imp.addline2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          imp.zipcode , -- ZipCode - varchar(9)
          imp.patsex , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          imp.pthomephone , -- HomePhone - varchar(10)
          imp.patdateofbirth , -- DOB - datetime
          imp.patsocialsecuritynumber , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          imp.ptmobilephone , -- MobilePhone - varchar(10)
          imp.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
		  0 -- SendEmailCorrespondence
FROM dbo.[_import_7_2_PatientDemoIns] imp
LEFT JOIN dbo.Doctor doc ON 
	doc.FirstName = imp.patrefphysicianname AND
	doc.MiddleName = imp.patrefmiddlename AND
	doc.LastName = imp.patreflastname AND
	VendorImportID = @VendorImportID AND
	PracticeID = @PracticeID2
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into PatientCase for Practice 1...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag
        )
SELECT DISTINCT
	      PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          'Created via Data Import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient
WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into PatientCase for Practice 2...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag
        )
SELECT DISTINCT
	      PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          'Created via Data Import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID2 , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient
WHERE PracticeID = @PracticeID2 and VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Insurance Policy 1 for Practice 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imp.regpriinspolicynumber , -- PolicyNumber - varchar(32)
          imp.regpriinsgroupnumber , -- GroupNumber - varchar(32)
	      CASE imp.regpriinssubrelationdescription WHEN 'Self' THEN 'S'
												   WHEN 'Child' THEN 'C'
												   WHEN 'Other' THEN 'O'
												   WHEN 'Spouse' THEN 'U'
												   ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubfirstname END , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssublastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubdateofbirth END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubaddline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubaddline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubcity END , -- HolderCity - varchar(128)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubstate END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubzipcode END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinspolicynumber END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_7_2_PatientDemoIns] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.AutoTempID AND
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.regpriinscode AND
	icp.VendorImportID = @VendorImportID
WHERE imp.regpriinscode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Insurance Policy 1 for Practice 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imp.regpriinspolicynumber , -- PolicyNumber - varchar(32)
          imp.regpriinsgroupnumber , -- GroupNumber - varchar(32)
	      CASE imp.regpriinssubrelationdescription WHEN 'Self' THEN 'S'
												   WHEN 'Child' THEN 'C'
												   WHEN 'Other' THEN 'O'
												   WHEN 'Spouse' THEN 'U'
												   ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubfirstname END , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssublastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubdateofbirth END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubaddline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubaddline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubcity END , -- HolderCity - varchar(128)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubstate END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinssubzipcode END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.regpriinssubrelationdescription <> 'Self' THEN imp.regpriinspolicynumber END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID2 , -- PracticeID - int
          imp.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_7_2_PatientDemoIns] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.AutoTempID AND
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID2
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.regpriinscode AND
	icp.VendorImportID = @VendorImportID
WHERE imp.regpriinscode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into Insurance Policy 2 for Practice 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imp.regsecinspolicynumber , -- PolicyNumber - varchar(32)
          imp.regsecinsgroupnumber , -- GroupNumber - varchar(32)
	      CASE imp.regsecinssubrelationdescription WHEN 'Self' THEN 'S'
												   WHEN 'Child' THEN 'C'
												   WHEN 'Other' THEN 'O'
												   WHEN 'Spouse' THEN 'U'
												   ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubfirstname END , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssublastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubdateofbirth END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubaddline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubaddline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubcity END , -- HolderCity - varchar(128)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubstate END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubzipcode END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinspolicynumber END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_7_2_PatientDemoIns] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.AutoTempID AND
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.regsecinscode AND
	icp.VendorImportID = @VendorImportID
WHERE imp.regsecinscode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Insurance Policy 2 for Practice 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imp.regsecinspolicynumber , -- PolicyNumber - varchar(32)
          imp.regsecinsgroupnumber , -- GroupNumber - varchar(32)
	      CASE imp.regsecinssubrelationdescription WHEN 'Self' THEN 'S'
												   WHEN 'Child' THEN 'C'
												   WHEN 'Other' THEN 'O'
												   WHEN 'Spouse' THEN 'U'
												   ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubfirstname END , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssublastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubdateofbirth END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubaddline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubaddline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubcity END , -- HolderCity - varchar(128)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubstate END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinssubzipcode END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.regsecinssubrelationdescription <> 'Self' THEN imp.regsecinspolicynumber END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID2 , -- PracticeID - int
          imp.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_7_2_PatientDemoIns] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.AutoTempID AND
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID2
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.regsecinscode AND
	icp.VendorImportID = @VendorImportID
WHERE imp.regsecinscode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT 



