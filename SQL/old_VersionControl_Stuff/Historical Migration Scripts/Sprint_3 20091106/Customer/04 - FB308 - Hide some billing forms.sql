-- this script looks for the billing forms other than Mass M5, Mass M7, Version 08/05 (with NPI Numbers), Version 08/05 (Medi-Cal with NPI Numbers) 
-- that assigned to ins companies and re-assign them to default form - HCFA with NPI 

update InsuranceCompany set BillingFormID=13 where BillingFormID not in (13, 16)
update InsuranceCompany set SecondaryPrecedenceBillingFormID=13 where SecondaryPrecedenceBillingFormID not in (13, 16)