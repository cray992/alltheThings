USE superbill_26089_dev
--USE superbill_26089_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 4

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


/*
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
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
*/


PRINT ''
PRINT 'Inserting into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
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
		  insname , -- InsuranceCompanyName - varchar(128)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
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
          inscode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_4_1_Insurance]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          Notes ,
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
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
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
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  patientemployer , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_4_1_Patients]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
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
          imp.patientfirstname , -- FirstName - varchar(64)
          imp.patientmiddlename , -- MiddleName - varchar(64)
          imp.patientlastname , -- LastName - varchar(64)
          imp.patientsuffix , -- Suffix - varchar(16)
          imp.patientaddress1 , -- AddressLine1 - varchar(256)
          imp.patientaddress2 , -- AddressLine2 - varchar(256)
          imp.patientcity , -- City - varchar(128)
          LEFT(imp.patientstate , 2) , -- State - varchar(2)
          CASE WHEN LEN(imp.patientzipcode) IN (5,9) THEN imp.patientzipcode
			   WHEN LEN(imp.patientzipcode) IN (4,8) THEN '0' + imp.patientzipcode
			   ELSE '' END , -- ZipCode - varchar(9)
          imp.patientsex , -- Gender - varchar(1)
          CASE imp.patientmaritalstatus WHEN 'LEGALLY SEPARATED' THEN 'L'
										WHEN 'WIDOWED' THEN 'W'
										WHEN 'DIVORCED' THEN 'D'
										WHEN 'MARRIED' THEN 'M'
										ELSE 'S' END , -- MaritalStatus - varchar(1)
          LEFT(imp.patienthomephone , 10) , -- HomePhone - varchar(10)
          LEFT(imp.patientworkphone , 10) , -- WorkPhone - varchar(10)
          CASE WHEN ISDATE(imp.patientdateofbirth) = 1 THEN imp.patientdateofbirth
			   ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.patientsocialsecurityno)) >= 6 
			   THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(imp.patientsocialsecurityno) , 9) ELSE '' END , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          1 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          emp.EmployerID , -- EmployerID - int
          imp.patientuniqueid , -- MedicalRecordNumber - varchar(128)
          imp.patientuniqueid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_4_1_Patients] AS imp
LEFT JOIN dbo.Employers AS emp ON
	emp.EmployerName = imp.patientemployer
WHERE NOT EXISTS (SELECT * FROM dbo.Patient WHERE MedicalRecordNumber = imp.patientuniqueid) AND imp.patientfirstname <> '' AND imp.patientlastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




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
          VendorImportID ,
          StatementActive ,
          EPSDTCodeID 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- StatementActive - bit
          1  -- EPSDTCodeID - int
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Primary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
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
          LEFT(RTRIM(LTRIM(imp.covid)) , 32) , -- PolicyNumber - varchar(32)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN subfname END , -- HolderFirstName - varchar(64)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN subminit END , -- HolderMiddleName - varchar(64)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN sublname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN CASE WHEN ISDATE(imp.subscriberdateofbirth) = 1 THEN imp.subscriberdateofbirth ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN CASE WHEN LEN(imp.subssn) >= 6 THEN RIGHT('000' + imp.subssn, 9) END END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN imp.patientaddress1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN imp.patientaddress2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN imp.patientcity END , -- HolderCity - varchar(128)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(imp.patientstate , 2) END , -- HolderState - varchar(2)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN CASE WHEN LEN(imp.patientzipcode) IN (5,9) THEN imp.patientzipcode
												 WHEN LEN(imp.patientzipcode) IN (4,8) THEN '0' + imp.patientzipcode
												 ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(imp.patienthomephone , 10) END , -- HolderPhone - varchar(10)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(RTRIM(LTRIM(imp.covid)), 32) END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(RTRIM(LTRIM(imp.covid)), 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_1_Patients] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.patientuniqueid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.inscode AND
	icp.VendorImportID = @VendorImportID
WHERE imp.patientinsorder = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Secondary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
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
          LEFT(RTRIM(LTRIM(imp.covid)) , 32) , -- PolicyNumber - varchar(32)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN subfname END , -- HolderFirstName - varchar(64)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN subminit END , -- HolderMiddleName - varchar(64)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN sublname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN CASE WHEN ISDATE(imp.subscriberdateofbirth) = 1 THEN imp.subscriberdateofbirth ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN CASE WHEN LEN(imp.subssn) >= 6 THEN RIGHT('000' + imp.subssn, 9) END END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN imp.patientaddress1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN imp.patientaddress2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN imp.patientcity END , -- HolderCity - varchar(128)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(imp.patientstate , 2) END , -- HolderState - varchar(2)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN CASE WHEN LEN(imp.patientzipcode) IN (5,9) THEN imp.patientzipcode
												 WHEN LEN(imp.patientzipcode) IN (4,8) THEN '0' + imp.patientzipcode
												 ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(imp.patienthomephone , 10) END , -- HolderPhone - varchar(10)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(RTRIM(LTRIM(imp.covid)), 32) END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(RTRIM(LTRIM(imp.covid)), 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_1_Patients] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.patientuniqueid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.inscode AND
	icp.VendorImportID = @VendorImportID
WHERE imp.patientinsorder = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Tertiary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          LEFT(RTRIM(LTRIM(imp.covid)) , 32) , -- PolicyNumber - varchar(32)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN subfname END , -- HolderFirstName - varchar(64)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN subminit END , -- HolderMiddleName - varchar(64)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN sublname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN CASE WHEN ISDATE(imp.subscriberdateofbirth) = 1 THEN imp.subscriberdateofbirth ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN CASE WHEN LEN(imp.subssn) >= 6 THEN RIGHT('000' + imp.subssn, 9) END END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN imp.patientaddress1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN imp.patientaddress2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN imp.patientcity END , -- HolderCity - varchar(128)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(imp.patientstate , 2) END , -- HolderState - varchar(2)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN CASE WHEN LEN(imp.patientzipcode) IN (5,9) THEN imp.patientzipcode
												 WHEN LEN(imp.patientzipcode) IN (4,8) THEN '0' + imp.patientzipcode
												 ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(imp.patienthomephone , 10) END , -- HolderPhone - varchar(10)
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(RTRIM(LTRIM(imp.covid)), 32) END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          CASE WHEN (imp.sublname <> imp.patientlastname AND imp.subfname <> imp.patientfirstname) THEN LEFT(RTRIM(LTRIM(imp.covid)), 32) END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_1_Patients] imp
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.patientuniqueid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.inscode AND
	icp.VendorImportID = @VendorImportID
WHERE imp.patientinsorder = 3
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 ,
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Responsible Party on Patients...'
UPDATE dbo.Patient
	SET ResponsibleDifferentThanPatient = CASE WHEN imp.relationshiptorespparty NOT IN ('FEMALE SUBSCRIBER-02','MALE SUBSCRIBER-01','') THEN 1 ELSE 0 END ,
		ResponsibleFirstName = CASE WHEN imp.relationshiptorespparty NOT IN ('FEMALE SUBSCRIBER-02','MALE SUBSCRIBER-01','') THEN imp.resppartyfirstname END ,
		ResponsibleMiddleName = CASE WHEN imp.relationshiptorespparty NOT IN ('FEMALE SUBSCRIBER-02','MALE SUBSCRIBER-01','') THEN imp.resppartymiddlename END ,
		ResponsibleLastName = CASE WHEN imp.relationshiptorespparty NOT IN ('FEMALE SUBSCRIBER-02','MALE SUBSCRIBER-01','') THEN imp.resppartylastname END ,
		ResponsibleRelationshipToPatient = CASE imp.relationshiptorespparty WHEN 'FEMALE CHILD-06' THEN 'C'
										   WHEN 'FEMALE SPOUSE-04' THEN 'U'
										   WHEN 'FEMALE SUBSCRIBER-02' THEN 'S'
										   WHEN 'LIFE PARTNER' THEN 'O'
										   WHEN 'MALE CHILD-05' THEN 'C'
										   WHEN 'MALE SPOUSE-03' THEN 'U'
										   WHEN 'MALE SUBSCRIBER-01' THEN 'S'
										   WHEN 'OTHER-09' THEN 'O'
										   ELSE 'S' END ,
		ResponsibleAddressLine1 = CASE WHEN imp.relationshiptorespparty NOT IN ('FEMALE SUBSCRIBER-02','MALE SUBSCRIBER-01','') THEN imp.resppartyaddress1 END , -- ResponsibleAddressLine1 - varchar(256)
        ResponsibleAddressLine2 = CASE WHEN imp.relationshiptorespparty NOT IN ('FEMALE SUBSCRIBER-02','MALE SUBSCRIBER-01','') THEN imp.resppartyaddress2 END , -- ResponsibleAddressLine2 - varchar(256)
        ResponsibleCity = CASE WHEN imp.relationshiptorespparty NOT IN ('FEMALE SUBSCRIBER-02','MALE SUBSCRIBER-01','') THEN imp.resppartycity END , -- ResponsibleCity - varchar(128)
        ResponsibleState = CASE WHEN imp.relationshiptorespparty NOT IN ('FEMALE SUBSCRIBER-02','MALE SUBSCRIBER-01','') THEN LEFT(imp.resppartystate , 2) END , -- ResponsibleState - varchar(2)
        ResponsibleZipCode = CASE WHEN imp.relationshiptorespparty NOT IN ('FEMALE SUBSCRIBER-02','MALE SUBSCRIBER-01','') THEN CASE WHEN LEN(imp.resppartyzipcode) IN (5,9) THEN imp.resppartyzipcode
			   WHEN LEN(imp.resppartyzipcode) IN (4,8) THEN '0' + imp.resppartyzipcode
			   ELSE '' END END
FROM dbo.Patient pat
INNER JOIN dbo.[_import_4_1_Patients] imp ON
	imp.patientuniqueid = pat.VendorID
WHERE pat.PracticeID = @PracticeID AND pat.VendorImportID = @VendorImportID AND imp.relationshiptorespparty NOT IN ('FEMALE SUBSCRIBER-02','MALE SUBSCRIBER-01','')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'




--ROLLBACK
--COMMIT