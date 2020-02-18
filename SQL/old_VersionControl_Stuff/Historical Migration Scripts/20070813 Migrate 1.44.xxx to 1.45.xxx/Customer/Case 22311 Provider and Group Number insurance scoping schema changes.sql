--add scope table

CREATE TABLE BillingNumberInsuranceScope
(
	BillingNumberInsuranceScopeID int NOT NULL CONSTRAINT PK_BillingNumberInsuranceScope PRIMARY KEY,
	Name varchar(100)
)
GO

--populate data for billing number scope
INSERT INTO BillingNumberInsuranceScope VALUES (1,'All Insurance Companies and Plans')
INSERT INTO BillingNumberInsuranceScope VALUES (2,'Insurance Company')
INSERT INTO BillingNumberInsuranceScope VALUES (3,'Insurance Plan')
GO

--add type field, two new foreign keys to Provider Number table

ALTER TABLE ProviderNumber
ADD 
	InsuranceCompanyID int NULL CONSTRAINT FK_ProviderNumber_InsuranceCompany FOREIGN KEY REFERENCES InsuranceCompany (InsuranceCompanyID),
	BillingNumberInsuranceScopeID int NULL CONSTRAINT FK_ProviderNumber_BillingNumberInsuranceScope FOREIGN KEY REFERENCES BillingNumberInsuranceScope (BillingNumberInsuranceScopeID)
GO

--update all existing values to proper scoping

UPDATE ProviderNumber SET BillingNumberInsuranceScopeID = 1 WHERE InsuranceCompanyPlanID IS NULL

UPDATE ProviderNumber SET BillingNumberInsuranceScopeID = 3 WHERE InsuranceCompanyPlanID IS NOT NULL

--set default on provider number's scope to Insurance Program

ALTER TABLE ProviderNumber
ADD CONSTRAINT DF_ProviderNumber_BillingNumberInsuranceScopeID DEFAULT 2 FOR BillingNumberInsuranceScopeID
GO 

--add type field, two new foreign keys to Group Number table

ALTER TABLE PracticeInsuranceGroupNumber
ADD 
	InsuranceCompanyID int NULL CONSTRAINT FK_PracticeInsuranceGroupNumber_InsuranceCompany FOREIGN KEY REFERENCES InsuranceCompany (InsuranceCompanyID),
	BillingNumberInsuranceScopeID int NULL CONSTRAINT FK_PracticeInsuranceGroupNumber_BillingNumberInsuranceScope FOREIGN KEY REFERENCES BillingNumberInsuranceScope (BillingNumberInsuranceScopeID)
GO

--update all existing values to Insurance Plan scoping

UPDATE PracticeInsuranceGroupNumber SET BillingNumberInsuranceScopeID = 1 WHERE InsuranceCompanyPlanID IS NULL

UPDATE PracticeInsuranceGroupNumber SET BillingNumberInsuranceScopeID = 3 WHERE InsuranceCompanyPlanID IS NOT NULL

--set default on group number's scope to Insurance Program

ALTER TABLE PracticeInsuranceGroupNumber
ADD CONSTRAINT DF_PracticeInsuranceGroupNumber_BillingNumberInsuranceScopeID DEFAULT 2 FOR BillingNumberInsuranceScopeID
GO 

--add fields to restrict null-scoping

ALTER TABLE ProviderNumberType
ADD 
	RestrictInsuranceScope bit NOT NULL CONSTRAINT DF_ProviderNumberType_RestrictInsuranceScope DEFAULT 0
GO

UPDATE ProviderNumberType SET RestrictInsuranceScope = 1 WHERE ANSIReferenceIdentificationQualifier IN ('1A','1B','1C','1D','1H','G2')

ALTER TABLE GroupNumberType
ADD 
	RestrictInsuranceScope bit NOT NULL CONSTRAINT DF_GroupNumberType_RestrictInsuranceScope DEFAULT 0
GO

UPDATE GroupNumberType SET RestrictInsuranceScope = 1 WHERE ANSIReferenceIdentificationQualifier IN ('1A','1B','1C','1D','1H','G2')
