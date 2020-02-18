-----------------------------------------------------------------------------------------------------------
-- Case 19514: Change procedure code J7320 to Q4084.
-----------------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 203
IF charindex('_0203_', db_name()) > 0
BEGIN

--INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
--VALUES (24, 'One Page Scanned Version 2 with Insurances', 'Encounter form that prints on a single page', 24)

--INSERT INTO PrintingFormDetails (PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
--VALUES (24, 9, 27, 'One Page Scanned Version 2 with Insurances', 0)

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
<svg formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="300" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
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
			font-size: 6pt; font-weight: bold;
			}

			text.centeredtext
			{
			text-anchor: middle;
			}

		</style>
	</defs>

	<!-- Background image -->
	<image x="0.5in" y="0" width="7.5in" height="11in" xlink:href="kareodms://8e56a984-116a-42b0-ae60-a42eaa2041f6?type=global" />

	<!--<image x="0.5in" y="0" width="7.5in" height="11in" xlink:href="EncounterForm.OnePage.ScannedV2.WithInsurances.jpg" />-->

	<g id="PracticeHeader">
		<text x="2.25in" y="0.2in" width="4.0in" height="0.1in" font-family="Arial" font-weight="bold" font-size="14pt" class="centeredtext" valueSource="EncounterForm.1.PracticeName1"/>
		<text x="2.25in" y="0.4in" width="4.0in" height="0.1in" font-family="Arial" font-weight="bold" font-size="12pt" class="centeredtext" valueSource="EncounterForm.1.Provider1"/>
		<text x="2.25in" y="0.57in" width="4.0in" height="0.1in" font-family="Arial" font-weight="bold" font-size="10pt" class="centeredtext" valueSource="EncounterForm.1.PracticeAddress1"/>
		<text x="2.25in" y="0.70in" width="4.0in" height="0.1in" font-family="Arial" font-weight="bold" font-size="10pt" class="centeredtext" valueSource="EncounterForm.1.PracticePhoneFax1"/>
	</g>

	<g id="BottomInformation">

		<text x="0.56in" y="8.12in" width="0.93in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.AppDateTime1" />
		<text x="1.50in"  y="8.12in" width="1.7in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.PatientName1" />
		<text x="3.25in" y="8.12in" width="1.125in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.Reason1" />
		<text x="4.40in" y="8.12in" width="0.75in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.PatientBalance1" />

		<text x="0.56in" y="8.45in" width="0.61in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.TicketNumber1" />
		<text x="1.15in" y="8.45in" width="0.37in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.DrNumber1" />
		<text x="1.50in" y="8.45in" width="1.05in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.ProviderLastName1" />
		<text x="2.52in" y="8.45in" width="1.28in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.POS1" />
		<text x="3.78in" y="8.45in" width="0.60in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.DOB1" />

		<text x="0.56in" y="8.77in" width="0.65in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.PatientID1" />
		<text x="1.2in" y="8.77in" width="1.71in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.ResponsiblePerson1" />
		<text x="2.88in" y="8.79in" width="0.70in" height="0.1in" font-family="Arial Narrow" font-size="7pt" valueSource="EncounterForm.1.HomePhone1" />
		<text x="3.60in" y="8.77in" width="0.80in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.ReferringProviderLastName1" />

		<text x="0.56in" y="9.09in" width="0.52in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.Gender1" />
		<text x="1.20in" y="9.09in" width="1.50in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.AddressLine11" />
		<text x="2.750in" y="9.09in" width="1.65in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.CityStateZip1" />

		<text x="0.82in" y="9.40in" width="0.5in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.Bal901" />
		<text x="1.35in" y="9.40in" width="0.50in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.Bal601" />
		<text x="1.88in" y="9.40in" width="0.50in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.Bal301" />
		<text x="2.40in" y="9.40in" width="0.50in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.BalCurrent1" />
		<text x="2.92in" y="9.40in" width="0.50in" height="0.1in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.PatientBalance1" />

		<text x="0.56in" y="9.75in" width="1.27in" height="0.375in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.PrimaryIns1" />
		<text x="0.56in" y="10.18in" width="1.27in" height="0.375in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.SecondaryIns1" />
		<text x="2.15in" y="9.75in" width="1.54in" height="0.375in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.PolicyNumber1" />
		<text x="2.15in" y="10.18in" width="1.54in" height="0.375in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.SecondaryPolicyNumber1" />
		<text x="3.65in" y="9.90in" width="0.75in" height="0.25in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.RelationshipToInsured1" />
		<text x="3.65in" y="10.19in" width="0.75in" height="0.25in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.SecondaryRelationshipToInsured1" />
	</g>

</svg>'
WHERE PrintingFormDetailsID = 24

END