------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Case 13049: Implement a one page customized encounter form for TX Institute Of Pulmonary And Sleep Med, a practice of PRS Medical Managers(Customer 278). 
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 278
IF charindex('_0278_', db_name()) > 0
BEGIN
/*
INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (28, 'One Page TIOPASM Lab', 'Encounter form that prints on a single page', 28)

INSERT INTO PrintingFormDetails
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES
	(44, 9, 31, 'One Page TIOPASM Lab', 1)
*/
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

	<xsl:template name="CreateDiagnosesColumnLayout">

		<xsl:param name="maximumRowsInColumn"/>
		<xsl:param name="maximumColumns"/>
		<xsl:param name="totalElements"/>
		<xsl:param name="currentElement"/>
		<xsl:param name="currentRow"/>
		<xsl:param name="currentColumn"/>
		<xsl:param name="currentCategory" select="0"/>

		<xsl:variable name="xLeftOffset" select="0.5"/>
		<xsl:variable name="xOffset" select="1.875"/>
		<xsl:variable name="yTopOffset" select="5.82"/>
		<xsl:variable name="yOffset" select="0.15625"/>
		<xsl:variable name="codeXOffset" select="0.01"/>
		<xsl:variable name="descriptionXOffset" select="0.17"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeWidth" select=".20"/>
		<xsl:variable name="descriptionWidth" select="1.74"/>

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
          <line x1="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y1="{$yTopOffset + $codeYOffset + 0.10 + $yOffset * ($currentRow + 2)}in" x2="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset + $codeWidth - 0.09}in" y2="{$yTopOffset + $codeYOffset + 0.10 + $yOffset * ($currentRow + 2)}in"></line>

          <xsl:variable name="Description" select="data[@id=concat(''EncounterForm.1.DiagnosisName'', $currentElement)]"/>
          <xsl:variable name="Code" select="data[@id=concat(''EncounterForm.1.DiagnosisCode'', $currentElement)]"/>
          <xsl:variable name="CodeDescription" select="concat($Description, ''  -  '', $Code)"/>
          
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.10in" font-size="6pt">
            <xsl:value-of select="$CodeDescription"/>
          </text>
					
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
          <line x1="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y1="{$yTopOffset + $codeYOffset + 0.10 + $yOffset * ($currentRow + 1)}in" x2="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset + $codeWidth - 0.09}in" y2="{$yTopOffset + $codeYOffset + 0.10 + $yOffset * ($currentRow + 1)}in"></line>

          <xsl:variable name="Description" select="data[@id=concat(''EncounterForm.1.DiagnosisName'', $currentElement)]"/>
          <xsl:variable name="Code" select="data[@id=concat(''EncounterForm.1.DiagnosisCode'', $currentElement)]"/>
          <xsl:variable name="CodeDescription" select="concat($Description, ''  -  '', $Code)"/>
          
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" font-size="6pt">
            <xsl:value-of select="$CodeDescription"/>
          </text>
          
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
					font-size: 9pt;
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

					g#DiagnosisDetails line
					{
					stroke: black;
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
        <line x1="3.0in" y1="1.40in" x2="3.0in" y2="2.68in" stroke="black"></line>
        <text x="0.52in" y="1.55in" font-size="6pt">PATIENT CONTACT</text>
        <text x="0.52in" y="1.62in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.52in" y="1.77in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.52in" y="1.92in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.AddressLine21" />
            <text x="0.52in" y="2.07in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.52in" y="2.22in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:when>
          <xsl:otherwise>
            <text x="0.52in" y="1.92in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.52in" y="2.07in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:otherwise>
        </xsl:choose>
        <line x1="0.50in" y1="2.39125in" x2="8.0in" y2="2.39125in" stroke="black"></line>
        <text x="0.52in" y="2.43in" font-size="6pt">PATIENT NUMBER</text>
        <text x="0.52in" y="2.50in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.PatientID1" />
        <line x1="1.75in" y1="2.39125in" x2="1.75in" y2="2.68in" stroke="black"></line>
        <text x="1.77in" y="2.43in" font-size="6pt">DATE OF BIRTH</text>
        <text x="1.77in" y="2.50in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.DOB1" />
        <line x1="0.50in" y1="2.68in" x2="8.0in" y2="2.68in" stroke="black"></line>
      </g>
      
      <g id="InsuranceCoverage">
        <text x="3.02in" y="1.41in" font-weight="bold" font-size="6pt">INSURANCE COVERAGE</text>
        <text x="3.02in" y="1.55in" font-size="6pt">GUARANTOR</text>
        <text x="3.02in" y="1.62in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        <line x1="3.0in" y1="1.81375in" x2="8.0in" y2="1.81375in" stroke="black"></line>
        <text x="3.02in" y="1.84375in" font-size="6pt">PRIMARY INSURANCE</text>
        <text x="3.02in" y="1.91375in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1" />
        <line x1="3.0in" y1="2.1025in" x2="8.0in" y2="2.1025in" stroke="black"></line>
        <text x="3.02in" y="2.1325in" font-size="6pt">SECONDARY INSURANCE</text>
        <text x="3.02in" y="2.2025in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.SecondaryIns1" />
        <text x="3.02in" y="2.42125in" font-size="6pt">COPAY</text>
        <text x="3.02in" y="2.49125in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.Copay1" />
        <line x1="4.25in" y1="2.39125in" x2="4.25in" y2="2.68in" stroke="black"></line>
        <text x="4.27in" y="2.42125in" font-size="6pt">DEDUCTIBLE</text>
        <text x="4.27in" y="2.49125in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.Deductible1" />
      </g>
      
      <g id="EncounterInformation">
        <text x="5.52in" y="1.41in" font-weight="bold" font-size="6pt">ENCOUNTER INFORMATION</text>
        <line x1="5.50in" y1="1.40in" x2="5.50in" y2="2.68in" stroke="black"></line>
        <text x="5.52in" y="1.55in" font-size="6pt">DATE/TIME</text>
        <text x="5.52in" y="1.62in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1" />
        <line x1="6.75in" y1="1.525in" x2="6.75in" y2="2.1025in" stroke="black"></line>
        <text x="6.77in" y="1.55in" font-size="6pt">TICKET NUMBER</text>
        <text x="6.77in" y="1.62in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.TicketNumber1" />
        <text x="5.52in" y="1.84375in" font-size="6pt">PLACE OF SERVICE</text>
        <text x="5.52in" y="1.91375in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.POS1" />
        <text x="6.77in" y="1.84375in" font-size="6pt">REASON</text>
        <text x="6.77in" y="1.91375in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.Reason1" />
        <text x="5.52in" y="2.1325in" font-size="6pt">PROVIDER</text>
        <text x="5.52in" y="2.2025in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.52in" y="2.42125in" font-size="6pt">REFERRING PROVIDER</text>
        <text x="5.52in" y="2.49125in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.RefProvider1" />
      </g>

      <g id="PulmonaryTest">
        <text x="0.50in" y="2.79in">***************************************************************************************************************************************************************************************</text>
        <text x="0.52in" y="2.93in" font-size="7pt">Pulmonary Function Test</text>
        <text x="0.52in" y="3.06in" font-size="7pt">94010-59_____    -  Pre-Spirometry only</text>
        <text x="0.52in" y="3.30in" font-size="7pt">94060-59_____    -  Bronchodilation Evaluation</text>
        <text x="0.52in" y="3.54in" font-size="7pt">94720-59_____    -  DLCO</text>
        <text x="0.52in" y="3.78in" font-size="7pt">94360-59_____    -  Airflow Resistance (via body box)</text>
        <text x="0.52in" y="4.02in" font-size="7pt">94260-59_____    -  Thoracic Gas Volume</text>
        <text x="0.52in" y="4.26in" font-size="7pt">93720-59_____    -  Body Box</text>
        <text x="0.52in" y="4.50in" font-size="7pt">94664-59_____    -  Demo/Eval.-Inhaler,Nebulizer..........</text>
        <text x="0.52in" y="4.74in" font-size="7pt">94150-59_____    -  Total Vital Capacity (Slow)</text>
        <text x="0.52in" y="4.98in" font-size="7pt">94240-59_____    -  FRC</text>
        <text x="0.52in" y="5.22in" font-size="7pt">94620-59_____    -  Pulmonary Stress Test; Simple</text>
        <text x="0.52in" y="5.46in" font-size="7pt">94621-59_____    -  Pulmonary Stress Test; Complex</text>
        <text x="0.52in" y="5.70in" font-size="7pt">94200-59_____    -  MVU</text>
        <text x="4.25in" y="2.93in">*</text>
        <text x="4.33in" y="2.94in" font-size="7pt">Vital Signs:</text>
        <text x="4.25in" y="3.06in">*</text>
        <text x="4.25in" y="3.18in">*</text>
        <text x="4.25in" y="3.30in">*</text>
        <text x="4.33in" y="3.31in" font-size="7pt">Weight:</text>
        <line x1="4.63in" y1="3.43in" x2="5.20in" y2="3.43in" stroke="black"></line>
        <text x="4.25in" y="3.42in">*</text>
        <text x="4.25in" y="3.54in">*</text>
        <text x="4.25in" y="3.66in">*</text>
        <text x="4.25in" y="3.78in">*</text>
        <text x="4.33in" y="3.79in" font-size="7pt">Blood Pressure:</text>
        <line x1="4.93in" y1="3.91in" x2="5.20in" y2="3.91in" stroke="black"></line>
        <text x="4.25in" y="3.90in">*</text>
        <text x="4.25in" y="4.02in">*</text>
        <text x="4.25in" y="4.14in">*</text>
        <text x="4.25in" y="4.26in">*</text>
        <text x="4.33in" y="4.27in" font-size="7pt">Temp:</text>
        <line x1="4.59in" y1="4.39in" x2="5.20in" y2="4.39in" stroke="black"></line>
        <text x="6.33in" y="4.27in" font-size="7pt">o2Sat:</text>
        <line x1="6.59in" y1="4.39in" x2="7.10in" y2="4.39in" stroke="black"></line>
        <text x="4.25in" y="4.38in">*</text>
        <text x="4.25in" y="4.50in">*</text>
        <text x="4.25in" y="4.62in">*</text>
        <text x="4.25in" y="4.74in">*</text>
        <text x="4.33in" y="4.75in" font-size="7pt">Pulse:</text>
        <line x1="4.58in" y1="4.87in" x2="5.20in" y2="4.87in" stroke="black"></line>
        <text x="4.25in" y="4.86in">*</text>
        <text x="4.25in" y="4.98in">*</text>
        <text x="4.25in" y="5.10in">*</text>
        <text x="4.25in" y="5.22in">*</text>
        <text x="4.33in" y="5.23in" font-size="7pt">Height:</text>
        <line x1="4.61in" y1="5.35in" x2="5.20in" y2="5.35in" stroke="black"></line>
        <text x="4.25in" y="5.34in">*</text>
        <text x="4.25in" y="5.46in">*</text>
        <text x="4.25in" y="5.58in">*</text>
        <text x="4.25in" y="5.70in">*</text>
        <text x="0.50in" y="5.81in">***************************************************************************************************************************************************************************************</text>
      </g>

			<g id="DiagnosisDetails">
        <text x="4.07in" y="5.96in" font-size="7pt">Diagnosis</text>
				<xsl:call-template name="CreateDiagnosesColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="20"/>
					<xsl:with-param name="maximumColumns" select="4"/>
					<xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
        <text x="0.54in" y="9.28in" font-size="6pt">*fifth digit for asthma: 0=w/out status asthmaticus, 1=w/status asthmaticus, 2=w/axercerbation</text>
        <text x="0.50in" y="9.33in">---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------</text>
			</g>

      <g id="AccountBalance">
        <rect x="0.50in" y="9.47in" width="7.50in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <text x="0.54in" y="9.48in" font-weight="bold" font-size="6pt">PREVIOUS ACCOUNT BALANCE</text>
        <text x="0.54in" y="9.625in" font-size="6pt">LAST INSURANCE PAYMENT</text>
        <text x="0.57in" y="9.705in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.LastInsPay1" />
        <line x1="1.75in" y1="9.595in" x2="1.75in" y2="10.17in" stroke="black"></line>
        <text x="1.79in" y="9.625in" font-size="6pt">PREVIOUS INS BALANCE</text>
        <text x="1.82in" y="9.7025in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.InsBalance1" />
        <line x1="0.50in" y1="9.8825in" x2="5.50in" y2="9.8825in" stroke="black"></line>
        <text x="0.54in" y="9.9125in" font-size="6pt">LAST PATIENT PAYMENT</text>
        <text x="0.57in" y="9.9925in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.79in" y="9.9125in" font-size="6pt">PREVIOUS PATIENT BALANCE</text>
        <text x="1.82in" y="9.9925in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.PatientBalance1" />
        <line x1="0.50in" y1="10.17in" x2="8.0in" y2="10.17in" stroke="black"></line>
      </g>

      <g id="AccountActivity">
        <text x="3.04in" y="9.48in" font-weight="bold" font-size="6pt">TODAY''S ACCOUNT ACTIVITY</text>
        <line x1="3.0in" y1="9.595in" x2="3.0in" y2="10.17in" stroke="black"></line>
        <text x="3.04in" y="9.625in" font-size="6pt">TODAY''S CHARGES</text>
        <line x1="4.25in" y1="9.595in" x2="4.25in" y2="10.17in" stroke="black"></line>
        <text x="4.29in" y="9.625in" font-size="6pt">TODAY''S ADJUSTMENTS</text>
        <text x="3.04in" y="9.9125in" font-size="6pt">TODAY''S AMOUNT DUE</text>
        <text x="4.29in" y="9.9125in" font-size="6pt">NEXT APPOINTMENT</text>
        <line x1="5.50in" y1="9.595in" x2="5.50in" y2="10.17in" stroke="black"></line>
      </g>

      <g id="PaymentOnAccount">
        <text x="5.54in" y="9.48in" font-weight="bold" font-size="6pt">PAYMENT ON ACCOUNT</text>
        <text x="5.54in" y="9.625in" font-size="6pt">PAYMENT METHOD</text>
        <circle cx="5.65in" cy="9.805in" r="0.04in" fill="none" stroke="black"/>
        <text x="5.85in" y="9.765in" font-size="6pt" >CASH</text>
        <circle cx="5.65in" cy="9.955in" r="0.04in" fill="none" stroke="black"/>
        <text x="5.85in" y="9.915in" font-size="6pt" >CREDIT CARD</text>
        <circle cx="5.65in" cy="10.105in" r="0.04in" fill="none" stroke="black"/>
        <text x="5.85in" y="10.065in" font-size="6pt" >CHECK #</text>
        <line x1="6.75in" y1="9.595in" x2="6.75in" y2="10.17in" stroke="black"></line>
        <text x="6.79in" y="9.625in" font-size="6pt">TODAY''S PAYMENT</text>
        <line x1="6.75in" y1="9.8825in" x2="8.0in" y2="9.8825in" stroke="black"></line>
        <text x="6.79in" y="9.9125in" font-size="6pt">BALANCE DUE</text>
      </g>

		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 44

END