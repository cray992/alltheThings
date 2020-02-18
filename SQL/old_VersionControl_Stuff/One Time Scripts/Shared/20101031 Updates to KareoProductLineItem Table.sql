IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KareoProductLineItem_DefaultDateType' AND Type='U')
	DROP TABLE KareoProductLineItem_DefaultDateType
	
GO

CREATE TABLE KareoProductLineItem_DefaultDateType(DefaultDateTypeID INT NOT NULL, DefaultDateTypeName VARCHAR(50) NOT NULL)
INSERT INTO KareoProductLineItem_DefaultDateType
VALUES(1,'Period')
INSERT INTO KareoProductLineItem_DefaultDateType
VALUES(2,'Period Forward')

GO

IF NOT EXISTS(SELECT sc.name FROM sys.objects so INNER JOIN sys.columns sc 
							 ON so.object_id=sc.object_id
							 WHERE so.name='KareoProductLineItem' AND so.type='U' and sc.name='DefaultDateTypeID')
BEGIN
	ALTER TABLE KareoProductLineItem ADD DefaultDateTypeID INT NULL
END

GO

--Set all to default to invoicing period
UPDATE KP
	SET DefaultDateTypeID=1
FROM KareoProductLineItem KP

--update specific product lines to take period forward setting
UPDATE KP
	SET DefaultDateTypeID=2
FROM KareoProductLineItem KP
WHERE KareoProductLineItemID IN (1,2,3,36,37,38,39,40,41,42,43,44)

GO

ALTER TABLE KareoProductLineItem ALTER COLUMN DefaultDateTypeID INT NOT NULL

GO

ALTER TABLE KareoProductLineItem ADD Internal BIT NOT NULL CONSTRAINT DF_KareoProductLineItem_Internal DEFAULT 0 WITH VALUES

GO

ALTER TABLE KareoProductLineItem ADD CONSTRAINT UX_KareoProductLineItem UNIQUE (KareoProductLineItemName)