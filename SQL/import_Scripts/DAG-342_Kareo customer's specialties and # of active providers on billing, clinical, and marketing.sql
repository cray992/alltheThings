USE superbill_shared
GO
SELECT * FROM dbo.Doctor d WHERE d.ActiveDoctor= 1 

SELECT * FROM dbo.Encounter WHERE PracticeID = 6



SELECT --cp.*
cp.CustomerID,l.CompanyTypeCaption,cp.PracticeID,COUNT(DISTINCT cp.KareoProviderID)AS provider_count 
FROM dbo.BillingInvoicing_CustomerProviders cp
	INNER JOIN dbo.Customer c ON 
		c.CustomerID = cp.CustomerID
	INNER JOIN dbo.CompanyType l ON 
		l.CompanyTypeID = c.CompanyTypeID
	INNER JOIN dbo.TypeOfService t ON 
		t.TypeOfServiceCode = c.CustomerType
WHERE Audit_ActiveDoctor = 1 AND cp.CustomerID = 63463
GROUP BY l.CompanyTypeCaption,cp.CustomerID,cp.PracticeID


SELECT * FROM 

SELECT * FROM dbo.Customer WHERE CustomerID = 63463

SELECT * FROM 
SELECT * FROM dbo.KareoSpecialty

SELECT * FROM 
SELECT * FROM dbo.TaxonomySpecialty


SELECT * FROM dbo.CompanyType

SELECT * FROM dbo.Customer c WHERE CustomerID = 63463
SELECT * FROM dbo.ServiceTypeCode
