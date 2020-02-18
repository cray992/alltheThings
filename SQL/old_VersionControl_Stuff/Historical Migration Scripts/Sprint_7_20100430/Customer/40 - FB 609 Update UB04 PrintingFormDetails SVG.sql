update PrintingFormDetails 
set SVGDefinition=
'<?xml version="1.0" standalone="yes"?>
<!-- UB04 SVG Transform Without Background -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />
	<!-- Y Locations for each procedure line -->
	<xsl:variable name="rowHeight">0.16666666666666666666666666666667</xsl:variable>
	
	<!--
			Generates a procedure line in SVG 
			
			Parameters:
				currentProcedureNum - index of the current line being processed (1 based)
				yLocation - y location for this procedure
	-->
	<xsl:template name="GenerateProcedureSVG">
		<xsl:param name="currentProcedureNum"/>
		<xsl:param name="yLocation"/>
				<g id="line_fl42_fl49_{$currentProcedureNum}">
					<text x=".16in" y="{$yLocation}in" width=".4in" height="0.15in" valueSource="UB04.1.4_2_ProcedureRevenueCode{$currentProcedureNum}" />
					<text x=".62in" y="{$yLocation}in" width="2.18in" height="0.15in" valueSource="UB04.1.4_3_ProcedureCode{$currentProcedureNum}" />
					<text x="3.14in" y="{$yLocation}in" width="1.3in" height="0.15in" valueSource="UB04.1.4_4_ProcedureName{$currentProcedureNum}" />
					<text x="4.62in" y="{$yLocation}in" width=".6in" height="0.15in" valueSource="UB04.1.4_5_ProcedureServiceDate{$currentProcedureNum}" class="date" />
					<text x="5.32in" y="{$yLocation}in" width=".7in" height="0.15in" valueSource="UB04.1.4_6_ProcedureUnits{$currentProcedureNum}" class="right" />
					<text x="6.08in" y="{$yLocation}in" width=".7in" height="0.15in" valueSource="UB04.1.4_7_ProcedureTotalChargesDollars{$currentProcedureNum}" class="money" />
					<text x="6.86in" y="{$yLocation}in" width=".3in" height="0.15in" valueSource="UB04.1.4_7_ProcedureTotalChargesCents{$currentProcedureNum}" />
					<text x="7.08in" y="{$yLocation}in" width=".7in" height="0.15in" valueSource="UB04.1.4_8_ProcedureNonCoveredChargeDollars{$currentProcedureNum}" class="money" />
					<text x="7.85in" y="{$yLocation}in" width=".3in" height="0.15in" valueSource="UB04.1.4_8_ProcedureNonCoveredChargeCents{$currentProcedureNum}" />
					<text x="8.08in" y="{$yLocation}in" width=".3in" height="0.15in" valueSource="UB04.1.4_9_{$currentProcedureNum}" />
				</g>
	</xsl:template>
	
	<!--.
			Takes in the number procedures to process.
			
			Parameters:
				totalProcedures - total number of services to display
				currentProcedureNum - index of the current service being processed (1 based)
	-->
	<xsl:template name="CreateProcedureLayout">
		<xsl:param name="totalProcedures"/>
		<xsl:param name="currentProcedureNum"/>

		<xsl:if test="$currentProcedureNum &lt;= $totalProcedures">
			<xsl:call-template name="GenerateProcedureSVG">
				<xsl:with-param name="currentProcedureNum" select="$currentProcedureNum"/>
				<xsl:with-param name="yLocation" select="format-number(($currentProcedureNum + 17) * $rowHeight, ''#.000'')"/>
			</xsl:call-template>
			
			<!-- Calls the same template recursively (increments the procedure num by one) -->
			<xsl:call-template name="CreateProcedureLayout">
				<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
				<xsl:with-param name="currentProcedureNum" select="$currentProcedureNum + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/formData/page">
		<!-- Procedure count to determine how many procedure we''ll need to loop through [Use ''UB04.1.4_3_ProcedureCode'' since the summary line (23) does not have a description] -->
		<xsl:variable name="totalProcedures" select="count(data[starts-with(@id,''UB04.1.4_3_ProcedureCode'')])"/>

		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="ub04" formId="UB04" pageId="UB04.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
			<defs>
				<style type="text/css">
					<![CDATA[
		
		g {
			font-family: Courier New;
			font-size: 10pt;
			font-style: normal;
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
		
		text.date
		{
			text-anchor: end;
		}
		
		text.right
		{
			text-anchor: end;
		}
		
	    	]]>
				</style>
			</defs>
			<g transform="translate(5, -13)">
				<g id="box_fl01">
					<text x=".25in" y="0.167in" width="2.28in" height="0.15in" valueSource="UB04.1.0_1_BillingProviderName" />
					<text x=".25in" y="0.333in" width="2.28in" height="0.15in" valueSource="UB04.1.0_1_BillingProviderStreet" />
					<text x=".25in" y="0.50in" width="2.28in" height="0.15in" valueSource="UB04.1.0_1_BillingProviderCityStateZip" />
					<text x=".25in" y="0.667in" width="2.28in" height="0.15in" valueSource="UB04.1.0_1_BillingProviderPhone" />
				</g>
				<g id="box_fl02">
					<text x="2.75in" y="0.167in" width="2.28in" height="0.15in" valueSource="UB04.1.0_2_PayToName" />
					<text x="2.75in" y="0.333in" width="2.28in" height="0.15in" valueSource="UB04.1.0_2_PayToStreet" />
					<text x="2.75in" y="0.50in" width="2.28in" height="0.15in" valueSource="UB04.1.0_2_PayToCityStateZip" />
					<text x="2.75in" y="0.667in" width="2.28in" height="0.15in" valueSource="UB04.1.0_2_line4" />
				</g>
				<g id="box_fl03">
					<text x="5.5in" y="0.167in" width="2.18in" height="0.15in" valueSource="UB04.1.0_3_a_PatientControlNumber" />
					<text x="5.5in" y="0.333in" width="2.18in" height="0.15in" valueSource="UB04.1.0_3_b_PatientMedicalRecordNumber" />
				</g>
				<g id="box_fl04">
					<text x="7.89in" y="0.333in" width=".4in" height="0.15in" valueSource="UB04.1.0_4_TypeOfBill" />
				</g>
				<g id="box_fl05">
					<text x="5.7in" y="0.50in" width=".4in" height="0.15in" valueSource ="UB04.1.0_5_sub_id" />
					<text x="5.10in" y="0.667in" width="1.0in" height="0.15in" valueSource="UB04.1.0_5_FederalTaxNumber" />
				</g>
				<g id="box_fl06">
					<text x="6.14in" y="0.667in" width=".6in" height="0.15in" valueSource="UB04.1.0_6_ServiceFromDate" class="date" />
					<text x="6.84in" y="0.667in" width=".6in" height="0.15in" valueSource="UB04.1.0_6_ServiceToDate" class="date" />
				</g>
				<g id="box_fl07">
					<text x="7.64in" y="0.50in" width=".7in" height="0.15in" valueSource="UB04.1.0_7_line1" />
					<text x="7.54in" y="0.667in" width=".8in" height="0.15in" valueSource="UB04.1.0_7_line2" />
				</g>
				<g id="box_fl08">
					<text x="1.26in" y="0.833in" width="1.7in" height="0.15in" valueSource="UB04.1.0_8_a_PatientID" />
					<text x="0.27in" y="1.0in" width="2.56in" height="0.15in" valueSource="UB04.1.0_8_b_PatientName" />
				</g>
				<g id="box_fl09">
					<text x="4.26in" y="0.833in" width="3.5in" height="0.15in" valueSource="UB04.1.0_9_a_PatientStreetAddress" />
					<text x="3.26in" y="1.0in" width="2.66in" height="0.15in" valueSource="UB04.1.0_9_b_PatientCity" />
					<text x="6.56in" y="1.0in" width="0.3in" height="0.15in" valueSource="UB04.1.0_9_c_PatientState" />
					<text x="6.96in" y="1.0in" width="0.9in" height="0.15in" valueSource="UB04.1.0_9_d_PatientZipCode" />
					<text x="8.06in" y="1.0in" width="0.3in" height="0.15in" valueSource="UB04.1.0_9_e_PatientCountry" />
				</g>
				<g id="line_08_fl10_fl29">
					<text x=".14in" y="1.333in" width=".8in" height="0.15in" valueSource="UB04.1.1_0_PatientBirthDate" class="date" />
					<text x="1.06in" y="1.333in" width="0.2in" height="0.15in" valueSource="UB04.1.1_1_PatientGender" />
					<text x="1.24in" y="1.333in" width="0.6in" height="0.15in" valueSource="UB04.1.1_2_AdmissionDate" class="date" />
					<text x="1.96in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.1_3_AdmissionHour" />
					<text x="2.26in" y="1.333in" width="0.2in" height="0.15in" valueSource="UB04.1.1_4_AdmissionType" />
					<text x="2.56in" y="1.333in" width="0.2in" height="0.15in" valueSource="UB04.1.1_5_PointOfOrigin" />
					<text x="2.86in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.1_6_DischargeHour" />
					<text x="3.04in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.1_7_PatientDischargeStatus" class="right" />
					<text x="3.45in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.1_8_ConditionCode1" />
					<text x="3.75in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.1_9_ConditionCode2" />
					<text x="4.05in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.2_0_ConditionCode3" />
					<text x="4.35in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.2_1_ConditionCode4" />
					<text x="4.65in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.2_2_ConditionCode5" />
					<text x="4.95in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.2_3_ConditionCode6" />
					<text x="5.25in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.2_4_ConditionCode7" />
					<text x="5.55in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.2_5_ConditionCode8" />
					<text x="5.85in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.2_6_ConditionCode9" />
					<text x="6.15in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.2_7_ConditionCode10" />
					<text x="6.45in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.2_8_CondtionCode11" />
					<text x="6.77in" y="1.333in" width="0.3in" height="0.15in" valueSource="UB04.1.2_9_AccidentState" />
				</g>
				<g id="box_fl30">
					<text x="7.25in" y="1.167in" width="1.05in" height="0.15in" valueSource="UB04.1.3_0_line1" />
					<text x="7.08in" y="1.333in" width="1.2in" height="0.15in" valueSource="UB04.1.3_0_line2" />
				</g>
				<g id="line_10_fl31a_fl37a">
					<text x=".17in" y="1.667in" width=".3in" height="0.15in" valueSource="UB04.1.3_1_OccurenceCode1" />
					<text x=".44in" y="1.667in" width=".6in" height="0.15in" valueSource="UB04.1.3_1_OccurenceCodeDate1" class="date" />
					<text x="1.17in" y="1.667in" width=".3in" height="0.15in" valueSource="UB04.1.3_2_OccurenceCode2" />
					<text x="1.44in" y="1.667in" width=".6in" height="0.15in" valueSource="UB04.1.3_2_OccurenceCodeDate2" class="date" />
					<text x="2.17in" y="1.667in" width=".3in" height="0.15in" valueSource="UB04.1.3_3_OccurenceCode3" />
					<text x="2.44in" y="1.667in" width=".6in" height="0.15in" valueSource="UB04.1.3_3_OccurenceCodeDate3" class="date" />
					<text x="3.17in" y="1.667in" width=".3in" height="0.15in" valueSource="UB04.1.3_4_OccurenceCode4" />
					<text x="3.44in" y="1.667in" width=".6in" height="0.15in" valueSource="UB04.1.3_4_OccurenceCodeDate4" class="date" />
					<text x="4.16in" y="1.667in" width=".3in" height="0.15in" valueSource="UB04.1.3_5_OccurenceSpanCode1" />
					<text x="4.44in" y="1.667in" width=".6in" height="0.15in" valueSource="UB04.1.3_5_OccurenceSpanCodeDateFrom1" class="date" />
					<text x="5.14in" y="1.667in" width=".6in" height="0.15in" valueSource="UB04.1.3_5_OccurenceSpanCodeDateTo1" class="date" />
					<text x="5.87in" y="1.667in" width=".3in" height="0.15in" valueSource="UB04.1.3_6_OccurenceSpanCode2" />
					<text x="6.14in" y="1.667in" width=".6in" height="0.15in" valueSource="UB04.1.3_6_OccurenceSpanCodeDateFrom2" class="date" />
					<text x="6.84in" y="1.667in" width=".6in" height="0.15in" valueSource="UB04.1.3_6_OccurenceSpanCodeDateTo2" class="date" />
					<text x="7.57in" y="1.667in" width=".8in" height="0.15in" valueSource="UB04.1.3_7_a" />
				</g>
				<g id="line_10_fl31b_fl37b">
					<text x=".17in" y="1.833in" width=".3in" height="0.15in" valueSource="UB04.1.3_1_OccurenceCode5" />
					<text x=".44in" y="1.833in" width=".6in" height="0.15in" valueSource="UB04.1.3_1_OccurenceCodeDate5" class="date" />
					<text x="1.17in" y="1.833in" width=".3in" height="0.15in" valueSource="UB04.1.3_2_OccurenceCode6" />
					<text x="1.44in" y="1.833in" width=".6in" height="0.15in" valueSource="UB04.1.3_2_OccurenceCodeDate6" class="date" />
					<text x="2.17in" y="1.833in" width=".3in" height="0.15in" valueSource="UB04.1.3_3_OccurenceCode7" />
					<text x="2.44in" y="1.833in" width=".6in" height="0.15in" valueSource="UB04.1.3_3_OccurenceCodeDate7" class="date" />
					<text x="3.17in" y="1.833in" width=".3in" height="0.15in" valueSource="UB04.1.3_4_OccurenceCode8" />
					<text x="3.44in" y="1.833in" width=".6in" height="0.15in" valueSource="UB04.1.3_4_OccurenceCodeDate8" class="date" />
					<text x="4.16in" y="1.833in" width=".3in" height="0.15in" valueSource="UB04.1.3_5_OccurenceSpanCode3" />
					<text x="4.44in" y="1.833in" width=".6in" height="0.15in" valueSource="UB04.1.3_5_OccurenceSpanCodeDateFrom3" class="date" />
					<text x="5.14in" y="1.833in" width=".6in" height="0.15in" valueSource="UB04.1.3_5_OccurenceSpanCodeDateTo3" class="date" />
					<text x="5.87in" y="1.833in" width=".3in" height="0.15in" valueSource="UB04.1.3_6_OccurenceSpanCode4" />
					<text x="6.14in" y="1.833in" width=".6in" height="0.15in" valueSource="UB04.1.3_6_OccurenceSpanCodeDateFrom4" class="date" />
					<text x="6.84in" y="1.833in" width=".6in" height="0.15in" valueSource="UB04.1.3_6_OccurenceSpanCodeDateTo4" class="date" />
					<text x="7.57in" y="1.833in" width=".8in" height="0.15in" valueSource="UB04.1.3_7_b" />
				</g>
				<g id="box_fl38">
					<text x=".32in" y="2.0in" width="3.5in" height="0.15in" valueSource="UB04.1.3_8_InsuranceCompanyName" />
					<text x=".32in" y="2.167in" width="3.5in" height="0.15in" valueSource="UB04.1.3_8_InsuranceCompanyAddress" />
					<text x=".32in" y="2.333in" width="3.5in" height="0.15in" valueSource="UB04.1.3_8_InsuranceCompanyCityStateZip" />
					<text x=".32in" y="2.5in" width="3.5in" height="0.15in" valueSource="UB04.1.3_8_line4" />
					<text x=".32in" y="2.667in" width="3.5in" height="0.15in" valueSource="UB04.1.3_8_line5" />
				</g>
				<g id="box_fl39">
					<text x="4.48in" y="2.167in" width=".3in" height="0.15in" valueSource="UB04.1.3_9_ValueCode1" />
					<text x="4.79in" y="2.167in" width=".7in" height="0.15in" valueSource="UB04.1.3_9_ValueCodeDollars1" class="money" />
					<text x="5.51in" y="2.167in" width=".3in" height="0.15in" valueSource="UB04.1.3_9_ValueCodeCents1" />
					<text x="4.48in" y="2.333in" width=".3in" height="0.15in" valueSource="UB04.1.4_1_ValueCode4" />
					<text x="4.79in" y="2.333in" width=".7in" height="0.15in" valueSource="UB04.1.3_9_ValueCodeDollars4" class="money" />
					<text x="5.51in" y="2.333in" width=".3in" height="0.15in" valueSource="UB04.1.3_9_ValueCodeCents4" />
					<text x="4.48in" y="2.5in" width=".3in" height="0.15in" valueSource="UB04.1.3_9_ValueCode7" />
					<text x="4.79in" y="2.5in" width=".7in" height="0.15in" valueSource="UB04.1.3_9_ValueCodeDollars7" class="money" />
					<text x="5.51in" y="2.5in" width=".3in" height="0.15in" valueSource="UB04.1.3_9_ValueCodeCents7" />
					<text x="4.48in" y="2.667in" width=".3in" height="0.15in" valueSource="UB04.1.3_9_ValueCode10" />
					<text x="4.79in" y="2.667in" width=".7in" height="0.15in" valueSource="UB04.1.3_9_ValueCodeDollars10" class="money" />
					<text x="5.51in" y="2.667in" width=".3in" height="0.15in" valueSource="UB04.1.3_9_ValueCodeCents10" />
				</g>
				<g id="box_fl40">
					<text x="5.78in" y="2.167in" width=".3in" height="0.15in" valueSource="UB04.1.4_0_ValueCode2" />
					<text x="6.07in" y="2.167in" width=".7in" height="0.15in" valueSource="UB04.1.4_0_ValueCodeDollars2" class="money" />
					<text x="6.81in" y="2.167in" width=".3in" height="0.15in" valueSource="UB04.1.4_0_ValueCodeCents2" />
					<text x="5.78in" y="2.333in" width=".3in" height="0.15in" valueSource="UB04.1.4_0_ValueCode5" />
					<text x="6.07in" y="2.333in" width=".7in" height="0.15in" valueSource="UB04.1.4_0_ValueCodeDollars5" class="money" />
					<text x="6.81in" y="2.333in" width=".3in" height="0.15in" valueSource="UB04.1.4_0_ValueCodeCents5" />
					<text x="5.78in" y="2.5in" width=".3in" height="0.15in" valueSource="UB04.1.4_0_ValueCode8" />
					<text x="6.07in" y="2.5in" width=".7in" height="0.15in" valueSource="UB04.1.4_0_ValueCodeDollars8" class="money" />
					<text x="6.81in" y="2.5in" width=".3in" height="0.15in" valueSource="UB04.1.4_0_ValueCodeCents8" />
					<text x="5.78in" y="2.667in" width=".3in" height="0.15in" valueSource="UB04.1.4_0_ValueCode11" />
					<text x="6.07in" y="2.667in" width=".7in" height="0.15in" valueSource="UB04.1.4_0_ValueCodeDollars11" class="money" />
					<text x="6.81in" y="2.667in" width=".3in" height="0.15in" valueSource="UB04.1.4_0_ValueCodeCents11" />
				</g>
				<g id="box_fl41">
					<text x="7.08in" y="2.167in" width=".3in" height="0.15in" valueSource="UB04.1.4_1_ValueCode3" />
					<text x="7.37in" y="2.167in" width=".7in" height="0.15in" valueSource="UB04.1.4_1_ValueCodeDollars3" class="money" />
					<text x="8.11in" y="2.167in" width=".3in" height="0.15in" valueSource="UB04.1.4_1_ValueCodeCents3" />
					<text x="7.08in" y="2.333in" width=".3in" height="0.15in" valueSource="UB04.1.4_1_ValueCode6" />
					<text x="7.37in" y="2.333in" width=".7in" height="0.15in" valueSource="UB04.1.4_1_ValueCodeDollars6" class="money" />
					<text x="8.11in" y="2.333in" width=".3in" height="0.15in" valueSource="UB04.1.4_1_ValueCodeCents6" />
					<text x="7.08in" y="2.5in" width=".3in" height="0.15in" valueSource="UB04.1.4_1_ValueCode9" />
					<text x="7.37in" y="2.5in" width=".7in" height="0.15in" valueSource="UB04.1.4_1_ValueCodeDollars9" class="money" />
					<text x="8.11in" y="2.5in" width=".3in" height="0.15in" valueSource="UB04.1.4_1_ValueCodeCents9" />
					<text x="7.08in" y="2.667in" width=".3in" height="0.15in" valueSource="UB04.1.4_1_ValueCode12" />
					<text x="7.37in" y="2.667in" width=".7in" height="0.15in" valueSource="UB04.1.4_1_ValueCodeDollars12" class="money" />
					<text x="8.11in" y="2.667in" width=".3in" height="0.15in" valueSource="UB04.1.4_1_ValueCodeCents12" />
				</g>
				<!-- Insert the procedure rows -->
				<xsl:call-template name="CreateProcedureLayout">
					<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
					<xsl:with-param name="currentProcedureNum" select="1"/>
				</xsl:call-template>
				<g id="line_fl42_fl49_23">
					<text x=".16in" y="6.667in" width=".4in" height="0.15in" valueSource="UB04.1.4_2_ProcedureRevenueCode23" />
					<text x=".94in" y="6.645in" width=".35in" height="0.15in" valueSource="UB04.1.4_3_CurrentPage23" class="right" />
					<text x="1.54in" y="6.645in" width=".35in" height="0.15in" valueSource="UB04.1.4_3_TotalPages23" class="right" />
					<text x="4.62in" y="6.667in" width=".6in" height="0.15in" valueSource="UB04.1.4_5_CreationDate23" class="date"/>
					<text x="6.08in" y="6.667in" width=".7in" height="0.15in" valueSource="UB04.1.4_7_TotalChargesDollars23" class="money" />
					<text x="6.86in" y="6.667in" width=".3in" height="0.15in" valueSource="UB04.1.4_7_TotalChargesCents23" />
					<text x="7.08in" y="6.667in" width=".7in" height="0.15in" valueSource="UB04.1.4_8_TotalNonCoveredChargesDollars23" class="money" />
					<text x="7.85in" y="6.667in" width=".3in" height="0.15in" valueSource="UB04.1.4_8_TotalNonCoveredChargesCents23" />
					<text x="8.08in" y="6.667in" width=".3in" height="0.15in" valueSource="UB04.1.4_9_23" />
				</g>
				<g id="line42_fl50_fl57a">
					<text x=".18in" y="7.0in" width="2.0in" height="0.15in" valueSource="UB04.1.5_0_PayerNamePrimary" />
					<text x="2.48in" y="7.0in" width="1.4in" height="0.15in" valueSource="UB04.1.5_1_HealthPlanIdNumberPrimary" />
					<text x="3.94in" y="7.0in" width=".2in" height="0.15in" valueSource="UB04.1.5_2_ReleaseOfICIPrimary" />
					<text x="4.24in" y="7.0in" width=".2in" height="0.15in" valueSource="UB04.1.5_3_AssignmentOfBenefitsPrimary" />
					<text x="4.36in" y="7.0in" width=".8in" height="0.15in" valueSource="UB04.1.5_4_PriorPaymentsPrimaryDollars" class="money" />
					<text x="5.21in" y="7.0in" width=".3in" height="0.15in" valueSource="UB04.1.5_4_PriorPaymentsPrimaryCents" />
					<text x="5.46in" y="7.0in" width=".8in" height="0.15in" valueSource="UB04.1.5_5_EstimatedAmountPrimaryDollars" class="money" />
					<text x="6.30in" y="7.0in" width=".3in" height="0.15in" valueSource="UB04.1.5_5_EstimatedAmountPrimaryCents" />
					<text x="6.88in" y="7.0in" width="1.4in" height="0.15in" valueSource="UB04.1.5_7_OtherProviderIdentifierPrimary" />
				</g>
				<g id="line42_fl50_fl57b">
					<text x=".18in" y="7.167in" width="2.0in" height="0.15in" valueSource="UB04.1.5_0_PayerNameSecondary" />
					<text x="2.48in" y="7.167in" width="1.4in" height="0.15in" valueSource="UB04.1.5_1_HealthPlanIdNumberSecondary" />
					<text x="3.94in" y="7.167in" width=".2in" height="0.15in" valueSource="UB04.1.5_2_ReleaseOfICISecondary" />
					<text x="4.24in" y="7.167in" width=".2in" height="0.15in" valueSource="UB04.1.5_3_AssignmentOfBenefitsSecondary" />
					<text x="4.36in" y="7.167in" width=".8in" height="0.15in" valueSource="UB04.1.5_4_PriorPaymentsSecondaryDollars" class="money" />
					<text x="5.21in" y="7.167in" width=".3in" height="0.15in" valueSource="UB04.1.5_4_PriorPaymentsSecondaryCents" />
					<text x="5.46in" y="7.167in" width=".8in" height="0.15in" valueSource="UB04.1.5_5_EstimatedAmountSecondaryDollars" class="money" />
					<text x="6.30in" y="7.167in" width=".3in" height="0.15in" valueSource="UB04.1.5_5_EstimatedAmountSecondaryCents" />
					<text x="6.88in" y="7.167in" width="1.4in" height="0.15in" valueSource="UB04.1.5_7_OtherProviderIdentifierSecondary" />
				</g>
				<g id="line42_fl50_fl57c">
					<text x=".18in" y="7.333in" width="2.0in" height="0.15in" valueSource="UB04.1.5_0_PayerNameTertiary" />
					<text x="2.48in" y="7.333in" width="1.4in" height="0.15in" valueSource="UB04.1.5_1_HealthPlanIdNumberTertiary" />
					<text x="3.94in" y="7.333in" width=".2in" height="0.15in" valueSource="UB04.1.5_2_ReleaseOfICITertiary" />
					<text x="4.24in" y="7.333in" width=".2in" height="0.15in" valueSource="UB04.1.5_3_AssignmentOfBenefitsTertiary" />
					<text x="4.36in" y="7.333in" width=".8in" height="0.15in" valueSource="UB04.1.5_4_PriorPaymentsTertiaryDollars" class="money" />
					<text x="5.21in" y="7.333in" width=".3in" height="0.15in" valueSource="UB04.1.5_4_PriorPaymentsTertiaryCents" />
					<text x="5.46in" y="7.333in" width=".8in" height="0.15in" valueSource="UB04.1.5_5_EstimatedAmountTertiaryDollars" class="money" />
					<text x="6.30in" y="7.333in" width=".3in" height="0.15in" valueSource="UB04.1.5_5_EstimatedAmountTertiaryCents" />
					<text x="6.88in" y="7.333in" width="1.4in" height="0.15in" valueSource="UB04.1.5_7_OtherProviderIdentifierTertiary" />
				</g>
				<g id="box_fl56">
					<text x="6.88in" y="6.833in" width="1.4in" height="0.15in" valueSource="UB04.1.5_6_BillingProviderNPI" />
				</g>
				<g id="line46_fl58_fl62a">
					<text x=".18in" y="7.667in" width="2.28in" height="0.15in" valueSource="UB04.1.5_8_InsuredNamePrimary" />
					<text x="2.76in" y="7.667in" width=".3in" height="0.15in" valueSource="UB04.1.5_9_PatientRelationshipToInsuredPrimary" />
					<text x="3.06in" y="7.667in" width="1.8in" height="0.15in" valueSource="UB04.1.6_0_InsurancePolicyNumberPrimary" />
					<text x="5.06in" y="7.667in" width="1.3in" height="0.15in" valueSource="UB04.1.6_1_InsurancePolicyGroupNamePrimary" />
					<text x="6.56in" y="7.667in" width="1.55in" height="0.15in" valueSource="UB04.1.6_2_InsurancePolicyGroupNumberPrimary" />
				</g>
				<g id="line46_fl58_fl62b">
					<text x=".18in" y="7.833in" width="2.28in" height="0.15in" valueSource="UB04.1.5_8_InsuredNameSecondary" />
					<text x="2.76in" y="7.833in" width=".3in" height="0.15in" valueSource="UB04.1.5_9_PatientRelationshipToInsuredSecondary" />
					<text x="3.06in" y="7.833in" width="1.8in" height="0.15in" valueSource="UB04.1.6_0_InsurancePolicyNumberSecondary" />
					<text x="5.06in" y="7.833in" width="1.3in" height="0.15in" valueSource="UB04.1.6_1_InsurancePolicyGroupNameSecondary" />
					<text x="6.56in" y="7.833in" width="1.55in" height="0.15in" valueSource="UB04.1.6_2_InsurancePolicyGroupNumberSecondary" />
				</g>
				<g id="line46_fl58_fl62c">
					<text x=".18in" y="8.0in" width="2.28in" height="0.15in" valueSource="UB04.1.5_8_InsuredNameTertiary" />
					<text x="2.76in" y="8.0in" width=".3in" height="0.15in" valueSource="UB04.1.5_9_PatientRelationshipToInsuredTertiary" />
					<text x="3.06in" y="8.0in" width="1.8in" height="0.15in" valueSource="UB04.1.6_0_InsurancePolicyNumberTertiary" />
					<text x="5.06in" y="8.0in" width="1.3in" height="0.15in" valueSource="UB04.1.6_1_InsurancePolicyGroupNameTertiary" />
					<text x="6.56in" y="8.0in" width="1.55in" height="0.15in" valueSource="UB04.1.6_2_InsurancePolicyGroupNumberTertiary" />
				</g>
				<g id="line46_fl63_fl65a">
					<text x=".18in" y="8.333in" width="2.66in" height="0.15in" valueSource="UB04.1.6_3_TreatmentAuthCodePrimary" />
					<text x="3.26in" y="8.333in" width="2.36in" height="0.15in" valueSource="UB04.1.6_4_DocumentControlNumberPrimary" />
					<text x="5.88in" y="8.333in" width="2.28in" height="0.15in" valueSource="UB04.1.6_5_EmployerNamePrimary" />
				</g>
				<g id="line46_fl63_fl65b">
					<text x=".18in" y="8.5in" width="2.66in" height="0.15in" valueSource="UB04.1.6_3_TreatmentAuthCodeSecondary" />
					<text x="3.26in" y="8.5in" width="2.36in" height="0.15in" valueSource="UB04.1.6_4_DocumentControlNumberSecondary" />
					<text x="5.88in" y="8.5in" width="2.28in" height="0.15in" valueSource="UB04.1.6_5_EmployerNameSecondary" />
				</g>
				<g id="line46_fl63_fl65b">
					<text x=".18in" y="8.667in" width="2.66in" height="0.15in" valueSource="UB04.1.6_3_TreatmentAuthCodeTertiary" />
					<text x="3.26in" y="8.667in" width="2.36in" height="0.15in" valueSource="UB04.1.6_4_DocumentControlNumberTertiary" />
					<text x="5.88in" y="8.667in" width="2.28in" height="0.15in" valueSource="UB04.1.6_5_EmployerNameTertiary" />
				</g>
				<g id="box_66">
					<text x=".08in" y="9.0in" width=".2in" height="0.15in" valueSource="UB04.1.6_6_DiagnosisProcedureCodeQualifier" />
				</g>
				<g id="line53_fl67a_h">
					<text x=".30in" y="8.833in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_PrincipalDiagnosisCode" />
					<text x="1.10in" y="8.833in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode1" />
					<text x="1.90in" y="8.833in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode2" />
					<text x="2.70in" y="8.833in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode3" />
					<text x="3.50in" y="8.833in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode4" />
					<text x="4.30in" y="8.833in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode5" />
					<text x="5.10in" y="8.833in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode6" />
					<text x="5.90in" y="8.833in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode7" />
					<text x="6.70in" y="8.833in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode8" />
				</g>
				<g id="line53_fl67i_q">
					<text x=".30in" y="9.0in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode9" />
					<text x="1.10in" y="9.0in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode10" />
					<text x="1.90in" y="9.0in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode11" />
					<text x="2.70in" y="9.0in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode12" />
					<text x="3.50in" y="9.0in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode13" />
					<text x="4.30in" y="9.0in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode14" />
					<text x="5.10in" y="9.0in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode15" />
					<text x="5.90in" y="9.0in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode16" />
					<text x="6.70in" y="9.0in" width=".8in" height="0.15in" valueSource="UB04.1.6_7_OtherDiagnosisCode17" />
				</g>
				<g id="box_68">
					<text x="7.56in" y="8.833in" width=".8in" height="0.15in" valueSource="UB04.1.6_8_line1" />
					<text x="7.48in" y="9.0in" width=".9in" height="0.15in" valueSource="UB04.1.6_8_line2" />
				</g>
				<g id="line55_fl69_fl73">
					<text x=".54in" y="9.167in" width=".7in" height="0.15in" valueSource="UB04.1.6_9_AdmittingDiagnosisCode" />
					<text x="1.74in" y="9.167in" width=".7in" height="0.15in" valueSource="UB04.1.7_0_PatientReasonDx1" />
					<text x="2.44in" y="9.167in" width=".7in" height="0.15in" valueSource="UB04.1.7_0_PatientReasonDx2" />
					<text x="3.14in" y="9.167in" width=".7in" height="0.15in" valueSource="UB04.1.7_0_PatientReasonDx3" />
					<text x="4.26in" y="9.167in" width=".4in" height="0.15in" valueSource="UB04.1.7_1_DRGCode" />
					<text x="5.00in" y="9.167in" width=".8in" height="0.15in" valueSource="UB04.1.7_2_eci_a" />
					<text x="5.80in" y="9.167in" width=".8in" height="0.15in" valueSource="UB04.1.7_2_eci_b" />
					<text x="6.60in" y="9.167in" width=".8in" height="0.15in" valueSource="UB04.1.7_2_eci_c" />
					<text x="7.48in" y="9.167in" width=".9in" height="0.15in" valueSource="UB04.1.7_3" />
				</g>
				<g id="box_fl74">
					<text x=".16in" y="9.5in" width=".7in" height="0.15in" valueSource="UB04.1.7_4_PrincipalProcedureCode" />
					<text x=".96in" y="9.5in" width=".6in" height="0.15in" valueSource="UB04.1.7_4_PrincipalProcedureDate" class="date" />
					<text x="1.64in" y="9.5in" width=".7in" height="0.15in" valueSource="UB04.1.7_4_OtherProcedureCode1" />
					<text x="2.46in" y="9.5in" width=".6in" height="0.15in" valueSource="UB04.1.7_4_OtherProcedureDate1" class="date" />
					<text x="3.14in" y="9.5in" width=".7in" height="0.15in" valueSource="UB04.1.7_4_OtherProcedureCode2" />
					<text x="3.96in" y="9.5in" width=".6in" height="0.15in" valueSource="UB04.1.7_4_OtherProcedureDate2" class="date" />
					<text x=".16in" y="9.833in" width=".7in" height="0.15in" valueSource="UB04.1.7_4_OtherProcedureCode3" />
					<text x=".96in" y="9.833in" width=".6in" height="0.15in" valueSource="UB04.1.7_4_OtherProcedureDate3" class="date" />
					<text x="1.64in" y="9.833in" width=".7in" height="0.15in" valueSource="UB04.1.7_4_OtherProcedureCode4" />
					<text x="2.46in" y="9.833in" width=".6in" height="0.15in" valueSource="UB04.1.7_4_OtherProcedureDate4" class="date" />
					<text x="3.14in" y="9.833in" width=".7in" height="0.15in" valueSource="UB04.1.7_4_OtherProcedureCode5" />
					<text x="3.96in" y="9.833in" width=".6in" height="0.15in" valueSource="UB04.1.7_4_OtherProcedureDate5" class="date" />
				</g>
				<g id="box_fl75">
					<text x="4.70in" y="9.333in" width=".4in" height="0.15in" valueSource="UB04.1.7_5_line1" />
					<text x="4.70in" y="9.5in" width=".4in" height="0.15in" valueSource="UB04.1.7_5_line2" />
					<text x="4.70in" y="9.667in" width=".4in" height="0.15in" valueSource="UB04.1.7_5_line3" />
					<text x="4.70in" y="9.833in" width=".4in" height="0.15in" valueSource="UB04.1.7_5_line4" />
				</g>
				<g id="box_fl76">
					<text x="6.0in" y="9.333in" width="1.05in" height="0.15in" valueSource="UB04.1.7_6_AttendingProviderNPI" />
					<text x="7.20in" y="9.333in" width=".3in" height="0.15in" valueSource="UB04.1.7_6_AttendingProviderQualifier" />
					<text x="7.48in" y="9.333in" width=".9in" height="0.15in" valueSource="UB04.1.7_6_AttendingProviderNumber" />
					<text x="5.4in" y="9.5in" width="1.5in" height="0.15in" valueSource="UB04.1.7_6_AttendingProviderLastName" />
					<text x="7.2in" y="9.5in" width="1.1in" height="0.15in" valueSource="UB04.1.7_6_AttendingProviderFistName" />
				</g>
				<g id="box_fl77">
					<text x="6.0in" y="9.667in" width="1.05in" height="0.15in" valueSource="UB04.1.7_7_OperatingProviderNPI" />
					<text x="7.21in" y="9.667in" width=".3in" height="0.15in" valueSource="UB04.1.7_7_OperatingProviderQualifier" />
					<text x="7.48in" y="9.667in" width=".9in" height="0.15in" valueSource="UB04.1.7_7_OperatingProviderNumber" />
					<text x="5.4in" y="9.833in" width="1.5in" height="0.15in" valueSource="UB04.1.7_7_OperatingProviderLastName" />
					<text x="7.2in" y="9.833in" width="1.1in" height="0.15in" valueSource="UB04.1.7_7_OperatingProviderFistName" />
				</g>
				<g id="box_fl78">
					<text x="5.62in" y="10.0in" width=".3in" height="0.15in" valueSource="UB04.1.7_8_Other1ProviderTypeQualifier" />
					<text x="6.0in" y="10.0in" width="1.05in" height="0.15in" valueSource="UB04.1.7_8_Other1ProviderNPI" />
					<text x="7.21in" y="10.0in" width=".3in" height="0.15in" valueSource="UB04.1.7_8_Other1ProviderQualifier" />
					<text x="7.48in" y="10.0in" width=".9in" height="0.15in" valueSource="UB04.1.7_8_Other1ProviderQualifier" />
					<text x="5.4in" y="10.167in" width="1.5in" height="0.15in" valueSource="UB04.1.7_8_Other1ProviderLastName" />
					<text x="7.2in" y="10.167in" width="1.1in" height="0.15in" valueSource="UB04.1.7_8_Other1ProviderFistName" />
				</g>
				<g id="box_fl79">
					<text x="5.62in" y="10.333in" width=".3in" height="0.15in" valueSource="UB04.1.7_9_Other2ProviderTypeQualifier" />
					<text x="6.0in" y="10.333in" width="1.05in" height="0.15in" valueSource="UB04.1.7_9_Other2ProviderNPI" />
					<text x="7.21in" y="10.333in" width=".3in" height="0.15in" valueSource="UB04.1.7_9_Other2ProviderQualifier" />
					<text x="7.48in" y="10.333in" width=".9in" height="0.15in" valueSource="UB04.1.7_9_Other2ProviderNumber" />
					<text x="5.4in" y="10.5in" width="1.5in" height="0.15in" valueSource="UB04.1.7_9_Other2ProviderLastName" />
					<text x="7.2in" y="10.5in" width="1.1in" height="0.15in" valueSource="UB04.1.7_9_Other2ProviderFistName" />
				</g>
				<g id="box_fl80">
					<text x=".70in" y="10.0in" width="1.7in" height="0.15in" valueSource="UB04.1.8_0_Remarks1" />
					<text x=".28in" y="10.167in" width="2.18in" height="0.15in" valueSource="UB04.1.8_0_Remarks2" />
					<text x=".28in" y="10.333in" width="2.18in" height="0.15in" valueSource="UB04.1.8_0_Remarks3" />
					<text x=".28in" y="10.5in" width="2.18in" height="0.15in" valueSource="UB04.1.8_0_Remarks4" />
				</g>
				<g id="box_fl81">
					<text x="2.71in" y="10.0in" width=".3in" height="0.15in" valueSource="UB04.1.8_1_cc_left_a" />
					<text x="2.94in" y="10.0in" width="1.0in" height="0.15in" valueSource="UB04.1.8_1_cc_middle_a" />
					<text x="3.98in" y="10.0in" width="1.1in" height="0.15in" valueSource="UB04.1.8_1_cc_right_a" />
					<text x="2.71in" y="10.167in" width=".3in" height="0.15in" valueSource="UB04.1.8_1_cc_left_b" />
					<text x="2.94in" y="10.167in" width="1.0in" height="0.15in" valueSource="UB04.1.8_1_cc_middle_b" />
					<text x="3.98in" y="10.167in" width="1.1in" height="0.15in" valueSource="UB04.1.8_1_cc_right_b" />
					<text x="2.71in" y="10.333in" width=".3in" height="0.15in" valueSource="UB04.1.8_1_cc_left_c" />
					<text x="2.94in" y="10.333in" width="1.0in" height="0.15in" valueSource="UB04.1.8_1_cc_middle_c" />
					<text x="3.98in" y="10.333in" width="1.1in" height="0.15in" valueSource="UB04.1.8_1_cc_right_c" />
					<text x="2.71in" y="10.5in" width=".3in" height="0.15in" valueSource="UB04.1.8_1_cc_left_d" />
					<text x="2.94in" y="10.5in" width="1.0in" height="0.15in" valueSource="UB04.1.8_1_cc_middle_d" />
					<text x="3.98in" y="10.5in" width="1.1in" height="0.15in" valueSource="UB04.1.8_1_cc_right_d" />
				</g>
			</g>
		</svg>
	</xsl:template>
</xsl:stylesheet>'
where PrintingFormDetailsID=89
