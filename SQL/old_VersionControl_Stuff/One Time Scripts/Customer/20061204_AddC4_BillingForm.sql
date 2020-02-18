/*
-----------------------------------------------------------------------------------------------------
CASE 15047 - Implement C-4 Billing Form
-----------------------------------------------------------------------------------------------------
*/

INSERT INTO BillingForm(BillingFormID, FormType, FormName, PrintingFormID, MaxProcedures, MaxDiagnosis)
VALUES(15, 'C4', 'C-4', 21, 6, 4)

INSERT INTO PrintingForm(PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
VALUES(21, 'C4', 'C-4', 'BillDataProvider_GetC4DocumentData', 1)

INSERT INTO PrintingFormDetails(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description)
VALUES(78, 21, 65, 'C-4')

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="C4" pageId="C4.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
  <defs>
    <style type="text/css">
      <![CDATA[
		
		g {
			font-family: Courier New;
			font-size: 9pt;
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

		text.smaller
		{
			font-size: 9pt;
		}
				
	    	]]>
    </style>
  </defs>

  <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://ac9dcaf3-63a4-4ef2-839c-64a212717cf3?type=global" />

  <g>
    <text x="0.29in" y="1.04in" width="1.05in" height="0.10in" valueSource="C4.1.0_WorkersCompCaseNumber" />
    <text x="2.79in" y="1.04in" width="0.77in" height="0.10in" valueSource="C4.1.0_InjuryDate" />
    <text x="6.74in" y="1.04in" width="1.40in" height="0.10in" valueSource="C4.1.0_PatientSSN" />
    <text x="0.74in" y="1.27in" width="3.21in" height="0.10in" valueSource="C4.1.0_PatientName" />
    <text x="3.93in" y="1.27in" width="3.11in" height="0.10in" valueSource="C4.1.0_PatientAddress_Street" />
    <text x="3.93in" y="1.39in" width="3.11in" height="0.10in" valueSource="C4.1.0_PatientAddress_CityStateZip" />
    <text x="6.96in" y="1.36in" width="1.20in" height="0.10in" valueSource="C4.1.0_PatientTelephone" />
    <text x="0.74in" y="1.56in" width="3.21in" height="0.10in" valueSource="C4.1.0_EmployerName" />
    <text x="3.93in" y="1.56in" width="3.11in" height="0.10in" valueSource="C4.1.0_EmployerAddress_Street" />
    <text x="3.93in" y="1.70in" width="3.11in" height="0.10in" valueSource="C4.1.0_EmployerAddress_CityStateZip" />
    <text x="6.99in" y="1.70in" width="1.20in" height="0.10in" valueSource="C4.1.0_PatientBirthDate" />
    <text x="0.74in" y="1.89in" width="3.21in" height="0.10in" valueSource="C4.1.0_InsuranceCompanyName" />
    <text x="3.93in" y="1.89in" width="3.11in" height="0.10in" valueSource="C4.1.0_InsuranceCompanyAddress_Street" />
    <text x="3.93in" y="2.03in" width="3.11in" height="0.10in" valueSource="C4.1.0_InsuranceCompanyAddress_CityStateZip" />
    <text x="0.74in" y="2.22in" width="3.21in" height="0.10in" valueSource="C4.1.0_SupervisingProviderName" />
    <text x="3.93in" y="2.22in" width="3.11in" height="0.10in" valueSource="C4.1.0_SupervisingProviderAddress_Street" />
    <text x="3.93in" y="2.36in" width="3.11in" height="0.10in" valueSource="C4.1.0_SupervisingProviderAddress_CityStateZip" />
    <text x="0.44in" y="3.20in" width="4.0in" height="0.10in" valueSource="C4.1.1_RelatedSymptomsDate" />
    <text x="0.44in" y="3.53in" width="4.0in" height="0.10in" valueSource="C4.1.2_DisabilityDates" />
    <text x="1.76in" y="3.72in" width="1.65in" height="0.10in" valueSource="C4.1.3_ExaminationBeginDate" />
    <text x="1.76in" y="3.86in" width="1.65in" height="0.10in" valueSource="C4.1.3_ExaminationEndDate" />
    <text x="3.91in" y="3.86in" width="0.74in" height="0.10in" valueSource="C4.1.3_FirstTreatmentDate" />
    <text x="0.44in" y="4.36in" width="1.70in" height="0.10in" valueSource="C4.1.4_XRaysTakenDate" />
    <text x="2.11in" y="4.36in" width="3.0in" height="0.10in" valueSource="C4.1.4_HospitalizationDates" />
    <text x="4.26in" y="4.14in" width="0.17in" height="0.10in" valueSource="C4.1.4_RequiredAuthorization" />
    <text x="0.44in" y="5.04in" width="0.77in" height="0.10in" valueSource="C4.1.6_UnableToWorkDate" />
    <text x="3.84in" y="5.83in" width="0.17in" height="0.10in" valueSource="C4.1.11_EmploymentRelated_YES" />
    <text x="4.17in" y="5.83in" width="0.17in" height="0.10in" valueSource="C4.1.11_EmploymentRelated_NO" />
    <text x="0.59in" y="6.33in" width="0.70in" height="0.10in" valueSource="C4.1.12_Diagnosis1" />
    <text x="0.59in" y="6.50in" width="0.70in" height="0.10in" valueSource="C4.1.12_Diagnosis2" />
    <text x="4.25in" y="6.33in" width="0.70in" height="0.10in" valueSource="C4.1.12_Diagnosis3" />
    <text x="4.25in" y="6.50in" width="0.70in" height="0.10in" valueSource="C4.1.12_Diagnosis4" />
  </g>

  <g id="Procedures">
    <text x="0.44in" y="7.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateMM1" />
    <text x="0.74in" y="7.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateDD1" />
    <text x="1.03in" y="7.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateYY1" />
    <text x="1.34in" y="7.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateMM1" />
    <text x="1.64in" y="7.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateDD1" />
    <text x="1.94in" y="7.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateYY1" />
    <text x="2.23in" y="7.36in" width="0.33in" height="0.10in" valueSource="C4.1.13B_POS1" />
    <text x="2.85in" y="7.36in" width="0.82in" height="0.10in" valueSource="C4.1.13D_CPT1" />
    <text x="3.66in" y="7.36in" width="0.33in" height="0.10in" valueSource="C4.1.13D_FirstModifier1" />
    <text x="3.98in" y="7.36in" width="0.60in" height="0.10in" valueSource="C4.1.13D_OtherModifiers1" />
    <text x="4.53in" y="7.36in" width="0.82in" height="0.10in" valueSource="C4.1.13E_DiagnosisCodes1" />
    <text x="5.32in" y="7.36in" width="0.67in" height="0.10in" valueSource="C4.1.13F_Charges_Dollars1" class="money" />
    <text x="5.98in" y="7.36in" width="0.33in" height="0.10in" valueSource="C4.1.13F_Charges_Cents1" />
    <text x="6.21in" y="7.36in" width="0.33in" height="0.10in" valueSource="C4.1.13G_ServiceUnitCount1" />
    <text x="6.84in" y="7.36in" width="1.30in" height="0.10in" valueSource="C4.1.13I_ServiceLocationZip1" />

    <text x="0.44in" y="7.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateMM2" />
    <text x="0.74in" y="7.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateDD2" />
    <text x="1.03in" y="7.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateYY2" />
    <text x="1.34in" y="7.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateMM2" />
    <text x="1.64in" y="7.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateDD2" />
    <text x="1.94in" y="7.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateYY2" />
    <text x="2.23in" y="7.70in" width="0.33in" height="0.10in" valueSource="C4.1.13B_POS2" />
    <text x="2.85in" y="7.70in" width="0.82in" height="0.10in" valueSource="C4.1.13D_CPT2" />
    <text x="3.66in" y="7.70in" width="0.33in" height="0.10in" valueSource="C4.1.13D_FirstModifier2" />
    <text x="3.98in" y="7.70in" width="0.60in" height="0.10in" valueSource="C4.1.13D_OtherModifiers2" />
    <text x="4.53in" y="7.70in" width="0.82in" height="0.10in" valueSource="C4.1.13E_DiagnosisCodes2" />
    <text x="5.32in" y="7.70in" width="0.67in" height="0.10in" valueSource="C4.1.13F_Charges_Dollars2" class="money" />
    <text x="5.98in" y="7.70in" width="0.33in" height="0.10in" valueSource="C4.1.13F_Charges_Cents2" />
    <text x="6.21in" y="7.70in" width="0.33in" height="0.10in" valueSource="C4.1.13G_ServiceUnitCount2" />
    <text x="6.84in" y="7.70in" width="1.30in" height="0.10in" valueSource="C4.1.13I_ServiceLocationZip2" />

    <text x="0.44in" y="8.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateMM3" />
    <text x="0.74in" y="8.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateDD3" />
    <text x="1.03in" y="8.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateYY3" />
    <text x="1.34in" y="8.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateMM3" />
    <text x="1.64in" y="8.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateDD3" />
    <text x="1.94in" y="8.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateYY3" />
    <text x="2.23in" y="8.03in" width="0.33in" height="0.10in" valueSource="C4.1.13B_POS3" />
    <text x="2.85in" y="8.03in" width="0.82in" height="0.10in" valueSource="C4.1.13D_CPT3" />
    <text x="3.66in" y="8.03in" width="0.33in" height="0.10in" valueSource="C4.1.13D_FirstModifier3" />
    <text x="3.98in" y="8.03in" width="0.60in" height="0.10in" valueSource="C4.1.13D_OtherModifiers3" />
    <text x="4.53in" y="8.03in" width="0.82in" height="0.10in" valueSource="C4.1.13E_DiagnosisCodes3" />
    <text x="5.32in" y="8.03in" width="0.67in" height="0.10in" valueSource="C4.1.13F_Charges_Dollars3" class="money" />
    <text x="5.98in" y="8.03in" width="0.33in" height="0.10in" valueSource="C4.1.13F_Charges_Cents3" />
    <text x="6.21in" y="8.03in" width="0.33in" height="0.10in" valueSource="C4.1.13G_ServiceUnitCount3" />
    <text x="6.84in" y="8.03in" width="1.30in" height="0.10in" valueSource="C4.1.13I_ServiceLocationZip3" />

    <text x="0.44in" y="8.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateMM4" />
    <text x="0.74in" y="8.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateDD4" />
    <text x="1.03in" y="8.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateYY4" />
    <text x="1.34in" y="8.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateMM4" />
    <text x="1.64in" y="8.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateDD4" />
    <text x="1.94in" y="8.36in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateYY4" />
    <text x="2.23in" y="8.36in" width="0.33in" height="0.10in" valueSource="C4.1.13B_POS4" />
    <text x="2.85in" y="8.36in" width="0.82in" height="0.10in" valueSource="C4.1.13D_CPT4" />
    <text x="3.66in" y="8.36in" width="0.33in" height="0.10in" valueSource="C4.1.13D_FirstModifier4" />
    <text x="3.98in" y="8.36in" width="0.60in" height="0.10in" valueSource="C4.1.13D_OtherModifiers4" />
    <text x="4.53in" y="8.36in" width="0.82in" height="0.10in" valueSource="C4.1.13E_DiagnosisCodes4" />
    <text x="5.32in" y="8.36in" width="0.67in" height="0.10in" valueSource="C4.1.13F_Charges_Dollars4" class="money" />
    <text x="5.98in" y="8.36in" width="0.33in" height="0.10in" valueSource="C4.1.13F_Charges_Cents4" />
    <text x="6.21in" y="8.36in" width="0.33in" height="0.10in" valueSource="C4.1.13G_ServiceUnitCount4" />
    <text x="6.84in" y="8.36in" width="1.30in" height="0.10in" valueSource="C4.1.13I_ServiceLocationZip4" />

    <text x="0.44in" y="8.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateMM5" />
    <text x="0.74in" y="8.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateDD5" />
    <text x="1.03in" y="8.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateYY5" />
    <text x="1.34in" y="8.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateMM5" />
    <text x="1.64in" y="8.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateDD5" />
    <text x="1.94in" y="8.70in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateYY5" />
    <text x="2.23in" y="8.70in" width="0.33in" height="0.10in" valueSource="C4.1.13B_POS5" />
    <text x="2.85in" y="8.70in" width="0.82in" height="0.10in" valueSource="C4.1.13D_CPT5" />
    <text x="3.66in" y="8.70in" width="0.33in" height="0.10in" valueSource="C4.1.13D_FirstModifier5" />
    <text x="3.98in" y="8.70in" width="0.60in" height="0.10in" valueSource="C4.1.13D_OtherModifiers5" />
    <text x="4.53in" y="8.70in" width="0.82in" height="0.10in" valueSource="C4.1.13E_DiagnosisCodes5" />
    <text x="5.32in" y="8.70in" width="0.67in" height="0.10in" valueSource="C4.1.13F_Charges_Dollars5" class="money" />
    <text x="5.98in" y="8.70in" width="0.33in" height="0.10in" valueSource="C4.1.13F_Charges_Cents5" />
    <text x="6.21in" y="8.70in" width="0.33in" height="0.10in" valueSource="C4.1.13G_ServiceUnitCount5" />
    <text x="6.84in" y="8.70in" width="1.30in" height="0.10in" valueSource="C4.1.13I_ServiceLocationZip5" />

    <text x="0.44in" y="9.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateMM6" />
    <text x="0.74in" y="9.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateDD6" />
    <text x="1.03in" y="9.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceBeginDateYY6" />
    <text x="1.34in" y="9.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateMM6" />
    <text x="1.64in" y="9.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateDD6" />
    <text x="1.94in" y="9.03in" width="0.33in" height="0.10in" valueSource="C4.1.13A_ServiceEndDateYY6" />
    <text x="2.23in" y="9.03in" width="0.33in" height="0.10in" valueSource="C4.1.13B_POS6" />
    <text x="2.85in" y="9.03in" width="0.82in" height="0.10in" valueSource="C4.1.13D_CPT6" />
    <text x="3.66in" y="9.03in" width="0.33in" height="0.10in" valueSource="C4.1.13D_FirstModifier6" />
    <text x="3.98in" y="9.03in" width="0.60in" height="0.10in" valueSource="C4.1.13D_OtherModifiers6" />
    <text x="4.53in" y="9.03in" width="0.82in" height="0.10in" valueSource="C4.1.13E_DiagnosisCodes6" />
    <text x="5.32in" y="9.03in" width="0.67in" height="0.10in" valueSource="C4.1.13F_Charges_Dollars6" class="money" />
    <text x="5.98in" y="9.03in" width="0.33in" height="0.10in" valueSource="C4.1.13F_Charges_Cents6" />
    <text x="6.21in" y="9.03in" width="0.33in" height="0.10in" valueSource="C4.1.13G_ServiceUnitCount6" />
    <text x="6.84in" y="9.03in" width="1.30in" height="0.10in" valueSource="C4.1.13I_ServiceLocationZip6" />
  </g>

  <g>
    <text x="0.44in" y="9.36in" width="1.50in" height="0.10in" valueSource="C4.1.14_FederalTaxID" />
    <text x="1.93in" y="9.32in" width="0.17in" height="0.10in" valueSource="C4.1.14_SSN" />
    <text x="2.22in" y="9.32in" width="0.17in" height="0.10in" valueSource="C4.1.14_EIN" />
    <text x="2.55in" y="9.36in" width="2.74in" height="0.10in" valueSource="C4.1.15_PatientAccountNumber" />
    <text x="5.25in" y="9.36in" width="0.67in" height="0.10in" valueSource="C4.1.16_TotalCharge_Dollars" class="money" />
    <text x="5.99in" y="9.36in" width="0.33in" height="0.10in" valueSource="C4.1.16_TotalCharge_Cents" />
    <text x="0.44in" y="10.27in" width="1.53in" height="0.10in" valueSource="C4.1.21_PhysicianSignature" />
    <text x="1.95in" y="10.27in" width="0.65in" height="0.10in" valueSource="C4.1.21_PhysicianSignatureDate" />
    <text x="2.55in" y="9.85in" width="2.74in" height="0.10in" valueSource="C4.1.22_FacilityName" />
    <text x="2.55in" y="10.01in" width="2.74in" height="0.10in" valueSource="C4.1.22_FacilityAddress_Street" />
    <text x="2.55in" y="10.17in" width="2.74in" height="0.10in" valueSource="C4.1.22_FacilityAddress_CityStateZip" />
    <text x="2.55in" y="10.33in" width="2.74in" height="0.10in" valueSource="C4.1.22_FacilityPhone" />
    <text x="5.28in" y="9.85in" width="2.85in" height="0.10in" valueSource="C4.1.23_PracticeName" />
    <text x="5.28in" y="10.01in" width="2.85in" height="0.10in" valueSource="C4.1.23_PracticeAddress_Street" />
    <text x="5.28in" y="10.17in" width="2.85in" height="0.10in" valueSource="C4.1.23_PracticeAddress_CityStateZip" />
    <text x="5.28in" y="10.33in" width="2.85in" height="0.10in" valueSource="C4.1.23_PracticePhone" />
  </g>
  
</svg>'
WHERE PrintingFormDetailsID = 78

Update BillingForm
SET TransForm = '<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>
	<xsl:decimal-format name="default-format" NaN="0.00"/>
	<xsl:template match="/formData/page">
		<formData formId="C4">
			<page pageId="C4.1">
				<BillID>
					<xsl:value-of select="data[@id=''C4.1.BillID1'']"/>
				</BillID>

        <data id="C4.1.0_WorkersCompCaseNumber">
          <xsl:value-of select="data[@id=''C4.1.WCCaseNumber1'']"/>
        </data>
        
        <data id="C4.1.0_InjuryDate">
          <xsl:if test="string-length(data[@id=''C4.1.InjuryDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''C4.1.InjuryDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.InjuryDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.InjuryDate1''], 9, 2)"/>
          </xsl:if>
        </data>

        <data id="C4.1.0_PatientSSN">
          <xsl:value-of select="data[@id=''C4.1.PatientSSN1'']"/>
        </data>

        <data id="C4.1.0_PatientName">
          <xsl:value-of select="data[@id=''C4.1.PatientFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''C4.1.PatientMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''C4.1.PatientMiddleName1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''C4.1.PatientLastName1'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.PatientSuffix1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.PatientSuffix1'']"/>
          </xsl:if>
				</data>

        <data id="C4.1.0_PatientAddress_Street">
          <xsl:value-of select="data[@id=''C4.1.PatientStreet11'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.PatientStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.PatientStreet21'']"/>
          </xsl:if>
        </data>
        <data id="C4.1.0_PatientAddress_CityStateZip">
          <xsl:if test="string-length(data[@id=''C4.1.PatientStreet11'']) &gt; 0">
            <xsl:value-of select="data[@id=''C4.1.PatientCity1'']"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.PatientState1'']"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''C4.1.PatientZip1'']) = 9">
                <xsl:value-of select="substring(data[@id=''C4.1.PatientZip1''], 1, 5)"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(data[@id=''C4.1.PatientZip1''], 6, 4)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''C4.1.PatientZip1'']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </data>

        <data id="C4.1.0_PatientTelephone">
          <xsl:if test="string-length(data[@id=''C4.1.PatientPhone1'']) &gt; 0">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.PatientPhone1''], 1, 3)"/>
            <xsl:text>) </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.PatientPhone1''], 4, 3)"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.PatientPhone1''], 7, 4)"/>
          </xsl:if>
        </data>

        <data id="C4.1.0_EmployerName">
          <xsl:value-of select="data[@id=''C4.1.EmployerName1'']"/>
        </data>

        <data id="C4.1.0_EmployerAddress_Street">
          <xsl:value-of select="data[@id=''C4.1.EmployerStreet11'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.EmployerStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.EmployerStreet21'']"/>
          </xsl:if>
        </data>
        <data id="C4.1.0_EmployerAddress_CityStateZip">
          <xsl:if test="string-length(data[@id=''C4.1.EmployerStreet11'']) &gt; 0">
            <xsl:value-of select="data[@id=''C4.1.EmployerCity1'']"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.EmployerState1'']"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''C4.1.EmployerZip1'']) = 9">
                <xsl:value-of select="substring(data[@id=''C4.1.EmployerZip1''], 1, 5)"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(data[@id=''C4.1.EmployerZip1''], 6, 4)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''C4.1.EmployerZip1'']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </data>

        <data id="C4.1.0_PatientBirthDate">
          <xsl:if test="string-length(data[@id=''C4.1.PatientBirthDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''C4.1.PatientBirthDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.PatientBirthDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.PatientBirthDate1''], 9, 2)"/>
          </xsl:if>
        </data>

        <data id="C4.1.0_InsuranceCompanyName">
          <xsl:value-of select="data[@id=''C4.1.InsuranceCompanyName1'']"/>
        </data>

        <data id="C4.1.0_InsuranceCompanyAddress_Street">
          <xsl:value-of select="data[@id=''C4.1.InsuranceCompanyStreet11'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.InsuranceCompanyStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.InsuranceCompanyStreet21'']"/>
          </xsl:if>
        </data>
        <data id="C4.1.0_InsuranceCompanyAddress_CityStateZip">
          <xsl:if test="string-length(data[@id=''C4.1.InsuranceCompanyStreet11'']) &gt; 0">
            <xsl:value-of select="data[@id=''C4.1.InsuranceCompanyCity1'']"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.InsuranceCompanyState1'']"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''C4.1.InsuranceCompanyZip1'']) = 9">
                <xsl:value-of select="substring(data[@id=''C4.1.InsuranceCompanyZip1''], 1, 5)"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(data[@id=''C4.1.InsuranceCompanyZip1''], 6, 4)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''C4.1.InsuranceCompanyZip1'']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </data>

        <data id="C4.1.0_SupervisingProviderName">
          <xsl:value-of select="data[@id=''C4.1.SupervisingProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''C4.1.SupervisingProviderMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''C4.1.SupervisingProviderMiddleName1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''C4.1.SupervisingProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.SupervisingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.SupervisingProviderDegree1'']"/>
          </xsl:if>
        </data>

        <data id="C4.1.0_SupervisingProviderAddress_Street">
          <xsl:value-of select="data[@id=''C4.1.SupervisingProviderStreet11'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.SupervisingProviderStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.SupervisingProviderStreet21'']"/>
          </xsl:if>
        </data>
        <data id="C4.1.0_SupervisingProviderAddress_CityStateZip">
          <xsl:if test="string-length(data[@id=''C4.1.SupervisingProviderStreet11'']) &gt; 0">
            <xsl:value-of select="data[@id=''C4.1.SupervisingProviderCity1'']"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.SupervisingProviderState1'']"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''C4.1.SupervisingProviderZip1'']) = 9">
                <xsl:value-of select="substring(data[@id=''C4.1.SupervisingProviderZip1''], 1, 5)"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(data[@id=''C4.1.SupervisingProviderZip1''], 6, 4)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''C4.1.SupervisingProviderZip1'']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </data>

        <data id="C4.1.1_RelatedSymptomsDate">
          <xsl:if test="string-length(data[@id=''C4.1.SimilarIllnessDate1'']) &gt; 0">
            <xsl:text>Date of onset of related symptoms: </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.SimilarIllnessDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.SimilarIllnessDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.SimilarIllnessDate1''], 9, 2)"/>
          </xsl:if>
        </data>

        <data id="C4.1.2_DisabilityDates">
          <xsl:if test="string-length(data[@id=''C4.1.DisabilityBeginDate1'']) &gt; 0">
            <xsl:text>Disabled From: </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.DisabilityBeginDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.DisabilityBeginDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.DisabilityBeginDate1''], 9, 2)"/>
            <xsl:text> To: </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.DisabilityEndDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.DisabilityEndDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.DisabilityEndDate1''], 9, 2)"/>
          </xsl:if>
        </data>

        <data id="C4.1.3_ExaminationBeginDate">
          <xsl:if test="string-length(data[@id=''C4.1.ServiceFromDate1'']) &gt; 0">
            <xsl:text>From: </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.ServiceFromDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.ServiceFromDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.ServiceFromDate1''], 9, 2)"/>
          </xsl:if>
        </data>
        <data id="C4.1.3_ExaminationEndDate">
          <xsl:if test="string-length(data[@id=''C4.1.ServiceToDate1'']) &gt; 0">
            <xsl:text> To: </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.ServiceToDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.ServiceToDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.ServiceToDate1''], 9, 2)"/>
          </xsl:if>
        </data>
        <data id="C4.1.3_FirstTreatmentDate">
          <xsl:if test="string-length(data[@id=''C4.1.CurrentIllnessDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''C4.1.CurrentIllnessDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.CurrentIllnessDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.CurrentIllnessDate1''], 9, 2)"/>
          </xsl:if>
        </data>
        
        <data id="C4.1.4_XRaysTakenDate">
          <xsl:if test="string-length(data[@id=''C4.1.XRaysTakenDate1'']) &gt; 0">
            <xsl:text>X-rays taken: </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.XRaysTakenDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.XRaysTakenDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.XRaysTakenDate1''], 9, 2)"/>
          </xsl:if>
        </data>
        <data id="C4.1.4_HospitalizationDates">
          <xsl:if test="string-length(data[@id=''C4.1.HospitalizationBeginDate1'']) &gt; 0">
            <xsl:text>Hospitalized From: </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.HospitalizationBeginDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.HospitalizationBeginDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.HospitalizationBeginDate1''], 9, 2)"/>
            <xsl:text> To: </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.HospitalizationEndDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.HospitalizationEndDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.HospitalizationEndDate1''], 9, 2)"/>
          </xsl:if>
        </data>
        <data id="C4.1.4_RequiredAuthorization">
          <xsl:if test="string-length(data[@id=''C4.1.AuthorizationNumber1'']) &gt; 0">X</xsl:if>
        </data>

        <data id="C4.1.6_UnableToWorkDate">
          <xsl:if test="string-length(data[@id=''C4.1.UnableToWorkDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''C4.1.UnableToWorkDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.UnableToWorkDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''C4.1.UnableToWorkDate1''], 9, 2)"/>
          </xsl:if>
        </data>

        <data id="C4.1.11_EmploymentRelated_YES">
          <xsl:if test="data[@id=''C4.1.EmploymentRelatedFlag1''] = 1">X</xsl:if>
        </data>
        <data id="C4.1.11_EmploymentRelated_NO">
          <xsl:if test="data[@id=''C4.1.EmploymentRelatedFlag1''] != 1">X</xsl:if>
        </data>

        <data id="C4.1.12_Diagnosis1">
          <xsl:value-of select="data[@id=''C4.1.DiagnosisCode11'']"/>
        </data>
        <data id="C4.1.12_Diagnosis2">
          <xsl:value-of select="data[@id=''C4.1.DiagnosisCode21'']"/>
        </data>
        <data id="C4.1.12_Diagnosis3">
          <xsl:value-of select="data[@id=''C4.1.DiagnosisCode31'']"/>
        </data>
        <data id="C4.1.12_Diagnosis4">
          <xsl:value-of select="data[@id=''C4.1.DiagnosisCode41'']"/>
        </data>

        <data id="C4.1.14_FederalTaxID">
          <xsl:value-of select="data[@id=''C4.1.FederalTaxID1'']"/>
        </data>
        <data id="C4.1.14_SSN">
          <xsl:if test="data[@id=''C4.1.FederalTaxIDType1''] = ''SSN''">X</xsl:if>
        </data>
        <data id="C4.1.14_EIN">
          <xsl:if test="data[@id=''C4.1.FederalTaxIDType1''] = ''EIN''">X</xsl:if>
        </data>

        <data id="C4.1.15_PatientAccountNumber">
          <xsl:value-of select="data[@id=''C4.1.PatientAccountNumber1'']"/>
        </data>

        <data id="C4.1.16_TotalCharge_Dollars">
          <xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''C4.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))"/>
          <xsl:value-of select="$charges-dollars"/>
        </data>
        <data id="C4.1.16_TotalCharge_Cents">
          <xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''C4.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
          <xsl:value-of select="$charges-cents"/>
        </data>

        <data id="C4.1.21_PhysicianSignature">
          <xsl:value-of select="data[@id=''C4.1.RenderingProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''C4.1.RenderingProviderMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''C4.1.RenderingProviderMiddleName1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''C4.1.RenderingProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.RenderingProviderDegree1'']"/>
          </xsl:if>
        </data>

        <data id="C4.1.21_PhysicianSignatureDate">
          <xsl:value-of select="substring(data[@id=''C4.1.CurrentDate1''], 1, 2)"/>
          <xsl:value-of select="substring(data[@id=''C4.1.CurrentDate1''], 4, 2)"/>
          <xsl:value-of select="substring(data[@id=''C4.1.CurrentDate1''], 9, 2)"/>
        </data>

        <data id="C4.1.22_FacilityName">
          <xsl:value-of select="data[@id=''C4.1.FacilityName1'']"/>
        </data>
        <data id="C4.1.22_FacilityAddress_Street">
          <xsl:value-of select="data[@id=''C4.1.FacilityStreet11'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.FacilityStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.FacilityStreet21'']"/>
          </xsl:if>
        </data>
        <data id="C4.1.22_FacilityAddress_CityStateZip">
          <xsl:if test="string-length(data[@id=''C4.1.FacilityCity1'']) &gt; 0">
            <xsl:value-of select="data[@id=''C4.1.FacilityCity1'']"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.FacilityState1'']"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''C4.1.FacilityZip1'']) = 9">
                <xsl:value-of select="substring(data[@id=''C4.1.FacilityZip1''], 1, 5)"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(data[@id=''C4.1.FacilityZip1''], 6, 4)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''C4.1.FacilityZip1'']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </data>
        <data id="C4.1.22_FacilityPhone">
          <xsl:if test="string-length(data[@id=''C4.1.FacilityPhone1'']) &gt; 0">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.FacilityPhone1''], 1, 3)"/>
            <xsl:text>) </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.FacilityPhone1''], 4, 3)"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.FacilityPhone1''], 7, 4)"/>
          </xsl:if>
        </data>

        <data id="C4.1.23_PracticeName">
          <xsl:value-of select="data[@id=''C4.1.PracticeName1'']"/>
        </data>
        <data id="C4.1.23_PracticeAddress_Street">
          <xsl:value-of select="data[@id=''C4.1.PracticeStreet11'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.PracticeStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.PracticeStreet21'']"/>
          </xsl:if>
        </data>
        <data id="C4.1.23_PracticeAddress_CityStateZip">
          <xsl:if test="string-length(data[@id=''C4.1.PracticeCity1'']) &gt; 0">
            <xsl:value-of select="data[@id=''C4.1.PracticeCity1'']"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''C4.1.PracticeState1'']"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''C4.1.PracticeZip1'']) = 9">
                <xsl:value-of select="substring(data[@id=''C4.1.PracticeZip1''], 1, 5)"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(data[@id=''C4.1.PracticeZip1''], 6, 4)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''C4.1.PracticeZip1'']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </data>
        <data id="C4.1.23_PracticePhone">
          <xsl:if test="string-length(data[@id=''C4.1.PracticePhone1'']) &gt; 0">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.PracticePhone1''], 1, 3)"/>
            <xsl:text>) </xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.PracticePhone1''], 4, 3)"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="substring(data[@id=''C4.1.PracticePhone1''], 7, 4)"/>
          </xsl:if>
        </data>

				<!-- Procedure 1 -->
        
				<ClaimID>
					<xsl:value-of select="data[@id=''C4.1.ClaimID1'']"/>
				</ClaimID>
        
				<data id="C4.1.13A_ServiceBeginDateMM1">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate1''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateDD1">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate1''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateYY1">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate1''], 9, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateMM1">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate1''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateDD1">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate1''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateYY1">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate1''], 9, 2)"/>
				</data>
        
				<data id="C4.1.13B_POS1">
					<xsl:value-of select="data[@id=''C4.1.PlaceOfServiceCode1'']"/>
				</data>
        
				<data id="C4.1.13D_CPT1">
					<xsl:value-of select="data[@id=''C4.1.ProcedureCode1'']"/>
				</data>
				<data id="C4.1.13D_FirstModifier1">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier11'']"/>
				</data>
				<data id="C4.1.13D_OtherModifiers1">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier21'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier31'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier41'']"/>
				</data>
        
				<data id="C4.1.13E_DiagnosisCodes1">
					<xsl:value-of select="data[@id=''C4.1.DiagnosisPointer11'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer21'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer21'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer31'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer31'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer41'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer41'']"/>
          </xsl:if>
				</data>
        
				<xsl:if test="data[@id=''C4.1.ServiceUnitCount1''] &gt; 0">
					<data id="C4.1.13F_Charges_Dollars1">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''C4.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars"/>
					</data>
					<data id="C4.1.13F_Charges_Cents1">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''C4.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
						<xsl:value-of select="$charge-cents"/>
					</data>
          
					<data id="C4.1.13G_ServiceUnitCount1">
            <xsl:value-of select="format-number(data[@id=''C4.1.ServiceUnitCount1''], ''#.00'', ''default-format'')"/>
					</data>
				</xsl:if>

        <data id="C4.1.13I_ServiceLocationZip1">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''C4.1.ServiceLocationZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip1''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip1''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''C4.1.ServiceLocationZip1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        
				<!-- Procedure 2 -->
        
				<ClaimID>
					<xsl:value-of select="data[@id=''C4.1.ClaimID2'']"/>
				</ClaimID>
        
				<data id="C4.1.13A_ServiceBeginDateMM2">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate2''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateDD2">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate2''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateYY2">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate2''], 9, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateMM2">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate2''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateDD2">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate2''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateYY2">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate2''], 9, 2)"/>
				</data>
        
				<data id="C4.1.13B_POS2">
					<xsl:value-of select="data[@id=''C4.1.PlaceOfServiceCode2'']"/>
				</data>
        
				<data id="C4.1.13D_CPT2">
					<xsl:value-of select="data[@id=''C4.1.ProcedureCode2'']"/>
				</data>
				<data id="C4.1.13D_FirstModifier2">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier12'']"/>
				</data>
				<data id="C4.1.13D_OtherModifiers2">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier22'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier32'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier42'']"/>
				</data>
        
				<data id="C4.1.13E_DiagnosisCodes2">
					<xsl:value-of select="data[@id=''C4.1.DiagnosisPointer12'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer22'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer22'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer32'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer32'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer42'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer42'']"/>
          </xsl:if>
				</data>
        
				<xsl:if test="data[@id=''C4.1.ServiceUnitCount2''] &gt; 0">
					<data id="C4.1.13F_Charges_Dollars2">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''C4.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
						<xsl:value-of select="$charge-dollars"/>
					</data>
					<data id="C4.1.13F_Charges_Cents2">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''C4.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')"/>
						<xsl:value-of select="$charge-cents"/>
					</data>
          
					<data id="C4.1.13G_ServiceUnitCount2">
            <xsl:value-of select="format-number(data[@id=''C4.1.ServiceUnitCount2''], ''#.00'', ''default-format'')"/>
					</data>
				</xsl:if>

        <data id="C4.1.13I_ServiceLocationZip2">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''C4.1.ServiceLocationZip2'']) = 9">
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip2''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip2''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''C4.1.ServiceLocationZip2'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>

				<!-- Procedure 3 -->
        
				<ClaimID>
					<xsl:value-of select="data[@id=''C4.1.ClaimID3'']"/>
				</ClaimID>
        
				<data id="C4.1.13A_ServiceBeginDateMM3">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate3''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateDD3">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate3''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateYY3">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate3''], 9, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateMM3">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate3''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateDD3">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate3''], 4, 2)" />
				</data>
				<data id="C4.1.13A_ServiceEndDateYY3">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate3''], 9, 2)"/>
				</data>
        
				<data id="C4.1.13B_POS3">
					<xsl:value-of select="data[@id=''C4.1.PlaceOfServiceCode3'']"/>
				</data>
        
				<data id="C4.1.13D_CPT3">
					<xsl:value-of select="data[@id=''C4.1.ProcedureCode3'']"/>
				</data>
				<data id="C4.1.13D_FirstModifier3">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier13'']"/>
				</data>
				<data id="C4.1.13D_OtherModifiers3">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier23'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier33'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier43'']"/>
				</data>
        
				<data id="C4.1.13E_DiagnosisCodes3">
					<xsl:value-of select="data[@id=''C4.1.DiagnosisPointer13'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer23'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer23'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer33'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer33'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer43'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer43'']"/>
          </xsl:if>
				</data>
        
				<xsl:if test="data[@id=''C4.1.ServiceUnitCount3''] &gt; 0">
					<data id="C4.1.13F_Charges_Dollars3">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''C4.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
						<xsl:value-of select="$charge-dollars"/>
					</data>
					<data id="C4.1.13F_Charges_Cents3">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''C4.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')"/>
						<xsl:value-of select="$charge-cents"/>
					</data>
          
					<data id="C4.1.13G_ServiceUnitCount3">
            <xsl:value-of select="format-number(data[@id=''C4.1.ServiceUnitCount3''], ''#.00'', ''default-format'')"/>
					</data>
				</xsl:if>

        <data id="C4.1.13I_ServiceLocationZip3">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''C4.1.ServiceLocationZip3'']) = 9">
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip3''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip3''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''C4.1.ServiceLocationZip3'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>

				<!-- Procedure 4 -->
        
				<ClaimID>
					<xsl:value-of select="data[@id=''C4.1.ClaimID4'']"/>
				</ClaimID>
        
				<data id="C4.1.13A_ServiceBeginDateMM4">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate4''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateDD4">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate4''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateYY4">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate4''], 9, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateMM4">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate4''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateDD4">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate4''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateYY4">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate4''], 9, 2)"/>
				</data>
        
				<data id="C4.1.13B_POS4">
					<xsl:value-of select="data[@id=''C4.1.PlaceOfServiceCode4'']"/>
				</data>
        
				<data id="C4.1.13D_CPT4">
					<xsl:value-of select="data[@id=''C4.1.ProcedureCode4'']"/>
				</data>
				<data id="C4.1.13D_FirstModifier4">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier14'']"/>
				</data>
				<data id="C4.1.13D_OtherModifiers4">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier24'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier34'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier44'']"/>
				</data>
        
				<data id="C4.1.13E_DiagnosisCodes4">
					<xsl:value-of select="data[@id=''C4.1.DiagnosisPointer14'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer24'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer24'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer34'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer34'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer44'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer44'']"/>
          </xsl:if>
				</data>
        
				<xsl:if test="data[@id=''C4.1.ServiceUnitCount4''] &gt; 0">
					<data id="C4.1.13F_Charges_Dollars4">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''C4.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
						<xsl:value-of select="$charge-dollars"/>
					</data>
					<data id="C4.1.13F_Charges_Cents4">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''C4.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')"/>
						<xsl:value-of select="$charge-cents"/>
					</data>
          
					<data id="C4.1.13G_ServiceUnitCount4">
            <xsl:value-of select="format-number(data[@id=''C4.1.ServiceUnitCount4''], ''#.00'', ''default-format'')"/>
					</data>
				</xsl:if>
        
        <data id="C4.1.13I_ServiceLocationZip4">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''C4.1.ServiceLocationZip4'']) = 9">
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip4''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip4''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''C4.1.ServiceLocationZip4'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>

				<!-- Procedure 5 -->
        
				<ClaimID>
					<xsl:value-of select="data[@id=''C4.1.ClaimID5'']"/>
				</ClaimID>
        
				<data id="C4.1.13A_ServiceBeginDateMM5">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate5''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateDD5">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate5''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateYY5">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate5''], 9, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateMM5">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate5''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateDD5">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate5''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateYY5">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate5''], 9, 2)"/>
				</data>
        
				<data id="C4.1.13B_POS5">
					<xsl:value-of select="data[@id=''C4.1.PlaceOfServiceCode5'']"/>
				</data>
        
				<data id="C4.1.13D_CPT5">
					<xsl:value-of select="data[@id=''C4.1.ProcedureCode5'']"/>
				</data>
				<data id="C4.1.13D_FirstModifier5">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier15'']"/>
				</data>
				<data id="C4.1.13D_OtherModifiers5">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier25'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier35'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier45'']"/>
				</data>
        
				<data id="C4.1.13E_DiagnosisCodes5">
					<xsl:value-of select="data[@id=''C4.1.DiagnosisPointer15'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer25'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer25'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer35'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer35'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer45'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer45'']"/>
          </xsl:if>
				</data>
        
				<xsl:if test="data[@id=''C4.1.ServiceUnitCount5''] &gt; 0">
					<data id="C4.1.13F_Charges_Dollars5">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''C4.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
						<xsl:value-of select="$charge-dollars"/>
					</data>
					<data id="C4.1.13F_Charges_Cents5">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''C4.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')"/>
						<xsl:value-of select="$charge-cents"/>
					</data>
          
					<data id="C4.1.13G_ServiceUnitCount5">
            <xsl:value-of select="format-number(data[@id=''C4.1.ServiceUnitCount5''], ''#.00'', ''default-format'')"/>
					</data>
				</xsl:if>

        <data id="C4.1.13I_ServiceLocationZip5">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''C4.1.ServiceLocationZip5'']) = 9">
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip5''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip5''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''C4.1.ServiceLocationZip5'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>

				<!-- Procedure 6 -->
        
				<ClaimID>
					<xsl:value-of select="data[@id=''C4.1.ClaimID6'']"/>
				</ClaimID>
        
				<data id="C4.1.13A_ServiceBeginDateMM6">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate6''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateDD6">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate6''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceBeginDateYY6">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceBeginDate6''], 9, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateMM6">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate6''], 1, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateDD6">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate6''], 4, 2)"/>
				</data>
				<data id="C4.1.13A_ServiceEndDateYY6">
					<xsl:value-of select="substring(data[@id=''C4.1.ServiceEndDate6''], 9, 2)"/>
				</data>
        
				<data id="C4.1.13B_POS6">
					<xsl:value-of select="data[@id=''C4.1.PlaceOfServiceCode6'']"/>
				</data>
        
				<data id="C4.1.13D_CPT6">
					<xsl:value-of select="data[@id=''C4.1.ProcedureCode6'']"/>
				</data>
				<data id="C4.1.13D_FirstModifier6">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier16'']"/>
				</data>
				<data id="C4.1.13D_OtherModifiers6">
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier26'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier36'']"/>
					<xsl:value-of select="data[@id=''C4.1.ProcedureModifier46'']"/>
				</data>
        
				<data id="C4.1.13E_DiagnosisCodes6">
					<xsl:value-of select="data[@id=''C4.1.DiagnosisPointer16'']"/>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer26'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer26'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer36'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer36'']"/>
          </xsl:if>
          <xsl:if test="string-length(data[@id=''C4.1.DiagnosisPointer46'']) &gt; 0">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="data[@id=''C4.1.DiagnosisPointer46'']"/>
          </xsl:if>
				</data>
        
				<xsl:if test="data[@id=''C4.1.ServiceUnitCount6''] &gt; 0">
					<data id="C4.1.13F_Charges_Dollars6">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''C4.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')"/>
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
						<xsl:value-of select="$charge-dollars"/>
					</data>
					<data id="C4.1.13F_Charges_Cents6">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''C4.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')"/>
						<xsl:value-of select="$charge-cents"/>
					</data>
          
					<data id="C4.1.13G_ServiceUnitCount6">
            <xsl:value-of select="format-number(data[@id=''C4.1.ServiceUnitCount6''], ''#.00'', ''default-format'')"/>
					</data>
				</xsl:if>

        <data id="C4.1.13I_ServiceLocationZip6">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''C4.1.ServiceLocationZip6'']) = 9">
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip6''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''C4.1.ServiceLocationZip6''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''C4.1.ServiceLocationZip6'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
				
			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE BillingFormID = 15