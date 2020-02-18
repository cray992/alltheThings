USE superbill_21618_prod
GO

SET XACT_ABORT ON
 
BEGIN TRANSACTION
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 
PRINT ''
PRINT 'Purging existing records in detination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 
 

DELETE FROM dbo.Employers WHERE ModifiedUserID = 0 AND CreatedUserID = 0
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Referring Doctor records deleted'
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
PRINT 'Inserting Into Referring Doctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          SSN ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          HomePhone ,
          WorkPhone ,
          MobilePhone ,
          EmailAddress ,
          Notes ,
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
          NPI 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname, -- FirstName - varchar(64)
          imp.mi , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          imp.suffix , -- Suffix - varchar(16)
		  LEFT(dbo.fn_RemoveNonNumericCharacters(imp.taxid), 9) , -- SSN int(9)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          LEFT(imp.state, 2) , -- State - varchar(2)
		  '' , -- Country
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.zip), 9) , -- ZipCode - varchar(9)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.phone1), 10) , -- HomePhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.phone2), 10) , -- WorkPhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.cellular), 10) , -- MobilePhone - varchar(10)
          imp.email , -- EmailAddress - varchar(256)
          CASE WHEN imp.practicename <> '' THEN 'Practice:' + ' ' + imp.practicename ELSE imp.note END, -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          LEFT(imp.degree, 8) , -- Degree - varchar(8)
          imp.addresscode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.fax),10 ), -- FaxNumber - varchar(10)
          1 , -- External - bit
          LEFT(dbo.fn_RemoveNonNumericCharacters(imp.npi), 10)  -- NPI - varchar(10)
FROM dbo.[_import_1_1_ReferringPhysician] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  imp.firstname , -- EmployerName - varchar(128)
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE(), -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
From dbo.[_import_1_1_Employer] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          AnesthesiaType 
        )
SELECT DISTINCT
	      imp.name , -- InsuranceCompanyName - varchar(128)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          '2013-11-27 18:30:35' , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          '2013-11-27 18:30:35' , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          LEFT(imp.name, 50) , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U'  -- AnesthesiaType - varchar(1)
FROM dbo.[_import_1_1_Insurance] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'





PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
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
          CreatedPracticeID ,
          Fax ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  imp.name , -- PlanName - varchar(128)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          imp.zip , -- ZipCode - varchar(9)
          imp.phone1 , -- Phone - varchar(10)
          imp.ext1 , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          imp.fax , -- Fax - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          imp.addresscode , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Insurance] imp
	INNER JOIN dbo.InsuranceCompany ic ON 
		ic.VendorID = LEFT(imp.name, 50) AND
		ic.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'





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
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
		  EmergencyName, 
		  EmergencyPhone ,
          Active 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname , -- FirstName - varchar(64)
          imp.mi , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          imp.suffix , -- Suffix - varchar(16)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          LEFT(imp.state, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(imp.zip, 9) , -- ZipCode - varchar(9)
          LEFT(imp.gender, 1) , -- Gender - varchar(1)
          LEFT(imp.homephone, 10) , -- HomePhone - varchar(10)
          LEFT(imp.workphone, 10) , -- WorkPhone - varchar(10)
          LEFT(imp.workext, 10) , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(imp.dob) = 1 THEN imp.dob 
		  ELSE NULL END, -- DOB - datetime
          LEFT(imp.ssn, 9) , -- SSN - char(9)
          LEFT(imp.email, 256) , -- EmailAddress - varchar(256)
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          LEFT(imp.code, 128) , -- MedicalRecordNumber - varchar(128)
          LEFT(imp.cellphone, 10) , -- MobilePhone - varchar(10)
          LEFT(imp.code, 50) , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
		  imp.emergencycontact1 , --EmergencyName
		  imp.emergencyphone1 , --EmergencyPhone
          imp.active  -- Active - bit
FROM dbo.[_import_1_1_PatientDemo] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into PatientCase...'
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
          'Created via Data Import. Please verify before use' , -- Notes - text
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
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into InsurancePolicy1...'
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
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID , 
		  Notes
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imp.inspolicyno1 , -- PolicyNumber - varchar(32)
          imp.insgroupno1 , -- GroupNumber - varchar(32)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN 'C'
										   WHEN 'Other' THEN 'O'
										   WHEN 'Spouse' THEN 'U'
										   WHEN 'Self' THEN 'S'
										   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.FirstName WHERE imp.cardholdername1 = pat.VendorID)
									       WHEN 'Other' THEN (SELECT pat.FirstName WHERE imp.cardholdername1 = pat.VendorID)  
										   WHEN 'Spouse' THEN (SELECT pat.FirstName WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderFirstName - varchar(64)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.MiddleName WHERE imp.cardholdername1 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.MiddleName WHERE imp.cardholdername1 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.MiddleName WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderMiddleName - varchar(64)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.LastName WHERE imp.cardholdername1 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.LastName WHERE imp.cardholdername1 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.LastName WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderLastName - varchar(64)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.Suffix WHERE imp.cardholdername1 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.Suffix WHERE imp.cardholdername1 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.Suffix WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderSuffix - varchar(16)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.DOB WHERE imp.cardholdername1 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.DOB WHERE imp.cardholdername1 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.DOB WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.Gender WHERE imp.cardholdername1 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.Gender WHERE imp.cardholdername1 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.Gender WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderGender - char(1)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.AddressLine1 WHERE imp.cardholdername1 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.AddressLine1 WHERE imp.cardholdername1 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.AddressLine1 WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderAddressLine1 - varchar(256)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.AddressLine2 WHERE imp.cardholdername1 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.AddressLine2 WHERE imp.cardholdername1 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.AddressLine2 WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderAddressLine2 - varchar(256)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.City WHERE imp.cardholdername1 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.City WHERE imp.cardholdername1 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.City WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderCity - varchar(128)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.State WHERE imp.cardholdername1 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.State WHERE imp.cardholdername1 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.State WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderState - varchar(2)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN (SELECT pat.ZipCode WHERE imp.cardholdername1 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.ZipCode WHERE imp.cardholdername1 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.ZipCode WHERE imp.cardholdername1 = pat.VendorID) 
										   ELSE '' END , -- HolderZipCode - varchar(9)
          CASE imp.cardholderrelationship1 WHEN 'Child' THEN imp.inspolicyno1
										   WHEN 'Other' THEN imp.inspolicyno1
										   WHEN 'Spouse' THEN imp.inspolicyno1
										   ELSE '' END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.patientcode , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
		  imp.insrestrictions1 -- Notes
FROM dbo.[_import_5_1_PatientCasePolicyUpdate] imp
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = imp.patientcode AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = imp.inscode1 AND
		icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.Patient pat ON 
		pat.VendorID = imp.cardholdername1
WHERE imp.inscode1 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into InsurancePolicy2...'
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
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID , 
		  Notes
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imp.inspolicyno2 , -- PolicyNumber - varchar(32)
          imp.insgroupno2 , -- GroupNumber - varchar(32)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN 'C'
										   WHEN 'Other' THEN 'O'
										   WHEN 'Spouse' THEN 'U'
										   WHEN 'Self' THEN 'S'
										   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(2)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.FirstName WHERE imp.cardholdername2 = pat.VendorID)
									       WHEN 'Other' THEN (SELECT pat.FirstName WHERE imp.cardholdername2 = pat.VendorID)  
										   WHEN 'Spouse' THEN (SELECT pat.FirstName WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderFirstName - varchar(64)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.MiddleName WHERE imp.cardholdername2 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.MiddleName WHERE imp.cardholdername2 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.MiddleName WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderMiddleName - varchar(64)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.LastName WHERE imp.cardholdername2 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.LastName WHERE imp.cardholdername2 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.LastName WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderLastName - varchar(64)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.Suffix WHERE imp.cardholdername2 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.Suffix WHERE imp.cardholdername2 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.Suffix WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderSuffix - varchar(26)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.DOB WHERE imp.cardholdername2 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.DOB WHERE imp.cardholdername2 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.DOB WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.Gender WHERE imp.cardholdername2 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.Gender WHERE imp.cardholdername2 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.Gender WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderGender - char(1)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.AddressLine1 WHERE imp.cardholdername2 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.AddressLine1 WHERE imp.cardholdername2 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.AddressLine1 WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderAddressLine1 - varchar(256)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.AddressLine2 WHERE imp.cardholdername2 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.AddressLine2 WHERE imp.cardholdername2 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.AddressLine2 WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderAddressLine2 - varchar(256)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.City WHERE imp.cardholdername2 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.City WHERE imp.cardholdername2 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.City WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderCity - varchar(128)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.State WHERE imp.cardholdername2 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.State WHERE imp.cardholdername2 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.State WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderState - varchar(2)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN (SELECT pat.ZipCode WHERE imp.cardholdername2 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.ZipCode WHERE imp.cardholdername2 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.ZipCode WHERE imp.cardholdername2 = pat.VendorID) 
										   ELSE '' END , -- HolderZipCode - varchar(9)
          CASE imp.cardholderrelationship2 WHEN 'Child' THEN imp.inspolicyno2
										   WHEN 'Other' THEN imp.inspolicyno2
										   WHEN 'Spouse' THEN imp.inspolicyno2
										   ELSE '' END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.patientcode , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
		  imp.insrestrictions2 -- Notes
FROM dbo.[_import_5_1_PatientCasePolicyUpdate] imp
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = imp.patientcode AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = imp.inscode2 AND
		icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.Patient pat ON 
		pat.VendorID = imp.cardholdername1
WHERE imp.inscode2 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into InsurancePolicy3...'
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
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID , 
		  Notes
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          imp.inspolicyno3 , -- PolicyNumber - varchar(32)
          imp.insgroupno3 , -- GroupNumber - varchar(32)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN 'C'
										   WHEN 'Other' THEN 'O'
										   WHEN 'Spouse' THEN 'U'
										   WHEN 'Self' THEN 'S'
										   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(2)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.FirstName WHERE imp.cardholdername3 = pat.VendorID)
									       WHEN 'Other' THEN (SELECT pat.FirstName WHERE imp.cardholdername3 = pat.VendorID)  
										   WHEN 'Spouse' THEN (SELECT pat.FirstName WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END, -- HolderFirstName - varchar(64)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.MiddleName WHERE imp.cardholdername3 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.MiddleName WHERE imp.cardholdername3 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.MiddleName WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END , -- HolderMiddleName - varchar(64)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.LastName WHERE imp.cardholdername3 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.LastName WHERE imp.cardholdername3 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.LastName WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END , -- HolderLastName - varchar(64)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.Suffix WHERE imp.cardholdername3 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.Suffix WHERE imp.cardholdername3 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.Suffix WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END , -- HolderSuffix - varchar(26)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.DOB WHERE imp.cardholdername3 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.DOB WHERE imp.cardholdername3 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.DOB WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.Gender WHERE imp.cardholdername3 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.Gender WHERE imp.cardholdername3 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.Gender WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END , -- HolderGender - char(1)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.AddressLine1 WHERE imp.cardholdername3 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.AddressLine1 WHERE imp.cardholdername3 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.AddressLine1 WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END , -- HolderAddressLine1 - varchar(256)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.AddressLine2 WHERE imp.cardholdername3 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.AddressLine2 WHERE imp.cardholdername3 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.AddressLine2 WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END , -- HolderAddressLine2 - varchar(256)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.City WHERE imp.cardholdername3 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.City WHERE imp.cardholdername3 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.City WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END , -- HolderCity - varchar(128)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.State WHERE imp.cardholdername3 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.State WHERE imp.cardholdername3 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.State WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END , -- HolderState - varchar(2)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN (SELECT pat.ZipCode WHERE imp.cardholdername3 = pat.VendorID)
										   WHEN 'Other' THEN (SELECT pat.ZipCode WHERE imp.cardholdername3 = pat.VendorID) 
										   WHEN 'Spouse' THEN (SELECT pat.ZipCode WHERE imp.cardholdername3 = pat.VendorID) 
										   ELSE '' END , -- HolderZipCode - varchar(9)
          CASE imp.cardholderrelationship3 WHEN 'Child' THEN imp.inspolicyno3
										   WHEN 'Other' THEN imp.inspolicyno3
										   WHEN 'Spouse' THEN imp.inspolicyno3
										   ELSE '' END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.patientcode , -- VendorID - varchar(50)
          @VendorImportID ,  -- VendorImportID - int
		  imp.insrestrictions3 -- Notes
FROM dbo.[_import_5_1_PatientCasePolicyUpdate] imp
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = imp.patientcode AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = imp.inscode3 AND
		icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.Patient pat ON 
		pat.VendorID = imp.cardholdername1
WHERE imp.inscode3 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT


