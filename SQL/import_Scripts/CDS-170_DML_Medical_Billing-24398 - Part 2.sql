USE superbill_24398_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID1 INT
DECLARE @PracticeID2 INT
DECLARE @PracticeID3 INT
DECLARE @PracticeID4 INT
DECLARE @PracticeID5 INT
DECLARE @VendorImportID INT


SET @PracticeID1 = 1
SET @PracticeID2 = 2
SET @PracticeID3 = 3
SET @PracticeID4 = 4
SET @PracticeID5 = 5
SET @VendorImportID = 3


PRINT 'PracticeID = ' + CAST(@PracticeID1 AS VARCHAR(10))
PRINT 'PracticeID = ' + CAST(@PracticeID2 AS VARCHAR(10))
PRINT 'PracticeID = ' + CAST(@PracticeID3 AS VARCHAR(10))
PRINT 'PracticeID = ' + CAST(@PracticeID4 AS VARCHAR(10))
PRINT 'PracticeID = ' + CAST(@PracticeID5 AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in detination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID1 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted for Practice 1'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID2 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted for Practice 2'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID3 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted for Practice 3'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID4 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted for Practice 4'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID5 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted for Practice 5'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID1 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted for Practice 1'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID2 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted for Practice 2'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID3 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted for Practice 3'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID4 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted for Practice 4'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID5 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted for Practice 5'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID1 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted for Practice 1'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID2 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted for Practice 2'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID3 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted for Practice 3'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID4 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted for Practice 4'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID5 AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted for Practice 5'

/*
==========================================================================================================================================
CREATE PATIENTS FOR PRACTICE 1
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patients into Practice 1...'
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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
		  EmployerID
        )
SELECT DISTINCT
		  @PracticeID1 , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.middleinitial , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          pat.suffix , -- Suffix - varchar(16)
          pat.street1 , -- AddressLine1 - varchar(256)
          pat.street2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state , 2) , -- State - varchar(2)
          CASE
			WHEN LEN(pat.zipcode) IN (5,9) THEN pat.zipcode
			WHEN LEN(pat.zipcode) IN (4,8) THEN '0' + pat.zipcode
			ELSE '' END , -- ZipCode - varchar(9)
          CASE
			pat.gender WHEN 'M' THEN 'M'
					   WHEN 'F' THEN 'F'
					   ELSE 'U' END , -- Gender - varchar(1)
          'S' , -- MaritalStatus - varchar(1)
          LEFT(pat.homephone , 10) , -- HomePhone - varchar(10)
          LEFT(pat.workphone , 10) , -- WorkPhone - varchar(10)
          CASE
			WHEN ISDATE(pat.dateofbirth) = 1 THEN pat.dateofbirth
			ELSE '' END , -- DOB - datetime
          LEFT(pat.socialsecuritynumber , 9) , -- SSN - char(9)
          pat.email , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          NULL , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          pat.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(pat.cellphone , 10) , -- MobilePhone - varchar(10)
          NULL , -- PrimaryCarePhysicianID - int
          pat.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
		  emp.EmployerID -- EmployerID - int
FROM dbo.[_import_3_1_PatientDemographics] AS pat
LEFT JOIN dbo.Employers AS emp ON
	emp.EmployerName = pat.employername
WHERE firstname <> '' AND lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENT CASES FOR PRACTICE 1
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patient Case into Practice 1...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          StatementActive 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please review before using.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID1 , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- StatementActive - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PRIMARY INSURANCE POLICIES FOR PRACTICE 1
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Primary Insurance Policy for Practice 1...'
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
          HolderZipCode ,
          DependentPolicyNumber ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          LEFT(imp.policynumber1 , 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.groupnumber1 , 32) , -- GroupNumber - varchar(32)
          CASE
			imp.patientrelationship1 WHEN 'Spouse' THEN 'U'
									 WHEN 'Child' THEN 'C'
									 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1firstname END , -- HolderFirstName - varchar(64)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1middlename END , -- HolderMiddleName - varchar(64)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE (CASE WHEN ISDATE(imp.holder1dateofbirth) = 1 THEN imp.holder1dateofbirth
																	ELSE NULL END) END , -- HolderDOB - datetime
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1ssn END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1street1 END , -- HolderAddressLine1 - varchar(256)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1street2 END , -- HolderAddressLine2 - varchar(256)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1city END , -- HolderCity - varchar(128)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1state , 2) END , -- HolderState - varchar(2)
          CASE imp.patientrelationship1 WHEN 'S' THEN ''
										ELSE (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1policynumber , 32) END , -- DependentPolicyNumber - varchar(32)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1policynumber , 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID1 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemographics] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID1
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.insuranceplanname1 AND
	icp.VendorImportID = @VendorImportID
WHERE imp.insuranceplanname1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE SECONDARY INSURANCE POLICIES FOR PRACTICE 1
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Secondary Insurance Policy for Practice 1...'
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
          HolderZipCode ,
          DependentPolicyNumber ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          LEFT(imp.policynumber2 , 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.groupnumber2 , 32) , -- GroupNumber - varchar(32)
          CASE
			imp.patientrelationship2 WHEN 'Spouse' THEN 'U'
									 WHEN 'Child' THEN 'C'
									 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2firstname END , -- HolderFirstName - varchar(64)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2middlename END , -- HolderMiddleName - varchar(64)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE (CASE WHEN ISDATE(imp.holder2dateofbirth) = 1 THEN imp.holder1dateofbirth
																	ELSE NULL END) END , -- HolderDOB - datetime
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE dbo.fn_RemoveNonNumericCharacters(imp.holder2ssn) END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2street1 END , -- HolderAddressLine1 - varchar(256)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2street2 END , -- HolderAddressLine2 - varchar(256)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2city END , -- HolderCity - varchar(128)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2state , 2) END , -- HolderState - varchar(2)
          CASE imp.patientrelationship2 WHEN 'S' THEN ''
										ELSE (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder2zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder2zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2policynumber , 32) END , -- DependentPolicyNumber - varchar(32)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2policynumber , 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID1 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemographics] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID1
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.insuranceplanname2 AND
	icp.VendorImportID = @VendorImportID
WHERE imp.insuranceplanname2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'





/*
==========================================================================================================================================
CREATE PATIENTS FOR PRACTICE 2
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patients into Practice 2...'
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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
		  EmployerID
        )
SELECT DISTINCT
		  @PracticeID2 , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.middleinitial , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          pat.suffix , -- Suffix - varchar(16)
          pat.street1 , -- AddressLine1 - varchar(256)
          pat.street2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state , 2) , -- State - varchar(2)
          CASE
			WHEN LEN(pat.zipcode) IN (5,9) THEN pat.zipcode
			WHEN LEN(pat.zipcode) IN (4,8) THEN '0' + pat.zipcode
			ELSE '' END , -- ZipCode - varchar(9)
          CASE
			pat.gender WHEN 'M' THEN 'M'
					   WHEN 'F' THEN 'F'
					   ELSE 'U' END , -- Gender - varchar(1)
          'S' , -- MaritalStatus - varchar(1)
          LEFT(pat.homephone , 10) , -- HomePhone - varchar(10)
          LEFT(pat.workphone , 10) , -- WorkPhone - varchar(10)
          CASE
			WHEN ISDATE(pat.dateofbirth) = 1 THEN pat.dateofbirth
			ELSE '' END , -- DOB - datetime
          LEFT(pat.socialsecuritynumber , 9) , -- SSN - char(9)
          pat.email , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          NULL , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          pat.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(pat.cellphone , 10) , -- MobilePhone - varchar(10)
          NULL , -- PrimaryCarePhysicianID - int
          pat.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
		  emp.EmployerID -- EmployerID - int
FROM dbo.[_import_3_1_PatientDemographics] AS pat
LEFT JOIN dbo.Employers AS emp ON
	emp.EmployerName = pat.employername
WHERE firstname <> '' AND lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENT CASES FOR PRACTICE 2
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patient Case into Practice 2...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          StatementActive 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please review before using.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID2 , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- StatementActive - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PRIMARY INSURANCE POLICIES FOR PRACTICE 2
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Primary Insurance Policy for Practice 2...'
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
          HolderZipCode ,
          DependentPolicyNumber ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          LEFT(imp.policynumber1 , 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.groupnumber1 , 32) , -- GroupNumber - varchar(32)
          CASE
			imp.patientrelationship1 WHEN 'Spouse' THEN 'U'
									 WHEN 'Child' THEN 'C'
									 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1firstname END , -- HolderFirstName - varchar(64)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1middlename END , -- HolderMiddleName - varchar(64)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE (CASE WHEN ISDATE(imp.holder1dateofbirth) = 1 THEN imp.holder1dateofbirth
																	ELSE NULL END) END , -- HolderDOB - datetime
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1ssn END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1street1 END , -- HolderAddressLine1 - varchar(256)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1street2 END , -- HolderAddressLine2 - varchar(256)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1city END , -- HolderCity - varchar(128)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1state , 2) END , -- HolderState - varchar(2)
          CASE imp.patientrelationship1 WHEN 'S' THEN ''
										ELSE (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1policynumber , 32) END , -- DependentPolicyNumber - varchar(32)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1policynumber , 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID2 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemographics] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID2
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.insuranceplanname1 AND
	icp.VendorImportID = @VendorImportID
WHERE imp.insuranceplanname1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE SECONDARY INSURANCE POLICIES FOR PRACTICE 2
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Secondary Insurance Policy for Practice 2...'
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
          HolderZipCode ,
          DependentPolicyNumber ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          LEFT(imp.policynumber2 , 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.groupnumber2 , 32) , -- GroupNumber - varchar(32)
          CASE
			imp.patientrelationship2 WHEN 'Spouse' THEN 'U'
									 WHEN 'Child' THEN 'C'
									 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2firstname END , -- HolderFirstName - varchar(64)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2middlename END , -- HolderMiddleName - varchar(64)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE (CASE WHEN ISDATE(imp.holder2dateofbirth) = 1 THEN imp.holder1dateofbirth
																	ELSE NULL END) END , -- HolderDOB - datetime
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE dbo.fn_RemoveNonNumericCharacters(imp.holder2ssn) END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2street1 END , -- HolderAddressLine1 - varchar(256)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2street2 END , -- HolderAddressLine2 - varchar(256)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2city END , -- HolderCity - varchar(128)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2state , 2) END , -- HolderState - varchar(2)
          CASE imp.patientrelationship2 WHEN 'S' THEN ''
										ELSE (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder2zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder2zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2policynumber , 32) END , -- DependentPolicyNumber - varchar(32)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2policynumber , 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID2 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemographics] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID2
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.insuranceplanname2 AND
	icp.VendorImportID = @VendorImportID
WHERE imp.insuranceplanname2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'





/*
==========================================================================================================================================
CREATE PATIENTS FOR PRACTICE 3
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patients into Practice 3...'
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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
		  EmployerID
        )
SELECT DISTINCT
		  @PracticeID3 , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.middleinitial , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          pat.suffix , -- Suffix - varchar(16)
          pat.street1 , -- AddressLine1 - varchar(256)
          pat.street2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state , 2) , -- State - varchar(2)
          CASE
			WHEN LEN(pat.zipcode) IN (5,9) THEN pat.zipcode
			WHEN LEN(pat.zipcode) IN (4,8) THEN '0' + pat.zipcode
			ELSE '' END , -- ZipCode - varchar(9)
          CASE
			pat.gender WHEN 'M' THEN 'M'
					   WHEN 'F' THEN 'F'
					   ELSE 'U' END , -- Gender - varchar(1)
          'S' , -- MaritalStatus - varchar(1)
          LEFT(pat.homephone , 10) , -- HomePhone - varchar(10)
          LEFT(pat.workphone , 10) , -- WorkPhone - varchar(10)
          CASE
			WHEN ISDATE(pat.dateofbirth) = 1 THEN pat.dateofbirth
			ELSE '' END , -- DOB - datetime
          LEFT(pat.socialsecuritynumber , 9) , -- SSN - char(9)
          pat.email , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          NULL , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          pat.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(pat.cellphone , 10) , -- MobilePhone - varchar(10)
          NULL , -- PrimaryCarePhysicianID - int
          pat.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
		  emp.EmployerID -- EmployerID - int
FROM dbo.[_import_3_1_PatientDemographics] AS pat
LEFT JOIN dbo.Employers AS emp ON
	emp.EmployerName = pat.employername
WHERE firstname <> '' AND lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENT CASES FOR PRACTICE 3
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patient Case into Practice 3...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          StatementActive 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please review before using.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID3 , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- StatementActive - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID3
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PRIMARY INSURANCE POLICIES FOR PRACTICE 3
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Primary Insurance Policy for Practice 3...'
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
          HolderZipCode ,
          DependentPolicyNumber ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          LEFT(imp.policynumber1 , 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.groupnumber1 , 32) , -- GroupNumber - varchar(32)
          CASE
			imp.patientrelationship1 WHEN 'Spouse' THEN 'U'
									 WHEN 'Child' THEN 'C'
									 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1firstname END , -- HolderFirstName - varchar(64)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1middlename END , -- HolderMiddleName - varchar(64)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE (CASE WHEN ISDATE(imp.holder1dateofbirth) = 1 THEN imp.holder1dateofbirth
																	ELSE NULL END) END , -- HolderDOB - datetime
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1ssn END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1street1 END , -- HolderAddressLine1 - varchar(256)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1street2 END , -- HolderAddressLine2 - varchar(256)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1city END , -- HolderCity - varchar(128)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1state , 2) END , -- HolderState - varchar(2)
          CASE imp.patientrelationship1 WHEN 'S' THEN ''
										ELSE (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1policynumber , 32) END , -- DependentPolicyNumber - varchar(32)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1policynumber , 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID3 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemographics] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID3
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.insuranceplanname1 AND
	icp.VendorImportID = @VendorImportID
WHERE imp.insuranceplanname1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE SECONDARY INSURANCE POLICIES FOR PRACTICE 3
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Secondary Insurance Policy for Practice 3...'
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
          HolderZipCode ,
          DependentPolicyNumber ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          LEFT(imp.policynumber2 , 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.groupnumber2 , 32) , -- GroupNumber - varchar(32)
          CASE
			imp.patientrelationship2 WHEN 'Spouse' THEN 'U'
									 WHEN 'Child' THEN 'C'
									 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2firstname END , -- HolderFirstName - varchar(64)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2middlename END , -- HolderMiddleName - varchar(64)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE (CASE WHEN ISDATE(imp.holder2dateofbirth) = 1 THEN imp.holder1dateofbirth
																	ELSE NULL END) END , -- HolderDOB - datetime
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE dbo.fn_RemoveNonNumericCharacters(imp.holder2ssn) END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2street1 END , -- HolderAddressLine1 - varchar(256)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2street2 END , -- HolderAddressLine2 - varchar(256)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2city END , -- HolderCity - varchar(128)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2state , 2) END , -- HolderState - varchar(2)
          CASE imp.patientrelationship2 WHEN 'S' THEN ''
										ELSE (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder2zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder2zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2policynumber , 32) END , -- DependentPolicyNumber - varchar(32)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2policynumber , 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID3 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemographics] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID3
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.insuranceplanname2 AND
	icp.VendorImportID = @VendorImportID
WHERE imp.insuranceplanname2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



/*
==========================================================================================================================================
CREATE PATIENTS FOR PRACTICE 4
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patients into Practice 4...'
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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
		  EmployerID
        )
SELECT DISTINCT
		  @PracticeID4 , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.middleinitial , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          pat.suffix , -- Suffix - varchar(16)
          pat.street1 , -- AddressLine1 - varchar(256)
          pat.street2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state , 2) , -- State - varchar(2)
          CASE
			WHEN LEN(pat.zipcode) IN (5,9) THEN pat.zipcode
			WHEN LEN(pat.zipcode) IN (4,8) THEN '0' + pat.zipcode
			ELSE '' END , -- ZipCode - varchar(9)
          CASE
			pat.gender WHEN 'M' THEN 'M'
					   WHEN 'F' THEN 'F'
					   ELSE 'U' END , -- Gender - varchar(1)
          'S' , -- MaritalStatus - varchar(1)
          LEFT(pat.homephone , 10) , -- HomePhone - varchar(10)
          LEFT(pat.workphone , 10) , -- WorkPhone - varchar(10)
          CASE
			WHEN ISDATE(pat.dateofbirth) = 1 THEN pat.dateofbirth
			ELSE '' END , -- DOB - datetime
          LEFT(pat.socialsecuritynumber , 9) , -- SSN - char(9)
          pat.email , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          NULL , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          pat.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(pat.cellphone , 10) , -- MobilePhone - varchar(10)
          NULL , -- PrimaryCarePhysicianID - int
          pat.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
		  emp.EmployerID -- EmployerID - int
FROM dbo.[_import_3_1_PatientDemographics] AS pat
LEFT JOIN dbo.Employers AS emp ON
	emp.EmployerName = pat.employername
WHERE firstname <> '' AND lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENT CASES FOR PRACTICE 4
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patient Case into Practice 4...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          StatementActive 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please review before using.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID4 , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- StatementActive - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID4
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PRIMARY INSURANCE POLICIES FOR PRACTICE 4
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Primary Insurance Policy for Practice 4...'
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
          HolderZipCode ,
          DependentPolicyNumber ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          LEFT(imp.policynumber1 , 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.groupnumber1 , 32) , -- GroupNumber - varchar(32)
          CASE
			imp.patientrelationship1 WHEN 'Spouse' THEN 'U'
									 WHEN 'Child' THEN 'C'
									 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1firstname END , -- HolderFirstName - varchar(64)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1middlename END , -- HolderMiddleName - varchar(64)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE (CASE WHEN ISDATE(imp.holder1dateofbirth) = 1 THEN imp.holder1dateofbirth
																	ELSE NULL END) END , -- HolderDOB - datetime
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1ssn END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1street1 END , -- HolderAddressLine1 - varchar(256)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1street2 END , -- HolderAddressLine2 - varchar(256)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1city END , -- HolderCity - varchar(128)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1state , 2) END , -- HolderState - varchar(2)
          CASE imp.patientrelationship1 WHEN 'S' THEN ''
										ELSE (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1policynumber , 32) END , -- DependentPolicyNumber - varchar(32)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1policynumber , 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID4 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemographics] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID4
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.insuranceplanname1 AND
	icp.VendorImportID = @VendorImportID
WHERE imp.insuranceplanname1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE SECONDARY INSURANCE POLICIES FOR PRACTICE 4
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Secondary Insurance Policy for Practice 4...'
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
          HolderZipCode ,
          DependentPolicyNumber ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          LEFT(imp.policynumber2 , 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.groupnumber2 , 32) , -- GroupNumber - varchar(32)
          CASE
			imp.patientrelationship2 WHEN 'Spouse' THEN 'U'
									 WHEN 'Child' THEN 'C'
									 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2firstname END , -- HolderFirstName - varchar(64)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2middlename END , -- HolderMiddleName - varchar(64)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE (CASE WHEN ISDATE(imp.holder2dateofbirth) = 1 THEN imp.holder1dateofbirth
																	ELSE NULL END) END , -- HolderDOB - datetime
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE dbo.fn_RemoveNonNumericCharacters(imp.holder2ssn) END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2street1 END , -- HolderAddressLine1 - varchar(256)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2street2 END , -- HolderAddressLine2 - varchar(256)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2city END , -- HolderCity - varchar(128)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2state , 2) END , -- HolderState - varchar(2)
          CASE imp.patientrelationship2 WHEN 'S' THEN ''
										ELSE (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder2zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder2zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2policynumber , 32) END , -- DependentPolicyNumber - varchar(32)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2policynumber , 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID4 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemographics] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID4
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.insuranceplanname2 AND
	icp.VendorImportID = @VendorImportID
WHERE imp.insuranceplanname2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




/*
==========================================================================================================================================
CREATE PATIENTS FOR PRACTICE 5
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patients into Practice 5...'
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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
		  EmployerID
        )
SELECT DISTINCT
		  @PracticeID5 , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.middleinitial , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          pat.suffix , -- Suffix - varchar(16)
          pat.street1 , -- AddressLine1 - varchar(256)
          pat.street2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state , 2) , -- State - varchar(2)
          CASE
			WHEN LEN(pat.zipcode) IN (5,9) THEN pat.zipcode
			WHEN LEN(pat.zipcode) IN (4,8) THEN '0' + pat.zipcode
			ELSE '' END , -- ZipCode - varchar(9)
          CASE
			pat.gender WHEN 'M' THEN 'M'
					   WHEN 'F' THEN 'F'
					   ELSE 'U' END , -- Gender - varchar(1)
          'S' , -- MaritalStatus - varchar(1)
          LEFT(pat.homephone , 10) , -- HomePhone - varchar(10)
          LEFT(pat.workphone , 10) , -- WorkPhone - varchar(10)
          CASE
			WHEN ISDATE(pat.dateofbirth) = 1 THEN pat.dateofbirth
			ELSE '' END , -- DOB - datetime
          LEFT(pat.socialsecuritynumber , 9) , -- SSN - char(9)
          pat.email , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          NULL , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          pat.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(pat.cellphone , 10) , -- MobilePhone - varchar(10)
          NULL , -- PrimaryCarePhysicianID - int
          pat.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
		  emp.EmployerID -- EmployerID - int
FROM dbo.[_import_3_1_PatientDemographics] AS pat
LEFT JOIN dbo.Employers AS emp ON
	emp.EmployerName = pat.employername
WHERE firstname <> '' AND lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENT CASES FOR PRACTICE 5
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patient Case into Practice 5...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          StatementActive 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please review before using.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID5 , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- StatementActive - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PRIMARY INSURANCE POLICIES FOR PRACTICE 5
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Primary Insurance Policy for Practice 5...'
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
          HolderZipCode ,
          DependentPolicyNumber ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          LEFT(imp.policynumber1 , 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.groupnumber1 , 32) , -- GroupNumber - varchar(32)
          CASE
			imp.patientrelationship1 WHEN 'Spouse' THEN 'U'
									 WHEN 'Child' THEN 'C'
									 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1firstname END , -- HolderFirstName - varchar(64)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1middlename END , -- HolderMiddleName - varchar(64)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE (CASE WHEN ISDATE(imp.holder1dateofbirth) = 1 THEN imp.holder1dateofbirth
																	ELSE NULL END) END , -- HolderDOB - datetime
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1ssn END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1street1 END , -- HolderAddressLine1 - varchar(256)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1street2 END , -- HolderAddressLine2 - varchar(256)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE imp.holder1city END , -- HolderCity - varchar(128)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1state , 2) END , -- HolderState - varchar(2)
          CASE imp.patientrelationship1 WHEN 'S' THEN ''
										ELSE (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1policynumber , 32) END , -- DependentPolicyNumber - varchar(32)
          CASE imp.patientrelationship1 WHEN 'S' THEN '' ELSE LEFT(imp.holder1policynumber , 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID5 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemographics] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID5
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.insuranceplanname1 AND
	icp.VendorImportID = @VendorImportID
WHERE imp.insuranceplanname1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE SECONDARY INSURANCE POLICIES FOR PRACTICE 5
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Secondary Insurance Policy for Practice 5...'
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
          HolderZipCode ,
          DependentPolicyNumber ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          LEFT(imp.policynumber2 , 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.groupnumber2 , 32) , -- GroupNumber - varchar(32)
          CASE
			imp.patientrelationship2 WHEN 'Spouse' THEN 'U'
									 WHEN 'Child' THEN 'C'
									 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2firstname END , -- HolderFirstName - varchar(64)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2middlename END , -- HolderMiddleName - varchar(64)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE (CASE WHEN ISDATE(imp.holder2dateofbirth) = 1 THEN imp.holder1dateofbirth
																	ELSE NULL END) END , -- HolderDOB - datetime
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE dbo.fn_RemoveNonNumericCharacters(imp.holder2ssn) END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2street1 END , -- HolderAddressLine1 - varchar(256)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2street2 END , -- HolderAddressLine2 - varchar(256)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE imp.holder2city END , -- HolderCity - varchar(128)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2state , 2) END , -- HolderState - varchar(2)
          CASE imp.patientrelationship2 WHEN 'S' THEN ''
										ELSE (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder2zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.holder2zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.holder1zipcode)
												   ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2policynumber , 32) END , -- DependentPolicyNumber - varchar(32)
          CASE imp.patientrelationship2 WHEN 'S' THEN '' ELSE LEFT(imp.holder2policynumber , 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID5 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_PatientDemographics] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.chartnumber AND
	pc.PracticeID = @PracticeID5
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.PlanName = imp.insuranceplanname2 AND
	icp.VendorImportID = @VendorImportID
WHERE imp.insuranceplanname2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'





--ROLLBACK TRAN
--COMMIT


