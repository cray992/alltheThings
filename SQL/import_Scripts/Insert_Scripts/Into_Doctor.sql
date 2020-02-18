USE superbill_63463_PK
GO

SET XACT_ABORT ON

--BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 6
SET @SourcePracticeID = 6
SET @VendorImportID = 2

SET NOCOUNT ON

PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          SSN ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          HomePhone ,
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          PagerPhone ,
          PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          DOB ,
          EmailAddress ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          TaxonomyCode ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
          [External] ,
          NPI ,
          ProviderTypeID ,
          ProviderPerformanceReportActive ,
          ProviderPerformanceScope ,
          ProviderPerformanceFrequency ,
          ProviderPerformanceDelay ,
          ProviderPerformanceCarbonCopyEmailRecipients ,
          ExternalBillingID ,
          GlobalPayToAddressFlag ,
          GlobalPayToName ,
          GlobalPayToAddressLine1 ,
          GlobalPayToAddressLine2 ,
          GlobalPayToCity ,
          GlobalPayToState ,
          GlobalPayToZipCode ,
          GlobalPayToCountry ,
          KareoSpecialtyId
        )
SELECT 
		  @TargetPracticeID , -- PracticeID - int
          i.prefix , -- Prefix - varchar(16)
          i.firstname , -- FirstName - varchar(64)
          i.middleinitial , -- MiddleName - varchar(64)
          i.LastName , -- LastName - varchar(64)
          i.Suffix , -- Suffix - varchar(16)
          i.SSN , -- SSN - varchar(9)
          i.Address1 , -- AddressLine1 - varchar(256)
          i.Address2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.State , -- State - varchar(2)
          NULL, --i.Country  -- Country - varchar(32)
          i.zip , -- ZipCode - varchar(9)
          i.HomePhone , -- HomePhone - varchar(10)
          NULL, --i.HomePhoneExt  -- HomePhoneExt - varchar(10)
          i.WorkPhone , -- WorkPhone - varchar(10)
          NULL, --i.WorkPhoneExt  -- WorkPhoneExt - varchar(10)
          NULL, --i.PagerPhone  -- PagerPhone - varchar(10)
          NULL, --i.PagerPhoneExt  -- PagerPhoneExt - varchar(10)
          i.cellphone , -- MobilePhone - varchar(10)
          NULL, --i.MobilePhoneExt  -- MobilePhoneExt - varchar(10)
          i.dateofbirth , -- DOB - datetime
          i.Email , -- EmailAddress - varchar(256)
          NULL, --i.Notes , -- Notes - text
          1, -- i.ActiveDoctor  -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL, --i.Degree  -- Degree - varchar(8)
          NULL, --i.TaxonomyCode  -- TaxonomyCode - char(10)
          i.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          i.Fax , -- FaxNumber - varchar(10)
          i.FaxExt , -- FaxNumberExt - varchar(10)
          0, --i.[External]  -- External - bit
          i.NPI , -- NPI - varchar(10)
          NULL, --i.ProviderTypeID  -- ProviderTypeID - int
          NULL, --i.ProviderPerformanceReportActive  -- ProviderPerformanceReportActive - bit
          NULL, --i.ProviderPerformanceScope  -- ProviderPerformanceScope - int
          NULL, --i.ProviderPerformanceFrequency  -- ProviderPerformanceFrequency - char(1)
          NULL, --i.ProviderPerformanceDelay  -- ProviderPerformanceDelay - int
          NULL, --i.ProviderPerformanceCarbonCopyEmailRecipients , -- ProviderPerformanceCarbonCopyEmailRecipients - varchar(max)
          NULL, --i.ExternalBillingID , -- ExternalBillingID - varchar(50)
          NULL, --i.GlobalPayToAddressFlag , -- GlobalPayToAddressFlag - bit
          NULL, --i.GlobalPayToName , -- GlobalPayToName - varchar(128)
          NULL, --i.GlobalPayToAddressLine1 , -- GlobalPayToAddressLine1 - varchar(256)
          NULL, --i.GlobalPayToAddressLine2 , -- GlobalPayToAddressLine2 - varchar(256)
          NULL, --i.GlobalPayToCity , -- GlobalPayToCity - varchar(128)
          NULL, --i.GlobalPayToState , -- GlobalPayToState - varchar(2)
          NULL, --i.GlobalPayToZipCode , -- GlobalPayToZipCode - varchar(9)
          NULL, --i.GlobalPayToCountry , -- GlobalPayToCountry - varchar(32)
          NULL --i.KareoSpecialtyId  -- KareoSpecialtyId - int
--FROM dbo._import_2_6_ReferringDoctors i WHERE i.npi NOT IN(SELECT npi FROM dbo.Doctor) 

FROM dbo._import_2_6_ReferringDoctors i WHERE --i.PracticeID = @SourcePracticeID  AND
NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE d.VendorID = i.AutoTempID AND d.PracticeID = @TargetPracticeID)
AND i.lastname<>''

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DELETE FROM dbo.Doctor  WHERE LastName =''

--SELECT *FROM dbo.Doctor

--UPDATE dbo.Doctor SET doctor.[External] = 1
--WHERE doctor.[External] IS NULL