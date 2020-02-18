--USE superbill_41683_dev
USE superbill_41683_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Appoinment Start and End Times...'
UPDATE dbo.Appointment 
SET StartDKPracticeID = dk.DKPracticeID ,
	EndDKPracticeID = dk.DKPracticeID ,
	StartDate = DATEADD(yy,-15,StartDate) ,
	EndDate = DATEADD(yy,-15,EndDate)  
FROM dbo.Appointment a 
	INNER JOIN dbo.DateKeyToPractice dk ON
        dk.[PracticeID] = @PracticeID AND
        dk.Dt = CAST(CAST(DATEADD(yy,-15,StartDate) AS DATE) AS DATETIME)
WHERE CreatedDate = '2016-01-23 05:26:32.123' AND ModifiedDate = '2016-01-23 05:26:32.123'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Appointment...'
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
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.stamrtdamte , -- StartDate - datetime
          i.stopmdamte , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          i.[status] , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.stamrtdamte,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.stopmdamte,5), ':','') AS SMALLINT)  -- EndTm - smallint
FROM dbo.[_import_6_1_DermAssociatesPatientScheduling] i
	INNER JOIN dbo.Patient p ON 
		i.chart = p.VendorID AND 
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.PatientCase pc ON 
		p.PatientID = pc.PatientID AND
		pc.VendorImportID = @VendorImportID AND 
		pc.Name <> 'Balance Forward'
	INNER JOIN dbo.DateKeyToPractice dk ON
        dk.[PracticeID] = @PracticeID AND
        dk.Dt = CAST(CAST(i.stamrtdamte AS DATE) AS DATETIME)
WHERE i.chart <> '' AND i.drfirst <> '' 
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
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          CASE WHEN i.drlast IN ('FOTOFINDER', 'ODONNEL', 'THERAPY', 'COOLSCULPTING', '') THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          CASE i.drlast 
			WHEN 'CHENG' THEN 12
			WHEN 'HEALEY' THEN 4
			WHEN 'RIVKIN' THEN 2
			WHEN 'WEISS' THEN 3
			WHEN 'BREITHAUPT' THEN 6
			WHEN 'FOTOFINDER' THEN 5
			WHEN 'PRINCE' THEN 8
			WHEN 'OSDER' THEN 7
			WHEN 'ODONNEL' THEN 2
			WHEN 'THERAPY' THEN 6
			WHEN 'HOFFMAN' THEN 5
			WHEN 'COOLSCULPTING' THEN 7
			WHEN '' THEN 8
		  END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_6_1_DermAssociatesPatientScheduling] i
	INNER JOIN dbo.Patient p ON 
		i.chart = p.VendorID AND 
		p.VendorImportID = @VendorImportID
	INNER JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND 
		CAST(i.stamrtdamte AS DATETIME) = a.StartDate AND 
		CAST(i.stopmdamte AS DATETIME) = a.EndDate 
WHERE i.chart <> '' AND i.drfirst <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          CASE i.reasoncode
			WHEN 'BC' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'BODY CHECK')
			WHEN 'BLK' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'BLOCKED SLOT')
			WHEN 'BU' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'BLU- U')
			WHEN 'CO' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'COSMETICS')
			WHEN 'CS' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'COOLSCULPTING')
			WHEN 'FA' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'FACIAL')
			WHEN 'FF' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'FotoFacial ')
			WHEN 'FU' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'FOLLOW UP')
			WHEN 'GE' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'GENTLELASE')
			WHEN 'LU' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'LUNCH')
			WHEN 'MOH' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'MOHS')
			WHEN 'NP' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'NEW PATIENT')
			WHEN 'OV' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'OFFICE VISIT')
			WHEN 'SR' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SUTURE REMOVAL')
			WHEN 'SU' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'SURGERY')
			WHEN 'UB' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'UVB')
			WHEN 'VB' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'VBEAM')
		  END , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_6_1_DermAssociatesPatientScheduling] i
	INNER JOIN dbo.Patient p ON 
		i.chart = p.VendorID AND 
		p.VendorImportID = @VendorImportID
	INNER JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND 
		CAST(i.stamrtdamte AS DATETIME) = a.StartDate AND 
		CAST(i.stopmdamte AS DATETIME) = a.EndDate 
WHERE i.chart <> '' AND i.drfirst <> '' AND i.reasoncode <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT


