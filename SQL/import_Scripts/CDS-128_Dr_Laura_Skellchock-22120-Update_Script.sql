USE superbill_22120_dev
--USE superbill_22120_prod
GO


UPDATE dbo.Patient
SET HomePhone = imp.homephone ,
	MobilePhone = imp.cellphone ,
	EmailAddress = imp.email
FROM dbo.[_import_5_1_SkellchockPatients] AS imp, dbo.Patient AS pat
WHERE pat.VendorImportID = 4 AND pat.FirstName = imp.firstname AND pat.LastName = imp.lastname AND pat.AddressLine1 = imp.address1 AND pat.City = imp.city