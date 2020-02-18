USE superbill_50394_dev
--USE superbill_50394_prod
GO


SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

SET NOCOUNT ON 


PRINT ''
PRINT 'Updating Patient...'
UPDATE dbo.Patient 
SET DefaultServiceLocationID = NULL 
WHERE DefaultServiceLocationID IS NOT NULL AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Guarantor...'
UPDATE dbo.Patient 
SET ResponsibleDifferentThanPatient = 1 ,
	ResponsibleRelationshipToPatient = 'O' ,
	ResponsibleFirstName = i.gfirstname ,
	ResponsibleMiddleName = i.gmiddlename ,
	ResponsibleLastName = i.glastname ,
	ResponsibleAddressLine1 = i.addressline1 , 
	ResponsibleAddressLine2 = i.addressline2 , 
	ResponsibleCity = i.city , 
	ResponsibleState = i.[state] ,
	ResponsibleZipCode = CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
							  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
						 ELSE '' END
FROM dbo.Patient p 
INNER JOIN dbo.[_import_4_1_GuarantorInfo] i ON 
	i.medrecnbr = p.VendorID AND 
	p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage ,
          AccountStatus ,
          NoteTypeCode ,
          LastNote
        )
SELECT DISTINCT
		  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          'Church: ' + i.church , -- NoteMessage - varchar(max)
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0  -- LastNote - bit
FROM dbo.[_import_4_1_Church] i 
INNER JOIN dbo.Patient p ON
	i.medrecnbr = p.VendorID AND 
	p.VendorImportID = @VendorImportID
WHERE i.church <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT

