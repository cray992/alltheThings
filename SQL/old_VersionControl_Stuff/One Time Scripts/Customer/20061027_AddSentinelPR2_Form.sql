/*
-----------------------------------------------------------------------------------------------------
CASE 15025 - Implement Sentinel PR2 Form
-----------------------------------------------------------------------------------------------------
*/
/*
INSERT INTO PrintingForm (PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
VALUES (17, 'Sentinel PR2', 'Primary Treating Physicians Progress', 'AppointmentDataProvider_GetSentinelPR2FormXml', 0)

INSERT INTO PrintingFormDetails (PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES (71, 17, 58, 'Sentinel PR2 (Three Page) - Page 1', 0)

INSERT INTO PrintingFormDetails (PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES (72, 17, 59, 'Sentinel PR2 (Three Page) - Page 2', 0)

INSERT INTO PrintingFormDetails (PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES (73, 17, 60, 'Sentinel PR2 (Three Page) - Page 3', 0)
*/
UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="SentinelPR2" pageId="SentinelPR2.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css">
			<![CDATA[
		
		g {
			font-family: Times New Roman,Courier New;
			font-size: 10pt;
			font-style: Normal;
			font-weight: Normal;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
	    	]]>
		</style>
	</defs>

  <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://aabb4ad9-60b9-4097-b49d-bf83cd98f9f6?type=global"></image>

  <!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="Sentinel.PR2.1.jpg"></image>
  -->
  
  <g id="header">
    <text x="0.50in" y="0.50in" width="3.10in" height="0.1in" valueSource="SentinelPR2.1.SERVICE_LOCATION1" />
    <text x="0.95in" y="0.69in" width="1.90in" height="0.1in" valueSource="SentinelPR2.1.PROVIDER_PHONE1" />
  </g>

	<g id="patient">
		<text x="0.86in" y="2.42in" width="1.66in" height="0.1in" valueSource="SentinelPR2.1.LAST_NAME1" />
		<text x="2.89in" y="2.42in" width="1.65in" height="0.1in" valueSource="SentinelPR2.1.FIRST_NAME1" />
		<text x="4.80in" y="2.42in" width="0.09in" height="0.1in" valueSource="SentinelPR2.1.MIDDLE_INITIAL1" />
		<text x="6.35in" y="2.42in" width="0.09in" height="0.1in" valueSource="SentinelPR2.1.GENDER1" />
		<text x="1.08in" y="2.58in" width="1.42in" height="0.1in" valueSource="SentinelPR2.1.ADDRESS1" />
		<text x="2.84in" y="2.58in" width="1.52in" height="0.1in" valueSource="SentinelPR2.1.CITY1" />
		<text x="4.79in" y="2.58in" width="0.30in" height="0.1in" valueSource="SentinelPR2.1.STATE1" />
		<text x="6.86in" y="2.58in" width="0.70in" height="0.1in" valueSource="SentinelPR2.1.ZIP1" />
		<text x="1.43in" y="2.75in" width="2.10in" height="0.1in" valueSource="SentinelPR2.1.DOI1" />
		<text x="1.40in" y="2.92in" width="1.10in" height="0.1in" valueSource="SentinelPR2.1.DOB1" />
		<text x="2.80in" y="2.92in" width="1.10in" height="0.1in" valueSource="SentinelPR2.1.SSN1" />
		<text x="4.47in" y="2.92in" width="1.20in" height="0.1in" valueSource="SentinelPR2.1.PHONE1" />
	</g>

	<g id="claim">
    <text x="1.55in" y="3.24in" width="4.40in" height="0.1in" valueSource="SentinelPR2.1.CLAIM_NAME1" />
		<text x="0.94in" y="3.41in" width="3.0in" height="0.1in" valueSource="SentinelPR2.1.CLAIM_ADMINISTRATOR_NAME1" />
		<text x="5.0in" y="3.41in" width="2.75in" height="0.1in" valueSource="SentinelPR2.1.CLAIM_NUMBER1" />
		<text x="1.09in" y="3.57in" width="4.20in" height="0.1in" valueSource="SentinelPR2.1.CLAIM_ADMINISTRATOR_ADDRESS1" />
		<text x="0.96in" y="3.74in" width="1.90in" height="0.1in" valueSource="SentinelPR2.1.CLAIM_ADMINISTRATOR_PHONE1" />
		<text x="4.33in" y="3.74in" width="1.90in" height="0.1in" valueSource="SentinelPR2.1.CLAIM_ADMINISTRATOR_FAX_PHONE1" />
	</g>

	<g id="employer">
		<text x="1.56in" y="3.90in" width="2.01in" height="0.1in" valueSource="SentinelPR2.1.EMPLOYER_NAME1" />
		<text x="4.60in" y="3.90in" width="1.90in" height="0.1in" valueSource="SentinelPR2.1.EMPLOYER_PHONE1" />
	</g>

</svg>'
WHERE PrintingFormDetailsID = 71

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="SentinelPR2" pageId="SentinelPR2.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css">
			<![CDATA[
		
		g {
			font-family: Times New Roman,Courier New;
			font-size: 10pt;
			font-style: Normal;
			font-weight: Normal;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
	    	]]>
		</style>
	</defs>

	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://1d6afa5b-df38-4bb0-a2fb-cb4048cec4de?type=global"></image>

  <!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="Sentinel.PR2.2.jpg"></image>
  -->
  
  <g id="header">
    <text x="0.50in" y="0.66in" width="3.10in" height="0.1in" valueSource="SentinelPR2.1.SERVICE_LOCATION1" />
    <text x="0.95in" y="0.85in" width="1.90in" height="0.1in" valueSource="SentinelPR2.1.PROVIDER_PHONE1" />
  </g>

	<g id="physician">
		<text x="4.79in" y="8.65in" width="1.10in" height="0.1in" valueSource="SentinelPR2.1.DATE1" />
		<text x="5.39in" y="9.09in" width="2.23in" height="0.1in" valueSource="SentinelPR2.1.PROVIDER_STATE_LICENSE1" />
		<text x="1.23in" y="9.25in" width="4.12in" height="0.1in" valueSource="SentinelPR2.1.SERVICE_LOCATION1" />
		<text x="5.70in" y="9.25in" width="1.10in" height="0.1in" valueSource="SentinelPR2.1.DATE1" />
		<text x="0.91in" y="9.40in" width="3.41in" height="0.1in" valueSource="SentinelPR2.1.PROVIDER_NAME1" />
		<text x="1.04in" y="9.55in" width="4.32in" height="0.1in" valueSource="SentinelPR2.1.PROVIDER_ADDRESS1" />
	</g>

</svg>'
WHERE PrintingFormDetailsID = 72

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="SentinelPR2" pageId="SentinelPR2.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css">
			<![CDATA[
		
		g {
			font-family: Times New Roman,Courier New;
			font-size: 10pt;
			font-style: Normal;
			font-weight: Normal;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
	    	]]>
		</style>
	</defs>

  <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://47e1e4ef-c7e0-44f7-b30f-0600c34cc995?type=global"></image>

  <!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="Sentinel.PR2.3.jpg"></image>
  -->
  
  <g id="header">
    <text x="0.50in" y="1.10in" width="3.10in" height="0.1in" valueSource="SentinelPR2.1.SERVICE_LOCATION1" />
    <text x="0.95in" y="1.29in" width="1.90in" height="0.1in" valueSource="SentinelPR2.1.PROVIDER_PHONE1" />
  </g>

	<g id="patient">
		<text x="0.86in" y="2.14in" width="1.66in" height="0.1in" valueSource="SentinelPR2.1.LAST_NAME1" />
		<text x="2.89in" y="2.14in" width="1.65in" height="0.1in" valueSource="SentinelPR2.1.FIRST_NAME1" />
		<text x="4.80in" y="2.14in" width="0.09in" height="0.1in" valueSource="SentinelPR2.1.MIDDLE_INITIAL1" />
		<text x="6.35in" y="2.14in" width="0.09in" height="0.1in" valueSource="SentinelPR2.1.GENDER1" />
		<text x="1.08in" y="2.30in" width="1.42in" height="0.1in" valueSource="SentinelPR2.1.ADDRESS1" />
		<text x="2.84in" y="2.30in" width="1.52in" height="0.1in" valueSource="SentinelPR2.1.CITY1" />
		<text x="4.79in" y="2.30in" width="0.30in" height="0.1in" valueSource="SentinelPR2.1.STATE1" />
		<text x="6.86in" y="2.30in" width="0.90in" height="0.1in" valueSource="SentinelPR2.1.ZIP1" />
		<text x="1.43in" y="2.46in" width="2.10in" height="0.1in" valueSource="SentinelPR2.1.DOI1" />
		<text x="1.40in" y="2.63in" width="1.10in" height="0.1in" valueSource="SentinelPR2.1.DOB1" />
		<text x="2.80in" y="2.63in" width="1.10in" height="0.1in" valueSource="SentinelPR2.1.SSN1" />
		<text x="4.47in" y="2.63in" width="1.50in" height="0.1in" valueSource="SentinelPR2.1.PHONE1" />
	</g>

</svg>'
WHERE PrintingFormDetailsID = 73