USE superbill_27853_dev
--USE superbill_27853_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

--DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT )
--INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID)
--(
--       SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule 
--       WHERE Notes = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) 
--)
--DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
--DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
--DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = -50 AND ModifiedUserID = -50
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'



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
		  employercode + ' - ' + employername , -- EmployerName - varchar(128)
          employeraddress1 , -- AddressLine1 - varchar(256)
          employeraddress2 , -- AddressLine2 - varchar(256)
          employercity , -- City - varchar(128)
          employerstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(employerzipcode,'-','') , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_1_1_Employer]
WHERE employercode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Service Location...'
INSERT INTO dbo.ServiceLocation 
        ( PracticeID ,
          Name ,
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
          PlaceOfServiceCode ,
          BillingName ,
          Phone ,
		  FaxPhone ,
          CLIANumber ,
          VendorImportID ,
          VendorID ,
          NPI ,
          TimeZoneID 
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          locationname , -- Name - varchar(128)
          locationaddress1 , -- AddressLine1 - varchar(256)
          locationaddress2 , -- AddressLine2 - varchar(256)
          locationcity , -- City - varchar(128)
          locationstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(locationzipcode,'-','') , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE locationtype WHEN 'Hospital' THEN '22'
							WHEN 'Office' THEN '11'
							WHEN 'Nursing Home' THEN '32'
							WHEN 'Laboratory' THEN '11'
							ELSE '11' END , -- PlaceOfServiceCode - char(2)
          locationname , -- BillingName - varchar(128)
          locationphone , -- Phone - varchar(10)
          dbo.fn_RemoveNonNumericCharacters(locationfax) , -- FaxPhone - varchar(10)
          locationclia , -- CLIANumber - varchar(30)
          @VendorImportID , -- VendorImportID - int
          locationcode , -- VendorID - int
          locationnpi , -- NPI - varchar(10)
          15  -- TimeZoneID - int
FROM dbo.[_import_1_1_Location]
WHERE locationcode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          [External] 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pcpfirstname , -- FirstName - varchar(64)
          pcpmiddleinitial , -- MiddleName - varchar(64)
          pcplastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pcpaddress1 , -- AddressLine1 - varchar(256)
          pcpaddress2 , -- AddressLine2 - varchar(256)
          pcpcity , -- City - varchar(128)
          pcpstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(pcpzipcode,'-','') , -- ZipCode - varchar(9)
          pcpphone , -- WorkPhone - varchar(10)
          REPLACE(pcppager,'-','') , -- PagerPhone - varchar(10)
          pcpemail , -- EmailAddress - varchar(256)
          CASE WHEN pcpupin <> '' THEN 'UPIN: ' + pcpupin ELSE '' END , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          LEFT(degree, 8) , -- Degree - varchar(8)
          pcpcode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          pcpfax , -- FaxNumber - varchar(10)
          1  -- External - bit
FROM dbo.[_import_1_1_PCP]
WHERE pcpfirstname <> '' AND pcplastname <> ''
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
		  insurancename , -- InsuranceCompanyName - varchar(128)
          CASE noteinsurancecontact WHEN '' THEN '' ELSE 'Contact: ' + noteinsurancecontact + CHAR(13) + CHAR(10) END +
		 (CASE noteinsurancecontactextension WHEN '' THEN '' ELSE 'Contact Ext: ' + noteinsurancecontactextension + CHAR(13) + CHAR(10) END) +
		 (CASE noteinsurancetelephonebenefits WHEN '' THEN '' ELSE 'Phone Benefits: ' + noteinsurancetelephonebenefits + CHAR(13) + CHAR(10) END) +
		 (CASE noteinsurancetelephoneauthorization WHEN '' THEN '' ELSE 'Phone Authorization: ' + noteinsurancetelephoneauthorization + CHAR(13) + CHAR(10)  END) +
		 (CASE noteinsurancetelephonerelations WHEN '' THEN '' ELSE 'Phone Relation: ' + noteinsurancetelephonerelations + CHAR(13) + CHAR(10) END) +
		 (CASE noteinsuranceemailaddress WHEN '' THEN '' ELSE 'Email Address: ' + noteinsuranceemailaddress END)
		  , -- Notes - text
          insuranceaddress1 , -- AddressLine1 - varchar(256)
          insuranceaddress2 , -- AddressLine2 - varchar(256)
          insurancecity , -- City - varchar(128)
          insurancestate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(insurancezipcode,'-','') , -- ZipCode - varchar(9)
          insurancefax , -- Fax - varchar(10)
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
          insurancecode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18 -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceMaster]
WHERE insurancename <> '' AND insuranceaddress1 <> '' AND insurancename NOT LIKE '%Do Not Use%'
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
          [State] , -- State - varchar(2)
          Country , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          CAST(Notes AS VARCHAR(MAX)) , -- Notes - text
          CreatedDate , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          ModifiedDate , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
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
          PrimaryProviderID ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          rp.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.patientfirstname , -- FirstName - varchar(64)
          i.patientmiddleinitial , -- MiddleName - varchar(64)
          i.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.patientaddress1 , -- AddressLine1 - varchar(256)
          i.patientaddress2 , -- AddressLine2 - varchar(256)
          i.patientcity , -- City - varchar(128)
          LEFT(i.patientstate , 2), -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)) IN (4,8) THEN '0' + (dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)) 
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientzipcode)) IN (5,9) THEN (dbo.fn_RemoveNonNumericCharacters(i.patientzipcode))
		  ELSE '' END, -- ZipCode - varchar(9)
          i.patientsex , -- Gender - varchar(1)
          i.patientmaritalstatus , -- MaritalStatus - varchar(1)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientphone),10)
		  ELSE '' END  , -- HomePhone - varchar(10)
		  		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientphone))),10)
		  ELSE NULL END , -- HomePhoneExt - varchar(10)
          i.patientworkphone , -- WorkPhone - varchar(10)
          i.patientworkextension , -- WorkPhoneExt - varchar(10)
          i.patientdateofbirth , -- DOB - datetime
          CASE WHEN LEN(i.patientsocialsecurity)>= 6 THEN RIGHT('000' + i.patientsocialsecurity, 9) ELSE NULL END , -- SSN - char(9)
          i.patientemailaddress , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.patientemployercode <> '' THEN 'E' ELSE 'U' END, -- EmploymentStatus - char(1)
          1 , -- PrimaryProviderID - int
          e.EmployerID , -- EmployerID - int
          i.patientaccountnumber , -- MedicalRecordNumber - varchar(128)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone),10)
		  ELSE '' END , -- MobilePhone - varchar(10)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientcellularphone))),10)
		  ELSE NULL END  , -- MobilePhoneExt - varchar(10)
          pcp.DoctorID, -- PrimaryCarePhysicianID - int
          i.patientaccountnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- PhonecallRemindersEnabled - bit
          i.patientemergencyfirstname + ' ' + i.patientemergencylastname , -- EmergencyName - varchar(128)
          i.patientemergencyphone  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_1_1_PatientMaster] i
LEFT JOIN dbo.Doctor rp ON 
	rp.VendorID = i.patientreferringcode AND
	rp.VendorImportID = @VendorImportID AND
	rp.[External] = 0
LEFT JOIN dbo.Doctor pcp ON 
	pcp.VendorID = i.patientpcpcode AND
	pcp.VendorImportID = @VendorImportID AND
	pcp.[External] = 0
LEFT JOIN dbo.Employers e ON	
	LEFT(e.EmployerName, CHARINDEX('-',e.employername) - 2 ) = patientreferringcode
LEFT JOIN dbo.ServiceLocation sl ON 
	i.patientlocationcode = sl.VendorID AND
	sl.VendorImportID = @VendorImportID AND
	sl.PracticeID = @PracticeID
WHERE i.patientfirstname <> '' AND i.patientlastname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          AccountStatus ,
          NoteTypeCode ,
          LastNote
        )
SELECT DISTINCT
		  GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          'Kareo Import' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          CASE WHEN i.notepatientlastvisit = '' THEN '' ELSE 'Patient Last Visit: ' + i.notepatientlastvisit + CHAR(13) + CHAR(10) END +
		 (CASE WHEN i.notepatientlaststatementdate = '' THEN '' ELSE 'Patient Last Statement Date: ' + i.notepatientlaststatementdate + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN i.notepatientlaststatementamount = '' THEN '' ELSE 'Patient Last Statement Amount: ' + i.notepatientlaststatementamount + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN i.notepatientdriverslicense = '' THEN '' ELSE 'Patient Drivers License: '  + i.notepatientdriverslicense + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN i.notepatientcontactinstruction = '' THEN '' ELSE 'Patient Contact Instruction: ' + i.notepatientcontactinstruction END), -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          1  -- LastNote - bit
FROM dbo.[_import_1_1_PatientMaster] i
INNER JOIN dbo.Patient p ON
	i.patientaccountnumber = p.VendorID AND
	p.VendorImportID = @VendorImportID AND 
	p.PracticeID = @PracticeID
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
PRINT 'Inserting Into Insurance Policy...'
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
          DependentPolicyNumber ,
          Phone ,
          PhoneExt ,
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
          CASE WHEN i.policystartdate <> '' THEN i.policystartdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN i.policyenddate <> '' THEN i.policyenddate ELSE NULL END , -- PolicyEndDate - datetime
          CASE WHEN i.policyrelationship <> 1 THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.policyrelationship <> 1 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.policyrelationship <> 1 THEN i.policyfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.policyrelationship <> 1 THEN i.policymiddleinitial END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.policyrelationship <> 1 THEN i.policylastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.policyrelationship <> 1 THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.policyrelationship <> 1 THEN CASE WHEN ISDATE(i.policydateofbirth) = 1 THEN i.policydateofbirth ELSE NULL END ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN i.policyrelationship <> 1 THEN CASE WHEN LEN(i.policysocialsecurity)>= 6 THEN RIGHT('000' + policysocialsecurity, 9) ELSE NULL END END , -- HolderSSN - char(11)
          CASE WHEN i.policyemployercode <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
          e.EmployerName , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.policyrelationship <> 1 THEN i.policysex END , -- HolderGender - char(1)
          CASE WHEN i.policyrelationship <> 1 THEN i.policyaddress1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.policyrelationship <> 1 THEN i.policyaddress2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.policyrelationship <> 1 THEN i.policycity END, -- HolderCity - varchar(128)
          CASE WHEN i.policyrelationship <> 1 THEN i.policystate END , -- HolderState - varchar(2)
          CASE WHEN i.policyrelationship <> 1 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.policyrelationship <> 1 THEN REPLACE(i.policyzipcode,'-','') END, -- HolderZipCode - varchar(9)
          CASE WHEN i.policyrelationship <> 1 THEN i.policynumber END , -- DependentPolicyNumber - varchar(32)
          CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policyphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.policyphone),10)
			ELSE '' END , -- Phone - varchar(10)
          CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.policyphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.policyphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.policyphone))),10)
			ELSE '' END  , -- PhoneExt - varchar(10)
          CASE WHEN ISNUMERIC(i.policycopay) = 1 THEN i.policycopay ELSE 0 END , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.PatientCaseID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.policygroupname, 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_PatientPolicy] i
INNER JOIN dbo.PatientCase pc ON
	i.policyaccountnumber = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.policyinsurancecode = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_Employer] ie ON
	i.policyemployercode = ie.employercode
LEFT JOIN dbo.Employers e ON
	ie.employercode + ' - ' + ie.employername = e.EmployerName
WHERE CAST(i.policyenddate AS DATETIME) >= GETDATE()
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
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.apptcomment + CASE WHEN i.noteapptphone = '' THEN '' ELSE CHAR(13) + CHAR(10) + 'Phone: ' + i.noteapptphone END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_1_1_ApptMaster] i
INNER JOIN dbo.Patient p ON 
	i.apptaccountnumber = p.VendorID AND
	p.VendorImportID = @VendorImportId
INNER JOIN dbo.PatientCase pc ON 
	i.apptaccountnumber = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice dk ON	
	dk.PracticeID = @PracticeID AND
	dk.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


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
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_ApptMaster] i
INNER JOIN dbo.Patient p ON
	i.apptaccountnumber = p.VendorID AND
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	p.PatientID = a.PatientID AND
	a.StartDate = CAST(i.startdate AS DATETIME) AND
	a.enddate = CAST(i.enddate AS DATETIME) 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



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
FROM dbo.[_import_1_1_ApptMaster] i
INNER JOIN dbo.Patient p ON
	i.apptaccountnumber = p.VendorID AND
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	p.PatientID = a.PatientID AND
	a.StartDate = CAST(i.startdate AS DATETIME) AND
	a.enddate = CAST(i.enddate AS DATETIME) 
INNER JOIN dbo.AppointmentReason ar ON
	i.apptreason = ar.Name AND
	ar.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Contract and Fees Contract Rate Schedule...'
INSERT INTO dbo.ContractsAndFees_ContractRateSchedule
        ( PracticeID ,
          InsuranceCompanyID ,
          EffectiveStartDate ,
          EffectiveEndDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          AddPercent ,
          AnesthesiaTimeIncrement ,
          Capitated
        )
SELECT DISTINCT
	      1 , -- PracticeID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyID - int
          GETDATE() , -- EffectiveStartDate - datetime
          DATEADD(dd, -1, DATEADD(yy, 1, GETDATE())) , -- EffectiveEndDate - datetime
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          0 , -- AddPercent - decimal
          15 , -- AnesthesiaTimeIncrement - int
          0  -- Capitated - bit
FROM dbo.[_import_1_1_FeeMaster] i
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.InsuranceCompanyPlanID IN (SELECT icp.InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan icp
									INNER JOIN dbo.[_import_1_1_InsuranceMaster] i ON
										icp.VendorID = i.insurancecode AND
										icp.VendorImportID = @VendorImportID
								   WHERE insurancefeetable <> 'Standard') AND 
	icp.VendorImportID = @VendorImportID --VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Contracts and Fees Contract Rate...'
INSERT INTO dbo.ContractsAndFees_ContractRate
        ( ContractRateScheduleID ,
          ProcedureCodeID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT DISTINCT
		  crs.ContractRateScheduleID , -- ContractRateScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          ifm.feechargeamount , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.ContractsAndFees_ContractRateSchedule crs
	INNER JOIN dbo.[_import_1_1_FeeMaster] ifm ON
		crs.InsuranceCompanyID IN (SELECT icp.InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan icp
									INNER JOIN dbo.[_import_1_1_InsuranceMaster] i ON
										icp.VendorID = i.insurancecode AND
										icp.VendorImportID = @VendorImportID
									WHERE i.insurancefeetable = ifm.feetable)
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON
		pcd.ProcedureCode = ifm.feeprocedurecode
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Contracts and Fees Contract Rate Schedule Link...'
INSERT INTO dbo.ContractsAndFees_ContractRateScheduleLink
        ( ProviderID ,
          LocationID ,
          ContractRateScheduleID
        )
SELECT  
		  d.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          crs.ContractRateScheduleID  -- ContractRateScheduleID - int
FROM dbo.Doctor d , dbo.ServiceLocation sl , dbo.ContractsAndFees_ContractRateSchedule crs
WHERE d.PracticeID = @PracticeID AND
	d.[External] = 0 AND
	sl.PracticeID = @PracticeID AND
	crs.InsuranceCompanyID IN (SELECT InsuranceCompanyID  FROM dbo.InsuranceCompany ic WHERE ic.CreatedPracticeID = @PracticeID) AND
	crs.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting into Standard Fee Schedule...'
      INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
                  ( PracticeID ,
                    Name ,
                    Notes ,
                    EffectiveStartDate ,
                    SourceType ,
                    SourceFileName ,
                    EClaimsNoResponseTrigger ,
                    PaperClaimsNoResponseTrigger ,
                    AddPercent ,
                    AnesthesiaTimeIncrement
                  )
      VALUES  
                  ( 
                    @PracticeID , -- PracticeID - int
                    'Default Contract' , -- Name - varchar(128)
                    'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
                    GETDATE() , -- EffectiveStartDate - datetime
                    'F' , -- SourceType - char(1)
                    'Import File' , -- SourceFileName - varchar(256)
                    30 , -- EClaimsNoResponseTrigger - int
                    30 , -- PaperClaimsNoResponseTrigger - int
                    0 , -- AddPercent - decimal
                    15  -- AnesthesiaTimeIncrement - int
                  )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee...'
      INSERT INTO dbo.ContractsAndFees_StandardFee
                  ( StandardFeeScheduleID ,
                    ProcedureCodeID ,
                    SetFee ,
                    AnesthesiaBaseUnits
                  )
      SELECT DISTINCT
                    sfs.[StandardFeeScheduleID], -- StandardFeeScheduleID - int
                    pcd.[ProcedureCodeDictionaryID] , -- ProcedureCodeID - int
                    i.feechargeamount , -- SetFee - money
                    0  -- AnesthesiaBaseUnits - int
      FROM dbo.[_import_1_1_FeeMaster] AS i
      INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
            CAST(sfs.[Notes] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID  
      INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
            pcd.[ProcedureCode] = i.feealternateprocedurecode
WHERE i.feetable = 'Standard'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee Schedule Link...'
      INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
                  ( ProviderID ,
                    LocationID ,
                    StandardFeeScheduleID
                  )
      SELECT DISTINCT
                    doc.[DoctorID] , -- ProviderID - int
                    sl.[ServiceLocationID] , -- LocationID - int
                    sfs.[StandardFeeScheduleID]  -- StandardFeeScheduleID - int
      FROM dbo.Doctor AS doc, dbo.ServiceLocation AS sl, dbo.ContractsAndFees_StandardFeeSchedule AS sfs
      WHERE doc.[External] = 0 AND
            doc.[PracticeID] = @PracticeID AND
            sl.PracticeID = @PracticeID AND
            sfs.[Notes] = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--ROLLBACK
--COMMIT


