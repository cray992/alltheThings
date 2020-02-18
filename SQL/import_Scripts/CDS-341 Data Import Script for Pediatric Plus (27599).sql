USE superbill_27599_dev
--USE superbill_27599_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 4
SET @PracticeID = 1



--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE CreatedUserID = -50
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = -50
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'



PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          City ,
          State ,
          Country ,
          ZipCode ,
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
          street , -- AddressLine1 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          dbo.fn_RemoveNonNumericCharacters(zip) , -- ZipCode - varchar(9)
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          LTRIM(RTRIM(insid)) , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_4_1_InsuranceList]
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Employer...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  employer , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE(), -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_4_1_patientdemo]
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


SET IDENTITY_INSERT dbo.Patient ON
PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PatientID ,
		  PracticeID ,
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
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleCountry ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
		  MobilePhoneExt ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
		  i.PatientID ,
		  @PracticeID  , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          i.patientfirstname , -- FirstName - varchar(64)
          i.patientmiddleinitial , -- MiddleName - varchar(64)
          i.patientlastname , -- LastName - varchar(64)
          i.patientnamesuffix , -- Suffix - varchar(16)
          i.patientaddress1 , -- AddressLine1 - varchar(256)
          i.patientaddress2 , -- AddressLine2 - varchar(256)
          i.patientcity , -- City - varchar(128)
          LEFT(i.patientstate,2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          dbo.fn_RemoveNonNumericCharacters(i.patientzip) , -- ZipCode - varchar(9)
          CASE WHEN i.patientsex <> '' THEN i.patientsex ELSE 'U' END , -- Gender - varchar(1)
          CASE i.patientmaritalstatus 
		  WHEN 'MARRIED' THEN 'M'
		  WHEN 'DIVORCED' THEN 'D'
		  WHEN 'WIDOWED' THEN 'W'
		  WHEN 'SINGLE'	THEN 'S' 
		  ELSE '' END	   , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.patienthomephone),10), -- HomePhone - varchar(10)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patienthomephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patienthomephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patienthomephone))),10) ELSE NULL END ,
          dbo.fn_RemoveNonNumericCharacters(i.patientworkphone) , -- WorkPhone - varchar(10)
          i.patientdob , -- DOB - datetime
          CASE WHEN LEN(i.patientssn) >= 6 THEN RIGHT('000'+i.patientssn,9) ELSE '' END, -- SSN - char(9)
          i.patientemail , -- EmailAddress - varchar(256)
          CASE WHEN i.guardianfrstnm <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN i.guardianfrstnm <> '' THEN '' END, -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.guardianfrstnm <> '' THEN i.guardianfrstnm END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.guardianfrstnm <> '' THEN i.guardianlastnm END, -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.guardianfrstnm <> '' THEN i.guardianlastnm END, -- ResponsibleLastName - varchar(64)
          CASE WHEN i.guardianfrstnm <> '' THEN '' END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN i.guardianfrstnm <> '' AND i.ptntemrgncycntctrltnshp <> 'S' THEN i.ptntgrntrrltnshp END, -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.guardianfrstnm <> '' THEN i.guarantoraddr END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.guardianfrstnm <> '' THEN i.guarantoraddr2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.guardianfrstnm <> '' THEN i.guarantorcity END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.guardianfrstnm <> '' THEN LEFT(i.guarantorstate,2) END , -- ResponsibleState - varchar(2)
          CASE WHEN i.guardianfrstnm <> '' THEN '' END, -- ResponsibleCountry - varchar(32)
          CASE WHEN i.guardianfrstnm <> '' THEN dbo.fn_RemoveNonNumericCharacters(i.guarantorzip) END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.employer <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          e.EmployerID , -- EmployerID - int
          i.legacy , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientmobileno),10) , -- MobilePhone - varchar(10)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientmobileno)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientmobileno),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientmobileno))),10) ELSE NULL END , 
          i.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          i.ptntemrgncycntctnamerelationship , -- EmergencyName - varchar(128)
          dbo.fn_RemoveNonNumericCharacters(i.ptntemrgncycntctph)  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_4_1_patientdemo] i
LEFT JOIN dbo.Employers e ON 
e.EmployerName = i.employer
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
SET IDENTITY_INSERT dbo.Patient OFF


PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
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
          NoteTypeCode 
        )
SELECT DISTINCT
		  GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          i.patientnotes , -- NoteMessage - varchar(max)
          1  -- NoteTypeCode - int
FROM dbo.[_import_4_1_patientdemo] i
INNER JOIN dbo.Patient p ON
p.VendorID = i.patientid AND 
p.VendorImportID = @VendorImportID
WHERE i.patientnotes <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient Case...'
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
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Policy 1...'
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
          HolderGender ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
		  HolderAddressLine1 , 
		  HolderAddressLine2 ,
		  HolderCity ,
		  HolderState ,
		  HolderZipCode ,
		  HolderCountry
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.policynumber1 , -- PolicyNumber - varchar(32)
          i.groupnumber1 , -- GroupNumber - varchar(32)
          CASE i.patientrelationship1 
		  WHEN 'CHILD' THEN 'C'
		  WHEN 'SPOUSE' THEN 'U'
		  WHEN 'OTHER' THEN 'O'
		  WHEN 'O' THEN 'O'
		  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.patientrelationship1 <> '' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.patientrelationship1 <> '' THEN i.holder1firstname END, -- HolderFirstName - varchar(64)
          CASE WHEN i.patientrelationship1 <> '' THEN i.holder1middlename END, -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientrelationship1 <> '' THEN i.holder1lastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientrelationship1 <> '' THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.patientrelationship1 <> '' THEN i.holder1dateofbirth END, -- HolderDOB - datetime
          CASE WHEN i.patientrelationship1 <> '' THEN i.holder1ssn END, -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.patientrelationship1 <> '' THEN i.holder1gender END, -- HolderGender - char(1)
          i.holder1policynumber , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
		  CASE WHEN i.patientrelationship1 <> '' THEN i.holder1street1 END ,
		  CASE WHEN i.patientrelationship1 <> '' THEN i.holder1street2 END ,
		  CASE WHEN i.patientrelationship1 <> '' THEN i.holder1city END ,
		  CASE WHEN i.patientrelationship1 <> '' THEN LEFT(i.holder1state,2) END ,
		  CASE WHEN i.patientrelationship1 <> '' THEN dbo.fn_RemoveNonNumericCharacters(i.holder1zipcode) END ,
		  CASE WHEN i.patientrelationship1 <> '' THEN '' END
FROM dbo.[_import_4_1_patientdemo] i
INNER JOIN dbo.PatientCase pc ON 
pc.VendorID = i.patientid AND 
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
icp.VendorID = LTRIM(RTRIM(i.insurancecode1)) AND
icp.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Policy 2...'
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
          HolderGender ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
		  HolderAddressLine1 , 
		  HolderAddressLine2 ,
		  HolderCity ,
		  HolderState ,
		  HolderZipCode ,
		  HolderCountry
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.policynumber2 , -- PolicyNumber - varchar(32)
          i.groupnumber2 , -- GroupNumber - varchar(32)
          CASE i.patientrelationship2 
		  WHEN 'CHILD' THEN 'C'
		  WHEN 'SPOUSE' THEN 'U'
		  WHEN 'OTHER' THEN 'O'
		  WHEN 'O' THEN 'O'
		  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(2)
          CASE WHEN i.patientrelationship2 <> '' THEN '' END , -- HolderPrefix - varchar(26)
          CASE WHEN i.patientrelationship2 <> '' THEN i.holder2firstname END, -- HolderFirstName - varchar(64)
          CASE WHEN i.patientrelationship2 <> '' THEN i.holder2middlename END, -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientrelationship2 <> '' THEN i.holder2lastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientrelationship2 <> '' THEN '' END , -- HolderSuffix - varchar(26)
          CASE WHEN i.patientrelationship2 <> '' THEN i.holder2dateofbirth END, -- HolderDOB - datetime
          CASE WHEN i.patientrelationship2 <> '' THEN i.holder2ssn END, -- HolderSSN - char(22)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.patientrelationship2 <> '' THEN i.holder2gender END, -- HolderGender - char(2)
          i.holder2policynumber , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
		  CASE WHEN i.patientrelationship2 <> '' THEN i.holder2street2 END ,
		  CASE WHEN i.patientrelationship2 <> '' THEN i.holder2street2 END ,
		  CASE WHEN i.patientrelationship2 <> '' THEN i.holder2city END ,
		  CASE WHEN i.patientrelationship2 <> '' THEN LEFT(i.holder2state,2) END ,
		  CASE WHEN i.patientrelationship2 <> '' THEN dbo.fn_RemoveNonNumericCharacters(i.holder2zipcode) END ,
		  CASE WHEN i.patientrelationship2 <> '' THEN '' END
FROM dbo.[_import_4_1_patientdemo] i
INNER JOIN dbo.PatientCase pc ON 
pc.VendorID = i.patientid AND 
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
icp.VendorID = LTRIM(RTRIM(i.insurancecode2)) AND
icp.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Patient Cases with no Policies...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11 ,
		Name = 'Self Pay'
FROM dbo.PatientCase pc
LEFT JOIN dbo.InsurancePolicy ip ON
		pc.PatientCaseID = ip.PatientCaseID  
WHERE pc.VendorImportID = @VendorImportID AND
      ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT

