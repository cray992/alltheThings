USE superbill_10590_dev
--USE superbill_10590_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 30
SET @VendorImportID = 17

SET NOCOUNT ON 

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
          158 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.[status] , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_18_30_ReportMonthlyAppointments] i
INNER JOIN dbo.Patient p ON
p.VendorID = i.patientid AND 
p.VendorImportID = @VendorImportID
LEFT JOIN dbo.PatientCase pc ON
p.PatientID = pc.PatientID AND 
pc.VendorImportID = @VendorImportID 
INNER JOIN dbo.DateKeyToPractice DK ON
DK.PracticeID = @PracticeID AND
DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          reasonforvisit , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          reasonforvisit , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_18_30_ReportMonthlyAppointments] i
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.Name = i.reasonforvisit AND ar.PracticeID = @PracticeID) AND 
i.reasonforvisit <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
FROM dbo.[_import_18_30_ReportMonthlyAppointments] i
INNER JOIN dbo.Patient p ON 
p.VendorID = i.patientid AND
p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON 
a.PatientID = p.PatientID AND
a.StartDate = CAST(i.startdate AS DATETIME) AND
a.EndDate = CAST(i.enddate AS DATETIME)
INNER JOIN dbo.AppointmentReason ar ON 
ar.Name = i.reasonforvisit AND
ar.PracticeID = @PracticeID
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
          10219 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_18_30_ReportMonthlyAppointments] i
INNER JOIN dbo.Patient p ON 
p.VendorID = i.patientid AND
p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON 
a.PatientID = p.PatientID AND
a.StartDate = CAST(i.startdate AS DATETIME) AND
a.EndDate = CAST(i.enddate AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating InsurancePolicy.InsuranceCompanyPlanID...'
UPDATE dbo.InsurancePolicy 
SET InsuranceCompanyPlanID = 230
WHERE InsuranceCompanyPlanID = 203 AND PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

UPDATE dbo.PatientCase 
	SET Name = 'Self Pay'
FROM dbo.PatientCase pc
	LEFT JOIN dbo.InsurancePolicy ip ON
		pc.PatientCaseID = ip.PatientCaseID  
WHERE pc.VendorImportID = @VendorImportID AND
      PayerScenarioID = 11 AND 
      ip.PatientCaseID IS NULL 
	  


	  SELECT TOP 100 * FROM dbo.Patient WHERE VendorImportID = 17
--ROLLBACK
--COMMIT
