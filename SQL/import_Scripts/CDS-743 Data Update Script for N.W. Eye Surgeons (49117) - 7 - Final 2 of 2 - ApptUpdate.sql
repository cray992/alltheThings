USE superbill_49117_dev
--USE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
SET @PracticeID = 1

SET NOCOUNT ON 

CREATE TABLE #tempappt (ApptID VARCHAR(50) , StartDate DATETIME , EndDate DATETIME , [Status] VARCHAR(25) ,
						ResourceDesc VARCHAR(50) , ApptRescheduled VARCHAR(50) , ReschedInd VARCHAR(5) , ApptKeptInd VARCHAR(5) ,
						apptretainid VARCHAR(10) , promptretainind VARCHAR(10) , WorkflowStatus VARCHAR(50) , [Event] VARCHAR(50) , PatientID INT )


INSERT INTO #tempappt
        ( ApptID ,
          StartDate ,
          EndDate ,
          [Status] ,
          ApptRescheduled ,
          ReschedInd ,
          ApptKeptInd ,
		  apptretainid ,
		  promptretainind ,
          WorkflowStatus ,
          [Event] ,
          PatientID 
        )
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
		  CASE WHEN i.apptrescheduled = 'NULL' THEN '' ELSE i.apptrescheduled END , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          CASE WHEN i.apptkeptind = 'NULL' THEN '' ELSE i.apptkeptind END , -- ApptKeptInd - varchar(1)
		  CASE WHEN i.apptretainid = 'NULL' THEN '' ELSE i.apptkeptind END ,
		  CASE WHEN i.promptretainind = 'NULL' THEN '' ELSE i.promptretainind END ,
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_19_1_491171AppointmentUpdatev4p1] i
INNER JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10')

UNION SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
		  CASE WHEN i.apptrescheduled = 'NULL' THEN '' ELSE i.apptrescheduled END , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          CASE WHEN i.apptkeptind = 'NULL' THEN '' ELSE i.apptkeptind END , -- ApptKeptInd - varchar(1)
		  CASE WHEN i.apptretainid = 'NULL' THEN '' ELSE i.apptkeptind END ,
		  CASE WHEN i.promptretainind = 'NULL' THEN '' ELSE i.promptretainind END ,
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_20_1_491171AppointmentUpdatev4p2] i
LEFT JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10')

UNION SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
		  CASE WHEN i.apptrescheduled = 'NULL' THEN '' ELSE i.apptrescheduled END , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          CASE WHEN i.apptkeptind = 'NULL' THEN '' ELSE i.apptkeptind END , -- ApptKeptInd - varchar(1)
		  CASE WHEN i.apptretainid = 'NULL' THEN '' ELSE i.apptkeptind END ,
		  CASE WHEN i.promptretainind = 'NULL' THEN '' ELSE i.promptretainind END ,
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_21_1_491171AppointmentUpdatev4p3] i
LEFT JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10')

UNION SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
		  CASE WHEN i.apptrescheduled = 'NULL' THEN '' ELSE i.apptrescheduled END , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          CASE WHEN i.apptkeptind = 'NULL' THEN '' ELSE i.apptkeptind END , -- ApptKeptInd - varchar(1)
		  CASE WHEN i.apptretainid = 'NULL' THEN '' ELSE i.apptkeptind END ,
		  CASE WHEN i.promptretainind = 'NULL' THEN '' ELSE i.promptretainind END ,
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_22_1_491171AppointmentUpdatev4p4] i
LEFT JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10')

PRINT ''
PRINT 'Updating Appointments - Cancelled...'
UPDATE dbo.Appointment 
	SET AppointmentConfirmationStatusCode = 'X' ,
		ModifiedDate = GETDATE()
FROM dbo.Appointment a 
	INNER JOIN #tempappt i ON 
		a.[Subject] = i.ApptID AND 
		a.PracticeID = @PracticeID
WHERE i.[Status] = 'Cancelled' AND a.AppointmentConfirmationStatusCode <> 'X' AND a.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #tempappt

--ROLLBACK
--COMMIT


