/*
-----------------------------------------------------------------------------------------------------
CASE 13291 - Leave numerous fields blank.
-----------------------------------------------------------------------------------------------------
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
		<text x="1.56in" y="0.76in" width="1.84in" height="0.10in" valueSource="NYM.1.1_PatientName" />
		<text x="3.26in" y="0.76in" width="1.25in" height="0.10in" valueSource="NYM.1.2_PatientBirthDate" />
    <text x="5.09in" y="1.74in" width="3.15in" height="0.10in" valueSource="NYM.1.8_InsuredEmployer" />
    <text x="1.56in" y="1.99in" width="1.80in" height="0.10in" font-size="8pt" valueSource="NYM.1.9_OtherInsuredName" />
    <text x="1.56in" y="2.10in" width="1.80in" height="0.10in" font-size="8pt" valueSource="NYM.1.9_OtherInsuredPlanName" />
    <text x="1.56in" y="2.21in" width="1.80in" height="0.10in" font-size="8pt" valueSource="NYM.1.9_OtherInsuredAddress_Street" />
    <text x="1.56in" y="2.32in" width="1.80in" height="0.10in" font-size="8pt" valueSource="NYM.1.9_OtherInsuredAddress_CityStateZip" />
    <text x="1.56in" y="2.43in" width="1.80in" height="0.10in" font-size="8pt" valueSource="NYM.1.9_OtherInsuredPolicyNumber" />
		<text x="3.87in" y="2.06in" width="0.17in" height="0.10in" valueSource="NYM.1.10_PatientCondition_Employment" />
		<text x="3.87in" y="2.39in" width="0.17in" height="0.10in" valueSource="NYM.1.10_PatientCondition_AutoAccident" />
		<text x="4.23in" y="2.39in" width="0.17in" height="0.10in" valueSource="NYM.1.10_PatientCondition_OtherLiability" />
		<text x="0.16in" y="3.42in" width="0.83in" height="0.10in" valueSource="NYM.1.14_IllnessStartDate" />
    <text x="0.99in" y="3.42in" width="0.83in" height="0.10in" valueSource="NYM.1.15_FirstConsultationDate" />
    <text x="4.14in" y="3.42in" width="0.93in" height="0.10in" valueSource="NYM.1.17_ReturnToWorkDate" />
		<text x="0.19in" y="3.73in" width="3.12in" height="0.10in" valueSource="NYM.1.19_ReferringPhyscianName" />
    <text x="5.63in" y="3.73in" width="1.67in" height="0.10in" valueSource="NYM.1.19C_IDNumber" />
		<text x="1.36in" y="4.07in" width="0.93in" height="0.10in" valueSource="NYM.1.20_HospitalizationBeginDate" />
		<text x="2.27in" y="4.07in" width="0.93in" height="0.10in" valueSource="NYM.1.20_HospitalizationEndDate" />
		<text x="0.19in" y="4.40in" width="3.12in" height="0.10in" valueSource="NYM.1.21_FacilityName" />
    <text x="3.22in" y="4.40in" width="2.62in" height="0.10in" valueSource="NYM.1.21A_FacilityAddress" />
    <text x="6.59in" y="4.99in" width="0.17in" height="0.10in" valueSource="NYM.1.22G_EPSDT_THP_YES" />
    <text x="6.78in" y="4.99in" width="0.17in" height="0.10in" valueSource="NYM.1.22G_EPSDT_THP_NO" />
    <text x="7.60in" y="4.99in" width="0.17in" height="0.10in" valueSource="NYM.1.22H_FamilyPlanning_YES" />
    <text x="7.79in" y="4.99in" width="0.17in" height="0.10in" valueSource="NYM.1.22H_FamilyPlanning_NO" />
    <text x="7.39in" y="5.40in" width="0.17in" height="0.10in" valueSource="NYM.1.23B_PaymentSourceCode_M" />
    <text x="7.59in" y="5.40in" width="0.17in" height="0.10in" valueSource="NYM.1.23B_PaymentSourceCode_O" />
	</g>
  
	<g class="smaller">
		<text x="0.13in" y="6.09in" width="0.83in" height="0.10in" valueSource="NYM.1.24A_ServiceBeginDate1" />
		<text x="1.05in" y="6.09in" width="0.32in" height="0.10in" valueSource="NYM.1.24B_PlaceOfServiceCode1" />
		<text x="1.34in" y="6.09in" width="0.63in" height="0.10in" valueSource="NYM.1.24C_ProcedureCode1" />
		<text x="1.95in" y="6.09in" width="0.32in" height="0.10in" valueSource="NYM.1.24D_ProcedureModifier1" />
    <text x="2.25in" y="6.09in" width="0.32in" height="0.10in" valueSource="NYM.1.24E_ProcedureModifier1" />
    <text x="2.55in" y="6.09in" width="0.32in" height="0.10in" valueSource="NYM.1.24F_ProcedureModifier1" />
    <text x="2.85in" y="6.09in" width="0.32in" height="0.10in" valueSource="NYM.1.24G_ProcedureModifier1" />
		<text x="3.28in" y="6.09in" width="1.07in" height="0.10in" valueSource="NYM.1.24H_DiagnosisPointer1Code1" />
		<text x="3.95in" y="6.09in" width="0.52in" height="0.10in" text-anchor="end" valueSource="NYM.1.24I_ServiceUnitCount1" />
    <text x="4.42in" y="6.09in" width="0.94in" height="0.10in" valueSource="NYM.1.24J_Charges_Dollars1" class="money" />
    <text x="5.44in" y="6.09in" width="0.31in" height="0.10in" valueSource="NYM.1.24J_Charges_Cents1" />
    <text x="5.64in" y="6.09in" width="0.94in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Dollars1" class="money" />
    <text x="6.66in" y="6.09in" width="0.31in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Cents1" />
    <text x="6.86in" y="6.09in" width="0.94in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars1" class="money" />
    <text x="7.88in" y="6.09in" width="0.31in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents1" />

    <text x="0.13in" y="6.405in" width="0.83in" height="0.10in" valueSource="NYM.1.24A_ServiceBeginDate2" />
    <text x="1.05in" y="6.405in" width="0.32in" height="0.10in" valueSource="NYM.1.24B_PlaceOfServiceCode2" />
    <text x="1.34in" y="6.405in" width="0.63in" height="0.10in" valueSource="NYM.1.24C_ProcedureCode2" />
    <text x="1.95in" y="6.405in" width="0.32in" height="0.10in" valueSource="NYM.1.24D_ProcedureModifier2" />
    <text x="2.25in" y="6.405in" width="0.32in" height="0.10in" valueSource="NYM.1.24E_ProcedureModifier2" />
    <text x="2.55in" y="6.405in" width="0.32in" height="0.10in" valueSource="NYM.1.24F_ProcedureModifier2" />
    <text x="2.85in" y="6.405in" width="0.32in" height="0.10in" valueSource="NYM.1.24G_ProcedureModifier2" />
    <text x="3.28in" y="6.405in" width="1.07in" height="0.10in" valueSource="NYM.1.24H_DiagnosisPointer1Code2" />
    <text x="3.95in" y="6.405in" width="0.52in" height="0.10in" text-anchor="end" valueSource="NYM.1.24I_ServiceUnitCount2" />
    <text x="4.42in" y="6.405in" width="0.94in" height="0.10in" valueSource="NYM.1.24J_Charges_Dollars2" class="money" />
    <text x="5.44in" y="6.405in" width="0.31in" height="0.10in" valueSource="NYM.1.24J_Charges_Cents2" />
    <text x="5.64in" y="6.405in" width="0.94in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Dollars2" class="money" />
    <text x="6.66in" y="6.405in" width="0.31in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Cents2" />
    <text x="6.86in" y="6.405in" width="0.94in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars2" class="money" />
    <text x="7.88in" y="6.405in" width="0.31in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents2" />

    <text x="0.13in" y="6.72in" width="0.83in" height="0.10in" valueSource="NYM.1.24A_ServiceBeginDate3" />
    <text x="1.05in" y="6.72in" width="0.32in" height="0.10in" valueSource="NYM.1.24B_PlaceOfServiceCode3" />
    <text x="1.34in" y="6.72in" width="0.63in" height="0.10in" valueSource="NYM.1.24C_ProcedureCode3" />
    <text x="1.95in" y="6.72in" width="0.32in" height="0.10in" valueSource="NYM.1.24D_ProcedureModifier3" />
    <text x="2.25in" y="6.72in" width="0.32in" height="0.10in" valueSource="NYM.1.24E_ProcedureModifier3" />
    <text x="2.55in" y="6.72in" width="0.32in" height="0.10in" valueSource="NYM.1.24F_ProcedureModifier3" />
    <text x="2.85in" y="6.72in" width="0.32in" height="0.10in" valueSource="NYM.1.24G_ProcedureModifier3" />
    <text x="3.28in" y="6.72in" width="1.07in" height="0.10in" valueSource="NYM.1.24H_DiagnosisPointer1Code3" />
    <text x="3.95in" y="6.72in" width="0.52in" height="0.10in" text-anchor="end" valueSource="NYM.1.24I_ServiceUnitCount3" />
    <text x="4.42in" y="6.72in" width="0.94in" height="0.10in" valueSource="NYM.1.24J_Charges_Dollars3" class="money" />
    <text x="5.44in" y="6.72in" width="0.31in" height="0.10in" valueSource="NYM.1.24J_Charges_Cents3" />
    <text x="5.64in" y="6.72in" width="0.94in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Dollars3" class="money" />
    <text x="6.66in" y="6.72in" width="0.31in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Cents3" />
    <text x="6.86in" y="6.72in" width="0.94in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars3" class="money" />
    <text x="7.88in" y="6.72in" width="0.31in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents3" />

    <text x="0.13in" y="7.03in" width="0.83in" height="0.10in" valueSource="NYM.1.24A_ServiceBeginDate4" />
    <text x="1.05in" y="7.03in" width="0.32in" height="0.10in" valueSource="NYM.1.24B_PlaceOfServiceCode4" />
    <text x="1.34in" y="7.03in" width="0.63in" height="0.10in" valueSource="NYM.1.24C_ProcedureCode4" />
    <text x="1.95in" y="7.03in" width="0.32in" height="0.10in" valueSource="NYM.1.24D_ProcedureModifier4" />
    <text x="2.25in" y="7.03in" width="0.32in" height="0.10in" valueSource="NYM.1.24E_ProcedureModifier4" />
    <text x="2.55in" y="7.03in" width="0.32in" height="0.10in" valueSource="NYM.1.24F_ProcedureModifier4" />
    <text x="2.85in" y="7.03in" width="0.32in" height="0.10in" valueSource="NYM.1.24G_ProcedureModifier4" />
    <text x="3.28in" y="7.03in" width="1.07in" height="0.10in" valueSource="NYM.1.24H_DiagnosisPointer1Code4" />
    <text x="3.95in" y="7.03in" width="0.52in" height="0.10in" text-anchor="end" valueSource="NYM.1.24I_ServiceUnitCount4" />
    <text x="4.42in" y="7.03in" width="0.94in" height="0.10in" valueSource="NYM.1.24J_Charges_Dollars4" class="money" />
    <text x="5.44in" y="7.03in" width="0.31in" height="0.10in" valueSource="NYM.1.24J_Charges_Cents4" />
    <text x="5.64in" y="7.03in" width="0.94in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Dollars4" class="money" />
    <text x="6.66in" y="7.03in" width="0.31in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Cents4" />
    <text x="6.86in" y="7.03in" width="0.94in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars4" class="money" />
    <text x="7.88in" y="7.03in" width="0.31in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents4" />

    <text x="0.13in" y="7.345in" width="0.83in" height="0.10in" valueSource="NYM.1.24A_ServiceBeginDate5" />
    <text x="1.05in" y="7.345in" width="0.32in" height="0.10in" valueSource="NYM.1.24B_PlaceOfServiceCode5" />
    <text x="1.34in" y="7.345in" width="0.63in" height="0.10in" valueSource="NYM.1.24C_ProcedureCode5" />
    <text x="1.95in" y="7.345in" width="0.32in" height="0.10in" valueSource="NYM.1.24D_ProcedureModifier5" />
    <text x="2.25in" y="7.345in" width="0.32in" height="0.10in" valueSource="NYM.1.24E_ProcedureModifier5" />
    <text x="2.55in" y="7.345in" width="0.32in" height="0.10in" valueSource="NYM.1.24F_ProcedureModifier5" />
    <text x="2.85in" y="7.345in" width="0.32in" height="0.10in" valueSource="NYM.1.24G_ProcedureModifier5" />
    <text x="3.28in" y="7.345in" width="1.07in" height="0.10in" valueSource="NYM.1.24H_DiagnosisPointer1Code5" />
		<text x="3.95in" y="7.345in" width="0.52in" height="0.10in" text-anchor="end" valueSource="NYM.1.24I_ServiceUnitCount5" />
    <text x="4.42in" y="7.345in" width="0.94in" height="0.10in" valueSource="NYM.1.24J_Charges_Dollars5" class="money" />
    <text x="5.44in" y="7.345in" width="0.31in" height="0.10in" valueSource="NYM.1.24J_Charges_Cents5" />
    <text x="5.64in" y="7.345in" width="0.94in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Dollars5" class="money" />
    <text x="6.66in" y="7.345in" width="0.31in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Cents5" />
    <text x="6.86in" y="7.345in" width="0.94in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars5" class="money" />
    <text x="7.88in" y="7.345in" width="0.31in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents5" />

    <text x="0.13in" y="7.66in" width="0.83in" height="0.10in" valueSource="NYM.1.24A_ServiceBeginDate6" />
    <text x="1.05in" y="7.66in" width="0.32in" height="0.10in" valueSource="NYM.1.24B_PlaceOfServiceCode6" />
    <text x="1.34in" y="7.66in" width="0.63in" height="0.10in" valueSource="NYM.1.24C_ProcedureCode6" />
    <text x="1.95in" y="7.66in" width="0.32in" height="0.10in" valueSource="NYM.1.24D_ProcedureModifier6" />
    <text x="2.25in" y="7.66in" width="0.32in" height="0.10in" valueSource="NYM.1.24E_ProcedureModifier6" />
    <text x="2.55in" y="7.66in" width="0.32in" height="0.10in" valueSource="NYM.1.24F_ProcedureModifier6" />
    <text x="2.85in" y="7.66in" width="0.32in" height="0.10in" valueSource="NYM.1.24G_ProcedureModifier6" />
    <text x="3.28in" y="7.66in" width="1.07in" height="0.10in" valueSource="NYM.1.24H_DiagnosisPointer1Code6" />
    <text x="3.95in" y="7.66in" width="0.52in" height="0.10in" text-anchor="end" valueSource="NYM.1.24I_ServiceUnitCount6" />
    <text x="4.42in" y="7.66in" width="0.94in" height="0.10in" valueSource="NYM.1.24J_Charges_Dollars6" class="money" />
    <text x="5.44in" y="7.66in" width="0.31in" height="0.10in" valueSource="NYM.1.24J_Charges_Cents6" />
    <text x="5.64in" y="7.66in" width="0.94in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Dollars6" class="money" />
    <text x="6.66in" y="7.66in" width="0.31in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Cents6" />
    <text x="6.86in" y="7.66in" width="0.94in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars6" class="money" />
    <text x="7.88in" y="7.66in" width="0.31in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents6" />

    <text x="0.13in" y="7.975in" width="0.83in" height="0.10in" valueSource="NYM.1.24A_ServiceBeginDate7" />
    <text x="1.05in" y="7.975in" width="0.32in" height="0.10in" valueSource="NYM.1.24B_PlaceOfServiceCode7" />
    <text x="1.34in" y="7.975in" width="0.63in" height="0.10in" valueSource="NYM.1.24C_ProcedureCode7" />
    <text x="1.95in" y="7.975in" width="0.32in" height="0.10in" valueSource="NYM.1.24D_ProcedureModifier7" />
    <text x="2.25in" y="7.975in" width="0.32in" height="0.10in" valueSource="NYM.1.24E_ProcedureModifier7" />
    <text x="2.55in" y="7.975in" width="0.32in" height="0.10in" valueSource="NYM.1.24F_ProcedureModifier7" />
    <text x="2.85in" y="7.975in" width="0.32in" height="0.10in" valueSource="NYM.1.24G_ProcedureModifier7" />
    <text x="3.28in" y="7.975in" width="1.07in" height="0.10in" valueSource="NYM.1.24H_DiagnosisPointer1Code7" />
		<text x="3.95in" y="7.975in" width="0.52in" height="0.10in" text-anchor="end" valueSource="NYM.1.24I_ServiceUnitCount7" />
		<text x="4.42in" y="7.975in" width="0.94in" height="0.10in" valueSource="NYM.1.24J_Charges_Dollars7" class="money" />
    <text x="5.44in" y="7.975in" width="0.31in" height="0.10in" valueSource="NYM.1.24J_Charges_Cents7" />
    <text x="5.64in" y="7.975in" width="0.94in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Dollars7" class="money" />
    <text x="6.66in" y="7.975in" width="0.31in" height="0.10in" valueSource="NYM.1.24K_MedicarePayments_Cents7" />
    <text x="6.86in" y="7.975in" width="0.94in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Dollars7" class="money" />
    <text x="7.88in" y="7.975in" width="0.31in" height="0.10in" valueSource="NYM.1.24L_OtherInsurancePayments_Cents7" />
	</g>
  
	<g>
		<text x="2.10in" y="10.08in" width="3.0in" height="0.10in" valueSource="NYM.1.32_PatientAccountNumber" />
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
        <data id="NYM.1.10_PatientCondition_AutoAccident">
          <xsl:if test="data[@id=''NYM.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="NYM.1.10_PatientCondition_OtherLiability">
          <xsl:if test="data[@id=''NYM.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
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
        
        <data id="NYM.1.17_ReturnToWorkDate">
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
        
        <data id="NYM.1.19C_IDNumber">
          <xsl:value-of select="data[@id=''NYM.1.ReferringProviderIDNumber1'']"/>
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

        <xsl:if test="(data[@id=''NYM.1.PlaceOfServiceCode1''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode2''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode3''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode4''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode5''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode6''] = ''99'' or data[@id=''NYM.1.PlaceOfServiceCode7''] = ''99'') and data[@id=''NYM.1.PayerInsuranceType1''] = ''MB''">
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

        <data id="NYM.1.23B_PaymentSourceCode_M">
          <xsl:value-of select="data[@id=''NYM.1.PaymentSourceCodeM1'']"/>
        </data>

        <data id="NYM.1.23B_PaymentSourceCode_O">
          <xsl:value-of select="data[@id=''NYM.1.PaymentSourceCodeO1'']"/>
        </data>
       
        <data id="NYM.1.32_PatientAccountNumber">
	        <xsl:value-of select="data[@id=''NYM.1.PatientAccountNumber1'']"/>
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