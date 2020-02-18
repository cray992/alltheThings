USE superbill_33955_dev
--USE superbill_33955_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0 AND CreatedDate > DATEADD(hh,-2,GETDATE())
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
*/

PRINT ''
PRINT 'Inserting Insurance Company Plan - Existing Company...'
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
          PhoneExt ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReviewCode ,
          CreatedPracticeID ,
          Fax ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  i.insname , -- PlanName - varchar(128)
          i.insaddress1 , -- AddressLine1 - varchar(256)
          i.insaddress2 , -- AddressLine2 - varchar(256)
          i.inscity , -- City - varchar(128)
          i.insstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.inszipcode, -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16) 
          RIGHT(dbo.fn_RemoveNonNumericCharacters(i.inszipcode),10) , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          RIGHT(dbo.fn_RemoveNonNumericCharacters(i.inszipcode),10) , -- Fax - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.insid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_insurances] i
INNER JOIN dbo.InsuranceCompany ic ON
	ic.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany
								WHERE i.insname = InsuranceCompanyName AND
									(ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurane Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
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
		  i.insname , -- InsuranceCompanyName - varchar(128)
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 , -- EClaimsAccepts - bit
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
          i.insname , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_insurances] i
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = i.insname AND CreatedPracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurane Company Plan...'
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
          PhoneExt ,
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
		  icp.insname , -- PlanName - varchar(128)
          icp.insaddress1 , -- AddressLine1 - varchar(256)
          icp.insaddress2 , -- AddressLine2 - varchar(256)
          icp.inscity , -- City - varchar(128)
          icp.insstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          icp.inszipcode, -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16) 
          RIGHT(dbo.fn_RemoveNonNumericCharacters(icp.inszipcode),10) , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          RIGHT(dbo.fn_RemoveNonNumericCharacters(icp.inszipcode),10) , -- Fax - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.insid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_insurances] icp
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.insname, 50) AND
	ICP.insname = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.insid = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
	      i.employer , -- EmployerName - varchar(128)
          i.employeraddress , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          '' , -- City - varchar(128)
          '' , -- State - varchar(2)
          '' , -- Country - varchar(32)
          '' , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_1_patientdemographics] i
WHERE NOT EXISTS (SELECT * FROM dbo.Employers e WHERE i.employer = e.EmployerName) AND i.employer <> ''
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
          DefaultServiceLocationID ,
          EmployerID ,
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
		  @PracticeID , -- PracticeID - int
          NULL , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.middlename , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.[address] , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.postalcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.postalcode) 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.postalcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.postalcode) 
		  ELSE '' END  , -- ZipCode - varchar(9)
          CASE i.gender 
			   WHEN 'Female' THEN 'F'
			   WHEN 'Male' THEN 'M'
			   WHEN 'M' THEN 'M'
			   WHEN 'F' THEN 'F'
		  ELSE 'U' END , -- Gender - varchar(1)
          i.maritalstatus , -- MaritalStatus - varchar(1)
          CASE	
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phonehome)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phonehome),10)
		  ELSE '' END , -- HomePhone - varchar(10)
          CASE 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phonehome)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.phonehome),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.phonehome))),10)
		  ELSE '' END , -- HomePhoneExt - varchar(10)
          CASE	
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phonework)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phonework),10) 
		  ELSE '' END , -- WorkPhone - varchar(10)
          CASE 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phonework)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.phonework),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.phonework))),10)
		  ELSE '' END , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(i.dob) = 1 THEN i.dob ELSE NULL END  , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.ssn),9) ELSE '' END , -- SSN - char(9)
          CASE WHEN i.email <> '' THEN i.email ELSE i.prefix END , -- EmailAddress - varchar(256)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN i.responsiblefirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN i.responsiblemiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN i.responsiblelastname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN '' END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN i.responsibleaddress END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN '' END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN i.responsiblecity END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN i.responsiblestate END , -- ResponsibleState - varchar(2)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.responsiblefirstname <> '' AND i.responsiblefirstname <> i.firstname AND i.responsiblelastname <> i.lastname THEN i.responsiblezip END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.employer <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          1 , -- DefaultServiceLocationID - int
          e.EmployerID , -- EmployerID - int
          i.objectid , -- MedicalRecordNumber - varchar(128)
          CASE	
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phonemobile)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phonemobile),10) 
		  ELSE '' END  , -- MobilePhone - varchar(10)
          CASE 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phonemobile)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.phonemobile),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.phonemobile))),10)
		  ELSE '' END , -- MobilePhoneExt - varchar(10)
          i.objectid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          CASE WHEN i.emergencycontact = '' THEN '' ELSE i.emergencycontact +
		  CASE WHEN i.emergencycontactrelationship = '' THEN '' ELSE ' | Relation: ' + i.emergencycontactrelationship END END  , -- EmergencyName - varchar(128)
          CASE	
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.emergencycontactphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.emergencycontactphone),10) 
		  ELSE '' END  , -- EmergencyPhone - varchar(10)
          CASE 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.emergencycontactphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.emergencycontactphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.emergencycontactphone))),10)
		  ELSE '' END    -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_2_1_patientdemographics] i
LEFT JOIN dbo.Employers e ON 
	e.EmployerID = (SELECT TOP 1 EmployerID FROM dbo.Employers WHERE i.employer = EmployerName)
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
          1 , -- ShowExpiredInsurancePolicies - bit
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
FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID AND FirstName <> '' AND LastName <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into InsurancePolicy 1 of 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
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
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.primaryinsurancepolicy , -- PolicyNumber - varchar(32)
          i.primaryinsurancegroup , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.primaryinsuranceeffectivedate) = 1 THEN i.primaryinsuranceeffectivedate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.primaryinsuranceexpirationdate) = 1 THEN i.primaryinsuranceexpirationdate ELSE NULL END , -- PolicyEndDate - datetime
          1 , -- CardOnFile - bit
          CASE i.primaryinsurancefrprelation   WHEN 'self' THEN 'S'
											   WHEN '19' THEN 'C'
											   WHEN '1' THEN 'U' 
											   WHEN '53' THEN 'O'
											   WHEN 'G8' THEN 'O'
											   ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN i.primaryinsurancefrpfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN i.primaryinsurancefrpmiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN i.primaryinsurancefrplastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN CASE WHEN ISDATE(i.primaryinsurancefrpdob) = 1 THEN i.primaryinsurancefrpdob ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.primaryinsurancefrpssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.primaryinsurancefrpzip),9) ELSE '' END END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          NULL , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN CASE i.primaryinsurancefrpgender WHEN 'Female' THEN 'F'
																										   WHEN 'Male' THEN 'M'
																										   WHEN 'M' THEN 'M'
																										   WHEN 'F' THEN 'F'
																										   ELSE 'U' END END , -- HolderGender - char(1)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN i.primaryinsurancefrpaddress END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN i.primaryinsurancefrpaddress2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN i.primaryinsurancefrpcity END , -- HolderCity - varchar(128)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN i.primaryinsurancefrpstate END , -- HolderState - varchar(2)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN dbo.fn_RemoveNonNumericCharacters(i.primaryinsurancefrpzip) END , -- HolderZipCode - varchar(9)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.primaryinsurancefrpphone),10) END , -- HolderPhone - varchar(10)
          CASE WHEN i.primaryinsurancefrprelation NOT IN ('self','') THEN i.primaryinsurancepolicy END , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          dbo.fn_RemoveNonNumericCharacters(i.primaryinsurancecopayment) , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID+i.primaryinsurancepolicy , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_1_patientinsurances] i
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = i.objectid AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorID = i.primaryinsurance AND
	icp.VendorImportID = @VendorImportID AND
    i.primaryinsuranceaddress = icp.AddressLine1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into InsurancePolicy 2 of 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
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
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.secondaryinsurancepolicy , -- PolicyNumber - varchar(32)
          i.secondaryinsurancegroup , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.secondaryinsuranceeffectivedate) = 1 THEN i.secondaryinsuranceeffectivedate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.secondaryinsuranceexpirationdate) = 1 THEN i.secondaryinsuranceexpirationdate ELSE NULL END , -- PolicyEndDate - datetime
          1 , -- CardOnFile - bit
          CASE i.secondaryinsurancefrprelation WHEN 'self' THEN 'S'
											   WHEN '19' THEN 'C'
											   WHEN '1' THEN 'U' 
											   WHEN '53' THEN 'O'
											   WHEN 'G8' THEN 'O'
											   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN i.secondaryinsurancefrpfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN i.secondaryinsurancefrpmiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN i.secondaryinsurancefrplastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN CASE WHEN ISDATE(i.secondaryinsurancefrpdob) = 1 THEN i.secondaryinsurancefrpdob ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.secondaryinsurancefrpssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.secondaryinsurancefrpzip),9) ELSE '' END END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          NULL , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN CASE i.secondaryinsurancefrpgender WHEN 'Female' THEN 'F'
																										   WHEN 'Male' THEN 'M'
																										   WHEN 'M' THEN 'M'
																										   WHEN 'F' THEN 'F'
																										   ELSE 'U' END END , -- HolderGender - char(1)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN i.secondaryinsurancefrpaddress END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN i.secondaryinsurancefrpaddress2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN i.secondaryinsurancefrpcity END , -- HolderCity - varchar(128)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN i.secondaryinsurancefrpstate END , -- HolderState - varchar(2)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN dbo.fn_RemoveNonNumericCharacters(i.secondaryinsurancefrpzip) END , -- HolderZipCode - varchar(9)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.secondaryinsurancefrpphone),10) END , -- HolderPhone - varchar(10)
          CASE WHEN i.secondaryinsurancefrprelation NOT IN ('self','') THEN i.secondaryinsurancepolicy END , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          dbo.fn_RemoveNonNumericCharacters(i.secondaryinsurancecopayment) , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID+i.secondaryinsurancepolicy , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_1_patientinsurances] i
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = i.objectid AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorID = i.secondaryinsurance AND
	icp.VendorImportID = @VendorImportID AND
    i.secondaryinsuranceaddress = icp.AddressLine1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into InsurancePolicy 3 of 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
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
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          i.tertiaryinsurancepolicy , -- PolicyNumber - varchar(32)
          i.tertiaryinsurancegroup , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.tertiaryinsuranceeffectivedate) = 1 THEN i.tertiaryinsuranceeffectivedate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.tertiaryinsuranceexpirationdate) = 1 THEN i.tertiaryinsuranceexpirationdate ELSE NULL END , -- PolicyEndDate - datetime
          1 , -- CardOnFile - bit
          CASE i.tertiaryinsurancefrprelation  WHEN 'self' THEN 'S'
											   WHEN '19' THEN 'C'
											   WHEN '1' THEN 'U' 
											   WHEN '53' THEN 'O'
											   WHEN 'G8' THEN 'O'
											   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN i.tertiaryinsurancefrpfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN i.tertiaryinsurancefrpmiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN i.tertiaryinsurancefrplastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN CASE WHEN ISDATE(i.tertiaryinsurancefrpdob) = 1 THEN i.tertiaryinsurancefrpdob ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.tertiaryinsurancefrpssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.tertiaryinsurancefrpzip),9) ELSE '' END END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          NULL , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN CASE i.tertiaryinsurancefrpgender WHEN 'Female' THEN 'F'
																										   WHEN 'Male' THEN 'M'
																										   WHEN 'M' THEN 'M'
																										   WHEN 'F' THEN 'F'
																										   ELSE 'U' END END , -- HolderGender - char(1)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN i.tertiaryinsurancefrpaddress END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN i.tertiaryinsurancefrpcity END , -- HolderCity - varchar(128)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN i.tertiaryinsurancefrpstate END , -- HolderState - varchar(2)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN dbo.fn_RemoveNonNumericCharacters(i.tertiaryinsurancefrpzip) END , -- HolderZipCode - varchar(9)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN i.tertiaryinsurancefrpphone END , -- HolderPhone - varchar(10)
          CASE WHEN i.tertiaryinsurancefrprelation NOT IN ('self','') THEN i.tertiaryinsurancepolicy END , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          dbo.fn_RemoveNonNumericCharacters(i.tertiaryinsurancecopayment) , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID+i.tertiaryinsurancepolicy , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_1_patientinsurances] i
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorID = i.objectid AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorID = i.tertiaryinsurance AND
	icp.VendorImportID = @VendorImportID AND
	i.tertiaryinsuranceaddress = icp.AddressLine1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.schedulerapptname , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          i.schedulerapptname , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_2_1_patientappointments] i
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.schedulerapptname = ar.Name AND ar.PracticeID = @PracticeID) AND i.schedulerapptname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment...'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          DATEADD(hh,-3,i.starttime) , -- StartDate - datetime
          DATEADD(hh,-3,i.endtime) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.idschedulerappts , -- Subject - varchar(64)
          '' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.starttime,5), ':','') AS SMALLINT) - 300, -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.endtime,5),  ':', '') AS SMALLINT)- 300  -- EndTm - smallint
FROM dbo.[_import_2_1_patientappointments] i
INNER JOIN dbo.Patient p ON
	i.objectid = p.VendorID AND
	p.VendorImportID = @VendorImportID
LEFT JOIN dbo.PatientCase pc ON
	p.PatientID = pc.PatientID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice DK ON
	DK.PracticeID = @PracticeID AND
	DK.dt = CAST(CAST(i.starttime AS DATE) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_patientappointments] i
INNER JOIN dbo.Appointment a ON
	i.idschedulerappts = a.[Subject] AND
	a.PracticeID = @PracticeID
INNER JOIN dbo.AppointmentReason ar ON
	i.schedulerapptname = ar.Name AND
	ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.[resource] WHEN 'Badia, Alejandro' THEN 2
							WHEN 'Husain, Tarik' THEN 5
							WHEN 'Serralta, Yanira' THEN 6
		  END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_patientappointments] i
INNER JOIN dbo.Appointment a ON
	i.idschedulerappts = a.[Subject] AND
	a.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11 , Name = 'Self Pay'
FROM dbo.PatientCase pc
LEFT JOIN dbo.InsurancePolicy ip ON
	pc.PatientID = ip.PatientCaseID AND
	ip.PracticeID = @PracticeiD
WHERE ip.PatientCaseID IS NULL AND pc.VendorImportID = @VendorImportID

--ROLLBACK
--COMMIT

