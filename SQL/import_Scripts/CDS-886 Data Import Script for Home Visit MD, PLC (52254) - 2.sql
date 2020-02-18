USE superbill_52254_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT , @VendorImportID INT
SET @PracticeID = 1
SET @VendorImportID = 3


INSERT INTO dbo.ServiceLocation
        ( PracticeID ,
          Name ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PlaceOfServiceCode ,
          BillingName ,
          Phone ,
          PhoneExt ,
          FaxPhone ,
          FaxPhoneExt ,
          HCFABox32FacilityID ,
          CLIANumber ,
          RevenueCode ,
          VendorImportID ,
          VendorID ,
          NPI ,
          TimeZoneID ,
          PayToName ,
          PayToAddressLine1 ,
          PayToAddressLine2 ,
          PayToCity ,
          PayToState ,
          PayToCountry ,
          PayToZipCode ,
          PayToPhone ,
          PayToPhoneExt ,
          PayToFax ,
          PayToFaxExt ,
          EIN 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.servicelocationname , -- Name - varchar(128)
          i.servicelocationaddress1 , -- AddressLine1 - varchar(256)
          i.servicelocationaddress2 , -- AddressLine2 - varchar(256)
          i.servicelocationcity , -- City - varchar(128)
          i.servicelocationstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.servicelocationzip)) IN (4,8) THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.servicelocationzip),9) 
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.servicelocationzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.servicelocationzip)
		  ELSE '' END , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ISNULL(pos.PlaceOfServiceCode,11) , -- PlaceOfServiceCode - char(2)
          i.locationbillingname , -- BillingName - varchar(128)
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- FaxPhone - varchar(10)
          '' , -- FaxPhoneExt - varchar(10)
          '' , -- HCFABox32FacilityID - varchar(50)
          '' , -- CLIANumber - varchar(30)
          '' , -- RevenueCode - varchar(4)
          @VendorImportID , -- VendorImportID - int
          i.servicelocationid , -- VendorID - int
          i.npi , -- NPI - varchar(10)
          15 , -- TimeZoneID - int
          i.locationbillingname , -- PayToName - varchar(60)
          i.mailingaddress1 , -- PayToAddressLine1 - varchar(256)
          i.mailingaddress2 , -- PayToAddressLine2 - varchar(256)
          i.mailingcity , -- PayToCity - varchar(128)
          i.mailingstate , -- PayToState - varchar(2)
          '' , -- PayToCountry - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.mailingzipcode)) IN (4,8) THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.mailingzipcode),9) 
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.mailingzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.mailingzipcode)
		  ELSE '' END , -- PayToZipCode - varchar(9)
          '' , -- PayToPhone - varchar(10)
          '' , -- PayToPhoneExt - varchar(10)
          '' , -- PayToFax - varchar(10)
          '' , -- PayToFaxExt - varchar(10)
          ''  -- EIN - varchar(9)
FROM dbo._import_3_1_PrimeSuiteCareProviderLocati i
LEFT JOIN dbo.PlaceOfService pos ON 
	i.posdesc = pos.[Description]
LEFT JOIN dbo.ServiceLocation sl ON 
	i.servicelocationname = sl.Name AND
	sl.PracticeID = @PracticeID
WHERE i.servicelocationid <> '' AND sl.ServiceLocationID IS NULL AND i.servicelocationname NOT LIKE '%USE%'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Service Location Records Created...'

--ROLLBACK
--COMMIT

