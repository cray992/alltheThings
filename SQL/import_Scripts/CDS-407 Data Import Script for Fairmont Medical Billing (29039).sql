USE superbill_29039_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 
-- Clear out any existing records for this import, (makes the script safe to run multiple times)
--PRINT ''
--PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.AppointmentToAppointmentReason WHERE ModifiedDate > '2014-08-06 20:59:45.983'
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentToAppointmentReason'
--DELETE FROM dbo.AppointmentReason WHERE ModifiedDate > '2014-08-06 20:59:45.983'
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentReason'
--DELETE FROM dbo.AppointmentToResource WHERE ModifiedDate > '2014-08-11 16:25:12.947'
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from AppointmentToResource '
--DELETE FROM dbo.Appointment WHERE CreatedUserID = 0 AND ModifiedUserID = 0
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from  Appointment '


PRINT ''
PRINT 'Inserting into AppointmentReason'

INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
       -- DefaultColorCode ,
          Description ,
          ModifiedDate 
     --   TIMESTAMP ,
     --   AppointmentReasonGuid
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          ir.apptreason , -- Name - varchar(128)
          ir.duration , -- DefaultDurationMinutes - int
       -- 0 , -- DefaultColorCode - int
          ir.apptreason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
 FROM dbo.[_import_3_1_Reason] as ir
WHERE ir.apptreason <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.Name = ir.apptreason)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into AppointmentReason'


PRINT ''
PRINT'Inserting records into Appointment'

INSERT INTO dbo.Appointment
        ( 
		  PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
      --  Subject ,
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
SELECT DISTINCT   
          pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          ia.startdate , -- StartDate - datetime
          ia.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
      --  '' , -- Subject - varchar(64)
          ia.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          ia.resourcetypeid, -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
      --  NULL , -- AllDay - bit
      --  0 , -- InsurancePolicyAuthorizationID - int
          patcase.PatientCaseID , -- PatientCaseID - int
      --  NULL , -- Recurrence - bit
      --  GETDATE() , -- RecurrenceStartDate - datetime
      --  GETDATE() , -- RangeEndDate - datetime
      --  '' , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          ia.StartTm , -- StartTm - smallint
          ia.EndTm  -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM dbo.[_import_3_1_Appointment] as ia
INNER JOIN dbo.patient AS pat ON
  pat.patientID = ia.patientID and
  pat.medicalrecordnumber = ia.medicalrecordnumber and
  pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.patientID = ia.patientID AND
  patcase.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(ia.startdate AS date) AS DATETIME)

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted into Appointment Successfully'


PRINT ''
PRINT 'Inserting records into AppointmentToAppointmentReason'

INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
     --   TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT 
          dboa.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID -- PracticeID - int  
FROM dbo.[_import_3_1_Appointment] as ia      
INNER JOIN dbo.patient AS pat ON
	pat.PatientID = ia.PatientID AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS dboa ON
	ia.PatientID = dboa.PatientID AND
	CAST(ia.startdate AS DATETIME) = dboa.StartDate AND
	CAST(ia.enddate AS DATETIME) = dboa.EndDate
INNER JOIN dbo.AppointmentReason AS ar ON 
	ar.Name = ia.reason AND
	ar.PracticeID = @PracticeID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in   AppointmentToAppointmentReason'



PRINT ''
PRINT 'Inserting records into AppointmenttoResource'

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
          ia.resourcetypeid , -- AppointmentResourceTypeID - int
          ia.resourceid , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo._import_3_1_Appointment as ia
INNER JOIN dbo.patient AS pat ON
	pat.PatientID = ia.PatientID AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS dboa ON
	ia.PatientID = dboa.PatientID AND
	CAST(ia.startdate AS DATETIME) = dboa.StartDate AND
	CAST(ia.enddate AS DATETIME) = dboa.EndDate



PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'



--ROLLBACK
--COMMIT TRANSACTION
        PRINT ''
		PRINT 'COMMITTED SUCCESSFULLY' 
