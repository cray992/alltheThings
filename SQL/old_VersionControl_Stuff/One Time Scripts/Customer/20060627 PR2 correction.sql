UPDATE PrintingFormDetails
SET SVGDefinition = 
'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="PR2" pageId="PR2.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
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

	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://f47353d0-8a86-4f58-a3ac-3395c1b98aec?type=global"></image>
	
	<!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="PR2.1.jpg"></image>
	-->
	

	<g id="patient">
		<g id="patient1">
			<text x="1.19in" 	y="2.60in" width="2.47in" height="0.1in" valueSource="PR2.1.LAST_NAME1" />
			<text x="3.99in" 	y="2.60in" width="1.68in" height="0.1in" valueSource="PR2.1.FIRST_NAME1" />
			<text x="5.99in" 	y="2.60in" width="0.09in" height="0.1in" valueSource="PR2.1.MIDDLE_INITIAL1" />
			<text x="6.52in" 	y="2.60in" width="0.09in" height="0.1in" valueSource="PR2.1.GENDER1" />
		</g>
		<g id="patient2">
			<text x="1.38in" 	y="2.81in" width="2.10in" height="0.1in" valueSource="PR2.1.ADDRESS1" />
			<text x="3.75in" 	y="2.81in" width="1.42in" height="0.1in" valueSource="PR2.1.CITY1" />
			<text x="5.53in" 	y="2.81in" width="0.30in" height="0.1in" valueSource="PR2.1.STATE1" />
			<text x="6.04in" 	y="2.81in" width="0.70in" height="0.1in" valueSource="PR2.1.ZIP1" />
		</g>
		<g id="patient3">
			<text x="1.70in" 	y="3.03in" width="1.10in" height="0.1in" valueSource="PR2.1.DOI1" />
			<text x="3.70in" 	y="3.03in" width="1.10in" height="0.1in" valueSource="PR2.1.DOB1" />
		</g>
		<g id="patient4">

			<text x="3.83in" 	y="3.25in" width="0.45in" height="0.1in" valueSource="PR2.1.SSN11" />
			<text x="4.27in" 	y="3.25in" width="0.45in" height="0.1in" valueSource="PR2.1.SSN21" />
			<text x="4.67in" 	y="3.25in" width="0.45in" height="0.1in" valueSource="PR2.1.SSN31" />
			<text x="5.62in" 	y="3.25in" width="0.45in" height="0.1in" valueSource="PR2.1.AREACODE1" />
			<text x="5.97in" 	y="3.25in" width="1.00in" height="0.1in" valueSource="PR2.1.PHONE1" />
		</g>
	</g>

	<g id="claim">
		<g id="claim1">
			<text x="1.27in" 	y="3.67in" width="2.9in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_NAME1" />
			<text x="5.0in" 	y="3.67in" width="1.75in" height="0.1in" valueSource="PR2.1.CLAIM_NUMBER1" />
		</g>
		<g id="claim2">
			<text x="1.38in" 	y="3.88in" width="2.20in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_ADDRESS1" />
			<text x="3.95in" 	y="3.88in" width="1.32in" height="0.1in" valueSource="PR2.1.CLAIM_CITY1" />
			<text x="5.53in" 	y="3.88in" width="0.30in" height="0.1in" valueSource="PR2.1.CLAIM_STATE1" />
			<text x="6.07in" 	y="3.88in" width="0.70in" height="0.1in" valueSource="PR2.1.CLAIM_ZIP1" />
		</g>
		<g id="claim3">
			<text x="1.33in" 	y="4.1in" width="0.45in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_AREACODE1" />
			<text x="1.68in" 	y="4.1in" width="1.00in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_PHONE1" />
			<text x="3.97in" 	y="4.1in" width="0.45in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_FAX_AREACODE1" />
			<text x="4.32in" 	y="4.1in" width="1.00in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_FAX_PHONE1" />
		</g>
	</g>

	<g id="employer">
		<g id="employer1">
			<text x="1.87in" 	y="4.32in" width="2.9in" height="0.1in" valueSource="PR2.1.EMPLOYER_NAME1" />
			<text x="5.8in" 	y="4.32in" width="0.45in" height="0.1in" valueSource="PR2.1.EMPLOYER_AREACODE1" />
			<text x="6.15in" 	y="4.32in" width="1.00in" height="0.1in" valueSource="PR2.1.EMPLOYER_PHONE1" />
		</g>
	</g>

	<g id="administrator">
		<g id="administrator1">
		</g>
		<g id="administrator2">
		</g>
		<g id="administrator3">
		</g>
		<g id="administrator4">
		</g>
	</g>

	<g id="physician">
		<g id="physician1">
			<text x="5.25in" 	y="8.69in" width="1.10in" height="0.1in" valueSource="PR2.1.DATE1" />
		</g>
		<g id="physician2">
			<text x="5.21in" 	y="9.28in" width="2.22in" height="0.1in" valueSource="PR2.1.PROVIDER_STATE_LICENSE1" />
		</g>
		<g id="physician3">
			<text x="1.58in" 	y="9.50in" width="3.10in" height="0.1in" valueSource="PR2.1.SERVICE_LOCATION1" />
			<text x="5.09in" 	y="9.50in" width="1.10in" height="0.1in" valueSource="PR2.1.DATE1" />
		</g>
		<g id="physician4">
			<text x="1.31in" 	y="9.71in" width="3.41in" height="0.1in" valueSource="PR2.1.PROVIDER_NAME1" />
			<text x="5.25in" 	y="9.71in" width="2.22in" height="0.1in" valueSource="PR2.1.PROVIDER_SPECIALTY1" />
		</g>
		<g id="physician5">
			<text x="1.44in" 	y="9.93in" width="2.86in" height="0.3in" valueSource="PR2.1.PROVIDER_STREET1" />
			<text x="4.75in" 	y="9.93in" width="2.22in" height="0.1in" valueSource="PR2.1.PROVIDER_PHONE1" />
		</g>
	</g>

</svg>'
WHERE PrintingFormDetailsID = 8
/*
INSERT INTO PrintingForm
	(PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
VALUES
	(5, 'PR2', 'Primary Treating Physicians Progress', 'AppointmentDataProvider_GetPR2FormXml', 0)

INSERT INTO PrintingFormDetails
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGDefinition, SVGTransform)
VALUES
	(8, 5, 1, 'PR2', '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="PR2" pageId="PR2.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
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

	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://1e853c31-6ddb-4bbd-9d4f-5cb7aafbbffb"></image>
	
	<!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="PR2.1.jpg"></image>
	-->
	

	<g id="patient">
		<g id="patient1">
			<text x="1.19in" 	y="2.60in" width="2.47in" height="0.1in" valueSource="PR2.1.LAST_NAME1" />
			<text x="3.99in" 	y="2.60in" width="1.68in" height="0.1in" valueSource="PR2.1.FIRST_NAME1" />
			<text x="5.99in" 	y="2.60in" width="0.09in" height="0.1in" valueSource="PR2.1.MIDDLE_INITIAL1" />
			<text x="6.52in" 	y="2.60in" width="0.09in" height="0.1in" valueSource="PR2.1.GENDER1" />
		</g>
		<g id="patient2">
			<text x="1.38in" 	y="2.81in" width="2.10in" height="0.1in" valueSource="PR2.1.ADDRESS1" />
			<text x="3.75in" 	y="2.81in" width="1.42in" height="0.1in" valueSource="PR2.1.CITY1" />
			<text x="5.53in" 	y="2.81in" width="0.30in" height="0.1in" valueSource="PR2.1.STATE1" />
			<text x="6.04in" 	y="2.81in" width="0.70in" height="0.1in" valueSource="PR2.1.ZIP1" />
		</g>
		<g id="patient3">
			<text x="1.70in" 	y="3.03in" width="1.10in" height="0.1in" valueSource="PR2.1.DOI1" />
			<text x="3.70in" 	y="3.03in" width="1.10in" height="0.1in" valueSource="PR2.1.DOB1" />
		</g>
		<g id="patient4">

			<text x="3.83in" 	y="3.25in" width="0.45in" height="0.1in" valueSource="PR2.1.SSN11" />
			<text x="4.27in" 	y="3.25in" width="0.45in" height="0.1in" valueSource="PR2.1.SSN21" />
			<text x="4.67in" 	y="3.25in" width="0.45in" height="0.1in" valueSource="PR2.1.SSN31" />
			<text x="5.62in" 	y="3.25in" width="0.45in" height="0.1in" valueSource="PR2.1.AREACODE1" />
			<text x="5.97in" 	y="3.25in" width="1.00in" height="0.1in" valueSource="PR2.1.PHONE1" />
		</g>
	</g>

	<g id="claim">
		<g id="claim1">
			<text x="1.27in" 	y="3.67in" width="2.9in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_NAME1" />
			<text x="5.0in" 	y="3.67in" width="1.75in" height="0.1in" valueSource="PR2.1.CLAIM_NUMBER1" />
		</g>
		<g id="claim2">
			<text x="1.38in" 	y="3.88in" width="2.20in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_ADDRESS1" />
			<text x="3.95in" 	y="3.88in" width="1.32in" height="0.1in" valueSource="PR2.1.CLAIM_CITY1" />
			<text x="5.53in" 	y="3.88in" width="0.30in" height="0.1in" valueSource="PR2.1.CLAIM_STATE1" />
			<text x="6.07in" 	y="3.88in" width="0.70in" height="0.1in" valueSource="PR2.1.CLAIM_ZIP1" />
		</g>
		<g id="claim3">
			<text x="1.33in" 	y="4.1in" width="0.45in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_AREACODE1" />
			<text x="1.68in" 	y="4.1in" width="1.00in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_PHONE1" />
			<text x="3.97in" 	y="4.1in" width="0.45in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_FAX_AREACODE1" />
			<text x="4.32in" 	y="4.1in" width="1.00in" height="0.1in" valueSource="PR2.1.CLAIM_ADMINISTRATOR_FAX_PHONE1" />
		</g>
	</g>

	<g id="employer">
		<g id="employer1">
			<text x="1.87in" 	y="4.32in" width="2.9in" height="0.1in" valueSource="PR2.1.EMPLOYER_NAME1" />
			<text x="5.8in" 	y="4.32in" width="0.45in" height="0.1in" valueSource="PR2.1.EMPLOYER_AREACODE1" />
			<text x="6.15in" 	y="4.32in" width="1.00in" height="0.1in" valueSource="PR2.1.EMPLOYER_PHONE1" />
		</g>
	</g>

	<g id="administrator">
		<g id="administrator1">
		</g>
		<g id="administrator2">
		</g>
		<g id="administrator3">
		</g>
		<g id="administrator4">
		</g>
	</g>

	<g id="physician">
		<g id="physician1">
			<text x="5.25in" 	y="8.69in" width="1.10in" height="0.1in" valueSource="PR2.1.DATE1" />
		</g>
		<g id="physician2">
			<text x="5.21in" 	y="9.28in" width="2.22in" height="0.1in" valueSource="PR2.1.PROVIDER_STATE_LICENSE1" />
		</g>
		<g id="physician3">
			<text x="1.58in" 	y="9.50in" width="3.10in" height="0.1in" valueSource="PR2.1.SERVICE_LOCATION1" />
			<text x="5.09in" 	y="9.50in" width="1.10in" height="0.1in" valueSource="PR2.1.DATE1" />
		</g>
		<g id="physician4">
			<text x="1.31in" 	y="9.71in" width="3.41in" height="0.1in" valueSource="PR2.1.PROVIDER_NAME1" />
			<text x="5.25in" 	y="9.71in" width="2.22in" height="0.1in" valueSource="PR2.1.PROVIDER_SPECIALTY1" />
		</g>
		<g id="physician5">
			<text x="1.44in" 	y="9.93in" width="2.86in" height="0.3in" valueSource="PR2.1.PROVIDER_STREET1" />
			<text x="4.75in" 	y="9.93in" width="2.22in" height="0.1in" valueSource="PR2.1.PROVIDER_PHONE1" />
		</g>
	</g>

</svg>', 0)
*/
