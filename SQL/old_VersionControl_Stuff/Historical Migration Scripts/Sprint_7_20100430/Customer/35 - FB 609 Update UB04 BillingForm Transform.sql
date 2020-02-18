---------------------------------------------------------------------------------------
-- temporary transforms
update BillingForm
set Transform=
'<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml"/>
  <xsl:decimal-format name="default-format" NaN="0.00"/>
  <xsl:template match="/formData/page">
    <formData formId="UB04">
      <page pageId="UB04.1">

				<data id="UB04.1.0_1_BillingProviderName">
					<xsl:value-of select="data[@id=''UB04.1.BillingProviderName1'']"/>
				</data>

				<data id="UB04.1.0_1_BillingProviderStreet">
					<xsl:value-of select="data[@id=''UB04.1.BillingProviderStreet1'']"/>
				</data>

				<data id="UB04.1.0_1_BillingProviderCityStateZip">
					<xsl:value-of select="data[@id=''UB04.1.BillingProviderCityStateZip1'']"/>
				</data>

				<data id="UB04.1.0_1_BillingProviderPhone">
					<xsl:value-of select="data[@id=''UB04.1.BillingProviderPhone1'']"/>
				</data>

				<data id="UB04.1.0_2_PayToName">
					<xsl:value-of select="data[@id=''UB04.1.PayToName1'']"/>
				</data>

				<data id="UB04.1.0_2_PayToStreet">
					<xsl:value-of select="data[@id=''UB04.1.PayToStreet1'']"/>
				</data>

				<data id="UB04.1.0_2_PayToCityStateZip">
					<xsl:value-of select="data[@id=''UB04.1.PayToCityStateZip1'']"/>
				</data>

				<data id="UB04.1.0_2_line4">
					<xsl:value-of select="data[@id=''UB04.1.0_2_line4'']"/>
				</data>

				<data id="UB04.1.0_3_a_PatientControlNumber">
					<xsl:value-of select="data[@id=''UB04.1.PatientControlNumber1'']"/>
				</data>

				<data id="UB04.1.0_3_b_PatientMedicalRecordNumber">
					<xsl:value-of select="data[@id=''UB04.1.PatientMedicalRecordNumber1'']"/>
				</data>

				<data id="UB04.1.0_4_TypeOfBill">
					<xsl:value-of select="data[@id=''UB04.1.TypeOfBill1'']"/>
				</data>

				<data id="UB04.1.0_5_sub_id">
					<xsl:value-of select="data[@id=''UB04.1.0_5_sub_id'']"/>
				</data>

				<data id="UB04.1.0_5_FederalTaxNumber">
					<xsl:value-of select="data[@id=''UB04.1.FederalTaxNumber1'']"/>
				</data>

				<data id="UB04.1.0_6_ServiceFromDate">
					<xsl:value-of select="data[@id=''UB04.1.ServiceFromDate1'']"/>
				</data>

				<data id="UB04.1.0_6_ServiceToDate">
					<xsl:value-of select="data[@id=''UB04.1.ServiceToDate1'']"/>
				</data>

				<data id="UB04.1.0_7_line1">
					<xsl:value-of select="data[@id=''UB04.1.0_7_line1'']"/>
				</data>

				<data id="UB04.1.0_7_line2">
					<xsl:value-of select="data[@id=''UB04.1.0_7_line2'']"/>
				</data>

				<data id="UB04.1.0_8_a_PatientID">
					<xsl:value-of select="data[@id=''UB04.1.PatientID1'']"/>
				</data>

				<data id="UB04.1.0_8_b_PatientName">
					<xsl:value-of select="data[@id=''UB04.1.PatientName1'']"/>
				</data>

				<data id="UB04.1.0_9_a_PatientStreetAddress">
					<xsl:value-of select="data[@id=''UB04.1.PatientStreetAddress1'']"/>
				</data>

				<data id="UB04.1.0_9_b_PatientCity">
					<xsl:value-of select="data[@id=''UB04.1.PatientCity1'']"/>
				</data>

				<data id="UB04.1.0_9_c_PatientState">
					<xsl:value-of select="data[@id=''UB04.1.PatientState1'']"/>
				</data>

				<data id="UB04.1.0_9_d_PatientZipCode">
					<xsl:value-of select="data[@id=''UB04.1.PatientZipCode1'']"/>
				</data>

				<data id="UB04.1.0_9_e_PatientCountry">
					<xsl:value-of select="data[@id=''UB04.1.PatientCountry1'']"/>
				</data>

				<data id="UB04.1.1_0_PatientBirthDate">
					<xsl:value-of select="data[@id=''UB04.1.PatientBirthDate1'']"/>
				</data>

				<data id="UB04.1.1_1_PatientGender">
					<xsl:value-of select="data[@id=''UB04.1.PatientGender1'']"/>
				</data>

				<data id="UB04.1.1_2_AdmissionDate">
					<xsl:value-of select="data[@id=''UB04.1.AdmissionDate1'']"/>
				</data>

				<data id="UB04.1.1_3_AdmissionHour">
					<xsl:value-of select="data[@id=''UB04.1.AdmissionHour1'']"/>
				</data>

				<data id="UB04.1.1_4_AdmissionType">
					<xsl:value-of select="data[@id=''UB04.1.AdmissionType1'']"/>
				</data>

				<data id="UB04.1.1_5_PointOfOrigin">
					<xsl:value-of select="data[@id=''UB04.1.PointOfOrigin1'']"/>
				</data>

				<data id="UB04.1.1_6_DischargeHour">
					<xsl:value-of select="data[@id=''UB04.1.DischargeHour1'']"/>
				</data>

				<data id="UB04.1.1_7_PatientDischargeStatus">
					<xsl:value-of select="data[@id=''UB04.1.PatientDischargeStatus1'']"/>
				</data>

				<data id="UB04.1.1_8_ConditionCode1">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode1'']"/>
				</data>

				<data id="UB04.1.1_9_ConditionCode2">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode2'']"/>
				</data>

				<data id="UB04.1.2_0_ConditionCode3">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode3'']"/>
				</data>

				<data id="UB04.1.2_1_ConditionCode4">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode4'']"/>
				</data>

				<data id="UB04.1.2_2_ConditionCode5">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode5'']"/>
				</data>

				<data id="UB04.1.2_3_ConditionCode6">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode6'']"/>
				</data>

				<data id="UB04.1.2_4_ConditionCode7">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode7'']"/>
				</data>

				<data id="UB04.1.2_5_ConditionCode8">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode8'']"/>
				</data>

				<data id="UB04.1.2_6_ConditionCode9">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode9'']"/>
				</data>

				<data id="UB04.1.2_7_ConditionCode10">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode10'']"/>
				</data>

				<data id="UB04.1.2_8_CondtionCode11">
					<xsl:value-of select="data[@id=''UB04.1.ConditionCode11'']"/>
				</data>

				<data id="UB04.1.2_9_AccidentState">
					<xsl:value-of select="data[@id=''UB04.1.AccidentState1'']"/>
				</data>

				<data id="UB04.1.3_0_line1">
					<xsl:value-of select="data[@id=''UB04.1.3_0_line1'']"/>
				</data>

				<data id="UB04.1.3_0_line2">
					<xsl:value-of select="data[@id=''UB04.1.3_0_line2'']"/>
				</data>

				<data id="UB04.1.3_1_OccurenceCode1">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCode1'']"/>
				</data>

				<data id="UB04.1.3_1_OccurenceCodeDate1">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCodeDate1'']"/>
				</data>

				<data id="UB04.1.3_2_OccurenceCode2">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCode2'']"/>
				</data>

				<data id="UB04.1.3_2_OccurenceCodeDate2">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCodeDate2'']"/>
				</data>

				<data id="UB04.1.3_3_OccurenceCode3">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCode3'']"/>
				</data>

				<data id="UB04.1.3_3_OccurenceCodeDate3">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCodeDate3'']"/>
				</data>

				<data id="UB04.1.3_4_OccurenceCode4">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCode4'']"/>
				</data>

				<data id="UB04.1.3_4_OccurenceCodeDate4">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCodeDate4'']"/>
				</data>

				<data id="UB04.1.3_5_OccurenceSpanCode1">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCode1'']"/>
				</data>

				<data id="UB04.1.3_5_OccurenceSpanCodeDateFrom1">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCodeDateFrom1'']"/>
				</data>

				<data id="UB04.1.3_5_OccurenceSpanCodeDateTo1">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCodeDateTo1'']"/>
				</data>

				<data id="UB04.1.3_6_OccurenceSpanCode2">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCode2'']"/>
				</data>

				<data id="UB04.1.3_6_OccurenceSpanCodeDateFrom2">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCodeDateFrom2'']"/>
				</data>

				<data id="UB04.1.3_6_OccurenceSpanCodeDateTo2">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCodeDateTo2'']"/>
				</data>

				<data id="UB04.1.3_7_a">
					<xsl:value-of select="data[@id=''UB04.1.3_7_a'']"/>
				</data>

				<data id="UB04.1.3_1_OccurenceCode5">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCode5'']"/>
				</data>

				<data id="UB04.1.3_1_OccurenceCodeDate5">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCodeDate5'']"/>
				</data>

				<data id="UB04.1.3_2_OccurenceCode6">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCode6'']"/>
				</data>

				<data id="UB04.1.3_2_OccurenceCodeDate6">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCodeDate6'']"/>
				</data>

				<data id="UB04.1.3_3_OccurenceCode7">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCode7'']"/>
				</data>

				<data id="UB04.1.3_3_OccurenceCodeDate7">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCodeDate7'']"/>
				</data>

				<data id="UB04.1.3_4_OccurenceCode8">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCode8'']"/>
				</data>

				<data id="UB04.1.3_4_OccurenceCodeDate8">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceCodeDate8'']"/>
				</data>

				<data id="UB04.1.3_5_OccurenceSpanCode3">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCode3'']"/>
				</data>

				<data id="UB04.1.3_5_OccurenceSpanCodeDateFrom3">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCodeDateFrom3'']"/>
				</data>

				<data id="UB04.1.3_5_OccurenceSpanCodeDateTo3">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCodeDateTo3'']"/>
				</data>

				<data id="UB04.1.3_6_OccurenceSpanCode4">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCode4'']"/>
				</data>

				<data id="UB04.1.3_6_OccurenceSpanCodeDateFrom4">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCodeDateFrom4'']"/>
				</data>

				<data id="UB04.1.3_6_OccurenceSpanCodeDateTo4">
					<xsl:value-of select="data[@id=''UB04.1.OccurenceSpanCodeDateTo4'']"/>
				</data>

				<data id="UB04.1.3_7_b">
					<xsl:value-of select="data[@id=''UB04.1.3_7_b'']"/>
				</data>

				<data id="UB04.1.3_8_InsuranceCompanyName">
					<xsl:value-of select="data[@id=''UB04.1.InsuranceCompanyName1'']"/>
				</data>

				<data id="UB04.1.3_8_InsuranceCompanyAddress">
					<xsl:value-of select="data[@id=''UB04.1.InsuranceCompanyAddress1'']"/>
				</data>

				<data id="UB04.1.3_8_InsuranceCompanyCityStateZip">
					<xsl:value-of select="data[@id=''UB04.1.InsuranceCompanyCityStateZip1'']"/>
				</data>

				<data id="UB04.1.3_8_line4">
					<xsl:value-of select="data[@id=''UB04.1.3_8_line4'']"/>
				</data>

				<data id="UB04.1.3_8_line5">
					<xsl:value-of select="data[@id=''UB04.1.3_8_line5'']"/>
				</data>

				<data id="UB04.1.3_9_ValueCode1">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode1'']"/>
				</data>

				<data id="UB04.1.3_9_ValueCodeDollars1">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount1''], ''.'')"/>
				</data>

				<data id="UB04.1.3_9_ValueCodeCents1">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount1''], ''.'')"/>
				</data>

				<data id="UB04.1.3_9_ValueCode4">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode4'']"/>
				</data>

				<data id="UB04.1.3_9_ValueCodeDollars4">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount4''], ''.'')"/>
				</data>

				<data id="UB04.1.3_9_ValueCodeCents4">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount4''], ''.'')"/>
				</data>

				<data id="UB04.1.3_9_ValueCode7">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode7'']"/>
				</data>

				<data id="UB04.1.3_9_ValueCodeDollars7">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount7''], ''.'')"/>
				</data>

				<data id="UB04.1.3_9_ValueCodeCents7">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount7''], ''.'')"/>
				</data>

				<data id="UB04.1.3_9_ValueCode10">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode10'']"/>
				</data>

				<data id="UB04.1.3_9_ValueCodeDollars10">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount10''], ''.'')"/>
				</data>

				<data id="UB04.1.3_9_ValueCodeCents10">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount10''], ''.'')"/>
				</data>

				<data id="UB04.1.4_0_ValueCode2">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode2'']"/>
				</data>

				<data id="UB04.1.4_0_ValueCodeDollars2">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount2''], ''.'')"/>
				</data>

				<data id="UB04.1.4_0_ValueCodeCents2">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount2''], ''.'')"/>
				</data>

				<data id="UB04.1.4_0_ValueCode5">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode5'']"/>
				</data>

				<data id="UB04.1.4_0_ValueCodeDollars5">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount5''], ''.'')"/>
				</data>

				<data id="UB04.1.4_0_ValueCodeCents5">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount5''], ''.'')"/>
				</data>

				<data id="UB04.1.4_0_ValueCode8">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode8'']"/>
				</data>

				<data id="UB04.1.4_0_ValueCodeDollars8">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount8''], ''.'')"/>
				</data>

				<data id="UB04.1.4_0_ValueCodeCents8">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount8''], ''.'')"/>
				</data>

				<data id="UB04.1.4_0_ValueCode11">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode11'']"/>
				</data>

				<data id="UB04.1.4_0_ValueCodeDollars11">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount11''], ''.'')"/>
				</data>

				<data id="UB04.1.4_0_ValueCodeCents11">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount11''], ''.'')"/>
				</data>

				<data id="UB04.1.4_1_ValueCode3">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode3'']"/>
				</data>

				<data id="UB04.1.4_1_ValueCodeDollars3">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount3''], ''.'')"/>
				</data>

				<data id="UB04.1.4_1_ValueCodeCents3">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount3''], ''.'')"/>
				</data>

				<data id="UB04.1.4_1_ValueCode6">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode6'']"/>
				</data>

				<data id="UB04.1.4_1_ValueCodeDollars6">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount6''], ''.'')"/>
				</data>

				<data id="UB04.1.4_1_ValueCodeCents6">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount6''], ''.'')"/>
				</data>

				<data id="UB04.1.4_1_ValueCode9">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode9'']"/>
				</data>

				<data id="UB04.1.4_1_ValueCodeDollars9">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount9''], ''.'')"/>
				</data>

				<data id="UB04.1.4_1_ValueCodeCents9">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount9''], ''.'')"/>
				</data>

				<data id="UB04.1.4_1_ValueCode12">
					<xsl:value-of select="data[@id=''UB04.1.ValueCode12'']"/>
				</data>

				<data id="UB04.1.4_1_ValueCodeDollars12">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ValueCodeAmount12''], ''.'')"/>
				</data>

				<data id="UB04.1.4_1_ValueCodeCents12">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ValueCodeAmount12''], ''.'')"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode1">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode1'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode1">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode1'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName1">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName1'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate1">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate1'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits1">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits1'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars1">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges1''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents1">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges1''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars1">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge1''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents1">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge1''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_1">
					<xsl:value-of select="data[@id=''UB04.1.4_9_1'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode2">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode2'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode2">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode2'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName2">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName2'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate2">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate2'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits2">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits2'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars2">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges2''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents2">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges2''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars2">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge2''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents2">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge2''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_2">
					<xsl:value-of select="data[@id=''UB04.1.4_9_2'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode3">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode3'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode3">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode3'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName3">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName3'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate3">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate3'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits3">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits3'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars3">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges3''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents3">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges3''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars3">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge3''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents3">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge3''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_3">
					<xsl:value-of select="data[@id=''UB04.1.4_9_3'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode4">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode4'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode4">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode4'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName4">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName4'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate4">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate4'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits4">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits4'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars4">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges4''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents4">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges4''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars4">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge4''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents4">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge4''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_4">
					<xsl:value-of select="data[@id=''UB04.1.4_9_4'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode5">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode5'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode5">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode5'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName5">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName5'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate5">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate5'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits5">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits5'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars5">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges5''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents5">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges5''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars5">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge5''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents5">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge5''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_5">
					<xsl:value-of select="data[@id=''UB04.1.4_9_5'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode6">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode6'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode6">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode6'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName6">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName6'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate6">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate6'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits6">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits6'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars6">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges6''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents6">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges6''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars6">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge6''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents6">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge6''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_6">
					<xsl:value-of select="data[@id=''UB04.1.4_9_6'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode7">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode7'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode7">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode7'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName7">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName7'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate7">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate7'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits7">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits7'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars7">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges7''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents7">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges7''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars7">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge7''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents7">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge7''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_7">
					<xsl:value-of select="data[@id=''UB04.1.4_9_7'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode8">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode8'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode8">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode8'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName8">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName8'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate8">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate8'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits8">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits8'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars8">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges8''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents8">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges8''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars8">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge8''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents8">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge8''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_8">
					<xsl:value-of select="data[@id=''UB04.1.4_9_8'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode9">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode9'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode9">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode9'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName9">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName9'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate9">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate9'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits9">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits9'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars9">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges9''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents9">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges9''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars9">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge9''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents9">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge9''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_9">
					<xsl:value-of select="data[@id=''UB04.1.4_9_9'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode10">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode10'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode10">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode10'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName10">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName10'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate10">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate10'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits10">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits10'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars10">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges10''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents10">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges10''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars10">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge10''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents10">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge10''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_10">
					<xsl:value-of select="data[@id=''UB04.1.4_9_10'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode11">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode11'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode11">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode11'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName11">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName11'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate11">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate11'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits11">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits11'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars11">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges11''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents11">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges11''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars11">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge11''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents11">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge11''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_11">
					<xsl:value-of select="data[@id=''UB04.1.4_9_11'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode12">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode12'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode12">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode12'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName12">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName12'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate12">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate12'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits12">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits12'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars12">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges12''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents12">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges12''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars12">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge12''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents12">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge12''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_12">
					<xsl:value-of select="data[@id=''UB04.1.4_9_12'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode13">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode13'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode13">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode13'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName13">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName13'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate13">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate13'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits13">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits13'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars13">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges13''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents13">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges13''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars13">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge13''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents13">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge13''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_13">
					<xsl:value-of select="data[@id=''UB04.1.4_9_13'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode14">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode14'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode14">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode14'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName14">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName14'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate14">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate14'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits14">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits14'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars14">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges14''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents14">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges14''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars14">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge14''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents14">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge14''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_14">
					<xsl:value-of select="data[@id=''UB04.1.4_9_14'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode15">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode15'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode15">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode15'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName15">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName15'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate15">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate15'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits15">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits15'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars15">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges15''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents15">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges15''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars15">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge15''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents15">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge15''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_15">
					<xsl:value-of select="data[@id=''UB04.1.4_9_15'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode16">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode16'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode16">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode16'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName16">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName16'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate16">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate16'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits16">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits16'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars16">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges16''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents16">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges16''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars16">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge16''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents16">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge16''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_16">
					<xsl:value-of select="data[@id=''UB04.1.4_9_16'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode17">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode17'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode17">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode17'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName17">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName17'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate17">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate17'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits17">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits17'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars17">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges17''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents17">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges17''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars17">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge17''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents17">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge17''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_17">
					<xsl:value-of select="data[@id=''UB04.1.4_9_17'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode18">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode18'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode18">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode18'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName18">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName18'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate18">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate18'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits18">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits18'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars18">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges18''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents18">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges18''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars18">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge18''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents18">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge18''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_18">
					<xsl:value-of select="data[@id=''UB04.1.4_9_18'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode19">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode19'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode19">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode19'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName19">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName19'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate19">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate19'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits19">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits19'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars19">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges19''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents19">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges19''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars19">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge19''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents19">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge19''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_19">
					<xsl:value-of select="data[@id=''UB04.1.4_9_19'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode20">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode20'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode20">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode20'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName20">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName20'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate20">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate20'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits20">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits20'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars20">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges20''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents20">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges20''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars20">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge20''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents20">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge20''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_20">
					<xsl:value-of select="data[@id=''UB04.1.4_9_20'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode21">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode21'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode21">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode21'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName21">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName21'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate21">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate21'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits21">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits21'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars21">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges21''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents21">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges21''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars21">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge21''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents21">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge21''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_21">
					<xsl:value-of select="data[@id=''UB04.1.4_9_21'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode22">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode22'']"/>
				</data>

				<data id="UB04.1.4_3_ProcedureCode22">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureCode22'']"/>
				</data>

				<data id="UB04.1.4_4_ProcedureName22">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureName22'']"/>
				</data>

				<data id="UB04.1.4_5_ProcedureServiceDate22">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureServiceDate22'']"/>
				</data>

				<data id="UB04.1.4_6_ProcedureUnits22">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureUnits22'']"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesDollars22">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureTotalCharges22''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_ProcedureTotalChargesCents22">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureTotalCharges22''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeDollars22">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.ProcedureNonCoveredCharge22''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_ProcedureNonCoveredChargeCents22">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.ProcedureNonCoveredCharge22''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_22">
					<xsl:value-of select="data[@id=''UB04.1.4_9_22'']"/>
				</data>

				<data id="UB04.1.4_2_ProcedureRevenueCode23">
					<xsl:value-of select="data[@id=''UB04.1.ProcedureRevenueCode23'']"/>
				</data>

				<data id="UB04.1.4_3_CurrentPage23">
					<xsl:value-of select="data[@id=''UB04.1.CurrentPage1'']"/>
				</data>

				<data id="UB04.1.4_3_TotalPages23">
					<xsl:value-of select="data[@id=''UB04.1.TotalPages1'']"/>
				</data>

				<data id="UB04.1.4_5_CreationDate23">
					<xsl:value-of select="data[@id=''UB04.1.CreationDate1'']"/>
				</data>

				<data id="UB04.1.4_7_TotalChargesDollars23">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.TotalCharges1''], ''.'')"/>
				</data>

				<data id="UB04.1.4_7_TotalChargesCents23">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.TotalCharges1''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_TotalNonCoveredChargesDollars23">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.TotalNonCoveredCharges1''], ''.'')"/>
				</data>

				<data id="UB04.1.4_8_TotalNonCoveredChargesCents23">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.TotalNonCoveredCharges1''], ''.'')"/>
				</data>

				<data id="UB04.1.4_9_23">
					<xsl:value-of select="data[@id=''UB04.1.4_9_23'']"/>
				</data>

				<data id="UB04.1.5_0_PayerNamePrimary">
					<xsl:value-of select="data[@id=''UB04.1.PayerNamePrimary1'']"/>
				</data>

				<data id="UB04.1.5_1_HealthPlanIdNumberPrimary">
					<xsl:value-of select="data[@id=''UB04.1.HealthPlanIdNumberPrimary1'']"/>
				</data>

				<data id="UB04.1.5_2_ReleaseOfICIPrimary">
					<xsl:value-of select="data[@id=''UB04.1.ReleaseOfICIPrimary1'']"/>
				</data>

				<data id="UB04.1.5_3_AssignmentOfBenefitsPrimary">
					<xsl:value-of select="data[@id=''UB04.1.AssignmentOfBenefitsPrimary1'']"/>
				</data>

				<data id="UB04.1.5_4_PriorPaymentsPrimaryDollars">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.PriorPaymentsPrimary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_4_PriorPaymentsPrimaryCents">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.PriorPaymentsPrimary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_5_EstimatedAmountPrimaryDollars">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.EstimatedAmountPrimary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_5_EstimatedAmountPrimaryCents">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.EstimatedAmountPrimary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_7_OtherProviderIdentifierPrimary">
					<xsl:value-of select="data[@id=''UB04.1.OtherProviderIdentifierPrimary1'']"/>
				</data>

				<data id="UB04.1.5_0_PayerNameSecondary">
					<xsl:value-of select="data[@id=''UB04.1.PayerNameSecondary1'']"/>
				</data>

				<data id="UB04.1.5_1_HealthPlanIdNumberSecondary">
					<xsl:value-of select="data[@id=''UB04.1.HealthPlanIdNumberSecondary1'']"/>
				</data>

				<data id="UB04.1.5_2_ReleaseOfICISecondary">
					<xsl:value-of select="data[@id=''UB04.1.ReleaseOfICISecondary1'']"/>
				</data>

				<data id="UB04.1.5_3_AssignmentOfBenefitsSecondary">
					<xsl:value-of select="data[@id=''UB04.1.AssignmentOfBenefitsSecondary1'']"/>
				</data>

				<data id="UB04.1.5_4_PriorPaymentsSecondaryDollars">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.PriorPaymentsSecondary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_4_PriorPaymentsSecondaryCents">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.PriorPaymentsSecondary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_5_EstimatedAmountSecondaryDollars">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.EstimatedAmountSecondary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_5_EstimatedAmountSecondaryCents">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.EstimatedAmountSecondary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_7_OtherProviderIdentifierSecondary">
					<xsl:value-of select="data[@id=''UB04.1.OtherProviderIdentifierSecondary1'']"/>
				</data>

				<data id="UB04.1.5_0_PayerNameTertiary">
					<xsl:value-of select="data[@id=''UB04.1.PayerNameTertiary1'']"/>
				</data>

				<data id="UB04.1.5_1_HealthPlanIdNumberTertiary">
					<xsl:value-of select="data[@id=''UB04.1.HealthPlanIdNumberTertiary1'']"/>
				</data>

				<data id="UB04.1.5_2_ReleaseOfICITertiary">
					<xsl:value-of select="data[@id=''UB04.1.ReleaseOfICITertiary1'']"/>
				</data>

				<data id="UB04.1.5_3_AssignmentOfBenefitsTertiary">
					<xsl:value-of select="data[@id=''UB04.1.AssignmentOfBenefitsTertiary1'']"/>
				</data>

				<data id="UB04.1.5_4_PriorPaymentsTertiaryDollars">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.PriorPaymentsTertiary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_4_PriorPaymentsTertiaryCents">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.PriorPaymentsTertiary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_5_EstimatedAmountTertiaryDollars">
					<xsl:value-of select="substring-before(data[@id=''UB04.1.EstimatedAmountTertiary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_5_EstimatedAmountTertiaryCents">
					<xsl:value-of select="substring-after(data[@id=''UB04.1.EstimatedAmountTertiary1''], ''.'')"/>
				</data>

				<data id="UB04.1.5_7_OtherProviderIdentifierTertiary">
					<xsl:value-of select="data[@id=''UB04.1.OtherProviderIdentifierTertiary1'']"/>
				</data>

				<data id="UB04.1.5_6_BillingProviderNPI">
					<xsl:value-of select="data[@id=''UB04.1.BillingProviderNPI1'']"/>
				</data>

				<data id="UB04.1.5_8_InsuredNamePrimary">
					<xsl:value-of select="data[@id=''UB04.1.InsuredNamePrimary1'']"/>
				</data>

				<data id="UB04.1.5_9_PatientRelationshipToInsuredPrimary">
					<xsl:value-of select="data[@id=''UB04.1.PatientRelationshipToInsuredPrimary1'']"/>
				</data>

				<data id="UB04.1.6_0_InsurancePolicyNumberPrimary">
					<xsl:value-of select="data[@id=''UB04.1.InsurancePolicyNumberPrimary1'']"/>
				</data>

				<data id="UB04.1.6_1_InsurancePolicyGroupNamePrimary">
					<xsl:value-of select="data[@id=''UB04.1.InsurancePolicyGroupNamePrimary1'']"/>
				</data>

				<data id="UB04.1.6_2_InsurancePolicyGroupNumberPrimary">
					<xsl:value-of select="data[@id=''UB04.1.InsurancePolicyGroupNumberPrimary1'']"/>
				</data>

				<data id="UB04.1.5_8_InsuredNameSecondary">
					<xsl:value-of select="data[@id=''UB04.1.InsuredNameSecondary1'']"/>
				</data>

				<data id="UB04.1.5_9_PatientRelationshipToInsuredSecondary">
					<xsl:value-of select="data[@id=''UB04.1.PatientRelationshipToInsuredSecondary1'']"/>
				</data>

				<data id="UB04.1.6_0_InsurancePolicyNumberSecondary">
					<xsl:value-of select="data[@id=''UB04.1.InsurancePolicyNumberSecondary1'']"/>
				</data>

				<data id="UB04.1.6_1_InsurancePolicyGroupNameSecondary">
					<xsl:value-of select="data[@id=''UB04.1.InsurancePolicyGroupNameSecondary1'']"/>
				</data>

				<data id="UB04.1.6_2_InsurancePolicyGroupNumberSecondary">
					<xsl:value-of select="data[@id=''UB04.1.InsurancePolicyGroupNumberSecondary1'']"/>
				</data>

				<data id="UB04.1.5_8_InsuredNameTertiary">
					<xsl:value-of select="data[@id=''UB04.1.5_8_InsuredNameTertiary1'']"/>
				</data>

				<data id="UB04.1.5_9_PatientRelationshipToInsuredTertiary">
					<xsl:value-of select="data[@id=''UB04.1.PatientRelationshipToInsuredTertiary1'']"/>
				</data>

				<data id="UB04.1.6_0_InsurancePolicyNumberTertiary">
					<xsl:value-of select="data[@id=''UB04.1.InsurancePolicyNumberTertiary1'']"/>
				</data>

				<data id="UB04.1.6_1_InsurancePolicyGroupNameTertiary">
					<xsl:value-of select="data[@id=''UB04.1.InsurancePolicyGroupNameTertiary1'']"/>
				</data>

				<data id="UB04.1.6_2_InsurancePolicyGroupNumberTertiary">
					<xsl:value-of select="data[@id=''UB04.1.InsurancePolicyGroupNumberTertiary1'']"/>
				</data>

				<data id="UB04.1.6_3_TreatmentAuthCodePrimary">
					<xsl:value-of select="data[@id=''UB04.1.TreatmentAuthCodePrimary1'']"/>
				</data>

				<data id="UB04.1.6_4_DocumentControlNumberPrimary">
					<xsl:value-of select="data[@id=''UB04.1.DocumentControlNumberPrimary1'']"/>
				</data>

				<data id="UB04.1.6_5_EmployerNamePrimary">
					<xsl:value-of select="data[@id=''UB04.1.EmployerNamePrimary1'']"/>
				</data>

				<data id="UB04.1.6_3_TreatmentAuthCodeSecondary">
					<xsl:value-of select="data[@id=''UB04.1.TreatmentAuthCodeSecondary1'']"/>
				</data>

				<data id="UB04.1.6_4_DocumentControlNumberSecondary">
					<xsl:value-of select="data[@id=''UB04.1.DocumentControlNumberSecondary1'']"/>
				</data>

				<data id="UB04.1.6_5_EmployerNameSecondary">
					<xsl:value-of select="data[@id=''UB04.1.EmployerNameSecondary1'']"/>
				</data>

				<data id="UB04.1.6_3_TreatmentAuthCodeTertiary">
					<xsl:value-of select="data[@id=''UB04.1.TreatmentAuthCodeTertiary1'']"/>
				</data>

				<data id="UB04.1.6_4_DocumentControlNumberTertiary">
					<xsl:value-of select="data[@id=''UB04.1.DocumentControlNumberTertiary1'']"/>
				</data>

				<data id="UB04.1.6_5_EmployerNameTertiary">
					<xsl:value-of select="data[@id=''UB04.1.EmployerNameTertiary1'']"/>
				</data>

				<data id="UB04.1.6_6_DiagnosisProcedureCodeQualifier">
					<xsl:value-of select="data[@id=''UB04.1.DiagnosisProcedureCodeQualifier1'']"/>
				</data>

				<data id="UB04.1.6_7_PrincipalDiagnosisCode">
					<xsl:value-of select="data[@id=''UB04.1.PrincipalDiagnosisCode1'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode1">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode1'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode2">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode2'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode3">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode3'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode4">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode4'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode5">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode5'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode6">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode6'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode7">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode7'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode8">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode8'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode9">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode9'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode10">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode10'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode11">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode11'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode12">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode12'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode13">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode13'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode14">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode14'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode15">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode15'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode16">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode16'']"/>
				</data>

				<data id="UB04.1.6_7_OtherDiagnosisCode17">
					<xsl:value-of select="data[@id=''UB04.1.OtherDiagnosisCode17'']"/>
				</data>

				<data id="UB04.1.6_8_line1">
					<xsl:value-of select="data[@id=''UB04.1.6_8_line1'']"/>
				</data>

				<data id="UB04.1.6_8_line2">
					<xsl:value-of select="data[@id=''UB04.1.6_8_line2'']"/>
				</data>

				<data id="UB04.1.6_9_AdmittingDiagnosisCode">
					<xsl:value-of select="data[@id=''UB04.1.AdmittingDiagnosisCode1'']"/>
				</data>

				<data id="UB04.1.7_0_PatientReasonDx1">
					<xsl:value-of select="data[@id=''UB04.1.PatientReasonDx11'']"/>
				</data>

				<data id="UB04.1.7_0_PatientReasonDx2">
					<xsl:value-of select="data[@id=''UB04.1.PatientReasonDx21'']"/>
				</data>

				<data id="UB04.1.7_0_PatientReasonDx3">
					<xsl:value-of select="data[@id=''UB04.1.PatientReasonDx31'']"/>
				</data>

				<data id="UB04.1.7_1_DRGCode">
					<xsl:value-of select="data[@id=''UB04.1.DRGCode1'']"/>
				</data>

				<data id="UB04.1.7_2_eci_a">
					<xsl:value-of select="data[@id=''UB04.1.7_2_eci_a'']"/>
				</data>

				<data id="UB04.1.7_2_eci_b">
					<xsl:value-of select="data[@id=''UB04.1.7_2_eci_b'']"/>
				</data>

				<data id="UB04.1.7_2_eci_c">
					<xsl:value-of select="data[@id=''UB04.1.7_2_eci_c'']"/>
				</data>

				<data id="UB04.1.7_3">
					<xsl:value-of select="data[@id=''UB04.1.7_3'']"/>
				</data>

				<data id="UB04.1.7_4_PrincipalProcedureCode">
					<xsl:value-of select="data[@id=''UB04.1.PrincipalProcedureCode1'']"/>
				</data>

				<data id="UB04.1.7_4_PrincipalProcedureDate">
					<xsl:value-of select="data[@id=''UB04.1.PrincipalProcedureDate1'']"/>
				</data>

				<data id="UB04.1.7_4_OtherProcedureCode1">
					<xsl:value-of select="data[@id=''UB04.1.OtherProcedureCode11'']"/>
				</data>

				<data id="UB04.1.7_4_OtherProcedureDate1">
					<xsl:value-of select="data[@id=''UB04.1.OtherProcedureDate11'']"/>
				</data>

				<data id="UB04.1.7_4_OtherProcedureCode2">
					<xsl:value-of select="data[@id=''UB04.1.OtherProcedureCode21'']"/>
				</data>

				<data id="UB04.1.7_4_OtherProcedureDate2">
					<xsl:value-of select="data[@id=''UB04.1.OtherProcedureDate21'']"/>
				</data>

				<data id="UB04.1.7_4_OtherProcedureCode3">
					<xsl:value-of select="data[@id=''UB04.1.OtherProcedureCode31'']"/>
				</data>

				<data id="UB04.1.7_4_OtherProcedureDate3">
					<xsl:value-of select="data[@id=''UB04.1.OtherProcedureDate31'']"/>
				</data>

				<data id="UB04.1.7_4_OtherProcedureCode4">
					<xsl:value-of select="data[@id=''UB04.1.OtherProcedureCode41'']"/>
				</data>

				<data id="UB04.1.7_4_OtherProcedureDate4">
					<xsl:value-of select="data[@id=''UB04.1.OtherProcedureDate41'']"/>
				</data>

				<data id="UB04.1.7_4_OtherProcedureCode5">
					<xsl:value-of select="data[@id=''UB04.1.OtherProcedureCode51'']"/>
				</data>

				<data id="UB04.1.7_4_OtherProcedureDate5">
					<xsl:value-of select="data[@id=''UB04.1.OtherProcedureDate51'']"/>
				</data>

				<data id="UB04.1.7_5_line1">
					<xsl:value-of select="data[@id=''UB04.1.7_5_line1'']"/>
				</data>

				<data id="UB04.1.7_5_line2">
					<xsl:value-of select="data[@id=''UB04.1.7_5_line2'']"/>
				</data>

				<data id="UB04.1.7_5_line3">
					<xsl:value-of select="data[@id=''UB04.1.7_5_line3'']"/>
				</data>

				<data id="UB04.1.7_5_line4">
					<xsl:value-of select="data[@id=''UB04.1.7_5_line4'']"/>
				</data>

				<data id="UB04.1.7_6_AttendingProviderNPI">
					<xsl:value-of select="data[@id=''UB04.1.AttendingProviderNPI1'']"/>
				</data>

				<data id="UB04.1.7_6_AttendingProviderQualifier">
					<xsl:value-of select="data[@id=''UB04.1.AttendingProviderQualifier1'']"/>
				</data>

				<data id="UB04.1.7_6_AttendingProviderNumber">
					<xsl:value-of select="data[@id=''UB04.1.AttendingProviderNumber1'']"/>
				</data>

				<data id="UB04.1.7_6_AttendingProviderLastName">
					<xsl:value-of select="data[@id=''UB04.1.AttendingProviderLastName1'']"/>
				</data>

				<data id="UB04.1.7_6_AttendingProviderFistName">
					<xsl:value-of select="data[@id=''UB04.1.AttendingProviderFistName1'']"/>
				</data>

				<data id="UB04.1.7_7_OperatingProviderNPI">
					<xsl:value-of select="data[@id=''UB04.1.OperatingProviderNPI1'']"/>
				</data>

				<data id="UB04.1.7_7_OperatingProviderQualifier">
					<xsl:value-of select="data[@id=''UB04.1.OperatingProviderQualifier1'']"/>
				</data>

				<data id="UB04.1.7_7_OperatingProviderNumber">
					<xsl:value-of select="data[@id=''UB04.1.OperatingProviderNumber1'']"/>
				</data>

				<data id="UB04.1.7_7_OperatingProviderLastName">
					<xsl:value-of select="data[@id=''UB04.1.OperatingProviderLastName1'']"/>
				</data>

				<data id="UB04.1.7_7_OperatingProviderFistName">
					<xsl:value-of select="data[@id=''UB04.1.OperatingProviderFistName1'']"/>
				</data>

				<data id="UB04.1.7_8_Other1ProviderTypeQualifier">
					<xsl:value-of select="data[@id=''UB04.1.Other1ProviderTypeQualifier1'']"/>
				</data>

				<data id="UB04.1.7_8_Other1ProviderNPI">
					<xsl:value-of select="data[@id=''UB04.1.Other1ProviderNPI1'']"/>
				</data>

				<data id="UB04.1.7_8_Other1ProviderQualifier">
					<xsl:value-of select="data[@id=''UB04.1.Other1ProviderQualifier1'']"/>
				</data>

				<data id="UB04.1.7_8_Other1ProviderQualifier">
					<xsl:value-of select="data[@id=''UB04.1.Other1ProviderNumber1'']"/>
				</data>

				<data id="UB04.1.7_8_Other1ProviderLastName">
					<xsl:value-of select="data[@id=''UB04.1.Other1ProviderLastName1'']"/>
				</data>

				<data id="UB04.1.7_8_Other1ProviderFistName">
					<xsl:value-of select="data[@id=''UB04.1.Other1ProviderFistName1'']"/>
				</data>

				<data id="UB04.1.7_9_Other2ProviderTypeQualifier">
					<xsl:value-of select="data[@id=''UB04.1.Other2ProviderTypeQualifier1'']"/>
				</data>

				<data id="UB04.1.7_9_Other2ProviderNPI">
					<xsl:value-of select="data[@id=''UB04.1.Other2ProviderNPI1'']"/>
				</data>

				<data id="UB04.1.7_9_Other2ProviderQualifier">
					<xsl:value-of select="data[@id=''UB04.1.Other2ProviderQualifier1'']"/>
				</data>

				<data id="UB04.1.7_9_Other2ProviderNumber">
					<xsl:value-of select="data[@id=''UB04.1.Other2ProviderNumber1'']"/>
				</data>

				<data id="UB04.1.7_9_Other2ProviderLastName">
					<xsl:value-of select="data[@id=''UB04.1.Other2ProviderLastName1'']"/>
				</data>

				<data id="UB04.1.7_9_Other2ProviderFistName">
					<xsl:value-of select="data[@id=''UB04.1.Other2ProviderFistName'']"/>
				</data>

				<data id="UB04.1.8_0_Remarks1">
					<xsl:value-of select="data[@id=''UB04.1.Remarks11'']"/>
				</data>

				<data id="UB04.1.8_0_Remarks2">
					<xsl:value-of select="data[@id=''UB04.1.Remarks21'']"/>
				</data>

				<data id="UB04.1.8_0_Remarks3">
					<xsl:value-of select="data[@id=''UB04.1.Remarks31'']"/>
				</data>

				<data id="UB04.1.8_0_Remarks4">
					<xsl:value-of select="data[@id=''UB04.1.Remarks41'']"/>
				</data>

				<data id="UB04.1.8_1_cc_left_a">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_left_a'']"/>
				</data>

				<data id="UB04.1.8_1_cc_middle_a">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_middle_a'']"/>
				</data>

				<data id="UB04.1.8_1_cc_right_a">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_right_a'']"/>
				</data>

				<data id="UB04.1.8_1_cc_left_b">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_left_b'']"/>
				</data>

				<data id="UB04.1.8_1_cc_middle_b">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_middle_b'']"/>
				</data>

				<data id="UB04.1.8_1_cc_right_b">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_right_b'']"/>
				</data>

				<data id="UB04.1.8_1_cc_left_c">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_left_c'']"/>
				</data>

				<data id="UB04.1.8_1_cc_middle_c">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_middle_c'']"/>
				</data>

				<data id="UB04.1.8_1_cc_right_c">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_right_c'']"/>
				</data>

				<data id="UB04.1.8_1_cc_left_d">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_left_d'']"/>
				</data>

				<data id="UB04.1.8_1_cc_middle_d">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_middle_d'']"/>
				</data>

				<data id="UB04.1.8_1_cc_right_d">
					<xsl:value-of select="data[@id=''UB04.1.8_1_cc_right_d'']"/>
				</data>
				
			</page>
    </formData>
  </xsl:template>
</xsl:stylesheet>'
where BillingFormID=18