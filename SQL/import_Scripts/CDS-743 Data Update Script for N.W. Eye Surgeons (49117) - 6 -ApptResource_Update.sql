USE superbill_49117_dev
--USE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @NewVendorImportID INT

SET @PracticeID = 1
SET @NewVendorImportID = 7

SET NOCOUNT ON 

CREATE TABLE #tempappt (ApptID VARCHAR(50) , ChartNumber VARCHAR(50) , DoctorFirstName VARCHAR(64) , DoctorLastName VARCHAR(64) , 
						PatientFirstName VARCHAR(64) , PatientMiddleName VARCHAR(64) , PatientLastName VARCHAR(64) , 
						StartDate DATETIME , EndDate DATETIME , [Status] VARCHAR(25) , Note VARCHAR(MAX) , ServiceLocationName VARCHAR(125), 
						ResourceDesc VARCHAR(50) , ApptRescheduled VARCHAR(50) , ReschedInd VARCHAR(5) , ApptKeptInd VARCHAR(5) , WorkflowStatus VARCHAR(50) ,
						[Event] VARCHAR(50) , PatientID INT )


INSERT INTO #tempappt
        ( ApptID ,
          ChartNumber ,
          DoctorFirstName ,
          DoctorLastName ,
          PatientFirstName ,
          PatientMiddleName ,
          PatientLastName ,
          StartDate ,
          EndDate ,
          Status ,
          Note ,
          ServiceLocationName ,
		  ResourceDesc ,
          ApptRescheduled ,
          ReschedInd ,
          ApptKeptInd ,
          WorkflowStatus ,
          Event ,
          PatientID 
        )
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END  , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          CASE i.servicelocationname
			WHEN 'Mira Vista Care Center' THEN 'Z Mira Vista Care Center'
			WHEN 'SRUCK Skagit Regional Urgent Care' THEN 'Z SRUCK Skagit Regional Urgent C'
			WHEN 'SRUCF Skagit Regional Urgent Care' THEN 'Z SRUCF Skagit Regional Urgent C'
			WHEN 'BASC Bellingham Ambulatory Surgery Cntr' THEN 'Z BASC Bellingham Ambulatory Sur'
			WHEN 'SLS NW Eye Surgeons' THEN 'Z SLS NW Eye Surgeons'
			WHEN 'NSSC North Seattle Surgery Center' THEN 'Z NSSC North Seattle Surgery Cen'
			WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
		  ELSE servicelocationname END  , -- ServiceLocationName - varchar(125)
          i.practiceresource ,
		  i.apptrescheduled , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          i.apptkeptind , -- ApptKeptInd - varchar(1)
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_6_1_491171AppointmentUpdatev2p1] i
INNER JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID

UNION

 SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END  , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          CASE i.servicelocationname
			WHEN 'Mira Vista Care Center' THEN 'Z Mira Vista Care Center'
			WHEN 'SRUCK Skagit Regional Urgent Care' THEN 'Z SRUCK Skagit Regional Urgent C'
			WHEN 'SRUCF Skagit Regional Urgent Care' THEN 'Z SRUCF Skagit Regional Urgent C'
			WHEN 'BASC Bellingham Ambulatory Surgery Cntr' THEN 'Z BASC Bellingham Ambulatory Sur'
			WHEN 'SLS NW Eye Surgeons' THEN 'Z SLS NW Eye Surgeons'
			WHEN 'NSSC North Seattle Surgery Center' THEN 'Z NSSC North Seattle Surgery Cen'
			WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
		  ELSE servicelocationname END  , -- ServiceLocationName - varchar(125)
          i.practiceresource ,
		  i.apptrescheduled , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          i.apptkeptind , -- ApptKeptInd - varchar(1)
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_7_1_491171AppointmentUpdatev2p2] i
INNER JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID

UNION

 SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END  , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          CASE i.servicelocationname
			WHEN 'Mira Vista Care Center' THEN 'Z Mira Vista Care Center'
			WHEN 'SRUCK Skagit Regional Urgent Care' THEN 'Z SRUCK Skagit Regional Urgent C'
			WHEN 'SRUCF Skagit Regional Urgent Care' THEN 'Z SRUCF Skagit Regional Urgent C'
			WHEN 'BASC Bellingham Ambulatory Surgery Cntr' THEN 'Z BASC Bellingham Ambulatory Sur'
			WHEN 'SLS NW Eye Surgeons' THEN 'Z SLS NW Eye Surgeons'
			WHEN 'NSSC North Seattle Surgery Center' THEN 'Z NSSC North Seattle Surgery Cen'
			WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
		  ELSE servicelocationname END  , -- ServiceLocationName - varchar(125)
          i.practiceresource ,
		  i.apptrescheduled , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          i.apptkeptind , -- ApptKeptInd - varchar(1)
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_8_1_491171AppointmentUpdatev2p3] i
INNER JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID

UNION SELECT

		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.doctorfirstname , -- DoctorFirstName - varchar(64)
          CASE WHEN i.doctorlastname = 'Talley Rostov' THEN 'Talley-Rostov'  ELSE i.doctorlastname END  , -- DoctorLastName - varchar(64)
          i.patientfirstname , -- PatientFirstName - varchar(64)
          i.patientmiddlename , -- PatientMiddleName - varchar(64)
          i.patientlastname , -- PatientLastName - varchar(64)
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          i.[status] , -- Status - varchar(25)
          i.note , -- Note - varchar(max)
          CASE i.servicelocationname
			WHEN 'Mira Vista Care Center' THEN 'Z Mira Vista Care Center'
			WHEN 'SRUCK Skagit Regional Urgent Care' THEN 'Z SRUCK Skagit Regional Urgent C'
			WHEN 'SRUCF Skagit Regional Urgent Care' THEN 'Z SRUCF Skagit Regional Urgent C'
			WHEN 'BASC Bellingham Ambulatory Surgery Cntr' THEN 'Z BASC Bellingham Ambulatory Sur'
			WHEN 'SLS NW Eye Surgeons' THEN 'Z SLS NW Eye Surgeons'
			WHEN 'NSSC North Seattle Surgery Center' THEN 'Z NSSC North Seattle Surgery Cen'
			WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
		  ELSE servicelocationname END  , -- ServiceLocationName - varchar(125)
          i.practiceresource ,
		  i.apptrescheduled , -- ApptRescheduled - varchar(50)
          i.reschedind , -- ReschedInd - varchar(1)
          i.apptkeptind , -- ApptKeptInd - varchar(1)
          i.workflowstatus , -- WorkflowStatus - varchar(50)
          i.[event] , -- Event - varchar(50)
          p.PatientID -- PatientID - int
FROM dbo.[_import_9_1_491171AppointmentUpdatev2p4] i
INNER JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID


--- updating appointment to resource for last two appointment inserts since a bad case when did not assign the correct resource
PRINT ''
PRINT 'Updating AppointmenttoResource...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = CASE i.ResourceDesc WHEN 'Visual Field Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-VF-ONLY' AND LastName = 'TECH')
										  WHEN 'Ortho Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-ORTHO' AND LastName = 'TECH')
									 	  WHEN 'Technician Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Technician Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'TECH')
									 	  WHEN 'Technician Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'TECH')
									 	  WHEN 'Technician Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'TECH')
									 	  WHEN 'Technician Sequim' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SQC' AND LastName = 'TECH')
									 	  WHEN 'Technician Smokey Point' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SPC' AND LastName = 'TECH')
									 	  WHEN 'Photo Bellingham' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'TECH')
									 	  WHEN 'Photo Mount Vernon' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'MVC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'PHOTO')
									 	  WHEN 'Photo Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'PHOTO')
										  WHEN 'Ascan Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC' AND LastName = 'TECH')
										  WHEN 'Ascan Renton' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RC' AND LastName = 'TECH')
										  WHEN 'Ascan Sequim' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SQC' AND LastName = 'TECH')
				    ELSE atr.ResourceID END ,
		AppointmentResourceTypeID = CASE i.ResourceDesc WHEN 'Visual Field Seattle' THEN 1
										  WHEN 'Ortho Seattle' THEN 1
									 	  WHEN 'Technician Bellingham' THEN 1
									 	  WHEN 'Technician Mount Vernon' THEN 1
									 	  WHEN 'Technician Renton' THEN 1
									 	  WHEN 'Technician Seattle' THEN 1
									 	  WHEN 'Technician Sequim' THEN 1
									 	  WHEN 'Technician Smokey Point' THEN 1
									 	  WHEN 'Photo Bellingham' THEN 1
									 	  WHEN 'Photo Mount Vernon' THEN 1
									 	  WHEN 'Photo Seattle' THEN 1
									 	  WHEN 'Photo Renton' THEN 1
										  WHEN 'Ascan Seattle' THEN 1
										  WHEN 'Ascan Renton' THEN 1
										  WHEN 'Ascan Sequim' THEN 1
									ELSE atr.AppointmentResourceTypeID END ,
		ModifiedDate = GETDATE()
FROM dbo.AppointmentToResource atr 
INNER JOIN dbo.Appointment a ON 
	atr.AppointmentID = a.AppointmentID AND 
	atr.PracticeID = @PracticeID AND 
	a.AppointmentType = 'P'
INNER JOIN #tempappt i ON 
	a.[Subject] = i.ApptID 
WHERE a.CreatedDate IN ('2016-03-31 17:50:15.853' , '2016-03-23 15:07:31.397')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

DROP TABLE #tempappt

--ROLLBACK
--COMMIT