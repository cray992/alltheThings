--USE superbill_49117_dev
USE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @NewVendorImportID INT
DECLARE @VendorImportID1 INT
DECLARE @VendorImportID2 INT
DECLARE @VendorImportID3 INT
DECLARE @VendorImportID4 INT
DECLARE @DefaultCollectionCategory INT

SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)
SET @PracticeID = 1
SET @NewVendorImportID = 8
SET @VendorImportID1 = 0
SET @VendorImportID2 = 5
SET @VendorImportID3 = 6
SET @VendorImportID4 = 7

SET NOCOUNT ON 

/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo.[_import_17_1_PatientDemographics] i ON p.PatientID = i.id

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  ,
--		SSN = i.ssn
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated - Db13' 
--DROP TABLE #updatepat 

/*==========================================================================*/


CREATE TABLE #temppat (personid VARCHAR(50) , FirstName VARCHAR(64) , LastName VARCHAR(64) , mrn VARCHAR(50) , dateofbirth DATETIME ,
					   address1 VARCHAR(256) , address2 VARCHAR(256) , city VARCHAR(128) , [state] VARCHAR(2) , zipcode VARCHAR(9) , 
					   maritalstatus VARCHAR(1) , homephone VARCHAR(10) , workphone VARCHAR(10) ,  
					   ssn CHAR(9) , email VARCHAR(256) , cellphone VARCHAR(10) , ResponsiblePartyFirstName 
					   VARCHAR(64) , ResponsiblePartyLastName VARCHAR(64), ResponsiblePartyMiddleName VARCHAR(64), 
					   ResponsiblePartyAddress1 VARCHAR(256), ResponsiblePartyAddress2 VARCHAR(256) , ResponsiblePartyCity VARCHAR(256) ,
					   ResponsiblePartyState VARCHAR(2) , ResponsiblePartyZipCode VARCHAR(9))


INSERT INTO	#temppat
        ( personid , FirstName , LastName , mrn , dateofbirth , address1 , address2 , city , [state] , zipcode , 
		  maritalstatus , homephone , workphone , ssn , email , cellphone , ResponsiblePartyFirstName , 
		  ResponsiblePartyLastName , ResponsiblePartyMiddleName , ResponsiblePartyAddress1 , ResponsiblePartyAddress2 , 
		  ResponsiblePartyCity , ResponsiblePartyState , ResponsiblePartyZipCode ) 
SELECT DISTINCT    
		  i.personid , -- personid - varchar(50)
          i.firstname , -- FirstName - varchar(64)
          i.lastname , -- LastName - varchar(64)
		  i.medrecnbrchartnumber , 
		  CASE WHEN ISDATE(i.dateofbirth) = 1 THEN DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) ELSE '1901-01-01 12:00:00.000' END , 
		  i.address1  , 
		  i.address1 , 
		  i.city , 
		  i.[state] , 
		  i.zip ,
		  i.maritalstatus , 
		  i.homephone , 
		  i.WorkPhone , 
		  i.ssn ,
		  i.email , 
		  i.cellphone , 
		  i.responsiblepartyfirstname , 
		  i.ResponsiblePartyLastName , 
		  i.ResponsiblePartyMiddleName , 
		  i.ResponsiblePartyAddress1 , 
		  i.ResponsiblePartyAddress2 , 
		  i.ResponsiblePartyCity , 
		  i.ResponsiblePartyState , 
		  i.ResponsiblePartyZipCode 
FROM dbo.[_import_14_1_491171PatientDemoUpdate1] i

UNION

SELECT DISTINCT    
		  i.personid , -- personid - varchar(50)
          i.firstname , -- FirstName - varchar(64)
          i.lastname , -- LastName - varchar(64)
		  i.medrecnbrchartnumber , 
		  CASE WHEN ISDATE(i.dateofbirth) = 1 THEN DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) ELSE '1901-01-01 12:00:00.000' END , 
		  i.address1  , 
		  i.address1 , 
		  i.city , 
		  i.[state] , 
		  i.zip ,
		  i.maritalstatus , 
		  i.homephone , 
		  i.WorkPhone , 
		  i.ssn ,
		  i.email , 
		  i.cellphone , 
		  i.responsiblepartyfirstname , 
		  i.ResponsiblePartyLastName , 
		  i.ResponsiblePartyMiddleName , 
		  i.ResponsiblePartyAddress1 , 
		  i.ResponsiblePartyAddress2 , 
		  i.ResponsiblePartyCity , 
		  i.ResponsiblePartyState , 
		  i.ResponsiblePartyZipCode 
FROM dbo.[_import_17_1_491171PatientDemoUpdate2] i

PRINT ''
PRINT 'Updating Existing Patients with Demographic Info from Most Recent Export from NGProd...'
UPDATE dbo.Patient 
	SET AddressLine1 = CASE WHEN i.address1 <> p.AddressLine1 THEN i.address1 ELSE p.AddressLine1 END ,
		AddressLine2 = CASE WHEN i.address2 <> p.AddressLine2 THEN i.address1 ELSE p.AddressLine2 END ,
		City = CASE WHEN i.city <> p.City THEN i.city ELSE p.City END ,
		[State] = CASE WHEN i.[state] <> p.[state] THEN i.[state] ELSE p.[state] END ,
		ZipCode = CASE WHEN i.zipcode <> p.ZipCode THEN i.zipcode ELSE p.ZipCode END ,
		MaritalStatus = CASE WHEN i.maritalstatus <> p.maritalstatus THEN i.maritalstatus ELSE p.maritalstatus END ,
		HomePhone = CASE WHEN i.homephone <> p.homephone THEN i.homephone ELSE p.homephone END ,
		WorkPhone = CASE WHEN i.WorkPhone <> p.WorkPhone THEN i.WorkPhone ELSE p.WorkPhone END ,
		SSN = CASE WHEN i.ssn <> p.SSN THEN i.ssn ELSE p.SSN END ,
		EmailAddress = CASE WHEN i.email <> p.EmailAddress THEN i.email ELSE p.EmailAddress END ,
		MobilePhone = CASE WHEN i.cellphone <> p.MobilePhone THEN i.cellphone ELSE p.MobilePhone END ,
		ResponsibleFirstName = CASE WHEN i.ResponsiblePartyFirstName <> p.ResponsibleFirstName THEN i.ResponsiblePartyFirstName ELSE p.ResponsibleFirstName END ,
		ResponsibleLastName = CASE WHEN i.ResponsiblePartyLastName <> p.ResponsibleLastName THEN i.ResponsiblePartyLastName ELSE p.ResponsibleLastName END ,
		ResponsibleMiddleName = CASE WHEN i.ResponsiblePartyMiddleName <> p.ResponsibleMiddleName THEN i.ResponsiblePartyMiddleName ELSE p.ResponsibleMiddleName END ,
		ResponsibleAddressLine1 = CASE WHEN i.ResponsiblePartyAddress1 <> p.ResponsibleAddressLine1 THEN i.ResponsiblePartyAddress1 ELSE p.ResponsibleAddressLine1 END ,
		ResponsibleAddressLine2 = CASE WHEN i.ResponsiblePartyAddress2 <> p.ResponsibleAddressLine2 THEN i.ResponsiblePartyAddress2 ELSE p.ResponsibleAddressLine2 END ,
		ResponsibleCity = CASE WHEN i.ResponsiblePartyCity <> p.ResponsibleCity THEN i.ResponsiblePartyCity ELSE p.ResponsibleCity END ,
		ResponsibleState = CASE WHEN i.ResponsiblePartyState <> p.ResponsibleState THEN i.ResponsiblePartyState ELSE p.ResponsibleState END ,
		ResponsibleZipCode = CASE WHEN i.ResponsiblePartyZipCode <> p.ResponsibleZipCode THEN i.ResponsiblePartyZipCode ELSE p.ResponsibleZipCode END ,
		ResponsibleDifferentThanPatient = CASE WHEN i.ResponsiblePartyFirstName <> '' THEN 1 ELSE p.ResponsibleDifferentThanPatient END ,
		ResponsibleRelationshipToPatient = CASE WHEN p.ResponsibleDifferentThanPatient = 1 THEN 'O' ELSE NULL END
FROM dbo.Patient p 
	INNER JOIN #temppat i ON 
		p.VendorID = i.personid AND 
		p.PracticeID = @PracticeID AND 
        p.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' as records updated'

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
( 
	PracticeID , ReferringPhysicianID , Prefix, Suffix, FirstName , MiddleName , LastName , AddressLine1 , AddressLine2 , City , State , ZipCode , Gender , 
	MaritalStatus , HomePhone , HomePhoneExt , WorkPhone , WorkPhoneExt , DOB , SSN , EmailAddress , ResponsibleDifferentThanPatient , ResponsiblePrefix, ResponsibleFirstName,
	ResponsibleMiddleName, ResponsibleLastName, ResponsibleSuffix, ResponsibleRelationshipToPatient, ResponsibleAddressLine1, ResponsibleAddressline2, ResponsibleCity, ResponsibleState,
	ResponsibleZipCode, CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , EmploymentStatus , PrimaryProviderID , EmployerID , MedicalRecordNumber , 
	MobilePhone , MobilePhoneExt , PrimaryCarePhysicianID , VendorID , VendorImportID , CollectionCategoryID , Active , SendEmailCorrespondence , 
	PhonecallRemindersEnabled, EmergencyName, EmergencyPhone, EmergencyPhoneExt
)
SELECT DISTINCT
	@PracticeID , -- PracticeID - int
	ReferringDoc.DoctorID , -- ReferringPhysicianID - int
	'' , -- Prefix 
	'' , -- Suffix
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
	pd.maritalstatus , -- MaritalStatus - varchar(1)
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
	CASE WHEN PD.responsiblepartyfirstname  <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
	'' , -- ResponsiblePrefix - varchar(16)
	LEFT(PD.responsiblepartyfirstname, 64) , -- ResponsibleFirstName - varchar(64)
	LEFT(PD.responsiblepartymiddlename, 64) , -- ResponsibleMiddleName - varchar(64)
	LEFT(PD.responsiblepartylastname, 64) , -- ResposibleLastName - varchar(64)
	LEFT(PD.responsiblepartysuffix, 16) , -- ResponsibleSuffix - varchar(16)
	CASE WHEN pd.responsiblepartyfirstname <> '' THEN 'O'
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
	E.EmployerID, -- EmployerID - int 
	LEFT(PD.medrecnbrchartnumber,128) , -- MedicalRecordNumber - varchar(128)
	CASE
		WHEN LEN(PD.cellphone) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.cellphone),10)
		ELSE '' END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.cellphone)) > 10 THEN LEFT(SUBSTRING(PD.cellphone,11,LEN(PD.cellphone)),10)
		ELSE NULL END , -- MobilePhoneExt - varchar(10)
	PrimaryCare.DoctorID , -- PrimaryCarePhysicianID - int 
	PD.personid , -- VendorID - varchar(50)
	@NewVendorImportID , -- VendorImportID - int
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
FROM dbo.[_import_14_1_491171PatientDemoUpdate1] AS PD
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
	LEFT JOIN dbo.Employers AS E ON E.EmployerID = (SELECT TOP 1 E2.EmployerID FROM dbo.Employers E2 WHERE E2.EmployerName = LEFT(PD.employername,128) AND E2.AddressLine1 = LEFT(PD.employeraddress1,256) AND E2.State = LEFT(PD.employerstate,2))
	LEFT JOIN dbo.Patient p ON PD.personid = p.VendorID AND p.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
WHERE PD.firstname <> '' AND PD.lastname <> '' AND p.PatientID IS NULL

UNION 

SELECT DISTINCT
	@PracticeID , -- PracticeID - int
	ReferringDoc.DoctorID , -- ReferringPhysicianID - int
	'' , -- Prefix 
	'' , -- Suffix
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
	pd.maritalstatus , -- MaritalStatus - varchar(1)
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
	CASE WHEN PD.responsiblepartyfirstname  <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
	'' , -- ResponsiblePrefix - varchar(16)
	LEFT(PD.responsiblepartyfirstname, 64) , -- ResponsibleFirstName - varchar(64)
	LEFT(PD.responsiblepartymiddlename, 64) , -- ResponsibleMiddleName - varchar(64)
	LEFT(PD.responsiblepartylastname, 64) , -- ResposibleLastName - varchar(64)
	LEFT(PD.responsiblepartysuffix, 16) , -- ResponsibleSuffix - varchar(16)
	CASE WHEN pd.responsiblepartyfirstname <> '' THEN 'O'
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
	E.EmployerID, -- EmployerID - int 
	LEFT(PD.medrecnbrchartnumber,128) , -- MedicalRecordNumber - varchar(128)
	CASE
		WHEN LEN(PD.cellphone) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.cellphone),10)
		ELSE '' END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.cellphone)) > 10 THEN LEFT(SUBSTRING(PD.cellphone,11,LEN(PD.cellphone)),10)
		ELSE NULL END , -- MobilePhoneExt - varchar(10)
	PrimaryCare.DoctorID , -- PrimaryCarePhysicianID - int 
	PD.personid , -- VendorID - varchar(50)
	@NewVendorImportID , -- VendorImportID - int
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
FROM dbo.[_import_17_1_491171PatientDemoUpdate2] AS PD
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
	LEFT JOIN dbo.Employers AS E ON E.EmployerID = (SELECT TOP 1 E2.EmployerID FROM dbo.Employers E2 WHERE E2.EmployerName = LEFT(PD.employername,128) AND E2.AddressLine1 = LEFT(PD.employeraddress1,256) AND E2.State = LEFT(PD.employerstate,2))
	LEFT JOIN dbo.Patient p ON PD.personid = p.VendorID AND p.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
WHERE PD.firstname <> '' AND PD.lastname <> '' AND p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted' 

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
	'Self Pay' , -- Name - varchar(128)
	1 , -- Active - bit
	11 , -- PayerScenarioID - int
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
	@NewVendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.[_import_14_1_491171PatientDemoUpdate1] pd
	INNER JOIN dbo.Patient AS PAT ON pat.VendorImportID = @NewVendorImportID AND pat.VendorID = pd.personid
	LEFT JOIN dbo.PatientCase pc ON PAT.PatientID = pc.PatientID AND pc.PracticeID = @PracticeID
WHERE pc.PatientCaseID IS NULL

UNION

SELECT DISTINCT 
	PAT.PatientID , -- PatientID - int
	'Self Pay' , -- Name - varchar(128)
	1 , -- Active - bit
	11 , -- PayerScenarioID - int
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
	@NewVendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.[_import_17_1_491171PatientDemoUpdate2] pd
	INNER JOIN dbo.Patient AS PAT ON pat.VendorImportID = @NewVendorImportID AND pat.VendorID = pd.personid
	LEFT JOIN dbo.PatientCase pc ON PAT.PatientID = pc.PatientID AND pc.PracticeID = @PracticeID
WHERE pc.PatientCaseID IS NULL
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
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          'Church: ' + i.patchurchnote , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_14_1_491171PatientDemoUpdate1] i 
INNER JOIN dbo.Patient p ON
	i.personid = p.VendorID AND 
	p.VendorImportID = @NewVendorImportID
WHERE i.patchurchnote <> ''

UNION

SELECT DISTINCT
		  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          'Church: ' + i.patchurchnote , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_17_1_491171PatientDemoUpdate2] i 
INNER JOIN dbo.Patient p ON
	i.personid = p.VendorID AND 
	p.VendorImportID = @NewVendorImportID
WHERE i.patchurchnote <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE INSURANCE POLICIES 1 OF 2
==========================================================================================================================================
*/

CREATE TABLE #tempPolicies1
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


INSERT INTO #tempPolicies1
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
		1 AS InsuranceColumnCount, personid AS PatientVendorID, InsuranceCode1 AS InsuranceCode, 
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
	FROM dbo.[_import_14_1_491171PatientDemoUpdate1]
	WHERE insurancecode1 <> ''
	
	UNION
  	
	SELECT DISTINCT 
		2 AS InsuranceColumnCount, personid AS PatientVendorID, InsuranceCode2 AS InsuranceCode, 
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
	FROM dbo.[_import_14_1_491171PatientDemoUpdate1]
	WHERE insurancecode2 <> ''  
	
	UNION
  	
	SELECT DISTINCT 
		3 AS InsuranceColumnCount, personid AS PatientVendorID, InsuranceCode3 AS InsuranceCode, 
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
	FROM dbo.[_import_14_1_491171PatientDemoUpdate1]
	WHERE  insurancecode3 <> ''  
) AS Y
ORDER BY InsuranceColumnCount


/*
==========================================================================================================================================
CREATE INSURANCE POLICIES 2 OF 2
==========================================================================================================================================
*/

CREATE TABLE #tempPolicies2
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


INSERT INTO #tempPolicies2
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
		1 AS InsuranceColumnCount, personid AS PatientVendorID, InsuranceCode1 AS InsuranceCode, 
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
	FROM dbo.[_import_17_1_491171PatientDemoUpdate2]
	WHERE insurancecode1 <> ''
	
	UNION
  	
	SELECT DISTINCT 
		2 AS InsuranceColumnCount, personid AS PatientVendorID, InsuranceCode2 AS InsuranceCode, 
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
	FROM dbo.[_import_17_1_491171PatientDemoUpdate2]
	WHERE insurancecode2 <> ''  
	
	UNION
  	
	SELECT DISTINCT 
		3 AS InsuranceColumnCount, personid AS PatientVendorID, InsuranceCode3 AS InsuranceCode, 
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
	FROM dbo.[_import_17_1_491171PatientDemoUpdate2]
	WHERE  insurancecode3 <> ''  
) AS Y
ORDER BY InsuranceColumnCount

PRINT ''
PRINT 'Updating Existing Policy Info from Most Recent Export from NGProd 1 of 6...'
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = CASE WHEN ip.InsuranceCompanyPlanID <> icp.InsuranceCompanyPlanID THEN icp.InsuranceCompanyPlanID ELSE ip.InsuranceCompanyPlanID END ,
		PolicyNumber = CASE WHEN ip.PolicyNumber <> tp.PolicyNumber  THEN tp.PolicyNumber ELSE ip.PolicyNumber END , 
		GroupNumber = CASE WHEN ip.GroupNumber <> tp.GroupNumber  THEN tp.GroupNumber ELSE ip.GroupNumber END , 
		PolicyStartDate = CASE WHEN ip.PolicyStartDate <> tp.PolicyStartDate  THEN tp.PolicyStartDate ELSE ip.PolicyStartDate END ,
		PolicyEndDate = CASE WHEN ip.PolicyEndDate <> tp.PolicyEndDate  THEN tp.PolicyEndDate ELSE ip.PolicyEndDate END ,
		--PatientRelationshipToInsured = CASE WHEN ip.PatientRelationshipToInsured <> tp.PatientRelationshipToInsured  THEN tp.PatientRelationshipToInsured ELSE ip.PatientRelationshipToInsured END ,
		HolderFirstName = CASE WHEN ip.HolderFirstName <> tp.HolderFirstName  THEN tp.HolderFirstName ELSE ip.HolderFirstName END ,
		HolderMiddleName = CASE WHEN ip.HolderMiddleName <> tp.HolderMiddleName  THEN tp.HolderMiddleName ELSE ip.HolderMiddleName END  , 
		HolderLastName = CASE WHEN ip.HolderLastName <> tp.HolderLastName  THEN tp.HolderLastName ELSE ip.HolderLastName END ,
		HolderDOB = CASE WHEN ip.HolderDOB <> tp.HolderDOB  THEN tp.HolderDOB ELSE ip.HolderDOB END ,
		HolderSSN = CASE WHEN ip.HolderSSN <> tp.HolderSSN  THEN tp.HolderSSN ELSE ip.HolderSSN END  ,
		HolderGender = CASE WHEN ip.HolderGender <> tp.HolderGender  THEN tp.HolderGender ELSE ip.HolderGender END  ,
		HolderAddressLine1 = CASE WHEN ip.HolderAddressLine1 <> tp.HolderStreet1  THEN tp.HolderStreet1 ELSE ip.HolderAddressLine1 END  ,
		HolderAddressLine2 = CASE WHEN ip.HolderAddressLine2 <> tp.HolderStreet2  THEN tp.HolderStreet2 ELSE ip.HolderAddressLine2 END  ,
		HolderCity = CASE WHEN ip.HolderCity <> tp.HolderCity  THEN tp.HolderCity ELSE ip.HolderCity END  ,
		HolderState = CASE WHEN ip.HolderState <> tp.HolderState  THEN tp.HolderState ELSE ip.HolderState END  ,
		HolderZipCode = CASE WHEN ip.HolderZipCode <> tp.HolderZipCode  THEN tp.HolderZipCode ELSE ip.HolderZipCode END  
FROM dbo.InsurancePolicy ip
INNER JOIN #tempPolicies1 tp ON 
	tp.PatientVendorID = ip.VendorID AND tp.InsuranceColumnCount = 1
LEFT JOIN dbo.InsuranceCompanyPlan ICP ON 
	TP.InsuranceCode = ICP.VendorID AND 
	ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
WHERE ip.Precedence = 1 AND ip.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Existing Policy Info from Most Recent Export from NGProd 2 of 6...'
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = CASE WHEN ip.InsuranceCompanyPlanID <> icp.InsuranceCompanyPlanID THEN icp.InsuranceCompanyPlanID ELSE ip.InsuranceCompanyPlanID END ,
		PolicyNumber = CASE WHEN ip.PolicyNumber <> tp.PolicyNumber  THEN tp.PolicyNumber ELSE ip.PolicyNumber END , 
		GroupNumber = CASE WHEN ip.GroupNumber <> tp.GroupNumber  THEN tp.GroupNumber ELSE ip.GroupNumber END , 
		PolicyStartDate = CASE WHEN ip.PolicyStartDate <> tp.PolicyStartDate  THEN tp.PolicyStartDate ELSE ip.PolicyStartDate END ,
		PolicyEndDate = CASE WHEN ip.PolicyEndDate <> tp.PolicyEndDate  THEN tp.PolicyEndDate ELSE ip.PolicyEndDate END ,
		--PatientRelationshipToInsured = CASE WHEN ip.PatientRelationshipToInsured <> tp.PatientRelationshipToInsured  THEN tp.PatientRelationshipToInsured ELSE ip.PatientRelationshipToInsured END ,
		HolderFirstName = CASE WHEN ip.HolderFirstName <> tp.HolderFirstName  THEN tp.HolderFirstName ELSE ip.HolderFirstName END ,
		HolderMiddleName = CASE WHEN ip.HolderMiddleName <> tp.HolderMiddleName  THEN tp.HolderMiddleName ELSE ip.HolderMiddleName END  , 
		HolderLastName = CASE WHEN ip.HolderLastName <> tp.HolderLastName  THEN tp.HolderLastName ELSE ip.HolderLastName END ,
		HolderDOB = CASE WHEN ip.HolderDOB <> tp.HolderDOB  THEN tp.HolderDOB ELSE ip.HolderDOB END ,
		HolderSSN = CASE WHEN ip.HolderSSN <> tp.HolderSSN  THEN tp.HolderSSN ELSE ip.HolderSSN END  ,
		HolderGender = CASE WHEN ip.HolderGender <> tp.HolderGender  THEN tp.HolderGender ELSE ip.HolderGender END  ,
		HolderAddressLine1 = CASE WHEN ip.HolderAddressLine1 <> tp.HolderStreet1  THEN tp.HolderStreet1 ELSE ip.HolderAddressLine1 END  ,
		HolderAddressLine2 = CASE WHEN ip.HolderAddressLine2 <> tp.HolderStreet2  THEN tp.HolderStreet2 ELSE ip.HolderAddressLine2 END  ,
		HolderCity = CASE WHEN ip.HolderCity <> tp.HolderCity  THEN tp.HolderCity ELSE ip.HolderCity END  ,
		HolderState = CASE WHEN ip.HolderState <> tp.HolderState  THEN tp.HolderState ELSE ip.HolderState END  ,
		HolderZipCode = CASE WHEN ip.HolderZipCode <> tp.HolderZipCode  THEN tp.HolderZipCode ELSE ip.HolderZipCode END  
FROM dbo.InsurancePolicy ip
INNER JOIN #tempPolicies1 tp ON 
	tp.PatientVendorID = ip.VendorID AND tp.InsuranceColumnCount = 2
LEFT JOIN dbo.InsuranceCompanyPlan ICP ON 
	TP.InsuranceCode = ICP.VendorID AND 
	ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
WHERE ip.Precedence = 2 AND ip.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Existing Policy Info from Most Recent Export from NGProd 3 of 6...'
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = CASE WHEN ip.InsuranceCompanyPlanID <> icp.InsuranceCompanyPlanID THEN icp.InsuranceCompanyPlanID ELSE ip.InsuranceCompanyPlanID END ,
		PolicyNumber = CASE WHEN ip.PolicyNumber <> tp.PolicyNumber  THEN tp.PolicyNumber ELSE ip.PolicyNumber END , 
		GroupNumber = CASE WHEN ip.GroupNumber <> tp.GroupNumber  THEN tp.GroupNumber ELSE ip.GroupNumber END , 
		PolicyStartDate = CASE WHEN ip.PolicyStartDate <> tp.PolicyStartDate  THEN tp.PolicyStartDate ELSE ip.PolicyStartDate END ,
		PolicyEndDate = CASE WHEN ip.PolicyEndDate <> tp.PolicyEndDate  THEN tp.PolicyEndDate ELSE ip.PolicyEndDate END ,
		--PatientRelationshipToInsured = CASE WHEN ip.PatientRelationshipToInsured <> tp.PatientRelationshipToInsured  THEN tp.PatientRelationshipToInsured ELSE ip.PatientRelationshipToInsured END ,
		HolderFirstName = CASE WHEN ip.HolderFirstName <> tp.HolderFirstName  THEN tp.HolderFirstName ELSE ip.HolderFirstName END ,
		HolderMiddleName = CASE WHEN ip.HolderMiddleName <> tp.HolderMiddleName  THEN tp.HolderMiddleName ELSE ip.HolderMiddleName END  , 
		HolderLastName = CASE WHEN ip.HolderLastName <> tp.HolderLastName  THEN tp.HolderLastName ELSE ip.HolderLastName END ,
		HolderDOB = CASE WHEN ip.HolderDOB <> tp.HolderDOB  THEN tp.HolderDOB ELSE ip.HolderDOB END ,
		HolderSSN = CASE WHEN ip.HolderSSN <> tp.HolderSSN  THEN tp.HolderSSN ELSE ip.HolderSSN END  ,
		HolderGender = CASE WHEN ip.HolderGender <> tp.HolderGender  THEN tp.HolderGender ELSE ip.HolderGender END  ,
		HolderAddressLine1 = CASE WHEN ip.HolderAddressLine1 <> tp.HolderStreet1  THEN tp.HolderStreet1 ELSE ip.HolderAddressLine1 END  ,
		HolderAddressLine2 = CASE WHEN ip.HolderAddressLine2 <> tp.HolderStreet2  THEN tp.HolderStreet2 ELSE ip.HolderAddressLine2 END  ,
		HolderCity = CASE WHEN ip.HolderCity <> tp.HolderCity  THEN tp.HolderCity ELSE ip.HolderCity END  ,
		HolderState = CASE WHEN ip.HolderState <> tp.HolderState  THEN tp.HolderState ELSE ip.HolderState END  ,
		HolderZipCode = CASE WHEN ip.HolderZipCode <> tp.HolderZipCode  THEN tp.HolderZipCode ELSE ip.HolderZipCode END  
FROM dbo.InsurancePolicy ip
INNER JOIN #tempPolicies1 tp ON 
	tp.PatientVendorID = ip.VendorID AND tp.InsuranceColumnCount = 3
LEFT JOIN dbo.InsuranceCompanyPlan ICP ON 
	TP.InsuranceCode = ICP.VendorID AND 
	ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
WHERE ip.Precedence = 3 AND ip.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Existing Policy Info from Most Recent Export from NGProd 4 of 6...'
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = CASE WHEN ip.InsuranceCompanyPlanID <> icp.InsuranceCompanyPlanID THEN icp.InsuranceCompanyPlanID ELSE ip.InsuranceCompanyPlanID END ,
		PolicyNumber = CASE WHEN ip.PolicyNumber <> tp.PolicyNumber  THEN tp.PolicyNumber ELSE ip.PolicyNumber END , 
		GroupNumber = CASE WHEN ip.GroupNumber <> tp.GroupNumber  THEN tp.GroupNumber ELSE ip.GroupNumber END , 
		PolicyStartDate = CASE WHEN ip.PolicyStartDate <> tp.PolicyStartDate  THEN tp.PolicyStartDate ELSE ip.PolicyStartDate END ,
		PolicyEndDate = CASE WHEN ip.PolicyEndDate <> tp.PolicyEndDate  THEN tp.PolicyEndDate ELSE ip.PolicyEndDate END ,
		--PatientRelationshipToInsured = CASE WHEN ip.PatientRelationshipToInsured <> tp.PatientRelationshipToInsured  THEN tp.PatientRelationshipToInsured ELSE ip.PatientRelationshipToInsured END ,
		HolderFirstName = CASE WHEN ip.HolderFirstName <> tp.HolderFirstName  THEN tp.HolderFirstName ELSE ip.HolderFirstName END ,
		HolderMiddleName = CASE WHEN ip.HolderMiddleName <> tp.HolderMiddleName  THEN tp.HolderMiddleName ELSE ip.HolderMiddleName END  , 
		HolderLastName = CASE WHEN ip.HolderLastName <> tp.HolderLastName  THEN tp.HolderLastName ELSE ip.HolderLastName END ,
		HolderDOB = CASE WHEN ip.HolderDOB <> tp.HolderDOB  THEN tp.HolderDOB ELSE ip.HolderDOB END ,
		HolderSSN = CASE WHEN ip.HolderSSN <> tp.HolderSSN  THEN tp.HolderSSN ELSE ip.HolderSSN END  ,
		HolderGender = CASE WHEN ip.HolderGender <> tp.HolderGender  THEN tp.HolderGender ELSE ip.HolderGender END  ,
		HolderAddressLine1 = CASE WHEN ip.HolderAddressLine1 <> tp.HolderStreet1  THEN tp.HolderStreet1 ELSE ip.HolderAddressLine1 END  ,
		HolderAddressLine2 = CASE WHEN ip.HolderAddressLine2 <> tp.HolderStreet2  THEN tp.HolderStreet2 ELSE ip.HolderAddressLine2 END  ,
		HolderCity = CASE WHEN ip.HolderCity <> tp.HolderCity  THEN tp.HolderCity ELSE ip.HolderCity END  ,
		HolderState = CASE WHEN ip.HolderState <> tp.HolderState  THEN tp.HolderState ELSE ip.HolderState END  ,
		HolderZipCode = CASE WHEN ip.HolderZipCode <> tp.HolderZipCode  THEN tp.HolderZipCode ELSE ip.HolderZipCode END  
FROM dbo.InsurancePolicy ip
INNER JOIN #tempPolicies2 tp ON 
	tp.PatientVendorID = ip.VendorID AND tp.InsuranceColumnCount = 1
LEFT JOIN dbo.InsuranceCompanyPlan ICP ON 
	TP.InsuranceCode = ICP.VendorID AND 
	ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
WHERE ip.Precedence = 1 AND ip.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Existing Policy Info from Most Recent Export from NGProd 5 of 6...'
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = CASE WHEN ip.InsuranceCompanyPlanID <> icp.InsuranceCompanyPlanID THEN icp.InsuranceCompanyPlanID ELSE ip.InsuranceCompanyPlanID END ,
		PolicyNumber = CASE WHEN ip.PolicyNumber <> tp.PolicyNumber  THEN tp.PolicyNumber ELSE ip.PolicyNumber END , 
		GroupNumber = CASE WHEN ip.GroupNumber <> tp.GroupNumber  THEN tp.GroupNumber ELSE ip.GroupNumber END , 
		PolicyStartDate = CASE WHEN ip.PolicyStartDate <> tp.PolicyStartDate  THEN tp.PolicyStartDate ELSE ip.PolicyStartDate END ,
		PolicyEndDate = CASE WHEN ip.PolicyEndDate <> tp.PolicyEndDate  THEN tp.PolicyEndDate ELSE ip.PolicyEndDate END ,
		--PatientRelationshipToInsured = CASE WHEN ip.PatientRelationshipToInsured <> tp.PatientRelationshipToInsured  THEN tp.PatientRelationshipToInsured ELSE ip.PatientRelationshipToInsured END ,
		HolderFirstName = CASE WHEN ip.HolderFirstName <> tp.HolderFirstName  THEN tp.HolderFirstName ELSE ip.HolderFirstName END ,
		HolderMiddleName = CASE WHEN ip.HolderMiddleName <> tp.HolderMiddleName  THEN tp.HolderMiddleName ELSE ip.HolderMiddleName END  , 
		HolderLastName = CASE WHEN ip.HolderLastName <> tp.HolderLastName  THEN tp.HolderLastName ELSE ip.HolderLastName END ,
		HolderDOB = CASE WHEN ip.HolderDOB <> tp.HolderDOB  THEN tp.HolderDOB ELSE ip.HolderDOB END ,
		HolderSSN = CASE WHEN ip.HolderSSN <> tp.HolderSSN  THEN tp.HolderSSN ELSE ip.HolderSSN END  ,
		HolderGender = CASE WHEN ip.HolderGender <> tp.HolderGender  THEN tp.HolderGender ELSE ip.HolderGender END  ,
		HolderAddressLine1 = CASE WHEN ip.HolderAddressLine1 <> tp.HolderStreet1  THEN tp.HolderStreet1 ELSE ip.HolderAddressLine1 END  ,
		HolderAddressLine2 = CASE WHEN ip.HolderAddressLine2 <> tp.HolderStreet2  THEN tp.HolderStreet2 ELSE ip.HolderAddressLine2 END  ,
		HolderCity = CASE WHEN ip.HolderCity <> tp.HolderCity  THEN tp.HolderCity ELSE ip.HolderCity END  ,
		HolderState = CASE WHEN ip.HolderState <> tp.HolderState  THEN tp.HolderState ELSE ip.HolderState END  ,
		HolderZipCode = CASE WHEN ip.HolderZipCode <> tp.HolderZipCode  THEN tp.HolderZipCode ELSE ip.HolderZipCode END  
FROM dbo.InsurancePolicy ip
INNER JOIN #tempPolicies2 tp ON 
	tp.PatientVendorID = ip.VendorID AND tp.InsuranceColumnCount = 2
LEFT JOIN dbo.InsuranceCompanyPlan ICP ON 
	TP.InsuranceCode = ICP.VendorID AND 
	ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
WHERE ip.Precedence = 2 AND ip.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Existing Policy Info from Most Recent Export from NGProd 6 of 6...'
UPDATE dbo.InsurancePolicy
	SET InsuranceCompanyPlanID = CASE WHEN ip.InsuranceCompanyPlanID <> icp.InsuranceCompanyPlanID THEN icp.InsuranceCompanyPlanID ELSE ip.InsuranceCompanyPlanID END ,
		PolicyNumber = CASE WHEN ip.PolicyNumber <> tp.PolicyNumber  THEN tp.PolicyNumber ELSE ip.PolicyNumber END , 
		GroupNumber = CASE WHEN ip.GroupNumber <> tp.GroupNumber  THEN tp.GroupNumber ELSE ip.GroupNumber END , 
		PolicyStartDate = CASE WHEN ip.PolicyStartDate <> tp.PolicyStartDate  THEN tp.PolicyStartDate ELSE ip.PolicyStartDate END ,
		PolicyEndDate = CASE WHEN ip.PolicyEndDate <> tp.PolicyEndDate  THEN tp.PolicyEndDate ELSE ip.PolicyEndDate END ,
		--PatientRelationshipToInsured = CASE WHEN ip.PatientRelationshipToInsured <> tp.PatientRelationshipToInsured  THEN tp.PatientRelationshipToInsured ELSE ip.PatientRelationshipToInsured END ,
		HolderFirstName = CASE WHEN ip.HolderFirstName <> tp.HolderFirstName  THEN tp.HolderFirstName ELSE ip.HolderFirstName END ,
		HolderMiddleName = CASE WHEN ip.HolderMiddleName <> tp.HolderMiddleName  THEN tp.HolderMiddleName ELSE ip.HolderMiddleName END  , 
		HolderLastName = CASE WHEN ip.HolderLastName <> tp.HolderLastName  THEN tp.HolderLastName ELSE ip.HolderLastName END ,
		HolderDOB = CASE WHEN ip.HolderDOB <> tp.HolderDOB  THEN tp.HolderDOB ELSE ip.HolderDOB END ,
		HolderSSN = CASE WHEN ip.HolderSSN <> tp.HolderSSN  THEN tp.HolderSSN ELSE ip.HolderSSN END  ,
		HolderGender = CASE WHEN ip.HolderGender <> tp.HolderGender  THEN tp.HolderGender ELSE ip.HolderGender END  ,
		HolderAddressLine1 = CASE WHEN ip.HolderAddressLine1 <> tp.HolderStreet1  THEN tp.HolderStreet1 ELSE ip.HolderAddressLine1 END  ,
		HolderAddressLine2 = CASE WHEN ip.HolderAddressLine2 <> tp.HolderStreet2  THEN tp.HolderStreet2 ELSE ip.HolderAddressLine2 END  ,
		HolderCity = CASE WHEN ip.HolderCity <> tp.HolderCity  THEN tp.HolderCity ELSE ip.HolderCity END  ,
		HolderState = CASE WHEN ip.HolderState <> tp.HolderState  THEN tp.HolderState ELSE ip.HolderState END  ,
		HolderZipCode = CASE WHEN ip.HolderZipCode <> tp.HolderZipCode  THEN tp.HolderZipCode ELSE ip.HolderZipCode END  
FROM dbo.InsurancePolicy ip
INNER JOIN #tempPolicies2 tp ON 
	tp.PatientVendorID = ip.VendorID AND tp.InsuranceColumnCount = 3
LEFT JOIN dbo.InsuranceCompanyPlan ICP ON 
	TP.InsuranceCode = ICP.VendorID AND 
	ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
WHERE ip.Precedence = 3 AND ip.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Insurance Policy 1 of 2...'
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
	1 , -- case - int
	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
		WHEN TP.PatientRelationshipToInsured IN ('C','Child') THEN 'C'
		WHEN TP.PatientRelationshipToInsured IN ('O','Other') THEN 'O'
		WHEN TP.PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(TP.HolderDOB) = 1 AND TP.HolderDOB <> '1/1/1900' THEN TP.HolderDOB ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(TP.HolderSSN) = 9 THEN TP.HolderSSN ELSE NULL END END, -- HolderSSN
	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN TP.HolderGender IN ('M','Male') THEN 'M' WHEN TP.HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderCity,128) END, -- HolderCity - varchar(128)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(TP.HolderState,2)) END, -- HolderState
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
		WHEN LEN(TP.HolderZipCode) IN (5,9) THEN TP.HolderZipCode
		WHEN LEN(TP.HolderZipCode) = 4 THEN '0' + TP.HolderZipCode
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
	@NewVendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM #tempPolicies1 AS TP
	JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID) AND VendorID = PatientVendorID
	JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID)
	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID  AND ip.Precedence = 1
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 1

UNION 

SELECT DISTINCT
	PC.PatientCaseID , -- PatientCaseID - int
	ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	2 , -- case - int
	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
		WHEN TP.PatientRelationshipToInsured IN ('C','Child') THEN 'C'
		WHEN TP.PatientRelationshipToInsured IN ('O','Other') THEN 'O'
		WHEN TP.PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(TP.HolderDOB) = 1 AND TP.HolderDOB <> '1/1/1900' THEN TP.HolderDOB ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(TP.HolderSSN) = 9 THEN TP.HolderSSN ELSE NULL END END, -- HolderSSN
	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN TP.HolderGender IN ('M','Male') THEN 'M' WHEN TP.HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderCity,128) END, -- HolderCity - varchar(128)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(TP.HolderState,2)) END, -- HolderState
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
		WHEN LEN(TP.HolderZipCode) IN (5,9) THEN TP.HolderZipCode
		WHEN LEN(TP.HolderZipCode) = 4 THEN '0' + TP.HolderZipCode
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
	@NewVendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM #tempPolicies1 AS TP
	INNER JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID) AND VendorID = PatientVendorID
	INNER JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID)
	INNER JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 2
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 2 

UNION

SELECT DISTINCT
	PC.PatientCaseID , -- PatientCaseID - int
	ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	3 , -- case - int
	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
		WHEN TP.PatientRelationshipToInsured IN ('C','Child') THEN 'C'
		WHEN TP.PatientRelationshipToInsured IN ('O','Other') THEN 'O'
		WHEN TP.PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(TP.HolderDOB) = 1 AND TP.HolderDOB <> '1/1/1900' THEN TP.HolderDOB ELSE NULL END END, -- TP.HolderDOB - datetime
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(TP.HolderSSN) = 9 THEN TP.HolderSSN ELSE NULL END END, -- HolderSSN
	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN TP.HolderGender IN ('M','Male') THEN 'M' WHEN TP.HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderCity,128) END, -- HolderCity - varchar(128)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(TP.HolderState,2)) END, -- HolderState
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
		WHEN LEN(TP.HolderZipCode) IN (5,9) THEN TP.HolderZipCode
		WHEN LEN(TP.HolderZipCode) = 4 THEN '0' + TP.HolderZipCode
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
	@NewVendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM #tempPolicies1 AS TP
	INNER JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID) AND VendorID = PatientVendorID
	INNER JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID)
	INNER JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 3
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 3
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy 2 of 2...'
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
	1 , -- case - int
	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
		WHEN TP.PatientRelationshipToInsured IN ('C','Child') THEN 'C'
		WHEN TP.PatientRelationshipToInsured IN ('O','Other') THEN 'O'
		WHEN TP.PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(TP.HolderDOB) = 1 AND TP.HolderDOB <> '1/1/1900' THEN TP.HolderDOB ELSE NULL END END, -- TP.HolderDOB - datetime
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(TP.HolderSSN) = 9 THEN TP.HolderSSN ELSE NULL END END, -- HolderSSN
	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN TP.HolderGender IN ('M','Male') THEN 'M' WHEN TP.HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderCity,128) END, -- HolderCity - varchar(128)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(TP.HolderState,2)) END, -- HolderState
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
		WHEN LEN(TP.HolderZipCode) IN (5,9) THEN TP.HolderZipCode
		WHEN LEN(TP.HolderZipCode) = 4 THEN '0' + TP.HolderZipCode
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
	@NewVendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM #tempPolicies2 AS TP
	INNER JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID) AND VendorID = PatientVendorID
	INNER JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID)
	INNER JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 1
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 1

UNION

SELECT DISTINCT
	PC.PatientCaseID , -- PatientCaseID - int
	ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	2 , -- case - int
	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
		WHEN TP.PatientRelationshipToInsured IN ('C','Child') THEN 'C'
		WHEN TP.PatientRelationshipToInsured IN ('O','Other') THEN 'O'
		WHEN TP.PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(TP.HolderDOB) = 1 AND TP.HolderDOB <> '1/1/1900' THEN TP.HolderDOB ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(TP.HolderSSN) = 9 THEN TP.HolderSSN ELSE NULL END END, -- HolderSSN
	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN TP.HolderGender IN ('M','Male') THEN 'M' WHEN TP.HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderCity,128) END, -- HolderCity - varchar(128)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(TP.HolderState,2)) END, -- HolderState
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
		WHEN LEN(TP.HolderZipCode) IN (5,9) THEN TP.HolderZipCode
		WHEN LEN(TP.HolderZipCode) = 4 THEN '0' + TP.HolderZipCode
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
	@NewVendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM #tempPolicies2 AS TP
	INNER JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID) AND VendorID = PatientVendorID
	INNER JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID)
	INNER JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 2
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 2 

UNION

SELECT DISTINCT
	PC.PatientCaseID , -- PatientCaseID - int
	ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	3 , -- case - int
	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
		WHEN TP.PatientRelationshipToInsured IN ('C','Child') THEN 'C'
		WHEN TP.PatientRelationshipToInsured IN ('O','Other') THEN 'O'
		WHEN TP.PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(TP.HolderDOB) = 1 AND TP.HolderDOB <> '1/1/1900' THEN TP.HolderDOB ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(TP.HolderSSN) = 9 THEN TP.HolderSSN ELSE NULL END END, -- HolderSSN
	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN TP.HolderGender IN ('M','Male') THEN 'M' WHEN TP.HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderCity,128) END, -- HolderCity - varchar(128)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(TP.HolderState,2)) END, -- HolderState
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
		WHEN LEN(TP.HolderZipCode) IN (5,9) THEN TP.HolderZipCode
		WHEN LEN(TP.HolderZipCode) = 4 THEN '0' + TP.HolderZipCode
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
	@NewVendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM #tempPolicies2 AS TP
	INNER JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID) AND VendorID = PatientVendorID
	INNER JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID)
	INNER JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID  AND ip.Precedence = 3
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 3
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


CREATE TABLE #tempappt (ApptID VARCHAR(50) , ChartNumber VARCHAR(50) , DoctorFirstName VARCHAR(64) , DoctorLastName VARCHAR(64) , 
						PatientFirstName VARCHAR(64) , PatientMiddleName VARCHAR(64) , PatientLastName VARCHAR(64) , 
						StartDate DATETIME , EndDate DATETIME , [Status] VARCHAR(25) , Note VARCHAR(MAX) , ServiceLocationName VARCHAR(125), 
						ResourceDesc VARCHAR(50) , ApptRescheduled VARCHAR(50) , ReschedInd VARCHAR(5) , ApptKeptInd VARCHAR(5) ,
						apptretainid VARCHAR(10) , promptretainind VARCHAR(10) , WorkflowStatus VARCHAR(50) , [Event] VARCHAR(50) , PatientID INT )


INSERT INTO #tempappt
        ( ApptID ,
          ChartNumber ,
          DoctorFirstName ,
          DoctorLastName ,
          PatientFirstName ,
          PatientMiddleName ,
          PatientLastName ,
          StartDate ,
          EndDate ,
          Status ,
          Note ,
          ServiceLocationName ,
		  ResourceDesc ,
          ApptRescheduled ,
          ReschedInd ,
          ApptKeptInd ,
		  apptretainid ,
		  promptretainind ,
          WorkflowStatus ,
          Event ,
          PatientID 
        )
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END  , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          CASE i.servicelocationname
			WHEN 'Mira Vista Care Center' THEN 'Z Mira Vista Care Center'
			WHEN 'SRUCK Skagit Regional Urgent Care' THEN 'Z SRUCK Skagit Regional Urgent C'
			WHEN 'SRUCF Skagit Regional Urgent Care' THEN 'Z SRUCF Skagit Regional Urgent C'
			WHEN 'BASC Bellingham Ambulatory Surgery Cntr' THEN 'Z BASC Bellingham Ambulatory Sur'
			WHEN 'SLS NW Eye Surgeons' THEN 'Z SLS NW Eye Surgeons'
			WHEN 'NSSC North Seattle Surgery Center' THEN 'Z NSSC North Seattle Surgery Cen'
			WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
		  ELSE servicelocationname END  , -- ServiceLocationName - varchar(125)
          i.practiceresource ,
		  CASE WHEN i.apptrescheduled = 'NULL' THEN '' ELSE i.apptrescheduled END , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          CASE WHEN i.apptkeptind = 'NULL' THEN '' ELSE i.apptkeptind END , -- ApptKeptInd - varchar(1)
		  CASE WHEN i.apptretainid = 'NULL' THEN '' ELSE i.apptkeptind END ,
		  CASE WHEN i.promptretainind = 'NULL' THEN '' ELSE i.promptretainind END ,
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_10_1_491171AppointmentUpdatev3p1] i
INNER JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10')

UNION

 SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END  , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          CASE i.servicelocationname
			WHEN 'Mira Vista Care Center' THEN 'Z Mira Vista Care Center'
			WHEN 'SRUCK Skagit Regional Urgent Care' THEN 'Z SRUCK Skagit Regional Urgent C'
			WHEN 'SRUCF Skagit Regional Urgent Care' THEN 'Z SRUCF Skagit Regional Urgent C'
			WHEN 'BASC Bellingham Ambulatory Surgery Cntr' THEN 'Z BASC Bellingham Ambulatory Sur'
			WHEN 'SLS NW Eye Surgeons' THEN 'Z SLS NW Eye Surgeons'
			WHEN 'NSSC North Seattle Surgery Center' THEN 'Z NSSC North Seattle Surgery Cen'
			WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
		  ELSE servicelocationname END  , -- ServiceLocationName - varchar(125)
          i.practiceresource ,
		  CASE WHEN i.apptrescheduled = 'NULL' THEN '' ELSE i.apptrescheduled END , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          CASE WHEN i.apptkeptind = 'NULL' THEN '' ELSE i.apptkeptind END , -- ApptKeptInd - varchar(1)
		  CASE WHEN i.apptretainid = 'NULL' THEN '' ELSE i.apptkeptind END ,
		  CASE WHEN i.promptretainind = 'NULL' THEN '' ELSE i.promptretainind END ,
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_11_1_491171AppointmentUpdatev3p2] i
LEFT JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10')

UNION

 SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END  , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          CASE i.servicelocationname
			WHEN 'Mira Vista Care Center' THEN 'Z Mira Vista Care Center'
			WHEN 'SRUCK Skagit Regional Urgent Care' THEN 'Z SRUCK Skagit Regional Urgent C'
			WHEN 'SRUCF Skagit Regional Urgent Care' THEN 'Z SRUCF Skagit Regional Urgent C'
			WHEN 'BASC Bellingham Ambulatory Surgery Cntr' THEN 'Z BASC Bellingham Ambulatory Sur'
			WHEN 'SLS NW Eye Surgeons' THEN 'Z SLS NW Eye Surgeons'
			WHEN 'NSSC North Seattle Surgery Center' THEN 'Z NSSC North Seattle Surgery Cen'
			WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
		  ELSE servicelocationname END  , -- ServiceLocationName - varchar(125)
          i.practiceresource ,
		  CASE WHEN i.apptrescheduled = 'NULL' THEN '' ELSE i.apptrescheduled END , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          CASE WHEN i.apptkeptind = 'NULL' THEN '' ELSE i.apptkeptind END , -- ApptKeptInd - varchar(1)
		  CASE WHEN i.apptretainid = 'NULL' THEN '' ELSE i.apptkeptind END ,
		  CASE WHEN i.promptretainind = 'NULL' THEN '' ELSE i.promptretainind END ,
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_12_1_491171AppointmentUpdatev3p3] i
LEFT JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10')

UNION SELECT

		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END  , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          CASE i.servicelocationname
			WHEN 'Mira Vista Care Center' THEN 'Z Mira Vista Care Center'
			WHEN 'SRUCK Skagit Regional Urgent Care' THEN 'Z SRUCK Skagit Regional Urgent C'
			WHEN 'SRUCF Skagit Regional Urgent Care' THEN 'Z SRUCF Skagit Regional Urgent C'
			WHEN 'BASC Bellingham Ambulatory Surgery Cntr' THEN 'Z BASC Bellingham Ambulatory Sur'
			WHEN 'SLS NW Eye Surgeons' THEN 'Z SLS NW Eye Surgeons'
			WHEN 'NSSC North Seattle Surgery Center' THEN 'Z NSSC North Seattle Surgery Cen'
			WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
		  ELSE servicelocationname END  , -- ServiceLocationName - varchar(125)
          i.practiceresource ,
		  CASE WHEN i.apptrescheduled = 'NULL' THEN '' ELSE i.apptrescheduled END , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          CASE WHEN i.apptkeptind = 'NULL' THEN '' ELSE i.apptkeptind END , -- ApptKeptInd - varchar(1)
		  CASE WHEN i.apptretainid = 'NULL' THEN '' ELSE i.apptkeptind END ,
		  CASE WHEN i.promptretainind = 'NULL' THEN '' ELSE i.promptretainind END ,
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_13_1_491171AppointmentUpdatev3p4] i
LEFT JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10')

PRINT ''
PRINT 'Updating Appointments - Cancelled...'
UPDATE dbo.Appointment 
	SET AppointmentConfirmationStatusCode = 'X' ,
		ModifiedDate = GETDATE()
FROM dbo.Appointment a 
	INNER JOIN #tempappt i ON 
		a.[Subject] = i.ApptID AND 
		a.PracticeID = @PracticeID
WHERE i.[Status] = 'Cancelled'
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
	          CASE 
				WHEN PA.Note LIKE '%NO SHOW%' THEN 'N' 
				WHEN PA.[Status] = 'Cancelled' THEN 'X'
			  ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
	          PC.PatientCaseID , -- PatientCaseID - int
	          DK.DKPracticeID , -- StartDKPracticeID - int
	          DK.DKPracticeID , -- EndDKPracticeID - int
			  CAST(REPLACE(LEFT(CAST(pa.startdate AS TIME),5), ':','') AS SMALLINT) ,   -- StartTm - smallint
	          CAST(REPLACE(LEFT(CAST(pa.enddate AS TIME),5), ':','') AS SMALLINT) , 
			  PA.apptid 
	FROM #tempappt PA
	INNER JOIN dbo.Patient PAT ON 
		PA.PatientID = PAT.PatientID AND
		PAT.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase PC ON 
		pc.patientcaseid = (SELECT MAX(PatientCaseID) FROM dbo.patientcase PC2 
							WHERE pat.patientid = pc.patientid AND pc2.PracticeID = @PracticeID)
		--PC.PatientID = PAT.PatientID AND
		--PC.PracticeID = @PracticeID  
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(PA.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation SL ON
		SL.NAME = PA.ServiceLocationName AND
		SL.PracticeID = @PracticeID  
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
	LEFT JOIN dbo.Appointment a ON 
		pa.ApptID = a.[Subject] AND
        a.PracticeID = @PracticeID
WHERE PA.reschedind = 'N' AND a.AppointmentID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Appointment to Resource...'	
	INSERT INTO dbo.AppointmentToResource
	        ( AppointmentID ,
	          AppointmentResourceTypeID ,
	          ResourceID ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT DISTINCT  APP.AppointmentID , -- AppointmentID - int
	          1 , -- AppointmentResourceTypeID - int
	          CASE PA.ResourceDesc	      WHEN 'Visual Field Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-VF-ONLY' AND LastName = 'TECH')
										  WHEN 'Ortho Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-ORTHO' AND LastName = 'TECH')
									 	  WHEN 'Technician Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Technician Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'TECH')
									 	  WHEN 'Technician Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'TECH')
									 	  WHEN 'Technician Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'TECH')
									 	  WHEN 'Technician Sequim' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SQC' AND LastName = 'TECH')
									 	  WHEN 'Technician Smokey Point' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SPC' AND LastName = 'TECH')
									 	  WHEN 'Photo Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'PHOTO')
										  WHEN 'Ascan Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'TECH')
										  WHEN 'Ascan Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'TECH')
										  WHEN 'Ascan Sequim' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SQC' AND LastName = 'TECH')
			  ELSE doc.DoctorID END , -- ResourceID - int
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM #tempappt PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		APP.[Subject] = PA.apptid AND 
		app.PracticeID = @PracticeID
	LEFT JOIN dbo.Doctor DOC ON
		DOC.FirstName = PA.DoctorFirstName AND
		DOC.LastName = PA.DoctorLastName AND
		DOC.PracticeID = @PracticeID AND
		DOC.[EXTERNAL] = 0  
WHERE app.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

CREATE TABLE #ar (NextGenAR VARCHAR(50) , KareoARid VARCHAR(50))
INSERT INTO #ar
        ( NextGenAR, KareoARid )
SELECT DISTINCT
		  nextgenapptreasons , -- NextGenAR - varchar(50)
          CASE nextgenapptreasons 
			WHEN '1 Day Post Op' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = '1 DAY POST OP')
			WHEN '1 Week Post Op' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = '1 WEEK POST OP')
			WHEN '4 Day Post Op' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SHORT')
			WHEN 'ADD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Argon' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'Ascan' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'Botox' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'Cataract Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'CCON - CATARACT CONSULT')
			WHEN 'Cataract Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'CCON - CATARACT CONSULT')
			WHEN 'Cataract Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Cataract Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Chalazion Removal' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'Combined Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY LONG ')
			WHEN 'Combined Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY LONG ')
			WHEN 'Comprehensive Exam' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Cornea Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'KCON - CORNEA CONSULT')
			WHEN 'Cornea Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'KCON - CORNEA CONSULT')
			WHEN 'Cornea Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Cornea Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Cryo' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'CXL - Cornea Crosslinking Proc' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'KCXL - CROSSLINKING PROCEDURE')
			WHEN 'Diabetic Exam' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'EP Long' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'FA / Photo' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - FA/PHOTOS')
			WHEN 'Final Post Op' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Glaucoma Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'GCON - GLAUCOMA CONSULT')
			WHEN 'Glaucoma Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'GCON - GLAUCOMA CONSULT')
			WHEN 'Glaucoma Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Glaucoma Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'H&P' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Hold' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'HOLD')
			WHEN 'Injection' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'Injection BMP Clinic Only' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'IOL Exchange OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'IOL Exchange OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'IOP' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SHORT')
			WHEN 'I-Stent/Cataract Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'I-Stent/Cataract Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Laser Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Lid Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Lid Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Lid Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Lid Surgery OU' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Misc Procedure OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Misc Procedure OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Misc Procedure OU' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'NP Long' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG NP')
			WHEN 'NP Retina Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'RETCON NP - RETINA CONSULT')
			WHEN 'NULL' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'OCT' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'ORA OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'ORA OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Ortho' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - ORTHO-CHILD')
			WHEN 'Peels' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'Photo' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - FA/PHOTOS')
			WHEN 'Pneumatic' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'Post Op - Dilated' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Post Op - Non-dilated' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SHORT')
			WHEN 'Pre Op' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'Procedure' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'Procedure WC' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'Product' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'Z - PRODUCT')
			WHEN 'Recheck - Dilated' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Recheck - Non-dilated' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SHORT')
			WHEN 'Refractive Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'REFCON - REFRACTIVE CONSULT')
			WHEN 'Refractive Surgery' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY REFRACTIVE')
			WHEN 'REP APPOINTMENT ONLY' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
			WHEN 'Retina Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'RETCON - RETINA CONSULT')
			WHEN 'Retina Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'RETCON - RETINA CONSULT')
			WHEN 'Retina Surgery' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Same Day Emergency' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SDER')
			WHEN 'Same Day IOP' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SHORT')
			WHEN 'Same Day Laser' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'Same Day Surgery' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Same Day Surgery Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'SLT' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'SLT Only' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'Strabismus Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Strabismus Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Strabismus Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Strabismus Surgery OU' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Tech Exam' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'VA Check' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'VC Enhancement' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'REFCON - REFRACTIVE CONSULT')
			WHEN 'VF' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - SC VF/MATRIX')
			WHEN 'VF - Matrix Only' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - SC VF/MATRIX')
			WHEN 'Yag' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'Z  ADMIN' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
			WHEN 'Z  MARKETING' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
			WHEN 'Z  MEETING' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
			WHEN 'Z  NOTES' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
			WHEN 'ZZ CEE Mock Go Live' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
		END	  -- KareoARid - varchar(50)
FROM dbo.[_import_9_1_AppointmentReasonsNextGen]

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
          ar.KareoARid , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM #tempappt i 
INNER JOIN dbo.Appointment a ON 
	i.ApptID = a.[Subject] AND
    a.PracticeID = @PracticeID
INNER JOIN #ar ar ON
	i.[Event] = ar.NextGenAR
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


UPDATE dbo.Doctor 
	SET AddressLine1 = CASE WHEN d.AddressLine1 <> i.address1 THEN i.address1 ELSE d.AddressLine1 END,
		AddressLine2 = CASE WHEN d.AddressLine2 <> i.address2 THEN i.address2 ELSE d.AddressLine2 END,
		city = CASE WHEN d.City <> i.city THEN i.city ELSE d.City END,
		[state] = CASE WHEN d.[State] <> i.[State] THEN i.[State] ELSE d.[State] END,
		ZipCode = CASE WHEN d.ZipCode <> CASE WHEN LEN(i.zip) IN (4,8) THEN '0' + i.zip ELSE zip END THEN i.zip ELSE d.ZipCode END,
		ssn = CASE WHEN d.SSN <> i.SSN THEN i.SSN ELSE d.SSN END,
		homephone = CASE WHEN d.HomePhone <> i.homephone THEN i.homephone ELSE d.homephone END,
		workphone = CASE WHEN d.workphone <> i.workphone THEN i.workphone ELSE d.workphone END,
		MobilePhone = CASE WHEN d.MobilePhone <> i.cellphone THEN i.cellphone ELSE d.MobilePhone END,
		EmailAddress = CASE WHEN d.EmailAddress <> i.email THEN i.email ELSE d.EmailAddress END
FROM dbo.Doctor d 
	INNER JOIN dbo.[_import_18_1_491171Providers] i ON
		d.FirstName = i.firstname AND 
		d.LastName = i.lastname AND
        d.[External] = 1 AND 
		d.PracticeID = @PracticeID AND 
		d.ActiveDoctor = 1
WHERE d.ActiveDoctor = 1 AND d.[External] = 1 AND d.PracticeID = @PracticeID 

PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
( 
	PracticeID , Prefix, Suffix, FirstName , MiddleName , LastName , SSN , AddressLine1 , AddressLine2 , City , State , Country , HomePhone , HomePhoneExt , 
	WorkPhone , WorkPhoneExt , MobilePhone , MobilePhoneExt , DOB , EmailAddress , Notes , ActiveDoctor , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , UserID , Degree , TaxonomyCode , VendorID , VendorImportID , FaxNumber , FaxNumberExt , [External] , NPI 
)
SELECT DISTINCT 
	@PracticeID , -- PracticeID - int
	'' , -- Prefix
	LEFT(RP.suffix,16), -- Suffix
	LEFT(RP.firstname,64) , -- FirstName - varchar(64)
	LEFT(RP.middleinitial,64) , -- MiddleName - varchar(64)
	LEFT(RP.lastname,64) , -- LastName - varchar(64)
	CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.ssn)) >= 6 
					THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(RP.ssn) , 9)
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
	REPLACE(rp.note,'|  |',CHAR(13) + CHAR(10)) , -- Notes - text
	1 , -- ActiveDoctor - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	0 , -- UserID - int
	UPPER(LEFT(RP.degree,8)) , -- Degree - varchar(8)
	TC.TaxonomyCode , -- TaxonomyCode - char(10)
	RP.AutoTempID , -- VendorID - varchar(50)
	@NewVendorImportID , -- VendorImportID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(RP.fax),10) , -- FaxNumber - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(RP.faxext),10) , -- FaxNumberExt - varchar(10)
	1 , -- External - bit
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(RP.npi)) = 10 THEN dbo.fn_RemoveNonNumericCharacters(RP.npi)
		ELSE NULL END -- NPI - varchar(10)
FROM dbo.[_import_18_1_491171Providers] AS RP 
	LEFT JOIN dbo.TaxonomyCode AS TC ON TC.TaxonomyCode = RP.taxonomycode
	LEFT JOIN dbo.Doctor AS OD ON OD.FirstName = RP.FirstName AND OD.LastName = RP.LastName AND OD.[External] = 1 AND OD.PracticeID = @PracticeID
WHERE RP.firstname <> '' AND RP.lastname <> '' 
	AND OD.DoctorId IS NULL AND RP.deleteindicator = 'N'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 5 , Name = 'Default Case'
FROM dbo.PatientCase pc 
LEFT JOIN dbo.InsurancePolicy ip ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @PracticeID AND
    ip.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID)
WHERE pc.CreatedUserID = 0 AND pc.ModifiedUserID = 0 AND pc.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@NewVendorImportID) 
AND ip.InsurancePolicyID IS NOT NULL AND ip.CreatedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



DROP TABLE #temppat
DROP TABLE #tempPolicies1
DROP TABLE #tempPolicies2
DROP TABLE #tempappt


--ROLLBACK
--COMMIT


