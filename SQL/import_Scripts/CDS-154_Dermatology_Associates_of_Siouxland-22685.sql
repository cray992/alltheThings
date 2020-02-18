USE superbill_22685_dev
--USE superbill_22685_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in detination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 


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
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'

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
          state , -- State - varchar(2)
          CASE
			WHEN LEN(zipcode) IN (5,9) THEN zipcode
			WHEN LEN(zipcode) IN (4,8) THEN '0' + zipcode
			ELSE '' END , -- ZipCode - varchar(9)
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
          code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Insurance]
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
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE REFERRING PHYSICIANS
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Referring Physicians...'
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
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          referringprefix , -- Prefix - varchar(16)
          referringfirst , -- FirstName - varchar(64)
          referringmiddle , -- MiddleName - varchar(64)
          referringlast , -- LastName - varchar(64)
          referringsuffix , -- Suffix - varchar(16)
          referringaddress1 , -- AddressLine1 - varchar(256)
          referringaddress2 , -- AddressLine2 - varchar(256)
          referringcity , -- City - varchar(128)
          referringstate , -- State - varchar(2)
          CASE
			WHEN LEN(referringzip) IN (5,9) THEN referringzip
			WHEN LEN(referringzip) IN (4,8) THEN '0' + referringzip
			ELSE '' END , -- ZipCode - varchar(9)
          referringphone , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          referringcode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          referringfaxphone , -- FaxNumber - varchar(10)
          1 , -- External - bit
          referringnpi  -- NPI - varchar(10)
FROM dbo.[_import_1_1_ReferringPhysician]
WHERE referringfirst NOT IN ('DO','') AND referringlast NOT IN ('NOT USE','')
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
          employeradd1 , -- AddressLine1 - varchar(256)
          employercity , -- City - varchar(128)
          employerstate , -- State - varchar(2)
          CASE
			WHEN LEN(employerzip) IN (5,9) THEN employerzip
			WHEN LEN(employerzip) IN (4,8) THEN '0' + employerzip
			ELSE '' END , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_Employer]
WHERE employer <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PATIENTS
==========================================================================================================================================
*/

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
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.patientfirst , -- FirstName - varchar(64)
          pat.patientmiddle , -- MiddleName - varchar(64)
          pat.patientlast , -- LastName - varchar(64)
          pat.patientsuffix , -- Suffix - varchar(16)
          pat.homeadd1 , -- AddressLine1 - varchar(256)
          pat.homeadd2 , -- AddressLine2 - varchar(256)
          pat.homecity , -- City - varchar(128)
          pat.homestate , -- State - varchar(2)
          CASE
			WHEN LEN(pat.homezip) IN (5,9) THEN pat.homezip
			WHEN LEN(pat.homezip) IN (4,8) THEN '0' + pat.homezip
			ELSE '' END , -- ZipCode - varchar(9)
          CASE
			pat.sex WHEN 'F' THEN 'F'
					WHEN 'M' THEN 'M'
					ELSE 'U' END , -- Gender - varchar(1)
          CASE
			pat.maritalstatus WHEN 'M' THEN 'M'
							  WHEN 'W' THEN 'W'
							  WHEN 'D' THEN 'D'
							  ELSE 'S' END , -- MaritalStatus - varchar(1)
          LEFT(pat.homephone , 10) , -- HomePhone - varchar(10)
          CASE
			WHEN ISDATE(pat.dateofbirth) = 1 THEN pat.dateofbirth
			ELSE '' END , -- DOB - datetime
          pat.ssn , -- SSN - char(9)
          pat.patientemail , -- EmailAddress - varchar(256)
          CASE WHEN pat.GuarantorRelationship <> 'S' THEN 1
			   ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          CASE 
			WHEN pat.guarantorrelationship <> 'S' THEN pat.guarantorfirst
			ELSE '' END , -- ResponsibleFirstName - varchar(64)
          CASE
			WHEN pat.guarantorrelationship <> 'S' THEN pat.guarantormiddle
			ELSE '' END , -- ResponsibleMiddleName - varchar(64)
          CASE
			WHEN pat.guarantorrelationship <> 'S' THEN pat.guarantorlast
			ELSE '' END , -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
          CASE
			pat.guarantorrelationship WHEN 'C' THEN 'C'
									  WHEN 'O' THEN 'O'
									  WHEN 'U' THEN 'U'
									  ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE
			WHEN pat.guarantorrelationship <> 'S' THEN pat.guarantoradd1
			ELSE '' END , -- ResponsibleAddressLine1 - varchar(256)
          CASE
			WHEN pat.guarantorrelationship <> 'S' THEN pat.guarantoradd2
			ELSE '' END , -- ResponsibleAddressLine2 - varchar(256)
          CASE
			WHEN pat.guarantorrelationship <> 'S' THEN pat.guarantorcity
			ELSE '' END , -- ResponsibleCity - varchar(128)
          CASE
			WHEN pat.guarantorrelationship <> 'S' THEN pat.guarantorstate
			ELSE '' END , -- ResponsibleState - varchar(2)
          CASE
			WHEN pat.guarantorrelationship <> 'S' THEN (CASE
															WHEN LEN(pat.guarantorzip) IN (5,9) THEN pat.guarantorzip
															WHEN LEN(pat.guarantorzip) IN (4,8) THEN '0' + pat.guarantorzip
															ELSE '' END)
			ELSE '' END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          NULL , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          pat.accountnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(pat.patientcell, 10) , -- MobilePhone - varchar(10)
          '' , -- MobilePhoneExt - varchar(10)
          NULL , -- PrimaryCarePhysicianID - int
          pat.accountnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          pat.emergencycontact , -- EmergencyName - varchar(128)
          LEFT(pat.emergencyphone , 10)  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_1_1_PatientDemographic] AS pat
WHERE pat.patientfirst <> '' AND pat.patientlast <> ''
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
          VendorImportID 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please review before using' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE PRIMARY INSURANCE POLICIES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Primary Insurance Policies...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
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
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pat.primarypolicy , -- PolicyNumber - varchar(32)
          pat.primarygroup , -- GroupNumber - varchar(32)
          CASE
			pat.primaryinsuredrelationship WHEN 'C' THEN 'C'
										   WHEN 'U' THEN 'U'
										   WHEN 'O' THEN 'O'
										   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN pat.primaryinsuredfirstname
			ELSE '' END , -- HolderFirstName - varchar(64)
          CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN pat.primaryinsuredmiddlename
			ELSE '' END , -- HolderMiddleName - varchar(64)
          CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN pat.primaryinsuredlastname
			ELSE '' END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN (CASE 
																WHEN ISDATE(pat.primaryinsureddob) = 1 THEN pat.primaryinsureddob
																ELSE '' END)
			ELSE '' END , -- HolderDOB - datetime
          CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN (CASE
																WHEN LEN(pat.primaryinsuredssn) = 6 THEN '000' + pat.primaryinsuredssn
																WHEN LEN(pat.primaryinsuredssn) = 7 THEN '00' + pat.primaryinsuredssn
																WHEN LEN(pat.primaryinsuredssn) = 8 THEN '0' + pat.primaryinsuredssn
																WHEN LEN(pat.primaryinsuredssn) = 9 THEN pat.primaryinsuredssn
																ELSE '' END)
			ELSE '' END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN (CASE
																pat.primaryinsuredgender WHEN 'F' THEN 'F'
																						 WHEN 'M' THEN 'M'
																						 ELSE 'U' END)
			ELSE '' END  , -- HolderGender - char(1)
		  CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN pat.homeadd1
			ELSE '' END , -- HolderAddressLine1 - varchar(256)
          CASE 
			WHEN pat.primaryinsuredrelationship <> 'S' THEN pat.homeadd2
			ELSE '' END , -- HolderAddressLine2 - varchar(256)
          CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN pat.homecity
			ELSE '' END , -- HolderCity - varchar(128)
          CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN pat.homestate
			ELSE '' END , -- HolderState - varchar(2)
          CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN (CASE
																WHEN LEN(pat.homezip) IN (5,9) THEN pat.homezip
																WHEN LEN(pat.homezip) IN (4,8) THEN '0' + pat.homezip
																ELSE '' END)
			ELSE '' END , -- HolderZipCode - varchar(9)
          CASE
			WHEN pat.primaryinsuredrelationship <> 'S' THEN LEFT(pat.homephone , 10)
													   ELSE '' END , -- HolderPhone - varchar(10)
          pat.primarypolicy , -- DependentPolicyNumber - varchar(32)
          pat.primarypolicy , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pat.accountnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemographic] AS pat
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = pat.accountnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = pat.primaryinsurancecode AND
	icp.VendorImportID = @VendorImportID
WHERE pat.primarypolicy <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE SECONDARY INSURANCE POLICIES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Secondary Insurance Policies...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
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
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pat.secondaryinsurancepolicy , -- PolicyNumber - varchar(32)
          pat.secondaryinsurancegroup , -- GroupNumber - varchar(32)
          CASE
			pat.ins2phrel WHEN 'C' THEN 'C'
						  WHEN 'U' THEN 'U'
						  WHEN 'O' THEN 'O'
						  ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE
			WHEN pat.ins2phrel <> 'S' THEN pat.secondaryinsuredfirstname
			ELSE '' END , -- HolderFirstName - varchar(64)
          CASE
			WHEN pat.ins2phrel <> 'S' THEN pat.secondaryinsuredmiddlename
			ELSE '' END , -- HolderMiddleName - varchar(64)
          CASE
			WHEN pat.ins2phrel <> 'S' THEN pat.secondaryinsuredlastname
			ELSE '' END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE
			WHEN pat.ins2phrel <> 'S' THEN (CASE 
												WHEN ISDATE(pat.secondaryinsureddob) = 1 THEN pat.secondaryinsureddob
												ELSE '' END)
			ELSE '' END , -- HolderDOB - datetime
          CASE
			WHEN pat.ins2phrel <> 'S' THEN (CASE
												WHEN LEN(pat.secondaryinsuredssn) = 6 THEN '000' + pat.secondaryinsuredssn
												WHEN LEN(pat.secondaryinsuredssn) = 7 THEN '00' + pat.secondaryinsuredssn
												WHEN LEN(pat.secondaryinsuredssn) = 8 THEN '0' + pat.secondaryinsuredssn
												WHEN LEN(pat.secondaryinsuredssn) = 9 THEN pat.secondaryinsuredssn
												ELSE '' END)
			ELSE '' END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE
			WHEN pat.ins2phrel <> 'S' THEN (CASE
												pat.secondaryinsuredgender WHEN 'F' THEN 'F'
																		   WHEN 'M' THEN 'M'
																		   ELSE 'U' END)
			ELSE '' END  , -- HolderGender - char(1)
		  CASE
			WHEN pat.ins2phrel <> 'S' THEN pat.homeadd1
			ELSE '' END , -- HolderAddressLine1 - varchar(256)
          CASE 
			WHEN pat.ins2phrel <> 'S' THEN pat.homeadd2
			ELSE '' END , -- HolderAddressLine2 - varchar(256)
          CASE
			WHEN pat.ins2phrel <> 'S' THEN pat.homecity
			ELSE '' END , -- HolderCity - varchar(128)
          CASE
			WHEN pat.ins2phrel <> 'S' THEN pat.homestate
			ELSE '' END , -- HolderState - varchar(2)
          CASE
			WHEN pat.ins2phrel <> 'S' THEN (CASE
												WHEN LEN(pat.homezip) IN (5,9) THEN pat.homezip
												WHEN LEN(pat.homezip) IN (4,8) THEN '0' + pat.homezip
												ELSE '' END)
			ELSE '' END , -- HolderZipCode - varchar(9)
          CASE
			WHEN pat.ins2phrel <> 'S' THEN LEFT(pat.homephone , 10)
									  ELSE '' END , -- HolderPhone - varchar(10)
          pat.secondaryinsurancepolicy , -- DependentPolicyNumber - varchar(32)
          pat.secondaryinsurancepolicy , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pat.accountnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemographic] AS pat
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = pat.accountnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = pat.secondaryinsurancecode AND
	icp.VendorImportID = @VendorImportID
WHERE pat.secondaryinsurancepolicy <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE TERTIARY INSURANCE POLICIES
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Tertiary Insurance Policies...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
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
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          pat.tertiarypolicy , -- PolicyNumber - varchar(32)
          pat.tertiarygroup , -- GroupNumber - varchar(32)
          CASE
			pat.tertiaryinsuredrelationship WHEN 'C' THEN 'C'
											WHEN 'U' THEN 'U'
											WHEN 'O' THEN 'O'
											ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN pat.tertiaryinsuredfirstname
			ELSE '' END , -- HolderFirstName - varchar(64)
          CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN pat.tertiaryinsuredmiddlename
			ELSE '' END , -- HolderMiddleName - varchar(64)
          CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN pat.tertiaryinsuredlastname
			ELSE '' END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN (CASE 
																WHEN ISDATE(pat.tertiaryinsureddob) = 1 THEN pat.tertiaryinsureddob
																ELSE '' END)
			ELSE '' END , -- HolderDOB - datetime
          CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN (CASE
																WHEN LEN(pat.teritaryinsuredssn) = 6 THEN '000' + pat.teritaryinsuredssn
																WHEN LEN(pat.teritaryinsuredssn) = 7 THEN '00' + pat.teritaryinsuredssn
																WHEN LEN(pat.teritaryinsuredssn) = 8 THEN '0' + pat.teritaryinsuredssn
																WHEN LEN(pat.teritaryinsuredssn) = 9 THEN pat.teritaryinsuredssn
																ELSE '' END)
			ELSE '' END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN (CASE
																pat.teritiaryinsuredgender WHEN 'F' THEN 'F'
																						   WHEN 'M' THEN 'M'
																						   ELSE 'U' END)
			ELSE '' END  , -- HolderGender - char(1)
		  CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN pat.homeadd1
			ELSE '' END , -- HolderAddressLine1 - varchar(256)
          CASE 
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN pat.homeadd2
			ELSE '' END , -- HolderAddressLine2 - varchar(256)
          CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN pat.homecity
			ELSE '' END , -- HolderCity - varchar(128)
          CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN pat.homestate
			ELSE '' END , -- HolderState - varchar(2)
          CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN (CASE
																WHEN LEN(pat.homezip) IN (5,9) THEN pat.homezip
																WHEN LEN(pat.homezip) IN (4,8) THEN '0' + pat.homezip
																ELSE '' END)
			ELSE '' END , -- HolderZipCode - varchar(9)
          CASE
			WHEN pat.tertiaryinsuredrelationship <> 'S' THEN LEFT(pat.homephone , 10)
														ELSE '' END , -- HolderPhone - varchar(10)
          pat.tertiarypolicy , -- DependentPolicyNumber - varchar(32)
          pat.tertiarypolicy , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pat.accountnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatientDemographic] AS pat
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = pat.accountnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON
	icp.VendorID = pat.tertiaryinsurancecode AND
	icp.VendorImportID = @VendorImportID
WHERE pat.tertiaryinsurancecode <> ''
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
          sl.ServiceLocationID , -- ServiceLocationID - int
          app.startdate , -- StartDate - datetime
          app.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          app.appointmentnotes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int-
          app.starttm , -- StartTm - smallint
          app.endtm -- EndTm - smallint
FROM dbo.[_import_1_1_Appointment] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.patientaccountnumber AND
	pat.VendorImportID = @VendorImportID
INNER JOIN dbo.ServiceLocation AS sl ON
	sl.Name = app.servicelocation AND
	sl.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase AS pc ON
	pc.PatientID = pat.PatientID AND
	pc.PracticeID = @PracticeID  
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = (SELECT Dt FROM dbo.DateKeyToPractice WHERE Dt = DATEADD(d , 0, DATEDIFF(d , 0 , app.startdate)))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE APPOINTMENT REASONS
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  appt.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.patientaccountnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS appt ON
	appt.PatientID = pat.PatientID AND
	appt.StartDate = app.startdate
INNER JOIN dbo.AppointmentReason AS ar ON
	ar.Name = app.appointmentdescription AND
	ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
  
/*
==========================================================================================================================================
CREATE APPOINTMENT RESOURCES
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
FROM dbo.[_import_1_1_Appointment] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.patientaccountnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS appt ON
	appt.PatientID = pat.PatientID AND
	appt.PracticeID = @PracticeID
INNER JOIN dbo.Doctor AS doc ON
	doc.FirstName = app.resourcefirstname AND
	doc.LastName = app.resourcelastname AND
	doc.PracticeID = @PracticeID AND
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


--ROLLBACK TRANSACTION
COMMIT