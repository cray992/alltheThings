/*Add column midlevel provider in TaxonomySpecialty table in shared*/

ALTER TABLE dbo.TaxonomySpecialty 
ADD MidlevelProvider BIT NOT NULL 
CONSTRAINT DF_TaxonomySpecialty_Midlevel
DEFAULT(0) WITH VALUES
GO

UPDATE dbo.TaxonomySpecialty
SET MidlevelProvider = 1
WHERE TaxonomyTypeCode = '36'
GO
