/*
-----------------------------------------------------------------------------------------------------
CASE 17912 - Correct Box 19b and 31 for MASSM9 billing form.
-----------------------------------------------------------------------------------------------------
*/

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="MASSM5" pageId="MASSM5.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
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
		<text x="3.67in" y="4.71in" width="1.62in" height="0.1in" valueSource="MASSM5.1.19b_ReferringProviderNumber" />
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
		<text x="6.57in" y="6.49in" width="0.52in" height="0.1in" text-anchor="end" valueSource="MASSM5.1.24a_fServiceUnitCount" />
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
		<text x="6.57in" y="6.82in" width="0.52in" height="0.1in" text-anchor="end" valueSource="MASSM5.1.24b_fServiceUnitCount" />
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
    <text x="6.57in" y="7.16in" width="0.52in" height="0.1in" text-anchor="end" valueSource="MASSM5.1.24c_fServiceUnitCount" />
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
    <text x="6.57in" y="7.49in" width="0.52in" height="0.1in" text-anchor="end" valueSource="MASSM5.1.24d_fServiceUnitCount" />
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
		<text x="6.57in" y="7.82in" width="0.52in" height="0.1in" text-anchor="end" valueSource="MASSM5.1.24e_fServiceUnitCount" />
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
    <text x="6.57in" y="8.15in" width="0.52in" height="0.1in" text-anchor="end" valueSource="MASSM5.1.24f_fServiceUnitCount" />
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
    <text x="6.57in" y="8.47in" width="0.52in" height="0.1in" text-anchor="end" valueSource="MASSM5.1.24g_fServiceUnitCount" />
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
    <text x="6.57in" y="8.81in" width="0.52in" height="0.1in" text-anchor="end" valueSource="MASSM5.1.24h_fServiceUnitCount" />
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
		<text x="0.28in" y="10.04in" width="2.70in" height="0.1in" valueSource="MASSM5.1.32_PatientAccountNumber" />
		<text x="3.48in" y="10.04in" width="1.70in" height="0.1in" valueSource="MASSM5.1.33_BillingAgentNumber" />
	</g>
</svg>'
WHERE PrintingFormDetailsID = 11

Update BillingForm
SET TransForm = '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" />
  <xsl:decimal-format name="default-format" NaN="0.00" />
  <xsl:template match="/formData/page">
    <formData formId="MASSM5">
      <page pageId="MASSM5.1">
        <BillID>
          <xsl:value-of select="data[@id=''MASSM5.1.BillID1'']" />
        </BillID>
        <data id="MASSM5.1.1_MemberName">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientFirstName1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientMiddleName1''], 1, 1)" />
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''MASSM5.1.PatientLastName1'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientSuffix1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.PatientSuffix1'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.2_PatientBirthDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientBirthDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientBirthDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientBirthDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientBirthDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.3_InsuredName">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberFirstName1'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:if test="string-length(data[@id=''MASSM5.1.SubscriberMiddleName1'']) &gt; 0">
                <xsl:value-of select="substring(data[@id=''MASSM5.1.SubscriberMiddleName1''], 1, 1)" />
                <xsl:text xml:space="preserve"> </xsl:text>
              </xsl:if>
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberLastName1'']" />
              <xsl:if test="string-length(data[@id=''MASSM5.1.SubscriberSuffix1'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.SubscriberSuffix1'']" />
              </xsl:if>
            </xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''MASSM5.1.HCFASameAsInsuredFormatCode1''] = ''M''">
              <xsl:text>SAME</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientFirstName1'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:if test="string-length(data[@id=''MASSM5.1.PatientMiddleName1'']) &gt; 0">
                <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientMiddleName1''], 1, 1)" />
                <xsl:text xml:space="preserve"> </xsl:text>
              </xsl:if>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientLastName1'']" />
              <xsl:if test="string-length(data[@id=''MASSM5.1.PatientSuffix1'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.PatientSuffix1'']" />
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.4_MemberAddress_Street">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet11'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet21'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.4_MemberAddress_CityStateZip">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientCity1'']" />
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.PatientState1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM5.1.PatientZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 1, 5)" />
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 6, 4)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientZip1'']" />
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.4_MemberTelephone">
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientPhone1'']) &gt; 0">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientPhone1''], 1, 3)" />
            <xsl:text>) </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientPhone1''], 4, 3)" />
            <xsl:text>-</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientPhone1''], 7, 4)" />
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
              <xsl:value-of select="data[@id=''MASSM5.1.PolicyNumber1'']" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.DependentPolicyNumber1'']" />
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
          <xsl:value-of select="data[@id=''MASSM5.1.GroupNumber1'']" />
        </data>
        <data id="MASSM5.1.9_MemberOtherHealthIns_YES" />
        <data id="MASSM5.1.9_MemberOtherHealthIns_NO">
          X
        </data>
        <data id="MASSM5.1.9_MemberOtherHealthIns_AddressStreet" />
        <data id="MASSM5.1.9_MemberOtherHealthIns_AddressCityStateZip" />
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
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberStreet11'']" />
              <xsl:if test="string-length(data[@id=''MASSM5.1.SubscriberStreet21'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.SubscriberStreet21'']" />
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet11'']" />
              <xsl:if test="string-length(data[@id=''MASSM5.1.PatientStreet21'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet21'']" />
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.11_InsuredAddress_CityStateZip">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberCity1'']" />
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberState1'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:choose>
                <xsl:when test="string-length(data[@id=''MASSM5.1.SubscriberZip1'']) = 9">
                  <xsl:value-of select="substring(data[@id=''MASSM5.1.SubscriberZip1''], 1, 5)" />
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="substring(data[@id=''MASSM5.1.SubscriberZip1''], 6, 4)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="data[@id=''MASSM5.1.SubscriberZip1'']" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientCity1'']" />
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientState1'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:choose>
                <xsl:when test="string-length(data[@id=''MASSM5.1.PatientZip1'']) = 9">
                  <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 1, 5)" />
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 6, 4)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="data[@id=''MASSM5.1.PatientZip1'']" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.12_Signature">
        	Signature on File
        </data>
        <data id="MASSM5.1.12_Date">
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 1, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 4, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 9, 2)" />
        </data>
        <data id="MASSM5.1.13_Signature">
        	Signature on File
        </data>
        <data id="MASSM5.1.13_Date">
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 1, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 4, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 9, 2)" />
        </data>
        <data id="MASSM5.1.14_CurrentIllnessDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.CurrentIllnessDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentIllnessDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentIllnessDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentIllnessDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.15_FirstConsultationDate" />
        <data id="MASSM5.1.16_SimilarSymptoms_YES" />
        <data id="MASSM5.1.16_SimilarSymptoms_NO" />
        <data id="MASSM5.1.16a_Emergency" />
        <data id="MASSM5.1.17_ReturnToWorkDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.DisabilityEndDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.18_TotalDisabilityBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.DisabilityBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityBeginDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityBeginDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityBeginDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.18_TotalDisabilityEndDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.DisabilityEndDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.18_PartialDisabilityBeginDate" />
        <data id="MASSM5.1.18_PartialDisabilityEndDate" />
        <data id="MASSM5.1.19a_ReferringPhyscianName">
          <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderFirstName1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''MASSM5.1.ReferringProviderMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ReferringProviderMiddleName1''],1,1)" />
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderLastName1'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.ReferringProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderDegree1'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.19b_ReferringProviderNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderIDNumber1'']" />
        </data>
        <data id="MASSM5.1.20_HospitalizationBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.HospitalizationBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationBeginDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationBeginDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationBeginDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.20_HospitalizationEndDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.HospitalizationEndDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationEndDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationEndDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationEndDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.21_FacilityName">
          <xsl:if test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''99''">
            <xsl:value-of select="data[@id=''MASSM5.1.FacilityName1'']" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.FacilityStreet11'']" />
            <xsl:if test="string-length(data[@id=''MASSM5.1.FacilityStreet21'']) &gt; 0">
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''MASSM5.1.FacilityStreet21'']" />
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.FacilityCity1'']" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.FacilityState1'']" />
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''MASSM5.1.FacilityZip1'']) = 9">
                <xsl:value-of select="substring(data[@id=''MASSM5.1.FacilityZip1''], 1, 5)" />
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(data[@id=''MASSM5.1.FacilityZip1''], 6, 4)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''MASSM5.1.FacilityZip1'']" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </data>
        <data id="MASSM5.1.22_LabWork_External_YES" />
        <data id="MASSM5.1.22_LabWork_External_NO" />
        <data id="MASSM5.1.22_LabWork_External_Charges" />
        <data id="MASSM5.1.23a_Diagnosis1">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode11'']" />
        </data>
        <data id="MASSM5.1.23a_Diagnosis2">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode21'']" />
        </data>
        <data id="MASSM5.1.23a_Diagnosis3">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode31'']" />
        </data>
        <data id="MASSM5.1.23a_Diagnosis4">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode41'']" />
        </data>
        <data id="MASSM5.1.23b_Screen" />
        <data id="MASSM5.1.23b_Referral" />
        <data id="MASSM5.1.23c_FamilyPlanning" />
        <data id="MASSM5.1.23d_AuthorizationNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.AuthorizationNumber1'']" />
        </data>
        <data id="MASSM5.1.25_PhysicianSignature">
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderFirstName1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.RenderingProviderMiddleName1''], 1, 1)" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderLastName1'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderDegree1'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.25_PhysicianSignatureCurrentDate">
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 1, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 4, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 9, 2)" />
        </data>
        <data id="MASSM5.1.26_Accept_YES" />
        <data id="MASSM5.1.26_Accept_NO" />
        <data id="MASSM5.1.27_TotalCharge_Dollars">
          <xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''MASSM5.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
          <xsl:value-of select="$charges-dollars" />
        </data>
        <data id="MASSM5.1.27_TotalCharge_Cents">
          <xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''MASSM5.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$charges-cents" />
        </data>
        <data id="MASSM5.1.28_TotalPaid_Dollars">
          <xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''MASSM5.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
          <xsl:value-of select="$paid-dollars" />
        </data>
        <data id="MASSM5.1.28_TotalPaid_Cents">
          <xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''MASSM5.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$paid-cents" />
        </data>
        <data id="MASSM5.1.29_TotalBalance_Dollars">
          <xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''MASSM5.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
          <xsl:value-of select="$balance-dollars" />
        </data>
        <data id="MASSM5.1.29_TotalBalance_Cents">
          <xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''MASSM5.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$balance-cents" />
        </data>
        <data id="MASSM5.1.30_ServicingProviderNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderIndividualNumber1'']" />
        </data>
        <data id="MASSM5.1.31_PhysicianName">
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderFirstName1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.RenderingProviderMiddleName1''], 1, 1)" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderLastName1'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderDegree1'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.31_PhysicianAddress">
          <xsl:value-of select="data[@id=''MASSM5.1.PracticeStreet11'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.PracticeStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.PracticeStreet21'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.31_PhysicianCityStateZip">
          <xsl:value-of select="data[@id=''MASSM5.1.PracticeCity1'']" />
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.PracticeState1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM5.1.PracticeZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticeZip1''], 1, 5)" />
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticeZip1''], 6, 4)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PracticeZip1'']" />
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.31_PhysicianTelephone">
          <xsl:text>(</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticePhone1''], 1, 3)" />
          <xsl:text xml:space="preserve">) </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticePhone1''], 4, 3)" />
          <xsl:text>-</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticePhone1''], 7, 4)" />
        </data>
        <data id="MASSM5.1.31_PhysicianProviderNo">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM5.1.RenderingProviderGroupNumber1'']) &gt; 0">
              <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderGroupNumber1'']" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderIndividualNumber1'']" />
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.32_PatientAccountNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientAccountNumber1'']" />
        </data>
        <data id="MASSM5.1.33_BillingAgentNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.BillingAgentNumber1'']" />
        </data>
        <!-- Procedure 1 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID1'']" />
        </ClaimID>
        <data id="MASSM5.1.24a_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24a_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate1''] = data[@id=''MASSM5.1.ServiceEndDate1'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate1'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24a_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode1'']" />
        </data>
        <data id="MASSM5.1.24a_cTypeOfServiceCode" />
        <data id="MASSM5.1.24a_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode1'']" />
        </data>
        <data id="MASSM5.1.24a_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier11'']" />
        </data>
        <data id="MASSM5.1.24a_cProcedureExplanation" />
        <data id="MASSM5.1.24a_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code1'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount1''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24a_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24a_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24a_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount1'']" />
          </data>
          <data id="MASSM5.1.24a_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24a_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        <!-- Procedure 2 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID2'']" />
        </ClaimID>
        <data id="MASSM5.1.24b_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate2'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate2''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate2''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate2''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24b_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate2''] = data[@id=''MASSM5.1.ServiceEndDate2'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate2'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate2''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate2''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate2''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24b_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode2'']" />
        </data>
        <data id="MASSM5.1.24b_cTypeOfServiceCode" />
        <data id="MASSM5.1.24b_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode2'']" />
        </data>
        <data id="MASSM5.1.24b_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier12'']" />
        </data>
        <data id="MASSM5.1.24b_cProcedureExplanation" />
        <data id="MASSM5.1.24b_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code2'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount2''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24b_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24b_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24b_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount2'']" />
          </data>
          <data id="MASSM5.1.24b_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24b_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount2''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        <!-- Procedure 3 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID3'']" />
        </ClaimID>
        <data id="MASSM5.1.24c_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate3'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate3''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate3''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate3''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24c_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate3''] = data[@id=''MASSM5.1.ServiceEndDate3'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate3'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate3''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate3''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate3''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24c_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode3'']" />
        </data>
        <data id="MASSM5.1.24c_cTypeOfServiceCode" />
        <data id="MASSM5.1.24c_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode3'']" />
        </data>
        <data id="MASSM5.1.24c_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier13'']" />
        </data>
        <data id="MASSM5.1.24c_cProcedureExplanation" />
        <data id="MASSM5.1.24c_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code3'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount3''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24c_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24c_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24c_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount3'']" />
          </data>
          <data id="MASSM5.1.24c_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24c_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount3''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        <!-- Procedure 4 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID4'']" />
        </ClaimID>
        <data id="MASSM5.1.24d_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate4'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate4''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate4''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate4''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24d_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate4''] = data[@id=''MASSM5.1.ServiceEndDate4'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate4'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate4''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate4''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate4''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24d_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode4'']" />
        </data>
        <data id="MASSM5.1.24d_cTypeOfServiceCode" />
        <data id="MASSM5.1.24d_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode4'']" />
        </data>
        <data id="MASSM5.1.24d_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier14'']" />
        </data>
        <data id="MASSM5.1.24d_cProcedureExplanation" />
        <data id="MASSM5.1.24d_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code4'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount4''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24d_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24d_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24d_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount4'']" />
          </data>
          <data id="MASSM5.1.24d_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24d_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount4''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        <!-- Procedure 5 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID5'']" />
        </ClaimID>
        <data id="MASSM5.1.24e_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate5'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate5''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate5''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate5''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24e_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate5''] = data[@id=''MASSM5.1.ServiceEndDate5'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate5'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate5''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate5''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate5''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24e_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode5'']" />
        </data>
        <data id="MASSM5.1.24e_cTypeOfServiceCode" />
        <data id="MASSM5.1.24e_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode5'']" />
        </data>
        <data id="MASSM5.1.24e_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier15'']" />
        </data>
        <data id="MASSM5.1.24e_cProcedureExplanation" />
        <data id="MASSM5.1.24e_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code5'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount5''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24e_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24e_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24e_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount5'']" />
          </data>
          <data id="MASSM5.1.24e_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24e_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount5''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        <!-- Procedure 6 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID6'']" />
        </ClaimID>
        <data id="MASSM5.1.24f_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate6'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate6''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate6''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate6''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24f_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate6''] = data[@id=''MASSM5.1.ServiceEndDate6'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate6'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate6''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate6''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate6''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24f_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode6'']" />
        </data>
        <data id="MASSM5.1.24f_cTypeOfServiceCode" />
        <data id="MASSM5.1.24f_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode6'']" />
        </data>
        <data id="MASSM5.1.24f_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier16'']" />
        </data>
        <data id="MASSM5.1.24f_cProcedureExplanation" />
        <data id="MASSM5.1.24f_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code6'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount6''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24f_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24f_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24f_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount6'']" />
          </data>
          <data id="MASSM5.1.24f_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24f_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount6''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        <!-- Procedure 7 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID7'']" />
        </ClaimID>
        <data id="MASSM5.1.24g_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate7'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate7''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate7''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate7''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24g_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate7''] = data[@id=''MASSM5.1.ServiceEndDate7'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate7'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate7''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate7''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate7''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24g_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode7'']" />
        </data>
        <data id="MASSM5.1.24g_cTypeOfServiceCode" />
        <data id="MASSM5.1.24g_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode7'']" />
        </data>
        <data id="MASSM5.1.24g_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier17'']" />
        </data>
        <data id="MASSM5.1.24g_cProcedureExplanation" />
        <data id="MASSM5.1.24g_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code7'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount7''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24g_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount7''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24g_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount7''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24g_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount7'']" />
          </data>
          <data id="MASSM5.1.24g_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount7''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24g_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount7''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        <!-- Procedure 8 -->
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID8'']" />
        </ClaimID>
        <data id="MASSM5.1.24h_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate8'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate8''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate8''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate8''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24h_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate8''] = data[@id=''MASSM5.1.ServiceEndDate8'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate8'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate8''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate8''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate8''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24h_bPlaceOfServiceCode">
          <xsl:value-of select="data[@id=''MASSM5.1.PlaceOfServiceCode8'']" />
        </data>
        <data id="MASSM5.1.24h_cTypeOfServiceCode" />
        <data id="MASSM5.1.24h_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode8'']" />
        </data>
        <data id="MASSM5.1.24h_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier18'']" />
        </data>
        <data id="MASSM5.1.24h_cProcedureExplanation" />
        <data id="MASSM5.1.24h_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code8'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount8''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24h_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount8''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24h_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount8''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24h_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount8'']" />
          </data>
          <data id="MASSM5.1.24h_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount8''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24h_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount8''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
      </page>
    </formData>
  </xsl:template>
</xsl:stylesheet>'
WHERE BillingFormID = 10