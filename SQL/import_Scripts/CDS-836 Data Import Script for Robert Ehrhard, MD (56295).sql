USE superbill_56295_prod
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

/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME))  -- DateofBirth - 
--FROM dbo.Patient p 
--INNER JOIN dbo.[_import_3_1_PatientDemographics] i ON p.PatientID = i.id

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #updatepat

/*==========================================================================*/

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
          ModifiedUserID
        )
SELECT DISTINCT	
		  i.employername , -- EmployerName - varchar(128)
          i.employeraddress1 , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          i.employercity , -- City - varchar(128)
          i.exmployerstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          dbo.fn_RemoveNonNumericCharacters(i.employerzip) , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo._import_2_1_ReportPatientList i 
	LEFT JOIN dbo.Employers e ON
		i.employername = e.EmployerName AND 
		i.employeraddress1 = e.AddressLine1
WHERE e.EmployerID IS NULL AND i.employername <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient...'
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
          Country ,
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          DOB ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' ,
          i.firstname ,
          i.middlename ,
          i.lastname ,
          '' ,
          i.address1 ,
          '' ,
          i.city ,
          i.[state] ,
          '' ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip) 
		  ELSE '' END ,
          i.sex ,
          '' ,
          dbo.fn_RemoveNonNumericCharacters(i.phone) ,
          CASE WHEN ISDATE(i.dobsex) = 1 THEN i.dobsex ELSE '1901-01-01 12:00:00.000' END ,
          i.email ,
          CASE WHEN i.guarantorid <> '' AND i.patientid <> i.guarantorid THEN 1 ELSE 0 END ,
          CASE WHEN i.guarantorid <> '' AND i.patientid <> i.guarantorid THEN '' END ,
          CASE WHEN i.guarantorid <> '' AND i.patientid <> i.guarantorid THEN i.guarantorfirstname END ,
          CASE WHEN i.guarantorid <> '' AND i.patientid <> i.guarantorid THEN i.guarantormiddlename END ,
          CASE WHEN i.guarantorid <> '' AND i.patientid <> i.guarantorid THEN i.guarantorlastname END ,
          CASE WHEN i.guarantorid <> '' AND i.patientid <> i.guarantorid THEN '' END ,
          CASE WHEN i.guarantorid <> '' AND i.patientid <> i.guarantorid THEN 'O' ELSE 'S' END ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CASE WHEN i.employername <> '' THEN 'E' ELSE 'U' END ,
          d.DoctorID ,
          1 ,
          e.EmployerID ,
          i.patientid ,
          i.patientid ,
          @VendorImportID ,
          1 ,
          CASE WHEN i.[status] <> 'Active' THEN 0 ELSE 1 END ,
          0 ,
          0 ,
          CASE WHEN i.emergencycontactname <> '' THEN i.emergencycontactname ELSE '' END + 
		  CASE WHEN i.emergencycontactaddress <> '' THEN ' ' + i.emergencycontactaddress ELSE '' END + 
		  CASE WHEN i.emergencycontactcitystatezip <> '' THEN ' ' + i.emergencycontactcitystatezip ELSE '' END ,
          CASE WHEN i.emergencycontactphone <> '' THEN dbo.fn_RemoveNonNumericCharacters(i.emergencycontactphone) END
FROM dbo._import_2_1_ReportPatientList i
	LEFT JOIN dbo.Patient p2 ON 
		p2.VendorID = i.patientid AND
        p2.PracticeID = @PracticeID
	LEFT JOIN dbo.Doctor d ON 
		i.primaryproviderfirstname = d.FirstName AND
		i.primaryproviderlastname = d.LastName AND 
		d.[External] = 0 AND
		d.PracticeID = @PracticeID AND 
		d.ActiveDoctor = 1
	LEFT JOIN dbo.Employers e ON
		i.employername = e.EmployerName AND 
		i.employeraddress1 = e.AddressLine1
WHERE p2.PatientID IS NULL
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
FROM dbo._import_2_1_ReportPatientList pd
	JOIN dbo.Patient AS PAT ON VendorImportID = @VendorImportID AND VendorID = pd.patientid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Updating Other Appointment...'
UPDATE dbo.Appointment	
SET AppointmentType = 'P' ,
	PatientID = p.PatientID , 
	PatientCaseID = pc.PatientCaseID , 
	ModifiedDate = GETDATE()
FROM dbo.Appointment a
	INNER JOIN dbo._import_2_1_PaOtherAppointments i ON 
		i.notes = a.[Subject] AND
        CAST(i.startdate AS DATETIME) = a.StartDate AND 
        CAST(i.enddate AS DATETIME) = a.EndDate 
	INNER JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND
        p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON
		pc.PatientCaseID = (SELECT MAX(pc2.patientcaseid) FROM dbo.PatientCase pc2
							WHERE pc2.PatientID = p.PatientID AND 
								  pc2.PracticeID = @PracticeID)
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
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.AutoTempID , -- Subject - varchar(64)
          i.reasonforvisit , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.[status]
			WHEN 'Cancelled by Office' THEN 'X' 
			WHEN 'Cancelled by Patient' THEN 'X' 
			WHEN 'Cancelled by Provider' THEN 'X' 
			WHEN 'Last Minute Cancel by Patient' THEN 'X' 
			WHEN 'Checked In' THEN 'I'
			WHEN 'Confirmed' THEN 'C'
			WHEN 'Patient Did Not Come' THEN 'N' 
		  ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.dkpracticeid , -- StartDKPracticeID - int
          dk.dkpracticeid , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.startdate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.enddate,5), ':','') AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_2_1_ReportMonthlyAppointments i
	INNER JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND 
		p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON
		pc.PatientCaseID = (SELECT MAX(pc2.patientcaseid) FROM dbo.PatientCase pc2
							WHERE pc2.PatientID = p.PatientID AND 
								  pc2.PracticeID = @PracticeID)	
	LEFT JOIN dbo.Appointment a ON 
		CAST(i.startdate AS DATETIME) = a.StartDate	AND
		CAST(i.enddate AS DATETIME) = a.EndDate AND
		p.PatientID = a.PatientID
	INNER JOIN dbo.DateKeyToPractice dk ON 
		CAST(CAST(i.startdate AS DATE) AS DATETIME) = dk.Dt AND
        dk.PracticeID = @PracticeID
WHERE a.AppointmentID IS NULL
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
SELECT DISTINCT
	      a.AppointmentID , -- AppointmentID - int
          CASE WHEN i.provider <> 'Robert Ehrhard, MD' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          CASE i.provider 
			WHEN 'Emily Klein' THEN (SELECT PracticeResourceID FROM dbo.PracticeResource WHERE ResourceName = 'Nurse Practitioner' AND PracticeID = @PracticeID) 
			WHEN 'Nichole Harbeson' THEN (SELECT PracticeResourceID FROM dbo.PracticeResource WHERE ResourceName = 'Nurse Practitioner' AND PracticeID = @PracticeID)
			WHEN 'Tiffany McCandless' THEN (SELECT PracticeResourceID FROM dbo.PracticeResource WHERE ResourceName = 'Audiologist' AND PracticeID = @PracticeID)
		  ELSE 1 END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_2_1_ReportMonthlyAppointments i 
	INNER JOIN dbo.Appointment a ON 
		a.[Subject] = i.AutoTempID AND
        a.StartDate = CAST(i.startdate AS DATETIME) AND 
		a.EndDate = CAST(I.enddate AS DATETIME)
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

CREATE TABLE #updatereason (AppointmentReasonID INT , Name VARCHAR(128) , TargetAppointmentReasonID INT)
INSERT INTO #updatereason
        ( AppointmentReasonID ,
          Name 
        )
SELECT DISTINCT
		  AppointmentReasonID , -- AppointmentReasonID - int
          Name  -- Name - varchar(128)
FROM dbo.AppointmentReason 
WHERE ModifiedDate >= '2016-10-05 11:37:24.737'

UPDATE #updatereason
	SET TargetAppointmentReasonID = CASE WHEN name LIKE 'CPAP%' THEN 99
										 WHEN name LIKE 'CT Scan%' THEN 100
										 WHEN name LIKE 'est%' THEN 94
										 WHEN name LIKE 'Follow up%' THEN 93
										 WHEN name LIKE 'Lesion Removal%' THEN 96
										 WHEN name LIKE 'New%' THEN 95
										 WHEN name LIKE 'Post%' THEN 103
										 WHEN name LIKE 'Surgery%' THEN 104
										 WHEN name LIKE 'Tube%' THEN 97
										 WHEN name LIKE 'VNG%' THEN 105
										 WHEN name LIKE 'BEETH%' THEN 94
									END 

-- Eroneous Appointment Reasons were created and assigned. This updates the Appointments to customer approved Appointment Reasons
PRINT ''
PRINT 'Updating Appointment to Appointment Reason...'
UPDATE dbo.AppointmentToAppointmentReason
	SET AppointmentReasonID = ar.TargetAppointmentReasonID
FROM dbo.AppointmentToAppointmentReason atar
	INNER JOIN #updatereason ar ON
		atar.AppointmentReasonID = ar.AppointmentReasonID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	

-- Removing uneeded reasons from the import file
UPDATE dbo._import_2_1_ReportMonthlyAppointments
SET reasonforvisit = 
CASE WHEN reasonforvisit LIKE 'ASC%' THEN ''
WHEN reasonforvisit LIKE 'BESPH%' THEN ''
WHEN reasonforvisit LIKE 'block%' THEN ''
WHEN reasonforvisit LIKE 'board%' THEN ''
WHEN reasonforvisit LIKE 'cred%' THEN ''
WHEN reasonforvisit LIKE 'dept%' THEN ''
WHEN reasonforvisit LIKE 'dia%' THEN ''
WHEN reasonforvisit LIKE 'do not%' THEN ''
WHEN reasonforvisit LIKE 'extra%' THEN ''
WHEN reasonforvisit LIKE 'lunch%' THEN ''
WHEN reasonforvisit LIKE 'med%' THEN ''
WHEN reasonforvisit LIKE 'needs%' THEN ''
WHEN reasonforvisit LIKE 'orc%' THEN ''
WHEN reasonforvisit LIKE 'patoka%' THEN ''
WHEN reasonforvisit LIKE 'time%' THEN ''
WHEN reasonforvisit LIKE 'urgent%' THEN ''
ELSE reasonforvisit END


-- Inserting and attaching approved Appointment Reasons to New Appointments
PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason 1 of 2...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID ,
          CASE WHEN i.reasonforvisit LIKE 'CPAP%' THEN 99
			   WHEN i.reasonforvisit LIKE 'CT Scan%' THEN 100
			   WHEN i.reasonforvisit LIKE 'est%' THEN 94
			   WHEN i.reasonforvisit LIKE 'Follow up%' THEN 93
			   WHEN i.reasonforvisit LIKE 'Follow-up%' THEN 93
			   WHEN i.reasonforvisit LIKE 'Lesion Removal%' THEN 96
			   WHEN i.reasonforvisit LIKE 'New%' THEN 95
			   WHEN i.reasonforvisit LIKE '%Post%' THEN 103
			   WHEN i.reasonforvisit LIKE 'Surgery%' THEN 104
			   WHEN i.reasonforvisit LIKE 'Tube%' THEN 97
			   WHEN i.reasonforvisit LIKE 'VNG%' THEN 105
			   WHEN i.reasonforvisit LIKE 'BEETH%' THEN 94
			   WHEN i.reasonforvisit LIKE 'Audio%' THEN 107
			   WHEN i.reasonforvisit LIKE 'Balloon%' THEN 98
			   WHEN i.reasonforvisit LIKE 'Hearing Aid Check%' THEN 108
			   WHEN i.reasonforvisit = 'Hearing Aid Fitting' THEN 109
		  ELSE ar.AppointmentReasonID END , -- AppointmentReasonID - int
		  1 ,
		  GETDATE() ,
		  @PracticeID
FROM dbo._import_2_1_ReportMonthlyAppointments i 
	INNER JOIN dbo.Appointment a ON 
		a.[Subject] = i.AutoTempID AND
        a.StartDate = CAST(i.startdate AS DATETIME) AND 
		a.EndDate = CAST(I.enddate AS DATETIME)
	LEFT JOIN dbo.AppointmentReason ar ON 
		i.reasonforvisit = ar.Name AND 
		ar.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE()) AND i.reasonforvisit <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- Inserting and attaching approved Appointment Reasons to converted Other to Patient Appointments
PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason 2 of 2...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID ,
          CASE WHEN i.reasonforvisit LIKE 'CPAP%' THEN 99
			   WHEN i.reasonforvisit LIKE 'CT Scan%' THEN 100
			   WHEN i.reasonforvisit LIKE 'est%' THEN 94
			   WHEN i.reasonforvisit LIKE 'Follow up%' THEN 93
			   WHEN i.reasonforvisit LIKE 'Follow-up%' THEN 93
			   WHEN i.reasonforvisit LIKE 'Lesion Removal%' THEN 96
			   WHEN i.reasonforvisit LIKE 'New%' THEN 95
			   WHEN i.reasonforvisit LIKE '%Post%' THEN 103
			   WHEN i.reasonforvisit LIKE 'Surgery%' THEN 104
			   WHEN i.reasonforvisit LIKE 'Tube%' THEN 97
			   WHEN i.reasonforvisit LIKE 'VNG%' THEN 105
			   WHEN i.reasonforvisit LIKE 'BEETH%' THEN 94
			   WHEN i.reasonforvisit LIKE 'Audio%' THEN 107
			   WHEN i.reasonforvisit LIKE 'Balloon%' THEN 98
			   WHEN i.reasonforvisit LIKE 'Hearing Aid Check%' THEN 108
			   WHEN i.reasonforvisit = 'Hearing Aid Fitting' THEN 109
		  ELSE ar.AppointmentReasonID END , -- AppointmentReasonID - int
		  1 ,
		  GETDATE() ,
		  @PracticeID
FROM dbo._import_2_1_PaOtherAppointments i 
	INNER JOIN dbo.Appointment a ON 
		a.[Subject] = i.notes AND
        a.StartDate = CAST(i.startdate AS DATETIME) AND 
		a.EndDate = CAST(I.enddate AS DATETIME)
	LEFT JOIN dbo.AppointmentReason ar ON 
		i.reasonforvisit = ar.Name AND 
		ar.PracticeID = @PracticeID
WHERE i.reasonforvisit <> '' AND a.CreatedDate = '2016-10-05 11:37:02.517'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- these records were previously imported from 1_1_OtherAppointments with missing provider resource
PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment a
	LEFT JOIN dbo.AppointmentToResource atr ON
		a.AppointmentID = atr.AppointmentID AND 
		atr.PracticeID = @PracticeID
WHERE atr.AppointmentToResourceID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- removing erroneous appointment reasons where not edited by customer
DELETE FROM dbo.AppointmentReason WHERE ModifiedDate >= '2016-10-05 11:37:24.737' AND PracticeID = @PracticeID 
AND AppointmentReasonID NOT IN (SELECT AppointmentReasonID FROM dbo.AppointmentToAppointmentReason WHERE PracticeID = @PracticeID)

DROP TABLE #updatereason

--ROLLBACK
--COMMIT

