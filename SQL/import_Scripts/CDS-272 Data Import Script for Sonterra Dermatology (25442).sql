USE superbill_25442_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @VendorImportID = 4
SET @PracticeID = 1



--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'

PRINT ''
PRINT 'Updating dbo.[_import_4_1_PatientDemoReport] Account / PatientID...'
UPDATE dbo.[_import_4_1_PatientDemoReport]
SET account = account + '00'
FROM dbo.[_import_4_1_PatientDemoReport]
WHERE account IN (1,2)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '

PRINT ''
PRINT 'Inserting Into Referring Providers...'
INSERT INTO dbo.Doctor
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
          HomePhone ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          addressline1 , -- AddressLine1 - varchar(256)
          addressline2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(zipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) IN (3,7) THEN '00' + dbo.fn_RemoveNonNumericCharacters(zipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zipcode) ELSE '' END , -- ZipCode - varchar(9)
          phonenumber , -- WorkPhone - varchar(10)
          CASE WHEN medicaidprovider = '' THEN '' ELSE 'Medicaid Provider #: ' + medicaidprovider + CHAR(13) + CHAR(10) END +
		  (CASE WHEN medicareprovider = '' THEN '' ELSE 'Medicare Provider #: ' + medicareprovider + CHAR(13) + CHAR(10) END)  , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          referringphysiciannumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          faxnumber , -- FaxNumber - varchar(10)
          1  -- External - bit
FROM dbo.[_import_4_1_ReferringProviders]
WHERE referringphysiciannumber <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
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
		  InsuranceCompanyName , -- InsuranceCompanyName - varchar(128)
           CASE WHEN insurancegroupnumber = '' THEN '' ELSE 'Insurance Group Number: ' + insurancegroupnumber + CHAR(13) + CHAR(10) END + 
		  (CASE WHEN medicareassignedmedigapcode = '' THEN '' ELSE 'Medicare Assigned Medigap Code: ' + medicareassignedmedigapcode + CHAR(13) + CHAR(10) END) , -- Notes - text
          addressline1 , -- AddressLine1 - varchar(256)
          addressline2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(zipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) IN (3,7) THEN '00' + dbo.fn_RemoveNonNumericCharacters(zipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zipcode) ELSE '' END, -- ZipCode - varchar(9)
          phonenumber , -- Phone - varchar(10)
          13 , -- BillingFormID - int
          'CI', -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          insurancecode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_4_1_InsuranceCompanyList] 
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
          Phone ,
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
          [State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
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
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient...'
SET IDENTITY_INSERT dbo.Patient ON
INSERT INTO dbo.Patient
        ( PatientID ,
		  PracticeID ,
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
          WorkPhone ,
          WorkPhoneExt ,
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
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
		  imp.account ,
		  @PracticeID , -- PracticeID - int
          doc.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          imp.firstnamepatient , -- FirstName - varchar(64)
          imp.middleinitialpatient , -- MiddleName - varchar(64)
          imp.lastnamepatient , -- LastName - varchar(64)
          imp.suffixpatient , -- Suffix - varchar(16)
          imp.[address] , -- AddressLine1 - varchar(256)
          imp.addressline2patient , -- AddressLine2 - varchar(256)
          imp.citypatient , -- City - varchar(128)
          imp.statepatient , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zipcodepatient)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.zipcodepatient)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zipcodepatient)) IN (3,7) THEN '00' + dbo.fn_RemoveNonNumericCharacters(imp.zipcodepatient)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zipcodepatient)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.zipcodepatient) 
			   ELSE '' END , -- ZipCode - varchar(9)
          CASE WHEN imp.sexofpatient = '' THEN 'U' ELSE imp.sexofpatient END , -- Gender - varchar(1)
          CASE WHEN imp.maritalstatuspatient = 'O' THEN '' ELSE imp.maritalstatuspatient END , -- MaritalStatus - varchar(1)
          imp.phone , -- HomePhone - varchar(10)
          imp.workphonepatient , -- WorkPhone - varchar(10)
          imp.workextensionpatient , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(imp.dateofbirthpatient) = 1 THEN imp.dateofbirthpatient ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(imp.socialsecuritynumber) >= 5 THEN RIGHT('0000' + imp.socialsecuritynumber,9) ELSE '' END, -- SSN - char(9)
          imp.emailaddress ,  -- EmailAddress - varchar(256)
          CASE WHEN imp.responsibilty <> 'S' THEN 1 ELSE 0 END, -- ResponsibleDifferentThanPatient - bit
          CASE WHEN imp.responsibilty <> 'S' THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN imp.responsibilty <> 'S' THEN imp.firstnameresponsibleparty ELSE '' END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN imp.responsibilty <> 'S' THEN imp.middleinitialrespparty ELSE '' END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN imp.responsibilty <> 'S' THEN imp.lastnameresponsibleparty ELSE '' END , -- ResponsibleLastName - varchar(64)
          CASE WHEN imp.responsibilty <> 'S' THEN imp.suffixresponsibleparty ELSE '' END , -- ResponsibleSuffix - varchar(16)
          CASE imp.responsibilty WHEN '' THEN 'S' ELSE imp.responsibilty END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN imp.responsibilty <> 'S' THEN imp.addressline1respparty ELSE '' END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN imp.responsibilty <> 'S' THEN imp.addressline2respparty ELSE '' END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN imp.responsibilty <> 'S' THEN imp.cityresponsibleparty ELSE '' END , -- ResponsibleCity - varchar(128)
          CASE WHEN imp.responsibilty <> 'S' THEN imp.stateresponsibleparty ELSE '' END , -- ResponsibleState - varchar(2)
          CASE WHEN imp.responsibilty <> 'S' THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN imp.responsibilty <> 'S' THEN 
			   CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zipcoderesponsibleparty)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.zipcoderesponsibleparty) 
			   	    WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zipcoderesponsibleparty)) IN (3,7) THEN '00' + dbo.fn_RemoveNonNumericCharacters(imp.zipcoderesponsibleparty)
				    WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zipcoderesponsibleparty)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.zipcoderesponsibleparty) 
					ELSE '' END END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.employmentstatuspatient = '' THEN 'U' ELSE imp.employmentstatuspatient END, -- EmploymentStatus - char(1)
          CASE WHEN imp.doctorofrecord <> '' THEN imp.doctorofrecord ELSE NULL END , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          imp.account , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          imp.active , -- Active - bit
          CASE WHEN imp.emailaddress <> '' THEN 1 ELSE 0 END , -- SendEmailCorrespondence - bit
          imp.emercencycontact , -- EmergencyName - varchar(128)
          imp.emergencycontactphone  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_4_1_PatientDemoReport] imp
	LEFT JOIN dbo.Doctor doc ON 
		doc.VendorID = imp.referringphysiciannumber AND
		doc.VendorImportID = @VendorImportID
WHERE imp.firstnamepatient <> '' AND imp.lastnamepatient <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
SET IDENTITY_INSERT dbo.Patient OFF



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
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Policies...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
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
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          imp.precedence , -- Precedence - int
          imp.policy , -- PolicyNumber - varchar(32)
          imp.[group] , -- GroupNumber - varchar(32)
          CASE WHEN imp.effectivedatestart <> '' THEN imp.effectivedatestart ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN imp.effectivedateend <> '' THEN imp.effectivedateend ELSE NULL END  , -- PolicyEndDate - datetime
          CASE imp.relationtopatient WHEN 1 THEN 'S'
								 WHEN 2 THEN 'U'
								 WHEN 3 THEN 'C'
								 ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN imp.relationtopatient <> 1 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN imp.relationtopatient <> 1 THEN imp.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN imp.relationtopatient <> 1 THEN imp.middleinitial END , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.relationtopatient <> 1 THEN imp.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN imp.relationtopatient <> 1 THEN CASE imp.generation WHEN 'SR' THEN 'Sr'
																	WHEN 'JR' THEN 'Jr' 
																	WHEN 'I' THEN 'I' 
																	WHEN 'II' THEN 'II'
																	WHEN 'III' THEN 'III'
																	WHEN 'IV' THEN 'IV' 
																	WHEN 'V' THEN 'V' 
																	ELSE '' END END, -- HolderSuffix - varchar(16)
          CASE WHEN imp.relationtopatient <> 1 THEN imp.birthday END ,  -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.relationtopatient <> 1 THEN 'U' END , -- HolderGender - char(1)
          CASE WHEN imp.relationtopatient <> 1 THEN imp.addressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.relationtopatient <> 1 THEN imp.addressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.relationtopatient <> 1 THEN imp.city END , -- HolderCity - varchar(128)
          CASE WHEN imp.relationtopatient <> 1 THEN imp.[state] END , -- HolderState - varchar(2)
          CASE WHEN imp.relationtopatient <> 1 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN imp.relationtopatient <> 1 THEN  
		  (CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(imp.zipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zipcode)) IN (3,7) THEN '00' + dbo.fn_RemoveNonNumericCharacters(imp.zipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(imp.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(imp.zipcode) ELSE '' END) END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.relationtopatient <> 1 THEN imp.policy ELSE '' END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' +
		  CASE WHEN imp.createdbydate = '' THEN '' ELSE CHAR(13)+CHAR(10)+ 'Created Date from Import File: ' + imp.createdbydate END , -- Notes - text
          1 , -- Active - bit
           @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_1_PatPolicy] imp
	INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = imp.account AND
	pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorID = imp.insurancecode AND
	icp.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient Alert...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          ShowInEncounterFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT DISTINCT
		  pat.PatientID , -- PatientID - int
          'Please verify Patient Insurance Policies' , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_4_1_PatPolicy] imp
	INNER JOIN dbo.Patient pat ON 
	pat.VendorID = imp.account AND 
	pat.VendorImportID = @VendorImportID
WHERE imp.precedence > 2 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



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


--COMMIT
--ROLLBACK

