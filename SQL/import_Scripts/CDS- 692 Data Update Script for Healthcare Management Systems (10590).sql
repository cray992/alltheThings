--USE superbill_10590_dev
USE superbill_10590_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 33
SET @VendorImportID = 19

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Patient - Email...'
UPDATE dbo.Patient 
	SET EmailAddress = i.patemial
FROM dbo.[_import_21_33_mailaddr] i
INNER JOIN dbo.Patient p ON
	i.patvendorid = p.VendorID AND 
	p.VendorImportID = @VendorImportID
WHERE p.EmailAddress IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  ( 3 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'Nurse' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )

PRINT ''
PRINT 'Updating Appointment to Resource...'
UPDATE dbo.AppointmentToResource
	SET ResourceID = pr.PracticeResourceID , 
		AppointmentResourceTypeID = 2
FROM dbo.AppointmentToResource atr 
INNER JOIN dbo.Appointment a ON 
	a.AppointmentID = atr.AppointmentID AND 
	a.PracticeID = @PracticeID
INNER JOIN dbo.[_import_20_33_aptfile2] i ON 
	CAST(i.startdateest AS DATETIME) = a.StartDate AND 
	CAST(i.endtimeest AS DATETIME) = a.EndDate AND 
	i.aptuniq = a.[Subject]
INNER JOIN dbo.PracticeResource pr ON 
	pr.PracticeID = @PracticeID AND 
	pr.ResourceName = 'Nurse'
WHERE i.aptdr IN (7,8) AND a.PracticeID = @PracticeID AND a.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--PRINT ''
--PRINT 'Updating Appointment - Endate for Dr. Mickley...'
--UPDATE dbo.Appointment
--	SET 
--		EndDate = DATEADD(mi,-15,a.enddate) , 
--		EndTm = CAST(REPLACE(REPLACE(REPLACE(RIGHT(DATEADD(mi,-15,a.enddate),8),':',''),'AM',''),'PM','') AS SMALLINT)
--FROM dbo.Appointment a
--INNER JOIN dbo.[_import_20_33_aptfile2] i ON 
--	CAST(i.startdateest AS DATETIME) = a.StartDate AND 
--	CAST(i.endtimeest AS DATETIME) = a.EndDate AND 
--	i.aptuniq = a.[Subject]
--WHERE i.aptdr IN (3,4) AND a.ModifiedUserID = 0 AND a.PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT






