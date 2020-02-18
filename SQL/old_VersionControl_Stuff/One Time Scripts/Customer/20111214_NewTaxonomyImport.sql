-- importing new TaxonomyCodes
SELECT * INTO #src FROM SHAREDSERVER.superbill_shared.dbo.[_Taxonomy20111214] WHERE [Deactivation Date]='' AND Code NOT IN (SELECT TaxonomyCode FROM dbo.TaxonomyCode)

-- create Taxonomy Type Records
--SELECT LEFT(Code, 2) NewTypeCode, [Type] NewType INTO #newTypes FROM #src WHERE LEFT(Code, 2) NOT IN (SELECT TaxonomyTypeCode FROM dbo.TaxonomyType)

-- Taxonomy Specialty
SELECT LEFT(Code, 2) TypeCode, SUBSTRING(Code, 3, 2) SpecialtyCode, Specialization  INTO #newSpec FROM #src WHERE NOT EXISTS (SELECT * FROM dbo.TaxonomySpecialty WHERE TaxonomyTypeCode=LEFT(Code, 2) AND TaxonomySpecialtyCode=SUBSTRING(Code, 3, 2))

--SELECT * FROM #src

--SELECT * FROM dbo.TaxonomySpecialty ORDER BY TaxonomySpecialtyCode, TaxonomyTypeCode


BEGIN TRAN

INSERT INTO dbo.TaxonomySpecialty
        ( TaxonomySpecialtyCode ,
          TaxonomyTypeCode ,
          TaxonomySpecialtyName ,
          TaxonomySpecialtyDesc
        )
SELECT SpecialtyCode , -- TaxonomySpecialtyCode - varchar(4)
          TypeCode , -- TaxonomyTypeCode - varchar(4)
          Specialization , -- TaxonomySpecialtyName - varchar(256)
          ''  -- TaxonomySpecialtyDesc - text
FROM #newSpec

INSERT INTO dbo.TaxonomyCode
        ( TaxonomyCode ,
          TaxonomyTypeCode ,
          TaxonomySpecialtyCode ,
          TaxonomyCodeClassification ,
          TaxonomyCodeDesc ,
          IsValid
        )
SELECT Code , -- TaxonomyCode - char(10)
          LEFT(Code, 2) , -- TaxonomyTypeCode - varchar(4)
          SUBSTRING(Code, 3, 2) , -- TaxonomySpecialtyCode - varchar(4)
          Classification , -- TaxonomyCodeClassification - varchar(256)
          [Definition] , -- TaxonomyCodeDesc - text
          1  -- IsValid - bit
FROM #src

commit TRAN

DROP TABLE #src
DROP TABLE #newSpec

