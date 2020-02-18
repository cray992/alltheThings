EXEC sp_rename @objname = 'EditionType.EditionTypeID',  @newname = 'EditionTypeIDOld', @objtype = 'COLUMN'
GO

ALTER TABLE EditionType
	ADD EditionTypeID int
GO

ALTER TABLE EditionType 
	DROP CONSTRAINT PK_SubscriptionType
GO

UPDATE EditionType SET EditionTypeID = EditionTypeIDOld
GO

ALTER TABLE EditionType
	DROP COLUMN EditionTypeIDOld

ALTER TABLE EditionType
	ALTER COLUMN EditionTypeID int NOT NULL
GO

ALTER TABLE EditionType
	ADD CONSTRAINT [PK_EditionType] PRIMARY KEY CLUSTERED 
	(
		[EditionTypeID] ASC
	)
GO

--first, reset all blank edition references to something valid

IF (db_name() = 'CustomerModelPrepopulated')
BEGIN
	IF NOT EXISTS(SELECT EditionTypeID FROM EditionType WHERE EditionTypeName = 'Trial')
	BEGIN
		INSERT INTO EditionType (EditionTypeID, EditionTypeName, Active, SortOrder) VALUES (5,'Trial',1,0)
	END

	UPDATE Practice
	SET EditionTypeID = 5
END
ELSE
BEGIN
	UPDATE Practice
	SET EditionTypeID = 1
	WHERE EditionTypeID IS NULL
END

--the edition has to be set to something valid
ALTER TABLE Practice
	ALTER COLUMN EditionTypeID int NOT NULL
GO

--now let's enforce referential integrity, too
ALTER TABLE Practice
	ADD CONSTRAINT FK_Practice_EditionType FOREIGN KEY (EditionTypeID) REFERENCES EditionType (EditionTypeID)
GO
