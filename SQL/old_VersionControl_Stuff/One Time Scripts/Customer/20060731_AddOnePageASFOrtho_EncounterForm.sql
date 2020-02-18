----------------------------------------------------------------------------------------------------------------------------------------------------
-- Case 13004: Implement a one page customized encounter form for ASF Orthopaedics Medical Group, a practice of GR Medical Management(Customer 108). 
----------------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT EncounterFormTypeID FROM EncounterFormType WHERE EncounterFormTypeID = 27)
BEGIN
	INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder, NumberOfPages, PageOneDetailsID, ShowProcedures, ShowDiagnoses, ShowPatientBalance)
	VALUES (27, 'One Page AO', 'Encounter form that prints on a single page', 27, 1, 43, 1, 1, 1)
END

IF NOT EXISTS(SELECT PrintingFormDetailsID FROM PrintingFormDetails WHERE PrintingFormDetailsID = 43)
BEGIN
	INSERT INTO PrintingFormDetails
		(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
	VALUES
		(43, 9, 30, 'One Page AO', 1)
END

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />
	<!--            Takes in the number of rows to draw the dotted horizontal lines for.                    Parameters:          maximumRows - max number of rows allowed in a column          currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)       -->
	<xsl:template name="CreateDiagnosesGridLines">
		<xsl:param name="maximumRows"/>
		<xsl:param name="currentRow"/>
		<xsl:param name="sectionHeader"/>
		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="yTopOffset" select="1.97"/>
		<xsl:variable name="yOffset" select="0.118"/>
		<xsl:variable name="lineWidth" select="7.50"/>
		<xsl:variable name="headerYOffset" select="0.01"/>
		<xsl:variable name="codeXOffset" select="0.02"/>
		<xsl:variable name="lineOffset" select="0.06"/>
		<xsl:if test="$maximumRows >= $currentRow">
			<!-- Creates the actual horizontal line for the row -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<!-- Calls the same template recursively -->
			<xsl:call-template name="CreateDiagnosesGridLines">
				<xsl:with-param name="maximumRows" select="$maximumRows"/>
				<xsl:with-param name="currentRow" select="$currentRow + 1"/>
				<xsl:with-param name="sectionHeader" select="$sectionHeader"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$maximumRows = $currentRow">
			<!-- Print the top horizontal dotted line -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset - $lineOffset}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset - $yOffset - $lineOffset}in" />
			<!-- Print the vertical lines -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 0.275}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.275}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 0.40}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.40}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 1.875}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 1.875}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 2.15}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.15}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.275}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.275}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 3.75}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 3.75}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 4.025}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.025}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.15}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.15}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.625}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.625}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 5.90}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.90}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 6.025}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 6.025}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.15875in" fill="rgb(255, 255, 0)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $codeXOffset + 3.44}in" y="{$yTopOffset + $headerYOffset + 0.009 + 0.046875 - 0.03 - $yOffset * 3}in" font-family="Arial" font-weight="bold" font-size="7pt">DIAGNOSIS</text>
		</xsl:if>
	</xsl:template>
	<!--            Takes in the number of rows allowed per column and the number of columns to process.          Loops through each detail element to print.          If this is a new category print the category in addition to the detail element.          Keep track of how many rows have been printed.          Once the row meets the total number of rows for a column move to the next column.          Don''t print a category on the last row in a column.                    Parameters:          maximumRowsInColumn - max number of rows allowed in a column          maximumColumns - max number of columns to process          totalElements - total number of elements to process          currentElement - index of current element being processed          currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)          currentColumn - 1 based index of current column being processed (mainly used for offsetting x location)          currentCategory - index of the current category being processed (once this changes we print out the category again)    -->
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
		<xsl:variable name="yTopOffset" select="1.51"/>
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
				<xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or                          ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
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
		<xsl:variable name="yTopOffset" select="7.484"/>
		<xsl:variable name="yOffset" select="0.118"/>
		<xsl:variable name="lineWidth" select="7.50"/>
		<xsl:variable name="headerYOffset" select="0.01"/>
		<xsl:variable name="codeXOffset" select="0.02"/>
		<xsl:variable name="lineOffset" select="0.06"/>
		<xsl:if test="$maximumRows >= $currentRow">
			<!-- Creates the actual horizontal line for the row -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<!-- Calls the same template recursively -->
			<xsl:call-template name="CreateProceduresGridLines">
				<xsl:with-param name="maximumRows" select="$maximumRows"/>
				<xsl:with-param name="currentRow" select="$currentRow + 1"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$maximumRows = $currentRow">
			<!-- Print the top horizontal dotted line -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset - $lineOffset}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset - $yOffset - $lineOffset}in" />
			<!-- Print the vertical lines -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 0.275}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.275}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 0.40}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.40}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 1.875}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 1.875}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 2.15}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.15}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.275}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.275}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 3.75}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 3.75}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 4.025}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.025}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.15}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.15}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.625}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.625}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" stroke-width="1.5pt"/>
			<line x1="{$xLeftOffset + 5.90}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.90}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 6.025}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 6.025}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset + $lineOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset - $lineOffset + $yOffset * ($currentRow - 1)}in" />
			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.15875in" fill="rgb(255, 255, 0)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $codeXOffset + 3.3775}in" y="{$yTopOffset + $headerYOffset + 0.009 + 0.046875 - 0.03 - $yOffset * 3}in" font-family="Arial" font-weight="bold" font-size="7pt">PROCEDURES</text>
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
		<xsl:variable name="yTopOffset" select="7.024"/>
		<xsl:variable name="yOffset" select="0.118"/>
		<xsl:variable name="codeXOffset" select="0.01"/>
		<xsl:variable name="descriptionXOffset" select="0.415"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.041"/>
		<xsl:variable name="codeWidth" select="0.30"/>
		<xsl:variable name="descriptionWidth" select="1.485"/>
		<xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
			<xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.ProcedureCategory'', $currentElement)]"/>
			<xsl:choose>
				<xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or                          ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth + 0.03}in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />
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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth + 0.03}in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />
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
				<style type="text/css">       g       {       font-family: Arial Narrow,Arial,Helvetica;       font-size: 7pt;       font-style: Normal;       font-weight: Normal;       alignment-baseline: text-before-edge;       }         text.bold       {       font-family: Arial,Arial Narrow,Helvetica;       font-size: 7pt;       font-style: Normal;       font-weight: bold;       alignment-baseline: text-before-edge;       }         text       {       baseline-shift: -100%;       }         g#DiagnosisGrid line       {       stroke: black;       }         g#ProceduresGrid line       {       stroke: black;       }        </style>
			</defs>
			<g>
				<g id ="AccountInformation">
					<rect x="0.50in" y="0.40in" width="1.875in" height="0.34875in" fill="rgb(255, 255, 255)" stroke="black"/>
					<text x="0.56in" y="0.46in">Account No.</text>
					<text x="0.54in" y="0.62in" width="0.9175in" height="0.10in" valueSource="EncounterForm.1.PatientID1"/>
					<line x1="0.50in" y1="0.574375in" x2="2.375in" y2="0.574375in" stroke="black"></line>
					<line x1="1.4375in" y1="0.40in" x2="1.4375in" y2="0.74875in" stroke="black"></line>
					<text x="1.4975in" y="0.46in">Chart No.</text>
					<text x="1.4775in" y="0.62in" width="0.9175in" height="0.10in" valueSource="EncounterForm.1.MedicalRecordNumber1"/>
				</g>
				<g id="PracticeInformation">
					<text x="0.50in" y="0.43in" width="7.50in" height="0.10in" text-anchor="middle" valueSource="EncounterForm.1.Provider1" />
					<text x="0.50in" y="0.52in" width="7.50in" height="0.10in" font-size="9pt" font-weight="bold" text-anchor="middle" valueSource="EncounterForm.1.PracticeName1" />
					<text x="0.50in" y="0.64in" width="7.50in" height="0.10in" font-size="8pt" text-anchor="middle" valueSource="EncounterForm.1.PracticeAddress1" />
				</g>
				<g id="AppointmentInformation">
					<rect x="6.125in" y="0.40in" width="1.875in" height="0.34875in" fill="rgb(255, 255, 255)" stroke="black"/>
					<text x="6.185in" y="0.46in">Appt No.</text>
					<text x="6.165in" y="0.62in" width="0.7275in" height="0.10in" valueSource="EncounterForm.1.TicketNumber1"/>
					<line x1="6.125in" y1="0.574375in" x2="8.0in" y2="0.574375in" stroke="black"></line>
					<line x1="6.875in" y1="0.40in" x2="6.875in" y2="0.74875in" stroke="black"></line>
					<text x="6.935in" y="0.46in">Appt Date/Time</text>
					<text x="6.915in" y="0.62in" width="1.095in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1"/>
				</g>
				<g id="PatientInformation">
					<rect x="0.50in" y="0.84in" width="7.50in" height="0.75in" fill="rgb(255, 255, 255)" stroke="black"/>
					<text x="0.51in" y="0.85in" font-size="5pt">Patient Name</text>
					<text x="0.90in" y="0.85in" width="2.11in" height="0.10in" valueSource="EncounterForm.1.PatientName1"/>
					<line x1="0.50in" y1="0.99in" x2="8.0in" y2="0.99in" stroke="black"></line>
					<text x="0.51in" y="1.0in" font-size="5pt">Street Address</text>
					<xsl:variable name="patFullAddress" select="concat(data[@id=''EncounterForm.1.AddressLine11''], '' '', data[@id=''EncounterForm.1.AddressLine21''])"/>
					<text x="0.93in" y="1.0in" width="2.08in" height="0.10in">
						<xsl:value-of select="$patFullAddress"/>
					</text>
					<line x1="0.50in" y1="1.14in" x2="8.0in" y2="1.14in" stroke="black"></line>
					<text x="0.51in" y="1.15in" font-size="5pt">City</text>
					<text x="0.63in" y="1.15in" width="1.3275in" height="0.10in" valueSource="EncounterForm.1.City1"/>
					<line x1="1.9375in" y1="1.14in" x2="1.9375in" y2="1.59in" stroke="black"></line>
					<text x="1.9475in" y="1.15in" font-size="5pt">State</text>
					<text x="2.1075in" y="1.15in" width="0.2875in" height="0.10in" valueSource="EncounterForm.1.State1"/>
					<line x1="2.375in" y1="1.14in" x2="2.375in" y2="1.44in" stroke="black"></line>
					<text x="2.385in" y="1.15in" font-size="5pt">Zip</text>
					<text x="2.485in" y="1.15in" width="0.535in" height="0.10in" valueSource="EncounterForm.1.ZipCode1"/>
					<line x1="0.50in" y1="1.29in" x2="8.0in" y2="1.29in" stroke="black"></line>
					<text x="0.51in" y="1.30in" font-size="5pt">Phone</text>
					<text x="0.72in" y="1.30in" width="1.2375in" height="0.10in" valueSource="EncounterForm.1.HomePhone1"/>
					<line x1="0.50in" y1="1.44in" x2="8.0in" y2="1.44in" stroke="black"></line>
					<text x="0.51in" y="1.45in" font-size="5pt">Birth Date</text>
					<text x="0.81in" y="1.45in" width="0.8975in" height="0.10in" valueSource="EncounterForm.1.DOBAge1"/>
					<line x1="1.6875in" y1="1.44in" x2="1.6875in" y2="1.59in" stroke="black"></line>
					<text x="1.6975in" y="1.45in" font-size="5pt">Sex</text>
					<xsl:variable name="patGenderLetter" select="substring(data[@id=''EncounterForm.1.Gender1''], 1, 1)"/>
					<text x="1.8275in" y="1.45in" height="0.10in">
						<xsl:value-of select="$patGenderLetter"/>
					</text>
					<text x="1.9475in" y="1.45in" font-size="5pt">SSN</text>
					<text x="2.0975in" y="1.45in" width="0.91in" height="0.10in" valueSource="EncounterForm.1.SSN1"/>
				</g>
				<g id="InsuranceInformation">
					<line x1="3.0in" y1="0.84in" x2="3.0in" y2="1.59in" stroke="black"></line>
					<text x="3.01in" y="0.85in" font-size="5pt">Insured Name</text>
					<text x="3.40in" y="0.85in" width="2.16in" height="0.10in" valueSource="EncounterForm.1.ResponsiblePerson1"/>
					<text x="3.01in" y="1.0in" font-size="5pt">Insurance-Plan</text>
					<text x="3.44in" y="1.0in" width="2.12in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1"/>
					<text x="3.01in" y="1.15in" font-size="5pt">Policy No</text>
					<text x="3.28in" y="1.15in" width="1.1675in" height="0.10in" valueSource="EncounterForm.1.PolicyNumber1"/>
					<line x1="4.4275in" y1="1.14in" x2="4.4275in" y2="1.29in" stroke="black"></line>
					<text x="4.4375in" y="1.15in" font-size="5pt">Relation</text>
					<text x="4.6775in" y="1.15in" width="0.4175in" height="0.10in" valueSource="EncounterForm.1.RelationshipToInsured1"/>
					<line x1="5.075in" y1="1.14in" x2="5.075in" y2="1.29in" stroke="black"></line>
					<text x="5.085in" y="1.15in" font-size="5pt">Ins Group ID</text>
					<text x="5.445in" y="1.15in" width="0.85in" height="0.10in" valueSource="EncounterForm.1.GroupNumber1"/>
					<text x="3.01in" y="1.30in" font-size="5pt">Copays</text>
					<text x="3.23in" y="1.30in" width="2.33in" height="0.10in" valueSource="EncounterForm.1.Copay1"/>
					<text x="3.01in" y="1.45in" font-size="5pt">Employer</text>
					<text x="3.28in" y="1.45in" width="2.29in" height="0.10in" valueSource="EncounterForm.1.Employer1"/>
				</g>
				<g id="DoctorInformation">
					<line x1="5.55in" y1="0.84in" x2="5.55in" y2="1.14in" stroke="black"></line>
					<text x="5.56in" y="0.85in" font-size="5pt">Chief Complaint</text>
					<text x="6.0in" y="0.85in" width="2.01in" height="0.10in" valueSource="EncounterForm.1.Reason1"/>
					<text x="5.56in" y="1.0in" font-size="5pt">Appointment Scheduled With</text>
					<text x="6.34in" y="1.0in" width="1.67in" height="0.10in" valueSource="EncounterForm.1.Provider1"/>
					<line x1="6.28in" y1="1.14in" x2="6.28in" y2="1.29in" stroke="black"></line>
					<text x="6.29in" y="1.15in" font-size="5pt">Physician</text>
					<text x="6.56in" y="1.15in" width="1.46in" height="0.10in" valueSource="EncounterForm.1.PCP1"/>
					<line x1="5.55in" y1="1.29in" x2="5.55in" y2="1.59in" stroke="black"></line>
					<text x="5.56in" y="1.30in" font-size="5pt">Accident Type</text>
					<text x="7.1125in" y="1.30in" font-size="5pt">Date</text>
					<text x="7.2625in" y="1.30in" width="0.7575in" height="0.10in" valueSource="EncounterForm.1.InjuryDate1"/>
					<line x1="7.1025in" y1="1.29in" x2="7.1025in" y2="1.59in" stroke="black"></line>
					<text x="5.56in" y="1.45in" font-size="5pt">Ref. Physician</text>
					<text x="5.96in" y="1.45in" width="1.1625in" height="0.10in" valueSource="EncounterForm.1.RefProvider1"/>
					<text x="7.1125in" y="1.45in" font-size="5pt">Balance</text>
					<text x="7.3525in" y="1.45in" width="0.6675in" height="0.10in" valueSource="EncounterForm.1.PatientBalance1"/>
				</g>
				<g id="OfficeInformation">
					<rect x="0.50in" y="9.5925in" width="7.50in" height="0.7875in" fill="rgb(240, 230, 140)" stroke="black"/>
					<text x="0.51in" y="9.6025in" font-size="5pt">Refer To:</text>
					<line x1="2.1875in" y1="9.5925in" x2="2.1875in" y2="9.789375in" stroke="black"></line>
					<text x="2.1975in" y="9.6025in" font-size="5pt">Next Appt:</text>
					<line x1="3.875in" y1="9.5925in" x2="3.875in" y2="9.789375in" stroke="black"></line>
					<text x="3.885in" y="9.6025in" font-size="5pt">Amount Paid:</text>
					<line x1="5.5625in" y1="9.5925in" x2="5.5625in" y2="9.789375in" stroke="black"></line>
					<text x="5.5725in" y="9.6025in" font-size="5pt">Total Charges:</text>
					<line x1="0.50in" y1="9.789375in" x2="8.0in" y2="9.789375in" stroke="black"></line>
					<line x1="0.50in" y1="9.98625in" x2="8.0in" y2="9.98625in" stroke="black"></line>
					<text x="0.54in" y="9.99125in" font-size="6pt">I affirm that the medical information indicated on this form is derived from and supported by my clinic documentation in the medical record. I direct that this information be billed on my behalf. I understand that, if the information I have</text>
					<text x="0.54in" y="10.07125in" font-size="6pt">provided herewith is not support by my entries in the medical record, I may incur liability.</text>
					<line x1="0.50in" y1="10.183125in" x2="8.0in" y2="10.183125in" stroke="black"></line>
					<text x="0.51in" y="10.193125in" font-size="5pt">Physician Signature:</text>
					<text x="2.9375in" y="10.193125in" font-size="5pt">Date:</text>
					<line x1="4.25in" y1="10.183125in" x2="4.25in" y2="10.38in" stroke="black"></line>
					<text x="4.26in" y="10.193125in" font-size="5pt">Patient Authorized Signature:</text>
					<text x="6.6875in" y="10.193125in" font-size="5pt">Date:</text>
				</g>
			</g>
			<g id="DiagnosisGrid">
				<xsl:call-template name="CreateDiagnosesGridLines">
					<xsl:with-param name="maximumRows" select="45"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="sectionHeader" select="1"/>
				</xsl:call-template>
			</g>
			<g id="DiagnosisDetails">
				<xsl:call-template name="CreateDiagnosesColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="45"/>
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
					<xsl:with-param name="maximumRows" select="19"/>
					<xsl:with-param name="currentRow" select="1"/>
				</xsl:call-template>
			</g>
			<g id="ProceduresDetails">
				<xsl:call-template name="CreateProceduresColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="19"/>
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
WHERE PrintingFormDetailsID = 43
