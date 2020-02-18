--USE superbill_12929_dev
USE superbill_12929_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM Appointment WHERE
	 PatientID IN (SELECT PatientID FROM Patient WHERE PracticeID = @PracticeID AND VendorImportId =@VendorImportID))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM Patient WHERE
	 PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM Patient WHERE
	 PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientAlert records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM Patient WHERE
	 PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientJournalNote records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'




-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	Prefix ,
	LastName ,
	FirstName ,
	MiddleName ,
	Suffix ,
	AddressLine1 ,
	AddressLine2 ,
	City ,
	[State] ,
	Country ,
	ZipCode ,
	Gender ,
	HomePhone ,
	WorkPhone,
	WorkPhoneExt,
	MobilePhone,
	DOB ,
	SSN ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	EmailAddress ,
	PhonecallRemindersEnabled , 
	EmergencyName , 
	ResponsibleDifferentThanPatient ,
	ResponsiblePrefix ,
	ResponsibleFirstName ,
	ResponsibleLastName , 
	ResponsibleMiddleName ,
	ResponsibleSuffix , 
	ResponsibleAddressLine1 ,
	ResponsibleAddressLine2 , 
	ResponsibleCity ,
	ResponsibleCountry , 
	ResponsibleZipCode ,
	ResponsibleRelationshipToPatient
	)
SELECT DISTINCT
	@PracticeID
	,''
	,lname
	,fname
	,mi
	,''
	,address1
	,address2
	,city
	,LEFT([state], 2)
	,''
	,LEFT(REPLACE(zipcode, '-', ''), 9)
	,CASE WHEN sex = 'F' THEN 'F' WHEN sex = 'M' THEN 'M' ELSE 'U' END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(home, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(wphone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(wkext, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(cellphone, '-', ''), '(', ''), ')', ''), ' ', ''),10)
	,CASE ISDATE(dateofbirth) WHEN 1 THEN dateofbirth ELSE NULL END 
	,LEFT(REPLACE(ssn, '-', ''), 9)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,idnum -- Unique Id Yipee
	,@VendorImportID
	,1
	,CASE WHEN active = 'Y' THEN 1 ELSE 0 END 
	,CASE WHEN email <> '' THEN 1 ELSE 0 END 
	,email
	,1
	,LEFT(contact, 128)
	,CASE WHEN guarantor = 'Y' THEN 1 ELSE 0 END 
	,'' 
	,CASE WHEN guarantor = 'Y' THEN gname ELSE NULL END 
	,''
	,''
	,''
	,CASE WHEN guarantor = 'Y' THEN gaddress1 ELSE NULL END 
	,CASE WHEN guarantor = 'Y' THEN gaddress2 ELSE NULL END 
	,CASE WHEN guarantor = 'Y' THEN gcity ELSE NULL END 
	,CASE WHEN guarantor = 'Y' THEN '' ELSE NULL END 
	,CASE WHEN guarantor = 'Y' THEN gzipcode ELSE NULL END 
	,CASE WHEN guarantor = 'Y' THEN 'O' ELSE NULL END 
FROM dbo.[_import_1_1_PatientDemographics]
WHERE fname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Journal Note
PRINT ''
PRINT 'Inserting records into Patient Journal Notes ...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          NoteMessage ,
          SoftwareApplicationID
        )
SELECT 
		GETDATE() , -- CreatedDate - datetime
        0 , -- CreatedUserID - int
        GETDATE() , -- ModifiedDate - datetime
        0 , -- ModifiedUserID - int
        realP.patientID , -- PatientID - int
        '' ,
        impPJN.memo , -- NoteMessage - varchar(max)
        'K' -- SoftwareApplicationID
FROM dbo.[_import_1_1_PatientDemographics] impPJN
LEFT JOIN dbo.Patient realP ON
	impPJN.idnum = realP.VendorID
	AND realP.VendorImportID = @VendorImportID
WHERE	
	impPJN.memo <> '' 
	AND realP.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Journal Note
PRINT ''
PRINT 'Inserting records into Patient Journal Notes #2...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          NoteMessage ,
          SoftwareApplicationID
        )
SELECT 
		GETDATE() , -- CreatedDate - datetime
        0 , -- CreatedUserID - int
        GETDATE() , -- ModifiedDate - datetime
        0 , -- ModifiedUserID - int
        realP.patientID , -- PatientID - int
        '' ,
        impPJN.gname + ' phone number: ' + impPJN.gphone, -- NoteMessage - varchar(max)
        'K' -- SoftwareApplicationID
FROM dbo.[_import_1_1_PatientDemographics] impPJN
LEFT JOIN dbo.Patient realP ON
	impPJN.idnum = realP.VendorID
	AND realP.VendorImportID = @VendorImportID
WHERE	
	impPJN.guarantor = 'Y' 
	AND realP.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Journal Note
PRINT ''
PRINT 'Inserting records into Patient Journal Notes #3...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          NoteMessage ,
          SoftwareApplicationID
        )
SELECT 
		GETDATE() , -- CreatedDate - datetime
        0 , -- CreatedUserID - int
        GETDATE() , -- ModifiedDate - datetime
        0 , -- ModifiedUserID - int
        realP.patientID , -- PatientID - int
        '' ,
        'Last visit: ' + impPJN.lastvisit , -- NoteMessage - varchar(max)
        'K' -- SoftwareApplicationID
FROM dbo.[_import_1_1_PatientDemographics] impPJN
LEFT JOIN dbo.Patient realP ON
	impPJN.idnum = realP.VendorID
	AND realP.VendorImportID = @VendorImportID
WHERE	
	impPJN.lastvisit <> '' 
	AND realP.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

--Patient Alert
PRINT ''
PRINT 'Inserting records into PatientAlert ...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          ShowInEncounterFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT    realP.patientID , -- PatientID - int
          impPA.alert , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_1_PatientDemographics] impPA
INNER JOIN dbo.Patient realP ON 
	impPA.idnum = realP.VendorID
	AND realP.VendorImportID = @VendorImportID
WHERE impPA.alert <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Appointments
PRINT ''
PRINT 'Inserting records into Appointment ...'
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
          InsurancePolicyAuthorizationID ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm
        )
SELECT    realP.patientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          	CASE WHEN LEN(schedulingDate) < 21
			THEN CAST(RTRIM(LEFT(schedulingDate,8)) AS DATETIME) + 
			CASE WHEN LEN(hmm) < 10
					THEN DATEADD(hh, -3, hmm )
				 WHEN LEN(hmm) > 10 
							THEN DATEADD(hh, -3, REPLACE(hmm, '12/30/1899', ''))
				 ELSE NULL 
			END
		ELSE CAST(RTRIM(LEFT(schedulingDate,10)) AS DATETIME) + 
			CASE WHEN LEN(hmm) < 10
					THEN DATEADD(hh, -3, hmm)  
				WHEN LEN(hmm) > 10 
					THEN DATEADD(hh, -3, REPLACE(hmm, '12/30/1899', ''))
				ELSE NULL 
			END
		END,  --StartDate/Time
		CASE WHEN LEN(schedulingDate) < 21 
			THEN CAST(RTRIM(LEFT(schedulingDate,8)) AS DATETIME) + 
			CASE WHEN LEN(hmm) < 10 
					THEN DATEADD(hh, -3, DATEADD(mi, 30,hmm))
				 WHEN LEN(hmm) > 10 THEN DATEADD(hh, -3, DATEADD(mi, 30, REPLACE(hmm, '12/30/1899', '')))
				 ELSE NULL 
			END
		ELSE CAST(RTRIM(LEFT(schedulingDate,10)) AS DATETIME) + 
			CASE WHEN LEN(hmm) < 10 
					THEN DATEADD(mi, 30, DATEADD(hh, -3,hmm))  
				WHEN LEN(hmm) > 10 
					THEN DATEADD(mi, 30, REPLACE(DATEADD(hh, -3,hmm), '12/30/1899', ''))
				ELSE NULL 
			END
		END, -- EndDate/time
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          impAppt.[ReasonforAppt] , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          NULL , -- InsurancePolicyAuthorizationID - int
          NULL , -- PatientCaseID - int
          dk.dkPracticeID ,
          dk.dkPracticeID , 
          CASE 
		WHEN LEN(hmm) < 10 THEN (DATEPART(hh, CAST('9-26-2012 ' + [hmm] AS DATETIME)) * 100) 
	+ DATEPART(mi, CAST('9-26-2012 ' + [hmm] AS DATETIME))
	ELSE (DATEPART(hh, CAST('9-26-2012 ' + REPLACE([hmm],'12/30/1899','') AS DATETIME)) * 100) 
	+ DATEPART(mi, CAST('9-26-2012 ' + REPLACE([hmm],'12/30/1899','') AS DATETIME)) END,
	CASE 
		WHEN LEN(hmm) < 10 THEN (DATEPART(hh, CAST('9-26-2012 ' + [hmm] AS DATETIME)) * 100) 
	+ DATEPART(mi, DATEADD(mi,30,CAST('9-26-2012 ' + [hmm] AS DATETIME)))
	ELSE (DATEPART(hh, CAST('9-26-2012 ' + REPLACE([hmm],'12/30/1899','') AS DATETIME)) * 100) 
	+ DATEPART(mi, DATEADD(mi,30,CAST('9-26-2012 ' + REPLACE([hmm],'12/30/1899','') AS DATETIME))) END 
FROM dbo.[_import_0_1_Scheduler] impAppt
LEFT JOIN dbo.Patient realP ON 
	impAppt.[AccountNumber] = realP.VendorID
	AND realP.FirstName = impAppt.[FirstName]
	AND realP.VendorImportID = @VendorImportID
LEFT JOIN dbo.DateKeyToPractice dk ON
	impAppt.[schedulingdate] = dk.Dt
	AND dk.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




-- Appointment To Resource
PRINT ''
PRINT 'Inserting records into AppointmentToResource ...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          TIMESTAMP ,
          PracticeID
        )
SELECT    appt.AppointmentID,  -- AppointmentID - int
       1 , -- AppointmentResourceTypeID - int
        CASE 
			WHEN doc.DoctorID IS NULL 
				THEN (SELECT doctorID FROM doctor WHERE LastName = 'Shariff') 
			ELSE doc.DoctorID 
		END , -- ResourceID - int
        GETDATE() , -- ModifiedDate - datetime
        NULL , -- TIMESTAMP - timestamp
        1  -- PracticeID - int
FROM dbo.[_import_0_1_Scheduler] impAppt
JOIN dbo.Patient realP ON 
	impAppt.[AccountNumber] = realP.VendorID
	AND realP.FirstName = impAppt.[FirstName]
	AND realP.VendorImportID = 1
 JOIN dbo.Appointment appt ON 
	realP.PatientID = appt.PatientID
	AND appt.StartDate = 	CASE WHEN LEN(schedulingDate) < 21
			THEN CAST(RTRIM(LEFT(schedulingDate,8)) AS DATETIME) + 
			CASE WHEN LEN(hmm) < 10
					THEN DATEADD(hh, -3, hmm )
				 WHEN LEN(hmm) > 10 
							THEN DATEADD(hh, -3, REPLACE(hmm, '12/30/1899', ''))
				 ELSE NULL 
			END
		ELSE CAST(RTRIM(LEFT(schedulingDate,10)) AS DATETIME) + 
			CASE WHEN LEN(hmm) < 10
					THEN DATEADD(hh, -3, hmm)  
				WHEN LEN(hmm) > 10 
					THEN DATEADD(hh, -3, REPLACE(hmm, '12/30/1899', ''))
				ELSE NULL 
			END
		END
	AND CAST(appt.notes AS VARCHAR(MAX)) = impAppt.reasonforappt
LEFT JOIN dbo.Doctor doc ON
	impAppt.[DrNPI] = doc.NPI
	AND DOC.FirstName = impAppt.providerfirstname

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT TRAN

