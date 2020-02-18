USE superbill_49117_dev
--USE superbill_479117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @NewVendorImportID INT

SET @PracticeID = 1
SET @NewVendorImportID = 20

SET NOCOUNT ON 
-- FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) ,
--	    HomePhone = i.homephone , 
--		HomePhoneExt = i.homephoneext ,
--		WorkPhone = i.workphone ,
--		WorkPhoneExt = i.workphoneext ,
--		MobilePhone = i.mobilephone ,
--		MobilePhoneExt = i.mobilephoneext ,
--		SSN = i.ssn
--FROM dbo.[_import_21_1_PatientDemographics] i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = CAST(i.id AS INT)
--WHERE i.id <> ''
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

-- Updating service location names in import appointment tables to match those in the account
UPDATE dbo.[_import_16_1_491171PatientApptsUpdate1] 
	SET servicelocationname = CASE servicelocationname 
								WHEN 'MVC NW Eye Surgeons' THEN 'MVC N.W. Eye Surgeons'
								WHEN 'MVS NW Eye Surgeons' THEN 'MVS N.W. Eye Surgeons'
								WHEN 'RC NW Eye Surgeons' THEN 'RC N.W. Eye Surgeons'
								WHEN 'RS NW Eye Surgeons' THEN 'RS N.W. Eye Surgeons'
								WHEN 'SC NW Eye Surgeons' THEN 'SC N.W. Eye Surgeons'
								WHEN 'SPC NW Eye Surgeons' THEN 'SPC N.W. Eye Surgeons'
								WHEN 'SQC NW Eye Surgeons' THEN 'SQC N.W. Eye Surgeons'
								WHEN 'SQS NW Eye Surgeons' THEN 'SQS N.W. Eye Surgeons'
								WHEN 'SS NW Eye Surgeons' THEN 'SS N.W. Eye Surgeons'
								WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
							  ELSE servicelocationname END

UPDATE dbo.[_import_17_1_491171PatientApptsUpdate2] 
	SET servicelocationname = CASE servicelocationname 
								WHEN 'MVC NW Eye Surgeons' THEN 'MVC N.W. Eye Surgeons'
								WHEN 'MVS NW Eye Surgeons' THEN 'MVS N.W. Eye Surgeons'
								WHEN 'RC NW Eye Surgeons' THEN 'RC N.W. Eye Surgeons'
								WHEN 'RS NW Eye Surgeons' THEN 'RS N.W. Eye Surgeons'
								WHEN 'SC NW Eye Surgeons' THEN 'SC N.W. Eye Surgeons'
								WHEN 'SPC NW Eye Surgeons' THEN 'SPC N.W. Eye Surgeons'
								WHEN 'SQC NW Eye Surgeons' THEN 'SQC N.W. Eye Surgeons'
								WHEN 'SQS NW Eye Surgeons' THEN 'SQS N.W. Eye Surgeons'
								WHEN 'SS NW Eye Surgeons' THEN 'SS N.W. Eye Surgeons'
								WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
							  ELSE servicelocationname END

UPDATE dbo.[_import_18_1_491171PatientApptsUpdate3] 
	SET servicelocationname = CASE servicelocationname 
								WHEN 'MVC NW Eye Surgeons' THEN 'MVC N.W. Eye Surgeons'
								WHEN 'MVS NW Eye Surgeons' THEN 'MVS N.W. Eye Surgeons'
								WHEN 'RC NW Eye Surgeons' THEN 'RC N.W. Eye Surgeons'
								WHEN 'RS NW Eye Surgeons' THEN 'RS N.W. Eye Surgeons'
								WHEN 'SC NW Eye Surgeons' THEN 'SC N.W. Eye Surgeons'
								WHEN 'SPC NW Eye Surgeons' THEN 'SPC N.W. Eye Surgeons'
								WHEN 'SQC NW Eye Surgeons' THEN 'SQC N.W. Eye Surgeons'
								WHEN 'SQS NW Eye Surgeons' THEN 'SQS N.W. Eye Surgeons'
								WHEN 'SS NW Eye Surgeons' THEN 'SS N.W. Eye Surgeons'
								WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
							  ELSE servicelocationname END

UPDATE dbo.[_import_19_1_491171PatientApptsUpdate4] 
	SET servicelocationname = CASE servicelocationname 
								WHEN 'MVC NW Eye Surgeons' THEN 'MVC N.W. Eye Surgeons'
								WHEN 'MVS NW Eye Surgeons' THEN 'MVS N.W. Eye Surgeons'
								WHEN 'RC NW Eye Surgeons' THEN 'RC N.W. Eye Surgeons'
								WHEN 'RS NW Eye Surgeons' THEN 'RS N.W. Eye Surgeons'
								WHEN 'SC NW Eye Surgeons' THEN 'SC N.W. Eye Surgeons'
								WHEN 'SPC NW Eye Surgeons' THEN 'SPC N.W. Eye Surgeons'
								WHEN 'SQC NW Eye Surgeons' THEN 'SQC N.W. Eye Surgeons'
								WHEN 'SQS NW Eye Surgeons' THEN 'SQS N.W. Eye Surgeons'
								WHEN 'SS NW Eye Surgeons' THEN 'SS N.W. Eye Surgeons'
								WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
							  ELSE servicelocationname END


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
FROM dbo.[_import_20_1_503941PatientDemoUpdate1] AS PD
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
	LEFT JOIN dbo.Patient p ON PD.personid = p.VendorID AND p.VendorImportID IN (0,5,6)
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
FROM dbo.[_import_20_1_503941PatientDemoUpdate1] pd
	INNER JOIN dbo.Patient AS PAT ON pat.VendorImportID = @NewVendorImportID AND pat.VendorID = pd.personid
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
FROM dbo.[_import_20_1_503941PatientDemoUpdate1] i 
INNER JOIN dbo.Patient p ON
	i.personid = p.VendorID AND 
	p.VendorImportID = @NewVendorImportID
WHERE i.patchurchnote <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Appointment - Cancelled 1 of 4...'
UPDATE dbo.Appointment
	SET AppointmentConfirmationStatusCode = 'X' , 
		Notes = 'Conversion Error'
FROM dbo.[_import_16_1_491171PatientApptsUpdate1] i 
INNER JOIN dbo.Appointment a ON
	i.apptid = a.[Subject] AND
	a.PracticeID = @PracticeID
WHERE i.apptrescheduled <> '' AND a.AppointmentType = 'P'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating Appointment - Cancelled 2 of 4...'
UPDATE dbo.Appointment
	SET AppointmentConfirmationStatusCode = 'X' , 
		Notes = 'Conversion Error'
FROM dbo.[_import_17_1_491171PatientApptsUpdate2] i 
INNER JOIN dbo.Appointment a ON
	i.apptid = a.[Subject] AND
	a.PracticeID = @PracticeID
WHERE i.apptrescheduled <> '' AND a.AppointmentType = 'P'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating Appointment - Cancelled 3 of 4...'
UPDATE dbo.Appointment
	SET AppointmentConfirmationStatusCode = 'X' , 
		Notes = 'Conversion Error'
FROM dbo.[_import_18_1_491171PatientApptsUpdate3] i 
INNER JOIN dbo.Appointment a ON
	i.apptid = a.[Subject] AND
	a.PracticeID = @PracticeID
WHERE i.apptrescheduled <> '' AND a.AppointmentType = 'P'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating Appointment - Cancelled 4 of 4...'
UPDATE dbo.Appointment
	SET AppointmentConfirmationStatusCode = 'X' , 
		Notes = 'Conversion Error'
FROM dbo.[_import_19_1_491171PatientApptsUpdate4] i 
INNER JOIN dbo.Appointment a ON
	i.apptid = a.[Subject] AND
	a.PracticeID = @PracticeID
WHERE i.apptrescheduled <> '' AND a.AppointmentType = 'P'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 



CREATE TABLE #tempappt (ApptID VARCHAR(50) , ChartNumber VARCHAR(50) , DoctorFirstName VARCHAR(64) , DoctorLastName VARCHAR(64) , 
						PatientFirstName VARCHAR(64) , PatientMiddleName VARCHAR(64) , PatientLastName VARCHAR(64) , 
						StartDate DATETIME , EndDate DATETIME , [Status] VARCHAR(25) , Note VARCHAR(MAX) , ServiceLocationName VARCHAR(125), 
						ResourceDesc VARCHAR(50) , ResourceID VARCHAR(50) , ApptRescheduled VARCHAR(50) , PatientID INT)

PRINT ''
PRINT 'Inserting Into #TempPat 1 of 4...'
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
          i.doctorlastname , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          i.servicelocationname , -- ServiceLocationName - varchar(125)
          i.resourcedesc , -- ResourceDesc - varchar(50)
          i.resourceid , -- ResourceID - varchar(50)
          i.apptrescheduled ,  -- ApptRescheduled - varchar(50)
		  p.PatientID
FROM dbo.[_import_16_1_491171PatientApptsUpdate1] i
INNER JOIN dbo.Patient p ON 
	i.chartnumber = p.VendorID AND 
	p.VendorImportID = @NewVendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into #TempPat 2 of 4...'
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
          i.doctorlastname , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          i.servicelocationname , -- ServiceLocationName - varchar(125)
          i.resourcedesc , -- ResourceDesc - varchar(50)
          i.resourceid , -- ResourceID - varchar(50)
          i.apptrescheduled , -- ApptRescheduled - varchar(50)
		  p.PatientID
FROM dbo.[_import_17_1_491171PatientApptsUpdate2] i
INNER JOIN dbo.Patient p ON 
	i.chartnumber = p.VendorID AND 
	p.VendorImportID = @NewVendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into #TempPat 3 of 4...'
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
          i.doctorlastname , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          i.servicelocationname , -- ServiceLocationName - varchar(125)
          i.resourcedesc , -- ResourceDesc - varchar(50)
          i.resourceid , -- ResourceID - varchar(50)
          i.apptrescheduled ,  -- ApptRescheduled - varchar(50)
		  p.PatientID
FROM dbo.[_import_18_1_491171PatientApptsUpdate3] i
INNER JOIN dbo.Patient p ON 
	i.chartnumber = p.VendorID AND 
	p.VendorImportID = @NewVendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into #TempPat 4 of 4...'
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
          i.doctorlastname , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          i.servicelocationname , -- ServiceLocationName - varchar(125)
          i.resourcedesc , -- ResourceDesc - varchar(50)
          i.resourceid , -- ResourceID - varchar(50)
          i.apptrescheduled ,  -- ApptRescheduled - varchar(50)
		  p.PatientID
FROM dbo.[_import_19_1_491171PatientApptsUpdate4] i
INNER JOIN dbo.Patient p ON 
	i.chartnumber = p.VendorID AND 
	p.VendorImportID = @NewVendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Appointments - From Other to Patient...'
UPDATE dbo.Appointment
	SET PatientID = i.PatientID ,
		AppointmentType = 'P' , 
		[Subject] = i.apptid , 
	    AppointmentConfirmationStatusCode = CASE WHEN i.ApptRescheduled <> '' THEN 'X' ELSE AppointmentConfirmationStatusCode END
FROM dbo.Appointment a 
INNER JOIN #tempappt i ON 
	a.StartDate = CAST(i.startdate AS DATETIME) AND 
	a.EndDate = CAST(i.enddate AS DATETIME) AND
    CAST(a.Notes AS VARCHAR(MAX)) = i.note  
INNER JOIN dbo.Patient p ON 
	i.patientfirstname + ' ' + i.patientmiddlename + ' ' + i.patientlastname = p.FirstName + ' ' + p.MiddleName + ' ' + p.LastName AND
	i.chartnumber = p.VendorID 
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
	FROM #tempappt PA
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
	LEFT JOIN dbo.Appointment a ON pa.ApptID = a.[Subject] AND a.PracticeID = @PracticeID
WHERE a.AppointmentID IS NULL AND PA.ApptRescheduled = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

--SELECT 			  
--CAST(REPLACE(LEFT(CAST(pa.startdate AS TIME),5), ':','') AS SMALLINT) ,
--RIGHT(CAST(PA.StartDate AS DATETIME),8)   -- StartTm - smallint
--CAST(REPLACE(RIGHT(PA.EndDate,5),  ':', '') AS SMALLINT)  
--FROM #tempappt pa

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
				CASE PA.ResourceDesc WHEN 'Visual Field Seattle' THEN 37
									 WHEN 'Ortho Seattle' THEN 35
									 WHEN 'Technician Bellingham' THEN 30
									 WHEN 'Technician Mount Vernon' THEN 32
									 WHEN 'Technician Renton' THEN 34
									 WHEN 'Technician Seattle' THEN 28
									 WHEN 'Technician Sequim' THEN 39
									 WHEN 'Technician Smokey Point' THEN 38
									 WHEN 'Photo Bellingham' THEN 30
									 WHEN 'Photo Mount Vernon' THEN 31
									 WHEN 'Photo Seattle' THEN 36
									 WHEN 'Photo Renton' THEN 33
				END
			  ELSE DOC.DoctorID END , -- ResourceID - int
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
		DOC.FirstName =  PA.DoctorFirstName  AND
		DOC.LastName = PA.DoctorLastName AND
		DOC.PracticeID = @PracticeID AND
		DOC.[EXTERNAL] = 0  
WHERE app.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Updating AppointmenttoResource - Resource 1 of 4...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = CASE i.ResourceDesc WHEN 'Visual Field Seattle' THEN 37
										  WHEN 'Ortho Seattle' THEN 35
									 	  WHEN 'Technician Bellingham' THEN 30
									 	  WHEN 'Technician Mount Vernon' THEN 32
									 	  WHEN 'Technician Renton' THEN 34
									 	  WHEN 'Technician Seattle' THEN 28
									 	  WHEN 'Technician Sequim' THEN 39
									 	  WHEN 'Technician Smokey Point' THEN 38
									 	  WHEN 'Photo Bellingham' THEN 30
									 	  WHEN 'Photo Mount Vernon' THEN 31
									 	  WHEN 'Photo Seattle' THEN 36
									 	  WHEN 'Photo Renton' THEN 33
				    ELSE atr.ResourceID END ,
		AppointmentResourceTypeID = CASE i.ResourceDesc WHEN 'Visual Field Seattle' THEN 1
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
									ELSE atr.AppointmentResourceTypeID END
FROM dbo.AppointmentToResource atr 
INNER JOIN dbo.Appointment a ON 
	atr.AppointmentID = a.AppointmentID AND 
	atr.PracticeID = @PracticeID
INNER JOIN dbo.[_import_16_1_491171PatientApptsUpdate1] i ON 
	a.[Subject] = i.apptid 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating AppointmenttoResource - Resource 2 of 4...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = CASE i.ResourceDesc WHEN 'Visual Field Seattle' THEN 37
										  WHEN 'Ortho Seattle' THEN 35
									 	  WHEN 'Technician Bellingham' THEN 30
									 	  WHEN 'Technician Mount Vernon' THEN 32
									 	  WHEN 'Technician Renton' THEN 34
									 	  WHEN 'Technician Seattle' THEN 28
									 	  WHEN 'Technician Sequim' THEN 39
									 	  WHEN 'Technician Smokey Point' THEN 38
									 	  WHEN 'Photo Bellingham' THEN 30
									 	  WHEN 'Photo Mount Vernon' THEN 31
									 	  WHEN 'Photo Seattle' THEN 36
									 	  WHEN 'Photo Renton' THEN 33
				    ELSE atr.ResourceID END ,
		AppointmentResourceTypeID = CASE i.ResourceDesc WHEN 'Visual Field Seattle' THEN 1
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
									ELSE atr.AppointmentResourceTypeID END
FROM dbo.AppointmentToResource atr 
INNER JOIN dbo.Appointment a ON 
	atr.AppointmentID = a.AppointmentID AND 
	atr.PracticeID = @PracticeID
INNER JOIN dbo.[_import_17_1_491171PatientApptsUpdate2] i ON 
	a.[Subject] = i.apptid 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating AppointmenttoResource - Resource 3 of 4...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = CASE i.ResourceDesc WHEN 'Visual Field Seattle' THEN 37
										  WHEN 'Ortho Seattle' THEN 35
									 	  WHEN 'Technician Bellingham' THEN 30
									 	  WHEN 'Technician Mount Vernon' THEN 32
									 	  WHEN 'Technician Renton' THEN 34
									 	  WHEN 'Technician Seattle' THEN 28
									 	  WHEN 'Technician Sequim' THEN 39
									 	  WHEN 'Technician Smokey Point' THEN 38
									 	  WHEN 'Photo Bellingham' THEN 30
									 	  WHEN 'Photo Mount Vernon' THEN 31
									 	  WHEN 'Photo Seattle' THEN 36
									 	  WHEN 'Photo Renton' THEN 33
				    ELSE atr.ResourceID END ,
		AppointmentResourceTypeID = CASE i.ResourceDesc WHEN 'Visual Field Seattle' THEN 1
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
									ELSE atr.AppointmentResourceTypeID END
FROM dbo.AppointmentToResource atr 
INNER JOIN dbo.Appointment a ON 
	atr.AppointmentID = a.AppointmentID AND 
	atr.PracticeID = @PracticeID
INNER JOIN dbo.[_import_18_1_491171PatientApptsUpdate3] i ON 
	a.[Subject] = i.apptid 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

PRINT ''
PRINT 'Updating AppointmenttoResource - Resource 4 of 4...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = CASE i.ResourceDesc WHEN 'Visual Field Seattle' THEN 37
										  WHEN 'Ortho Seattle' THEN 35
									 	  WHEN 'Technician Bellingham' THEN 30
									 	  WHEN 'Technician Mount Vernon' THEN 32
									 	  WHEN 'Technician Renton' THEN 34
									 	  WHEN 'Technician Seattle' THEN 28
									 	  WHEN 'Technician Sequim' THEN 39
									 	  WHEN 'Technician Smokey Point' THEN 38
									 	  WHEN 'Photo Bellingham' THEN 30
									 	  WHEN 'Photo Mount Vernon' THEN 31
									 	  WHEN 'Photo Seattle' THEN 36
									 	  WHEN 'Photo Renton' THEN 33
				    ELSE atr.ResourceID END ,
		AppointmentResourceTypeID = CASE i.ResourceDesc WHEN 'Visual Field Seattle' THEN 1
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
									ELSE atr.AppointmentResourceTypeID END
FROM dbo.AppointmentToResource atr 
INNER JOIN dbo.Appointment a ON 
	atr.AppointmentID = a.AppointmentID AND 
	atr.PracticeID = @PracticeID
INNER JOIN dbo.[_import_19_1_491171PatientApptsUpdate4] i ON 
	a.[Subject] = i.apptid 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 


DROP TABLE #tempappt

--ROLLBACK
--COMMIT


SELECT * FROM dbo.[_import_16_1_491171PatientApptsUpdate1] WHERE patientfirstname = 'Rafael' ORDER BY CAST(startdate AS DATETIME)
SELECT * FROM dbo.[_import_17_1_491171PatientApptsUpdate2] WHERE patientfirstname = 'Rafael' ORDER BY CAST(startdate AS DATETIME)
SELECT * FROM dbo.[_import_18_1_491171PatientApptsUpdate3] WHERE patientfirstname = 'Rafael' AND apptid = 'A59A0A9A-54E3-4C7E-82BC-FE3D414AEF8A' ORDER BY CAST(startdate AS DATETIME) 
SELECT * FROM dbo.[_import_19_1_491171PatientApptsUpdate4] WHERE patientfirstname = 'Rafael' ORDER BY CAST(startdate AS DATETIME)

SELECT * FROM dbo.Patient WHERE VendorID = 'C7ADEE66-65DB-4335-91A9-BADDB8D72DBD'

SELECT * FROM dbo.[_import_20_1_503941PatientDemoUpdate1] WHERE personid = 'C7ADEE66-65DB-4335-91A9-BADDB8D72DBD'
SELECT * FROM dbo.[_import_6_1_49117PatientDemographics1] WHERE personid = 'C7ADEE66-65DB-4335-91A9-BADDB8D72DBD'

SELECT * FROM dbo.Patient WHERE FirstName = 'barbara'


SELECT * FROM dbo.Patient WHERE VendorID = '2046C121-3465-4CC0-9CF0-C74E252E06CB'

