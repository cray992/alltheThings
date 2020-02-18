USE superbill_21022_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 9

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
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
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
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Phone ,
          PhoneExt ,
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
		  name , -- InsuranceCompanyName - varchar(128)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state, 2) , -- State - varchar(2)
          CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(zipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zipcode)) = 8 THEN '0' + dbo.fn_RemoveNonNumericCharacters(zipcode)
			ELSE '' END , -- ZipCode - varchar(9)
          LEFT(phone , 10) , -- Phone - varchar(10)
          phoneext , -- PhoneExt - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
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
          insuranceid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_9_1_Insurances]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE INSURANCE COMPANY PLANS
==========================================================================================================================================
*/

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
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          VendorID ,
          VendorImportID ,
		  InsuranceCompanyID
        )
SELECT DISTINCT
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
		  InsuranceCompanyID --InsuranceCompanyID - int
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE EMPLOYERS
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  employer , -- EmployerName - varchar(128)
          employeraddress1 , -- AddressLine1 - varchar(256)
          employeraddress2 , -- AddressLine2 - varchar(256)
          employercity , -- City - varchar(128)
          employerstate , -- State - varchar(2)
          employerzipcode , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_9_1_PatientDemographic]
WHERE employer <> '' AND employer <> 'none'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          EmergencyName ,
          EmergencyPhone ,
		  EmploymentStatus
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.firstname , -- FirstName - varchar(64)
          pat.middlename , -- MiddleName - varchar(64)
          pat.lastname , -- LastName - varchar(64)
          pat.suffix , -- Suffix - varchar(16)
          pat.address1 , -- AddressLine1 - varchar(256)
          pat.address2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state , 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pat.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(pat.zipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pat.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(pat.zipcode)
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pat.zipcode)) = 8 THEN '0' + dbo.fn_RemoveNonNumericCharacters(pat.zipcode)
			ELSE '' END , -- ZipCode - varchar(9)
          CASE pat.gender WHEN 'F' THEN 'F'
						  WHEN 'M' THEN 'M'
						  ELSE 'U' END , -- Gender - varchar(1)
          CASE pat.maritalstatus WHEN 'Married' THEN 'M'
								 WHEN 'Divorced' THEN 'D'
								 WHEN 'Widowed' THEN 'W'
								 WHEN 'Single' THEN 'S'
								 ELSE 'S' END , -- MaritalStatus - varchar(1)
          LEFT(pat.homephone , 10) , -- HomePhone - varchar(10)
          LEFT(pat.workphone , 10) , -- WorkPhone - varchar(10)
          LEFT(pat.workphoneext , 10) , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(pat.dateofbirth) = 1 THEN pat.dateofbirth
			   ELSE NULL END , -- DOB - datetime
          CASE
			WHEN LEN(pat.ssn) = 7 THEN '00' + pat.ssn
			WHEN LEN(pat.ssn) = 8 THEN '0' + pat.ssn
			WHEN LEN(pat.ssn) = 9 THEN pat.ssn
			ELSE '' END , -- SSN - char(9)
          pat.emailaddress , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          doc.DoctorID , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          pat.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(pat.mobilephone , 10) , -- MobilePhone - varchar(10)
          doc.DoctorID , -- PrimaryCarePhysicianID - int
          pat.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          CASE pat.activeinactive WHEN 1 THEN 1
								  WHEN 0 THEN 0
								  ELSE 1 END , -- Active - bit
          CASE WHEN pat.emailaddress <> '' THEN 1
			   ELSE 0 END , -- SendEmailCorrespondence - bit
          pat.emergencycontactname , -- EmergencyName - varchar(128)
          LEFT(pat.emergencycontactphone , 10) , -- EmergencyPhone - varchar(10)
		  'U' -- EmploymentStatus
FROM dbo.[_import_9_1_PatientDemographic] AS pat
LEFT JOIN dbo.Doctor AS doc ON
	doc.FirstName = pat.renderingproviderfirstname AND
	doc.LastName = pat.renderingproviderlastname AND
	doc.[External] = 0 AND
	doc.PracticeID = @PracticeID
--LEFT JOIN dbo.ServiceLocation AS sl ON
--	sl.PracticeID = @PracticeID
WHERE pat.firstname <> '' AND pat.lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENT CASES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Patient Cases...'
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
          StatementActive 
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
          1  -- StatementActive - bit
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PRIMARY INSURANCE POLICIES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Insurance Policy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pat.primaryidnumber , -- PolicyNumber - varchar(32)
          pat.primarygroupnumber , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_9_1_PatientDemographic] AS pat
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = pat.chartnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = pat.primaryinsuranceid AND
	icp.VendorImportID = @VendorImportID
WHERE primaryinsuranceid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE SECONDARY INSURANCE POLICIES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pat.secondaryidnumber , -- PolicyNumber - varchar(32)
          pat.secondarygroupnumber , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_9_1_PatientDemographic] AS pat
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = pat.chartnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = pat.secondaryinsuranceid AND
	icp.VendorImportID = @VendorImportID
WHERE secondaryinsuranceid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE TERTIARY INSURANCE POLICIES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Insurance Policy 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          pat.tertiaryidnumber , -- PolicyNumber - varchar(32)
          pat.tertiarygroupnumber , -- GroupNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_9_1_PatientDemographic] AS pat
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = pat.chartnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = pat.tertiaryinsuranceid AND
	icp.VendorImportID = @VendorImportID
WHERE tertiaryinsuranceid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE REFERRING PHYSICIANS
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Doctors...'
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
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          firstname , -- FirstName - varchar(64)
          middlename , -- MiddleName - varchar(64)
          lastname , -- LastName - varchar(64)
          suffix , -- Suffix - varchar(16)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          LEFT(state , 2) , -- State - varchar(2)
          CASE 
			WHEN LEN(zipcode) IN (5,9) THEN zipcode
			WHEN LEN(zipcode) = 4 THEN '0' + zipcode
			ELSE '' END , -- ZipCode - varchar(9)
          LEFT(phone , 10) , -- WorkPhone - varchar(10)
          LEFT(phoneext , 10) , -- WorkPhoneExt - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          LEFT(degree , 8) , -- Degree - varchar(8)
          id , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          REPLACE(npi, '-', '')  -- NPI - varchar(10)
FROM dbo.[_import_9_1_ReferringPhysician]
WHERE firstname <> '' AND lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE STANDARD FEE SCHEDULE
==========================================================================================================================================
*/

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
          MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID ,
          AddPercent ,
          AnesthesiaTimeIncrement
        )
VALUES  ( 
		  @PracticeID , -- PracticeID - int
          'Default Contract' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          '2013-01-01 07:00:00' , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
		  )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE STANDARD FEE
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Standard Fee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT DISTINCT
	      sfs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          imp.price , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_9_1_FeeSchedule] AS imp
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
	CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	sfs.PracticeID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
	pcd.ProcedureCode = imp.cptcode  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE STANDARD FEE LINK
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Standard Fee Link...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT DISTINCT
		  doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor AS doc, dbo.ServiceLocation AS sl, dbo.ContractsAndFees_StandardFeeSchedule AS sfs
WHERE doc.[External] = 0 AND
	  doc.PracticeID = @PracticeID AND
	  sl.PracticeID = @PracticeID AND
	  CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	  sfs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE APPOINTMENT
==========================================================================================================================================
*/

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
          app.StartDateTime , --StartDate 
		  app.EndDateTime , -- EndDate
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          app.appnotes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE app.status WHEN 'Pending' THEN 'C'
						  WHEN 'Confirmed' THEN 'C'
						  WHEN 'Canceled' THEN 'X'
						  WHEN 'Missed' THEN 'N'
						  WHEN 'Waiting' THEN 'C'
						  ELSE 'C' END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          app.starttime  , -- StartTm - smallint (minus 300 for eastern timezone)
          app.endtime  -- EndTm - smallint (minus 300 for eastern timezone)
FROM dbo.[_import_9_1_Sheet1] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.patientchartnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase AS pc ON
	pc.PatientID = pat.PatientID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = (SELECT Dt FROM dbo.DateKeyToPractice WHERE Dt = DATEADD(d , 0, DATEDIFF(d , 0 , app.startdatetime)))
PRINT CAST(@@rowcount AS VARCHAR) + ' records inserted'
 
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
		  appt.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          doc.DoctorID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_9_1_Sheet1] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.patientchartnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS appt ON
	appt.PatientID = pat.PatientID AND
	appt.StartDate = app.startdatetime
INNER JOIN dbo.Doctor AS doc ON
	doc.FirstName = app.defaultrenderingproviderfirstname AND
	doc.LastName = app.defaultrenderingproviderlastname AND
    doc.[External] = 0  
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