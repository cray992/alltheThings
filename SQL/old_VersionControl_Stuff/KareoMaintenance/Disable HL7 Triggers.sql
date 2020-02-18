IF NOT EXISTS(SELECT * FROM dbo.CustomerProperties WHERE [Key] = 'DisableHL7Triggers')
BEGIN
	INSERT INTO dbo.CustomerProperties ([Key], [Value])
	VALUES  ('DisableHL7Triggers', -- Key - varchar(50)
	         '1'  -- Value - varchar(max)
	         )
END
ELSE
BEGIN
	UPDATE dbo.CustomerProperties
	SET VALUE = '1'
	WHERE [Key] = 'DisableHL7Triggers'
END

