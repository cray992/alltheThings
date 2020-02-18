/* Updates PatientStatementsVendor ... */
UPDATE PatientStatementsVendor SET
	VendorName = 'PSC Info Group (Recommended)'
WHERE
	PatientStatementsVendorID = 3
GO

UPDATE PatientStatementsVendor SET
	VendorName = 'Bridgestone (Requires Special Enrollment)'
WHERE
	PatientStatementsVendorID = 4
GO

ALTER TABLE dbo.PatientStatementsVendor ADD
	SupportsSingleLogin bit NULL,
	SortOrder int NULL
GO

UPDATE PatientStatementsVendor SET
	SupportsSingleLogin = 0
GO

UPDATE PatientStatementsVendor SET
	SupportsSingleLogin = 1
WHERE PatientStatementsVendorId = 3
GO	

UPDATE PatientStatementsVendor SET
	SortOrder = 0
WHERE PatientStatementsVendorId = 3
GO	

UPDATE PatientStatementsVendor SET
	SortOrder = 5
WHERE PatientStatementsVendorId = 4
GO	

/* Updates PatientStatementsFormat ... */
ALTER TABLE dbo.PatientStatementsFormat ADD
	SupportsOfficeHours bit NULL,
	SupportsCreditCards bit NULL,
	SupportsReturnAddress bit NULL,
	SupportsRemitAddress bit NULL,
	SortOrder int NULL
GO

/* Adds a new patient statement format ... */
INSERT PatientStatementsFormat (
	FormatName, 
	FormatExternalName, 
	LinesPerPage,
	PatientStatementsVendorId, 
	GoodForPrinting, 
	GoodForElectronic, 
	StoredProcedureName, 
	TransformXsltFileName, 
	Notes,
	SupportsOfficeHours,
	SupportsCreditCards,
	SupportsReturnAddress,
	SupportsRemitAddress,
	SortOrder )
VALUES (
	'Kareo Standard (Recommended)', 
	'KN', 
	38, 
	3, 
	0, 
	1, 
	'BillDataProvider_GetStatementBatchXML', 
	'PSC_XML_reformatter_1.xsl', 
	'XML format used to pass data to PSC',
	1,
	1,
	1,
	1,
	0 )
GO

UPDATE dbo.PatientStatementsFormat SET
	FormatName = 'Kareo Legacy (Requires Special Enrollment)',
	GoodForElectronic = 0,
	Notes = 'Simple format used to save text files',
	SortOrder = 5
WHERE
	PatientStatementsFormatID = 3
GO

UPDATE PatientStatementsFormat SET
	SupportsOfficeHours = 0,
	SupportsCreditCards = 0,
	SupportsReturnAddress = 0,
	SupportsRemitAddress = 0
WHERE
	FormatName <> 'Kareo Standard (Recommended)'
GO
