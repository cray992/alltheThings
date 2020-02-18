IF(SELECT COUNT(*) FROM dbo.SharedSystemPropertiesAndValues WHERE PropertyName = 'UseHtml5Dashboard') = 0
BEGIN

	INSERT INTO SharedSystemPropertiesAndValues
	(PropertyName, Value, PropertyDescription)
	VALUES
	(
		'UseHtml5Dashboard',
		'True', 
		'When enabled, allows the dashboard to be shown using the html 5 control)'
	)

END