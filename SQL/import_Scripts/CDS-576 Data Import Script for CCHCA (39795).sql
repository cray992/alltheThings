USE superbill_39795_dev
--USE superbill_39795_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR)
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

PRINT ''
PRINT 'Updating Doctor Demographics...'
UPDATE dbo.Doctor 
	SET HomePhone = dbo.fn_RemoveNonNumericCharacters(i.hmphone) ,
		MobilePhone = LEFT(dbo.fn_RemoveNonNumericCharacters(i.mobilephone),10) ,
		MobilePhoneExt = CASE
						 WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.mobilephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.mobilephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.mobilephone))),10)
		                 ELSE NULL END ,
		FaxNumber = dbo.fn_RemoveNonNumericCharacters(i.fax) ,
		EmailAddress = i.emailaddr ,
		NPI = i.npi ,
		Notes = 'Upin: ' + CAST(i.upin AS VARCHAR) + CHAR(13) + CHAR(10) + CAST(d.Notes AS VARCHAR)
FROM dbo.Doctor d 
INNER JOIN dbo.[_import_3_1_RefProfUpdate] i ON
	i.firstname = d.FirstName AND i.lastname = d.LastName AND i.addr1 = d.AddressLine1 AND d.VendorImportID = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          HomePhone ,
		  HomePhoneExt ,
          MobilePhone ,
          EmailAddress ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          i.firstname ,
          i.middlname ,
          i.lastname ,
          '' ,
          i.addr1 ,
          i.addr2 ,
          i.city ,
          LEFT(i.[state],2) ,
          '' ,
          LEFT(REPLACE(i.zip,' ',''),9) ,
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.hmphone),10) ,
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.hmphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.hmphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.hmphone))),10)
		  ELSE NULL END ,
          dbo.fn_RemoveNonNumericCharacters(i.mobilephone) ,

          i.emailaddr ,
          'Upin: ' + i.upin ,
          1 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          i.name ,
          @VendorImportID ,
          dbo.fn_RemoveNonNumericCharacters(i.fax) ,
          1 ,
          i.npi 
FROM dbo.[_import_3_1_RefProfUpdate] i
WHERE NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE i.firstname = d.FirstName AND i.lastname = d.LastName AND i.addr1 = d.AddressLine1 AND d.PracticeID = @PracticeID)
	  AND i.firstname <> '' AND i.lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT
