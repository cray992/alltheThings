/*

DATABASE UPDATE SCRIPT

v1.33.xxxx to v1.34.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------


/*-----------------------------------------------------------------------------
	Case 7450 -- HolderDifferentThanPatient bit in InsurancePolicy is obsolete.
	it is going to be computed on the fly like the following:
	(CASE PI.PatientRelationshipToInsured WHEN 'S' THEN 0 ELSE 1 END)
-----------------------------------------------------------------------------*/

UPDATE [dbo].InsurancePolicy
SET PatientRelationshipToInsured = 'S' WHERE PatientRelationshipToInsured NOT IN ('S', 'U', 'O', 'C') AND (HolderDifferentThanPatient = 0)
GO

UPDATE [dbo].InsurancePolicy
SET PatientRelationshipToInsured = 'O' WHERE PatientRelationshipToInsured NOT IN ('S', 'U', 'O', 'C') AND (HolderDifferentThanPatient = 1)
GO

ALTER TABLE [dbo].InsurancePolicy ADD CONSTRAINT [FK_InsurancePolicy_PatientRelationshipToInsured] FOREIGN KEY 
	(
		[PatientRelationshipToInsured]
	) REFERENCES [Relationship] (
		[Relationship]
	)
GO

ALTER TABLE [dbo].InsurancePolicy DROP CONSTRAINT DF_InsurancePolicy_HolderDifferentThanPatient
ALTER TABLE [dbo].InsurancePolicy DROP COLUMN HolderDifferentThanPatient
GO

/*---------------------------------------------------------------------------------------
	Case 7530:   Create Data Schema to support Procedure Macros  
---------------------------------------------------------------------------------------*/

CREATE TABLE dbo.[ProcedureMacro] (
	-- standard fields
	[ProcedureMacroID] [int] IDENTITY (1, 1) NOT NULL ,
	[PracticeID] [int] NOT NULL ,
	RecordTimeStamp timestamp,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL DEFAULT (0),

	-- contract specific
	[Name] varchar(128) not null,
	[Description] text null,
	[Active] bit not null default 1
)

CREATE TABLE dbo.ProcedureMacroDetail(
	ProcedureMacroDetailID int not null identity(1,1),

	-- std fields
	RecordTimeStamp timestamp,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL DEFAULT (0),

	ProcedureMacroID int not null,
	ProcedureCodeDictionaryID int not null,
	
	ProcedureModifier1 varchar(19),
	ProcedureModifier2 varchar(19),
	ProcedureModifier3 varchar(19),
	ProcedureModifier4 varchar(19),

	Units decimal (18, 0) default 1,
	Charge money default 0,

	DiagnosisCodeDictionaryID1 int,
	DiagnosisCodeDictionaryID2 int,
	DiagnosisCodeDictionaryID3 int,
	DiagnosisCodeDictionaryID4 int
)	

GO

/*---------------------------------------------------------------------------------------
	Case 7536: Reintroduce support for making reports dynamically deployable without client builds
---------------------------------------------------------------------------------------*/

UPDATE	Report
SET	MenuName = '&Appointments Summary'
WHERE	[Name] = 'Appointments Summary'

GO

ALTER TABLE dbo.ReportCategoryToSoftwareApplication ADD
	ModifiedDate datetime NULL
GO

ALTER TABLE dbo.ReportCategoryToSoftwareApplication ADD CONSTRAINT
	DF_ReportCategoryToSoftwareApplication_ModifiedDate DEFAULT GetDate() FOR ModifiedDate
GO

ALTER TABLE dbo.ReportToSoftwareApplication ADD
	ModifiedDate datetime NULL
GO

ALTER TABLE dbo.ReportToSoftwareApplication ADD CONSTRAINT
	DF_ReportToSoftwareApplication_ModifiedDate DEFAULT GetDate() FOR ModifiedDate
GO


/*
-----------------------------------------------------------------------------------------------------
CASE 7251 - Implement Mass Medicaid Form 5
-----------------------------------------------------------------------------------------------------
*/

ALTER TABLE BillingForm ADD PrintingFormID INT, MaxProcedures INT, MaxDiagnosis INT

GO

UPDATE BillingForm SET PrintingFormID=1, MaxProcedures=6, MaxDiagnosis=4

GO

INSERT INTO BillingForm(BillingFormID, FormType, FormName, PrintingFormID, MaxProcedures, MaxDiagnosis)
VALUES(10, 'MASSM5', 'Massachusetts Medicaid Form 5',8, 8,4)

GO

ALTER TABLE InsuranceCompany ADD SecondaryPrecedenceBillingFormID INT

GO

UPDATE InsuranceCompany SET SecondaryPrecedenceBillingFormID=BillingFormID

GO

ALTER TABLE InsuranceCompany ALTER COLUMN SecondaryPrecedenceBillingFormID INT NOT NULL

GO

ALTER TABLE InsuranceCompany ADD CONSTRAINT DF_InsuranceCompany_SecondaryPrecedenceBillingFormID
DEFAULT 1 FOR SecondaryPrecedenceBillingFormID

GO

INSERT INTO PrintingForm(PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
VALUES(8,'MASSM5','Massachusetts Medicaid Form 5','BillDataProvider_GetMASSM5DocumentData',0)

GO

INSERT INTO PrintingFormDetails(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID,Description)
VALUES(11,8,1,'Massachusetts Medicaid Form 5')

GO

UPDATE PrintingFormDetails SET SVGDefinition='<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="MASSM5" pageId="MASSM5.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
  <defs>
    <style type="text/css"><![CDATA[
		
		g {
			font-family: Courier New;
			font-size: 10pt;
			font-style: Normal;
			font-weight: bold;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
		text.money
		{
			text-anchor: end;
		}
		
		text.smaller, g.smaller text
		{
			font-size: 9pt;
		}
		
	    	]]></style>
  </defs>

  
  <g>
    <text x="0.28in" y="1.55in" width="3.10in" height="0.1in" valueSource="MASSM5.1.1_MemberName" />
    <text x="3.48in" y="1.55in" width="1.80in" height="0.1in" valueSource="MASSM5.1.2_PatientBirthDate" />
    <text x="5.32in" y="1.55in" width="2.96in" height="0.1in" valueSource="MASSM5.1.3_InsuredName" />
    <text x="0.28in" y="1.81in" width="3.17in" height="0.1in" valueSource="MASSM5.1.4_MemberAddress_Street" />
    <text x="0.28in" y="1.96in" width="3.17in" height="0.1in" valueSource="MASSM5.1.4_MemberAddress_CityStateZip" />
    <text x="1.22in" y="2.23in" width="2.21in" height="0.1in" valueSource="MASSM5.1.4_MemberTelephone" />
    <text x="3.68in" y="1.86in" width="0.17in" height="0.1in" valueSource="MASSM5.1.5_PatientGender_Male" />
    <text x="4.36in" y="1.86in" width="0.17in" height="0.1in" valueSource="MASSM5.1.5_PatientGender_Female" />
    <text x="5.32in" y="1.88in" width="2.96in" height="0.1in" valueSource="MASSM5.1.6_PolicyNumber" />
    <text x="3.56in" y="2.23in" width="0.15in" height="0.1in" valueSource="MASSM5.1.7_MemberRelationshipToInsured_Self" />
    <text x="3.98in" y="2.23in" width="0.18in" height="0.1in" valueSource="MASSM5.1.7_MemberRelationshipToInsured_Spouse" />
    <text x="4.38in" y="2.23in" width="0.17in" height="0.1in" valueSource="MASSM5.1.7_MemberRelationshipToInsured_Child" />
    <text x="4.77in" y="2.23in" width="0.17in" height="0.1in" valueSource="MASSM5.1.7_MemberRelationshipToInsured_Other" />
    <text x="5.32in" y="2.23in" width="2.96in" height="0.1in" valueSource="MASSM5.1.8_GroupNumber" />
    <text x="0.45in" y="2.5in" width="0.18in" height="0.1in" valueSource="MASSM5.1.9_MemberOtherHealthIns_YES" />
    <text x="0.96in" y="2.5in" width="0.17in" height="0.1in" valueSource="MASSM5.1.9_MemberOtherHealthIns_NO" />
    <text x="0.28in" y="2.84in" width="3.18in" height="0.1in" valueSource="MASSM5.1.9_MemberOtherHealthIns_AddressStreet" />
    <text x="0.28in" y="2.99in" width="3.18in" height="0.1in" valueSource="MASSM5.1.9_MemberOtherHealthIns_AddressCityStateZip" />
    <text x="3.7in" y="2.7in" width="0.19in" height="0.1in" valueSource="MASSM5.1.10_MemberCondition_Employment_YES" />
    <text x="4.38in" y="2.7in" width="0.18in" height="0.1in" valueSource="MASSM5.1.10_MemberCondition_Employment_NO" />
    <text x="3.7in" y="3.04in" width="0.17in" height="0.1in" valueSource="MASSM5.1.10_MemberCondition_Accident_Auto" />
    <text x="4.38in" y="3.04in" width="0.18in" height="0.1in" valueSource="MASSM5.1.10_MemberCondition_Accident_Other" />
    <text x="5.32in" y="2.5in" width="2.96in" height="0.1in" valueSource="MASSM5.1.11_InsuredAddress_Street" />
    <text x="5.32in" y="2.65in" width="2.96in" height="0.1in" valueSource="MASSM5.1.11_InsuredAddress_CityStateZip" />
    <text x="0.38in" y="3.44in" width="3.35in" height="0.1in" valueSource="MASSM5.1.12_Signature" />
    <text x="3.9in" y="3.44in" width="1.40in" height="0.1in" valueSource="MASSM5.1.12_Date" />
    <text x="5.32in" y="3.44in" width="1.90in" height="0.1in" valueSource="MASSM5.1.13_Signature" />
    <text x="7.22in" y="3.44in" width="0.96in" height="0.1in" valueSource="MASSM5.1.13_Date" />
    <text x="0.28in" y="4.04in" width="1.36in" height="0.1in" valueSource="MASSM5.1.14_CurrentIllnessDate" />
    <text x="3.48in" y="4.04in" width="1.49in" height="0.1in" valueSource="MASSM5.1.15_FirstConsultationDate" />
    <text x="5.58in" y="4.04in" width="0.19in" height="0.1in" valueSource="MASSM5.1.16_SimilarSymptoms_YES" />
    <text x="6.23in" y="4.04in" width="0.19in" height="0.1in" valueSource="MASSM5.1.16_SimilarSymptoms_NO" />
    <text x="7.6in" y="4.04in" width="0.19in" height="0.1in" valueSource="MASSM5.1.16a_Emergency" />
    <text x="0.28in" y="4.38in" width="1.49in" height="0.1in" valueSource="MASSM5.1.17_ReturnToWorkDate" />
    <text x="2.1in" y="4.38in" width="1.40in" height="0.1in" valueSource="MASSM5.1.18_TotalDisabilityBeginDate" />
    <text x="3.94in" y="4.38in" width="1.40in" height="0.1in" valueSource="MASSM5.1.18_TotalDisabilityEndDate" />
    <text x="5.62in" y="4.38in" width="1.20in" height="0.1in" valueSource="MASSM5.1.18_PartialDisabilityBeginDate" />
    <text x="7.4in" y="4.38in" width="0.96in" height="0.1in" valueSource="MASSM5.1.18_PartialDisabilityEndDate" />
    <text x="0.28in" y="4.71in" width="3.38in" height="0.1in" valueSource="MASSM5.1.19a_ReferringPhyscianName" />
    <text x="3.67in" y="4.71in" width="1.62in" height="0.1in" valueSource="MASSM5.1.19b_ReferringProviderUPIN" />
    <text x="5.81in" y="4.71in" width="1.08in" height="0.1in" valueSource="MASSM5.1.20_HospitalizationBeginDate" />
    <text x="7.51in" y="4.71in" width="0.76in" height="0.1in" valueSource="MASSM5.1.20_HospitalizationEndDate" />
    <text x="0.28in" y="5.03in" width="5.03in" height="0.1in" valueSource="MASSM5.1.21_FacilityName" />
    <text x="5.59in" y="5.03in" width="0.17in" height="0.1in" valueSource="MASSM5.1.22_LabWork_External_YES" />
    <text x="6.2in" y="5.03in" width="0.19in" height="0.1in" valueSource="MASSM5.1.22_LabWork_External_NO" />
    <text x="7.41in" y="5.03in" width="0.97in" height="0.1in" valueSource="MASSM5.1.22_LabWork_External_Charges" />
    <text x="0.35in" y="5.35in" width="4.54in" height="0.1in" valueSource="MASSM5.1.23a_Diagnosis1" />
    <text x="0.35in" y="5.53in" width="4.54in" height="0.1in" valueSource="MASSM5.1.23a_Diagnosis2" />
    <text x="0.35in" y="5.67in" width="4.54in" height="0.1in" valueSource="MASSM5.1.23a_Diagnosis3" />
    <text x="0.35in" y="5.84in" width="4.54in" height="0.1in" valueSource="MASSM5.1.23a_Diagnosis4" />
    <text x="6.84in" y="5.28in" width="0.19in" height="0.1in" valueSource="MASSM5.1.23b_Screen" />
    <text x="7.6in" y="5.28in" width="0.19in" height="0.1in" valueSource="MASSM5.1.23b_Referral" />
    <text x="6.84in" y="5.5in" width="0.19in" height="0.1in" valueSource="MASSM5.1.23c_FamilyPlanning" />
    <text x="6.86in" y="5.84in" width="1.40in" height="0.1in" valueSource="MASSM5.1.23d_AuthorizationNumber" />
  </g>
  <g class="smaller">
    <text x="0.28in" y="6.49in" width="0.71in" height="0.1in" valueSource="MASSM5.1.24a_aServiceBeginDate" />
    <text x="1in" y="6.49in" width="0.68in" height="0.1in" valueSource="MASSM5.1.24a_aServiceEndDate" />
    <text x="1.71in" y="6.49in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24a_bPlaceOfServiceCode" />
    <text x="2.11in" y="6.49in" width="0.28in" height="0.1in" valueSource="MASSM5.1.24a_cTypeOfServiceCode" />
    <text x="2.42in" y="6.49in" width="0.75in" height="0.1in" valueSource="MASSM5.1.24a_cProcedureCode" />
    <text x="3.26in" y="6.49in" width="0.24in" height="0.1in" valueSource="MASSM5.1.24a_cProcedureModifier1" />
    <text x="3.49in" y="6.49in" width="1.89in" height="0.1in" valueSource="MASSM5.1.24a_cProcedureExplanation" />
    <text x="5.38in" y="6.49in" width="0.57in" height="0.1in" valueSource="MASSM5.1.24a_dDiagnosisPointer1Code" />
    <text x="5.97in" y="6.49in" width="0.44in" height="0.1in" valueSource="MASSM5.1.24a_eCharges_Dollars" class="money" />
    <text x="6.44in" y="6.49in" width="0.31in" height="0.1in" valueSource="MASSM5.1.24a_eCharges_Cents" />
    <text x="6.78in" y="6.49in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24a_fServiceUnitCount" />
    <text x="7.18in" y="6.49in" width="0.78in" height="0.1in" valueSource="MASSM5.1.24a_gPaid_Dollars" class="money" />
    <text x="7.99in" y="6.49in" width="0.29in" height="0.1in" valueSource="MASSM5.1.24a_gPaid_Cents" />
    <text x="0.28in" y="6.82in" width="0.71in" height="0.1in" valueSource="MASSM5.1.24b_aServiceBeginDate" />
    <text x="1in" y="6.82in" width="0.68in" height="0.1in" valueSource="MASSM5.1.24b_aServiceEndDate" />
    <text x="1.71in" y="6.82in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24b_bPlaceOfServiceCode" />
    <text x="2.11in" y="6.82in" width="0.28in" height="0.1in" valueSource="MASSM5.1.24b_cTypeOfServiceCode" />
    <text x="2.42in" y="6.82in" width="0.75in" height="0.1in" valueSource="MASSM5.1.24b_cProcedureCode" />
    <text x="3.26in" y="6.82in" width="0.24in" height="0.1in" valueSource="MASSM5.1.24b_cProcedureModifier1" />
    <text x="3.49in" y="6.82in" width="1.89in" height="0.1in" valueSource="MASSM5.1.24b_cProcedureExplanation" />
    <text x="5.38in" y="6.82in" width="0.57in" height="0.1in" valueSource="MASSM5.1.24b_dDiagnosisPointer1Code" />
    <text x="5.97in" y="6.82in" width="0.44in" height="0.1in" valueSource="MASSM5.1.24b_eCharges_Dollars" class="money" />
    <text x="6.44in" y="6.82in" width="0.31in" height="0.1in" valueSource="MASSM5.1.24b_eCharges_Cents" />
    <text x="6.78in" y="6.82in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24b_fServiceUnitCount" />
    <text x="7.18in" y="6.82in" width="0.78in" height="0.1in" valueSource="MASSM5.1.24b_gPaid_Dollars" class="money" />
    <text x="7.99in" y="6.82in" width="0.29in" height="0.1in" valueSource="MASSM5.1.24b_gPaid_Cents" />
    <text x="0.28in" y="7.16in" width="0.71in" height="0.1in" valueSource="MASSM5.1.24c_aServiceBeginDate" />
    <text x="1in" y="7.16in" width="0.68in" height="0.1in" valueSource="MASSM5.1.24c_aServiceEndDate" />
    <text x="1.71in" y="7.16in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24c_bPlaceOfServiceCode" />
    <text x="2.11in" y="7.16in" width="0.28in" height="0.1in" valueSource="MASSM5.1.24c_cTypeOfServiceCode" />
    <text x="2.42in" y="7.16in" width="0.75in" height="0.1in" valueSource="MASSM5.1.24c_cProcedureCode" />
    <text x="3.26in" y="7.16in" width="0.24in" height="0.1in" valueSource="MASSM5.1.24c_cProcedureModifier1" />
    <text x="3.49in" y="7.16in" width="1.89in" height="0.1in" valueSource="MASSM5.1.24c_cProcedureExplanation" />
    <text x="5.38in" y="7.16in" width="0.57in" height="0.1in" valueSource="MASSM5.1.24c_dDiagnosisPointer1Code" />
    <text x="5.97in" y="7.16in" width="0.44in" height="0.1in" valueSource="MASSM5.1.24c_eCharges_Dollars" class="money" />
    <text x="6.44in" y="7.16in" width="0.31in" height="0.1in" valueSource="MASSM5.1.24c_eCharges_Cents" />
    <text x="6.78in" y="7.16in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24c_fServiceUnitCount" />
    <text x="7.18in" y="7.16in" width="0.78in" height="0.1in" valueSource="MASSM5.1.24c_gPaid_Dollars" class="money" />
    <text x="7.99in" y="7.16in" width="0.29in" height="0.1in" valueSource="MASSM5.1.24c_gPaid_Cents" />
    <text x="0.28in" y="7.49in" width="0.71in" height="0.1in" valueSource="MASSM5.1.24d_aServiceBeginDate" />
    <text x="1in" y="7.49in" width="0.68in" height="0.1in" valueSource="MASSM5.1.24d_aServiceEndDate" />
    <text x="1.71in" y="7.49in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24d_bPlaceOfServiceCode" />
    <text x="2.11in" y="7.49in" width="0.28in" height="0.1in" valueSource="MASSM5.1.24d_cTypeOfServiceCode" />
    <text x="2.42in" y="7.49in" width="0.75in" height="0.1in" valueSource="MASSM5.1.24d_cProcedureCode" />
    <text x="3.26in" y="7.49in" width="0.24in" height="0.1in" valueSource="MASSM5.1.24d_cProcedureModifier1" />
    <text x="3.49in" y="7.49in" width="1.89in" height="0.1in" valueSource="MASSM5.1.24d_cProcedureExplanation" />
    <text x="5.38in" y="7.49in" width="0.57in" height="0.1in" valueSource="MASSM5.1.24d_dDiagnosisPointer1Code" />
    <text x="5.97in" y="7.49in" width="0.44in" height="0.1in" valueSource="MASSM5.1.24d_eCharges_Dollars" class="money" />
    <text x="6.44in" y="7.49in" width="0.31in" height="0.1in" valueSource="MASSM5.1.24d_eCharges_Cents" />
    <text x="6.78in" y="7.49in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24d_fServiceUnitCount" />
    <text x="7.18in" y="7.49in" width="0.78in" height="0.1in" valueSource="MASSM5.1.24d_gPaid_Dollars" class="money" />
    <text x="7.99in" y="7.49in" width="0.29in" height="0.1in" valueSource="MASSM5.1.24d_gPaid_Cents" />
    <text x="0.28in" y="7.82in" width="0.71in" height="0.1in" valueSource="MASSM5.1.24e_aServiceBeginDate" />
    <text x="1in" y="7.82in" width="0.68in" height="0.1in" valueSource="MASSM5.1.24e_aServiceEndDate" />
    <text x="1.71in" y="7.82in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24e_bPlaceOfServiceCode" />
    <text x="2.11in" y="7.82in" width="0.28in" height="0.1in" valueSource="MASSM5.1.24e_cTypeOfServiceCode" />
    <text x="2.42in" y="7.82in" width="0.75in" height="0.1in" valueSource="MASSM5.1.24e_cProcedureCode" />
    <text x="3.26in" y="7.82in" width="0.24in" height="0.1in" valueSource="MASSM5.1.24e_cProcedureModifier1" />
    <text x="3.49in" y="7.82in" width="1.89in" height="0.1in" valueSource="MASSM5.1.24e_cProcedureExplanation" />
    <text x="5.38in" y="7.82in" width="0.57in" height="0.1in" valueSource="MASSM5.1.24e_dDiagnosisPointer1Code" />
    <text x="5.97in" y="7.82in" width="0.44in" height="0.1in" valueSource="MASSM5.1.24e_eCharges_Dollars" class="money" />
    <text x="6.44in" y="7.82in" width="0.31in" height="0.1in" valueSource="MASSM5.1.24e_eCharges_Cents" />
    <text x="6.78in" y="7.82in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24e_fServiceUnitCount" />
    <text x="7.18in" y="7.82in" width="0.78in" height="0.1in" valueSource="MASSM5.1.24e_gPaid_Dollars" class="money" />
    <text x="7.99in" y="7.82in" width="0.29in" height="0.1in" valueSource="MASSM5.1.24e_gPaid_Cents" />
    <text x="0.28in" y="8.15in" width="0.71in" height="0.1in" valueSource="MASSM5.1.24f_aServiceBeginDate" />
    <text x="1in" y="8.15in" width="0.68in" height="0.1in" valueSource="MASSM5.1.24f_aServiceEndDate" />
    <text x="1.71in" y="8.15in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24f_bPlaceOfServiceCode" />
    <text x="2.11in" y="8.15in" width="0.28in" height="0.1in" valueSource="MASSM5.1.24f_cTypeOfServiceCode" />
    <text x="2.42in" y="8.15in" width="0.75in" height="0.1in" valueSource="MASSM5.1.24f_cProcedureCode" />
    <text x="3.26in" y="8.15in" width="0.24in" height="0.1in" valueSource="MASSM5.1.24f_cProcedureModifier1" />
    <text x="3.49in" y="8.15in" width="1.89in" height="0.1in" valueSource="MASSM5.1.24f_cProcedureExplanation" />
    <text x="5.38in" y="8.15in" width="0.57in" height="0.1in" valueSource="MASSM5.1.24f_dDiagnosisPointer1Code" />
    <text x="5.97in" y="8.15in" width="0.44in" height="0.1in" valueSource="MASSM5.1.24f_eCharges_Dollars" class="money" />
    <text x="6.44in" y="8.15in" width="0.31in" height="0.1in" valueSource="MASSM5.1.24f_eCharges_Cents" />
    <text x="6.78in" y="8.15in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24f_fServiceUnitCount" />
    <text x="7.18in" y="8.15in" width="0.78in" height="0.1in" valueSource="MASSM5.1.24f_gPaid_Dollars" class="money" />
    <text x="7.99in" y="8.15in" width="0.29in" height="0.1in" valueSource="MASSM5.1.24f_gPaid_Cents" />
    <text x="0.28in" y="8.47in" width="0.71in" height="0.1in" valueSource="MASSM5.1.24g_aServiceBeginDate" />
    <text x="1in" y="8.47in" width="0.68in" height="0.1in" valueSource="MASSM5.1.24g_aServiceEndDate" />
    <text x="1.71in" y="8.47in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24g_bPlaceOfServiceCode" />
    <text x="2.11in" y="8.47in" width="0.28in" height="0.1in" valueSource="MASSM5.1.24g_cTypeOfServiceCode" />
    <text x="2.42in" y="8.47in" width="0.75in" height="0.1in" valueSource="MASSM5.1.24g_cProcedureCode" />
    <text x="3.26in" y="8.47in" width="0.24in" height="0.1in" valueSource="MASSM5.1.24g_cProcedureModifier1" />
    <text x="3.49in" y="8.47in" width="1.89in" height="0.1in" valueSource="MASSM5.1.24g_cProcedureExplanation" />
    <text x="5.38in" y="8.47in" width="0.57in" height="0.1in" valueSource="MASSM5.1.24g_dDiagnosisPointer1Code" />
    <text x="5.97in" y="8.47in" width="0.44in" height="0.1in" valueSource="MASSM5.1.24g_eCharges_Dollars" class="money" />
    <text x="6.44in" y="8.47in" width="0.31in" height="0.1in" valueSource="MASSM5.1.24g_eCharges_Cents" />
    <text x="6.78in" y="8.47in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24g_fServiceUnitCount" />
    <text x="7.18in" y="8.47in" width="0.78in" height="0.1in" valueSource="MASSM5.1.24g_gPaid_Dollars" class="money" />
    <text x="7.99in" y="8.47in" width="0.29in" height="0.1in" valueSource="MASSM5.1.24g_gPaid_Cents" />
    <text x="0.28in" y="8.81in" width="0.71in" height="0.1in" valueSource="MASSM5.1.24h_aServiceBeginDate" />
    <text x="1in" y="8.81in" width="0.68in" height="0.1in" valueSource="MASSM5.1.24h_aServiceEndDate" />
    <text x="1.71in" y="8.81in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24h_bPlaceOfServiceCode" />
    <text x="2.11in" y="8.81in" width="0.28in" height="0.1in" valueSource="MASSM5.1.24h_cTypeOfServiceCode" />
    <text x="2.42in" y="8.81in" width="0.75in" height="0.1in" valueSource="MASSM5.1.24h_cProcedureCode" />
    <text x="3.26in" y="8.81in" width="0.24in" height="0.1in" valueSource="MASSM5.1.24h_cProcedureModifier1" />
    <text x="3.49in" y="8.81in" width="1.89in" height="0.1in" valueSource="MASSM5.1.24h_cProcedureExplanation" />
    <text x="5.38in" y="8.81in" width="0.57in" height="0.1in" valueSource="MASSM5.1.24h_dDiagnosisPointer1Code" />
    <text x="5.97in" y="8.81in" width="0.44in" height="0.1in" valueSource="MASSM5.1.24h_eCharges_Dollars" class="money" />
    <text x="6.44in" y="8.81in" width="0.31in" height="0.1in" valueSource="MASSM5.1.24h_eCharges_Cents" />
    <text x="6.78in" y="8.81in" width="0.38in" height="0.1in" valueSource="MASSM5.1.24h_fServiceUnitCount" />
    <text x="7.18in" y="8.81in" width="0.78in" height="0.1in" valueSource="MASSM5.1.24h_gPaid_Dollars" class="money" />
    <text x="7.99in" y="8.81in" width="0.29in" height="0.1in" valueSource="MASSM5.1.24h_gPaid_Cents" />
  </g>
  <g>
    <text x="0.84in" y="9.74in" width="1.79in" height="0.1in" valueSource="MASSM5.1.25_PhysicianSignature" />
    <text x="2.71in" y="9.74in" width="0.79in" height="0.1in" valueSource="MASSM5.1.25_PhysicianSignatureCurrentDate" />
    <text x="3.81in" y="9.39in" width="0.19in" height="0.1in" valueSource="MASSM5.1.26_Accept_YES" />
    <text x="4.52in" y="9.39in" width="0.19in" height="0.1in" valueSource="MASSM5.1.26_Accept_NO" />
    <text x="5.38in" y="9.23in" width="1.04in" height="0.1in" valueSource="MASSM5.1.27_TotalCharge_Dollars" class="money" />
    <text x="6.44in" y="9.23in" width="0.33in" height="0.1in" valueSource="MASSM5.1.27_TotalCharge_Cents" />
    <text x="6.78in" y="9.23in" width="0.42in" height="0.1in" valueSource="MASSM5.1.28_TotalPaid_Dollars" class="money" />
    <text x="7.23in" y="9.23in" width="0.33in" height="0.1in" valueSource="MASSM5.1.28_TotalPaid_Cents" />
    <text x="7.48in" y="9.23in" width="0.48in" height="0.1in" valueSource="MASSM5.1.29_TotalBalance_Dollars" class="money" />
    <text x="7.99in" y="9.23in" width="0.33in" height="0.1in" valueSource="MASSM5.1.29_TotalBalance_Cents" />
    <text x="3.48in" y="9.74in" width="1.70in" height="0.1in" valueSource="MASSM5.1.30_ServicingProviderNumber" />
    <text x="5.38in" y="9.50in" width="2.90in" height="0.1in" valueSource="MASSM5.1.31_PhysicianName" />
    <text x="5.38in" y="9.63in" width="2.90in" height="0.1in" valueSource="MASSM5.1.31_PhysicianAddress" />
    <text x="5.38in" y="9.76in" width="2.90in" height="0.1in" valueSource="MASSM5.1.31_PhysicianCityStateZip" />
    <text x="5.38in" y="9.88in" width="2.90in" height="0.1in" valueSource="MASSM5.1.31_PhysicianTelephone" />
    <text x="6.32in" y="10.04in" width="1.96in" height="0.1in" valueSource="MASSM5.1.31_PhysicianProviderNo" />
    <text x="0.28in" y="10.04in" width="2.70in" height="0.1in" valueSource="MASSM5.1.32_PatientID" />
    <text x="3.48in" y="10.04in" width="1.70in" height="0.1in" valueSource="MASSM5.1.33_BillingAgentNumber" />
  </g>
</svg>'
WHERE PrintingFormDetailsID=11


Update BillingForm SET TransForm='<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml"/>
  <xsl:decimal-format name="default-format" NaN="0.00"/>
  <xsl:template match="/formData/page">
    <formData formId="MASSM5">
      <page pageId="MASSM5.1">
        <BillID>
          <xsl:value-of select="data[@id=''MASSM5.1.BillID1'']"/>
        </BillID>
        <data id="MASSM5.1.1_MemberName">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientMiddleName1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''MASSM5.1.PatientLastName1'']"/>
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientSuffix1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.PatientSuffix1'']"/>
          </xsl:if>
        </data>
        <data id="MASSM5.1.2_PatientBirthDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientBirthDate1'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientBirthDate1''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientBirthDate1''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientBirthDate1''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.3_InsuredName">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberFirstName1'']"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:if test="string-length(data[@id=''MASSM5.1.SubscriberMiddleName1'']) &gt; 0">
                <xsl:value-of select="substring(data[@id=''MASSM5.1.SubscriberMiddleName1''], 1, 1)"/>
                <xsl:text xml:space="preserve"> </xsl:text>
              </xsl:if>
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberLastName1'']"/>
              <xsl:if test="string-length(data[@id=''MASSM5.1.SubscriberSuffix1'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.SubscriberSuffix1'']"/>
              </xsl:if>
            </xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''MASSM5.1.HCFASameAsInsuredFormatCode1''] = ''M''">
              <xsl:text>SAME</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientFirstName1'']"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:if test="string-length(data[@id=''MASSM5.1.PatientMiddleName1'']) &gt; 0">
                <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientMiddleName1''], 1, 1)"/>
                <xsl:text xml:space="preserve"> </xsl:text>
              </xsl:if>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientLastName1'']"/>
              <xsl:if test="string-length(data[@id=''MASSM5.1.PatientSuffix1'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.PatientSuffix1'']"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.4_MemberAddress_Street">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet11'']"/>
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet21'']"/>
          </xsl:if>
        </data>
        <data id="MASSM5.1.4_MemberAddress_CityStateZip">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientCity1'']"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.PatientState1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM5.1.PatientZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientZip1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.4_MemberTelephone">
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientPhone1'']) &gt; 0">
		  <xsl:text>(</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientPhone1''], 1, 3)"/>
		  <xsl:text>) </xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientPhone1''], 4, 3)"/>
		  <xsl:text>-</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientPhone1''], 7, 4)"/>
	  </xsl:if>
        </data>
        
        <data id="MASSM5.1.5_PatientGender_Male">
          <xsl:if test="data[@id=''MASSM5.1.PatientGender1''] = ''M''">X</xsl:if>
        </data>
        <data id="MASSM5.1.5_PatientGender_Female">
          <xsl:if test="data[@id=''MASSM5.1.PatientGender1''] = ''F''">X</xsl:if>
        </data>
        <data id="MASSM5.1.6_PolicyNumber">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM5.1.PolicyNumber1'']) &gt; 0">
              <xsl:value-of select="data[@id=''MASSM5.1.PolicyNumber1'']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.DependentPolicyNumber1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>

        <data id="MASSM5.1.7_MemberRelationshipToInsured_Self">
            <xsl:if test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
        </data>
        <data id="MASSM5.1.7_MemberRelationshipToInsured_Spouse">
            <xsl:if test="data[@id=''MASSM5.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
        </data>
        <data id="MASSM5.1.7_MemberRelationshipToInsured_Child">
            <xsl:if test="data[@id=''MASSM5.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
        </data>
        <data id="MASSM5.1.7_MemberRelationshipToInsured_Other">
          <xsl:if test="data[@id=''MASSM5.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
        </data>

        <data id="MASSM5.1.8_GroupNumber">
           <xsl:value-of select="data[@id=''MASSM5.1.GroupNumber1'']"/>
        </data>

        <data id="MASSM5.1.9_MemberOtherHealthIns_YES">
        </data>
        <data id="MASSM5.1.9_MemberOtherHealthIns_NO">
          X
        </data>
        <data id="MASSM5.1.9_MemberOtherHealthIns_AddressStreet">
        </data>
        <data id="MASSM5.1.9_MemberOtherHealthIns_AddressCityStateZip">
        </data>

        <data id="MASSM5.1.10_MemberCondition_Employment_YES">
          <xsl:if test="data[@id=''MASSM5.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="MASSM5.1.10_MemberCondition_Employment_NO">
          <xsl:if test="data[@id=''MASSM5.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
        </data>
        <data id="MASSM5.1.10_MemberCondition_Accident_Auto">
          <xsl:if test="data[@id=''MASSM5.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="MASSM5.1.10_MemberCondition_Accident_Other">
          <xsl:if test="data[@id=''MASSM5.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        
        <data id="MASSM5.1.11_InsuredAddress_Street">
            <xsl:choose>
              <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''1''">
                <xsl:value-of select="data[@id=''MASSM5.1.SubscriberStreet11'']"/>
                <xsl:if test="string-length(data[@id=''MASSM5.1.SubscriberStreet21'']) &gt; 0">
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="data[@id=''MASSM5.1.SubscriberStreet21'']"/>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet11'']"/>
                <xsl:if test="string-length(data[@id=''MASSM5.1.PatientStreet21'']) &gt; 0">
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet21'']"/>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
        </data>       
        <data id="MASSM5.1.11_InsuredAddress_CityStateZip">
            <xsl:choose>
              <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''1''">
                <xsl:value-of select="data[@id=''MASSM5.1.SubscriberCity1'']"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.SubscriberState1'']"/>
                <xsl:text xml:space="preserve"> </xsl:text>
                <xsl:choose>
                  <xsl:when test="string-length(data[@id=''MASSM5.1.SubscriberZip1'']) = 9">
                    <xsl:value-of select="substring(data[@id=''MASSM5.1.SubscriberZip1''], 1, 5)"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="substring(data[@id=''MASSM5.1.SubscriberZip1''], 6, 4)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="data[@id=''MASSM5.1.SubscriberZip1'']"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''MASSM5.1.PatientCity1'']"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.PatientState1'']"/>
                <xsl:text xml:space="preserve"> </xsl:text>
                <xsl:choose>
                  <xsl:when test="string-length(data[@id=''MASSM5.1.PatientZip1'']) = 9">
                    <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 1, 5)"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 6, 4)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="data[@id=''MASSM5.1.PatientZip1'']"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
        </data>
        
        <data id="MASSM5.1.12_Signature">
        	Signature on File
        </data>
        <data id="MASSM5.1.12_Date">
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 1, 2)"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 4, 2)"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 9, 2)"/>
        </data>

        <data id="MASSM5.1.13_Signature">
        	Signature on File
        </data>
        <data id="MASSM5.1.13_Date">
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 1, 2)"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 4, 2)"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 9, 2)"/>
        </data>


        <data id="MASSM5.1.14_CurrentIllnessDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.CurrentIllnessDate1'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentIllnessDate1''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentIllnessDate1''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentIllnessDate1''], 9, 2)"/>
	  </xsl:if>
        </data>

	<data id="MASSM5.1.15_FirstConsultationDate">
	</data>
	
	<data id="MASSM5.1.16_SimilarSymptoms_YES">
	</data>
	<data id="MASSM5.1.16_SimilarSymptoms_NO">
	</data>
	<data id="MASSM5.1.16a_Emergency">
	</data>
	

        <data id="MASSM5.1.17_ReturnToWorkDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.DisabilityEndDate1'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 9, 2)"/>
	  </xsl:if>
        </data>

        
        <data id="MASSM5.1.18_TotalDisabilityBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.DisabilityBeginDate1'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityBeginDate1''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityBeginDate1''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityBeginDate1''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.18_TotalDisabilityEndDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.DisabilityEndDate1'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 9, 2)"/>
	  </xsl:if>
        </data>

	<data id="MASSM5.1.18_PartialDisabilityBeginDate">
	</data>
	<data id="MASSM5.1.18_PartialDisabilityEndDate">
	</data>
	
        <data id="MASSM5.1.19a_ReferringPhyscianName">
          <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''MASSM5.1.ReferringProviderMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ReferringProviderMiddleName1''],1,1)"/>
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''MASSM5.1.ReferringProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderDegree1'']"/>
          </xsl:if>
        </data>	
        
        <data id="MASSM5.1.19b_ReferringProviderUPIN">
	          <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderIDNumber1'']"/>
        </data>
	
	<data id="MASSM5.1.20_HospitalizationBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.HospitalizationBeginDate1'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationBeginDate1''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationBeginDate1''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationBeginDate1''], 9, 2)"/>
	  </xsl:if>
	</data>
	<data id="MASSM5.1.20_HospitalizationEndDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.HospitalizationEndDate1'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationEndDate1''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationEndDate1''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationEndDate1''], 9, 2)"/>
	  </xsl:if>
        </data>
        
        <data id="MASSM5.1.21_FacilityName">
        	<xsl:if test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''99''">
        		<xsl:value-of select="data[@id=''MASSM5.1.FacilityName1'']"/>
        		<xsl:text>, </xsl:text>
			<xsl:value-of select="data[@id=''MASSM5.1.FacilityStreet11'']"/>
			<xsl:if test="string-length(data[@id=''MASSM5.1.FacilityStreet21'']) &gt; 0">
			  <xsl:text>, </xsl:text>
			  <xsl:value-of select="data[@id=''MASSM5.1.FacilityStreet21'']"/>
			</xsl:if>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="data[@id=''MASSM5.1.FacilityCity1'']"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="data[@id=''MASSM5.1.FacilityState1'']"/>
			<xsl:text xml:space="preserve"> </xsl:text>
			<xsl:choose>
				<xsl:when test="string-length(data[@id=''MASSM5.1.FacilityZip1'']) = 9">
					<xsl:value-of select="substring(data[@id=''MASSM5.1.FacilityZip1''], 1, 5)"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="substring(data[@id=''MASSM5.1.FacilityZip1''], 6, 4)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="data[@id=''MASSM5.1.FacilityZip1'']"/>
				</xsl:otherwise>
			</xsl:choose>        		
        	</xsl:if>
        </data>
        
        <data id="MASSM5.1.22_LabWork_External_YES">
        </data>
        <data id="MASSM5.1.22_LabWork_External_NO">
        </data>
	<data id="MASSM5.1.22_LabWork_External_Charges">
	</data>
	
	<data id="MASSM5.1.23a_Diagnosis1">
	  <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode11'']"/>
	</data>
	<data id="MASSM5.1.23a_Diagnosis2">
	  <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode21'']"/>
	</data>
	<data id="MASSM5.1.23a_Diagnosis3">
	  <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode31'']"/>
	</data>
	<data id="MASSM5.1.23a_Diagnosis4">
	  <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode41'']"/>
	</data>
	
	<data id="MASSM5.1.23b_Screen" />
	<data id="MASSM5.1.23b_Referral" />
	<data id="MASSM5.1.23c_FamilyPlanning" />
	
	
        <data id="MASSM5.1.23d_AuthorizationNumber">
            <xsl:value-of select="data[@id=''MASSM5.1.AuthorizationNumber1'']"/>
        </data>
	
	
        <data id="MASSM5.1.25_PhysicianSignature">
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.RenderingProviderMiddleName1''], 1, 1)"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''MASSM5.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderDegree1'']"/>
          </xsl:if>
        </data>	
	
        <data id="MASSM5.1.25_PhysicianSignatureCurrentDate">
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 1, 2)"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 4, 2)"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 9, 2)"/>
        </data>	
        
        <data id="MASSM5.1.26_Accept_YES" />
        <data id="MASSM5.1.26_Accept_NO" />
        
        
        <data id="MASSM5.1.27_TotalCharge_Dollars">
          <xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''MASSM5.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))"/>
          <xsl:value-of select="$charges-dollars"/>
        </data>
        <data id="MASSM5.1.27_TotalCharge_Cents">
          <xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''MASSM5.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$charges-cents"/>
        </data>
        
        <data id="MASSM5.1.28_TotalPaid_Dollars">
          <xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''MASSM5.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))"/>
          <xsl:value-of select="$paid-dollars"/>
        </data>
        <data id="MASSM5.1.28_TotalPaid_Cents">
          <xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''MASSM5.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$paid-cents"/>
        </data>
        
      
        <data id="MASSM5.1.29_TotalBalance_Dollars">
          <xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''MASSM5.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))"/>
          <xsl:value-of select="$balance-dollars"/>
        </data>
        <data id="MASSM5.1.29_TotalBalance_Cents">
          <xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''MASSM5.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$balance-cents"/>
        </data>
        
        <data id="MASSM5.1.30_ServicingProviderNumber">
	          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderIndividualNumber1'']"/>
        </data>
        
        
        <data id="MASSM5.1.31_PhysicianName">
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.RenderingProviderMiddleName1''], 1, 1)"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''MASSM5.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderDegree1'']"/>
          </xsl:if>
        </data>	        
        <data id="MASSM5.1.31_PhysicianAddress">
          <xsl:value-of select="data[@id=''MASSM5.1.PracticeStreet11'']"/>
          <xsl:if test="string-length(data[@id=''MASSM5.1.PracticeStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.PracticeStreet21'']"/>
          </xsl:if>
        </data>
        <data id="MASSM5.1.31_PhysicianCityStateZip">
          <xsl:value-of select="data[@id=''MASSM5.1.PracticeCity1'']"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.PracticeState1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM5.1.PracticeZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticeZip1''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticeZip1''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PracticeZip1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>        
        <data id="MASSM5.1.31_PhysicianTelephone">
	          <xsl:text>(</xsl:text>
	          <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticePhone1''], 1, 3)"/>
	          <xsl:text xml:space="preserve">) </xsl:text>
	          <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticePhone1''], 4, 3)"/>
	          <xsl:text>-</xsl:text>
	          <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticePhone1''], 7, 4)"/>
        </data>
        
        <data id="MASSM5.1.31_PhysicianProviderNo">
	          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderGroupNumber1'']"/>
        </data>

        <data id="MASSM5.1.32_PatientID">
	          <xsl:value-of select="data[@id=''MASSM5.1.PatientID1'']"/>
        </data>

        <data id="MASSM5.1.33_BillingAgentNumber" />
        


       <!-- Procedure 1 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID1'']"/>
        </ClaimID>
        <data id="MASSM5.1.24a_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate1''], 1, 2)"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate1''], 4, 2)"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate1''], 9, 2)"/>
          </xsl:if>
        </data>
        <data id="MASSM5.1.24a_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate1''] = data[@id=''MASSM5.1.ServiceEndDate1'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate1'']) &gt; 0)">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate1''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate1''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate1''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24a_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode1'']"/>
        </data>
        <data id="MASSM5.1.24a_cTypeOfServiceCode" />
        <data id="MASSM5.1.24a_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode1'']"/>
        </data>
        <data id="MASSM5.1.24a_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier11'']"/>
        </data>
        <data id="MASSM5.1.24a_cProcedureExplanation"/>
        <data id="MASSM5.1.24a_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code1'']"/>
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount1''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24a_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM5.1.24a_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>
          <data id="MASSM5.1.24a_fServiceUnitCount">
            <xsl:value-of select="format-number(data[@id=''MASSM5.1.ServiceUnitCount1''], ''0.0'', ''default-format'')"/>
          </data>
          <data id="MASSM5.1.24a_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM5.1.24a_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
       <!-- Procedure 2 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID2'']"/>
        </ClaimID>
        <data id="MASSM5.1.24b_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate2'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate2''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate2''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate2''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24b_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate2''] = data[@id=''MASSM5.1.ServiceEndDate2'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate2'']) &gt; 0)">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate2''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate2''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate2''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24b_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode2'']"/>
        </data>
        <data id="MASSM5.1.24b_cTypeOfServiceCode" />
        <data id="MASSM5.1.24b_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode2'']"/>
        </data>
        <data id="MASSM5.1.24b_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier12'']"/>
        </data>
        <data id="MASSM5.1.24b_cProcedureExplanation"/>
        <data id="MASSM5.1.24b_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code2'']"/>
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount2''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24b_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM5.1.24b_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>
          <data id="MASSM5.1.24b_fServiceUnitCount">
            <xsl:value-of select="format-number(data[@id=''MASSM5.1.ServiceUnitCount2''], ''0.0'', ''default-format'')"/>
          </data>
          <data id="MASSM5.1.24b_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM5.1.24b_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
       <!-- Procedure 3 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID3'']"/>
        </ClaimID>
        <data id="MASSM5.1.24c_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate3'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate3''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate3''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate3''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24c_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate3''] = data[@id=''MASSM5.1.ServiceEndDate3'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate3'']) &gt; 0)">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate3''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate3''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate3''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24c_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode3'']"/>
        </data>
        <data id="MASSM5.1.24c_cTypeOfServiceCode" />
        <data id="MASSM5.1.24c_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode3'']"/>
        </data>
        <data id="MASSM5.1.24c_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier13'']"/>
        </data>
        <data id="MASSM5.1.24c_cProcedureExplanation"/>
        <data id="MASSM5.1.24c_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code3'']"/>
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount3''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24c_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM5.1.24c_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>
          <data id="MASSM5.1.24c_fServiceUnitCount">
            <xsl:value-of select="format-number(data[@id=''MASSM5.1.ServiceUnitCount3''], ''0.0'', ''default-format'')"/>
          </data>
          <data id="MASSM5.1.24c_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM5.1.24c_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
       <!-- Procedure 4 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID4'']"/>
        </ClaimID>
        <data id="MASSM5.1.24d_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate4'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate4''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate4''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate4''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24d_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate4''] = data[@id=''MASSM5.1.ServiceEndDate4'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate4'']) &gt; 0)">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate4''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate4''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate4''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24d_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode4'']"/>
        </data>
        <data id="MASSM5.1.24d_cTypeOfServiceCode" />
        <data id="MASSM5.1.24d_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode4'']"/>
        </data>
        <data id="MASSM5.1.24d_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier14'']"/>
        </data>
        <data id="MASSM5.1.24d_cProcedureExplanation"/>
        <data id="MASSM5.1.24d_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code4'']"/>
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount4''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24d_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM5.1.24d_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>
          <data id="MASSM5.1.24d_fServiceUnitCount">
            <xsl:value-of select="format-number(data[@id=''MASSM5.1.ServiceUnitCount4''], ''0.0'', ''default-format'')"/>
          </data>
          <data id="MASSM5.1.24d_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM5.1.24d_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
       <!-- Procedure 5 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID5'']"/>
        </ClaimID>
        <data id="MASSM5.1.24e_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate5'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate5''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate5''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate5''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24e_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate5''] = data[@id=''MASSM5.1.ServiceEndDate5'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate5'']) &gt; 0)">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate5''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate5''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate5''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24e_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode5'']"/>
        </data>
        <data id="MASSM5.1.24e_cTypeOfServiceCode" />
        <data id="MASSM5.1.24e_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode5'']"/>
        </data>
        <data id="MASSM5.1.24e_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier15'']"/>
        </data>
        <data id="MASSM5.1.24e_cProcedureExplanation"/>
        <data id="MASSM5.1.24e_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code5'']"/>
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount5''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24e_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM5.1.24e_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>
          <data id="MASSM5.1.24e_fServiceUnitCount">
            <xsl:value-of select="format-number(data[@id=''MASSM5.1.ServiceUnitCount5''], ''0.0'', ''default-format'')"/>
          </data>
          <data id="MASSM5.1.24e_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM5.1.24e_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
       <!-- Procedure 6 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID6'']"/>
        </ClaimID>
        <data id="MASSM5.1.24f_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate6'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate6''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate6''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate6''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24f_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate6''] = data[@id=''MASSM5.1.ServiceEndDate6'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate6'']) &gt; 0)">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate6''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate6''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate6''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24f_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode6'']"/>
        </data>
        <data id="MASSM5.1.24f_cTypeOfServiceCode" />
        <data id="MASSM5.1.24f_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode6'']"/>
        </data>
        <data id="MASSM5.1.24f_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier16'']"/>
        </data>
        <data id="MASSM5.1.24f_cProcedureExplanation"/>
        <data id="MASSM5.1.24f_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code6'']"/>
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount6''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24f_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM5.1.24f_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>
          <data id="MASSM5.1.24f_fServiceUnitCount">
            <xsl:value-of select="format-number(data[@id=''MASSM5.1.ServiceUnitCount6''], ''0.0'', ''default-format'')"/>
          </data>
          <data id="MASSM5.1.24f_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM5.1.24f_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
       <!-- Procedure 7 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID7'']"/>
        </ClaimID>
        <data id="MASSM5.1.24g_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate7'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate7''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate7''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate7''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24g_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate7''] = data[@id=''MASSM5.1.ServiceEndDate7'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate7'']) &gt; 0)">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate7''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate7''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate7''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24g_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode7'']"/>
        </data>
        <data id="MASSM5.1.24g_cTypeOfServiceCode" />
        <data id="MASSM5.1.24g_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode7'']"/>
        </data>
        <data id="MASSM5.1.24g_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier17'']"/>
        </data>
        <data id="MASSM5.1.24g_cProcedureExplanation"/>
        <data id="MASSM5.1.24g_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code7'']"/>
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount7''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24g_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount7''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM5.1.24g_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>
          <data id="MASSM5.1.24g_fServiceUnitCount">
            <xsl:value-of select="format-number(data[@id=''MASSM5.1.ServiceUnitCount7''], ''0.0'', ''default-format'')"/>
          </data>
          <data id="MASSM5.1.24g_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount7''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM5.1.24g_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
       <!-- Procedure 8 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID8'']"/>
        </ClaimID>
        <data id="MASSM5.1.24h_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate8'']) &gt; 0">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate8''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate8''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate8''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24h_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate8''] = data[@id=''MASSM5.1.ServiceEndDate8'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate8'']) &gt; 0)">
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate8''], 1, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate8''], 4, 2)"/>
		  <xsl:text>/</xsl:text>
		  <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate8''], 9, 2)"/>
	  </xsl:if>
        </data>
        <data id="MASSM5.1.24h_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode8'']"/>
        </data>
        <data id="MASSM5.1.24h_cTypeOfServiceCode" />
        <data id="MASSM5.1.24h_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode8'']"/>
        </data>
        <data id="MASSM5.1.24h_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier18'']"/>
        </data>
        <data id="MASSM5.1.24h_cProcedureExplanation"/>
        <data id="MASSM5.1.24h_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code8'']"/>
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount8''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24h_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount8''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM5.1.24h_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount8''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>
          <data id="MASSM5.1.24h_fServiceUnitCount">
            <xsl:value-of select="format-number(data[@id=''MASSM5.1.ServiceUnitCount8''], ''0.0'', ''default-format'')"/>
          </data>
          <data id="MASSM5.1.24h_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount8''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM5.1.24h_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount8''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>

      </page>
    </formData>
  </xsl:template>
</xsl:stylesheet>'
WHERE BillingFormID=10

GO

/*-----------------------------------------------------------------------------
	Case 5176: Migrate "Coding Forms" terminology to "Encounter Forms"
-----------------------------------------------------------------------------*/

/* CREATE [EncounterTemplate] */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EncounterTemplate]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EncounterTemplate]
GO

CREATE TABLE [dbo].[EncounterTemplate] (
	[EncounterTemplateID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL ,
	[PracticeID] [int] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* COPY [CodingTemplate] rows to [EncounterTemplate] */

SET IDENTITY_INSERT EncounterTemplate ON

INSERT INTO EncounterTemplate (
	EncounterTemplateID, 
	CreatedDate, 
	CreatedUserID, 
	[Description], 
	ModifiedDate, 
	ModifiedUserID, 
	[Name], 
	PracticeID )
SELECT	CodingTemplateID, 
	CreatedDate, 
	CreatedUserID, 
	[Description], 
	ModifiedDate, 
	ModifiedUserID, 
	[Name], 
	PracticeID
FROM
	CodingTemplate
ORDER BY
	CodingTemplateID ASC

SET IDENTITY_INSERT EncounterTemplate OFF

/* CREATE [DiagnosisCodeDictionaryToEncounterTemplate] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DiagnosisCodeDictionaryToEncounterTemplate]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DiagnosisCodeDictionaryToEncounterTemplate]
GO

CREATE TABLE [dbo].[DiagnosisCodeDictionaryToEncounterTemplate] (
	[ID_PK] [int] IDENTITY (1, 1) NOT NULL ,
	[DiagnosisCodeDictionaryID] [int] NOT NULL ,
	[EncounterTemplateID] [int] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL 
) ON [PRIMARY]
GO

/* COPY [DiagnosisCodeDictionaryToCodingTemplate] rows to [DiagnosisCodeDictionaryToEncounterTemplate] */

SET IDENTITY_INSERT DiagnosisCodeDictionaryToEncounterTemplate ON

INSERT INTO [DiagnosisCodeDictionaryToEncounterTemplate] (
	ID_PK, 
	DiagnosisCodeDictionaryID, 
	EncounterTemplateID, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID )
SELECT	ID_PK, 
	DiagnosisCodeDictionaryID, 
	CodingTemplateID, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID
FROM	DiagnosisCodeDictionaryToCodingTemplate
ORDER BY
	ID_PK ASC

SET IDENTITY_INSERT DiagnosisCodeDictionaryToEncounterTemplate OFF

/* DROP foreign keys to [DiagnosisCodeDictionaryToCodingTemplate] and [CodingTemplate] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_DiagnosisCodeDictionaryToCodingTemplate_DiagnosisCodeDictionary]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[DiagnosisCodeDictionaryToCodingTemplate] DROP CONSTRAINT [FK_DiagnosisCodeDictionaryToCodingTemplate_DiagnosisCodeDictionary]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_DiagnosisCodeDictionaryToCodingTemplate_CodingTemplate]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[DiagnosisCodeDictionaryToCodingTemplate] DROP CONSTRAINT FK_DiagnosisCodeDictionaryToCodingTemplate_CodingTemplate
GO

/* DROP foreign keys to [CodingTemplate] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Doctor_CodingTemplate]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Doctor] DROP CONSTRAINT FK_Doctor_CodingTemplate
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProcedureCategory_CodingTemplate]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProcedureCategory] DROP CONSTRAINT FK_ProcedureCategory_CodingTemplate
GO

/* RENAME Doctor.DefaultCodingTemplateID to Doctor.DefaultEncounterTemplateID */

EXECUTE sp_rename N'dbo.Doctor.DefaultCodingTemplateID', N'Tmp_DefaultEncounterTemplateID_3', 'COLUMN'
GO

EXECUTE sp_rename N'dbo.Doctor.Tmp_DefaultEncounterTemplateID_3', N'DefaultEncounterTemplateID', 'COLUMN'
GO

/* RENAME ProcedureCategory.CodingTemplateID to ProcedureCategory.EncounterTemplateID */

EXECUTE sp_rename N'dbo.ProcedureCategory.CodingTemplateID', N'Tmp_EncounterTemplateID_4', 'COLUMN'
GO

EXECUTE sp_rename N'dbo.ProcedureCategory.Tmp_EncounterTemplateID_4', N'EncounterTemplateID', 'COLUMN'
GO

/* ADD constraints to [EncounterTemplate] */

ALTER TABLE [dbo].[EncounterTemplate] WITH NOCHECK ADD 
	CONSTRAINT [PK_EncounterTemplate] PRIMARY KEY  CLUSTERED 
	(
		[EncounterTemplateID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[EncounterTemplate] ADD 
	CONSTRAINT [DF_EncounterTemplate_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_EncounterTemplate_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_EncounterTemplate_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_EncounterTemplate_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

ALTER TABLE [dbo].[Doctor] ADD CONSTRAINT [FK_Doctor_EncounterTemplate] FOREIGN KEY 
	(
		[DefaultEncounterTemplateID]
	) REFERENCES [EncounterTemplate] (
		[EncounterTemplateID]
	)
GO

ALTER TABLE [dbo].[ProcedureCategory] ADD CONSTRAINT [FK_ProcedureCategory_EncounterTemplate] FOREIGN KEY 
	(
		[EncounterTemplateID]
	) REFERENCES [EncounterTemplate] (
		[EncounterTemplateID]
	)
GO

/* ADD constraints to [DiagnosisCodeDictionaryToEncounterTemplate] */

ALTER TABLE [dbo].[DiagnosisCodeDictionaryToEncounterTemplate] WITH NOCHECK ADD 
	CONSTRAINT [PK_DiagnosisCodeDictionaryToEncounterTemplate] PRIMARY KEY  CLUSTERED 
	(
		[ID_PK]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DiagnosisCodeDictionaryToEncounterTemplate] ADD 
	CONSTRAINT [DF_DiagnosisCodeDictionaryToEncounterTemplate_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_DiagnosisCodeDictionaryToEncounterTemplate_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_DiagnosisCodeDictionaryToEncounterTemplate_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_DiagnosisCodeDictionaryToEncounterTemplate_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

ALTER TABLE [dbo].[DiagnosisCodeDictionaryToEncounterTemplate] ADD 
	CONSTRAINT [FK_DiagnosisCodeDictionaryToEncounterTemplate_EncounterTemplate] FOREIGN KEY 
	(
		[EncounterTemplateID]
	) REFERENCES [dbo].[EncounterTemplate] (
		[EncounterTemplateID]
	),
	CONSTRAINT [FK_DiagnosisCodeDictionaryToEncounterTemplate_DiagnosisCodeDictionary] FOREIGN KEY 
	(
		[DiagnosisCodeDictionaryID]
	) REFERENCES [dbo].[DiagnosisCodeDictionary] (
		[DiagnosisCodeDictionaryID]
	)
GO

/* DROP [DiagnosisCodeDictionaryToCodingTemplate] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DiagnosisCodeDictionaryToCodingTemplate]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DiagnosisCodeDictionaryToCodingTemplate]
GO

/* DROP [CodingTemplate] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CodingTemplate]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CodingTemplate]
GO


/*-----------------------------------------------------------------------------
	Case 7685 - Add flag to PrintingFormDetail table to denote if the 
		    SVGDefinition is a transform
-----------------------------------------------------------------------------*/

ALTER TABLE [dbo].[PrintingFormDetails] ADD
	SVGTransform BIT
GO

ALTER TABLE [dbo].[PrintingFormDetails] ADD CONSTRAINT
	DF_PrintingFormDetails_SVGTransform DEFAULT 0 FOR SVGTransform
GO

UPDATE 	PrintingFormDetails
SET 	SVGTransform = 0

ALTER TABLE [dbo].[PrintingFormDetails] ALTER COLUMN
	SVGTransform BIT NOT NULL
GO



/*-----------------------------------------------------------------------------
	Case 7571 - Change document data model to store pages separately
-----------------------------------------------------------------------------*/

/* CREATE table [DocumentLabelType] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DocumentLabelType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DocumentLabelType]
GO

CREATE TABLE [dbo].[DocumentLabelType] (
	[DocumentLabelTypeID] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SortOrder] [int] NOT NULL 
) ON [PRIMARY]
GO

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 1,
	'Document Batch',
	'Document Batch',
	1 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 2,
	'Explanation of Benefits (EOB)',
	'Explanation of Benefits (EOB)',
	2 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 3,
	'Insurance Correspondence',
	'Insurance Correspondence',
	3 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 4,
	'Medical Report',
	'Medical Report',
	4 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 5,
	'Patient Authorization/Referral',
	'Patient Authorization/Referral',
	5 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 6,
	'Patient Correspondence',
	'Patient Correspondence',
	6 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 7,
	'Patient Demographics',
	'Patient Demographics',
	7 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 8,
	'Patient Driver’s License',
	'Patient Driver’s License',
	8 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 9,
	'Patient Insurance Card',
	'Patient Insurance Card',
	9 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 10,
	'Payment Batch',
	'Payment Batch',
	10 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 11,
	'Superbill',
	'Superbill',
	11 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 12,
	'Superbill Batch',
	'Superbill Batch',
	12 )

INSERT INTO DocumentLabelType (
	DocumentLabelTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 13,
	'Other',
	'Other',
	13 )

GO

ALTER TABLE [dbo].[DocumentLabelType] WITH NOCHECK ADD 
	CONSTRAINT [PK_DocumentLabelType] PRIMARY KEY  CLUSTERED 
	(
		[DocumentLabelTypeID]
	)  ON [PRIMARY] 
GO

/* CREATE table [DocumentStatusType] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DocumentStatusType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DocumentStatusType]
GO

CREATE TABLE [dbo].[DocumentStatusType] (
	[DocumentStatusTypeID] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SortOrder] [int] NOT NULL 
) ON [PRIMARY]
GO

INSERT INTO DocumentStatusType (
	DocumentStatusTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 1, 
	'New', 
	'New', 
	1 )

INSERT INTO DocumentStatusType (
	DocumentStatusTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 2, 
	'Processed', 
	'Processed', 
	2 )
	
INSERT INTO DocumentStatusType (
	DocumentStatusTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 3, 
	'Error', 
	'Error', 
	3 )	

GO

ALTER TABLE [dbo].[DocumentStatusType] WITH NOCHECK ADD 
	CONSTRAINT [PK_DocumentStatusType] PRIMARY KEY  CLUSTERED 
	(
		[DocumentStatusTypeID]
	)  ON [PRIMARY] 
GO

/* CREATE table [PageStatusType] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PageStatusType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PageStatusType]
GO

CREATE TABLE [dbo].[PageStatusType] (
	[PageStatusTypeID] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SortOrder] [int] NOT NULL 
) ON [PRIMARY]
GO

INSERT INTO PageStatusType (
	PageStatusTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 1, 
	'Normal', 
	'Normal', 
	1 )

INSERT INTO PageStatusType (
	PageStatusTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 2, 
	'Error', 
	'Error', 
	2 )

INSERT INTO PageStatusType (
	PageStatusTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 3, 
	'Unprocessed', 
	'Unprocessed', 
	3 )

GO

ALTER TABLE [dbo].[PageStatusType] WITH NOCHECK ADD 
	CONSTRAINT [PK_PageStatusType] PRIMARY KEY  CLUSTERED 
	(
		[PageStatusTypeID]
	)  ON [PRIMARY] 
GO

/* CREATE table [DocumentType] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DocumentType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DocumentType]
GO

CREATE TABLE [dbo].[DocumentType] (
	[DocumentTypeID] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SortOrder] [int] NOT NULL 
) ON [PRIMARY]
GO

INSERT INTO DocumentType (
	DocumentTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 1, 
	'Scan', 
	'Scan', 
	1 )

INSERT INTO DocumentType (
	DocumentTypeID, 
	[Name], 
	[Description], 
	SortOrder )
VALUES ( 2, 
	'File', 
	'File', 
	2 )

GO

ALTER TABLE [dbo].[DocumentType] WITH NOCHECK ADD 
	CONSTRAINT [PK_DocumentType] PRIMARY KEY  CLUSTERED 
	(
		[DocumentTypeID]
	)  ON [PRIMARY] 
GO

/* CREATE table [DMSDocument] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DMSDocument]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DMSDocument]
GO

CREATE TABLE [dbo].[DMSDocument] (
	[DMSDocumentID] [int] IDENTITY (1, 1) NOT NULL ,
	[DocumentName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DocumentLabelTypeID] [int] NOT NULL ,
	[DocumentStatusTypeID] [int] NOT NULL ,
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Properties] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OriginalDMSDocumentID] [int] NULL ,
	[DocumentTypeID] [int] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[DMSDocument] WITH NOCHECK ADD 
	CONSTRAINT [PK_DMSDocument] PRIMARY KEY  CLUSTERED 
	(
		[DMSDocumentID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DMSDocument] ADD 
	CONSTRAINT [DF_DMSDocument_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_DMSDocument_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_DMSDocument_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_DMSDocument_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

/* CREATE new [DMSFileInfo] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TempDMSFileInfo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TempDMSFileInfo]
GO

CREATE TABLE [dbo].[TempDMSFileInfo] (
	[DMSFileInfoID] [int] IDENTITY (1, 1) NOT NULL ,
	[DMSFileInfoKey] [uniqueidentifier] NOT NULL ,
	[DMSDocumentID] [int] NOT NULL ,
	[PageStatusTypeID] [int] NOT NULL ,
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SortOrder] [int] NOT NULL,
	[UploaderUserID] [int] NULL ,
	[Ext] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileName] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MimeType] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SizeInBytes] [decimal](15, 0) NULL ,
	[OriginalFilename] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FileCreatedDate] [datetime] NULL ,
	[FileModifiedDate] [datetime] NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Populate DMSDocument and DMSFileInfo table */

CREATE TABLE #TempDMSDocument (
	[TempDMSDocumentID] [int] IDENTITY (1, 1) NOT NULL, 
	[FileInfoKey] [uniqueidentifier] NOT NULL )

GO

/* Create DMSDocumentIDs */
INSERT INTO #TempDMSDocument ( 
	FileInfoKey )
SELECT 	DFI.FileInfoKey
FROM	DMSFileInfo DFI
ORDER BY DFI.CreatedDate ASC

/* Create new DMSFileInfo rows from existing DMSFileInfo rows */

DECLARE @PageStatusTypeID INT

SELECT 	@PageStatusTypeID = PageStatusTypeID 
FROM 	PageStatusType
WHERE	[Name] = 'Normal'

INSERT INTO TempDMSFileInfo (
	[DMSFileInfoKey],
	[DMSDocumentID],
	[PageStatusTypeID],
	[Notes],
	[SortOrder],
	[UploaderUserID],
	[Ext],
	[FileName],
	[MimeType],
	[SizeInBytes],
	[OriginalFilename],
	[FileCreatedDate],
	[FileModifiedDate],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID] )
SELECT	DFI.[FileInfoKey],
	DMSD.TempDMSDocumentID,
	@PageStatusTypeID,
	DFI.[Notes],
	1,
	DFI.[UploaderUserID],
	DFI.[Ext],
	DFI.[FileName],
	DFI.[MimeType],
	DFI.[SizeInBytes],
	DFI.[OriginalFilename],
	DFI.[FileCreatedDate],
	DFI.[FileModifiedDate],
	DFI.[CreatedDate],
	DFI.[CreatedUserID],
	DFI.[ModifiedDate],
	DFI.[ModifiedUserID]
FROM	#TempDMSDocument DMSD
	JOIN DMSFileInfo DFI
		ON DFI.FileInfoKey = DMSD.FileInfoKey

GO

/* DROP old [DMSFileInfo] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_DMSFileToRecordAssociation_DMSFileInfo]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[DMSFileToRecordAssociation] DROP CONSTRAINT FK_DMSFileToRecordAssociation_DMSFileInfo
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[DMSFileInfo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [DMSFileInfo]
GO

/* RENAME [TempDMSFileInfo] to [DMSFileInfo] */

EXEC sp_rename 'TempDMSFileInfo', 'DMSFileInfo'
GO

/* ADD DMSFileInfo constraints */

ALTER TABLE [dbo].[DMSFileInfo] WITH NOCHECK ADD 
	CONSTRAINT [PK_DMSFileInfo] PRIMARY KEY  CLUSTERED 
	(
		[DMSFileInfoID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DMSFileInfo] ADD 
	CONSTRAINT [DF_DMSFileInfo_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_DMSFileInfo_CreatUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_DMSFileInfo_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_DMSFileInfo_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

/* Create new DMSDocument rows */

DECLARE @DocumentLabelTypeID INT,
	@DocumentStatusTypeID INT

SELECT	@DocumentLabelTypeID = DocumentLabelTypeID
FROM	DocumentLabelType
WHERE 	[Name] = 'Other'

SELECT 	@DocumentStatusTypeID = DocumentStatusTypeID
FROM	DocumentStatusType
WHERE	[Name] = 'Processed'

SET IDENTITY_INSERT DMSDocument ON

INSERT INTO DMSDocument (
	DMSDocumentID, 
	DocumentName, 
	DocumentLabelTypeID, 
	DocumentStatusTypeID, 
	Notes, 
	DocumentTypeID,
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID )
SELECT	DFI.DMSDocumentID,
	DFI.[FileName],
	@DocumentLabelTypeID,
	@DocumentStatusTypeID,
	DFI.Notes,
	2,
	DFI.CreatedDate,
	DFI.CreatedUserID,
	DFI.ModifiedDate,
	DFI.ModifiedUserID
FROM	DMSFileInfo DFI

SET IDENTITY_INSERT DMSDocument OFF

GO

/* CREATE table [DMSDocumentToRecordAssociation] */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DMSDocumentToRecordAssociation]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DMSDocumentToRecordAssociation]
GO

CREATE TABLE [dbo].[DMSDocumentToRecordAssociation] (
	[DMSDocumentID] [int] NOT NULL ,
	[RecordID] [int] NOT NULL ,
	[RecordTypeID] [int] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DMSDocumentToRecordAssociation] WITH NOCHECK ADD 
	CONSTRAINT [PK_DMSDocumentToRecordAssociation] PRIMARY KEY  CLUSTERED 
	(
		[DMSDocumentID],
		[RecordID],
		[RecordTypeID]
	)  ON [PRIMARY] 
GO

/* COPY rows from [DMSFileToRecordAssociation] to [DMSDocumentToRecordAssociation] */

INSERT INTO DMSDocumentToRecordAssociation (
	DMSDocumentID, 
	RecordID, 
	RecordTypeID, 
	ModifiedUserID, 
	ModifiedDate, 
	CreatedUserID, 
	CreatedDate )
SELECT	DMSD.TempDMSDocumentID,
	DFTRA.RecordID,
	DFTRA.RecordTypeID,
	DFTRA.ModifiedUserID,
	DFTRA.ModifiedDate,
	DFTRA.CreatedUserID,
	DFTRA.CreatedDate
FROM	#TempDMSDocument DMSD
	JOIN DMSFileToRecordAssociation DFTRA
		ON DFTRA.FileInfoKey = DMSD.FileInfoKey

GO

DROP TABLE #TempDMSDocument

GO

ALTER TABLE dbo.DMSDocumentToRecordAssociation ADD CONSTRAINT
	DF_DMSDocumentToRecordAssociation_ModifiedUserID DEFAULT 0 FOR ModifiedUserID
GO

ALTER TABLE dbo.DMSDocumentToRecordAssociation ADD CONSTRAINT
	DF_DMSDocumentToRecordAssociation_ModifiedDate DEFAULT GetDate() FOR ModifiedDate
GO

ALTER TABLE dbo.DMSDocumentToRecordAssociation ADD CONSTRAINT
	DF_DMSDocumentToRecordAssociation_CreatedUserID DEFAULT 0 FOR CreatedUserID
GO

ALTER TABLE dbo.DMSDocumentToRecordAssociation ADD CONSTRAINT
	DF_DMSDocumentToRecordAssociation_CreatedDate DEFAULT GetDate() FOR CreatedDate
GO

/* ADD foreign key constraints */

ALTER TABLE dbo.DMSDocument ADD CONSTRAINT
	FK_DMSDocument_DocumentLabelType FOREIGN KEY
	(
	DocumentLabelTypeID
	) REFERENCES dbo.DocumentLabelType
	(
	DocumentLabelTypeID
	)
GO

ALTER TABLE dbo.DMSDocument ADD CONSTRAINT
	FK_DMSDocument_DocumentStatusType FOREIGN KEY
	(
	DocumentStatusTypeID
	) REFERENCES dbo.DocumentStatusType
	(
	DocumentStatusTypeID
	)
GO

ALTER TABLE dbo.DMSDocument ADD CONSTRAINT
	FK_DMSDocument_DocumentType FOREIGN KEY
	(
	DocumentTypeID
	) REFERENCES dbo.DocumentType
	(
	DocumentTypeID
	)
GO

ALTER TABLE dbo.DMSFileInfo ADD CONSTRAINT
	FK_DMSFileInfo_DMSDocument FOREIGN KEY
	(
	DMSDocumentID
	) REFERENCES dbo.DMSDocument
	(
	DMSDocumentID
	)
GO

ALTER TABLE dbo.DMSFileInfo ADD CONSTRAINT
	FK_DMSFileInfo_PageStatusType FOREIGN KEY
	(
	PageStatusTypeID
	) REFERENCES dbo.PageStatusType
	(
	PageStatusTypeID
	)
GO

ALTER TABLE dbo.DMSDocumentToRecordAssociation ADD CONSTRAINT
	FK_DMSDocumentToRecordAssociation_DMSDocument FOREIGN KEY
	(
	DMSDocumentID
	) REFERENCES dbo.DMSDocument
	(
	DMSDocumentID
	)
GO

ALTER TABLE dbo.DMSDocumentToRecordAssociation ADD CONSTRAINT
	FK_DMSDocumentToRecordAssociation_DMSRecordType FOREIGN KEY
	(
	RecordTypeID
	) REFERENCES dbo.DMSRecordType
	(
	RecordTypeID
	)
GO

/* DROP [DMSFileToRecordAssociation] table */

if exists (select * from dbo.sysobjects where id = object_id(N'[DMSFileToRecordAssociation]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [DMSFileToRecordAssociation]

GO

/*-----------------------------------------------------------------------------
	Case 7672 - Add table to hold the different encounter form types
-----------------------------------------------------------------------------*/

-- Add new EncounterFormType
CREATE TABLE [dbo].[EncounterFormType] (
	EncounterFormTypeID INT NOT NULL CONSTRAINT PK_EncounterFormType_EncounterFormTypeID 
		PRIMARY KEY NONCLUSTERED,
	Name varchar(50) NOT NULL, 
	Description varchar(128) NOT NULL ,
	SortOrder int NOT NULL
)
GO

-- Insert two new encounter form types
INSERT 	EncounterFormType
	(EncounterFormTypeID,
	Name,
	Description,
	SortOrder)
VALUES	(1,
	'One Page',
	'Encounter form that prints on a single page',
	1)

INSERT 	EncounterFormType
	(EncounterFormTypeID,
	Name,
	Description,
	SortOrder)
VALUES	(2,
	'Two Page',
	'Encounter form that prints on two pages',
	2)

-- Add encounter form type to encounter template table
ALTER TABLE [dbo].[EncounterTemplate] ADD
	EncounterFormTypeID int 
GO

-- Add foreign key in Encounter Template
ALTER TABLE [dbo].[EncounterTemplate] ADD CONSTRAINT
	FK_EncounterTemplate_EncounterFormType FOREIGN KEY
	(
	EncounterFormTypeID
	) REFERENCES dbo.EncounterFormType
	(
	EncounterFormTypeID
	)
GO

-- Update existing records
UPDATE	EncounterTemplate
SET	EncounterFormTypeID = 2

-- Add encounter form type to encounter template table
ALTER TABLE [dbo].[EncounterTemplate] 
	ALTER COLUMN EncounterFormTypeID int NOT NULL
GO

/*-----------------------------------------------------------------------------
	Case 7675 - Handle SVG Encounter Form Printing
-----------------------------------------------------------------------------*/

-- Add a column to the Document table to hold additional parameters necessary for encounter form printing
-- (encounter template id, appointment date)
ALTER TABLE [dbo].[Document] ADD
	DocumentParameters text
GO

-- Add a printing form and printing details for Encounter Form
INSERT	PrintingForm(
	PrintingFormID,
	Name,
	Description,
	StoredProcedureName,
	RecipientSpecific)
VALUES	(9,
	'Encounter Form',
	'Encounter Form',
	'AppointmentDataProvider_GetEncounterFormData',
	0)

INSERT	PrintingFormDetails(
	PrintingFormDetailsID,
	PrintingFormID,
	SVGDefinitionID,
	Description,
	SVGDefinition,
	SVGTransform)
VALUES	(12,
	9,
	1,
	'Encounter Form (One Page)',
	'<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="default-format" NaN="0.00" />

  <!--  
        Takes in the number of rows allowed per column and the number of columns to process.
        Loops through each detail element to print.
        If this is a new category print the category in addition to the detail element.
        Keep track of how many rows have been printed.
        Once the row meets the total number of rows for a column move to the next column.
        Don''t print a category on the last row in a column.
        
        Parameters:
        maximumRowsInColumn - max number of rows allowed in a column
        maximumColumns - max number of columns to process
        totalElements - total number of elements to process
        currentElement - index of current element being processed
        currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)
        currentColumn - 1 based index of current column being processed (mainly used for offsetting x location)
        currentCategory - index of the current category being processed (once this changes we print out the category again)
        
  -->
  <xsl:template name="CreateProcedureColumnLayout">

    <xsl:param name="maximumRowsInColumn"/>
    <xsl:param name="maximumColumns"/>
    <xsl:param name="totalElements"/>
    <xsl:param name="currentElement"/>
    <xsl:param name="currentRow"/>
    <xsl:param name="currentColumn"/>
    <xsl:param name="currentCategory" select="0"/>

    <xsl:variable name="xLeftOffset" select="0.495"/>
    <xsl:variable name="xOffset" select="2.506"/>
    <xsl:variable name="yTopOffset" select="3.143"/>
    <xsl:variable name="yOffset" select=".1067"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".437"/>
    <xsl:variable name="rectangleYOffset" select="0.001"/>

    <xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.ProcedureCategory'', $currentElement)]"/>

      <xsl:choose>
        <xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
          <!-- There isn''t enough room to print on this column -->

          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateProcedureColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement"/>
            <xsl:with-param name="currentRow" select="1"/>
            <xsl:with-param name="currentColumn" select="$currentColumn + 1"/>
            <xsl:with-param name="currentCategory" select="0"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$currentCategory != $CurrentCategoryIndex">
          <!-- The category is not the same but there is enough room on this column so print out the category -->

          <!-- Creates the actual category line -->
          <rect x="{$xLeftOffset + $xOffset * ($currentColumn - 1)}in" y="{$yTopOffset + $yOffset * ($currentRow - 1) + $rectangleYOffset}in" width="2.4975in" height="0.11in" style="fill:black" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" style="fill:white" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateProcedureColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement + 1"/>
            <xsl:with-param name="currentRow" select="$currentRow + 2"/>
            <xsl:with-param name="currentColumn" select="$currentColumn"/>
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- The category is the same and there is enough room on this column so print out the detail -->

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateProcedureColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement + 1"/>
            <xsl:with-param name="currentRow" select="$currentRow + 1"/>
            <xsl:with-param name="currentColumn" select="$currentColumn"/>
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:if>
  </xsl:template>

  <xsl:template name="CreateDiagnosisColumnLayout">

    <xsl:param name="maximumRowsInColumn"/>
    <xsl:param name="maximumRowsInLastColumn"/>
    <xsl:param name="maximumColumns"/>
    <xsl:param name="totalElements"/>
    <xsl:param name="currentElement"/>
    <xsl:param name="currentRow"/>
    <xsl:param name="currentColumn"/>
    <xsl:param name="currentCategory" select="0"/>

    <xsl:variable name="xLeftOffset" select="0.495"/>
    <xsl:variable name="xOffset" select="2.506"/>
    <xsl:variable name="yTopOffset" select="7.173"/>
    <xsl:variable name="yOffset" select=".1067"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".437"/>
    <xsl:variable name="rectangleYOffset" select="0.001"/>

    <xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.DiagnosisCategory'', $currentElement)]"/>

      <xsl:choose>
        <xsl:when test="(($currentColumn != $maximumColumns) and
                        (($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)) or
                        ($currentColumn = $maximumColumns) and 
                        (($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInLastColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInLastColumn)))">
          <!-- There isn''t enough room to print on this column -->

          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement"/>
            <xsl:with-param name="currentRow" select="1"/>
            <xsl:with-param name="currentColumn" select="$currentColumn + 1"/>
            <xsl:with-param name="currentCategory" select="0"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$currentCategory != $CurrentCategoryIndex">
          <!-- The category is not the same but there is enough room on this column so print out the category -->

          <!-- Creates the actual category line -->
          <rect x="{$xLeftOffset + $xOffset * ($currentColumn - 1)}in" y="{$yTopOffset + $yOffset * ($currentRow - 1) + $rectangleYOffset}in" width="2.4977in" height="0.11in" style="fill:black" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" style="fill:white" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement + 1"/>
            <xsl:with-param name="currentRow" select="$currentRow + 2"/>
            <xsl:with-param name="currentColumn" select="$currentColumn"/>
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- The category is the same and there is enough room on this column so print out the detail -->

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement + 1"/>
            <xsl:with-param name="currentRow" select="$currentRow + 1"/>
            <xsl:with-param name="currentColumn" select="$currentColumn"/>
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:if>
  </xsl:template>

  <xsl:template match="/formData/page">
    <xsl:variable name="ProcedureCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])"/>
    <xsl:variable name="DiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])"/>
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
      <defs>
        <style type="text/css">
          g
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 9pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          g#Title
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 16pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          text
          {
          baseline-shift: -100%;
          }

          g#ProcedureDetails,g#DiagnosisDetails text
          {
          font-size: 6pt;
          }
        </style>
      </defs>

      <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://8aafe9b3-6236-4142-9a15-f71e928c10aa?type=global"></image>
      <!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="EncounterForm.OnePage.jpg"></image>
-->
      <g id="Title">
        <text x="0.49in" y=".42in" width="5in" height="0.1in" valueSource="EncounterForm.1.TemplateName1" />
      </g>
      <g id="PracticeInformation">
        <text x="0.49in" y=".7in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeName1" />
        <text x="0.49in" y=".85in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeAddress1" />
        <text x="0.49in" y="1in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticePhoneFax1" />
        <text x="0.49in" y="1.15in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeTaxID1" />
      </g>
      <g id="PatientInformation">
        <text x="0.54in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.54in" y="1.75in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine21" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:when>
          <xsl:otherwise>
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:otherwise>
        </xsl:choose>
        <text x="0.54in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientID1" />
        <text x="1.75in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.DOB1" />
      </g>
      <g id="InsuranceCoverage">
        <text x="3.052in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        <text x="3.052in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PrimaryIns1" />
        <text x="3.052in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.SecondaryIns1" />
        <text x="3.052in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Copay1" />
        <text x="4.34in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Deductible1" />
      </g>
      <g id="EncounterInformation">
        <text x="5.565in" y="1.6in" width="1.3in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="5.565in" y="1.9in" width="1.3in" height="0.1in" valueSource="EncounterForm.1.POS1" />
        <text x="6.937in" y="1.9in" width="1.1in" height="0.1in" valueSource="EncounterForm.1.Reason1" />
        <text x="5.565in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.565in" y="2.52in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.RefProvider1" />
      </g>
      <g id="ProcedureDetails">
        <xsl:call-template name="CreateProcedureColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="35"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$ProcedureCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>
      <g id="DiagnosisDetails">
        <xsl:call-template name="CreateDiagnosisColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="22"/>
          <xsl:with-param name="maximumRowsInLastColumn" select="17"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>
      <g id="PreviousAccountBalance">
        <text x="0.537in" y="9.99in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.LastInsPay1" />
        <text x="0.537in" y="10.29in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.77in" y="9.99in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.InsBalance1" />
        <text x="1.77in" y="10.29in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientBalance1" />
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>',
	1)

INSERT	PrintingFormDetails(
	PrintingFormDetailsID,
	PrintingFormID,
	SVGDefinitionID,
	Description,
	SVGDefinition,
	SVGTransform)
VALUES	(13,
	9,
	2,
	'Encounter Form (Two Page) - Page 1',
	'<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="default-format" NaN="0.00" />

  <!--  
        Takes in the number of rows allowed per column and the number of columns to process.
        Loops through each detail element to print.
        If this is a new category print the category in addition to the detail element.
        Keep track of how many rows have been printed.
        Once the row meets the total number of rows for a column move to the next column.
        Don''t print a category on the last row in a column.
        
        Parameters:
        maximumRowsInColumn - max number of rows allowed in a column
        maximumColumns - max number of columns to process
        totalElements - total number of elements to process
        currentElement - index of current element being processed
        currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)
        currentColumn - 1 based index of current column being processed (mainly used for offsetting x location)
        currentCategory - index of the current category being processed (once this changes we print out the category again)
        
  -->
  <xsl:template name="CreateColumnLayout">

    <xsl:param name="maximumRowsInColumn"/>
    <xsl:param name="maximumColumns"/>
    <xsl:param name="totalElements"/>
    <xsl:param name="currentElement"/>
    <xsl:param name="currentRow"/>
    <xsl:param name="currentColumn"/>
    <xsl:param name="currentCategory" select="0"/>

    <xsl:variable name="xLeftOffset" select="0.495"/>
    <xsl:variable name="xOffset" select="2.506"/>
    <xsl:variable name="yTopOffset" select="3.058"/>
    <xsl:variable name="yOffset" select=".1065"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".38"/>
    <xsl:variable name="rectangleYOffset" select="0.001"/>

    <xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.ProcedureCategory'', $currentElement)]"/>

      <xsl:choose>
        <xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
          <!-- There isn''t enough room to print on this column -->

          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement"/>
            <xsl:with-param name="currentRow" select="1"/>
            <xsl:with-param name="currentColumn" select="$currentColumn + 1"/>
            <xsl:with-param name="currentCategory" select="0"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$currentCategory != $CurrentCategoryIndex">
          <!-- The category is not the same but there is enough room on this column so print out the category -->

          <!-- Creates the actual category line -->
          <rect x="{$xLeftOffset + $xOffset * ($currentColumn - 1)}in" y="{$yTopOffset + $yOffset * ($currentRow - 1) + $rectangleYOffset}in" width="2.4975in" height="0.11in" style="fill:black" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.86in" height="0.1in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" style="fill:white" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".35in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.86in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement + 1"/>
            <xsl:with-param name="currentRow" select="$currentRow + 2"/>
            <xsl:with-param name="currentColumn" select="$currentColumn"/>
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- The category is the same and there is enough room on this column so print out the detail -->

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".35in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.86in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement + 1"/>
            <xsl:with-param name="currentRow" select="$currentRow + 1"/>
            <xsl:with-param name="currentColumn" select="$currentColumn"/>
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:if>
  </xsl:template>

  <xsl:template match="/formData/page">
    <xsl:variable name="ProcedureCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])"/>
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
      <defs>
        <style type="text/css">
          g
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 9pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          g#Title
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 16pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          text
          {
          baseline-shift: -100%;
          }

          g#ProcedureDetails text
          {
          font-size: 6pt;
          }
        </style>
      </defs>

      <!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="EncounterForm.TwoPage.1.jpg"></image>
-->
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://7b50a749-38bb-40ac-8850-b495269dfbf0?type=global"></image>

      <g id="Title">
        <text x="0.49in" y=".42in" width="5in" height="0.1in" valueSource="EncounterForm.1.TemplateName1" />
      </g>
      <g id="PracticeInformation">
        <text x="0.49in" y=".7in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeName1" />
        <text x="0.49in" y=".85in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeAddress1" />
        <text x="0.49in" y="1in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticePhoneFax1" />
        <text x="0.49in" y="1.15in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeTaxID1" />
      </g>
      <g id="PatientInformation">
        <text x="0.54in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.54in" y="1.75in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine21" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:when>
          <xsl:otherwise>
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:otherwise>
        </xsl:choose>
        <text x="0.54in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientID1" />
        <text x="1.75in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.DOB1" />
      </g>
      <g id="InsuranceCoverage">
        <text x="3.052in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        <text x="3.052in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PrimaryIns1" />
        <text x="3.052in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.SecondaryIns1" />
        <text x="3.052in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Copay1" />
        <text x="4.34in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Deductible1" />
      </g>
      <g id="EncounterInformation">
        <text x="5.565in" y="1.6in" width="1.3in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="5.565in" y="1.9in" width="1.3in" height="0.1in" valueSource="EncounterForm.1.POS1" />
        <text x="6.937in" y="1.9in" width="1.1in" height="0.1in" valueSource="EncounterForm.1.Reason1" />
        <text x="5.565in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.565in" y="2.52in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.RefProvider1" />
      </g>
      <g id="ProcedureDetails">
        <xsl:call-template name="CreateColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="62"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$ProcedureCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>
      <g id="PreviousAccountBalance">
        <text x="0.537in" y="9.99in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.LastInsPay1" />
        <text x="0.537in" y="10.29in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.77in" y="9.99in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.InsBalance1" />
        <text x="1.77in" y="10.29in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientBalance1" />
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>',
	1)

INSERT	PrintingFormDetails(
	PrintingFormDetailsID,
	PrintingFormID,
	SVGDefinitionID,
	Description,
	SVGDefinition,
	SVGTransform)
VALUES	(14,
	9,
	3,
	'Encounter Form (Two Page) - Page 2',
	'<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="default-format" NaN="0.00" />

  <!--  
        Takes in the number of rows allowed per column and the number of columns to process.
        Loops through each detail element to print.
        If this is a new category print the category in addition to the detail element.
        Keep track of how many rows have been printed.
        Once the row meets the total number of rows for a column move to the next column.
        Don''t print a category on the last row in a column.
        
        Parameters:
        maximumRowsInColumn - max number of rows allowed in a column
        maximumColumns - max number of columns to process
        totalElements - total number of elements to process
        currentElement - index of current element being processed
        currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)
        currentColumn - 1 based index of current column being processed (mainly used for offsetting x location)
        currentCategory - index of the current category being processed (once this changes we print out the category again)
        
  -->
  <xsl:template name="CreateColumnLayout">

    <xsl:param name="maximumRowsInColumn"/>
    <xsl:param name="maximumColumns"/>
    <xsl:param name="totalElements"/>
    <xsl:param name="currentElement"/>
    <xsl:param name="currentRow"/>
    <xsl:param name="currentColumn"/>
    <xsl:param name="currentCategory" select="0"/>

    <xsl:variable name="xLeftOffset" select="0.495"/>
    <xsl:variable name="xOffset" select="2.506"/>
    <xsl:variable name="yTopOffset" select="1.341"/>
    <xsl:variable name="yOffset" select="0.1065"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".437"/>
    <xsl:variable name="rectangleYOffset" select="0.001"/>

    <xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.DiagnosisCategory'', $currentElement)]"/>

      <xsl:choose>
        <xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
          <!-- There isn''t enough room to print on this column -->

          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement"/>
            <xsl:with-param name="currentRow" select="1"/>
            <xsl:with-param name="currentColumn" select="$currentColumn + 1"/>
            <xsl:with-param name="currentCategory" select="0"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$currentCategory != $CurrentCategoryIndex">
          <!-- The category is not the same but there is enough room on this column so print out the category -->

          <!-- Creates the actual category line -->
          <rect x="{$xLeftOffset + $xOffset * ($currentColumn - 1)}in" y="{$yTopOffset + $yOffset * ($currentRow - 1) + $rectangleYOffset}in" width="2.4977in" height="0.11in" style="fill:black" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.8in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" style="fill:white" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.8in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement + 1"/>
            <xsl:with-param name="currentRow" select="$currentRow + 2"/>
            <xsl:with-param name="currentColumn" select="$currentColumn"/>
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- The category is the same and there is enough room on this column so print out the detail -->

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.8in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumColumns" select="$maximumColumns"/>
            <xsl:with-param name="totalElements" select="$totalElements"/>
            <xsl:with-param name="currentElement" select="$currentElement + 1"/>
            <xsl:with-param name="currentRow" select="$currentRow + 1"/>
            <xsl:with-param name="currentColumn" select="$currentColumn"/>
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:if>
  </xsl:template>

  <xsl:template match="/formData/page">
    <xsl:variable name="DiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])"/>
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
      <defs>
        <style type="text/css">
          g
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 8pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          g#DiagnosisDetails text
          {
          font-size: 6pt;
          }

          text
          {
          baseline-shift: -100%;
          }
        </style>
      </defs>

      <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://0dcc6cb1-86a8-456a-9397-968e0e3dd018?type=global"></image>
<!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="EncounterForm.TwoPage.2.jpg"></image>
-->
      <g id="EncounterInformation">
        <text x="0.545in" y=".75in" width=".85in" height="0.1in" valueSource="EncounterForm.1.PatientID1" />
        <text x="1.355in" y=".75in" width="2in" height="0.1in" valueSource="EncounterForm.1.PatientName1" />
        <text x="3.39in" y=".75in" width="2.2in" height="0.1in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.63in" y=".75in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="6.86in" y=".75in" width="1.2in" height="0.1in" valueSource="EncounterForm.1.POS1" />
      </g>
      <g id="DiagnosisDetails">
        <xsl:call-template name="CreateColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="79"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>',
	1)
	
-- Add default bit column to the Business Rule table
ALTER TABLE [dbo].[BusinessRule] ADD
	DefaultRule bit 
GO

IF (SELECT COUNT(*) FROM BusinessRuleProcessingType)=0
BEGIN
	INSERT INTO BusinessRuleProcessingType(BusinessRuleProcessingTypeID, Name)
	VALUES(1,'Claim Processing Rules')
	INSERT INTO BusinessRuleProcessingType(BusinessRuleProcessingTypeID, Name)
	VALUES(2,'Appointment Processing Rules')
END 

GO


-- Loop through all practices and add the default business rule for Encounter Form Printing
DECLARE	@PracticeID INT
DECLARE @i INT
DECLARE @Total INT

SET @PracticeID = 0
SET @i = 1

SELECT	@Total = COUNT(PracticeID)
FROM	Practice

WHILE	@i <= @Total
BEGIN
	SELECT	@PracticeID = MIN(PracticeID)
	FROM	Practice
	WHERE	PracticeID > @PracticeID

	INSERT	BusinessRule(
			PracticeID,
			BusinessRuleProcessingTypeID,
			Name,
			SortOrder,
			ContinueProcessing, 
			BusinessRuleXML,
			DefaultRule
		)
	VALUES	(	@PracticeID,
			2,
			'Encounter Form Default',
			1,
			0, 
			'<?xml version="1.0" encoding="utf-8"?>  <businessRule name="Encounter Form Default">
  <conditions/>
  <actions>
    <action storedProcedure="BusinessRuleEngine_ActionPrintDocuments">
      <parameter>
        <recipient value="1" valueName="Practice"/>
      </parameter>
      <document value="9" valueName="Encounter Form"/>
    </action>
  </actions>
  </businessRule>',
			1)
	
	SET @i = @i + 1
END


/*-----------------------------------------------------------------------------
	Case 7637
-----------------------------------------------------------------------------*/
CREATE TABLE [DiagnosisCategory] (
	[DiagnosisCategoryID] [int] IDENTITY (1, 1) NOT NULL ,
	[EncounterTemplateID] [int] NOT NULL ,
	[Name] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_DiagnosisCategory_CreatedDate] DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_DiagnosisCategory_CreatedUserID] DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_DiagnosisCategory_ModifiedDate] DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_DiagnosisCategory_ModifiedUserID] DEFAULT (0),
	[RecordTimeStamp] [timestamp] NOT NULL ,
	CONSTRAINT [PK_DiagnosisCategory] PRIMARY KEY  CLUSTERED 
	(
		[DiagnosisCategoryID]
	)  ON [PRIMARY] ,
	CONSTRAINT [FK_DiagnosisCategory_EncounterTemplate] FOREIGN KEY 
	(
		[EncounterTemplateID]
	) REFERENCES [EncounterTemplate] (
		[EncounterTemplateID]
	)
) ON [PRIMARY]
GO


CREATE TABLE [DiagnosisCategoryToDiagnosisCodeDictionary] (
	[ID_PK] [int] IDENTITY (1, 1) NOT NULL ,
	[DiagnosisCategoryID] [int] NOT NULL ,
	[DiagnosisCodeDictionaryID] [int] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_DiagnosisCategoryToDiagnosisCodeDictionary_CreatedDate] DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_CategoryToDiagnosis_CreatedUserID] DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_DiagnosisCategoryToDiagnosisCodeDictionary_ModifiedDate] DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_CategoryToDiagnosis_ModifiedUserID] DEFAULT (0),
	[RecordTimeStamp] [timestamp] NOT NULL ,
	CONSTRAINT [PK_DiagnosisCategoryToDiagnosisCodeDictionary] PRIMARY KEY  CLUSTERED 
	(
		[ID_PK]
	)  ON [PRIMARY] ,
	CONSTRAINT [FK_DiagnosisCategoryToDiagnosisCodeDictionary_DiagnosisCategory] FOREIGN KEY 
	(
		[DiagnosisCategoryID]
	) REFERENCES [DiagnosisCategory] (
		[DiagnosisCategoryID]
	),
	CONSTRAINT [FK_DiagnosisCategoryToDiagnosisCodeDictionary_DiagnosisCodeDictionary] FOREIGN KEY 
	(
		[DiagnosisCodeDictionaryID]
	) REFERENCES [DiagnosisCodeDictionary] (
		[DiagnosisCodeDictionaryID]
	)
) ON [PRIMARY]
GO

/*-----------------------------------------------------------------------------
	Case 3835, 6247
-----------------------------------------------------------------------------*/
UPDATE Report SET ReportParameters='<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="TimeOffset" parameterName="TimeOffset" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"
			default="Today" forceDefault="true" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" overrideMaxDate="true" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="AppointmentResourceTypeID" text="Type:" description="Limits the report by resource type."
			default="A" ignore="A">
			<value displayText="All" value="A" />
			<value displayText="Practice Resource" value="2" />
			<value displayText="Provider" value="1" />
		</extendedParameter>
		<extendedParameter type="PracticeResources" parameterName="ResourceID" text="Practice Resource:" default="-1"
			ignore="-1" enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="2" />
		<extendedParameter type="Provider" parameterName="ResourceID" text="Provider:" default="-1" ignore="-1"
			enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="1" />
		<extendedParameter type="AppointmentStatus" parameterName="Status" text="Status:" default="-1" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient" default="-1" ignore="-1" />
	</extendedParameters>
</parameters>',
ModifiedDate = getdate()
WHERE [Name]='Appointments Summary'



/*-----------------------------------------------------------------------------
	Case 7940
-----------------------------------------------------------------------------*/
INSERT INTO DiagnosisCategory(
[EncounterTemplateID], 
[Name], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID])
SELECT 
DISTINCT [EncounterTemplateID], 
'Generic Category',
GetDate(), 
0, 
GetDate(),  
0
FROM DiagnosisCodeDictionaryToEncounterTemplate
-----------------------------------------------------------------------------------------------

INSERT INTO DiagnosisCategoryToDiagnosisCodeDictionary
(
[DiagnosisCategoryID], 
[DiagnosisCodeDictionaryID], 
[CreatedDate], 
[CreatedUserID], 
[ModifiedDate], 
[ModifiedUserID])
SELECT 
dbo.DiagnosisCategory.DiagnosisCategoryID,
DiagnosisCodeDictionaryToEncounterTemplate.[DiagnosisCodeDictionaryID], 
DiagnosisCodeDictionaryToEncounterTemplate.[CreatedDate], 
DiagnosisCodeDictionaryToEncounterTemplate.[CreatedUserID], 
DiagnosisCodeDictionaryToEncounterTemplate.[ModifiedDate], 
DiagnosisCodeDictionaryToEncounterTemplate.[ModifiedUserID]
FROM dbo.DiagnosisCategory,[dbo].[DiagnosisCodeDictionaryToEncounterTemplate],dbo.DiagnosisCodeDictionary
WHERE DiagnosisCodeDictionaryToEncounterTemplate.[EncounterTemplateID] = DiagnosisCategory.[EncounterTemplateID]
AND DiagnosisCodeDictionaryToEncounterTemplate.[DiagnosisCodeDictionaryID] = dbo.DiagnosisCodeDictionary.DiagnosisCodeDictionaryID

/*-----------------------------------------------------------------------------
	Case 7634 Add DefaultServiceLocationID field as FK to ServiceLocation  to the Patient table
-----------------------------------------------------------------------------*/
ALTER TABLE Patient ADD DefaultServiceLocationID INT NULL
GO

ALTER TABLE Patient ADD CONSTRAINT FK_Patient_ServiceLocationID
FOREIGN KEY (DefaultServiceLocationID) REFERENCES ServiceLocation (ServiceLocationID)
ON DELETE NO ACTION
ON UPDATE NO ACTION

GO

/*-----------------------------------------------------------------------------
Case 7570: Implement new Document list task
-----------------------------------------------------------------------------*/
ALTER TABLE DMSDocument ADD PracticeID INT NULL
GO

ALTER TABLE DMSDocument ADD CONSTRAINT FK_DMSDocument_PracticeID
FOREIGN KEY (PracticeID) REFERENCES Practice (PracticeID)
ON DELETE NO ACTION
ON UPDATE NO ACTION

GO

--migrate all associated documents to have a practice ID set
UPDATE
	DMSDocument
SET
	PracticeID = X.PracticeID
FROM
	DMSDocument D
	INNER JOIN 
(
SELECT
	DRA.DMSDocumentID,
	DRA.RecordID,
	DRA.RecordTypeID,
	COALESCE(A.PracticeID,
	COALESCE(C.PracticeID,
	COALESCE(E.PracticeID,
	COALESCE(PAT.PracticeID,
	COALESCE(PAY.PracticeID,
	COALESCE(DOC.PracticeID, NULL)))))) PracticeID
FROM
	DMSDocumentToRecordAssociation DRA
	LEFT OUTER JOIN Appointment A ON A.AppointmentID = DRA.RecordID AND DRA.RecordTypeID = 3
	LEFT OUTER JOIN Claim C ON C.ClaimID = DRA.RecordID AND DRA.RecordTypeID = 4
	LEFT OUTER JOIN Encounter E ON E.EncounterID = DRA.RecordID AND DRA.RecordTypeID = 2
	LEFT OUTER JOIN Patient PAT ON PAT.PatientID = DRA.RecordID AND DRA.RecordTypeID = 1
	LEFT OUTER JOIN Payment PAY ON PAY.PaymentID = DRA.RecordID AND DRA.RecordTypeID = 5
	LEFT OUTER JOIN Doctor DOC ON DOC.DoctorID = DRA.RecordID AND DRA.RecordTypeID = 6
) X ON D.DMSDocumentID = X.DMSDocumentID
WHERE X.PracticeID IS NOT NULL
GO

/*-----------------------------------------------------------------------------
	Case 7674 Add index to appointment for patient id
-----------------------------------------------------------------------------*/
CREATE NONCLUSTERED INDEX IX_Appointment_PatientID
ON Appointment (PatientID)

GO

/*-----------------------------------------------------------------------------
Case 7678, 7679 - Update report parameters for A/R Aging Summary and Detail reports. 
		  Create new parameters for A/R Aging by Insurance and Patient reports.
-----------------------------------------------------------------------------*/

-- Update the existing A/R Aging Summary's report parameters
UPDATE	Report
SET	ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	</basicParameters>
</parameters>',
	ModifiedDate = getdate()
WHERE	Name = 'A/R Aging Summary'

-- Update the existing A/R Aging Detail's report parameters and description
UPDATE	Report
SET	ReportParameters = 
'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="RespType" text="Payer Type:" description="Limits the report by the payer type." default="I">
			<value displayText="Patient" value="P" />
			<value displayText="Insurance" value="I" />
		</extendedParameter>
		<extendedParameter type="Patient" parameterName="RespID" text="Patient:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="P" permission="FindPatient" />
		<extendedParameter type="Insurance" parameterName="RespID" text="Insurance:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="I" permission="FindInsurancePlan" />
		<extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range." default="All">
			<value displayText="All" value="All" />
			<value displayText="Current Only" value="Current" />
			<value displayText="30+" value="Age31_60" />
			<value displayText="60+" value="Age61_90" />
			<value displayText="90+" value="Age91_120" />
			<value displayText="120+" value="AgeOver120" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range." default="All">
			<value displayText="All" value="All" />
			<value displayText="$10+" value="$10+" />
			<value displayText="$50+" value="$50+" />
			<value displayText="$100+" value="$100+" />
			<value displayText="$1,000+" value="$1000+" />
			<value displayText="$5,000+" value="$5000+" />
			<value displayText="$10,000+" value="$10000+" />
			<value displayText="$100,000+" value="$100000+" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field." default="false">
			<value displayText="Resp Name" value="false" />
			<value displayText="Open Balance" value="true" />
		</extendedParameter>
	</extendedParameters>
</parameters>',
	Description = 'This report provides a detailed accounts receivable aging schedule showing the outstanding balance on claims, grouped by age range.',
	DisplayOrder = 20,
	ModifiedDate = getdate()
WHERE	Name = 'A/R Aging Detail'

-- Insert new A/R Aging by Insurance report
declare @ReportCategoryId int
declare @ReportId int

SELECT 	@ReportCategoryId = ReportCategoryID
FROM 	ReportCategory 
WHERE 	Name = 'Accounts Receivable'

INSERT INTO Report (
	ReportCategoryID,
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	ReportPath,
	ReportParameters,
	MenuName,
	PermissionValue)
VALUES (
	@ReportCategoryId,
	15,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'A/R Aging by Insurance',
	'This report provides a summary accounts receivable aging schedule for insurance companies with an outstanding balance.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptARAging',
	'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
		<basicParameter type="String" parameterName="PayerTypeCode" default="1" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range." default="All">
			<value displayText="All" value="All" />
			<value displayText="Current Only" value="Current" />
			<value displayText="30+" value="Age31_60" />
			<value displayText="60+" value="Age61_90" />
			<value displayText="90+" value="Age91_120" />
			<value displayText="120+" value="AgeOver120" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range." default="All">
			<value displayText="All" value="All" />
			<value displayText="$10+" value="$10+" />
			<value displayText="$50+" value="$50+" />
			<value displayText="$100+" value="$100+" />
			<value displayText="$1,000+" value="$1000+" />
			<value displayText="$5,000+" value="$5000+" />
			<value displayText="$10,000+" value="$10000+" />
			<value displayText="$100,000+" value="$100000+" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field." default="true">
			<value displayText="Resp Name" value="false" />
			<value displayText="Open Balance" value="true" />
		</extendedParameter>
	</extendedParameters>
</parameters>',
	'A/R Aging by &Insurance',
	'ReadARAgingByInsurance')

set @ReportId = @@identity

INSERT INTO ReportToSoftwareApplication(
	ReportID,
	SoftwareApplicationID)
VALUES (
	@ReportID,
	'B')

INSERT INTO ReportToSoftwareApplication(
	ReportID,
	SoftwareApplicationID)
VALUES (
	@ReportID,
	'M')

-- Insert new A/R Aging by Patient report
INSERT INTO Report (
	ReportCategoryID,
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	ReportPath,
	ReportParameters,
	MenuName,
	PermissionValue)
VALUES (
	@ReportCategoryId,
	17,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'A/R Aging by Patient',
	'This report provides a summary accounts receivable aging schedule for patients with an outstanding balance.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptARAging',
	'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
		<basicParameter type="String" parameterName="PayerTypeCode" default="2" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range." default="All">
			<value displayText="All" value="All" />
			<value displayText="Current Only" value="Current" />
			<value displayText="30+" value="Age31_60" />
			<value displayText="60+" value="Age61_90" />
			<value displayText="90+" value="Age91_120" />
			<value displayText="120+" value="AgeOver120" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range." default="All">
			<value displayText="All" value="All" />
			<value displayText="$10+" value="$10+" />
			<value displayText="$50+" value="$50+" />
			<value displayText="$100+" value="$100+" />
			<value displayText="$1,000+" value="$1000+" />
			<value displayText="$5,000+" value="$5000+" />
			<value displayText="$10,000+" value="$10000+" />
			<value displayText="$100,000+" value="$100000+" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field." default="true">
			<value displayText="Resp Name" value="false" />
			<value displayText="Open Balance" value="true" />
		</extendedParameter>
	</extendedParameters>
</parameters>',
	'A/R Aging by &Patient',
	'ReadARAgingByPatient')

set @ReportId = @@identity

INSERT INTO ReportToSoftwareApplication(
	ReportID,
	SoftwareApplicationID)
VALUES (
	@ReportID,
	'B')

INSERT INTO ReportToSoftwareApplication(
	ReportID,
	SoftwareApplicationID)
VALUES (
	@ReportID,
	'M')

GO

-- Add Hyperlink for A/R Aging by Insurance and Patient reports
INSERT	ReportHyperlink(
	ReportHyperlinkID,
	Description,
	ReportParameters)
VALUES	(11,
	'A/R Aging by Insurance',
	'<?xml version="1.0" encoding="utf-8" ?>
 <task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="A/R Aging by Insurance" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="Date" />
            <methodParam param="{0}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
 </task>')

INSERT	ReportHyperlink(
	ReportHyperlinkID,
	Description,
	ReportParameters)
VALUES	(12,
	'A/R Aging by Patient',
	'<?xml version="1.0" encoding="utf-8" ?>
 <task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="A/R Aging by Patient" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="Date" />
            <methodParam param="{0}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
 </task>')


GO

/*-----------------------------------------------------------------------------
Case 7523 - updated encounter entry screen 
-----------------------------------------------------------------------------*/
ALTER TABLE encounter ADD
	PostingDate datetime null,
	DateOfServiceTo datetime null,
	SupervisingProviderID int null,
	ReferringPhysicianID int null,
	PaymentMethod char(1) null,
	Reference varchar(40) null,

	AddOns bigint not null default 0,
	-- Hospitalization Dates
	HospitalizationStartDT datetime null,
	HospitalizationEndDT datetime null,
	-- Misc
	Box19 varchar(40) null,
	DoNotSendElectronic bit not null default 0

GO


-- set PostingDate for the existed records
update encounter set PostingDate=DateOfService where PostingDate is null
GO

ALTER TABLE Encounter ALTER COLUMN PostingDate DATETIME NOT NULL
GO

ALTER TABLE [dbo].[Encounter] 
	ADD CONSTRAINT [FK_Encounter_Doctor_01] FOREIGN KEY 
	(
		[SupervisingProviderID]
	) REFERENCES [Doctor] (
		[DoctorID]
	)
GO

ALTER TABLE [dbo].[Encounter] 
	ADD CONSTRAINT [FK_Encounter_ReferringPhysician] FOREIGN KEY 
	(
		[ReferringPhysicianID]
	) REFERENCES [ReferringPhysician] (
		[ReferringPhysicianID]
	)
GO

/*-----------------------------------------------------------------------------
Case 7526 - Create new parameters for Patient Balance Detail and Summary reports.
-----------------------------------------------------------------------------*/

-- Insert new Patient Balance Summary report
declare @ReportCategoryId2 int
declare @ReportId2 int

SELECT 	@ReportCategoryId2 = ReportCategoryID
FROM 	ReportCategory 
WHERE 	Name = 'Patients'

INSERT INTO Report (
	ReportCategoryID,
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	ReportPath,
	ReportParameters,
	MenuName,
	PermissionValue)
VALUES (
	@ReportCategoryId2,
	2,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'Patient Balance Summary',
	'This report shows a total of all charges with an open balance for each patient.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPatientBalanceSummary',
	'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
	</basicParameters>
</parameters>',
	'Patient &Balance Summary',
	'ReadPatientBalanceSummary')

set @ReportId2 = @@identity

INSERT INTO ReportToSoftwareApplication(
	ReportID,
	SoftwareApplicationID)
VALUES (
	@ReportID2,
	'B')

INSERT INTO ReportToSoftwareApplication(
	ReportID,
	SoftwareApplicationID)
VALUES (
	@ReportID2,
	'M')

-- Insert new Patient Balance Detail report
INSERT INTO Report (
	ReportCategoryID,
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	ReportPath,
	ReportParameters,
	MenuName,
	PermissionValue)
VALUES (
	@ReportCategoryId2,
	4,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'Patient Balance Detail',
	'This report shows the specific charges that make up each patient''s open balance.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPatientBalanceDetail',
	'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Patient to display a report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	</extendedParameters>
</parameters>',
	'Patient B&alance Detail',
	'ReadPatientBalanceDetail')

set @ReportId2 = @@identity

INSERT INTO ReportToSoftwareApplication(
	ReportID,
	SoftwareApplicationID)
VALUES (
	@ReportID2,
	'B')

INSERT INTO ReportToSoftwareApplication(
	ReportID,
	SoftwareApplicationID)
VALUES (
	@ReportID2,
	'M')

UPDATE 	Report
SET	MenuName = 'Patient &Transactions Summary',
	ModifiedDate = getdate()
WHERE	Name = 'Patient Transactions Summary'

UPDATE 	Report
SET	MenuName = 'Patient Tra&nsactions Detail',
	ModifiedDate = getdate()
WHERE	Name = 'Patient Transactions Detail'

UPDATE 	Report
SET	MenuName = 'Patient &Detail',
	ModifiedDate = getdate()
WHERE	Name = 'Patient Detail'

GO

-- Add Hyperlink for Patient Balance Detail report
INSERT	ReportHyperlink(
	ReportHyperlinkID,
	Description,
	ReportParameters)
VALUES	(13,
	'Patient Balance Detail',
	'<?xml version="1.0" encoding="utf-8" ?>
 <task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Balance Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="PatientID" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{1}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
 </task>')

GO
 
 
---------------------------------------------------------------------------------------
--case 6610 - adding active flag to procedures, diagnoses
---------------------------------------------------------------------------------------

--procedure
ALTER TABLE 
	ProcedureCodeDictionary
ADD
	Active bit NOT NULL 
CONSTRAINT
	DF_ProcedureCodeDictionary_Active DEFAULT 1
GO


--diagnoses
ALTER TABLE 
	DiagnosisCodeDictionary
ADD
	Active bit NOT NULL
CONSTRAINT
	DF_DiagnosisCodeDictionary_Active DEFAULT 1
GO

 
/*-----------------------------------------------------------------------------
Case 7523 - Implement new Encounter details screen to support scrolling, 
new layout, new data model.
-----------------------------------------------------------------------------*/

/* Update the Standard HCFA transform */
UPDATE 	BillingForm
SET	Transform = 
'<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare">
				<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB''">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_Medicaid">
				<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_Champus">
				<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''CH''">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_Champva">
				<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''VA''">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other">
				<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MB'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MC'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''CH'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''VA''">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
							</xsl:if>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1">
						<xsl:text>NONE</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local">
				<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
			</data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No">X</data>
			<data id="CMS1500.1.2_0Dollars">      0</data>
			<data id="CMS1500.1.2_0Cents">.00</data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB'' or data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
						<xsl:choose>
							<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityCLIANumber1'']) > 0 and (//data[@id=''CMS1500.1.TypeOfServiceCode1''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode2''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode3''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode4''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode5''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode6''] = ''5'')">
								<xsl:value-of select="data[@id=''CMS1500.1.FacilityCLIANumber1'']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeEIN1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN">X</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes">X</data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"></data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>
			
			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>

			
			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
			</data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode2''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
			</data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode3''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
			</data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode4''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
			</data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode5''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
			</data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode6''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
			</data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'

WHERE FormName = 'Standard'


/* Update the Medicaid of Ohio HCFA transform */
UPDATE 	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid">X</data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM"></data>
			<data id="CMS1500.1.3_DD"></data>
			<data id="CMS1500.1.3_YY"></data>
			<data id="CMS1500.1.3_M"></data>
			<data id="CMS1500.1.3_F"></data>
			<data id="CMS1500.1.4_InsuredName"></data>
			<data id="CMS1500.1.5_PatientAddress"></data>
			<data id="CMS1500.1.5_City"></data>
			<data id="CMS1500.1.5_State"></data>
			<data id="CMS1500.1.5_Zip"></data>
			<data id="CMS1500.1.5_Area"></data>
			<data id="CMS1500.1.5_Phone"></data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress"></data>
			<data id="CMS1500.1.7_City"></data>
			<data id="CMS1500.1.7_State"></data>
			<data id="CMS1500.1.7_Zip"></data>
			<data id="CMS1500.1.7_Area"></data>
			<data id="CMS1500.1.7_Phone"></data>
			<data id="CMS1500.1.8_Single"></data>
			<data id="CMS1500.1.8_Married"></data>
			<data id="CMS1500.1.8_Other"></data>
			<data id="CMS1500.1.8_Employed"></data>
			<data id="CMS1500.1.8_FTStud"></data>
			<data id="CMS1500.1.8_PTStud"></data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"></data>
			<data id="CMS1500.1.1_1GroupNumber"></data>
			<data id="CMS1500.1.1_1aMM"></data>
			<data id="CMS1500.1.1_1aDD"></data>
			<data id="CMS1500.1.1_1aYY"></data>
			<data id="CMS1500.1.1_1aM"></data>
			<data id="CMS1500.1.1_1aF"></data>
			<data id="CMS1500.1.1_1bEmployer"></data>
			<data id="CMS1500.1.1_1cPlanName"></data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature"></data>
			<data id="CMS1500.1.1_2Date"></data>
			<data id="CMS1500.1.1_3Signature"></data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"></data>
			<data id="CMS1500.1.1_5DD"></data>
			<data id="CMS1500.1.1_5YY"></data>
			<data id="CMS1500.1.1_6StartMM"></data>
			<data id="CMS1500.1.1_6StartDD"></data>
			<data id="CMS1500.1.1_6StartYY"></data>
			<data id="CMS1500.1.1_6EndMM"></data>
			<data id="CMS1500.1.1_6EndDD"></data>
			<data id="CMS1500.1.1_6EndYY"></data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ReferringProviderIDNumber1'']) &lt; 1">
						<xsl:text>9111115</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_8StartMM"></data>
			<data id="CMS1500.1.1_8StartDD"></data>
			<data id="CMS1500.1.1_8StartYY"></data>
			<data id="CMS1500.1.1_8EndMM"></data>
			<data id="CMS1500.1.1_8EndDD"></data>
			<data id="CMS1500.1.1_8EndYY"></data>
			<data id="CMS1500.1.1_9Local">
				<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
			</data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No"> </data>
			<data id="CMS1500.1.2_0Dollars">       </data>
			<data id="CMS1500.1.2_0Cents"> </data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID"></data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN"> </data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes"> </data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Address"></data>
			<data id="CMS1500.1.3_3Name">
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderPrefix1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderPrefix1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderMiddleName1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderMiddleName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1"></data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1"></data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2"></data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2"></data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3"></data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3"></data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4"></data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4"></data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5"></data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5"></data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6"></data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6"></data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	FormName = 'Medicaid of Ohio' 


/* Update the Medicaid of Michigan HCFA transform */
UPDATE 	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid">X</data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
						<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
						</xsl:if>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
						<xsl:text xml:space="preserve"> </xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>SAME</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
						<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>SAME</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="OtherSubscriberEmployerName" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="PatientEmployerName" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ReferringProviderIDNumber1'']) &lt; 1">
						<xsl:text>9111115</xsl:text>
					</xsl:when>
					<xsl:otherwise>		 
						<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>			
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local"> 
				<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
			</data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No"> </data>
			<data id="CMS1500.1.2_0Dollars"> </data>
			<data id="CMS1500.1.2_0Cents"> </data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeEIN1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN">X</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes"> </data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"></data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1"> </data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2"> </data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3"> </data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4"> </data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5"> </data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6"> </data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	FormName = 'Medicaid of Michigan' 


/* Update the Medicaid of Florida HCFA transform */
UPDATE 	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid">X</data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
							</xsl:if>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1">
						<xsl:text>NONE</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderOtherID1'']" />
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local">
				<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
			</data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No">X</data>
			<data id="CMS1500.1.2_0Dollars">      0</data>
			<data id="CMS1500.1.2_0Cents">.00</data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeEIN1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN">X</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes">X</data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"></data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
			</data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode2''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
			</data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode3''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
			</data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode4''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
			</data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode5''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
			</data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode6''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
			</data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	FormName = 'Medicaid of Florida' 


/* Update the Standard (with Facility ID Box 32) HCFA transform */
UPDATE 	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare">
				<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB''">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_Medicaid">
				<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_Champus">
				<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''CH''">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_Champva">
				<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''VA''">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other">
				<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MB'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MC'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''CH'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''VA''">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
							</xsl:if>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1">
						<xsl:text>NONE</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local">
				<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
			</data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No">X</data>
			<data id="CMS1500.1.2_0Dollars">      0</data>
			<data id="CMS1500.1.2_0Cents">.00</data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB'' or data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
						<xsl:choose>
							<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityCLIANumber1'']) > 0 and (//data[@id=''CMS1500.1.TypeOfServiceCode1''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode2''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode3''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode4''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode5''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode6''] = ''5'')">
								<xsl:value-of select="data[@id=''CMS1500.1.FacilityCLIANumber1'']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeEIN1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN">X</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes">X</data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityInfo1'']" />
			</data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>
			
			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>

			
			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
			</data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode2''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
			</data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode3''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
			</data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode4''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
			</data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode5''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
			</data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode6''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
			</data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	FormName = 'Standard (with Facility ID Box 32)' 

GO

---------------------------------------------------------------------------------------
--case 8048 - Fixing TypeOfService code to be one character only
---------------------------------------------------------------------------------------

ALTER TABLE [dbo].[ProcedureCodeDictionary] 
DROP CONSTRAINT [DF__Procedure__TypeO__1F054C92]
GO

INSERT INTO TypeOfService (TypeOfServiceCode, Description) VALUES ('_', 'Not a HCPCS service')
GO

UPDATE
	ProcedureCodeDictionary
SET
	TypeOfServiceCode = '_' 
WHERE
	TypeOfServiceCode = '99'
GO

ALTER TABLE
	ProcedureCodeDictionary
ALTER COLUMN
	TypeOfServiceCode char(1) not null
GO

ALTER TABLE [dbo].[ProcedureCodeDictionary] 
ADD CONSTRAINT [DF_ProcedureCodeDictionary_TypeOfServiceCode] 
DEFAULT ('1') FOR [TypeOfServiceCode]
GO

ALTER TABLE [dbo].[TypeOfService] 
DROP CONSTRAINT [PK_TypeOfService]
GO

ALTER TABLE
	TypeOfService
ALTER COLUMN
	TypeOfServiceCode char(1) not null
GO

ALTER TABLE [dbo].[TypeOfService] ADD CONSTRAINT [PK_TypeOfService] PRIMARY KEY  CLUSTERED 
	(
		[TypeOfServiceCode]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ProcedureCodeDictionary] ADD CONSTRAINT [FK_ProcedureCodeDictionary_TypeOfServiceCode] FOREIGN KEY 
	(
		[TypeOfServiceCode]
	) REFERENCES [TypeOfService] (
		[TypeOfServiceCode]
	)
GO

---------------------------------------------------------------------------------------
--case XXXX - Removing DatePosted Column and Replacing with SubmittedDate
---------------------------------------------------------------------------------------
ALTER TABLE Encounter ADD SubmittedDate DATETIME NULL

GO

UPDATE Encounter SET SubmittedDate=DatePosted

GO

ALTER TABLE Encounter DROP COLUMN DatePosted

GO


---------------------------------------------------------------------------------------
--case 6521:  Add records for the Fee Schedule Detail report
---------------------------------------------------------------------------------------

declare @ReportCategoryId3 int
declare @ReportId3 int

INSERT INTO ReportCategory (
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	MenuName)
VALUES (
	8,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'Settings',
	'Settings',
	'Report List',
	'&Settings')

set @ReportCategoryId3 = @@identity

INSERT INTO Report (
	ReportCategoryID,
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	ReportPath,
	ReportParameters,
	MenuName,
	PermissionValue)
VALUES (
	@ReportCategoryId3,
	1,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'Fee Schedule Detail',
	'This report lists the fee schedule associated with a contract.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptContractFee',
	'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please select a Contract to display the corresponding Fee Schedule Detail report." refreshOnParameterChange="true">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
	        <basicParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract" />
	</basicParameters>
</parameters>',
	'&Fee Schedule Detail',
	'ReadFeeScheduleDetail')

set @ReportId3 = @@identity

INSERT INTO ReportCategoryToSoftwareApplication
VALUES (
	@ReportCategoryID3,
	'B',
	getdate())

INSERT INTO ReportToSoftwareApplication
VALUES (
	@ReportID3,
	'B',
	getdate())

---------------------------------------------------------------------------------------
--case XXXX - Description
---------------------------------------------------------------------------------------



--ROLLBACK
--COMMIT
