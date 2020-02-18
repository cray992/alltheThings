IF EXISTS( select * from sys.triggers where name = 'tr_Customer_TrialSecurity' )
BEGIN 
DROP TRIGGER dbo.tr_Customer_TrialSecurity
END
go

DISABLE TRIGGER tr_Customer_Update_CustomerSettingsLog_Insert ON Customer
GO
DISABLE TRIGGER tr_Customer_Update_Delete ON Customer

GO


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.COLUMN_NAME='SortOrder' AND c.TABLE_NAME='EditionType')
BEGIN 
ALTER TABLE EditionType
ADD SortOrder INT NOT NULL DEFAULT(0)
END

GO
UPDATE EditionType
SET SortOrder= CASE WHEN EditionTypeID=1 then 3
					WHEN EditionTypeID=2 THEN 2
					WHEN EditionTypeID=3 THEN 1
					WHEN EditionTypeID=5 THEN 0
					WHEN EditiontypeiD=7 THEN 4
					WHEN EditionTypeID=8 THEN 10
					WHEN EditionTypeID=9 THEN 11
					WHEN EditionTypeID=10 THEN 12
					WHEN EditionTypeID=11 THEN 13
					WHEN EditionTypeId=12 THEN 14
					WHEN EditionTypeId=13 THEN 15
					ELSE 0 END

GO

IF NOT EXISTS(SELECT EditionTypeID FROM EditionType WHERE EditionType.EditionTypeID =12)
BEGIN
INSERT EditionType
	(	EditionTypeCaption
		,Active
		,SortOrder
		,EditionRank
		)
VALUES	('Open',1, 14,199
		)
END		

IF NOT EXISTS(SELECT EditionTypeID FROM EditionType WHERE EditionType.EditionTypeID =13)
BEGIN
		
INSERT EditionType
		(EditionTypeCaption
		,Active
		,SortOrder
		,EditionRank
		)
VALUES	(
		'Suite'
		,1
		,15
		,299
		)
		
END

GO

IF EXISTS(SELECT * FROM sys.foreign_keys AS fk 
			INNER JOIN sysobjects AS s ON fk.parent_object_id=s.id
			WHERE fk.name='FK_EditionSetEditionType_EditionSetID' AND s.name='EditionSetEditionType')
			
ALTER TABLE EditionSetEditionType
DROP CONSTRAINT FK_EditionSetEditionType_EditionSetID
GO

IF EXISTS(SELECT * FROM sys.foreign_keys AS fk 
			INNER JOIN sysobjects AS s ON fk.parent_object_id=s.id
			WHERE fk.name='FK_Customer_EditionSetID' AND s.name='Customer')
			
			ALTER TABLE Customer
			DROP CONSTRAINT FK_Customer_EditionSetID

GO
IF EXISTS(SELECT * FROM sys.foreign_keys AS fk 
			INNER JOIN sysobjects AS s ON fk.parent_object_id=s.id
			WHERE fk.name='FK_Partner_EditionSetID' AND s.name='Partner')
			ALTER TABLE Partner
			DROP CONSTRAINT FK_Partner_EditionSetID

GO

IF EXISTS(SELECT * FROM sys.tables AS t WHERE name='EditionSet')
BEGIN
DROP TABLE EditionSet
END
GO


BEGIN 
CREATE TABLE [dbo].EditionSet
(
	[EditionSetID] [int] IDENTITY(1,1) NOT NULL CONSTRAINT PK_EditionSet PRIMARY KEY CLUSTERED (EditionSetID),
	[Description] [varchar](128) NULL,
	[CreatedDate] datetime CONSTRAINT DF_EditionSet_CreatedDate default(GETDATE()),
	[DefaultEditionTypeID] INT NOT NULL CONSTRAINT FK_EditionSet_DefaultEditionTypeID FOREIGN KEY (DefaultEditionTypeID) REFERENCES EditionType(EditionTypeId),
)
ON [PRIMARY]

END

GO

IF NOT EXISTS(SELECT * FROM EditionSet WHERE Description='Kareo Original')
BEGIN 
INSERT INTO EditionSet(Description, [DefaultEditionTypeID])
VALUES('Kareo Original', 1)
END

IF NOT EXISTS(SELECT * FROM EditionSet WHERE Description='Quest')
BEGIN 
INSERT INTO EditionSet(Description, [DefaultEditionTypeID])
VALUES('Quest', 8)
END


IF NOT EXISTS(SELECT * FROM EditionSet WHERE Description='Kareo Partners')--Suite ANd Open
BEGIN 
INSERT INTO EditionSet(Description, [DefaultEditionTypeID])
VALUES('Kareo Partners', 12)
END


IF NOT EXISTS(SELECT * FROM EditionSet WHERE Description='Kareo')--Just Suite
BEGIN 
INSERT INTO EditionSet(Description, [DefaultEditionTypeID])
VALUES('Kareo', 13)
END
GO

IF NOT EXISTS(SELECT * FROM EditionSet WHERE Description='Trial')--Trial Customers
BEGIN 
INSERT INTO EditionSet(Description, [DefaultEditionTypeID])
VALUES('Trial', 5)
END
GO


IF EXISTS(SELECT * FROM sys.objects  WHERE name='EditionSetEditionType' AND type='u')
DROP TABLE EditionSetEditionType
go

CREATE TABLE EditionSetEditionType
	(EditionSetEditionTypeID int NOT NULL IDENTITY (1, 1),
	EditionSetID int NOT NULL,
	EditionTypeID int NOT NULL	
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.EditionSetEditionType ADD CONSTRAINT
	PK_EditionSetEditionType PRIMARY KEY CLUSTERED 
	(
	EditionSetID,
	EditionTypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.EditionSetEditionType ADD CONSTRAINT FK_EditionSetEditionType_EditionSetID FOREIGN KEY (EditionSetID) REFERENCES EditionSet(EditionSetID)
GO 
ALTER TABLE dbo.EditionSetEditionType ADD CONSTRAINT FK_EditionSetEditionType_EditionTypeID FOREIGN KEY  (EditionTypeID) REFERENCES EditionType(EditiontypeID)
GO

IF EXISTS(SELECT * FROM EditionSetEditionType)
TRUNCATE TABLE EditionSetEditionType
GO
INSERT INTO EditionSetEditionType(EditionSetID, EditionTypeID)
SELECT 1,EditiontypeID
FROM EditionType
WHERE EditionTypeId IN (1,2,3,7)


GO
INSERT INTO EditionSetEditionType(EditionSetID, EditionTypeID)
SELECT 2,EditiontypeID
FROM EditionType
WHERE EditionTypeId BETWEEN 8 AND 11
GO

IF NOT EXISTS(SELECT EditionSetID FROM EditionSetEditionType WHERE EditionSetID=5)
BEGIN
INSERT INTO EditionSetEditionType(EditionSetID, EditionTypeID)
SELECT 5, EditionTypeId
FROM EditionType AS et
WHERE EditionTypeID=5
END
GO

IF NOT EXISTS(SELECT EditionSetID FROM EditionSetEditionType WHERE EditionSetID=3)

INSERT INTO EditionSetEditionType(EditionSetID, EditionTypeID)
SELECT 3, EditionTypeId
FROM EditionType AS et
WHERE EditionTypeCaption IN ('Open', 'Suite')

GO
IF NOT EXISTS(SELECT EditionSetID FROM EditionSetEditionType WHERE EditionSetID=4)

INSERT INTO EditionSetEditionType(EditionSetID, EditionTypeID)
SELECT 4, EditionTypeId
FROM EditionType AS et
WHERE EditionTypeCaption IN ('Suite')



GO

UPDATE EditionType
SET Active=1
WHERE editionTypeID NOT IN (4,6,10)
GO

UPDATE EditionType
SET Active=0
WHERE editionTypeID  IN (4,6,10)
GO


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.COLUMN_NAME='EditionSetID' AND c.TABLE_NAME='Customer')
BEGIN
ALTER TABLE Customer
ADD EditionSetID INT NOT NULL DEFAULT(4) 

ALTER TABLE Customer ADD CONSTRAINT FK_Customer_EditionSetID FOREIGN KEY (EditionSetID) REFERENCES EditionSet(EditionSetID)
END
		
GO

IF NOT EXISTS(SELECT TOP 1 * FROM dbo.Customer AS C WHERE EditionSetID = 1)
BEGIN
	UPDATE Customer
	SET EditionSetID=1
	WHERE PartnerID<>2 AND customerType<>'T' AND CustomerType <> 'D'
END

UPDATE Customer
SET EditionSetID=5
WHERE  customerType='T' OR CustomerType = 'D'


UPDATE Customer
SET EditionSetID=2
WHERE PartnerID=2


IF NOT EXISTS(SELECT * FROM EditionTypeSoftwareFeature AS etsf WHERE etsf.EditionTypeID IN (12,13))
BEGIN
	INSERT INTO EditionTypeSoftwareFeature
			(EditionTypeID
			,SoftwareFeatureID
			,SoftwareFeatureUsageID
			)

	SELECT 12,etsf.SoftwareFeatureID, etsf.SoftwareFeatureUsageID
	FROM EditionTypeSoftwareFeature AS etsf
	WHERE etsf.EditionTypeID=7
	UNION ALL
	SELECT 13,etsf.SoftwareFeatureID, etsf.SoftwareFeatureUsageID
	FROM EditionTypeSoftwareFeature AS etsf
	WHERE etsf.EditionTypeID=7		
END

IF NOT EXISTS (SELECT * FROM dbo.Partner AS P WHERE PartnerID = 10 )
BEGIN

INSERT INTO dbo.Partner
        ( Name ,
          ModifiedDate ,
          PartnerTypeID
        )
VALUES  ( 'BackChart' , -- Name - varchar(100)
          GETDATE(), -- ModifiedDate - datetime
          1 -- PartnerTypeID - int
        )
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS AS c WHERE c.COLUMN_NAME='EditionSetID' AND c.TABLE_NAME='Partner')
BEGIN
	ALTER TABLE dbo.Partner
	ADD EditionSetID INT NULL 
	CONSTRAINT FK_Partner_EditionSetID FOREIGN KEY (EditionSetID) REFERENCES EditionSet(EditionSetID)
END
go

	UPDATE dbo.Partner
	SET EditionSetID = 2
	WHERE PartnerID = 2 AND EditionSetID IS NULL
	
	UPDATE dbo.Partner
	SET EditionSetID = 3
	WHERE PartnerID IN (3, 4, 5, 6, 7, 8, 10 )
	AND EditionSetID IS NULL
	
	UPDATE dbo.Partner
	SET EditionSetID = 4
	WHERE EditionSetID IS NULL
	
	ALTER TABLE dbo.Partner
	ALTER COLUMN EditionSetID INT NOT NULL

go

Enable TRIGGER tr_Customer_Update_CustomerSettingsLog_Insert ON Customer
Go
Enable TRIGGER tr_Customer_Update_Delete ON Customer