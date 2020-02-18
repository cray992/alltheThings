----MH_docs_NPI_Taxonomy_data_grab


SELECT COUNT(DISTINCT ad.DoctorGuid)
  FROM [DataCollection].[dbo].[AllDocs2] ad
JOIN superbill_shared.dbo.Customer c ON c.customerid = ad.CustomerID
  WHERE ad.ActiveDoctor = 1 AND c.DBActive = 1 AND c.CustomerType = 'n' and c.CancellationDate IS NULL AND ad.NPI IS NOT NULL
;
----

DECLARE @Sql VARCHAR(MAX)
SET @SQL='
INSERT INTO SHAREDSERVER.DataCollection.dbo.AllDocs2
(
    CustomerID,
    PracticeID,
    Prefix,
    FirstName,
    MiddleName,
    LastName,
    Suffix,
    SSN,
    AddressLine1,
    AddressLine2,
    City,
    State,
    Country,
    ZipCode,
    HomePhone,
    HomePhoneExt,
    WorkPhone,
    WorkPhoneExt,
    PagerPhone,
    PagerPhoneExt,
    MobilePhone,
    MobilePhoneExt,
    DOB,
    EmailAddress,
    Notes,
    ActiveDoctor,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    UserID,
    Degree,
    DefaultEncounterTemplateID,
    TaxonomyCode,
    DepartmentID,
    VendorID,
    VendorImportID,
    FaxNumber,
    FaxNumberExt,
    OrigReferringPhysicianID,
    [External],
    NPI,
    ProviderTypeID,
    ProviderPerformanceReportActive,
    ProviderPerformanceScope,
    ProviderPerformanceFrequency,
    ProviderPerformanceDelay,
    ProviderPerformanceCarbonCopyEmailRecipients,
    ExternalBillingID,
    GlobalPayToAddressFlag,
    GlobalPayToName,
    GlobalPayToAddressLine1,
    GlobalPayToAddressLine2,
    GlobalPayToCity,
    GlobalPayToState,
    GlobalPayToZipCode,
    GlobalPayToCountry,
    DoctorGuid,
    CreatedFromEhr,
    ActivateAfterWizard,
    KareoSpecialtyId
)
SELECT 
			  dbo.fn_GetCustomerID()AS CustomerID,
              PracticeID,
              Prefix,
              FirstName,
              MiddleName,
              LastName,
              Suffix,
              SSN,
              AddressLine1,
              AddressLine2,
              City,
              State,
              Country,
              ZipCode,
              HomePhone,
              HomePhoneExt,
              WorkPhone,
              WorkPhoneExt,
              PagerPhone,
              PagerPhoneExt,
              MobilePhone,
              MobilePhoneExt,
              DOB,
              EmailAddress,
              Notes,
              ActiveDoctor,
              CreatedDate,
              CreatedUserID,
              ModifiedDate,
              ModifiedUserID,
              UserID,
              Degree,
              DefaultEncounterTemplateID,
              TaxonomyCode,
              DepartmentID,
              VendorID,
              VendorImportID,
              FaxNumber,
              FaxNumberExt,
              OrigReferringPhysicianID,
              [External],
              NPI,
              ProviderTypeID,
              ProviderPerformanceReportActive,
              ProviderPerformanceScope,
              ProviderPerformanceFrequency,
              ProviderPerformanceDelay,
              ProviderPerformanceCarbonCopyEmailRecipients,
              ExternalBillingID,
              GlobalPayToAddressFlag,
              GlobalPayToName,
              GlobalPayToAddressLine1,
              GlobalPayToAddressLine2,
              GlobalPayToCity,
              GlobalPayToState,
              GlobalPayToZipCode,
              GlobalPayToCountry,
              DoctorGuid,
              CreatedFromEhr,
              ActivateAfterWizard,
              KareoSpecialtyId 
FROM dbo.Doctor WITH (NOLOCK)
'
DECLARE @CurrentDB INT, --Current RowNum we're working on in the #DBInfo table
@DBCount INT, --Total count of rows in the #DBInfo table
@DBName	VARCHAR(50)
CREATE TABLE #DBInfo
(
RowNum INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
[DatabaseID] INT NOT NULL,
DBName VARCHAR(128) NOT NULL,
)
;
INSERT INTO #DBInfo
SELECT
distinct	
d.Database_ID,
--DatabaseServerName ,
customer.DatabaseName
FROM SHAREDSERVER.superbill_shared.dbo.customer AS customer WITH(NOLOCK) 
INNER JOIN sys.databases d ON customer.DatabaseName=d.name
INNER JOIN (SELECT customerid FROM SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription WITH (NOLOCK) WHERE ProductId=6 AND DeactivationDate IS NULL) bill ON customer.CustomerID=bill.customerid
WHERE CustomerType='N'
ORDER BY customer.DatabaseName
;
--===== Preset the variables
SELECT @DBCount = MAX(RowNum),
@CurrentDB = 1
FROM #DBInfo
;
DECLARE @SqlCommand VARCHAR(MAX)
WHILE @CurrentDB <= @DBCount
BEGIN
SELECT @DBName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB); 
PRINT @DBName
PRINT @CurrentDB
SET @SqlCommand='USE ['+@DBName+ ']; EXEC  ('''+@SQL+''');'
EXEC(@SQLCommand);
--SELECT @SqlCommand
--===== Get ready to read the next file row
SELECT @CurrentDB = @CurrentDB + 1
;
END
DROP TABLE #DBInfo