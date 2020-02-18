USE superbill_18177_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 2
SET @SourcePracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT ''
PRINT 'Inserting Into Practice Resource...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
SELECT DISTINCT
		  pr.PracticeResourceTypeID , -- PracticeResourceTypeID - int
          @TargetPracticeID , -- PracticeID - int
          pr.ResourceName , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.PracticeResource pr
WHERE pr.PracticeID = @SourcePracticeID AND 
NOT EXISTS 
(
	SELECT * FROM dbo.PracticeResource pr2 
	WHERE pr.ResourceName = pr2.ResourceName AND 
	pr2.PracticeID = @TargetPracticeID
)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @TargetPracticeID , -- PracticeID - int
          ar.Name , -- Name - varchar(128)
          ar.DefaultDurationMinutes , -- DefaultDurationMinutes - int
          ar.DefaultColorCode , -- DefaultColorCode - int
          ar.[Description] , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.AppointmentReason ar
WHERE ar.PracticeID = @SourcePracticeID AND NOT EXISTS 
(
	SELECT * FROM dbo.AppointmentReason ar2 
	WHERE ar.Name = ar2.Name AND 
		  ar.DefaultDurationMinutes = ar2.DefaultDurationMinutes AND 
		  ar2.PracticeID = @TargetPracticeID
)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT