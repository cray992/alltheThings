-- Get Edition Type
DECLARE @EditionTypeID INT
SELECT @EditionTypeID=(SELECT EditionTypeID FROM dbo.EditionType AS ET WHERE EditionTypeCaption='Flex Plan')

-- Get Edition Type for Suite (for new mapping to eset of kareo only flex)
DECLARE @EditionTypeSuite INT
SELECT @EditionTypeSuite = (SELECT EditionTypeID FROM dbo.EditionType WHERE EditionTypeCaption='Suite')

-- Get Edition Type for Open (for new mapping to eset of kareo partner flex)
DECLARE @EditionTypeOpen INT
SELECT @EditionTypeOpen = (SELECT EditionTypeID FROM dbo.EditionType WHERE EditionTypeCaption='Open')

-- Get EditionSetID for Kareo Flex
DECLARE @ESET_Kareo INT
SELECT @ESET_Kareo = (SELECT EditionSetID FROM dbo.EditionSet WHERE Description = 'Kareo Flex')

-- Get EditionSetID for Partner Flex
DECLARE @ESET_Partner INT
SELECT @ESET_Partner = (SELECT EditionSetID FROM dbo.EditionSet WHERE Description = 'Partner Flex')


IF NOT EXISTS(SELECT * FROM dbo.EditionSetEditionType AS ESET WHERE EditionTypeID =@EditionTypeID)
BEGIN 

	INSERT INTO dbo.EditionSetEditionType
			( EditionSetID ,
			  EditionTypeID
			)
	VALUES  ( @ESET_Kareo, -- EditionSetID - int
	 @EditionTypeID-- EditionTypeID - int
			)

	INSERT INTO dbo.EditionSetEditionType
			( EditionSetID ,
			  EditionTypeID
			)
	VALUES  ( @ESET_Partner, -- EditionSetID - int
	 @EditionTypeID-- EditionTypeID - int
			)

	INSERT INTO dbo.EditionSetEditionType
			( EditionSetID ,
			  EditionTypeID
			)
	VALUES  ( @ESET_Partner, -- EditionSetID - int
	 @EditionTypeSuite -- EditionTypeID - int
			)
			
	INSERT INTO dbo.EditionSetEditionType
			( EditionSetID ,
			  EditionTypeID
			)
	VALUES  ( @ESET_Kareo, -- EditionSetID - int
	 @EditionTypeSuite-- EditionTypeID - int
	 )

	INSERT INTO dbo.EditionSetEditionType
			( EditionSetID ,
			  EditionTypeID
			)
	VALUES  ( @ESET_Partner, -- EditionSetID - int
	 @EditionTypeOpen -- EditionTypeID - int
			)

END
