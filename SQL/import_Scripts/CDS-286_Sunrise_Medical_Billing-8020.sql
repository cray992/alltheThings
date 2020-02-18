USE superbill_8020_dev
--USE superbill_8020_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 8
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))



--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'


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
          PhoneExt ,
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
		  name , -- InsuranceCompanyName - varchar(128)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state , 2) , -- State - varchar(2)
          CASE WHEN LEN(zip) IN (5,9) THEN zip
			   WHEN LEN(zip) IN (4,8) THEN '0' + zip
			   ELSE '' END , -- ZipCode - varchar(9)
          LEFT(phone , 10) , -- Phone - varchar(10)
          LEFT(phoneext , 10) , -- PhoneExt - varchar(10)
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
          InsuranceID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_8_Insurances]
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
          PhoneExt ,
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
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
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
PRINT 'Inserting into Referring Doctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          refdocfirstname , -- FirstName - varchar(64)
          refdocmiddle , -- MiddleName - varchar(64)
          refdoclastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          CASE WHEN refnotes <> '' THEN refnotes + CHAR(13)+CHAR(10) + CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' END, -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          refdocid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          refnpi  -- NPI - varchar(10)
FROM dbo.[_import_1_8_ReferringProvider]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Employer...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  i.employer , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_8_Demographics] i
WHERE NOT EXISTS (SELECT * FROM dbo.Employers e WHERE e.EmployerName = i.employer)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient...'
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
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsibleRelationshipToPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          doc.DoctorID , -- ReferringPhysicianID - int
          impPat.salutation , -- Prefix - varchar(16)
          impPat.first , -- FirstName - varchar(64)
          impPat.middle , -- MiddleName - varchar(64)
          impPat.LastName , -- LastName - varchar(64)
          impPat.suffix , -- Suffix - varchar(16)
          impPat.address1 , -- AddressLine1 - varchar(256)
          impPat.address2 , -- AddressLine2 - varchar(256)
          impPat.city , -- City - varchar(128)
          impPat.state , -- State - varchar(2)
          CASE WHEN LEN(impPat.zip) IN (5,9) THEN impPat.zip
			   WHEN LEN(impPat.zip) IN (4,8) THEN '0' + impPat.zip
			   ELSE '' END , -- ZipCode - varchar(9)
          CASE impPat.gender WHEN 'M' THEN 'M'
							 WHEN 'F' THEN 'F'
							 ELSE 'U' END , -- Gender - varchar(1)
          impPat.maritalstatus , -- MaritalStatus - varchar(1)
          LEFT(impPat.phone , 10) , -- HomePhone - varchar(10)
          LEFT(impPat.workphone , 10) , -- WorkPhone - varchar(10)
          CASE WHEN ISDATE(impPat.birthdate) = 1 THEN impPat.birthdate
			   ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(impPat.ss) >= 6 THEN RIGHT('000' + impPat.ss , 9) ELSE '' END , -- SSN - char(9)
          impPat.email , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          'S' , -- ResponsibleRelationshipToPatient - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          impPat.employmentstatus , -- EmploymentStatus - char(1)
          doc1.DoctorID , -- PrimaryProviderID - int
          emp.EmployerID , -- EmployerID - int
          impPat.PatientID , -- MedicalRecordNumber - varchar(128)
          impPat.Cellphone , -- MobilePhone - varchar(10)
          impPat.PatientID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          CASE WHEN impPat.email <> '' THEN 1 ELSE 0 END  -- SendEmailCorrespondence - bit
FROM dbo.[_import_1_8_Demographics] impPat
LEFT JOIN dbo.Doctor doc ON
	doc.VendorID = impPat.referringdoctorid AND
	doc.[External] = 1 AND
	doc.VendorImportID = @VendorImportID AND
	doc.PracticeID = @PracticeID
LEFT JOIN dbo.Doctor doc1 ON
	doc1.FirstName = impPat.Defaultrendfirst AND
	doc1.LastName = impPat.defaultrendlast AND
	doc1.[External] = 0 AND
	doc1.PracticeID = @PracticeID
LEFT JOIN dbo.Employers emp ON
	emp.EmployerName = impPat.Employer
WHERE NOT EXISTS (SELECT * FROM dbo.Patient p WHERE p.MedicalRecordNumber = impPat.patientid AND p.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Journal Note...'
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
          CASE WHEN impPat.ChartID <> '' THEN 'Chart ID: ' + impPat.ChartID +
		  CASE WHEN impPat.Comments <> '' THEN CHAR(10)+CHAR(13) + 'Comments: ' + impPat.comments +
		  CASE WHEN impPat.referredbymore <> '' THEN CHAR(10)+CHAR(13) + 'Referred by More: ' + impPat.referredbymore
		  END END END , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          0 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_1_8_Demographics] impPat
INNER JOIN dbo.Patient pat ON
	pat.VendorID = impPat.PatientID AND
	pat.VendorImportID = @VendorImportID
WHERE impPat.comments <> '' OR impPat.referredbymore <> '' OR impPat.chartid <> ''
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
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
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
          impPat.primarypolicynumber , -- PolicyNumber - varchar(32)
          impPat.primarygroupnumber , -- GroupNumber - varchar(32)
          CASE impPat.patientrel WHEN 1 THEN 'S'
								 WHEN 2 THEN 'U'
								 WHEN 3 THEN 'C'
								 WHEN 4 THEN 'O'
								 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.primaryinsuredfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.primaryinsuredmiddle END , -- HolderMiddleName - varchar(64)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.primaryinsuredlastname END , -- HolderLastName - varchar(64)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.primaryinsuredsuffix END , -- HolderSuffix - varchar(16)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN CASE WHEN ISDATE(impPat.primaryinsureddob) = 1 THEN impPat.primaryinsureddob ELSE NULL END END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.address1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.address2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.city END , -- HolderCity - varchar(128)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.STATE END , -- HolderState - varchar(2)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN CASE WHEN LEN(impPat.zip) IN (5,9) THEN impPat.zip
																WHEN LEN(impPat.zip) IN (4,8) THEN '0' + impPat.zip
																ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN LEFT(impPat.phone , 10) END , -- HolderPhone - varchar(10)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.primarypolicynumber END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          impPat.copay , -- Copay - money
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.primarypolicynumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_8_Demographics] impPat
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = impPat.PatientID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = impPat.Primaryinsuranceid AND
	icp.VendorImportID = @VendorImportID
WHERE impPat.primarypolicynumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Secondary Insurance Policy...'
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
          impPat.secondarypolicynumber , -- PolicyNumber - varchar(32)
          impPat.secondarygroupnumber , -- GroupNumber - varchar(32)
          CASE impPat.patientrel WHEN 1 THEN 'S'
								 WHEN 2 THEN 'U'
								 WHEN 3 THEN 'C'
								 WHEN 4 THEN 'O'
								 ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.secondaryinsuredfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.secondaryinsuredmiddle END , -- HolderMiddleName - varchar(64)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.secondaryinsuredlastname END , -- HolderLastName - varchar(64)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.secondaryinsuredsuffix END , -- HolderSuffix - varchar(16)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN CASE WHEN ISDATE(impPat.insureds2dob) = 1 THEN impPat.insureds2dob ELSE NULL END END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.address1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.address2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.city END , -- HolderCity - varchar(128)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.STATE END , -- HolderState - varchar(2)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN CASE WHEN LEN(impPat.zip) IN (5,9) THEN impPat.zip
																WHEN LEN(impPat.zip) IN (4,8) THEN '0' + impPat.zip
																ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN LEFT(impPat.phone , 10) END , -- HolderPhone - varchar(10)
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.secondarypolicynumber END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          CASE WHEN impPat.patientrel NOT IN (1 , '') THEN impPat.secondarypolicynumber END , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_8_Demographics] impPat
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = impPat.PatientID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = impPat.secondaryinsuranceid AND
	icp.VendorImportID = @VendorImportID
WHERE impPat.secondarypolicynumber <> ''  
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



--ROLLBACK
--COMMIT



