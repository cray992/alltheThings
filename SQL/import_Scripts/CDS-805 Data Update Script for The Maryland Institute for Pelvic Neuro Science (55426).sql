--USE superbill_55426_dev
USE superbill_55426_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 4

SET NOCOUNT ON 

CREATE TABLE #doc (DocID INT , WorkPhone VARCHAR(10) , WorkPhoneExt VARCHAR(10) , Fax VARCHAR(10) , FaxExt VARCHAR(10))
INSERT INTO #doc
        ( DocID ,
          WorkPhone ,
          WorkPhoneExt ,
          Fax ,
          FaxExt
        )
SELECT DISTINCT
		  DoctorID , -- DocID - int
          HomePhone , -- WorkPhone - varchar(10)
          HomePhoneExt , -- WorkPhoneExt - varchar(10)
          MobilePhone , -- Fax - varchar(10)
          MobilePhoneExt  -- FaxExt - varchar(10)
FROM dbo.Doctor 
WHERE [External] = 1 AND PracticeID = @PracticeID AND VendorImportID = @VendorImportID

PRINT ''
PRINT 'Updating Referring Doctor...'
UPDATE dbo.Doctor 
	SET WorkPhone = i.WorkPhone , 
		WorkPhoneExt = i.WorkPhoneExt , 
		FaxNumber = i.Fax , 
		FaxNumberExt = i.FaxExt , 
		HomePhone = NULL ,
		HomePhoneExt = NULL ,
		MobilePhone = NULL , 
		MobilePhoneExt = NULL
FROM dbo.Doctor d 
INNER JOIN #doc i ON 
	d.DoctorID = i.DocID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

