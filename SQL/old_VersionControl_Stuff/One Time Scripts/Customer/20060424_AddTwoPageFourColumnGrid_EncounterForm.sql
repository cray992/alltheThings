---------------------------------------------------------------------------------------------
-- Case 10210: Implement a two page four column grid. 
---------------------------------------------------------------------------------------------

INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (12, 'Two Page Four Column Grid', 'Encounter form that prints on two pages', 12)

INSERT INTO PrintingFormDetails 
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform, SVGDefinition)
VALUES
	(27, 9, 13, 'Encounter Form Four Column (Two Page) - Page 1', 1, '<?xml version="1.0" encoding="utf-8"?>
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
    <xsl:variable name="xOffset" select="1.875"/>
    <xsl:variable name="yTopOffset" select="2.13"/>
    <xsl:variable name="yOffset" select=".140625"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".350"/>
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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" style="fill:black" font-family="Arial" font-weight="bold" font-size="8pt" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".30in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" font-family="Arial Narrow" font-size="7pt" />

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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".30in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>

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

  <xsl:template name="DrawHorLines">
    <xsl:param name="yOffset"/>
    <xsl:param name="maximumRows"/>
    <xsl:param name="currentRow" select="1"/>

    <xsl:if test="$maximumRows >= $currentRow">

      <line x1="0.5in" y1="{$yOffset + .140625 * ($currentRow)}in"
          x2="8in" y2="{$yOffset + .140625 * ($currentRow)}in"
          style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>

      <xsl:call-template name="DrawHorLines">
        <xsl:with-param name="yOffset" select="$yOffset"/>
        <xsl:with-param name="maximumRows" select="$maximumRows"/>
        <xsl:with-param name="currentRow" select="$currentRow+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="DrawVertLines">
    <xsl:param name="xOffset"/>
    <xsl:param name="yOffset"/>
    <xsl:param name="height"/>
    <xsl:param name="maximumCols"/>
    <xsl:param name="currentCol" select="0"/>

    <xsl:if test="$maximumCols > $currentCol">

      <line x1="{$xOffset+($currentCol)*1.875}in" y1="{$yOffset}in"
          x2="{$xOffset+($currentCol)*1.875}in" y2="{$yOffset +$height}in"
          style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="$xOffset"/>
        <xsl:with-param name="yOffset" select="$yOffset"/>
        <xsl:with-param name="height" select="$height"/>
        <xsl:with-param name="maximumCols" select="$maximumCols"/>
        <xsl:with-param name="currentCol" select="$currentCol+1"/>
      </xsl:call-template>
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

          text.ralignedtext
          {
          text-anchor: end;
          }

          text.centeredtext
          {
          text-anchor: middle;
          }
        </style>
      </defs>

      <g id="PracticeInformation">
        <xsl:variable name="practiceName" select="concat(data[@id=''EncounterForm.1.Provider1''], '' - '', data[@id=''EncounterForm.1.PracticeName1''])"/>
        <xsl:variable name="fullAddress" select="concat(data[@id=''EncounterForm.1.PracticeAddress1''], '' '', data[@id=''EncounterForm.1.PracticeAddress2''], '' - '', data[@id=''EncounterForm.1.PracticeCityStateZip1''], '' '', data[@id=''EncounterForm.1.PracticePhoneFax1''])"/>

        <text x="4.25in" y="0.5in" font-family="Arial" font-weight="bold" font-size="12pt" class="centeredtext">
          <xsl:value-of select="$practiceName"/>
        </text>

        <text x="4.25in" y="0.7in" font-family="Arial Narrow" font-size="9pt" class="centeredtext">
          <xsl:value-of select="$fullAddress"/>
        </text>
      </g>

      <g id="PatientBox" transform="translate(100, 187)">
        <rect x="0.00in" y="0.000in" width="3.71875in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="3.71875in" height="1.01in" fill="none" stroke="black" stroke-width="0.5pt"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">PATIENT</text>

        <!-- Left captions -->
        <text x="0.57in" y="0.185in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">NAME:</text>
        <text x="0.57in" y="0.320in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">ADDRESS:</text>
        <text x="0.57in" y="0.455in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">HOME:</text>
        <text x="0.57in" y="0.590in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PRIMARY:</text>
        <text x="0.57in" y="0.725in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">COPAY/DED.:</text>
        <text x="0.57in" y="0.860in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">SECONDARY:</text>

        <!-- Right captions-->
        <text x="2.60in" y="0.455in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">WORK:</text>
        <text x="2.60in" y="0.590in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DOB/AGE:</text>
        <text x="2.60in" y="0.725in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">GENDER:</text>
        <text x="2.60in" y="0.860in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">GUARANTOR:</text>

        <!-- Fields -->
        <xsl:variable name="patNameID" select="concat(data[@id=''EncounterForm.1.PatientName1''], '' ('', data[@id=''EncounterForm.1.PatientID1''], '')'' )"/>
        <xsl:variable name="patFullAddress" select="concat(data[@id=''EncounterForm.1.AddressLine11''], '' '', data[@id=''EncounterForm.1.AddressLine21''], '', '', data[@id=''EncounterForm.1.CityStateZip1''])"/>
        <xsl:variable name="patCopayDed" select="concat(data[@id=''EncounterForm.1.Copay1''], '' / '', data[@id=''EncounterForm.1.Deductible1''])"/>
        <xsl:variable name="patDOBAge" select="data[@id=''EncounterForm.1.DOBAge1'']"/>

        <!-- Fields Left column -->
        <text x="0.60in" y="0.12in" width="3.0in" height="0.2in" font-family="Arial Narrow" font-weight="bold" font-size="11pt">
          <xsl:value-of select="$patNameID"/>
        </text>

        <text x="0.60in" y="0.300in" width="3.0in" height="0.15in" font-family="Arial Narrow" font-size="8pt">
          <xsl:value-of select="$patFullAddress"/>
        </text>

        <text x="0.60in" y="0.435in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.HomePhone1"/>

        <text x="0.60in" y="0.570in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PrimaryIns1"/>

        <text x="0.60in" y="0.705in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt">
          <xsl:value-of select="$patCopayDed"/>
        </text>

        <text x="0.60in" y="0.840in" width="1.36in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.SecondaryIns1"/>

        <!-- Fields Right column -->
        <text x="2.63in" y="0.435in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.WorkPhone1"/>

        <text x="2.63in" y="0.570in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt">
          <xsl:value-of select="$patDOBAge"/>
        </text>

        <text x="2.63in" y="0.705in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.Gender1"/>

        <text x="2.63in" y="0.840in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.ResponsiblePerson1"/>
      </g>

      <g id="VisitBox" transform="translate(856, 187)">
        <rect x="0.00in" y="0.000in" width="3.71875in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="3.71875in" height="1.01in" fill="none" stroke="black" stroke-width="0.5pt"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">VISIT</text>

        <!-- Left captions -->
        <text x="0.57in" y="0.185in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PROVIDER:</text>
        <text x="0.57in" y="0.320in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DATE/TIME:</text>
        <text x="0.57in" y="0.455in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">LOCATION:</text>
        <text x="0.57in" y="0.590in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">REFER.:</text>
        <text x="0.57in" y="0.725in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">CASE:</text>
        <text x="0.57in" y="0.860in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">SCENARIO:</text>

        <!-- Right captions-->
        <text x="2.60in" y="0.320in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">TICKET #:</text>
        <text x="2.60in" y="0.455in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">REASON:</text>
        <text x="2.60in" y="0.590in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PCP:</text>
        <text x="2.60in" y="0.725in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">INJURY DATE:</text>
        <text x="2.60in" y="0.860in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">INJURY PLACE:</text>

        <!-- Fields Left column -->
        <text x="0.60in" y="0.15in" width="3.0in" height="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="9pt" valueSource="EncounterForm.1.Provider1"/>
        <text x="0.60in" y="0.300in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.AppDateTime1"/>
        <text x="0.60in" y="0.435in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.POS1"/>
        <text x="0.60in" y="0.570in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PatCaseRefPhys1"/>
        <text x="0.60in" y="0.705in" width="1.31in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PatientCase1"/>
        <text x="0.60in" y="0.840in" width="1.31in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PatientCaseScenario1"/>

        <!-- Fields Right column -->
        <text x="2.63in" y="0.300in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.TicketNumber1"/>
        <text x="2.63in" y="0.435in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.Reason1"/>
        <text x="2.63in" y="0.570in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PCP1"/>
        <text x="2.63in" y="0.705in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.InjuryDate1"/>
        <text x="2.63in" y="0.840in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.InjuryPlace1"/>
      </g>

      <g id="ProcedureDetails">
        <rect x="0.50in" y="2.000in" width="7.5in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <!-- <rect x="0.50in" y="2.000in" width="7.50in" height="1.01in" fill="none" stroke="black"/> -->
        <text x="0.55in" y="2.005in" font-family="Arial" font-weight="bold" font-size="7pt">PROCEDURES</text>

        <xsl:call-template name="CreateProcedureColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="55"/>
          <xsl:with-param name="maximumColumns" select="4"/>
          <xsl:with-param name="totalElements" select="$ProcedureCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>

      <!-- Draw the lines for Procedure Codes-->
      <xsl:call-template name="DrawHorLines">
        <xsl:with-param name="yOffset" select="2.125"/>
        <xsl:with-param name="maximumRows" select="55"/>
      </xsl:call-template>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="0.5"/>
        <xsl:with-param name="yOffset" select="2.125"/>
        <xsl:with-param name="height" select="7.736215"/>
        <xsl:with-param name="maximumCols" select="5"/>
      </xsl:call-template>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="0.8125"/>
        <xsl:with-param name="yOffset" select="2.125"/>
        <xsl:with-param name="height" select="7.736125"/>
        <xsl:with-param name="maximumCols" select="4"/>
      </xsl:call-template>

      <g id="ReturnScheduleBox" transform="translate(100, 1994)">
        <rect x="0.00in" y="0.000in" width="1.84375in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="1.84375in" height="0.500in" fill="none" stroke="black"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">RETURN SCHEDULE</text>

        <text x="0.16in" y="0.16in" width="1.751in" height="0.500in" font-family="Arial" font-weight="bold" font-size="7pt">1      2      3      4      5      6      7</text>
        <text x="0.16in" y="0.32in" width="1.751in" height="0.500in" font-family="Arial" font-weight="bold" font-size="7pt">D       W       M       Y    PRN_____</text>
      </g>

      <g id="AccountStatusBox" transform="translate(481, 1994)">
        <rect x="0.00in" y="0.000in" width="1.8125in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="1.8125in" height="0.500in" fill="none" stroke="black"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">ACCOUNT STATUS</text>

        <text x="0.16in" y="0.16in" width="1.751in" height="0.500in" font-family="Arial Narrow" font-size="7pt"></text>
      </g>

      <g id="AccountActivityBox" transform="translate(856, 1994)">
        <rect x="0.00in" y="0.000in" width="1.8125in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="1.8125in" height="0.500in" fill="none" stroke="black"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">ACCOUNT ACTIVITY</text>

        <text x="0.9in" y="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PRIOR BALANCE:</text>
        <text x="0.9in" y="0.30in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">TODAY''S CHARGES:</text>

        <text x="0.95in" y="0.13in" width="0.75in" height="0.1in"  font-family="Arial Narrow" font-weight="bold" font-size="8pt" valueSource="EncounterForm.1.PatientBalance1"/>
      </g>

      <g id="PaymentOnAccountBox" transform="translate(1231, 1994)">
        <rect x="0.00in" y="0.000in" width="1.84375in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="1.84375in" height="0.500in" fill="none" stroke="black"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">PAYMENT ON ACCOUNT</text>

        <circle cx="0.09in" cy="0.22in" r="0.03in" fill="none" stroke="black" />
        <circle cx="0.09in" cy="0.37in" r="0.03in" fill="none" stroke="black" />
        <circle cx="0.55in" cy="0.22in" r="0.03in" fill="none" stroke="black" />

        <text x="0.18in" y="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" >CHECK</text>
        <text x="0.18in" y="0.30in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" >CREDIT CARD</text>
        <text x="0.63in" y="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" >CASH</text>

        <line x1="0.875in" y1="0.125in" x2="0.8725in" y2="0.5in" stroke="black" stroke-width="0.5pt"/>

        <text x="1.35in" y="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DUE:</text>
        <text x="1.35in" y="0.30in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PAYMENT:</text>
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>')

INSERT INTO PrintingFormDetails 
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform, SVGDefinition)
VALUES
	(28, 9, 14, 'Encounter Form Four Column (Two Page) - Page 2', 1, '<?xml version="1.0" encoding="utf-8"?>
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
    <xsl:variable name="xOffset" select="1.875"/>
    <xsl:variable name="yTopOffset" select="0.625"/>
    <xsl:variable name="yOffset" select=".140625"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".35"/>
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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" 
            y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" 
            width="1.55in" height="0.1in" 
            valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" style="fill:black" 
            font-family="Arial" font-weight="bold" font-size="8pt"/>
          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".30in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>

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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".30in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>


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

  <xsl:template name="DrawHorLines">
    <xsl:param name="yOffset"/>
    <xsl:param name="maximumRows"/>
    <xsl:param name="currentRow" select="1"/>

    <xsl:if test="$maximumRows >= $currentRow">

      <line x1="0.5in" y1="{$yOffset + .140625 * ($currentRow)}in"
          x2="8in" y2="{$yOffset + .140625 * ($currentRow)}in"
          style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>

      <xsl:call-template name="DrawHorLines">
        <xsl:with-param name="yOffset" select="$yOffset"/>
        <xsl:with-param name="maximumRows" select="$maximumRows"/>
        <xsl:with-param name="currentRow" select="$currentRow+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="DrawVertLines">
    <xsl:param name="xOffset"/>
    <xsl:param name="yOffset"/>
    <xsl:param name="height"/>
    <xsl:param name="maximumCols"/>
    <xsl:param name="currentCol" select="0"/>

    <xsl:if test="$maximumCols > $currentCol">

      <line x1="{$xOffset+($currentCol)*1.875}in" y1="{$yOffset}in"
          x2="{$xOffset+($currentCol)*1.875}in" y2="{$yOffset +$height}in"
          style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="$xOffset"/>
        <xsl:with-param name="yOffset" select="$yOffset"/>
        <xsl:with-param name="height" select="$height"/>
        <xsl:with-param name="maximumCols" select="$maximumCols"/>
        <xsl:with-param name="currentCol" select="$currentCol+1"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template match="/formData/page">
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

          text.ralignedtext
          {
          text-anchor: end;
          }

          text.centeredtext
          {
          text-anchor: middle;
          }

          line
          {
          stroke: black;
          stroke-width: 0.0069in;
          }
          
        </style>
      </defs>

      <g id="DiagnosisDetails">
        <rect x="0.50in" y="0.5in" width="7.5in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <!-- <rect x="0.50in" y="2.000in" width="7.50in" height="1.01in" fill="none" stroke="black"/> -->
        <text x="0.55in" y="0.5in" font-family="Arial" font-weight="bold" font-size="7pt">DIAGNOSES</text>

        <xsl:call-template name="CreateDiagnosisColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="65"/>
          <xsl:with-param name="maximumRowsInLastColumn" select="65"/>
          <xsl:with-param name="maximumColumns" select="4"/>
          <xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>

      <!-- Draw the lines for Diagnosis Codes-->
      <xsl:call-template name="DrawHorLines">
        <xsl:with-param name="yOffset" select="0.625"/>
        <xsl:with-param name="maximumRows" select="65"/>
      </xsl:call-template>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="0.5"/>
        <xsl:with-param name="yOffset" select="0.625"/>
        <xsl:with-param name="height" select="9.142375"/>
        <xsl:with-param name="maximumCols" select="5"/>
      </xsl:call-template>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="0.8125"/>
        <xsl:with-param name="yOffset" select="0.625"/>
        <xsl:with-param name="height" select="9.142375"/>
        <xsl:with-param name="maximumCols" select="4"/>
      </xsl:call-template>

      <g id="Signature">
        <text x="0.5in" y="9.825in" font-family="Arial" font-weight="bold" font-size="7pt">I hereby certify that I have rendered the above services.</text>
        <text x="0.5in" y="10.125in" font-family="Arial Narrow" font-weight="bold" font-size="7pt">PHYSICIAN''S SIGNATURE</text>
        <line x1="1.57in" y1="10.225in" x2="5.5in" y2="10.225in" />
        <text x="5.6in" y="10.125in" font-family="Arial Narrow" font-weight="bold" font-size="7pt">DATE</text>
        <line x1="5.88in" y1="10.225in" x2="8.0in" y2="10.225in" />
      </g>

    </svg>
  </xsl:template>
</xsl:stylesheet>')

GO
