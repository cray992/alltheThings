-- Case 9922 - New one page large font encounter form
INSERT INTO EncounterFormType
VALUES(
		8,
		'One Page (Large Font)',
		'Encounter form that prints on a single page with a large font',
		1)

INSERT INTO PrintingFormDetails
VALUES(
		22,
		9,
		9,
		'Encounter Form (One Page Large Font)',
		'<?xml version="1.0" encoding="utf-8"?>
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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yAdditionalOffset  + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" style="fill:white" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yAdditionalOffset  + $yOffset * $currentRow}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yAdditionalOffset  + $yOffset * $currentRow}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yAdditionalOffset  + $yOffset * ($currentRow - 1)}in" width=".4in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yAdditionalOffset  + $yOffset * ($currentRow - 1)}in" width="1.78in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

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

          g#ProcedureDetails,g#DiagnosisDetails text
          {
          font-size: 9pt;
          }
        </style>
      </defs>

      <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://f5743d27-4626-4343-bd4a-9c85c16cade6?type=global"></image>
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
        <text x="0.54in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientID1" />
        <text x="1.75in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.DOB1" />
      </g>
      <g id="InsuranceCoverage">
        <text x="3.052in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        <text x="3.052in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PrimaryIns1" />
        <text x="3.052in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.SecondaryIns1" />
        <text x="3.052in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Copay1" />
        <text x="4.34in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Deductible1" />
      </g>
      <g id="EncounterInformation">
        <text x="5.565in" y="1.6in" width="1.3in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="5.565in" y="1.9in" width="1.3in" height="0.1in" valueSource="EncounterForm.1.POS1" />
        <text x="6.937in" y="1.9in" width="1.1in" height="0.1in" valueSource="EncounterForm.1.Reason1" />
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
        <text x="0.537in" y="9.99in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.LastInsPay1" />
        <text x="0.537in" y="10.29in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.77in" y="9.99in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.InsBalance1" />
        <text x="1.77in" y="10.29in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientBalance1" />
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>',
		1)