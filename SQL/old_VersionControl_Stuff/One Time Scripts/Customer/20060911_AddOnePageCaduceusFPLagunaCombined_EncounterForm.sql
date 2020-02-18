-------------------------------------------------------------------------------------------------------------------
-- Case 14003: Implement a one page customized encounter form for Caduceus, a practice of Department B(Customer 1). 
-------------------------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 1
IF charindex('_0001_', db_name()) > 0
BEGIN

INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (49, 'One Page Caduceus FP Laguna Combined', 'Encounter form that prints on a single page', 49)

INSERT INTO PrintingFormDetails
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES
	(65, 9, 52, 'One Page Caduceus FP Laguna Combined', 1)

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
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://cd836126-e947-4438-81e3-152b09eda337?type=global" />

      <!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="EncounterForm.OnePage.Caduceus.FP.Laguna.Combined.jpg" />
      -->
      
      <g>
        
				<g id="AccountActivity">
					<text x="4.61in" y="0.545in" width="1.50in" height="0.10in" valueSource="EncounterForm.1.PatientBalance1"/>
				</g>

				<g id="PatientInformation">
					<text x="0.40in" y="1.205in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.PatientName1"/>
          <text x="0.40in" y="1.325in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.AddressLine11" />
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
              <text x="0.40in" y="1.445in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.AddressLine21" />
              <text x="0.40in" y="1.565in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1"/>
              <text x="0.40in" y="1.685in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.FullPhone1"/>
            </xsl:when>
            <xsl:otherwise>
              <text x="0.40in" y="1.445in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1"/>
              <text x="0.40in" y="1.565in" width="2.32in" height="0.10in" valueSource="EncounterForm.1.FullPhone1"/>
            </xsl:otherwise>
          </xsl:choose>
					<text x="0.40in" y="1.945in" width="1.21in" height="0.10in" valueSource="EncounterForm.1.PatientID1"/>
					<text x="1.71in" y="1.945in" width="0.99in" height="0.10in" valueSource="EncounterForm.1.DOBAge1"/>
				</g>

				<g id="InsuranceCoverage">
					<text x="2.76in" y="1.215in" width="1.81in" height="0.10in" valueSource="EncounterForm.1.ResponsiblePerson1"/>
					<text x="2.76in" y="1.455in" width="1.81in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1"/>
					<text x="2.76in" y="1.705in" width="1.81in" height="0.10in" valueSource="EncounterForm.1.SecondaryIns1"/>
					<text x="2.76in" y="1.945in" width="0.97in" height="0.10in" valueSource="EncounterForm.1.Copay1"/>
					<text x="3.78in" y="1.945in" width="0.78in" height="0.10in" valueSource="EncounterForm.1.Deductible1"/>
				</g>

				<g id="AppointmentInformation">
					<text x="4.61in" y="1.215in" width="1.50in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1"/>
					<text x="4.61in" y="1.455in" width="1.50in" height="0.10in" valueSource="EncounterForm.1.POS1"/>
					<text x="4.61in" y="1.705in" width="1.50in" height="0.10in" valueSource="EncounterForm.1.PCP1"/>
					<text x="4.61in" y="1.945in" width="1.50in" height="0.10in" valueSource="EncounterForm.1.Provider1"/>
					<text x="6.16in" y="1.215in" width="1.95in" height="0.10in" valueSource="EncounterForm.1.TicketNumber1"/>
					<text x="6.16in" y="1.455in" width="1.95in" height="0.10in" valueSource="EncounterForm.1.Reason1"/>
          <text x="6.16in" y="1.705in" width="1.95in" height="0.10in" valueSource="EncounterForm.1.InjuryDate1"/>
				</g>

				<g id="AccountStatus">
					<text x="0.40in" y="2.2275in" width="5.71in" height="0.10in" valueSource="EncounterForm.1.AccountStatus1" />
				</g>

			</g>

		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 65

END