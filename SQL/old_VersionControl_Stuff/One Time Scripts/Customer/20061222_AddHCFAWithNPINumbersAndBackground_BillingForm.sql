/*
-----------------------------------------------------------------------------------------------------
CASE 17303 - Implement HCFA with NPI numbers and Background Billing Form
-----------------------------------------------------------------------------------------------------
*/

IF NOT EXISTS(SELECT PrintingFormID FROM PrintingForm WHERE PrintingFormID = 22)
BEGIN
	INSERT INTO PrintingForm(PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
	VALUES(22, 'CMS1500 (with NPI numbers and background)', 'CMS 1500 Form - Version 08/05 with NPI', 'BillDataProvider_GetHCFADocumentDataWithNPINumbersAndBackground', 1)
END

IF NOT EXISTS(SELECT PrintingFormDetailsID FROM PrintingFormDetails WHERE PrintingFormDetailsID = 80)
BEGIN
	INSERT INTO PrintingFormDetails(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
	VALUES(80, 22, 67, 'HCFA with NPI Numbers and Background', 1)
END

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<!-- HCFA SVG Transform With Background -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />
	<!-- Y Locations for each procedure line -->
	<xsl:variable name="yProcedure1">7.14</xsl:variable>
	<xsl:variable name="yProcedure2">7.45</xsl:variable>
	<xsl:variable name="yProcedure3">7.75</xsl:variable>
	<xsl:variable name="yProcedure4">8.06</xsl:variable>
	<xsl:variable name="yProcedure5">8.36</xsl:variable>
	<xsl:variable name="yProcedure6">8.67</xsl:variable>
	<!--        Generates regular procedure SVG for one procedure                    Parameters:          currentProcedure - index of the current procedure being processed          yProcedureLocation - y location for this procedure         -->
	<xsl:template name="GenerateProcedureSVG">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation"/>
		<g id="box24_{$currentProcedure}">
			<text x="0.58in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.85in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
			<text x="1.14in" y="{$yProcedureLocation}in" width="0.50in" height="0.10in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.42in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.71in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
			<text x="2.0in" y="{$yProcedureLocation}in" width="0.50in" height="0.10in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.28in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.56in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.cEMG{$currentProcedure}" />
			<text x="2.85in" y="{$yProcedureLocation}in" width="0.70in" height="0.10in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.56in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.dModifier1{$currentProcedure}" />
			<text x="3.87in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.dModifier2{$currentProcedure}" />
			<text x="4.16in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.dModifier3{$currentProcedure}" />
			<text x="4.45in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.dModifier4{$currentProcedure}" />
			<text x="4.70in" y="{$yProcedureLocation}in" width="0.52in" height="0.10in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.24in" y="{$yProcedureLocation}in" width="0.55in" height="0.10in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.78in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.0in" y="{$yProcedureLocation}in" width="0.52in" height="0.10in" text-anchor="start" valueSource="CMS1500.1.gUnits{$currentProcedure}" class="smaller" />
			<text x="6.38in" y="{$yProcedureLocation}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.62in" y="{$yProcedureLocation - 0.155}in" width="0.30in" height="0.10in" valueSource="CMS1500.1.iQualifier{$currentProcedure}" />
			<text x="6.86in" y="{$yProcedureLocation - 0.155}in" width="1.23in" height="0.10in" valueSource="CMS1500.1.jID{$currentProcedure}" />
			<text x="6.86in" y="{$yProcedureLocation}in" width="1.23in" height="0.10in" valueSource="CMS1500.1.jNPI{$currentProcedure}" />
			<text x="0.57in" y="{$yProcedureLocation - 0.155}in" width="6.14in" height="0.10in" valueSource="CMS1500.1.SupplementalInfo{$currentProcedure}" />
		</g>
	</xsl:template>
	<!--            Takes in the number procedures to process.          Loops through each procedure to print.          Keeps track of how many rows that have been printed.                    Parameters:          totalProcedures - total number of procedures to display          currentProcedure - index of the current procedure being processed          currentProcedureLine - current procedure line to print out        -->
	<xsl:template name="CreateProcedureLayout">
		<xsl:param name="totalProcedures"/>
		<xsl:param name="currentProcedure"/>
		<xsl:param name="currentProcedureLine"/>
		<xsl:if test="$totalProcedures >= $currentProcedure">
			<!-- Print the procedure information on one procedure lines -->
			<xsl:choose>
				<xsl:when test="$currentProcedureLine = 1">
					<xsl:call-template name="GenerateProcedureSVG">
						<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
						<xsl:with-param name="yProcedureLocation" select="$yProcedure1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$currentProcedureLine = 2">
					<xsl:call-template name="GenerateProcedureSVG">
						<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
						<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$currentProcedureLine = 3">
					<xsl:call-template name="GenerateProcedureSVG">
						<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
						<xsl:with-param name="yProcedureLocation" select="$yProcedure3"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$currentProcedureLine = 4">
					<xsl:call-template name="GenerateProcedureSVG">
						<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
						<xsl:with-param name="yProcedureLocation" select="$yProcedure4"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$currentProcedureLine = 5">
					<xsl:call-template name="GenerateProcedureSVG">
						<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
						<xsl:with-param name="yProcedureLocation" select="$yProcedure5"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="GenerateProcedureSVG">
						<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
						<xsl:with-param name="yProcedureLocation" select="$yProcedure6"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Calls the same template recursively (increments the procedure line by one) -->
			<xsl:call-template name="CreateProcedureLayout">
				<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
				<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
				<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/formData/page">
		<!-- Procedure count to determine how many procedures we''ll need to loop through -->
		<xsl:variable name="ProcedureCount" select="count(data[starts-with(@id,''CMS1500.1.aStartMM'')])"/>
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="CMS1500" pageId="CMS1500.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
			<defs>
				<style type="text/css">       <![CDATA[        g {     font-family: Courier New;     font-size: 10pt;     font-style: normal;     font-weight: bold;     alignment-baseline: text-before-edge;    }        text    {     baseline-shift: -100%;    }        text.money    {     text-anchor: end;    }      text.smaller    {     font-size: 9pt;    }              ]]>      </style>
			</defs>
			<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://19164345-ce08-4b9b-b838-4b75d32c9095?type=global"></image>
			<!--<image x="0" y="0" width="8.5in" height="11in" xlink:href="./CMS1500.NPINumbers.jpg"></image>-->
			<g id="carrier">
				<text x="4.21in" y="0.66in" width="4.10in" height="0.10in" valueSource="CMS1500.1.CarrierName" />
				<text x="4.21in" y="0.82in" width="4.10in" height="0.10in" valueSource="CMS1500.1.CarrierStreet" />
				<text x="4.21in" y="0.98in" width="4.10in" height="0.10in" valueSource="CMS1500.1.CarrierCityStateZip" />
			</g>
			<g id="line1">
				<text x="0.58in" y="1.64in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_Medicare" />
				<text x="1.23in" y="1.64in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_Medicaid" />
				<text x="1.89in" y="1.64in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_Champus" />
				<text x="2.74in" y="1.64in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_Champva" />
				<text x="3.40in" y="1.64in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_GroupHealthPlan" />
				<text x="4.15in" y="1.64in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_Feca" />
				<text x="4.72in" y="1.64in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_Other" />
				<text x="5.19in" y="1.63in" width="2.93in" height="0.10in" valueSource="CMS1500.1.1_aIDNumber" />
			</g>
			<g id="line2">
				<text x="0.57in" y="1.93in" width="2.79in" height="0.10in" valueSource="CMS1500.1.2_PatientName" />
				<text x="3.36in" y="1.95in" width="0.30in" height="0.10in" valueSource="CMS1500.1.3_MM" />
				<text x="3.67in" y="1.95in" width="0.30in" height="0.10in" valueSource="CMS1500.1.3_DD" />
				<text x="3.95in" y="1.95in" width="0.50in" height="0.10in" valueSource="CMS1500.1.3_YY" />
				<text x="4.43in" y="1.94in" width="0.09in" height="0.10in" valueSource="CMS1500.1.3_M" />
				<text x="4.91in" y="1.94in" width="0.09in" height="0.10in" valueSource="CMS1500.1.3_F" />
				<text x="5.19in"  y="1.93in" width="2.93in" height="0.1in" valueSource="CMS1500.1.4_InsuredName" />
			</g>
			<g id="line3">
				<text x="0.57in" y="2.24in" width="2.79in" height="0.10in" valueSource="CMS1500.1.5_PatientAddress" />
				<text x="3.59in" y="2.26in" width="0.09in" height="0.10in" valueSource="CMS1500.1.6_Self" />
				<text x="4.07in" y="2.26in" width="0.09in" height="0.10in" valueSource="CMS1500.1.6_Spouse" />
				<text x="4.44in" y="2.26in" width="0.09in" height="0.10in" valueSource="CMS1500.1.6_Child" />
				<text x="4.92in" y="2.26in" width="0.09in" height="0.10in" valueSource="CMS1500.1.6_Other" />
				<text x="5.19in" y="2.24in" width="2.93in" height="0.10in" valueSource="CMS1500.1.7_InsuredAddress" />
			</g>
			<g id="line4">
				<text x="0.57in" y="2.54in" width="2.42in" height="0.10in" valueSource="CMS1500.1.5_City" />
				<text x="2.94in" y="2.54in" width="0.30in" height="0.10in" valueSource="CMS1500.1.5_State" />
				<text x="5.19in" y="2.54in" width="2.28in" height="0.10in" valueSource="CMS1500.1.7_City" />
				<text x="7.43in" y="2.54in" width="0.30in" height="0.10in" valueSource="CMS1500.1.7_State" />
			</g>
			<g id="box8">
				<text x="3.79in" y="2.56in" width="0.09in" height="0.10in" valueSource="CMS1500.1.8_Single" />
				<text x="4.35in" y="2.56in" width="0.09in" height="0.10in" valueSource="CMS1500.1.8_Married" />
				<text x="4.92in" y="2.56in" width="0.09in" height="0.10in" valueSource="CMS1500.1.8_Other" />
				<text x="3.79in" y="2.86in" width="0.09in" height="0.10in" valueSource="CMS1500.1.8_Employed" />
				<text x="4.35in" y="2.86in" width="0.09in" height="0.10in" valueSource="CMS1500.1.8_FTStud" />
				<text x="4.92in" y="2.86in" width="0.09in" height="0.10in" valueSource="CMS1500.1.8_PTStud" />
			</g>
			<g id="line5">
				<text x="0.57in" y="2.86in" width="1.19in" height="0.10in" valueSource="CMS1500.1.5_Zip" />
				<text x="1.91in" y="2.86in" width="0.40in" height="0.10in" valueSource="CMS1500.1.5_Area" />
				<text x="2.27in" y="2.86in" width="1.10in" height="0.10in" valueSource="CMS1500.1.5_Phone" />
				<text x="5.19in" y="2.86in" width="1.23in" height="0.10in" valueSource="CMS1500.1.7_Zip" />
				<text x="6.62in" y="2.85in" width="0.40in" height="0.10in" valueSource="CMS1500.1.7_Area" />
				<text x="7.0in" y="2.85in" width="1.10in" height="0.10in" valueSource="CMS1500.1.7_Phone" />
			</g>
			<g id="line6">
				<text x="0.57in" y="3.15in" width="2.79in" height="0.10in" valueSource="CMS1500.1.9_OtherName" />
				<text x="5.19in" y="3.15in" width="2.93in" height="0.10in" valueSource="CMS1500.1.1_1GroupNumber" />
			</g>
			<g id="box10">
				<text x="3.78in" y="3.47in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_0aYes" />
				<text x="4.34in" y="3.47in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_0aNo" />
				<text x="3.78in" y="3.78in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_0bYes" />
				<text x="4.34in" y="3.78in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_0bNo" />
				<text x="4.72in" y="3.77in" width="0.3in" height="0.10in" valueSource="CMS1500.1.1_0bState" />
				<text x="3.78in" y="4.08in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_0cYes" />
				<text x="4.34in" y="4.08in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_0cNo" />
			</g>
			<g id="line7">
				<text x="0.57in" y="3.44in" width="2.79in" height="0.10in" valueSource="CMS1500.1.9_aGrpNumber" />
				<text x="5.46in" y="3.48in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_1aMM" />
				<text x="5.77in" y="3.48in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_1aDD" />
				<text x="6.06in" y="3.48in" width="0.60in" height="0.10in" valueSource="CMS1500.1.1_1aYY" />
				<text x="6.89in" y="3.47in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_1aM" />
				<text x="7.56in" y="3.47in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_1aF" />
			</g>
			<g id="line8">
				<text x="0.62in" y="3.78in" width="0.30in" height="0.10in" valueSource="CMS1500.1.9_bMM" />
				<text x="0.94in" y="3.78in" width="0.30in" height="0.10in" valueSource="CMS1500.1.9_bDD" />
				<text x="1.24in" y="3.78in" width="0.60in" height="0.10in" valueSource="CMS1500.1.9_bYYYY" />
				<text x="2.18in" y="3.78in"  width="0.09in" height="0.10in" valueSource="CMS1500.1.9_bM" />
				<text x="2.74in" y="3.78in" width="0.09in" height="0.10in" valueSource="CMS1500.1.9_bF" />
				<text x="5.19in" y="3.76in" width="2.93in" height="0.10in" valueSource="CMS1500.1.1_1bEmployer" />
			</g>
			<g id="line9">
				<text x="0.57in" y="4.07in" width="2.79in" height="0.10in" valueSource="CMS1500.1.9_cEmployer" />
				<text x="5.19in" y="4.07in" width="2.93in" height="0.10in" valueSource="CMS1500.1.1_1cPlanName" />
			</g>
			<g id="line10">
				<text x="0.57in" y="4.39in" width="2.79in" height="0.10in" valueSource="CMS1500.1.9_dPlanName" />
				<text x="3.28in" y="4.39in" width="1.85in" height="0.10in" valueSource="CMS1500.1.1_0dLocal" />
				<text x="5.37in" y="4.38in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_1dYes" />
				<text x="5.85in" y="4.38in" width="0.09in" height="0.10in" valueSource="CMS1500.1.1_1dNo" />
			</g>
			<g id="line11">
				<text x="1.05in" y="4.96in" width="2.20in" height="0.10in" valueSource="CMS1500.1.1_2Signature" />
				<text x="3.88in" y="4.96in" width="1.30in" height="0.10in" valueSource="CMS1500.1.1_2Date" />
				<text x="5.72in" y="4.97in" width="2.0in" height="0.10in" valueSource="CMS1500.1.1_3Signature" />
			</g>
			<g id="line12">
				<text x="0.62in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_4MM" />
				<text x="0.94in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_4DD" />
				<text x="1.25in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_4YY" />
				<text x="3.94in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_5MM" />
				<text x="4.25in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_5DD" />
				<text x="4.56in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_5YY" />
				<text x="5.58in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_6StartMM" />
				<text x="5.86in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_6StartDD" />
				<text x="6.18in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_6StartYY" />
				<text x="6.89in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_6EndMM" />
				<text x="7.19in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_6EndDD" />
				<text x="7.49in" y="5.32in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_6EndYY" />
			</g>
			<g id="line13">
				<text x="0.57in" y="5.61in" width="2.61in" height="0.10in" valueSource="CMS1500.1.1_7Referring" />
				<text x="3.30in" y="5.47in" width="0.24in" height="0.10in" valueSource="CMS1500.1.1_7aQualifier" />
				<text x="3.51in" y="5.47in" width="1.75in" height="0.10in" valueSource="CMS1500.1.1_7aID" />
				<text x="3.51in" y="5.62in" width="1.75in" height="0.10in" valueSource="CMS1500.1.1_7bNPI" />
				<text x="5.58in" y="5.62in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_8StartMM" />
				<text x="5.86in" y="5.62in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_8StartDD" />
				<text x="6.18in" y="5.62in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_8StartYY" />
				<text x="6.89in" y="5.62in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_8EndMM" />
				<text x="7.19in" y="5.62in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_8EndDD" />
				<text x="7.49in" y="5.62in" width="0.30in" height="0.10in" valueSource="CMS1500.1.1_8EndYY" />
			</g>
			<g id="line14">
				<text x="0.57in" y="5.91in" width="4.66in" height="0.10in" valueSource="CMS1500.1.1_9Local" />
				<text x="5.38in" y="5.91in" width="0.09in" height="0.10in" valueSource="CMS1500.1.2_0Yes" />
				<text x="5.86in" y="5.91in" width="0.09in" height="0.10in" valueSource="CMS1500.1.2_0No" />
				<text x="6.32in" y="5.91in" width="0.80in" height="0.10in" valueSource="CMS1500.1.2_0Dollars" class="money" />
				<text x="7.11in" y="5.91in" width="0.30in" height="0.10in" valueSource="CMS1500.1.2_0Cents" />
			</g>
			<g id="box21">
				<text x="0.74in" y="6.21in" width="0.70in" height="0.10in" valueSource="CMS1500.1.2_1Diag1" />
				<text x="0.74in" y="6.52in" width="0.70in" height="0.10in" valueSource="CMS1500.1.2_1Diag2" />
				<text x="3.30in" y="6.21in" width="0.70in" height="0.10in" valueSource="CMS1500.1.2_1Diag3" />
				<text x="3.30in" y="6.52in" width="0.70in" height="0.10in" valueSource="CMS1500.1.2_1Diag4" />
			</g>
			<g id="line15">
				<text x="5.19in" y="6.21in" width="1.10in"  height="0.10in" valueSource="CMS1500.1.2_2Code" />
				<text x="6.27in" y="6.21in" width="1.80in" height="0.10in" valueSource="CMS1500.1.2_2Number" />
			</g>
			<g id="line16">
				<text x="5.19in" y="6.52in" width="2.93in" height="0.10in" valueSource="CMS1500.1.2_3PriorAuth" />
			</g>
			<g id="line17">
				<text x="0.57in" y="8.96in" width="1.31in" height="0.10in" valueSource="CMS1500.1.2_5ID" />
				<text x="2.09in" y="8.96in" width="0.10in" height="0.10in" valueSource="CMS1500.1.2_5SSN" />
				<text x="2.28in" y="8.96in" width="0.10in" height="0.10in" valueSource="CMS1500.1.2_5EIN" />
				<text x="2.62in" y="8.96in" width="1.41in" height="0.10in" valueSource="CMS1500.1.2_6Account" />
				<text x="4.07in" y="8.96in" width="0.10in" height="0.10in" valueSource="CMS1500.1.2_7Yes" />
				<text x="4.55in" y="8.96in" width="0.10in" height="0.10in" valueSource="CMS1500.1.2_7No" />
				<text x="5.25in" y="8.96in" width="0.65in" height="0.10in" valueSource="CMS1500.1.2_8Dollars" class="money" />
				<text x="5.91in" y="8.96in" width="0.33in" height="0.10in" valueSource="CMS1500.1.2_8Cents" />
				<text x="6.30in" y="8.96in" width="0.56in" height="0.10in" valueSource="CMS1500.1.2_9Dollars" class="money" />
				<text x="6.84in" y="8.96in" width="0.33in" height="0.10in" valueSource="CMS1500.1.2_9Cents" />
				<text x="7.13in" y="8.96in" width="0.56in" height="0.10in" valueSource="CMS1500.1.3_0Dollars" class="money" />
				<text x="7.69in" y="8.96in" width="0.33in" height="0.10in" valueSource="CMS1500.1.3_0Cents" />
			</g>
			<!-- Insert the procedure rows -->
			<xsl:call-template name="CreateProcedureLayout">
				<xsl:with-param name="totalProcedures" select="$ProcedureCount"/>
				<xsl:with-param name="currentProcedure" select="1"/>
				<xsl:with-param name="currentProcedureLine" select="1"/>
			</xsl:call-template>
			<g id="box31">
				<text x="0.57in" y="9.47in" width="2.08in" height="0.10in" valueSource="CMS1500.1.3_1Signature" />
				<text x="0.57in" y="9.61in" width="2.08in" height="0.10in" valueSource="CMS1500.1.3_1ProviderName" />
				<text x="0.95in" y="9.75in" width="1.0in" height="0.10in" valueSource="CMS1500.1.3_1Date" />
			</g>
			<g id="box32">
				<text x="2.62in" y="9.24in" width="2.62in" height="0.10in" valueSource="CMS1500.1.3_2Name" />
				<text x="2.62in" y="9.38in" width="2.62in" height="0.10in" valueSource="CMS1500.1.3_2Street" />
				<text x="2.62in" y="9.52in" width="2.62in" height="0.10in" valueSource="CMS1500.1.3_2CityStateZip" />
				<text x="2.72in" y="9.73in" width="1.04in" height="0.10in" valueSource="CMS1500.1.3_2aNPI" />
				<text x="3.79in" y="9.73in" width="1.50in" height="0.10in" valueSource="CMS1500.1.3_2bOtherID" />
			</g>
			<g id="box33">
				<text x="6.72in" y="9.14in" width="0.40in" height="0.10in" valueSource="CMS1500.1.3_3Area" class="smaller" />
				<text x="7.06in" y="9.14in" width="1.04in" height="0.10in" valueSource="CMS1500.1.3_3Phone" class="smaller" />
				<text x="5.18in" y="9.23in" width="2.86in" height="0.10in" valueSource="CMS1500.1.3_3Name" class="smaller" />
				<text x="5.18in" y="9.35in" width="2.86in" height="0.10in" valueSource="CMS1500.1.3_3Street" class="smaller" />
				<text x="5.18in" y="9.47in" width="2.86in" height="0.10in" valueSource="CMS1500.1.3_3CityStateZip" class="smaller" />
				<text x="5.29in" y="9.74in" width="1.04in" height="0.10in" valueSource="CMS1500.1.3_3PIN" class="smaller" />
				<text x="6.35in" y="9.74in" width="1.74in" height="0.10in" valueSource="CMS1500.1.3_3GRP" class="smaller" />
			</g>
		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 80