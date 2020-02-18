IF NOT EXISTS (SELECT * FROM dbo.CustomerProperties WHERE [Key]='PracticeFusionLinkFullyDisabled')
BEGIN
	INSERT INTO dbo.CustomerProperties
		([Key], Value)
	VALUES	('PracticeFusionLinkFullyDisabled', -- Key - varchar(50)
		 'true'  -- Value - varchar(max)
		 )
END
ELSE
	UPDATE dbo.CustomerProperties
	SET Value='true'
	WHERE [Key]='PracticeFusionLinkFullyDisabled'
END