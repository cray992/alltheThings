USE superbill_27907_dev
--USE superbill_27907_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 1
SET @PracticeID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))



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
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = -50 AND ModifiedUserID = -50
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'



PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          Fax ,
          FaxExt ,
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
		  institution , -- InsuranceCompanyName - varchar(128)
          street , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(zip) 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zip)
			   ELSE '' END , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          contact , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          LEFT(phone, 10) , -- Phone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(fax)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(fax), 10) ELSE '' END , -- Fax - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(fax)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(fax),11,LEN(dbo.fn_RemoveNonNumericCharacters(fax))),10)ELSE '' END, -- FaxExt - varchar(10)
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
          insurancecompanyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceAddrBook] 
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
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          FaxExt ,
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
          ContactPrefix , -- ContactPrefix - varchar(16)
          ContactFirstName , -- ContactFirstName - varchar(64)
          ContactMiddleName , -- ContactMiddleName - varchar(64)
          ContactLastName , -- ContactLastName - varchar(64)
          ContactSuffix , -- ContactSuffix - varchar(16)
          Phone , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
          FaxExt , -- FaxExt - varchar(10)
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Referring Doctor...'
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
		  WorkPhone ,
		  WorkPhoneExt ,
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
          FaxNumberExt ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          fname , -- FirstName - varchar(64)
          mname , -- MiddleName - varchar(64)
          lname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          street , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(zip) IN (4,8) THEN '0' + zip WHEN LEN(zip) IN (5,9) THEN zip ELSE '' END , -- ZipCode - varchar(9)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(phone), 10) ELSE '' END , -- WorkPhone - varchar(10)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(phone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(phone),11,LEN(dbo.fn_RemoveNonNumericCharacters(phone))),10)ELSE '' END , -- WorkPhoneExt - varchar(10)
          email , -- EmailAddress - varchar(256)
          CASE WHEN specialty = '' THEN '' ELSE 'Specialty: ' + specialty + CHAR(13) + CHAR(10) END +
		 (CASE WHEN alternateid = '' THEN '' ELSE 'AlternateID: ' + alternateid + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN upin = '' THEN '' ELSE 'UPin: ' + upin END), -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          degree , -- Degree - varchar(8)
          id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(fax)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(fax), 10) ELSE '' END , -- Fax - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(fax)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(fax),11,LEN(dbo.fn_RemoveNonNumericCharacters(fax))),10)ELSE '' END, -- FaxExt - varchar(10)
          1 , -- External - bit
          npi  -- NPI - varchar(10)
FROM dbo.[_import_1_1_RefProvidersAddrBook]
WHERE fname <> '' and lname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Emnployers...'
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
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_1_1_Patient] WHERE employer <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          rd.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.fname , -- FirstName - varchar(64)
          i.mname , -- MiddleName - varchar(64)
          i.lname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.street , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(i.zip) IN (4,8) THEN '0' + i.zip WHEN LEN(i.zip) IN (5,9) THEN i.zip ELSE '' END, -- ZipCode - varchar(9)
          CASE i.sex WHEN '' THEN 'U' ELSE i.sex END , -- Gender - varchar(1)
          i.phone , -- HomePhone - varchar(10)
          dbo.fn_RemoveNonNumericCharacters(i.workphone) , -- WorkPhone - varchar(10)
          CASE WHEN ISDATE(i.dob) = 1 THEN i.dob ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(i.ssn) >= 6 THEN RIGHT('000' + i.ssn , 9) ELSE NULL END , -- SSN - char(9)
          i.email , -- EmailAddress - varchar(256)
          CASE WHEN g.relationship <> 'Self' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN g.relationship <> 'Self' THEN '' ELSE NULL END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN g.relationship <> 'Self' THEN g.fname ELSE NULL END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN g.relationship <> 'Self' THEN g.mname ELSE NULL END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN g.relationship <> 'Self' THEN g.lname ELSE NULL END , -- ResponsibleLastName - varchar(64)
          CASE WHEN g.relationship <> 'Self' THEN '' ELSE NULL END , -- ResponsibleSuffix - varchar(16)
          CASE g.relationship WHEN 'Other' THEN 'O' ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN g.relationship <> 'Self' THEN g.street ELSE NULL END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN g.relationship <> 'Self' THEN '' ELSE NULL END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN g.relationship <> 'Self' THEN g.city ELSE NULL END , -- ResponsibleCity - varchar(128)
          CASE WHEN g.relationship <> 'Self' THEN g.[state] ELSE NULL END , -- ResponsibleState - varchar(2)
          CASE WHEN g.relationship <> 'Self' THEN '' ELSE NULL END , -- ResponsibleCountry - varchar(32)
          CASE WHEN g.relationship <> 'Self' THEN 
			CASE WHEN LEN(g.zip) IN (4,8) THEN '0' + g.zip WHEN LEN(g.zip) IN (5,9) THEN g.zip ELSE '' END ELSE NULL END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.employer <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          1 , -- DefaultServiceLocationID - int
          e.EmployerID , -- EmployerID - int
          i.clpatid , -- MedicalRecordNumber - varchar(128)
          i.cellphone , -- MobilePhone - varchar(10)
          i.clpatid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_1_1_Patient] i
	LEFT JOIN dbo.Doctor rd ON 
		i.refdocid = rd.VendorID AND
		rd.[External] = 1 AND
		rd.VendorImportID = @VendorImportID
	LEFT JOIN dbo.[_import_1_1_Guarantor] g ON
		i.clpatid = g.patid
	LEFT JOIN dbo.Employers e ON 
		i.employer = e.EmployerName
WHERE i.fname <> '' AND i.lname <> ''
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
FROM dbo.Patient WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Policy...'
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
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.[priority] , -- Precedence - int
          i.policynumber , -- PolicyNumber - varchar(32)
          i.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(effectivedate) = 1 THEN effectivedate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE([expiredate]) = 1 THEN [expiredate] ELSE NULL END , -- PolicyEndDate - datetime
          CASE relationship WHEN 'Other' THEN 'O'
							WHEN 'Spouse' THEN 'U'
							WHEN 'Guardian' THEN 'O'
							ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.relationship <> 'Self' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.relationship <> 'Self' THEN fname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.relationship <> 'Self' THEN mname ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.relationship <> 'Self' THEN lname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.relationship <> 'Self' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          CASE WHEN i.relationship <> 'Self' THEN 
			CASE WHEN ISDATE(i.dob) = 1 THEN i.dob ELSE NULL END ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN i.relationship <> 'Self' THEN 
			CASE WHEN LEN(i.ssn) >= 6 THEN RIGHT('000' + ssn, 9) ELSE '' END ELSE NULL END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.relationship <> 'Self' THEN i.sex ELSE NULL END , -- HolderGender - char(1)
          CASE WHEN i.relationship <> 'Self' THEN i.street ELSE NULL END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.relationship <> 'Self' THEN '' ELSE NULL END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.relationship <> 'Self' THEN i.city ELSE NULL END , -- HolderCity - varchar(128)
          CASE WHEN i.relationship <> 'Self' THEN i.[state] ELSE NULL END , -- HolderState - varchar(2)
          CASE WHEN i.relationship <> 'Self' THEN '' ELSE NULL END , -- HolderCountry - varchar(32)
          CASE WHEN i.relationship <> 'Self' THEN 
			CASE WHEN LEN(i.zip) IN (4,8) THEN '0' + i.zip WHEN LEN(i.zip) IN (5,9) THEN i.zip ELSE '' END ELSE NULL END , -- HolderZipCode - varchar(9)
          CASE WHEN i.relationship <> 'Self' THEN i.phone ELSE NULL END , -- HolderPhone - varchar(10)
          CASE WHEN i.relationship <> 'Self' THEN i.policynumber ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_Policy] i	
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		i.insurancecompanyid = icp.VendorID AND
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON 
		i.patid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          startdateest, -- StartDate - datetime
          enddateest , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          p.VendorID , -- Subject - varchar(64)
          CASE comments WHEN '' THEN '' ELSE 'Comments: ' + comments +CHAR(13) + CHAR(10) END +
		 (CASE visitnote WHEN '' THEN '' ELSE 'Visit Notes: ' + visitnote END) , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          starttmest , -- StartTm - smallint
          endtmest  -- EndTm - smallint
FROM dbo.[_import_1_1_Appointments] a
	INNER JOIN dbo.PatientCase pc ON 
		a.clpatid = pc.VendorID AND
		pc.VendorImportID = @VendorImportId
	INNER JOIN dbo.Patient p ON
		a.clpatid = p.VendorID AND
		p.VendorImportID = @VendorImportId
	INNER JOIN dbo.DateKeyToPractice dk ON
		dk.PracticeID = @PracticeID AND
		dk.Dt = CAST(CAST(a.startdateest AS DATE) AS DATETIME)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Creating Practice Resource for Missing Providers...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  ( 3 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'Missing Provider' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Appointment Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  ap.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          kareoresourceid , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointments] a
	INNER JOIN dbo.Appointment ap ON
		a.clpatid = ap.Subject AND
		ap.StartDate = CAST(a.startdateest AS DATETIME) AND
		ap.EndDate = CAST(a.enddateest AS DATETIME) AND
		ap.PracticeID = @PracticeID
WHERE a.kareoresourceid <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Appointment Resource 2...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  ap.AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          pr.PracticeResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointments] a
	INNER JOIN dbo.Appointment ap ON
		a.clpatid = ap.Subject AND
		ap.StartDate = CAST(a.startdateest AS DATETIME) AND
		ap.EndDate = CAST(a.enddateest AS DATETIME) AND
		ap.PracticeID = @PracticeID
	INNER JOIN dbo.PracticeResource pr ON
		pr.ResourceName = 'Missing Provider' AND
		pr.PracticeID = @PracticeID
WHERE a.kareoresourceid = ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          apptreason , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          apptreason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_1_1_Appointments]
WHERE apptreason <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into App to App Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  ap.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointments] a
	INNER JOIN dbo.Appointment ap ON
		a.clpatid = ap.Subject AND
		ap.StartDate = CAST(a.startdateest AS DATETIME) AND
		ap.EndDate = CAST(a.enddateest AS DATETIME) AND
		ap.PracticeID = @PracticeID
	INNER JOIN dbo.AppointmentReason ar ON
		a.apptreason = ar.Name AND
		ar.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '






--COMMIT
--ROLLBACK

