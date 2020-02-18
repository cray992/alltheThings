USE superbill_22944_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1 
SET @VendorImportID = 5

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in detination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 

DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT )
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID)
(
	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule 
	WHERE Notes = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) 
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Notes deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


/*
==========================================================================================================================================
CREATE INSURANCE COMPANIES
==========================================================================================================================================
*/

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
          Phone ,
          Fax ,
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
		  carriername , -- InsuranceCompanyName - varchar(128)
          '' , -- Notes - text
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          CASE
			WHEN LEN(zipcode) IN (5,9) THEN zipcode
			WHEN LEN(zipcode) IN (4,8) THEN '0' + zipcode
			ELSE '' END , -- ZipCode - varchar(9)
          eligibilityphonenumber , -- Phone - varchar(10)
          faxnumber , -- Fax - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          CASE
			typeofinsurance WHEN 'C1' THEN 'CI'
							WHEN 'MB' THEN 'MB'
							WHEN 'MC' THEN 'MC'
							ELSE 'CI' END , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          carrieruid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_3_1_InsuranceInfo]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE INSURANCE COMPANY PLANS
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Insurance Company Plans...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
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
          State , -- State - varchar(2)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE EMPLOYERS
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Employer...'
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
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_3_1_PatientInfo]
WHERE employer <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENTS
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patients...'
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
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          pat.title , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.middlename , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.address1 , -- AddressLine1 - varchar(256)
          pat.address2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          pat.state , -- State - varchar(2)
          CASE
			WHEN LEN(pat.zipcode) IN (5,9) THEN pat.zipcode
			WHEN LEN(pat.zipcode) IN (4,8) THEN '0' + pat.zipcode
			ELSE '' END , -- ZipCode - varchar(9)
          CASE
			pat.gender WHEN 'F' THEN 'F'
					   WHEN 'M' THEN 'M'
					   ELSE 'U' END , -- Gender - varchar(1)
          CASE
			pat.maritalstatus WHEN '1' THEN 'S'
							  WHEN '2' THEN 'M'
							  WHEN '3' THEN 'D'
							  WHEN '4' THEN 'L'
							  WHEN '5' THEN 'W'
							  ELSE 'S' END , -- MaritalStatus - varchar(1)
          pat.homephone , -- HomePhone - varchar(10)
          pat.workphone , -- WorkPhone - varchar(10)
          pat.workphoneext , -- WorkPhoneExt - varchar(10)
          CASE
			WHEN ISDATE(pat.dob) = 1 THEN pat.dob
			ELSE '' END , -- DOB - datetime
          CASE 
			WHEN LEN(pat.ssn) = 6 THEN '000' + pat.ssn
			WHEN LEN(pat.ssn) = 7 THEN '00' + pat.ssn
			WHEN LEN(pat.ssn) = 8 THEN '0' + pat.ssn
			WHEN LEN(pat.ssn) = 9 THEN pat.ssn
			ELSE '' END , -- SSN - char(9)
          pat.email , -- EmailAddress - varchar(256)
          CASE
			pat.relationship WHEN '1' THEN 0
							 WHEN '2' THEN 1
							 WHEN '3' THEN 1
							 WHEN '4' THEN 1
							 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          rp.firstname , -- ResponsibleFirstName - varchar(64)
          rp.middlename , -- ResponsibleMiddleName - varchar(64)
          rp.lastname , -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
          CASE
			pat.relationship WHEN '2' THEN 'U'
						     WHEN '3' THEN 'C'
							 ELSE 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          rp.address1 , -- ResponsibleAddressLine1 - varchar(256)
          rp.address2 , -- ResponsibleAddressLine2 - varchar(256)
          rp.city , -- ResponsibleCity - varchar(128)
          rp.state , -- ResponsibleState - varchar(2)
          CASE
			WHEN LEN(REPLACE('-', '', rp.zipcode)) IN (5,9) THEN rp.zipcode
			WHEN LEN(REPLACE('-', '', rp.zipcode)) IN (4,8) THEN '0' + rp.zipcode
			ELSE '' END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          1 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          emp.EmployerID , -- EmployerID - int
          pat.chartnumber , -- MedicalRecordNumber - varchar(128)
          pat.cellphone , -- MobilePhone - varchar(10)
          1 , -- PrimaryCarePhysicianID - int
          pat.patientuid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_3_1_PatientInfo] AS pat
LEFT JOIN dbo.[_import_3_1_ResponsiblePartyInfo] AS rp ON
	rp.responsiblepartyuid = pat.responsiblepartyfid
LEFT JOIN dbo.Employers AS emp ON
	emp.EmployerName = pat.employer
WHERE pat.deceased = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENT JOURNAL NOTES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patient Journal Notes...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage 
        )
SELECT
		  pn.createdate , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.PatientID , -- PatientID - int
          'Kareo' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          pn.note  -- NoteMessage - varchar(max)
FROM dbo.[_import_3_1_PatientNotes] AS pn
LEFT JOIN dbo.Patient AS pat ON
	pat.VendorID = pn.patientfid AND
	pat.VendorImportID = @VendorImportID
WHERE pat.PatientID <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
	
/*
==========================================================================================================================================
CREATE PATIENT CASE
==========================================================================================================================================
*/

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
		  ShowExpiredInsurancePolicies 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please review before using.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- StatementActive - bit
		  1 -- ShowExpiredInsurancePolicies - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE INSURANCE POLICY
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Primary Insurance Policy...'
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
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          imp.sequencenumber , -- Precedence - int
          imp.SubscriberIDNumber , -- PolicyNumber - varchar(32)
          imp.groupnumber , -- GroupNumber - varchar(32)
          CASE
			WHEN ISDATE(imp.effectivestartdate) = 1 THEN imp.effectivestartdate
			ELSE NULL END , -- PolicyStartDate - datetime
		  CASE
			WHEN ISDATE(imp.effectiveenddate) = 1 THEN imp.effectiveenddate
			ELSE NULL END , -- PolicyEndDate - datetime      
          CASE
			imp.relationshippatienttosubscriber WHEN '1' THEN 'S'
												WHEN '2' THEN 'U'
												WHEN '3' THEN 'C'
												WHEN '4' THEN 'O'
												ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          rpi.firstname , -- HolderFirstName - varchar(64)
          rpi.middlename , -- HolderMiddleName - varchar(64)
          rpi.lastname , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE
			WHEN ISDATE(rpi.dob) = 1 THEN rpi.dob
			ELSE '' END , -- HolderDOB - datetime
          CASE
			WHEN LEN(rpi.ssn) = 6 THEN '000' + rpi.ssn
			WHEN LEN(rpi.ssn) = 7 THEN '00' + rpi.ssn
			WHEN LEN(rpi.ssn) = 8 THEN '0' + rpi.ssn
			WHEN LEN(rpi.ssn) = 9 THEN rpi.ssn
			ELSE '' END  , -- HolderSSN - char(11)
          CASE
			WHEN rpi.employer <> '' THEN 1
			ELSE 0 END , -- HolderThroughEmployer - bit
          CASE
			WHEN rpi.employer <> '' THEN rpi.employer
			ELSE '' END , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE
			rpi.Gender WHEN 'F' THEN 'F'
					   WHEN 'M' THEN 'M'
					   ELSE 'U' END , -- HolderGender - char(1)
          rpi.address1 , -- HolderAddressLine1 - varchar(256)
          rpi.address2 , -- HolderAddressLine2 - varchar(256)
          rpi.city , -- HolderCity - varchar(128)
          rpi.state , -- HolderState - varchar(2)
          CASE
			WHEN LEN(REPLACE('-', '', rpi.zipcode)) IN (5,9) THEN rpi.zipcode
			WHEN LEN(REPLACE('-', '', rpi.zipcode)) IN (4,8) THEN '0' + rpi.zipcode
			ELSE '' END , -- HolderZipCode - varchar(9)
          rpi.homephone , -- HolderPhone - varchar(10)
          imp.subscriberidnumber , -- DependentPolicyNumber - varchar(32)
          imp.copaydollaramount , -- Copay - money
          imp.annualdeductible , -- Deductible - money
          imp.subscriberidnumber , -- PatientInsuranceNumber - varchar(32)
          CASE
			WHEN imp.effectiveenddate <> '' THEN 0
			ELSE 1 END , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.patientfid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(imp.groupname , 14)  -- GroupName - varchar(14)
FROM dbo.[_import_3_1_PolicyInfo] AS imp
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = imp.patientfid AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = imp.carrierfid AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_3_1_ResponsiblePartyInfo] AS rpi ON
	rpi.responsiblepartyuid = imp.responsiblepartysubscriberfid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE REFERRING DOCTORS
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Doctor...'
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
          ZipCode ,
          WorkPhone ,
          WorkPhoneExt ,
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
          firstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          CASE
			WHEN LEN(REPLACE('-','', zipcode)) IN (5,9) THEN zipcode
			WHEN LEN(REPLACE('-','', zipcode)) IN (4,8) THEN '0' + zipcode
			ELSE '' END , -- ZipCode - varchar(9)
          officephone , -- WorkPhone - varchar(10)
          officeextension , -- WorkPhoneExt - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          title , -- Degree - varchar(8)
          referringprovideruid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          fax , -- FaxNumber - varchar(10)
          1 , -- External - bit
          LEFT(npinumber , 10)  -- NPI - varchar(10)
FROM dbo.[_import_3_1_ReferringInfo]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE APPOINTMENTS
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Appointments...'
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
          imp.startdate , -- StartDate - datetime
          imp.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          imp.comments , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imp.starttm , -- StartTm - smallint
          imp.endtm  -- EndTm - smallint
FROM dbo.[_import_5_1_Sheet1] AS imp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imp.patientfid AND
	pat.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase AS pc ON
	pc.PatientID = pat.PatientID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = (SELECT Dt FROM dbo.DateKeyToPractice WHERE Dt = DATEADD(d , 0, DATEDIFF(d , 0 , imp.startdate)))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE APPOINTMENT TO RESOURCE
==========================================================================================================================================
*/

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
		  app.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_5_1_Sheet1] AS imp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imp.patientfid AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS app ON
	app.PatientID = pat.PatientID AND
	app.StartDate = imp.startdate
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
UPDATE PATIENT CASES 
==========================================================================================================================================
*/

PRINT ''
PRINT 'Updating Patient Cases that have no cases...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11
	WHERE VendorImportID = @VendorImportID AND
		  PayerScenarioID = 5 AND 
		  PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'




COMMIT