/*
-----------------------------------------------------------------------------------------------------
CASE 21181 - Implement Proof of Service Form for Medical Management Specialist(Customer 681).
-----------------------------------------------------------------------------------------------------
*/
/*
INSERT INTO PrintingForm(PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
VALUES(23, 'POS', 'Proof of Service Form for MMS(Customer 681)', 'BillDataProvider_GetPOSFormXml', 1)

INSERT INTO PrintingFormDetails(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description)
VALUES(84, 23, 71, 'POS')
*/
UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="POS" pageId="POS.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css">
			<![CDATA[
		
		g {
			font-family: Times New Roman,Courier New;
			font-size: 11pt;
			font-style: Normal;
			font-weight: Normal;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
		g.recipients text
		{
			font-size: 9pt;
		}
		
	    	]]>
		</style>
	</defs>

	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://de0fc855-0a81-4d42-a4c5-b1c029af5874?type=global"></image>

  <g id="Prologue">
    <text x="1.14in" y="3.07in" width="1.14in" height="0.1in" valueSource="POS.1.DATE1" />
    <text x="0.85in" y="3.31in" width="4.20in" height="0.1in" valueSource="POS.1.PATIENT_NAME1" />
  </g>

  <g id="Insurance">
    <text x="1.77in" y="4.57in" width="3.17in" height="0.1in" valueSource="POS.1.INSURANCE_PLAN_NAME1" />
    <text x="1.77in" y="4.73in" width="3.17in" height="0.1in" valueSource="POS.1.INSURANCE_PLAN_STREET1" />
    <text x="1.77in" y="4.89in" width="3.17in" height="0.1in" valueSource="POS.1.INSURANCE_PLAN_CITYSTATEZIP1" />
  
    <text x="5.04in" y="4.57in" width="3.17in" height="0.1in" valueSource="POS.1.INSURANCE_PLAN_NAME2" />
    <text x="5.04in" y="4.73in" width="3.17in" height="0.1in" valueSource="POS.1.INSURANCE_PLAN_STREET2" />
    <text x="5.04in" y="4.89in" width="3.17in" height="0.1in" valueSource="POS.1.INSURANCE_PLAN_CITYSTATEZIP2" />
  </g>

  <g id="Attorney">
    <text x="1.77in" y="6.14in" width="3.17in" height="0.1in" valueSource="POS.1.ATTORNEY_NAME1" />
    <text x="1.77in" y="6.30in" width="3.17in" height="0.1in" valueSource="POS.1.ATTORNEY_COMPANY1" />
    <text x="1.77in" y="6.46in" width="3.17in" height="0.1in" valueSource="POS.1.ATTORNEY_STREET1" />
    <text x="1.77in" y="6.62in" width="3.17in" height="0.1in" valueSource="POS.1.ATTORNEY_CITYSTATEZIP1" />
  </g>

</svg>'
WHERE PrintingFormDetailsID = 84