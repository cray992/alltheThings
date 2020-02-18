USE superbill_33189_dev 
--USE superbill_33189_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 47
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Inserting Into PracticeResource...'
INSERT INTO dbo.PracticeResource 
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
SELECT DISTINCT
		  3 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          FirstName + ' ' + LastName + ' ' + CASE WHEN Degree IS NULL THEN '' ELSE Degree END, -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.Doctor WHERE DoctorID IN (5491, 5458, 5457, 5472)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Appointment to Resource...'
UPDATE dbo.AppointmentToResource
SET ResourceID = (CASE ResourceID WHEN 5457 THEN (SELECT PracticeResourceID FROM dbo.PracticeResource 
												  WHERE ResourceName LIKE '%QUINT%')
								  WHEN 5458 THEN (SELECT PracticeResourceID FROM dbo.PracticeResource 
												  WHERE ResourceName LIKE '%NANCY%')
								  WHEN 5472 THEN (SELECT PracticeResourceID FROM dbo.PracticeResource 
												  WHERE ResourceName LIKE '%STEVEN%')
								  WHEN 5491 THEN (SELECT PracticeResourceID FROM dbo.PracticeResource 
												  WHERE ResourceName LIKE '%Kendra%') 
				  END) ,
	AppointmentResourceTypeID = 2
FROM dbo.AppointmentToResource
WHERE ResourceID IN (5491, 5458, 5457, 5472)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT



