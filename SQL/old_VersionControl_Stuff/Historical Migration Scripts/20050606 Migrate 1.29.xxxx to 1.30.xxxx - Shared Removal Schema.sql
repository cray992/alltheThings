/*

SHARED DATABASE UPDATE SCRIPT

v1.29.xxxx to v1.30.xxxx		
*/
----------------------------------

--BEGIN TRAN 

----------------------------------

---------------------------------------------------------------------------------------
--case 5446 - Modify data model to include InsuranceCompany table
-- get rid of obsolete fields that were moved to InsuranceCompany:
ALTER TABLE InsuranceCompanyPlan DROP CONSTRAINT DF_InsuranceCompanyPlan_InsuranceProgramCode,
FK_InsuranceCompanyPlan_InsuranceProgram,DF__Insurance__BillS__32616E72,
DF_InsuranceCompanyPlan_HCFADiagnosisReferenceFormatCode,FK_InsuranceCompanyPlan_HCFADiagnosisReferenceFormat,
DF_InsuranceCompanyPlan_HCFASameAsInsuredFormatCode,FK_InsuranceCompanyPlan_HCFASameAsInsuredFormat,
FK_InsuranceCompanyPlan_ProviderNumberType_LocalUse,
FK_InsuranceCompanyPlan_ProviderNumberType, FK_InsuranceCompanyPlan_GroupNumberType,
DF_InsuranceCompanyPlan_BillingFormID, FK_InsuranceCompanyPlan_BillForm,
DF_InsuranceCompanyPlan_EClaimsAccepts, FK_InsuranceCompanyPlan_ClearinghousePayersList,
FK_InsuranceCompany_ClearinghousePayersList

GO

ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN InsuranceProgramCode
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN HCFADiagnosisReferenceFormatCode
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN HCFASameAsInsuredFormatCode
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN LocalUseFieldTypeCode
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN ProviderNumberTypeID
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN GroupNumberTypeID
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN LocalUseProviderNumberTypeID
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN BillingFormID
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN EClaimsAccepts
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN BillSecondaryInsurance
ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN ClearinghousePayerID
GO


---------------------------------------------------------------------------------------
--case XXXX - Description
---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
