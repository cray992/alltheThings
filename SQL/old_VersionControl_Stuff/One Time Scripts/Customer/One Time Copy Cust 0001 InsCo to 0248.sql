
INSERT INTO InsuranceCompany(InsuranceCompanyName,Notes,AddressLine1,AddressLine2,City,State,Country,
ZipCode,ContactPrefix,ContactFirstName,ContactMiddleName,ContactLastName,ContactSuffix,Phone,PhoneExt,
Fax,FaxExt,BillSecondaryInsurance,EClaimsAccepts,BillingFormID,InsuranceProgramCode,HCFADiagnosisReferenceFormatCode,
HCFASameAsInsuredFormatCode,LocalUseFieldTypeCode,ReviewCode,ProviderNumberTypeID,GroupNumberTypeID,
LocalUseProviderNumberTypeID,CompanyTextID,ClearinghousePayerID,SecondaryPrecedenceBillingFormID,
DefaultAdjustmentCode,VendorImportID,VendorID,CreatedPracticeID)
SELECT InsuranceCompanyName,Notes,AddressLine1,AddressLine2,City,State,Country,
ZipCode,ContactPrefix,ContactFirstName,ContactMiddleName,ContactLastName,ContactSuffix,Phone,PhoneExt,
Fax,FaxExt,BillSecondaryInsurance,EClaimsAccepts,BillingFormID,InsuranceProgramCode,HCFADiagnosisReferenceFormatCode,
HCFASameAsInsuredFormatCode,LocalUseFieldTypeCode,'R',ProviderNumberTypeID,GroupNumberTypeID,
LocalUseProviderNumberTypeID,CompanyTextID,ClearinghousePayerID,SecondaryPrecedenceBillingFormID,
DefaultAdjustmentCode,3,InsuranceCompanyID,2
FROM [01IC_Copy]

INSERT INTO InsuranceCompanyPlan(PlanName,Notes,AddressLine1,AddressLine2,City,State,Country,
ZipCode,ContactPrefix,ContactFirstName,ContactMiddleName,ContactLastName,ContactSuffix,Phone,PhoneExt,
Fax,FaxExt,ReviewCode,InsuranceCompanyID,Copay,Deductible,VendorImportID,VendorID,CreatedPracticeID)
SELECT t.PlanName,t.Notes,t.AddressLine1,t.AddressLine2,t.City,t.State,t.Country,
t.ZipCode,t.ContactPrefix,t.ContactFirstName,t.ContactMiddleName,t.ContactLastName,t.ContactSuffix,t.Phone,t.PhoneExt,
t.Fax,t.FaxExt,'R',IC.InsuranceCompanyID,t.Copay,t.Deductible,3,t.InsuranceCompanyPlanID,2
FROM InsuranceCompany IC INNER JOIN [01ICP_Copy] t
ON IC.VendorImportID=3 AND IC.VendorID=t.InsuranceCompanyID




