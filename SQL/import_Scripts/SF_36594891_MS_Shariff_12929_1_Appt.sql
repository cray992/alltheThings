USE superbill_12929_dev
--USE superbill_12929_prod	





DECLARE @PracticeID INT

SET @PracticeID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))


UPDATE dbo.Appointment
	SET Notes = NULL
	WHERE Notes IS NOT NULL 
	
PRINT ''
PRINT 'Inserting into AppointementReason ...'
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
          LEFT(impSC.reasonforappt, 128) , -- Name - varchar(128)
          30 , -- DefaultDurationMinutes - int
          -16711681 , -- DefaultColorCode - int
          impSC.reasonforappt , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_1_1_Scheduler] impSc
WHERE impsc.reasonforappt <> ''
PRINT CAST(@@Rowcount AS VARCHAR(10)) + ' records inserted'



INSERT dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          ModifiedDate ,
          PracticeID
        )
SELECT  DISTINCT 
		app.AppointmentID , -- AppointmentID - int
        ar.AppointmentReasonID, -- AppointmentReasonID - int
          GETDATE() , -- ModifiedDate - datetime
          1 -- PracticeID - int
FROM dbo.[_import_0_1_Scheduler]  sch
JOIN dbo.Patient pat ON pat.VendorID = sch.accountnumber
JOIN dbo.Appointment app ON app.PatientID = pat.PatientID AND
	app.StartDate = CASE WHEN LEN(sch.schedulingDate) < 21
						THEN CAST(RTRIM(LEFT(sch.schedulingDate,8)) AS DATETIME) + 
						CASE WHEN LEN(sch.hmm) < 10
								THEN DATEADD(hh, -3, hmm )
							 WHEN LEN(sch.hmm) > 10 
										THEN DATEADD(hh, -3, REPLACE(hmm, '12/30/1899', ''))
							 ELSE NULL 
						END
					ELSE CAST(RTRIM(LEFT(sch.schedulingDate,10)) AS DATETIME) + 
						CASE WHEN LEN(sch.hmm) < 10
								THEN DATEADD(hh, -3, sch.hmm)  
							WHEN LEN(sch.hmm) > 10 
								THEN DATEADD(hh, -3, REPLACE(sch.hmm, '12/30/1899', ''))
							ELSE NULL 
						END
					END
JOIN dbo.AppointmentReason ar ON sch.reasonforappt = ar.[Description] 



IF NOT EXISTS (SELECT * FROM doctor WHERE npi = '1821080029')
BEGIN 
	INSERT INTO dbo.Doctor
			( PracticeID ,
			  Prefix ,
			  FirstName ,
			  MiddleName ,
			  LastName ,
			  Suffix ,
			  ActiveDoctor ,
			  CreatedDate ,
			  CreatedUserID ,
			  ModifiedDate ,
			  ModifiedUserID ,
			  Degree ,
			  VendorImportID ,
			  [External] ,
			  NPI ,
			  ProviderTypeID ,
			  ProviderPerformanceReportActive ,
			  ProviderPerformanceScope ,
			  ProviderPerformanceFrequency ,
			  ProviderPerformanceDelay 
			)
	VALUES  ( 1 , -- PracticeID - int
			  '' , -- Prefix - varchar(16)
			  'Stephen' , -- FirstName - varchar(64)
			  '' , -- MiddleName - varchar(64)
			  'Keim' , -- LastName - varchar(64)
			  '' , -- Suffix - varchar(16)
			  1 , -- ActiveDoctor - bit
			  GETDATE() , -- CreatedDate - datetime
			  0 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  0 , -- ModifiedUserID - int
			  'MD' , -- Degree - varchar(8)
			  1 , -- VendorImportID - int
			  0 , -- External - bit
			  '1821080029' , -- NPI - varchar(10)
			  1 , -- ProviderTypeID - int
			  0 , -- ProviderPerformanceReportActive - bit
			  2 , -- ProviderPerformanceScope - int
			  'W' , -- ProviderPerformanceFrequency - char(1)
			  2  -- ProviderPerformanceDelay - int
			)
END


 UPDATE atr
  SET atr.resourceID = CASE WHEN imp.drnpi = '' AND imp.providerfirstname = 'OFFICE1' THEN 1
							WHEN imp.drnpi <> '' then doc.doctorID
							ELSE (SELECT doctorid FROM dbo.Doctor WHERE LastName = 'Shariff')
						END,
		atr.appointmentresourcetypeid = CASE WHEN imp.providerfirstname = 'OFFICE1' THEN 2
										ELSE 1 
										END		
  FROM dbo.AppointmentToResource atr 
  JOIN dbo.Appointment app ON atr.AppointmentID = app.AppointmentID
  JOIN dbo.Patient pat ON app.PatientID = pat.PatientID
  JOIN dbo._import_1_1_Scheduler imp ON imp.accountnumber = pat.VendorID
  left JOIN dbo.Doctor doc ON doc.npi = imp.drnpi 
 
	
 UPDATE dbo.Appointment 
	SET EndDate = DATEADD(mi, 30, StartDate)
	WHERE StartDate > EndDate




