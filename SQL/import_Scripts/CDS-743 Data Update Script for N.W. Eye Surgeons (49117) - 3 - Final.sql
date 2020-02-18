USE superbill_49117_dev
--USE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @NewVendorImportID INT
DECLARE @VendorImportID1 INT
DECLARE @VendorImportID2 INT
DECLARE @VendorImportID3 INT
DECLARE @DefaultCollectionCategory INT

SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)
SET @PracticeID = 1
SET @NewVendorImportID = 20
SET @VendorImportID1 = 0
SET @VendorImportID2 = 5
SET @VendorImportID3 = 6

SET NOCOUNT ON 

/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--
CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
SELECT DISTINCT
		     p.PatientID , -- PatientID - int
			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
			 i.ssn  -- SSN - varchar(9)
FROM dbo.Patient p 
INNER JOIN dbo.[_import_12_1_KareoExport49117PatDemoExport] i ON p.PatientID = i.id

PRINT ''
PRINT 'Updating Existing Patients Demographics...'
UPDATE dbo.Patient 
	SET DOB = i.DateofBirth  ,
		SSN = i.ssn
FROM #updatepat i 
INNER JOIN dbo.Patient p ON
	p.PatientID = i.patientid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

/*==========================================================================*/

UPDATE dbo.[_import_8_1_491171PatientApptsUpdate1] 
	SET servicelocationname = CASE servicelocationname 
								--WHEN 'MVC NW Eye Surgeons' THEN 'MVC N.W. Eye Surgeons'
								--WHEN 'MVS NW Eye Surgeons' THEN 'MVS N.W. Eye Surgeons'
								--WHEN 'RC NW Eye Surgeons' THEN 'RC N.W. Eye Surgeons'
								--WHEN 'RS NW Eye Surgeons' THEN 'RS N.W. Eye Surgeons'
								--WHEN 'SC NW Eye Surgeons' THEN 'SC N.W. Eye Surgeons'
								--WHEN 'SPC NW Eye Surgeons' THEN 'SPC N.W. Eye Surgeons'
								--WHEN 'SQC NW Eye Surgeons' THEN 'SQC N.W. Eye Surgeons'
								--WHEN 'SQS NW Eye Surgeons' THEN 'SQS N.W. Eye Surgeons'
								--WHEN 'SS NW Eye Surgeons' THEN 'SS N.W. Eye Surgeons'
								WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
							  ELSE servicelocationname END

UPDATE dbo.[_import_9_1_491171PatientApptsUpdate2] 
	SET servicelocationname = CASE servicelocationname 
								--WHEN 'MVC NW Eye Surgeons' THEN 'MVC N.W. Eye Surgeons'
								--WHEN 'MVS NW Eye Surgeons' THEN 'MVS N.W. Eye Surgeons'
								--WHEN 'RC NW Eye Surgeons' THEN 'RC N.W. Eye Surgeons'
								--WHEN 'RS NW Eye Surgeons' THEN 'RS N.W. Eye Surgeons'
								--WHEN 'SC NW Eye Surgeons' THEN 'SC N.W. Eye Surgeons'
								--WHEN 'SPC NW Eye Surgeons' THEN 'SPC N.W. Eye Surgeons'
								--WHEN 'SQC NW Eye Surgeons' THEN 'SQC N.W. Eye Surgeons'
								--WHEN 'SQS NW Eye Surgeons' THEN 'SQS N.W. Eye Surgeons'
								--WHEN 'SS NW Eye Surgeons' THEN 'SS N.W. Eye Surgeons'
								WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
							  ELSE servicelocationname END

UPDATE dbo.[_import_10_1_491171PatientApptsUpdate3] 
	SET servicelocationname = CASE servicelocationname 
								--WHEN 'MVC NW Eye Surgeons' THEN 'MVC N.W. Eye Surgeons'
								--WHEN 'MVS NW Eye Surgeons' THEN 'MVS N.W. Eye Surgeons'
								--WHEN 'RC NW Eye Surgeons' THEN 'RC N.W. Eye Surgeons'
								--WHEN 'RS NW Eye Surgeons' THEN 'RS N.W. Eye Surgeons'
								--WHEN 'SC NW Eye Surgeons' THEN 'SC N.W. Eye Surgeons'
								--WHEN 'SPC NW Eye Surgeons' THEN 'SPC N.W. Eye Surgeons'
								--WHEN 'SQC NW Eye Surgeons' THEN 'SQC N.W. Eye Surgeons'
								--WHEN 'SQS NW Eye Surgeons' THEN 'SQS N.W. Eye Surgeons'
								--WHEN 'SS NW Eye Surgeons' THEN 'SS N.W. Eye Surgeons'
								WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
							  ELSE servicelocationname END

CREATE TABLE #temppat (personid VARCHAR(50) , FirstName VARCHAR(64) , LastName VARCHAR(64) , mrn VARCHAR(50) , dateofbirth DATETIME)
INSERT INTO	#temppat
        ( personid , FirstName , LastName , mrn , dateofbirth ) 
SELECT DISTINCT    
		  personid , -- personid - varchar(50)
          firstname , -- FirstName - varchar(64)
          lastname , -- LastName - varchar(64)
		  medrecnbrchartnumber , 
		  DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME))
FROM dbo.[_import_6_1_491171PatientDemoUpdate1] i

INSERT INTO	#temppat
        ( personid , FirstName , LastName , mrn , dateofbirth ) 
SELECT DISTINCT    
		  personid , -- personid - varchar(50)
          firstname , -- FirstName - varchar(64)
          lastname , -- LastName - varchar(64)
		  medrecnbrchartnumber , 
		  DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME))
FROM dbo.[_import_7_1_491171PatientDemoUpdate2] i

--INSERT INTO	#temppat
        --( personid , FirstName , LastName , mrn , dateofbirth ) 
--SELECT DISTINCT    
--		  personid , -- personid - varchar(50)
--          firstname , -- FirstName - varchar(64)
--          lastname , -- LastName - varchar(64)
--		  medrecnbrchartnumber , 
		  --dateofbirth
--FROM dbo.[_import_16_1_491171PatientDemographics3]

PRINT ''
PRINT 'Update Duplicate Patients with a zzz LastName'
UPDATE dbo.Patient
SET LastName = 'zzz' + p.LastName ,
	VendorID = 'zzz' + VendorID
FROM dbo.Patient p
INNER JOIN 
(
SELECT patientid , firstname , lastname , DOB , VendorImportID , ROW_NUMBER() OVER(PARTITION BY FirstName , LastName , DOB ORDER BY CreatedDate DESC) 
AS DupePat FROM dbo.Patient
) AS sp ON p.PatientID = sp.PatientID
WHERE sp.DupePat IN (2,3) AND sp.VendorImportID = @VendorImportID2 AND p.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

PRINT ''
PRINT 'Updating Existing Patients with Medical Record Number...'
UPDATE dbo.Patient SET MedicalRecordNumber = tp.mrn 
FROM #temppat tp 
INNER JOIN dbo.Patient p ON 
	tp.FirstName = p.FirstName AND 
	tp.LastName = p.LastName AND 
	tp.dateofbirth = p.DOB  
WHERE p.MedicalRecordNumber IS NULL OR p.MedicalRecordNumber = '' OR p.MedicalRecordNumber <> tp.mrn
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
        
PRINT ''
PRINT 'Updating Existing Patients with VendorID...'
UPDATE dbo.Patient SET VendorID = tp.personid , VendorImportID = CASE WHEN p.VendorImportID IS NULL THEN @NewVendorImportID ELSE p.VendorImportID END
FROM #temppat tp 
INNER JOIN dbo.Patient p ON 
	tp.FirstName = p.FirstName AND 
	tp.LastName = p.LastName AND 
	tp.dateofbirth = p.DOB  
WHERE p.VendorID IS NULL OR p.VendorID <> tp.personid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Existing Patient Case Records with VendorID...'
UPDATE dbo.PatientCase SET VendorID = tp.personid
FROM dbo.PatientCase pc 
INNER JOIN dbo.Patient p ON
	pc.PatientID = p.PatientID AND 
	p.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
INNER JOIN #temppat tp ON 
	tp.FirstName = p.FirstName AND 
	tp.LastName = p.LastName AND 
	tp.dateofbirth = p.DOB
WHERE pc.VendorID IS NULL OR pc.VendorID <> tp.personid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Deleting From Referring Doctor...'
DELETE FROM dbo.Doctor WHERE VendorID IN (SELECT 

SELECT * FROM dbo.[_import_11_1_491171Providers]

PRINT ''
PRINT 'Inserting Into Patient 1 of 2...'
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
FROM dbo.[_import_6_1_491171PatientDemoUpdate1] AS PD
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
	LEFT JOIN dbo.Patient p ON PD.personid = p.VendorID AND p.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
WHERE PD.firstname <> '' AND PD.lastname <> '' AND p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient 2 of 2...'
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
FROM dbo.[_import_7_1_491171PatientDemoUpdate2] AS PD
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
	LEFT JOIN dbo.Patient p ON PD.personid = p.VendorID AND p.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
WHERE PD.firstname <> '' AND PD.lastname <> '' AND p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into Patient 3 of 3...'
--INSERT INTO dbo.Patient
--( 
--	PracticeID , ReferringPhysicianID , Prefix, Suffix, FirstName , MiddleName , LastName , AddressLine1 , AddressLine2 , City , State , ZipCode , Gender , 
--	MaritalStatus , HomePhone , HomePhoneExt , WorkPhone , WorkPhoneExt , DOB , SSN , EmailAddress , ResponsibleDifferentThanPatient , ResponsiblePrefix, ResponsibleFirstName,
--	ResponsibleMiddleName, ResponsibleLastName, ResponsibleSuffix, ResponsibleRelationshipToPatient, ResponsibleAddressLine1, ResponsibleAddressline2, ResponsibleCity, ResponsibleState,
--	ResponsibleZipCode, CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , EmploymentStatus , PrimaryProviderID , DefaultServiceLocationID , EmployerID , MedicalRecordNumber , 
--	MobilePhone , MobilePhoneExt , PrimaryCarePhysicianID , VendorID , VendorImportID , CollectionCategoryID , Active , SendEmailCorrespondence , 
--	PhonecallRemindersEnabled, EmergencyName, EmergencyPhone, EmergencyPhoneExt
--)
--SELECT DISTINCT
--	@PracticeID , -- PracticeID - int
--	ReferringDoc.DoctorID , -- ReferringPhysicianID - int
--	'' , -- Prefix 
--	'' , -- Suffix
--	LEFT(PD.firstname,64) , -- FirstName - varchar(64)
--	LEFT(PD.middleinitial,64) , -- MiddleName - varchar(64)
--	LEFT(PD.lastname,64) , -- LastName - varchar(64)
--	LEFT(PD.address1,256) , -- AddressLine1 - varchar(256)
--	LEFT(PD.address2,256) , -- AddressLine2 - varchar(256)
--	LEFT(PD.city,128) , -- City - varchar(128)
--	UPPER(LEFT(PD.state,2)) , -- State - varchar(2)
--	CASE 
--		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(PD.zipcode)
--		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(PD.zipcode)
--		ELSE '' END , -- ZipCode - varchar(9)
--	CASE
--		WHEN PD.gender IN ('M','Male') THEN 'M'
--		WHEN PD.gender IN ('F','Female') THEN 'F'
--		ELSE 'U' END , -- Gender - varchar(1)
--	CASE 
--		WHEN PD.maritalstatus IN ('D','Divorced') THEN 'D'
--		WHEN PD.maritalstatus IN ('M','Married') THEN 'M'
--		WHEN PD.maritalstatus IN ('S','Single') THEN 'S'
--		WHEN PD.maritalstatus IN ('W','Widowed') THEN 'W'
--		ELSE '' END , -- MaritalStatus - varchar(1)
--	CASE
--		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.homephone),10)
--		ELSE '' END, -- HomePhone - varchar(10)
--	CASE
--		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone))),10)
--		ELSE NULL END , -- HomePhoneExt - varchar(10)
--	CASE
--		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.workphone),10)
--		ELSE '' END , -- WorkPhone - varchar(10)
--	CASE
--		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.workphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone))),10)
--		ELSE NULL END , -- WorkPhoneExt - varchar(10)
--	CASE
--		WHEN ISDATE(PD.dateofbirth) = 1 THEN PD.dateofbirth
--		ELSE NULL END , -- DOB - datetime
--	CASE
--		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.SSN)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(PD.SSN), 9)
--		ELSE NULL END , -- SSN - char(9)
--	LEFT(PD.email,256) , -- EmailAddress - varchar(256)
--	CASE WHEN PD.responsiblepartyrelationship  <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
--	'' , -- ResponsiblePrefix - varchar(16)
--	LEFT(PD.responsiblepartyfirstname, 64) , -- ResponsibleFirstName - varchar(64)
--	LEFT(PD.responsiblepartymiddlename, 64) , -- ResponsibleMiddleName - varchar(64)
--	LEFT(PD.responsiblepartylastname, 64) , -- ResposibleLastName - varchar(64)
--	LEFT(PD.responsiblepartysuffix, 16) , -- ResponsibleSuffix - varchar(16)
--	CASE WHEN PD.responsiblepartyrelationship IN ('C','Child') THEN 'C'
--         WHEN PD.responsiblepartyrelationship IN ('U','Spouse') THEN 'U'
--         WHEN PD.responsiblepartyrelationship IN ('O','Other') THEN 'O'
--	ELSE NULL END , -- ResponsibleRelationshipToPatient (char)
--	LEFT(PD.responsiblepartyaddress1, 256) , -- ResponsibleAddressLine1 - varchar(256)
--	LEFT(PD.responsiblepartyaddress2, 256) , -- ResponsibleAddressLine2 - varchar(256)
--	LEFT(PD.responsiblepartycity, 128) , -- ResponsibleCity - varchar(128) 
--	LEFT(PD.responsiblepartystate, 2) , -- ResponsibleState - varchar(2)
--	LEFT(REPLACE(PD.responsiblepartyzipcode, '-',''), 9) , -- ResponsibleZipCode - varchar(9)
--	GETDATE() , -- CreatedDate - datetime
--	0 , -- CreatedUserID - int
--	GETDATE() , -- ModifiedDate - datetime
--	0 , -- ModifiedUserID - int
--	CASE
--		WHEN PD.employmentstatus IN ('E','Employed') THEN 'E'
--		WHEN PD.employmentstatus IN ('R','Retired') THEN 'R'
--		WHEN PD.employmentstatus IN ('S','Student, Full-Time') THEN 'S'
--		WHEN PD.employmentstatus IN ('T','Student, Part-Time') THEN 'T'
--		ELSE 'U' END, -- EmploymentStatus - char(1)
--	PrimaryProvider.DoctorID , -- PrimaryProviderID - int 
--	CASE WHEN SL.ServiceLocationID IS NOT NULL THEN SL.ServiceLocationID
--		ELSE SL2.ServiceLocationID END , -- DefaultServiceLocationID - int 
--	E.EmployerID, -- EmployerID - int 
--	LEFT(PD.medrecnbrchartnumber,128) , -- MedicalRecordNumber - varchar(128)
--	CASE
--		WHEN LEN(PD.cellphone) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.cellphone),10)
--		ELSE '' END , -- MobilePhone - varchar(10)
--	CASE
--		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.cellphone)) > 10 THEN LEFT(SUBSTRING(PD.cellphone,11,LEN(PD.cellphone)),10)
--		ELSE NULL END , -- MobilePhoneExt - varchar(10)
--	PrimaryCare.DoctorID , -- PrimaryCarePhysicianID - int 
--	PD.personid , -- VendorID - varchar(50)
--	@NewVendorImportID , -- VendorImportID - int
--	@DefaultCollectionCategory , -- CollectionCategoryID - int
--	CASE 
--		WHEN PD.Active IN ('0','No','N','Inactive') THEN 0
--		ELSE 1 END, -- Active - bit
--	1, -- SendEmailCorrespondence - bit
--	0,  -- PhonecallRemindersEnabled - bit
--	LEFT(PD.EmergencyName,128) , -- EmergencyName - varchar(128)
--	CASE
--		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphone),10)
--		ELSE '' END , -- EmergencyPhone - varchar(10)
--	LEFT(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphoneext),10) -- EmergencyPhoneExt - varchar(10)
--FROM dbo.[_import_16_1_491171PatientDemographics3] AS PD
--	LEFT JOIN dbo.Doctor AS ReferringDoc ON 
--			ReferringDoc.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS RD WHERE RD.FirstName = PD.ReferringPhysicianFirstName AND 
--											RD.LastName = PD.ReferringPhysicianLastName AND RD.PracticeID = @PracticeID AND RD.ActiveDoctor = 1)
--	LEFT JOIN dbo.Doctor AS PrimaryProvider ON 
--			PrimaryProvider.FirstName = PD.PrimaryProviderFirstName AND 
--			PrimaryProvider.LastName = PD.PrimaryProviderLastName AND 
--			PrimaryProvider.[External] = 0 AND 
--			PrimaryProvider.PracticeID = @PracticeID AND
--			PrimaryProvider.ActiveDoctor = 1
--	LEFT JOIN dbo.Doctor AS PrimaryCare ON 
--		PrimaryCare.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS PC WHERE PC.FirstName = PD.primarycarephysicianfirstname AND 
--									PC.LastName = PD.Primarycarephysicianlastname AND PC.PracticeID = @PracticeID AND PC.ActiveDoctor = 1)
--	LEFT JOIN dbo.ServiceLocation AS SL ON SL.Name = PD.defaultservicelocation
--	LEFT JOIN dbo.ServiceLocation AS SL2 ON 1 = 1 AND SL2.ServiceLocationID = (SELECT TOP 1 ServiceLocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID) 
--	LEFT JOIN dbo.Employers AS E ON E.EmployerID = (SELECT TOP 1 E2.EmployerID FROM dbo.Employers E2 WHERE E2.EmployerName = LEFT(PD.employername,128) AND E2.AddressLine1 = LEFT(PD.employeraddress1,256) AND E2.State = LEFT(PD.employerstate,2))
--	LEFT JOIN dbo.Patient p ON PD.personid = p.VendorID AND p.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3)
--WHERE PD.firstname <> '' AND PD.lastname <> '' AND p.PatientID IS NULL
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case 1 of 2...'
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
FROM dbo.[_import_6_1_491171PatientDemoUpdate1] pd
	INNER JOIN dbo.Patient AS PAT ON pat.VendorImportID = @NewVendorImportID AND pat.VendorID = pd.personid
	LEFT JOIN dbo.PatientCase pc ON PAT.PatientID = pc.PatientID AND pc.PracticeID = @PracticeID
WHERE pc.PatientCaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


PRINT ''
PRINT 'Inserting Into Patient Case 2 of 2...'
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
FROM dbo.[_import_7_1_491171PatientDemoUpdate2] pd
	INNER JOIN dbo.Patient AS PAT ON pat.VendorImportID = @NewVendorImportID AND pat.VendorID = pd.personid
	LEFT JOIN dbo.PatientCase pc ON PAT.PatientID = pc.PatientID AND pc.PracticeID = @PracticeID
WHERE pc.PatientCaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


--CREATE TABLE #inspolupdate (TargetInsurancePolicyID INT , SourcePatientCaseID INT , SourcePatVendorID VARCHAR(50) , TargetPatientID INT , TargetPatientCaseID INT)
--INSERT INTO #inspolupdate ( TargetInsurancePolicyID ,SourcePatientCaseID, SourcePatVendorID )
--SELECT DISTINCT   ip.InsurancePolicyID , ip.PatientCaseID, p.VendorID  
--FROM dbo.InsurancePolicy ip
--INNER JOIN dbo.PatientCase pc ON 
--	ip.PatientCaseID = pc.PatientCaseID AND 
--	pc.PracticeID = @PracticeID 
--INNER JOIN dbo.Patient p ON 
--	pc.PatientID = p.PatientID 
--WHERE p.LastName LIKE 'zzz%'

--UPDATE #inspolupdate  
--	SET TargetPatientID = p.patientid , 
--		TargetPatientCaseID = pc.PatientCaseID
--FROM dbo.Patient p
--INNER JOIN #inspolupdate i ON 
--	p.VendorID = i.SourcePatVendorID
--LEFT JOIN dbo.PatientCase pc ON
--	p.PatientID = pc.PatientID
--WHERE p.LastName NOT LIKE 'zzz%'

--PRINT ''
--PRINT 'Moving Existing Insurance Policies from Duplicated Patients to New Record...'
--UPDATE dbo.InsurancePolicy 
--	SET PatientCaseID = i.TargetPatientCaseID
--FROM dbo.InsurancePolicy ip 
--INNER JOIN #inspolupdate i ON 
--	i.TargetInsurancePolicyID = (SELECT DISTINCT InsurancePolicyID FROM dbo.InsurancePolicy ip2 WHERE i.TargetInsurancePolicyID = ip2.InsurancePolicyID)
--WHERE i.TargetPatientCaseID IS NOT NULL AND NOT EXISTS (SELECT * FROM dbo.InsurancePolicy ip2 WHERE i.TargetPatientCaseID = ip2.PatientCaseID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

CREATE TABLE #apptupdate (TargetAppointmentID INT , PatientCaseID INT ,SourcePatientID INT , SourcePatVendorID VARCHAR(50) , TargetPatientID INT , TargetPatientCaseID INT)
INSERT INTO #apptupdate ( TargetAppointmentID , PatientCaseID ,SourcePatientID, SourcePatVendorID )
SELECT DISTINCT   a.AppointmentID , a.PatientCaseID , a.PatientID , REPLACE(p.VendorID,'zzz','')  
FROM dbo.Appointment a
INNER JOIN dbo.Patient p ON 
	a.PatientID = p.PatientID 
WHERE p.LastName LIKE 'zzz%'

UPDATE #apptupdate  
	SET TargetPatientID = p.patientid , 
		TargetPatientCaseID = pc.PatientCaseID
FROM dbo.Patient p
INNER JOIN #apptupdate a ON 
	p.VendorID = a.SourcePatVendorID
LEFT JOIN dbo.PatientCase pc ON
	p.PatientID = pc.PatientID
WHERE p.LastName NOT LIKE 'zzz%'

PRINT ''
PRINT 'Moving Existing Appointments from Duplicated Patients to New Record...'
UPDATE dbo.Appointment 
	SET PatientID = i.TargetPatientID ,
		PatientCaseID = i.TargetPatientCaseID 
FROM dbo.Appointment a 
INNER JOIN #apptupdate i ON 
	a.AppointmentID = i.TargetAppointmentID
LEFT JOIN dbo.PatientCase pc ON
	i.TargetPatientCaseID = pc.PatientCaseID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--PRINT ''
--PRINT 'Inserting Into Patient Case 3 of 3...'
--INSERT INTO dbo.PatientCase
--( 
--	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
--	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
--	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
--	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
--)
--SELECT DISTINCT 
--	PAT.PatientID , -- PatientID - int
--	'Self Pay' , -- Name - varchar(128)
--	1 , -- Active - bit
--	11 , -- PayerScenarioID - int
--	NULL , -- ReferringPhysicianID - int
--	0 , -- EmploymentRelatedFlag - bit
--	0, -- AutoAccidentRelatedFlag - bit
--	0, -- OtherAccidentRelatedFlag - bit
--	0, -- AbuseRelatedFlag - bit
--	NULL , -- AutoAccidentRelatedState - char(2)
--	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
--	0, -- ShowExpiredInsurancePolicies - bit
--	GETDATE() , -- CreatedDate - datetime
--	0 , -- CreatedUserID - int
--	GETDATE() , -- ModifiedDate - datetime
--	0 , -- ModifiedUserID - int
--	@PracticeID , -- PracticeID - int
--	NULL , -- CaseNumber - varchar(128)
--	NULL , -- WorkersCompContactInfoID - int
--	PAT.VendorID , -- VendorID - varchar(50)
--	@NewVendorImportID , -- VendorImportID - int
--	0, -- PregnncyRelatedFlag - bit
--	1, -- StatementActive - bit
--	0, -- EPSDT - bit
--	0, -- FamilyPlanning - bit
--	1 , -- EPSDTCodeID - int
--	0 , -- EmergencyRelated - bit
--	0 -- HomeboundRelatedFlag
--FROM dbo.[_import_16_1_491171PatientDemographics3] pd
--	INNER JOIN dbo.Patient AS PAT ON pat.VendorImportID = @NewVendorImportID AND pat.VendorID = pd.personid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Patient Journal Note 1 of 3...'
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
FROM dbo.[_import_6_1_491171PatientDemoUpdate1] i 
INNER JOIN dbo.Patient p ON
	i.personid = p.VendorID AND 
	p.VendorImportID = @NewVendorImportID
WHERE i.patchurchnote <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Patient Journal Note 2 of 3...'
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
FROM dbo.[_import_7_1_491171PatientDemoUpdate2] i 
INNER JOIN dbo.Patient p ON
	i.personid = p.VendorID AND 
	p.VendorImportID = @NewVendorImportID
WHERE i.patchurchnote <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into Patient Journal Note 3 of 3...'
--INSERT INTO dbo.PatientJournalNote
--        ( CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          PatientID ,
--          UserName ,
--          SoftwareApplicationID ,
--          Hidden ,
--          NoteMessage ,
--          AccountStatus ,
--          NoteTypeCode ,
--          LastNote
--        )
--SELECT DISTINCT
--		  GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          p.PatientID , -- PatientID - int
--          '' , -- UserName - varchar(128)
--          'K' , -- SoftwareApplicationID - char(1)
--          0 , -- Hidden - bit
--          'Church: ' + i.patchurchnote , -- NoteMessage - varchar(max)
--          0 , -- AccountStatus - bit
--          1 , -- NoteTypeCode - int
--          0  -- LastNote - bit
--FROM dbo.[_import_16_1_491171PatientDemographics3] i 
--INNER JOIN dbo.Patient p ON
--	i.personid = p.VendorID AND 
--	p.VendorImportID = @NewVendorImportID
--WHERE i.patchurchnote <> ''
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
	@NewVendorImportID  -- VendorImportID - int
FROM dbo._import_11_1_491171InsuranceList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.InsuranceCompanyName = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
LEFT JOIN dbo.InsuranceCompanyPlan oicp ON 
	icp.insuranceid = oicp.VendorID
WHERE oicp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

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
	@NewVendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_11_1_491171InsuranceList AS IICL
WHERE ( insurancecompanyname <> '' OR planname <> '') AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.InsuranceCompanyName AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'															 

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
	@NewVendorImportID -- VendorImportID - int
FROM dbo._import_11_1_491171InsuranceList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.InsuranceCompanyName, 50) AND
	ICP.Insurancecompanyname = IC.InsuranceCompanyName AND
	IC.VendorImportID = @NewVendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.Insuranceid = OICP.VendorID AND
	OICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @NewVendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

/*
==========================================================================================================================================
CREATE INSURANCE POLICIES  
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
	FROM dbo.[_import_6_1_491171PatientDemoUpdate1]
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
	FROM dbo.[_import_6_1_491171PatientDemoUpdate1]
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
	FROM dbo.[_import_6_1_491171PatientDemoUpdate1]
	WHERE  insurancecode3 <> ''  
) AS Y
ORDER BY InsuranceColumnCount

PRINT ''
PRINT 'Inserting Into Insurance Policy 1.1 of 2...'
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
	JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID) AND VendorID = PatientVendorID
	JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID  AND ip.Precedence = 1
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy 1.2 of 2...'
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
	INNER JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID) AND VendorID = PatientVendorID
	INNER JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	INNER JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 2
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 2 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy 1.3 of 2...'
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
	JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID) AND VendorID = PatientVendorID
	JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 3
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 3
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


/*
==========================================================================================================================================
CREATE INSURANCE POLICIES  
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
	FROM dbo.[_import_7_1_491171PatientDemoUpdate2]
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
	FROM dbo.[_import_7_1_491171PatientDemoUpdate2]
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
	FROM dbo.[_import_7_1_491171PatientDemoUpdate2]
	WHERE  insurancecode3 <> ''  
) AS Y
ORDER BY InsuranceColumnCount

PRINT ''
PRINT 'Inserting Into Insurance Policy 2.1 of 2...'
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
	JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID) AND VendorID = PatientVendorID
	JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 1
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy 2.2 of 2...'
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
	JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID) AND VendorID = PatientVendorID
	JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 2
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 2 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy 2.3 of 2...'
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
	JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID) AND VendorID = PatientVendorID
	JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID  AND ip.Precedence = 3
WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 3
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

/*
==========================================================================================================================================
CREATE INSURANCE POLICIES  
==========================================================================================================================================
*/

--CREATE TABLE #tempPolicies3
--(
--	InsuranceColumnCount INT,
--	PatientVendorID VARCHAR(128),
--	InsuranceCode VARCHAR(128),
--	PolicyNumber VARCHAR(32), 
--	GroupNumber VARCHAR(32), 
--	PolicyStartDate DATETIME, 
--	PolicyEndDate DATETIME, 
--	Copay MONEY,
--	Deductible INT,
--	PatientRelationshipToInsured VARCHAR(MAX), 
--	HolderLastName VARCHAR(64), 
--	HolderMiddleName VARCHAR(64),
--	HolderFirstName VARCHAR(64), 
--	HolderStreet1 VARCHAR(256), 
--	HolderStreet2 VARCHAR(256), 
--	HolderCity VARCHAR(128), 
--	HolderState VARCHAR(2), 
--	HolderZipCode VARCHAR(9), 
--	HolderSSN VARCHAR(9), 
--	HolderDOB DATETIME, 
--	HolderGender CHAR(1),
--	HolderPolicyNumber VARCHAR(32),
--	Employer VARCHAR(128),
--	PolicyNote VARCHAR(8000)
--)


--INSERT INTO #tempPolicies3
--( 
--	InsuranceColumnCount , PatientVendorID , InsuranceCode, PolicyNumber , GroupNumber , PolicyStartDate , 
--	PolicyEndDate , Copay, Deductible, PatientRelationshipToInsured, HolderLastName , HolderMiddleName , 
--	HolderFirstName , HolderStreet1 , HolderStreet2 , HolderCity , HolderState , HolderZipCode , HolderSSN , 
--	HolderDOB , HolderGender , HolderPolicyNumber, Employer, PolicyNote
--)
--SELECT DISTINCT
--	InsuranceColumnCount,
--	PatientVendorID,
--	InsuranceCode, 
--	LEFT(PolicyNumber, 32),
--	LEFT(GroupNumber, 32),
--	PolicyStartDate, 
--	PolicyEndDate, 
--	Copay,
--	Deductible,
--	PatientRelationshipToInsured,
--	LEFT(HolderLastName, 64),
--	LEFT(HolderMiddleName, 64),
--	LEFT(HolderFirstName, 64),
--	LEFT(HolderStreet1, 256),
--	LEFT(HolderStreet2, 256),
--	LEFT(HolderCity, 128),
--	LEFT(HolderState, 2),
--	LEFT(HolderZipCode, 9),
--	LEFT(HolderSSN, 9),
--	HolderDOB, 
--	LEFT(HolderGender, 1),
--	HolderPolicyNumber,
--	Employer,
--	PolicyNote
--FROM
--(	SELECT DISTINCT 
--		1 AS InsuranceColumnCount, personid AS PatientVendorID, InsuranceCode1 AS InsuranceCode, 
--		policynumber1 AS PolicyNumber, groupnumber1 AS GroupNumber, CASE WHEN ISDATE(policy1startdate) = 1 
--		THEN policy1startdate ELSE NULL END AS PolicyStartDate, CASE WHEN ISDATE(policy1enddate) = 1 THEN policy1enddate 
--		ELSE NULL END AS PolicyEndDate, policy1copay AS Copay, policy1deductible AS Deductible,  patientrelationship1 AS 
--		PatientRelationshipToInsured, holder1lastname AS HolderLastName, Holder1middlename AS HolderMiddleName, 
--		Holder1firstname AS HolderFirstName, Holder1street1 AS HolderStreet1, holder1street2 AS HolderStreet2, 
--		holder1city AS HolderCity, holder1state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder1zipcode) AS 
--		HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder1ssn) AS holderSSN, CASE WHEN 
--		ISDATE(Holder1dateofbirth) = 1 THEN Holder1dateofbirth ELSE NULL END AS HolderDOB, CASE WHEN Holder1gender IN 
--		('M','Male') THEN 'M' WHEN Holder1gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
--		holder1PolicyNumber AS HolderPolicyNumber, Employer1 AS Employer, Policy1Note AS PolicyNote
--	FROM dbo.[_import_16_1_491171PatientDemographics3]
--	WHERE insurancecode1 <> ''
	
--	UNION
  	
--	SELECT DISTINCT 
--		2 AS InsuranceColumnCount, personid AS PatientVendorID, InsuranceCode2 AS InsuranceCode, 
--		policynumber2 AS PolicyNumber, groupnumber2 AS GroupNumber, CASE WHEN ISDATE(policy2startdate) = 1 
--		THEN policy2startdate ELSE NULL END AS PolicyStartDate, CASE WHEN ISDATE(policy2enddate) = 1 THEN policy2enddate 
--		ELSE NULL END AS PolicyEndDate, policy2copay AS Copay, policy2deductible AS Deductible,  patientrelationship2 AS
--		PatientRelationshipToInsured, holder2lastname AS HolderLastName, Holder2middlename AS HolderMiddleName, 
--		Holder2firstname AS HolderFirstName, Holder2street1 AS HolderStreet1, holder2street2 AS HolderStreet2, 
--		holder2city AS HolderCity, holder2state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder2zipcode) 
--		AS HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder2ssn) AS holderSSN, CASE WHEN 
--		ISDATE(Holder2dateofbirth) = 1 THEN Holder2dateofbirth ELSE NULL END AS HolderDOB, CASE WHEN Holder2gender IN 
--		('M','Male') THEN 'M' WHEN Holder2gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
--		holder2PolicyNumber AS HolderPolicyNumber, Employer2 AS Employer, Policy2Note AS PolicyNote
--	FROM dbo.[_import_16_1_491171PatientDemographics3]
--	WHERE insurancecode2 <> ''  
	
--	UNION
  	
--	SELECT DISTINCT 
--		3 AS InsuranceColumnCount, personid AS PatientVendorID, InsuranceCode3 AS InsuranceCode, 
--		policynumber3 AS PolicyNumber, groupnumber3 AS GroupNumber, CASE WHEN ISDATE(policy3startdate) = 1 
--		THEN policy3startdate ELSE NULL END AS PolicyStartDate, CASE WHEN ISDATE(policy3enddate) = 1 THEN policy3enddate 
--		ELSE NULL END AS PolicyEndDate, policy3copay AS Copay, policy3deductible AS Deductible,  patientrelationship3 AS
--		PatientRelationshipToInsured, holder3lastname AS HolderLastName, Holder3middlename AS HolderMiddleName, 
--		Holder3firstname AS HolderFirstName, Holder3street1 AS HolderStreet1, holder3street2 AS HolderStreet2, 
--		holder3city AS HolderCity, holder3state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder3zipcode) 
--		AS HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder3ssn) AS holderSSN, CASE WHEN 
--		ISDATE(Holder3dateofbirth) = 1 THEN Holder3dateofbirth ELSE NULL END AS HolderDOB, CASE WHEN Holder3gender IN 
--		('M','Male') THEN 'M' WHEN Holder3gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
--		holder3PolicyNumber AS HolderPolicyNumber, Employer3 AS Employer, Policy3Note AS PolicyNote
--	FROM dbo.[_import_16_1_491171PatientDemographics3]
--	WHERE  insurancecode3 <> ''  
--) AS Y
--ORDER BY InsuranceColumnCount

--PRINT ''
--PRINT 'Inserting Into Insurance Policy 3.1 of 3...'
--INSERT INTO dbo.InsurancePolicy
--( 
--	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate , CardOnFile , PatientRelationshipToInsured , 
--	HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , HolderThroughEmployer , HolderEmployerName , 
--	PatientInsuranceStatusID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity , 
--	HolderState , HolderZipCode , HolderPhone , HolderPhoneExt , DependentPolicyNumber , Notes , Copay , Deductible , Active , PracticeID , VendorID , 
--	VendorImportID , GroupName , ReleaseOfInformation
--)
--SELECT DISTINCT
--	PC.PatientCaseID , -- PatientCaseID - int
--	ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
--	1 , -- case - int
--	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
--	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
--	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
--	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
--	0, -- CardOnFile - bit
--	CASE
--		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
--		WHEN TP.PatientRelationshipToInsured IN ('C','Child') THEN 'C'
--		WHEN TP.PatientRelationshipToInsured IN ('O','Other') THEN 'O'
--		WHEN TP.PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
--		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
--	'', -- HolderPrefix - varchar(16)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
--	'', -- HolderSuffix - varchar(16)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(TP.HolderDOB) = 1 AND TP.HolderDOB <> '1/1/1900' THEN TP.HolderDOB ELSE NULL END END, -- HolderDOB - datetime
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(TP.HolderSSN) = 9 THEN TP.HolderSSN ELSE NULL END END, -- HolderSSN
--	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
--	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
--	0 , -- PatientInsuranceStatusID - int
--	GETDATE(),
--	0 , -- CreatedUserID - int
--	GETDATE(),
--	0 , -- ModifiedUserID - int
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN TP.HolderGender IN ('M','Male') THEN 'M' WHEN TP.HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderCity,128) END, -- HolderCity - varchar(128)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(TP.HolderState,2)) END, -- HolderState
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
--		WHEN LEN(TP.HolderZipCode) IN (5,9) THEN TP.HolderZipCode
--		WHEN LEN(TP.HolderZipCode) = 4 THEN '0' + TP.HolderZipCode
--		ELSE '' END END, -- HolderZipCode - varchar(9)
--	'', -- HolderPhone - varchar(10)
--	'' , -- HolderPhoneExt - varchar(10)
--	LEFT(TP.PolicyNumber, 32) , -- DependentPolicyNumber - varchar(32)
--    TP.PolicyNote + CHAR(13) + CHAR(10) + CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
--	TP.Copay, -- Copay - money
--	TP.Deductible, -- Deductible - money
--	1, -- Active - bit
--	@PracticeID , -- PracticeID - int
--	PAT.VendorID , -- VendorID - varchar(50)
--	@NewVendorImportID , -- VendorImportID - int
--	'' , -- GroupName - varchar(14)
--	'Y'  -- ReleaseOfInformation - varchar(1)
--FROM #tempPolicies3 AS TP
--	JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID) AND VendorID = PatientVendorID
--	JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
--	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
--	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 1
--WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 1
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

--PRINT ''
--PRINT 'Inserting Into Insurance Policy 3.2 of 3...'
--INSERT INTO dbo.InsurancePolicy
--( 
--	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate , CardOnFile , PatientRelationshipToInsured , 
--	HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , HolderThroughEmployer , HolderEmployerName , 
--	PatientInsuranceStatusID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity , 
--	HolderState , HolderZipCode , HolderPhone , HolderPhoneExt , DependentPolicyNumber , Notes , Copay , Deductible , Active , PracticeID , VendorID , 
--	VendorImportID , GroupName , ReleaseOfInformation
--)
--SELECT DISTINCT
--	PC.PatientCaseID , -- PatientCaseID - int
--	ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
--	2 , -- case - int
--	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
--	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
--	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
--	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
--	0, -- CardOnFile - bit
--	CASE
--		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
--		WHEN TP.PatientRelationshipToInsured IN ('C','Child') THEN 'C'
--		WHEN TP.PatientRelationshipToInsured IN ('O','Other') THEN 'O'
--		WHEN TP.PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
--		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
--	'', -- HolderPrefix - varchar(16)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
--	'', -- HolderSuffix - varchar(16)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(TP.HolderDOB) = 1 AND TP.HolderDOB <> '1/1/1900' THEN TP.HolderDOB ELSE NULL END END, -- HolderDOB - datetime
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(TP.HolderSSN) = 9 THEN TP.HolderSSN ELSE NULL END END, -- HolderSSN
--	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
--	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
--	0 , -- PatientInsuranceStatusID - int
--	GETDATE(),
--	0 , -- CreatedUserID - int
--	GETDATE(),
--	0 , -- ModifiedUserID - int
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN TP.HolderGender IN ('M','Male') THEN 'M' WHEN TP.HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderCity,128) END, -- HolderCity - varchar(128)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(TP.HolderState,2)) END, -- HolderState
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
--		WHEN LEN(TP.HolderZipCode) IN (5,9) THEN TP.HolderZipCode
--		WHEN LEN(TP.HolderZipCode) = 4 THEN '0' + TP.HolderZipCode
--		ELSE '' END END, -- HolderZipCode - varchar(9)
--	'', -- HolderPhone - varchar(10)
--	'' , -- HolderPhoneExt - varchar(10)
--	LEFT(TP.PolicyNumber, 32) , -- DependentPolicyNumber - varchar(32)
--    TP.PolicyNote + CHAR(13) + CHAR(10) + CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
--	TP.Copay, -- Copay - money
--	TP.Deductible, -- Deductible - money
--	1, -- Active - bit
--	@PracticeID , -- PracticeID - int
--	PAT.VendorID , -- VendorID - varchar(50)
--	@NewVendorImportID , -- VendorImportID - int
--	'' , -- GroupName - varchar(14)
--	'Y'  -- ReleaseOfInformation - varchar(1)
--FROM #tempPolicies3 AS TP
--	JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID) AND VendorID = PatientVendorID
--	JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
--	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
--	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 2
--WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 2 
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

--PRINT ''
--PRINT 'Inserting Into Insurance Policy 3.3 of 3...'
--INSERT INTO dbo.InsurancePolicy
--( 
--	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate , CardOnFile , PatientRelationshipToInsured , 
--	HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , HolderThroughEmployer , HolderEmployerName , 
--	PatientInsuranceStatusID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity , 
--	HolderState , HolderZipCode , HolderPhone , HolderPhoneExt , DependentPolicyNumber , Notes , Copay , Deductible , Active , PracticeID , VendorID , 
--	VendorImportID , GroupName , ReleaseOfInformation
--)
--SELECT DISTINCT
--	PC.PatientCaseID , -- PatientCaseID - int
--	ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
--	3 , -- case - int
--	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
--	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
--	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
--	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
--	0, -- CardOnFile - bit
--	CASE
--		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
--		WHEN TP.PatientRelationshipToInsured IN ('C','Child') THEN 'C'
--		WHEN TP.PatientRelationshipToInsured IN ('O','Other') THEN 'O'
--		WHEN TP.PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
--		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
--	'', -- HolderPrefix - varchar(16)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
--	'', -- HolderSuffix - varchar(16)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(TP.HolderDOB) = 1 AND TP.HolderDOB <> '1/1/1900' THEN TP.HolderDOB ELSE NULL END END, -- TP.HolderDOB - datetime
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(TP.HolderSSN) = 9 THEN TP.HolderSSN ELSE NULL END END, -- HolderSSN
--	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
--	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
--	0 , -- PatientInsuranceStatusID - int
--	GETDATE(),
--	0 , -- CreatedUserID - int
--	GETDATE(),
--	0 , -- ModifiedUserID - int
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN TP.HolderGender IN ('M','Male') THEN 'M' WHEN TP.HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderCity,128) END, -- HolderCity - varchar(128)
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(TP.HolderState,2)) END, -- HolderState
--	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
--		WHEN LEN(TP.HolderZipCode) IN (5,9) THEN TP.HolderZipCode
--		WHEN LEN(TP.HolderZipCode) = 4 THEN '0' + TP.HolderZipCode
--		ELSE '' END END, -- HolderZipCode - varchar(9)
--	'', -- HolderPhone - varchar(10)
--	'' , -- HolderPhoneExt - varchar(10)
--	LEFT(TP.PolicyNumber, 32) , -- DependentPolicyNumber - varchar(32)
--    TP.PolicyNote + CHAR(13) + CHAR(10) + CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
--	TP.Copay, -- Copay - money
--	TP.Deductible, -- Deductible - money
--	1, -- Active - bit
--	@PracticeID , -- PracticeID - int
--	PAT.VendorID , -- VendorID - varchar(50)
--	@NewVendorImportID , -- VendorImportID - int
--	'' , -- GroupName - varchar(14)
--	'Y'  -- ReleaseOfInformation - varchar(1)
--FROM #tempPolicies3 AS TP
--	JOIN dbo.Patient AS PAT ON VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID) AND VendorID = PatientVendorID
--	JOIN dbo.PatientCase AS PC ON PAT.PatientID = pc.PatientID AND PC.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
--	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
--	LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 3
--WHERE ip.InsurancePolicyID IS NULL AND tp.InsuranceColumnCount = 3
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Updating Appointment - Cancelled 1 of 3...'
UPDATE dbo.Appointment
	SET AppointmentConfirmationStatusCode = 'X' , 
		Notes = 'Conversion Error'
FROM dbo.[_import_8_1_491171PatientApptsUpdate1] i 
INNER JOIN dbo.Appointment a ON
	i.apptid = a.[Subject] AND
	a.PracticeID = @PracticeID
WHERE i.apptreschedid <> '' AND a.AppointmentType = 'P'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating Appointment - Cancelled 2 of 3...'
UPDATE dbo.Appointment
	SET AppointmentConfirmationStatusCode = 'X' , 
		Notes = 'Conversion Error'
FROM dbo.[_import_9_1_491171PatientApptsUpdate2] i 
INNER JOIN dbo.Appointment a ON
	i.apptid = a.[Subject] AND
	a.PracticeID = @PracticeID
WHERE i.apptreschedid <> '' AND a.AppointmentType = 'P'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating Appointment - Cancelled 3 of 3...'
UPDATE dbo.Appointment
	SET AppointmentConfirmationStatusCode = 'X' , 
		Notes = 'Conversion Error'
FROM dbo.[_import_10_1_491171PatientApptsUpdate3] i 
INNER JOIN dbo.Appointment a ON
	i.apptid = a.[Subject] AND
	a.PracticeID = @PracticeID
WHERE i.apptreschedid <> '' AND a.AppointmentType = 'P'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

CREATE TABLE #tempappt (ApptID VARCHAR(50) , ChartNumber VARCHAR(50) , DoctorFirstName VARCHAR(64) , DoctorLastName VARCHAR(64) , 
						PatientFirstName VARCHAR(64) , PatientMiddleName VARCHAR(64) , PatientLastName VARCHAR(64) , 
						StartDate DATETIME , EndDate DATETIME , [Status] VARCHAR(25) , Note VARCHAR(MAX) , ServiceLocationName VARCHAR(125), 
						ResourceDesc VARCHAR(50) , ResourceID VARCHAR(50) , ApptRescheduled VARCHAR(50) , PatientID INT)

--PRINT ''
--PRINT 'Inserting Into #Tempappt 1 of 3...'
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
          ResourceID ,
          ApptRescheduled ,
		  PatientID
        )
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          i.servicelocationname , -- ServiceLocationName - varchar(125)
          i.practiceresource , -- ResourceDesc - varchar(50)
          i.resourceid , -- ResourceID - varchar(50)
          i.apptreschedid ,  -- ApptRescheduled - varchar(50)
		  p.PatientID
FROM dbo.[_import_8_1_491171PatientApptsUpdate1] i
INNER JOIN dbo.Patient p ON 
	i.chartnumber = p.VendorID AND
	p.PracticeID = @PracticeID
LEFT JOIN dbo.Appointment a ON 
	i.apptid = a.[Subject] 
WHERE a.AppointmentID IS NULL 
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into #Tempappt 2 of 3...'
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
          ResourceID ,
          ApptRescheduled , 
		  PatientID
        )
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          i.servicelocationname , -- ServiceLocationName - varchar(125)
          i.practiceresource , -- ResourceDesc - varchar(50)
          i.resourceid , -- ResourceID - varchar(50)
          i.apptreschedid , -- ApptRescheduled - varchar(50)
		  p.PatientID
FROM dbo.[_import_9_1_491171PatientApptsUpdate2] i
INNER JOIN dbo.Patient p ON 
	i.chartnumber = p.VendorID AND
	p.PracticeID = @PracticeID
LEFT JOIN dbo.Appointment a ON 
	i.apptid = a.[Subject] 
WHERE a.AppointmentID IS NULL 
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into #Tempappt 3 of 3...'
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
          ResourceID ,
          ApptRescheduled ,
		  PatientID
        )
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          i.servicelocationname , -- ServiceLocationName - varchar(125)
          i.practiceresource , -- ResourceDesc - varchar(50)
          i.resourceid , -- ResourceID - varchar(50)
          i.apptreschedid ,  -- ApptRescheduled - varchar(50)
		  p.PatientID
FROM dbo.[_import_10_1_491171PatientApptsUpdate3] i
INNER JOIN dbo.Patient p ON 
	i.chartnumber = p.VendorID AND
	p.PracticeID = @PracticeID
LEFT JOIN dbo.Appointment a ON 
	i.apptid = a.[Subject] 
WHERE a.AppointmentID IS NULL
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- added patient case
PRINT ''
PRINT 'Updating Appointments - From Other to Patient...'
UPDATE dbo.Appointment
	SET PatientID = i.PatientID ,
		AppointmentType = 'P' , 
		[Subject] = i.apptid , 
	    AppointmentConfirmationStatusCode = CASE WHEN i.ApptRescheduled <> '' THEN 'X' ELSE AppointmentConfirmationStatusCode END ,
		ModifiedDate = GETDATE() ,
		Notes = CASE WHEN i.ApptRescheduled <> '' THEN 'Conversion Error' ELSE a.Notes END
FROM dbo.Appointment a 
INNER JOIN #tempappt i ON 
	a.StartDate = CAST(i.startdate AS DATETIME) AND 
	a.EndDate = CAST(i.enddate AS DATETIME) AND
    CAST(a.Notes AS VARCHAR(MAX)) = i.note  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating AppointmenttoResource - Resource 1 of 3...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = CASE i.practiceresource WHEN 'Visual Field Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-VF-ONLY' AND LastName = 'TECH')
										  WHEN 'Ortho Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-ORTHO' AND LastName = 'TECH')
									 	  WHEN 'Technician Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Technician Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'TECH')
									 	  WHEN 'Technician Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'TECH')
									 	  WHEN 'Technician Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'TECH')
									 	  WHEN 'Technician Sequim' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SQC' AND LastName = 'TECH')
									 	  WHEN 'Technician Smokey Point' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SPC' AND LastName = 'TECH')
									 	  WHEN 'Photo Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Photo Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'PHOTO')
				    ELSE atr.ResourceID END ,
		AppointmentResourceTypeID = CASE i.practiceresource WHEN 'Visual Field Seattle' THEN 1
										  WHEN 'Ortho Seattle' THEN 1
									 	  WHEN 'Technician Bellingham' THEN 1
									 	  WHEN 'Technician Mount Vernon' THEN 1
									 	  WHEN 'Technician Renton' THEN 1
									 	  WHEN 'Technician Seattle' THEN 1
									 	  WHEN 'Technician Sequim' THEN 1
									 	  WHEN 'Technician Smokey Point' THEN 1
									 	  WHEN 'Photo Bellingham' THEN 1
									 	  WHEN 'Photo Mount Vernon' THEN 1
									 	  WHEN 'Photo Seattle' THEN 1
									 	  WHEN 'Photo Renton' THEN 1
									ELSE atr.AppointmentResourceTypeID END ,
		ModifiedDate = GETDATE()
FROM dbo.AppointmentToResource atr 
INNER JOIN dbo.Appointment a ON 
	atr.AppointmentID = a.AppointmentID AND 
	atr.PracticeID = @PracticeID
INNER JOIN dbo.[_import_8_1_491171PatientApptsUpdate1] i ON 
	a.[Subject] = i.apptid 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating AppointmenttoResource - Resource 2 of 3...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = CASE i.practiceresource WHEN 'Visual Field Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-VF-ONLY' AND LastName = 'TECH')
										  WHEN 'Ortho Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-ORTHO' AND LastName = 'TECH')
									 	  WHEN 'Technician Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Technician Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'TECH')
									 	  WHEN 'Technician Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'TECH')
									 	  WHEN 'Technician Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'TECH')
									 	  WHEN 'Technician Sequim' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SQC' AND LastName = 'TECH')
									 	  WHEN 'Technician Smokey Point' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SPC' AND LastName = 'TECH')
									 	  WHEN 'Photo Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Photo Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'PHOTO')
				    ELSE atr.ResourceID END ,
		AppointmentResourceTypeID = CASE i.practiceresource WHEN 'Visual Field Seattle' THEN 1
										  WHEN 'Ortho Seattle' THEN 1
									 	  WHEN 'Technician Bellingham' THEN 1
									 	  WHEN 'Technician Mount Vernon' THEN 1
									 	  WHEN 'Technician Renton' THEN 1
									 	  WHEN 'Technician Seattle' THEN 1
									 	  WHEN 'Technician Sequim' THEN 1
									 	  WHEN 'Technician Smokey Point' THEN 1
									 	  WHEN 'Photo Bellingham' THEN 1
									 	  WHEN 'Photo Mount Vernon' THEN 1
									 	  WHEN 'Photo Seattle' THEN 1
									 	  WHEN 'Photo Renton' THEN 1
									ELSE atr.AppointmentResourceTypeID END ,
		ModifiedDate = GETDATE()
FROM dbo.AppointmentToResource atr 
INNER JOIN dbo.Appointment a ON 
	atr.AppointmentID = a.AppointmentID AND 
	atr.PracticeID = @PracticeID
INNER JOIN dbo.[_import_9_1_491171PatientApptsUpdate2] i ON 
	a.[Subject] = i.apptid 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating AppointmenttoResource - Resource 3 of 3...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = CASE i.practiceresource WHEN 'Visual Field Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-VF-ONLY' AND LastName = 'TECH')
										  WHEN 'Ortho Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-ORTHO' AND LastName = 'TECH')
									 	  WHEN 'Technician Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Technician Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'TECH')
									 	  WHEN 'Technician Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'TECH')
									 	  WHEN 'Technician Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'TECH')
									 	  WHEN 'Technician Sequim' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SQC' AND LastName = 'TECH')
									 	  WHEN 'Technician Smokey Point' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SPC' AND LastName = 'TECH')
									 	  WHEN 'Photo Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Photo Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'PHOTO')
				    ELSE atr.ResourceID END ,
		AppointmentResourceTypeID = CASE i.practiceresource WHEN 'Visual Field Seattle' THEN 1
										  WHEN 'Ortho Seattle' THEN 1
									 	  WHEN 'Technician Bellingham' THEN 1
									 	  WHEN 'Technician Mount Vernon' THEN 1
									 	  WHEN 'Technician Renton' THEN 1
									 	  WHEN 'Technician Seattle' THEN 1
									 	  WHEN 'Technician Sequim' THEN 1
									 	  WHEN 'Technician Smokey Point' THEN 1
									 	  WHEN 'Photo Bellingham' THEN 1
									 	  WHEN 'Photo Mount Vernon' THEN 1
									 	  WHEN 'Photo Seattle' THEN 1
									 	  WHEN 'Photo Renton' THEN 1
									ELSE atr.AppointmentResourceTypeID END ,
		ModifiedDate = GETDATE()
FROM dbo.AppointmentToResource atr 
INNER JOIN dbo.Appointment a ON 
	atr.AppointmentID = a.AppointmentID AND 
	atr.PracticeID = @PracticeID
INNER JOIN dbo.[_import_10_1_491171PatientApptsUpdate3] i ON 
	a.[Subject] = i.apptid 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating Appointments - Modified Date...'
UPDATE dbo.Appointment
	SET ModifiedDate = GETDATE()
FROM dbo.Appointment a 
INNER JOIN dbo.AppointmentToResource atr ON 
	a.AppointmentID = atr.AppointmentID
WHERE atr.ModifiedDate > DATEADD(mi,-10,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

CREATE TABLE #tempappt2 (ApptID VARCHAR(50) , ChartNumber VARCHAR(50) , DoctorFirstName VARCHAR(64) , DoctorLastName VARCHAR(64) , 
						PatientFirstName VARCHAR(64) , PatientMiddleName VARCHAR(64) , PatientLastName VARCHAR(64) , 
						StartDate DATETIME , EndDate DATETIME , [Status] VARCHAR(25) , Note VARCHAR(MAX) , ServiceLocationName VARCHAR(125), 
						ResourceDesc VARCHAR(50) , ResourceID VARCHAR(50) , ApptRescheduled VARCHAR(50) , PatientID INT)

--PRINT ''
--PRINT 'Inserting Into #Tempappt2 1 of 3...'
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
          ResourceID ,
          ApptRescheduled ,
		  PatientID
        )
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END, -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          i.servicelocationname , -- ServiceLocationName - varchar(125)
          i.practiceresource , -- ResourceDesc - varchar(50)
          i.resourceid , -- ResourceID - varchar(50)
          i.apptreschedid ,  -- ApptRescheduled - varchar(50)
		  p.PatientID
FROM dbo.[_import_8_1_491171PatientApptsUpdate1] i
LEFT JOIN dbo.Patient p ON 
	i.chartnumber = p.VendorID
LEFT JOIN dbo.Appointment a ON 
	i.apptid = a.[Subject] 
WHERE a.AppointmentID IS NULL
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into #Tempappt2 2 of 3...'
INSERT INTO #tempappt2
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
          ResourceID ,
          ApptRescheduled ,
		  PatientID
        )
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          i.servicelocationname , -- ServiceLocationName - varchar(125)
          i.practiceresource , -- ResourceDesc - varchar(50)
          i.resourceid , -- ResourceID - varchar(50)
          i.apptreschedid ,  -- ApptRescheduled - varchar(50)
		  p.PatientID
FROM dbo.[_import_9_1_491171PatientApptsUpdate2] i
LEFT JOIN dbo.Patient p ON 
	i.chartnumber = p.VendorID
LEFT JOIN dbo.Appointment a ON 
	i.apptid = a.[Subject] 
WHERE a.AppointmentID IS NULL
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--PRINT ''
--PRINT 'Inserting Into #Tempappt2 3 of 3...'
INSERT INTO #tempappt2
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
		  ResourceID ,
          ApptRescheduled ,
		  PatientID
        )
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          i.servicelocationname , -- ServiceLocationName - varchar(125)
          i.practiceresource , -- ResourceDesc - varchar(50)
          i.resourceid , -- ResourceID - varchar(50)
          i.apptreschedid ,  -- ApptRescheduled - varchar(50)
		  p.PatientID
FROM dbo.[_import_10_1_491171PatientApptsUpdate3] i
LEFT JOIN dbo.Patient p ON 
	i.chartnumber = p.VendorID
LEFT JOIN dbo.Appointment a ON 
	i.apptid = a.[Subject] 
WHERE a.AppointmentID IS NULL
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
			  CAST(REPLACE(LEFT(CAST(pa.startdate AS TIME),5), ':','') AS SMALLINT) ,   -- StartTm - smallint
	          CAST(REPLACE(LEFT(CAST(pa.enddate AS TIME),5), ':','') AS SMALLINT) , 
			  PA.apptid 
	FROM #tempappt2 PA
	INNER JOIN dbo.Patient PAT ON 
		PA.PatientID = PAT.PatientID AND
		PAT.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase PC ON 
		PC.PatientID = PAT.PatientID AND
		PC.PracticeID = @PracticeID  
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(PA.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation SL ON
		SL.NAME = PA.ServiceLocationName AND
		SL.PracticeID = @PracticeID  
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
WHERE PA.ApptRescheduled = ''
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
	          CASE WHEN DOC.DoctorID IS NULL THEN 
				CASE PA.ResourceDesc	  WHEN 'Visual Field Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-VF-ONLY' AND LastName = 'TECH')
										  WHEN 'Ortho Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-ORTHO' AND LastName = 'TECH')
									 	  WHEN 'Technician Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Technician Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'TECH')
									 	  WHEN 'Technician Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'TECH')
									 	  WHEN 'Technician Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'TECH')
									 	  WHEN 'Technician Sequim' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SQC' AND LastName = 'TECH')
									 	  WHEN 'Technician Smokey Point' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SPC' AND LastName = 'TECH')
									 	  WHEN 'Photo Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Photo Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'PHOTO')
			  END 
			  ELSE doc.DoctorID END , -- ResourceID - int
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM #tempappt2 PA
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
WHERE app.CreatedDate > DATEADD(mi,-15,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Appointment - Other...'
	INSERT INTO dbo.Appointment
	        ( PracticeID ,
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
	          StartDKPracticeID ,
	          EndDKPracticeID ,
	          StartTm ,
	          EndTm 
	        )
	SELECT DISTINCT   @PracticeID , -- PracticeID - int
	          CASE WHEN SL.ServiceLocationID IS NULL THEN 
						SL2.ServiceLocationID ELSE SL.ServiceLocationID END , -- ServiceLocationID - int
	          OA.StartDate , -- StartDate - datetime
	          OA.EndDate , -- EndDate - datetime
	          'O' , -- AppointmentType - varchar(1)
	          OA.patientfirstname + ' ' + OA.patientmiddlename + ' ' + OA.patientlastname , -- Subject - varchar(64)
	          OA.Note , -- Notes - text
	          GETDATE() , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          1 , -- AppointmentResourceTypeID - int
	          CASE  WHEN OA.[STATUS] IN ('C','Confirmed') THEN 'C' 
				    WHEN OA.[STATUS] IN ('E','Seen') THEN 'E'
				    WHEN OA.[STATUS] IN ('I','Check-in') THEN 'I'
					WHEN OA.[STATUS] IN ('N','No-show') THEN 'N'
					WHEN OA.[STATUS] IN ('O','Check-out') THEN 'O' 
					WHEN OA.[STATUS] IN ('R','Rescheduled') THEN 'R'
					WHEN OA.[STATUS] IN ('S','Scheduled') THEN 'S'
					WHEN OA.[STATUS] IN ('X','Cancelled') THEN 'X'
					ELSE 'S' END, -- AppointmentConfirmationStatusCode - char(1)
	          DK.DKPracticeID , -- StartDKPracticeID - int
	          DK.DKPracticeID , -- EndDKPracticeID - int
			  CAST(REPLACE(LEFT(CAST(OA.startdate AS TIME),5), ':','') AS SMALLINT) ,   -- StartTm - smallint
	          CAST(REPLACE(LEFT(CAST(OA.enddate AS TIME),5), ':','') AS SMALLINT) 
	FROM #tempappt2 OA
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(OA.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation SL ON
		SL.NAME = OA.ServiceLocationName AND
		SL.PracticeID = @PracticeID  
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
	LEFT JOIN dbo.Appointment a ON 
	    OA.apptid = a.[Subject] AND
		a.PracticeID = @PracticeID
WHERE a.AppointmentID IS NULL AND oa.ApptRescheduled = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Resource - Other...'	
	INSERT INTO dbo.AppointmentToResource
	        ( AppointmentID ,
	          AppointmentResourceTypeID ,
	          ResourceID ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT DISTINCT   APP.AppointmentID , -- AppointmentID - int
	          1 , -- AppointmentResourceTypeID - int
	          CASE WHEN DOC.DoctorID IS NULL THEN 
				CASE OA.ResourceDesc	  WHEN 'Visual Field Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-VF-ONLY' AND LastName = 'TECH')
										  WHEN 'Ortho Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-ORTHO' AND LastName = 'TECH')
									 	  WHEN 'Technician Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Technician Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'TECH')
									 	  WHEN 'Technician Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'TECH')
									 	  WHEN 'Technician Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'TECH')
									 	  WHEN 'Technician Sequim' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SQC' AND LastName = 'TECH')
									 	  WHEN 'Technician Smokey Point' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SPC' AND LastName = 'TECH')
									 	  WHEN 'Photo Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Photo Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'PHOTO')
			  END ELSE DOC.DoctorID END  , -- ResourceID - int
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM #tempappt2 OA
	INNER JOIN dbo.Appointment APP ON 
		OA.patientfirstname + ' ' + OA.patientmiddlename + ' ' + OA.patientlastname = APP.[Subject] AND 
		APP.StartDate = CAST(OA.startdate AS DATETIME) AND
        APP.AppointmentType = 'O'
	LEFT JOIN dbo.Doctor DOC ON
		DOC.FirstName = OA.DoctorFirstName AND
		DOC.LastName = OA.DoctorLastName AND
		DOC.PracticeID = @PracticeID AND
		DOC.[EXTERNAL] = 0  
	LEFT JOIN dbo.AppointmentToResource atr ON 
		APP.AppointmentID = atr.AppointmentID AND 
		atr.PracticeID = @PracticeID
WHERE atr.AppointmentToResourceID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 5 , Name = 'Default Case'
FROM dbo.PatientCase pc 
LEFT JOIN dbo.InsurancePolicy ip ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @PracticeID AND
    ip.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID)
WHERE pc.CreatedUserID = 0 AND pc.ModifiedUserID = 0 AND pc.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@NewVendorImportID) AND ip.InsurancePolicyID IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #inspolupdate
DROP TABLE #updatepat
DROP TABLE #temppat
DROP TABLE #tempPolicies1
DROP TABLE #tempPolicies2
--DROP TABLE #tempPolicies3
DROP TABLE #tempappt
DROP TABLE #tempappt2

--ROLLBACK
--COMMIT




