---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Case 17592: Implement a one page customized encounter form for Inland Pulmonary Medical Group, a practice of California Medical Billing(Customer 327).
---------------------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT EncounterFormTypeID FROM EncounterFormType WHERE EncounterFormTypeID = 56)
BEGIN
	INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder, NumberOfPages, PageOneDetailsID, ShowProcedures, ShowDiagnoses, ShowPatientBalance)
	VALUES (56, '1-Page, 3-Column with Equal Spacing', 'Encounter form that prints on a single page', 56, 1, 81, 1, 1, 1)
END
ELSE
BEGIN
	-- Fixes any existing records that might be messed up
	UPDATE EncounterFormType SET PageOneDetailsID=81, ShowPatientBalance=1 WHERE EncounterFormTypeID=56
END

IF NOT EXISTS(SELECT PrintingFormDetailsID FROM PrintingFormDetails WHERE PrintingFormDetailsID = 81)
BEGIN
	INSERT INTO PrintingFormDetails (PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
	VALUES (81, 9, 68, '1-Page, 3-Column with Equal Spacing', 1)
END

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />
	<!--            Takes in the number of rows to draw the dotted horizontal lines for.                    Parameters:          maximumRows - max number of rows allowed in a column          currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)       -->
	<xsl:template name="CreateProceduresGridLines">
		<xsl:param name="maximumRows"/>
		<xsl:param name="currentRow"/>
		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="yTopOffset" select="3.11"/>
		<xsl:variable name="yOffset" select="0.13"/>
		<xsl:variable name="lineWidth" select="7.50"/>
		<xsl:variable name="headerYOffset" select="0.01"/>
		<xsl:variable name="codeXOffset" select="0.02"/>
		<xsl:variable name="descriptionXOffset" select="0.27"/>
		<xsl:variable name="diagnosisXOffset" select="2.273"/>
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
			<line x1="{$xLeftOffset + 2.04}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.04}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.54}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.54}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.0}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.0}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.04}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.04}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" font-family="Arial" font-weight="bold" font-size="7pt">PROCEDURES</text>
			<!-- Add headers -->
			<text x="{$xLeftOffset + $codeXOffset - 0.02}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.25in" height="0.10in" class="centeredtext">X</text>
			<text x="{$xLeftOffset + $descriptionXOffset - 0.02}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="1.80in" height="0.10in" class="centeredtext">DESCRIPTION</text>
			<text x="{$xLeftOffset + $diagnosisXOffset - 0.23}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.46in" height="0.10in" class="centeredtext">CODE</text>
			<text x="{$xLeftOffset + $codeXOffset + 2.48}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.25in" height="0.10in" class="centeredtext">X</text>
			<text x="{$xLeftOffset + $descriptionXOffset + 2.48}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="1.80in" height="0.10in" class="centeredtext">DESCRIPTION</text>
			<text x="{$xLeftOffset + $diagnosisXOffset + 2.27}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.46in" height="0.10in" class="centeredtext">CODE</text>
			<text x="{$xLeftOffset + $codeXOffset + 4.98}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.25in" height="0.10in" class="centeredtext">X</text>
			<text x="{$xLeftOffset + $descriptionXOffset + 4.98}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="1.80in" height="0.10in" class="centeredtext">DESCRIPTION</text>
			<text x="{$xLeftOffset + $diagnosisXOffset + 4.77}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.46in" height="0.10in" class="centeredtext">CODE</text>
		</xsl:if>
	</xsl:template>
	<!--            Takes in the number of rows allowed per column and the number of columns to process.          Loops through each detail element to print.          If this is a new category print the category in addition to the detail element.          Keep track of how many rows have been printed.          Once the row meets the total number of rows for a column move to the next column.          Don''t print a category on the last row in a column.                    Parameters:          maximumRowsInColumn - max number of rows allowed in a column          maximumColumns - max number of columns to process          totalElements - total number of elements to process          currentElement - index of current element being processed          currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)          currentColumn - 1 based index of current column being processed (mainly used for offsetting x location)          currentCategory - index of the current category being processed (once this changes we print out the category again)    -->
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
		<xsl:variable name="yTopOffset" select="2.68"/>
		<xsl:variable name="yOffset" select="0.13"/>
		<xsl:variable name="codeXOffset" select="2.03"/>
		<xsl:variable name="descriptionXOffset" select="0.27"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeWidth" select="0.45"/>
		<xsl:variable name="descriptionWidth" select="1.80"/>
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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" class="bold" />
					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" class="ralignedtext" />
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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" class="ralignedtext" />
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
		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="yTopOffset" select="7.05"/>
		<xsl:variable name="yOffset" select="0.13"/>
		<xsl:variable name="lineWidth" select="7.50"/>
		<xsl:variable name="headerYOffset" select="0.01"/>
		<xsl:variable name="codeXOffset" select="0.02"/>
		<xsl:variable name="descriptionXOffset" select="0.29"/>
		<xsl:variable name="diagnosisXOffset" select="2.273"/>
		<xsl:if test="$maximumRows >= $currentRow">
			<!-- Creates the actual horizontal line for the row -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<!-- Calls the same template recursively -->
			<xsl:call-template name="CreateDiagnosesGridLines">
				<xsl:with-param name="yTopOffset" select="$yTopOffset"/>
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
			<line x1="{$xLeftOffset + 2.04}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.04}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.54}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.54}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.0}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.0}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.04}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.04}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" font-family="Arial" font-weight="bold" font-size="7pt">DIAGNOSES</text>
			<!-- Add headers -->
			<text x="{$xLeftOffset + $codeXOffset - 0.02}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.25in" height="0.10in" class="centeredtext">X</text>
			<text x="{$xLeftOffset + $descriptionXOffset - 0.05}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="1.80in" height="0.10in" class="centeredtext">DIAGNOSIS</text>
			<text x="{$xLeftOffset + $diagnosisXOffset - 0.235}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.46in" height="0.10in" class="centeredtext">ICD-9-CM</text>
			<text x="{$xLeftOffset + $codeXOffset + 2.48}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.25in" height="0.10in" class="centeredtext">X</text>
			<text x="{$xLeftOffset + $descriptionXOffset + 2.45}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="1.80in" height="0.10in" class="centeredtext">DIAGNOSIS</text>
			<text x="{$xLeftOffset + $diagnosisXOffset + 2.265}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.46in" height="0.10in" class="centeredtext">ICD-9-CM</text>
			<text x="{$xLeftOffset + $codeXOffset + 4.98}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.25in" height="0.10in" class="centeredtext">X</text>
			<text x="{$xLeftOffset + $descriptionXOffset + 4.95}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="1.80in" height="0.10in" class="centeredtext">DIAGNOSIS</text>
			<text x="{$xLeftOffset + $diagnosisXOffset + 4.765}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width="0.46in" height="0.10in" class="centeredtext">ICD-9-CM</text>
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
		<xsl:variable name="xOffset" select="2.50"/>
		<xsl:variable name="yTopOffset" select="6.62"/>
		<xsl:variable name="yOffset" select="0.13"/>
		<xsl:variable name="codeXOffset" select="2.03"/>
		<xsl:variable name="descriptionXOffset" select="0.27"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeWidth" select="0.45"/>
		<xsl:variable name="descriptionWidth" select="1.80"/>
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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" class="bold" />
					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" class="ralignedtext" />
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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" class="ralignedtext" />
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
				<style type="text/css">       g       {       font-family: Arial Narrow,Arial,Helvetica;       font-size: 7pt;       font-style: Normal;       font-weight: Normal;       alignment-baseline: text-before-edge;       }         text.bold       {       font-family: Arial,Arial Narrow,Helvetica;       font-size: 8pt;       font-style: Normal;       font-weight: bold;       alignment-baseline: text-before-edge;       }         g#Title       {       font-family: Arial,Arial Narrow,Helvetica;       font-size: 16pt;       font-style: Normal;       font-weight: Normal;       alignment-baseline: text-before-edge;       }         text       {       baseline-shift: -100%;       }         g#DiagnosisGrid line       {       stroke: black;       }         g#ProceduresGrid line       {       stroke: black;       }         text.centeredtext       {       text-anchor: middle;       }         text.ralignedtext       {       text-anchor: end;       }        </style>
			</defs>
			<g id="Title">
				<text x="0.49in" y="0.40in" width="5.09in" height="0.10in" valueSource="EncounterForm.1.TemplateName1" />
			</g>
			<g id="PracticeInformation">
				<text x="0.49in" y="0.71in" width="4.03in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.PracticeName1" />
				<text x="0.49in" y="0.86in" width="4.03in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.PracticeAddress1" />
				<text x="0.49in" y="1.01in" width="4.03in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.PracticePhoneFax1" />
				<text x="0.49in" y="1.16in" width="4.03in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.PracticeTaxID1" />
			</g>
			<g id="AccountActivity">
				<rect x="4.50in" y="0.70in" width="3.5in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
				<text x="4.83in" y="0.71in" font-weight="bold" font-size="6pt">ACCOUNT ACTIVITY</text>
				<line x1="4.50in" y1="0.70in" x2="4.50in" y2="1.40in" stroke="black"></line>
				<text x="4.52in" y="0.855in" font-size="6pt">PREVIOUS BALANCE</text>
				<text x="4.52in" y="0.935in" width="1.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.PatientBalance1"/>
				<line x1="4.50in" y1="1.1125in" x2="6.0in" y2="1.1125in" stroke="black"></line>
				<text x="4.52in" y="1.1425in" font-size="6pt">TODAY''S CHARGES</text>
				<line x1="6.0in" y1="0.825in" x2="6.0in" y2="1.40in" stroke="black"></line>
			</g>
			<g id="PaymentOnAccount">
				<text x="6.47in" y="0.71in" font-weight="bold" font-size="6pt">PAYMENT ON ACCOUNT</text>
				<text x="6.02in" y="0.855in" font-size="6pt">PAYMENT METHOD</text>
				<circle cx="6.12in" cy="1.035in" r="0.04in" fill="none" stroke="black"/>
				<text x="6.32in" y="0.995in" font-size="6pt">CASH</text>
				<circle cx="6.12in" cy="1.185in" r="0.04in" fill="none" stroke="black"/>
				<text x="6.32in" y="1.145in" font-size="6pt">CREDIT CARD</text>
				<circle cx="6.12in" cy="1.335in" r="0.04in" fill="none" stroke="black"/>
				<text x="6.32in" y="1.295in" font-size="6pt">CHECK #</text>
				<line x1="7.0in" y1="0.825in" x2="7.0in" y2="1.40in" stroke="black"></line>
				<text x="7.02in" y="0.855in" font-size="6pt">BALANCE DUE</text>
				<line x1="7.0in" y1="1.1125in" x2="8.0in" y2="1.1125in" stroke="black"></line>
				<text x="7.02in" y="1.1425in" font-size="6pt">TODAY''S PAYMENT</text>
			</g>
			<g id="PatientInformation">
				<rect x="0.50in" y="1.40in" width="7.50in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
				<text x="0.52in" y="1.41in" font-weight="bold" font-size="6pt">PATIENT INFORMATION</text>
				<line x1="3.0in" y1="1.40in" x2="3.0in" y2="2.68in" stroke="black"></line>
				<text x="0.52in" y="1.55in" font-size="6pt">PATIENT CONTACT</text>
				<text x="0.52in" y="1.64in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.PatientName1" />
				<text x="0.52in" y="1.78in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.AddressLine11" />
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
						<text x="0.52in" y="1.92in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.AddressLine21" />
						<text x="0.52in" y="2.06in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.CityStateZip1" />
						<text x="0.52in" y="2.20in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.HomePhone1" />
					</xsl:when>
					<xsl:otherwise>
						<text x="0.52in" y="1.92in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.CityStateZip1" />
						<text x="0.52in" y="2.06in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.HomePhone1" />
					</xsl:otherwise>
				</xsl:choose>
				<line x1="0.50in" y1="2.39125in" x2="8.0in" y2="2.39125in" stroke="black"></line>
				<text x="0.52in" y="2.42125in" font-size="6pt">PATIENT NUMBER</text>
				<text x="0.52in" y="2.51125in" width="1.25in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.PatientID1" />
				<line x1="1.75in" y1="2.39125in" x2="1.75in" y2="2.68in" stroke="black"></line>
				<text x="1.77in" y="2.42125in" font-size="6pt">DATE OF BIRTH</text>
				<text x="1.77in" y="2.51125in" width="1.25in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.DOB1" />
				<line x1="0.50in" y1="2.68in" x2="8.0in" y2="2.68in" stroke="black"></line>
			</g>
			<g id="InsuranceCoverage">
				<text x="3.02in" y="1.41in" font-weight="bold" font-size="6pt">INSURANCE COVERAGE</text>
				<text x="3.02in" y="1.55in" font-size="6pt">GUARANTOR</text>
				<text x="3.02in" y="1.64in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.ResponsiblePerson1" />
				<line x1="3.0in" y1="1.81375in" x2="8.0in" y2="1.81375in" stroke="black"></line>
				<text x="3.02in" y="1.84375in" font-size="6pt">PRIMARY INSURANCE</text>
				<text x="3.02in" y="1.93375in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.PrimaryIns1" />
				<line x1="3.0in" y1="2.1025in" x2="8.0in" y2="2.1025in" stroke="black"></line>
				<text x="3.02in" y="2.1325in" font-size="6pt">SECONDARY INSURANCE</text>
				<text x="3.02in" y="2.2225in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.SecondaryIns1" />
				<text x="3.02in" y="2.42125in" font-size="6pt">COPAY</text>
				<text x="3.02in" y="2.51125in" width="1.25in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.Copay1" />
				<line x1="4.25in" y1="2.39125in" x2="4.25in" y2="2.68in" stroke="black"></line>
				<text x="4.27in" y="2.42125in" font-size="6pt">DEDUCTIBLE</text>
				<text x="4.27in" y="2.51125in" width="1.25in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.Deductible1" />
			</g>
			<g id="EncounterInformation">
				<text x="5.52in" y="1.41in" font-weight="bold" font-size="6pt">ENCOUNTER INFORMATION</text>
				<line x1="5.50in" y1="1.40in" x2="5.50in" y2="2.68in" stroke="black"></line>
				<text x="5.52in" y="1.55in" font-size="6pt">DATE/TIME</text>
				<text x="5.52in" y="1.64in" width="1.25in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.AppDateTime1" />
				<line x1="6.75in" y1="1.525in" x2="6.75in" y2="2.1025in" stroke="black"></line>
				<text x="6.77in" y="1.55in" font-size="6pt">TICKET NUMBER</text>
				<text x="6.77in" y="1.64in" width="1.25in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.TicketNumber1" />
				<text x="5.52in" y="1.84375in" font-size="6pt">PLACE OF SERVICE</text>
				<text x="5.52in" y="1.93375in" width="1.25in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.POS1" />
				<text x="6.77in" y="1.84375in" font-size="6pt">REASON</text>
				<text x="6.77in" y="1.93375in" width="1.25in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.Reason1" />
				<text x="5.52in" y="2.1325in" font-size="6pt">PROVIDER</text>
				<text x="5.52in" y="2.2225in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.Provider1" />
				<text x="5.52in" y="2.42125in" font-size="6pt">REFERRING PROVIDER</text>
				<text x="5.52in" y="2.51125in" width="2.50in" height="0.10in" font-size="9pt" valueSource="EncounterForm.1.RefProvider1" />
			</g>
			<g id="ProceduresGrid">
				<xsl:call-template name="CreateProceduresGridLines">
					<xsl:with-param name="maximumRows" select="28"/>
					<xsl:with-param name="currentRow" select="1"/>
				</xsl:call-template>
			</g>
			<g id="ProceduresDetails">
				<xsl:call-template name="CreateProceduresColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="28"/>
					<xsl:with-param name="maximumColumns" select="3"/>
					<xsl:with-param name="totalElements" select="$ProceduresCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>
			<g id="DiagnosisGrid">
				<xsl:call-template name="CreateDiagnosesGridLines">
					<xsl:with-param name="maximumRows" select="28"/>
					<xsl:with-param name="currentRow" select="1"/>
				</xsl:call-template>
			</g>
			<g id="DiagnosisDetails">
				<xsl:call-template name="CreateDiagnosesColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="28"/>
					<xsl:with-param name="maximumColumns" select="3"/>
					<xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>
		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 81
