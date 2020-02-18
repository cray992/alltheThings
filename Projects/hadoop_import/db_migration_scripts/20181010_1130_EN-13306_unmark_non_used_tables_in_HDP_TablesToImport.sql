USE ReportingLog

UPDATE HDP_TablesToImport set ImportTypeId=0
WHERE TableName in (
'AppointmentToResource',
'ClaimResponseStatus',
'ClaimTransactionType',
'Department',
'EncounterHealthCode',
'EncounterHistory',
'HealthCode',
'ICD9ToICD10Crosswalk',
'MedicareFeeScheduleRVU',
'MedicareFeeScheduleRVUBatch',
'PatientCaseDate',
'PayerScenarioType',
'PaymentType',
'ProductDomain_Product',
'ProductDomain_ProductPromoCodes',
'RefundStatusCode',
'Signup_AccountDiscount',
'Signup_AccountDiscountType',
'Signup_Attribution',
'Signup_Order',
'Signup_ProviderLicense',
'Signup_ProviderLicenseProduct',
'TaxonomyType',
'TypeOfService',
'Other',
'PayerTypeCode'
)