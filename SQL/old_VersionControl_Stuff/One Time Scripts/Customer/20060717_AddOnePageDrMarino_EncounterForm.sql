---------------------------------------------------------------------------------------------------------
-- Case 12547: Implement a one page customized encounter form for Dr. Marino, a provider of customer 285. 
---------------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 285
IF charindex('_0285_', db_name()) > 0
BEGIN

INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (25, 'One Page Dr. Marino', 'Encounter form that prints on a single page', 25)

INSERT INTO PrintingFormDetails
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES
	(29, 9, 28, 'One Page Dr. Marino', 1)

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
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

		<xsl:variable name="xLeftOffset" select="0.5"/>
		<xsl:variable name="yTopOffset" select="1.77"/>
		<xsl:variable name="yOffset" select=".15625"/>
		<xsl:variable name="lineWidth" select="7.5"/>
		<xsl:variable name="headerYOffset" select="0.01"/>
		<xsl:variable name="descriptioncodeXOffset" select=".02"/>
		<xsl:variable name="feeXOffset" select="1.77"/>
		<xsl:variable name="moddxXOffset" select="2.145"/>

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
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 1.75}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 1.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.125}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 2.125}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.3125}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 2.3125}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.50}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 2.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.25}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 4.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.625}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 4.625}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.8125}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 4.8125}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.00}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 5.00}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 6.75}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 6.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.125}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 7.125}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.3125}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + 7.3125}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $descriptioncodeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" font-family="Arial" font-weight="bold" font-size="7pt">PROCEDURES</text>

			<!-- Add headers -->
			<text x="{$xLeftOffset + $descriptioncodeXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="1.75in" height="0.1in">DESCRIPTION/CODE</text>
			<text x="{$xLeftOffset + $feeXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".375in" height="0.1in">FEE</text>
			<text x="{$xLeftOffset + $moddxXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".375in" height="0.1in">MOD/DX</text>
			<text x="{$xLeftOffset + $descriptioncodeXOffset + 2.5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="1.75in" height="0.1in">DESCRIPTION/CODE</text>
			<text x="{$xLeftOffset + $feeXOffset + 2.5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".375in" height="0.1in">FEE</text>
			<text x="{$xLeftOffset + $moddxXOffset + 2.5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".375in" height="0.1in">MOD/DX</text>
			<text x="{$xLeftOffset + $descriptioncodeXOffset + 5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="1.75in" height="0.1in">DESCRIPTION/CODE</text>
			<text x="{$xLeftOffset + $feeXOffset + 5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".375in" height="0.1in">FEE</text>
			<text x="{$xLeftOffset + $moddxXOffset + 5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".375in" height="0.1in">MOD/DX</text>
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

		<xsl:variable name="xLeftOffset" select="0.5"/>
		<xsl:variable name="xOffset" select="2.5"/>
		<xsl:variable name="yTopOffset" select="1.27"/>
		<xsl:variable name="yOffset" select=".15625"/>
		<xsl:variable name="codeXOffset" select="1.47"/>
		<xsl:variable name="descriptionXOffset" select=".02"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeWidth" select=".27"/>
		<xsl:variable name="descriptionWidth" select="1.45"/>

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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.1in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" class="bold" />

					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

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
					stroke-dasharray: 2, 2;
					stroke-width: 0.0069in;
					}

					text.centeredtext
					{
					font-size: 9pt;
					text-anchor: middle;
					}

					text.ralignedtext
					{
					text-anchor: end;
					}

					text.header
					{
					font-weight: bold;
					font-size: 12pt;
					text-anchor: middle;
					}

				</style>
			</defs>

			<g>

        <g id="PatientInfo">
          <text x="0.55in" y="0.70in" font-family="Arrial Narrow" font-size="7pt">Ins. Company</text>
          <line x1="1.20in" y1="0.82in" x2="3.26in" y2="0.82in" stroke="black"></line>
          <text x="1.23in" y="0.70in" width="2.00in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.PrimaryIns1"></text>
          <text x="0.55in" y="0.85in" font-family="Arrial Narrow" font-size="7pt">Medicare- Routine procedures:</text>
          <rect x="1.98in" y="0.86in" width="0.10in" height="0.11in" fill="rgb(255, 255, 255)" stroke="black" stroke-width="0.5pt"/>
          <text x="2.11in" y="0.85in" font-family="Arrial Narrow" font-size="7pt">**ABN Signed</text>
          <text x="0.55in" y="1.00in" font-family="Arrial Narrow" font-size="7pt">DOB:</text>
          <line x1="0.83in" y1="1.12in" x2="1.83in" y2="1.12in" stroke="black"></line>
          <text x="0.86in" y="1.00in" width="0.94in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.DOBAge1"></text>
          <rect x="1.98in" y="1.02in" width="0.10in" height="0.11in" fill="rgb(255, 255, 255)" stroke="black" stroke-width="0.5pt"/>
          <text x="2.11in" y="1.00in" font-family="Arrial Narrow" font-size="7pt">New Patient</text>
          <text x="0.52in" y="1.15in" font-family="Arrial Narrow" font-size="7pt">Patient:</text>
          <line x1="0.96in" y1="1.27in" x2="3.52in" y2="1.27in" stroke="black"></line>
          <text x="0.99in" y="1.15in" width="2.50in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.PatientName1"></text>
        </g>

        <g id="PracticeInfo">
          <text x="3.37in" y="0.50in" width="2.50in" height="0.10in" font-family="Arial" font-size="12pt" font-weight="bold" valueSource="EncounterForm.1.PracticeName1" />
          <text x="3.50in" y="0.70in" width="2.50in" height="0.10in" font-family="Arial Narrow" font-size="9pt"  valueSource="EncounterForm.1.PracticeAddress1" />
          <text x="3.63in" y="0.85in" width="2.50in" height="0.10in" font-family="Arial Narrow" font-size="9pt"  valueSource="EncounterForm.1.PracticePhoneFax1" />
        </g>

        <g id="VisitInfo">
          <text x="3.75in" y="1.15in" font-family="Arrial Narrow" font-size="7pt">Date:</text>
          <line x1="4.02in" y1="1.27in" x2="6.03in" y2="1.27in" stroke="black"></line>

          <xsl:variable name="patAppDate" select="concat(substring(data[@id=''EncounterForm.1.AppDateTime1''], 1, 2), ''/'', substring(data[@id=''EncounterForm.1.AppDateTime1''], 4, 2), ''/'', substring(data[@id=''EncounterForm.1.AppDateTime1''], 7, 4))"/>

          <text x="4.05in" y="1.15in" width="1.75in" height="0.1in" font-family="Arial Narrow" font-size="7pt">
            <xsl:value-of select="$patAppDate"/>
          </text>

          <text x="6.20in" y="0.43in" font-family="Arrial Narrow" font-size="6pt">Co-Pay:</text>
          <line x1="6.64in" y1="0.54in" x2="7.68in" y2="0.54in" stroke="black"></line>
          <text x="6.59in" y="0.42in" width="0.98in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.Copay1"></text>
          <text x="6.20in" y="0.58in" font-family="Arrial Narrow" font-size="6pt">Paid:     Cash     CC</text>
          <line x1="6.98in" y1="0.69in" x2="7.22in" y2="0.69in" stroke="black"></line>
          <text x="7.25in" y="0.58in" font-family="Arrial Narrow" font-size="6pt">Check #</text>
          <line x1="7.61in" y1="0.69in" x2="8.00in" y2="0.69in" stroke="black"></line>
          <text x="6.20in" y="0.73in" font-family="Arrial Narrow" font-size="6pt">Other</text>
          <line x1="6.45in" y1="0.84in" x2="8.0in" y2="0.84in" stroke="black"></line>
          <line x1="6.20in" y1="0.97in" x2="8.0in" y2="0.97in" stroke="black"></line>
          <text x="6.20in" y="1.00in" font-family="Arrial Narrow" font-size="7pt">Arrival Time:</text>
          <line x1="6.80in" y1="1.12in" x2="7.83in" y2="1.12in" stroke="black"></line>
          <text x="6.20in" y="1.15in" font-family="Arrial Narrow" font-size="7pt">Appointment Time:</text>
          <line x1="7.10in" y1="1.27in" x2="7.91in" y2="1.27in" stroke="black"></line>

          <xsl:variable name="patAppTime" select="substring(data[@id=''EncounterForm.1.AppDateTime1''], 12)"/>

          <text x="7.13in" y="1.15in" width="0.75in" height="0.1in" font-family="Arial Narrow" font-size="7pt">
            <xsl:value-of select="$patAppTime"/>
          </text>
        </g>

      </g>

			<g id="ProceduresGrid">
				<xsl:call-template name="CreateProceduresGridLines">
					<xsl:with-param name="maximumRows" select="50"/>
					<xsl:with-param name="currentRow" select="1"/>
				</xsl:call-template>
			</g>

			<g id="ProceduresDetails">
				<xsl:call-template name="CreateProceduresColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="50"/>
					<xsl:with-param name="maximumColumns" select="3"/>
					<xsl:with-param name="totalElements" select="$ProceduresCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>

      <g id="NextAppointment">
        <rect x="5.50in" y="8.80125in" width="2.50in" height="0.625in" fill="rgb(255, 255, 255)" stroke="black" stroke-width="0.5pt" />
        <text x="5.51in" y="8.79125in" font-family="Arial" font-weight="bold" font-size="7pt">NEXT APPOINTMENT:</text>
      </g>
      
      <g id="Modifiers">
        <rect x="0.50in" y="9.48in" width="2.75in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
        <text x="0.90in" y="9.48in" font-family="Arial" font-weight="bold" font-size="7pt">Modifiers</text>
        <line x1="3.25in" y1="9.605in" x2="3.25in" y2="10.71in" stroke="black" stroke-width="1.5pt"></line>
        <text x="0.52in" y="9.63in" font-family="Courier" font-size="6pt">-22 Unusual Services-greater than normally required</text>
        <text x="0.52in" y="9.75in" font-family="Courier" font-size="6pt">-24 Unrelated E&amp;M During Post op period</text>
        <text x="0.52in" y="9.87in" font-family="Courier" font-size="6pt">-25 Seperately identifiable E&amp;M Same Day of Procedure</text>
        <text x="0.52in" y="9.99in" font-family="Courier" font-size="6pt">-26 Professional Component</text>
        <text x="0.52in" y="10.11in" font-family="Courier" font-size="6pt">-50 Bilateral Procedure</text>
        <text x="0.52in" y="10.23in" font-family="Courier" font-size="6pt">-57 Decision for Surgery</text>
        <text x="0.52in" y="10.35in" font-family="Courier" font-size="6pt">-59 Distinct Service on Same Day</text>
        <text x="0.52in" y="10.47in" font-family="Courier" font-size="6pt">-99 Multiple Modifiers</text>
        <text x="0.52in" y="10.59in" font-family="Courier" font-size="6pt">(*) = starred procedure, seperately payable</text>
      </g>

      <g id="Diagnosis">
        <rect x="3.25in" y="9.48in" width="2.00in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
        <text x="3.55in" y="9.48in" font-family="Arial" font-weight="bold" font-size="7pt">ICD 9 Diagnosis</text>
        <line x1="5.25in" y1="9.605in" x2="5.25in" y2="10.71in" stroke="black" stroke-width="1.5pt"></line>
        <text x="3.27in" y="9.63in" font-family="Courier" font-size="6pt">1:</text>
        <line x1="3.37in" y1="9.73in" x2="4.12in" y2="9.73in" stroke="black"></line>
        <text x="3.27in" y="9.78in" font-family="Courier" font-size="6pt">2:</text>
        <line x1="3.37in" y1="9.88in" x2="4.12in" y2="9.88in" stroke="black"></line>
        <text x="4.22in" y="9.63in" font-family="Courier" font-size="6pt">3:</text>
        <line x1="4.32in" y1="9.73in" x2="5.05in" y2="9.73in" stroke="black"></line>
        <text x="4.22in" y="9.78in" font-family="Courier" font-size="6pt">4:</text>
        <line x1="4.32in" y1="9.88in" x2="5.05in" y2="9.88in" stroke="black"></line>
        <line x1="3.25in" y1="10.08in" x2="5.03in" y2="10.08in" stroke="black"></line>
        <line x1="3.25in" y1="10.26in" x2="5.07in" y2="10.26in" stroke="black"></line>
        <line x1="3.25in" y1="10.44in" x2="5.11in" y2="10.44in" stroke="black"></line>
      </g>

      <g id="OfficeUse">
        <rect x="5.25in" y="9.48in" width="2.75in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
        <text x="5.88in" y="9.48in" font-family="Arial" font-weight="bold" font-size="7pt">For Office Use Only</text>
        <text x="5.33in" y="9.63in" font-family="Courier" font-size="6pt">I acknowledge receipt of medical services and authorize</text>
        <text x="5.30in" y="9.78in" font-family="Courier" font-size="6pt">the release of any medical information necessary to process</text>
        <text x="5.30in" y="9.93in" font-family="Courier" font-size="6pt">this claim for health care payment</text>
        <text x="5.30in" y="10.28in" font-family="Courier" font-size="6pt">Signed:</text>
        <line x1="5.60in" y1="10.38in" x2="7.56in" y2="10.38in" stroke="black"></line>
        <line x1="5.30in" y1="10.56in" x2="5.42in" y2="10.56in" stroke="black"></line>
        <text x="5.45in" y="10.46in" font-family="Courier" font-size="6pt">Seen by Nurse Practitioner</text>
        <text x="6.97in" y="10.46in" font-family="Courier" font-size="7pt">N     E</text>
      </g>
      
		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 29

END