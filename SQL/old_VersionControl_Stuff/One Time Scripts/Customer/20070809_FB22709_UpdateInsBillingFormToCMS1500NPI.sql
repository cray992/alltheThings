    
/*-----------------------------------------------------------------------------
Case 22709 - [SF11882] Set insurance primary & secondary billing forms to 
CMS 1500 Form - Version 08/05 with NPI for customer 681  
-----------------------------------------------------------------------------*/

IF (DB_NAME() LIKE 'superbill_0681_%')
BEGIN
	/* Set primary billing form to CMS-1500 Standard (with NPI Numbers) */
	UPDATE InsuranceCompany SET
		BillingFormID = 13
	WHERE InsuranceCompanyID IN ( 
		SELECT IC.InsuranceCompanyID FROM InsuranceCompany IC WHERE IC.BillingFormID <> 13 ) 

	/* Set secondary billing form to CMS-1500 Standard (with NPI Numbers) */
	UPDATE InsuranceCompany SET
		SecondaryPrecedenceBillingFormID = 13
	WHERE InsuranceCompanyID IN ( 
		SELECT IC.InsuranceCompanyID FROM InsuranceCompany IC WHERE IC.SecondaryPrecedenceBillingFormID <> 13 )
END