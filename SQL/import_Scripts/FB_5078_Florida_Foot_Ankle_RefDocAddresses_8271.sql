USE superbill_8271_dev
--USE superbill_8271_prod
GO


UPDATE dbo.Doctor
SET
	Doctor.AddressLine1 = impDoc.Street1,
	Doctor.AddressLine2 = impDoc.Street2,
	Doctor.City = impDoc.City,
	Doctor.State = LEFT(impDoc.STATE, 2),
	Doctor.ZipCode = LEFT(REPLACE(impDoc.Zipcode + impDoc.[Zip Plus4], '-', ''), 9),
	Doctor.Country = 'USA'
FROM dbo.[_importRefDocAddresses] impDoc
WHERE
	(Doctor.AddressLine1 IS NULL OR Doctor.AddressLine1 = '') AND
	[External] = 1 AND
	Doctor.NPI = impDoc.Npi AND
	Doctor.FirstName = impDoc.Fname AND
	Doctor.LastName = impDoc.Lname
	

