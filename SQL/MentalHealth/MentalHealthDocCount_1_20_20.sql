----MentalHealthDocCount


CREATE TABLE MHDocCount (CustomerID INT, LastName VARCHAR(255), FirstName VARCHAR(255), ProviderTypeName VARCHAR(255), PracticeName VARCHAR(255), TaxonomySpecialtyName VARCHAR(255), Active BIT)
------ ------

DECLARE @Sql VARCHAR(MAX)
SET @SQL='
INSERT INTO SHAREDSERVER.DataCollection.dbo.MHDocCount
(
    CustomerID,
    LastName,
    FirstName,
    ProviderTypeName,
    PracticeName,
    TaxonomySpecialtyName,
	Active
)
SELECT DISTINCT dbo.fn_GetCustomerID()AS CustomerID, d.LastName, d.FirstName, pt.ProviderTypeName, pr.Name AS PracticeName, ts.TaxonomySpecialtyName, d.ActiveDoctor
FROM dbo.Doctor d 
	JOIN dbo.TaxonomyCode tc ON tc.TaxonomyCode = d.TaxonomyCode
	JOIN dbo.TaxonomySpecialty ts ON ts.TaxonomySpecialtyCode = tc.TaxonomySpecialtyCode
	JOIN dbo.Practice pr ON pr.PracticeID = d.PracticeID
	JOIN dbo.ProviderType pt ON pt.ProviderTypeID = d.ProviderTypeID
	JOIN SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription ps ON ps.ProviderGuid = d.DoctorGuid
WHERE tc.TaxonomySpecialtyCode IN (
''''17'''',''''3g'''',''''3k'''',''''6e'''',''''6s'''',''''1s'''',''''1y'''',''''03'''',''''3'''',''''5C'''',''''6h'''',''''2l'''',''''3g'''',''''3t'''',''''7g'''',''''84'''',''''8A'''',''''3r'''',''''3q'''',''''3p'''',''''41''''
)
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
