--USE superbill_49184_dev
USE superbill_49184_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @VendorImportID INT
SET @VendorImportID = 2

DECLARE @NIMCDEMOS10 INT

SET @NIMCDEMOS10 = 10

SET NOCOUNT ON

-- temp table to select distinct ins co records from all import tables

CREATE TABLE #tempins (PayerName VARCHAR(128) , PayerID VARCHAR(50) , PayerAddress1 VARCHAR(256) , PayerCity VARCHAR(128) ,
					   PayerState VARCHAR(2) , PayerZipCode VARCHAR(9) , PayerPhone VARCHAR(10))

INSERT INTO #tempins
        ( PayerName ,
          PayerID ,
          PayerAddress1 ,
          PayerCity ,
          PayerState ,
          PayerZipCode ,
		  PayerPhone
        )
SELECT DISTINCT
		  primarypayername , -- PayerName - varchar(128)
          primarypayerpayerid + primarypayervmcode , -- PayerID - varchar(50)
          primarypayerpayeraddress , -- PayerAddress1 - varchar(256)
          primarypayerpayercity , -- PayerCity - varchar(128)
          primarypayerpayerstate , -- PayerState - varchar(2)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(primarypayerpayerzipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(primarypayerpayerzipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(primarypayerpayerzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(primarypayerpayerzipcode)
		  ELSE '' END , -- PayerZipCode - varchar(9)
		  dbo.fn_RemoveNonNumericCharacters(primarypayerpayerphone) -- PayerPhone - varchar(10)
FROM dbo.[_import_2_4_NIMCDEMOS10]
LEFT JOIN #tempins ON PayerID = primarypayerpayerid
WHERE PayerName IS NULL AND primarypayername <> '' AND primarypayerpayeraddress <> ''


--- secondary insurance list
INSERT INTO #tempins
        ( PayerName ,
          PayerID ,
          PayerAddress1 ,
          PayerCity ,
          PayerState ,
          PayerZipCode ,
		  PayerPhone
        )
SELECT DISTINCT
		  secondarypayername , -- PayerName - varchar(128)
          secondarypayerpayerid + secondarypayervmcode , -- PayerID - varchar(50)
          secondarypayerpayeraddress , -- PayerAddress1 - varchar(256)
          secondarypayerpayercity , -- PayerCity - varchar(128)
          secondarypayerpayerstate , -- PayerState - varchar(2)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(secondarypayerpayerzipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(secondarypayerpayerzipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(secondarypayerpayerzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(secondarypayerpayerzipcode)
		  ELSE '' END , -- PayerZipCode - varchar(9)
		  dbo.fn_RemoveNonNumericCharacters(secondarypayerpayerphone) -- PayerPhone - varchar(10)
FROM dbo.[_import_2_4_NIMCDEMOS10]
LEFT JOIN #tempins ON PayerID = secondarypayerpayerid + secondarypayervmcode
WHERE PayerName IS NULL AND secondarypayername <> '' AND secondarypayerpayeraddress <> ''

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
		  ReviewCode ,
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
		  i.PayerName ,
          1 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
		  'R' ,
          @NIMCDEMOS10 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          13 ,
          i.PayerID ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM #tempins i
	LEFT JOIN dbo.[InsuranceCompany] ic ON 
		i.PayerID = ic.VendorID
WHERE ic.InsuranceCompanyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          PhoneExt ,
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
          i.PayerAddress1 , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          i.PayerCity , -- City - varchar(128)
          i.PayerState , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.PayerZipCode , -- ZipCode - varchar(9)
          i.PayerPhone , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'R' , -- ReviewCode - char(1)
          ic.CreatedPracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany ic
	INNER JOIN #tempins i ON 
		ic.VendorID = i.PayerID AND
		ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DECLARE @DefaultCollectionCategory INT
SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)

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
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @NIMCDEMOS10 , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          patientfirstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          patientaddress , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          patientcity , -- City - varchar(128)
          patientstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(patientzipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(patientzipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(patientzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(patientzipcode)
		  ELSE '' END , -- ZipCode - varchar(9)
          CASE patientgender WHEN '' THEN 'U' ELSE patientgender END , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(patienthomephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(patienthomephone), 10) ELSE '' END, -- HomePhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(patienthomephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(patienthomephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(patienthomephone))) ,10) ELSE '' END , -- HomePhoneExt - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(patientworkphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(patientworkphone), 10) ELSE '' END , -- WorkPhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(patientworkphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(patientworkphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(patientworkphone))) ,10) ELSE '' END , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(patientdateofbirth) = 1 THEN patientdateofbirth END , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(patientsocialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(patientsocialsecurity), 9) ELSE '' END , -- SSN - char(9)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          patientvm , -- MedicalRecordNumber - varchar(128)
          patientvm , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          @DefaultCollectionCategory , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_2_4_NIMCDEMOS10]
WHERE patientvm <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          ReferringPhysicianID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          AutoAccidentRelatedState ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          CaseNumber ,
          WorkersCompContactInfoID ,
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
          NULL , -- ReferringPhysicianID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          NULL , -- AutoAccidentRelatedState - char(2)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          PracticeID , -- PracticeID - int
          NULL , -- CaseNumber - varchar(128)
          NULL , -- WorkersCompContactInfoID - int
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
WHERE VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
-- Primary insurance policy insert

PRINT ''
PRINT 'Inserting Into Insurance Policy - Primary...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.patcovpripayerpolicy , -- PolicyNumber - varchar(32)
          i.patcovpripayergroup , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.patcovpripayercoverageeffectivedate) = 1 THEN i.patcovpripayercoverageeffectivedate END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.patcovpripayercoverageexpirationdate) = 1 THEN i.patcovpripayercoverageexpirationdate END , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @NIMCDEMOS10 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_4_NIMCDEMOS10] i
	INNER JOIN dbo.PatientCase pc ON 
		i.patientvm = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID AND
        pc.PracticeID = @NIMCDEMOS10
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		i.primarypayerpayerid + i.primarypayervmcode = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
WHERE i.patcovpripayerpolicy <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
-- Secondary insurance policy insert

PRINT ''
PRINT 'Inserting Into Insurance Policy - Secondary...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.patcovsecpayerpolicy , -- PolicyNumber - varchar(32)
          i.patcovsecpayergroup , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.patcovsecpayercoverageeffectivedate) = 1 THEN i.patcovsecpayercoverageeffectivedate END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.patcovsecpayercoverageexpirationdate) = 1 THEN i.patcovsecpayercoverageexpirationdate END , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @NIMCDEMOS10 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_4_NIMCDEMOS10] i
	INNER JOIN dbo.PatientCase pc ON 
		i.patientvm = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID AND
        pc.PracticeID = @NIMCDEMOS10
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		i.secondarypayerpayerid + i.secondarypayervmcode = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
WHERE i.patcovsecpayerpolicy <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11 , Name = 'Self Pay'
FROM dbo.PatientCase pc 
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
		ip.VendorImportID = @VendorImportID
WHERE ip.InsurancePolicyID IS NULL AND pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #tempins

--ROLLBACK
--COMMIT

