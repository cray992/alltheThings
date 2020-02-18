/*
-----------------------------------------------------------------------------------------------------
CASE 14281 - Implement UB-92 Form
-----------------------------------------------------------------------------------------------------
*/
/*
INSERT INTO BillingForm(BillingFormID, FormType, FormName, PrintingFormID, MaxProcedures, MaxDiagnosis)
VALUES(12, 'UB92', 'UB-92', 18, 21, 4)

INSERT INTO PrintingForm(PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
VALUES(18, 'UB92', 'UB-92', 'BillDataProvider_GetUB92DocumentData', 0)

INSERT INTO PrintingFormDetails(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description)
VALUES(74, 18, 61, 'UB-92')
*/
UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="UB92" pageId="UB92.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
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
    <text x="0.22in" y="0.22in" width="2.56in" height="0.10in" valueSource="UB92.1.1_ProviderName" />
    <text x="0.22in" y="0.38in" width="2.56in" height="0.10in" valueSource="UB92.1.1_PracticeAddress_Street" />
    <text x="0.22in" y="0.54in" width="2.56in" height="0.10in" valueSource="UB92.1.1_PracticeAddress_CityStateZip" />
    <text x="0.22in" y="0.70in" width="2.56in" height="0.10in" valueSource="UB92.1.1_PracticePhone" />
    <text x="5.90in" y="0.37in" width="2.12in" height="0.10in" valueSource="UB92.1.3_PatientControlNumber" />
    <text x="8.0in" y="0.37in" width="0.46in" height="0.10in" valueSource="UB92.1.4_BillType" />
    <text x="2.81in" y="0.70in" width="1.14in" height="0.10in" valueSource="UB92.1.5_EmployerIDNumber" />
    <text x="3.91in" y="0.70in" width="0.76in" height="0.10in" valueSource="UB92.1.6_StatementPeriodBeginDate" />
    <text x="4.62in" y="0.70in" width="0.76in" height="0.10in" valueSource="UB92.1.6_StatementPeriodEndDate" />
		<text x="0.22in" y="1.03in" width="3.08in" height="0.10in" valueSource="UB92.1.12_PatientName" />
    <text x="3.29in" y="1.03in" width="5.13in" height="0.10in" valueSource="UB92.1.13_PatientAddress" />
    <text x="0.22in" y="1.37in" width="0.82in" height="0.10in" valueSource="UB92.1.14_PatientBirthDate" />
    <text x="1.13in" y="1.37in" width="0.17in" height="0.10in" valueSource="UB92.1.15_PatientGender" />
    <text x="1.39in" y="1.37in" width="0.17in" height="0.10in" valueSource="UB92.1.16_PatientMaritalStatus" />
    <text x="1.56in" y="1.37in" width="0.76in" height="0.10in" valueSource="UB92.1.17_AdmissionDate" />
    <text x="3.81in" y="1.37in" width="1.80in" height="0.10in" valueSource="UB92.1.23_PatientMedicalRecordNumber" />
    <text x="5.60in" y="1.37in" width="0.31in" height="0.10in" valueSource="UB92.1.24_ConditionCode_EPSDT" />
    <text x="5.90in" y="1.37in" width="0.31in" height="0.10in" valueSource="UB92.1.25_ConditionCode_FamilyPlanning" />
    <text x="0.19in" y="1.71in" width="0.31in" height="0.10in" valueSource="UB92.1.32a_OccurrenceCode_AutoAccident" />
    <text x="0.49in" y="1.71in" width="0.77in" height="0.10in" valueSource="UB92.1.32a_AutoAccidentDate" />
    <text x="1.19in" y="1.71in" width="0.31in" height="0.10in" valueSource="UB92.1.33a_OccurrenceCode_EmploymentRelated" />
    <text x="1.49in" y="1.71in" width="0.77in" height="0.10in" valueSource="UB92.1.33a_EmploymentAccidentDate" />
    <text x="2.19in" y="1.71in" width="0.31in" height="0.10in" valueSource="UB92.1.34a_OccurrenceCode_OtherAccident" />
    <text x="2.49in" y="1.71in" width="0.77in" height="0.10in" valueSource="UB92.1.34a_OtherAccidentDate" />
  </g>

  <g id="Procedures">
    <text x="0.19in" y="3.045in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode1" />
    <text x="0.70in" y="3.045in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description1" />
    <text x="3.20in" y="3.045in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode1" />
    <text x="4.21in" y="3.045in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate1" />
    <text x="4.91in" y="3.045in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount1" />
    <text x="5.64in" y="3.045in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount1" class="money"/>

    <text x="0.19in" y="3.21in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode2" />
    <text x="0.70in" y="3.21in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description2" />
    <text x="3.20in" y="3.21in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode2" />
    <text x="4.21in" y="3.21in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate2" />
    <text x="4.91in" y="3.21in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount2" />
    <text x="5.64in" y="3.21in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount2" class="money"/>

    <text x="0.19in" y="3.375in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode3" />
    <text x="0.70in" y="3.375in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description3" />
    <text x="3.20in" y="3.375in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode3" />
    <text x="4.21in" y="3.375in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate3" />
    <text x="4.91in" y="3.375in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount3" />
    <text x="5.64in" y="3.375in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount3" class="money"/>

    <text x="0.19in" y="3.54in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode4" />
    <text x="0.70in" y="3.54in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description4" />
    <text x="3.20in" y="3.54in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode4" />
    <text x="4.21in" y="3.54in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate4" />
    <text x="4.91in" y="3.54in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount4" />
    <text x="5.64in" y="3.54in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount4" class="money"/>

    <text x="0.19in" y="3.705in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode5" />
    <text x="0.70in" y="3.705in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description5" />
    <text x="3.20in" y="3.705in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode5" />
    <text x="4.21in" y="3.705in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate5" />
    <text x="4.91in" y="3.705in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount5" />
    <text x="5.64in" y="3.705in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount5" class="money"/>

    <text x="0.19in" y="3.87in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode6" />
    <text x="0.70in" y="3.87in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description6" />
    <text x="3.20in" y="3.87in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode6" />
    <text x="4.21in" y="3.87in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate6" />
    <text x="4.91in" y="3.87in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount6" />
    <text x="5.64in" y="3.87in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount6" class="money"/>

    <text x="0.19in" y="4.035in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode7" />
    <text x="0.70in" y="4.035in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description7" />
    <text x="3.20in" y="4.035in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode7" />
    <text x="4.21in" y="4.035in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate7" />
    <text x="4.91in" y="4.035in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount7" />
    <text x="5.64in" y="4.035in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount7" class="money"/>

    <text x="0.19in" y="4.20in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode8" />
    <text x="0.70in" y="4.20in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description8" />
    <text x="3.20in" y="4.20in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode8" />
    <text x="4.21in" y="4.20in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate8" />
    <text x="4.91in" y="4.20in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount8" />
    <text x="5.64in" y="4.20in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount8" class="money"/>

    <text x="0.19in" y="4.365in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode9" />
    <text x="0.70in" y="4.365in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description9" />
    <text x="3.20in" y="4.365in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode9" />
    <text x="4.21in" y="4.365in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate9" />
    <text x="4.91in" y="4.365in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount9" />
    <text x="5.64in" y="4.365in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount9" class="money"/>

    <text x="0.19in" y="4.53in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode10" />
    <text x="0.70in" y="4.53in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description10" />
    <text x="3.20in" y="4.53in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode10" />
    <text x="4.21in" y="4.53in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate10" />
    <text x="4.91in" y="4.53in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount10" />
    <text x="5.64in" y="4.53in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount10" class="money"/>

    <text x="0.19in" y="4.70in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode11" />
    <text x="0.70in" y="4.70in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description11" />
    <text x="3.20in" y="4.70in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode11" />
    <text x="4.21in" y="4.70in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate11" />
    <text x="4.91in" y="4.70in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount11" />
    <text x="5.64in" y="4.70in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount11" class="money"/>

    <text x="0.19in" y="4.865in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode12" />
    <text x="0.70in" y="4.865in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description12" />
    <text x="3.20in" y="4.865in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode12" />
    <text x="4.21in" y="4.865in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate12" />
    <text x="4.91in" y="4.865in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount12" />
    <text x="5.64in" y="4.865in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount12" class="money"/>

    <text x="0.19in" y="5.03in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode13" />
    <text x="0.70in" y="5.03in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description13" />
    <text x="3.20in" y="5.03in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode13" />
    <text x="4.21in" y="5.03in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate13" />
    <text x="4.91in" y="5.03in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount13" />
    <text x="5.64in" y="5.03in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount13" class="money"/>

    <text x="0.19in" y="5.195in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode14" />
    <text x="0.70in" y="5.195in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description14" />
    <text x="3.20in" y="5.195in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode14" />
    <text x="4.21in" y="5.195in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate14" />
    <text x="4.91in" y="5.195in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount14" />
    <text x="5.64in" y="5.195in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount14" class="money"/>

    <text x="0.19in" y="5.36in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode15" />
    <text x="0.70in" y="5.36in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description15" />
    <text x="3.20in" y="5.36in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode15" />
    <text x="4.21in" y="5.36in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate15" />
    <text x="4.91in" y="5.36in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount15" />
    <text x="5.64in" y="5.36in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount15" class="money"/>

    <text x="0.19in" y="5.525in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode16" />
    <text x="0.70in" y="5.525in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description16" />
    <text x="3.20in" y="5.525in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode16" />
    <text x="4.21in" y="5.525in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate16" />
    <text x="4.91in" y="5.525in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount16" />
    <text x="5.64in" y="5.525in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount16" class="money"/>

    <text x="0.19in" y="5.69in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode17" />
    <text x="0.70in" y="5.69in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description17" />
    <text x="3.20in" y="5.69in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode17" />
    <text x="4.21in" y="5.69in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate17" />
    <text x="4.91in" y="5.69in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount17" />
    <text x="5.64in" y="5.69in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount17" class="money"/>

    <text x="0.19in" y="5.855in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode18" />
    <text x="0.70in" y="5.855in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description18" />
    <text x="3.20in" y="5.855in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode18" />
    <text x="4.21in" y="5.855in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate18" />
    <text x="4.91in" y="5.855in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount18" />
    <text x="5.64in" y="5.855in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount18" class="money"/>

    <text x="0.19in" y="6.02in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode19" />
    <text x="0.70in" y="6.02in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description19" />
    <text x="3.20in" y="6.02in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode19" />
    <text x="4.21in" y="6.02in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate19" />
    <text x="4.91in" y="6.02in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount19" />
    <text x="5.64in" y="6.02in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount19" class="money"/>

    <text x="0.19in" y="6.185in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode20" />
    <text x="0.70in" y="6.185in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description20" />
    <text x="3.20in" y="6.185in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode20" />
    <text x="4.21in" y="6.185in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate20" />
    <text x="4.91in" y="6.185in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount20" />
    <text x="5.64in" y="6.185in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount20" class="money"/>

    <text x="0.19in" y="6.35in" width="0.55in" height="0.10in" valueSource="UB92.1.42_RevenueCode21" />
    <text x="0.70in" y="6.35in" width="2.50in" height="0.10in" valueSource="UB92.1.43_Description21" />
    <text x="3.20in" y="6.35in" width="1.0in" height="0.10in" valueSource="UB92.1.44_ProcedureCode21" />
    <text x="4.21in" y="6.35in" width="0.70in" height="0.10in" valueSource="UB92.1.45_ServiceBeginDate21" />
    <text x="4.91in" y="6.35in" width="0.81in" height="0.10in" valueSource="UB92.1.46_ServiceUnitCount21" />
    <text x="5.64in" y="6.35in" width="1.0in" height="0.10in" valueSource="UB92.1.47_ChargeAmount21" class="money"/>
  </g>

  <g>
    <text x="0.70in" y="6.70in" width="2.50in" height="0.10in" valueSource="UB92.1.47_TotalChargesLabel" />
    <text x="5.64in" y="6.70in" width="1.0in" height="0.10in" valueSource="UB92.1.47_TotalCharges" class="money" />
    <text x="0.22in" y="7.04in" width="2.59in" height="0.10in" valueSource="UB92.1.50A_InsuredPlanName" />
    <text x="0.22in" y="7.20in" width="2.59in" height="0.10in" valueSource="UB92.1.50B_OtherInsuredPlanName" />
    <text x="2.82in" y="7.04in" width="1.41in" height="0.10in" valueSource="UB92.1.51A_ProviderNumber" />
    <text x="2.82in" y="7.20in" width="1.41in" height="0.10in" valueSource="UB92.1.51B_OtherProviderNumber" />
    <text x="0.22in" y="7.87in" width="2.59in" height="0.10in" valueSource="UB92.1.58A_InsuredName" />
    <text x="0.22in" y="8.03in" width="2.59in" height="0.10in" valueSource="UB92.1.58B_OtherInsuredName" />
    <text x="2.81in" y="7.87in" width="0.31in" height="0.10in" valueSource="UB92.1.59A_RelationshipToPatient" />
    <text x="2.81in" y="8.03in" width="0.31in" height="0.10in" valueSource="UB92.1.59B_OtherRelationshipToPatient" />
    <text x="3.10in" y="7.87in" width="1.97in" height="0.10in" valueSource="UB92.1.60A_InsuredPolicyNumber" />
    <text x="3.10in" y="8.03in" width="1.97in" height="0.10in" valueSource="UB92.1.60B_OtherInsuredPolicyNumber" />
    <text x="6.60in" y="7.87in" width="1.91in" height="0.10in" valueSource="UB92.1.62A_GroupNumber" />
    <text x="6.60in" y="8.03in" width="1.91in" height="0.10in" valueSource="UB92.1.62B_OtherGroupNumber" />
    <text x="0.22in" y="9.20in" width="0.74in" height="0.10in" valueSource="UB92.1.67_Diagnosis1" />
    <text x="0.91in" y="9.20in" width="0.74in" height="0.10in" valueSource="UB92.1.68_Diagnosis2" />
    <text x="1.61in" y="9.20in" width="0.74in" height="0.10in" valueSource="UB92.1.69_Diagnosis3" />
    <text x="2.31in" y="9.20in" width="0.74in" height="0.10in" valueSource="UB92.1.70_Diagnosis4" />
    <text x="0.51in" y="9.53in" width="0.86in" height="0.10in" valueSource="UB92.1.80_PrincipalProcedureCode" />
    <text x="1.30in" y="9.53in" width="0.76in" height="0.10in" valueSource="UB92.1.80_PrincipalProcedureDate" />
    <text x="2.01in" y="9.53in" width="0.86in" height="0.10in" valueSource="UB92.1.81A_PrincipalProcedureCode" />
    <text x="2.80in" y="9.53in" width="0.76in" height="0.10in" valueSource="UB92.1.81A_PrincipalProcedureDate" />
    <text x="3.51in" y="9.53in" width="0.86in" height="0.10in" valueSource="UB92.1.81B_PrincipalProcedureCode" />
    <text x="4.30in" y="9.53in" width="0.76in" height="0.10in" valueSource="UB92.1.81B_PrincipalProcedureDate" />
    <text x="0.51in" y="9.86in" width="0.86in" height="0.10in" valueSource="UB92.1.81C_PrincipalProcedureCode" />
    <text x="1.30in" y="9.86in" width="0.76in" height="0.10in" valueSource="UB92.1.81C_PrincipalProcedureDate" />
    <text x="2.01in" y="9.86in" width="0.86in" height="0.10in" valueSource="UB92.1.81D_PrincipalProcedureCode" />
    <text x="2.80in" y="9.86in" width="0.76in" height="0.10in" valueSource="UB92.1.81D_PrincipalProcedureDate" />
    <text x="3.51in" y="9.86in" width="0.86in" height="0.10in" valueSource="UB92.1.81E_PrincipalProcedureCode" />
    <text x="4.30in" y="9.86in" width="0.76in" height="0.10in" valueSource="UB92.1.81E_PrincipalProcedureDate" />
    <text x="5.11in" y="9.53in" width="1.03in" height="0.10in" valueSource="UB92.1.82_AttendingPhysicianID" />
    <text x="6.14in" y="9.53in" width="2.33in" height="0.10in" valueSource="UB92.1.82_AttendingPhysicianName" />
    <text x="5.11in" y="9.86in" width="3.39in" height="0.10in" valueSource="UB92.1.83_OtherPhysicianID" />
    <text x="5.33in" y="10.52in" width="2.05in" height="0.10in" valueSource="UB92.1.85_Signature" />
    <text x="7.36in" y="10.52in" width="1.04in" height="0.10in" valueSource="UB92.1.85_Date" />
  </g>
  
</svg>'
WHERE PrintingFormDetailsID = 74

Update BillingForm
SET TransForm = '<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml"/>
  <xsl:decimal-format name="default-format" NaN="0.00"/>
  <xsl:template match="/formData/page">
    <formData formId="UB92">
      <page pageId="UB92.1">
        <BillID>
          <xsl:value-of select="data[@id=''UB92.1.BillID1'']"/>
        </BillID>

        <data id="UB92.1.1_ProviderName">
          <xsl:value-of select="data[@id=''UB92.1.RenderingProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''UB92.1.RenderingProviderMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.RenderingProviderMiddleName1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''UB92.1.RenderingProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''UB92.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''UB92.1.RenderingProviderDegree1'']"/>
          </xsl:if>
        </data>
        <data id="UB92.1.1_PracticeAddress_Street">
          <xsl:value-of select="data[@id=''UB92.1.PracticeStreet11'']"/>
          <xsl:if test="string-length(data[@id=''UB92.1.PracticeStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''UB92.1.PracticeStreet21'']"/>
          </xsl:if>
        </data>
        <data id="UB92.1.1_PracticeAddress_CityStateZip">
          <xsl:value-of select="data[@id=''UB92.1.PracticeCity1'']"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''UB92.1.PracticeState1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''UB92.1.PracticeZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''UB92.1.PracticeZip1''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''UB92.1.PracticeZip1''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''UB92.1.PracticeZip1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="UB92.1.1_PracticePhone">
          <xsl:if test="string-length(data[@id=''UB92.1.PracticePhone1'']) &gt; 0">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="substring(data[@id=''UB92.1.PracticePhone1''], 1, 3)"/>
            <xsl:text>) </xsl:text>
            <xsl:value-of select="substring(data[@id=''UB92.1.PracticePhone1''], 4, 3)"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="substring(data[@id=''UB92.1.PracticePhone1''], 7, 4)"/>
          </xsl:if>
        </data>

        <data id="UB92.1.3_PatientControlNumber">
          <xsl:value-of select="data[@id=''UB92.1.PatientAccountNumber1'']"/>
        </data>

        <data id="UB92.1.4_BillType">
          711
        </data>

        <data id="UB92.1.5_EmployerIDNumber">
          <xsl:value-of select="data[@id=''UB92.1.FederalTaxID1'']"/>
        </data>

        <data id="UB92.1.6_StatementPeriodBeginDate">
          <xsl:if test="string-length(data[@id=''UB92.1.StatementBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.StatementBeginDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.StatementBeginDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.StatementBeginDate1''], 7, 4)"/>
          </xsl:if>
        </data>
        <data id="UB92.1.6_StatementPeriodEndDate">
          <xsl:if test="string-length(data[@id=''UB92.1.StatementEndDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.StatementEndDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.StatementEndDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.StatementEndDate1''], 7, 4)"/>
          </xsl:if>
        </data>
        
        <data id="UB92.1.12_PatientName">
          <xsl:value-of select="data[@id=''UB92.1.PatientFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''UB92.1.PatientMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.PatientMiddleName1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''UB92.1.PatientLastName1'']"/>
          <xsl:if test="string-length(data[@id=''UB92.1.PatientSuffix1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''UB92.1.PatientSuffix1'']"/>
          </xsl:if>
        </data>

        <data id="UB92.1.13_PatientAddress">
          <xsl:value-of select="data[@id=''UB92.1.PatientStreet11'']"/>
          <xsl:if test="string-length(data[@id=''UB92.1.PatientStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''UB92.1.PatientStreet21'']"/>
          </xsl:if>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''UB92.1.PatientCity1'']"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''UB92.1.PatientState1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''UB92.1.PatientZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''UB92.1.PatientZip1''], 1, 5)"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''UB92.1.PatientZip1''], 6, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''UB92.1.PatientZip1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        
        <data id="UB92.1.14_PatientBirthDate">
          <xsl:if test="string-length(data[@id=''UB92.1.PatientBirthDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.PatientBirthDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.PatientBirthDate1''], 4, 2)"/>
		        <xsl:value-of select="substring(data[@id=''UB92.1.PatientBirthDate1''], 7, 4)"/>
	        </xsl:if>
        </data>

        <data id="UB92.1.15_PatientGender">
          <xsl:value-of select="data[@id=''UB92.1.PatientGender1'']"/>
        </data>

        <data id="UB92.1.16_PatientMaritalStatus">
          <xsl:value-of select="data[@id=''UB92.1.PatientMaritalStatus1'']"/>
        </data>

        <data id="UB92.1.17_AdmissionDate">
          <xsl:if test="string-length(data[@id=''UB92.1.HospitalizationBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.HospitalizationBeginDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.HospitalizationBeginDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.HospitalizationBeginDate1''], 7, 4)"/>
          </xsl:if>
        </data>

        <data id="UB92.1.23_PatientMedicalRecordNumber">
          <xsl:value-of select="data[@id=''UB92.1.PatientMedicalRecordNumber1'']"/>
        </data>

        <data id="UB92.1.24_ConditionCode_EPSDT">
          <xsl:if test="data[@id=''UB92.1.EPSDTFlag1''] = ''1''">A1</xsl:if>
        </data>

        <data id="UB92.1.25_ConditionCode_FamilyPlanning">
          <xsl:if test="data[@id=''UB92.1.FamilyPlanningFlag1''] = ''1''">A4</xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.AutoAccidentRelatedFlag1''] = ''1''">
          <data id="UB92.1.32a_OccurrenceCode_AutoAccident">
            01
          </data>
          <data id="UB92.1.32a_AutoAccidentDate">
            <xsl:if test="string-length(data[@id=''UB92.1.InjuryDate1'']) &gt; 0">
              <xsl:value-of select="substring(data[@id=''UB92.1.InjuryDate1''], 1, 2)"/>
              <xsl:value-of select="substring(data[@id=''UB92.1.InjuryDate1''], 4, 2)"/>
              <xsl:value-of select="substring(data[@id=''UB92.1.InjuryDate1''], 9, 2)"/>
            </xsl:if>
          </data>
        </xsl:if>

        <xsl:if test="data[@id=''UB92.1.EmploymentRelatedFlag1''] = ''1''">
          <data id="UB92.1.33a_OccurrenceCode_EmploymentRelated">
            04
          </data>
          <data id="UB92.1.33a_EmploymentAccidentDate">
            <xsl:if test="string-length(data[@id=''UB92.1.InjuryDate1'']) &gt; 0">
              <xsl:value-of select="substring(data[@id=''UB92.1.InjuryDate1''], 1, 2)"/>
              <xsl:value-of select="substring(data[@id=''UB92.1.InjuryDate1''], 4, 2)"/>
              <xsl:value-of select="substring(data[@id=''UB92.1.InjuryDate1''], 9, 2)"/>
            </xsl:if>
          </data>
        </xsl:if>

        <xsl:if test="data[@id=''UB92.1.OtherAccidentRelatedFlag1''] = ''1''">
          <data id="UB92.1.34a_OccurrenceCode_OtherAccident">
            05
          </data>
          <data id="UB92.1.34a_OtherAccidentDate">
            <xsl:if test="string-length(data[@id=''UB92.1.InjuryDate1'']) &gt; 0">
              <xsl:value-of select="substring(data[@id=''UB92.1.InjuryDate1''], 1, 2)"/>
              <xsl:value-of select="substring(data[@id=''UB92.1.InjuryDate1''], 4, 2)"/>
              <xsl:value-of select="substring(data[@id=''UB92.1.InjuryDate1''], 9, 2)"/>
            </xsl:if>
          </data>
        </xsl:if>

        <data id="UB92.1.47_TotalChargesLabel">
          TOTAL CHARGES
        </data>

        <data id="UB92.1.47_TotalCharges">
          <xsl:value-of select="data[@id=''UB92.1.TotalChargeAmount1'']"/>
        </data>
        
        <data id="UB92.1.50A_InsuredPlanName">
          <xsl:value-of select="data[@id=''UB92.1.PayerName1'']"/>
        </data>
        <data id="UB92.1.50B_OtherInsuredPlanName">
          <xsl:value-of select="data[@id=''UB92.1.OtherPayerName1'']"/>
        </data>

        <data id="UB92.1.51A_ProviderNumber">
          <xsl:choose>
            <xsl:when test="data[@id=''UB92.1.InsuranceType1''] = ''MC''">
              <xsl:value-of select="data[@id=''UB92.1.ProviderMedicaidID1'']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''UB92.1.ProviderUPIN1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="UB92.1.51B_OtherProviderNumber">
          <xsl:choose>
            <xsl:when test="data[@id=''UB92.1.OtherInsuranceType1''] = ''MC''">
              <xsl:value-of select="data[@id=''UB92.1.OtherProviderMedicaidID1'']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''UB92.1.OtherProviderUPIN1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        
        <data id="UB92.1.58A_InsuredName">
          <xsl:if test="data[@id=''UB92.1.SubscriberDifferentFlag1''] = ''1''">
            <xsl:value-of select="data[@id=''UB92.1.SubscriberFirstName1'']"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:if test="string-length(data[@id=''UB92.1.SubscriberMiddleName1'']) &gt; 0">
              <xsl:value-of select="substring(data[@id=''UB92.1.SubscriberMiddleName1''], 1, 1)"/>
              <xsl:text xml:space="preserve"> </xsl:text>
            </xsl:if>
            <xsl:value-of select="data[@id=''UB92.1.SubscriberLastName1'']"/>
            <xsl:if test="string-length(data[@id=''UB92.1.SubscriberSuffix1'']) &gt; 0">
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''UB92.1.SubscriberSuffix1'']"/>
            </xsl:if>
          </xsl:if>
        </data>
        <data id="UB92.1.58B_OtherInsuredName">
          <xsl:if test="data[@id=''UB92.1.OtherSubscriberDifferentFlag1''] = ''1''">
            <xsl:value-of select="data[@id=''UB92.1.OtherSubscriberFirstName1'']"/>
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:if test="string-length(data[@id=''UB92.1.OtherSubscriberMiddleName1'']) &gt; 0">
              <xsl:value-of select="substring(data[@id=''UB92.1.OtherSubscriberMiddleName1''], 1, 1)"/>
              <xsl:text xml:space="preserve"> </xsl:text>
            </xsl:if>
            <xsl:value-of select="data[@id=''UB92.1.OtherSubscriberLastName1'']"/>
            <xsl:if test="string-length(data[@id=''UB92.1.OtherSubscriberSuffix1'']) &gt; 0">
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''UB92.1.OtherSubscriberSuffix1'']"/>
            </xsl:if>
          </xsl:if>
        </data>

        <data id="UB92.1.59A_RelationshipToPatient">
          <xsl:if test="data[@id=''UB92.1.SubscriberDifferentFlag1''] = ''1''">
            <xsl:choose>
              <xsl:when test="data[@id=''UB92.1.PatientRelationshipToSubscriber1''] = ''U''">
                SPO
              </xsl:when>
              <xsl:when test="data[@id=''UB92.1.PatientRelationshipToSubscriber1''] = ''C''">
                CHI
              </xsl:when>
              <xsl:when test="data[@id=''UB92.1.PatientRelationshipToSubscriber1''] = ''O''">
                OTH
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </data>
        <data id="UB92.1.59B_OtherRelationshipToPatient">
          <xsl:if test="data[@id=''UB92.1.OtherSubscriberDifferentFlag1''] = ''1''">
            <xsl:choose>
              <xsl:when test="data[@id=''UB92.1.PatientRelationshipToOtherSubscriber1''] = ''U''">
                SPO
              </xsl:when>
              <xsl:when test="data[@id=''UB92.1.PatientRelationshipToOtherSubscriber1''] = ''C''">
                CHI
              </xsl:when>
              <xsl:when test="data[@id=''UB92.1.PatientRelationshipToOtherSubscriber1''] = ''O''">
                OTH
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </data>

        <data id="UB92.1.60A_InsuredPolicyNumber">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''UB92.1.PolicyNumber1'']) &gt; 0">
              <xsl:value-of select="data[@id=''UB92.1.PolicyNumber1'']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''UB92.1.DependentPolicyNumber1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="UB92.1.60B_OtherInsuredPolicyNumber">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''UB92.1.OtherPolicyNumber1'']) &gt; 0">
              <xsl:value-of select="data[@id=''UB92.1.OtherPolicyNumber1'']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''UB92.1.OtherDependentPolicyNumber1'']"/>
            </xsl:otherwise>
          </xsl:choose>
        </data>

        <data id="UB92.1.62A_GroupNumber">
          <xsl:value-of select="data[@id=''UB92.1.GroupNumber1'']"/>
        </data>
        <data id="UB92.1.62B_OtherGroupNumber">
          <xsl:value-of select="data[@id=''UB92.1.OtherGroupNumber1'']"/>
        </data>

        <data id="UB92.1.67_Diagnosis1">
          <xsl:value-of select="data[@id=''UB92.1.DiagnosisCode11'']"/>
        </data>

        <data id="UB92.1.68_Diagnosis2">
          <xsl:value-of select="data[@id=''UB92.1.DiagnosisCode21'']"/>
        </data>

        <data id="UB92.1.69_Diagnosis3">
          <xsl:value-of select="data[@id=''UB92.1.DiagnosisCode31'']"/>
        </data>
        
        <data id="UB92.1.70_Diagnosis4">
          <xsl:value-of select="data[@id=''UB92.1.DiagnosisCode41'']"/>
        </data>

        <data id="UB92.1.80_PrincipalProcedureCode">
          <xsl:value-of select="data[@id=''UB92.1.SurgicalProcedureCode1'']"/>
        </data>
        <data id="UB92.1.80_PrincipalProcedureDate">
          <xsl:if test="string-length(data[@id=''UB92.1.SurgeryDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate1''], 9, 2)"/>
          </xsl:if>
        </data>

        <data id="UB92.1.81A_PrincipalProcedureCode">
          <xsl:value-of select="data[@id=''UB92.1.SurgicalProcedureCode2'']"/>
        </data>
        <data id="UB92.1.81A_PrincipalProcedureDate">
          <xsl:if test="string-length(data[@id=''UB92.1.SurgeryDate2'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate2''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate2''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate2''], 9, 2)"/>
          </xsl:if>
        </data>
        <data id="UB92.1.81B_PrincipalProcedureCode">
          <xsl:value-of select="data[@id=''UB92.1.SurgicalProcedureCode3'']"/>
        </data>
        <data id="UB92.1.81B_PrincipalProcedureDate">
          <xsl:if test="string-length(data[@id=''UB92.1.SurgeryDate3'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate3''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate3''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate3''], 9, 2)"/>
          </xsl:if>
        </data>
        <data id="UB92.1.81C_PrincipalProcedureCode">
          <xsl:value-of select="data[@id=''UB92.1.SurgicalProcedureCode4'']"/>
        </data>
        <data id="UB92.1.81C_PrincipalProcedureDate">
          <xsl:if test="string-length(data[@id=''UB92.1.SurgeryDate4'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate4''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate4''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate4''], 9, 2)"/>
          </xsl:if>
        </data>
        <data id="UB92.1.81D_PrincipalProcedureCode">
          <xsl:value-of select="data[@id=''UB92.1.SurgicalProcedureCode5'']"/>
        </data>
        <data id="UB92.1.81D_PrincipalProcedureDate">
          <xsl:if test="string-length(data[@id=''UB92.1.SurgeryDate5'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate5''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate5''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate5''], 9, 2)"/>
          </xsl:if>
        </data>
        <data id="UB92.1.81E_PrincipalProcedureCode">
          <xsl:value-of select="data[@id=''UB92.1.SurgicalProcedureCode6'']"/>
        </data>
        <data id="UB92.1.81E_PrincipalProcedureDate">
          <xsl:if test="string-length(data[@id=''UB92.1.SurgeryDate6'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate6''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate6''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.SurgeryDate6''], 9, 2)"/>
          </xsl:if>
        </data>

        <data id="UB92.1.82_AttendingPhysicianID">
          <xsl:value-of select="data[@id=''UB92.1.ProviderUPIN1'']"/>
        </data>
        <data id="UB92.1.82_AttendingPhysicianName">
          <xsl:value-of select="data[@id=''UB92.1.RenderingProviderFirstName1'']"/>
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''UB92.1.RenderingProviderMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.RenderingProviderMiddleName1''], 1, 1)"/>
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''UB92.1.RenderingProviderLastName1'']"/>
          <xsl:if test="string-length(data[@id=''UB92.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''UB92.1.RenderingProviderDegree1'']"/>
          </xsl:if>
        </data>

        <data id="UB92.1.83_OtherPhysicianID">
          <xsl:value-of select="data[@id=''UB92.1.ProviderMedicaidID1'']"/>
        </data>

        <data id="UB92.1.85_Signature">
          Signature on File
        </data>
        <data id="UB92.1.85_Date">
          <xsl:value-of select="substring(data[@id=''UB92.1.CurrentDate1''], 1, 2)"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''UB92.1.CurrentDate1''], 4, 2)"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''UB92.1.CurrentDate1''], 9, 2)"/>
        </data>

        <!-- Procedure 1 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID1'']"/>
        </ClaimID>

        <data id="UB92.1.42_RevenueCode1">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode1'']"/>
        </data>

        <data id="UB92.1.43_Description1">
          <xsl:value-of select="data[@id=''UB92.1.Description1'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode1">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode1'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate1">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate1''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate1''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate1''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount1''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount1">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount1'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount1">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount1'']"/>
          </data>
        </xsl:if>
        
        <!-- Procedure 2 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID2'']"/>
        </ClaimID>

        <data id="UB92.1.42_RevenueCode2">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode2'']"/>
        </data>

        <data id="UB92.1.43_Description2">
          <xsl:value-of select="data[@id=''UB92.1.Description2'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode2">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode2'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate2">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate2'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate2''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate2''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate2''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount2''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount2">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount2'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount2">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount2'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 3 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID3'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode3">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode3'']"/>
        </data>

        <data id="UB92.1.43_Description3">
          <xsl:value-of select="data[@id=''UB92.1.Description3'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode3">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode3'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate3">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate3'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate3''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate3''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate3''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount3''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount3">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount3'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount3">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount3'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 4 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID4'']"/>
        </ClaimID>

        <data id="UB92.1.42_RevenueCode4">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode4'']"/>
        </data>

        <data id="UB92.1.43_Description4">
          <xsl:value-of select="data[@id=''UB92.1.Description4'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode4">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode4'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate4">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate4'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate4''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate4''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate4''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount4''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount4">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount4'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount4">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount4'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 5 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID5'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode5">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode5'']"/>
        </data>

        <data id="UB92.1.43_Description5">
          <xsl:value-of select="data[@id=''UB92.1.Description5'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode5">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode5'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate5">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate5'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate5''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate5''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate5''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount5''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount5">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount5'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount5">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount5'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 6 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID6'']"/>
        </ClaimID>

        <data id="UB92.1.42_RevenueCode6">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode6'']"/>
        </data>

        <data id="UB92.1.43_Description6">
          <xsl:value-of select="data[@id=''UB92.1.Description6'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode6">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode6'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate6">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate6'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate6''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate6''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate6''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount6''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount6">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount6'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount6">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount6'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 7 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID7'']"/>
        </ClaimID>

        <data id="UB92.1.42_RevenueCode7">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode7'']"/>
        </data>

        <data id="UB92.1.43_Description7">
          <xsl:value-of select="data[@id=''UB92.1.Description7'']"/>
        </data>
        
        <data id="UB92.1.44_ProcedureCode7">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode7'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate7">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate7'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate7''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate7''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate7''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount7''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount7">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount7'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount7">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount7'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 8 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID8'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode8">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode8'']"/>
        </data>

        <data id="UB92.1.43_Description8">
          <xsl:value-of select="data[@id=''UB92.1.Description8'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode8">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode8'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate8">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate8'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate8''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate8''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate8''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount8''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount8">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount8'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount8">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount8'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 9 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID9'']"/>
        </ClaimID>

        <data id="UB92.1.42_RevenueCode9">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode9'']"/>
        </data>

        <data id="UB92.1.43_Description9">
          <xsl:value-of select="data[@id=''UB92.1.Description9'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode9">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode9'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate9">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate9'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate9''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate9''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate9''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount9''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount9">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount9'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount9">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount9'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 10 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID10'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode10">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode10'']"/>
        </data>

        <data id="UB92.1.43_Description10">
          <xsl:value-of select="data[@id=''UB92.1.Description10'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode10">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode10'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate10">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate10'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate10''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate10''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate10''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount10''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount10">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount10'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount10">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount10'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 11 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID11'']"/>
        </ClaimID>

        <data id="UB92.1.42_RevenueCode11">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode11'']"/>
        </data>

        <data id="UB92.1.43_Description11">
          <xsl:value-of select="data[@id=''UB92.1.Description11'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode11">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode11'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate11">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate11'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate11''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate11''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate11''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount11''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount11">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount11'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount11">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount11'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 12 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID12'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode12">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode12'']"/>
        </data>

        <data id="UB92.1.43_Description12">
          <xsl:value-of select="data[@id=''UB92.1.Description12'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode12">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode12'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate12">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate12'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate12''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate12''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate12''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount12''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount12">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount12'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount12">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount12'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 13 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID13'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode13">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode13'']"/>
        </data>

        <data id="UB92.1.43_Description13">
          <xsl:value-of select="data[@id=''UB92.1.Description13'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode13">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode13'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate13">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate13'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate13''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate13''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate13''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount13''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount13">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount13'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount13">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount13'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 14 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID14'']"/>
        </ClaimID>

        <data id="UB92.1.42_RevenueCode14">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode14'']"/>
        </data>

        <data id="UB92.1.43_Description14">
          <xsl:value-of select="data[@id=''UB92.1.Description14'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode14">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode14'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate14">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate14'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate14''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate14''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate14''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount14''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount14">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount14'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount14">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount14'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 15 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID15'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode15">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode15'']"/>
        </data>

        <data id="UB92.1.43_Description15">
          <xsl:value-of select="data[@id=''UB92.1.Description15'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode15">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode15'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate15">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate15'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate15''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate15''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate15''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount15''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount15">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount15'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount15">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount15'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 16 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID16'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode16">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode16'']"/>
        </data>

        <data id="UB92.1.43_Description16">
          <xsl:value-of select="data[@id=''UB92.1.Description16'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode16">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode16'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate16">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate16'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate16''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate16''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate16''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount16''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount16">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount16'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount16">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount16'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 17 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID17'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode17">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode17'']"/>
        </data>

        <data id="UB92.1.43_Description17">
          <xsl:value-of select="data[@id=''UB92.1.Description17'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode17">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode17'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate17">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate17'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate17''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate17''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate17''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount17''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount17">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount17'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount17">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount17'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 18 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID18'']"/>
        </ClaimID>

        <data id="UB92.1.42_RevenueCode18">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode18'']"/>
        </data>

        <data id="UB92.1.43_Description18">
          <xsl:value-of select="data[@id=''UB92.1.Description18'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode18">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode18'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate18">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate18'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate18''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate18''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate18''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount18''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount18">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount18'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount18">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount18'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 19 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID19'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode19">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode19'']"/>
        </data>

        <data id="UB92.1.43_Description19">
          <xsl:value-of select="data[@id=''UB92.1.Description19'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode19">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode19'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate19">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate19'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate19''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate19''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate19''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount19''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount19">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount19'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount19">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount19'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 20 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID20'']"/>
        </ClaimID>
        
        <data id="UB92.1.42_RevenueCode20">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode20'']"/>
        </data>

        <data id="UB92.1.43_Description20">
          <xsl:value-of select="data[@id=''UB92.1.Description20'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode20">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode20'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate20">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate20'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate20''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate20''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate20''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount20''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount20">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount20'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount20">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount20'']"/>
          </data>
        </xsl:if>

        <!-- Procedure 21 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''UB92.1.ClaimID21'']"/>
        </ClaimID>

        <data id="UB92.1.42_RevenueCode21">
          <xsl:value-of select="data[@id=''UB92.1.RevenueCode21'']"/>
        </data>

        <data id="UB92.1.43_Description21">
          <xsl:value-of select="data[@id=''UB92.1.Description21'']"/>
        </data>

        <data id="UB92.1.44_ProcedureCode21">
          <xsl:value-of select="data[@id=''UB92.1.ProcedureCode21'']"/>
        </data>

        <data id="UB92.1.45_ServiceBeginDate21">
          <xsl:if test="string-length(data[@id=''UB92.1.ServiceBeginDate21'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate21''], 1, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate21''], 4, 2)"/>
            <xsl:value-of select="substring(data[@id=''UB92.1.ServiceBeginDate21''], 9, 2)"/>
          </xsl:if>
        </data>

        <xsl:if test="data[@id=''UB92.1.ServiceUnitCount21''] &gt; 0">
          <data id="UB92.1.46_ServiceUnitCount21">
            <xsl:value-of select="data[@id=''UB92.1.ServiceUnitCount21'']"/>
          </data>

          <data id="UB92.1.47_ChargeAmount21">
            <xsl:value-of select="data[@id=''UB92.1.ChargeAmount21'']"/>
          </data>
        </xsl:if>

      </page>
    </formData>
  </xsl:template>
</xsl:stylesheet>'
WHERE BillingFormID = 12