--DECLARE @VendorImportID INT
--
--INSERT INTO VendorImport(VendorName, DateCreated, Notes, VendorFormat)
--VALUES('Copy 0001DB to 0277DB',GETDATE(),'Case 11142','KAREO')
--
--SET @VendorImportID=@@IDENTITY	
--
--INSERT into superbill_0277_prod.dbo.InsuranceCompany  
--( VendorImportID, VendorID, CreatedPracticeID, ReviewCode, InsuranceCompanyName, Notes, 
--AddressLine1, AddressLine2, City, State, Country, ZipCode, ContactPrefix, ContactFirstName, 
--ContactMiddleName, ContactLastName, ContactSuffix, Phone, PhoneExt, Fax, FaxExt, 
--BillSecondaryInsurance, EClaimsAccepts, BillingFormID, InsuranceProgramCode, 
--HCFADiagnosisReferenceFormatCode, HCFASameAsInsuredFormatCode, LocalUseFieldTypeCode, 
--ProviderNumberTypeID, GroupNumberTypeID, LocalUseProviderNumberTypeID, CompanyTextID, 
--ClearinghousePayerID, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, 
--KareoInsuranceCompanyID, KareoLastModifiedDate,  
--SecondaryPrecedenceBillingFormID, ReferringProviderNumberTypeID )     
--SELECT @VendorImportID, InsuranceCompanyID, NULL, 'R', InsuranceCompanyName, Notes, AddressLine1, 
--AddressLine2, City, State, Country, ZipCode, ContactPrefix, ContactFirstName, ContactMiddleName, 
--ContactLastName, ContactSuffix, Phone, PhoneExt, Fax, FaxExt, BillSecondaryInsurance, 
--EClaimsAccepts, BillingFormID, InsuranceProgramCode, HCFADiagnosisReferenceFormatCode, 
--HCFASameAsInsuredFormatCode, LocalUseFieldTypeCode, ProviderNumberTypeID, GroupNumberTypeID, 
--LocalUseProviderNumberTypeID, CompanyTextID, ClearinghousePayerID, CreatedDate, CreatedUserID, 
--ModifiedDate, ModifiedUserID, KareoInsuranceCompanyID, KareoLastModifiedDate, 
--SecondaryPrecedenceBillingFormID, ReferringProviderNumberTypeID     
--FROM superbill_0001_prod.dbo.InsuranceCompany      
--WHERE State IN ('NJ','PA','DE')          
--
--INSERT into superbill_0277_prod.dbo.InsuranceCompanyPlan ( InsuranceCompanyID, VendorImportID, 
--VendorID, ReviewCode, PlanName, AddressLine1, AddressLine2, City, State, Country, ZipCode, 
--ContactPrefix, ContactFirstName, ContactMiddleName, ContactLastName, ContactSuffix, Phone, 
--PhoneExt, Notes, Fax, FaxExt, Copay, Deductible )     
--SELECT NIC.InsuranceCompanyID, @VendorImportID, ICP.InsuranceCompanyPlanID, 'R', ICP.PlanName, ICP.AddressLine1, 
--ICP.AddressLine2, ICP.City, ICP.State, ICP.Country, ICP.ZipCode, ICP.ContactPrefix, ICP.ContactFirstName, 
--ICP.ContactMiddleName, ICP.ContactLastName, ICP.ContactSuffix, ICP.Phone, ICP.PhoneExt, ICP.Notes, 
--ICP.Fax, ICP.FaxExt, ICP.Copay, ICP.Deductible     
--FROM superbill_0001_prod.dbo.InsuranceCompany IC INNER JOIN 
--superbill_0001_prod.dbo.InsuranceCompanyPlan ICP     
--ON IC.InsuranceCompanyID=ICP.InsuranceCompanyID     
--INNER JOIN superbill_0277_prod.dbo.InsuranceCompany NIC     
--ON IC.InsuranceCompanyID=NIC.VendorID AND NIC.VendorImportID=@VendorImportID      
--WHERE IC.State IN ('NJ','PA','DE') AND ICP.State IN ('NJ','PA','DE')
