/*

DATABASE UPDATE SCRIPT

v1.29.xxxx to v1.30.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------


---------------------------------------------------------------------------------------
--case 5446 - Modify data model to include InsuranceCompany table

IF DB_NAME()='superbill_0001_dev'
BEGIN
-- get rid of obsolete fields that were moved to InsuranceCompany:
 ALTER TABLE InsuranceCompanyPlan DROP CONSTRAINT DF_InsuranceCompanyPlan_InsuranceProgramCode,
 FK_InsuranceCompanyPlan_InsuranceProgram,DF__Insurance__BillS__49659AB2,DF__Insurance__Billi__09EBCAC9,
 DF__Insurance__HCFAD__3E53DAB9,DF__Insurance__HCFAS__3F47FEF2,DF__Insurance__EClai__7798DBBB,
 FK_InsuranceCompanyPlan_HCFADiagnosisReferenceFormat,
 FK_InsuranceCompanyPlan_HCFASameAsInsuredFormat,
 FK_InsuranceCompanyPlan_ProviderNumberType_LocalUse,
 FK_InsuranceCompanyPlan_ProviderNumberType, FK_InsuranceCompanyPlan_GroupNumberType,
 FK_InsuranceCompanyPlan_ClearinghousePayersList
 
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
END
 GO

-- the info in PracticeToInsuranceCompanyPlan has been migrated to PracticeToInsuranceCompany:
DROP TABLE PracticeToInsuranceCompanyPlan

---------------------------------------------------------------------------------------
--case 0000 - Transition to Kareo ProxyMed account

-- this table is obsolete, login info comes from shared - ClearinghouseConnection
DROP TABLE PracticeClearinghouseInfo

GO

---------------------------------------------------------------------------------------
--case 5390 - Migrate existing patients to case model

--ý Drop Claim Column AssignmentIndicator
DROP INDEX Claim.IX_Claim_AssignmentIndicator

ALTER TABLE Claim DROP CONSTRAINT CK_Claim_AssignmentIndicator

ALTER TABLE Claim DROP COLUMN AssignmentIndicator
--ý Drop Claim Column AssignmentIndicator

GO

--ý Drop Claim Columns that will not be moved
DROP INDEX Claim.IX_Claim_FacilityID	
ALTER TABLE Claim DROP COLUMN FacilityID

DROP INDEX Claim.IX_Claim_ReferringProviderID
ALTER TABLE Claim DROP CONSTRAINT FK_Claim_ReferringPhysician
ALTER TABLE Claim DROP COLUMN ReferringProviderID

DROP INDEX Claim.IX_Claim_AuthorizationID
ALTER TABLE Claim DROP COLUMN AuthorizationID

DROP INDEX Claim.IX_Claim_EncounterID
ALTER TABLE Claim DROP COLUMN EncounterID

DROP INDEX Claim.IX_Claim_ReferralDate
DROP INDEX Claim.IX_Claim_LastSeenDate
DROP INDEX Claim.IX_Claim_AcuteManifestationDate
DROP INDEX Claim.IX_Claim_LastXrayDate
DROP INDEX Claim.IX_Claim_SpecialProgramCode
DROP INDEX Claim.IX_Claim_PropertyCasualtyClaimNumber
DROP INDEX Claim.IX_Claim_PlaceOfServiceCode
DROP INDEX Claim.IX_Claim_ProcedureCode
DROP INDEX Claim.IX_Claim_ServiceBeginDate
DROP INDEX Claim.IX_Claim_DiagnosisCode1
DROP INDEX Claim.IX_Claim_DiagnosisCode2
DROP INDEX Claim.IX_Claim_DiagnosisCode3
DROP INDEX Claim.IX_Claim_DiagnosisCode4
DROP INDEX Claim.IX_Claim_DiagnosisCode5
DROP INDEX Claim.IX_Claim_DiagnosisCode6
DROP INDEX Claim.IX_Claim_DiagnosisCode7
DROP INDEX Claim.IX_Claim_DiagnosisCode8
ALTER TABLE Claim DROP CONSTRAINT DF_Claim_AmbulanceTransportFlag
ALTER TABLE Claim DROP CONSTRAINT DF_Claim_SpineTreatmentFlag
ALTER TABLE Claim DROP CONSTRAINT DF_Claim_VisionReplacementFlag
--Added

IF DB_NAME()='superbill_0001_dev'
BEGIN

	ALTER TABLE ClaimTransaction DROP CONSTRAINT DF_ClaimTransaction_IsFirstBill
	ALTER TABLE ClaimTransaction DROP CONSTRAINT DF_ClaimTransaction_Claim_TotalBalance
	ALTER TABLE ClaimTransaction DROP CONSTRAINT DF_ClaimTransaction_Claim_Amount
	ALTER TABLE ClaimTransaction DROP CONSTRAINT DF_ClaimTransaction_Claim_TotalAdjustments
	ALTER TABLE ClaimTransaction DROP CONSTRAINT DF_ClaimTransaction_Claim_TotalPayments
	DROP STATISTICS ClaimTransaction.hind_750625717_3A_16A_27A_1A_18A
	
	ALTER TABLE ClaimTransaction DROP COLUMN Claim_TotalBalance,Claim_ARBalance,Claim_PatientBalance,Claim_Amount,
	Claim_TotalAdjustments,Claim_TotalPayments,IsFirstBill
END

ALTER TABLE Claim DROP COLUMN OrderDate, ReferralDate, LastSeenDate, AcuteManifestationDate,
LastMenstrualDate, LastXrayDate, EstimatedBirthDate,
HearingVisionPrescriptionDate, ProviderSignatureOnFileFlag,
MedicareAssignmentCode, ReleaseOfInformationCode, SpecialProgramCode,
PropertyCasualtyClaimNumber, ServiceAuthorizationExceptionCode,
MammographyCertificationNumber, CLIANumber, APGNumber, IDENumber,
AmbulanceTransportFlag, AmbulanceCode, AmbulanceReasonCode,
AmbulanceDistance, AmbulanceCertificationCode1,
AmbulanceCertificationCode2, AmbulanceCertificationCode3,
AmbulanceCertificationCode4, AmbulanceCertificationCode5,
SpineTreatmentFlag, SpineTreatmentNumber, SpineTreatmentCount,
SpineSubluxationLevelCode, SpineSubluxationLevelEndCode,
SpineTreatmentPeriodCount, SpineTreatmentMonthlyCount,
SpinePatientConditionCode, SpineComplicationFlag, SpineXrayAvailableFlag,
VisionReplacementFlag, VisionReplacementTypeCode, VisionReplacementConditionCode,
PatientPaidAmount, PlaceOfServiceCode, ProcedureCode, TypeOfServiceCode,
ServiceBeginDate, ServiceChargeAmount, ServiceUnitCount, 
ProcedureModifier1, ProcedureModifier2, ProcedureModifier3,
ProcedureModifier4, DiagnosisPointer1, DiagnosisPointer2,
DiagnosisPointer3, DiagnosisPointer4, D1, D2, D3, D4, AssignedInsurancePolicyID


--ý Drop Claim Columns that will not be moved

GO

--ý Drop Claim Columns that will be moved to PatientCase
DROP INDEX Claim.IX_Claim_RenderingProviderID
ALTER TABLE Claim DROP COLUMN RenderingProviderID

DROP INDEX Claim.IX_Claim_InitialTreatmentDate
ALTER TABLE Claim DROP COLUMN InitialTreatmentDate

DROP INDEX Claim.IX_Claim_CurrentIllnessDate
ALTER TABLE Claim DROP COLUMN CurrentIllnessDate

DROP INDEX Claim.IX_Claim_SimilarIllnessDate
ALTER TABLE Claim DROP COLUMN SimilarIllnessDate

DROP INDEX Claim.IX_Claim_DisabilityBeginDate
ALTER TABLE Claim DROP COLUMN DisabilityBeginDate

DROP INDEX Claim.IX_Claim_DisabilityEndDate
ALTER TABLE Claim DROP COLUMN DisabilityEndDate

DROP INDEX Claim.IX_Claim_LastWorkedDate
ALTER TABLE Claim DROP COLUMN LastWorkedDate

DROP INDEX Claim.IX_Claim_ReturnToWorkDate
ALTER TABLE Claim DROP COLUMN ReturnToWorkDate

DROP INDEX Claim.IX_Claim_HospitalizationBeginDate
ALTER TABLE Claim DROP COLUMN HospitalizationBeginDate

DROP INDEX Claim.IX_Claim_HospitalizationEndDate
ALTER TABLE Claim DROP COLUMN HospitalizationEndDate

DROP INDEX Claim.IX_Claim_AutoAccidentRelatedFlag
ALTER TABLE Claim DROP COLUMN AutoAccidentRelatedFlag

DROP INDEX Claim.IX_Claim_AutoAccidentRelatedState
ALTER TABLE Claim DROP COLUMN AutoAccidentRelatedState

DROP INDEX Claim.IX_Claim_AbuseRelatedFlag
ALTER TABLE Claim DROP COLUMN AbuseRelatedFlag

DROP INDEX Claim.IX_Claim_EmploymentRelatedFlag
ALTER TABLE Claim DROP COLUMN EmploymentRelatedFlag

DROP INDEX Claim.IX_Claim_OtherAccidentRelatedFlag
ALTER TABLE Claim DROP COLUMN OtherAccidentRelatedFlag
--ý Drop Claim Columns that will be moved to PatientCase

GO

ALTER TABLE ClaimTransaction DROP CONSTRAINT CK_ClaimTransaction_AssignedToType
GO

ALTER TABLE ClaimTransaction DROP COLUMN AssignedToType,AssignedToID
GO

--ý Drop migrated EncounterProcedure Columns
ALTER TABLE EncounterProcedure DROP COLUMN DiagnosisID1,
DiagnosisID2, DiagnosisID3, DiagnosisID4
--ý Drop migrated EncounterProcedure Columns

GO

--ý Drop Claim Columns that will be moved to EncounterProcedure
ALTER TABLE Claim DROP COLUMN DiagnosisCode1,
DiagnosisCode2, DiagnosisCode3, DiagnosisCode4,
DiagnosisCode5, DiagnosisCode6, DiagnosisCode7,
DiagnosisCode8

ALTER TABLE Claim DROP COLUMN ServiceEndDate
--ý Drop Claim Columns that will be moved to EncounterProcedure

GO

--ý Drop Encounter Columns that will not be moved anywhere
ALTER TABLE Encounter DROP CONSTRAINT DF_Encounter_PaymentMethodType
ALTER TABLE Encounter DROP COLUMN PaymentMethodType

ALTER TABLE Encounter DROP CONSTRAINT DF_Encounter_DoctorSignature
ALTER TABLE Encounter DROP COLUMN DoctorSignature
--ý Drop Encounter Columns that will not be moved anywhere

GO

--ý Drop Encounter Columns that will be moved to PatientCase
ALTER TABLE Encounter DROP CONSTRAINT FK_Encounter_ReferringPhysician
DROP INDEX Encounter.IX_Encounter_PracticeID_RefPhyID
ALTER TABLE Encounter DROP COLUMN ReferringPhysicianID

ALTER TABLE Encounter DROP CONSTRAINT DF__Encounter__AutoA__16700691
ALTER TABLE Encounter DROP COLUMN AutoAccidentRelatedFlag

ALTER TABLE Encounter DROP CONSTRAINT DF__Encounter__Abuse__17642ACA
ALTER TABLE Encounter DROP COLUMN AbuseRelatedFlag

ALTER TABLE Encounter DROP CONSTRAINT DF__Encounter__Emplo__18584F03
ALTER TABLE Encounter DROP COLUMN EmploymentRelatedFlag

ALTER TABLE Encounter DROP CONSTRAINT DF__Encounter__Other__194C733C
ALTER TABLE Encounter DROP COLUMN OtherAccidentRelatedFlag

ALTER TABLE Encounter DROP COLUMN DateOfInjury, SimilarIllnessDate,
LastWorkedDate, ReturnToWorkDate, DisabilityBeginDate,
DisabilityEndDate, HospitalizationBeginDate, HospitalizationEndDate,
InitialTreatmentDate, AutoAccidentRelatedState,
PatientConditionType, PatientConditionOtherDescription
--ý Drop Encounter Columns that will be moved to PatientCase

GO

--ý Drop ClaimPayer and EncounterToPatientInsurance
DROP TABLE ClaimPayer
DROP TABLE EncounterToPatientInsurance
--ý Drop ClaimPayer and EncounterToPatientInsurance
GO

--ý Drop PatientAuthorization Table which was converted to InsurancePolicyAuthos
DROP TABLE PatientAuthorization
--ý Drop PatientAuthorization Table which was converted to InsurancePolicyAuthos

GO

--ý Drop PatientInsurance Table which was converted to InsurancePolicy
DROP TABLE PatientInsurance
--ý Drop PatientInsurance Table which was converted to InsurancePolicy

GO

ALTER TABLE Appointment DROP COLUMN PatientAuthorizationID

DROP INDEX Encounter.IX_Encounter_PatientID_PatientAuthorizationID

ALTER TABLE Encounter DROP COLUMN PatientAuthorizationID

GO

---------------------------------------------------------------------------------------
--case 6066 - Bill_EDI and Bill_HCFA need to have their PatientInsuranceIDs migrated
ALTER TABLE Bill_EDI DROP COLUMN PayerPatientInsuranceID
GO

ALTER TABLE Bill_HCFA DROP COLUMN PayerPatientInsuranceID, OtherPayerPatientInsuranceID
GO

--Remove Obsolete DashBoard Summarization Support Tables
DROP TABLE DashBoardARAgingDisplay
DROP TABLE DashBoardARAgingVolatile
DROP TABLE DashBoardReceiptsDisplay
DROP TABLE DashBoardReceiptsVolatile
DROP TABLE SummaryTransactionByProviderPerDay
GO

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
