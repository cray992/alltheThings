-------------------------------------------------------------------------------------------------
-- Case 10824: Implement a one page customized encounter form for G.R.M.M provider Uwaydah Munir. 
-------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 108
IF charindex('_0108_', db_name()) > 0
BEGIN
/*
INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (16, 'One Page Dr. Uwaydah', 'Encounter form that prints on a single page', 16)

INSERT INTO PrintingFormDetails
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES
	(34, 9, 19, 'One Page Dr. Uwaydah', 1)
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

	<xsl:template name="CreateDiagnosesGridLines">

		<xsl:param name="maximumRows"/>
		<xsl:param name="currentRow"/>
		<xsl:param name="sectionHeader"/>

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="yTopOffset" select="2.84"/>
		<xsl:variable name="yOffset" select="0.118"/>
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
			<line x1="{$xLeftOffset + 0.40}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.40}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 1.875}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 1.875}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 2.15}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.15}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.275}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.275}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 3.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 3.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 4.025}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.025}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.15}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.15}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.625}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.625}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 5.90}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.90}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 6.025}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 6.025}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.21875in" fill="rgb(255, 255, 0)" stroke="black" stroke-width="0.5pt" />

			<text x="{$xLeftOffset + $codeXOffset + 3.44}in" y="{$yTopOffset + $headerYOffset + 0.009 + 0.046875 - $yOffset * 3}in" font-family="Arial" font-weight="bold" font-size="7pt">DIAGNOSIS</text>

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
		<xsl:variable name="yTopOffset" select="2.44"/>
		<xsl:variable name="yOffset" select="0.118"/>
		<xsl:variable name="codeXOffset" select=".01"/>
		<xsl:variable name="descriptionXOffset" select="0.415"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.041"/>
		<xsl:variable name="codeWidth" select="0.30"/>
		<xsl:variable name="descriptionWidth" select="1.485"/>

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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" class="bold" />

					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth + 0.03}in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth + 0.03}in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

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

	<xsl:template name="CreateProceduresGridLines">

		<xsl:param name="maximumRows"/>
		<xsl:param name="currentRow"/>

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="yTopOffset" select="5.11"/>
		<xsl:variable name="yOffset" select="0.118"/>
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
			<line x1="{$xLeftOffset + 0.375}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.375}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 1.875}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 1.875}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 2.125}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.125}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 3.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 3.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 4.0}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.0}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.125}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.125}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.625}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.625}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 5.875}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.875}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 6.0}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 6.0}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.21875in" fill="rgb(255, 255, 0)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $codeXOffset + 3.3775}in" y="{$yTopOffset + $headerYOffset + 0.009 + 0.046875 - $yOffset * 3}in" font-family="Arial" font-weight="bold" font-size="7pt">PROCEDURES</text>

		</xsl:if>
	</xsl:template>

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
		<xsl:variable name="yTopOffset" select="4.71"/>
		<xsl:variable name="yOffset" select="0.118"/>
		<xsl:variable name="codeXOffset" select="0.01"/>
		<xsl:variable name="descriptionXOffset" select="0.395"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.041"/>
		<xsl:variable name="codeWidth" select="0.27"/>
		<xsl:variable name="descriptionWidth" select="1.515"/>

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
					font-size: 7pt;
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

				</style>
			</defs>

			<g>

				<g id ="AccountInformation">

					<rect x="0.50in" y="0.50in" width="1.875in" height="0.46875in" fill="rgb(255, 255, 255)" stroke="black"/>
					<text x="0.56in" y="0.56in">Account No.</text>
					<text x="0.54in" y="0.78in" width="0.9175in" height="0.10in" valueSource="EncounterForm.1.PatientID1"/>
					<line x1="0.50in" y1="0.734375in" x2="2.375in" y2="0.734375in" stroke="black"></line>
					<line x1="1.4375in" y1="0.50in" x2="1.4375in" y2="0.96875in" stroke="black"></line>
					<text x="1.4975in" y="0.56in">Chart No.</text>
					<text x="1.4775in" y="0.78in" width="0.9175in" height="0.10in" valueSource="EncounterForm.1.MedicalRecordNumber1"/>

				</g>

				<g id="PracticeInformation">
          <text x="0.50in" y="0.50in" width="7.50in" height="0.10in" font-size="9pt" font-weight="bold" text-anchor="middle" valueSource="EncounterForm.1.PracticeName1" />
          <text x="0.50in" y="0.62in" width="7.50in" height="0.10in" text-anchor="middle" valueSource="EncounterForm.1.Provider1" />
					<text x="2.96875in" y="0.74in" >___San Fernando    ___Los Angeles/Echo Park    ___Long Beach</text>
					<text x="2.74875in" y="0.86in" >___Lancaster    ___Rancho Cucamonga    ___Redondo Beach    ___San Diego</text>
				</g>

				<g id="AppointmentInformation">

					<rect x="6.125in" y="0.50in" width="1.875in" height="0.46875in" fill="rgb(255, 255, 255)" stroke="black"/>
					<text x="6.185in" y="0.56in">Appt No.</text>
					<text x="6.165in" y="0.78in" width="0.7275in" height="0.10in" valueSource="EncounterForm.1.TicketNumber1"/>
					<line x1="6.125in" y1="0.734375in" x2="8.0in" y2="0.734375in" stroke="black"></line>
					<line x1="6.875in" y1="0.50in" x2="6.875in" y2="0.96875in" stroke="black"></line>
					<text x="6.935in" y="0.56in">Appt Date/Time</text>
					<text x="6.915in" y="0.78in" width="1.095in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1"/>

				</g>

				<g id="PatientInformation">

					<rect x="0.50in" y="1.06in" width="7.50in" height="1.40in" fill="rgb(255, 255, 255)" stroke="black"/>
					<text x="0.51in" y="1.07in" font-size="5pt">Patient Name</text>
					<text x="0.54in" y="1.17in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.PatientName1"/>
					<line x1="0.50in" y1="1.34in" x2="8.0in" y2="1.34in" stroke="black"></line>
					<text x="0.51in" y="1.35in" font-size="5pt">Street Address</text>

					<xsl:variable name="patFullAddress" select="concat(data[@id=''EncounterForm.1.AddressLine11''], '' '', data[@id=''EncounterForm.1.AddressLine21''])"/>

					<text x="0.54in" y="1.45in" width="2.47in" height="0.10in">
						<xsl:value-of select="$patFullAddress"/>
					</text>

					<line x1="0.50in" y1="1.62in" x2="8.0in" y2="1.62in" stroke="black"></line>
					<text x="0.51in" y="1.63in" font-size="5pt">City</text>
					<text x="0.54in" y="1.73in" width="1.4075in" height="0.10in" valueSource="EncounterForm.1.City1"/>
					<line x1="1.9375in" y1="1.62in" x2="1.9375in" y2="2.46in" stroke="black"></line>
					<text x="1.9475in" y="1.63in" font-size="5pt">State</text>
					<text x="1.9775in" y="1.73in" width="0.4075in" height="0.10in" valueSource="EncounterForm.1.State1"/>
					<line x1="2.375in" y1="1.62in" x2="2.375in" y2="1.90in" stroke="black"></line>
					<text x="2.385in" y="1.63in" font-size="5pt">Zip</text>
					<text x="2.415in" y="1.73in" width="0.595in" height="0.10in" valueSource="EncounterForm.1.ZipCode1"/>
					<line x1="0.50in" y1="1.90in" x2="8.0in" y2="1.90in" stroke="black"></line>
					<text x="0.51in" y="1.91in" font-size="5pt">Phone</text>
					<text x="0.54in" y="2.01in" width="1.4075in" height="0.10in" valueSource="EncounterForm.1.HomePhone1"/>
					<line x1="0.50in" y1="2.18in" x2="8.0in" y2="2.18in" stroke="black"></line>
					<text x="0.51in" y="2.19in" font-size="5pt">Birth Date</text>
					<text x="0.54in" y="2.29in" width="1.1575in" height="0.10in" valueSource="EncounterForm.1.DOBAge1"/>
					<line x1="1.6875in" y1="2.18in" x2="1.6875in" y2="2.46in" stroke="black"></line>
					<text x="1.6975in" y="2.19in" font-size="5pt">Sex</text>

					<xsl:variable name="patGenderLetter" select="substring(data[@id=''EncounterForm.1.Gender1''], 1, 1)"/>

					<text x="1.7275in" y="2.29in" height="0.10in">
						<xsl:value-of select="$patGenderLetter"/>
					</text>

					<text x="1.9475in" y="2.19in" font-size="5pt">SSN</text>
					<text x="1.9775in" y="2.29in" width="1.03in" height="0.10in" valueSource="EncounterForm.1.SSN1"/>

				</g>

				<g id="InsuranceInformation">

					<line x1="3.0in" y1="1.06in" x2="3.0in" y2="2.46in" stroke="black"></line>
					<text x="3.01in" y="1.07in" font-size="5pt">Insured Name</text>
					<text x="3.04in" y="1.17in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.ResponsiblePerson1"/>
					<text x="3.01in" y="1.35in" font-size="5pt">Insurance-Plan</text>
					<text x="3.04in" y="1.45in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1"/>
					<text x="3.01in" y="1.63in" font-size="5pt">Policy No</text>
					<text x="3.04in" y="1.73in" width="1.1675in" height="0.10in" valueSource="EncounterForm.1.PolicyNumber1"/>
					<line x1="4.1875in" y1="1.62in" x2="4.1875in" y2="1.90in" stroke="black"></line>
					<text x="4.1975in" y="1.63in" font-size="5pt">Relation</text>
					<text x="4.2275in" y="1.73in" width="0.4075in" height="0.10in" valueSource="EncounterForm.1.RelationshipToInsured1"/>
					<line x1="4.625in" y1="1.62in" x2="4.625in" y2="1.90in" stroke="black"></line>
					<text x="4.635in" y="1.63in" font-size="5pt">Ins Group ID</text>
					<text x="4.665in" y="1.73in" width="0.85in" height="0.10in" valueSource="EncounterForm.1.GroupNumber1"/>
					<text x="3.01in" y="1.91in" font-size="5pt">Copays</text>
					<text x="3.04in" y="2.01in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.Copay1"/>
					<text x="3.01in" y="2.19in" font-size="5pt">Employer</text>
					<text x="3.04in" y="2.29in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.Employer1"/>

				</g>

				<g id="DoctorInformation">

					<line x1="5.50in" y1="1.06in" x2="5.50in" y2="2.46in" stroke="black"></line>
					<text x="5.51in" y="1.07in" font-size="5pt">Chief Complaint</text>
					<text x="5.54in" y="1.17in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.Reason1"/>
					<text x="5.51in" y="1.35in" font-size="5pt">Appointment Scheduled With</text>
					<text x="5.54in" y="1.45in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.Provider1"/>
					<text x="5.51in" y="1.63in" font-size="5pt">Physician</text>
					<text x="5.54in" y="1.73in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.PCP1"/>
					<text x="5.51in" y="1.91in" font-size="5pt">Accident Type</text>
					<text x="7.3225in" y="1.91in" font-size="5pt">Date</text>
					<text x="7.3525in" y="2.01in" width="0.6675in" height="0.10in" valueSource="EncounterForm.1.InjuryDate1"/>
					<line x1="7.3125in" y1="1.90in" x2="7.3125in" y2="2.46in" stroke="black"></line>
					<text x="5.51in" y="2.19in" font-size="5pt">Ref. Physician</text>
					<text x="5.54in" y="2.29in" width="1.7925in" height="0.10in" valueSource="EncounterForm.1.RefProvider1"/>
					<text x="7.3225in" y="2.19in" font-size="5pt">Balance</text>
					<text x="7.3525in" y="2.29in" width="0.6675in" height="0.10in" valueSource="EncounterForm.1.PatientBalance1"/>

				</g>

				<g id="OfficeInformation">

					<rect x="0.50in" y="9.1725in" width="7.50in" height="1.1875in" fill="rgb(240, 230, 140)" stroke="black"/>
					<text x="0.51in" y="9.1825in" font-size="5pt">Refer To:</text>
					<line x1="2.1875in" y1="9.1725in" x2="2.1875in" y2="9.469375in" stroke="black"></line>
					<text x="2.1975in" y="9.1825in" font-size="5pt">Next Appt:</text>
					<line x1="3.875in" y1="9.1725in" x2="3.875in" y2="9.469375in" stroke="black"></line>
					<text x="3.885in" y="9.1825in" font-size="5pt">Amount Paid:</text>
					<line x1="5.5625in" y1="9.1725in" x2="5.5625in" y2="9.469375in" stroke="black"></line>
					<text x="5.5725in" y="9.1825in" font-size="5pt">Total Charges:</text>
					<line x1="0.50in" y1="9.469375in" x2="8.0in" y2="9.469375in" stroke="black"></line>
					<line x1="0.50in" y1="9.76625in" x2="8.0in" y2="9.76625in" stroke="black"></line>
					<text x="0.54in" y="9.80625in" font-size="6.5pt">I affirm that the medical information indicated on this form is derived from and supported by my clinic documentation in the medical record. I direct that this information be billed on my behalf. I understand that, if the</text>
					<text x="0.54in" y="9.93625in" font-size="6.5pt">information I have provided herewith is not support by my entries in the medical record, I may incur liability.</text>
					<line x1="0.50in" y1="10.063125in" x2="8.0in" y2="10.063125in" stroke="black"></line>
					<text x="0.51in" y="10.073125in" font-size="5pt">Physician Signature:</text>
					<text x="2.9375in" y="10.073125in" font-size="5pt">Date:</text>
					<line x1="4.25in" y1="10.063125in" x2="4.25in" y2="10.36in" stroke="black"></line>
					<text x="4.26in" y="10.073125in" font-size="5pt">Patient Authorized Signature:</text>
					<text x="6.6875in" y="10.073125in" font-size="5pt">Date:</text>

				</g>
			</g>

			<g id="DiagnosisGrid">
				<xsl:call-template name="CreateDiagnosesGridLines">
					<xsl:with-param name="maximumRows" select="17"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="sectionHeader" select="1"/>
				</xsl:call-template>
			</g>

			<g id="DiagnosisDetails">
				<xsl:call-template name="CreateDiagnosesColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="17"/>
					<xsl:with-param name="maximumColumns" select="4"/>
					<xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>

			<g id="ProceduresGrid">
				<xsl:call-template name="CreateProceduresGridLines">
					<xsl:with-param name="maximumRows" select="35"/>
					<xsl:with-param name="currentRow" select="1"/>
				</xsl:call-template>
			</g>

			<g id="ProceduresDetails">
				<xsl:call-template name="CreateProceduresColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="35"/>
					<xsl:with-param name="maximumColumns" select="4"/>
					<xsl:with-param name="totalElements" select="$ProceduresCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>

		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 34

END