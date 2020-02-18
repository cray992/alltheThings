----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Case 13443: Implement a one page customized encounter form for Northwest Gastroenterology Associates, a practice of PRS Medical Managers(Customer 278).
----------------------------------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT EncounterFormTypeID FROM EncounterFormType WHERE EncounterFormTypeID = 46)
BEGIN
	INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder, NumberOfPages, PageOneDetailsID, ShowProcedures, ShowDiagnoses, ShowLastInsurancePaymentDate, ShowInsuranceBalance, ShowLastPatientPaymentDate, ShowPatientBalance)
	VALUES (46, 'One Page DB', 'Encounter form that prints on a single page', 46, 1, 62, 1, 1, 1, 1, 1, 1)
END

IF NOT EXISTS(SELECT PrintingFormDetailsID FROM PrintingFormDetails WHERE PrintingFormDetailsID = 62)
BEGIN
	INSERT INTO PrintingFormDetails
		(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
	VALUES
		(62, 9, 49, 'One Page DB', 1)
END

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />
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
		<xsl:variable name="yTopOffset" select="2.51"/>
		<xsl:variable name="yOffset" select="0.18625"/>
		<xsl:variable name="lineXOffset" select="0.01"/>
		<xsl:variable name="descriptionXOffset" select="0.22"/>
		<xsl:variable name="codeXOffset" select="5.90"/>
		<xsl:variable name="modifierXOffset" select="6.29"/>
		<xsl:variable name="feeXOffset" select="6.94"/>
		<xsl:variable name="lineYOffset" select="0.20"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="lineWidth" select="0.15"/>
		<xsl:variable name="descriptionWidth" select="5.65"/>
		<xsl:variable name="codeWidth" select="0.39"/>
		<xsl:variable name="modifierWidth" select="0.40"/>
		<xsl:variable name="feeWidth" select="0.50"/>
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
					<text x="{$xLeftOffset + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth + $codeWidth + 0.04}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" class="bold" />
					<line x1="{$xLeftOffset + $lineXOffset}in" y1="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 2)}in" x2="{$xLeftOffset + $lineXOffset + $lineWidth}in" y2="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 2)}in"></line>
					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />
					<xsl:variable name="Code" select="data[@id=concat(''EncounterForm.1.ProcedureCode'', $currentElement)]"/>
					<xsl:variable name="CodePeriod" select="concat($Code, ''.'')"/>
					<text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth + 0.03}in" height="0.10in">
						<xsl:value-of select="$CodePeriod"/>
					</text>
					<line x1="{$xLeftOffset + $modifierXOffset}in" y1="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 2)}in" x2="{$xLeftOffset + $modifierXOffset + $modifierWidth}in" y2="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 2)}in"></line>
					<line x1="{$xLeftOffset + $feeXOffset}in" y1="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 2)}in" x2="{$xLeftOffset + $feeXOffset + $feeWidth}in" y2="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 2)}in"></line>
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
					<line x1="{$xLeftOffset + $lineXOffset}in" y1="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 1)}in" x2="{$xLeftOffset + $lineXOffset + $lineWidth}in" y2="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 1)}in"></line>
					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />
					<xsl:variable name="Code" select="data[@id=concat(''EncounterForm.1.ProcedureCode'', $currentElement)]"/>
					<xsl:variable name="CodePeriod" select="concat($Code, ''.'')"/>
					<text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth + 0.03}in" height="0.10in">
						<xsl:value-of select="$CodePeriod"/>
					</text>
					<line x1="{$xLeftOffset + $modifierXOffset}in" y1="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 1)}in" x2="{$xLeftOffset + $modifierXOffset + $modifierWidth}in" y2="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 1)}in"></line>
					<line x1="{$xLeftOffset + $feeXOffset}in" y1="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 1)}in" x2="{$xLeftOffset + $feeXOffset + $feeWidth}in" y2="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 1)}in"></line>
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
	<xsl:template name="CreateDiagnosesColumnLayout">
		<xsl:param name="maximumRowsInColumn"/>
		<xsl:param name="maximumColumns"/>
		<xsl:param name="totalElements"/>
		<xsl:param name="currentElement"/>
		<xsl:param name="currentRow"/>
		<xsl:param name="currentColumn"/>
		<xsl:param name="currentCategory" select="0"/>
		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="xOffset" select="3.75"/>
		<xsl:variable name="yTopOffset" select="7.12"/>
		<xsl:variable name="yOffset" select="0.18625"/>
		<xsl:variable name="lineXOffset" select="0.01"/>
		<xsl:variable name="descriptionXOffset" select="0.27"/>
		<xsl:variable name="codeXOffset" select="3.33"/>
		<xsl:variable name="lineYOffset" select="0.20"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="lineWidth" select="0.20"/>
		<xsl:variable name="descriptionWidth" select="3.03"/>
		<xsl:variable name="codeWidth" select="0.42"/>
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
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth + $codeWidth + 0.04}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" class="bold" />
					<line x1="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $lineXOffset}in" y1="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 2)}in" x2="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $lineXOffset + $lineWidth}in" y2="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 2)}in"></line>
					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}"/>
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}"/>
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
					<line x1="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $lineXOffset}in" y1="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 1)}in" x2="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $lineXOffset + $lineWidth}in" y2="{$yTopOffset + $lineYOffset + $yOffset * ($currentRow + 1)}in"></line>
					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}"/>
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}"/>
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
		<xsl:variable name="ProceduresCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])"/>
		<xsl:variable name="DiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])"/>
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="300">
			<defs>
				<style type="text/css">            g            {            font-family: Arial Narrow,Arial,Helvetica;            font-size: 9pt;            font-style: Normal;            font-weight: Normal;            alignment-baseline: text-before-edge;            }              text.bold            {            font-family: Arial,Arial Narrow,Helvetica;            font-size: 8pt;            font-style: Normal;            font-weight: bold;            alignment-baseline: text-before-edge;            }              g#Title            {            font-family: Arial,Arial Narrow,Helvetica;            font-size: 16pt;            font-style: Normal;            font-weight: Normal;            alignment-baseline: text-before-edge;            }              text            {            baseline-shift: -100%;            }              g line            {            stroke: black;            }              text.centeredtext            {            font-size: 6pt;            text-anchor: middle;            }            </style>
			</defs>
			<g id="Title">
				<text x="0.49in" y="0.43in" width="5in" height="0.1in" valueSource="EncounterForm.1.TemplateName1" />
			</g>
			<g id="PracticeInformation">
				<text x="0.49in" y="0.71in" width="5.0in" height="0.10in" valueSource="EncounterForm.1.PracticeName1" />
				<text x="0.49in" y="0.86in" width="5.0in" height="0.10in" valueSource="EncounterForm.1.PracticeAddress1" />
				<text x="0.49in" y="1.01in" width="5.0in" height="0.10in" valueSource="EncounterForm.1.PracticePhoneFax1" />
				<text x="0.49in" y="1.16in" width="5.0in" height="0.10in" valueSource="EncounterForm.1.PracticeTaxID1" />
			</g>
			<g id="PatientInformation">
				<rect x="0.50in" y="1.40in" width="7.50in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
				<text x="0.52in" y="1.41in" font-weight="bold" font-size="6pt">PATIENT INFORMATION</text>
				<line x1="3.0in" y1="1.40in" x2="3.0in" y2="2.68in"></line>
				<text x="0.52in" y="1.55in" font-size="6pt">PATIENT CONTACT</text>
				<text x="0.52in" y="1.63in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.PatientName1" />
				<text x="0.52in" y="1.78in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.AddressLine11" />
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
						<text x="0.52in" y="1.93in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.AddressLine21" />
						<text x="0.52in" y="2.08in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1" />
						<text x="0.52in" y="2.23in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.HomePhone1" />
					</xsl:when>
					<xsl:otherwise>
						<text x="0.52in" y="1.93in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1" />
						<text x="0.52in" y="2.08in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.HomePhone1" />
					</xsl:otherwise>
				</xsl:choose>
				<line x1="0.50in" y1="2.39125in" x2="8.0in" y2="2.39125in"></line>
				<text x="0.52in" y="2.43in" font-size="6pt">PATIENT NUMBER</text>
				<text x="0.52in" y="2.50in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.PatientID1" />
				<line x1="1.75in" y1="2.39125in" x2="1.75in" y2="2.68in"></line>
				<text x="1.77in" y="2.43in" font-size="6pt">DATE OF BIRTH</text>
				<text x="1.77in" y="2.50in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.DOB1" />
				<line x1="0.50in" y1="2.68in" x2="8.0in" y2="2.68in"></line>
			</g>
			<g id="InsuranceCoverage">
				<text x="3.02in" y="1.41in" font-weight="bold" font-size="6pt">INSURANCE COVERAGE</text>
				<text x="3.02in" y="1.55in" font-size="6pt">GUARANTOR</text>
				<text x="3.02in" y="1.63in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.ResponsiblePerson1" />
				<line x1="3.0in" y1="1.81375in" x2="8.0in" y2="1.81375in"></line>
				<text x="3.02in" y="1.84375in" font-size="6pt">PRIMARY INSURANCE</text>
				<text x="3.02in" y="1.92375in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1" />
				<line x1="3.0in" y1="2.1025in" x2="8.0in" y2="2.1025in"></line>
				<text x="3.02in" y="2.1325in" font-size="6pt">SECONDARY INSURANCE</text>
				<text x="3.02in" y="2.2125in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.SecondaryIns1" />
				<text x="3.02in" y="2.42125in" font-size="6pt">COPAY</text>
				<text x="3.02in" y="2.50125in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.Copay1" />
				<line x1="4.25in" y1="2.39125in" x2="4.25in" y2="2.68in"></line>
				<text x="4.27in" y="2.42125in" font-size="6pt">DEDUCTIBLE</text>
				<text x="4.27in" y="2.50125in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.Deductible1" />
			</g>
			<g id="EncounterInformation">
				<text x="5.52in" y="1.41in" font-weight="bold" font-size="6pt">ENCOUNTER INFORMATION</text>
				<line x1="5.50in" y1="1.40in" x2="5.50in" y2="2.68in"></line>
				<text x="5.52in" y="1.55in" font-size="6pt">DATE/TIME</text>
				<text x="5.52in" y="1.63in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1" />
				<line x1="6.75in" y1="1.525in" x2="6.75in" y2="2.1025in"></line>
				<text x="6.77in" y="1.55in" font-size="6pt">TICKET NUMBER</text>
				<text x="6.77in" y="1.63in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.TicketNumber1" />
				<text x="5.52in" y="1.84375in" font-size="6pt">PLACE OF SERVICE</text>
				<text x="5.52in" y="1.92375in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.POS1" />
				<text x="6.77in" y="1.84375in" font-size="6pt">REASON</text>
				<text x="6.77in" y="1.92375in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.Reason1" />
				<text x="5.52in" y="2.1325in" font-size="6pt">PROVIDER</text>
				<text x="5.52in" y="2.2125in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.Provider1" />
				<text x="5.52in" y="2.42125in" font-size="6pt">REFERRING PROVIDER</text>
				<text x="5.52in" y="2.50125in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.RefProvider1" />
			</g>
			<g id="ProcedureDetails">
				<text x="0.50in" y="2.71in" width="7.50in" height="0.10in" class="centeredtext">PROCEDURE</text>
				<text x="1.50in" y="2.83in" font-size="6pt">DESCRIPTION</text>
				<text x="6.43in" y="2.83in" font-size="6pt">CPT</text>
				<text x="6.79in" y="2.83in" font-size="6pt">MODIFIER</text>
				<text x="7.63in" y="2.83in" font-size="6pt">FEE</text>
				<xsl:call-template name="CreateProceduresColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="21"/>
					<xsl:with-param name="maximumColumns" select="1"/>
					<xsl:with-param name="totalElements" select="$ProceduresCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>
			<g id="Comments">
				<text x="0.50in" y="6.86in" font-size="6pt">Comments:</text>
				<line x1="0.90in" y1="6.96in" x2="8.0in" y2="6.96in"></line>
				<line x1="0.50in" y1="7.11in" x2="8.0in" y2="7.11in"></line>
				<line x1="0.50in" y1="7.26in" x2="8.0in" y2="7.26in"></line>
			</g>
			<g id="DiagnosisDetails">
				<text x="0.50in" y="7.32in" font-size="6pt">*********************************************************************************************************************************DIAGNOSIS***********************************************************************************************************************************</text>
				<text x="1.25in" y="7.44in" font-size="6pt">DESCRIPTION</text>
				<text x="3.86in" y="7.44in" font-size="6pt">ICD-9</text>
				<text x="5.0in" y="7.44in" font-size="6pt">DESCRIPTION</text>
				<text x="7.61in" y="7.44in" font-size="6pt">ICD-9</text>
				<xsl:call-template name="CreateDiagnosesColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="12"/>
					<xsl:with-param name="maximumColumns" select="2"/>
					<xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
				<text x="0.50in" y="9.71in">---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------</text>
			</g>
			<g id="AccountBalance">
				<rect x="0.50in" y="9.86in" width="7.50in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
				<text x="0.54in" y="9.87in" font-weight="bold" font-size="6pt">PREVIOUS ACCOUNT BALANCE</text>
				<text x="0.54in" y="10.015in" font-size="6pt">LAST INSURANCE PAYMENT</text>
				<text x="0.57in" y="10.095in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.LastInsPay1" />
				<line x1="1.75in" y1="9.985in" x2="1.75in" y2="10.56in"></line>
				<text x="1.79in" y="10.015in" font-size="6pt">PREVIOUS INS BALANCE</text>
				<text x="1.82in" y="10.095in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.InsBalance1" />
				<line x1="0.50in" y1="10.2725in" x2="5.50in" y2="10.2725in"></line>
				<text x="0.54in" y="10.3025in" font-size="6pt">LAST PATIENT PAYMENT</text>
				<text x="0.57in" y="10.3825in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.LastPatientPay1" />
				<text x="1.79in" y="10.3025in" font-size="6pt">PREVIOUS PATIENT BALANCE</text>
				<text x="1.82in" y="10.3825in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.PatientBalance1" />
				<line x1="0.50in" y1="10.56in" x2="8.0in" y2="10.56in"></line>
			</g>
			<g id="AccountActivity">
				<text x="3.04in" y="9.87in" font-weight="bold" font-size="6pt">TODAY''S ACCOUNT ACTIVITY</text>
				<line x1="3.0in" y1="9.985in" x2="3.0in" y2="10.56in"></line>
				<text x="3.04in" y="10.015in" font-size="6pt">TODAY''S CHARGES</text>
				<line x1="4.25in" y1="9.985in" x2="4.25in" y2="10.56in"></line>
				<text x="4.29in" y="10.015in" font-size="6pt">TODAY''S ADJUSTMENTS</text>
				<text x="3.04in" y="10.3025in" font-size="6pt">TODAY''S AMOUNT DUE</text>
				<text x="4.29in" y="10.3025in" font-size="6pt">NEXT APPOINTMENT</text>
				<line x1="5.50in" y1="9.985in" x2="5.50in" y2="10.56in"></line>
			</g>
			<g id="PaymentOnAccount">
				<text x="5.54in" y="9.87in" font-weight="bold" font-size="6pt">PAYMENT ON ACCOUNT</text>
				<text x="5.54in" y="10.015in" font-size="6pt">PAYMENT METHOD</text>
				<circle cx="5.65in" cy="10.195in" r="0.04in" fill="none" stroke="black"/>
				<text x="5.85in" y="10.155in" font-size="6pt" >CASH</text>
				<circle cx="5.65in" cy="10.345in" r="0.04in" fill="none" stroke="black"/>
				<text x="5.85in" y="10.305in" font-size="6pt" >CREDIT CARD</text>
				<circle cx="5.65in" cy="10.495in" r="0.04in" fill="none" stroke="black"/>
				<text x="5.85in" y="10.455in" font-size="6pt" >CHECK #</text>
				<line x1="6.75in" y1="9.985in" x2="6.75in" y2="10.56in"></line>
				<text x="6.79in" y="10.015in" font-size="6pt">TODAY''S PAYMENT</text>
				<line x1="6.75in" y1="10.2725in" x2="8.0in" y2="10.2725in"></line>
				<text x="6.79in" y="10.3025in" font-size="6pt">BALANCE DUE</text>
			</g>
		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 62