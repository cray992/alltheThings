USE superbill_62262_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 1

SET NOCOUNT ON 

CREATE TABLE #ApptMap (AppointmentID INT , NewStartDate DATETIME , NewEndDate DATETIME , PatientVendorID VARCHAR(50))
INSERT INTO #ApptMap
        ( AppointmentID ,
          NewStartDate ,
          NewEndDate , 
		  PatientVendorID
        )
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
          DATEADD(hh,-3,CAST(i.apptdate AS DATETIME) + i.hmmss) , -- NewStartDate - datetime
          DATEADD(hh,-3,DATEADD(mi,CAST(i.duration AS INT),CAST(i.apptdate AS DATETIME)) + i.hmmss) , 
		  i.patientid
FROM dbo._import_2_1_printcsvreports1 i 
	INNER JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND 
		CAST(apptdate AS DATETIME) + enddateimported = a.EndDate AND
		a.PracticeID = @PracticeID

PRINT ''
PRINT 'Updating Appointment Date and Time...'
UPDATE a
	SET StartDate = i.NewStartDate , 
		EndDate = i.NewEndDate , 
		StartTm = REPLACE(LTRIM(REPLACE(LEFT(REPLACE(REPLACE(CAST(i.NewStartDate AS TIME),':',''),'.',''), 4),'0', ' ')),' ','0') , 
		EndTm = REPLACE(LTRIM(REPLACE(LEFT(REPLACE(REPLACE(CAST(i.NewEndDate AS TIME),':',''),'.',''), 4),'0', ' ')),' ','0') 
FROM dbo.Appointment a 
	INNER JOIN #ApptMap i ON a.AppointmentID = i.AppointmentID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #ApptMap

--ROLLBACK		
--COMMIT
