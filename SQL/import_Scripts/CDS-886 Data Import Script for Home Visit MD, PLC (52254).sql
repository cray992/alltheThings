USE superbill_52254_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT , @VendorImportID INT
SET @PracticeID = 1
SET @VendorImportID = 2

/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [Existing IC]
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
	CASE WHEN ICP.planname <> '' THEN LEFT(LTRIM(RTRIM(ICP.planname)),128)
		 ELSE LEFT(LTRIM(RTRIM(ICP.InsuranceCompanyName)),128) END  , -- PlanName - varchar(128)
	LEFT(LTRIM(RTRIM(ICP.Address1)),256) , -- AddressLine1 - varchar(256)
	LEFT(LTRIM(RTRIM(ICP.Address2)),256) , -- AddressLine2 - varchar(256)
	LEFT(LTRIM(RTRIM(ICP.City)),128) , -- City - varchar(128)
	UPPER(LEFT(LTRIM(RTRIM(ICP.[State])),2)) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(LTRIM(RTRIM(ICP.ContactFirstName)),64) , -- ContactFirstName - varchar(64)
	LEFT(LTRIM(RTRIM(ICP.ContactLastName)),64) , -- ContactLastName - varchar(64)
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
									WHERE LTRIM(RTRIM(ICP.InsuranceCompanyName)) = LTRIM(RTRIM(InsuranceCompanyName)) AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
LEFT JOIN dbo.InsuranceCompanyPlan imp ON
	ICP.insuranceid = imp.VendorID
WHERE imp.InsuranceCompanyPlanID IS NULL AND ICP.insurancecompanyname NOT LIKE 'zz%'
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
	CASE WHEN LEN(IICL.insurancecompanyname) > 1 THEN LEFT(LTRIM(RTRIM(IICL.insurancecompanyname)),128)
		 ELSE LEFT(LTRIM(RTRIM(IICL.planname)),128) END  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	19 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	CASE scope WHEN 1 THEN 'R' ELSE '' END , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	19 , -- SecondaryPrecedenceBillingFormID - int
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN LTRIM(RTRIM(IICL.insurancecompanyname))
		ELSE LTRIM(RTRIM(IICL.planname)) END,50) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_2_1_InsuranceCOMPANYPLANList AS IICL
WHERE ( insurancecompanyname <> '' OR planname <> '') AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE LTRIM(RTRIM(InsuranceCompanyName)) = LTRIM(RTRIM(IICL.InsuranceCompanyName)) AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID) )
    AND IICL.insurancecompanyname NOT LIKE 'zz%'

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
	CASE WHEN ICP.planname <> '' THEN LEFT(LTRIM(RTRIM(ICP.planname)),128)
		 ELSE LEFT(LTRIM(RTRIM(ICP.InsuranceCompanyName)),128) END  , -- PlanName - varchar(128)
	LEFT(LTRIM(RTRIM(ICP.Address1)),256) , -- AddressLine1 - varchar(256)
	LEFT(LTRIM(RTRIM(ICP.Address2)),256) , -- AddressLine2 - varchar(256)
	UPPER(LEFT(LTRIM(RTRIM(ICP.[State])),2)), -- City - varchar(128)
	LEFT(LTRIM(RTRIM(ICP.[State])),2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
	ELSE '' END , -- ZipCode - varchar(9)
	LEFT(LTRIM(RTRIM(ICP.ContactFirstName)),64) , -- ContactFirstName - varchar(64)
	LEFT(LTRIM(RTRIM(ICP.ContactLastName)),64) , -- ContactLastName - varchar(64)
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
	IC.VendorID = LEFT(LTRIM(RTRIM(ICP.InsuranceCompanyName)), 50) AND
	LTRIM(RTRIM(ICP.Insurancecompanyname)) = LTRIM(RTRIM(IC.InsuranceCompanyName)) AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.Insuranceid = OICP.VendorID AND
	OICP.VendorImportID IN (1,@VendorImportID)
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL AND
	  ICP.insurancecompanyname NOT LIKE 'zz%'
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
	LEFT(LTRIM(RTRIM(PD.suffix)), 16) , -- Suffix
	LEFT(LTRIM(RTRIM(PD.firstname)),64) , -- FirstName - varchar(64)
	LEFT(LTRIM(RTRIM(PD.middleinitial)),64) , -- MiddleName - varchar(64)
	LEFT(LTRIM(RTRIM(PD.lastname)),64) , -- LastName - varchar(64)
	LEFT(LTRIM(RTRIM(PD.address1)),256) , -- AddressLine1 - varchar(256)
	LEFT(LTRIM(RTRIM(PD.address2)),256) , -- AddressLine2 - varchar(256)
	LEFT(LTRIM(RTRIM(PD.city)),128) , -- City - varchar(128)
	UPPER(LEFT(LTRIM(RTRIM(PD.[state])),2)) , -- State - varchar(2)
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
		WHEN PD.maritalstatus IN ('A','Annulled') THEN 'A'
		WHEN PD.maritalstatus IN ('I','Interlocutory') THEN 'I'
		WHEN PD.maritalstatus IN ('L','Legally Separated') THEN 'L'
		WHEN PD.maritalstatus IN ('P','Polygamous') THEN 'P'
		WHEN PD.maritalstatus IN ('T','Domestic Parner') THEN 'T'
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
		WHEN ISDATE(PD.dateofbirth) = 1 THEN DATEADD(hh,12,CAST(PD.dateofbirth AS DATETIME))
		ELSE '1901-01-01 12:00:00.000' END , -- DOB - datetime
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.SSN)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(PD.SSN), 9)
		ELSE NULL END , -- SSN - char(9)
	LEFT(LTRIM(RTRIM(PD.email)),256) , -- EmailAddress - varchar(256)
	CASE WHEN REPLACE(PD.responsiblepartyfirstname,' ','') <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
	CASE WHEN PD.responsiblepartyfirstname <> '' THEN '' END , -- ResponsiblePrefix - varchar(16)
	CASE WHEN PD.responsiblepartyfirstname <> '' THEN LEFT(LTRIM(RTRIM(PD.responsiblepartyfirstname)), 64) END , -- ResponsibleFirstName - varchar(64)
	CASE WHEN PD.responsiblepartyfirstname <> '' THEN LEFT(LTRIM(RTRIM(PD.responsiblepartymiddlename)), 64) END , -- ResponsibleMiddleName - varchar(64)
	CASE WHEN PD.responsiblepartyfirstname <> '' THEN LEFT(LTRIM(RTRIM(PD.responsiblepartylastname)), 64) END , -- ResposibleLastName - varchar(64)
	CASE WHEN pd.responsiblepartyfirstname <> '' THEN LEFT(LTRIM(RTRIM(PD.responsiblepartysuffix)), 16) END , -- ResponsibleSuffix - varchar(16)
	CASE WHEN pd.responsiblepartyfirstname <> '' THEN CASE 
														   WHEN PD.responsiblepartyrelationship IN ('C','Child') THEN 'C'
														   WHEN PD.responsiblepartyrelationship IN ('U','Spouse') THEN 'U'
														   WHEN PD.responsiblepartyrelationship IN ('O','Other') THEN 'O'
													  ELSE 'O' END
	ELSE NULL END , -- ResponsibleRelationshipToPatient (char)
	CASE WHEN PD.responsiblepartyaddress1 <> '' THEN LEFT(LTRIM(RTRIM(PD.responsiblepartyaddress1)), 256) END , -- ResponsibleAddressLine1 - varchar(256)
	CASE WHEN PD.responsiblepartyaddress2 <> '' THEN LEFT(LTRIM(RTRIM(PD.responsiblepartyaddress2)), 256) END , -- ResponsibleAddressLine2 - varchar(256)
	CASE WHEN PD.responsiblepartycity <> '' THEN LEFT(LTRIM(RTRIM(PD.responsiblepartycity)), 128) END , -- ResponsibleCity - varchar(128) 
	CASE WHEN PD.responsiblepartystate <> '' THEN LEFT(LTRIM(RTRIM(PD.responsiblepartystate)), 2) END , -- ResponsibleState - varchar(2)
	CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.responsiblepartyzipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(PD.responsiblepartyzipcode)
		 WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.responsiblepartyzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(PD.zipcode)
	ELSE NULL END , -- ResponsibleZipCode - varchar(9)
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
	LEFT(LTRIM(RTRIM(PD.chartnumber)),128) , -- MedicalRecordNumber - varchar(128)
	CASE
		WHEN LEN(PD.cellphone) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.cellphone),10)
		ELSE '' END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.cellphone)) > 10 THEN LEFT(SUBSTRING(PD.cellphone,11,LEN(PD.cellphone)),10)
		ELSE NULL END , -- MobilePhoneExt - varchar(10)
	PrimaryCare.DoctorID , -- PrimaryCarePhysicianID - int 
	PD.chartnumber , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	@DefaultCollectionCategory , -- CollectionCategoryID - int
	CASE 
		WHEN PD.Active IN ('0','No','N','Inactive') THEN 0
		ELSE 1 END, -- Active - bit
	0 , -- SendEmailCorrespondence - bit
	0 ,  -- PhonecallRemindersEnabled - bit
	LEFT(LTRIM(RTRIM(PD.EmergencyName)),128) , -- EmergencyName - varchar(128)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphone),10)
		ELSE '' END , -- EmergencyPhone - varchar(10)
	LEFT(LTRIM(RTRIM(PD.Emergencyphoneext)),10) -- EmergencyPhoneExt - varchar(10)
FROM dbo._import_2_1_PatientDemographics AS PD
LEFT JOIN dbo.Doctor AS ReferringDoc ON 
		ReferringDoc.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS RD WHERE LTRIM(RTRIM(RD.FirstName)) = LTRIM(RTRIM(PD.ReferringPhysicianFirstName)) AND 
										LTRIM(RTRIM(RD.LastName)) = LTRIM(RTRIM(PD.ReferringPhysicianLastName)) AND RD.PracticeID = @PracticeID AND RD.ActiveDoctor = 1)
LEFT JOIN dbo.Doctor AS PrimaryProvider ON 
		LTRIM(RTRIM(PrimaryProvider.FirstName)) = LTRIM(RTRIM(PD.PrimaryProviderFirstName)) AND 
		LTRIM(RTRIM(PrimaryProvider.LastName)) = LTRIM(RTRIM(PD.PrimaryProviderLastName)) AND 
		PrimaryProvider.[External] = 0 AND 
		PrimaryProvider.PracticeID = @PracticeID AND
		PrimaryProvider.ActiveDoctor = 1
LEFT JOIN dbo.Doctor AS PrimaryCare ON 
	PrimaryCare.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS PC WHERE LTRIM(RTRIM(PC.FirstName)) = LTRIM(RTRIM(PD.primarycarephysicianfirstname)) AND 
								LTRIM(RTRIM(PC.LastName)) = LTRIM(RTRIM(PD.Primarycarephysicianlastname)) AND PC.PracticeID = @PracticeID AND PC.ActiveDoctor = 1)
LEFT JOIN dbo.ServiceLocation AS SL ON SL.Name = PD.defaultservicelocation
LEFT JOIN dbo.ServiceLocation AS SL2 ON 1 = 1 AND SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID) 
LEFT JOIN dbo.Employers AS E ON E.EmployerID = (SELECT MAX(E2.EmployerID) FROM dbo.Employers E2 WHERE E2.EmployerName = LEFT(LTRIM(RTRIM(PD.employername)),128) AND LTRIM(RTRIM(E2.AddressLine1)) = LEFT(LTRIM(RTRIM(PD.employeraddress1)),256) AND LTRIM(RTRIM(E2.[State])) = LEFT(LTRIM(RTRIM(PD.employerstate)),2))
LEFT JOIN dbo.Patient AS P ON p.FirstName = pd.firstname AND p.LastName = pd.lastname AND p.DOB = DATEADD(hh,12,CAST(pd.dateofbirth AS DATETIME))
WHERE PD.firstname <> '' AND PD.lastname <> '' AND p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


/*l
==========================================================================================================================================
CREATE PATIENT CASES
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into Patient Case...'
IF NOT EXISTS (SELECT * FROM dbo.PayerScenario WHERE Name = 'Commercial')
BEGIN

	INSERT INTO dbo.PayerScenario
			( Name ,
			PayerScenarioTypeID ,
			StatementActive
			)
	VALUES  ( 'Commercial' , -- Name - varchar(128)
			1 , -- PayerScenarioTypeID - int
			1  -- StatementActive - bit
			)
END

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
INNER JOIN dbo.Patient AS PAT ON VendorImportID = @VendorImportID AND VendorID = pd.chartnumber
LEFT JOIN dbo.PatientCase PC ON PAT.PatientID = PC.PatientID AND PC.Name = pd.defaultcase
WHERE PC.PatientCaseID IS NULL
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
	PatientRelationshipToInsured VARCHAR(25), 
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
	Employer VARCHAR(128),
	PolicyNote VARCHAR(8000)
)


INSERT INTO #tempPolicies
( 
	InsuranceColumnCount , PatientVendorID , InsuranceCode, PolicyNumber , GroupNumber , PolicyStartDate , 
	PolicyEndDate , Copay, Deductible, PatientRelationshipToInsured, HolderLastName , HolderMiddleName , 
	HolderFirstName , HolderStreet1 , HolderStreet2 , HolderCity , HolderState , HolderZipCode , HolderSSN , 
	HolderDOB , HolderGender , Employer , PolicyNote
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
	Employer,
	PolicyNote
FROM
(	SELECT DISTINCT 
		1 AS InsuranceColumnCount, chartnumber AS PatientVendorID, InsuranceCode1 AS InsuranceCode, 
		policynumber1 AS PolicyNumber, groupnumber1 AS GroupNumber, CASE WHEN ISDATE(policy1startdate) = 1 
		THEN policy1startdate ELSE NULL END AS PolicyStartDate, CASE WHEN ISDATE(policy1enddate) = 1 THEN policy1enddate 
		ELSE NULL END AS PolicyEndDate, policy1copay AS Copay, policy1deductible AS Deductible,  patientrelationship1 AS 
		PatientRelationshipToInsured, holder1lastname AS HolderLastName, Holder1middlename AS HolderMiddleName, 
		Holder1firstname AS HolderFirstName, Holder1street1 AS HolderStreet1, holder1street2 AS HolderStreet2, 
		holder1city AS HolderCity, holder1state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder1zipcode) AS 
		HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder1ssn) AS holderSSN, CASE WHEN 
		ISDATE(Holder1dateofbirth) = 1 THEN Holder1dateofbirth ELSE NULL END AS HolderDOB, CASE WHEN Holder1gender IN 
		('M','Male') THEN 'M' WHEN Holder1gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		Employer1 AS Employer, Policy1Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE insurancecode1 <> ''
	
	UNION
  	
	SELECT DISTINCT 
		2 AS InsuranceColumnCount, chartnumber AS PatientVendorID, InsuranceCode2 AS InsuranceCode, 
		policynumber2 AS PolicyNumber, groupnumber2 AS GroupNumber, CASE WHEN ISDATE(policy2startdate) = 1 
		THEN policy2startdate ELSE NULL END AS PolicyStartDate, CASE WHEN ISDATE(policy2enddate) = 1 THEN policy2enddate 
		ELSE NULL END AS PolicyEndDate, policy2copay AS Copay, policy2deductible AS Deductible,  patientrelationship2 AS
		PatientRelationshipToInsured, holder2lastname AS HolderLastName, Holder2middlename AS HolderMiddleName, 
		Holder2firstname AS HolderFirstName, Holder2street1 AS HolderStreet1, holder2street2 AS HolderStreet2, 
		holder2city AS HolderCity, holder2state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder2zipcode) 
		AS HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder2ssn) AS holderSSN, CASE WHEN 
		ISDATE(Holder2dateofbirth) = 1 THEN Holder2dateofbirth ELSE NULL END AS HolderDOB, CASE WHEN Holder2gender IN 
		('M','Male') THEN 'M' WHEN Holder2gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		Employer2 AS Employer, Policy2Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE insurancecode2 <> ''  
	
	UNION
  	
	SELECT DISTINCT 
		3 AS InsuranceColumnCount, chartnumber AS PatientVendorID, InsuranceCode3 AS InsuranceCode, 
		policynumber3 AS PolicyNumber, groupnumber3 AS GroupNumber, CASE WHEN ISDATE(policy3startdate) = 1 
		THEN policy3startdate ELSE NULL END AS PolicyStartDate, CASE WHEN ISDATE(policy3enddate) = 1 THEN policy3enddate 
		ELSE NULL END AS PolicyEndDate, policy3copay AS Copay, policy3deductible AS Deductible,  patientrelationship3 AS
		PatientRelationshipToInsured, holder3lastname AS HolderLastName, Holder3middlename AS HolderMiddleName, 
		Holder3firstname AS HolderFirstName, Holder3street1 AS HolderStreet1, holder3street2 AS HolderStreet2, 
		holder3city AS HolderCity, holder3state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder3zipcode) 
		AS HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder3ssn) AS holderSSN, CASE WHEN 
		ISDATE(Holder3dateofbirth) = 1 THEN Holder3dateofbirth ELSE NULL END AS HolderDOB, CASE WHEN Holder3gender IN 
		('M','Male') THEN 'M' WHEN Holder3gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		Employer3 AS Employer, Policy3Note AS PolicyNote
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
	LEFT(LTRIM(RTRIM(TP.PolicyNumber)),32), -- PolicyNumber - varchar(32)
	LEFT(LTRIM(RTRIM(TP.GroupNumber)),32), -- GroupNumber - varchar(32)
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
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(LTRIM(RTRIM(TP.HolderFirstName)),64) END, -- HolderFirstName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(LTRIM(RTRIM(TP.HolderMiddleName)),64) END, -- HolderMiddleName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(LTRIM(RTRIM(TP.HolderLastName)),64) END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(HolderDOB) = 1 AND HolderDOB <> '1/1/1900' THEN HolderDOB ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(HolderSSN)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(HolderSSN),9) ELSE NULL END END, -- HolderSSN
	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
	CASE WHEN TP.Employer <> '' THEN LTRIM(RTRIM(TP.Employer)) END , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE HolderGender END, -- HolderGender - char(1)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(LTRIM(RTRIM(HolderStreet1)),256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(LTRIM(RTRIM(HolderStreet2)),256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(LTRIM(RTRIM(HolderCity)),128) END, -- HolderCity - varchar(128)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(LTRIM(RTRIM(HolderState)),2)) END, -- HolderState
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(HolderZipCode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(HolderZipCode)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(HolderZipCode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(HolderZipCode)
		ELSE '' END END, -- HolderZipCode - varchar(9)
	'', -- HolderPhone - varchar(10)
	'' , -- HolderPhoneExt - varchar(10)
	CASE WHEN TP.PatientRelationshipToInsured <> '' THEN LEFT(LTRIM(RTRIM(TP.PolicyNumber)), 32) ELSE '' END , -- DependentPolicyNumber - varchar(32)
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
	INNER JOIN dbo.Patient AS PAT ON VendorImportID = @VendorImportID AND VendorID = PatientVendorID
	INNER JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (1,@VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Updating Patient Case - Self Pay...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = PS.PayerScenarioID ,
		NAME = 'Self Pay'
FROM dbo.PatientCase pc
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.PracticeID = @PracticeID	
INNER JOIN dbo.PayerScenario PS ON
	PS.Name = 'Self Pay'
WHERE 
	pc.VendorImportID = @VendorImportID AND 
	pc.PracticeID = @PracticeID AND
	pc.PayerScenarioID <> ps.PayerScenarioID AND
	ip.InsurancePolicyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

PRINT ''
PRINT 'Updating Existing Appointments with VendorID...'
UPDATE dbo.Appointment 
SET [Subject] = i.[subject]
FROM dbo.Appointment a 
INNER JOIN dbo.Patient p ON
a.PatientID = p.PatientID AND 
p.PracticeID = @PracticeID
INNER JOIN dbo._import_2_1_PatientAppointmentsFirst i ON 
a.StartDate = CAST(i.startdate AS DATETIME) AND
a.EndDate = CAST(i.enddate AS DATETIME) AND 
p.VendorID = i.chartnumber
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Appointment...'
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
	FROM dbo._import_2_1_PatientAppointments PA
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
	LEFT JOIN dbo.Appointment a ON 
		PA.[subject] = a.[Subject]
WHERE a.AppointmentID IS NULL AND PA.[disabled] = '0'
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
			  APP.AppointmentID , -- AppointmentID - int
	          AR.AppointmentReasonID , -- AppointmezntReasonID - int
	          1 , -- PrimaryAppointment - bit
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo._import_2_1_PatientAppointments PA
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
WHERE app.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
  
PRINT ''
PRINT 'Inserting Into Appointment to Resource - Practice Resource...'	
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
WHERE app.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
    
PRINT ''
PRINT 'Inserting Into Appointmenr to Resource - Practice Resource...'
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
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		APP.PatientID = PAT.PatientID AND 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime)       
	INNER JOIN dbo.PracticeResource PR ON
		PR.ResourceName = PA.PracticeResource AND
		PR.PracticeID = @PracticeID  
WHERE app.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Updating Insurance Policies - Primary...'
UPDATE dbo.InsurancePolicy 
	SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID , 
		PolicyNumber = i.policynumber1 ,
		GroupNumber = i.groupnumber1 , 
		PolicyStartDate = CASE WHEN ISDATE(i.policy1startdate) = 1 THEN i.policy1startdate END , 
		PolicyEndDate = CASE WHEN ISDATE(i.policy1enddate) = 1 THEN i.policy1enddate END , 
		CreatedDate = GETDATE() , 
		ModifiedDate = GETDATE()
FROM dbo.InsurancePolicy ip
INNER JOIN dbo._import_2_1_PatientDemographics i ON
	ip.VendorID = i.chartnumber AND 
	ip.VendorImportID = 1 
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.insurancecode1 = icp.VendorID 
WHERE ip.Precedence = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

PRINT ''
PRINT 'Updating Insurance Policies - Secondary...'
UPDATE dbo.InsurancePolicy 
	SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID , 
		PolicyNumber = i.policynumber2 ,
		GroupNumber = i.groupnumber2 , 
		PolicyStartDate = CASE WHEN ISDATE(i.policy2startdate) = 1 THEN i.policy2startdate END , 
		PolicyEndDate = CASE WHEN ISDATE(i.policy2enddate) = 1 THEN i.policy2enddate END ,
		CreatedDate = GETDATE() , 
		ModifiedDate = GETDATE()
FROM dbo.InsurancePolicy ip
INNER JOIN dbo._import_2_1_PatientDemographics i ON
	ip.VendorID = i.chartnumber AND 
	ip.VendorImportID = 1 
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.insurancecode2 = icp.VendorID 
WHERE ip.Precedence = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

PRINT ''
PRINT 'Updating Insurance Policies - Tertiary...'
UPDATE dbo.InsurancePolicy 
	SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID , 
		PolicyNumber = i.policynumber3 ,
		GroupNumber = i.groupnumber3 , 
		PolicyStartDate = CASE WHEN ISDATE(i.policy3startdate) = 1 THEN i.policy3startdate END , 
		PolicyEndDate = CASE WHEN ISDATE(i.policy3enddate) = 1 THEN i.policy3enddate END ,
		CreatedDate = GETDATE() , 
		ModifiedDate = GETDATE()
FROM dbo.InsurancePolicy ip
INNER JOIN dbo._import_2_1_PatientDemographics i ON
	ip.VendorID = i.chartnumber AND 
	ip.VendorImportID = 1 
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.insurancecode3 = icp.VendorID 
WHERE ip.Precedence = 3
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

PRINT ''
PRINT 'Updating Patient Case - CreatedDate...'
UPDATE dbo.PatientCase 
	SET CreatedDate = GETDATE() , 
		ModifiedDate = GETDATE() 
FROM dbo.PatientCase pc 
	INNER JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND
		ip.PracticeID = @PracticeID
WHERE pc.VendorImportID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

PRINT ''
PRINT 'Updating Patient - CreatedDate...'
UPDATE dbo.Patient 
	SET CreatedDate = GETDATE() , 
		ModifiedDate = GETDATE()
FROM dbo.Patient p 
	INNER JOIN dbo.PatientCase pc ON 
		p.PatientID = pc.PatientID AND 
		pc.VendorImportID = 1
WHERE pc.ModifiedDate > DATEADD(s,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

--ROLLBACK
--COMMIT
