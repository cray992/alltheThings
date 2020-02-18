USE superbill_61962_prod
GO

BEGIN TRAN
SET XACT_ABORT ON 
SET NOCOUNT ON

INSERT INTO dbo.Attorney
        ( Prefix ,
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
          WorkPhone ,
          WorkPhoneExt ,
          FaxPhone ,
          FaxPhoneExt ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT		
		  '' ,
		  i.name,
		  '',
		  '',
		  '',
          i.street1 , -- AddressLine1 - varchar(256)
          i.street2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zipcode)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zipcode)
		  ELSE '' END , -- ZipCode - varchar(9)
          CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone),10)
		  ELSE '' END  , -- WorkPhone - varchar(10)
          CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) > 10 THEN LEFT(SUBSTRING(i.phone,11,LEN(i.phone)),10)
		  ELSE NULL END , -- WorkPhoneExt - varchar(10)
          CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.fax)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.fax),10)
		  ELSE '' END  , -- FaxPhone - varchar(10)
          CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.fax)) > 10 THEN LEFT(SUBSTRING(i.fax,11,LEN(i.fax)),10)
		  ELSE NULL END, -- FaxPhoneExt - varchar(10)
          CASE WHEN i.contact <> '' THEN 'Contact: ' + i.contact END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo._import_1_2_ATTORNEYLIST i
WHERE i.code <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Attorney records inserted'
	


--ROLLBACK
--COMMIT

