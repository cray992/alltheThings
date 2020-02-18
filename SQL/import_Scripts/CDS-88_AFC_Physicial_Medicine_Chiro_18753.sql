--USE superbill_18753_dev
USE superbill_18753_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in detination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


PRINT ''
PRINT 'Inserting into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
		  Country ,
          ZipCode ,
          Phone ,
		  PhoneExt ,
          BillSecondaryInsurance ,
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
          VendorID ,
          VendorImportID ,
		  ContactFirstName ,
		  ContactLastName
        )
SELECT DISTINCT
		  name , -- InsuranceCompanyName - varchar(128)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state , 2) , -- State - varchar(2)
		  Country , -- Country
          LEFT(zip , 9) , -- ZipCode - varchar(9)
          LEFT(phone , 10) , -- Phone - varchar(10)
		  PhoneExt , -- PhoneExt
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          'R' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
		  ContactFirstName , -- ContactFirstName
		  ContactLastName -- ContactLastName 
FROM dbo.[_import_3_2_InsuranceList]
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Insurance Company Plan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactFirstName ,
          ContactLastName ,
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
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          Country , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          ContactFirstName , -- ContactFirstName - varchar(64)
          ContactLastName , -- ContactLastName - varchar(64)
          Phone , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'R' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          City ,
          State ,
          ZipCode ,
          Gender ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PrimaryProviderID ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pd1.firstname , -- FirstName - varchar(64)
          pd1.middlename , -- MiddleName - varchar(64)
          pd1.lastname , -- LastName - varchar(64)
          pd1.suffix , -- Suffix - varchar(16)
          pd1.address1 , -- AddressLine1 - varchar(256)
          pd1.city , -- City - varchar(128)
          pd2.state , -- State - varchar(2)
          pd2.zip , -- ZipCode - varchar(9)
          CASE pd3.sex WHEN 'F' THEN 'F'
					   WHEN 'M' THEN 'M'
					   ELSE 'U' END , -- Gender - varchar(1)
          LEFT(pd2.homephone , 10) , -- HomePhone - varchar(10)
          LEFT(pd2.workphone , 10) , -- WorkPhone - varchar(10)
          CASE WHEN pd3.birthdate = '01/01/1111' THEN NULL ELSE pd3.birthdate END , -- DOB - datetime
          pd3.socialsecurity , -- SSN - char(9)
          pd4.email , -- EmailAddress - varchar(256)
          CASE pd3.guarantortype WHEN 'S' THEN '0'
								 WHEN 'P' THEN '1'
								 ELSE '0' END , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pd3.guarantortype = 'P' THEN guar1.firstname ELSE '' END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN pd3.guarantortype = 'P' THEN guar1.middlename ELSE '' END, -- ResponsibleMiddleName - varchar(64)
          CASE WHEN pd3.guarantortype = 'P' THEN guar1.lastname ELSE '' END, -- ResponsibleLastName - varchar(64)
          CASE WHEN pd3.guarantortype = 'P' THEN guar1.suffix ELSE '' END , -- ResponsibleSuffix - varchar(16)
          CASE pd3.guarantortype WHEN 'S' THEN 'S'
								 WHEN 'P' THEN 'O'
								 ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN pd3.guarantortype = 'P' THEN guar1.address1 ELSE '' END, -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN pd3.guarantortype = 'P' THEN guar1.city ELSE '' END, -- ResponsibleCity - varchar(128)
          CASE WHEN pd3.guarantortype = 'P' THEN guar2.state ELSE '' END, -- ResponsibleState - varchar(2)
          CASE WHEN pd3.guarantortype = 'P' THEN  guar2.zip ELSE '' END, -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          doc.DoctorID , -- PrimaryProviderID - int
          pd1.patientid , -- MedicalRecordNumber - varchar(128)
          LEFT(pd2.mobilephone , 10) , -- MobilePhone - varchar(10)
          doc.DoctorID , -- PrimaryCarePhysicianID - int
          pd1.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_3_2_PatientDemographics1] AS pd1
INNER JOIN dbo.[_import_3_2_PatientDemographics2] AS pd2 ON
	pd2.patientcode = pd1.patientid
INNER JOIN dbo.[_import_3_2_PatientDemographics3] AS pd3 ON
	pd3.patientcode = pd1.patientid
INNER JOIN dbo.[_import_3_2_PatientDemographics4] AS pd4 ON
	pd4.patientcode = pd1.patientid
INNER JOIN dbo.[_import_3_2_PatientDemographics1] AS guar1 ON
	guar1.patientid = pd3.guarantorcode
INNER JOIN dbo.[_import_3_2_PatientDemographics2] AS guar2 ON
	guar2.patientcode = pd3.guarantorcode
LEFT JOIN dbo.Doctor AS doc ON
	doc.LastName = pd2.provider AND
	doc.ActiveDoctor = 1 AND
	doc.[External] = 0 AND  
	doc.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Case...'
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
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please review before use' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Policy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
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
          HolderGender ,
          HolderAddressLine1 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderPhone ,
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
          pp.priminsid , -- PolicyNumber - varchar(32)
          pp.priminsgroup , -- GroupNumber - varchar(32)
          CASE pp.primresprelationship WHEN 'P' THEN 'C'
									   WHEN 'S' THEN 'U'
									   WHEN 'M' THEN 'S'
									   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN pp.primresprelationship <> 'S' THEN pd1.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN pp.primresprelationship <> 'S' THEN pd1.middlename END, -- HolderMiddleName - varchar(64)
          CASE WHEN pp.primresprelationship <> 'S' THEN pd1.lastname END, -- HolderLastName - varchar(64)
          CASE WHEN pp.primresprelationship <> 'S' THEN pd1.suffix END, -- HolderSuffix - varchar(16)
          CASE WHEN pd3.birthdate = '01/01/1111' THEN NULL ELSE pd3.birthdate END , -- HolderDOB - datetime
          CASE WHEN pp.primresprelationship <> 'S' THEN pd3.socialsecurity END, -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN pp.primresprelationship <> 'S' THEN CASE pd3.sex WHEN 'F' THEN 'F'
					   WHEN 'M' THEN 'M'
					   ELSE 'U' END END, -- HolderGender - char(1)
          CASE WHEN pp.primresprelationship <> 'S' THEN pd1.address1 END, -- HolderAddressLine1 - varchar(256)
          CASE WHEN pp.primresprelationship <> 'S' THEN pd1.city END, -- HolderCity - varchar(128)
          CASE WHEN pp.primresprelationship <> 'S' THEN pd2.state END, -- HolderState - varchar(2)
          CASE WHEN pp.primresprelationship <> 'S' THEN pd2.zip END, -- HolderZipCode - varchar(9)
          CASE WHEN pp.primresprelationship <> 'S' THEN pd2.homephone END, -- HolderPhone - varchar(10)
          CASE WHEN pp.primresprelationship <> 'S' THEN  pp.priminsid END, -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pp.patientcode , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_2_PrimaryPolicy] AS pp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = pp.patientcode AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = pp.priminsco AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_3_2_PatientDemographics1] AS pd1 ON
	pd1.patientid = pp.primrespparty
INNER JOIN dbo.[_import_3_2_PatientDemographics2] AS pd2 ON
	pd2.patientcode = pp.primrespparty
INNER JOIN dbo.[_import_3_2_PatientDemographics3] AS pd3 ON
	pd3.patientcode = pp.primrespparty
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
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
          HolderGender ,
          HolderAddressLine1 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderPhone ,
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
          sp.secinsid , -- PolicyNumber - varchar(32)
          sp.secinsgroup , -- GroupNumber - varchar(32)
          CASE sp.secresprelationship  WHEN 'P' THEN 'C'
									   WHEN 'S' THEN 'U'
									   WHEN 'M' THEN 'S'
									   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN sp.secresprelationship <> 'S' THEN pd1.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN sp.secresprelationship <> 'S' THEN pd1.middlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN sp.secresprelationship <> 'S' THEN pd1.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN sp.secresprelationship <> 'S' THEN pd1.suffix END , -- HolderSuffix - varchar(16)
          CASE WHEN sp.secresprelationship <> 'S' THEN CASE WHEN pd3.birthdate = '01/01/1111' THEN NULL ELSE pd3.birthdate END END , -- HolderDOB - datetime
          CASE WHEN sp.secresprelationship <> 'S' THEN pd3.socialsecurity END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN sp.secresprelationship <> 'S' THEN CASE pd3.sex WHEN 'F' THEN 'F'
					   WHEN 'M' THEN 'M'
					   ELSE 'U' END END , -- HolderGender - char(1)
          CASE WHEN sp.secresprelationship <> 'S' THEN pd1.address1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN sp.secresprelationship <> 'S' THEN pd1.city END , -- HolderCity - varchar(128)
          CASE WHEN sp.secresprelationship <> 'S' THEN pd2.state END , -- HolderState - varchar(2)
          CASE WHEN sp.secresprelationship <> 'S' THEN pd2.zip END , -- HolderZipCode - varchar(9)
          CASE WHEN sp.secresprelationship <> 'S' THEN pd2.homephone END , -- HolderPhone - varchar(10)
          CASE WHEN sp.secresprelationship <> 'S' THEN sp.secinsid END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          sp.patientcode , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_2_SecondaryPolicy] AS sp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = sp.patientcode AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = sp.secinsco AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_3_2_PatientDemographics1] AS pd1 ON
	pd1.patientid = sp.secrespparty
INNER JOIN dbo.[_import_3_2_PatientDemographics2] AS pd2 ON
	pd2.patientcode = sp.secrespparty
INNER JOIN dbo.[_import_3_2_PatientDemographics3] AS pd3 ON
	pd3.patientcode = sp.secrespparty
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT
