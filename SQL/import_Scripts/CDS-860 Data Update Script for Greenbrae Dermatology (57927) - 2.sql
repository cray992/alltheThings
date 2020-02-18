USE superbill_57927_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

SET NOCOUNT ON 

PRINT ''
PRINT 'Update Patient...'
UPDATE dbo.Patient
	SET AddressLine1 = i.pataddr1 , 
		AddressLine2 = i.pataddr2 ,
		City = i.patcity , 
		[State] = LEFT(i.patstate,2) , 
		ZipCode = CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.patzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) 
							THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.patzip,'-',''),' ',''),'=',''),'r',''),'.',''))
					   WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.patzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (5,9) 
							THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.patzip,'-',''),' ',''),'=',''),'r',''),'.','')
				   ELSE '00000' END ,
		ModifiedDate = GETDATE() , 
		CreatedDate = GETDATE()
FROM dbo.Patient p
	INNER JOIN dbo._import_1_1_PatFile i ON 
		LEFT(VendorID,CHARINDEX('.',VendorID)-1) = i.pataccount AND 
		p.PracticeID = @PracticeID
WHERE p.VendorImportID = @VendorImportID AND p.ZipCode = '00000'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT



