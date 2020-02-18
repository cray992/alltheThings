---------------------------------------------------------------------------------------------
-- Case 9399: Implement a custom 2-page encounter form for GR's client Dr. Philips
---------------------------------------------------------------------------------------------

--begin tran
-- registration
INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (6, 'Two Page Scanned', 'Encounter form that uses prescanned form', 6)

INSERT INTO PrintingFormDetails 
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES
	(19, 9, 6, 'Encounter Form Version 3 (Two Page) - Page 1', 0)

INSERT INTO PrintingFormDetails 
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES
	(20, 9, 7, 'Encounter Form Version 3 (Two Page) - Page 2', 0)


-- First Page
UPDATE PrintingFormDetails
	SET SVGDefinition=
		'<?xml version="1.0" encoding="utf-8"?>
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
    </style>
  </defs>

	<!-- Background image (Full Size: 36879ab1-fd2a-4655-8f47-cecdc1a31695) --> 
  <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://cadc684a-90b0-4071-b287-eb9205a0c2d5?type=global" />


  <g id="HeaderInformation">

    <!-- First Line -->
    <text x="0.60in" y="0.85in" width="4.1in" height="0.1in" valueSource="EncounterForm.1.PatientName1" />
    <text x="5.0in" y="0.85in" width="1.40in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
    <text x="7.15in" y="0.85in" width="0.90in" height="0.1in" valueSource="EncounterForm.1.DOB1" />

    <!-- Second Line -->
    <text x="0.60in" y="1.12in" width="4.1in" height="0.1in" valueSource="EncounterForm.1.PrimaryIns1" />
    <text x="5.50in" y="1.12in" width="0.9in" height="0.1in" valueSource="EncounterForm.1.Copay1" />
    <text x="6.50in" y="1.12in" width="1.6in" height="0.1in" valueSource="EncounterForm.1.AuthNumber1" />
  </g>

</svg>'
WHERE PrintingFormDetailsID=19

-- Second Page
UPDATE PrintingFormDetails
	SET SVGDefinition=
		'<?xml version="1.0" encoding="utf-8"?> 
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
    </style>
  </defs>

	<!-- Background image -->
  <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://0393007d-26c7-47cb-8362-f619cf018d7f?type=global" />

</svg>'
WHERE PrintingFormDetailsID=20
