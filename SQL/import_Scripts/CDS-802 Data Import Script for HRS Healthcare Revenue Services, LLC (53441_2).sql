--USE superbill_53441_dev
USE superbill_53441_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1

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
--INNER JOIN dbo.[_import_2_2_PatientDemographics] i ON p.PatientID = i.id

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
          sl.ServiceLocationID , -- ServiceLocationID - int
          DATEADD(hh,-3,CAST(i.startdatetime AS DATETIME)) , -- StartDate - datetime
          DATEADD(hh,-3,DATEADD(mi,15,(CAST(i.startdatetime AS DATETIME)))) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.AutoTempID , -- Subject - varchar(64)
          CASE WHEN i.reason = '-' THEN '' ELSE i.reason END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.appointmentstatus 
			WHEN 'No Show' THEN 'N'
			WHEN 'Checked In' THEN 'I'
			WHEN 'Rescheduled' THEN 'R'
			WHEN 'Ready to Discharge' THEN 'E'
			WHEN 'Confirmed' THEN 'C' 
			WHEN 'Called to Reschedule' THEN 'R'
			WHEN 'Scheduled in Error' THEN 'X'
			WHEN 'Reschedule' THEN 'R'
			WHEN 'Discharged' THEN 'O'
			WHEN 'Canceled' THEN 'X'
		  ELSE 'S' END, -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.startdatetime,5), ':','') AS SMALLINT) - 300 , -- StartTm - smallint
          CAST(RIGHT(REPLACE(REPLACE(REPLACE(DATEADD(hh,-3,DATEADD(mi,15,i.startdatetime)),':',''),'AM',''),'PM',''),4) AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_1_2_Appointments i 
	INNER JOIN dbo.Patient p ON 
		i.patientfirstname = p.FirstName AND 
		i.patientlastname = p.LastName AND
		DATEADD(hh,12,CAST(i.birthdate AS DATETIME)) = p.DOB AND
        p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.patientcaseid) FROM dbo.PatientCase pc2
							WHERE pc2.PatientID = p.PatientID AND pc2.PracticeID = @PracticeID)
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.startdatetime AS DATE) AS DATETIME)
	INNER JOIN dbo.ServiceLocation sl ON
		sl.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID)
	LEFT JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND 
		a.StartDate = DATEADD(hh,-3,CAST(i.startdatetime AS DATETIME)) 
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
          1 , -- AppointmentResourceTypeID - int
          10 , -- ResourceID - int						DEFAULTED to DoctorID 10
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_1_2_Appointments i
	INNER JOIN dbo.Appointment a ON 
		i.AutoTempID = a.[Subject]
	--INNER JOIN dbo.Patient p ON 
	--	i.patientfirstname = p.FirstName AND 
	--	i.patientlastname = p.LastName AND
	--	DATEADD(hh,12,CAST(i.birthdate AS DATETIME)) = p.DOB AND
 --       p.PracticeID = @PracticeID
	--INNER JOIN dbo.Appointment a ON 
	--	a.StartDate = DATEADD(hh,-3,CAST(i.startdatetime AS DATETIME)) AND 
	--	a.EndDate = DATEADD(hh,-3,DATEADD(mi,15,(CAST(i.startdatetime AS DATETIME)))) AND 
	--	a.PatientID = p.PatientID
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE()) AND a.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

UPDATE dbo._import_1_2_Appointments SET appointmenttype = 'Post-Op' WHERE appointmenttype = 'Post Op'

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
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_1_2_Appointments i
	INNER JOIN dbo.Appointment a ON 
		i.AutoTempID = a.[Subject]
	--INNER JOIN dbo.Patient p ON 
	--	i.patientfirstname = p.FirstName AND 
	--	i.patientlastname = p.LastName AND
	--	DATEADD(hh,12,CAST(i.birthdate AS DATETIME)) = p.DOB AND
 --       p.PracticeID = @PracticeID
	--INNER JOIN dbo.Appointment a ON 
	--	a.StartDate = DATEADD(hh,-3,CAST(i.startdatetime AS DATETIME)) AND 
	--	a.EndDate = DATEADD(hh,-3,DATEADD(mi,15,(CAST(i.startdatetime AS DATETIME)))) AND 
	--	a.PatientID = p.PatientID
	INNER JOIN dbo.AppointmentReason ar ON 
		i.appointmenttype = ar.Name AND 
        ar.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-10,GETDATE()) AND a.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT
