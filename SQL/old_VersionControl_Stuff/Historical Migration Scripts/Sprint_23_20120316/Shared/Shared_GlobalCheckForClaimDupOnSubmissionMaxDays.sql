IF(SELECT COUNT(*) FROM dbo.SharedSystemPropertiesAndValues WHERE PropertyName = 'CheckForDuplicatesOnClaimSubmissionMaxDays') = 0
BEGIN

	INSERT INTO SharedSystemPropertiesAndValues
	(PropertyName, Value, PropertyDescription)
	VALUES
	(
		'CheckForDuplicatesOnClaimSubmissionMaxDays', 
		'2', 
		'Number of days to determine if claim submission is a possible duplicate (ie: if status is BLL and user resubmits claim within alloted days)'
	)

END