---------------------------------------------------------------------------------------
--casE 5268 Load all Provider taxonomy codes
---------------------------------------------------------------------------------------


IF EXISTS(SELECT * FROM sysobjects WHERE xtype='U' AND name='TaxonomyCode')
	DROP TABLE TaxonomyCode

CREATE TABLE TaxonomyCode(TaxonomyCode CHAR(10) NOT NULL, TaxonomyTypeCode VARCHAR(4) NOT NULL, TaxonomySpecialtyCode VARCHAR(4) NOT NULL, TaxonomyCodeClassification VARCHAR(256), TaxonomyCodeDesc TEXT
			  CONSTRAINT PK_TaxonomyCode_TaxonomyCode PRIMARY KEY CLUSTERED (TaxonomyCode))

IF EXISTS(SELECT * FROM sysobjects WHERE xtype='U' AND name='TaxonomySpecialty')
	DROP TABLE TaxonomySpecialty

CREATE TABLE TaxonomySpecialty(TaxonomySpecialtyCode VARCHAR(4) NOT NULL, TaxonomyTypeCode VARCHAR(4) NOT NULL, TaxonomySpecialtyName VARCHAR(256), TaxonomySpecialtyDesc TEXT
			       CONSTRAINT PK_TaxonomySpecialty_TaxonomySpecialtyCode PRIMARY KEY CLUSTERED (TaxonomyTypeCode,TaxonomySpecialtyCode))

IF EXISTS(SELECT * FROM sysobjects WHERE xtype='U' AND name='TaxonomyType')
	DROP TABLE TaxonomyType

CREATE TABLE TaxonomyType(TaxonomyTypeCode VARCHAR(4) NOT NULL, TaxonomyTypeName VARCHAR(256), TaxonomyTypeDesc TEXT
	                  CONSTRAINT PK_TaxonomyType_TaxonomyTypeCode PRIMARY KEY CLUSTERED (TaxonomyTypeCode))

CREATE NONCLUSTERED INDEX IX_TaxonomyCode_TaxonomyTypeCode
ON TaxonomyCode (TaxonomyTypeCode)

CREATE NONCLUSTERED INDEX IX_TaxonomyCode_TaxonomySpecialtyCode
ON TaxonomyCode (TaxonomySpecialtyCode)

ALTER TABLE TaxonomyCode ADD CONSTRAINT FK_TaxonomyCode_TaxonomyType FOREIGN KEY
(TaxonomyTypeCode) REFERENCES TaxonomyType (TaxonomyTypeCode)
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE TaxonomyCode ADD CONSTRAINT FK_TaxonomyCode_TaxonomySpecialty FOREIGN KEY
(TaxonomyTypeCode,TaxonomySpecialtyCode) REFERENCES TaxonomySpecialty (TaxonomyTypeCode,TaxonomySpecialtyCode)
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE TaxonomySpecialty ADD CONSTRAINT FK_TaxonomySpecialty_TaxonomyType FOREIGN KEY
(TaxonomyTypeCode) REFERENCES TaxonomyType (TaxonomyTypeCode)
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE Doctor DROP CONSTRAINT FK_Doctor_ProviderSpecialty

UPDATE Doctor SET ProviderSpecialtyCode='207R0000X'
WHERE ProviderSpecialtyCode='203BI0300X'

UPDATE Doctor SET ProviderSpecialtyCode='208100000X'
WHERE ProviderSpecialtyCode='203BP0400X'

UPDATE Doctor SET ProviderSpecialtyCode='2081P0010X'
WHERE ProviderSpecialtyCode='203BP0010X'

UPDATE Doctor SET ProviderSpecialtyCode='2081P2900X'
WHERE ProviderSpecialtyCode='203BP0009X'

UPDATE Doctor SET ProviderSpecialtyCode='2081P0004X'
WHERE ProviderSpecialtyCode='203BP0004X'

DELETE ProviderSpecialty
WHERE ProviderSpecialtyCode IN ('203BI0300X','203BP0400X','203BP0010X','203BP0009X','203BP0004X')

ALTER TABLE Doctor ADD TaxonomyCode CHAR(10)

UPDATE Doctor SET TaxonomyCode=ProviderSpecialtyCode

ALTER TABLE Doctor ALTER COLUMN TaxonomyCode CHAR(10) NOT NULL

ALTER TABLE Doctor ADD CONSTRAINT FK_Doctor_TaxonomyCode
FOREIGN KEY (TaxonomyCode) REFERENCES TaxonomyCode (TaxonomyCode)
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE Doctor DROP COLUMN ProviderSpecialty, HipaaProviderTaxonomyCode

INSERT INTO TaxonomyType
SELECT * FROM superbill_shared..TaxonomyType

INSERT INTO TaxonomySpecialty
SELECT * FROM superbill_shared..TaxonomySpecialty

INSERT INTO TaxonomyCode
SELECT * FROM superbill_shared..TaxonomyCode

GO
