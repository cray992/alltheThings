update dbo.PrintingFormDetails 
set SVGDefinition = '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg" version="1.0">
  <xsl:decimal-format name="default-format" NaN="0.00" />
  <!--  
        Takes in the number of rows to draw the dotted horizontal lines for.
        
        Parameters:
        maximumRows - max number of rows allowed in a column
        currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)   
  -->
  <xsl:template name="CreateGridLines">
    <xsl:param name="maximumRows" />
    <xsl:param name="currentRow" />
    <xsl:param name="headerText" />
    <xsl:param name="yTopOffset" />
    <xsl:variable name="xLeftOffset" select="0.50" />
    <xsl:variable name="yOffset" select="0.23" />
    <xsl:variable name="lineWidth" select="7.50" />
    <xsl:variable name="headerYOffset" select="0.083" />
    <xsl:variable name="codeXOffset" select="0.02" />
    <xsl:if test="$maximumRows &gt;= $currentRow">
      <!-- Creates the actual horizontal line for the row -->
      <line x1="{$xLeftOffset}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <!-- Calls the same template recursively -->
      <xsl:call-template name="CreateGridLines">
        <xsl:with-param name="maximumRows" select="$maximumRows" />
        <xsl:with-param name="currentRow" select="$currentRow + 1" />
        <xsl:with-param name="headerText" select="$headerText" />
        <xsl:with-param name="yTopOffset" select="$yTopOffset" />
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$maximumRows = $currentRow">
      <!-- Print the top horizontal dotted line -->
      <line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset - $yOffset}in" />
      <!-- Print the vertical lines -->
      <line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 0.5}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.5}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 2.5}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.5}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 3}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 3}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 5}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 5.5}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.5}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <!-- Add procedure header -->
      <rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.019 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
      <text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.019 - $yOffset * 3}in" font-family="Arial" font-weight="bold" font-size="7pt">
        <xsl:if test="$headerText = 1">
          PROCEDURES
        </xsl:if>
        <xsl:if test="$headerText = 2">
          DIAGNOSES
        </xsl:if>
      </text>
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
    <xsl:param name="maximumRowsInColumn" />
    <xsl:param name="maximumColumns" />
    <xsl:param name="totalElements" />
    <xsl:param name="currentElement" />
    <xsl:param name="currentRow" />
    <xsl:param name="currentColumn" />
    <xsl:param name="currentCategory" select="0" />
    <xsl:variable name="xLeftOffset" select="0.5" />
    <xsl:variable name="xOffset" select="2.5" />
    <xsl:variable name="yTopOffset" select="2.4" />
    <xsl:variable name="yOffset" select="0.23" />
    <xsl:variable name="codeXOffset" select="0.01" />
    <xsl:variable name="descriptionXOffset" select="0.52" />
    <xsl:variable name="codeYOffset" select="0.04" />
    <xsl:variable name="descriptionYOffset" select="0.028" />
    <xsl:variable name="codeWidth" select="0.52" />
    <xsl:variable name="descriptionWidth" select="2.015" />
    <xsl:if test="$totalElements &gt;= $currentElement and $maximumColumns &gt;= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.ProcedureCategory'', $currentElement)]" />
      <xsl:choose>
        <xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 &gt; $maximumRowsInColumn) or                         ($currentCategory = $CurrentCategoryIndex and $currentRow &gt; $maximumRowsInColumn)">
          <!-- There isn''t enough room to print on this column -->
          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateProceduresColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn" />
            <xsl:with-param name="maximumColumns" select="$maximumColumns" />
            <xsl:with-param name="totalElements" select="$totalElements" />
            <xsl:with-param name="currentElement" select="$currentElement" />
            <xsl:with-param name="currentRow" select="1" />
            <xsl:with-param name="currentColumn" select="$currentColumn + 1" />
            <xsl:with-param name="currentCategory" select="0" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$currentCategory != $CurrentCategoryIndex">
          <!-- The category is not the same but there is enough room on this column so print out the category -->
          <!-- Creates the actual category line -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" class="boldLarge" />
          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" class="large" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" class="large" />
          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateProceduresColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn" />
            <xsl:with-param name="maximumColumns" select="$maximumColumns" />
            <xsl:with-param name="totalElements" select="$totalElements" />
            <xsl:with-param name="currentElement" select="$currentElement + 1" />
            <xsl:with-param name="currentRow" select="$currentRow + 2" />
            <xsl:with-param name="currentColumn" select="$currentColumn" />
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- The category is the same and there is enough room on this column so print out the detail -->
          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" class="large" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" class="large" />
          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateProceduresColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn" />
            <xsl:with-param name="maximumColumns" select="$maximumColumns" />
            <xsl:with-param name="totalElements" select="$totalElements" />
            <xsl:with-param name="currentElement" select="$currentElement + 1" />
            <xsl:with-param name="currentRow" select="$currentRow + 1" />
            <xsl:with-param name="currentColumn" select="$currentColumn" />
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template name="CreateDiagnosesColumnLayout">
    <xsl:param name="maximumRowsInColumn" />
    <xsl:param name="maximumColumns" />
    <xsl:param name="totalElements" />
    <xsl:param name="currentElement" />
    <xsl:param name="currentRow" />
    <xsl:param name="currentColumn" />
    <xsl:param name="currentCategory" select="0" />
    <xsl:variable name="xLeftOffset" select="0.50" />
    <xsl:variable name="xOffset" select="2.50" />
    <xsl:variable name="yTopOffset" select="9.02" />
    <xsl:variable name="yOffset" select="0.23" />
    <xsl:variable name="codeXOffset" select="0.01" />
    <xsl:variable name="descriptionXOffset" select="0.52" />
    <xsl:variable name="codeYOffset" select="0.04" />
    <xsl:variable name="descriptionYOffset" select="0.028" />
    <xsl:variable name="codeWidth" select="0.52" />
    <xsl:variable name="descriptionWidth" select="2.015" />
    <xsl:if test="$totalElements &gt;= $currentElement and $maximumColumns &gt;= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.DiagnosisCategory'', $currentElement)]" />
      <xsl:choose>
        <xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 &gt; $maximumRowsInColumn) or                         ($currentCategory = $CurrentCategoryIndex and $currentRow &gt; $maximumRowsInColumn)">
          <!-- There isn''t enough room to print on this column -->
          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateDiagnosesColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn" />
            <xsl:with-param name="maximumColumns" select="$maximumColumns" />
            <xsl:with-param name="totalElements" select="$totalElements" />
            <xsl:with-param name="currentElement" select="$currentElement" />
            <xsl:with-param name="currentRow" select="1" />
            <xsl:with-param name="currentColumn" select="$currentColumn + 1" />
            <xsl:with-param name="currentCategory" select="0" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$currentCategory != $CurrentCategoryIndex">
          <!-- category is not the same but there is enough room on this column so print out the category -->
          <!-- Creates the actual category line -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" class="boldLarge" />
          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" class="large" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" class="large" />
          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateDiagnosesColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn" />
            <xsl:with-param name="maximumColumns" select="$maximumColumns" />
            <xsl:with-param name="totalElements" select="$totalElements" />
            <xsl:with-param name="currentElement" select="$currentElement + 1" />
            <xsl:with-param name="currentRow" select="$currentRow + 2" />
            <xsl:with-param name="currentColumn" select="$currentColumn" />
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- The category is the same and there is enough room on this column so print out the detail -->
          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" class="large" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" class="large" />
          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateDiagnosesColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn" />
            <xsl:with-param name="maximumColumns" select="$maximumColumns" />
            <xsl:with-param name="totalElements" select="$totalElements" />
            <xsl:with-param name="currentElement" select="$currentElement + 1" />
            <xsl:with-param name="currentRow" select="$currentRow + 1" />
            <xsl:with-param name="currentColumn" select="$currentColumn" />
            <xsl:with-param name="currentCategory" select="$CurrentCategoryIndex" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template match="/formData/page">
    <xsl:variable name="DiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])" />
    <xsl:variable name="ProceduresCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])" />
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

          text.boldLarge
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 11pt;
          font-style: Normal;
          font-weight: bold;
          }

          text
          {
          baseline-shift: -100%;
          }

          text.large
          {
          font-size: 11pt;
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
      <g>
        <!-- Practice Information -->
        <g id="PracticeInformation">
          <text x="0.54in" y="0.50in" width="3.97in" height="0.10in" font-weight="bold" font-size="8pt" valueSource="EncounterForm.1.FullPracticeName1" />
          <text x="0.54in" y="0.63in" width="3.97in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.PracticeAddress1" />
          <text x="0.54in" y="0.76in" width="3.97in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.PracticePhoneFax1" />
          <text x="0.54in" y="0.89in" width="3.97in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.PracticeTaxID1" />
        </g>
        <g id="AccountActivity">
          <rect x="4.50in" y="0.50in" width="3.50in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
          <text x="4.83in" y="0.50in" font-weight="bold" font-size="7pt">ACCOUNT ACTIVITY</text>
          <line x1="4.50in" y1="0.625in" x2="4.50in" y2="1.20in" />
          <text x="4.51in" y="0.655in" font-size="5pt">PREVIOUS BALANCE</text>
          <text x="4.54in" y="0.735in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.PatientBalance1" />
          <line x1="4.50in" y1="0.9125in" x2="6.0in" y2="0.9125in" />
          <text x="4.51in" y="0.9425in" font-size="5pt">TODAY''S CHARGES</text>
          <line x1="6.0in" y1="0.625in" x2="6.0in" y2="1.20in" />
        </g>
        <g id="PaymentOnAccount">
          <text x="6.47in" y="0.50in" font-weight="bold" font-size="7pt">PAYMENT ON ACCOUNT</text>
          <text x="6.01in" y="0.655in" font-size="5pt">PAYMENT METHOD</text>
          <circle cx="6.12in" cy="0.835in" r="0.04in" fill="none" stroke="black" />
          <text x="6.32in" y="0.795in" font-size="5pt">CASH</text>
          <circle cx="6.12in" cy="0.985in" r="0.04in" fill="none" stroke="black" />
          <text x="6.32in" y="0.945in" font-size="5pt">CREDIT CARD</text>
          <circle cx="6.12in" cy="1.135in" r="0.04in" fill="none" stroke="black" />
          <text x="6.32in" y="1.095in" font-size="5pt">CHECK #</text>
          <line x1="6.80in" y1="0.625in" x2="6.80in" y2="1.20in" />
          <text x="6.81in" y="0.655in" font-size="5pt">TODAY''S PAYMENT</text>
        </g>
        <g id="PatientInformation">
          <rect x="0.50in" y="1.20in" width="7.5in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
          <text x="0.52in" y="1.20in" font-weight="bold" font-size="7pt">PATIENT INFORMATION</text>
          <line x1="3.0in" y1="1.325in" x2="3.0in" y2="2.3583in" />
          <text x="0.51in" y="1.355in" font-size="5pt">PATIENT CONTACT</text>
          <text x="0.54in" y="1.435in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.PatientName1" />
          <text x="0.54in" y="1.565in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.AddressLine11" />
          <!--<xsl:choose>
            <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
              <text x="0.54in" y="1.695in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.AddressLine21" />
              <text x="0.54in" y="1.825in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1"/>
              <text x="0.54in" y="1.955in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.FullPhone1"/>
            </xsl:when>
            <xsl:otherwise>-->
          <text x="0.54in" y="1.695in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1" />
          <text x="0.54in" y="1.825in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.FullPhone1" />
          <text x="0.54in" y="1.955in" width="2.47in" height="0.10in">PATIENT SIGNATURE</text>
          <line x1="1.395in" y1="2.075in" x2="2.939in" y2="2.075in" />
          <!--</xsl:otherwise>
          </xsl:choose>-->
          <line x1="0.50in" y1="2.10in" x2="8.0in" y2="2.10in" />
          <text x="0.51in" y="2.13in" font-size="5pt">PATIENT ID</text>
          <text x="0.54in" y="2.21in" width="0.80in" height="0.10in" valueSource="EncounterForm.1.PatientID1" />
          <line x1="1.33in" y1="2.10in" x2="1.33in" y2="2.3583in" />
          <text x="1.34in" y="2.13in" font-size="5pt">CHART NUMBER</text>
          <text x="1.37in" y="2.21in" width="0.80in" height="0.10in" valueSource="EncounterForm.1.MedicalRecordNumber1" />
          <line x1="2.16in" y1="2.10in" x2="2.16in" y2="2.3583in" />
          <text x="2.17in" y="2.13in" font-size="5pt">DATE OF BIRTH</text>
          <text x="2.20in" y="2.21in" width="0.80in" height="0.10in" valueSource="EncounterForm.1.DOBAge1" />
          <line x1="0.50in" y1="2.3583in" x2="8.0in" y2="2.3583in" />
        </g>
        <g id="InsuranceCoverage">
          <text x="3.02in" y="1.20in" font-weight="bold" font-size="7pt">INSURANCE COVERAGE</text>
          <text x="3.01in" y="1.355in" font-size="5pt">PRIMARY INSURANCE</text>
          <text x="3.04in" y="1.435in" width="1.83in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1" />
          <line x1="3.0in" y1="1.5833in" x2="8.0in" y2="1.5833in" />
          <text x="3.01in" y="1.6133in" font-size="5pt">SECONDARY INSURANCE</text>
          <text x="3.04in" y="1.6933in" width="1.83in" height="0.10in" valueSource="EncounterForm.1.SecondaryIns1" />
          <line x1="3.0in" y1="1.8416in" x2="8.0in" y2="1.8416in" />
          <text x="3.01in" y="1.8716in" font-size="5pt">TERTIARY INSURANCE</text>
          <text x="3.04in" y="1.9516in" width="1.83in" height="0.10in" valueSource="EncounterForm.1.TertiaryIns1" />
          <text x="3.01in" y="2.13in" font-size="5pt">COPAY</text>
          <text x="3.04in" y="2.21in" width="0.595in" height="0.10in" valueSource="EncounterForm.1.Copay1" />
          <line x1="3.9in" y1="2.10in" x2="3.9in" y2="2.3583in" />
          <text x="3.91in" y="2.13in" font-size="5pt">DEDUCTIBLE</text>
          <text x="3.94in" y="2.21in" width="0.595in" height="0.10in" valueSource="EncounterForm.1.Deductible1" />
          <!--<line x1="4.25in" y1="1.325in" x2="4.25in" y2="2.3583in"></line>-->
          <line x1="4.86in" y1="1.325in" x2="4.86in" y2="2.3583in" />
          <text x="4.87in" y="1.355in" font-size="5pt">PRIMARY POLICY NUMBER</text>
          <text x="4.91in" y="1.435in" width="1.83in" height="0.10in" valueSource="EncounterForm.1.PolicyNumber1" />
          <text x="4.87in" y="1.6133in" font-size="5pt">SECONDARY POLICY NUMBER</text>
          <text x="4.91in" y="1.6933in" width="1.83in" height="0.10in" valueSource="EncounterForm.1.SecondaryPolicyNumber1" />
          <text x="4.87in" y="1.8716in" font-size="5pt">TERTIARY POLICY NUMBER</text>
          <text x="4.91in" y="1.9516in" width="1.83in" height="0.10in" valueSource="EncounterForm.1.TertiaryPolicyNumber1" />
          <text x="4.87in" y="2.13in" font-size="5pt">GUARANTOR</text>
          <text x="4.91in" y="2.21in" width="1.83in" height="0.10in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        </g>
        <g id="AppointmentInformation">
          <line x1="6.75in" y1="1.325in" x2="6.75in" y2="2.3583in" />
          <text x="6.76in" y="1.20in" font-weight="bold" font-size="7pt">APPOINTMENT INFORMATION</text>
          <text x="6.76in" y="1.355in" font-size="5pt">DATE/TIME</text>
          <text x="6.79in" y="1.435in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1" />
          <text x="6.76in" y="1.6133in" font-size="5pt">TICKET NUMBER</text>
          <text x="6.79in" y="1.6933in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.TicketNumber1" />
          <text x="6.76in" y="1.8716in" font-size="5pt">REASON</text>
          <text x="6.79in" y="1.9516in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.Reason1" />
          <text x="6.76in" y="2.13in" font-size="5pt">DATE OF LAST VISIT</text>
          <text x="6.79in" y="2.21in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.LastVisitDate1" />
        </g>
        <g id="AccountStatus">
          <text x="0.51in" y="2.3883in" font-size="5pt">ACCOUNT STATUS:</text>
          <text x="0.54in" y="2.4675in" width="5.47in" height="0.10in" valueSource="EncounterForm.1.AccountStatus1" class="large" />
          <line x1="0.50in" y1="2.7166in" x2="8.0in" y2="2.7166in" />
        </g>
        <g id="ReturnSchedule">
          <line x1="6.0in" y1="2.3583in" x2="6.0in" y2="2.7166in" />
          <text x="6.01in" y="2.3883in" font-size="5pt">RETURN SCHEDULE:</text>
          <text x="6.14in" y="2.4683in" font-size="5pt">1              2              3              4              5              6              7</text>
          <text x="6.18in" y="2.5283in" font-size="5pt">D                W                  M                Y               PRN_____</text>
        </g>
      </g>
      <g id="ProceduresGrid">
        <xsl:call-template name="CreateGridLines">
          <xsl:with-param name="maximumRows" select="27" />
          <xsl:with-param name="currentRow" select="1" />
          <xsl:with-param name="headerText" select="1" />
          <xsl:with-param name="yTopOffset" select="3.35" />
        </xsl:call-template>
      </g>
      <g id="ProceduresDetails">
        <xsl:call-template name="CreateProceduresColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="28" />
          <xsl:with-param name="maximumColumns" select="3" />
          <xsl:with-param name="totalElements" select="$ProceduresCategoryCount" />
          <xsl:with-param name="currentElement" select="1" />
          <xsl:with-param name="currentRow" select="1" />
          <xsl:with-param name="currentColumn" select="1" />
          <xsl:with-param name="currentCategory" select="0" />
        </xsl:call-template>
      </g>
      <g id="DiagnosisGrid">
        <xsl:call-template name="CreateGridLines">
          <xsl:with-param name="maximumRows" select="3" />
          <xsl:with-param name="currentRow" select="1" />
          <xsl:with-param name="headerText" select="2" />
          <xsl:with-param name="yTopOffset" select="9.98" />
        </xsl:call-template>
      </g>
      <g id="DiagnosesDetails">
        <xsl:call-template name="CreateDiagnosesColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="4"/>
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
where PrintingFormDetailsID = 86