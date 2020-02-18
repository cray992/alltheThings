USE superbill_26590_dev
--USE superbill_26590_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'

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
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(zip) IN (4,8) THEN '0' + zip 
			   WHEN LEN(zip) IN (5,9) THEN zip ELSE NULL END , -- ZipCode - varchar(9)
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
          inscoid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_3_1_InsuranceList]
WHERE inscoid <> ''
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
          [State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          MedicalRecordNumber ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          CASE WHEN refferingid <> '' THEN refferingid ELSE NULL END , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middlename , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          addr1 , -- AddressLine1 - varchar(256)
          addr2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(zip) 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zip) ELSE NULL END , -- ZipCode - varchar(9)
          gen , -- Gender - varchar(1)
          hmphone, -- HomePhone - varchar(10)
          workphone , -- WorkPhone - varchar(10)
          workphoneext , -- WorkPhoneExt - varchar(10)
          birthdt , -- DOB - datetime
          CASE WHEN LEN(ssn) >= 6 THEN RIGHT('000' + ssn,9) ELSE NULL END , -- SSN - char(9)
          emailaddr , -- EmailAddress - varchar(256)
          CASE patguarrel WHEN '' THEN 0
						  WHEN 'S' THEN 0 
						  WHEN 'C' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN patguarrel = 'C' THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN patguarrel = 'C' THEN guarfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN patguarrel = 'C' THEN guarmiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN patguarrel = 'C' THEN guarlastname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN patguarrel = 'C' THEN '' END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN patguarrel = 'C' THEN 'C' END , -- ResponsibleRelationshipToPatient - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          CASE WHEN renderringprovid <> '' THEN renderringprovid END , -- PrimaryProviderID - int
          mdrc , -- MedicalRecordNumber - varchar(128)
          CASE WHEN primcarephysid <> '' THEN primcarephysid END , -- PrimaryCarePhysicianID - int
          pernbr , -- VendorID - varchar(50)
          @VendorImportId , -- VendorImportID - int
          1 , -- Active - bit
          0 -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_3_1_PatientDemo]
WHERE firstname <> '' and lastname <> ''
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
FROM dbo.Patient 
WHERE VendorImportID = @VendorImportID
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
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.precedence , -- Precedence - int
          i.polnbr , -- PolicyNumber - varchar(32)
          i.groupnbr , -- GroupNumber - varchar(32)
          CASE WHEN i.poleff <> '' THEN i.poleff ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN i.polexp <> '' THEN i.polexp ELSE NULL END , -- PolicyEndDate - datetime
          i.relation , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.relation <> 'S' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.relation <> 'S' THEN i.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.relation <> 'S' THEN i.middlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.relation <> 'S' THEN i.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.relation <> 'S' THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.relation <> 'S' THEN i.birthdt END , -- HolderDOB - datetime
          CASE WHEN i.relation <> 'S' THEN 
		  CASE WHEN LEN(ssn) >= 6 THEN RIGHT('000' + ssn,9) ELSE NULL END END, -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.relation <> 'S' THEN 
		  CASE WHEN i.gen = '' THEN 'U' ELSE i.gen END END , -- HolderGender - char(1)
          CASE WHEN i.relation <> 'S' THEN i.addr1 END, -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.relation <> 'S' THEN i.addr2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.relation <> 'S' THEN i.city END , -- HolderCity - varchar(128)
          CASE WHEN i.relation <> 'S' THEN i.[state] END, -- HolderState - varchar(2)
          CASE WHEN i.relation <> 'S' THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.relation <> 'S' THEN 
		  CASE WHEN LEN(i.zip) IN (4,8) THEN '0' + i.zip 
			   WHEN LEN(i.zip) IN (5,9) THEN i.zip ELSE NULL END END , -- HolderZipCode - varchar(9)
          CASE WHEN i.relation <> 'S' THEN i.polnbr END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname, 14)  -- GroupName - varchar(14)
FROM dbo.[_import_3_1_InsurancePolicies] i
INNER JOIN dbo.PatientCase pc ON
pc.VendorID = i.pernbr AND
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
icp.VendorID = i.inscoid AND
icp.VendorImportID = @VendorImportID
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
          EndTm ,
		  Notes
        )
SELECT DISTINCT
		  pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          imp.servicelocation , -- ServiceLocationID - int
          imp.startdateest , -- StartDate - datetime
          imp.enddateest , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imp.resourcetype , -- AppointmentResourceTypeID - int
          CASE WHEN imp.sts = '' THEN 'S' ELSE imp.sts END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imp.starttmest , -- StartTm - smallint
          imp.endtmest , -- EndTm - smallint
		  imp.details  --Notes - text
FROM dbo.[_import_3_1_Appointment] imp
INNER JOIN dbo.Patient pat ON 
	pat.VendorID = imp.pernbr AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = pat.VendorID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = CAST(CAST(imp.startdateest AS DATE) AS DATETIME)  
WHERE imp.pernbr <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Appointment Reason...'
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
          imp.[event] , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          imp.[event] , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_3_1_Appointment] AS imp
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason WHERE imp.[event] = Name)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  app.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          0 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_Appointment] imp
INNER JOIN dbo.Patient AS pat ON 
	pat.VendorID = imp.pernbr AND
	pat.VendorImportID = @VendorImportID  
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = imp.startdateest AND
	app.StartTm = imp.starttmest  
INNER JOIN dbo.AppointmentReason AS ar ON
	ar.name = imp.event AND
	ar.PracticeID = @PracticeID
WHERE app.ModifiedDate > DATEADD(mi, -2, GETDATE()) AND imp.pernbr <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment to Resource Type 1...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  app.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          imp.resourceid , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_Appointment] AS imp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imp.pernbr AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = imp.startdateest
WHERE imp.resourcetype = 1 AND app.CreatedDate > DATEADD(mi,-2,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment to Resource Type 2...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  app.AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          imp.resourceid , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_Appointment] AS imp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imp.pernbr AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = imp.startdateest
WHERE imp.resourcetype = 2 AND app.CreatedDate > DATEADD(mi,-2,GETDATE())
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