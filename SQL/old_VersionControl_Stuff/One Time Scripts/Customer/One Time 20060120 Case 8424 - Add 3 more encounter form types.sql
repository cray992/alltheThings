-- Case 8424 Add 3 more encounter form types

DECLARE @TwoPageFirstPageName varchar(8000)
DECLARE @TwoPageFirstPageDescription varchar(8000)
DECLARE @TwoPage2Name varchar(8000)
DECLARE @TwoPage2Description varchar(8000)
DECLARE @TwoPage2FirstPageName varchar(8000)
DECLARE @TwoPage2FirstPageDescription varchar(8000)

SET	@TwoPageFirstPageName = 'Two Page (First Page Only)'
SET	@TwoPageFirstPageDescription = 'Encounter form that prints on two pages (only the first page will print)'

SET	@TwoPage2Name = 'Two Page Version 2'
SET	@TwoPage2Description = 'Encounter form version 2 that prints on two pages'

SET	@TwoPage2FirstPageName = 'Two Page Version 2 (First Page Only)'
SET	@TwoPage2FirstPageDescription = 'Encounter form version 2 that prints on two pages (only the first page will print)'


-- Insert the new encounter form types
INSERT INTO EncounterFormType(
	EncounterFormTypeID,
	Name,
	Description,
	SortOrder)
VALUES	(3,
	@TwoPageFirstPageName, 
	@TwoPageFirstPageDescription,
	3)

INSERT INTO EncounterFormType(
	EncounterFormTypeID,
	Name,
	Description,
	SortOrder)
VALUES	(4,
	@TwoPage2Name, 
	@TwoPage2Description,
	4)

INSERT INTO EncounterFormType(
	EncounterFormTypeID,
	Name,
	Description,
	SortOrder)
VALUES	(5,
	@TwoPage2FirstPageName, 
	@TwoPage2FirstPageDescription,
	5)

-- Insert the form details for Encounter Form Version 2 (Two Page) - Page 1
INSERT INTO PrintingFormDetails(
	PrintingFormDetailsID,
	PrintingFormID,
	SVGDefinitionID,
	Description,,
	SVGTransform)
VALUES	(17,
	9,
	4,
	'Encounter Form Version 2 (Two Page) - Page 1',
    1)

UPDATE PrintingFormDetails
SET SVGDefinition = 
	'<?xml version="1.0" encoding="utf-8"?>
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

          <text x="1.20in" y="1.21in" width="4.25in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.AddressLine11"></text>

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

INSERT INTO PrintingFormDetails(
	PrintingFormDetailsID,
	PrintingFormID,
	SVGDefinitionID,
	Description,
	SVGTransform)
VALUES	(18,
	9,
	5,
	'Encounter Form Version 2 (Two Page) - Page 2',
	1)

UPDATE PrintingFormDetails
SET SVGDefinition = 
	'<?xml version="1.0" encoding="utf-8"?>
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
    <xsl:variable name="yTopOffset" select="0.94975"/>
    <xsl:variable name="yOffset" select=".15625"/>
    <xsl:variable name="lineWidth" select="7.5"/>
    <xsl:variable name="headerYOffset" select="0.01"/>
    <xsl:variable name="codeXOffset" select=".02"/>
    <xsl:variable name="descriptionXOffset" select=".395"/>
    <xsl:variable name="rankXOffset" select="2.273"/>

    <xsl:if test="$maximumRows >= $currentRow">
      <!-- Creates the actual horizontal line for the row -->
      <line x1="{$xLeftOffset}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

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
      <line x1="{$xLeftOffset + .375}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + .375}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 2.25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 2.5}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.5}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 2.875}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.875}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 4.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 5}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 5.375}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.375}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
      <line x1="{$xLeftOffset + 7.5}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.5}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

      <!-- Add diagnosis header -->
      <rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
      <text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" font-family="Arial" font-weight="bold" font-size="7pt">DIAGNOSES</text>

      <!-- Add headers -->
      <text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Code</text>
      <text x="{$xLeftOffset + $descriptionXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".5in" height="0.1in">Name</text>
      <text x="{$xLeftOffset + $rankXOffset}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Rank</text>
      <text x="{$xLeftOffset + $codeXOffset + 2.5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Code</text>
      <text x="{$xLeftOffset + $descriptionXOffset + 2.5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".5in" height="0.1in">Name</text>
      <text x="{$xLeftOffset + $rankXOffset + 2.5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Rank</text>
      <text x="{$xLeftOffset + $codeXOffset + 5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Code</text>
      <text x="{$xLeftOffset + $descriptionXOffset + 5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".5in" height="0.1in">Name</text>
      <text x="{$xLeftOffset + $rankXOffset + 5}in" y="{$yTopOffset + $headerYOffset - $yOffset * 2}in" width=".25in" height="0.1in">Rank</text>
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

    <xsl:variable name="xLeftOffset" select="0.5"/>
    <xsl:variable name="xOffset" select="2.5"/>
    <xsl:variable name="yTopOffset" select="0.44875"/>
    <xsl:variable name="yOffset" select=".15625"/>
    <xsl:variable name="codeXOffset" select=".015"/>
    <xsl:variable name="descriptionXOffset" select=".395"/>
    <xsl:variable name="codeYOffset" select="0.04"/>
    <xsl:variable name="descriptionYOffset" select="0.028"/>
    <xsl:variable name="codeWidth" select=".4"/>
    <xsl:variable name="descriptionWidth" select="1.875"/>

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
          <!-- The category is not the same but there is enough room on this column so print out the category -->

          <!-- Creates the actual category line -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" class="bold" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

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

          line
          {
          stroke: black;
          stroke-width: 0.0069in;
          }

          g#DiagnosisGrid line
          {
          stroke: black;
          stroke-dasharray: 2, 2;
          stroke-width: 0.0069in;
          }

        </style>
      </defs>

      <g id="DiagnosisGrid">
        <xsl:call-template name="CreateHorizontalLines">
          <xsl:with-param name="maximumRows" select="58"/>
          <xsl:with-param name="currentRow" select="1"/>
        </xsl:call-template>
      </g>

      <g id="DiagnosisDetails">
        <xsl:call-template name="CreateDiagnosesColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="58"/>
          <xsl:with-param name="maximumColumns" select="3"/>
          <xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>

      <g id="Signature">
        <text x="0.5in" y="10.0in" font-family="Arial" font-weight="bold" font-size="7pt">I hereby certify that I have rendered the above services.</text>
        <text x="0.5in" y="10.3in" font-family="Arial Narrow" font-weight="bold" font-size="7pt">PHYSICIAN''S SIGNATURE</text>
        <line x1="1.57in" y1="10.4in" x2="5.5in" y2="10.4in" />
        <text x="5.6in" y="10.3in" font-family="Arial Narrow" font-weight="bold" font-size="7pt">DATE</text>
        <line x1="5.88in" y1="10.4in" x2="8.0in" y2="10.4in" />
      </g>
      
    </svg>
  </xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 18
