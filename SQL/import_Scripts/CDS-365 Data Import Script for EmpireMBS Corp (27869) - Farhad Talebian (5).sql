USE superbill_27869_dev
--USE superbill_27869_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID5 INT
DECLARE @Practice5VendorImportID INT

SET @PracticeID5 = 5
SET @Practice5VendorImportID = 5

PRINT ''
PRINT ''
PRINT 'PracticeID = ' + CAST(@PracticeID5 AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@Practice5VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID5 AND VendorImportID = @Practice5VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @Practice5VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @Practice5VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID5 AND VendorImportID = @Practice5VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID5 AND VendorImportID = @Practice5VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID5 AND VendorImportID = @Practice5VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID5 AND VendorImportID = @Practice5VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID5 AND VendorImportID = @Practice5VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'


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
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
		  PhoneExt , 
          Fax ,
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
	      i.insurancename , -- InsuranceCompanyName - varchar(128)
          CASE WHEN i.insurancenotes = '' THEN '' ELSE 'Notes: ' + i.insurancenotes + CHAR(13) + CHAR(10) END +
		 (CASE WHEN i.insurancetelephonebenefits = '' THEN '' ELSE 'Phone Benefits: ' + i.insurancetelephonebenefits + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN i.insurancetelephoneauthorization = '' THEN '' ELSE 'Phone Authorization: ' + i.insurancetelephoneauthorization + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN i.insurancetelephonerelations = '' THEN '' ELSE 'Phone Relations: ' + i.insurancetelephonerelations END) , -- Notes - text
          i.insuranceaddress1 , -- AddressLine1 - varchar(256)
          i.insuranceaddress2 , -- AddressLine2 - varchar(256)
          i.insurancecity , -- City - varchar(128)
          i.insurancestate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(insurancezipcode,'-','') , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          i.insurancecontact , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.insurancephone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.insurancephone),10) ELSE '' END , -- Phone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.insurancephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.insurancephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.insurancephone))),10)
		  ELSE NULL END , -- PhoneExt
		  i.insurancetelephonefax , -- Fax - varchar(10)
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID5 , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          i.insurancecode , -- VendorID - varchar(50)
          @Practice5VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_5_5_InsuranceMaster] i
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
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
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
		  ic.InsuranceCompanyName , -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
          ic.AddressLine2 , -- AddressLine2 - varchar(256)
          ic.City , -- City - varchar(128)
          ic.[State] , -- State - varchar(2)
          ic.Country , -- Country - varchar(32)
          ic.ZipCode , -- ZipCode - varchar(9)
          ic.ContactPrefix , -- ContactPrefix - varchar(16)
          ic.ContactFirstName , -- ContactFirstName - varchar(64)
          ic.ContactMiddleName , -- ContactMiddleName - varchar(64)
          ic.ContactLastName , -- ContactLastName - varchar(64)
          ic.ContactSuffix , -- ContactSuffix - varchar(16)
          ic.Phone , -- Phone - varchar(10)
          CAST(Notes AS VARCHAR) , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID5 , -- CreatedPracticeID - int
          ic.Fax , -- Fax - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.VendorID , -- VendorID - varchar(50)
          @Practice5VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany ic
WHERE VendorImportID = @Practice5VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
          WorkPhone ,
          PagerPhone ,
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
	      @PracticeID5 , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          referringfirstname , -- FirstName - varchar(64)
          referringmiddleinitial , -- MiddleName - varchar(64)
          referringlastname , -- LastName - varchar(64)
          referringsuffix , -- Suffix - varchar(16)
		  referringsocialsecurity , -- SSN 
          referringaddress1 , -- AddressLine1 - varchar(256)
          referringaddress2 , -- AddressLine2 - varchar(256)
          referringcity , -- City - varchar(128)
          referringstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          referringzipcode , -- ZipCode - varchar(9)
          referringphone , -- WorkPhone - varchar(10)
		  referringpager , -- Pager
		  referringemail , -- Email
          CASE WHEN referringupin = '' THEN '' ELSE 'Upin: ' + referringupin + CHAR(13) + CHAR(10) END +
		 (CASE WHEN referringtaxid = '' THEN '' ELSE 'TaxID: ' + referringtaxid + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN referringnotes = '' THEN '' ELSE 'Notes: ' + referringnotes END) , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          referringcredentials , -- Degree - varchar(8)
          referringidentity , -- VendorID - varchar(50)
          @Practice5VendorImportID , -- VendorImportID - int
          referringfax , -- FaxNumber - varchar(10)
          1 , -- External - bit
          referringnpi  -- NPI - varchar(10)
FROM dbo.[_import_5_5_ReferringMaster]
WHERE referringidentity <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Patient...'
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
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt 
        )
SELECT DISTINCT
		  @PracticeID5 , -- PracticeID - int
          rd.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.patientfirstname , -- FirstName - varchar(64)
          i.patientmiddleinitial , -- MiddleName - varchar(64)
          i.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.patientaddress1 , -- AddressLine1 - varchar(256)
          i.patientaddress2 , -- AddressLine2 - varchar(256)
          i.patientcity , -- City - varchar(128)
          i.patientstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
           CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)
                WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)
            ELSE '' END , -- ZipCode - varchar(9)
          CASE i.patientsex WHEN 'Female' THEN 'F'
							WHEN 'Male' THEN 'M'
							ELSE 'U' END , -- Gender - varchar(1)
          CASE i.patientmaritalstatus WHEN 'Married' THEN 'M'
									  WHEN 'Separated' THEN 'L'
									  WHEN 'Divorced' THEN 'D'
									  WHEN 'Widowed' THEN 'W'
									  WHEN 'Partnered' THEN 'T'
									  WHEN 'Single' THEN 'S'
									  ELSE '' END  , -- MaritalStatus - varchar(1)
	      CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientphone),10) ELSE '' END , -- HomePhone - varchar(10)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone))),10)
		  ELSE NULL END  , -- HomePhoneExt - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone),10) ELSE '' END , -- WorkPhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone))),10)
		  ELSE NULL END , -- WorkPhoneExt - varchar(10)
          CONVERT(DATETIME,i.PatientDateOfBirth,102) , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientsocialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.patientsocialsecurity), 9)
		  ELSE NULL END  , -- SSN - char(9)
          i.patientemailaddress , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.patientemployercode <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          i.patientaccountnumber , -- MedicalRecordNumber - varchar(128)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone),10) ELSE '' END , -- MobilePhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone))),10)
		  ELSE NULL END , -- MobilePhoneExt - varchar(10)
          i.patientaccountnumber , -- VendorID - varchar(50)
          @Practice5VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          i.patientemergencyfirstname + ' ' + i.patientemergencymiddleinitial + ' ' + i.patientlastname + CASE WHEN i.patientemergencyrelationship <> '' THEN ' | ' + i.patientemergencyrelationship ELSE '' END , -- EmergencyName - varchar(128)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientemergencyphone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientemergencyphone),10) ELSE '' END, -- EmergencyPhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientemergencyphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientemergencyphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientemergencyphone))),10)
		  ELSE NULL END   -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_5_5_FarhadTalebian5] i
	LEFT JOIN dbo.Doctor rd ON
		i.patientreferringcode = rd.VendorID AND
		rd.VendorImportID = @Practice5VendorImportID
WHERE i.patientaccountnumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
		  p.PatientID , -- PatientID - int
          'Class Code - ' + i.patientclasscode , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          1 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_5_5_FarhadTalebian5] i
	INNER JOIN dbo.Patient p ON
		p.VendorID = i.patientaccountnumber AND
		p.VendorImportID = @Practice5VendorImportID
WHERE i.patientclasscode <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
          @PracticeID5 , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @Practice5VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient 
WHERE VendorImportID = @Practice5VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Insert Into Insurance Policy...'
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
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.policylevel , -- Precedence - int
          i.policynumber , -- PolicyNumber - varchar(32)
          i.policygroupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(CONVERT(DATETIME,i.policystartdate,102)) = 1 THEN CONVERT(DATETIME,i.policystartdate,102) ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(CONVERT(DATETIME,i.policyenddate,102)) = 1 THEN CONVERT(DATETIME,i.policyenddate,102) ELSE NULL END , -- PolicyEndDate - datetime
          CASE i.policyrelationship WHEN 1 THEN 'S' 
									WHEN 2 THEN 'U' 
									WHEN 3 THEN 'C'
									ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.policyrelationship <> 1 THEN '' ELSE NULL END, -- HolderPrefix - varchar(16)
          CASE WHEN i.policyrelationship <> 1 THEN i.policyfirstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.policyrelationship <> 1 THEN i.policymiddleinitial ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.policyrelationship <> 1 THEN i.policylastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.policyrelationship <> 1 THEN '' ELSE NULL END, -- HolderSuffix - varchar(16)
          CASE WHEN i.policyrelationship <> 1 THEN CONVERT(DATETIME,i.policydateofbirth,102) ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN i.policyrelationship <> 1 THEN 
			CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policysocialsecurity)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.policysocialsecurity), 9)
			ELSE NULL END ELSE NULL END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.policyrelationship <> 1 THEN CASE i.policysex WHEN 'Female' THEN 'F'
																	WHEN 'Male' THEN 'M'
																	ELSE 'U' END ELSE NULL END , -- HolderGender - char(1)
          CASE WHEN i.policyrelationship <> 1 THEN i.policyaddress1 ELSE NULL END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.policyrelationship <> 1 THEN i.policyaddress2 ELSE NULL END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.policyrelationship <> 1 THEN i.policycity ELSE NULL END , -- HolderCity - varchar(128)
          CASE WHEN i.policyrelationship <> 1 THEN i.policystate ELSE NULL END , -- HolderState - varchar(2)
          CASE WHEN i.policyrelationship <> 1 THEN '' ELSE NULL END , -- HolderCountry - varchar(32)
          CASE WHEN i.policyrelationship <> 1 THEN 
			CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policyzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.policyzipcode)
            WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policyzipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.policyzipcode)
            ELSE '' END ELSE NULL END , -- HolderZipCode - varchar(9)
          CASE WHEN i.policyrelationship <> 1 THEN 
			CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policyphone))>= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.policyphone),10) 
			ELSE '' END ELSE NULL END , -- HolderPhone - varchar(10)
          CASE WHEN i.policyrelationship <> 1 THEN 
			CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policyphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.policyphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.policyphone))),10) 
			ELSE '' END ELSE NULL END, -- HolderPhoneExt - varchar(10)
          CASE WHEN i.policyrelationship <> 1 THEN i.policynumber ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          i.policycopay , -- Copay - money
          1 , -- Active - bit
          @PracticeID5 , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @Practice5VendorImportID , -- VendorImportID - int
          LEFT(i.policygroupname, 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_5_5_PolicyMaster] i
	INNER JOIN dbo.PatientCase pc ON
		i.policyaccountnumber = pc.VendorID AND
		pc.VendorImportID = @Practice5VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		i.policyinsurancecode = icp.VendorID AND
		icp.CreatedPracticeID = @PracticeID5
WHERE CAST(i.policyenddate AS DATETIME) > GETDATE()
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 ,
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @Practice5VendorImportID AND
              ip.PatientCaseID IS NULL AND
			  pc.PayerScenarioID = 5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--COMMIT
--ROLLBACK