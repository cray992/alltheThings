USE superbill_39795_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 22
SET @VendorImportID = 62

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


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
--INNER JOIN dbo.[_import_63_22_PatientDemographics] i ON p.PatientID = i.id

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  ,
--		SSN = i.ssn
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #updatepat

/*==========================================================================*/


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
FROM dbo._import_62_22_PatientDemographics AS PD
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
	LEFT JOIN dbo.Patient pat ON PD.chartnumber = pat.VendorID AND pat.PracticeID = @PracticeID
WHERE PD.firstname <> '' AND PD.lastname <> '' AND pat.PatientID IS NULL
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
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo._import_62_22_PatientDemographics pd
	JOIN dbo.Patient AS PAT ON VendorImportID = @VendorImportID AND VendorID = pd.chartnumber
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

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
			  CAST(REPLACE(RIGHT(PA.StartDate,5), ':','') AS SMALLINT)   , -- StartTm - smallint
	          CAST(REPLACE(RIGHT(PA.EndDate,5),  ':', '') AS SMALLINT),
			  PA.elationapptid
	FROM dbo._import_62_22_PatientAppointments PA
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
		CAST(pa.startdate AS DATETIME) = a.StartDate AND 
		CAST(pa.enddate AS DATETIME) = a.EndDate AND
		PAT.PatientID = a.PatientID AND 
		a.PracticeID = @PracticeID
WHERE a.AppointmentID IS NULL 
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
	SELECT DISTINCT    APP.AppointmentID , -- AppointmentID - int
	          AR.AppointmentReasonID , -- AppointmentReasonID - int
	          1 , -- PrimaryAppointment - bit
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo._import_62_22_PatientAppointments PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		PAT.PatientID = APP.PatientID AND
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.ENDDate = CAST(PA.EndDate AS DateTime) AND
		PA.elationapptid = APP.[Subject]     
	INNER JOIN dbo.AppointmentReason AR ON
		PA.[Reasons] = AR.NAME AND
		AR.PracticeID = @PracticeID
WHERE APP.CreatedDate > DATEADD(mi,-1,GETDATE())
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
	          DOC.DoctorID , -- ResourceID - int
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo._import_62_22_PatientAppointments PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		APP.PatientId = PAT.PatientID AND 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime) AND
		PA.elationapptid = APP.[Subject]     
	INNER JOIN dbo.Doctor DOC ON
		DOC.FirstName = PA.DoctorFirstName AND
		DOC.LastName = PA.DoctorLastName AND
		DOC.PracticeID = @PracticeID AND
		DOC.[EXTERNAL] = 0  AND
		DOC.ActiveDoctor = 1  
WHERE APP.CreatedDate > DATEADD(mi,-1,GETDATE())  
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
	SELECT    CASE WHEN PJN.CreatedDate  = '' THEN GETDATE() ELSE PJN.CreatedDate END , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          PAT.PatientID , -- PatientID - int
	          CASE WHEN PJN.UserName = '' THEN 'Kareo' ELSE UserName END  , -- UserName - varchar(128)
	          'K' , -- SoftwareApplicationID - char(1)
	          0 , -- Hidden - bit
	          PJN.NoteMessage , -- NoteMessage - varchar(max)
	          0 , -- AccountStatus - bit
	          1 , -- NoteTypeCode - int
	          0  -- LastNote - bit
	FROM dbo.[_import_62_22_PatientJournalNote] PJN
	INNER JOIN dbo.Patient PAT ON
		PJN.ChartNumber = PAT.VendorID AND
		PAT.PracticeID = @PracticeID AND
        pat.VendorImportID = @VendorImportID
	WHERE pjn.notemessage <> ''	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT