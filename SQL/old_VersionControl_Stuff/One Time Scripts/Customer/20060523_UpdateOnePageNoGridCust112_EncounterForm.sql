UPDATE PrintingFormDetails
SET SVGDefinition = 
	'<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="default-format" NaN="0.00" />

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

        <text x="0.49in" y="0.42in" valueSource="EncounterForm.1.TemplateName1" />

      </g>

      <g id="PracticeInformation">

        <xsl:variable name="PracticeNameAndAddress" select="concat(data[@id=''EncounterForm.1.PracticeName1''], '' '', data[@id=''EncounterForm.1.PracticeAddress1''])"/>

        <text x="0.49in" y="0.70in">
          <xsl:value-of select="$PracticeNameAndAddress"/>
        </text>

        <xsl:variable name="PracticePhonesAndTaxID" select="concat(data[@id=''EncounterForm.1.PracticePhoneFax1''], '' '', data[@id=''EncounterForm.1.PracticeTaxID1''])"/>

        <text x="0.49in" y="0.85in">
          <xsl:value-of select="$PracticePhonesAndTaxID"/>
        </text>

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