USE superbill_60023_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT , @VendorImportID INT
SET @PracticeID = 1
SET @VendorImportID = 1


UPDATE dbo.AppointmentReason 
	SET [Description] = i.[description]
FROM dbo.AppointmentReason ar 
INNER JOIN dbo._import_1_1_ImportApptReason i ON 
	ar.Name = i.appointmentreason 
WHERE i.[description] <> ar.[Description] AND ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Reason Records Updated...'


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
          i.appointmentreason , -- Name - varchar(128)
          i.duration , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          i.description , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo._import_1_1_ImportApptReason i
	LEFT JOIN dbo.AppointmentReason ar ON 
		i.appointmentreason = ar.Name AND 
		ar.PracticeID = @PracticeID
WHERE i.appointmentreason <> '' AND ar.AppointmentReasonID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Reason Records Inserted...'


--ROLLBACK
--COMMIT
