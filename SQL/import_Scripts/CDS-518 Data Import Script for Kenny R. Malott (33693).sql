USE superbill_33693_dev
--USE superbill_33693_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


/*
==========================================================================================================================================
CREATE REFERRING PHYSICIANS FROM [REFERRINGPHYSICIANS]
==========================================================================================================================================
*/	

INSERT INTO dbo.Doctor
( 
	PracticeID , Prefix, Suffix, FirstName , MiddleName , LastName , SSN , AddressLine1 , AddressLine2 , City , State , Country , HomePhone , HomePhoneExt , 
	WorkPhone , WorkPhoneExt , MobilePhone , MobilePhoneExt , DOB , EmailAddress , Notes , ActiveDoctor , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , UserID , Degree , TaxonomyCode , VendorID , VendorImportID , FaxNumber , FaxNumberExt , [External] , NPI 
)
SELECT DISTINCT 
	@PracticeID , -- PracticeID - int
	LEFT(RP.[prefix],16), -- Prefix
	LEFT(RP.suffix,16), -- Suffix
	LEFT(RP.firstname,64) , -- FirstName - varchar(64)
	LEFT(RP.middleinitial,64) , -- MiddleName - varchar(64)
	LEFT(RP.lastname,64) , -- LastName - varchar(64)
	CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.ssn)) >= 6 
					THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(RP.ssn) , 9)
	     WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.ssn)) >= 7 
					THEN RIGHT ('00' + dbo.fn_RemoveNonNumericCharacters(RP.ssn) , 9)
	     WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.ssn)) >= 8 
					THEN RIGHT ('0' + dbo.fn_RemoveNonNumericCharacters(RP.ssn) , 9)
	     ELSE dbo.fn_RemoveNonNumericCharacters(RP.ssn) END  , -- SSN - varchar(9)
	LEFT(RP.address1,256) , -- AddressLine1 - varchar(256)
	LEFT(RP.address2,256) , -- AddressLine2 - varchar(256)
	LEFT(RP.city,128) , -- City - varchar(128)
	UPPER(LEFT(RP.[state],2)) , -- State - varchar(2)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(RP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(RP.zip)
		ELSE '' END , -- ZipCode - varchar(9)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(RP.homephone),10)
		ELSE '' END , -- HomePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.homephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(RP.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(RP.homephone))),10)
		ELSE NULL END , -- HomePhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(RP.workphone),10)
		ELSE '' END , -- WorkPhone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(RP.workphoneextension),10) , -- WorkPhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.cellphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(RP.cellphone),10)
		ELSE '' END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.cellphone)) >= 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(RP.cellphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(RP.cellphone))),10)
		ELSE NULL END  , -- MobilePhoneExt - varchar(10)
	CASE
		WHEN ISDATE(RP.dateofbirth) = 1 THEN RP.dateofbirth
		ELSE NULL END , -- DOB - datetime
	LEFT(RP.email,256) , -- EmailAddress - varchar(256)
	rp.Notes + CHAR(13) + CHAR(10) + CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.  ' + RP.notes , -- Notes - text
	1 , -- ActiveDoctor - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	0 , -- UserID - int
	UPPER(LEFT(RP.degree,8)) , -- Degree - varchar(8)
	TC.TaxonomyCode , -- TaxonomyCode - char(10)
	RP.AutoTempID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(RP.fax),10) , -- FaxNumber - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(RP.faxext),10) , -- FaxNumberExt - varchar(10)
	1, -- External - bit
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.npi)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(RP.npi)
		ELSE NULL END -- NPI - varchar(10)
FROM dbo.[_import_1_1_ReferringDoctors] AS RP 
	LEFT JOIN dbo.TaxonomyCode AS TC ON TC.TaxonomyCode = RP.taxonomycode
	LEFT JOIN dbo.Doctor AS OD ON OD.FirstName = RP.FirstName AND OD.LastName = RP.LastName AND OD.[External] = 1 AND OD.PracticeID = @PracticeID
WHERE RP.firstname <> '' AND RP.lastname <> '' 
	AND OD.DoctorId IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted RP'
PRINT ''

/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [Existing IC]
==========================================================================================================================================
*/	

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
	LEFT(ICP.Zip,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(ICP.Phone,10) , -- Phone - varchar(10)
	LEFT(ICP.PhoneExt,10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	ICP.Fax , -- Fax - varchar(10)
	ICP.FaxExt , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_InsuranceCompanyPlanList] ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.Insurancecompanyname = (SELECT TOP 1 InsuranceCompanyName FROM dbo.InsuranceCompany 
									WHERE ICP.InsuranceCompanyName = InsuranceCompanyName AND
										  ReviewCode = 'R' OR CreatedPracticeID = @PracticeID)
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	IC.InsuranceCompanyID = OICP.InsuranceCompanyID AND
	OICP.PlanName = ICP.planname  
WHERE IC.CreatedPracticeID = @PracticeID AND
	  OICP.InsuranceCompanyPlanID IS NULL  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into IC - Existing IC'
PRINT ''


/*
==========================================================================================================================================
CREATE INSURANCE COMPANIES FROM [_import_1_1_InsuranceCompanyPlanList]
==========================================================================================================================================
*/	


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
	1 , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	13 , -- SecondaryPrecedenceBillingFormID - int
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,128) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceCompanyPlanList] AS IICL
WHERE ( insurancecompanyname <> '' OR planname <> '') AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.InsuranceCompanyName AND
														 ReviewCode = 'R' OR CreatedPracticeID = @PracticeID
														 AND VendorImportID <> @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted IC'
PRINT ''
/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

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
	LEFT(ICP.Zip,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
	LEFT(ICP.Phone,10) , -- Phone - varchar(10)
	LEFT(ICP.PhoneExt,10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	ICP.Fax , -- Fax - varchar(10)
	ICP.FaxExt , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@VendorImportID -- VendorImportID - int
FROM dbo.[_import_1_1_InsuranceCOMPANYPLANList] ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = ICP.InsuranceCompanyName AND
	ICP.Insurancecompanyname = IC.InsuranceCompanyName 
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	IC.InsuranceCompanyID = OICP .InsuranceCompanyID AND
    ICP.planname = OICP.PlanName AND
	OICP.VendorImportID = @VendorImportID 
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into ICP'
PRINT ''

/*
==========================================================================================================================================
CREATE REFERRING DOCTORS FROM [PATIENTDEMOGRAPHICS]
==========================================================================================================================================
*/	

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
	LEFT(PD.referringphysicianfirstname,64) , -- FirstName - varchar(64)
	'' , -- MiddleName - varchar(64)
	LEFT(PD.referringphysicianlastname,64) , -- LastName - varchar(64)
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
	PD.referringphysicianfirstname + PD.referringphysicianlastname , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	'' , -- FaxNumber - varchar(10)
	'' , -- FaxNumberExt - varchar(10)
	1, -- External - bit
	'' -- NPI - varchar(10)
FROM dbo.[_import_1_1_PatientDemographics] AS PD
LEFT JOIN dbo.Doctor AS D ON D.FirstName = PD.referringphysicianfirstname
		AND D.LastName = PD.referringphysicianlastname
		AND D.PracticeID = @PracticeID
		AND D.ActiveDoctor = 1
WHERE D.DoctorID IS NULL
	AND PD.referringphysicianfirstname <> ''
	AND PD.referringphysicianlastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted RP - Pat'
PRINT ''

/*
==========================================================================================================================================
CREATE DOCTORS FROM [PATIENTDEMOGRAPHICS]
==========================================================================================================================================
*/	

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
	PD.PrimaryCarePhysicianfirstname + PD.PrimaryCarePhysicianlastname , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	'' , -- FaxNumber - varchar(10)
	'' , -- FaxNumberExt - varchar(10)
	1, -- External - bit
	'' -- NPI - varchar(10)
FROM dbo.[_import_1_1_PatientDemographics] AS PD
LEFT JOIN dbo.Doctor AS D ON D.FirstName = PD.PrimaryCarePhysicianFirstName
		AND D.LastName = PD.PrimaryCarePhysicianLastName
		AND D.PracticeID = @PracticeID
		AND D.ActiveDoctor = 1
WHERE D.DoctorID IS NULL
	AND PD.PrimaryCarePhysicianfirstname <> ''
	AND PD.PrimaryCarePhysicianlastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted PCP - Pat'
PRINT ''


/*
==========================================================================================================================================
CREATE EMPLOYERS
==========================================================================================================================================
*/	

INSERT INTO dbo.Employers
(
	EmployerName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID 
)
SELECT DISTINCT 
	LEFT(PD.employername,128) , -- EmployerName - varchar(128)
	LEFT(PD.employeraddress1,256) , -- AddressLine1 - varchar(256)
	LEFT(PD.employeraddress2,256) , -- AddressLine2 - varchar(256)
	LEFT(PD.employercity,128) , -- City - varchar(128)
	UPPER(LEFT(PD.employerstate,2)) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.employerzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(PD.employerzip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.employerzip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(PD.employerzip)
		ELSE '' END , -- ZipCode - varchar(9)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientDemographics] AS PD
WHERE PD.employername <> '' AND
	  PD.employername NOT IN (SELECT EmployerName FROM dbo.Employers)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted EMP'
PRINT ''


/*
==========================================================================================================================================
CREATE PATIENTS
==========================================================================================================================================
*/	


DECLARE @DefaultCollectionCategory INT
SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)

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
FROM dbo.[_import_1_1_PatientDemographics] AS PD
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
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Pat'
PRINT ''

/*
==========================================================================================================================================
CREATE PATIENT ALERT
==========================================================================================================================================
*/	 

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
FROM dbo.[_import_1_1_PatientDemographics] AS IPD
	JOIN dbo.Patient AS PAT ON PAT.VendorID = IPD.ChartNumber AND PAT.VendorImportID = @VendorImportID
WHERE IPD.patientalertmessage <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted PA'
PRINT ''


/*l
==========================================================================================================================================
CREATE PATIENT CASES
==========================================================================================================================================
*/	

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
FROM dbo.[_import_1_1_PatientDemographics] pd
	JOIN dbo.Patient AS PAT ON VendorImportID = @VendorImportID AND VendorID = pd.chartnumber
WHERE 
	pd.DefaultCase NOT IN (SELECT Name FROM dbo.PatientCase WHERE PatientID = PAT.PatientID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted PC'
PRINT ''
/*
==========================================================================================================================================
CREATE PATIENT CASE DATE
==========================================================================================================================================
*/	

INSERT INTO dbo.PatientCaseDate
( 
	PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID
)
SELECT DISTINCT
	@PracticeID , -- PracticeID - int
	PC.PatientCaseID , -- PatientCaseID - int
	8 , -- PatientCaseDateTypeID - int
	IPD.datelastseen , -- StartDate - datetime
	NULL , -- EndDate - datetime
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientDemographics] AS IPD
	JOIN dbo.Patient AS PAT ON PAT.VendorID = IPD.ChartNumber AND PAT.VendorImportID = @VendorImportID
	JOIN dbo.PatientCase AS PC ON PC.PatientID = PAT.PatientID AND PC.VendorImportID = @VendorImportID
WHERE ISDATE(IPD.datelastseen) = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted PatCaseDate'
PRINT ''

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
	FROM dbo.[_import_1_1_PatientDemographics]
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
	FROM dbo.[_import_1_1_PatientDemographics]
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
	FROM dbo.[_import_1_1_PatientDemographics]
	WHERE  insurancecode3 <> ''  
) AS Y
ORDER BY InsuranceColumnCount



/*
==========================================================================================================================================
CREATE INSURANCE POLICIES  
==========================================================================================================================================
*/

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
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted IP'
PRINT ''

	
/*
==========================================================================================================================================
Create Balance Forward
==========================================================================================================================================
*/



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
          pat.PatientID , -- PatientID - int
          'Balance Forward' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          Pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient as pat 
INNER JOIN dbo.[_import_1_1_PatientDemographics] AS m ON
   pat.VendorID = m.chartnumber AND 
   pat.VendorImportID = @VendorImportID 
WHERE m.BalanceForward <> '' AND m.BalanceFOrward > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted BF - Case'
PRINT ''

IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE DiagnosisCode='000.00')
BEGIN

INSERT INTO dbo.DiagnosisCodeDictionary 
        ( 
		  DiagnosisCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          OfficialName ,
          LocalName ,
          OfficialDescription    
        )
VALUES  
       ( 
          '000.00' , -- DiagnosisCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- Active - bit
         'Miscellaneous' ,  -- OfficialName - varchar(300)
         'Miscellaneous' ,  -- LocalName - varchar(100)
          NULL  -- OfficialDescription - varchar(500) 
        )
END

INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
          LocationID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
          PatientCaseID ,
          PostingDate ,
          DateOfServiceTo ,
          PaymentMethod ,
          AddOns ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
          VendorID ,
          VendorImportID ,
          DoNotSendElectronicSecondary ,
          overrideClosingDate ,
          ClaimTypeID ,
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
          PatientCheckedIn 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          pc.PatientID , -- PatientID - int
          CASE WHEN PAT.PrimaryProviderID IS NULL THEN Doc.DoctorID ELSE PAT.PrimaryProviderID END , -- DoctorID - int
          CASE WHEN PAT.DefaultServiceLocationID IS NULL THEN SL.ServiceLocationID ELSE PAT.DefaultServiceLocationID END , -- LocationID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ' : Balance Forward Created, please verify before use.' , -- Notes - text
          2 , -- EncounterStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          pc.PatientCaseID , -- PatientCaseID - int       
          GETDATE() , -- PostingDate - datetime
          GETDATE() , -- DateOfServiceTo - datetime
          'U' , -- PaymentMethod - char(1)
          0 , -- AddOns - bigint
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
          pc.VendorID , -- VendorID - varchar(50)                
          @VendorImportID , -- VendorImportID - int
          0 , -- DoNotSendElectronicSecondary - bit
          0 , -- overrideClosingDate - bit
          0 , -- ClaimTypeID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          0  -- PatientCheckedIn - bit
FROM dbo.PatientCase AS PC  
INNER JOIN dbo.Patient PAT ON
	PC.PatientID = PAT.PatientID AND
	PC.VendorID = PAT.VendorID  
LEFT JOIN dbo.Doctor Doc ON
	Doc.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS D WHERE d.ActiveDoctor =1 AND d.[External] = 0 AND d.PracticeID = @PracticeID AND d.ActiveDoctor = 1)
LEFT JOIN dbo.ServiceLocation SL ON
	SL.ServicelocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation S WHERE s.PracticeID = @PracticeID)
WHERE pc.Name = 'Balance Forward' AND pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted ENC'
PRINT ''
INSERT INTO dbo.EncounterDiagnosis
        ( 
		  EncounterID ,
          DiagnosisCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          ListSequence ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
          enc.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          1 , -- ListSequence - int
          @PracticeID  , -- PracticeID - int
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter as enc 
INNER JOIN dbo.DiagnosisCodeDictionary AS dcd ON
    dcd.DiagnosisCode = '000.00' AND 
    enc.PracticeID = @PracticeID        
WHERE enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted ED'
PRINT ''

INSERT INTO dbo.EncounterProcedure
        ( 
		  EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ServiceChargeAmount ,   
          ServiceUnitCount ,
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
          TypeOfServiceCode ,
          AnesthesiaTime ,
          AssessmentDate ,
          DoctorID ,
          ConcurrentProcedures 
        )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pd.BalanceForward , -- ServiceChargeAmount - money   
          '1.000' , -- ServiceUnitCount - decimal
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
          GETDATE() , -- ServiceEndDate - datetime
          enc.VendorID , -- VendorID - varchar(50)              
          @VendorImportID , -- VendorImportID - int
          '1' , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
          GETDATE() , -- AssessmentDate - datetime
          enc.DoctorID , -- DoctorID - int
          1  -- ConcurrentProcedures - int
FROM dbo.Encounter AS enc
INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
   pcd.OfficialName = 'Balance Forward' AND 
   enc.PracticeID = @PracticeID
INNER JOIN dbo.EncounterDiagnosis AS ed ON
   ed.vendorID = enc.VendorID AND 
   enc.VendorImportID = @VendorImportID   
LEFT JOIN dbo.[_import_1_1_PatientDemographics] as pd ON 
    pd.ChartNumber = enc.vendorID AND 
	enc.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted EP'
PRINT ''
  

 
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
IF OBJECT_ID('tempdb..#tempPolicies') IS NOT NULL 
DROP TABLE #tempPolicies



/*
==========================================================================================================================================
CREATE Patient Appointments
==========================================================================================================================================
*/	



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
	          EndTm 
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
	          CAST(REPLACE(RIGHT(PA.EndDate,5),  ':', '') AS SMALLINT)
	FROM dbo.[_import_1_1_PatientAppointments] PA
	INNER JOIN dbo.Patient PAT ON 
		PA.ChartNumber = PAT.VendorID AND
		PAT.PracticeID = @PracticeID
	INNER JOIN dbo.PatientCase PC ON 
		PC.PatientID = PAT.PatientID AND
		PC.PracticeID = @PracticeID  AND
		PC.NAME <> 'Balance Forward'    
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(PA.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation SL ON
		SL.NAME = PA.ServiceLocationName AND
		SL.PracticeID = @PracticeID  
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted App'
PRINT ''

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
	FROM dbo.[_import_1_1_PatientAppointments] PA
	WHERE PA.[Reasons] <> '' AND 
			NOT EXISTS (SELECT * FROM dbo.AppointmentReason WHERE Name = PA.[Reasons] AND PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Ap Reason'
PRINT ''
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
	FROM dbo.[_import_1_1_PatientAppointments] PA
	WHERE PA.PracticeResource <> '' AND 
			NOT EXISTS (SELECT * FROM dbo.PracticeResource AS PR WHERE PR.ResourceName = PA.PracticeResource AND PR.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted PR'
PRINT ''
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
	FROM dbo.[_import_1_1_PatientAppointments] PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID      
	INNER JOIN dbo.Appointment APP ON 
		PAT.PatientID = APP.PatientID AND
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.ENDDate = CAST(PA.EndDate AS DateTime)      
	INNER JOIN dbo.AppointmentReason AR ON
		PA.[Reasons] = AR.NAME AND
		AR.PracticeID = @PracticeID
 PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Ap to APR'
PRINT '' 
	
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
	FROM dbo.[_import_1_1_PatientAppointments] PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		APP.PatientId = PAT.PatientID AND 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime)      
	INNER JOIN dbo.Doctor DOC ON
		DOC.FirstName = PA.DoctorFirstName AND
		DOC.LastName = PA.DoctorLastName AND
		DOC.PracticeID = @PracticeID AND
		DOC.[EXTERNAL] = 0  AND
		DOC.ActiveDoctor = 1    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Ap to R'
PRINT ''
    
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
	FROM dbo.[_import_1_1_PatientAppointments] PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		APP.PatientID = PAT.PatientID AND 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime)       
	INNER JOIN dbo.PracticeResource PR ON
		PR.ResourceName = PA.PracticeResource AND
		PR.PracticeID = @PracticeID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Ap to R'
PRINT ''





--ROLLBACK
--COMMIT