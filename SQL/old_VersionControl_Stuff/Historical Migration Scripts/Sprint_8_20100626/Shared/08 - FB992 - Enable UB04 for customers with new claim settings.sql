-- FB 992 enable UB04 for new claim settings customers
UPDATE Customer SET InstitutionalBillingEnabled = 1 WHERE ClaimSettingEdition = 2