/*
-----------------------------------------------------------------------------------------------------
POS Printing Form Details
-----------------------------------------------------------------------------------------------------
*/

if not exists(select printingformid from printingform where printingformid = 6)
begin
	INSERT INTO PrintingForm(PrintingFormID, Name, Description, StoredProcedureName, RecipientSpecific)
	VALUES(6, 'POS', 'Proof of Service', 'BillDataProvider_GetPOSFormXml', 1)
end

if not exists(select printingformdetailsid from printingformdetails where printingformdetailsid = 9)
begin
	INSERT INTO PrintingFormDetails(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description)
	VALUES(9, 6, 1, 'POS')
end

-- Customer 108 has their own background image so it's a different svg definition
IF charindex('_0108_', db_name()) = 0
BEGIN
	UPDATE PrintingFormDetails
	SET SVGDefinition = '<?xml version="1.0" standalone="yes"?>
	<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="POS" pageId="POS.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
		<defs>
			<style type="text/css"><![CDATA[        g {     font-family: Times New Roman,Courier New;     font-size: 11pt;     font-style: Normal;     font-weight: Normal;     alignment-baseline: text-before-edge;    }        text    {     baseline-shift: -100%;    }        g.recipients text    {     font-size: 9pt;    }            ]]></style>
		</defs>
		<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://03c9782d-44a6-44f5-bb65-f494d4a175be?type=global"></image>
		<!--   <image x="0" y="0" width="8.5in" height="11in" xlink:href="./POS.1.jpg"></image>   -->
		<g id="prologue">
			<text x="0.72in"  y="1.62in" width="7.90in" height="0.1in" valueSource="POS.1.ADDRESS1" />
			<text x="1.01in"  y="1.97in" width="1.3in" height="0.1in" valueSource="POS.1.DATE1" />
			<text x="0.72in"  y="2.32in" width="7.90in" height="0.1in" valueSource="POS.1.PRACTICE_NAME1" />
			<text x="1.66in"  y="2.77in" width="2.68in" height="0.1in" valueSource="POS.1.CITYSTATE1" />
		</g>
		<g id="checkboxes">
			<text x="0.87in" y="3.26in" width="0.09in" height="0.1in" valueSource="POS.1.INCLUDE_EVALUATIONREPORT1" />
			<text x="6.37in"  y="3.26in" width="1.3in" height="0.1in" valueSource="POS.1.DOS1" />
			<text x="0.87in"  y="3.44in" width="0.09in" height="0.1in" valueSource="POS.1.INCLUDE_IOC1" />
			<text x="2.89in"  y="3.43in" width="1.3in" height="0.1in" valueSource="POS.1.TOTAL_CHARGE1" />
			<text x="0.87in"  y="4.08in" width="0.09in" height="0.1in" valueSource="POS.1.INCLUDE_NOR1" />
			<text x="4.65in" y="4.08in" width="2.3in" height="0.1in"  valueSource="POS.1.DATE1" />
		</g>
		<g class="recipients">
			<g id="recepient1">
				<text x="0.87in"  y="5.29in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME1" />
				<text x="0.87in"  y="5.45in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET1" />
				<text x="0.87in"  y="5.61in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP1" />
			</g>
			<g id="recepient2">
				<text x="0.87in"  y="5.99in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME2" />
				<text x="0.87in"  y="6.15in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET2" />
				<text x="0.87in"  y="6.30in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP2" />
			</g>
			<g id="recepient3">
				<text x="0.87in"  y="6.66in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME3" />
				<text x="0.87in"  y="6.81in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET3" />
				<text x="0.87in"  y="6.97in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP3" />
			</g>
			<g id="recepient4">
				<text x="4.71in"  y="5.29in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME4" />
				<text x="4.71in"  y="5.45in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET4" />
				<text x="4.71in"  y="5.61in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP4" />
			</g>
			<g id="recepient5">
				<text x="4.71in"  y="5.99in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME5" />
				<text x="4.71in"  y="6.15in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET5" />
				<text x="4.71in"  y="6.30in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP5" />
			</g>
			<g id="recepient6">
				<text x="4.71in"  y="6.66in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME6" />
				<text x="4.71in"  y="6.81in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET6" />
				<text x="4.71in"  y="6.97in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP6" />
			</g>
		</g>
		<g id="epilogue">
			<text x="1.75in"  y="8.67in" width="4.90in" height="0.1in" valueSource="POS.1.DATE1" />
			<text x="1.75in"  y="9.16in" width="4.90in" height="0.1in" valueSource="POS.1.PATIENT_NAME1" />
			<text x="1.75in"  y="9.32in" width="4.90in" height="0.1in" valueSource="POS.1.EMP_NAME1" />
			<text x="1.75in"  y="9.48in" width="4.90in" height="0.1in" valueSource="POS.1.DOI_LIST1" />
			<text x="1.75in"  y="9.63in" width="4.90in" height="0.1in" valueSource="POS.1.CLAIMNO_LIST1" />
			<text x="1.75in"  y="9.80in" width="4.90in" height="0.1in" valueSource="POS.1.WCAB_NO_LIST1" />
		</g>
	</svg>'
	WHERE PrintingFormDetailsID = 9
END