USE superbill_28086_dev
--USE superbill_28086_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 1
SET @PracticeID = 1


--DECLARE @ContractFeesToNuke TABLE (ContractRateScheduleID INT )
--INSERT INTO @ContractFeesToNuke (ContractRateScheduleID)
--(
--       SELECT DISTINCT ContractRateScheduleID FROM dbo.ContractsAndFees_ContractRateSchedule
--	   WHERE SourceFileName = 'Import file'
--) 


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
--DELETE FROM dbo.ContractsAndFees_ContractRateScheduleLink WHERE ContractRateScheduleID IN (SELECT ContractRateScheduleID FROM @ContractFeesToNuke)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractRateScheduleLink records deleted'
--DELETE FROM dbo.ContractsAndFees_ContractRate WHERE ContractRateScheduleID IN (SELECT ContractRateScheduleID FROM @ContractFeesToNuke)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractRate records deleted'
--DELETE FROM dbo.ContractsAndFees_ContractRateSchedule WHERE ContractRateScheduleID IN (SELECT ContractRateScheduleID FROM @ContractFeesToNuke)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractRateSchedule records deleted'
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
--DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
--DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = -50 AND ModifiedUserID = -50
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , AddressLine1 , AddressLine2 , City , State , ZipCode , ContactFirstName , ContactLastName , Phone , 
	PhoneExt , Fax , FaxExt , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , HCFASameAsInsuredFormatCode , 
	ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , SecondaryPrecedenceBillingFormID ,
	VendorID , VendorImportID , Notes , NDCFormat , UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	LEFT(CASE 
		WHEN LEN(insurancecompanyname) > 1 THEN insurancecompanyname
		ELSE insuranceplanname END,128) AS Name , -- InsuranceCompanyName - varchar(128)
	LEFT(insurancestreet1,256) AS addressline1 , -- AddressLine1 - varchar(256)
	LEFT(insurancestreet2,256) AS addressline2, -- AddressLine2 - varchar(256)
	LEFT(insurancecity,128) AS city, -- City - varchar(128)
	UPPER(LEFT(insurancestate,2)) AS [state] , -- State - varchar(2)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(insurancezip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(insurancezip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(insurancezip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(insurancezip)
		ELSE '' END AS zipcode, -- ZipCode - varchar(9)
	LEFT(ContactFirstName,64) AS contactfirst , -- ContactFirstName - varchar(64)
	LEFT(ContactLastName,64) AS contactlast, -- ContactLastName - varchar(64)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(insurancephone)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(insurancephone)
		ELSE '' END AS contactphone, -- Phone - varchar(10)
	LEFT(insurancephoneext,10) AS contacthoneext , -- PhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(insurancefax)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(insurancefax),10)
		ELSE '' END AS fax , -- Fax - varchar(10)
	left(dbo.fn_RemoveNonNumericCharacters(insurancefaxext), 10) AS faxext , -- FaxExt - varchar(10)
	acceptselectronicclaims, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' InsuranceProgramCode, -- InsuranceProgramCode - char(2)
	'C' HCFADiagnosisReferenceFormatCode, -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' HCFASameAsInsuredFormatCode, -- HCFASameAsInsuredFormatCode - char(1)
	'R' , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() CreatedDate, -- CreatedDate - datetime
	0 CreatedUserID, -- CreatedUserID - int
	GETDATE() ModifiedDate, -- ModifiedDate - datetime
	0 ModifiedUserID, -- ModifiedUserID - int
	13 , -- SecondaryPrecedenceBillingFormID - int
	insuranceid , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	IICL.notes, -- Notes text 
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' AnesthesiaType, -- AnesthesiaType - varchar(1)
	18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceCompanyPlanList] AS IICL
WHERE
	insurancecompanyname <> '' OR insuranceplanname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SELECT COUNT(*) FROM dbo.[_import_1_1_InsuranceCOMPANYPLANList] WHERE insurancecompanyname <> '' OR insuranceplanname <> ''
--1170


PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactPrefix , ContactFirstName , ContactMiddleName , ContactLastName , 
	ContactSuffix , Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT 
	CASE WHEN ICP.insuranceplanname <> '' THEN LEFT(ICP.insuranceplanname,128)
		 ELSE IC.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(IC.AddressLine1,256) , -- AddressLine1 - varchar(256)
	LEFT(IC.AddressLine2,256) , -- AddressLine2 - varchar(256)
	LEFT(IC.City,128) , -- City - varchar(128)
	LEFT(IC.[State],2) , -- State - varchar(2)
	LEFT(IC.Country,32) , -- Country - varchar(32)
	LEFT(IC.ZipCode,9) , -- ZipCode - varchar(9)
	LEFT(IC.ContactPrefix,16) , -- ContactPrefix - varchar(16)
	LEFT(IC.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(IC.ContactMiddleName,64) , -- ContactMiddleName - varchar(64)
	LEFT(IC.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(IC.ContactSuffix,16) , -- ContactSuffix - varchar(16)
	LEFT(IC.Phone,10) , -- Phone - varchar(10)
	LEFT(IC.PhoneExt,10) , -- PhoneExt - varchar(10)
	IC.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	IC.Fax , -- Fax - varchar(10)
	IC.FaxExt , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	ic.VendorID,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany IC 
LEFT JOIN dbo.[_import_1_1_InsuranceCOMPANYPLANList] ICP ON
	IC.VendorID = ICP.insuranceid AND
	ICP.Insurancecompanyname = IC.InsuranceCompanyName AND
	ICP.insurancestreet1 = IC.AddressLine1  
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID  
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Referring Doctor...'
INSERT INTO dbo.Doctor
( 
	PracticeID , Prefix, Suffix, FirstName , MiddleName , LastName , SSN , AddressLine1 , AddressLine2 , City , State , Country , HomePhone , HomePhoneExt , 
	WorkPhone , WorkPhoneExt , MobilePhone , MobilePhoneExt , DOB , EmailAddress , Notes , ActiveDoctor , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , UserID , Degree , VendorID , VendorImportID , FaxNumber , FaxNumberExt , [External] , NPI 
)
SELECT DISTINCT 
	@PracticeID , -- PracticeID - int
	'', -- Prefix
	LEFT(irp.suffix,16), -- Suffix
	LEFT(irp.firstname,64) , -- FirstName - varchar(64)
	LEFT(irp.middleinitial,64) , -- MiddleName - varchar(64)
	LEFT(irp.lastname,64) , -- LastName - varchar(64)
	CASE
		WHEN LEN(ssn) = 9 THEN ssn
		ELSE NULL END , -- SSN - varchar(9)
	LEFT(street1,256) , -- AddressLine1 - varchar(256)
	LEFT(street2,256) , -- AddressLine2 - varchar(256)
	LEFT(city,128) , -- City - varchar(128)
	UPPER(LEFT(state,2)) , -- State - varchar(2)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(zip)
		ELSE '' END , -- ZipCode - varchar(9)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(homephone),10)
		ELSE '' END , -- HomePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(homephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(homephone))),10)
		ELSE NULL END , -- HomePhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(workphone),10)
		ELSE '' END , -- WorkPhone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(workphoneextension),10) , -- WorkPhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(cellphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(cellphone),10)
		ELSE '' END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(cellphone)) >= 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(cellphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(cellphone))),10)
		ELSE NULL END  , -- MobilePhoneExt - varchar(10)
	CASE
		WHEN ISDATE(dateofbirth) = 1 THEN dateofbirth
		ELSE NULL END , -- DOB - datetime
	LEFT(email,256) , -- EmailAddress - varchar(256)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.  ' + notes , -- Notes - text
	1 , -- ActiveDoctor - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	0 , -- UserID - int
	UPPER(LEFT(degree,8)) , -- Degree - varchar(8)
	IRP.AutoTempID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(fax),10) , -- FaxNumber - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(faxext),10) , -- FaxNumberExt - varchar(10)
	1, -- External - bit
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(npi)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(npi)
		ELSE NULL END -- NPI - varchar(10)
FROM dbo.[_import_1_1_ReferringProviders] irp 
WHERE NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE 
						d.FirstName = irp.firstname AND
						d.LastName = irp.lastname)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Referring Doctor from [dbo._import_1_1_PatientDemographics.PrimaryCarePhysician]...'
INSERT INTO dbo.Doctor
        ( PracticeID , Prefix , FirstName , MiddleName , LastName , Suffix , ActiveDoctor , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , 
		  VendorID , VendorImportID , [External] 
        )
SELECT DISTINCT  
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          irp.primarycarephysicianfirstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          irp.primarycarephysicianlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          NULL , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- External - bit
FROM dbo.[_import_1_1_PatientDemographics] irp
WHERE irp.primarycarephysicianfirstname <> '' AND irp.primarycarephysicianlastname <> '' 
AND NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE 
						d.FirstName = irp.primarycarephysicianfirstname AND
						d.LastName = irp.primarycarephysicianlastname AND
						d.PracticeID = @PracticeID)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Referring Doctor from [dbo._import_1_1_PatientDemographics.ReferringProviders]...'
INSERT INTO dbo.Doctor
        ( PracticeID , Prefix , FirstName , MiddleName , LastName , Suffix , ActiveDoctor , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , 
		  VendorID , VendorImportID , [External] 
        )
SELECT DISTINCT  
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          irp.referringphysicianfirstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          irp.referringphysicianlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          NULL , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- External - bit
FROM dbo.[_import_1_1_PatientDemographics] irp
WHERE irp.referringphysicianfirstname <> '' AND irp.referringphysicianlastname <> '' 
AND NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE 
						d.FirstName = irp.referringphysicianfirstname AND
						d.LastName = irp.referringphysicianlastname AND
						d.PracticeID = @PracticeID)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Employer...'
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
          ModifiedUserID ,
          RecordTimeStamp
        )
SELECT DISTINCT
		  i.employername , -- EmployerName - varchar(128)
          i.employeraddress1 , -- AddressLine1 - varchar(256)
          i.employeraddress2 , -- AddressLine2 - varchar(256)
          i.employercity , -- City - varchar(128)
          UPPER(i.employerstate) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.employerzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.employerzip)  
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.employerzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.employerzip)
			   ELSE '' END , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          NULL  -- RecordTimeStamp - timestamp
FROM dbo.[_import_1_1_PatientDemographics] i
WHERE i.employername <> '' AND NOT EXISTS (SELECT * FROM dbo.Employers e WHERE 
												e.EmployerName = i.employername AND
												e.AddressLine1 = i.employeraddress1)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
( 
	PracticeID , ReferringPhysicianID , Prefix, Suffix, FirstName , MiddleName , LastName , AddressLine1 , AddressLine2 , City , State , ZipCode , Gender , 
	MaritalStatus , HomePhone , HomePhoneExt , WorkPhone , WorkPhoneExt , DOB , SSN , EmailAddress , ResponsibleDifferentThanPatient , ResponsiblePrefix, ResponsibleFirstName,
	ResponsibleMiddleName, ResponsibleLastName, ResponsibleSuffix, ResponsibleRelationshipToPatient, ResponsibleAddressLine1, ResponsibleAddressline2, ResponsibleCity, ResponsibleState,
	ResponsibleZipCode, CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , EmploymentStatus , PrimaryProviderID , DefaultServiceLocationID , EmployerID , MedicalRecordNumber , 
	MobilePhone , MobilePhoneExt , PrimaryCarePhysicianID , VendorID , VendorImportID , CollectionCategoryID , Active , SendEmailCorrespondence , 
	PhonecallRemindersEnabled, EmergencyName, EmergencyPhone, EmergencyPhoneExt
)
SELECT DISTINCT
	@PracticeID , -- PracticeID - int
	ReferringDoc1.DoctorID , -- ReferringPhysicianID - int
	'' , -- Prefix 
	LEFT(IPD.suffix, 16) , -- Suffix
	LEFT(IPD.firstname,64) , -- FirstName - varchar(64)
	LEFT(IPD.middleinitial,64) , -- MiddleName - varchar(64)
	LEFT(IPD.lastname,64) , -- LastName - varchar(64)
	LEFT(IPD.street1,256) , -- AddressLine1 - varchar(256)
	LEFT(IPD.street2,256) , -- AddressLine2 - varchar(256)
	LEFT(IPD.city,128) , -- City - varchar(128)
	UPPER(LEFT(IPD.state,2)) , -- State - varchar(2)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(IPD.zipcode)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(IPD.zipcode)
		ELSE '' END , -- ZipCode - varchar(9)
	CASE
		WHEN IPD.gender IN ('M','Male') THEN 'M'
		WHEN IPD.gender IN ('F','Female') THEN 'F'
		ELSE 'U' END , -- Gender - varchar(1)
	CASE 
		WHEN IPD.maritalstatus IN ('D','Divorced') THEN 'D'
		WHEN IPD.maritalstatus IN ('M','Married') THEN 'M'
		WHEN IPD.maritalstatus IN ('S','Single') THEN 'S'
		WHEN IPD.maritalstatus IN ('W','Widowed') THEN 'W'
		ELSE '' END , -- MaritalStatus - varchar(1)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.homephone),10)
		ELSE LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.homephone) , 10) END, -- HomePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.homephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(IPD.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(IPD.homephone))),10)
		ELSE NULL END , -- HomePhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.workphone),10)
		ELSE LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.workphone) , 10) END , -- WorkPhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.workphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(IPD.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(IPD.homephone))),10)
		ELSE NULL END , -- WorkPhoneExt - varchar(10)
	CASE
		WHEN ISDATE(IPD.dateofbirth) = 1 THEN IPD.dateofbirth
		ELSE NULL END , -- DOB - datetime
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.socialsecuritynumber)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(IPD.socialsecuritynumber), 9)
		ELSE NULL END , -- SSN - char(9)
	LEFT(IPD.email,256) , -- EmailAddress - varchar(256)
	CASE WHEN IPD.responsiblepartyrelationship  <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
	'' , -- ResponsiblePrefix - varchar(16)
	LEFT(IPD.responsiblepartyfirstname, 64) , -- ResponsibleFirstName - varchar(64)
	LEFT(IPD.responsiblepartymiddlename, 64) , -- ResponsibleMiddleName - varchar(64)
	LEFT(IPD.responsiblepartylastname, 64) , -- ResposibleLastName - varchar(64)
	LEFT(IPD.responsiblepartysuffix, 16) , -- ResponsibleSuffix - varchar(16)
	LEFT(IPD.responsiblepartyrelationship, 1) , -- ResponsibleRelationshipToPatient (char)
	LEFT(IPD.responsiblepartyaddress1, 256) , -- ResponsibleAddressLine1 - varchar(256)
	LEFT(IPD.responsiblepartyaddress2, 256) , -- ResponsibleAddressLine2 - varchar(256)
	LEFT(IPD.responsiblepartycity, 128) , -- ResponsibleCity - varchar(128) 
	LEFT(IPD.responsiblepartystate, 2) , -- ResponsibleState - varchar(2)
	LEFT(REPLACE(IPD.responsiblepartyzipcode, '-',''), 9) , -- ResponsibleZipCode - varchar(9)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	CASE
		WHEN IPD.employmentstatus IN ('E','Employed') THEN 'E'
		WHEN IPD.employmentstatus IN ('R','Retired') THEN 'R'
		WHEN IPD.employmentstatus IN ('S','Student, Full-Time') THEN 'S'
		WHEN IPD.employmentstatus IN ('T','Student, Part-Time') THEN 'T'
		ELSE 'U' END, -- EmploymentStatus - char(1)
	2 , -- PrimaryProviderID - int 
	1 , -- DefaultServiceLocationID - int 
	E.EmployerID, -- EmployerID - int 
	LEFT(IPD.chartnumber,128) , -- MedicalRecordNumber - varchar(128)
	CASE
		WHEN LEN(IPD.cellphone) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.cellphone),10)
		ELSE LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.cellphone) , 10) END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.cellphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(IPD.cellphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(IPD.cellphone))),10)
		ELSE NULL END , -- MobilePhoneExt - varchar(10)
	PrimaryDoc.DoctorID , -- PrimaryCarePhysicianID - int 
	ipd.chartnumber, -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- CollectionCategoryID - int
	CASE 
		WHEN IPD.activestatusyesorno IN ('0','No','N','Inactive') THEN 0
		ELSE 1 END, -- Active - bit
	1, -- SendEmailCorrespondence - bit
	0,  -- PhonecallRemindersEnabled - bit
	LEFT(IPD.Emergencyname,128) , -- EmergencyName - varchar(128)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(IPD.Emergencyphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.Emergencyphone),10)
		ELSE '' END , -- EmergencyPhone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(IPD.Emergencyphoneext),10) -- EmergencyPhoneExt - varchar(10)
FROM dbo.[_import_1_1_PatientDemographics] AS IPD
	LEFT JOIN dbo.Doctor AS ReferringDoc1 ON 
		ReferringDoc1.DoctorID = (SELECT TOP 1 DoctorID FROM dbo.Doctor AS ReferringDoc2
									WHERE ReferringDoc2.FirstName = IPD.referringphysicianfirstname AND
										  ReferringDoc2.LastName = IPD.referringphysicianlastname AND
										  ReferringDoc2.[External] = 1 AND
										  ReferringDoc2.PracticeID = 1)
	LEFT JOIN dbo.Doctor AS PrimaryDoc ON 
		PrimaryDoc.DoctorID = (SELECT TOP 1 DoctorID FROM dbo.Doctor AS PrimaryDoc1
									WHERE PrimaryDoc1.FirstName = IPD.primarycarephysicianfirstname AND
										  PrimaryDoc1.LastName = IPD.primarycarephysicianlastname AND
										  PrimaryDoc1.[External] = 1 AND
										  PrimaryDoc1.PracticeID = 1) 
	LEFT JOIN dbo.Employers AS E ON 
	    E.EmployerID = (SELECT TOP 1 E2.EmployerID FROM dbo.Employers E2 WHERE 
								E2.EmployerName = LEFT(IPD.employername,128) AND 
								E2.AddressLine1 = LEFT(IPD.employeraddress1,256) AND 
								E2.State = LEFT(IPD.employerstate,2))
WHERE IPD.firstname <> '' AND IPD.lastname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SELECT COUNT(*) FROM dbo.[_import_1_1_PatientDemographics] WHERE firstname <> '' AND lastname <> ''
--27361

PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
INSERT INTO dbo.PatientJournalNote
( 
	CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , PatientID , UserName , SoftwareApplicationID , Hidden , 
	NoteMessage , AccountStatus , NoteTypeCode , LastNote
)
SELECT DISTINCT
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	PAT.PatientID , -- PatientID - int
	'Kareo' , -- UserName - varchar(128)
	'K' , -- SoftwareApplicationID - char(1)
	0 , -- Hidden - bit
	LEFT(IPD.patientnote,8000) , -- NoteMessage - varchar(max)
	0, -- AccountStatus - bit
	1 , -- NoteTypeCode - int
	0-- LastNote - bit
FROM dbo.[_import_1_1_PatientDemographics] AS IPD
	INNER JOIN dbo.Patient AS PAT ON 
		PAT.VendorID = IPD.chartnumber AND
	    PAT.VendorImportID = @VendorImportID
WHERE IPD.patientnote <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SELECT COUNT(*) FROM dbo.[_import_1_1_PatientDemographics] WHERE patientnote <> ''
--8318


PRINT ''
PRINT 'Inserting Into Patient Alert...'
INSERT INTO dbo.PatientAlert
( 
	PatientID ,AlertMessage ,ShowInPatientFlag ,ShowInAppointmentFlag ,ShowInEncounterFlag ,CreatedDate ,CreatedUserID ,ModifiedDate ,
	ModifiedUserID ,ShowInClaimFlag ,ShowInPaymentFlag ,ShowInPatientStatementFlag
)
SELECT DISTINCT
	PAT.PatientID , -- PatientID - int
	IPD.patientalertmessage , -- AlertMessage - text
	1, -- ShowInPatientFlag - bit
	1, -- ShowInAppointmentFlag - bit
	1, -- ShowInEncounterFlag - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	1, -- ShowInClaimFlag - bit
	1, -- ShowInPaymentFlag - bit
	1-- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_1_PatientDemographics]  AS IPD
	INNER JOIN dbo.Patient AS PAT ON 
		PAT.VendorID = IPD.chartnumber AND 
		PAT.VendorImportID = @VendorImportID
WHERE IPD.patientalertmessage <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SELECT COUNT(*) FROM dbo.[_import_1_1_PatientDemographics] WHERE [patientalertmessage] <> ''
--18


PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	PAT.PatientID , -- PatientID - int
	'Default Case'	, -- Name - varchar(128)
	1 , -- Active - bit
	5 , -- PayerScenarioID - int
	NULL , -- ReferringPhysicianID - int
	0 , -- EmploymentRelatedFlag - bit
	0, -- AutoAccidentRelatedFlag - bit
	0, -- OtherAccidentRelatedFlag - bit
	0, -- AbuseRelatedFlag - bit
	NULL , -- AutoAccidentRelatedState - char(2)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	0, -- ShowExpiredInsurancePolicies - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- PracticeID - int
	NULL , -- CaseNumber - varchar(128)
	NULL , -- WorkersCompContactInfoID - int
	PAT.VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.[_import_1_1_PatientDemographics] AS TP
	INNER JOIN dbo.Patient AS PAT ON VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into PatientCaseDate - Date Last Seen...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID
        )
SELECT DISTINCT  
          @PracticeID , -- PracticeID - int
          pc.PatientCaseID , -- PatientCaseID - int
          8 , -- PatientCaseDateTypeID - int
          i.datelastseen , -- StartDate - datetime
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientDemographics] i
	INNER JOIN dbo.Patient p ON p.VendorID = i.chartnumber AND p.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON pc.PatientID = p.PatientID AND pc.VendorImportID = @VendorImportID
WHERE ISDATE(i.datelastseen) = 1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 1...'
INSERT INTO dbo.InsurancePolicy
( 
	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate , CardOnFile , PatientRelationshipToInsured , 
	HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , HolderThroughEmployer , HolderEmployerName , 
	PatientInsuranceStatusID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity , 
	HolderState , HolderZipCode , HolderPhone , HolderPhoneExt , DependentPolicyNumber , Notes , Copay , Deductible , Active , PracticeID , VendorID , 
	VendorImportID , GroupName , ReleaseOfInformation
)
SELECT DISTINCT
	PC.PatientCaseID , -- PatientCaseID - int
	icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	1 , -- Precedence - int
	LEFT(i.policynumber1,32), -- PolicyNumber - varchar(32)
	LEFT(i.groupnumber1,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(i.policy1startdate) = 1 AND i.policy1startdate <> '1900-01-01' THEN i.policy1startdate ELSE NULL END,
	CASE WHEN ISDATE(i.policy1enddate) = 1 AND i.policy1enddate <> '1900-01-01' THEN i.policy1enddate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN i.patientrelationship1 IN ('C','Child') THEN 'C'
		WHEN i.patientrelationship1 IN ('O','Other') THEN 'O'
		WHEN i.patientrelationship1 IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1firstname,64) ELSE NULL END, -- HolderFirstName - varchar(64)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1middlename,64) ELSE NULL END, -- HolderMiddleName - varchar(64)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1lastname,64) ELSE NULL END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN CASE WHEN ISDATE(i.holder1dateofbirth) = 1 AND i.holder1dateofbirth <> '1/1/1900' THEN i.holder1dateofbirth ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN i.patientrelationship1 <> 'Self' THEN CASE WHEN LEN(i.holder1ssn)>= 6 THEN RIGHT('000' + i.holder1ssn, 9) ELSE NULL END ELSE NULL END, -- HolderSSN
	0 , -- HolderThroughEmployer - bit
	NULL , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN i.patientrelationship1 <> 'Self' THEN CASE WHEN i.holder1gender IN ('M','Male') THEN 'M' WHEN i.holder1gender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1street1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1street2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1city,128) END, -- HolderCity - varchar(128)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN UPPER(LEFT(i.holder1state,2)) END, -- HolderState
	CASE WHEN i.patientrelationship1 <> 'Self' THEN CASE 
		WHEN LEN(i.holder1zipcode) IN (5,9) THEN i.holder1zipcode
		WHEN LEN(i.holder1zipcode) = 4 THEN '0' + i.holder1zipcode
		ELSE '' END END, -- HolderZipCode - varchar(9)
	'', -- HolderPhone - varchar(10)
	'' , -- HolderPhoneExt - varchar(10)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.policynumber1, 32) ELSE NULL END , -- DependentPolicyNumber - varchar(32)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	i.policy1copay, -- Copay - money
	i.policy1deductible, -- Deductible - money
	1, -- Active - bit
	@PracticeID , -- PracticeID - int
	i.chartnumber , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_PatientDemographics] AS i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = i.insurancecode1 AND
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = i.chartnumber AND
		pc.VendorImportID = @VendorImportID
WHERE i.insurancecode1 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SELECT COUNT(*) FROM dbo.[_import_1_1_PatientDemographics] WHERE insurancecode1 <> ''
--24649

PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
( 
	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate , CardOnFile , PatientRelationshipToInsured , 
	HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , HolderThroughEmployer , HolderEmployerName , 
	PatientInsuranceStatusID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity , 
	HolderState , HolderZipCode , HolderPhone , HolderPhoneExt , DependentPolicyNumber , Notes , Copay , Deductible , Active , PracticeID , VendorID , 
	VendorImportID , GroupName , ReleaseOfInformation
)
SELECT DISTINCT
	PC.PatientCaseID , -- PatientCaseID - int
	icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	2 , -- Precedence - int
	LEFT(i.policynumber2,32), -- PolicyNumber - varchar(32)
	LEFT(i.groupnumber2,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(i.policy2startdate) = 1 AND i.policy2startdate <> '1900-01-01' THEN i.policy2startdate ELSE NULL END,
	CASE WHEN ISDATE(i.policy2enddate) = 1 AND i.policy2enddate <> '1900-01-01' THEN i.policy2enddate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN i.patientrelationship2 IN ('C','Child') THEN 'C'
		WHEN i.patientrelationship2 IN ('O','Other') THEN 'O'
		WHEN i.patientrelationship2 IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN i.patientrelationship2 <> 'Self' THEN LEFT(i.holder2firstname,64) ELSE NULL END, -- HolderFirstName - varchar(64)
	CASE WHEN i.patientrelationship2 <> 'Self' THEN LEFT(i.holder2middlename,64) ELSE NULL END, -- HolderMiddleName - varchar(64)
	CASE WHEN i.patientrelationship2 <> 'Self' THEN LEFT(i.holder2lastname,64) ELSE NULL END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN i.patientrelationship2 <> 'Self' THEN CASE WHEN ISDATE(i.holder2dateofbirth) = 1 AND i.holder2dateofbirth <> '1/1/1900' THEN i.holder2dateofbirth ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN i.patientrelationship2 <> 'Self' THEN CASE WHEN LEN(i.holder2ssn)>= 6 THEN RIGHT('000' + i.holder2ssn, 9) ELSE NULL END ELSE NULL END, -- HolderSSN
	0 , -- HolderThroughEmployer - bit
	NULL , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN i.patientrelationship2 <> 'Self' THEN CASE WHEN i.holder2gender IN ('M','Male') THEN 'M' WHEN i.holder2gender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN i.patientrelationship2 <> 'Self' THEN LEFT(i.holder2street1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN i.patientrelationship2 <> 'Self' THEN LEFT(i.holder2street2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN i.patientrelationship2 <> 'Self' THEN LEFT(i.holder2city,128) END, -- HolderCity - varchar(128)
	CASE WHEN i.patientrelationship2 <> 'Self' THEN UPPER(LEFT(i.holder2state,2)) END, -- HolderState
	CASE WHEN i.patientrelationship2 <> 'Self' THEN CASE 
		WHEN LEN(i.holder2zipcode) IN (5,9) THEN i.holder2zipcode
		WHEN LEN(i.holder2zipcode) = 4 THEN '0' + i.holder2zipcode
		ELSE '' END END, -- HolderZipCode - varchar(9)
	'', -- HolderPhone - varchar(10)
	'' , -- HolderPhoneExt - varchar(10)
	CASE WHEN i.patientrelationship2 <> 'Self' THEN LEFT(i.policynumber2, 32) ELSE NULL END , -- DependentPolicyNumber - varchar(32)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	i.policy2copay, -- Copay - money
	i.policy2deductible, -- Deductible - money
	1, -- Active - bit
	@PracticeID , -- PracticeID - int
	i.chartnumber , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_PatientDemographics] AS i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = i.insurancecode2 AND
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = i.chartnumber AND
		pc.VendorImportID = @VendorImportID
WHERE i.insurancecode2 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SELECT COUNT(*) FROM dbo.[_import_1_1_PatientDemographics] where insurancecode2 <> ''
--8807



PRINT ''
PRINT 'Inserting Into Insurance Policy 3...'
INSERT INTO dbo.InsurancePolicy
( 
	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate , CardOnFile , PatientRelationshipToInsured , 
	HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , HolderThroughEmployer , HolderEmployerName , 
	PatientInsuranceStatusID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity , 
	HolderState , HolderZipCode , HolderPhone , HolderPhoneExt , DependentPolicyNumber , Notes , Copay , Deductible , Active , PracticeID , VendorID , 
	VendorImportID , GroupName , ReleaseOfInformation
)
SELECT DISTINCT
	PC.PatientCaseID , -- PatientCaseID - int
	icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	3 , -- Precedence - int
	LEFT(i.policynumber3,32), -- PolicyNumber - varchar(32)
	LEFT(i.groupnumber3,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(i.policy3startdate) = 1 AND i.policy3startdate <> '1900-01-01' THEN i.policy3startdate ELSE NULL END,
	CASE WHEN ISDATE(i.policy3enddate) = 1 AND i.policy3enddate <> '1900-01-01' THEN i.policy3enddate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN i.patientrelationship3 IN ('C','Child') THEN 'C'
		WHEN i.patientrelationship3 IN ('O','Other') THEN 'O'
		WHEN i.patientrelationship3 IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN i.patientrelationship3 <> 'Self' THEN LEFT(i.holder3firstname,64) ELSE NULL END, -- HolderFirstName - varchar(64)
	CASE WHEN i.patientrelationship3 <> 'Self' THEN LEFT(i.holder3middlename,64) ELSE NULL END, -- HolderMiddleName - varchar(64)
	CASE WHEN i.patientrelationship3 <> 'Self' THEN LEFT(i.holder3lastname,64) ELSE NULL END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN i.patientrelationship3 <> 'Self' THEN CASE WHEN ISDATE(i.holder3dateofbirth) = 1 AND i.holder3dateofbirth <> '1/1/1900' THEN i.holder3dateofbirth ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN i.patientrelationship3 <> 'Self' THEN CASE WHEN LEN(i.holder3ssn)>= 6 THEN RIGHT('000' + i.holder3ssn, 9) ELSE NULL END ELSE NULL END, -- HolderSSN
	0 , -- HolderThroughEmployer - bit
	NULL , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN i.patientrelationship3 <> 'Self' THEN CASE WHEN i.holder3gender IN ('M','Male') THEN 'M' WHEN i.holder3gender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN i.patientrelationship3 <> 'Self' THEN LEFT(i.holder3street1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN i.patientrelationship3 <> 'Self' THEN LEFT(i.holder3street2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN i.patientrelationship3 <> 'Self' THEN LEFT(i.holder3city,128) END, -- HolderCity - varchar(128)
	CASE WHEN i.patientrelationship3 <> 'Self' THEN UPPER(LEFT(i.holder3state,2)) END, -- HolderState
	CASE WHEN i.patientrelationship3 <> 'Self' THEN CASE 
		WHEN LEN(i.holder3zipcode) IN (5,9) THEN i.holder3zipcode
		WHEN LEN(i.holder3zipcode) = 4 THEN '0' + i.holder3zipcode
		ELSE '' END END, -- HolderZipCode - varchar(9)
	'', -- HolderPhone - varchar(10)
	'' , -- HolderPhoneExt - varchar(10)
	CASE WHEN i.patientrelationship3 <> 'Self' THEN LEFT(i.policynumber3, 32) ELSE NULL END , -- DependentPolicyNumber - varchar(32)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	i.policy3copay, -- Copay - money
	i.policy3deductible, -- Deductible - money
	1, -- Active - bit
	@PracticeID , -- PracticeID - int
	i.chartnumber , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_PatientDemographics] AS i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = i.insurancecode3 AND
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = i.chartnumber AND
		pc.VendorImportID = @VendorImportID
WHERE i.insurancecode3 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SELECT COUNT(*) FROM dbo.[_import_1_1_PatientDemographics] WHERE insurancecode3 <> ''
--85

PRINT ''
PRINT 'Inserting Into StandardFeeSchedule...'
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
          'Default contract' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          GETDATE() , -- EffectiveStartDate - datetime
          'f' , -- SourceType - char(1)
          'Import file' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
        )
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into StandardFee...'
	INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
	SELECT
	      c.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          pm.ProcedureModifierID , -- ModifierID - int
          impSFS.standardFee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
	FROM dbo.[_import_1_1_StandardFeeSchedule] impSFS
	INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule c ON
		CAST(c.Notes AS VARCHAR) = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) AND
		c.practiceID = @PracticeID
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON
		impSFS.cpt = pcd.ProcedureCode
	LEFT JOIN dbo.ProcedureModifier pm ON
		impSFS.Modifier = pm.ProcedureModifierCode
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SELECT COUNT(*) FROM dbo.[_import_1_1_StandardFeeSchedule] WHERE cpt <> ''
--286



PRINT ''
PRINT 'Inserting Into StandardFeeScheduleLink...'
	INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
	SELECT
	      doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
	FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs 
	WHERE doc.PracticeID = @PracticeID AND
		doc.[External] = 0 AND 
		sl.PracticeID = @PracticeID AND
		CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
		sfs.PracticeID = @PracticeID 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into ContractRateSchedule... '
	INSERT INTO dbo.ContractsAndFees_ContractRateSchedule
        ( PracticeID ,
          InsuranceCompanyID ,
          EffectiveStartDate ,
          EffectiveEndDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID ,
          AddPercent ,
          AnesthesiaTimeIncrement ,
          Capitated
        )
	SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          ICP.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- EffectiveStartDate - datetime
          DATEADD(dd, -1, DATEADD(yy, 1, GETDATE())) , -- EffectiveEndDate - datetime
          'f' , -- SourceType - char(1)
          'Import file' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15 , -- AnesthesiaTimeIncrement - int
          0  -- Capitated - bit
	FROM dbo.[_import_1_1_InsuranceSpecificFeeSchedule] impCRS
	INNER JOIN dbo.[InsuranceCompanyPLan] ICP ON
		ICP.InsuranceCompanyPlanID = (SELECT TOP 1 InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan ICP2 
										WHERE ICP2.PlanName = impCRS.insuranceplan 
											  AND ICP2.VendorID = impCRS.insurancecodeuniqueidentifier)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into ContractRate...'
	INSERT INTO dbo.ContractsAndFees_ContractRate
        ( ContractRateScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
	SELECT  
		  crs.ContractRateScheduleID , -- ContractRateScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          pm.ProcedureModifierID , -- ModifierID - int
          impIFS.standardfee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
	FROM dbo.ContractsAndFees_ContractRateSchedule crs
	INNER JOIN dbo.[_import_1_1_InsuranceSpecificFeeSchedule] impIFS ON
		crs.InsuranceCompanyID = (SELECT  InsuranceCompanyID FROM dbo.InsuranceCompanyPlan
								WHERE PlanName = impIFS.[insuranceplan]
								 AND VendorID = impIFS.insurancecodeuniqueidentifier)
	INNER JOIN dbo.[ProcedureCodeDictionary] pcd ON
		impIFS.[cpt] = pcd.ProcedureCode 
	LEFT JOIN dbo.ProcedureModifier pm ON
		impIFS.Modifier = pm.ProcedureModifierCode
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--SELECT COUNT(*) FROM dbo.[_import_1_1_InsuranceSpecificFeeSchedule] WHERE cpt <> ''
--8533

PRINT ''
PRINT 'Inserting Into ContractRateSchedule...'
	INSERT INTO dbo.ContractsAndFees_ContractRateScheduleLink
        ( ProviderID ,
          LocationID ,
          ContractRateScheduleID
        )
	SELECT 
		  doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          crs.ContractRateScheduleId  -- ContractRateScheduleID - int
	FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_ContractRateSchedule crs
	WHERE doc.PracticeID = @PracticeID AND
		doc.[External] = 0 AND 
		sl.PracticeID = @PracticeID AND
	crs.InsuranceCompanyId IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE ReviewCode = 'R'
								OR CreatedPracticeID = @PracticeID) AND
		crs.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET Name = 'Self Pay' ,
			PayerScenarioID = 11
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
			  pc.PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--ROLLBACK
--COMMIT