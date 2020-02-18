/*
-----------------------------------------------------------------------------------------------------
CASE 14361 - Implement NY Medicaid Form
-----------------------------------------------------------------------------------------------------
*/
/*
INSERT INTO BillingForm(BillingFormID, FormType, FormName, PrintingFormID, MaxProcedures, MaxDiagnosis)
VALUES(11, 'NYM', 'NY Medicaid', 16, 7, 3)

INSERT INTO PrintingForm(PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
VALUES(16, 'NYM', 'NY Medicaid', 'BillDataProvider_GetNYMedicaidDocumentData', 0)

INSERT INTO PrintingFormDetails(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description)
VALUES(69, 16, 56, 'NY Medicaid')
*/
UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="NYM" pageId="NYM.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css">
			<![CDATA[
		
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
		
	    	]]>
		</style>
	</defs>
  
	<g>
		<text x="1.56in" y="0.81in" width="1.84in" height="0.1in" valueSource="NYM.1.1_PatientName" />
		<text x="3.23in" y="0.81in" width="1.25in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.2_PatientBirthDate" />
		<text x="5.39in" y="0.81in" width="2.87in" height="0.1in" valueSource="NYM.1.3_InsuredName" />
		<text x="1.56in" y="1.14in" width="1.80in" height="0.1in" valueSource="NYM.1.4_PatientAddress_Street" />
		<text x="1.56in" y="1.29in" width="1.80in" height="0.1in" valueSource="NYM.1.4_PatientAddress_CityStateZip" />
    <text x="3.44in" y="1.15in" width="0.17in" height="0.1in" valueSource="NYM.1.5_InsuredGender_Male" />
    <text x="3.77in" y="1.15in" width="0.17in" height="0.1in" valueSource="NYM.1.5_InsuredGender_Female" />
		<text x="4.35in" y="1.15in" width="0.17in" height="0.1in" valueSource="NYM.1.5A_PatientGender_Male" />
		<text x="4.68in" y="1.15in" width="0.17in" height="0.1in" valueSource="NYM.1.5A_PatientGender_Female" />
    <text x="3.31in" y="1.47in" width="1.79in" height="0.1in" valueSource="NYM.1.5B_PatientTelephone" />
    <text x="5.09in" y="1.14in" width="1.59in" height="0.1in" valueSource="NYM.1.6_MedicareNumber" />
    <text x="6.55in" y="1.14in" width="1.24in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.6A_MedicaidNumber" />
    <text x="5.09in" y="1.47in" width="1.59in" height="0.1in" valueSource="NYM.1.6B_PrivateInsuranceNumber" />
		<text x="6.59in" y="1.47in" width="0.90in" height="0.1in" valueSource="NYM.1.6B_GroupNumber" />
    <text x="1.56in" y="1.79in" width="1.80in" height="0.1in" valueSource="NYM.1.6C_PatientEmployer" />
		<text x="3.48in" y="1.83in" width="0.18in" height="0.1in" valueSource="NYM.1.7_PatientRelationshipToInsured_Self" />
		<text x="3.88in" y="1.83in" width="0.18in" height="0.1in" valueSource="NYM.1.7_PatientRelationshipToInsured_Spouse" />
		<text x="4.28in" y="1.83in" width="0.18in" height="0.1in" valueSource="NYM.1.7_PatientRelationshipToInsured_Child" />
		<text x="4.70in" y="1.83in" width="0.18in" height="0.1in" valueSource="NYM.1.7_PatientRelationshipToInsured_Other" />
    <text x="5.09in" y="1.79in" width="3.15in" height="0.1in" valueSource="NYM.1.8_InsuredEmployer" />
    <text x="1.56in" y="2.04in" width="1.80in" height="0.1in" font-size="8pt" valueSource="NYM.1.9_OtherInsuredName" />
    <text x="1.56in" y="2.15in" width="1.80in" height="0.1in" font-size="8pt" valueSource="NYM.1.9_OtherInsuredPlanName" />
    <text x="1.56in" y="2.26in" width="1.80in" height="0.1in" font-size="8pt" valueSource="NYM.1.9_OtherInsuredAddress_Street" />
    <text x="1.56in" y="2.37in" width="1.80in" height="0.1in" font-size="8pt" valueSource="NYM.1.9_OtherInsuredAddress_CityStateZip" />
    <text x="1.56in" y="2.48in" width="1.80in" height="0.1in" font-size="8pt" valueSource="NYM.1.9_OtherInsuredPolicyNumber" />
		<text x="3.87in" y="2.11in" width="0.17in" height="0.1in" valueSource="NYM.1.10_PatientCondition_Employment" />
		<text x="4.23in" y="2.11in" width="0.17in" height="0.1in" valueSource="NYM.1.10_PatientCondition_Crime" />
		<text x="3.87in" y="2.44in" width="0.17in" height="0.1in" valueSource="NYM.1.10_PatientCondition_AutoAccident" />
		<text x="4.23in" y="2.44in" width="0.17in" height="0.1in" valueSource="NYM.1.10_PatientCondition_OtherLiability" />
		<text x="5.09in" y="2.07in" width="3.16in" height="0.1in" valueSource="NYM.1.11_InsuredAddress_Street" />
		<text x="5.09in" y="2.22in" width="3.16in" height="0.1in" valueSource="NYM.1.11_InsuredAddress_CityStateZip" />
		<text x="1.56in" y="2.85in" width="2.70in" height="0.1in" valueSource="NYM.1.12_Signature" />
		<text x="4.15in" y="2.96in" width="0.93in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.12_Date" />
		<text x="5.09in" y="2.85in" width="3.16in" height="0.1in" valueSource="NYM.1.13_Signature" />
		<text x="0.16in" y="3.47in" width="0.83in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.14_IllnessStartDate" />
    <text x="0.99in" y="3.47in" width="0.83in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.15_FirstConsultationDate" />
    <text x="2.01in" y="3.50in" width="0.17in" height="0.1in" valueSource="NYM.1.16_SimilarSymptoms_YES" />
    <text x="2.62in" y="3.50in" width="0.17in" height="0.1in" valueSource="NYM.1.16_SimilarSymptoms_NO" />
    <text x="4.14in" y="3.47in" width="0.93in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.17_ReturnToWorkDate" />
    <text x="5.39in" y="3.50in" width="0.17in" height="0.1in" valueSource="NYM.1.18_TotalDisabilityDays_Full" />
    <text x="5.81in" y="3.50in" width="0.17in" height="0.1in" valueSource="NYM.1.18_TotalDisabilityDays_Partial" />
		<text x="6.34in" y="3.46in" width="0.93in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.18_TotalDisabilityBeginDate" />
    <text x="7.27in" y="3.46in" width="0.93in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.18_TotalDisabilityEndDate" />
		<text x="0.19in" y="3.78in" width="3.12in" height="0.1in" valueSource="NYM.1.19_ReferringPhyscianName" />
    <text x="5.63in" y="3.78in" width="1.67in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.19C_IDNumber" />
		<text x="1.36in" y="4.12in" width="0.93in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.20_HospitalizationBeginDate" />
		<text x="2.27in" y="4.12in" width="0.93in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.20_HospitalizationEndDate" />
    <text x="3.22in" y="4.12in" width="2.62in" height="0.1in" valueSource="NYM.1.20A_HospitalName" />
		<text x="0.19in" y="4.45in" width="3.12in" height="0.1in" valueSource="NYM.1.21_FacilityName" />
    <text x="3.22in" y="4.45in" width="2.62in" height="0.1in" valueSource="NYM.1.21A_FacilityAddress" />
    <text x="0.19in" y="4.79in" width="3.12in" height="0.1in" valueSource="NYM.1.22A_ProviderName" />
    <text x="6.59in" y="5.04in" width="0.17in" height="0.1in" valueSource="NYM.1.22G_EPSDT_THP_YES" />
    <text x="6.78in" y="5.04in" width="0.17in" height="0.1in" valueSource="NYM.1.22G_EPSDT_THP_NO" />
    <text x="7.60in" y="5.04in" width="0.17in" height="0.1in" valueSource="NYM.1.22H_FamilyPlanning_YES" />
    <text x="7.79in" y="5.04in" width="0.17in" height="0.1in" valueSource="NYM.1.22H_FamilyPlanning_NO" />
		<text x="0.38in" y="5.12in" width="4.63in" height="0.1in" valueSource="NYM.1.23_Diagnosis1" />
		<text x="0.38in" y="5.28in" width="4.63in" height="0.1in" valueSource="NYM.1.23_Diagnosis2" />
		<text x="0.38in" y="5.44in" width="4.63in" height="0.1in" valueSource="NYM.1.23_Diagnosis3" />
    <text x="5.17in" y="5.45in" width="2.28in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.23A_PriorApprovalNumber" />
    <text x="7.39in" y="5.45in" width="0.17in" height="0.1in" valueSource="NYM.1.23B_PaymentSourceCode_M" />
    <text x="7.59in" y="5.45in" width="0.17in" height="0.1in" valueSource="NYM.1.23B_PaymentSourceCode_O" />
	</g>
  
	<g class="smaller">
		<text x="0.10in" y="6.14in" width="0.83in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24A_ServiceBeginDate1" />
		<text x="1.02in" y="6.14in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24B_PlaceOfServiceCode1" />
		<text x="1.31in" y="6.14in" width="0.63in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24C_ProcedureCode1" />
		<text x="1.92in" y="6.14in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24D_ProcedureModifier1" />
    <text x="2.23in" y="6.14in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24E_ProcedureModifier1" />
    <text x="2.53in" y="6.14in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24F_ProcedureModifier1" />
    <text x="2.83in" y="6.14in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24G_ProcedureModifier1" />
		<text x="3.28in" y="6.14in" width="1.07in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24H_DiagnosisPointer1Code1" />
		<text x="4.21in" y="6.14in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24I_ServiceUnitCount1" />
    <text x="4.42in" y="6.14in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Dollars1" class="money" />
    <text x="5.44in" y="6.14in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Cents1" />
    <text x="5.64in" y="6.14in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Dollars1" class="money" />
    <text x="6.66in" y="6.14in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Cents1" />
    <text x="6.86in" y="6.14in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars1" class="money" />
    <text x="7.88in" y="6.14in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents1" />

    <text x="0.10in" y="6.455in" width="0.83in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24A_ServiceBeginDate2" />
    <text x="1.02in" y="6.455in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24B_PlaceOfServiceCode2" />
    <text x="1.31in" y="6.455in" width="0.63in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24C_ProcedureCode2" />
    <text x="1.92in" y="6.455in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24D_ProcedureModifier2" />
    <text x="2.23in" y="6.455in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24E_ProcedureModifier2" />
    <text x="2.53in" y="6.455in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24F_ProcedureModifier2" />
    <text x="2.83in" y="6.455in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24G_ProcedureModifier2" />
    <text x="3.28in" y="6.455in" width="1.07in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24H_DiagnosisPointer1Code2" />
    <text x="4.21in" y="6.455in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24I_ServiceUnitCount2" />
    <text x="4.42in" y="6.455in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Dollars2" class="money" />
    <text x="5.44in" y="6.455in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Cents2" />
    <text x="5.64in" y="6.455in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Dollars2" class="money" />
    <text x="6.66in" y="6.455in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Cents2" />
    <text x="6.86in" y="6.455in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars2" class="money" />
    <text x="7.88in" y="6.455in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents2" />

    <text x="0.10in" y="6.77in" width="0.83in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24A_ServiceBeginDate3" />
    <text x="1.02in" y="6.77in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24B_PlaceOfServiceCode3" />
    <text x="1.31in" y="6.77in" width="0.63in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24C_ProcedureCode3" />
    <text x="1.92in" y="6.77in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24D_ProcedureModifier3" />
    <text x="2.23in" y="6.77in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24E_ProcedureModifier3" />
    <text x="2.53in" y="6.77in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24F_ProcedureModifier3" />
    <text x="2.83in" y="6.77in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24G_ProcedureModifier3" />
    <text x="3.28in" y="6.77in" width="1.07in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24H_DiagnosisPointer1Code3" />
    <text x="4.21in" y="6.77in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24I_ServiceUnitCount3" />
    <text x="4.42in" y="6.77in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Dollars3" class="money" />
    <text x="5.44in" y="6.77in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Cents3" />
    <text x="5.64in" y="6.77in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Dollars3" class="money" />
    <text x="6.66in" y="6.77in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Cents3" />
    <text x="6.86in" y="6.77in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars3" class="money" />
    <text x="7.88in" y="6.77in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents3" />

    <text x="0.10in" y="7.08in" width="0.83in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24A_ServiceBeginDate4" />
    <text x="1.02in" y="7.08in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24B_PlaceOfServiceCode4" />
    <text x="1.31in" y="7.08in" width="0.63in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24C_ProcedureCode4" />
    <text x="1.92in" y="7.08in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24D_ProcedureModifier4" />
    <text x="2.23in" y="7.08in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24E_ProcedureModifier4" />
    <text x="2.53in" y="7.08in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24F_ProcedureModifier4" />
    <text x="2.83in" y="7.08in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24G_ProcedureModifier4" />
    <text x="3.28in" y="7.08in" width="1.07in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24H_DiagnosisPointer1Code4" />
    <text x="4.21in" y="7.08in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24I_ServiceUnitCount4" />
    <text x="4.42in" y="7.08in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Dollars4" class="money" />
    <text x="5.44in" y="7.08in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Cents4" />
    <text x="5.64in" y="7.08in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Dollars4" class="money" />
    <text x="6.66in" y="7.08in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Cents4" />
    <text x="6.86in" y="7.08in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars4" class="money" />
    <text x="7.88in" y="7.08in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents4" />

    <text x="0.10in" y="7.395in" width="0.83in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24A_ServiceBeginDate5" />
    <text x="1.02in" y="7.395in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24B_PlaceOfServiceCode5" />
    <text x="1.31in" y="7.395in" width="0.63in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24C_ProcedureCode5" />
    <text x="1.92in" y="7.395in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24D_ProcedureModifier5" />
    <text x="2.23in" y="7.395in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24E_ProcedureModifier5" />
    <text x="2.53in" y="7.395in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24F_ProcedureModifier5" />
    <text x="2.83in" y="7.395in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24G_ProcedureModifier5" />
    <text x="3.28in" y="7.395in" width="1.07in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24H_DiagnosisPointer1Code5" />
		<text x="4.21in" y="7.395in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24I_ServiceUnitCount5" />
    <text x="4.42in" y="7.395in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Dollars5" class="money" />
    <text x="5.44in" y="7.395in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Cents5" />
    <text x="5.64in" y="7.395in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Dollars5" class="money" />
    <text x="6.66in" y="7.395in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Cents5" />
    <text x="6.86in" y="7.395in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars5" class="money" />
    <text x="7.88in" y="7.395in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents5" />

    <text x="0.10in" y="7.71in" width="0.83in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24A_ServiceBeginDate6" />
    <text x="1.02in" y="7.71in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24B_PlaceOfServiceCode6" />
    <text x="1.31in" y="7.71in" width="0.63in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24C_ProcedureCode6" />
    <text x="1.92in" y="7.71in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24D_ProcedureModifier6" />
    <text x="2.23in" y="7.71in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24E_ProcedureModifier6" />
    <text x="2.53in" y="7.71in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24F_ProcedureModifier6" />
    <text x="2.83in" y="7.71in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24G_ProcedureModifier6" />
    <text x="3.28in" y="7.71in" width="1.07in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24H_DiagnosisPointer1Code6" />
    <text x="4.21in" y="7.71in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24I_ServiceUnitCount6" />
    <text x="4.42in" y="7.71in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Dollars6" class="money" />
    <text x="5.44in" y="7.71in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Cents6" />
    <text x="5.64in" y="7.71in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Dollars6" class="money" />
    <text x="6.66in" y="7.71in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Cents6" />
    <text x="6.86in" y="7.71in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars6" class="money" />
    <text x="7.88in" y="7.71in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents6" />

    <text x="0.10in" y="8.025in" width="0.83in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24A_ServiceBeginDate7" />
    <text x="1.02in" y="8.025in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24B_PlaceOfServiceCode7" />
    <text x="1.31in" y="8.025in" width="0.63in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24C_ProcedureCode7" />
    <text x="1.92in" y="8.025in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24D_ProcedureModifier7" />
    <text x="2.23in" y="8.025in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24E_ProcedureModifier7" />
    <text x="2.53in" y="8.025in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24F_ProcedureModifier7" />
    <text x="2.83in" y="8.025in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24G_ProcedureModifier7" />
    <text x="3.28in" y="8.025in" width="1.07in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24H_DiagnosisPointer1Code7" />
		<text x="4.21in" y="8.025in" width="0.32in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24I_ServiceUnitCount7" />
		<text x="4.42in" y="8.025in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Dollars7" class="money" />
    <text x="5.44in" y="8.025in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24J_Charges_Cents7" />
    <text x="5.64in" y="8.025in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Dollars7" class="money" />
    <text x="6.66in" y="8.025in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24K_MedicarePayments_Cents7" />
    <text x="6.86in" y="8.025in" width="0.94in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars7" class="money" />
    <text x="7.88in" y="8.025in" width="0.31in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents7" />
	</g>
  
	<g>
		<text x="0.19in" y="9.03in" width="3.05in" height="0.1in" valueSource="NYM.1.25_PhysicianSignature" />
    <text x="1.19in" y="10.13in" width="0.91in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.25E_DateSigned" />
		<text x="3.63in" y="8.76in" width="0.19in" height="0.1in" valueSource="NYM.1.26_Accept_YES" />
		<text x="4.52in" y="8.76in" width="0.19in" height="0.1in" valueSource="NYM.1.26_Accept_NO" />
		<text x="4.91in" y="8.78in" width="0.77in" height="0.1in" valueSource="NYM.1.27_TotalCharge_Dollars" class="money" />
		<text x="5.76in" y="8.78in" width="0.33in" height="0.1in" valueSource="NYM.1.27_TotalCharge_Cents" />
		<text x="5.91in" y="8.78in" width="0.77in" height="0.1in" valueSource="NYM.1.28_TotalPaid_Dollars" class="money" />
		<text x="6.77in" y="8.78in" width="0.33in" height="0.1in" valueSource="NYM.1.28_TotalPaid_Cents" />
		<text x="6.89in" y="8.78in" width="0.90in" height="0.1in" valueSource="NYM.1.29_TotalBalance_Dollars" class="money" />
		<text x="7.88in" y="8.78in" width="0.33in" height="0.1in" valueSource="NYM.1.29_TotalBalance_Cents" />
    <text x="3.22in" y="9.13in" width="1.79in" height="0.1in" valueSource="NYM.1.30_EmployerIDNumber" />
		<text x="2.10in" y="10.13in" width="3.0in" height="0.1in" letter-spacing="0.05in" valueSource="NYM.1.32_PatientID" />
	</g>
</svg>'
WHERE PrintingFormDetailsID = 69

Update BillingForm
SET TransForm = '<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml"/>
  <xsl:decimal-format name="default-format" NaN="0.00"/>
  <xsl:template match="/formData/page">
    <formData formId="NYM">
      <page pageId="NYM.1">
        <BillID>
          <xsl:value-of select="data[@id=''NYM.1.BillID1'']"/>
        </BillID>
        
        <data id="NYM.1.1_PatientName">
          <xsl:value-of select="data[@id=''NYM.1.PatientFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''NYM.1.PatientMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''NYM.1.PatientMiddleName1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''NYM.1.PatientLastName1'']"/>
          <xsl:if test="string-length(data[@id=''NYM.1.PatientSuffix1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''NYM.1.PatientSuffix1'']"/>
          </xsl:if>
        </data>
        
        <data id="NYM.1.2_PatientBirthDate">
          <xsl:if test="string-length(data[@id=''NYM.1.PatientBirthDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''NYM.1.PatientBirthDate1''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.PatientBirthDate1''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.PatientBirthDate1''], 7, 4)"/>
	        </xsl:if>
        </data>
        
        <data id="NYM.1.2A_AnnualFamilyIncome">
          <!-- We don''t store salary or wage.  Will be left blank. -->
        </data>
        
        <data id="NYM.1.3_InsuredName">
          <xsl:choose>
            <xsl:when test="data[@id=''NYM.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''NYM.1.SubscriberFirstName1'']"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:if test="string-length(data[@id=''NYM.1.SubscriberMiddleName1'']) &gt; 0">
                <xsl:value-of select="substring(data[@id=''NYM.1.SubscriberMiddleName1''], 1, 1)"/>
                <xsl:text xml:space="preserve"> </xsl:text>
              </xsl:if>
              <xsl:value-of select="data[@id=''NYM.1.SubscriberLastName1'']"/>
              <xsl:if test="string-length(data[@id=''NYM.1.SubscriberSuffix1'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''NYM.1.SubscriberSuffix1'']"/>
              </xsl:if>
            </xsl:when>
            <xsl:when test="data[@id=''NYM.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''NYM.1.HCFASameAsInsuredFormatCode1''] = ''M''">
              <xsl:text>SAME</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.PatientFirstName1'']"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:if test="string-length(data[@id=''NYM.1.PatientMiddleName1'']) &gt; 0">
                <xsl:value-of select="substring(data[@id=''NYM.1.PatientMiddleName1''], 1, 1)"/>
                <xsl:text xml:space="preserve"> </xsl:text>
              </xsl:if>
              <xsl:value-of select="data[@id=''NYM.1.PatientLastName1'']"/>
              <xsl:if test="string-length(data[@id=''NYM.1.PatientSuffix1'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''NYM.1.PatientSuffix1'']"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        
        <data id="NYM.1.4_PatientAddress_Street">
          <xsl:value-of select="data[@id=''NYM.1.PatientStreet11'']"/>
          <xsl:if test="string-length(data[@id=''NYM.1.PatientStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''NYM.1.PatientStreet21'']"/>
          </xsl:if>
        </data>
        <data id="NYM.1.4_PatientAddress_CityStateZip">
          <xsl:value-of select="data[@id=''NYM.1.PatientCity1'']"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''NYM.1.PatientState1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''NYM.1.PatientZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''NYM.1.PatientZip1''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''NYM.1.PatientZip1''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.PatientZip1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        
        <data id="NYM.1.5_InsuredGender_Male">
          <xsl:choose>
            <xsl:when test="data[@id=''NYM.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:if test="data[@id=''NYM.1.SubscriberGender1''] = ''M''">X</xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="data[@id=''NYM.1.PatientGender1''] = ''M''">X</xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="NYM.1.5_InsuredGender_Female">
          <xsl:choose>
            <xsl:when test="data[@id=''NYM.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:if test="data[@id=''NYM.1.SubscriberGender1''] = ''F''">X</xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="data[@id=''NYM.1.PatientGender1''] = ''F''">X</xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        
        <data id="NYM.1.5A_PatientGender_Male">
          <xsl:if test="data[@id=''NYM.1.PatientGender1''] = ''M''">X</xsl:if>
        </data>
        <data id="NYM.1.5A_PatientGender_Female">
          <xsl:if test="data[@id=''NYM.1.PatientGender1''] = ''F''">X</xsl:if>
        </data>
        
        <data id="NYM.1.5B_PatientTelephone">
          <xsl:if test="string-length(data[@id=''NYM.1.PatientPhone1'']) &gt; 0">
		        <xsl:value-of select="substring(data[@id=''NYM.1.PatientPhone1''], 1, 3)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.PatientPhone1''], 4, 3)"/>
		        <xsl:text>-</xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.PatientPhone1''], 7, 4)"/>
	        </xsl:if>
        </data>
        
        <data id="NYM.1.6_MedicareNumber">
          <xsl:if test="data[@id=''NYM.1.OtherInsuranceType1''] = ''MB''">
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''NYM.1.OtherPolicyNumber1'']) &gt; 0">
                <xsl:value-of select="data[@id=''NYM.1.OtherPolicyNumber1'']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''NYM.1.OtherDependentPolicyNumber1'']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </data>
        
        <data id="NYM.1.6A_MedicaidNumber">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''NYM.1.PolicyNumber1'']) &gt; 0">
              <xsl:value-of select="data[@id=''NYM.1.PolicyNumber1'']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.DependentPolicyNumber1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>

        <data id="NYM.1.6B_PrivateInsuranceNumber">
          <xsl:if test="data[@id=''NYM.1.OtherInsuranceType1''] != ''MC'' and data[@id=''NYM.1.OtherInsuranceType1''] != ''MB''">
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''NYM.1.OtherPolicyNumber1'']) &gt; 0">
                <xsl:value-of select="data[@id=''NYM.1.OtherPolicyNumber1'']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''NYM.1.OtherDependentPolicyNumber1'']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </data>
        <data id="NYM.1.6B_GroupNumber">
          <xsl:value-of select="data[@id=''NYM.1.GroupNumber1'']"/>
        </data>
        <data id="NYM.1.6B_ReciprocityNumber">
          <!-- We don''t store it.  Will be left blank. -->
        </data>
        
        <data id="NYM.1.6C_PatientEmployer">
          <xsl:value-of select="data[@id=''NYM.1.PatientEmployerName1'']"/>
        </data>
        
        <data id="NYM.1.7_PatientRelationshipToInsured_Self">
            <xsl:if test="data[@id=''NYM.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
        </data>
        <data id="NYM.1.7_PatientRelationshipToInsured_Spouse">
            <xsl:if test="data[@id=''NYM.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
        </data>
        <data id="NYM.1.7_PatientRelationshipToInsured_Child">
            <xsl:if test="data[@id=''NYM.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
        </data>
        <data id="NYM.1.7_PatientRelationshipToInsured_Other">
          <xsl:if test="data[@id=''NYM.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
        </data>
        
        <data id="NYM.1.8_InsuredEmployer">
          <xsl:choose>
            <xsl:when test="data[@id=''NYM.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''NYM.1.SubscriberEmployerName1'']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.PatientEmployerName1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>

      <xsl:if test="data[@id=''NYM.1.OtherInsuranceType1''] != ''MC'' and data[@id=''NYM.1.OtherInsuranceType1''] != ''MB''">
        <data id="NYM.1.9_OtherInsuredName">
          <xsl:choose>
            <xsl:when test="data[@id=''NYM.1.OtherSubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''NYM.1.OtherSubscriberFirstName1'']"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:if test="string-length(data[@id=''NYM.1.OtherSubscriberMiddleName1'']) &gt; 0">
                <xsl:value-of select="substring(data[@id=''NYM.1.OtherSubscriberMiddleName1''], 1, 1)"/>
                <xsl:text xml:space="preserve"> </xsl:text>
              </xsl:if>
              <xsl:value-of select="data[@id=''NYM.1.OtherSubscriberLastName1'']"/>
              <xsl:if test="string-length(data[@id=''NYM.1.OtherSubscriberSuffix1'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''NYM.1.OtherSubscriberSuffix1'']"/>
              </xsl:if>
            </xsl:when>
            <xsl:when test="data[@id=''NYM.1.OtherSubscriberDifferentFlag1''] = ''0'' and data[@id=''NYM.1.HCFASameAsInsuredFormatCode1''] = ''M''">
              <xsl:text>SAME</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.PatientFirstName1'']"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:if test="string-length(data[@id=''NYM.1.PatientMiddleName1'']) &gt; 0">
                <xsl:value-of select="substring(data[@id=''NYM.1.PatientMiddleName1''], 1, 1)"/>
                <xsl:text xml:space="preserve"> </xsl:text>
              </xsl:if>
              <xsl:value-of select="data[@id=''NYM.1.PatientLastName1'']"/>
              <xsl:if test="string-length(data[@id=''NYM.1.PatientSuffix1'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''NYM.1.PatientSuffix1'']"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="NYM.1.9_OtherInsuredPlanName">
          <xsl:value-of select="data[@id=''NYM.1.OtherPayerName1'']"/>
        </data>
        <data id="NYM.1.9_OtherInsuredAddress_Street">
          <xsl:choose>
            <xsl:when test="data[@id=''NYM.1.OtherSubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''NYM.1.OtherSubscriberStreet11'']"/>
              <xsl:if test="string-length(data[@id=''NYM.1.OtherSubscriberStreet21'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''NYM.1.OtherSubscriberStreet21'']"/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.PatientStreet11'']"/>
              <xsl:if test="string-length(data[@id=''NYM.1.PatientStreet21'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''NYM.1.PatientStreet21'']"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="NYM.1.9_OtherInsuredAddress_CityStateZip">
          <xsl:choose>
            <xsl:when test="data[@id=''NYM.1.OtherSubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''NYM.1.OtherSubscriberCity1'']"/>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''NYM.1.OtherSubscriberState1'']"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:choose>
                <xsl:when test="string-length(data[@id=''NYM.1.OtherSubscriberZip1'']) = 9">
                  <xsl:value-of select="substring(data[@id=''NYM.1.OtherSubscriberZip1''], 1, 5)"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="substring(data[@id=''NYM.1.OtherSubscriberZip1''], 6, 4)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="data[@id=''NYM.1.OtherSubscriberZip1'']"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.PatientCity1'']"/>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''NYM.1.PatientState1'']"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:choose>
                <xsl:when test="string-length(data[@id=''NYM.1.PatientZip1'']) = 9">
                  <xsl:value-of select="substring(data[@id=''NYM.1.PatientZip1''], 1, 5)"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="substring(data[@id=''NYM.1.PatientZip1''], 6, 4)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="data[@id=''NYM.1.PatientZip1'']"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="NYM.1.9_OtherInsuredPolicyNumber">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''NYM.1.OtherPolicyNumber1'']) &gt; 0">
              <xsl:value-of select="data[@id=''NYM.1.OtherPolicyNumber1'']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.OtherDependentPolicyNumber1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
      </xsl:if>
        
        <data id="NYM.1.10_PatientCondition_Employment">
          <xsl:if test="data[@id=''NYM.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="NYM.1.10_PatientCondition_Crime">
          <xsl:if test="data[@id=''NYM.1.CrimeRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="NYM.1.10_PatientCondition_AutoAccident">
          <xsl:if test="data[@id=''NYM.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="NYM.1.10_PatientCondition_OtherLiability">
          <xsl:if test="data[@id=''NYM.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        
        <data id="NYM.1.11_InsuredAddress_Street">
          <xsl:choose>
            <xsl:when test="data[@id=''NYM.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''NYM.1.SubscriberStreet11'']"/>
              <xsl:if test="string-length(data[@id=''NYM.1.SubscriberStreet21'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''NYM.1.SubscriberStreet21'']"/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.PatientStreet11'']"/>
              <xsl:if test="string-length(data[@id=''NYM.1.PatientStreet21'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''NYM.1.PatientStreet21'']"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>       
        <data id="NYM.1.11_InsuredAddress_CityStateZip">
          <xsl:choose>
            <xsl:when test="data[@id=''NYM.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''NYM.1.SubscriberCity1'']"/>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''NYM.1.SubscriberState1'']"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:choose>
                <xsl:when test="string-length(data[@id=''NYM.1.SubscriberZip1'']) = 9">
                  <xsl:value-of select="substring(data[@id=''NYM.1.SubscriberZip1''], 1, 5)"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="substring(data[@id=''NYM.1.SubscriberZip1''], 6, 4)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="data[@id=''NYM.1.SubscriberZip1'']"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.PatientCity1'']"/>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''NYM.1.PatientState1'']"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:choose>
                <xsl:when test="string-length(data[@id=''NYM.1.PatientZip1'']) = 9">
                  <xsl:value-of select="substring(data[@id=''NYM.1.PatientZip1''], 1, 5)"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="substring(data[@id=''NYM.1.PatientZip1''], 6, 4)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="data[@id=''NYM.1.PatientZip1'']"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        
        <data id="NYM.1.12_Signature">
        	Signature on File
        </data>
        <data id="NYM.1.12_Date">
          <xsl:value-of select="substring(data[@id=''NYM.1.CurrentDate1''], 1, 2)"/>
          <xsl:text xml:space="preserve">  </xsl:text>
          <xsl:value-of select="substring(data[@id=''NYM.1.CurrentDate1''], 4, 2)"/>
          <xsl:text xml:space="preserve">  </xsl:text>
          <xsl:value-of select="substring(data[@id=''NYM.1.CurrentDate1''], 9, 2)"/>
        </data>
        
        <data id="NYM.1.13_Signature">
        	Signature on File
        </data>
        
        <data id="NYM.1.14_IllnessStartDate">
          <xsl:if test="string-length(data[@id=''NYM.1.InjuryDate1'']) &gt; 0">
		        <xsl:value-of select="substring(data[@id=''NYM.1.InjuryDate1''], 1, 2)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.InjuryDate1''], 4, 2)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.InjuryDate1''], 9, 2)"/>
	        </xsl:if>
        </data>
        
	      <data id="NYM.1.15_FirstConsultationDate">
          <xsl:if test="string-length(data[@id=''NYM.1.CurrentIllnessDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''NYM.1.CurrentIllnessDate1''], 1, 2)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.CurrentIllnessDate1''], 4, 2)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.CurrentIllnessDate1''], 9, 2)"/>
          </xsl:if>
	      </data>
        
	      <data id="NYM.1.16_SimilarSymptoms_YES">
          <xsl:if test="string-length(data[@id=''NYM.1.SimilarIllnessDate1'']) &gt; 0">X</xsl:if>
        </data>
        <data id="NYM.1.16_SimilarSymptoms_NO">
          <xsl:if test="string-length(data[@id=''NYM.1.SimilarIllnessDate1'']) = 0">X</xsl:if>
	      </data>
        
	      <data id="NYM.1.16A_Emergency_YES">
         <!-- Will be left blank for now. -->
	      </data>
        <data id="NYM.1.16A_Emergency_NO">
          <!-- Will be left blank for now. -->
        </data>
        
        <data id="NYM.1.17_ReturnToWorkDate">
          <xsl:if test="string-length(data[@id=''NYM.1.DisabilityEndDate1'']) &gt; 0">
		        <xsl:value-of select="substring(data[@id=''NYM.1.DisabilityEndDate1''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.DisabilityEndDate1''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.DisabilityEndDate1''], 9, 2)"/>
	        </xsl:if>
        </data>
        
        <data id="NYM.1.18_TotalDisabilityDays_Full">
          <xsl:value-of select="data[@id=''NYM.1.TotalDisabilityDays1'']"/>
        </data>
        <data id="NYM.1.18_TotalDisabilityDays_Partial">
          0
        </data>
        <data id="NYM.1.18_TotalDisabilityBeginDate">
          <xsl:if test="string-length(data[@id=''NYM.1.DisabilityBeginDate1'']) &gt; 0">
		        <xsl:value-of select="substring(data[@id=''NYM.1.DisabilityBeginDate1''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.DisabilityBeginDate1''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.DisabilityBeginDate1''], 9, 2)"/>
	        </xsl:if>
        </data>
        <data id="NYM.1.18_TotalDisabilityEndDate">
          <xsl:if test="string-length(data[@id=''NYM.1.DisabilityEndDate1'']) &gt; 0">
		        <xsl:value-of select="substring(data[@id=''NYM.1.DisabilityEndDate1''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.DisabilityEndDate1''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.DisabilityEndDate1''], 9, 2)"/>
	        </xsl:if>
        </data>
        
        <data id="NYM.1.19_ReferringPhyscianName">
          <xsl:value-of select="data[@id=''NYM.1.ReferringProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''NYM.1.ReferringProviderMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''NYM.1.ReferringProviderMiddleName1''],1,1)"/>
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''NYM.1.ReferringProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''NYM.1.ReferringProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''NYM.1.ReferringProviderDegree1'']"/>
          </xsl:if>
        </data>
        
        <data id="NYM.1.19A_Address">
          <!-- Will be left blank for now. -->
        </data>
        
        <data id="NYM.1.19B_ProfCode">
          <!-- We don''t store profession codes.  Will be left blank. -->
        </data>
        
        <data id="NYM.1.19C_IDNumber">
          <xsl:value-of select="data[@id=''NYM.1.ReferringProviderIDNumber1'']"/>
        </data>
        
        <data id="NYM.1.19D_DXCode">
          <!-- Will be left blank. -->
        </data>
        
	      <data id="NYM.1.20_HospitalizationBeginDate">
          <xsl:if test="string-length(data[@id=''NYM.1.HospitalizationBeginDate1'']) &gt; 0">
		        <xsl:value-of select="substring(data[@id=''NYM.1.HospitalizationBeginDate1''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.HospitalizationBeginDate1''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.HospitalizationBeginDate1''], 9, 2)"/>
          </xsl:if>
        </data>
        <data id="NYM.1.20_HospitalizationEndDate">
          <xsl:if test="string-length(data[@id=''NYM.1.HospitalizationEndDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''NYM.1.HospitalizationEndDate1''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.HospitalizationEndDate1''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.HospitalizationEndDate1''], 9, 2)"/>
	        </xsl:if>
        </data>
        
        <data id="NYM.1.20A_HospitalName">
          <xsl:value-of select="data[@id=''NYM.1.HospitalName1'']"/>
        </data>
        
        <data id="NYM.1.20B_SurgeryDate">
          <!-- We don''t store it.  Will be left blank. -->
        </data>
        
        <data id="NYM.1.20C_SurgeryType">
          <!--  We don''t store it.  Will be left blank. -->
        </data>

      <xsl:if test="data[@id=''NYM.1.PlaceOfServiceCode1''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode2''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode3''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode4''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode5''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode6''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode7''] = ''99''">
        <data id="NYM.1.21_FacilityName">
            <xsl:value-of select="data[@id=''NYM.1.FacilityName1'']"/>
        </data>

        <data id="NYM.1.21A_FacilityAddress">
          <xsl:value-of select="data[@id=''NYM.1.FacilityStreet11'']"/>
          <xsl:if test="string-length(data[@id=''NYM.1.FacilityStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''NYM.1.FacilityStreet21'']"/>
          </xsl:if>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''NYM.1.FacilityCity1'']"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''NYM.1.FacilityState1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''NYM.1.FacilityZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''NYM.1.FacilityZip1''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''NYM.1.FacilityZip1''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''NYM.1.FacilityZip1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
      </xsl:if>
        
        <data id="NYM.1.22_LabWork_External_YES">
          <!-- We don''t store lab work information.  Will be left blank. -->
        </data>
        <data id="NYM.1.22_LabWork_External_NO">
          <!-- We don''t store lab work information.  Will be left blank. -->
        </data>
	      <data id="NYM.1.22_LabWork_External_Charges">
          <!-- We don''t store lab work information.  Will be left blank. -->
	      </data>
        
        <data id="NYM.1.22A_ProviderName">
          <xsl:value-of select="data[@id=''NYM.1.RenderingProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''NYM.1.RenderingProviderMiddleName1''], 1, 1)"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="data[@id=''NYM.1.RenderingProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''NYM.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''NYM.1.RenderingProviderDegree1'']"/>
          </xsl:if>
        </data>
        
        <data id="NYM.1.22B_ProfCode2">
          <!-- We don''t store profession codes.  Will be left blank. -->
        </data>
        
        <data id="NYM.1.22C_IDNumber2">
          <!-- Will be left blank for now. -->
        </data>
        
        <data id="NYM.1.22D_SterilizationAbortionCode">
          <!-- We don''t store it.  Will be left blank. -->
        </data>
        
        <data id="NYM.1.22E_StatusCode">
          <!-- Will be left blank. -->
        </data>
        
        <data id="NYM.1.22F_PossibleDisability_YES">
          <!-- We don''t store it.  Will be left blank. -->
        </data>
        <data id="NYM.1.22F_PossibleDisability_NO">
          <!-- We don''t store it.  Will be left blank. -->
        </data>
        
        <data id="NYM.1.22G_EPSDT_THP_YES">
          <xsl:if test="data[@id=''NYM.1.EPSDTFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="NYM.1.22G_EPSDT_THP_NO">
          <xsl:if test="data[@id=''NYM.1.EPSDTFlag1''] = ''0''">X</xsl:if>
        </data>
        
        <data id="NYM.1.22H_FamilyPlanning_YES">
          <xsl:if test="data[@id=''NYM.1.FamilyPlanningFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="NYM.1.22H_FamilyPlanning_NO">
          <xsl:if test="data[@id=''NYM.1.FamilyPlanningFlag1''] = ''0''">X</xsl:if>
        </data>
        
	      <data id="NYM.1.23_Diagnosis1">
	        <xsl:value-of select="data[@id=''NYM.1.DiagnosisCode11'']"/>
	      </data>
	      <data id="NYM.1.23_Diagnosis2">
	        <xsl:value-of select="data[@id=''NYM.1.DiagnosisCode21'']"/>
	      </data>
	      <data id="NYM.1.23_Diagnosis3">
	       <xsl:value-of select="data[@id=''NYM.1.DiagnosisCode31'']"/>
	      </data>
        
        <data id="NYM.1.23A_PriorApprovalNumber">
          <xsl:value-of select="data[@id=''NYM.1.AuthorizationNumber1'']"/>
        </data>
        
        <data id="NYM.1.23B_PaymentSourceCode_M">
          <xsl:value-of select="data[@id=''NYM.1.PaymentSourceCodeM1'']"/>
        </data>

        <data id="NYM.1.23B_PaymentSourceCode_O">
          <xsl:value-of select="data[@id=''NYM.1.PaymentSourceCodeO1'']"/>
        </data>
        
        <data id="NYM.1.24M_HospitalVisitsBeginDate">
          <!-- We don''t store it.  Will be left blank. -->
        </data>
        <data id="NYM.1.24M_HospitalVisitsEndDate">
          <!-- We don''t store it.  Will be left blank. -->
        </data>

        <data id="NYM.1.24N_ProcedureCode">
          <!-- We don''t store it.  Will be left blank. -->
        </data>

        <data id="NYM.1.24O_ProcedureModifier">
          <!-- We don''t store it.  Will be left blank. -->
        </data>
        
        <data id="NYM.1.25_PhysicianSignature">
          <xsl:value-of select="data[@id=''NYM.1.RenderingProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''NYM.1.RenderingProviderMiddleName1''], 1, 1)"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="data[@id=''NYM.1.RenderingProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''NYM.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''NYM.1.RenderingProviderDegree1'']"/>
          </xsl:if>
        </data>

        <data id="NYM.1.25A_ProviderIDNumber">
          <!-- This is pre-printed. -->
        </data>

        <data id="NYM.1.25B_MedicaidGroupIDNumber">
          <!-- This is pre-printed. -->
        </data>

        <data id="NYM.1.25C_LocatorCode">
          <!-- Will be left blank for now. -->
        </data>

        <data id="NYM.1.SubmittalCounty">
          <!-- We don''t store it.  Will be left blank. -->
        </data>
        
        <data id="NYM.1.25D_SA_EXCP_Code">
          <!-- We don''t store it.  Will be left blank. -->
        </data>
        
        <data id="NYM.1.25E_DateSigned">
          <xsl:value-of select="substring(data[@id=''NYM.1.CurrentDate1''], 1, 2)"/>
          <xsl:text xml:space="preserve">  </xsl:text>
          <xsl:value-of select="substring(data[@id=''NYM.1.CurrentDate1''], 4, 2)"/>
          <xsl:text xml:space="preserve">  </xsl:text>
          <xsl:value-of select="substring(data[@id=''NYM.1.CurrentDate1''], 9, 2)"/>
        </data>

        <data id="NYM.1.26_Accept_YES">
          <xsl:if test="data[@id=''NYM.1.AcceptAssignmentFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="NYM.1.26_Accept_NO">
          <xsl:if test="data[@id=''NYM.1.AcceptAssignmentFlag1''] = ''0''">X</xsl:if>
        </data>
        
        <data id="NYM.1.27_TotalCharge_Dollars">
          <xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''NYM.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))"/>
          <xsl:value-of select="$charges-dollars"/>
        </data>
        <data id="NYM.1.27_TotalCharge_Cents">
          <xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''NYM.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="$charges-cents"/>
        </data>
        
        <data id="NYM.1.28_TotalPaid_Dollars">
          <xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''NYM.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))"/>
          <xsl:value-of select="$paid-dollars"/>
        </data>
        <data id="NYM.1.28_TotalPaid_Cents">
          <xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''NYM.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="$paid-cents"/>
        </data>
      
        <data id="NYM.1.29_TotalBalance_Dollars">
          <xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''NYM.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))"/>
          <xsl:value-of select="$balance-dollars"/>
        </data>
        <data id="NYM.1.29_TotalBalance_Cents">
          <xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''NYM.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="$balance-cents"/>
        </data>

        <data id="NYM.1.30_EmployerIDNumber">
          <xsl:value-of select="data[@id=''NYM.1.FederalTaxID1'']"/>
          <xsl:text> / </xsl:text>
          <xsl:value-of select="data[@id=''NYM.1.FederalTaxIDType1'']"/>
        </data>

        <data id="NYM.1.31_PhysicianName">
          <!-- This is pre-printed. -->
        </data>	        
        <data id="NYM.1.31_PhysicianAddress">
          <!-- This is pre-printed. -->
        </data>
        <data id="NYM.1.31_PhysicianCityStateZip">
          <!-- This is pre-printed. -->
        </data>
        <data id="NYM.1.31_PhysicianTelephone">
          <!-- This is pre-printed. -->
        </data>
        <data id="NYM.1.31_PhysicianTelephoneExtension">
          <!-- This is pre-printed. -->
        </data>

        <data id="NYM.1.32_PatientID">
	        <xsl:value-of select="data[@id=''NYM.1.PatientID1'']"/>
        </data>

        <data id="NYM.1.32A_FeePaid_YES">
          <!--  Will be left blank. -->
        </data>
        <data id="NYM.1.32A_FeePaid_NO">
          <!--  Will be left blank. -->
        </data>

        <data id="NYM.1.33_OtherProviderIDNumber">
          <!--  Will be left blank. -->
        </data>

        <data id="NYM.1.34_ProfCode3">
          <!-- Will be left blank. -->
        </data>

        <data id="NYM.1.35.CaseManagerID">
          <!--  Will be left blank. -->
        </data>

       <!-- Procedure 1 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''NYM.1.ClaimID1'']"/>
        </ClaimID>
        
        <data id="NYM.1.24A_ServiceBeginDate1">
          <xsl:if test="string-length(data[@id=''NYM.1.ServiceBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate1''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate1''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate1''], 9, 2)"/>
          </xsl:if>
        </data>
        
        <data id="NYM.1.24B_PlaceOfServiceCode1">
          <xsl:value-of select="data[@id=''NYM.1.PlaceOfServiceCode1'']"/>
        </data>
        
        <data id="NYM.1.24C_ProcedureCode1">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureCode1'']"/>
        </data>
        
        <data id="NYM.1.24D_ProcedureModifier1">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier11'']"/>
        </data>

        <data id="NYM.1.24E_ProcedureModifier1">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier21'']"/>
        </data>

        <data id="NYM.1.24F_ProcedureModifier1">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier31'']"/>
        </data>

        <data id="NYM.1.24G_ProcedureModifier1">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier41'']"/>
        </data>
        
        <data id="NYM.1.24H_DiagnosisPointer1Code1">
          <xsl:variable name="code" select="substring-before(data[@id=''NYM.1.DiagnosisPointer1Code1''], ''.'')"/>
          <xsl:variable name="subcategory" select="substring-after(data[@id=''NYM.1.DiagnosisPointer1Code1''], ''.'')"/>
          <xsl:value-of select="$code"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="$subcategory"/>
        </data>
        
        <xsl:if test="format-number(data[@id=''NYM.1.ServiceUnitCount1''], ''0.0'', ''default-format'') &gt; 0">
          <data id="NYM.1.24I_ServiceUnitCount1">
            <xsl:value-of select="data[@id=''NYM.1.ServiceUnitCount1'']"/>
          </data>
          
          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 1 or data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24J_Charges_Dollars1">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24J_Charges_Cents1">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24K_MedicarePayments_Dollars1">
              <xsl:text>0</xsl:text>
            </data>
            <data id="NYM.1.24K_MedicarePayments_Cents1">
              <xsl:text>00</xsl:text>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 2">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars1">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.SecondaryIPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents1">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.SecondaryIPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 3">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars1">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.PPaidAmount1''] + data[@id=''NYM.1.SecondaryIPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents1">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.PPaidAmount1''] + data[@id=''NYM.1.SecondaryIPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>
        </xsl:if>
        
       <!-- Procedure 2 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''NYM.1.ClaimID2'']"/>
        </ClaimID>
        
        <data id="NYM.1.24A_ServiceBeginDate2">
          <xsl:if test="string-length(data[@id=''NYM.1.ServiceBeginDate2'']) &gt; 0">
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate2''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate2''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate2''], 9, 2)"/>
	        </xsl:if>
        </data>
        
        <data id="NYM.1.24B_PlaceOfServiceCode2">
          <xsl:value-of select="data[@id=''NYM.1.PlaceOfServiceCode2'']"/>
        </data>
        
        <data id="NYM.1.24C_ProcedureCode2">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureCode2'']"/>
        </data>
        
        <data id="NYM.1.24D_ProcedureModifier2">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier12'']"/>
        </data>

        <data id="NYM.1.24E_ProcedureModifier2">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier22'']"/>
        </data>

        <data id="NYM.1.24F_ProcedureModifier2">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier32'']"/>
        </data>

        <data id="NYM.1.24G_ProcedureModifier2">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier42'']"/>
        </data>
        
        <data id="NYM.1.24H_DiagnosisPointer1Code2">
          <xsl:variable name="code" select="substring-before(data[@id=''NYM.1.DiagnosisPointer1Code2''], ''.'')"/>
          <xsl:variable name="subcategory" select="substring-after(data[@id=''NYM.1.DiagnosisPointer1Code2''], ''.'')"/>
          <xsl:value-of select="$code"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="$subcategory"/>
        </data>
        
        <xsl:if test="format-number(data[@id=''NYM.1.ServiceUnitCount2''], ''0.0'', ''default-format'') &gt; 0">
          <data id="NYM.1.24I_ServiceUnitCount2">
            <xsl:value-of select="data[@id=''NYM.1.ServiceUnitCount2'']"/>
          </data>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 1 or data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24J_Charges_Dollars2">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24J_Charges_Cents2">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24K_MedicarePayments_Dollars2">
              <xsl:text>0</xsl:text>
            </data>
            <data id="NYM.1.24K_MedicarePayments_Cents2">
              <xsl:text>00</xsl:text>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 2">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars2">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.SecondaryIPaidAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents2">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.SecondaryIPaidAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 3">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars2">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.PPaidAmount2''] + data[@id=''NYM.1.SecondaryIPaidAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents2">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.PPaidAmount2''] + data[@id=''NYM.1.SecondaryIPaidAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>
        </xsl:if>
        
       <!-- Procedure 3 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''NYM.1.ClaimID3'']"/>
        </ClaimID>
        
        <data id="NYM.1.24A_ServiceBeginDate3">
          <xsl:if test="string-length(data[@id=''NYM.1.ServiceBeginDate3'']) &gt; 0">
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate3''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate3''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate3''], 9, 2)"/>
	        </xsl:if>
        </data>
        
        <data id="NYM.1.24B_PlaceOfServiceCode3">
          <xsl:value-of select="data[@id=''NYM.1.PlaceOfServiceCode3'']"/>
        </data>
        
        <data id="NYM.1.24C_ProcedureCode3">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureCode3'']"/>
        </data>
        
        <data id="NYM.1.24D_ProcedureModifier3">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier13'']"/>
        </data>

        <data id="NYM.1.24E_ProcedureModifier3">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier23'']"/>
        </data>

        <data id="NYM.1.24F_ProcedureModifier3">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier33'']"/>
        </data>
        
        <data id="NYM.1.24G_ProcedureModifier3">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier43'']"/>
        </data>

        <data id="NYM.1.24H_DiagnosisPointer1Code3">
          <xsl:variable name="code" select="substring-before(data[@id=''NYM.1.DiagnosisPointer1Code3''], ''.'')"/>
          <xsl:variable name="subcategory" select="substring-after(data[@id=''NYM.1.DiagnosisPointer1Code3''], ''.'')"/>
          <xsl:value-of select="$code"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="$subcategory"/>
        </data>
        
        <xsl:if test="format-number(data[@id=''NYM.1.ServiceUnitCount3''], ''0.0'', ''default-format'') &gt; 0">
          <data id="NYM.1.24I_ServiceUnitCount3">
            <xsl:value-of select="data[@id=''NYM.1.ServiceUnitCount3'']"/>
          </data>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 1 or data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24J_Charges_Dollars3">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24J_Charges_Cents3">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24K_MedicarePayments_Dollars3">
              <xsl:text>0</xsl:text>
            </data>
            <data id="NYM.1.24K_MedicarePayments_Cents3">
              <xsl:text>00</xsl:text>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 2">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars3">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.SecondaryIPaidAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents3">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.SecondaryIPaidAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 3">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars3">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.PPaidAmount3''] + data[@id=''NYM.1.SecondaryIPaidAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents3">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.PPaidAmount3''] + data[@id=''NYM.1.SecondaryIPaidAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>
        </xsl:if>
        
       <!-- Procedure 4 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''NYM.1.ClaimID4'']"/>
        </ClaimID>
        
        <data id="NYM.1.24A_ServiceBeginDate4">
          <xsl:if test="string-length(data[@id=''NYM.1.ServiceBeginDate4'']) &gt; 0">
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate4''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate4''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate4''], 9, 2)"/>
	        </xsl:if>
        </data>
        
        <data id="NYM.1.24B_PlaceOfServiceCode4">
          <xsl:value-of select="data[@id=''NYM.1.PlaceOfServiceCode4'']"/>
        </data>

        <data id="NYM.1.24C_ProcedureCode4">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureCode4'']"/>
        </data>
        
        <data id="NYM.1.24D_ProcedureModifier4">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier14'']"/>
        </data>

        <data id="NYM.1.24E_ProcedureModifier4">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier24'']"/>
        </data>
        
        <data id="NYM.1.24F_ProcedureModifier4">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier34'']"/>
        </data>

        <data id="NYM.1.24G_ProcedureModifier4">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier44'']"/>
        </data>
        
        <data id="NYM.1.24H_DiagnosisPointer1Code4">
          <xsl:variable name="code" select="substring-before(data[@id=''NYM.1.DiagnosisPointer1Code4''], ''.'')"/>
          <xsl:variable name="subcategory" select="substring-after(data[@id=''NYM.1.DiagnosisPointer1Code4''], ''.'')"/>
          <xsl:value-of select="$code"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="$subcategory"/>
        </data>
        
        <xsl:if test="format-number(data[@id=''NYM.1.ServiceUnitCount4''], ''0.0'', ''default-format'') &gt; 0">
          <data id="NYM.1.24I_ServiceUnitCount4">
            <xsl:value-of select="data[@id=''NYM.1.ServiceUnitCount4'']"/>
          </data>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 1 or data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24J_Charges_Dollars4">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24J_Charges_Cents4">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24K_MedicarePayments_Dollars4">
              <xsl:text>0</xsl:text>
            </data>
            <data id="NYM.1.24K_MedicarePayments_Cents4">
              <xsl:text>00</xsl:text>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 2">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars4">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.SecondaryIPaidAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents4">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.SecondaryIPaidAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 3">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars4">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.PPaidAmount4''] + data[@id=''NYM.1.SecondaryIPaidAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents4">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.PPaidAmount4''] + data[@id=''NYM.1.SecondaryIPaidAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>
        </xsl:if>

        <!-- Procedure 5 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''NYM.1.ClaimID5'']"/>
        </ClaimID>

        <data id="NYM.1.24A_ServiceBeginDate5">
          <xsl:if test="string-length(data[@id=''NYM.1.ServiceBeginDate5'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate5''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate5''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate5''], 9, 2)"/>
	        </xsl:if>
        </data>
        
        <data id="NYM.1.24B_PlaceOfServiceCode5">
          <xsl:value-of select="data[@id=''NYM.1.PlaceOfServiceCode5'']"/>
        </data>
        
        <data id="NYM.1.24C_ProcedureCode5">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureCode5'']"/>
        </data>
        
        <data id="NYM.1.24D_ProcedureModifier5">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier15'']"/>
        </data>

        <data id="NYM.1.24E_ProcedureModifier5">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier25'']"/>
        </data>

        <data id="NYM.1.24F_ProcedureModifier5">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier35'']"/>
        </data>
        
        <data id="NYM.1.24G_ProcedureModifier5">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier45'']"/>
        </data>
        
        <data id="NYM.1.24H_DiagnosisPointer1Code5">
          <xsl:variable name="code" select="substring-before(data[@id=''NYM.1.DiagnosisPointer1Code5''], ''.'')"/>
          <xsl:variable name="subcategory" select="substring-after(data[@id=''NYM.1.DiagnosisPointer1Code5''], ''.'')"/>
          <xsl:value-of select="$code"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="$subcategory"/>
        </data>
        
        <xsl:if test="format-number(data[@id=''NYM.1.ServiceUnitCount5''], ''0.0'', ''default-format'') &gt; 0">
          <data id="NYM.1.24I_ServiceUnitCount5">
            <xsl:value-of select="data[@id=''NYM.1.ServiceUnitCount5'']"/>
          </data>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 1 or data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24J_Charges_Dollars5">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24J_Charges_Cents5">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24K_MedicarePayments_Dollars5">
              <xsl:text>0</xsl:text>
            </data>
            <data id="NYM.1.24K_MedicarePayments_Cents5">
              <xsl:text>00</xsl:text>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 2">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars5">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.SecondaryIPaidAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents5">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.SecondaryIPaidAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 3">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars5">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.PPaidAmount5''] + data[@id=''NYM.1.SecondaryIPaidAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents5">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.PPaidAmount5''] + data[@id=''NYM.1.SecondaryIPaidAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>
        </xsl:if>
        
       <!-- Procedure 6 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''NYM.1.ClaimID6'']"/>
        </ClaimID>
        
        <data id="NYM.1.24A_ServiceBeginDate6">
          <xsl:if test="string-length(data[@id=''NYM.1.ServiceBeginDate6'']) &gt; 0">
		        <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate6''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate6''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate6''], 9, 2)"/>
          </xsl:if>
        </data>

        <data id="NYM.1.24B_PlaceOfServiceCode6">
          <xsl:value-of select="data[@id=''NYM.1.PlaceOfServiceCode6'']"/>
        </data>

        <data id="NYM.1.24C_ProcedureCode6">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureCode6'']"/>
        </data>

        <data id="NYM.1.24D_ProcedureModifier6">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier16'']"/>
        </data>

        <data id="NYM.1.24E_ProcedureModifier6">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier26'']"/>
        </data>

        <data id="NYM.1.24F_ProcedureModifier6">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier36'']"/>
        </data>

        <data id="NYM.1.24G_ProcedureModifier6">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier46'']"/>
        </data>

        <data id="NYM.1.24H_DiagnosisPointer1Code6">
          <xsl:variable name="code" select="substring-before(data[@id=''NYM.1.DiagnosisPointer1Code6''], ''.'')"/>
          <xsl:variable name="subcategory" select="substring-after(data[@id=''NYM.1.DiagnosisPointer1Code6''], ''.'')"/>
          <xsl:value-of select="$code"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="$subcategory"/>
        </data>

        <xsl:if test="format-number(data[@id=''NYM.1.ServiceUnitCount6''], ''0.0'', ''default-format'') &gt; 0">
          <data id="NYM.1.24I_ServiceUnitCount6">
            <xsl:value-of select="data[@id=''NYM.1.ServiceUnitCount6'']"/>
          </data>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 1 or data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24J_Charges_Dollars6">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24J_Charges_Cents6">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24K_MedicarePayments_Dollars6">
              <xsl:text>0</xsl:text>
            </data>
            <data id="NYM.1.24K_MedicarePayments_Cents6">
              <xsl:text>00</xsl:text>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 2">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars6">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.SecondaryIPaidAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents6">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.SecondaryIPaidAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 3">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars6">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.PPaidAmount6''] + data[@id=''NYM.1.SecondaryIPaidAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents6">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.PPaidAmount6''] + data[@id=''NYM.1.SecondaryIPaidAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>
        </xsl:if>

        <!-- Procedure 7 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''NYM.1.ClaimID7'']"/>
        </ClaimID>

        <data id="NYM.1.24A_ServiceBeginDate7">
          <xsl:if test="string-length(data[@id=''NYM.1.ServiceBeginDate7'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate7''], 1, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate7''], 4, 2)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''NYM.1.ServiceBeginDate7''], 9, 2)"/>
          </xsl:if>
        </data>

        <data id="NYM.1.24B_PlaceOfServiceCode7">
          <xsl:value-of select="data[@id=''NYM.1.PlaceOfServiceCode7'']"/>
        </data>

        <data id="NYM.1.24C_ProcedureCode7">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureCode7'']"/>
        </data>

        <data id="NYM.1.24D_ProcedureModifier7">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier17'']"/>
        </data>

        <data id="NYM.1.24E_ProcedureModifier7">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier27'']"/>
        </data>

        <data id="NYM.1.24F_ProcedureModifier7">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier37'']"/>
        </data>

        <data id="NYM.1.24G_ProcedureModifier7">
          <xsl:value-of select="data[@id=''NYM.1.ProcedureModifier47'']"/>
        </data>

        <data id="NYM.1.24H_DiagnosisPointer1Code7">
          <xsl:variable name="code" select="substring-before(data[@id=''NYM.1.DiagnosisPointer1Code7''], ''.'')"/>
          <xsl:variable name="subcategory" select="substring-after(data[@id=''NYM.1.DiagnosisPointer1Code7''], ''.'')"/>
          <xsl:value-of select="$code"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="$subcategory"/>
        </data>

        <xsl:if test="format-number(data[@id=''NYM.1.ServiceUnitCount7''], ''0.0'', ''default-format'') &gt; 0">
          <data id="NYM.1.24I_ServiceUnitCount7">
            <xsl:value-of select="data[@id=''NYM.1.ServiceUnitCount7'']"/>
          </data>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 1 or data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24J_Charges_Dollars7">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.ChargeAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24J_Charges_Cents7">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.ChargeAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeM1''] = 3">
            <data id="NYM.1.24K_MedicarePayments_Dollars7">
              <xsl:text>0</xsl:text>
            </data>
            <data id="NYM.1.24K_MedicarePayments_Cents7">
              <xsl:text>00</xsl:text>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 2">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars7">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.SecondaryIPaidAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents7">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.SecondaryIPaidAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>

          <xsl:if test="data[@id=''NYM.1.PaymentSourceCodeO1''] = 3">
            <data id="NYM.1.24L_OtherInsurancePayments_Dollars7">
              <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''NYM.1.PPaidAmount7''] + data[@id=''NYM.1.SecondaryIPaidAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
              <xsl:value-of select="$charge-dollars"/>
            </data>
            <data id="NYM.1.24L_OtherInsurancePayments_Cents7">
              <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''NYM.1.PPaidAmount7''] + data[@id=''NYM.1.SecondaryIPaidAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
              <xsl:value-of select="$charge-cents"/>
            </data>
          </xsl:if>
        </xsl:if>
        
      </page>
    </formData>
  </xsl:template>
</xsl:stylesheet>'
WHERE BillingFormID = 11