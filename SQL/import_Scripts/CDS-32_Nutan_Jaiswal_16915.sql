--USE superbill_16915_dev
USE superbill_16915_prod
GO



BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@Rowcount AS VARCHAR) + ' Insurance Policies deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' +  CAST(@@rowcount AS VARCHAR) + ' Patient Cases deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Patients deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' Doctors deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' InsuranceCompanyPlans deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@rowcount AS VARCHAR) + ' InsuranceCompanys deleted'



PRINT ''
PRINT 'Inserting into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
	      ZipCode ,
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
		  insco.insurancecompany , -- InsuranceCompanyName - varchar(128)
		  insco.address ,
		  '' ,
		  insco.city ,
		  insco.state ,
		  insco.zip ,
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
          insco.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_InsuranceList] InsCo
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '


PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT    ic.InsuranceCompanyName , -- PlanName - varchar(128)
		  ic.AddressLine1 ,
		  ic.AddressLine2 , 
		  ic.City ,
		  ic.STATE ,
		  ic.Zipcode ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany ic
WHERE ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '

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
          DOB ,
          SSN ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleCountry ,
          ResponsibleZipCode ,
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
          PhonecallRemindersEnabled 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.patientfirstname , -- FirstName - varchar(64)
          pat.patientmiddleinitial , -- MiddleName - varchar(64)
          pat.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.patientaddress , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          pat.patientcity , -- City - varchar(128)
          pat.patientstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pat.patientzipcode,'-',''), 9) , -- ZipCode - varchar(9)
          pat.patientgender , -- Gender - varchar(1)
          CASE pat.patientmaritalstatus WHEN 'Married' THEN 'M'
								 WHEN 'Others'  THEN 'S'
								 WHEN 'Divorced' THEN 'D'
								 WHEN 'Widowed' THEN 'W'
								 WHEN 'Single' THEN 'S' END , -- MaritalStatus - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(pat.patienthomephone, '(', ''), ')', ''), '-', ''), 10) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pat.patientworkphone, '(', ''), ')', ''), '-', ''), 10) , -- WorkPhone - varchar(10)
          pat.patientdob , -- DOB - datetime
          LEFT(REPLACE(pat.patientssn, '-', ''), 9) , -- SSN - char(9)
          CASE WHEN relationtoguarantor <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN relationtoguarantor <> '' THEN LEFT(pat.guarantorfirstname, 64) ELSE '' END , -- ResponsibleFirstName - varchar(64)
          '' , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN relationtoguarantor <> '' THEN LEFT(pat.guarantorlastname, 64) ELSE '' END , -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
          CASE WHEN relationtoguarantor <> '' THEN CASE pat.relationtoguarantor WHEN 'Father' THEN 'C'
																				WHEN 'Mother' THEN 'C'
																				WHEN 'Spouse' THEN 'U'
																				WHEN 'Others' THEN 'O'
																				ELSE 'S' END     
												  ELSE '' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN relationtoguarantor <> '' THEN pat.guarantoraddress ELSE '' END , -- ResponsibleAddressLine1 - varchar(256)
          '' , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN relationtoguarantor <> '' THEN pat.guarantorcity ELSE '' END , -- ResponsibleCity - varchar(128)
          CASE WHEN relationtoguarantor <> '' THEN pat.guarantorstate ELSE '' END , -- ResponsibleState - varchar(2)
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN relationtoguarantor <> '' THEN pat.guarantorzipcode ELSE '' END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
		  doc.DoctorID , -- PrimaryProviderID - int
          pat.patientid , -- MedicalRecordNumber - varchar(128)
          LEFT(REPLACE(REPLACE(REPLACE(pat.patientcellphone, '(', ''), ')', ''), '-', ''), 10) , -- MobilePhone - varchar(10)
          pat.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          1  -- PhonecallRemindersEnabled - bit
FROM [_import_2_1_PatientDemographics] pat
LEFT JOIN dbo.Doctor doc ON 
	LEFT(pat.principaldoctor, 6) = LEFT(doc.FirstName, 6) AND
	doc.[External] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '
	
	

PRINT ''
PRINT 'Inserting into PatientCase ...'
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
SELECT    pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat	
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '



PRINT ''
PRINT 'Insert into InsurancePolicy 1...'
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
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.primaryinsurancepolicyid , -- PolicyNumber - varchar(32)
          ip.primaryinsurancegroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ip.primaryinsurancesubscriberrelation = 'SELF' THEN 'S' 
			   WHEN ip.primaryinsurancesubscriberrelation = 'SPOUSE' THEN 'U' 
			   WHEN ip.primaryinsurancesubscriberrelation = 'CHILD' THEN 'C' ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.primaryinsurancesubscriberrelation = 'SELF' THEN ''
			   ELSE ip.primaryinsurancesubscriberfirstname  END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.primaryinsurancesubscriberrelation = 'SELF' THEN ''
			   ELSE ip.primaryinsurancesubscribermiddlename END  , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.primaryinsurancesubscriberrelation = 'SELF' THEN ''
			   ELSE ip.primaryinsurancesubscriberlastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          '' , -- HolderDOB - datetime
          '' , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ip.primaryinsurancepolicyid , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.patientaccountno + 1 , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_Insurance] ip 
INNER JOIN dbo.PatientCase pc ON
	ip.patientid = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.primaryinsurance = icp.PlanName AND
	icp.VendorImportID = @VendorImportID
WHERE ip.primaryinsurancepolicyid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '



PRINT ''
PRINT 'Insert into InsurancePolicy 2...'
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
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.secondaryinsurancepolicyid , -- PolicyNumber - varchar(32)
          ip.secondaryinsurancegroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ip.secondaryinsurancesubscriberrelation = 'SELF' THEN 'S' 
			   WHEN ip.secondaryinsurancesubscriberrelation = 'SPOUSE' THEN 'U' 
			   WHEN ip.secondaryinsurancesubscriberrelation = 'CHILD' THEN 'C' ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.secondaryinsurancesubscriberrelation = 'SELF' THEN ''
			   ELSE ip.secondaryinsurancesubscriberfirstname  END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.secondaryinsurancesubscriberrelation = 'SELF' THEN ''
			   ELSE ip.secondaryinsurancesubscribermiddlename END  , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.secondaryinsurancesubscriberrelation = 'SELF' THEN ''
			   ELSE ip.secondaryinsurancesubscriberlastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          '' , -- HolderDOB - datetime
          '' , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ip.secondaryinsurancepolicyid , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.patientaccountno + 2 , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_Insurance] ip 
INNER JOIN dbo.PatientCase pc ON
	ip.patientid = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.secondaryinsurance = icp.PlanName AND
	icp.VendorImportID = @VendorImportID
WHERE ip.secondaryinsurancepolicyid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '



PRINT ''
PRINT 'Insert into InsurancePolicy 3...'
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
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int 
		  icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          ip.tertiaryinsurancepolicyid , -- PolicyNumber - varchar(32)
          ip.tertiaryinsurancegroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ip.tertiaryinsurancesubscriberrelation = 'SELF' THEN 'S' 
			   WHEN ip.tertiaryinsurancesubscriberrelation = 'SPOUSE' THEN 'U' 
			   WHEN ip.tertiaryinsurancesubscriberrelation = 'CHILD' THEN 'C' ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.tertiaryinsurancesubscriberrelation = 'SELF' THEN ''
			   ELSE ip.tertiaryinsurancesubscriberfirstname  END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.tertiaryinsurancesubscriberrelation = 'SELF' THEN ''
			   ELSE ip.tertiaryinsurancesubscribermiddlename END  , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.tertiaryinsurancesubscriberrelation = 'SELF' THEN ''
			   ELSE ip.tertiaryinsurancesubscriberlastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          '' , -- HolderDOB - datetime
          '' , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ip.tertiaryinsurancepolicyid , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.patientaccountno + 3 , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_Insurance] ip 
INNER JOIN dbo.PatientCase pc ON
	ip.patientid = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.tertiaryinsurance = icp.PlanName AND
	icp.VendorImportID = @VendorImportID
WHERE ip.tertiaryinsurancepolicyid <> '' AND
	 ip.AutoTempID <> 4763	 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '



COMMIT