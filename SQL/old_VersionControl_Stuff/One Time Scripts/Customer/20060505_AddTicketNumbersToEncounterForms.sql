---------------------------------------------------------------------------------------------
-- Case 10389: Add ticket number to encounter forms. 
---------------------------------------------------------------------------------------------

-- One Page
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
    <xsl:variable name="xOffset" select="2.506"/>
    <xsl:variable name="yTopOffset" select="3.143"/>
    <xsl:variable name="yOffset" select=".1067"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".437"/>
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
          <rect x="{$xLeftOffset + $xOffset * ($currentColumn - 1)}in" y="{$yTopOffset + $yOffset * ($currentRow - 1) + $rectangleYOffset}in" width="2.4975in" height="0.11in" style="fill:black" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" style="fill:white" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

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

  <xsl:template name="CreateDiagnosisColumnLayout">

    <xsl:param name="maximumRowsInColumn"/>
    <xsl:param name="maximumRowsInLastColumn"/>
    <xsl:param name="maximumColumns"/>
    <xsl:param name="totalElements"/>
    <xsl:param name="currentElement"/>
    <xsl:param name="currentRow"/>
    <xsl:param name="currentColumn"/>
    <xsl:param name="currentCategory" select="0"/>

    <xsl:variable name="xLeftOffset" select="0.495"/>
    <xsl:variable name="xOffset" select="2.506"/>
    <xsl:variable name="yTopOffset" select="7.173"/>
    <xsl:variable name="yOffset" select=".1067"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".437"/>
    <xsl:variable name="rectangleYOffset" select="0.001"/>

    <xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.DiagnosisCategory'', $currentElement)]"/>

      <xsl:choose>
        <xsl:when test="(($currentColumn != $maximumColumns) and
                        (($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)) or
                        ($currentColumn = $maximumColumns) and 
                        (($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInLastColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInLastColumn)))">
          <!-- There isn''t enough room to print on this column -->

          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
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
          <rect x="{$xLeftOffset + $xOffset * ($currentColumn - 1)}in" y="{$yTopOffset + $yOffset * ($currentRow - 1) + $rectangleYOffset}in" width="2.4977in" height="0.11in" style="fill:black" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" style="fill:white" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
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
    <xsl:variable name="ProcedureCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])"/>
    <xsl:variable name="DiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])"/>
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

          g#ProcedureDetails,g#DiagnosisDetails text
          {
          font-size: 6pt;
          }
        </style>
      </defs>
      
      <!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="EncounterForm.OnePage.jpg"></image>
      -->
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://61cab830-b778-4ed6-a3e7-ac49d343bfda?type=global"></image>
      <g id="Title">
        <text x="0.49in" y=".42in" width="5in" height="0.1in" valueSource="EncounterForm.1.TemplateName1" />
      </g>
      <g id="PracticeInformation">
        <text x="0.49in" y=".7in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeName1" />
        <text x="0.49in" y=".85in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeAddress1" />
        <text x="0.49in" y="1in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticePhoneFax1" />
        <text x="0.49in" y="1.15in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeTaxID1" />
      </g>
      <g id="PatientInformation">
        <text x="0.54in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.54in" y="1.75in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine21" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:when>
          <xsl:otherwise>
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:otherwise>
        </xsl:choose>
        <text x="0.54in" y="2.52in" width="1.19in" height="0.1in" valueSource="EncounterForm.1.PatientID1" />
        <text x="1.75in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.DOB1" />
      </g>
      <g id="InsuranceCoverage">
        <text x="3.052in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        <text x="3.052in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PrimaryIns1" />
        <text x="3.052in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.SecondaryIns1" />
        <text x="3.052in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Copay1" />
        <text x="4.34in" y="2.52in" width="1.19in" height="0.1in" valueSource="EncounterForm.1.Deductible1" />
      </g>
      <g id="EncounterInformation">
        <text x="5.565in" y="1.6in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="6.937in" y="1.53in" width="1.0in" height="0.1in" font-size="5pt">TICKET</text>
        <text x="6.937in" y="1.6in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.TicketNumber1" />
        <text x="5.565in" y="1.9in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.POS1" />
        <text x="6.937in" y="1.9in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.Reason1" />
        <text x="5.565in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.565in" y="2.52in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.RefProvider1" />
      </g>
      <g id="ProcedureDetails">
        <xsl:call-template name="CreateProcedureColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="35"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$ProcedureCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>
      <g id="DiagnosisDetails">
        <xsl:call-template name="CreateDiagnosisColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="22"/>
          <xsl:with-param name="maximumRowsInLastColumn" select="17"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>
      <g id="PreviousAccountBalance">
        <text x="0.537in" y="9.99in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastInsPay1" />
        <text x="0.537in" y="10.29in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.77in" y="9.99in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.InsBalance1" />
        <text x="1.77in" y="10.29in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientBalance1" />
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 12

-- One Page (Large Font)
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
    <xsl:variable name="xOffset" select="2.506"/>
    <xsl:variable name="yTopOffset" select="3.143"/>
    <xsl:variable name="yOffset" select=".1067"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".437"/>
    <xsl:variable name="rectangleYOffset" select="0.001"/>
	  <xsl:variable name="yAdditionalOffset" select="-.027"/>

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
          <rect x="{$xLeftOffset + $xOffset * ($currentColumn - 1)}in" y="{$yTopOffset + $yOffset * ($currentRow - 1) + $rectangleYOffset}in" width="2.4975in" height="0.11in" style="fill:black" />
		  <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yAdditionalOffset + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" style="fill:white" />

		  <!-- Creates the detail lines -->
		  <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yAdditionalOffset + $yOffset * $currentRow}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
		  <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yAdditionalOffset + $yOffset * $currentRow}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

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
			<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yAdditionalOffset + $yOffset * ($currentRow - 1)}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
			<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yAdditionalOffset + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

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

  <xsl:template name="CreateDiagnosisColumnLayout">

    <xsl:param name="maximumRowsInColumn"/>
    <xsl:param name="maximumRowsInLastColumn"/>
    <xsl:param name="maximumColumns"/>
    <xsl:param name="totalElements"/>
    <xsl:param name="currentElement"/>
    <xsl:param name="currentRow"/>
    <xsl:param name="currentColumn"/>
    <xsl:param name="currentCategory" select="0"/>

    <xsl:variable name="xLeftOffset" select="0.495"/>
    <xsl:variable name="xOffset" select="2.506"/>
    <xsl:variable name="yTopOffset" select="7.173"/>
    <xsl:variable name="yOffset" select=".1067"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".437"/>
    <xsl:variable name="rectangleYOffset" select="0.001"/>
	  <xsl:variable name="yAdditionalOffset" select="-.027"/>

	  <xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.DiagnosisCategory'', $currentElement)]"/>

      <xsl:choose>
        <xsl:when test="(($currentColumn != $maximumColumns) and
                        (($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)) or
                        ($currentColumn = $maximumColumns) and 
                        (($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInLastColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInLastColumn)))">
          <!-- There isn''t enough room to print on this column -->

          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
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
          <rect x="{$xLeftOffset + $xOffset * ($currentColumn - 1)}in" y="{$yTopOffset + $yOffset * ($currentRow - 1) + $rectangleYOffset}in" width="2.4977in" height="0.11in" style="fill:black" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yAdditionalOffset  + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" font-size="9pt" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" style="fill:white" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yAdditionalOffset  + $yOffset * $currentRow}in" width=".4in" height="0.1in" font-size="8pt" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yAdditionalOffset  + $yOffset * $currentRow}in" width="1.78in" height="0.1in" font-size="9pt" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yAdditionalOffset  + $yOffset * ($currentRow - 1)}in" width=".4in" height="0.1in" font-size="8pt" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yAdditionalOffset  + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" font-size="9pt" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
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
    <xsl:variable name="ProcedureCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])"/>
    <xsl:variable name="DiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])"/>
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="300">
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

          g#ProcedureDetails text
          {
          font-size: 9pt;
          }
        </style>
      </defs>
      
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://61cab830-b778-4ed6-a3e7-ac49d343bfda?type=global"></image>
      <!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="EncounterForm.OnePage.jpg"></image>
      -->
      <g id="Title">
        <text x="0.49in" y=".42in" width="8in" height="0.1in" valueSource="EncounterForm.1.TemplateName1" />
      </g>
      <g id="PracticeInformation">
        <text x="0.49in" y=".7in" width="8in" height="0.1in" valueSource="EncounterForm.1.PracticeName1" />
        <text x="0.49in" y=".85in" width="8in" height="0.1in" valueSource="EncounterForm.1.PracticeAddress1" />
        <text x="0.49in" y="1in" width="8in" height="0.1in" valueSource="EncounterForm.1.PracticePhoneFax1" />
        <text x="0.49in" y="1.15in" width="8in" height="0.1in" valueSource="EncounterForm.1.PracticeTaxID1" />
      </g>
      <g id="PatientInformation">
        <text x="0.54in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.54in" y="1.75in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine21" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:when>
          <xsl:otherwise>
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:otherwise>
        </xsl:choose>
        <text x="0.54in" y="2.52in" width="1.19in" height="0.1in" valueSource="EncounterForm.1.PatientID1" />
        <text x="1.75in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.DOB1" />
      </g>
      <g id="InsuranceCoverage">
        <text x="3.052in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        <text x="3.052in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PrimaryIns1" />
        <text x="3.052in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.SecondaryIns1" />
        <text x="3.052in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Copay1" />
        <text x="4.34in" y="2.52in" width="1.19in" height="0.1in" valueSource="EncounterForm.1.Deductible1" />
      </g>
      <g id="EncounterInformation">
        <text x="5.565in" y="1.6in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="6.937in" y="1.53in" width="1.0in" height="0.1in" font-size="5pt">TICKET</text>
        <text x="6.937in" y="1.6in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.TicketNumber1" />
        <text x="5.565in" y="1.9in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.POS1" />
        <text x="6.937in" y="1.9in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.Reason1" />
        <text x="5.565in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.565in" y="2.52in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.RefProvider1" />
      </g>
      <g id="ProcedureDetails">
        <xsl:call-template name="CreateProcedureColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="35"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$ProcedureCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>
      <g id="DiagnosisDetails">
        <xsl:call-template name="CreateDiagnosisColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="22"/>
          <xsl:with-param name="maximumRowsInLastColumn" select="17"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>
      <g id="PreviousAccountBalance">
        <text x="0.537in" y="9.99in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastInsPay1" />
        <text x="0.537in" y="10.29in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.77in" y="9.99in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.InsBalance1" />
        <text x="1.77in" y="10.29in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientBalance1" />
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 22

-- Two Page
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
  <xsl:template name="CreateColumnLayout">

    <xsl:param name="maximumRowsInColumn"/>
    <xsl:param name="maximumColumns"/>
    <xsl:param name="totalElements"/>
    <xsl:param name="currentElement"/>
    <xsl:param name="currentRow"/>
    <xsl:param name="currentColumn"/>
    <xsl:param name="currentCategory" select="0"/>

    <xsl:variable name="xLeftOffset" select="0.495"/>
    <xsl:variable name="xOffset" select="2.506"/>
    <xsl:variable name="yTopOffset" select="3.058"/>
    <xsl:variable name="yOffset" select=".1065"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".38"/>
    <xsl:variable name="rectangleYOffset" select="0.001"/>

    <xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.ProcedureCategory'', $currentElement)]"/>

      <xsl:choose>
        <xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
          <!-- There isn''t enough room to print on this column -->

          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateColumnLayout">
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
          <rect x="{$xLeftOffset + $xOffset * ($currentColumn - 1)}in" y="{$yTopOffset + $yOffset * ($currentRow - 1) + $rectangleYOffset}in" width="2.4975in" height="0.11in" style="fill:black" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.86in" height="0.1in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" style="fill:white" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".35in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.86in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateColumnLayout">
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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".35in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.86in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateColumnLayout">
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

          g#ProcedureDetails text
          {
          font-size: 6pt;
          }
        </style>
      </defs>

      <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://e8fc4cea-f93a-4d3a-a1d4-41f19fb67ef7?type=global"></image>
      <!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="EncounterForm.TwoPage.1.jpg"></image>
      -->
      <g id="Title">
        <text x="0.49in" y=".42in" width="5in" height="0.1in" valueSource="EncounterForm.1.TemplateName1" />
      </g>
      <g id="PracticeInformation">
        <text x="0.49in" y=".7in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeName1" />
        <text x="0.49in" y=".85in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeAddress1" />
        <text x="0.49in" y="1in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticePhoneFax1" />
        <text x="0.49in" y="1.15in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeTaxID1" />
      </g>
      <g id="PatientInformation">
        <text x="0.54in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.54in" y="1.75in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine21" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:when>
          <xsl:otherwise>
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:otherwise>
        </xsl:choose>
        <text x="0.54in" y="2.52in" width="1.19in" height="0.1in" valueSource="EncounterForm.1.PatientID1" />
        <text x="1.75in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.DOB1" />
      </g>
      <g id="InsuranceCoverage">
        <text x="3.052in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        <text x="3.052in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PrimaryIns1" />
        <text x="3.052in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.SecondaryIns1" />
        <text x="3.052in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Copay1" />
        <text x="4.34in" y="2.52in" width="1.19in" height="0.1in" valueSource="EncounterForm.1.Deductible1" />
      </g>
      <g id="EncounterInformation">
        <text x="5.565in" y="1.6in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="6.937in" y="1.53in" width="1.0in" height="0.1in" font-size="5pt">TICKET</text>
        <text x="6.937in" y="1.6in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.TicketNumber1" />
        <text x="5.565in" y="1.9in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.POS1" />
        <text x="6.937in" y="1.9in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.Reason1" />
        <text x="5.565in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.565in" y="2.52in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.RefProvider1" />
      </g>
      <g id="ProcedureDetails">
        <xsl:call-template name="CreateColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="62"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$ProcedureCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>
      <g id="PreviousAccountBalance">
        <text x="0.537in" y="9.99in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastInsPay1" />
        <text x="0.537in" y="10.29in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.77in" y="9.99in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.InsBalance1" />
        <text x="1.77in" y="10.29in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientBalance1" />
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 13

-- Two Page Version 2
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
  <xsl:template name="CreateHorizontalLines">

    <xsl:param name="maximumRows"/>
    <xsl:param name="currentRow"/>

    <xsl:variable name="xLeftOffset" select="0.5"/>
    <xsl:variable name="yTopOffset" select="2.32475"/>
    <!-- 2.3125 -->
    <xsl:variable name="yOffset" select=".15625"/>
    <xsl:variable name="lineWidth" select="7.5"/>
    <xsl:variable name="headerYOffset" select="0.01"/>
    <xsl:variable name="codeXOffset" select=".02"/>
    <xsl:variable name="descriptionXOffset" select=".27"/>
    <xsl:variable name="diagnosisXOffset" select="2.273"/>

    <xsl:if test="$maximumRows >= $currentRow">
      <!-- Creates the actual horizontal line for the row -->
      <line x1="{$xLeftOffset}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

      <!-- Creates the little diagnosis vertical line -->
      <line x1="{$xLeftOffset + 2.375}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + 2.375}in" y2="{$yTopOffset -.03 + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 4.875}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + 4.875}in" y2="{$yTopOffset -.03 + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.375}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + 7.375}in" y2="{$yTopOffset -.03 + $yOffset * ($currentRow - 1)}in" />

      <!-- Calls the same template recursively -->
      <xsl:call-template name="CreateHorizontalLines">
        <xsl:with-param name="maximumRows" select="$maximumRows"/>
        <xsl:with-param name="currentRow" select="$currentRow + 1"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$maximumRows = $currentRow">
      <!-- Print the top horizontal dotted line -->
      <line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset - $yOffset}in" />

      <!-- Print the vertical lines -->
      <line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + .25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + .25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 2.25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 2.5}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.5}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 2.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 4.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 5}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 5.25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.5}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.5}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

      <!-- Add procedure header -->
      <rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
      <text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" font-family="Arial" font-weight="bold" font-size="7pt">PROCEDURES</text>

      <!-- Add headers -->
      <text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Code</text>
      <text x="{$xLeftOffset + $descriptionXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".5in" height="0.1in">Name</text>
      <text x="{$xLeftOffset + $diagnosisXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Diag</text>
      <text x="{$xLeftOffset + $codeXOffset + 2.5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Code</text>
      <text x="{$xLeftOffset + $descriptionXOffset + 2.5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".5in" height="0.1in">Name</text>
      <text x="{$xLeftOffset + $diagnosisXOffset + 2.5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Diag</text>
      <text x="{$xLeftOffset + $codeXOffset + 5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Code</text>
      <text x="{$xLeftOffset + $descriptionXOffset + 5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".5in" height="0.1in">Name</text>
      <text x="{$xLeftOffset + $diagnosisXOffset + 5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Diag</text>
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
  <xsl:template name="CreateProcedureColumnLayout">

    <xsl:param name="maximumRowsInColumn"/>
    <xsl:param name="maximumColumns"/>
    <xsl:param name="totalElements"/>
    <xsl:param name="currentElement"/>
    <xsl:param name="currentRow"/>
    <xsl:param name="currentColumn"/>
    <xsl:param name="currentCategory" select="0"/>

    <xsl:variable name="xLeftOffset" select="0.5"/>
    <xsl:variable name="xOffset" select="2.5"/>
    <xsl:variable name="yTopOffset" select="1.82475"/>
    <!-- 1.8125 -->
    <xsl:variable name="yOffset" select=".15625"/>
    <xsl:variable name="codeXOffset" select=".01"/>
    <xsl:variable name="descriptionXOffset" select=".27"/>
    <xsl:variable name="codeYOffset" select="0.04"/>
    <xsl:variable name="descriptionYOffset" select="0.028"/>
    <xsl:variable name="codeWidth" select=".27"/>
    <xsl:variable name="descriptionWidth" select="2"/>

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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.1in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" class="bold" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

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

  <xsl:template match="/formData/page">
    <xsl:variable name="ProcedureCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])"/>
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

        <!-- Practice Information -->
        <g>
          <text x="0.25in" y="0.50in" width="8in" height="0.1in" font-family="Arial" class="header" valueSource="EncounterForm.1.FullPracticeName1" />"
          <text x="0.25in" y="0.70in" width="8in" height="0.1in" font-family="Arial Narrow" font-size="9pt" class="centeredtext" valueSource="EncounterForm.1.FullPracticeAddress1" />
        </g>


        <g>
          <!-- Patient box -->
          <!-- Header -->
          <rect x="0.50in" y="0.9375in" width="4.90in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
          <rect x="0.50in" y="0.9375in" width="4.90in" height="0.875in" fill="none" stroke="black" stroke-width="0.5pt"/>
          <text x="0.54in" y="0.9375in" font-family="Arial" font-weight="bold" font-size="7pt">PATIENT</text>

          <!-- Fields captions -->
          <text x="0.15in" y="1.10in" width="1in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">NAME:</text>
          <text x="3.65in" y="1.10in" width="1in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PATIENT #:</text>

          <text x="0.15in" y="1.24in" width="1in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">ADDRESS:</text>

          <text x="0.15in" y="1.38in" width="1in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PHONE(S):</text>
          <text x="3.65in" y="1.38in" width="1in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DOB/AGE:</text>

          <text x="0.15in" y="1.52in" width="1in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PRIMARY:</text>
          <text x="3.65in" y="1.52in" width="1in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">GENDER:</text>

          <text x="0.15in" y="1.66in" width="1in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">SECONDARY:</text>
          <text x="3.65in" y="1.66in" width="1in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">GUARANTOR:</text>

          <!-- Patient fields -->
          <text x="1.20in" y="1.0390in" width="3.00in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="11pt" valueSource="EncounterForm.1.PatientName1"></text>
          <text x="4.70in" y="1.07in" width="0.75in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.PatientID1"></text>

          <xsl:variable name="patFullAddress" select="concat(data[@id=''EncounterForm.1.AddressLine11''], '' '', data[@id=''EncounterForm.1.AddressLine21''], '', '', data[@id=''EncounterForm.1.CityStateZip1''])"/>

          <text x="1.20in" y="1.21in" width="4.25in" height="0.1in" font-family="Arial Narrow" font-size="9pt">
            <xsl:value-of select="$patFullAddress"/>
          </text>

          <text x="1.20in" y="1.38in" width="3.00in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.FullPhone1"></text>
          <text x="4.70in" y="1.38in" width="0.75in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.DOBAge1"></text>

          <text x="1.20in" y="1.52in" width="3.00in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.PrimaryInsWithCopay1"></text>
          <text x="4.70in" y="1.52in" width="0.75in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.Gender1"></text>

          <text x="1.20in" y="1.66in" width="2.85in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.SecondaryIns1"></text>
          <text x="4.70in" y="1.66in" width="0.75in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.ResponsiblePerson1"></text>

        </g>

        <!-- Visit box -->
        <g>
          <rect x="5.50in" y="0.9375in" width="2.50in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
          <rect x="5.50in" y="0.9375in" width="2.50in" height="0.875in" fill="none" stroke="black" stroke-width="0.5pt" />

          <!-- Labels -->
          <text x="5.55in" y="0.9375in" font-family="Arial" font-weight="bold" font-size="7pt">VISIT</text>
          <text x="5.50in" y="1.10in" width="0.60in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PROVIDER:</text>
          <text x="5.50in" y="1.24in" width="0.60in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">LOCATION:</text>
          <text x="5.50in" y="1.38in" width="0.60in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DATE/TIME:</text>
          <text x="6.88in" y="1.38in" width="0.60in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">TICKET #:</text>
          <text x="5.50in" y="1.52in" width="0.60in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">REASON:</text>
          <text x="5.50in" y="1.66in" width="0.60in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">REFERRING:</text>
          
          
          <text x="6.13in" y="1.039in" width="1.93in" height="0.1in" font-family="Arial Narrow" font-weight="bold" font-size="11pt" valueSource="EncounterForm.1.Provider1" />
          <text x="6.13in" y="1.21in" width="1.93in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.POS1" />
          <text x="6.13in" y="1.38in" width="0.95in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.AppDateTime1" />
          <text x="7.51in" y="1.38in" width="0.53in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.TicketNumber1" />
          <text x="6.13in" y="1.52in" width="1.9in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.Reason1" />
          <text x="6.13in" y="1.66in" width="1.9in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.RefProvider1" />
        </g>
      </g>

      <g id="ProceduresGrid">
        <xsl:call-template name="CreateHorizontalLines">
          <xsl:with-param name="maximumRows" select="53"/>
          <xsl:with-param name="currentRow" select="1"/>
        </xsl:call-template>
      </g>

      <g id="ProcedureDetails">
        <xsl:call-template name="CreateProcedureColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="53"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$ProcedureCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 17

-- One Page No Grid
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
  
  <xsl:template match="/formData/page">
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
        </style>
      </defs>
      
      <!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="C:\SVN\Kareo\ThirdParty\SharpVectorGraphics\SVGTester\EncounterForm.OnePage.NoGrid.Cust112.jpg"></image>
      -->
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://04f7ee5e-e725-45b3-8593-f47d151d16fb?type=global"></image>

      <g id="Title">
        <text x="0.49in" y=".42in" width="5in" height="0.1in" valueSource="EncounterForm.1.TemplateName1" />
      </g>
      <g id="PracticeInformation">
        <text x="0.49in" y=".7in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeName1" />
        <text x="0.49in" y=".85in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeAddress1" />
        <text x="0.49in" y="1in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticePhoneFax1" />
        <text x="0.49in" y="1.15in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeTaxID1" />
      </g>
      <g id="PatientInformation">
        <text x="0.54in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.54in" y="1.75in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine21" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:when>
          <xsl:otherwise>
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:otherwise>
        </xsl:choose>
        <text x="0.54in" y="2.52in" width="1.19in" height="0.1in" valueSource="EncounterForm.1.PatientID1" />
        <text x="2.28in" y="2.445in" width="1.0in" height="0.1in" font-family="Arial" font-size="5pt">, AGE</text>
        <text x="1.75in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.DOBAge1" />
      </g>
      <g id="InsuranceCoverage">
        <text x="3.052in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        <text x="3.798in" y="1.819in" width="0.1in" height="0.1in" font-family="Arial" font-size="5pt">:</text>
        <text x="3.862in" y="1.797in" width="1.7in" height="0.1in" valueSource="EncounterForm.1.PrimaryIns1" font-size="8pt" />
        <text x="3.057in" y="1.985in" width="1.0in" height="0.1in" font-family="Arial" font-size="5pt">POL#:</text>
        <text x="3.312in" y="1.955in" width="0.99in" height="0.1in" valueSource="EncounterForm.1.PolicyNumber1" font-size="8pt" />
        <text x="4.302in" y="1.985in" width="1.0in" height="0.1in" font-family="Arial" font-size="5pt">GRP#:</text>
        <text x="4.562in" y="1.955in" width="0.99in" height="0.1in" valueSource="EncounterForm.1.GroupNumber1" font-size="8pt" />
        <text x="3.052in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.SecondaryIns1" />
        <text x="3.052in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Copay1" />
        <text x="4.34in" y="2.52in" width="1.18in" height="0.1in" valueSource="EncounterForm.1.Deductible1" />
      </g>
      <g id="EncounterInformation">
        <text x="5.565in" y="1.6in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="6.937in" y="1.53in" width="1.0in" height="0.1in" font-size="5pt">TICKET</text>
        <text x="6.937in" y="1.6in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.TicketNumber1" />
        <text x="5.565in" y="1.9in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.POS1" />
        <text x="6.937in" y="1.9in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.Reason1" />
        <text x="5.565in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.565in" y="2.52in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.RefProvider1" />
      </g>
      <g id="PreviousAccountBalance">
        <text x="0.537in" y="3.02in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastInsPay1" />
        <text x="0.537in" y="3.32in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.77in" y="3.02in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.InsBalance1" />
        <text x="1.77in" y="3.32in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientBalance1" />
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 26