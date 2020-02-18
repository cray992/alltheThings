/*
-----------------------------------------------------------------------------------------------------
CASE 15858 - Implement Massachusetts Medicaid Form 9 Billing Form
-----------------------------------------------------------------------------------------------------
*/
/*
INSERT INTO BillingForm(BillingFormID, FormType, FormName, PrintingFormID, MaxProcedures, MaxDiagnosis)
VALUES(14, 'MASSM9', 'Massachusetts Medicaid Form 9', 20, 10, 4)

INSERT INTO PrintingForm(PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
VALUES(20, 'MASSM9', 'Massachusetts Medicaid Form 9', 'BillDataProvider_GetMASSM9DocumentData', 0)

INSERT INTO PrintingFormDetails(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description)
VALUES(77, 20, 64, 'Massachusetts Medicaid Form 9')
*/
UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="MASSM9" pageId="MASSM9.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
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
    <text x="0.29in" y="1.81in" width="3.78in" height="0.10in" valueSource="MASSM9.1.1_ProviderName" />
    <text x="0.29in" y="1.96in" width="3.78in" height="0.10in" valueSource="MASSM9.1.1_ProviderAddress" />
    <text x="0.29in" y="2.11in" width="3.78in" height="0.10in" valueSource="MASSM9.1.1_ProviderCityStateZip" />
    <text x="0.29in" y="2.26in" width="3.78in" height="0.10in" valueSource="MASSM9.1.1_ProviderTelephone" />
    <text x="4.13in" y="2.39in" width="1.46in" height="0.10in" valueSource="MASSM9.1.2_ProviderNumber" />
    <text x="0.29in" y="2.79in" width="2.57in" height="0.10in" valueSource="MASSM9.1.5_ServicingProviderName" />
    <text x="6.98in" y="2.79in" width="1.39in" height="0.10in" valueSource="MASSM9.1.8_ReferringProviderNumber" />
		<text x="0.29in" y="3.37in" width="2.56in" height="0.10in" valueSource="MASSM9.1.9_PatientName" />
    <text x="2.88in" y="3.37in" width="2.07in" height="0.10in" valueSource="MASSM9.1.10_PolicyNumber" />
		<text x="5.01in" y="3.37in" width="1.26in" height="0.10in" valueSource="MASSM9.1.11_PatientBirthDate" />
		<text x="6.34in" y="3.34in" width="0.17in" height="0.10in" valueSource="MASSM9.1.12_PatientGender" />
    <text x="6.69in" y="3.34in" width="0.17in" height="0.10in" valueSource="MASSM9.1.13_OtherInsurance" />
    <text x="7.07in" y="3.37in" width="1.29in" height="0.10in" valueSource="MASSM9.1.14_PatientAccountNumber" />
    <text x="0.50in" y="3.76in" width="0.52in" height="0.10in" valueSource="MASSM9.1.15_PlaceOfService" />
    <text x="1.01in" y="3.76in" width="0.17in" height="0.10in" valueSource="MASSM9.1.16A_AccidentRelated_NO" />
    <text x="1.67in" y="3.76in" width="0.17in" height="0.10in" valueSource="MASSM9.1.16A_AccidentRelated_YES" />
    <text x="2.61in" y="3.76in" width="0.17in" height="0.10in" valueSource="MASSM9.1.16B_AccidentType" />
    <text x="2.88in" y="3.79in" width="1.26in" height="0.10in" valueSource="MASSM9.1.16C_InjuryDate" />
    <text x="4.28in" y="3.76in" width="0.17in" height="0.10in" valueSource="MASSM9.1.17_EPSDTRelated_NO" />
    <text x="4.93in" y="3.76in" width="0.17in" height="0.10in" valueSource="MASSM9.1.17_EPSDTRelated_YES" />
    <text x="0.34in" y="4.42in" width="1.28in" height="0.10in" valueSource="MASSM9.1.21_DiagnosisCode1" />
    <text x="1.70in" y="4.42in" width="2.67in" height="0.10in" valueSource="MASSM9.1.22_DiagnosisName1" />
	</g>
  
	<g class="smaller">
    <text x="0.58in" y="5.26in" width="1.09in" height="0.10in" valueSource="MASSM9.1.26_ServiceBeginDate1" />
    <text x="2.55in" y="5.26in" width="1.65in" height="0.10in" valueSource="MASSM9.1.27_Description1" />
    <text x="4.20in" y="5.26in" width="1.0in" height="0.10in" valueSource="MASSM9.1.28_ProcedureCode_Modifier1" />
    <text x="5.58in" y="5.26in" width="0.52in" height="0.10in" text-anchor="end" valueSource="MASSM9.1.31_ServiceUnitCount1" />
    <text x="6.06in" y="5.26in" width="0.59in" height="0.10in" valueSource="MASSM9.1.32_Charges_Dollars1" class="money" />
    <text x="6.75in" y="5.26in" width="0.31in" height="0.10in" valueSource="MASSM9.1.32_Charges_Cents1" />
    <text x="6.94in" y="5.26in" width="0.72in" height="0.10in" valueSource="MASSM9.1.33_Paid_Dollars1" class="money" />
    <text x="7.75in" y="5.26in" width="0.29in" height="0.10in" valueSource="MASSM9.1.33_Paid_Cents1" />

    <text x="0.58in" y="5.59in" width="1.09in" height="0.10in" valueSource="MASSM9.1.26_ServiceBeginDate2" />
    <text x="2.55in" y="5.59in" width="1.65in" height="0.10in" valueSource="MASSM9.1.27_Description2" />
    <text x="4.20in" y="5.59in" width="1.0in" height="0.10in" valueSource="MASSM9.1.28_ProcedureCode_Modifier2" />
    <text x="5.58in" y="5.59in" width="0.52in" height="0.10in" text-anchor="end" valueSource="MASSM9.1.31_ServiceUnitCount2" />
    <text x="6.06in" y="5.59in" width="0.59in" height="0.10in" valueSource="MASSM9.1.32_Charges_Dollars2" class="money" />
    <text x="6.75in" y="5.59in" width="0.31in" height="0.10in" valueSource="MASSM9.1.32_Charges_Cents2" />
    <text x="6.94in" y="5.59in" width="0.72in" height="0.10in" valueSource="MASSM9.1.33_Paid_Dollars2" class="money" />
    <text x="7.75in" y="5.59in" width="0.29in" height="0.10in" valueSource="MASSM9.1.33_Paid_Cents2" />

    <text x="0.58in" y="5.92in" width="1.09in" height="0.10in" valueSource="MASSM9.1.26_ServiceBeginDate3" />
    <text x="2.55in" y="5.92in" width="1.65in" height="0.10in" valueSource="MASSM9.1.27_Description3" />
    <text x="4.20in" y="5.92in" width="1.0in" height="0.10in" valueSource="MASSM9.1.28_ProcedureCode_Modifier3" />
    <text x="5.58in" y="5.92in" width="0.52in" height="0.10in" text-anchor="end" valueSource="MASSM9.1.31_ServiceUnitCount3" />
    <text x="6.06in" y="5.92in" width="0.59in" height="0.10in" valueSource="MASSM9.1.32_Charges_Dollars3" class="money" />
    <text x="6.75in" y="5.92in" width="0.31in" height="0.10in" valueSource="MASSM9.1.32_Charges_Cents3" />
    <text x="6.94in" y="5.92in" width="0.72in" height="0.10in" valueSource="MASSM9.1.33_Paid_Dollars3" class="money" />
    <text x="7.75in" y="5.92in" width="0.29in" height="0.10in" valueSource="MASSM9.1.33_Paid_Cents3" />

    <text x="0.58in" y="6.26in" width="1.09in" height="0.10in" valueSource="MASSM9.1.26_ServiceBeginDate4" />
    <text x="2.55in" y="6.26in" width="1.65in" height="0.10in" valueSource="MASSM9.1.27_Description4" />
    <text x="4.20in" y="6.26in" width="1.0in" height="0.10in" valueSource="MASSM9.1.28_ProcedureCode_Modifier4" />
    <text x="5.58in" y="6.26in" width="0.52in" height="0.10in" text-anchor="end" valueSource="MASSM9.1.31_ServiceUnitCount4" />
    <text x="6.06in" y="6.26in" width="0.59in" height="0.10in" valueSource="MASSM9.1.32_Charges_Dollars4" class="money" />
    <text x="6.75in" y="6.26in" width="0.31in" height="0.10in" valueSource="MASSM9.1.32_Charges_Cents4" />
    <text x="6.94in" y="6.26in" width="0.72in" height="0.10in" valueSource="MASSM9.1.33_Paid_Dollars4" class="money" />
    <text x="7.75in" y="6.26in" width="0.29in" height="0.10in" valueSource="MASSM9.1.33_Paid_Cents4" />

    <text x="0.58in" y="6.59in" width="1.09in" height="0.10in" valueSource="MASSM9.1.26_ServiceBeginDate5" />
    <text x="2.55in" y="6.59in" width="1.65in" height="0.10in" valueSource="MASSM9.1.27_Description5" />
    <text x="4.20in" y="6.59in" width="1.0in" height="0.10in" valueSource="MASSM9.1.28_ProcedureCode_Modifier5" />
    <text x="5.58in" y="6.59in" width="0.52in" height="0.10in" text-anchor="end" valueSource="MASSM9.1.31_ServiceUnitCount5" />
    <text x="6.06in" y="6.59in" width="0.59in" height="0.10in" valueSource="MASSM9.1.32_Charges_Dollars5" class="money" />
    <text x="6.75in" y="6.59in" width="0.31in" height="0.10in" valueSource="MASSM9.1.32_Charges_Cents5" />
    <text x="6.94in" y="6.59in" width="0.72in" height="0.10in" valueSource="MASSM9.1.33_Paid_Dollars5" class="money" />
    <text x="7.75in" y="6.59in" width="0.29in" height="0.10in" valueSource="MASSM9.1.33_Paid_Cents5" />

    <text x="0.58in" y="6.92in" width="1.09in" height="0.10in" valueSource="MASSM9.1.26_ServiceBeginDate6" />
    <text x="2.55in" y="6.92in" width="1.65in" height="0.10in" valueSource="MASSM9.1.27_Description6" />
    <text x="4.20in" y="6.92in" width="1.0in" height="0.10in" valueSource="MASSM9.1.28_ProcedureCode_Modifier6" />
    <text x="5.58in" y="6.92in" width="0.52in" height="0.10in" text-anchor="end" valueSource="MASSM9.1.31_ServiceUnitCount6" />
    <text x="6.06in" y="6.92in" width="0.59in" height="0.10in" valueSource="MASSM9.1.32_Charges_Dollars6" class="money" />
    <text x="6.75in" y="6.92in" width="0.31in" height="0.10in" valueSource="MASSM9.1.32_Charges_Cents6" />
    <text x="6.94in" y="6.92in" width="0.72in" height="0.10in" valueSource="MASSM9.1.33_Paid_Dollars6" class="money" />
    <text x="7.75in" y="6.92in" width="0.29in" height="0.10in" valueSource="MASSM9.1.33_Paid_Cents6" />

    <text x="0.58in" y="7.26in" width="1.09in" height="0.10in" valueSource="MASSM9.1.26_ServiceBeginDate7" />
    <text x="2.55in" y="7.26in" width="1.65in" height="0.10in" valueSource="MASSM9.1.27_Description7" />
    <text x="4.20in" y="7.26in" width="1.0in" height="0.10in" valueSource="MASSM9.1.28_ProcedureCode_Modifier7" />
    <text x="5.58in" y="7.26in" width="0.52in" height="0.10in" text-anchor="end" valueSource="MASSM9.1.31_ServiceUnitCount7" />
    <text x="6.06in" y="7.26in" width="0.59in" height="0.10in" valueSource="MASSM9.1.32_Charges_Dollars7" class="money" />
    <text x="6.75in" y="7.26in" width="0.31in" height="0.10in" valueSource="MASSM9.1.32_Charges_Cents7" />
    <text x="6.94in" y="7.26in" width="0.72in" height="0.10in" valueSource="MASSM9.1.33_Paid_Dollars7" class="money" />
    <text x="7.75in" y="7.26in" width="0.29in" height="0.10in" valueSource="MASSM9.1.33_Paid_Cents7" />

    <text x="0.58in" y="7.59in" width="1.09in" height="0.10in" valueSource="MASSM9.1.26_ServiceBeginDate8" />
    <text x="2.55in" y="7.59in" width="1.65in" height="0.10in" valueSource="MASSM9.1.27_Description8" />
    <text x="4.20in" y="7.59in" width="1.0in" height="0.10in" valueSource="MASSM9.1.28_ProcedureCode_Modifier8" />
    <text x="5.58in" y="7.59in" width="0.52in" height="0.10in" text-anchor="end" valueSource="MASSM9.1.31_ServiceUnitCount8" />
		<text x="6.06in" y="7.59in" width="0.59in" height="0.10in" valueSource="MASSM9.1.32_Charges_Dollars8" class="money" />
		<text x="6.75in" y="7.59in" width="0.31in" height="0.10in" valueSource="MASSM9.1.32_Charges_Cents8" />
		<text x="6.94in" y="7.59in" width="0.72in" height="0.10in" valueSource="MASSM9.1.33_Paid_Dollars8" class="money" />
		<text x="7.75in" y="7.59in" width="0.29in" height="0.10in" valueSource="MASSM9.1.33_Paid_Cents8" />

    <text x="0.58in" y="7.93in" width="1.09in" height="0.10in" valueSource="MASSM9.1.26_ServiceBeginDate9" />
    <text x="2.55in" y="7.93in" width="1.65in" height="0.10in" valueSource="MASSM9.1.27_Description9" />
    <text x="4.20in" y="7.93in" width="1.0in" height="0.10in" valueSource="MASSM9.1.28_ProcedureCode_Modifier9" />
    <text x="5.58in" y="7.93in" width="0.52in" height="0.10in" text-anchor="end" valueSource="MASSM9.1.31_ServiceUnitCount9" />
    <text x="6.06in" y="7.93in" width="0.59in" height="0.10in" valueSource="MASSM9.1.32_Charges_Dollars9" class="money" />
    <text x="6.75in" y="7.93in" width="0.31in" height="0.10in" valueSource="MASSM9.1.32_Charges_Cents9" />
    <text x="6.94in" y="7.93in" width="0.72in" height="0.10in" valueSource="MASSM9.1.33_Paid_Dollars9" class="money" />
    <text x="7.75in" y="7.93in" width="0.29in" height="0.10in" valueSource="MASSM9.1.33_Paid_Cents9" />

    <text x="0.58in" y="8.27in" width="1.09in" height="0.10in" valueSource="MASSM9.1.26_ServiceBeginDate10" />
    <text x="2.55in" y="8.27in" width="1.65in" height="0.10in" valueSource="MASSM9.1.27_Description10" />
    <text x="4.20in" y="8.27in" width="1.0in" height="0.10in" valueSource="MASSM9.1.28_ProcedureCode_Modifier10" />
    <text x="5.58in" y="8.27in" width="0.52in" height="0.10in" text-anchor="end" valueSource="MASSM9.1.31_ServiceUnitCount10" />
    <text x="6.06in" y="8.27in" width="0.59in" height="0.10in" valueSource="MASSM9.1.32_Charges_Dollars10" class="money" />
    <text x="6.75in" y="8.27in" width="0.31in" height="0.10in" valueSource="MASSM9.1.32_Charges_Cents10" />
    <text x="6.94in" y="8.27in" width="0.72in" height="0.10in" valueSource="MASSM9.1.33_Paid_Dollars10" class="money" />
    <text x="7.75in" y="8.27in" width="0.29in" height="0.10in" valueSource="MASSM9.1.33_Paid_Cents10" />
	</g>
  
	<g>
    <text x="6.05in" y="8.59in" width="0.59in" height="0.10in" valueSource="MASSM9.1.36_TotalCharge_Dollars" class="money" />
    <text x="6.70in" y="8.59in" width="0.31in" height="0.10in" valueSource="MASSM9.1.36_TotalCharge_Cents" />
    <text x="6.93in" y="8.59in" width="0.72in" height="0.10in" valueSource="MASSM9.1.37_TotalPaid_Dollars" class="money" />
    <text x="7.70in" y="8.59in" width="0.31in" height="0.10in" valueSource="MASSM9.1.37_TotalPaid_Cents" />
    <text x="0.29in" y="10.56in" width="2.79in" height="0.10in" valueSource="MASSM9.1.38_PhysicianSignature" />
    <text x="2.99in" y="10.56in" width="1.26in" height="0.10in" valueSource="MASSM9.1.39_PhysicianSignatureCurrentDate" />
  </g>
  
</svg>'
WHERE PrintingFormDetailsID = 77

Update BillingForm
SET TransForm = '<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml"/>
  <xsl:decimal-format name="default-format" NaN="0.00"/>
  <xsl:template match="/formData/page">
    <formData formId="MASSM9">
      <page pageId="MASSM9.1">
        <BillID>
          <xsl:value-of select="data[@id=''MASSM9.1.BillID1'']"/>
        </BillID>

        <data id="MASSM9.1.1_ProviderName">
          <xsl:value-of select="data[@id=''MASSM9.1.RenderingProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM9.1.RenderingProviderMiddleName1''], 1, 1)"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="data[@id=''MASSM9.1.RenderingProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''MASSM9.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.RenderingProviderDegree1'']"/>
          </xsl:if>
        </data>
        <data id="MASSM9.1.1_ProviderAddress">
          <xsl:value-of select="data[@id=''MASSM9.1.PracticeStreet11'']"/>
          <xsl:if test="string-length(data[@id=''MASSM9.1.PracticeStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.PracticeStreet21'']"/>
          </xsl:if>
        </data>
        <data id="MASSM9.1.1_ProviderCityStateZip">
          <xsl:value-of select="data[@id=''MASSM9.1.PracticeCity1'']"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''MASSM9.1.PracticeState1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM9.1.PracticeZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''MASSM9.1.PracticeZip1''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM9.1.PracticeZip1''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM9.1.PracticeZip1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM9.1.1_ProviderTelephone">
          <xsl:text>(</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM9.1.PracticePhone1''], 1, 3)"/>
          <xsl:text xml:space="preserve">) </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM9.1.PracticePhone1''], 4, 3)"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM9.1.PracticePhone1''], 7, 4)"/>
        </data>

        <data id="MASSM9.1.2_ProviderNumber">
          <xsl:value-of select="data[@id=''MASSM9.1.RenderingProviderMedicaidID1'']"/>
        </data>

        <data id="MASSM9.1.5_ServicingProviderName">
          <xsl:value-of select="data[@id=''MASSM9.1.PracticeName1'']"/>
        </data>

        <data id="MASSM9.1.8_ReferringProviderNumber">
          <xsl:value-of select="data[@id=''MASSM9.1.ReferringProviderNumber1'']"/>
        </data>
        
        <data id="MASSM9.1.9_PatientName">
          <xsl:value-of select="data[@id=''MASSM9.1.PatientFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''MASSM9.1.PatientMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.PatientMiddleName1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''MASSM9.1.PatientLastName1'']"/>
          <xsl:if test="string-length(data[@id=''MASSM9.1.PatientSuffix1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.PatientSuffix1'']"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.10_PolicyNumber">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM9.1.PolicyNumber1'']) &gt; 0">
              <xsl:value-of select="data[@id=''MASSM9.1.PolicyNumber1'']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM9.1.DependentPolicyNumber1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>

        <data id="MASSM9.1.11_PatientBirthDate">
          <xsl:if test="string-length(data[@id=''MASSM9.1.PatientBirthDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.PatientBirthDate1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.PatientBirthDate1''], 2, 1)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.PatientBirthDate1''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.PatientBirthDate1''], 5, 1)"/>
            <xsl:text xml:space="preserve">  </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.PatientBirthDate1''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.PatientBirthDate1''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.12_PatientGender">
          <xsl:value-of select="data[@id=''MASSM9.1.PatientGender1'']"/>
        </data>

        <data id="MASSM9.1.13_OtherInsurance">
          <xsl:if test="string-length(data[@id=''MASSM9.1.OtherPayerName1'']) &gt; 0">X</xsl:if>
        </data>
        
        <data id="MASSM9.1.14_PatientAccountNumber">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM9.1.PatientAccountNumber1'']) &gt; 0">
              <xsl:value-of select="data[@id=''MASSM9.1.PatientAccountNumber1'']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM9.1.PatientLastName1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>

        <data id="MASSM9.1.15_PlaceOfService">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM9.1.PlaceOfService1''] = 11">01</xsl:when>
            <xsl:when test="data[@id=''MASSM9.1.PlaceOfService1''] = 12">02</xsl:when>
            <xsl:when test="data[@id=''MASSM9.1.PlaceOfService1''] = 21">03</xsl:when>
            <xsl:when test="data[@id=''MASSM9.1.PlaceOfService1''] = 22">04</xsl:when>
            <xsl:when test="data[@id=''MASSM9.1.PlaceOfService1''] = 23">05</xsl:when>
            <xsl:when test="data[@id=''MASSM9.1.PlaceOfService1''] = 31 or data[@id=''MASSM9.1.PlaceOfService1''] = 32">06</xsl:when>
            <xsl:when test="data[@id=''MASSM9.1.PlaceOfService1''] = 33">07</xsl:when>
            <xsl:otherwise>99</xsl:otherwise>
          </xsl:choose>
        </data>

        <data id="MASSM9.1.16A_AccidentRelated_NO">
          <xsl:if test="data[@id=''MASSM9.1.AutoAccidentRelatedFlag1''] != 1 and data[@id=''MASSM9.1.EmploymentRelatedFlag1''] != 1 and data[@id=''MASSM9.1.OtherAccidentRelatedFlag1''] != 1">X</xsl:if>
        </data>
        <data id="MASSM9.1.16A_AccidentRelated_YES">
          <xsl:if test="data[@id=''MASSM9.1.AutoAccidentRelatedFlag1''] = 1 or data[@id=''MASSM9.1.EmploymentRelatedFlag1''] = 1 or data[@id=''MASSM9.1.OtherAccidentRelatedFlag1''] = 1">X</xsl:if>
        </data>

        <data id="MASSM9.1.16B_AccidentType">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM9.1.AutoAccidentRelatedFlag1''] = 1">1</xsl:when>
            <xsl:when test="data[@id=''MASSM9.1.EmploymentRelatedFlag1''] = 1">2</xsl:when>
            <xsl:when test="data[@id=''MASSM9.1.OtherAccidentRelatedFlag1''] = 1">3</xsl:when>
          </xsl:choose>
        </data>

        <data id="MASSM9.1.16C_InjuryDate">
          <xsl:if test="data[@id=''MASSM9.1.AutoAccidentRelatedFlag1''] = 1 or data[@id=''MASSM9.1.EmploymentRelatedFlag1''] = 1 or data[@id=''MASSM9.1.OtherAccidentRelatedFlag1''] = 1">
            <xsl:if test="string-length(data[@id=''MASSM9.1.InjuryDate1'']) &gt; 0">
              <xsl:value-of select="substring(data[@id=''MASSM9.1.InjuryDate1''], 1, 1)"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM9.1.InjuryDate1''], 2, 1)"/>
              <xsl:text xml:space="preserve">  </xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM9.1.InjuryDate1''], 4, 1)"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM9.1.InjuryDate1''], 5, 1)"/>
              <xsl:text xml:space="preserve">  </xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM9.1.InjuryDate1''], 9, 1)"/>
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM9.1.InjuryDate1''], 10, 1)"/>
            </xsl:if>
          </xsl:if>
        </data>

        <data id="MASSM9.1.17_EPSDTRelated_NO">
          <xsl:if test="data[@id=''MASSM9.1.EPSDTRelatedFlag1''] = 0">X</xsl:if>
        </data>
        <data id="MASSM9.1.17_EPSDTRelated_YES">
          <xsl:if test="data[@id=''MASSM9.1.EPSDTRelatedFlag1''] = 1">X</xsl:if>
        </data>

        <data id="MASSM9.1.21_DiagnosisCode1">
          <xsl:value-of select="data[@id=''MASSM9.1.DiagnosisCode11'']"/>
        </data>

        <data id="MASSM9.1.22_DiagnosisName1">
          <xsl:value-of select="data[@id=''MASSM9.1.DiagnosisName11'']"/>
        </data>

        <data id="MASSM9.1.36_TotalCharge_Dollars">
          <xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))"/>
          <xsl:value-of select="$charges-dollars"/>
        </data>
        <data id="MASSM9.1.36_TotalCharge_Cents">
          <xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''MASSM9.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="$charges-cents"/>
        </data>

        <data id="MASSM9.1.37_TotalPaid_Dollars">
          <xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))"/>
          <xsl:value-of select="$paid-dollars"/>
        </data>
        <data id="MASSM9.1.37_TotalPaid_Cents">
          <xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''MASSM9.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="$paid-cents"/>
        </data>

        <data id="MASSM9.1.38_PhysicianSignature">
          <xsl:text>Signature on File</xsl:text>
        </data>

        <data id="MASSM9.1.39_PhysicianSignatureCurrentDate">
          <xsl:value-of select="substring(data[@id=''MASSM9.1.CurrentDate1''], 1, 1)"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM9.1.CurrentDate1''], 2, 1)"/>
          <xsl:text xml:space="preserve">  </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM9.1.CurrentDate1''], 4, 1)"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM9.1.CurrentDate1''], 5, 1)"/>
          <xsl:text xml:space="preserve">  </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM9.1.CurrentDate1''], 9, 1)"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM9.1.CurrentDate1''], 10, 1)"/>
        </data>

       <!-- Procedure 1 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM9.1.ClaimID1'']"/>
        </ClaimID>
        
        <data id="MASSM9.1.26_ServiceBeginDate1">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ServiceBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate1''], 2, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate1''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate1''], 5, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate1''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate1''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.27_Description1">
          <xsl:value-of select="data[@id=''MASSM9.1.Description1'']"/>
        </data>

        <data id="MASSM9.1.28_ProcedureCode_Modifier1">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ProcedureCode1'']) &gt; 0">
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureCode1'']"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier11'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier21'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier31'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier41'']"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''MASSM9.1.ServiceUnitCount1''] &gt; 0">
          <data id="MASSM9.1.31_ServiceUnitCount1">
            <xsl:value-of select="data[@id=''MASSM9.1.ServiceUnitCount1'']"/>
          </data>
          
          <data id="MASSM9.1.32_Charges_Dollars1">
            <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM9.1.32_Charges_Cents1">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM9.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>

          <data id="MASSM9.1.33_Paid_Dollars1">
            <xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.PaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM9.1.33_Paid_Cents1">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM9.1.PaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>

        <!-- Procedure 2 -->

        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM9.1.ClaimID2'']"/>
        </ClaimID>

        <data id="MASSM9.1.26_ServiceBeginDate2">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ServiceBeginDate2'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate2''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate2''], 2, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate2''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate2''], 5, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate2''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate2''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.27_Description2">
          <xsl:value-of select="data[@id=''MASSM9.1.Description2'']"/>
        </data>

        <data id="MASSM9.1.28_ProcedureCode_Modifier2">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ProcedureCode2'']) &gt; 0">
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureCode2'']"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier12'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier22'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier32'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier42'']"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''MASSM9.1.ServiceUnitCount2''] &gt; 0">
          <data id="MASSM9.1.31_ServiceUnitCount2">
            <xsl:value-of select="data[@id=''MASSM9.1.ServiceUnitCount2'']"/>
          </data>
          
          <data id="MASSM9.1.32_Charges_Dollars2">
            <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM9.1.32_Charges_Cents2">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM9.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>

          <data id="MASSM9.1.33_Paid_Dollars2">
            <xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.PaidAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM9.1.33_Paid_Cents2">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM9.1.PaidAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>

        <!-- Procedure 3 -->

        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM9.1.ClaimID3'']"/>
        </ClaimID>

        <data id="MASSM9.1.26_ServiceBeginDate3">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ServiceBeginDate3'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate3''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate3''], 2, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate3''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate3''], 5, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate3''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate3''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.27_Description3">
          <xsl:value-of select="data[@id=''MASSM9.1.Description3'']"/>
        </data>

        <data id="MASSM9.1.28_ProcedureCode_Modifier3">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ProcedureCode3'']) &gt; 0">
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureCode3'']"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier13'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier23'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier33'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier43'']"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''MASSM9.1.ServiceUnitCount3''] &gt; 0">
          <data id="MASSM9.1.31_ServiceUnitCount3">
            <xsl:value-of select="data[@id=''MASSM9.1.ServiceUnitCount3'']"/>
          </data>
          
          <data id="MASSM9.1.32_Charges_Dollars3">
            <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM9.1.32_Charges_Cents3">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM9.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>

          <data id="MASSM9.1.33_Paid_Dollars3">
            <xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.PaidAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM9.1.33_Paid_Cents3">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM9.1.PaidAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
        
        <!-- Procedure 4 -->

        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM9.1.ClaimID4'']"/>
        </ClaimID>

        <data id="MASSM9.1.26_ServiceBeginDate4">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ServiceBeginDate4'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate4''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate4''], 2, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate4''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate4''], 5, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate4''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate4''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.27_Description4">
          <xsl:value-of select="data[@id=''MASSM9.1.Description4'']"/>
        </data>

        <data id="MASSM9.1.28_ProcedureCode_Modifier4">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ProcedureCode4'']) &gt; 0">
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureCode4'']"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier14'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier24'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier34'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier44'']"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''MASSM9.1.ServiceUnitCount4''] &gt; 0">
          <data id="MASSM9.1.31_ServiceUnitCount4">
            <xsl:value-of select="data[@id=''MASSM9.1.ServiceUnitCount4'']"/>
          </data>
          
          <data id="MASSM9.1.32_Charges_Dollars4">
            <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM9.1.32_Charges_Cents4">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM9.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>

          <data id="MASSM9.1.33_Paid_Dollars4">
            <xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.PaidAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM9.1.33_Paid_Cents4">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM9.1.PaidAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>

        <!-- Procedure 5 -->

        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM9.1.ClaimID5'']"/>
        </ClaimID>

        <data id="MASSM9.1.26_ServiceBeginDate5">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ServiceBeginDate5'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate5''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate5''], 2, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate5''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate5''], 5, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate5''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate5''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.27_Description5">
          <xsl:value-of select="data[@id=''MASSM9.1.Description5'']"/>
        </data>

        <data id="MASSM9.1.28_ProcedureCode_Modifier5">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ProcedureCode5'']) &gt; 0">
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureCode5'']"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier15'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier25'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier35'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier45'']"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''MASSM9.1.ServiceUnitCount5''] &gt; 0">
          <data id="MASSM9.1.31_ServiceUnitCount5">
            <xsl:value-of select="data[@id=''MASSM9.1.ServiceUnitCount5'']"/>
          </data>
          
          <data id="MASSM9.1.32_Charges_Dollars5">
            <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM9.1.32_Charges_Cents5">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM9.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>

          <data id="MASSM9.1.33_Paid_Dollars5">
            <xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.PaidAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM9.1.33_Paid_Cents5">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM9.1.PaidAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
       
       <!-- Procedure 6 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM9.1.ClaimID6'']"/>
        </ClaimID>

        <data id="MASSM9.1.26_ServiceBeginDate6">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ServiceBeginDate6'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate6''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate6''], 2, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate6''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate6''], 5, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate6''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate6''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.27_Description6">
          <xsl:value-of select="data[@id=''MASSM9.1.Description6'']"/>
        </data>

        <data id="MASSM9.1.28_ProcedureCode_Modifier6">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ProcedureCode6'']) &gt; 0">
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureCode6'']"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier16'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier26'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier36'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier46'']"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''MASSM9.1.ServiceUnitCount6''] &gt; 0">
          <data id="MASSM9.1.31_ServiceUnitCount6">
            <xsl:value-of select="data[@id=''MASSM9.1.ServiceUnitCount6'']"/>
          </data>
          
          <data id="MASSM9.1.32_Charges_Dollars6">
            <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM9.1.32_Charges_Cents6">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM9.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>

          <data id="MASSM9.1.33_Paid_Dollars6">
            <xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.PaidAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM9.1.33_Paid_Cents6">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM9.1.PaidAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
             
       <!-- Procedure 7 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM9.1.ClaimID7'']"/>
        </ClaimID>

        <data id="MASSM9.1.26_ServiceBeginDate7">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ServiceBeginDate7'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate7''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate7''], 2, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate7''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate7''], 5, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate7''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate7''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.27_Description7">
          <xsl:value-of select="data[@id=''MASSM9.1.Description7'']"/>
        </data>

        <data id="MASSM9.1.28_ProcedureCode_Modifier7">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ProcedureCode7'']) &gt; 0">
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureCode7'']"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier17'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier27'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier37'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier47'']"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''MASSM9.1.ServiceUnitCount7''] &gt; 0">
          <data id="MASSM9.1.31_ServiceUnitCount7">
            <xsl:value-of select="data[@id=''MASSM9.1.ServiceUnitCount7'']"/>
          </data>
          
          <data id="MASSM9.1.32_Charges_Dollars7">
            <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.ChargeAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM9.1.32_Charges_Cents7">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM9.1.ChargeAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>

          <data id="MASSM9.1.33_Paid_Dollars7">
            <xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.PaidAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM9.1.33_Paid_Cents7">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM9.1.PaidAmount7''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>

        <!-- Procedure 8 -->

        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM9.1.ClaimID8'']"/>
        </ClaimID>

        <data id="MASSM9.1.26_ServiceBeginDate8">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ServiceBeginDate8'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate8''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate8''], 2, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate8''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate8''], 5, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate8''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate8''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.27_Description8">
          <xsl:value-of select="data[@id=''MASSM9.1.Description8'']"/>
        </data>

        <data id="MASSM9.1.28_ProcedureCode_Modifier8">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ProcedureCode8'']) &gt; 0">
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureCode8'']"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier18'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier28'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier38'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier48'']"/>
          </xsl:if>
        </data>
        
        <xsl:if test="data[@id=''MASSM9.1.ServiceUnitCount8''] &gt; 0">
          <data id="MASSM9.1.31_ServiceUnitCount8">
            <xsl:value-of select="data[@id=''MASSM9.1.ServiceUnitCount8'']"/>
          </data>
          
          <data id="MASSM9.1.32_Charges_Dollars8">
            <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.ChargeAmount8''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM9.1.32_Charges_Cents8">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM9.1.ChargeAmount8''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>

          <data id="MASSM9.1.33_Paid_Dollars8">
            <xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.PaidAmount8''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM9.1.33_Paid_Cents8">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM9.1.PaidAmount8''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>

        <!-- Procedure 9 -->

        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM9.1.ClaimID9'']"/>
        </ClaimID>

        <data id="MASSM9.1.26_ServiceBeginDate9">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ServiceBeginDate9'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate9''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate9''], 2, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate9''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate9''], 5, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate9''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate9''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.27_Description9">
          <xsl:value-of select="data[@id=''MASSM9.1.Description9'']"/>
        </data>

        <data id="MASSM9.1.28_ProcedureCode_Modifier9">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ProcedureCode9'']) &gt; 0">
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureCode9'']"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier19'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier29'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier39'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier49'']"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''MASSM9.1.ServiceUnitCount9''] &gt; 0">
          <data id="MASSM9.1.31_ServiceUnitCount9">
            <xsl:value-of select="data[@id=''MASSM9.1.ServiceUnitCount9'']"/>
          </data>
          
          <data id="MASSM9.1.32_Charges_Dollars9">
            <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.ChargeAmount9''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM9.1.32_Charges_Cents9">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM9.1.ChargeAmount9''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>

          <data id="MASSM9.1.33_Paid_Dollars9">
            <xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.PaidAmount9''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM9.1.33_Paid_Cents9">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM9.1.PaidAmount9''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>

        <!-- Procedure 10 -->

        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM9.1.ClaimID10'']"/>
        </ClaimID>

        <data id="MASSM9.1.26_ServiceBeginDate10">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ServiceBeginDate10'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate10''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate10''], 2, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate10''], 4, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate10''], 5, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate10''], 9, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM9.1.ServiceBeginDate10''], 10, 1)"/>
          </xsl:if>
        </data>

        <data id="MASSM9.1.27_Description10">
          <xsl:value-of select="data[@id=''MASSM9.1.Description10'']"/>
        </data>

        <data id="MASSM9.1.28_ProcedureCode_Modifier10">
          <xsl:if test="string-length(data[@id=''MASSM9.1.ProcedureCode10'']) &gt; 0">
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureCode10'']"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier110'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier210'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier310'']"/>
            <xsl:value-of select="data[@id=''MASSM9.1.ProcedureModifier410'']"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''MASSM9.1.ServiceUnitCount10''] &gt; 0">
          <data id="MASSM9.1.31_ServiceUnitCount10">
            <xsl:value-of select="data[@id=''MASSM9.1.ServiceUnitCount10'']"/>
          </data>
          
          <data id="MASSM9.1.32_Charges_Dollars10">
            <xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.ChargeAmount10''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
            <xsl:value-of select="$charge-dollars"/>
          </data>
          <data id="MASSM9.1.32_Charges_Cents10">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM9.1.ChargeAmount10''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$charge-cents"/>
          </data>

          <data id="MASSM9.1.33_Paid_Dollars10">
            <xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=''MASSM9.1.PaidAmount10''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
            <xsl:value-of select="$pay-dollars"/>
          </data>
          <data id="MASSM9.1.33_Paid_Cents10">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM9.1.PaidAmount10''], ''#0.00'', ''default-format''), ''.'')"/>
            <xsl:value-of select="$pay-cents"/>
          </data>
        </xsl:if>
        
      </page>
    </formData>
  </xsl:template>
</xsl:stylesheet>'
WHERE BillingFormID = 14