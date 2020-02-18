--USE superbill_14049_dev
use superbill_14049_prod
GO

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT  ON

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT''

DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PracticeID = @PracticeID AND CreatedDate > DATEADD(hh, -1, GETDATE()))
PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResoure records deleted'

DELETE FROM dbo.Appointment WHERE PracticeID = @PracticeID AND CreatedDate > DATEADD(hh, -1, GETDATE())
PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'


		--Appointments
		PRINT ''
		PRINT ''
		PRINT 'Inserting into Appointments ...'
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
				  realP.PatientID , -- PatientID - int
				  @PracticeID , -- PracticeID - int
				  1 ,
				  DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				  DATEADD(hh, CAST(
						(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 2)) > 24 
						THEN  left((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 1)
						ELSE  left((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
								   CASE WHEN len(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
										THEN  replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')
										ELSE (replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200)
										END
									ELSE
										CASE WHEN 
											charindex( 'PM', replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 0 ) > 0
											THEN REPLACE(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', ''), 'PM', '')
			 							ELSE replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
										END 
									END ), 2) END) AS SMALLINT), date)) , --Starttime 
				DATEADD(mi, CAST(right((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
					   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
							THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
							ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
							END
						ELSE
							CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
								THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 				ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
							END 
						END ), 2) AS SMALLINT), 
				DATEADD(hh, CAST(
					(CASE WHEN (LEFT((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 2)) > 24 
					THEN  left((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 1)
					ELSE  left((CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
							   CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
									THEN  replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')
									ELSE (replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200)
									END
								ELSE
									CASE WHEN 
										charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
										THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '')
			 						ELSE replace(replace(ltrim(right(DATEADD(mi, cast(app.[length] AS smallint), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', '')
									END 
								END ), 2) END) AS SMALLINT), date)) , -- Endtime
				  'P' , -- AppointmentType - varchar(1)
				  app.id , -- Subject - varchar(64)
				  app.note , -- Notes - text
				  GETDATE() , -- CreatedDate - datetime
				  0 , -- CreatedUserID - int
				  GETDATE() , -- ModifiedDate - datetime
				  0 , -- ModifiedUserID - int
				  0 , -- AppointmentResourceTypeID - int
				  'S' , -- AppointmentConfirmationStatusCode - char(1)
				  pc.PatientCaseID , -- PatientCaseID - int
				  dk.DKPracticeID , -- StartDKPracticeID - int
				  dk.DKPracticeID , -- EndDKPracticeID - int
				  CASE WHEN charindex( 'PM' , app.[starttime] , 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') 
						ELSE (replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						replace(replace(ltrim(right(CAST(app.[starttime] AS DATETIME), 7)), 'AM', ''), ':', '')
				  END ,  -- StartTm - smallint
				  CASE WHEN charindex( 'PM' , app.[starttime], 0) > 0 then  
					  CASE WHEN len(replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '')) > 3
						   THEN  replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') 
						  ELSE (replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'PM', ''), ':', '') + 1200) 
					  END
					  ELSE
						CASE WHEN 
								charindex( 'PM', replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 0 ) > 0
							 THEN REPLACE(replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', ''), 'PM', '') 
			 			ELSE replace(replace(ltrim(right(DATEADD(mi, CAST(app.[length] AS SMALLINT), CAST(app.[starttime] AS DATETIME)), 7)), 'AM', ''), ':', '') 
						END 
				   END   -- EndTm - smallint
		FROM dbo.[_import_5_1_Appointments] app 
		LEFT JOIN dbo.Patient realP ON
			app.chartnumber = realP.VendorID AND
			realP.PracticeID =@PracticeID
		LEFT JOIN dbo.PatientCase pc ON 
			realP.patientID = pc.PatientCaseID and
			pc.PracticeID = @PracticeID
		LEFT JOIN dbo.DateKeyToPractice dk ON
			dk.Dt = CAST(date AS VARCHAR) AND
			dk.PracticeID = @PracticeID
		WHERE date > DATEADD(mi, -12, DATEADD(dd, -28, DATEADD(mm, -5, GETDATE()))) AND
			realP.PatientID IS NOT NULL 
		PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted '


		--AppointmentResource
		PRINT ''
		PRINT 'Inserting into AppointmentToResource ...'
		INSERT INTO dbo.AppointmentToResource
		( AppointmentID ,
		  AppointmentResourceTypeID ,
		  ResourceID ,
		  ModifiedDate ,
		  PracticeID
		)
		SELECT 
			App.AppointmentID,
			1,
			(SELECT DoctorID FROM dbo.Doctor WHERE DoctorID = 1),
			GETDATE(),
			1
		FROM dbo.[_import_5_1_Appointments] impAppt
		INNER JOIN dbo.Patient Pat ON 
			impAppt.chartnumber = Pat.VendorID AND 
			Pat.VendorImportID = 3
		INNER JOIN dbo.Appointment App ON 
			Pat.PatientID = App.PatientID AND
			CAST(app.Subject AS VARCHAR) = impAppt.id 
		PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




---SELECT * FROM dbo.[_import_5_1_Appointments] WHERE date > GETDATE()