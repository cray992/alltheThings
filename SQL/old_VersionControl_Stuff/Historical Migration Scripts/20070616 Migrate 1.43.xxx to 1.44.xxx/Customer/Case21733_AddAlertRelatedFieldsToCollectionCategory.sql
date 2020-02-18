--------------------------------------------------------------------------------
-- Case 21733 - Add field to hold the ShowAlert bit and the AlertMessage text
--------------------------------------------------------------------------------
ALTER TABLE dbo.CollectionCategory ADD
	[ShowAlert] bit NOT NULL CONSTRAINT DF_CollectionCategory_ShowAlert DEFAULT 0,
	[AlertMessage] varchar(max) NULL 

