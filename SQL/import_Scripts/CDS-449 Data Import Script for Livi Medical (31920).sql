USE superbill_31920_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
--DECLARE @VendorImportID INT
 
SET @PracticeID = 1
--SET @VendorImportID = 2 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
--PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 
-- Clear out any existing records for this import, (makes the script safe to run multiple times)
--PRINT ''
--PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

/*
DELETE FROM dbo.AppointmentToResource
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.AppointmentReason
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentReason records deleted'
*/


PRINT ''
PRINT 'Updating Appointment Subject...'
UPDATE dbo.Appointment 
	SET [Subject] = i.appointmentid
FROM dbo.[_import_3_1_sheet1] i
	INNER JOIN dbo.Patient p ON
		p.MedicalRecordNumber = i.patientid
	INNER JOIN dbo.Appointment a ON
		CAST(i.startdate AS DATETIME) = a.StartDate AND
		CAST(i.enddate AS DATETIME) = a.EndDate AND
		a.PatientID = p.PatientID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records updated'




--PRINT ''
--PRINT 'Inserting into AppointmentReason'
--INSERT INTO dbo.AppointmentReason
--        ( PracticeID ,
--          Name ,
--          DefaultDurationMinutes ,
--      --  DefaultColorCode ,
--      --  Description ,
--          ModifiedDate 
--      --  TIMESTAMP ,
--      --  AppointmentReasonGuid
--        )
--SELECT DISTINCT 
--          @PracticeID , -- PracticeID - int
--          ita.appointmenttype , -- Name - varchar(128)
--          15 , -- DefaultDurationMinutes - int
--      --  0 , -- DefaultColorCode - int
--      --  '' , -- Description - varchar(256)
--          GETDATE()  -- ModifiedDate - datetime
--     --   NULL , -- TIMESTAMP - timestamp
--     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
--FROM dbo.[_import_6_1_Sheet1] as ita 
--WHERE ita.appointmenttype <> '' AND NOT EXISTS (select * from dbo.AppointmentReason ar where ar.name = ita.appointmenttype)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into AppointmentReason'


PRINT ''
PRINT'Inserting records into Appointment'
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
      --  RecordTimeStamp ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
      --  AllDay ,
      --  InsurancePolicyAuthorizationID ,
          PatientCaseID ,
      --  Recurrence ,
      --  RecurrenceStartDate ,
      --  RangeEndDate ,
      --  RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
      --  AppointmentGuid
        )
SELECT  DISTINCT  
          pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          ita.startdate , -- StartDate - datetime
          ita.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          ita.appointmentid , -- Subject - varchar(64)
          ita.examreason , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
		  1 , -- AppointmentResourceTypeID - int
          CASE ita.appointmentstatus WHEN 'scheduled' THEN 'S' 
									 WHEN 'checkedOut' THEN 'O'
									 WHEN 'confirmed' THEN 'C' 
									 WHEN 'checkedIn' THEN 'I'
									 WHEN 'cancelled' THEN 'X' ELSE 'S' END, -- AppointmentConfirmationStatusCode - char(1)
      --  NULL , -- AllDay - bit
      --  0 , -- InsurancePolicyAuthorizationID - int
          patcase.PatientCaseID , -- PatientCaseID - int
      --  NULL , -- Recurrence - bit
      --  GETDATE() , -- RecurrenceStartDate - datetime
      --  GETDATE() , -- RangeEndDate - datetime
      --  '' , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          ita.StartTM , -- StartTm - smallint
          ita.EndTM  -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM dbo.[_import_3_1_Sheet1] as ita 
LEFT JOIN dbo.patient AS pat ON
  pat.MedicalRecordNumber = ita.patientid AND
  pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.patientID = pat.patientID AND
  patcase.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(ita.startdate AS date) AS DATETIME)
WHERE NOT EXISTS (SELECT * FROM dbo.Appointment a WHERE ita.appointmentid = a.[Subject])
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted into Appointment Successfully'


PRINT ''
PRINT 'Inserting into Appointment To Appointment Reason'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
	  --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT
          dboa.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
	  --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_Sheet1] as ita 
INNER JOIN dbo.Appointment AS dboa ON
	ita.appointmentid = dboa.[subject] AND
	dboa.PracticeID = @PracticeID
INNER JOIN dbo.AppointmentReason AS ar ON 
    ar.Name = ita.appointmenttype AND 
    ar.PracticeID = @PracticeID
WHERE dboa.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting records into AppointmenttoResource 1'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
      --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT 
          dboa.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE ita.assignedphysician WHEN 'Karen Trask, MSN, FNP-C' THEN 4
									 WHEN 'Thomas Green, FNPC' THEN 3
									 WHEN 'Farshad Fani Marvasti, M.D.' THEN 2
									 WHEN 'Jordi Livi, M.D.' THEN 1 ELSE 1 END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_Sheet1] as ita 
INNER JOIN dbo.Appointment AS dboa ON
	ita.appointmentid = dboa.[subject] AND
	dboa.PracticeID = @PracticeID
WHERE dboa.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource 1'

--ROLLBACK
--COMMIT TRANSACTION
--        PRINT 'COMMITTED SUCCESSFULLY'


/*
SELECT [appointmentid] AS [KareoAptID] , [SUBJECT] AS [ElationAptID ]  FROM dbo.Appointment 
WHERE [Subject] IN (SELECT appointmentid FROM dbo.[_import_3_1_Sheet1] WHERE appointmentid = [Subject])
ORDER BY AppointmentID
*/

