update PrintingFormDetails set SVGDefinition=
'<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />

  <!--  
        Takes in the number of rows to draw the dotted horizontal lines for.
        
        Parameters:
        maximumRows - max number of rows allowed in a column
        currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)   
  -->
  
	<xsl:template name="CreateProceduresGridLines">

		<xsl:param name="maximumRows"/>
		<xsl:param name="currentRow"/>

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="yTopOffset" select="1.98"/>
		<xsl:variable name="yOffset" select="0.15625"/>
		<xsl:variable name="lineWidth" select="7.50"/>
		<xsl:variable name="headerYOffset" select="0.01"/>
		<xsl:variable name="descriptioncodeXOffset" select="0.02"/>
		<xsl:variable name="feeXOffset" select="2.29"/>

		<xsl:if test="$maximumRows >= $currentRow">
			<!-- Creates the actual horizontal line for the row -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Calls the same template recursively -->
			<xsl:call-template name="CreateProceduresGridLines">
				<xsl:with-param name="maximumRows" select="$maximumRows"/>
				<xsl:with-param name="currentRow" select="$currentRow + 1"/>
			</xsl:call-template>
		</xsl:if>
    
		<xsl:if test="$maximumRows = $currentRow">
			<!-- Print the top horizontal dotted line -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset - $yOffset}in" />

			<!-- Print the vertical lines -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - 0.01 - $yOffset * 2}in" x2="{$xLeftOffset}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.25}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 2.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.50}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 2.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.75}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 4.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.00}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 5.00}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.25}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 7.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - 0.01 - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $descriptioncodeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="7.50in" height="0.10in" font-family="Arial" font-weight="bold" text-anchor="middle">PROCEDURES</text>

			<!-- Add headers -->
			<text x="{$xLeftOffset + $descriptioncodeXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in">DESCRIPTION / CODE</text>
			<text x="{$xLeftOffset + $feeXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in">FEE</text>
			<text x="{$xLeftOffset + $descriptioncodeXOffset + 2.50}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in">DESCRIPTION / CODE</text>
			<text x="{$xLeftOffset + $feeXOffset + 2.50}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in">FEE</text>
			<text x="{$xLeftOffset + $descriptioncodeXOffset + 5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in">DESCRIPTION / CODE</text>
			<text x="{$xLeftOffset + $feeXOffset + 5.0}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in">FEE</text>
		</xsl:if>
	</xsl:template>

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

	<xsl:template name="CreateProceduresColumnLayout">

		<xsl:param name="maximumRowsInColumn"/>
		<xsl:param name="maximumColumns"/>
		<xsl:param name="totalElements"/>
		<xsl:param name="currentElement"/>
		<xsl:param name="currentRow"/>
		<xsl:param name="currentColumn"/>
		<xsl:param name="currentCategory" select="0"/>

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="xOffset" select="2.50"/>
		<xsl:variable name="yTopOffset" select="1.48"/>
		<xsl:variable name="yOffset" select="0.15625"/>
		<xsl:variable name="codeXOffset" select="1.93"/>
		<xsl:variable name="descriptionXOffset" select="0.02"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeWidth" select="0.35"/>
		<xsl:variable name="descriptionWidth" select="1.96"/>

		<xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
			<xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.ProcedureCategory'', $currentElement)]"/>

			<xsl:choose>
				<xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
					<!-- There isn''t enough room to print on this column -->

					<!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
					<xsl:call-template name="CreateProceduresColumnLayout">
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
          <rect x="{$xLeftOffset + $xOffset * ($currentColumn - 1)}in" y="{$yTopOffset + $descriptionYOffset + 0.003 + $yOffset * ($currentRow + 1)}in" width="2.50in" height="0.15625in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" class="bold" />

					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

					<!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
					<xsl:call-template name="CreateProceduresColumnLayout">
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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

					<!-- Calls the same template recursively -->
					<xsl:call-template name="CreateProceduresColumnLayout">
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

	<xsl:template match="/formData/page">
		<xsl:variable name="OtherDiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])"/>
		<xsl:variable name="ProceduresCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])"/>
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="300">
			<defs>
				<style type="text/css">
					g
					{
					font-family: Arial Narrow,Arial,Helvetica;
					font-size: 7pt;
					font-style: Normal;
					font-weight: Normal;
					alignment-baseline: text-before-edge;
					}

					text.bold
					{
					font-family: Arial,Arial Narrow,Helvetica;
					font-size: 8pt;
					font-style: Normal;
					font-weight: bold;
					alignment-baseline: text-before-edge;
					}

					text
					{
					baseline-shift: -100%;
					}

					g#ProceduresGrid line
					{
					stroke: black;
					}
          
          g line
          {
          stroke: black;
          }

				</style>
			</defs>

      <g id="InsuranceInfo">
        <rect x="0.50in" y="0.40in" width="7.50in" height="0.90in" fill="rgb(255, 255, 255)" stroke="black" stroke-width="1pt"/>
        <text x="0.55in" y="0.43in">Pri Ins:</text>
        <line x1="0.83in" y1="0.55in" x2="2.28in" y2="0.55in"></line>
        <text x="0.86in" y="0.43in" width="1.45in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1"></text>
        <text x="2.31in" y="1.13in">Copay Amount:</text>
        <text x="2.92in" y="1.13in" width="0.97in" height="0.10in" valueSource="EncounterForm.1.Copay1"></text>
        <text x="0.55in" y="0.57in">Number:</text>
        <line x1="0.90in" y1="0.69in" x2="2.28in" y2="0.69in"></line>
        <text x="0.93in" y="0.57in" width="1.38in" height="0.10in" valueSource="EncounterForm.1.PolicyNumber1"></text>
        <text x="0.55in" y="0.71in">2nd Ins:</text>
        <line x1="0.87in" y1="0.83in" x2="2.28in" y2="0.83in"></line>
        <text x="0.90in" y="0.71in" width="1.41in" height="0.10in" valueSource="EncounterForm.1.SecondaryIns1"></text>
        <text x="0.55in" y="0.85in">Number:</text>
        <line x1="0.90in" y1="0.97in" x2="2.28in" y2="0.97in"></line>
        <text x="0.93in" y="0.85in" width="1.38in" height="0.10in" valueSource="EncounterForm.1.SecondaryPolicyNumber1"></text>
        <text x="0.55in" y="0.99in">3rd Ins:</text>
        <line x1="0.87in" y1="1.11in" x2="2.28in" y2="1.11in"></line>
        <text x="0.90in" y="0.99in" width="1.41in" height="0.10in" valueSource="EncounterForm.1.TertiaryIns1"></text>
        <text x="0.55in" y="1.13in">Number:</text>
        <line x1="0.90in" y1="1.25in" x2="2.28in" y2="1.25in"></line>
        <text x="0.93in" y="1.13in" width="1.38in" height="0.10in" valueSource="EncounterForm.1.TertiaryPolicyNumber1"></text>
      </g>

      <g id="PatientInfo">
        <text x="0.55in" y="1.35in" font-size="8pt">Chart No.</text>
        <text x="0.99in" y="1.35in" width="0.9175in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.MedicalRecordNumber1"/>
        <text x="3.05in" y="1.35in" font-size="8pt">Pt. Name:</text>
        <text x="3.52in" y="1.35in" width="1.47in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.PatientName1"></text>
      </g>

      <g id="PracticeInfo">
        <text x="0.50in" y="0.40in" width="7.50in" height="0.10in" font-size="9pt" text-anchor="middle" valueSource="EncounterForm.1.PracticeName1" />
        <text x="0.50in" y="0.55in" width="7.50in" height="0.10in" font-size="8pt" text-anchor="middle" valueSource="EncounterForm.1.PracticeAddress1" />
        <text x="0.50in" y="0.70in" width="7.50in" height="0.10in" font-size="8pt" text-anchor="middle" valueSource="EncounterForm.1.PracticePhoneFax1" />
      </g>

      <g id="AppointmentInfo">
        <text x="6.10in" y="0.43in" font-size="8pt">Provider</text>
        <text x="6.50in" y="0.43in" width="1.50in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.Provider1"></text>
        <text x="5.55in" y="1.35in" font-size="8pt">Date of Visit:</text>

        <xsl:variable name="patAppDate" select="substring(data[@id=''EncounterForm.1.AppDateTime1''], 1, 10)"/>

        <text x="6.13in" y="1.35in" width="1.0in" height="0.10in" font-size="8pt">
          <xsl:value-of select="$patAppDate"/>
        </text>

        <xsl:variable name="patAppTime" select="substring(data[@id=''EncounterForm.1.AppDateTime1''], 12)"/>

        <text x="7.50in" y="1.35in" width="0.47in" height="0.10in" font-size="8pt">
          <xsl:value-of select="$patAppTime"/>
        </text>

        <text x="6.13in" y="1.13in">Visit #:</text>
        <line x1="6.41in" y1="1.25in" x2="7.20in" y2="1.25in"></line>
        <text x="6.44in" y="1.13in" width="0.79in" height="0.10in" valueSource="EncounterForm.1.TicketNumber1"></text>
      </g>

			<g id="ProceduresGrid">
				<xsl:call-template name="CreateProceduresGridLines">
					<xsl:with-param name="maximumRows" select="49"/>
					<xsl:with-param name="currentRow" select="1"/>
				</xsl:call-template>
			</g>

			<g id="ProceduresDetails">
				<xsl:call-template name="CreateProceduresColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="49"/>
					<xsl:with-param name="maximumColumns" select="3"/>
					<xsl:with-param name="totalElements" select="$ProceduresCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>

      <g id="FooterInfo">
        <rect x="0.50in" y="9.52in" width="7.50in" height="0.83in" fill="rgb(255, 255, 255)" stroke="black" stroke-width="0.5pt"/>
        <line x1="6.25in" y1="9.52in" x2="6.25in" y2="10.35in"></line>
        <text x="0.52in" y="9.55in" font-weight="bold">Diagnosis / ICD - 9</text>
        <line x1="0.50in" y1="9.76in" x2="6.25in" y2="9.76in"></line>
        <line x1="4.50in" y1="9.73in" x2="4.50in" y2="10.35in"></line>
        <text x="0.52in" y="9.79in">I acknowledge receipt of medical services and authorize the release of any medical information necessary to</text>
        <text x="0.52in" y="9.91in">process this claim for health care payment only.</text>
        <text x="0.55in" y="10.05in">I</text>
        <rect x="0.61in" y="10.06in" width="0.10in" height="0.11in" fill="rgb(255, 255, 255)" stroke="black" stroke-width="0.5pt"/>
        <text x="0.77in" y="10.05in">do</text>
        <rect x="0.89in" y="10.06in" width="0.10in" height="0.11in" fill="rgb(255, 255, 255)" stroke="black" stroke-width="0.5pt"/>
        <text x="1.05in" y="10.05in">do not   authorize payment to the provider</text>
        <text x="0.52in" y="10.19in">Patient Signature</text>
        <text x="4.51in" y="9.79in" font-size="8pt">Tax ID Number:</text>

        <xsl:variable name="practiceTaxID" select="substring(data[@id=''EncounterForm.1.PracticeTaxID1''], 9)"/>

        <text x="4.53in" y="9.94in" width="1.69in" height="0.10in" font-size="8pt" text-anchor="middle">
          <xsl:value-of select="$practiceTaxID"/>
        </text>

        <text x="6.27in" y="9.56in" font-size="8pt">Estimated</text>
        <text x="6.27in" y="9.68in" font-size="8pt">Charges:</text>
        <line x1="6.25in" y1="9.86in" x2="8.0in" y2="9.86in"></line>
        <text x="6.27in" y="9.89in">Cash Discount</text>
        <line x1="6.25in" y1="10.07in" x2="8.0in" y2="10.07in"></line>
        <text x="6.27in" y="10.06in" font-size="8pt">Payment</text>
        <text x="6.27in" y="10.16in" font-size="8pt">Amount:</text>
        <text x="4.25in" y="10.52in">VISA / MC / CASH / Check #</text>
        <line x1="5.33in" y1="10.64in" x2="6.17in" y2="10.64in"></line>
        <rect x="6.25in" y="10.50in" width="1.75in" height="0.20in" fill="rgb(255, 255, 255)" stroke="black" stroke-width="0.5pt"/>
        <text x="6.27in" y="10.52in">Copay Collected:</text>
      </g>
      
		</svg>
	</xsl:template>
</xsl:stylesheet>'
where PrintingFormDetailsID=67
