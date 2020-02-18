/*
-----------------------------------------------------------------------------------------------------
CASE 21289 - Update old HCFA, move fields in box 28 - 30 over to the left a bit.
-----------------------------------------------------------------------------------------------------
*/

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<!-- HCFA SVG Transform No Background -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<!-- Y Locations for each procedure line -->
	<xsl:variable name="yProcedure1">7.36</xsl:variable>
	<xsl:variable name="yProcedure2">7.66</xsl:variable>
	<xsl:variable name="yProcedure3">8</xsl:variable>
	<xsl:variable name="yProcedure4">8.33</xsl:variable>
	<xsl:variable name="yProcedure5">8.67</xsl:variable>
	<xsl:variable name="yProcedure6">9</xsl:variable>

	<xsl:variable name="NDCFirstLineOffset">-0.0797</xsl:variable>
	<xsl:variable name="NDCSecondLineOffset">0.0703</xsl:variable>

	<!--  
				Generates regular procedure SVG for one procedure
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation - y location for this procedure
        
  -->
  
	<xsl:template name="GenerateProcedureSVG">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation"/>

		<g id="box24_{$currentProcedure}">
			<text x="0.37in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
      <xsl:choose>
        <xsl:when test="string-length(data[@id=''CMS1500.1.aStartYY{$currentProcedure}'']) = 2">
          <text x="1.0in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
        </xsl:when>
        <xsl:otherwise>
          <text x="0.9in" y="{$yProcedureLocation}in" width="0.5in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
        </xsl:otherwise>
      </xsl:choose>
			<text x="1.26in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
      <xsl:choose>
        <xsl:when test="string-length(data[@id=''CMS1500.1.aEndYY{$currentProcedure}'']) = 2">
          <text x="1.88in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
        </xsl:when>
        <xsl:otherwise>
          <text x="1.78in" y="{$yProcedureLocation}in" width="0.5in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
        </xsl:otherwise>
      </xsl:choose>
			<text x="2.17in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" y="{$yProcedureLocation}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" y="{$yProcedureLocation}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" y="{$yProcedureLocation}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" y="{$yProcedureLocation}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.11in" y="{$yProcedureLocation}in" width="0.52in" height="0.1in" text-anchor="start" valueSource="CMS1500.1.gUnits{$currentProcedure}" class="smaller" />
      <text x="6.47in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
      <text x="6.75in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
      <text x="7.05in" y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
      <text x="7.33in" y="{$yProcedureLocation}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
    </g>

  </xsl:template>

  <!--  
				Generates NDC procedure SVG for one procedure. 
				This prints over one row doubling up the NDC text in the same row.
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation - y location for this procedure
        
  -->
  
  <xsl:template name="GenerateNDCProcedureSVGOneLine">
    <xsl:param name="currentProcedure"/>
    <xsl:param name="yProcedureLocation"/>

    <g id="box24_{$currentProcedure}_NDC_1row">
      <text x="0.37in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
      <text x="0.68in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
      <text x="1.00in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
      <text x="1.26in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
      <text x="1.56in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
      <text x="1.88in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
      <text x="2.17in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
      <text x="2.44in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
      <text x="2.8in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
      <text x="3.46in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
      <text x="3.77in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
      <text x="4.5in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
      <text x="5.23in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
      <text x="5.83in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
      <text x="6.11in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.52in" height="0.1in" text-anchor="start" valueSource="CMS1500.1.gUnits{$currentProcedure}" class="smaller" />
			<text x="6.47in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
			<!--<text x="0.37in" 	y="{$yProcedureLocation + $NDCSecondLineOffset}in" width="2.37in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />-->
			<text x="2.8in" y="{$yProcedureLocation + $NDCSecondLineOffset}in" width="2.4in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />
		</g>

	</xsl:template>

	<!--  
				Generates NDC procedure SVG for one procedure. 
				This prints over two rows so it requires two procedure locations
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation1 - y location for the first procedure line
        yProcedureLocation2 - y location for the second procedure line
        
  -->
  
	<xsl:template name="GenerateNDCProcedureSVGTwoLine">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation1"/>
		<xsl:param name="yProcedureLocation2"/>

		<g id="box24_{$currentProcedure}_NDC_2row">
			<text x="0.37in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
			<text x="1.00in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.26in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
			<text x="1.88in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.17in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" y="{$yProcedureLocation1}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" y="{$yProcedureLocation1}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" y="{$yProcedureLocation1}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" y="{$yProcedureLocation1}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.11in" y="{$yProcedureLocation1}in" width="0.52in" height="0.1in" text-anchor="start" valueSource="CMS1500.1.gUnits{$currentProcedure}" class="smaller" />
			<text x="6.47in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" y="{$yProcedureLocation1}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
			<text x="0.37in" y="{$yProcedureLocation2}in" width="2.37in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />
		</g>

	</xsl:template>

	<!--  
        Takes in the number procedures to process.
        Loops through each procedure to print.
        If this is a regular procedure print in one row, if it is an NDC procedure print in two rows.
        Keep track of how many rows have been printed.
        
        Parameters:
        totalProcedures - total number of procedures to display
        currentProcedure - index of the current procedure being processed
        currentProcedureLine - current procedure line to print out
        
  -->
  
	<xsl:template name="CreateProcedureLayout">
		<xsl:param name="totalProcedures"/>
		<xsl:param name="currentProcedure"/>
		<xsl:param name="currentProcedureLine"/>

		<xsl:if test="$totalProcedures >= $currentProcedure">
			<!-- Get the procedure type for this procedure -->
			<xsl:variable name="NDCFormat" select="data[@id=concat(''CMS1500.1.NDCFormat'', $currentProcedure)]"/>

			<xsl:choose>
				<!-- NDC (1 line not printing on line 1) -->
				<xsl:when test="$NDCFormat = 1">
					<!-- Print the procedure information on ONE procedure line -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<!-- Note that procedure 2 y location is passed in even though this is supposed to be the first line.
									 This is due to the fact that we can''t print a one line NDC in procedure line 1. -->
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<!-- Calls the same template recursively (hardcodes the procedure line to 3 since we skipped line 1 to print NDC on line 2) -->
							<xsl:call-template name="CreateProcedureLayout">
								<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
								<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
								<xsl:with-param name="currentProcedureLine" select="3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- Calls the same template recursively -->
							<xsl:call-template name="CreateProcedureLayout">
								<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
								<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
								<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 1"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<!-- NDC (2 lines) -->
				<xsl:when test="$NDCFormat = 2">
					<!-- Print the procedure information on TWO procedure lines -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure1"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure2"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure3"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure4"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure5"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- Note this should never happen because isn''t enough room for a two line NDC starting at line 6 -->
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure6"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>


					<!-- Calls the same template recursively (increments the procedure line by two since we used up two lines) -->
					<xsl:call-template name="CreateProcedureLayout">
						<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
						<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
						<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 2"/>
					</xsl:call-template>
				</xsl:when>

				<!-- Normal Procedure -->
				<xsl:otherwise>
					<!-- Print the procedure information on one procedure lines -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure1"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>


					<!-- Calls the same template recursively (increments the procedure line by one) -->
					<xsl:call-template name="CreateProcedureLayout">
						<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
						<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
						<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 1"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>
	</xsl:template>

	<xsl:template match="/formData/page">
		<!-- Procedure count to determine how many procedures we''ll need to loop through -->
		<xsl:variable name="ProcedureCount" select="count(data[starts-with(@id,''CMS1500.1.aStartMM'')])"/>

		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="CMS1500" pageId="CMS1500.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
			<defs>
				<style type="text/css">
					<![CDATA[
		
		g {
			font-family: Courier New;
			font-size: 10pt;
			font-style: normal;
			font-weight: bold;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
		text.money
		{
			text-anchor: end;
		}

		text.smaller
		{
			font-size: 9pt;
		}
				
		
	    	]]>
				</style>
			</defs>

			<g id="carrier">
				<text x="4.44in" y="0.43in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierName" />
				<text x="4.44in" y="0.59in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierStreet" />
				<text x="4.44in" y="0.75in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierCityStateZip" />
			</g>

			<g id="line1">
				<text x="0.37in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Medicare" />
				<text x="1.06in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Medicaid" />
				<text x="1.77in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Champus" />
				<text x="2.65in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Champva" />
				<text x="3.34in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_GroupHealthPlan" />
				<text x="4.15in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Feca" />
				<text x="4.76in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Other" />

				<text x="5.25in" 	y="1.40in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_aIDNumber" />
			</g>

			<g id="line2">
				<text x="0.37in" 	y="1.73in" width="2.79in" height="0.1in" valueSource="CMS1500.1.2_PatientName" />

				<text x="3.33in" 	y="1.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_MM" />
				<text x="3.64in" 	y="1.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_DD" />
				<text x="3.92in" 	y="1.74in" width="0.6in" height="0.1in" valueSource="CMS1500.1.3_YY" />
				<text x="4.45in" 	y="1.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.3_M" />
				<text x="4.96in" 	y="1.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.3_F" />

				<text x="5.25in" 	y="1.74in" width="2.93in" height="0.1in" valueSource="CMS1500.1.4_InsuredName" />
			</g>

			<g id="line3">
				<text x="0.37in" 	y="2.06in" width="2.79in" height="0.1in" valueSource="CMS1500.1.5_PatientAddress" />

				<text x="3.54in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Self" />
				<text x="4.05in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Spouse" />
				<text x="4.45in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Child" />
				<text x="4.96in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Other" />

				<text x="5.25in" 	y="2.06in" width="2.93in" height="0.1in" valueSource="CMS1500.1.7_InsuredAddress" />
			</g>

			<g id="line4">
				<text x="0.37in" 	y="2.40in" width="2.42in" height="0.1in" valueSource="CMS1500.1.5_City" />
				<text x="2.90in" 	y="2.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.5_State" />

				<text x="5.25in" 	y="2.40in" width="2.28in" height="0.1in" valueSource="CMS1500.1.7_City" />
				<text x="7.6in" 	y="2.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.7_State" />
			</g>

			<g id="box8">
				<text x="3.75in" 	y="2.4in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Single" />
				<text x="4.34in" 	y="2.4in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Married" />
				<text x="4.95in" 	y="2.4in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Other" />
				<text x="3.75in" 	y="2.7in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Employed" />
				<text x="4.34in" 	y="2.7in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_FTStud" />
				<text x="4.95in" 	y="2.7in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_PTStud" />
			</g>

			<g id="line5">
				<text x="0.37in" 	y="2.72in" width="1.19in" height="0.1in" valueSource="CMS1500.1.5_Zip" />
				<text x="1.75in" 	y="2.72in" width="0.4in" height="0.1in" valueSource="CMS1500.1.5_Area" />
				<text x="2.14in" 	y="2.72in" width="1.1in" height="0.1in" valueSource="CMS1500.1.5_Phone" />

				<text x="5.25in" 	y="2.72in" width="1.23in" height="0.1in" valueSource="CMS1500.1.7_Zip" />
				<text x="6.73in" 	y="2.72in" width="0.4in" height="0.1in" valueSource="CMS1500.1.7_Area" />
				<text x="7.16in" 	y="2.72in" width="1.1in" height="0.1in" valueSource="CMS1500.1.7_Phone" />
			</g>

			<g id="line6">
				<text x="0.37in" 	y="3.05in" width="2.42in" height="0.1in" valueSource="CMS1500.1.9_OtherName" />

				<text x="5.25in" 	y="3.05in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1GroupNumber" />
			</g>

			<g id="box10">
				<text x="3.75in" 	y="3.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0aYes" />
				<text x="4.35in" 	y="3.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0aNo" />

				<text x="3.75in" 	y="3.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0bYes" />
				<text x="4.35in" 	y="3.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0bNo" />
				<text x="4.81in" 	y="3.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_0bState" />

				<text x="3.75in" 	y="4.05in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0cYes" />
				<text x="4.35in" 	y="4.05in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0cNo" />
			</g>

			<g id="line7">
				<text x="0.37in" 	y="3.40in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_aGrpNumber" />

				<text x="5.63in" 	y="3.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aMM" />
				<text x="5.94in" 	y="3.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aDD" />
				<text x="6.23in" 	y="3.40in" width="0.6in" height="0.1in" valueSource="CMS1500.1.1_1aYY" />
				<text x="7.04in" 	y="3.40in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1aM" />
				<text x="7.76in" 	y="3.40in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1aF" />
			</g>

			<g id="line8">
				<text x="0.45in" 	y="3.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bMM" />
				<text x="0.75in" 	y="3.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bDD" />
				<text x="1.04in" 	y="3.74in" width="0.6in" height="0.1in" valueSource="CMS1500.1.9_bYYYY" />
				<text x="2.05in" 	y="3.74in"  width="0.09in" height="0.1in" valueSource="CMS1500.1.9_bM" />
				<text x="2.65in" 	y="3.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.9_bF" />

				<text x="5.25in" 	y="3.74in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1bEmployer" />
			</g>

			<g id="line9">
				<text x="0.37in" 	y="4.05in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_cEmployer" />

				<text x="5.25in" 	y="4.05in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1cPlanName" />
			</g>

			<g id="line10">
				<text x="0.37in" 	y="4.39in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_dPlanName" />

				<text x="3.24in" 	y="4.39in" width="1.85in" height="0.1in" valueSource="CMS1500.1.1_0dLocal" />

				<text x="5.44in" 	y="4.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1dYes" />
				<text x="5.94in" 	y="4.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1dNo" />
			</g>

			<g id="line11">
				<text x="0.85in" 	y="5.05in"    width="2.2in"  height="0.1in" valueSource="CMS1500.1.1_2Signature" />
				<text x="3.85in" 	y="5.05in"    width="1.3in"  height="0.1in" valueSource="CMS1500.1.1_2Date" />

				<text x="5.9in" 	y="5.05in"    width="2in"    height="0.1in" valueSource="CMS1500.1.1_3Signature" />
			</g>

			<g id="line12">
				<text x="0.47in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4MM" />
				<text x="0.78in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4DD" />
				<text x="1.08in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4YY" />

				<text x="3.98in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5MM" />
				<text x="4.29in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5DD" />
				<text x="4.56in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5YY" />

				<text x="5.64in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartMM" />
				<text x="5.93in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartDD" />
				<text x="6.24in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartYY" />

				<text x="7.05in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndMM" />
				<text x="7.37in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndDD" />
				<text x="7.66in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndYY" />

			</g>

			<g id="line13">
				<text x="0.37in" 	y="5.72in" width="2.61in" height="0.1in" valueSource="CMS1500.1.1_7Referring" />

				<text x="3.23in" 	y="5.72in" width="1.92in" height="0.1in" valueSource="CMS1500.1.1_7aID" />

				<text x="5.64in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartMM" />
				<text x="5.93in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartDD" />
				<text x="6.25in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartYY" />

				<text x="7.05in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndMM" />
				<text x="7.37in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndDD" />
				<text x="7.66in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndYY" />
			</g>

			<g id="line14">
				<text x="0.37in" 	y="6.06in" width="4.78in" height="0.1in" valueSource="CMS1500.1.1_9Local" />

				<text x="5.43in" 	y="6.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.2_0Yes" />
				<text x="5.94in" 	y="6.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.2_0No" />

				<text x="6.61in" 	y="6.06in" width="0.8in" height="0.1in" valueSource="CMS1500.1.2_0Dollars" class="money" />
				<text x="7.38in" 	y="6.06in" width="0.3in" height="0.1in" valueSource="CMS1500.1.2_0Cents" />
			</g>

			<g id="box21">
				<text x="0.55in" 	y="6.45in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag1" />
				<text x="0.55in" 	y="6.76in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag2" />
				<text x="3.29in" 	y="6.45in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag3" />
				<text x="3.29in" 	y="6.76in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag4" />
			</g>

			<g id="line15">
				<text x="5.25in" 	y="6.4in" width="1.1in"  height="0.1in" valueSource="CMS1500.1.2_2Code" />
				<text x="6.37in" 	y="6.4in" width="1.86in" height="0.1in" valueSource="CMS1500.1.2_2Number" />
			</g>

			<g id="line16">
				<text x="5.25in" 	y="6.71in" width="2.93in" height="0.1in" valueSource="CMS1500.1.2_3PriorAuth" />
			</g>

			<g id="line17">
				<text x="0.43in" y="9.39in" width="1.31in" height="0.1in" valueSource="CMS1500.1.2_5ID" />
				<text x="1.96in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_5SSN" />
				<text x="2.15in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_5EIN" />

				<text x="2.51in" y="9.39in" width="1.41in" height="0.1in" valueSource="CMS1500.1.2_6Account" />

				<text x="4.03in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_7Yes" />
				<text x="4.53in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_7No" />

				<text x="5.25in" y="9.39in" width="0.65in" height="0.1in" valueSource="CMS1500.1.2_8Dollars" class="money" />
				<text x="5.94in" y="9.39in" width="0.33in" height="0.1in" valueSource="CMS1500.1.2_8Cents" />

				<text x="6.35in" y="9.39in" width="0.56in" height="0.1in" valueSource="CMS1500.1.2_9Dollars" class="money" />
				<text x="6.93in" y="9.39in" width="0.33in" height="0.1in" valueSource="CMS1500.1.2_9Cents" />

				<text x="7.27in" y="9.39in" width="0.56in" height="0.1in" valueSource="CMS1500.1.3_0Dollars" class="money" />
				<text x="7.86in" y="9.39in" width="0.33in" height="0.1in" valueSource="CMS1500.1.3_0Cents" />
			</g>

      <!-- Insert the procedure rows -->
      <xsl:call-template name="CreateProcedureLayout">
        <xsl:with-param name="totalProcedures" select="$ProcedureCount"/>
        <xsl:with-param name="currentProcedure" select="1"/>
        <xsl:with-param name="currentProcedureLine" select="1"/>
      </xsl:call-template>

      <g id="box31">
				<text x="0.37in" y="9.95in" width="2.2in" height="0.1in" valueSource="CMS1500.1.3_1Signature" />
				<text x="0.37in" y="10.10in" width="2.2in" height="0.1in" valueSource="CMS1500.1.3_1ProviderName" />
				<text x="1.25in" y="10.25in" width="1.0in" height="0.1in" valueSource="CMS1500.1.3_1Date" />
			</g>

			<g id="box32">
				<text x="2.52in" y="9.79in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Name" />
				<text x="2.52in" y="9.95in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Street" />
				<text x="2.52in" y="10.11in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2CityStateZip" />
				<text x="2.52in" y="10.27in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2FacilityInfo" />
			</g>

			<g id="box33">
				<text x="5.95in" y="9.67in" width="2.30in" height="0.1in" valueSource="CMS1500.1.3_3Provider" class="smaller" />
				<text x="5.26in" y="9.79in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Name" class="smaller" />
				<text x="5.26in" y="9.91in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Street" class="smaller" />
				<text x="5.26in" y="10.03in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3CityStateZip" class="smaller" />
				<text x="5.26in" y="10.15in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Phone" class="smaller" />
				<text x="5.44in" y="10.27in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3PIN" class="smaller" />
				<text x="6.92in" y="10.27in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3GRP" class="smaller" />
			</g>
      
		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 1

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<!-- HCFA SVG Transform With Background -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<!-- Y Locations for each procedure line -->
	<xsl:variable name="yProcedure1">7.36</xsl:variable>
	<xsl:variable name="yProcedure2">7.66</xsl:variable>
	<xsl:variable name="yProcedure3">8</xsl:variable>
	<xsl:variable name="yProcedure4">8.33</xsl:variable>
	<xsl:variable name="yProcedure5">8.67</xsl:variable>
	<xsl:variable name="yProcedure6">9</xsl:variable>

	<xsl:variable name="NDCFirstLineOffset">-0.0797</xsl:variable>
	<xsl:variable name="NDCSecondLineOffset">0.0703</xsl:variable>

	<!--  
				Generates regular procedure SVG for one procedure
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation - y location for this procedure
        
  -->
  
	<xsl:template name="GenerateProcedureSVG">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation"/>

		<g id="box24_{$currentProcedure}">
			<text x="0.37in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
      <text x="1.0in" 	y="{$yProcedureLocation}in" width="0.5in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.26in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
      <text x="1.88in" 	y="{$yProcedureLocation}in" width="0.5in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.17in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" 	y="{$yProcedureLocation}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" 	y="{$yProcedureLocation}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" 	y="{$yProcedureLocation}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" 	y="{$yProcedureLocation}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.11in" 	y="{$yProcedureLocation}in" width="0.52in" height="0.1in" text-anchor="start" valueSource="CMS1500.1.gUnits{$currentProcedure}" class="smaller" />
			<text x="6.47in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" 	y="{$yProcedureLocation}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
		</g>

	</xsl:template>

	<!--  
				Generates NDC procedure SVG for one procedure. 
				This prints over one row doubling up the NDC text in the same row.
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation - y location for this procedure
        
  -->
  
	<xsl:template name="GenerateNDCProcedureSVGOneLine">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation"/>

		<g id="box24_{$currentProcedure}_NDC_1row">
			<text x="0.37in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
			<text x="1.00in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.26in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
			<text x="1.88in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.17in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.11in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.52in" height="0.1in" text-anchor="start" valueSource="CMS1500.1.gUnits{$currentProcedure}" class="smaller" />
			<text x="6.47in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
			<!--<text x="0.37in" 	y="{$yProcedureLocation + $NDCSecondLineOffset}in" width="2.37in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />-->
			<text x="2.8in" y="{$yProcedureLocation + $NDCSecondLineOffset}in" width="2.4in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />
		</g>

	</xsl:template>

	<!--  
				Generates NDC procedure SVG for one procedure. 
				This prints over two rows so it requires two procedure locations
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation1 - y location for the first procedure line
        yProcedureLocation2 - y location for the second procedure line
        
  -->
  
	<xsl:template name="GenerateNDCProcedureSVGTwoLine">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation1"/>
		<xsl:param name="yProcedureLocation2"/>

		<g id="box24_{$currentProcedure}_NDC_2row">
			<text x="0.37in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
			<text x="1.00in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.26in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
			<text x="1.88in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.17in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" 	y="{$yProcedureLocation1}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" 	y="{$yProcedureLocation1}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" 	y="{$yProcedureLocation1}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" 	y="{$yProcedureLocation1}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.11in" 	y="{$yProcedureLocation1}in" width="0.52in" height="0.1in" text-anchor="start" valueSource="CMS1500.1.gUnits{$currentProcedure}" class="smaller" />
			<text x="6.47in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" 	y="{$yProcedureLocation1}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
			<text x="0.37in" 	y="{$yProcedureLocation2}in" width="2.37in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />
		</g>

	</xsl:template>

	<!--  
        Takes in the number procedures to process.
        Loops through each procedure to print.
        If this is a regular procedure print in one row, if it is an NDC procedure print in two rows.
        Keep track of how many rows have been printed.
        
        Parameters:
        totalProcedures - total number of procedures to display
        currentProcedure - index of the current procedure being processed
        currentProcedureLine - current procedure line to print out
        
  -->
  
	<xsl:template name="CreateProcedureLayout">
		<xsl:param name="totalProcedures"/>
		<xsl:param name="currentProcedure"/>
		<xsl:param name="currentProcedureLine"/>

		<xsl:if test="$totalProcedures >= $currentProcedure">
			<!-- Get the procedure type for this procedure -->
			<xsl:variable name="NDCFormat" select="data[@id=concat(''CMS1500.1.NDCFormat'', $currentProcedure)]"/>

			<xsl:choose>
				<!-- NDC (1 line not printing on line 1) -->
				<xsl:when test="$NDCFormat = 1">
					<!-- Print the procedure information on ONE procedure line -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<!-- Note that procedure 2 y location is passed in even though this is supposed to be the first line.
									 This is due to the fact that we can''t print a one line NDC in procedure line 1. -->
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<!-- Calls the same template recursively (hardcodes the procedure line to 3 since we skipped line 1 to print NDC on line 2) -->
							<xsl:call-template name="CreateProcedureLayout">
								<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
								<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
								<xsl:with-param name="currentProcedureLine" select="3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- Calls the same template recursively -->
							<xsl:call-template name="CreateProcedureLayout">
								<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
								<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
								<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 1"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<!-- NDC (2 lines) -->
				<xsl:when test="$NDCFormat = 2">
					<!-- Print the procedure information on TWO procedure lines -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure1"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure2"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure3"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure4"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure5"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- Note this should never happen because isn''t enough room for a two line NDC starting at line 6 -->
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure6"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<!-- Calls the same template recursively (increments the procedure line by two since we used up two lines) -->
					<xsl:call-template name="CreateProcedureLayout">
						<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
						<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
						<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 2"/>
					</xsl:call-template>
				</xsl:when>

				<!-- Normal Procedure -->
				<xsl:otherwise>
					<!-- Print the procedure information on one procedure lines -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure1"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<!-- Calls the same template recursively (increments the procedure line by one) -->
					<xsl:call-template name="CreateProcedureLayout">
						<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
						<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
						<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 1"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>
	</xsl:template>

	<xsl:template match="/formData/page">
		<!-- Procedure count to determine how many procedures we''ll need to loop through -->
		<xsl:variable name="ProcedureCount" select="count(data[starts-with(@id,''CMS1500.1.aStartMM'')])"/>

		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="CMS1500" pageId="CMS1500.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
			<defs>
				<style type="text/css">
					<![CDATA[
		
		g {
			font-family: Courier New;
			font-size: 10pt;
			font-style: normal;
			font-weight: bold;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
		text.money
		{
			text-anchor: end;
		}

		text.smaller
		{
			font-size: 9pt;
		}
				
	    	]]>
				</style>
			</defs>

			<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://98291fd6-8a70-41ad-8469-65c4ee8ee8d4?type=global"></image>
	
			<g id="carrier">
				<text x="4.44in" y="0.43in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierName" />
				<text x="4.44in" y="0.59in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierStreet" />
				<text x="4.44in" y="0.75in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierCityStateZip" />
			</g>

			<g id="line1">
				<text x="0.37in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Medicare" />
				<text x="1.06in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Medicaid" />
				<text x="1.77in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Champus" />
				<text x="2.65in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Champva" />
				<text x="3.34in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_GroupHealthPlan" />
				<text x="4.15in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Feca" />
				<text x="4.76in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Other" />

				<text x="5.25in" 	y="1.40in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_aIDNumber" />
			</g>

			<g id="line2">
				<text x="0.37in" 	y="1.73in" width="2.79in" height="0.1in" valueSource="CMS1500.1.2_PatientName" />

				<text x="3.33in" 	y="1.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_MM" />
				<text x="3.64in" 	y="1.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_DD" />
				<text x="3.92in" 	y="1.74in" width="0.6in" height="0.1in" valueSource="CMS1500.1.3_YY" />
				<text x="4.45in" 	y="1.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.3_M" />
				<text x="4.96in" 	y="1.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.3_F" />

				<text x="5.25in" 	y="1.74in" width="2.93in" height="0.1in" valueSource="CMS1500.1.4_InsuredName" />
			</g>

			<g id="line3">
				<text x="0.37in" 	y="2.06in" width="2.79in" height="0.1in" valueSource="CMS1500.1.5_PatientAddress" />

				<text x="3.54in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Self" />
				<text x="4.05in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Spouse" />
				<text x="4.45in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Child" />
				<text x="4.96in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Other" />

				<text x="5.25in" 	y="2.06in" width="2.93in" height="0.1in" valueSource="CMS1500.1.7_InsuredAddress" />
			</g>

			<g id="line4">
				<text x="0.37in" 	y="2.40in" width="2.42in" height="0.1in" valueSource="CMS1500.1.5_City" />
				<text x="2.90in" 	y="2.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.5_State" />

				<text x="5.25in" 	y="2.40in" width="2.28in" height="0.1in" valueSource="CMS1500.1.7_City" />
				<text x="7.6in" 	y="2.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.7_State" />
			</g>

			<g id="box8">
				<text x="3.75in" 	y="2.4in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Single" />
				<text x="4.34in" 	y="2.4in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Married" />
				<text x="4.95in" 	y="2.4in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Other" />
				<text x="3.75in" 	y="2.7in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Employed" />
				<text x="4.34in" 	y="2.7in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_FTStud" />
				<text x="4.95in" 	y="2.7in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_PTStud" />
			</g>

			<g id="line5">
				<text x="0.37in" 	y="2.72in" width="1.19in" height="0.1in" valueSource="CMS1500.1.5_Zip" />
				<text x="1.75in" 	y="2.72in" width="0.4in" height="0.1in" valueSource="CMS1500.1.5_Area" />
				<text x="2.14in" 	y="2.72in" width="1.1in" height="0.1in" valueSource="CMS1500.1.5_Phone" />

				<text x="5.25in" 	y="2.72in" width="1.23in" height="0.1in" valueSource="CMS1500.1.7_Zip" />
				<text x="6.73in" 	y="2.72in" width="0.4in" height="0.1in" valueSource="CMS1500.1.7_Area" />
				<text x="7.16in" 	y="2.72in" width="1.1in" height="0.1in" valueSource="CMS1500.1.7_Phone" />
			</g>

			<g id="line6">
				<text x="0.37in" 	y="3.05in" width="2.42in" height="0.1in" valueSource="CMS1500.1.9_OtherName" />

				<text x="5.25in" 	y="3.05in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1GroupNumber" />
			</g>

			<g id="box10">
				<text x="3.75in" 	y="3.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0aYes" />
				<text x="4.35in" 	y="3.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0aNo" />

				<text x="3.75in" 	y="3.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0bYes" />
				<text x="4.35in" 	y="3.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0bNo" />
				<text x="4.81in" 	y="3.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_0bState" />

				<text x="3.75in" 	y="4.05in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0cYes" />
				<text x="4.35in" 	y="4.05in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0cNo" />
			</g>

			<g id="line7">
				<text x="0.37in" 	y="3.40in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_aGrpNumber" />

				<text x="5.63in" 	y="3.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aMM" />
				<text x="5.94in" 	y="3.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aDD" />
				<text x="6.23in" 	y="3.40in" width="0.6in" height="0.1in" valueSource="CMS1500.1.1_1aYY" />
				<text x="7.04in" 	y="3.40in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1aM" />
				<text x="7.76in" 	y="3.40in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1aF" />
			</g>

			<g id="line8">
				<text x="0.45in" 	y="3.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bMM" />
				<text x="0.75in" 	y="3.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bDD" />
				<text x="1.04in" 	y="3.74in" width="0.6in" height="0.1in" valueSource="CMS1500.1.9_bYYYY" />
				<text x="2.05in" 	y="3.74in"  width="0.09in" height="0.1in" valueSource="CMS1500.1.9_bM" />
				<text x="2.65in" 	y="3.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.9_bF" />

				<text x="5.25in" 	y="3.74in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1bEmployer" />
			</g>

			<g id="line9">
				<text x="0.37in" 	y="4.05in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_cEmployer" />

				<text x="5.25in" 	y="4.05in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1cPlanName" />
			</g>

			<g id="line10">
				<text x="0.37in" 	y="4.39in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_dPlanName" />

				<text x="3.24in" 	y="4.39in" width="1.85in" height="0.1in" valueSource="CMS1500.1.1_0dLocal" />

				<text x="5.44in" 	y="4.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1dYes" />
				<text x="5.94in" 	y="4.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1dNo" />
			</g>

			<g id="line11">
				<text x="0.85in" 	y="5.05in"    width="2.2in"  height="0.1in" valueSource="CMS1500.1.1_2Signature" />
				<text x="3.85in" 	y="5.05in"    width="1.3in"  height="0.1in" valueSource="CMS1500.1.1_2Date" />

				<text x="5.9in" 	y="5.05in"    width="2in"    height="0.1in" valueSource="CMS1500.1.1_3Signature" />
			</g>

			<g id="line12">
				<text x="0.47in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4MM" />
				<text x="0.78in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4DD" />
				<text x="1.08in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4YY" />

				<text x="3.98in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5MM" />
				<text x="4.29in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5DD" />
				<text x="4.56in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5YY" />

				<text x="5.64in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartMM" />
				<text x="5.93in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartDD" />
				<text x="6.24in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartYY" />

				<text x="7.05in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndMM" />
				<text x="7.37in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndDD" />
				<text x="7.66in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndYY" />

			</g>

			<g id="line13">
				<text x="0.37in" 	y="5.72in" width="2.61in" height="0.1in" valueSource="CMS1500.1.1_7Referring" />

				<text x="3.23in" 	y="5.72in" width="1.92in" height="0.1in" valueSource="CMS1500.1.1_7aID" />

				<text x="5.64in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartMM" />
				<text x="5.93in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartDD" />
				<text x="6.25in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartYY" />

				<text x="7.05in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndMM" />
				<text x="7.37in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndDD" />
				<text x="7.66in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndYY" />
			</g>

			<g id="line14">
				<text x="0.37in" 	y="6.06in" width="4.78in" height="0.1in" valueSource="CMS1500.1.1_9Local" />

				<text x="5.43in" 	y="6.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.2_0Yes" />
				<text x="5.94in" 	y="6.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.2_0No" />

				<text x="6.61in" 	y="6.06in" width="0.8in" height="0.1in" valueSource="CMS1500.1.2_0Dollars" class="money" />
				<text x="7.38in" 	y="6.06in" width="0.3in" height="0.1in" valueSource="CMS1500.1.2_0Cents" />
			</g>

			<g id="box21">
				<text x="0.55in" 	y="6.45in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag1" />
				<text x="0.55in" 	y="6.76in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag2" />
				<text x="3.29in" 	y="6.45in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag3" />
				<text x="3.29in" 	y="6.76in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag4" />
			</g>

			<g id="line15">
				<text x="5.25in" 	y="6.4in" width="1.1in"  height="0.1in" valueSource="CMS1500.1.2_2Code" />
				<text x="6.37in" 	y="6.4in" width="1.86in" height="0.1in" valueSource="CMS1500.1.2_2Number" />
			</g>

			<g id="line16">
				<text x="5.25in" 	y="6.71in" width="2.93in" height="0.1in" valueSource="CMS1500.1.2_3PriorAuth" />
			</g>

			<g id="line17">
				<text x="0.43in" y="9.39in" width="1.31in" height="0.1in" valueSource="CMS1500.1.2_5ID" />
				<text x="1.96in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_5SSN" />
				<text x="2.15in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_5EIN" />

				<text x="2.51in" y="9.39in" width="1.41in" height="0.1in" valueSource="CMS1500.1.2_6Account" />

				<text x="4.03in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_7Yes" />
				<text x="4.53in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_7No" />

				<text x="5.30in" y="9.39in" width="0.65in" height="0.1in" valueSource="CMS1500.1.2_8Dollars" class="money" />
				<text x="5.99in" y="9.39in" width="0.33in" height="0.1in" valueSource="CMS1500.1.2_8Cents" />

				<text x="6.40in" y="9.39in" width="0.56in" height="0.1in" valueSource="CMS1500.1.2_9Dollars" class="money" />
				<text x="6.98in" y="9.39in" width="0.33in" height="0.1in" valueSource="CMS1500.1.2_9Cents" />

				<text x="7.32in" y="9.39in" width="0.56in" height="0.1in" valueSource="CMS1500.1.3_0Dollars" class="money" />
				<text x="7.91in" y="9.39in" width="0.33in" height="0.1in" valueSource="CMS1500.1.3_0Cents" />
			</g>

      <!-- Insert the procedure rows -->
      <xsl:call-template name="CreateProcedureLayout">
        <xsl:with-param name="totalProcedures" select="$ProcedureCount"/>
        <xsl:with-param name="currentProcedure" select="1"/>
        <xsl:with-param name="currentProcedureLine" select="1"/>
      </xsl:call-template>

      <g id="box31">
				<text x="0.37in" y="9.95in" width="2.2in" height="0.1in" valueSource="CMS1500.1.3_1Signature" />
				<text x="0.37in" y="10.10in" width="2.2in" height="0.1in" valueSource="CMS1500.1.3_1ProviderName" />
				<text x="1.25in" y="10.25in" width="1.0in" height="0.1in" valueSource="CMS1500.1.3_1Date" />
			</g>

			<g id="box32">
				<text x="2.52in" y="9.79in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Name" />
				<text x="2.52in" y="9.95in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Street" />
				<text x="2.52in" y="10.11in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2CityStateZip" />
				<text x="2.52in" y="10.27in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2FacilityInfo" />
			</g>

			<g id="box33">
				<text x="5.95in" y="9.67in" width="2.30in" height="0.1in" valueSource="CMS1500.1.3_3Provider" class="smaller" />
				<text x="5.26in" y="9.79in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Name" class="smaller" />
				<text x="5.26in" y="9.91in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Street" class="smaller" />
				<text x="5.26in" y="10.03in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3CityStateZip" class="smaller" />
				<text x="5.26in" y="10.15in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Phone" class="smaller" />
				<text x="5.44in" y="10.27in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3PIN" class="smaller" />
				<text x="6.92in" y="10.27in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3GRP" class="smaller" />
			</g>
      
		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 16