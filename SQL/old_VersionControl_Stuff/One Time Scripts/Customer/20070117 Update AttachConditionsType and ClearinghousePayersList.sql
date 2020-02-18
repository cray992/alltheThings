
UPDATE AttachConditionsType SET AttachConditionsTypeID=1, AttachConditionsTypeName='Paper And Electronic Claims And Eligibility'
WHERE AttachConditionsTypeName='Paper And Electronic Claims'

UPDATE AttachConditionsType SET AttachConditionsTypeID=4, AttachConditionsTypeName='Eligibility Checks Only'
WHERE AttachConditionsTypeName='Eligibility Checks Only Additional'

UPDATE ClearinghousePayersList SET SupportsPatientEligibilityRequests=1
WHERE B2BPayerID IS NOT NULL
