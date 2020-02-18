/* Import for Taxonomy Codes into the following tables:
1) TaxonomyType
2) TaxonomySpecialty
3) TaxonomyCode

MUST SET SYNOMYM TO NAME OF TABLE BEING IMPORTED
*/

USE Superbill_Shared

IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'Taxonomy_Import')
DROP SYNONYM [dbo].[Taxonomy_Import]
GO
Create Synonym Taxonomy_Import For Taxonomy_Import9  --<<<<< CHANGE THIS <<<-----
Go
--==========================================================================

-- DO NOT USE UPDATE BELOW <--<<<
-- Update records in dbo.TaxonomyType
-- WE do NOT update Taxonomy Codes because the new data does not contain values for General Categories = TaxonomyTypeName
--UPDATE TaxonomyType
--SET    TaxonomyTypeName = LEFT(Taxonomy_Import.Category, 256),
--       TaxonomyTypeDesc = Taxonomy_Import.TaxonomyCodeDesc
--FROM   (SELECT   MIN(Taxonomy_Import9_1.TaxonomyCode) AS MinTaxCode,
--                 LEFT(Taxonomy_Import9_1.TaxonomyCode,2) AS TaxTypeCode
--        FROM     Taxonomy_Import AS Taxonomy_Import9_1
--                 INNER JOIN TaxonomyType AS TaxonomyType_1
--                   ON LEFT(Taxonomy_Import9_1.TaxonomyCode,2) = TaxonomyType_1.TaxonomyTypeCode
--        GROUP BY LEFT(Taxonomy_Import9_1.TaxonomyCode,2)) AS derivedtbl_1
--       INNER JOIN Taxonomy_Import
--         ON derivedtbl_1.MinTaxCode = Taxonomy_Import.TaxonomyCode
--       INNER JOIN TaxonomyType
--         ON derivedtbl_1.TaxTypeCode = TaxonomyType.TaxonomyTypeCode

-- Insert records into dbo.TaxonomyType
INSERT INTO TaxonomyType
           (TaxonomyTypeCode,
            TaxonomyTypeName,
            TaxonomyTypeDesc)
SELECT LEFT(Taxonomy_Import.TaxonomyCode,2) AS TaxonomyTypeCode,
       Taxonomy_Import.Category,
       Taxonomy_Import.TaxonomyCodeDesc
FROM   (SELECT   MIN(Taxonomy_Import9_1.TaxonomyCode) AS MinTaxCode,
                 LEFT(Taxonomy_Import9_1.TaxonomyCode,2) AS TaxTypeCode
        FROM     Taxonomy_Import AS Taxonomy_Import9_1
                 LEFT OUTER JOIN TaxonomyType AS TaxonomyType_1
                   ON LEFT(Taxonomy_Import9_1.TaxonomyCode,2) = TaxonomyType_1.TaxonomyTypeCode
        WHERE    (TaxonomyType_1.TaxonomyTypeCode IS NULL )
        GROUP BY LEFT(Taxonomy_Import9_1.TaxonomyCode,2)) AS derivedtbl_1
       INNER JOIN Taxonomy_Import
         ON derivedtbl_1.MinTaxCode = Taxonomy_Import.TaxonomyCode

-- Update records in TaxonomySpecialty
UPDATE TaxonomySpecialty
SET    TaxonomySpecialtyName = Taxonomy_Import.Title,
       TaxonomySpecialtyDesc = Taxonomy_Import.TaxonomyCodeDesc
FROM   Taxonomy_Import
       INNER JOIN (SELECT   MIN(Taxonomy_Import9_1.TaxonomyCode) AS MinTaxCode,
                            SUBSTRING(Taxonomy_Import9_1.TaxonomyCode,3,2) AS TaxSpecCode,
                            LEFT(Taxonomy_Import9_1.TaxonomyCode,2) AS TaxTypeCode,
                            Taxonomy_Import9_1.Title
                   FROM     Taxonomy_Import AS Taxonomy_Import9_1
                            INNER JOIN TaxonomySpecialty AS TaxonomySpecialty_1
                              ON SUBSTRING(Taxonomy_Import9_1.TaxonomyCode,3,2) = TaxonomySpecialty_1.TaxonomySpecialtyCode
                                 AND LEFT(Taxonomy_Import9_1.TaxonomyCode,2) = TaxonomySpecialty_1.TaxonomyTypeCode
                   GROUP BY SUBSTRING(Taxonomy_Import9_1.TaxonomyCode,3,2),
                            LEFT(Taxonomy_Import9_1.TaxonomyCode,2),Taxonomy_Import9_1.Title) AS derivedtbl_1
         ON Taxonomy_Import.TaxonomyCode = derivedtbl_1.MinTaxCode
       INNER JOIN TaxonomySpecialty
         ON derivedtbl_1.TaxSpecCode = TaxonomySpecialty.TaxonomySpecialtyCode
            AND derivedtbl_1.TaxTypeCode = TaxonomySpecialty.TaxonomyTypeCode

--Add records to TaxonomySpecialty
INSERT INTO TaxonomySpecialty
           (TaxonomySpecialtyCode,
            TaxonomyTypeCode,
            TaxonomySpecialtyName,
            TaxonomySpecialtyDesc)
SELECT   SUBSTRING(Taxonomy_Import.TaxonomyCode,3,2) AS TaxSpecCode,
         LEFT(Taxonomy_Import.TaxonomyCode,2) AS TaxTypeCode,
         Taxonomy_Import.Title,
         Taxonomy_Import.TaxonomyCodeDesc
FROM     Taxonomy_Import
         INNER JOIN (SELECT   MIN(Taxonomy_Import9_1.TaxonomyCode) AS MinTaxCode,
                              SUBSTRING(Taxonomy_Import9_1.TaxonomyCode,3,2) AS TaxSpecCode,
                              LEFT(Taxonomy_Import9_1.TaxonomyCode,2) AS TaxTypeCode,
                              Taxonomy_Import9_1.Title
                     FROM     Taxonomy_Import AS Taxonomy_Import9_1
                              LEFT OUTER JOIN TaxonomySpecialty AS TaxonomySpecialty_1
                                ON SUBSTRING(Taxonomy_Import9_1.TaxonomyCode,3,2) = TaxonomySpecialty_1.TaxonomySpecialtyCode
                                   AND LEFT(Taxonomy_Import9_1.TaxonomyCode,2) = TaxonomySpecialty_1.TaxonomyTypeCode
                     WHERE    (TaxonomySpecialty_1.TaxonomySpecialtyCode IS NULL )
                     GROUP BY SUBSTRING(Taxonomy_Import9_1.TaxonomyCode,3,2),
                              LEFT(Taxonomy_Import9_1.TaxonomyCode,2),Taxonomy_Import9_1.Title) AS derivedtbl_1
           ON Taxonomy_Import.TaxonomyCode = derivedtbl_1.MinTaxCode
GROUP BY SUBSTRING(Taxonomy_Import.TaxonomyCode,3,2),
         LEFT(Taxonomy_Import.TaxonomyCode,2),Taxonomy_Import.Title,
         Taxonomy_Import.TaxonomyCodeDesc


-- Update records in TaxonomyCode
UPDATE TaxonomyCode
SET    TaxonomyCodeDesc = Taxonomy_Import.TaxonomyCodeDesc,
       TaxonomyCodeClassification = Taxonomy_Import.TaxonomyCodeClassification
FROM   Taxonomy_Import
       INNER JOIN TaxonomyCode
         ON Taxonomy_Import.TaxonomyCode = TaxonomyCode.TaxonomyCode

--UPDATE  TaxonomyCode
--SET TaxonomyCodeDesc = Taxonomy_Import.TaxonomyCodeDesc, 
--TaxonomyCodeClassification = Taxonomy_Import.TaxonomyCodeClassification
--FROM Taxonomy_Import 
--INNER JOIN TaxonomyCode 
--ON Taxonomy_Import.TaxonomyCode = TaxonomyCode.TaxonomyCode

-- Insert records in TaxonomyCode
/* Powered by General SQL Parser (www.sqlparser.com) */

INSERT INTO TaxonomyCode
           (TaxonomyCode,
            TaxonomyTypeCode,
            TaxonomySpecialtyCode,
            TaxonomyCodeClassification,
            TaxonomyCodeDesc)
SELECT Taxonomy_Import.TaxonomyCode,
       LEFT(Taxonomy_Import.TaxonomyCode,2) AS TaxTypeCode,
       SUBSTRING(Taxonomy_Import.TaxonomyCode,3,2) AS TaxSpecCode,
       Taxonomy_Import.TaxonomyCodeClassification,
       Taxonomy_Import.TaxonomyCodeDesc
FROM   Taxonomy_Import
       LEFT OUTER JOIN TaxonomyCode AS TaxonomyCode_1
         ON Taxonomy_Import.TaxonomyCode = TaxonomyCode_1.TaxonomyCode
WHERE  (TaxonomyCode_1.TaxonomyCode IS NULL)

--INSERT INTO TaxonomyCode
--(TaxonomyCode, TaxonomyTypeCode, TaxonomySpecialtyCode, TaxonomyCodeClassification, TaxonomyCodeDesc
--)
--SELECT Taxonomy_Import.TaxonomyCode, 
--LEFT(Taxonomy_Import.TaxonomyCode, 2) AS TaxTypeCode, 
--SUBSTRING(Taxonomy_Import.TaxonomyCode, 3, 2) AS TaxSpecCode, 
--Taxonomy_Import.TaxonomyCodeClassification, 
--Taxonomy_Import.TaxonomyCodeDesc
--FROM Taxonomy_Import 
--LEFT OUTER JOIN TaxonomyCode AS TaxonomyCode_1 
--ON Taxonomy_Import.TaxonomyCode = TaxonomyCode_1.TaxonomyCode
--WHERE (TaxonomyCode_1.TaxonomyCode IS NULL)




