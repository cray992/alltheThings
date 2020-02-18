USE superbill_26959_dev
--USE superbill_26959_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 6

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


PRINT ''
PRINT 'Inserting into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
          Fax ,
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
		  insurancename , -- InsuranceCompanyName - varchar(128)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          addressline1 , -- AddressLine1 - varchar(256)
          addressline2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state , 2) , -- State - varchar(2)
          CASE WHEN LEN(zip) IN (5,9) THEN zip
			   WHEN LEN(zip) IN (4,8) THEN '0' + zip
			   ELSE '' END , -- ZipCode - varchar(9)
          LEFT(phone , 10) , -- Phone - varchar(10)
          LEFT(fax , 10) , -- Fax - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          CASE [insurancetype] WHEN 'Medicare' THEN 'MB'
							   WHEN 'HMO' THEN '16'
							   WHEN 'Medicaid' THEN 'MC'
							   ELSE 'CI' END , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          insuranceid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_6_1_InsuranceList]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
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
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
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
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
		  PrimaryProviderID
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          impPat.firstname , -- FirstName - varchar(64)
          impPat.middlename , -- MiddleName - varchar(64)
          impPat.lastname , -- LastName - varchar(64)
          impPat.suffix , -- Suffix - varchar(16)
          impPat.addressline1 , -- AddressLine1 - varchar(256)
          impPat.addressline2 , -- AddressLine2 - varchar(256)
          impPat.city , -- City - varchar(128)
          LEFT(impPat.state , 2) , -- State - varchar(2)
          CASE WHEN LEN(impPat.zip) IN (5,9) THEN impPat.zip
			   WHEN LEN(impPat.zip) IN (4,8) THEN '0' + impPat.zip
			   ELSE '' END , -- ZipCode - varchar(9)
          CASE impPat.gender WHEN 'M' THEN 'M'
							 WHEN 'F' THEN 'F'
							 ELSE 'U' END , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          LEFT(impPat.homephone , 10) , -- HomePhone - varchar(10)
          LEFT(impPat.workphone , 10) , -- WorkPhone - varchar(10)
          CASE WHEN ISDATE(impPat.dob) = 1 THEN impPat.dob
			   ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(impPat.ssn) >= 6 THEN RIGHT('000' + impPat.ssn , 9)
			   ELSE '' END , -- SSN - char(9)
          impPat.email , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          impPat.id , -- MedicalRecordNumber - varchar(128)
          LEFT(impPat.mobilephone , 10) , -- MobilePhone - varchar(10)
          doc.DoctorID , -- PrimaryCarePhysicianID - int
          impPat.id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          CASE WHEN impPat.email <> '' THEN 1
			   ELSE 0 END , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
		  doc.DoctorID --PrimaryProviderID - int
FROM dbo.[_import_6_1_PatientDemographics] impPat
LEFT JOIN dbo.Doctor doc ON
	doc.FirstName = impPat.pcpfirstname AND
	doc.LastName = impPat.pcplastname AND
	doc.[External] = 0 AND
	doc.PracticeID = @PracticeID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Journal Note 1...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage ,
          AccountStatus ,
          NoteTypeCode ,
          LastNote
        )
SELECT DISTINCT
		  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.PatientID , -- PatientID - int
          'Kareo Import' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impPat.notes , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_6_1_PatientDemographics] AS impPat
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = impPat.id AND
	pat.VendorImportID = @VendorImportID  
WHERE impPat.notes <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Patient Journal Note 2...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage ,
          AccountStatus ,
          NoteTypeCode ,
          LastNote
        )
SELECT DISTINCT
		  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.PatientID , -- PatientID - int
          'Kareo Import' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          RTRIM(LTRIM(ISNULL('Pref Pharmacy #1:' +CHAR(13)+CHAR(10) + impPat.prefpharmacy1, '')
				 + ISNULL(CHAR(13)+CHAR(10) + 'Pref Pharmacy #2:' + CHAR(13)+CHAR(10) + impPat.prefpharmacy2, ''))) , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          1  -- LastNote - bit
FROM dbo.[_import_6_1_PatientDemographics] AS impPat
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = impPat.id AND
	pat.VendorImportID = @VendorImportID  
WHERE impPat.prefpharmacy1 <> '' AND impPat.prefpharmacy2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Patient Case...'
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
          StatementActive ,
          EPSDTCodeID 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
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
          GroupNumber ,
          PolicyStartDate ,
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
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          impPol.insuredid , -- PolicyNumber - varchar(32)
          impPol.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(impPol.effectivedate) = 1 THEN impPol.effectivedate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE impPol.insuredrelationship WHEN 'C' THEN 'C'
										  WHEN 'O' THEN 'O'
										  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredmidname END , -- HolderMiddleName - varchar(64)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredlastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN ISDATE(impPol.idob) = 1 THEN impPol.idob
				ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impPol.insuredssnumber)) >= 6
		  THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(impPol.insuredssnumber) , 9) END END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE impPol.insuredgender WHEN 'F' THEN 'F'
									WHEN 'M' THEN 'M'
									ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredaddrstreet END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN impPol.insuredaddrapt = '' THEN '' ELSE 'APT ' + impPol.insuredaddrapt END END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredaddrcity END , -- HolderCity - varchar(128)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN LEFT(impPol.insuredaddrstate , 2) END , -- HolderState - varchar(2)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN LEN(impPol.zippostalcode) IN (5,9) THEN impPol.zippostalcode
				WHEN LEN(impPol.zippostalcode) IN (4,8) THEN '0' + impPol.zippostalcode	ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN LEFT(dbo.fn_RemoveNonNumericCharacters(impPol.insuredhomephone) , 10) END , -- HolderPhone - varchar(10)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredid END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          impPol.copay , -- Copay - money
          impPol.annualdeductible , -- Deductible - money
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredid END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(impPol.planname , 14)  -- GroupName - varchar(14)
FROM dbo.[_import_6_1_Policy1] impPol
INNER JOIN dbo.Patient pat ON
	pat.FirstName = impPol.insuredfirstname AND
	pat.LastName = impPol.insuredlastname AND
	CAST(CAST(pat.DOB AS DATE) AS DATETIME) = CAST(CAST(impPol.idob AS DATE) AS DATETIME) AND
	pat.VendorImportID = @VendorImportID  
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = pat.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = impPol.insuranceid AND
	icp.VendorImportID = @VendorImportID
WHERE impPol.insuorder = 1 AND impPol.insuredid <> '' AND 
(pat.FirstName = impPol.insuredfirstname AND pat.LastName = impPol.insuredlastname AND CAST(CAST(pat.DOB AS DATE) AS DATETIME) = CAST(CAST(impPol.idob AS DATE) AS DATETIME))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Secondary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
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
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          impPol.insuredid , -- PolicyNumber - varchar(32)
          impPol.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(impPol.effectivedate) = 1 THEN impPol.effectivedate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE impPol.insuredrelationship WHEN 'C' THEN 'C'
										  WHEN 'O' THEN 'O'
										  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredmidname END , -- HolderMiddleName - varchar(64)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredlastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN ISDATE(impPol.idob) = 1 THEN impPol.idob
				ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impPol.insuredssnumber)) >= 6
		  THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(impPol.insuredssnumber) , 9) END END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE impPol.insuredgender WHEN 'F' THEN 'F'
									WHEN 'M' THEN 'M'
									ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredaddrstreet END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN impPol.insuredaddrapt = '' THEN '' ELSE 'APT ' + impPol.insuredaddrapt END END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredaddrcity END , -- HolderCity - varchar(128)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN LEFT(impPol.insuredaddrstate , 2) END , -- HolderState - varchar(2)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN LEN(impPol.zippostalcode) IN (5,9) THEN impPol.zippostalcode
				WHEN LEN(impPol.zippostalcode) IN (4,8) THEN '0' + impPol.zippostalcode	ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN LEFT(dbo.fn_RemoveNonNumericCharacters(impPol.insuredhomephone) , 10) END , -- HolderPhone - varchar(10)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredid END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          impPol.copay , -- Copay - money
          impPol.annualdeductible , -- Deductible - money
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredid END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(impPol.planname , 14)  -- GroupName - varchar(14)
FROM dbo.[_import_6_1_Policy2] impPol
INNER JOIN dbo.Patient pat ON
	pat.FirstName = impPol.insuredfirstname AND
	pat.LastName = impPol.insuredlastname AND
	CAST(CAST(pat.DOB AS DATE) AS DATETIME) = CAST(CAST(impPol.idob AS DATE) AS DATETIME) AND
	pat.VendorImportID = @VendorImportID  
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = pat.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = impPol.insuranceid AND
	icp.VendorImportID = @VendorImportID
WHERE impPol.insuorder = 2 AND impPol.insuredid <> '' AND 
(pat.FirstName = impPol.insuredfirstname AND pat.LastName = impPol.insuredlastname AND CAST(CAST(pat.DOB AS DATE) AS DATETIME) = CAST(CAST(impPol.idob AS DATE) AS DATETIME))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Tertiary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
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
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          impPol.insuredid , -- PolicyNumber - varchar(32)
          impPol.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(impPol.effectivedate) = 1 THEN impPol.effectivedate
			   ELSE NULL END , -- PolicyStartDate - datetime
          CASE impPol.insuredrelationship WHEN 'C' THEN 'C'
										  WHEN 'O' THEN 'O'
										  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredmidname END , -- HolderMiddleName - varchar(64)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredlastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN ISDATE(impPol.idob) = 1 THEN impPol.idob
				ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(impPol.insuredssnumber)) >= 6
		  THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(impPol.insuredssnumber) , 9) END END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE impPol.insuredgender WHEN 'F' THEN 'F'
									WHEN 'M' THEN 'M'
									ELSE 'U' END , -- HolderGender - char(1)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredaddrstreet END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN impPol.insuredaddrapt = '' THEN '' ELSE 'APT ' + impPol.insuredaddrapt END END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredaddrcity END , -- HolderCity - varchar(128)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN LEFT(impPol.insuredaddrstate , 2) END , -- HolderState - varchar(2)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN CASE WHEN LEN(impPol.zippostalcode) IN (5,9) THEN impPol.zippostalcode
				WHEN LEN(impPol.zippostalcode) IN (4,8) THEN '0' + impPol.zippostalcode	ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN LEFT(dbo.fn_RemoveNonNumericCharacters(impPol.insuredhomephone) , 10) END , -- HolderPhone - varchar(10)
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredid END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          impPol.copay , -- Copay - money
          impPol.annualdeductible , -- Deductible - money
          CASE WHEN impPol.insuredrelationship NOT IN ('S','P') THEN impPol.insuredid END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(impPol.planname , 14)  -- GroupName - varchar(14)
FROM dbo.[_import_6_1_Policy3] impPol
INNER JOIN dbo.Patient pat ON
	pat.FirstName = impPol.insuredfirstname AND
	pat.LastName = impPol.insuredlastname AND
	CAST(CAST(pat.DOB AS DATE) AS DATETIME) = CAST(CAST(impPol.idob AS DATE) AS DATETIME) AND
	pat.VendorImportID = @VendorImportID  
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = pat.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = impPol.insuranceid AND
	icp.VendorImportID = @VendorImportID
WHERE impPol.insuorder = 3 AND impPol.insuredid <> '' AND 
(pat.FirstName = impPol.insuredfirstname AND pat.LastName = impPol.insuredlastname AND CAST(CAST(pat.DOB AS DATE) AS DATETIME) = CAST(CAST(impPol.idob AS DATE) AS DATETIME))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Patient Cases to Self Pay Not Linked to Policies...'
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

--ROLLBACK
--COMMIT