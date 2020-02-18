USE superbill_63463_dev
GO

SET NOCOUNT ON 

BEGIN TRAN 
SELECT * FROM dbo.TaxonomyCode
SELECT * FROM dbo.TaxonomySpecialty
SELECT * FROM dbo.TaxonomyType
SELECT * FROM dbo.[Taxonomy_2018#csv$]

--rollback
--commit
-------------
PRINT''
PRINT'Inserting into Taxonomy Type...' 
INSERT INTO dbo.TaxonomyType
(
    TaxonomyTypeCode,
    TaxonomyTypeName,
    TaxonomyTypeDesc
)
SELECT DISTINCT 
    '', -- TaxonomyTypeCode - varchar(4)-------------------------- Where do I get this field?????
    it.Grouping, -- TaxonomyTypeName - varchar(256)
    ''  -- TaxonomyTypeDesc - text

FROM dbo.[Taxonomy_2018#csv$] it 
LEFT JOIN dbo.TaxonomyType tt ON tt.TaxonomyTypeName=it.Grouping
WHERE tt.TaxonomyTypeName IS NULL 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'Inserting into Taxonomy Specialty...'    
INSERT INTO dbo.TaxonomySpecialty
(
    TaxonomySpecialtyCode,
    TaxonomyTypeCode,
    TaxonomySpecialtyName,
    TaxonomySpecialtyDesc,
    MidlevelProvider
)
SELECT DISTINCT 
    it.code ,  -- TaxonomySpecialtyCode - varchar(4)
    tt.TaxonomyTypeCode,  -- TaxonomyTypeCode - varchar(4)
    it.Specialization,  -- TaxonomySpecialtyName - varchar(256)
    it.Definition,  -- TaxonomySpecialtyDesc - text
    NULL -- MidlevelProvider - bit
 
FROM dbo.[Taxonomy_2018#csv$] it
INNER JOIN dbo.TaxonomyType tt ON tt.TaxonomyTypeName=it.Grouping
LEFT JOIN dbo.TaxonomySpecialty ts ON ts.TaxonomySpecialtyName=it.Classification
WHERE ts.TaxonomySpecialtyName IS NULL 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'Inserting into Taxonomy Code...'  
INSERT INTO dbo.TaxonomyCode
(
    TaxonomyCode,
    TaxonomyTypeCode,
    TaxonomySpecialtyCode,
    TaxonomyCodeClassification,
    TaxonomyCodeDesc
)
SELECT DISTINCT 
    it.Code, -- TaxonomyCode - char(10)
    tt.TaxonomyTypeCode, -- TaxonomyTypeCode - varchar(4)
    tc.TaxonomySpecialtyCode, -- TaxonomySpecialtyCode - varchar(4)
    it.Classification, -- TaxonomyCodeClassification - varchar(256)
    it.Definition  -- TaxonomyCodeDesc - text
     

FROM dbo.[Taxonomy_2018#csv$] it
INNER JOIN dbo.TaxonomyType tt ON tt.TaxonomyTypeName=it.Grouping
INNER JOIN dbo.TaxonomySpecialty ts ON ts.TaxonomySpecialtyName=it.Classification
LEFT JOIN dbo.TaxonomyCode tc ON tc.TaxonomyCode=it.Code
WHERE tc.TaxonomyCode IS NULL AND it.Code IS NOT NULL 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--------------

--SELECT * FROM dbo.[Taxonomy_2018#csv$] it 
--LEFT JOIN dbo.TaxonomyType tt ON tt.TaxonomyTypeName=it.Grouping
--WHERE tt.TaxonomyTypeName IS NULL 

--SELECT * FROM dbo.TaxonomyType
--Respiratory, Developmental, Rehabilitative and Restorative Service Providers