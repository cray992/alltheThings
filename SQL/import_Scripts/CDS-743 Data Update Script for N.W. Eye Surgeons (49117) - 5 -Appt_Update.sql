--USE superbill_49117_dev
USE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @NewVendorImportID INT

SET @PracticeID = 1
SET @NewVendorImportID = 7

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Patient Appointment - Patient Case...'
UPDATE dbo.Appointment
	SET PatientCaseID = pc.PatientCaseID
FROM dbo.Appointment a 
	INNER JOIN dbo.Patient p ON
		a.PatientID = p.PatientID AND
        a.PracticeID = @PracticeID 
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2
							WHERE pc2.PatientID = p.PatientID AND pc2.PracticeID = @PracticeID)
WHERE a.PatientCaseID IS NULL AND a.AppointmentType = 'P'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

CREATE TABLE #temppat (personid VARCHAR(50) , zipcode VARCHAR(9))
INSERT INTO #temppat ( personid, zipcode )
SELECT DISTINCT  
		  i.personid , -- personid - varchar(50)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
		  ELSE '' END  -- zipcode - varchar(9)
FROM dbo.[_import_6_1_491171PatientDemoUpdate1] i 

INSERT INTO #temppat ( personid, zipcode )
SELECT DISTINCT  
		  i.personid , -- personid - varchar(50)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
		  ELSE '' END  -- zipcode - varchar(9)
FROM dbo.[_import_7_1_491171PatientDemoUpdate2] i 

PRINT ''
PRINT 'Updating Patient - ZipCode...'
UPDATE dbo.Patient 
	SET ZipCode = i.zipcode
FROM dbo.Patient p 
INNER JOIN #temppat i ON 
	p.VendorID = i.personid AND 
	p.PracticeID = @PracticeID
WHERE p.ZipCode <> i.zipcode AND p.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Patient - Default Service Location...'
UPDATE dbo.Patient
	SET DefaultServiceLocationID = NULL
WHERE DefaultServiceLocationID IS NOT NULL AND VendorImportID = @NewVendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
          i.kareoapptreasons , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          i.kareoapptreasons , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_9_1_AppointmentReasonsNextGen] i
	LEFT JOIN dbo.AppointmentReason ar ON 
		i.kareoapptreasons = ar.Name AND 
		ar.PracticeID = @PracticeID
WHERE ar.AppointmentReasonID IS NULL AND i.kareoapptreasons <> ''

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

PRINT ''
PRINT 'Updating Appointments from Scheduled to Cancelled...'
UPDATE dbo.Appointment
	SET AppointmentConfirmationStatusCode = 'X' ,
		Notes = 'Conversion Error' , 
		ModifiedDate = GETDATE()
FROM dbo.Appointment a
INNER JOIN #tempappt i ON 
	a.[Subject] = i.ApptID AND
	a.PracticeID = @PracticeID
WHERE a.AppointmentType = 'P' AND i.ReschedInd = 'Y' AND i.Note NOT LIKE '%**NO SHOW**%'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Appointments from Cancelled to Scheduled...'
UPDATE dbo.Appointment
	SET AppointmentConfirmationStatusCode = 'S' ,
		Notes = i.Note ,
		ModifiedDate = GETDATE()
FROM dbo.Appointment a
INNER JOIN #tempappt i ON 
	a.[Subject] = i.ApptID AND 
	a.PracticeID = @PracticeID 
WHERE a.AppointmentType = 'P' AND i.ReschedInd = 'N' AND i.Note NOT LIKE '%**NO SHOW**%'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

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
	          AppointmentResourceTypeID ,
	          AppointmentConfirmationStatusCode ,
	          PatientCaseID ,
	          StartDKPracticeID ,
	          EndDKPracticeID ,
	          StartTm ,
	          EndTm ,
			  [Subject]
	        )
	SELECT  DISTINCT  PAT.PatientID , -- PatientID - int
	          @PracticeID , -- PracticeID - int
	          CASE WHEN SL.ServiceLocationID IS NULL THEN SL2.ServiceLocationID ELSE SL.ServiceLocationID END , -- ServiceLocationID - int
	          PA.StartDate , -- StartDate - datetime
	          PA.EndDate , -- EndDate - datetime
	          'P' , -- AppointmentType - varchar(1)
	          PA.Note , -- Notes - text
	          GETDATE() , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          1 , -- AppointmentResourceTypeID - int
	          CASE 
				WHEN PA.Note LIKE '%**NO SHOW**%' THEN 'N' 
				WHEN PA.[Status] <> '' THEN 'X'
			  ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
	          PC.PatientCaseID , -- PatientCaseID - int
	          DK.DKPracticeID , -- StartDKPracticeID - int
	          DK.DKPracticeID , -- EndDKPracticeID - int
			  CAST(REPLACE(LEFT(CAST(pa.startdate AS TIME),5), ':','') AS SMALLINT) ,   -- StartTm - smallint
	          CAST(REPLACE(LEFT(CAST(pa.enddate AS TIME),5), ':','') AS SMALLINT) , 
			  PA.apptid 
	FROM #tempappt PA
	INNER JOIN dbo.Patient PAT ON 
		PA.PatientID = PAT.PatientID AND
		PAT.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase PC ON 
		pc.patientcaseid = (SELECT MAX(pc2.PatientCaseID) FROM dbo.patientcase PC2 
							WHERE pat.patientid = pc2.patientid AND pc2.PracticeID = @PracticeID) 
		--PC.PatientID = PAT.PatientID AND
		--PC.PracticeID = @PracticeID  
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(PA.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation SL ON
		SL.NAME = PA.ServiceLocationName AND
		SL.PracticeID = @PracticeID  
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
	LEFT JOIN dbo.Appointment a ON 
		pa.ApptID = a.[Subject] AND
        a.PracticeID = @PracticeID
WHERE PA.ReschedInd = 'N' AND a.AppointmentID IS NULL
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
	SELECT DISTINCT  APP.AppointmentID , -- AppointmentID - int
	          1 , -- AppointmentResourceTypeID - int
	          CASE WHEN DOC.DoctorID IS NULL THEN 
				CASE PA.ResourceDesc	  WHEN 'Visual Field Seattle' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'SC-VF-ONLY' AND LastName = 'TECH')
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
			  END 
			  ELSE doc.DoctorID END , -- ResourceID - int
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM #tempappt PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		APP.[Subject] = PA.apptid AND 
		app.PracticeID = @PracticeID
	LEFT JOIN dbo.Doctor DOC ON
		DOC.FirstName = PA.DoctorFirstName AND
		DOC.LastName = PA.DoctorLastName AND
		DOC.PracticeID = @PracticeID AND
		DOC.[EXTERNAL] = 0
	LEFT JOIN dbo.AppointmentToResource atr ON 
		app.AppointmentID = atr.AppointmentID AND 
		atr.PracticeID = @PracticeID
WHERE app.CreatedDate > DATEADD(mi,-15,GETDATE()) AND atr.AppointmentID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

CREATE TABLE #ar (NextGenAR VARCHAR(50) , KareoARid VARCHAR(50))
INSERT INTO #ar
        ( NextGenAR, KareoARid )
SELECT DISTINCT
		  nextgenapptreasons , -- NextGenAR - varchar(50)
          CASE nextgenapptreasons 
			WHEN '1 Day Post Op' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = '1 DAY POST OP')
			WHEN '1 Week Post Op' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = '1 WEEK POST OP')
			WHEN '4 Day Post Op' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SHORT')
			WHEN 'ADD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Argon' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'Ascan' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'Botox' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'Cataract Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'CCON - CATARACT CONSULT')
			WHEN 'Cataract Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'CCON - CATARACT CONSULT')
			WHEN 'Cataract Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Cataract Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Chalazion Removal' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'Combined Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY LONG ')
			WHEN 'Combined Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY LONG ')
			WHEN 'Comprehensive Exam' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Cornea Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'KCON - CORNEA CONSULT')
			WHEN 'Cornea Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'KCON - CORNEA CONSULT')
			WHEN 'Cornea Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Cornea Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Cryo' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'CXL - Cornea Crosslinking Proc' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'KCXL - CROSSLINKING PROCEDURE')
			WHEN 'Diabetic Exam' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'EP Long' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'FA / Photo' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - FA/PHOTOS')
			WHEN 'Final Post Op' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Glaucoma Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'GCON - GLAUCOMA CONSULT')
			WHEN 'Glaucoma Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'GCON - GLAUCOMA CONSULT')
			WHEN 'Glaucoma Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Glaucoma Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'H&P' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Hold' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'HOLD')
			WHEN 'Injection' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'Injection BMP Clinic Only' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'IOL Exchange OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'IOL Exchange OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'IOP' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SHORT')
			WHEN 'I-Stent/Cataract Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'I-Stent/Cataract Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Laser Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Lid Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Lid Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Lid Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Lid Surgery OU' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Misc Procedure OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Misc Procedure OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Misc Procedure OU' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'NP Long' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG NP')
			WHEN 'NP Retina Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'RETCON NP - RETINA CONSULT')
			WHEN 'NULL' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'OCT' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'ORA OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'ORA OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Ortho' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - ORTHO-CHILD')
			WHEN 'Peels' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'Photo' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - FA/PHOTOS')
			WHEN 'Pneumatic' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'Post Op - Dilated' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Post Op - Non-dilated' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SHORT')
			WHEN 'Pre Op' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'Procedure' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'Procedure WC' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'PROCEDURE')
			WHEN 'Product' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'Z - PRODUCT')
			WHEN 'Recheck - Dilated' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Recheck - Non-dilated' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SHORT')
			WHEN 'Refractive Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'REFCON - REFRACTIVE CONSULT')
			WHEN 'Refractive Surgery' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY REFRACTIVE')
			WHEN 'REP APPOINTMENT ONLY' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
			WHEN 'Retina Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'RETCON - RETINA CONSULT')
			WHEN 'Retina Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'RETCON - RETINA CONSULT')
			WHEN 'Retina Surgery' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Same Day Emergency' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SDER')
			WHEN 'Same Day IOP' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SHORT')
			WHEN 'Same Day Laser' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'Same Day Surgery' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Same Day Surgery Consult' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'SLT' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'SLT Only' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'Strabismus Eval' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LONG')
			WHEN 'Strabismus Surgery OD' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Strabismus Surgery OS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Strabismus Surgery OU' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'Tech Exam' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'VA Check' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - TECH ONLY')
			WHEN 'VC Enhancement' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'REFCON - REFRACTIVE CONSULT')
			WHEN 'VF' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - SC VF/MATRIX')
			WHEN 'VF - Matrix Only' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'T - SC VF/MATRIX')
			WHEN 'Yag' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LASER')
			WHEN 'Z  ADMIN' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
			WHEN 'Z  MARKETING' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
			WHEN 'Z  MEETING' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
			WHEN 'Z  NOTES' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
			WHEN 'ZZ CEE Mock Go Live' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NON-PATIENT APPOINTMENTS')
		END	  -- KareoARid - varchar(50)
FROM dbo.[_import_9_1_AppointmentReasonsNextGen]

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
          ar.KareoARid , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM #tempappt i 
INNER JOIN dbo.Appointment a ON 
	i.ApptID = a.[Subject] AND
    a.PracticeID = @PracticeID
INNER JOIN #ar ar ON
	i.[Event] = ar.NextGenAR
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DROP TABLE #ar
DROP TABLE #tempappt
DROP TABLE #temppat

--ROLLBACK
--COMMIT



