-- Make sure to only migrate the data when in customer 1
IF charindex('_0001_', db_name()) > 0
BEGIN

/*
-- Remove existing Encounter Form Type for flowsheet
DECLARE @FlowsheetFormTypeID INT

SELECT	@FlowsheetFormTypeID = EncounterFormTypeID
FROM EncounterFormType WHERE [Name] = 'Flowsheet for Caduceus/YLFP'

UPDATE	EncounterTemplate
SET		EncounterFormTypeID = 20	-- Setting it to one page four column
WHERE	EncounterFormTypeID = @FlowsheetFormTypeID

DELETE FROM	EncounterFormType
WHERE	EncounterFormTypeID = @FlowsheetFormTypeID

DELETE FROM PrintingFormDetails
WHERE	PrintingFormDetailsID = 21

-- Insert a new Printing Form for this flowsheet
INSERT INTO PrintingForm
	(PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
VALUES
	(12, 'Caduceus Flow Sheet', 'Caduceus Flow Sheet', 'AppointmentDataProvider_GetCaduceusFlowSheetXml', 0)


INSERT INTO PrintingFormDetails 
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES
	(21, 12, 1, 'Caduceus Flow Sheet', 0)
*/
UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
<svg formId="CaduceusFlowSheet" pageId="CaduceusFlowSheet.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="300" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <style type="text/css">

      g
      {
      font-family: Arial,Arial Narrow,Helvetica;
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
  <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://78a41cb8-8ddd-422e-a5f1-7ab60bff03c5?type=global" />


  <g id="HeaderInformation">

    <!-- First Line -->
    <text x="0.57in" y="0.61in" width="2.24in" height="0.1in" valueSource="CaduceusFlowSheet.1.PatientName1" />
    <text x="2.83in" y="0.61in" width="1.35in" height="0.1in" valueSource="CaduceusFlowSheet.1.AppDateTime1" />
    <text x="4.20in" y="0.61in" width="1.53in" height="0.1in" valueSource="CaduceusFlowSheet.1.PrimaryIns1" />
    <text x="5.75in" y="0.61in" width="2.20in" height="0.1in" valueSource="CaduceusFlowSheet.1.PCP1" />

    <!-- Second Line --> 
    <text x="0.57in" y="1.05in" width="2.24in" height="0.1in" valueSource="CaduceusFlowSheet.1.Reason1" />
    <text x="2.83in" y="1.05in" width="1.35in" height="0.1in" valueSource="CaduceusFlowSheet.1.DOB1" />
    <text x="4.20in" y="1.05in" width="1.53in" height="0.1in" valueSource="CaduceusFlowSheet.1.SecondaryIns1" />
    <text x="5.75in" y="1.05in" width="2.20in" height="0.1in" valueSource="CaduceusFlowSheet.1.Provider1" />

  </g>

</svg>'
WHERE PrintingFormDetailsID = 21

END