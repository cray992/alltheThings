USE superbill_63463_PK
GO

SET XACT_ABORT ON

--BEGIN TRANSACTION

--commit 

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 6
SET @SourcePracticeID = 6
SET @VendorImportID = 2

SET NOCOUNT ON

  
PRINT ''
PRINT 'Inserting Into ServiceLocation...'


INSERT INTO dbo.ServiceLocation
(
    PracticeID,
    Name,
    AddressLine1,
    AddressLine2,
    City,
    State,
    Country,
    ZipCode,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    PlaceOfServiceCode,
    BillingName,
    Phone,
    PhoneExt,
    FaxPhone,
    FaxPhoneExt,
    HCFABox32FacilityID,
    CLIANumber,
    RevenueCode,
    VendorImportID,
    VendorID,
    NPI,
    --FacilityIDType,
    --TimeZoneID,
    PayToName,
    PayToAddressLine1,
    PayToAddressLine2,
    PayToCity,
    PayToState,
    PayToCountry,
    PayToZipCode,
    PayToPhone,
    PayToPhoneExt,
    PayToFax,
    PayToFaxExt,
    EIN
    --BillTypeID
    
)
SELECT 
    @TargetPracticeID,         -- PracticeID - int
    servicelocationname,        -- Name - varchar(128)
    address1,        -- AddressLine1 - varchar(256)
    address2,        -- AddressLine2 - varchar(256)
    city,        -- City - varchar(128)
    state,        -- State - varchar(2)
    '',        -- Country - varchar(32)
    zip,        -- ZipCode - varchar(9)
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    '',        -- PlaceOfServiceCode - char(2)
    i.servicelocationname,        -- BillingName - varchar(128)
    phone,        -- Phone - varchar(10)
    NULL,        -- PhoneExt - varchar(10)
    '',        -- FaxPhone - varchar(10)
    '',        -- FaxPhoneExt - varchar(10)
    '',        -- HCFABox32FacilityID - varchar(50)
    '',        -- CLIANumber - varchar(30)
    '',        -- RevenueCode - varchar(4)
    @VendorImportID,         -- VendorImportID - int
    i.AutoTempID,         -- VendorID - int
    i.npi,        -- NPI - varchar(10)
    --0,         -- FacilityIDType - int
    --0,         -- TimeZoneID - int
    null,        -- PayToName - varchar(60)
    null,        -- PayToAddressLine1 - varchar(256)
    null,        -- PayToAddressLine2 - varchar(256)
    null,        -- PayToCity - varchar(128)
    null,        -- PayToState - varchar(2)
    null,        -- PayToCountry - varchar(32)
    null,        -- PayToZipCode - varchar(9)
    null,        -- PayToPhone - varchar(10)
    null,        -- PayToPhoneExt - varchar(10)
    null,        -- PayToFax - varchar(10)
    null,        -- PayToFaxExt - varchar(10)
    null        -- EIN - varchar(9)
    --0         -- BillTypeID - int
    
    
FROM dbo._import_2_6_ServiceLocations i

WHERE --i.PracticeID = @SourcePracticeID  AND
NOT EXISTS (SELECT * FROM dbo.ServiceLocation d WHERE d.AddressLine1 = i.address1 AND d.PracticeID = @TargetPracticeID)

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--SELECT * FROM dbo.ServiceLocation
--SELECT * FROM dbo._import_2_6_ServiceLocations

--DELETE FROM dbo.ServiceLocation WHERE PracticeID=6







       
--SELECT DISTINCT
--		  sl.ServiceLocationID, -- id - int
--		Osl.AddressLine1 ,
--          osl.Name  -- NAME - varchar(128)
--FROM dbo.ServiceLocation sl 
--INNER JOIN dbo._import_1_1_ServiceLocation osl ON
--	osl.Name = sl.Name AND
--    osl.AddressLine1 = sl.AddressLine1 AND
--	OSl.PracticeID = @SourcePracticeID
--WHERE sl.PracticeID = @TargetPracticeID