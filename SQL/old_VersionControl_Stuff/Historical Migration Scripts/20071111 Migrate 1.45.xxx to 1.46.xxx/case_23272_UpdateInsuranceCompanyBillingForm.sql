/*-----------------------------------------------------------------------------
FB Case 23272 / SF case 41586 - Switch insurance company billing form to 
Standard (with NPI Numbers)
-----------------------------------------------------------------------------*/

/* Set primary billing form to CMS-1500 Standard (with NPI Numbers) */
UPDATE InsuranceCompany SET
	BillingFormID = 13
WHERE BillingFormID = 1

/* Set secondary billing form to CMS-1500 Standard (with NPI Numbers) */
UPDATE InsuranceCompany SET
	SecondaryPrecedenceBillingFormID = 13
WHERE SecondaryPrecedenceBillingFormID = 1
