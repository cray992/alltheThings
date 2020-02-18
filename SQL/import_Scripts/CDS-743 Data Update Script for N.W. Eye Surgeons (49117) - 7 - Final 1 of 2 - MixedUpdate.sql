USE superbill_49117_dev
--SE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @NewVendorImportID INT
DECLARE @VendorImportID1 INT
DECLARE @VendorImportID2 INT
DECLARE @VendorImportID3 INT
DECLARE @VendorImportID4 INT
DECLARE @DefaultCollectionCategory INT

SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)
SET @PracticeID = 1
SET @NewVendorImportID = 8
SET @VendorImportID1 = 0
SET @VendorImportID2 = 5
SET @VendorImportID3 = 6
SET @VendorImportID4 = 7

SET NOCOUNT ON 


CREATE TABLE #temppat (personid VARCHAR(50) ,  
					   address2 VARCHAR(256))


INSERT INTO	#temppat
        ( personid , address2  ) 
SELECT DISTINCT    
		  i.personid , -- personid - varchar(50)
		  i.address2 
FROM dbo.[_import_14_1_491171PatientDemoUpdate1] i

UNION

SELECT DISTINCT    
		  i.personid , -- personid - varchar(50)
		  i.address2 
FROM dbo.[_import_17_1_491171PatientDemoUpdate2] i

PRINT ''
PRINT 'Updating Existing Patients with Demographic Info from Most Recent Export from NGProd...'
UPDATE dbo.Patient 
	SET 
		AddressLine2 = CASE WHEN i.address2 <> p.AddressLine2 THEN i.address2 ELSE p.AddressLine2 END 
FROM dbo.Patient p 
	INNER JOIN #temppat i ON 
		p.VendorID = i.personid AND 
		p.PracticeID = @PracticeID AND 
        p.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' as records updated'

UPDATE dbo.Doctor SET ZipCode = Country
UPDATE dbo.Doctor SET Country = ''

PRINT ''
PRINT 'Update Doctor - Zip and Email...'
UPDATE dbo.Doctor 
	SET AddressLine1 = CASE WHEN d.AddressLine1 <> i.address1 THEN i.address1 ELSE d.AddressLine1 END,
		AddressLine2 = CASE WHEN d.AddressLine2 <> i.address2 THEN i.address2 ELSE d.AddressLine2 END,
		city = CASE WHEN d.City <> i.city THEN i.city ELSE d.City END,
		[state] = CASE WHEN d.[State] <> i.[State] THEN i.[State] ELSE d.[State] END,
		ZipCode = CASE WHEN d.ZipCode <> CASE WHEN LEN(i.zip) IN (4,8) THEN '0' + i.zip ELSE i.zip END 
										 THEN CASE WHEN LEN(i.zip) IN (4,8) THEN '0' + i.zip ELSE i.zip END 
				  ELSE d.ZipCode END ,
		EmailAddress = CASE WHEN ISNULL(d.EmailAddress,'') <> i.email THEN i.email ELSE d.EmailAddress END ,
		ssn = CASE WHEN d.SSN <> i.SSN THEN i.SSN ELSE d.SSN END,
		homephone = CASE WHEN d.HomePhone <> i.homephone THEN i.homephone ELSE d.homephone END,
		workphone = CASE WHEN d.workphone <> i.workphone THEN i.workphone ELSE d.workphone END,
		MobilePhone = CASE WHEN d.MobilePhone <> i.cellphone THEN i.cellphone ELSE d.MobilePhone END,
		FaxNumber = CASE WHEN ISNULL(d.FaxNumber,'') <> i.fax THEN i.fax ELSE d.FaxNumber END
FROM dbo.Doctor d 
	INNER JOIN dbo.[_import_18_1_491171Providers] i ON
		d.FirstName = i.firstname AND 
		d.LastName = i.lastname AND
        d.[External] = 1 AND 
		d.PracticeID = 1 AND 
		d.ActiveDoctor = 1 
WHERE d.ActiveDoctor = 1 AND d.[External] = 1 AND d.PracticeID = 1 AND i.deleteindicator = 'N'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

CREATE TABLE #tempappt (ApptID VARCHAR(50) , ChartNumber VARCHAR(50) , ResourceDesc VARCHAR(50) , PatientID INT , StartDate DATETIME , 
						EndDate DATETIME , note VARCHAR(MAX) , [status] VARCHAR (10) , [event] VARCHAR(50))

INSERT INTO #tempappt
        ( ApptID ,
          ChartNumber ,
		  ResourceDesc ,
          PatientID , 
		  StartDate , 
		  EndDate , 
		  note , 
		  [status] , 
		  [event]
        )
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.practiceresource ,
          p.PatientID , -- PatientID - int
		  i.startdate , 
		  i.enddate , 
		  i.note , 
		  i.[status] , 
		  i.[event]
FROM dbo.[_import_10_1_491171AppointmentUpdatev3p1] i
INNER JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10')

UNION

 SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.practiceresource ,
          p.PatientID , -- PatientID - int
		  i.startdate , 
		  i.enddate , 
		  i.note , 
		  i.[status] , 
		  i.[event]
FROM dbo.[_import_11_1_491171AppointmentUpdatev3p2] i
LEFT JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10') 


UNION

 SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.practiceresource ,
          p.PatientID , -- PatientID - int
		  i.startdate , 
		  i.enddate , 
		  i.note , 
		  i.[status] , 
		  i.[event]
FROM dbo.[_import_12_1_491171AppointmentUpdatev3p3] i
LEFT JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10') 


UNION 
SELECT DISTINCT
		  i.apptid , -- ApptID - varchar(50)
          i.chartnumber , -- ChartNumber - varchar(50)
          i.practiceresource ,
          p.PatientID , -- PatientID - int
		  i.startdate , 
		  i.enddate , 
		  i.note , 
		  i.[status] , 
		  i.[event]
FROM dbo.[_import_13_1_491171AppointmentUpdatev3p4] i
LEFT JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.eventduration IN ('NULL','10') 

PRINT ''
PRINT 'Updating Appointments - From Other to Patient...'
UPDATE dbo.Appointment
	SET PatientID = i.PatientID ,
		AppointmentType = 'P' , 
		[Subject] = i.apptid , 
	    AppointmentConfirmationStatusCode = CASE 
												WHEN i.Note LIKE '%NO SHOW%' THEN 'N' 
												WHEN i.[Status] = 'Cancelled' THEN 'X'
											ELSE a.AppointmentConfirmationStatusCode END ,
		ModifiedDate = GETDATE() , 
		PatientCaseID = pc.PatientCaseID
FROM dbo.Appointment a 
INNER JOIN #tempappt i ON 
	a.StartDate = CAST(i.startdate AS DATETIME) AND 
	a.EndDate = CAST(i.enddate AS DATETIME) AND
	CAST(a.Notes AS VARCHAR(MAX)) = i.note  
INNER JOIN dbo.Patient p ON 
	i.ChartNumber = p.VendorID AND 
	p.PracticeID = @PracticeID
LEFT JOIN dbo.PatientCase PC ON 
	pc.patientcaseid = (SELECT MAX(PatientCaseID) FROM dbo.patientcase PC2 
						WHERE p.PatientID = pc2.PatientID AND pc2.PracticeID = @PracticeID)
WHERE a.AppointmentType = 'O' 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 


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
WHERE a.ModifiedDate > DATEADD(mi,-5,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Appointment to Resource - Photo Bellingham'
UPDATE dbo.AppointmentToResource
	SET ResourceID = (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BHC' AND LastName = 'PHOTO')
FROM dbo.AppointmentToResource atr 
	INNER JOIN dbo.Appointment a ON
		atr.AppointmentID = a.AppointmentID and 
		a.PracticeID = @PracticeID
	INNER JOIN #tempappt i ON 
		a.[Subject] = i.ApptID AND 
		a.PracticeID = @PracticeID
WHERE i.ResourceDesc = 'Photo Bellingham' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #ar
DROP TABLE #tempappt 
DROP TABLE #temppat

--ROLLBACK
--COMMIT
