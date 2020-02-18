USE superbill_9509_prod
GO

BEGIN TRAN

SET NOCOUNT ON 

UPDATE dbo.Appointment
SET StartDate = i.startdate , 
	EndDate = i.enddate ,
	StartTm = i.starttm ,
	EndTm = i.endtm ,
	StartDKPracticeID = dk.DKPracticeID ,
	EndDKPracticeID = dk.DKPracticeID
FROM dbo.Appointment a
INNER JOIN dbo.Patient p ON 
	a.PatientID = p.PatientID AND 
	p.PracticeID = 8
INNER JOIN dbo._import_8_8_Appts i ON 
	a.[Subject] = i.AutoTempID AND
	i.firstname = p.FirstName AND 
	i.lastname = p.LastName AND 
	DATEADD(hh,12,CAST(i.birthdate AS DATETIME)) = p.DOB
INNER JOIN dbo.DateKeyToPractice DK ON
	DK.PracticeID = 8 AND
	DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
WHERE a.PracticeID = 8 AND a.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT

