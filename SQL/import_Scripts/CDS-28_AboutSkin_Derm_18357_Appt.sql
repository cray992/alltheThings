USE superbill_18357_prod

DECLARE @PracticeID INT
SET @PracticeID = 1

--DELETE FROM dbo.Appointment WHERE PracticeID = @PracticeID AND CreatedDate > DATEADD(hh, -2, GETDATE())
--PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'

--UPDATE dbo.[_import_4_1_Appointments]
--	SET duration = 30
--	WHERE duration = ''


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
          RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT	  pat.PatientID ,  -- PatientID - int	
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
         DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[time], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				  DATEADD(hh, CAST(
						(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , app.[time], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 2)) > 24 
						THEN  left((CASE WHEN charindex( 'PM' , app.[time], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 1)
						ELSE  left((CASE WHEN charindex( 'PM' , app.[time], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 2) END) AS SMALLINT), appointmentdate)) , --Starttime 
				DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[time], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				DATEADD(hh, CAST(
					(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , app.[time], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 2)) > 24 
					THEN  left((CASE WHEN charindex( 'PM' , app.[time], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 1)
					ELSE  left((CASE WHEN charindex( 'PM' , app.[time], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[duration] AS smallint), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 2) END) AS SMALLINT), appointmentdate)) , -- Endtime
          'P' , -- AppointmentType - varchar(1)
          app.[description] , -- Subject - varchar(64)
          app.[notes] , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          '' , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
           CASE WHEN charindex( 'PM' , app.[time] , 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '') 
						ELSE (replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						replace(replace(ltrim(right(CAST(app.[time] AS DATETIME), 7)), 'AM', ''), ':', '')
				  END ,  -- StartTm - smallint
				  CASE WHEN charindex( 'PM' , app.[time], 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, CAST(app.[duration] AS SMALLINT), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(DATEADD(mi, CAST(app.[duration] AS SMALLINT), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '') 
						  ELSE (replace(replace(ltrim(right(DATEADD(mi, CAST(app.[duration] AS SMALLINT), CAST(app.[time] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, CAST(app.[duration] AS SMALLINT), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
							 THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, CAST(app.[duration] AS SMALLINT), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '') 
			 			ELSE replace(replace(ltrim(right(DATEADD(mi, CAST(app.[duration] AS SMALLINT), CAST(app.[time] AS DATETIME)), 7)), 'AM', ''), ':', '') 
						END 
				   END   -- EndTm - smallint
FROM dbo.[_import_4_1_Appointments] app
LEFT JOIN dbo.Patient pat ON
	app.patientid = pat.MedicalRecordNumber 
LEFT JOIN dbo.PatientCase pc ON	
	pat.PatientID = pc.PatientID
LEFT JOIN dbo.DateKeyToPractice dk ON
	dk.Dt = CAST(app.appointmentdate AS VARCHAR) AND
	dk.PracticeID = @PracticeID
WHERE pat.PatientID IS NOT NULL 



UPDATE dbo.Patient 
	SET HomePhone = (SELECT homephone FROM dbo.[_import_3_1_PatientPhoneNumbers] WHERE patientid = pat.medicalrecordnumber),
	    MobilePhone = (SELECT MobilePhone FROM dbo.[_import_3_1_PatientPhoneNumbers] WHERE patientid = pat.medicalrecordnumber)
	FROM dbo.Patient pat
	
	
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT    app.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          1  -- PracticeID - int
FROM dbo.[_import_5_1_Appointments] appt
inner JOIN dbo.AppointmentReason ar ON 
	LOWER(ar.NAME) = LOWER(appt.DESCRIPTION)
inner JOIN dbo.Patient pat ON 
	appt.patientid = pat.MedicalRecordNumber 
inner JOIN dbo.Appointment app ON	
	pat.Patientid = app.PatientID AND
	CAST(appt.[notes] AS VARCHAR) = CAST(app.Notes AS VARCHAR) AND
	app.StartTm = CASE WHEN charindex( 'PM' , appt.[time] , 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(CAST(appt.[time] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(CAST(appt.[time] AS DATETIME), 7)), 'PM', ''), ':', '') 
						ELSE (replace(replace(ltrim(right(CAST(appt.[time] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						replace(replace(ltrim(right(CAST(appt.[time] AS DATETIME), 7)), 'AM', ''), ':', '')
				  END 