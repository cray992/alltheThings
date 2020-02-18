UPDATE PrintingFormDetails
SET SVGDefinition = 
'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="NOR" pageId="NOR.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css"><![CDATA[
		
		g {
			font-family: Times New Roman,Courier New;
			font-size: 11pt;
			font-style: normal;
			font-weight: normal;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
	    	]]></style>
	</defs>

	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://2640f315-ed61-4021-aaed-32a7ca37aa83"></image>
	
	<!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="./NOR.1.jpg"></image>
	-->
	
	<g id="billingTop">
		<text x="0.72in" 	y="0.52in" width="4.90in" height="0.1in" valueSource="NOR.1.BILLINGCO_NAME1" />
		<text x="0.72in" 	y="0.71in" width="4.90in" height="0.1in" valueSource="NOR.1.BILLINGCO_STREET1" />
		<text x="0.72in" 	y="0.89in" width="4.90in" height="0.1in" valueSource="NOR.1.BILLINGCO_CITYSTATEZIP1" />
		
		<text x="0.72in" 	y="1.32in" width="0.90in" height="0.1in" valueSource="NOR.1.DATE1" />
	</g>
	
	<g id="toLines">
		<text x="1.75in" 	y="1.95in" width="2.93in" height="0.1in" valueSource="NOR.1.INSPLAN_NAME1" />
		<text x="1.75in" 	y="2.11in" width="2.93in" height="0.1in" valueSource="NOR.1.INSPLAN_ADDRESS1" />
		<text x="1.75in" 	y="2.29in" width="2.93in" height="0.1in" valueSource="NOR.1.INSPLAN_CITYSTATEZIP1" />

		<text x="1.75in" 	y="2.62in" width="2.93in" height="0.1in" valueSource="NOR.1.INSPLAN_ADJUST_NAME1" />

		<text x="1.75in" 	y="2.97in" width="2.93in" height="0.1in" valueSource="NOR.1.PATIENT_NAME1" />
		<text x="1.75in" 	y="3.15in" width="2.93in" height="0.1in" valueSource="NOR.1.CLAIMNO_LIST1" />
		<text x="1.75in" 	y="3.33in" width="2.93in" height="0.1in" valueSource="NOR.1.EMP_NAME1" />
		<text x="1.75in" 	y="3.51in" width="1.58in" height="0.1in" valueSource="NOR.1.PAT_SSN1" />
	</g>
	
	<g id="letterTop">
		<text x="2.32in" 	y="4.38in" width="3.33in" height="0.1in" valueSource="NOR.1.BILLINGCO_NAME1" />
		<text x="0.77in" 	y="4.54in" width="4.90in" height="0.1in" valueSource="NOR.1.PRACTICE_NAME1" />
	</g>
	
	<g id="directions">
		<text x="1.25in" 	y="5.14in" width="4.90in" height="0.1in" valueSource="NOR.1.BILLINGCO_NAME1" />
		<text x="1.25in" 	y="5.33in" width="4.90in" height="0.1in" valueSource="NOR.1.BILLINGCO_STREET1" />
		<text x="1.25in" 	y="5.51in" width="4.90in" height="0.1in" valueSource="NOR.1.BILLINGCO_CITYSTATEZIP1" />
		<text x="1.90in" 	y="5.78in" width="1.33in" height="0.1in" valueSource="NOR.1.BILLINGCO_PHONE1" />
		<text x="3.76in" 	y="5.78in" width="1.33in" height="0.1in" valueSource="NOR.1.BILLINGCO_FAX1" />
	</g>
</svg>'
WHERE Description = 'NOR'
