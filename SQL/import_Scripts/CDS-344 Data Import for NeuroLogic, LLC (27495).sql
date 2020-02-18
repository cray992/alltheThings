USE superbill_27495_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT

SET @VendorImportID = 4
SET @PracticeID = 1 


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
--DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
--DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'


PRINT ''
PRINT 'Removing 2 records from dbo.[_import_4_1_patientpolicy]...'
DELETE FROM dbo.[_import_4_1_patientpolicy] WHERE insurancecarrier = 'AARP HEALTH CARE OPTIONS'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '

PRINT ''
PRINT 'Inserting Into Doctor...'
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
          WorkPhone ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          [External] ,
          NPI ,
		  Degree
        )
SELECT DISTINCT  
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
		  '',
          lastname , -- LastName - varchar(64)
          suffix , -- Suffix - varchar(16)
          address , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN dbo.fn_RemoveNonNumericCharacters(LEN(zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(zip)
			   WHEN dbo.fn_RemoveNonNumericCharacters(LEN(zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zip) ELSE '' END , -- ZipCode - varchar(9)
		  dbo.fn_RemoveNonNumericCharacters(phone2) , --HomePhone
          dbo.fn_RemoveNonNumericCharacters(phone1) , -- WorkPhone - varchar(10)
          CASE WHEN upin <> '' THEN 'UPIN: ' + upin ELSE '' END , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          providername , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          npi , -- NPI - varchar(10)
		  degree
 FROM dbo.[_import_4_1_ReferringPhysician]
 WHERE providername <> ''
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
          ZipCode ,
          Phone ,
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
          InstitutionalBillingFormID,
		  ContactFirstName
        )
SELECT DISTINCT
		  name , -- InsuranceCompanyName - varchar(128)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' 
		  + CASE WHEN otherphone <> '' THEN CHAR(13)+CHAR(10) + 'Other Phone: ' + otherphone ELSE '' END , -- Notes - text
          [address] , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          citystate , -- City - varchar(128)
          LEFT(state , 2) , -- State - varchar(2)
          CASE WHEN LEN(zip) IN (5,9) THEN zip
			   WHEN LEN(zip) IN (4,8) THEN '0' + zip
			   ELSE '' END , -- ZipCode - varchar(9)
          LEFT(dbo.fn_RemoveNonNumericCharacters(phone),10) , -- Phone - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
		  CASE insurancetype 
			WHEN 'Medicaid' THEN 'MC'
			WHEN 'Self Pay' THEN '09'
			WHEN 'Champus' THEN 'CH'
			ELSE 'CI' END , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          name , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18 , -- InstitutionalBillingFormID - int
		  contact 
FROM dbo.[_import_4_1_insurancelist]
WHERE name <> ''
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




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
          MaritalStatus ,
          DOB ,
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
		  MedicalRecordNumber
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middlename , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          [address] , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(zip) IN (4,8) THEN '0' + zip
			   WHEN LEN(zip) IN (5,9) THEN zip ELSE '' END, -- ZipCode - varchar(9)
          'U' , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          dob , -- DOB - datetime
          CASE WHEN guarantorlastname <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN guarantorlastname <> '' THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN guarantorlastname <> '' THEN guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN guarantorlastname <> '' THEN guarantormiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN guarantorlastname <> '' THEN guarantorlastname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN guarantorlastname <> '' THEN '' END, -- ResponsibleSuffix - varchar(16)
          CASE WHEN guarantorlastname <> '' THEN 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN guarantorlastname <> '' THEN [address] END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN guarantorlastname <> '' THEN '' END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN guarantorlastname <> '' THEN city END , -- ResponsibleCity - varchar(128)
          CASE WHEN guarantorlastname <> '' THEN [state] END , -- ResponsibleState - varchar(2)
          CASE WHEN guarantorlastname <> '' THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN guarantorlastname <> '' THEN CASE WHEN LEN(zip) IN (4,8) THEN '0' + zip
			   WHEN LEN(zip) IN (5,9) THEN zip ELSE '' END END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          2 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          patientname , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit 
		  patientid
FROM dbo.[_import_4_1_patientdemographics] 
WHERE patientname <> ''
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
PRINT 'Updating dbo.[_import_4_1_patientpolicy] Primary Column...'
UPDATE dbo.[_import_4_1_patientpolicy] 
SET [primary] = 4
WHERE [primary] = 'Alternate'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '




PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
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
          i.[primary] , -- Precedence - int
          i.insuredid , -- PolicyNumber - varchar(32)
          1 , -- CardOnFile - bit
          CASE WHEN i.sublastname <> '' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.sublastname <> '' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.sublastname <> '' THEN i.subfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.sublastname <> '' THEN '' END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.sublastname <> '' THEN i.sublastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.sublastname <> '' THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.sublastname <> '' THEN  '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.sublastname <> '' THEN 'U' END , -- HolderGender - char(1)
          CASE WHEN i.sublastname <> '' THEN i.guarantoraddress END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.sublastname <> '' THEN i.address2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.sublastname <> '' THEN i.city END , -- HolderCity - varchar(128)
          CASE WHEN i.sublastname <> '' THEN i.[state] END , -- HolderState - varchar(2)
          CASE WHEN i.sublastname <> '' THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.sublastname <> '' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
		                                          WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip) END END, -- HolderZipCode - varchar(9)
          CASE WHEN i.sublastname <> '' THEN insuredid END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
		  'Y'
FROM dbo.[_import_4_1_patientpolicy] i
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = i.name AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = insurancecarrier AND
	icp.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



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
          i.appttype , -- Name - varchar(128)
          0 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          '' , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_4_1_appointment] i
WHERE appttype <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.Name = i.appttype)
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
		  pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE WHEN i.[status] = 'Completed' THEN 'C' ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_4_1_appointment] i
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = i.patientname AND
	pat.PracticeID = @PracticeID 
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = pat.VendorID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)   
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Appointment to Resource Type 1...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT	
	      AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          2 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_4_1_appointment] i
INNER JOIN dbo.Patient p ON 
	p.VendorID = i.patientname AND
	p.PracticeID = @PracticeID 
INNER JOIN dbo.Appointment AS a ON
	a.PatientID = p.PatientID AND
	a.StartDate = i.startdate 
WHERE a.ModifiedDate > DATEADD(mi,-10,GETDATE()) AND i.schedulerresourcetypeid2 = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Appointment to Resource Type 2...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT	
	      AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          2 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_4_1_appointment] i
INNER JOIN dbo.Patient p ON 
	p.VendorID = i.patientname AND
	p.PracticeID = @PracticeID 
INNER JOIN dbo.Appointment AS a ON
	a.PatientID = p.PatientID AND
	a.StartDate = i.startdate 
WHERE a.ModifiedDate > DATEADD(mi,-10,GETDATE()) AND i.schedulerresourcetypeid2 = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Appointment To Appointment Reason...'
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
FROM dbo.[_import_4_1_appointment] i
INNER JOIN dbo.Patient AS p ON
	p.VendorID = i.patientname AND
	p.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS a ON
	a.PatientID = p.PatientID AND
	a.StartDate = i.startdate 
INNER JOIN dbo.AppointmentReason ar ON
    ar.NAME = i.appttype AND
	ar.PracticeID = @PracticeID
WHERE a.ModifiedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--COMMIT
--ROLLBACK

