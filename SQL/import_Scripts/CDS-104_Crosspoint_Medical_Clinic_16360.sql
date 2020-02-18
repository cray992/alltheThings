UPDATE dbo.InsuranceCompany
	SET NDCFormat = 1 ,
		UseFacilityID = 1 ,
		AnesthesiaType = 'U' ,
		InstitutionalBillingFormID = 18 ,
		SecondaryPrecedenceBillingFormID = 13
	WHERE CreatedPracticeID = 1 AND VendorImportID = 2