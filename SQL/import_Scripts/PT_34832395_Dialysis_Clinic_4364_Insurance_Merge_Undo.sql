USE superbill_4364_dev
--USE superbill_4364_prod
GO


SET XACT_ABORT ON

BEGIN TRAN


-- SET IDENTITY_INSERT to ON.
SET IDENTITY_INSERT dbo.InsuranceCompany ON

INSERT INTO dbo.InsuranceCompany ( 
	InsuranceCompanyID,
	InsuranceCompanyName ,
	Notes ,
	AddressLine1 ,
	AddressLine2 ,
	City ,
	State ,
	Country ,
	ZipCode ,
	ContactPrefix ,
	ContactFirstName ,
	ContactMiddleName ,
	ContactLastName ,
	ContactSuffix ,
	Phone ,
	PhoneExt ,
	Fax ,
	FaxExt ,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	InsuranceProgramCode ,
	HCFADiagnosisReferenceFormatCode ,
	HCFASameAsInsuredFormatCode ,
	LocalUseFieldTypeCode ,
	ReviewCode ,
	ProviderNumberTypeID ,
	GroupNumberTypeID ,
	LocalUseProviderNumberTypeID ,
	CompanyTextID ,
	ClearinghousePayerID ,
	CreatedPracticeID ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	KareoInsuranceCompanyID ,
	KareoLastModifiedDate ,
	SecondaryPrecedenceBillingFormID ,
	VendorID ,
	VendorImportID ,
	DefaultAdjustmentCode ,
	ReferringProviderNumberTypeID ,
	NDCFormat ,
	UseFacilityID ,
	AnesthesiaType ,
	InstitutionalBillingFormID
)
SELECT 
	InsuranceCompanyID,
	InsuranceCompanyName ,
	Notes ,
	AddressLine1 ,
	AddressLine2 ,
	City ,
	State ,
	Country ,
	ZipCode ,
	ContactPrefix ,
	ContactFirstName ,
	ContactMiddleName ,
	ContactLastName ,
	ContactSuffix ,
	Phone ,
	PhoneExt ,
	Fax ,
	FaxExt ,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	InsuranceProgramCode ,
	HCFADiagnosisReferenceFormatCode ,
	HCFASameAsInsuredFormatCode ,
	LocalUseFieldTypeCode ,
	ReviewCode ,
	ProviderNumberTypeID ,
	GroupNumberTypeID ,
	LocalUseProviderNumberTypeID ,
	CompanyTextID ,
	ClearinghousePayerID ,
	CreatedPracticeID ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	KareoInsuranceCompanyID ,
	KareoLastModifiedDate ,
	SecondaryPrecedenceBillingFormID ,
	VendorID ,
	VendorImportID ,
	DefaultAdjustmentCode ,
	ReferringProviderNumberTypeID ,
	NDCFormat ,
	UseFacilityID ,
	AnesthesiaType ,
	InstitutionalBillingFormID
FROM 
	dbo.InsuranceCompanyOld 
WHERE InsuranceCompanyID NOT IN (SELECT InsurancecompanyID FROM dbo.InsuranceCompany)

-- SET IDENTITY_INSERT to OFF.
SET IDENTITY_INSERT dbo.InsuranceCompany OFF



-- SET IDENTITY_INSERT to ON.
SET IDENTITY_INSERT dbo.InsuranceCompanyPlan ON

INSERT INTO dbo.InsuranceCompanyPlan (
	InsuranceCompanyPlanID,
	PlanName ,
	AddressLine1 ,
	AddressLine2 ,
	City ,
	State ,
	Country ,
	ZipCode ,
	ContactPrefix ,
	ContactFirstName ,
	ContactMiddleName ,
	ContactLastName ,
	ContactSuffix ,
	Phone ,
	PhoneExt ,
	Notes ,
	MM_CompanyID ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	ReviewCode ,
	CreatedPracticeID ,
	Fax ,
	FaxExt ,
	KareoInsuranceCompanyPlanID ,
	KareoLastModifiedDate ,
	InsuranceCompanyID ,
	ADS_CompanyID ,
	Copay ,
	Deductible ,
	VendorID ,
	VendorImportID
)
SELECT 
	InsuranceCompanyPlanID,
	PlanName ,
	AddressLine1 ,
	AddressLine2 ,
	City ,
	State ,
	Country ,
	ZipCode ,
	ContactPrefix ,
	ContactFirstName ,
	ContactMiddleName ,
	ContactLastName ,
	ContactSuffix ,
	Phone ,
	PhoneExt ,
	Notes ,
	MM_CompanyID ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	ReviewCode ,
	CreatedPracticeID ,
	Fax ,
	FaxExt ,
	KareoInsuranceCompanyPlanID ,
	KareoLastModifiedDate ,
	InsuranceCompanyID ,
	ADS_CompanyID ,
	Copay ,
	Deductible ,
	VendorID ,
	VendorImportID
FROM 
	dbo.InsuranceCompanyPlanOld 
WHERE InsuranceCompanyPlanID NOT IN (SELECT InsurancecompanyPlanID FROM dbo.InsuranceCompanyPlan)

-- SET IDENTITY_INSERT to OFF.
SET IDENTITY_INSERT dbo.InsuranceCompanyPlan OFF


COMMIT TRAN