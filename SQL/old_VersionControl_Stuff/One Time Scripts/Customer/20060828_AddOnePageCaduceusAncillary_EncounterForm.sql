-------------------------------------------------------------------------------------------------------------------
-- Case 13584: Implement a one page customized encounter form for Caduceus, a practice of Department B(Customer 1). 
-------------------------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 1
IF charindex('_0001_', db_name()) > 0
BEGIN

INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (47, 'One Page Caduceus Ancillary', 'Encounter form that prints on a single page', 47)

INSERT INTO PrintingFormDetails
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES
	(63, 9, 50, 'One Page Caduceus Ancillary', 1)

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="default-format" NaN="0.00" />

  <xsl:template match="/formData/page">
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

          text
          {
          baseline-shift: -100%;
          }

        </style>
      </defs>

      <!-- Background image -->
	    <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://4032f937-b40d-47ba-8ec4-ada906832ad2?type=global" />

      <!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="EncounterForm.OnePage.Caduceus.Ancillary.jpg" />
      -->
      
      <g>

        <g id="AccountActivity">
          <text x="4.62in" y="0.575in" width="1.49in" height="0.10in" valueSource="EncounterForm.1.PatientBalance1"/>
        </g>

        <g id="PatientInformation">
          <text x="0.40in" y="1.235in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.PatientName1"/>
          <text x="0.40in" y="1.355in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.AddressLine11" />
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
              <text x="0.40in" y="1.475in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.AddressLine21" />
              <text x="0.40in" y="1.595in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1"/>
              <text x="0.40in" y="1.715in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.FullPhone1"/>
            </xsl:when>
            <xsl:otherwise>
              <text x="0.40in" y="1.475in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1"/>
              <text x="0.40in" y="1.595in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.FullPhone1"/>
            </xsl:otherwise>
          </xsl:choose>
          <text x="0.40in" y="1.975in" width="1.21in" height="0.10in" valueSource="EncounterForm.1.PatientID1"/>
          <text x="1.71in" y="1.975in" width="0.99in" height="0.10in" valueSource="EncounterForm.1.DOBAge1"/>
        </g>

        <g id="InsuranceCoverage">
          <text x="2.76in" y="1.235in" width="1.81in" height="0.10in" valueSource="EncounterForm.1.ResponsiblePerson1"/>
          <text x="2.76in" y="1.485in" width="1.81in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1"/>
          <text x="2.76in" y="1.735in" width="1.81in" height="0.10in" valueSource="EncounterForm.1.SecondaryIns1"/>
          <text x="2.76in" y="1.975in" width="0.97in" height="0.10in" valueSource="EncounterForm.1.Copay1"/>
          <text x="3.78in" y="1.975in" width="0.78in" height="0.10in" valueSource="EncounterForm.1.Deductible1"/>
        </g>

        <g id="EncounterInformation">
          <text x="4.62in" y="1.235in" width="1.49in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1"/>
          <text x="4.62in" y="1.485in" width="1.49in" height="0.10in" valueSource="EncounterForm.1.POS1"/>
          <text x="4.62in" y="1.735in" width="1.49in" height="0.10in" valueSource="EncounterForm.1.RefProvider1"/>
          <text x="4.62in" y="1.975in" width="1.49in" height="0.10in" valueSource="EncounterForm.1.Provider1"/>
          <text x="6.18in" y="1.235in" width="1.91in" height="0.10in" valueSource="EncounterForm.1.TicketNumber1"/>
          <text x="6.18in" y="1.485in" width="1.91in" height="0.10in" valueSource="EncounterForm.1.Reason1"/>
        </g>

        <g id="AccountStatus">
          <text x="0.40in" y="2.2475in" width="5.71in" height="0.10in" valueSource="EncounterForm.1.AccountStatus1" />
        </g>

      </g>

    </svg>
  </xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 63

END