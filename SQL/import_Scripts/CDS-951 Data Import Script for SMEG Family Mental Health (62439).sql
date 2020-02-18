USE superbill_62439_prod
GO

BEGIN TRAN 
SET XACT_ABORT ON 
SET NOCOUNT ON 

DECLARE @PracticeID INT
SET @PracticeID = 1

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
		  p.PatientID ,
          @PracticeID ,
          1 ,
          i.startdate ,
          i.enddate ,
          'P' ,
          i.AutoTempID ,
          i.[service] ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          'S' ,
          pc.PatientCaseID ,
          dk.DKPracticeID ,
          dk.DKPracticeID ,
          CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) ,
          CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)
FROM dbo._import_2_1_Sheet1 i 
	INNER JOIN dbo.Patient p ON 
		p.PatientID = (SELECT MIN(p2.PatientID) 
					   FROM dbo.Patient p2 
					   WHERE p2.FirstName = i.patfirstname AND 
							 p2.LastName = i.patlastname AND
							 p2.PracticeID = @PracticeID)
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MIN(pc2.PatientCaseID)
							FROM dbo.PatientCase pc2	
							WHERE p.PatientID = pc2.PatientID AND 
								  p.PracticeID = @PracticeID)
	INNER JOIN dbo.DateKeyToPractice dk ON 
		dk.PracticeID = @PracticeID AND
		dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment records inserted'

IF NOT EXISTS (SELECT * FROM dbo.PracticeResource WHERE ResourceName = 'Nurse') 
BEGIN

INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  ( 1 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'Nurse' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )
END

INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          CASE WHEN i.provider = 'Goswick, Gail' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          CASE i.provider 
			WHEN 'Coffman, Lisa' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Lisa' AND LastName = 'COFFMAN' AND [External] = 0 AND ActiveDoctor = 1)
			WHEN 'Davis, Karen' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'KAREN' AND LastName = 'DAVIS' AND [External] = 0 AND ActiveDoctor = 1) 
			WHEN 'Goswick, Gail' THEN (SELECT PracticeResourceID FROM dbo.PracticeResource WHERE ResourceName = 'Nurse')
			WHEN 'Meola, Cheryl' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'CHERYL' AND LastName = 'MEOLA' AND [External] = 0 AND ActiveDoctor = 1)
			WHEN 'Newhouse, Kelly' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'KELLY' AND LastName = 'NEWHOUSE' AND [External] = 0 AND ActiveDoctor = 1)
			WHEN 'Rogers , Jamie' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Dr. JAMIE' AND LastName = 'ROGERS' AND [External] = 0 AND ActiveDoctor = 1)
			WHEN 'Sexton, Leslie' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'LESLIE' AND LastName = 'SEXTON' AND [External] = 0 AND ActiveDoctor = 1)
			WHEN 'Wright, Marion' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MARION' AND LastName = 'WRIGHT' AND [External] = 0 AND ActiveDoctor = 1)
		  END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- PracticeID - int
FROM dbo._import_2_1_Sheet1 i 
	INNER JOIN dbo.Appointment a ON 
		i.AutoTempID = a.[Subject] AND 
		a.PracticeID = @PracticeID AND
		a.AppointmentType = 'P' AND
		a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' AppointmentToResource records inserted'

--ROLLBACK
--COMMIT

SELECT * FROM dbo.PracticeResource