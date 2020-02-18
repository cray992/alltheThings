IF(SELECT COUNT(*) FROM dbo.SharedSystemPropertiesAndValues WHERE PropertyName = 'CheckForDuplicatesOnClaimSubmission') = 0
BEGIN
	INSERT INTO SharedSystemPropertiesAndValues
	(PropertyName, Value, PropertyDescription)
	VALUES
	(
		'CheckForDuplicatesOnClaimSubmission', 
		'True', 
		'When enabled, sending claims will check if any of the given claims will be denied due to possible duplication.  If so, the user is prompted and has the option to remove those from the submission'
	)
END