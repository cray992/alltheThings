------------------------------------------------------------------------------------------------------------------------------------
-- Case 11101: Correct DPI issues.
------------------------------------------------------------------------------------------------------------------------------------

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
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
		<xsl:variable name="xOffset" select="1.875"/>
		<xsl:variable name="yTopOffset" select="2.13"/>
		<xsl:variable name="yOffset" select=".140625"/>
		<xsl:variable name="codeXOffset" select=".03"/>
		<xsl:variable name="descriptionXOffset" select=".350"/>
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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" style="fill:black" font-family="Arial" font-weight="bold" font-size="8pt" />

					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".30in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" font-family="Arial Narrow" font-size="7pt" />

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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".30in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>

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

	<xsl:template name="DrawHorLines">
		<xsl:param name="yOffset"/>
		<xsl:param name="maximumRows"/>
		<xsl:param name="currentRow" select="1"/>

		<xsl:if test="$maximumRows >= $currentRow">

			<line x1="0.5in" y1="{$yOffset + .140625 * ($currentRow)}in"
          x2="8in" y2="{$yOffset + .140625 * ($currentRow)}in"
          style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>

			<xsl:call-template name="DrawHorLines">
				<xsl:with-param name="yOffset" select="$yOffset"/>
				<xsl:with-param name="maximumRows" select="$maximumRows"/>
				<xsl:with-param name="currentRow" select="$currentRow+1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="DrawVertLines">
		<xsl:param name="xOffset"/>
		<xsl:param name="yOffset"/>
		<xsl:param name="height"/>
		<xsl:param name="maximumCols"/>
		<xsl:param name="currentCol" select="0"/>

		<xsl:if test="$maximumCols > $currentCol">

			<line x1="{$xOffset+($currentCol)*1.875}in" y1="{$yOffset}in"
          x2="{$xOffset+($currentCol)*1.875}in" y2="{$yOffset +$height}in"
          style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>

			<xsl:call-template name="DrawVertLines">
				<xsl:with-param name="xOffset" select="$xOffset"/>
				<xsl:with-param name="yOffset" select="$yOffset"/>
				<xsl:with-param name="height" select="$height"/>
				<xsl:with-param name="maximumCols" select="$maximumCols"/>
				<xsl:with-param name="currentCol" select="$currentCol+1"/>
			</xsl:call-template>
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

					text.ralignedtext
					{
					text-anchor: end;
					}

					text.centeredtext
					{
					text-anchor: middle;
					}
				</style>
			</defs>

			<g id="PracticeInformation">
				<xsl:variable name="practiceName" select="concat(data[@id=''EncounterForm.1.Provider1''], '' - '', data[@id=''EncounterForm.1.PracticeName1''])"/>
				<xsl:variable name="fullAddress" select="concat(data[@id=''EncounterForm.1.PracticeAddress1''], '' '', data[@id=''EncounterForm.1.PracticeAddress2''], '' - '', data[@id=''EncounterForm.1.PracticeCityStateZip1''], '' '', data[@id=''EncounterForm.1.PracticePhoneFax1''])"/>

				<text x="4.25in" y="0.5in" font-family="Arial" font-weight="bold" font-size="12pt" class="centeredtext">
					<xsl:value-of select="$practiceName"/>
				</text>

				<text x="4.25in" y="0.7in" font-family="Arial Narrow" font-size="9pt" class="centeredtext">
					<xsl:value-of select="$fullAddress"/>
				</text>
			</g>

      <g id="PatientBox">
        <rect x="0.50in" y="0.93in" width="3.71875in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.50in" y="0.93in" width="3.71875in" height="1.01in" fill="none" stroke="black" stroke-width="0.5pt"/>
        <text x="0.55in" y="0.935in" font-family="Arial" font-weight="bold" font-size="7pt">PATIENT</text>

        <!-- Left captions -->
        <text x="1.07in" y="1.11in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">NAME:</text>
        <text x="1.07in" y="1.245in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">ADDRESS:</text>
        <text x="1.07in" y="1.38in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">HOME:</text>
        <text x="1.07in" y="1.515in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PRIMARY:</text>
        <text x="1.07in" y="1.65in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">COPAY/DED.:</text>
        <text x="1.07in" y="1.785in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">SECONDARY:</text>

        <!-- Right captions-->
        <text x="3.10in" y="1.38in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">WORK:</text>
        <text x="3.10in" y="1.515in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DOB/AGE:</text>
        <text x="3.10in" y="1.65in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">GENDER:</text>
        <text x="3.10in" y="1.785in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">GUARANTOR:</text>

        <!-- Fields -->
        <xsl:variable name="patNameID" select="concat(data[@id=''EncounterForm.1.PatientName1''], '' ('', data[@id=''EncounterForm.1.PatientID1''], '')'' )"/>
        <xsl:variable name="patFullAddress" select="concat(data[@id=''EncounterForm.1.AddressLine11''], '' '', data[@id=''EncounterForm.1.AddressLine21''], '', '', data[@id=''EncounterForm.1.CityStateZip1''])"/>
        <xsl:variable name="patCopayDed" select="concat(data[@id=''EncounterForm.1.Copay1''], '' / '', data[@id=''EncounterForm.1.Deductible1''])"/>
        <xsl:variable name="patDOBAge" select="data[@id=''EncounterForm.1.DOBAge1'']"/>

        <!-- Fields Left column -->
        <text x="1.10in" y="1.045in" width="3.0in" height="0.2in" font-family="Arial Narrow" font-weight="bold" font-size="11pt">
          <xsl:value-of select="$patNameID"/>
        </text>

        <text x="1.10in" y="1.225in" width="3.0in" height="0.15in" font-family="Arial Narrow" font-size="8pt">
          <xsl:value-of select="$patFullAddress"/>
        </text>

        <text x="1.10in" y="1.36in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.HomePhone1"/>

        <text x="1.10in" y="1.495in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PrimaryIns1"/>

        <text x="1.10in" y="1.63in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt">
          <xsl:value-of select="$patCopayDed"/>
        </text>

        <text x="1.10in" y="1.765in" width="1.36in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.SecondaryIns1"/>

        <!-- Fields Right column -->
        <text x="3.13in" y="1.36in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.WorkPhone1"/>

        <text x="3.13in" y="1.495in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt">
          <xsl:value-of select="$patDOBAge"/>
        </text>

        <text x="3.13in" y="1.63in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.Gender1"/>

        <text x="3.13in" y="1.765in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.ResponsiblePerson1"/>
      </g>

      <g id="VisitBox">
        <rect x="4.28125in" y="0.93in" width="3.71875in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="4.28125in" y="0.93in" width="3.71875in" height="1.01in" fill="none" stroke="black" stroke-width="0.5pt"/>
        <text x="4.33125in" y="0.935in" font-family="Arial" font-weight="bold" font-size="7pt">VISIT</text>

        <!-- Left captions -->
        <text x="4.85125in" y="1.11in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PROVIDER:</text>
        <text x="4.85125in" y="1.245in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DATE/TIME:</text>
        <text x="4.85125in" y="1.38in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">LOCATION:</text>
        <text x="4.85125in" y="1.515in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">REFER.:</text>
        <text x="4.85125in" y="1.65in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">CASE:</text>
        <text x="4.85125in" y="1.785in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">SCENARIO:</text>

        <!-- Right captions-->
        <text x="6.88125in" y="1.245in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">TICKET #:</text>
        <text x="6.88125in" y="1.38in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">REASON:</text>
        <text x="6.88125in" y="1.515in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PCP:</text>
        <text x="6.88125in" y="1.65in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">INJURY DATE:</text>
        <text x="6.88125in" y="1.785in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">INJURY PLACE:</text>

        <!-- Fields Left column -->
        <text x="4.88125in" y="1.075in" width="3.14in" height="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="9pt" valueSource="EncounterForm.1.Provider1"/>
        <text x="4.88125in" y="1.225in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.AppDateTime1"/>
        <text x="4.88125in" y="1.36in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.POS1"/>
        <text x="4.88125in" y="1.495in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PatCaseRefPhys1"/>
        <text x="4.88125in" y="1.63in" width="1.31in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PatientCase1"/>
        <text x="4.88125in" y="1.765in" width="1.31in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PatientCaseScenario1"/>

        <!-- Fields Right column -->
        <text x="6.91125in" y="1.225in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.TicketNumber1"/>
        <text x="6.91125in" y="1.36in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.Reason1"/>
        <text x="6.91125in" y="1.495in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PCP1"/>
        <text x="6.91125in" y="1.63in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.InjuryDate1"/>
        <text x="6.91125in" y="1.765in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.InjuryPlace1"/>
      </g>

			<g id="ProcedureDetails">
				<rect x="0.50in" y="2.000in" width="7.5in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
				<!-- <rect x="0.50in" y="2.000in" width="7.50in" height="1.01in" fill="none" stroke="black"/> -->
				<text x="0.55in" y="2.005in" font-family="Arial" font-weight="bold" font-size="7pt">PROCEDURES</text>

				<xsl:call-template name="CreateProcedureColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="55"/>
					<xsl:with-param name="maximumColumns" select="4"/>
					<xsl:with-param name="totalElements" select="$ProcedureCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>

			<!-- Draw the lines for Procedure Codes-->
			<xsl:call-template name="DrawHorLines">
				<xsl:with-param name="yOffset" select="2.125"/>
				<xsl:with-param name="maximumRows" select="55"/>
			</xsl:call-template>

			<xsl:call-template name="DrawVertLines">
				<xsl:with-param name="xOffset" select="0.5"/>
				<xsl:with-param name="yOffset" select="2.125"/>
				<xsl:with-param name="height" select="7.736215"/>
				<xsl:with-param name="maximumCols" select="5"/>
			</xsl:call-template>

			<xsl:call-template name="DrawVertLines">
				<xsl:with-param name="xOffset" select="0.8125"/>
				<xsl:with-param name="yOffset" select="2.125"/>
				<xsl:with-param name="height" select="7.736125"/>
				<xsl:with-param name="maximumCols" select="4"/>
			</xsl:call-template>

      <g id="ReturnScheduleBox">
        <rect x="0.50in" y="9.925in" width="1.84375in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.50in" y="9.925in" width="1.84375in" height="0.500in" fill="none" stroke="black"/>
        <text x="0.55in" y="9.93in" font-family="Arial" font-weight="bold" font-size="7pt">RETURN SCHEDULE</text>

        <text x="0.66in" y="10.10in" width="1.751in" height="0.500in" font-family="Arial" font-weight="bold" font-size="7pt">1      2      3      4      5      6      7</text>
        <text x="0.66in" y="10.25in" width="1.751in" height="0.500in" font-family="Arial" font-weight="bold" font-size="7pt">D       W       M       Y    PRN_____</text>
      </g>

      <g id="AccountStatusBox">
        <rect x="2.40625in" y="9.925in" width="1.8125in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="2.40625in" y="9.925in" width="1.8125in" height="0.500in" fill="none" stroke="black"/>
        <text x="2.45625in" y="9.93in" font-family="Arial" font-weight="bold" font-size="7pt">ACCOUNT STATUS</text>

        <text x="2.56625in" y="10.085in" width="1.751in" height="0.500in" font-family="Arial Narrow" font-size="7pt"></text>
      </g>

      <g id="AccountActivityBox">
        <rect x="4.28125in" y="9.925in" width="1.8125in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="4.28125in" y="9.925in" width="1.8125in" height="0.500in" fill="none" stroke="black"/>
        <text x="4.33125in" y="9.93in" font-family="Arial" font-weight="bold" font-size="7pt">ACCOUNT ACTIVITY</text>

        <text x="5.18125in" y="10.10in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PRIOR BALANCE:</text>
        <text x="5.18125in" y="10.25in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">TODAY''S CHARGES:</text>

        <text x="5.21125in" y="10.08in" width="0.75in" height="0.1in"  font-family="Arial Narrow" font-weight="bold" font-size="8pt" valueSource="EncounterForm.1.PatientBalance1"/>
      </g>

      <g id="PaymentOnAccountBox">
        <rect x="6.15625in" y="9.925in" width="1.84375in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="6.15625in" y="9.925in" width="1.84375in" height="0.500in" fill="none" stroke="black"/>
        <text x="6.20625in" y="9.93in" font-family="Arial" font-weight="bold" font-size="7pt">PAYMENT ON ACCOUNT</text>

        <circle cx="6.24625in" cy="10.17in" r="0.03in" fill="none" stroke="black" />
        <circle cx="6.24625in" cy="10.32in" r="0.03in" fill="none" stroke="black" />
        <circle cx="6.67625in" cy="10.17in" r="0.03in" fill="none" stroke="black" />

        <text x="6.30625in" y="10.10in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" >CHECK</text>
        <text x="6.30625in" y="10.25in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" >CREDIT CARD</text>
        <text x="6.73625in" y="10.10in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" >CASH</text>

        <line x1="7.03125in" y1="10.05in" x2="7.03125in" y2="10.425in" stroke="black" stroke-width="0.5pt"/>

        <text x="7.50625in" y="10.10in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DUE:</text>
        <text x="7.50625in" y="10.25in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PAYMENT:</text>
      </g>
      
		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 27