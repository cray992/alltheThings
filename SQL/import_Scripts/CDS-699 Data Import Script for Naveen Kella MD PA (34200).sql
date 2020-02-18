USE superbill_34200_dev
--USE superbill_34200_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Deleting Duplicate Patients from Import File...'
DELETE FROM dbo.[_import_2_1_PatientDemographics] WHERE chartnumber IN (SELECT MedicalRecordNumber FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = 1 AND MedicalRecordNumber <> '')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'


/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [Existing IC]
==========================================================================================================================================
*/	

CREATE TABLE #tempins (InsID INT)
INSERT INTO #tempins  (InsID)
SELECT DISTINCT insuranceid  -- InsID - int
FROM dbo.[_import_2_1_InsuranceCOMPANYPLANList] ic
INNER JOIN dbo.[_import_2_1_PatientDemographics] ip ON
	ic.insuranceid = ip.insurancecode1
WHERE insuranceid <> ''

INSERT INTO #tempins  (InsID)
SELECT DISTINCT insuranceid  -- InsID - int
FROM dbo.[_import_2_1_InsuranceCOMPANYPLANList] ic
INNER JOIN dbo.[_import_2_1_PatientDemographics] ip ON
	ic.insuranceid = ip.insurancecode2
WHERE NOT EXISTS (SELECT * FROM #tempins i WHERE ip.insurancecode2 = i.InsID) AND insuranceid <> '' 

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(ICP.planname,128)
		 ELSE ICP.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(ICP.Address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.Address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Phone),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.PhoneExt),10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Fax), 10) , -- Fax - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.FaxExt), 10) , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo._import_2_1_InsuranceCOMPANYPLANList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.InsuranceCompanyName = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
INNER JOIN dbo.#tempins i ON 
	ICP.insuranceid = i.InsID
WHERE ICP.insuranceid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
/*
==========================================================================================================================================
CREATE INSURANCE COMPANIES FROM [_import_2_1_InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,128)  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	CASE scope WHEN 1 THEN 'R' ELSE '' END , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	13 , -- SecondaryPrecedenceBillingFormID - int
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,50) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_2_1_InsuranceCOMPANYPLANList AS IICL
INNER JOIN dbo.#tempins i ON 
	IICL.insuranceid = i.InsID
WHERE ( insurancecompanyname <> '' OR planname <> '') AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.InsuranceCompanyName AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
AND iicl.insuranceid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'															 

/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(ICP.planname,128)
		 ELSE ICP.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(ICP.Address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.Address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Phone),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.PhoneExt),10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Fax), 10) , -- Fax - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.FaxExt), 10) , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@VendorImportID -- VendorImportID - int
FROM dbo._import_2_1_InsuranceCOMPANYPLANList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.InsuranceCompanyName, 50) AND
	ICP.Insurancecompanyname = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
INNER JOIN dbo.#tempins i ON 
	ICP.insuranceid = i.InsID
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.Insuranceid = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL AND 
	  icp.insuranceid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

/*
==========================================================================================================================================
CREATE REFERRING DOCTORS FROM [PATIENTDEMOGRAPHICS]
==========================================================================================================================================
*/	

--PRINT ''
--PRINT 'Inserting Into Doctor...'
--INSERT INTO dbo.Doctor
--( 
--	PracticeID , Prefix, Suffix, FirstName , MiddleName , LastName , SSN , AddressLine1 , AddressLine2 , City , State , Zipcode,  Country , HomePhone , HomePhoneExt , 
--	WorkPhone , WorkPhoneExt , MobilePhone , MobilePhoneExt , DOB , EmailAddress , Notes , ActiveDoctor , CreatedDate , CreatedUserID , ModifiedDate , 
--	ModifiedUserID , UserID , Degree , TaxonomyCode , VendorID , VendorImportID , FaxNumber , FaxNumberExt , [External] , NPI 
--)
--SELECT DISTINCT
--	@PracticeID , -- PracticeID - int
--	'', -- Prefix
--	'', -- Suffix
--	LEFT(PD.referringphysicianfirstname,64) , -- FirstName - varchar(64)
--	'' , -- MiddleName - varchar(64)
--	LEFT(PD.referringphysicianlastname,64) , -- LastName - varchar(64)
--	NULL, -- SSN - varchar(9)
--	'' , -- AddressLine1 - varchar(256)
--	'' , -- AddressLine2 - varchar(256)
--	'' , -- City - varchar(128)
--	'' , -- State - varchar(2)
--	'' , -- ZipCode - varchar(9)
--	'' , -- Country - varchar(32)
--	'', -- HomePhone - varchar(10)
--	'' , -- HomePhoneExt - varchar(10)
--	'' , -- WorkPhone - varchar(10)
--	'' , -- WorkPhoneExt - varchar(10)
--	'' , -- MobilePhone - varchar(10)
--	'' , -- MobilePhoneExt - varchar(10)
--	NULL , -- DOB - datetime
--	'' , -- EmailAddress - varchar(256)
--	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
--	1 , -- ActiveDoctor - bit
--	GETDATE() , -- CreatedDate - datetime
--	0 , -- CreatedUserID - int
--	GETDATE() , -- ModifiedDate - datetime
--	0 , -- ModifiedUserID - int
--	0 , -- UserID - int
--	'' , -- Degree - varchar(8)
--	NULL , -- TaxonomyCode - char(10)
--	LEFT(PD.referringphysicianfirstname + PD.referringphysicianlastname, 50) , -- VendorID - varchar(50)
--	@VendorImportID , -- VendorImportID - int
--	'' , -- FaxNumber - varchar(10)
--	'' , -- FaxNumberExt - varchar(10)
--	1, -- External - bit
--	'' -- NPI - varchar(10)
--FROM dbo._import_2_1_PatientDemographics AS PD
--LEFT JOIN dbo.Doctor AS D ON D.FirstName = PD.referringphysicianfirstname
--		AND D.LastName = PD.referringphysicianlastname
--		AND D.PracticeID = @PracticeID
--		AND D.ActiveDoctor = 1
--WHERE D.DoctorID IS NULL
--	AND PD.referringphysicianfirstname <> ''
--	AND PD.referringphysicianlastname <> ''
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

/*
==========================================================================================================================================
CREATE DOCTORS FROM [PATIENTDEMOGRAPHICS]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
( 
	PracticeID , Prefix, Suffix, FirstName , MiddleName , LastName , SSN , AddressLine1 , AddressLine2 , City , State , Zipcode,  Country , HomePhone , HomePhoneExt , 
	WorkPhone , WorkPhoneExt , MobilePhone , MobilePhoneExt , DOB , EmailAddress , Notes , ActiveDoctor , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , UserID , Degree , TaxonomyCode , VendorID , VendorImportID , FaxNumber , FaxNumberExt , [External] , NPI 
)
SELECT DISTINCT
	@PracticeID , -- PracticeID - int
	'', -- Prefix
	'', -- Suffix
	LEFT(PD.PrimaryCarePhysicianfirstname,64) , -- FirstName - varchar(64)
	'' , -- MiddleName - varchar(64)
	LEFT(PD.PrimaryCarePhysicianlastname,64) , -- LastName - varchar(64)
	NULL, -- SSN - varchar(9)
	'' , -- AddressLine1 - varchar(256)
	'' , -- AddressLine2 - varchar(256)
	'' , -- City - varchar(128)
	'' , -- State - varchar(2)
	'' , -- ZipCode - varchar(9)
	'' , -- Country - varchar(32)
	'', -- HomePhone - varchar(10)
	'' , -- HomePhoneExt - varchar(10)
	'' , -- WorkPhone - varchar(10)
	'' , -- WorkPhoneExt - varchar(10)
	'' , -- MobilePhone - varchar(10)
	'' , -- MobilePhoneExt - varchar(10)
	NULL , -- DOB - datetime
	'' , -- EmailAddress - varchar(256)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	1 , -- ActiveDoctor - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	0 , -- UserID - int
	'' , -- Degree - varchar(8)
	NULL , -- TaxonomyCode - char(10)
	LEFT(PD.PrimaryCarePhysicianfirstname + PD.PrimaryCarePhysicianlastname, 50) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	'' , -- FaxNumber - varchar(10)
	'' , -- FaxNumberExt - varchar(10)
	1, -- External - bit
	'' -- NPI - varchar(10)
FROM dbo._import_2_1_PatientDemographics AS PD
LEFT JOIN dbo.Doctor AS D ON D.FirstName = PD.PrimaryCarePhysicianFirstName
		AND D.LastName = PD.PrimaryCarePhysicianLastName
		AND D.PracticeID = @PracticeID
		AND D.ActiveDoctor = 1
WHERE D.DoctorID IS NULL
	AND PD.PrimaryCarePhysicianfirstname <> ''
	AND PD.PrimaryCarePhysicianlastname <> ''
	AND NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE pd.PrimaryCarePhysicianfirstname = d.FirstName AND PrimaryCarePhysicianlastname = d.LastName AND d.PracticeID  = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


/*
==========================================================================================================================================
CREATE PATIENTS
==========================================================================================================================================
*/	



DECLARE @DefaultCollectionCategory INT
SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)
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
	ReferringDoc.DoctorID , -- ReferringPhysicianID - int
	'' , -- Prefix 
	LEFT(PD.suffix, 16) , -- Suffix
	LEFT(PD.firstname,64) , -- FirstName - varchar(64)
	LEFT(PD.middleinitial,64) , -- MiddleName - varchar(64)
	LEFT(PD.lastname,64) , -- LastName - varchar(64)
	LEFT(PD.address1,256) , -- AddressLine1 - varchar(256)
	LEFT(PD.address2,256) , -- AddressLine2 - varchar(256)
	LEFT(PD.city,128) , -- City - varchar(128)
	UPPER(LEFT(PD.state,2)) , -- State - varchar(2)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(PD.zipcode)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(PD.zipcode)
		ELSE '' END , -- ZipCode - varchar(9)
	CASE
		WHEN PD.gender IN ('M','Male') THEN 'M'
		WHEN PD.gender IN ('F','Female') THEN 'F'
		ELSE 'U' END , -- Gender - varchar(1)
	CASE 
		WHEN PD.maritalstatus IN ('D','Divorced') THEN 'D'
		WHEN PD.maritalstatus IN ('M','Married') THEN 'M'
		WHEN PD.maritalstatus IN ('S','Single') THEN 'S'
		WHEN PD.maritalstatus IN ('W','Widowed') THEN 'W'
		ELSE '' END , -- MaritalStatus - varchar(1)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.homephone),10)
		ELSE '' END, -- HomePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone))),10)
		ELSE NULL END , -- HomePhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.workphone),10)
		ELSE '' END , -- WorkPhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.workphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone))),10)
		ELSE NULL END , -- WorkPhoneExt - varchar(10)
	CASE
		WHEN ISDATE(PD.dateofbirth) = 1 THEN PD.dateofbirth
		ELSE NULL END , -- DOB - datetime
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.SSN)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(PD.SSN), 9)
		ELSE NULL END , -- SSN - char(9)
	LEFT(PD.email,256) , -- EmailAddress - varchar(256)
	CASE WHEN PD.responsiblepartyrelationship  <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
	'' , -- ResponsiblePrefix - varchar(16)
	LEFT(PD.responsiblepartyfirstname, 64) , -- ResponsibleFirstName - varchar(64)
	LEFT(PD.responsiblepartymiddlename, 64) , -- ResponsibleMiddleName - varchar(64)
	LEFT(PD.responsiblepartylastname, 64) , -- ResposibleLastName - varchar(64)
	LEFT(PD.responsiblepartysuffix, 16) , -- ResponsibleSuffix - varchar(16)
	CASE WHEN PD.responsiblepartyrelationship IN ('C','Child') THEN 'C'
         WHEN PD.responsiblepartyrelationship IN ('U','Spouse') THEN 'U'
         WHEN PD.responsiblepartyrelationship IN ('O','Other') THEN 'O'
	ELSE NULL END , -- ResponsibleRelationshipToPatient (char)
	LEFT(PD.responsiblepartyaddress1, 256) , -- ResponsibleAddressLine1 - varchar(256)
	LEFT(PD.responsiblepartyaddress2, 256) , -- ResponsibleAddressLine2 - varchar(256)
	LEFT(PD.responsiblepartycity, 128) , -- ResponsibleCity - varchar(128) 
	LEFT(PD.responsiblepartystate, 2) , -- ResponsibleState - varchar(2)
	LEFT(REPLACE(PD.responsiblepartyzipcode, '-',''), 9) , -- ResponsibleZipCode - varchar(9)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	CASE
		WHEN PD.employmentstatus IN ('E','Employed') THEN 'E'
		WHEN PD.employmentstatus IN ('R','Retired') THEN 'R'
		WHEN PD.employmentstatus IN ('S','Student, Full-Time') THEN 'S'
		WHEN PD.employmentstatus IN ('T','Student, Part-Time') THEN 'T'
		ELSE 'U' END, -- EmploymentStatus - char(1)
	PrimaryProvider.DoctorID , -- PrimaryProviderID - int 
	CASE WHEN SL.ServiceLocationID IS NOT NULL THEN SL.ServiceLocationID
		ELSE SL2.ServiceLocationID END , -- DefaultServiceLocationID - int 
	E.EmployerID, -- EmployerID - int 
	LEFT(PD.chartnumber,128) , -- MedicalRecordNumber - varchar(128)
	CASE
		WHEN LEN(PD.cellphone) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.cellphone),10)
		ELSE '' END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.cellphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.cellphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.cellphone))),10)
		ELSE NULL END , -- MobilePhoneExt - varchar(10)
	PrimaryCare.DoctorID , -- PrimaryCarePhysicianID - int 
	PD.ChartNumber , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	@DefaultCollectionCategory , -- CollectionCategoryID - int
	CASE 
		WHEN PD.Active IN ('0','No','N','Inactive') THEN 0
		ELSE 1 END, -- Active - bit
	1, -- SendEmailCorrespondence - bit
	0,  -- PhonecallRemindersEnabled - bit
	LEFT(PD.EmergencyName,128) , -- EmergencyName - varchar(128)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphone),10)
		ELSE '' END , -- EmergencyPhone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphoneext),10) -- EmergencyPhoneExt - varchar(10)
FROM dbo._import_2_1_PatientDemographics AS PD
	LEFT JOIN dbo.Doctor AS ReferringDoc ON 
			ReferringDoc.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS RD WHERE RD.FirstName = PD.ReferringPhysicianFirstName AND 
											RD.LastName = PD.ReferringPhysicianLastName AND RD.PracticeID = @PracticeID AND RD.ActiveDoctor = 1)
	LEFT JOIN dbo.Doctor AS PrimaryProvider ON 
			PrimaryProvider.FirstName = PD.PrimaryProviderFirstName AND 
			PrimaryProvider.LastName = PD.PrimaryProviderLastName AND 
			PrimaryProvider.[External] = 0 AND 
			PrimaryProvider.PracticeID = @PracticeID AND
			PrimaryProvider.ActiveDoctor = 1
	LEFT JOIN dbo.Doctor AS PrimaryCare ON 
		PrimaryCare.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS PC WHERE PC.FirstName = PD.primarycarephysicianfirstname AND 
									PC.LastName = PD.Primarycarephysicianlastname AND PC.PracticeID = @PracticeID AND PC.ActiveDoctor = 1)
	LEFT JOIN dbo.ServiceLocation AS SL ON SL.Name = PD.defaultservicelocation
	LEFT JOIN dbo.ServiceLocation AS SL2 ON 1 = 1 AND SL2.ServiceLocationID = (SELECT TOP 1 ServiceLocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID) 
	LEFT JOIN dbo.Employers AS E ON E.EmployerID = (SELECT TOP 1 E2.EmployerID FROM dbo.Employers E2 WHERE E2.EmployerName = LEFT(PD.employername,128) AND E2.AddressLine1 = LEFT(PD.employeraddress1,256) AND E2.State = LEFT(PD.employerstate,2))
WHERE PD.firstname <> '' AND PD.lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

/*
==========================================================================================================================================
CREATE PATIENT CASES
==========================================================================================================================================
*/	

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
	CASE WHEN pd.DefaultCase = '' THEN 'Default Case' 
		ELSE LEFT(pd.DefaultCase, 128) END , -- Name - varchar(128)
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
FROM dbo._import_2_1_PatientDemographics pd
	JOIN dbo.Patient AS PAT ON VendorImportID = @VendorImportID AND VendorID = pd.chartnumber
WHERE 
	pd.DefaultCase NOT IN (SELECT Name FROM dbo.PatientCase WHERE PatientID = PAT.PatientID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

/*
==========================================================================================================================================
TEMP TABLE FOR INSERTING CASES AND POLICIES
==========================================================================================================================================
*/	

CREATE TABLE #tempPolicies
(
	InsuranceColumnCount INT,
	PatientVendorID VARCHAR(128),
	InsuranceCode VARCHAR(128),
	PolicyNumber VARCHAR(32), 
	GroupNumber VARCHAR(32), 
	PolicyStartDate DATETIME, 
	PolicyEndDate DATETIME, 
	Copay MONEY,
	Deductible INT,
	PatientRelationshipToInsured VARCHAR(MAX), 
	HolderLastName VARCHAR(64), 
	HolderMiddleName VARCHAR(64),
	HolderFirstName VARCHAR(64), 
	HolderStreet1 VARCHAR(256), 
	HolderStreet2 VARCHAR(256), 
	HolderCity VARCHAR(128), 
	HolderState VARCHAR(2), 
	HolderZipCode VARCHAR(9), 
	HolderSSN VARCHAR(9), 
	HolderDOB DATETIME, 
	HolderGender CHAR(1),
	HolderPolicyNumber VARCHAR(32),
	Employer VARCHAR(128),
	PolicyNote VARCHAR(8000)
)


INSERT INTO #tempPolicies
( 
	InsuranceColumnCount , PatientVendorID , InsuranceCode, PolicyNumber , GroupNumber , PolicyStartDate , 
	PolicyEndDate , Copay, Deductible, PatientRelationshipToInsured, HolderLastName , HolderMiddleName , 
	HolderFirstName , HolderStreet1 , HolderStreet2 , HolderCity , HolderState , HolderZipCode , HolderSSN , 
	HolderDOB , HolderGender , HolderPolicyNumber, Employer, PolicyNote
)
SELECT DISTINCT
	InsuranceColumnCount,
	PatientVendorID,
	InsuranceCode, 
	LEFT(PolicyNumber, 32),
	LEFT(GroupNumber, 32),
	PolicyStartDate, 
	PolicyEndDate, 
	Copay,
	Deductible,
	PatientRelationshipToInsured,
	LEFT(HolderLastName, 64),
	LEFT(HolderMiddleName, 64),
	LEFT(HolderFirstName, 64),
	LEFT(HolderStreet1, 256),
	LEFT(HolderStreet2, 256),
	LEFT(HolderCity, 128),
	LEFT(HolderState, 2),
	LEFT(HolderZipCode, 9),
	LEFT(HolderSSN, 9),
	HolderDOB, 
	LEFT(HolderGender, 1),
	HolderPolicyNumber,
	Employer,
	PolicyNote
FROM
(	SELECT DISTINCT 
		1 AS InsuranceColumnCount, ChartNumber AS PatientVendorID, InsuranceCode1 AS InsuranceCode, 
		policynumber1 AS PolicyNumber, groupnumber1 AS GroupNumber, CASE WHEN ISDATE(policy1startdate) = 1 
		THEN policy1startdate ELSE NULL END AS PolicyStartDate, CASE WHEN ISDATE(policy1enddate) = 1 THEN policy1enddate 
		ELSE NULL END AS PolicyEndDate, policy1copay AS Copay, policy1deductible AS Deductible,  patientrelationship1 AS 
		PatientRelationshipToInsured, holder1lastname AS HolderLastName, Holder1middlename AS HolderMiddleName, 
		Holder1firstname AS HolderFirstName, Holder1street1 AS HolderStreet1, holder1street2 AS HolderStreet2, 
		holder1city AS HolderCity, holder1state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder1zipcode) AS 
		HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder1ssn) AS holderSSN, CASE WHEN 
		ISDATE(Holder1dateofbirth) = 1 THEN Holder1dateofbirth ELSE NULL END AS HolderDOB, CASE WHEN Holder1gender IN 
		('M','Male') THEN 'M' WHEN Holder1gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		holder1PolicyNumber AS HolderPolicyNumber, Employer1 AS Employer, Policy1Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE insurancecode1 <> ''
	
	UNION
  	
	SELECT DISTINCT 
		2 AS InsuranceColumnCount, ChartNumber AS PatientVendorID, InsuranceCode2 AS InsuranceCode, 
		policynumber2 AS PolicyNumber, groupnumber2 AS GroupNumber, CASE WHEN ISDATE(policy2startdate) = 1 
		THEN policy2startdate ELSE NULL END AS PolicyStartDate, CASE WHEN ISDATE(policy2enddate) = 1 THEN policy2enddate 
		ELSE NULL END AS PolicyEndDate, policy2copay AS Copay, policy2deductible AS Deductible,  patientrelationship2 AS
		PatientRelationshipToInsured, holder2lastname AS HolderLastName, Holder2middlename AS HolderMiddleName, 
		Holder2firstname AS HolderFirstName, Holder2street1 AS HolderStreet1, holder2street2 AS HolderStreet2, 
		holder2city AS HolderCity, holder2state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder2zipcode) 
		AS HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder2ssn) AS holderSSN, CASE WHEN 
		ISDATE(Holder2dateofbirth) = 1 THEN Holder2dateofbirth ELSE NULL END AS HolderDOB, CASE WHEN Holder2gender IN 
		('M','Male') THEN 'M' WHEN Holder2gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		holder2PolicyNumber AS HolderPolicyNumber, Employer2 AS Employer, Policy2Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE insurancecode2 <> ''  
	
	UNION
  	
	SELECT DISTINCT 
		3 AS InsuranceColumnCount, ChartNumber AS PatientVendorID, InsuranceCode3 AS InsuranceCode, 
		policynumber3 AS PolicyNumber, groupnumber3 AS GroupNumber, CASE WHEN ISDATE(policy3startdate) = 1 
		THEN policy3startdate ELSE NULL END AS PolicyStartDate, CASE WHEN ISDATE(policy3enddate) = 1 THEN policy3enddate 
		ELSE NULL END AS PolicyEndDate, policy3copay AS Copay, policy3deductible AS Deductible,  patientrelationship3 AS
		PatientRelationshipToInsured, holder3lastname AS HolderLastName, Holder3middlename AS HolderMiddleName, 
		Holder3firstname AS HolderFirstName, Holder3street1 AS HolderStreet1, holder3street2 AS HolderStreet2, 
		holder3city AS HolderCity, holder3state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder3zipcode) 
		AS HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder3ssn) AS holderSSN, CASE WHEN 
		ISDATE(Holder3dateofbirth) = 1 THEN Holder3dateofbirth ELSE NULL END AS HolderDOB, CASE WHEN Holder3gender IN 
		('M','Male') THEN 'M' WHEN Holder3gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		holder3PolicyNumber AS HolderPolicyNumber, Employer3 AS Employer, Policy3Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE  insurancecode3 <> ''  
) AS Y
ORDER BY InsuranceColumnCount



/*
==========================================================================================================================================
CREATE INSURANCE POLICIES  
==========================================================================================================================================
*/
PRINT ''
PRINT 'Inserting Into Insurance Policy...'
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
	ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	TP.InsuranceColumnCount , -- case - int
	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
		WHEN PatientRelationshipToInsured IN ('C','Child') THEN 'C'
		WHEN PatientRelationshipToInsured IN ('O','Other') THEN 'O'
		WHEN PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(HolderDOB) = 1 AND HolderDOB <> '1/1/1900' THEN HolderDOB ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(HolderSSN) = 9 THEN HolderSSN ELSE NULL END END, -- HolderSSN
	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN HolderGender IN ('M','Male') THEN 'M' WHEN HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(HolderCity,128) END, -- HolderCity - varchar(128)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(HolderState,2)) END, -- HolderState
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
		WHEN LEN(HolderZipCode) IN (5,9) THEN HolderZipCode
		WHEN LEN(HolderZipCode) = 4 THEN '0' + HolderZipCode
		ELSE '' END END, -- HolderZipCode - varchar(9)
	'', -- HolderPhone - varchar(10)
	'' , -- HolderPhoneExt - varchar(10)
	LEFT(TP.PolicyNumber, 32) , -- DependentPolicyNumber - varchar(32)
    TP.PolicyNote + CHAR(13) + CHAR(10) + CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	TP.Copay, -- Copay - money
	TP.Deductible, -- Deductible - money
	1, -- Active - bit
	@PracticeID , -- PracticeID - int
	PAT.VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM #tempPolicies AS TP
	JOIN dbo.Patient AS PAT ON VendorImportID = @VendorImportID AND VendorID = PatientVendorID
	JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID = @VendorImportID
	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Appointment - P...'
	INSERT INTO dbo.Appointment
	        ( PatientID ,
	          PracticeID ,
	          ServiceLocationID ,
	          StartDate ,
	          EndDate ,
	          AppointmentType ,
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
	          EndTm ,
			  [Subject]
	        )
	SELECT  DISTINCT  PAT.PatientID , -- PatientID - int
	          @PracticeID , -- PracticeID - int
	          CASE WHEN SL.ServiceLocationID IS NULL THEN SL2.ServiceLocationID ELSE SL.ServiceLocationID END , -- ServiceLocationID - int
	          PA.StartDate , -- StartDate - datetime
	          PA.EndDate , -- EndDate - datetime
	          'P' , -- AppointmentType - varchar(1)
	          PA.Note , -- Notes - text
	          GETDATE() , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          1 , -- AppointmentResourceTypeID - int
	           CASE WHEN PA.[STATUS] IN ('C','Confirmed') THEN 'C' 
					WHEN PA.[STATUS] IN ('E','Seen') THEN 'E'
					WHEN PA.[STATUS] IN ('I','Check-in') THEN 'I'
					WHEN PA.[STATUS] IN ('N','No-show') THEN 'N'
					WHEN PA.[STATUS] IN ('O','Check-out') THEN 'O' 
					WHEN PA.[STATUS] IN ('R','Rescheduled') THEN 'R'
					WHEN PA.[STATUS] IN ('S','Scheduled') THEN 'S'
					WHEN PA.[STATUS] IN ('X','Cancelled') THEN 'X'
					ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
	          PC.PatientCaseID , -- PatientCaseID - int
	          DK.DKPracticeID , -- StartDKPracticeID - int
	          DK.DKPracticeID , -- EndDKPracticeID - int
			  CAST(REPLACE(RIGHT(PA.StartDate,5), ':','') AS SMALLINT)   , -- StartTm - smallint
	          CAST(REPLACE(RIGHT(PA.EndDate,5),  ':', '') AS SMALLINT) ,
			  PA.elationapptid
			  FROM dbo._import_2_1_PatientAppointments PA
	INNER JOIN dbo.Patient PAT ON 
		PA.ChartNumber = PAT.MedicalRecordNumber AND
		PAT.PracticeID = @PracticeID 
	LEFT JOIN dbo.PatientCase PC ON 
		PC.PatientID = PAT.PatientID AND
		PC.PracticeID = @PracticeID  AND
		pc.PatientCaseID = (SELECT pc.PatientCaseID FROM dbo.InsurancePolicy ip WHERE pc.PatientCaseID = ip.PatientCaseID AND ip.SyncWithEHR = 1)
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(PA.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation SL ON
		SL.NAME = PA.ServiceLocationName AND
		SL.PracticeID = @PracticeID  
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
	LEFT JOIN dbo.Appointment a ON 
		a.StartDate = CAST(PA.startdate AS DATETIME) AND 
		a.EndDate = CAST(PA.enddate AS DATETIME) AND 
		a.PatientID = pat.PatientID
WHERE a.AppointmentID IS NULL AND PA.elationapptid <> '' AND PAT.MedicalRecordNumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into AppointmentReason...'
	INSERT INTO dbo.AppointmentReason
			( PracticeID ,
			  Name ,
			  DefaultDurationMinutes ,
			  DefaultColorCode ,
			  Description ,
			  ModifiedDate 
			)
	SELECT  DISTINCT  @PracticeID , -- PracticeID - int
			  PA.[Reasons] , -- Name - varchar(128)
			  15 , -- DefaultDurationMinutes - int
			  Null , -- DefaultColorCode - int
			  PA.[Reasons] , -- Description - varchar(256)
			  GETDATE()  -- ModifiedDate - datetime
	FROM dbo._import_2_1_PatientAppointments PA
	WHERE PA.[Reasons] <> '' AND 
			NOT EXISTS (SELECT * FROM dbo.AppointmentReason WHERE Name = PA.[Reasons] AND PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Practice Resource...'
	INSERT INTO dbo.PracticeResource
			( PracticeResourceTypeID,
			  PracticeID,
			  ResourceName,
			  ModifiedDate,
			  CreatedDate
			)
	SELECT DISTINCT	
			  3 , --PracticeResourceTypeID - int
			  @PracticeID , -- PracticeID - int
			  PA.PracticeResource , -- ResourceName - varchar(50)
			  GETDATE() , -- ModifiedDate - datetime
			  GETDATE() -- CreatedDate - datetime
	FROM dbo._import_2_1_PatientAppointments PA
	WHERE PA.PracticeResource <> '' AND 
			NOT EXISTS (SELECT * FROM dbo.PracticeResource AS PR WHERE PR.ResourceName = PA.PracticeResource AND PR.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Appointment To Appointment Reason - P...'
	INSERT INTO dbo.AppointmentToAppointmentReason
	        ( AppointmentID ,
	          AppointmentReasonID ,
	          PrimaryAppointment ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT DISTINCT    APP.AppointmentID , -- AppointmentID - int
	          AR.AppointmentReasonID , -- AppointmentReasonID - int
	          1 , -- PrimaryAppointment - bit
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo._import_2_1_PatientAppointments PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.MedicalRecordNumber = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID      
	INNER JOIN dbo.Appointment APP ON 
		PAT.PatientID = APP.PatientID AND
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.ENDDate = CAST(PA.EndDate AS DateTime) AND
		APP.[Subject] = PA.elationapptid    
	INNER JOIN dbo.AppointmentReason AR ON
		PA.[Reasons] = AR.NAME AND
		AR.PracticeID = @PracticeID
WHERE app.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
  
PRINT ''
PRINT 'Inserting Into Appointment to Resource - Doctor Resource - P...'	
	INSERT INTO dbo.AppointmentToResource
	        ( AppointmentID ,
	          AppointmentResourceTypeID ,
	          ResourceID ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT DISTINCT  APP.AppointmentID , -- AppointmentID - int
	          1 , -- AppointmentResourceTypeID - int
	          DOC.DoctorID , -- ResourceID - int 
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo._import_2_1_PatientAppointments PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.MedicalRecordNumber = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		APP.PatientId = PAT.PatientID AND 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime) AND
		APP.[Subject] = PA.elationapptid         
	INNER JOIN dbo.Doctor DOC ON
		DOC.FirstName = PA.DoctorFirstName AND
		DOC.LastName = PA.DoctorLastName AND
		DOC.PracticeID = @PracticeID AND
		DOC.[EXTERNAL] = 0  AND
		DOC.ActiveDoctor = 1    
WHERE PA.elationapptid <> '' AND app.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
    
PRINT ''
PRINT 'Inserting Into Appointmen5 to Resource - Practice Resource - P...'
	INSERT INTO dbo.AppointmentToResource
	        ( AppointmentID ,
	          AppointmentResourceTypeID ,
	          ResourceID ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT  DISTINCT  APP.AppointmentID , -- AppointmentID - int
	          2 , -- AppointmentResourceTypeID - int
	          PR.PracticeResourceID, -- ResourceID - int  
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo._import_2_1_PatientAppointments PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.MedicalRecordNumber = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		APP.PatientID = PAT.PatientID AND 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime) AND
		APP.[Subject] = PA.elationapptid          
	INNER JOIN dbo.PracticeResource PR ON
		PR.ResourceName = PA.PracticeResource AND
		PR.PracticeID = @PracticeID  
WHERE app.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


PRINT ''
PRINT 'Inserting Into Appointment - O...'
	INSERT INTO dbo.Appointment
	        ( 
	          PracticeID ,
	          ServiceLocationID ,
	          StartDate ,
	          EndDate ,
	          AppointmentType ,
	          CreatedDate ,
	          CreatedUserID ,
	          ModifiedDate ,
	          ModifiedUserID ,
	          AppointmentResourceTypeID ,
	          AppointmentConfirmationStatusCode ,
	          StartDKPracticeID ,
	          EndDKPracticeID ,
	          StartTm ,
	          EndTm , 
			  [Subject]
	        )
	SELECT  DISTINCT 
	          @PracticeID , -- PracticeID - int
	          CASE WHEN SL.ServiceLocationID IS NULL THEN SL2.ServiceLocationID ELSE SL.ServiceLocationID END , -- ServiceLocationID - int
	          PA.StartDate , -- StartDate - datetime
	          PA.EndDate , -- EndDate - datetime
	          'O' , -- AppointmentType - varchar(1)
	          GETDATE() , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          1 , -- AppointmentResourceTypeID - int
	           CASE WHEN PA.[STATUS] IN ('C','Confirmed') THEN 'C' 
					WHEN PA.[STATUS] IN ('E','Seen') THEN 'E'
					WHEN PA.[STATUS] IN ('I','Check-in') THEN 'I'
					WHEN PA.[STATUS] IN ('N','No-show') THEN 'N'
					WHEN PA.[STATUS] IN ('O','Check-out') THEN 'O' 
					WHEN PA.[STATUS] IN ('R','Rescheduled') THEN 'R'
					WHEN PA.[STATUS] IN ('S','Scheduled') THEN 'S'
					WHEN PA.[STATUS] IN ('X','Cancelled') THEN 'X'
					ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
	          DK.DKPracticeID , -- StartDKPracticeID - int
	          DK.DKPracticeID , -- EndDKPracticeID - int
			  CAST(REPLACE(RIGHT(PA.StartDate,5), ':','') AS SMALLINT)   , -- StartTm - smallint
	          CAST(REPLACE(RIGHT(PA.EndDate,5),  ':', '') AS SMALLINT) ,
			  LEFT(PA.Note, 64)
	FROM dbo._import_2_1_PatientAppointments PA
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(PA.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation SL ON
		SL.NAME = PA.ServiceLocationName AND
		SL.PracticeID = @PracticeID  
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
	LEFT JOIN dbo.Appointment a ON 
		a.StartDate = CAST(PA.startdate AS DATETIME) AND 
		a.EndDate = CAST(PA.enddate AS DATETIME) AND 
		a.AppointmentType = 'O'
WHERE a.AppointmentID IS NULL AND PA.elationapptid <> '' AND PA.chartnumber = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


PRINT ''
PRINT 'Inserting Into Appointment To Appointment Reason - O...'
	INSERT INTO dbo.AppointmentToAppointmentReason
	        ( AppointmentID ,
	          AppointmentReasonID ,
	          PrimaryAppointment ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT DISTINCT    
			  APP.AppointmentID , -- AppointmentID - int
	          AR.AppointmentReasonID , -- AppointmentReasonID - int
	          1 , -- PrimaryAppointment - bit
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo._import_2_1_PatientAppointments PA
	INNER JOIN dbo.Appointment APP ON 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.ENDDate = CAST(PA.EndDate AS DateTime) AND 
		APP.AppointmentType = 'O'
	INNER JOIN dbo.AppointmentReason AR ON
		PA.[Reasons] = AR.NAME AND
		AR.PracticeID = @PracticeID
WHERE app.CreatedDate > DATEADD(mi,-1,GETDATE()) AND PA.elationapptid <> '' AND PA.chartnumber = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
  
PRINT ''
PRINT 'Inserting Into Appointment to Resource - Doctor Resouce - O...'	
	INSERT INTO dbo.AppointmentToResource
	        ( AppointmentID ,
	          AppointmentResourceTypeID ,
	          ResourceID ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT DISTINCT  APP.AppointmentID , -- AppointmentID - int
	          1 , -- AppointmentResourceTypeID - int
	          DOC.DoctorID , -- ResourceID - int 
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo._import_2_1_PatientAppointments PA
	INNER JOIN dbo.Appointment APP ON 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime)  AND 
		APP.AppointmentType = 'O'     
	INNER JOIN dbo.Doctor DOC ON
		DOC.FirstName = PA.DoctorFirstName AND
		DOC.LastName = PA.DoctorLastName AND
		DOC.PracticeID = @PracticeID AND
		DOC.[EXTERNAL] = 0  AND
		DOC.ActiveDoctor = 1    
WHERE PA.elationapptid <> '' AND PA.chartnumber = '' AND app.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
    
PRINT ''
PRINT 'Inserting Into Appointmen5 to Resource - Practice Resource - O...'
	INSERT INTO dbo.AppointmentToResource
	        ( AppointmentID ,
	          AppointmentResourceTypeID ,
	          ResourceID ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT  DISTINCT  APP.AppointmentID , -- AppointmentID - int
	          2 , -- AppointmentResourceTypeID - int
	          PR.PracticeResourceID, -- ResourceID - int  
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo._import_2_1_PatientAppointments PA
	INNER JOIN dbo.Appointment APP ON 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime)  AND 
		APP.AppointmentType = 'O'         
	INNER JOIN dbo.PracticeResource PR ON
		PR.ResourceName = PA.PracticeResource AND
		PR.PracticeID = @PracticeID  
WHERE app.CreatedDate > DATEADD(mi,-1,GETDATE()) AND PA.elationapptid <> '' AND PA.chartnumber = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


-- Set cases without policies to self-pay (11)
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11,
	NAME = 'Self Pay'
WHERE 
	@VendorImportID = VendorImportID AND 
	@PracticeID = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID) AND
	PayerScenarioID <> 11
	

-- Cleanup / DROP temp tables

DROP TABLE #tempPolicies
DROP TABLE #tempins

--ROLLBACK
--COMMIT


/*
DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2


SELECT a.PracticeID ,
a.appointmentid AS [AppointmentID] ,
ipa.elationapptid AS [ElationApptID] ,
a.patientid AS [PatientID] ,
p.medicalrecordnumber AS [ElationPatID] ,
p.FirstName + ' ' + p.MiddleName + ' ' + p.LastName AS [PatientName] ,
CASE WHEN Reas1.AppointmentID IS NOT NULL THEN ar1.Name END AS [Reason1] ,
CASE WHEN Reas2.AppointmentID IS NOT NULL THEN ar2.Name END AS [Reason2] ,
CASE WHEN Reas3.AppointmentID IS NOT NULL THEN ar3.Name END AS [Reason3] ,
CASE WHEN Reas4.AppointmentID IS NOT NULL THEN ar4.Name END AS [Reason4] ,
CASE WHEN Res1.AppointmentID IS NOT NULL THEN CASE WHEN Res1.AppointmentResourceTypeID = 1 THEN d1.FirstName + ' ' + d1.LastName 
												   WHEN Res1.AppointmentResourceTypeID = 2 THEN pr1.ResourceName END END AS [Resource1] ,
CASE WHEN Res2.AppointmentID IS NOT NULL THEN CASE WHEN Res2.AppointmentResourceTypeID = 1 THEN d2.FirstName + ' ' + d2.LastName 
												   WHEN Res2.AppointmentResourceTypeID = 2 THEN pr2.ResourceName END END AS [Resource2] ,
CASE WHEN Res3.AppointmentID IS NOT NULL THEN CASE WHEN Res3.AppointmentResourceTypeID = 1 THEN d3.FirstName + ' ' + d3.LastName 
												   WHEN Res3.AppointmentResourceTypeID = 2 THEN pr3.ResourceName END END AS [Resource3] ,
CASE WHEN Res4.AppointmentID IS NOT NULL THEN CASE WHEN Res4.AppointmentResourceTypeID = 1 THEN d4.FirstName + ' ' + d4.LastName 
												   WHEN Res4.AppointmentResourceTypeID = 2 THEN pr4.ResourceName END END AS [Resource4] ,
CASE a.AppointmentType WHEN 'P' THEN 'Patient' WHEN 'O' THEN 'Other' END AS [AppointmentType] ,
sl.name AS [Location] , 
a.startdate AS [StartDate] ,
a.EndDate AS [EndDate] ,
DATEDIFF(MINUTE,a.StartDate,a.enddate) AS [Duation],
CASE WHEN a.AppointmentType = 'O' THEN a.[subject] END AS [Subject]  , 
REPLACE(REPLACE(CAST(a.notes AS VARCHAR(MAX)),CHAR(13),' '),CHAR(10),'') AS [Notes] ,
CASE a.AppointmentConfirmationStatusCode 
	WHEN 'C' THEN 'Confirmed'
	WHEN 'E' THEN 'Seen'
	WHEN 'I' THEN 'Check-in'
	WHEN 'N' THEN 'No-show'
	WHEN 'O' THEN 'Check-out'
	WHEN 'R' THEN 'Rescheduled'
	WHEN 'S' THEN 'Scheduled'
	WHEN 'T' THEN 'Tentative'
	WHEN 'X' THEN 'Cancelled'
END AS [Status] ,
a.createddate AS [DateCreated] ,
a.modifieddate AS [DateEdited] ,
CASE ar.[type] WHEN 'D' THEN 'Daily'
			WHEN 'W' THEN 'Weekly'
			WHEN 'M' THEN 'Monthly'
			WHEN 'Y' THEN 'Yearly'
END AS [Recurrence Type] ,
CASE WHEN ar.[type] = 'W' THEN 'Recur every ' + CAST(ar.WeeklyNumWeeks AS VARCHAR) + ' week(s) on ' + 
					CASE WHEN ar.WeeklyOnSunday = 0 THEN '' ELSE 'Sunday, ' END +
					CASE WHEN ar.WeeklyOnMonday = 0 THEN '' ELSE 'Monday, ' END +
					CASE WHEN ar.WeeklyOnTuesday = 0 THEN '' ELSE 'Tuesday, ' END +
					CASE WHEN ar.WeeklyOnWednesday = 0 THEN '' ELSE 'Wednesday, ' END + 
					CASE WHEN ar.WeeklyOnThursday = 0 THEN '' ELSE 'Thursday, ' END +
					CASE WHEN ar.WeeklyOnFriday = 0 THEN '' ELSE 'Friday, ' END +
					CASE WHEN ar.WeeklyOnSaturday = 0 THEN '' ELSE 'Sunday, ' END +
					CASE ar.RangeType 
						WHEN 'N' THEN '' 
						WHEN 'D' THEN ' until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR)
						WHEN 'O' THEN ' until ' + CAST(ar.RangeEndOccurrences AS VARCHAR) + ' ocurrences on | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR)  END
     WHEN ar.[type] = 'D' THEN 'Recur every ' +
					CASE ar.DailyType 
						WHEN 'X' THEN CAST(DailyNumDays AS VARCHAR) + ' days' 
					    WHEN 'W' THEN 'Weekday' END +
					CASE ar.RangeType 
						WHEN 'N' THEN '' 
						WHEN 'D' THEN ' until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR)
						WHEN 'O' THEN ' until ' + CAST(ar.RangeEndOccurrences AS VARCHAR) + ' ocurrences on | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR) END
	WHEN ar.[type] = 'M' THEN 
					CASE ar.monthlytype 
						WHEN 'D' THEN 'Recur every ' + CAST(ar.MonthlyDayOfMonth AS VARCHAR) +
									CASE WHEN ar.MonthlyDayOfMonth % 100 IN (11,12,13) THEN CAST(ar.MonthlyDayOfMonth AS VARCHAR) + 'th'
										 WHEN ar.MonthlyDayOfMonth % 10 = 1 THEN 'st'
										 WHEN ar.MonthlyDayOfMonth % 10 = 2 THEN 'nd'
										 WHEN ar.MonthlyDayOfMonth % 10 = 3 THEN 'rd'
									ELSE 'th' END + ' day ' + CASE WHEN ar.MonthlyNumMonths = 1 THEN 'every month' ELSE ' for every ' + CAST(ar.monthlynummonths AS VARCHAR) + ' months' END 
						WHEN 'T' THEN 'Recur every ' + CASE ar.monthlyweektypeofmonth 
														WHEN '1' THEN 'first '
														WHEN '2' THEN 'second '
														WHEN '3' THEN 'third '
														WHEN '4' THEN 'forth '
														WHEN 'L' THEN 'last ' 
													   END 
					END +
					CASE ar.monthlytypeofday 
						WHEN 'D' THEN 'day '
						WHEN 'K' THEN 'weekday '
						WHEN 'E' THEN 'weekend day '
						WHEN 'S' THEN 'Sunday '
						WHEN 'M' THEN 'Monday '
						WHEN 'T' THEN 'Tuesday '
						WHEN 'W' THEN 'Wednesday '
						WHEN 'R' THEN 'Thursday '
						WHEN 'F' THEN 'Friday '
						WHEN 'A' THEN 'Saturday '
						ELSE '' 
					END +
					CASE ar.RangeType 
						WHEN 'N' THEN '' 
						WHEN 'D' THEN ' until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR)
						WHEN 'O' THEN ' for ' + CAST(ar.RangeEndOccurrences AS VARCHAR) + ' ocurrences until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR) END				
	WHEN ar.[type] = 'Y' THEN 
					CASE ar.yearlytype 
						WHEN 'D' THEN 'Recur every ' + CAST(ar.YearlyDayOfMonth AS VARCHAR) +
									CASE WHEN ar.YearlyDayOfMonth % 100 IN (11,12,13) THEN CAST(ar.YearlyDayOfMonth AS VARCHAR) + 'th'
										 WHEN ar.YearlyDayOfMonth % 10 = 1 THEN 'st'
										 WHEN ar.YearlyDayOfMonth % 10 = 2 THEN 'nd'
										 WHEN ar.YearlyDayOfMonth % 10 = 3 THEN 'rd'
									ELSE 'th' END + ' day '
						 WHEN 'T' THEN 'Recur every ' + CASE ar.YearlyDayTypeOfMonth 
														 WHEN '1' THEN 'first '
														 WHEN '2' THEN 'second '
														 WHEN '3' THEN 'third '
														 WHEN '4' THEN 'forth '
														 WHEN 'L' THEN 'last ' 
														END 
					END +
					CASE ar.YearlyTypeofDay 
						WHEN 'D' THEN 'day '
						WHEN 'K' THEN 'weekday '
						WHEN 'E' THEN 'weekend day '
						WHEN 'S' THEN 'Sunday '
						WHEN 'M' THEN 'Monday '
						WHEN 'T' THEN 'Tuesday '
						WHEN 'W' THEN 'Wednesday '
						WHEN 'R' THEN 'Thursday '
						WHEN 'F' THEN 'Friday '
						WHEN 'A' THEN 'Saturday '
						ELSE '' 
					END +
					CASE ar.YearlyMonth
						WHEN '1' THEN 'of January'
						WHEN '2' THEN 'of February'
						WHEN '3' THEN 'of March'
						WHEN '4' THEN 'of April'
						WHEN '5' THEN 'of May'
						WHEN '6' THEN 'of June'
						WHEN '7' THEN 'of July'
						WHEN '8' THEN 'of August'
						WHEN '9' THEN 'of September'
						WHEN '10' THEN 'of October'
						WHEN '11' THEN 'of November'
						WHEN '12' THEN 'of December'
					END +
					CASE ar.RangeType 
						WHEN 'N' THEN '' 
						WHEN 'D' THEN ' until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR)
						WHEN 'O' THEN ' for ' + CAST(ar.RangeEndOccurrences AS VARCHAR) + ' ocurrences until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR) END				
END AS [Recurrence Pattern]
FROM dbo.Appointment a 
LEFT JOIN  (
SELECT AppointmentID, AppointmentToResourceID, AppointmentResourceTypeID , ResourceID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToResourceID DESC) AS ResNum FROM dbo.AppointmentToResource
		   ) AS Res1  ON a.AppointmentID = Res1.AppointmentID AND Res1.ResNum = 1
LEFT JOIN  (
SELECT AppointmentID, AppointmentToResourceID, AppointmentResourceTypeID , ResourceID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToResourceID DESC) AS ResNum FROM dbo.AppointmentToResource
		   ) AS Res2  ON a.AppointmentID = Res2.AppointmentID AND Res2.ResNum = 2
LEFT JOIN  (
SELECT AppointmentID, AppointmentToResourceID, AppointmentResourceTypeID , ResourceID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToResourceID DESC) AS ResNum FROM dbo.AppointmentToResource
		   ) AS Res3  ON a.AppointmentID = Res3.AppointmentID AND Res3.ResNum = 3
LEFT JOIN  (
SELECT AppointmentID, AppointmentToResourceID, AppointmentResourceTypeID , ResourceID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToResourceID DESC) AS ResNum FROM dbo.AppointmentToResource
		   ) AS Res4  ON a.AppointmentID = Res4.AppointmentID AND Res4.ResNum = 4
LEFT JOIN  (
SELECT AppointmentToAppointmentReasonID, AppointmentID, AppointmentReasonID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToAppointmentReasonID DESC) AS ReasNum FROM dbo.AppointmentToAppointmentReason
		   ) AS Reas1 ON a.AppointmentID = Reas1.AppointmentID AND Reas1.ReasNum = 1
LEFT JOIN  (
SELECT AppointmentToAppointmentReasonID, AppointmentID, AppointmentReasonID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToAppointmentReasonID DESC) AS ReasNum FROM dbo.AppointmentToAppointmentReason
		   ) AS Reas2 ON a.AppointmentID = Reas2.AppointmentID AND Reas2.ReasNum = 2
LEFT JOIN  (
SELECT AppointmentToAppointmentReasonID, AppointmentID, AppointmentReasonID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToAppointmentReasonID DESC) AS ReasNum FROM dbo.AppointmentToAppointmentReason
		   ) AS Reas3 ON a.AppointmentID = Reas3.AppointmentID AND Reas3.ReasNum = 3
LEFT JOIN  (
SELECT AppointmentToAppointmentReasonID, AppointmentID, AppointmentReasonID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToAppointmentReasonID DESC) AS ReasNum FROM dbo.AppointmentToAppointmentReason
		   ) AS Reas4 ON a.AppointmentID = Reas4.AppointmentID AND Reas4.ReasNum = 4
LEFT JOIN dbo.AppointmentReason ar1 ON ar1.AppointmentReasonID = Reas1.AppointmentReasonID
LEFT JOIN dbo.AppointmentReason ar2 ON ar2.AppointmentReasonID = Reas2.AppointmentReasonID
LEFT JOIN dbo.AppointmentReason ar3 ON ar3.AppointmentReasonID = Reas3.AppointmentReasonID
LEFT JOIN dbo.AppointmentReason ar4 ON ar4.AppointmentReasonID = Reas4.AppointmentReasonID
LEFT JOIN dbo.PracticeResource pr1 ON Res1.ResourceID = pr1.PracticeResourceID AND Res1.AppointmentResourceTypeID = 2
LEFT JOIN dbo.PracticeResource pr2 ON Res2.ResourceID = pr2.PracticeResourceID AND Res2.AppointmentResourceTypeID = 2
LEFT JOIN dbo.PracticeResource pr3 ON Res3.ResourceID = pr3.PracticeResourceID AND Res3.AppointmentResourceTypeID = 2
LEFT JOIN dbo.PracticeResource pr4 ON Res4.ResourceID = pr4.PracticeResourceID AND Res4.AppointmentResourceTypeID = 2
LEFT JOIN dbo.Doctor d1 ON Res1.ResourceID = d1.DoctorID AND Res1.AppointmentResourceTypeID = 1 AND d1.[External] = 0
LEFT JOIN dbo.Doctor d2 ON Res2.ResourceID = d2.DoctorID AND Res2.AppointmentResourceTypeID = 1 AND d2.[External] = 0
LEFT JOIN dbo.Doctor d3 ON Res3.ResourceID = d3.DoctorID AND Res3.AppointmentResourceTypeID = 1 AND d3.[External] = 0
LEFT JOIN dbo.Doctor d4 ON Res4.ResourceID = d4.DoctorID AND Res4.AppointmentResourceTypeID = 1 AND d4.[External] = 0
INNER JOIN dbo.servicelocation sl ON a.ServiceLocationID = sl.servicelocationid
LEFT JOIN dbo.Patient p ON a.patientid = p.PatientID AND p.PracticeID = @PracticeID
LEFT JOIN dbo.AppointmentRecurrence ar ON a.AppointmentID = ar.AppointmentID
LEFT JOIN dbo.[_import_2_1_PatientAppointments] ipa ON ipa.enddate = a.EndDate AND ipa.startdate = a.StartDate AND ipa.chartnumber = p.MedicalRecordNumber
WHERE a.PracticeID = @PracticeID 
ORDER BY a.AppointmentID


*/

SELECT * FROM dbo.Doctor ORDER BY CreatedDate desc