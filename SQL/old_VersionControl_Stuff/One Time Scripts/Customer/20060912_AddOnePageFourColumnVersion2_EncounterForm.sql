-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Case 13989: Implement a one page customized encounter form for First Choice Ankle & Foot Care Center, a practice of First Choice Ankle & Foot Care PLLC(Customer 554).
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 554
IF charindex('_0554_', db_name()) > 0
BEGIN

/*
INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (50, '1-Page, 4-Column Version 2', 'Encounter form that prints on a single page', 50)

INSERT INTO PrintingFormDetails (PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES (66, 9, 53, '1-Page, 4-Column Version 2', 1)
*/

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

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="yTopOffset" select="2.48"/>
		<xsl:variable name="yOffset" select="0.13625"/>
		<xsl:variable name="lineWidth" select="7.50"/>
		<xsl:variable name="headerYOffset" select="0.01"/>
		<xsl:variable name="codeXOffset" select="0.02"/>
		<xsl:variable name="descriptionXOffset" select="0.27"/>

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
			<line x1="{$xLeftOffset + 0.25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 1.875}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 1.875}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.125}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.125}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 3.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 3.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.0}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.0}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.625}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.625}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.875}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.875}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" font-family="Arial" font-weight="bold">PROCEDURES</text>

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
		<xsl:variable name="xOffset" select="1.875"/>
		<xsl:variable name="yTopOffset" select="1.90"/>
		<xsl:variable name="yOffset" select="0.13625"/>
		<xsl:variable name="codeXOffset" select="0.01"/>
		<xsl:variable name="descriptionXOffset" select="0.27"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeWidth" select="0.27"/>
		<xsl:variable name="descriptionWidth" select="1.64"/>

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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" class="bold" />

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

	<xsl:template name="CreateDiagnosesGridLines">

		<xsl:param name="maximumRows"/>
		<xsl:param name="currentRow"/>
		<xsl:param name="sectionHeader"/>

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="yTopOffset" select="6.33"/>
		<xsl:variable name="yOffset" select="0.13625"/>
		<xsl:variable name="lineWidth" select="7.50"/>
		<xsl:variable name="headerYOffset" select="0.01"/>
		<xsl:variable name="codeXOffset" select="0.02"/>
		<xsl:variable name="descriptionXOffset" select="0.29"/>

		<xsl:if test="$maximumRows >= $currentRow">
			<!-- Creates the actual horizontal line for the row -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Calls the same template recursively -->
			<xsl:call-template name="CreateDiagnosesGridLines">
				<xsl:with-param name="maximumRows" select="$maximumRows"/>
				<xsl:with-param name="currentRow" select="$currentRow + 1"/>
				<xsl:with-param name="sectionHeader" select="$sectionHeader"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$maximumRows = $currentRow">
			<!-- Print the top horizontal dotted line -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset - $yOffset}in" />

			<!-- Print the vertical lines -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 0.275}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.275}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 1.875}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 1.875}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.15}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.15}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 3.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 3.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.025}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.025}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.625}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.625}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.90}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.90}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" font-family="Arial" font-weight="bold">DIAGNOSES</text>

		</xsl:if>
	</xsl:template>

	<xsl:template name="CreateDiagnosesColumnLayout">

		<xsl:param name="maximumRowsInColumn"/>
		<xsl:param name="maximumColumns"/>
		<xsl:param name="totalElements"/>
		<xsl:param name="currentElement"/>
		<xsl:param name="currentRow"/>
		<xsl:param name="currentColumn"/>
		<xsl:param name="currentCategory" select="0"/>

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="xOffset" select="1.875"/>
		<xsl:variable name="yTopOffset" select="5.75"/>
		<xsl:variable name="yOffset" select="0.13625"/>
		<xsl:variable name="codeXOffset" select="0.01"/>
		<xsl:variable name="descriptionXOffset" select="0.29"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeWidth" select="0.30"/>
		<xsl:variable name="descriptionWidth" select="1.61"/>

		<xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
			<xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.DiagnosisCategory'', $currentElement)]"/>

			<xsl:choose>
				<xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
					<!-- There isn''t enough room to print on this column -->

					<!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
					<xsl:call-template name="CreateDiagnosesColumnLayout">
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
					<!-- category is not the same but there is enough room on this column so print out the category -->

					<!-- Creates the actual category line -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" class="bold" />

					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

					<!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
					<xsl:call-template name="CreateDiagnosesColumnLayout">
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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

					<!-- Calls the same template recursively -->
					<xsl:call-template name="CreateDiagnosesColumnLayout">
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
		<xsl:variable name="DiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])"/>
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

					g#DiagnosisGrid line
					{
					stroke: black;
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

			<!-- Practice Information -->
		  <g id ="PracticeInformation">
        <xsl:variable name="practiceAddress" select="concat(data[@id=''EncounterForm.1.FullPracticeName1''], '' '', data[@id=''EncounterForm.1.FullPracticeAddress1''])"/>

        <text x="0.54in" y="0.45in" width="7.50in" height="0.10in" font-size="8pt">
          <xsl:value-of select="$practiceAddress"/>
        </text>
			</g>

			<g id="PatientInformation">
				<rect x="0.50in" y="0.62in" width="7.50in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
				<text x="0.52in" y="0.62in" font-weight="bold">PATIENT INFORMATION</text>
				<line x1="3.0in" y1="0.745in" x2="3.0in" y2="2.0366in" stroke="black"></line>
			  <text x="0.51in" y="0.775in" font-size="5pt">PATIENT CONTACT</text>
        <text x="0.54in" y="0.855in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.PatientName1" class="bold"/>
        <text x="0.54in" y="0.985in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.AddressLine11"/>
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.54in" y="1.115in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.AddressLine21"/>
            <text x="0.54in" y="1.245in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1"/>
            <text x="0.54in" y="1.375in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.FullPhone1"/>
          </xsl:when>
          <xsl:otherwise>
            <text x="0.54in" y="1.115in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1"/>
            <text x="0.54in" y="1.245in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.FullPhone1"/>
          </xsl:otherwise>
        </xsl:choose>
        <line x1="0.50in" y1="1.7783in" x2="8.0in" y2="1.7783in" stroke="black"></line>
				<text x="0.51in" y="1.8083in" font-size="5pt">PATIENT ID</text>
				<text x="0.54in" y="1.8883in" width="1.21in" height="0.10in" valueSource="EncounterForm.1.PatientID1"/>
				<text x="1.76in" y="1.8083in" font-size="5pt">DATE OF BIRTH</text>
			  <text x="1.79in" y="1.8883in" width="1.21in" height="0.10in" valueSource="EncounterForm.1.DOBAge1"/>
        <line x1="0.50in" y1="2.0366in" x2="8.0in" y2="2.0366in" stroke="black"></line>
		  </g>

      <g id="AppointmentInformation">
        <text x="3.02in" y="0.62in" font-weight="bold">APPOINTMENT INFORMATION</text>
        <line x1="4.50in" y1="0.745in" x2="4.50in" y2="2.0366in" stroke="black"></line>
        <text x="3.01in" y="0.775in" font-size="5pt">DATE/TIME</text>
        <text x="3.04in" y="0.855in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1"/>
        <line x1="3.0in" y1="1.0033in" x2="6.0in" y2="1.0033in" stroke="black"></line>
        <text x="3.01in" y="1.0333in" font-size="5pt">DATE OF LAST PCP VISIT</text>
        <line x1="3.0in" y1="1.2616in" x2="8.0in" y2="1.2616in" stroke="black"></line>
        <text x="3.01in" y="1.2916in" font-size="5pt">PCP</text>
        <text x="3.04in" y="1.3716in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.PCP1"/>
        <line x1="3.0in" y1="1.52in" x2="8.0in" y2="1.52in" stroke="black"></line>
        <text x="3.01in" y="1.55in" font-size="5pt">REFERRING PHYSICIAN</text>
        <text x="3.04in" y="1.63in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.RefProvider1"/>
        <text x="3.01in" y="1.8083in" font-size="5pt">TREATING PHYSICIAN</text>
        <text x="3.04in" y="1.8883in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.Provider1"/>
      </g>

      <g id="InsuranceCoverage">
        <text x="4.52in" y="0.62in" font-weight="bold">INSURANCE COVERAGE</text>
        <line x1="6.0in" y1="0.745in" x2="6.0in" y2="1.7783in" stroke="black"></line>
        <text x="4.51in" y="0.775in" font-size="5pt">PRIMARY INSURANCE</text>
        <text x="4.54in" y="0.855in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1"/>
        <text x="4.51in" y="1.0333in" font-size="5pt">SECONDARY INSURANCE</text>
        <text x="4.54in" y="1.1133in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.SecondaryIns1"/>
        <text x="4.51in" y="1.2916in" font-size="5pt">COPAY</text>
        <text x="4.54in" y="1.3716in" width="0.73in" height="0.10in" valueSource="EncounterForm.1.Copay1"/>
        <line x1="5.25in" y1="1.2616in" x2="5.25in" y2="2.0366in" stroke="black"></line>
        <text x="5.26in" y="1.2916in" font-size="5pt">DEDUCTIBLE</text>
        <text x="5.29in" y="1.3716in" width="0.73in" height="0.10in" valueSource="EncounterForm.1.Deductible1"/>
        <text x="4.51in" y="1.55in" font-size="5pt">REFERRAL #</text>
        <text x="4.54in" y="1.63in" width="0.73in" height="0.10in" valueSource="EncounterForm.1.AuthNumber1"/>
        <text x="5.26in" y="1.55in" font-size="5pt">REFERRAL SOURCE</text>
        <text x="5.29in" y="1.63in" width="0.73in" height="0.10in" valueSource="EncounterForm.1.ReferringSource1"/>
      </g>

      <g id="PaymentOnAccount">
        <text x="6.02in" y="0.62in" font-weight="bold">PAYMENT ON ACCOUNT</text>
        <text x="6.01in" y="0.775in" font-size="5pt">PAYMENT METHOD</text>
        <circle cx="6.12in" cy="0.9258in" r="0.04in" fill="none" stroke="black"/>
        <text x="6.32in" y="0.8858in" font-size="5pt" >CASH</text>
        <circle cx="6.12in" cy="1.0658in" r="0.04in" fill="none" stroke="black"/>
        <text x="6.32in" y="1.0258in" font-size="5pt" >CREDIT CARD</text>
        <circle cx="6.12in" cy="1.2058in" r="0.04in" fill="none" stroke="black"/>
        <text x="6.32in" y="1.1658in" font-size="5pt" >CHECK #</text>
        <line x1="7.0in" y1="0.745in" x2="7.0in" y2="1.2616in" stroke="black"></line>
        <text x="7.01in" y="0.775in" font-size="5pt">BALANCE DUE</text>
        <line x1="7.0in" y1="1.0033in" x2="8.0in" y2="1.0033in" stroke="black"></line>
        <text x="7.01in" y="1.0333in" font-size="5pt">TODAY''S PAYMENT</text>
      </g>

      <g id="Notes">
        <text x="6.01in" y="1.2916in" font-size="5pt">NOTES</text>
      </g>

			<g id="ReturnSchedule">
				<text x="6.01in" y="1.55in" font-size="5pt">RETURN SCHEDULE:</text>
			  <text x="6.08in" y="1.66in" font-size="5pt">_____        D                W                  M                Y               PRN_____</text>
		  </g>

      <g id="GlobalEnds">
        <text x="4.51in" y="1.8083in" font-size="5pt">GLOBAL ENDS</text>
      </g>

      <g id="Modifiers">
        <text x="5.26in" y="1.8083in" font-size="5pt">MODIFIERS:</text>
        <text x="5.29in" y="1.8883in" font-size="5pt">LT         1         2         3         4         5         RT         1         2         3         4         5</text>
        <text x="5.49in" y="1.9483in" font-size="5pt">TA       T1       T2       T3       T4                    T5       T6       T7       T8       T9</text>
      </g>

			<g id="ProceduresGrid">
				<xsl:call-template name="CreateProceduresGridLines">
					<xsl:with-param name="maximumRows" select="26"/>
					<xsl:with-param name="currentRow" select="1"/>
				</xsl:call-template>
			</g>

			<g id="ProceduresDetails">
				<xsl:call-template name="CreateProceduresColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="27"/>
					<xsl:with-param name="maximumColumns" select="4"/>
					<xsl:with-param name="totalElements" select="$ProceduresCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>

			<g id="DiagnosisGrid">
				<xsl:call-template name="CreateDiagnosesGridLines">
					<xsl:with-param name="maximumRows" select="29"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="sectionHeader" select="1"/>
				</xsl:call-template>
			</g>

			<g id="DiagnosisDetails">
				<xsl:call-template name="CreateDiagnosesColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="30"/>
					<xsl:with-param name="maximumColumns" select="4"/>
					<xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>

      <g id="Signature">
        <text x="0.50in" y="10.23in" font-weight="bold">I hereby certify that I have rendered the above services.</text>
        <text x="0.50in" y="10.53in" font-weight="bold">PHYSICIAN''S SIGNATURE</text>
        <line x1="1.57in" y1="10.63in" x2="5.50in" y2="10.63in" />
        <text x="5.60in" y="10.53in" font-weight="bold">DATE</text>
        <line x1="5.88in" y1="10.63in" x2="8.0in" y2="10.63in" />
      </g>

		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 66

END