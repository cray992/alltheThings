
IF NOT EXISTS(SELECT * FROM sys.tables AS t WHERE name='EditionSet')
BEGIN 
CREATE TABLE [dbo].EditionSet(
	[EditionSetID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](128) NULL,
	[CreateDate] datetime default(GETDATE()))
 ON [PRIMARY]

ALTER TABLE EditionSet ADD CONSTRAINT PK_EditionSet  PRIMARY KEY (EditionSetID)
END

GO


IF NOT EXISTS(SELECT * FROM EditionSet WHERE Description='Kareo Original')
BEGIN 
INSERT INTO EditionSet(Description)
VALUES('Kareo Original')
END

IF NOT EXISTS(SELECT * FROM EditionSet WHERE Description='Quest')
BEGIN 
INSERT INTO EditionSet(Description)
VALUES('Quest')
END


IF NOT EXISTS(SELECT * FROM EditionSet WHERE Description='Kareo Partners')--Suite ANd Open
BEGIN 
INSERT INTO EditionSet(Description)
VALUES('Kareo Partners')
END


IF NOT EXISTS(SELECT * FROM EditionSet WHERE Description='Kareo')--Just Suite
BEGIN 
INSERT INTO EditionSet(Description)
VALUES('Kareo')
END
GO
IF EXISTS(SELECT * FROM sys.objects  WHERE name='EditionSetEditionType' AND type='u')
DROP TABLE EditionSetEditionType
go

CREATE TABLE EditionSetEditionType
	(
	EditionSetID int NOT NULL,
	EditionTypeID int NOT NULL,
	EditionSetEditionTypeID int NOT NULL IDENTITY (1, 1)
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.EditionSetEditionType ADD CONSTRAINT
	PK_EditionSetEditionType PRIMARY KEY CLUSTERED 
	(
	EditionSetID,
	EditionTypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.EditionSetEditionType ADD CONSTRAINT FK_EditionSetID FOREIGN KEY (EditionSetID) REFERENCES EditionSet(EditionSetID)
GO 
ALTER TABLE dbo.EditionSetEditionType ADD CONSTRAINT FK_EditionTypeID FOREIGN KEY  (EditionTypeID) REFERENCES EditionType(EditiontypeID)
GO

IF EXISTS(SELECT * FROM EditionSetEditionType)
TRUNCATE TABLE EditionSetEditionType
GO
INSERT INTO EditionSetEditionType(EditionSetID, EditionTypeID)
SELECT 1,EditiontypeID
FROM EditionType
WHERE EditionTypeId BETWEEN 1 AND 7


GO
INSERT INTO EditionSetEditionType(EditionSetID, EditionTypeID)
SELECT 2,EditiontypeID
FROM EditionType
WHERE EditionTypeId BETWEEN 8 AND 11

IF NOT EXISTS(SELECT EditionTypeID FROM EditionType WHERE EditionType.EditionTypeID =12)
BEGIN
INSERT EditionType
	(	EditionTypeID
		,EditionTypeName
		,SortOrder
		,Active
		
		)
VALUES	(12,'Open',14,  0
		)
END		

IF NOT EXISTS(SELECT EditionTypeID FROM EditionType WHERE EditionType.EditionTypeID =13)
BEGIN
		
INSERT EditionType
		(EditionTypeID
		,EditionTypeName
		,SortOrder
		,Active
		
		)
VALUES	(13,
		'Suite'
		,15
		,0
		
		)
		
END

GO

IF NOT EXISTS(SELECT EditionSetID FROM EditionSetEditionType WHERE EditionSetID=3)

INSERT INTO EditionSetEditionType(EditionSetID, EditionTypeID)
SELECT 3, EditionTypeId
FROM EditionType AS et
WHERE EditionTypeName IN ('Open', 'Suite')

GO
IF NOT EXISTS(SELECT EditionSetID FROM EditionSetEditionType WHERE EditionSetID=4)

INSERT INTO EditionSetEditionType(EditionSetID, EditionTypeID)
SELECT 4, EditionTypeId
FROM EditionType AS et
WHERE EditionTypeName IN ('Suite')



