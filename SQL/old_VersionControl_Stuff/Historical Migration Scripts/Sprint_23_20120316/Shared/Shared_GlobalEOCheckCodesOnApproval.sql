IF(SELECT COUNT(*) FROM dbo.SharedSystemPropertiesAndValues WHERE PropertyName = 'GlobalEOCheckCodesOnApproval') = 0
BEGIN

	INSERT INTO SharedSystemPropertiesAndValues
	(PropertyName, Value, PropertyDescription)
	VALUES
	(
		'GlobalEOCheckCodesOnApproval', 
		'False', 
		'When enabled, saving an Encounter automatically performs check-codes (unless turned off in EncounterOptions at practice level)'
	)

END