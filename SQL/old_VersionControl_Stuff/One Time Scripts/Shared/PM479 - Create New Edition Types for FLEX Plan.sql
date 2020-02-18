/*  Insert new EditionSets for Flex Plan */

IF (SELECT COUNT(*) FROM dbo.EditionSet WHERE Description = 'Kareo Flex') = 0
BEGIN

	INSERT INTO dbo.EditionSet
			( Description ,
			  CreatedDate ,
			  DefaultEditionTypeID
			)
	VALUES  ( 'Kareo Flex' , -- Description - varchar(128)
			  '2013-04-17 00:00:44' , -- CreatedDate - datetime
			  14  -- DefaultEditionTypeID - int
			)

END

IF (SELECT COUNT(*) FROM dbo.EditionSet WHERE Description = 'Partner Flex') = 0
BEGIN

	INSERT INTO dbo.EditionSet
			( Description ,
			  CreatedDate ,
			  DefaultEditionTypeID
			)
	VALUES  ( 'Partner Flex' , -- Description - varchar(128)
			  '2013-04-17 00:00:44' , -- CreatedDate - datetime
			  14  -- DefaultEditionTypeID - int
			)
END