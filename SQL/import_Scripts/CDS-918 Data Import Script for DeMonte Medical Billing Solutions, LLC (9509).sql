USE superbill_9509_prod
GO

BEGIN TRAN
SET XACT_ABORT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 8
SET @VendorImportID = 7

SET NOCOUNT ON

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
          HomePhone ,
          DOB ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT	
		  @PracticeID ,
          '' ,
          i.FirstName ,
          '' ,
          i.LastName ,
          '' ,
          i.[Address] ,
          i.Address2 ,
          i.City ,
          LEFT(i.[State],2) ,
          '' ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zipcode)
		  ELSE '' END ,
          CASE i.gender
			WHEN 'Male' THEN 'M'
			WHEN 'Female' THEN 'F'
		  ELSE 'U' END ,
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.daytimephone),10) ,
          CASE WHEN ISDATE(i.birthdate) = 1 THEN i.birthdate ELSE '1901-01-01 12:00:00.000' END ,
          i.email ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.cellphone),10) ,
          i.customerid ,
          @VendorImportID ,
          1 ,
          CASE WHEN i.[status] = 'Inactive' THEN 0 ELSE 1 END ,
          0 ,
          0
FROM dbo._import_7_8_Demos i
	LEFT JOIN dbo.Patient p ON 
		i.firstname = p.FirstName AND 
		i.lastname = p.LastName AND
		DATEADD(hh,12,CAST(i.birthdate AS DATETIME)) = p.DOB AND
		p.PracticeID = @PracticeID
WHERE p.PatientID IS NULL AND i.customerid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted Into Patient...'

INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	pd.PatientID , -- PatientID - int
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
	pd.VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient pd
WHERE pd.VendorImportID = @VendorImportID AND pd.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted Into PatientCase...'

--Removing specified providers from import data
UPDATE dbo._import_7_8_Appts
	SET practitioner = ''
WHERE practitioner IN ('Charolette Hoffman','Dawn Long','Diana Gummo','Edward McGuinness','Erika Kuhn','Kelly Roberts',
					   'Mary Dean Aber','Rhoda Eligator','Shirley Salmon Davis, LCSW','Sue Padlo','Tammy Fait','William Snow') 

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
          9 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.AutoTempID , -- Subject - varchar(64)
          CASE WHEN i.apptnotesinternal = '' THEN '' ELSE 'Appt Notes (internal): ' + i.apptnotesinternal + CHAR(13) + CHAR(10) END + 
		  CASE WHEN i.apptnotestofrompatient = '' THEN '' ELSE 'Appt Notes (to/from Patient): ' + i.apptnotestofrompatient + CHAR(13) + CHAR(10) END +  
		  CASE WHEN i.cancelreason = '' THEN '' ELSE 'Cancel Reason: ' + i.cancelreason END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.appointmentstatus 
			WHEN 'No Show' THEN 'N' 
			WHEN 'Rescheduled' THEN 'R'
			WHEN 'Late Cancel' THEN 'X'
			WHEN 'Clinician Canceled' THEN 'X'
			WHEN 'Confirmed' THEN 'C'
			WHEN 'Complete' THEN 'O'
			WHEN 'Cancelled' THEN 'X'
		  ELSE 'S' END, -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo._import_7_8_Appts i 
	INNER JOIN dbo.Patient p ON 
		i.firstname = p.FirstName AND 
		i.lastname = p.LastName AND 
		DATEADD(hh,12,CAST(i.birthdate AS DATETIME)) = p.DOB AND
		p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2 
							WHERE pc2.PracticeID = @PracticeID AND pc2.PatientID = p.PatientID)
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.Appointment a ON 
		CAST(i.startdate AS DATETIME) = a.StartDate AND 
		CAST(i.enddate AS DATETIME) = a.EndDate AND
		a.PracticeID = @PracticeID AND 
		p.PatientID = a.PatientID
WHERE i.practitioner <> '' AND a.AppointmentID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted Into Appointments...'

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
          CASE i.practitioner  
			WHEN 'Barbara Torango' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BARBARA' AND LastName = 'TORANGO' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Brenda Spatafore, RN' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BRENDA' AND LastName = 'SPATAFORE' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Brittany Hudspeth, LPC' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BRITTANY' AND LastName = 'HUDSPETH' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Daniel Lloyd, Post Doc' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'DANIEL' AND LastName = 'LLOYD' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Donald Cramer, CRNP' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'DONALD' AND LastName = 'CRAMER' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Doug Stewart, LPC' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'DOUGLAS' AND LastName = 'STEWART' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Elizabeth Grandelis, LPC' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'ELIZABETH' AND LastName = 'GRANDELIS' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Grace Confer-Hammond, LPC' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'GRACE' AND LastName = 'CONFER-HAMMOND' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Greg Lobb, PhD' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'GREGORY' AND LastName = 'LOBB' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Holly Eisenbrandt, PC' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'HOLLY' AND LastName = 'EISENBRANDT' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Joe Roberts, PhD' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'JOSEPH' AND LastName = 'ROBERTS' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Katie Stahler, PhD' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'CATHERINE' AND LastName = 'STAHLER' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Lauren Hartz' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'LAUREN' AND LastName = 'HARTZ' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Mahendra Patil, MD' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MAHENDRA' AND LastName = 'PATIL' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Mary Burke, PhD' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MARY' AND LastName = 'BURKE' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Megan Sukhia, LPC' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MEGAN' AND LastName = 'BOYLE' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Nancy Kennedy, PsyD' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'NANCY' AND LastName = 'KENNEDY' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Susan Bella-Nesbitt, LPC' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SUSAN' AND LastName = 'BELLA-NESBITT' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Tiffany Leonard, PsyD' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'TIFFANY' AND LastName = 'LEONARD' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
			WHEN 'Wesley Waldrup, LPC' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'WESLEY' AND LastName = 'WALDRUP' AND ActiveDoctor = 1 AND PracticeID = @PracticeID AND [External] = 0)
		  --ELSE (SELECT MIN(DoctorID) FROM dbo.Doctor WHERE PracticeID = @PracticeID AND [External] = 0 AND ActiveDoctor = 1) 
		  END , -- ResourceID - int
          GETDATE() , -- Modif	iedDate - datetime
          @PracticeID -- PracticeID - int
FROM dbo._import_7_8_Appts i 
	INNER JOIN dbo.Appointment a ON 
		i.AutoTempID = a.[Subject] AND
        a.PracticeID = @PracticeID 
WHERE i.practitioner <> '' AND a.CreatedDate > DATEADD(mi,-2,GETDATE()) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted Into AppointmentToResource...'

--ROLLBACK
--COMMIT

