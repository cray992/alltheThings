USE superbill_27899_prod
GO

BEGIN TRAN
SET XACT_ABORT ON 
SET NOCOUNT ON 

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 65
SET @VendorImportID = 60

INSERT INTO dbo.Patient
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          MaritalStatus ,
          DOB ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT		
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          i.patientfirstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          i.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
		  '' , -- MaritalStatus
          i.patientdob , -- DOB - datetime
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          i.patientfirstname+i.patientlastname+i.patientdob , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo._import_60_65_Appointments i 
	LEFT JOIN dbo.Patient p ON 
		i.patientfirstname = p.FirstName AND 
		i.patientlastname = p.LastName AND
		DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) = p.DOB AND 
		p.PracticeID = @PracticeID
WHERE p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient records inserted'

INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
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
		  Notes
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          Sl.ServiceLocationID , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.AutoTempID , -- Subject - varchar(64)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.[status] 
			WHEN 'Cancelled' THEN 'X'
			WHEN 'No show' THEN 'N'
			WHEN 'Seen' THEN 'E'
		  ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.startdate,5), ':','') AS SMALLINT)  , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.enddate,5), ':','') AS SMALLINT) , -- EndTm - smallint
		  'Appointment Type: ' + i.appointmenttype
FROM dbo._import_60_65_Appointments i 
	INNER JOIN dbo.Patient p ON 
		i.patientfirstname = p.FirstName AND 
		i.patientlastname = p.LastName AND 
		DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) = p.DOB AND
		p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2
							WHERE pc2.PatientID = p.PatientID AND 
								  pc2.PracticeID = @PracticeID)
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
	INNER JOIN dbo.ServiceLocation sl ON 
		sl.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
WHERE i.[date] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment records inserted'

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
          693 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment a
INNER JOIN dbo._import_60_65_Appointments i ON 
	a.[Subject] = i.AutoTempID AND 
	a.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' AppointmentToResource records inserted'

--ROLLBACK
--COMMIT		