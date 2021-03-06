--------------------------------------------------------------------------------------
-- Add the Narrative Report to the DocumentLabelType
--------------------------------------------------------------------------------------

DECLARE @DocumentLabelTypeID INT
SELECT	@DocumentLabelTypeID = DocumentLabelTypeID
FROM	DocumentLabelType
WHERE	Name = 'Narrative Report'

IF @DocumentLabelTypeID IS NULL
BEGIN
	-- Update the sort order for all greater than equal to 5
	UPDATE 	DocumentLabelType
	SET	SortOrder = SortOrder + 1
	WHERE	SortOrder >= 5

	-- Insert new Narrative Report
	INSERT INTO DocumentLabelType
	VALUES(	14,
		'Narrative Report',
		'Narrative Report',
		5)
END

--------------------------------------------------------------------------------------
-- Insert a new Printing Form for the HCFA with Background form
--------------------------------------------------------------------------------------
DELETE FROM PrintingFormDetails WHERE PrintingFormDetailsID = 16
DELETE FROM PrintingForm WHERE PrintingFormID = 11

INSERT INTO PrintingForm(
	PrintingFormID,
	Name,
	Description,
	StoredProcedureName,
	RecipientSpecific)
VALUES(	11,
	'CMS1500 (with background)',
	'CMS 1500 Form',
	'BillDataProvider_GetHCFADocumentDataWithBackground',
	0)

-- Insert printing form details SVG for HCFA with no Background form
INSERT INTO PrintingFormDetails(
	PrintingFormDetailsID,
	PrintingFormID,
	SVGDefinitionID,
	Description,
	SVGDefinition,
	SVGTransform)
VALUES(	16,
	11,
	1,
	'HCFA with Background',
	'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="CMS1500" pageId="CMS1500.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css"><![CDATA[
		
		g {
			font-family: Courier New;
			font-size: 10pt;
			font-style: normal;
			font-weight: bold;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
		text.money
		{
			text-anchor: end;
		}

		text.smaller
		{
			font-size: 9pt;
		}
				
		
	    	]]></style>
	</defs>

	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://98291fd6-8a70-41ad-8469-65c4ee8ee8d4?type=global"></image>
	
	<!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="./CMS1500.1.jpg"></image>
	-->
	
	<g id="carrier">
		<text x="4.44in" y="0.43in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierName" />
		<text x="4.44in" y="0.59in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierStreet" />
		<text x="4.44in" y="0.75in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierCityStateZip" />
	</g>
	
	<g id="line1">
		<text x="0.37in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Medicare" />
		<text x="1.06in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Medicaid" />
		<text x="1.77in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Champus" />
		<text x="2.65in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Champva" />
		<text x="3.34in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_GroupHealthPlan" />
		<text x="4.15in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Feca" />
		<text x="4.76in" 	y="1.41in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Other" />

		<text x="5.25in" 	y="1.40in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_aIDNumber" />
	</g>
	
	<g id="line2">
		<text x="0.37in" 	y="1.73in" width="2.79in" height="0.1in" valueSource="CMS1500.1.2_PatientName" />
		
		<text x="3.33in" 	y="1.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_MM" />
		<text x="3.64in" 	y="1.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_DD" />
		<text x="3.92in" 	y="1.74in" width="0.6in" height="0.1in" valueSource="CMS1500.1.3_YY" />
		<text x="4.45in" 	y="1.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.3_M" />
		<text x="4.96in" 	y="1.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.3_F" />
		
		<text x="5.25in" 	y="1.74in" width="2.93in" height="0.1in" valueSource="CMS1500.1.4_InsuredName" />
	</g>
	
	<g id="line3">
		<text x="0.37in" 	y="2.06in" width="2.79in" height="0.1in" valueSource="CMS1500.1.5_PatientAddress" />
		
		<text x="3.54in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Self" />
		<text x="4.05in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Spouse" />
		<text x="4.45in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Child" />
		<text x="4.96in" 	y="2.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Other" />
		
		<text x="5.25in" 	y="2.06in" width="2.93in" height="0.1in" valueSource="CMS1500.1.7_InsuredAddress" />
	</g>
	
	<g id="line4">
		<text x="0.37in" 	y="2.40in" width="2.42in" height="0.1in" valueSource="CMS1500.1.5_City" />
		<text x="2.90in" 	y="2.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.5_State" />

		<text x="5.25in" 	y="2.40in" width="2.28in" height="0.1in" valueSource="CMS1500.1.7_City" />
		<text x="7.6in" 	y="2.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.7_State" />
	</g>
	
	<g id="box8">
		<text x="3.75in" 	y="2.4in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Single" />
		<text x="4.34in" 	y="2.4in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Married" />
		<text x="4.95in" 	y="2.4in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Other" />
		<text x="3.75in" 	y="2.7in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Employed" />
		<text x="4.34in" 	y="2.7in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_FTStud" />
		<text x="4.95in" 	y="2.7in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_PTStud" />
	</g>
	
	<g id="line5">
		<text x="0.37in" 	y="2.72in" width="1.19in" height="0.1in" valueSource="CMS1500.1.5_Zip" />
		<text x="1.75in" 	y="2.72in" width="0.4in" height="0.1in" valueSource="CMS1500.1.5_Area" />
		<text x="2.14in" 	y="2.72in" width="1.1in" height="0.1in" valueSource="CMS1500.1.5_Phone" />

		<text x="5.25in" 	y="2.72in" width="1.23in" height="0.1in" valueSource="CMS1500.1.7_Zip" />
		<text x="6.73in" 	y="2.72in" width="0.4in" height="0.1in" valueSource="CMS1500.1.7_Area" />
		<text x="7.16in" 	y="2.72in" width="1.1in" height="0.1in" valueSource="CMS1500.1.7_Phone" />
	</g>
	
	<g id="line6">
		<text x="0.37in" 	y="3.05in" width="2.42in" height="0.1in" valueSource="CMS1500.1.9_OtherName" />

		<text x="5.25in" 	y="3.05in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1GroupNumber" />
	</g>

	<g id="box10">
		<text x="3.75in" 	y="3.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0aYes" />
		<text x="4.35in" 	y="3.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0aNo" />

		<text x="3.75in" 	y="3.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0bYes" />
		<text x="4.35in" 	y="3.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0bNo" />
		<text x="4.81in" 	y="3.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_0bState" />

		<text x="3.75in" 	y="4.05in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0cYes" />
		<text x="4.35in" 	y="4.05in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0cNo" />
	</g>
	
	<g id="line7">
		<text x="0.37in" 	y="3.40in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_aGrpNumber" />
	
		<text x="5.63in" 	y="3.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aMM" />
		<text x="5.94in" 	y="3.40in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aDD" />
		<text x="6.23in" 	y="3.40in" width="0.6in" height="0.1in" valueSource="CMS1500.1.1_1aYY" />
		<text x="7.04in" 	y="3.40in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1aM" />
		<text x="7.76in" 	y="3.40in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1aF" />
	</g>
	
	<g id="line8">
		<text x="0.45in" 	y="3.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bMM" />
		<text x="0.75in" 	y="3.74in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bDD" />
		<text x="1.04in" 	y="3.74in" width="0.6in" height="0.1in" valueSource="CMS1500.1.9_bYYYY" />
		<text x="2.05in" 	y="3.74in"  width="0.09in" height="0.1in" valueSource="CMS1500.1.9_bM" />
		<text x="2.65in" 	y="3.74in" width="0.09in" height="0.1in" valueSource="CMS1500.1.9_bF" />
	
		<text x="5.25in" 	y="3.74in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1bEmployer" />
	</g>
	
	<g id="line9">
		<text x="0.37in" 	y="4.05in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_cEmployer" />
	
		<text x="5.25in" 	y="4.05in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1cPlanName" />
	</g>
	
	<g id="line10">
		<text x="0.37in" 	y="4.39in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_dPlanName" />

		<text x="3.24in" 	y="4.39in" width="1.85in" height="0.1in" valueSource="CMS1500.1.1_0dLocal" />
	
		<text x="5.44in" 	y="4.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1dYes" />
		<text x="5.94in" 	y="4.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1dNo" />
	</g>
	
	<g id="line11">
		<text x="0.85in" 	y="5.05in"    width="2.2in"  height="0.1in" valueSource="CMS1500.1.1_2Signature" />
		<text x="3.85in" 	y="5.05in"    width="1.3in"  height="0.1in" valueSource="CMS1500.1.1_2Date" />

		<text x="5.9in" 	y="5.05in"    width="2in"    height="0.1in" valueSource="CMS1500.1.1_3Signature" />
	</g>
	
	<g id="line12">
		<text x="0.47in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4MM" />
		<text x="0.78in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4DD" />
		<text x="1.08in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4YY" />

		<text x="3.98in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5MM" />
		<text x="4.29in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5DD" />
		<text x="4.56in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5YY" />

		<text x="5.64in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartMM" />
		<text x="5.93in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartDD" />
		<text x="6.24in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartYY" />

		<text x="7.05in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndMM" />
		<text x="7.37in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndDD" />
		<text x="7.66in" 	y="5.41in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndYY" />
	
	</g>
	
	<g id="line13">
		<text x="0.37in" 	y="5.72in" width="2.61in" height="0.1in" valueSource="CMS1500.1.1_7Referring" />

		<text x="3.23in" 	y="5.72in" width="1.92in" height="0.1in" valueSource="CMS1500.1.1_7aID" />

		<text x="5.64in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartMM" />
		<text x="5.93in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartDD" />
		<text x="6.25in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartYY" />

		<text x="7.05in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndMM" />
		<text x="7.37in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndDD" />
		<text x="7.66in" 	y="5.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndYY" />
	</g>
	
	<g id="line14">
		<text x="0.37in" 	y="6.06in" width="4.78in" height="0.1in" valueSource="CMS1500.1.1_9Local" />
		
		<text x="5.43in" 	y="6.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.2_0Yes" />
		<text x="5.94in" 	y="6.06in" width="0.09in" height="0.1in" valueSource="CMS1500.1.2_0No" />
		
		<text x="6.61in" 	y="6.06in" width="0.8in" height="0.1in" valueSource="CMS1500.1.2_0Dollars" class="money" />
		<text x="7.38in" 	y="6.06in" width="0.3in" height="0.1in" valueSource="CMS1500.1.2_0Cents" />
	</g>
	
	<g id="box21">
		<text x="0.55in" 	y="6.45in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag1" />
		<text x="0.55in" 	y="6.76in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag2" />
		<text x="3.29in" 	y="6.45in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag3" />
		<text x="3.29in" 	y="6.76in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag4" />
	</g>
	
	<g id="line15">
		<text x="5.25in" 	y="6.4in" width="1.1in"  height="0.1in" valueSource="CMS1500.1.2_2Code" />
		<text x="6.37in" 	y="6.4in" width="1.86in" height="0.1in" valueSource="CMS1500.1.2_2Number" />
	</g>
	
	<g id="line16">
		<text x="5.25in" 	y="6.71in" width="2.93in" height="0.1in" valueSource="CMS1500.1.2_3PriorAuth" />
	</g>
	
	<g id="box24_1">
		<text x="0.37in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM1" />
		<text x="0.68in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD1" />
		<text x="1.00in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY1" />
		<text x="1.26in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM1" />
		<text x="1.56in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD1" />
		<text x="1.88in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY1" />
		<text x="2.17in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS1" />
		<text x="2.44in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS1" />
		<text x="2.8in" 	y="7.36in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT1" />
		<text x="3.46in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier1" />
		<text x="3.77in" 	y="7.36in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra1" />
		<text x="4.5in" 	y="7.36in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag1" />
		<text x="5.23in" 	y="7.36in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars1" class="money" />
		<text x="5.83in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents1" />
		<text x="6.13in" 	y="7.36in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits1" />
		<text x="6.47in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT1" />
		<text x="6.75in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG1" />
		<text x="7.05in" 	y="7.36in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB1" />
		<text x="7.33in" 	y="7.36in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal1" class="smaller" />
	</g>
	<g id="box24_2">
		<text x="0.37in" 	y="7.66in" width="0.3in"  height="0.11in" valueSource="CMS1500.1.aStartMM2" />
		<text x="0.68in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartDD2" />
		<text x="1.00in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartYY2" />
		<text x="1.26in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndMM2" />
		<text x="1.56in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndDD2" />
		<text x="1.88in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndYY2" />
		<text x="2.17in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.bPOS2" />
		<text x="2.44in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.cTOS2" />
		<text x="2.8in"  	y="7.66in" width="0.7in"  height="0.1in" valueSource="CMS1500.1.dCPT2" />
		<text x="3.46in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.dModifier2" />
		<text x="3.77in" 	y="7.66in" width="0.6in"  height="0.1in" valueSource="CMS1500.1.dExtra2" />
		<text x="4.5in"  	y="7.66in" width="0.7in"  height="0.1in" valueSource="CMS1500.1.eDiag2" />
		<text x="5.23in" 	y="7.66in" width="0.55in"  height="0.1in" valueSource="CMS1500.1.fDollars2" class="money" />
		<text x="5.83in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.fCents2" />
		<text x="6.13in" 	y="7.66in" width="0.33in"  height="0.1in" valueSource="CMS1500.1.gUnits2" />
		<text x="6.47in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.hEPSDT2" />
		<text x="6.75in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.iEMG2" />
		<text x="7.05in" 	y="7.66in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.jCOB2" />
		<text x="7.33in" 	y="7.66in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal2" class="smaller" />
	</g>
	<g id="box24_3">
		<text x="0.37in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartMM3" />
		<text x="0.68in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartDD3" />
		<text x="1.00in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartYY3" />
		<text x="1.26in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndMM3" />
		<text x="1.56in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndDD3" />
		<text x="1.88in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndYY3" />
		<text x="2.17in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.bPOS3" />
		<text x="2.44in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.cTOS3" />
		<text x="2.8in"  	y="8.00in" width="0.7in"  height="0.1in" valueSource="CMS1500.1.dCPT3" />
		<text x="3.46in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.dModifier3" />
		<text x="3.77in" 	y="8.00in" width="0.6in"  height="0.1in" valueSource="CMS1500.1.dExtra3" />
		<text x="4.5in"  	y="8.00in" width="0.7in"  height="0.1in" valueSource="CMS1500.1.eDiag3" />
		<text x="5.23in" 	y="8.00in" width="0.55in"  height="0.1in" valueSource="CMS1500.1.fDollars3" class="money" />
		<text x="5.83in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.fCents3" />
		<text x="6.13in" 	y="8.00in" width="0.33in"  height="0.1in" valueSource="CMS1500.1.gUnits3" />
		<text x="6.47in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.hEPSDT3" />
		<text x="6.75in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.iEMG3" />
		<text x="7.05in" 	y="8.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.jCOB3" />
		<text x="7.33in" 	y="8.00in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal3" class="smaller" />
	</g>
	<g id="box24_4">
		<text x="0.37in" 	y="8.33in" width="0.3in"  height="0.11in" valueSource="CMS1500.1.aStartMM4" />
		<text x="0.68in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartDD4" />
		<text x="1.00in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartYY4" />
		<text x="1.26in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndMM4" />
		<text x="1.56in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndDD4" />
		<text x="1.88in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndYY4" />
		<text x="2.17in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.bPOS4" />
		<text x="2.44in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.cTOS4" />
		<text x="2.8in"  	y="8.33in" width="0.7in"  height="0.1in" valueSource="CMS1500.1.dCPT4" />
		<text x="3.46in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.dModifier4" />
		<text x="3.77in" 	y="8.33in" width="0.6in"  height="0.1in" valueSource="CMS1500.1.dExtra4" />
		<text x="4.5in"  	y="8.33in" width="0.7in"  height="0.1in" valueSource="CMS1500.1.eDiag4" />
		<text x="5.23in" 	y="8.33in" width="0.55in"  height="0.1in" valueSource="CMS1500.1.fDollars4" class="money" />
		<text x="5.83in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.fCents4" />
		<text x="6.13in" 	y="8.33in" width="0.33in"  height="0.1in" valueSource="CMS1500.1.gUnits4" />
		<text x="6.47in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.hEPSDT4" />
		<text x="6.75in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.iEMG4" />
		<text x="7.05in" 	y="8.33in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.jCOB4" />
		<text x="7.33in" 	y="8.33in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal4" class="smaller" />
	</g>
	<g id="box24_5">
		<text x="0.37in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartMM5" />
		<text x="0.68in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartDD5" />
		<text x="1.00in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartYY5" />
		<text x="1.26in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndMM5" />
		<text x="1.56in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndDD5" />
		<text x="1.88in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndYY5" />
		<text x="2.17in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.bPOS5" />
		<text x="2.44in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.cTOS5" />
		<text x="2.8in"  	y="8.67in" width="0.7in"  height="0.1in" valueSource="CMS1500.1.dCPT5" />
		<text x="3.46in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.dModifier5" />
		<text x="3.77in" 	y="8.67in" width="0.6in"  height="0.1in" valueSource="CMS1500.1.dExtra5" />
		<text x="4.5in"  	y="8.67in" width="0.7in"  height="0.1in" valueSource="CMS1500.1.eDiag5" />
		<text x="5.23in" 	y="8.67in" width="0.55in"  height="0.1in" valueSource="CMS1500.1.fDollars5" class="money" />
		<text x="5.83in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.fCents5" />
		<text x="6.13in" 	y="8.67in" width="0.33in"  height="0.1in" valueSource="CMS1500.1.gUnits5" />
		<text x="6.47in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.hEPSDT5" />
		<text x="6.75in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.iEMG5" />
		<text x="7.05in" 	y="8.67in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.jCOB5" />
		<text x="7.33in" 	y="8.67in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal5" class="smaller" />
	</g>
	<g id="box24_6">
		<text x="0.37in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartMM6" />
		<text x="0.68in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartDD6" />
		<text x="1.00in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aStartYY6" />
		<text x="1.26in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndMM6" />
		<text x="1.56in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndDD6" />
		<text x="1.88in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.aEndYY6" />
		<text x="2.17in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.bPOS6" />
		<text x="2.44in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.cTOS6" />
		<text x="2.8in"  	y="9.00in" width="0.7in"  height="0.1in" valueSource="CMS1500.1.dCPT6" />
		<text x="3.46in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.dModifier6" />
		<text x="3.77in" 	y="9.00in" width="0.6in"  height="0.1in" valueSource="CMS1500.1.dExtra6" />
		<text x="4.5in"  	y="9.00in" width="0.7in"  height="0.1in" valueSource="CMS1500.1.eDiag6" />
		<text x="5.23in" 	y="9.00in" width="0.55in"  height="0.1in" valueSource="CMS1500.1.fDollars6" class="money" />
		<text x="5.83in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.fCents6" />
		<text x="6.13in" 	y="9.00in" width="0.33in"  height="0.1in" valueSource="CMS1500.1.gUnits6" />
		<text x="6.47in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.hEPSDT6" />
		<text x="6.75in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.iEMG6" />
		<text x="7.05in" 	y="9.00in" width="0.3in"  height="0.1in" valueSource="CMS1500.1.jCOB6" />
		<text x="7.33in" 	y="9.00in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal6" class="smaller" />
	</g>
	
	<g id="line17">
		<text x="0.43in" y="9.39in" width="1.31in" height="0.1in" valueSource="CMS1500.1.2_5ID" />
		<text x="1.96in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_5SSN" />
		<text x="2.15in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_5EIN" />
		
		<text x="2.51in" y="9.39in" width="1.41in" height="0.1in" valueSource="CMS1500.1.2_6Account" />
		
		<text x="4.03in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_7Yes" />
		<text x="4.53in" y="9.39in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_7No" />
		
		<text x="5.35in" y="9.39in" width="0.65in" height="0.1in" valueSource="CMS1500.1.2_8Dollars" class="money" />
		<text x="6.04in" y="9.39in" width="0.33in" height="0.1in" valueSource="CMS1500.1.2_8Cents" />
		
		<text x="6.45in" y="9.39in" width="0.56in" height="0.1in" valueSource="CMS1500.1.2_9Dollars" class="money" />
		<text x="7.03in" y="9.39in" width="0.33in" height="0.1in" valueSource="CMS1500.1.2_9Cents" />
		
		<text x="7.37in" y="9.39in" width="0.56in" height="0.1in" valueSource="CMS1500.1.3_0Dollars" class="money" />
		<text x="7.96in" y="9.39in" width="0.33in" height="0.1in" valueSource="CMS1500.1.3_0Cents" />
	</g>
	
	<g id="box31">
		<text x="0.37in" y="9.95in" width="1.7in" height="0.1in" valueSource="CMS1500.1.3_1Signature" />
		<text x="0.37in" y="10.10in" width="1.7in" height="0.1in" valueSource="CMS1500.1.3_1ProviderName" />
		<text x="1.25in" y="10.25in" width="1.0in" height="0.1in" valueSource="CMS1500.1.3_1Date" />
	</g>
	
	<g id="box32">
		<text x="2.52in" y="9.79in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Name" />
		<text x="2.52in" y="9.95in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Street" />
		<text x="2.52in" y="10.11in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2CityStateZip" />
		<text x="2.52in" y="10.27in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2FacilityInfo" />
	</g>
	
	<g id="box33">
		<text x="5.95in" y="9.67in" width="2.30in" height="0.1in" valueSource="CMS1500.1.3_3Name" />
		<text x="5.26in" y="9.79in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Street" />
		<text x="5.26in" y="9.95in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3CityStateZip" />
		<text x="5.26in" y="10.11in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Phone" />
		<text x="5.44in" y="10.27in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3PIN" />
		<text x="6.92in" y="10.27in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3GRP" />
	</g>
</svg>',
	0)

GO
