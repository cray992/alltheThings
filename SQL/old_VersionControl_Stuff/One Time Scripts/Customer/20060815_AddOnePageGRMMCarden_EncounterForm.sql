---------------------------------------------------------------------------------------------------------------------------------------
-- Case 13010: Implement a one page customized encounter form for Dr. Edward Carden, a provider of GR Medical Management(Customer 108).
---------------------------------------------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 108
IF charindex('_0108_', db_name()) > 0
BEGIN
/*
INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (39, 'One Page Dr. Carden', 'Encounter form that prints on a single page', 39)

INSERT INTO PrintingFormDetails
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES
	(55, 9, 42, 'One Page Dr. Carden', 1)
*/
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
					font-size: 9pt;
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
	    <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://3db2c19c-c527-4986-8ed1-0e7c633f2ade?type=global" />

      <!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="EncounterForm.OnePage.GRMM.Carden.jpg" />
      -->
      
			<g id="HeaderInformation">
				<text x="0.36in" y="0.75in" width="2.64in" height="0.10in" valueSource="EncounterForm.1.PatientName1"/>
        <text x="0.36in" y="1.10in" width="2.64in" height="0.10in" valueSource="EncounterForm.1.SSN1"/>
        <text x="0.36in" y="1.43in" width="2.64in" height="0.10in" valueSource="EncounterForm.1.DOBAge1"/>
        <text x="3.02in" y="0.75in" width="2.52in" height="0.10in" valueSource="EncounterForm.1.PatientID1"/>
        <text x="3.02in" y="1.10in" width="2.52in" height="0.10in" valueSource="EncounterForm.1.PatCaseScenario1"/>
        <text x="3.02in" y="1.43in" width="2.52in" height="0.10in" valueSource="EncounterForm.1.RefProvider1"/>
        <text x="5.57in" y="0.75in" width="2.57in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1"/>
        <text x="5.57in" y="1.10in" width="2.57in" height="0.10in" valueSource="EncounterForm.1.POS1"/>
        <text x="5.57in" y="1.43in" width="2.57in" height="0.10in" valueSource="EncounterForm.1.TicketNumber1"/>
			</g>

		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 55

END