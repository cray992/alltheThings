USE superbill_24492_dev
--USE superbill_24492_prod
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

--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
--DELETE FROM dbo.AppointmentReason WHERE ModifiedDate BETWEEN DATEADD(mi , 20 , GETDATE()) AND DATEADD(mi, -20, GETDATE())
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Reason records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = -50 AND ModifiedUserID = -50
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'


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
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
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
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  insurancename , -- InsuranceCompanyName - varchar(128)
          CASE WHEN email = '' THEN '' ELSE 'Insurance Email: ' + email END , -- Notes - text
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          CASE WHEN LEN(zip) IN (5,9) THEN zip
			   WHEN LEN(zip) IN (4,8) THEN '0' + zip
			   ELSE '' END , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          contactname , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          LEFT(phone , 10) , -- Phone - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          CASE WHEN billingtype = 'EDI' THEN 1 ELSE 0 END , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          CASE insurancetype WHEN 'Medicaid' THEN 'MC'
							 ELSE 'CI' END  , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          insuranceid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Insurance]
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
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
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
          State , -- State - varchar(2)
          ZipCode , -- ZipCode - varchar(9)
          ContactPrefix , -- ContactPrefix - varchar(16)
          ContactFirstName , -- ContactFirstName - varchar(64)
          ContactMiddleName , -- ContactMiddleName - varchar(64)
          ContactLastName , -- ContactLastName - varchar(64)
          ContactSuffix , -- ContactSuffix - varchar(16)
          Phone , -- Phone - varchar(10)
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
PRINT 'Inserting into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          City ,
          State ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  employernameaddress , -- EmployerName - varchar(128)
          employeraddress , -- AddressLine1 - varchar(256)
          employercity , -- City - varchar(128)
          employerstate , -- State - varchar(2)
          CASE WHEN LEN(employerzip) IN (5,9) THEN employerzip
			   WHEN LEN(employerzip) IN (4,8) THEN '0' + employerzip
			   ELSE '' END , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientDemo]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient...'
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
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '', -- Prefix - varchar(16)
          imppat.firstname , -- FirstName - varchar(64)
          imppat.middlename , -- MiddleName - varchar(64)
          imppat.lastname , -- LastName - varchar(64)
          imppat.suffix , -- Suffix - varchar(16)
          imppat.address1 , -- AddressLine1 - varchar(256)
          imppat.address2 , -- AddressLine2 - varchar(256)
          imppat.patientcity , -- City - varchar(128)
          LEFT(imppat.patientstate , 2) , -- State - varchar(2)
          CASE WHEN LEN(imppat.patientzip) IN (5,9) THEN imppat.patientzip
			   WHEN LEN(imppat.patientzip) IN (4,8) THEN '0' + imppat.patientzip
			   ELSE '' END , -- ZipCode - varchar(9)
          imppat.sex , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          LEFT(imppat.patienthomephone , 10) , -- HomePhone - varchar(10)
          LEFT(imppat.employerphone , 10) , -- WorkPhone - varchar(10)
          LEFT(imppat.employerphoneext , 10) , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(imppat.dob) = 1 THEN imppat.dob ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(imppat.ssn) >= 6 THEN RIGHT('000' + imppat.ssn , 9) ELSE '' END , -- SSN - char(9)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN imppat.employernameaddress <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          CASE WHEN imppat.primaryprovider = 'MARK S LINDAU, MD' THEN 2 ELSE NULL END , -- PrimaryProviderID - int
          NULL , -- DefaultServiceLocationID - int
          imppat.email , -- MedicalRecordNumber - varchar(128)
          NULL , -- PrimaryCarePhysicianID - int
          imppat.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE WHEN imppat.[status] = 'Inactive' THEN 0 ELSE 1 END , -- Active - bit
          imppat.emergencycontact , -- EmergencyName - varchar(128)
          LEFT(imppat.emergencyphone , 10)  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_1_1_PatientDemo] AS imppat
WHERE imppat.firstname <> '' AND imppat.lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          'PatientID: ' + i.patientid , -- NoteMessage - varchar(max)
          1 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          1  -- LastNote - bit
FROM dbo.[_import_1_1_PatientDemo] i
INNER JOIN dbo.Patient p ON
	p.VendorID = i.patientid AND
	p.VendorImportID = @VendorImportID
WHERE i.patientid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Patient Employers...'
UPDATE dbo.Patient
	SET EmployerID = emp.EmployerID
FROM dbo.Patient pat
INNER JOIN dbo.[_import_1_1_PatientDemo] imppat ON
	imppat.patientid = pat.VendorID
INNER JOIN dbo.Employers AS emp ON
	emp.EmployerName = imppat.employernameaddress
WHERE imppat.employernameaddress <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
		  HolderThroughEmployer ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imppat.primaryinsuredid , -- PolicyNumber - varchar(32)
          CASE WHEN imppat.primaryinsuredfirstname = '' AND imppat.primaryinsuredlastname = '' THEN 'S' ELSE
		 (CASE WHEN imppat.primaryinsuredfirstname <> imppat.firstname AND imppat.primaryinsuredlastname <> imppat.lastname 
		  THEN 'O' ELSE 'S' END) END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN imppat.primaryinsuredfirstname = '' AND imppat.primaryinsuredlastname = '' THEN '' ELSE
		 (CASE WHEN imppat.primaryinsuredfirstname <> imppat.firstname AND imppat.primaryinsuredlastname <> imppat.lastname 
		  THEN imppat.primaryinsuredfirstname ELSE '' END) END   , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          CASE WHEN imppat.primaryinsuredfirstname = '' AND imppat.primaryinsuredlastname = '' THEN '' ELSE
		 (CASE WHEN imppat.primaryinsuredfirstname <> imppat.firstname AND imppat.primaryinsuredlastname <> imppat.lastname 
		  THEN imppat.primaryinsuredlastname ELSE '' END) END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          NULL , -- HolderDOB - datetime
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE WHEN imppat.primaryinsuredfirstname = '' AND imppat.primaryinsuredlastname = '' THEN '' ELSE
		 (CASE WHEN imppat.primaryinsuredfirstname <> imppat.firstname AND imppat.primaryinsuredlastname <> imppat.lastname 
		  THEN imppat.primaryinsuredid ELSE '' END) END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemo] AS imppat
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = imppat.primaryinsuranceid AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imppat.patientid AND
	pc.VendorImportID = @VendorImportID
WHERE imppat.primaryinsuranceid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Secondary Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
		  HolderThroughEmployer ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imppat.secinsuredid , -- PolicyNumber - varchar(32)
          CASE WHEN imppat.secinsuredfirstname = '' AND imppat.secinsuredlastname = '' THEN 'S' ELSE
		 (CASE WHEN imppat.secinsuredfirstname <> imppat.firstname AND imppat.secinsuredlastname <> imppat.lastname 
		  THEN 'O' ELSE 'S' END) END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN imppat.secinsuredfirstname = '' AND imppat.secinsuredlastname = '' THEN '' ELSE
		 (CASE WHEN imppat.secinsuredfirstname <> imppat.firstname AND imppat.secinsuredlastname <> imppat.lastname 
		  THEN imppat.primaryinsuredfirstname ELSE '' END) END   , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          CASE WHEN imppat.secinsuredfirstname = '' AND imppat.secinsuredlastname = '' THEN '' ELSE
		 (CASE WHEN imppat.secinsuredfirstname <> imppat.firstname AND imppat.secinsuredlastname <> imppat.lastname 
		  THEN imppat.secinsuredlastname ELSE '' END) END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          NULL , -- HolderDOB - datetime
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          'U' , -- HolderGender - char(1)
          CASE WHEN imppat.secinsuredfirstname = '' AND imppat.secinsuredlastname = '' THEN '' ELSE
		 (CASE WHEN imppat.secinsuredfirstname <> imppat.firstname AND imppat.secinsuredlastname <> imppat.lastname 
		  THEN imppat.secinsuredid ELSE '' END) END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemo] AS imppat
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = imppat.secondaryinsuranceid AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imppat.patientid AND
	pc.VendorImportID = @VendorImportID
WHERE imppat.secondaryinsuranceid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.reasonforvisit , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          i.reasonforvisit , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_1_1_Appointment] i
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.reasonforvisit = ar.Name)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment...'
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
          impapp.startdate , -- StartDate - datetime
          impapp.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          '' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE impapp.status WHEN 'Cancelled by Patient' THEN 'X'
							 WHEN 'Patient Did Not Come' THEN 'N'
							 WHEN 'Rescheduled' THEN 'R'
							 ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          impapp.starttm , -- StartTm - smallint
          impapp.endtm  -- EndTm - smallint
FROM dbo.[_import_1_1_Appointment] AS impapp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = impapp.patientid AND
	pat.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = impapp.patientid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.[PracticeID] = @PracticeID AND
	dk.Dt = CAST(CAST(impApp.[startdate] AS DATE) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into Appointment to Resource...'
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
          CASE i.provider WHEN 'DANA HARGUNANI' THEN 7
						  WHEN 'ELLEN STEVENSON' THEN 6
						  WHEN 'John Trumbo' THEN 4 
						  WHEN 'MARK LINDAU, MD' THEN 2
						  WHEN 'ROBERT HEFFERNAN' THEN 3 END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] i
INNER JOIN dbo.Patient p ON
	i.patientid = p.VendorID AND
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	p.PatientID = a.PatientID AND
	CAST(i.startdate AS DATETIME) = a.StartDate AND
	CAST(i.enddate AS DATETIME) = a.EndDate
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
FROM dbo.[_import_1_1_Appointment] i
INNER JOIN dbo.Patient p ON
	i.patientid = p.VendorID AND
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	p.PatientID = a.PatientID AND
	CAST(i.startdate AS DATETIME) = a.StartDate AND
	CAST(i.enddate AS DATETIME) = a.EndDate
INNER JOIN dbo.AppointmentReason ar ON
	i.reasonforvisit = ar.Name AND
	ar.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '




--ROLLBACK
--COMMIT




