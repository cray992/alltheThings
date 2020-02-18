-- Currently for customer-109

--------------------------------------------------------------------------------------
-- Remove the existing forms that we are about to insert
--------------------------------------------------------------------------------------

DELETE FROM PrintingFormDetails
WHERE PrintingFormID IN
(2, 3, 4, 5, 6, 7, 10)

DELETE FROM PrintingForm 
WHERE PrintingFormID IN
(2, 3, 4, 5, 6, 7, 10)

--------------------------------------------------------------------------------------
-- Insert New PrintingForms
--------------------------------------------------------------------------------------

INSERT	PrintingForm(
		PrintingFormID,
		Name,
		Description, 
		StoredProcedureName
	)
VALUES	(	2,
		'DFR',
		'Doctor''s First Report of Occupational Injury or Illness',
		'AppointmentDataProvider_GetDFRFormXml'
	)

INSERT	PrintingForm(
		PrintingFormID,
		Name,
		Description, 
		StoredProcedureName,
		RecipientSpecific
	)
VALUES	(	3,
		'IOC',
		'Itemization of Charges',
		'BillDataProvider_GetIOCFormXml',
		0
	)

INSERT	PrintingForm(
		PrintingFormID,
		Name,
		Description, 
		StoredProcedureName
	)
VALUES	(	4,
		'NOR',
		'Notice of Representation',
		'BillDataProvider_GetNORFormXml'
	)

INSERT	PrintingForm(
		PrintingFormID,
		Name,
		Description, 
		StoredProcedureName
	)
VALUES	(	5,
		'PR2',
		'Primary Treating Physicians Progress',
		'AppointmentDataProvider_GetPR2FormXml'
	)

INSERT	PrintingForm(
		PrintingFormID,
		Name,
		Description, 
		StoredProcedureName
	)
VALUES	(	6,
		'POS',
		'Proof of Service',
		'BillDataProvider_GetPOSFormXml'
	)

INSERT	PrintingForm(
		PrintingFormID,
		Name,
		Description, 
		StoredProcedureName,
		RecipientSpecific
	)
VALUES	(	7,
		'Label',
		'Mailing Label',
		'BillDataProvider_GetLabelFormXml',
		1
	)

INSERT INTO PrintingForm(
		PrintingFormID,
		Name,
		Description,
		StoredProcedureName,
		RecipientSpecific
	)
VALUES	(	10,
		'Lien',
		'Lien',
		'BillDataProvider_GetLienFormXml',
		0
	)

--------------------------------------------------------------------------------------
-- Add the DFR
--------------------------------------------------------------------------------------

INSERT	PrintingFormDetails(
		PrintingFormDetailsID,
		PrintingFormID,
		SVGDefinitionID,
		Description,
		SVGDefinition
	)
VALUES	(	2,
		2,
		1,
		'DFR', 
		'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="DFR" pageId="DFR.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css"><![CDATA[
		
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
		
		g#field9,g#field8 text
		{
			font-size: 8pt;
		}
		
	    	]]></style>
	</defs>

	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://d0c76bbb-1783-4abf-9071-cca7373a5159"></image>

	<!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="./DFR.1.jpg"></image>
	-->
	
	<g id="header">
		<g id="field1">
			<text x="0.62in" 	y="1.53in" width="6.7in" height="0.1in" valueSource="DFR.1.INSURANCE_NAME1" />
		</g>

		<g id="field2">
			<text x="0.62in" 	y="1.81in" width="6.7in" height="0.1in" valueSource="DFR.1.EMPLOYER_NAME1" />
		</g>

		<g id="field3">
			<text x="0.62in" 	y="2.09in" width="4.00in" height="0.1in" valueSource="DFR.1.EMPLOYER_STREET1" />
			<text x="4.70in" 	y="2.09in" width="1.50in" height="0.1in" valueSource="DFR.1.EMPLOYER_CITY1" />
			<text x="6.25in" 	y="2.09in" width="1.00in" height="0.1in" valueSource="DFR.1.EMPLOYER_ZIP1" />
		</g>


		<g id="field5">
			<text x="0.62in" 	y="2.66in" width="3.73in" height="0.1in" valueSource="DFR.1.PATIENT_NAME1" />
		</g>

		<g id="field6">
			<text x="4.45in" 	y="2.66in" width="0.09in" height="0.1in" valueSource="DFR.1.PATIENT_GENDER_M1" />
			<text x="4.93in" 	y="2.66in" width="0.09in" height="0.1in" valueSource="DFR.1.PATIENT_GENDER_F1" />
		</g>

		<g id="field7">
			<text x="6.30in" 	y="2.66in" width="0.90in" height="0.1in" valueSource="DFR.1.PATIENT_DOB1" />
		</g>

		<g id="field8">
			<text x="0.62in" 	y="2.95in" width="2.50in" height="0.1in" valueSource="DFR.1.PATIENT_STREET1" />
			<text x="3.07in" 	y="2.95in" width="1.15in" height="0.1in" valueSource="DFR.1.PATIENT_CITY1" />
			<text x="4.25in" 	y="2.95in" width="0.90in" height="0.1in" valueSource="DFR.1.PATIENT_ZIP1" />
		</g>

		<g id="field9">
			<text x="5.38in" 	y="2.95in" width="0.35in" height="0.1in" valueSource="DFR.1.PATIENT_AREACODE1" />
			<text x="5.65in" 	y="2.95in" width="0.90in" height="0.1in" valueSource="DFR.1.PATIENT_PHONE1" />
		</g>


		<g id="field11">
			<text x="5.52in" 	y="3.22in" width="0.40in" height="0.1in" valueSource="DFR.1.PATIENT_SSN11" />
			<text x="5.92in" 	y="3.22in" width="0.40in" height="0.1in" valueSource="DFR.1.PATIENT_SSN21" />
			<text x="6.35in" 	y="3.22in" width="0.40in" height="0.1in" valueSource="DFR.1.PATIENT_SSN31" />
		</g>


		<g id="field13">
			<text x="2.16in" 	y="3.80in" width="0.90in" height="0.1in" valueSource="DFR.1.DOI1" />
		</g>


		<g id="field15">
			<text x="2.16in" 	y="4.06in" width="0.90in" height="0.1in" valueSource="DFR.1.APPOINTMENT_DATE1" />
			<text x="3.45in" 	y="4.06in" width="0.40in" height="0.1in" valueSource="DFR.1.APPOINTMENT_TIME_AM1" />
			<text x="4.17in" 	y="4.06in" width="0.40in" height="0.1in" valueSource="DFR.1.APPOINTMENT_TIME_PM1" />
		</g>
	</g>

	
	<g id="footer">
		<g id="footer1">
			<text x="5.80in" 	y="8.90in" width="1.51in" height="0.1in" valueSource="DFR.1.PROVIDER_STATE_LICENSE1" />
		</g>

		<g id="footer2">
			<text x="2.28in" 	y="9.12in" width="2.09in" height="0.1in" valueSource="DFR.1.PROVIDER_NAME1" />
			<text x="5.80in" 	y="9.12in" width="1.51in" height="0.1in" valueSource="DFR.1.PROVIDER_EIN1" />
		</g>

		<g id="footer3">
			<text x="0.91in" 	y="9.33in" width="3.45in" height="0.1in" valueSource="DFR.1.PROVIDER_ADDRESS1" />
			<text x="5.80in" 	y="9.33in" width="0.40in" height="0.1in" valueSource="DFR.1.PROVIDER_AREACODE1" />
			<text x="6.17in" 	y="9.33in" width="1.10in" height="0.1in" valueSource="DFR.1.PROVIDER_PHONE1" />
		</g>
   
	</g>

</svg>'
	)

--------------------------------------------------------------------------------------
-- Add the IOC
--------------------------------------------------------------------------------------

INSERT	PrintingFormDetails(
		PrintingFormDetailsID,
		PrintingFormID,
		SVGDefinitionID,
		Description,
		SVGDefinition
	)
VALUES	(	3,
		3,
		1,
		'IOC (Single Page)', 
		'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="IOC" pageId="IOC.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css"><![CDATA[

			g {
				font-family: Times New Roman,Courier New;
				font-size: 10pt;
				font-style: normal;
				font-weight: normal;
				alignment-baseline: text-before-edge;
			}

			text
			{
				baseline-shift: -100%;
			}
			
			text.header
			{
				font-weight: bold;
				font-size: 14pt;
				text-anchor: middle;
			}
			
			rect.test
			{
				fill: black;
				opacity: 0.4;
			}
			
			g.lines
			{
				stroke: black;
				stroke-width: 0.01in;
			}
			
			g#formListFooter, g#formFooter
			{
				font-weight: bold;
			}
			
			
			g#data g#dataLines
			{
				font-size: 9pt;
			}

			]]>
		</style>
	</defs>
	
	<!-- This is the one-page itemization of charges form -->

	<g id="formBackground">
	
		<g id="formTitle" >
			<text x="0.25in" y="0.5in" width="8.00in" height="0.2in" class="header">Itemization of Charges</text>	
		</g>
	
		<g id="formHeader">
			<text x="0.50in" y="1.00in" width="4.10in" height="0.1in">Clinic:</text>
			<text x="0.50in" y="1.15in" width="4.10in" height="0.1in">Address:</text>
			<text x="4.50in" y="1.00in" width="4.10in" height="0.1in">Phone:</text>
			<text x="4.50in" y="1.15in" width="4.10in" height="0.1in">Tax ID:</text>

			<text x="0.50in" y="1.70in" width="4.10in" height="0.1in">Adjuster:</text>
			<text x="0.50in" y="1.85in" width="4.10in" height="0.1in">Insurance:</text>
			
			<text x="4.50in" y="1.70in" width="4.10in" height="0.1in">Patient #:</text>
			<text x="4.50in" y="1.85in" width="4.10in" height="0.1in">Patient:</text>
			<text x="4.50in" y="2.00in" width="4.10in" height="0.1in">Date of Injury:</text>
			<text x="4.50in" y="2.15in" width="4.10in" height="0.1in">WCAB #:</text>


			<text x="0.50in" y="2.35in" width="4.10in" height="0.1in">Provider:</text>
			<text x="0.50in" y="2.50in" width="4.10in" height="0.1in">Employer:</text>

			<text x="0.50in" y="2.80in" width="4.10in" height="0.1in">Group Number:</text>
			<text x="4.50in" y="2.80in" width="4.10in" height="0.1in">Policy Number:</text>
		</g>

	
		<g id="formListHeader">
			<text x="0.50in" y="3.20in" width="0.70in" height="0.1in">Visit #</text>
			<text x="1.25in" y="3.20in" width="0.95in" height="0.1in">Date of Service</text>
			<text x="2.25in" y="3.20in" width="2.20in" height="0.1in">Procedure Description</text>
			<text x="4.50in" y="3.20in" width="0.95in" height="0.1in">Code</text>
			<text x="6.00in" y="3.20in" width="0.95in" height="0.1in">Charge</text>
			<text x="7.00in" y="3.20in" width="0.95in" height="0.1in">Payment</text>
			
			<g class="lines">
				<line x1="0.50in" y1="3.40in" x2="1.20in" y2="3.40in" />
				<line x1="1.25in" y1="3.40in" x2="2.20in" y2="3.40in" />
				<line x1="2.25in" y1="3.40in" x2="4.45in" y2="3.40in" />
				<line x1="4.50in" y1="3.40in" x2="5.95in" y2="3.40in" />
				<line x1="6.00in" y1="3.40in" x2="6.95in" y2="3.40in" />
				<line x1="7.00in" y1="3.40in" x2="7.95in" y2="3.40in" />
			</g>
		</g>
		

		<g id="formListFooter">
			<g class="lines">
				<line x1="0.50in" y1="10.20in" x2="1.20in" y2="10.20in" />
				<line x1="1.25in" y1="10.20in" x2="2.20in" y2="10.20in" />
				<line x1="2.25in" y1="10.20in" x2="4.45in" y2="10.20in" />
				<line x1="4.50in" y1="10.20in" x2="5.95in" y2="10.20in" />
				<line x1="6.00in" y1="10.20in" x2="6.95in" y2="10.20in" />
				<line x1="7.00in" y1="10.20in" x2="7.95in" y2="10.20in" />
			</g>
			
			<text x="0.50in" y="10.21in" width="1in" height="0.1in">TOTAL</text>
			
		</g>
		
		<g id="formFooter">
			<text x="0.50in" y="10.40in" width="1in" height="0.1in">Balance Due:</text>
			<text x="7.00in" y="10.40in" width="0.5in" height="0.1in">Page #:</text>
			<text x="7.8in" y="10.40in" width="0.2in" height="0.1in">of</text>
		</g>
	</g>
	
	<g id="data">
	
		<g id="dataHeader">
			<text x="1.5in" y="1.00in" width="3.00in" height="0.1in" valueSource="IOC.1.Clinic1" />
			<text x="1.5in" y="1.15in" width="3.00in" height="0.1in" valueSource="IOC.1.Street1" />
			<text x="1.5in" y="1.30in" width="3.00in" height="0.1in" valueSource="IOC.1.CityStateZip1" />
			<text x="5.5in" y="1.00in" width="3.00in" height="0.1in" valueSource="IOC.1.Phone1" />
			<text x="5.5in" y="1.15in" width="3.00in" height="0.1in" valueSource="IOC.1.TaxID1" />

			<text x="1.5in" y="1.70in" width="3.00in" height="0.1in" valueSource="IOC.1.Adjuster1" />
			<text x="1.5in" y="1.85in" width="3.00in" height="0.1in" valueSource="IOC.1.InsuranceName1" />
			<text x="1.5in" y="2.00in" width="3.00in" height="0.1in" valueSource="IOC.1.InsuranceStreet1" />
			<text x="1.5in" y="2.15in" width="3.00in" height="0.1in" valueSource="IOC.1.InsuranceCityStateZip1" />
			
			<text x="5.5in" y="1.70in" width="3.00in" height="0.1in" valueSource="IOC.1.PatientID1" />
			<text x="5.5in" y="1.85in" width="3.00in" height="0.1in" valueSource="IOC.1.PatientName1" style="font-weight: bold;" />
			<text x="5.5in" y="2.00in" width="3.00in" height="0.1in" valueSource="IOC.1.DOI1" />
			<text x="5.5in" y="2.15in" width="3.00in" height="0.1in" valueSource="IOC.1.WCAB1" />
			
			<text x="1.5in" y="2.35in" width="3.00in" height="0.1in" valueSource="IOC.1.Provider1" />
			<text x="1.5in" y="2.50in" width="3.00in" height="0.1in" valueSource="IOC.1.Employer1" />

			<text x="1.5in" y="2.80in" width="3.00in" height="0.1in" valueSource="IOC.1.GroupNumber1" />
			<text x="5.5in" y="2.80in" width="3.00in" height="0.1in" valueSource="IOC.1.PolicyNumber1" />
		</g>
		
		<g id="dataFooter">
			<text x="6.00in" y="10.21in" width="0.95in" height="0.1in" valueSource="IOC.1.TotalAdjustedCharge1" />
			<text x="7.00in" y="10.21in" width="0.95in" height="0.1in" valueSource="IOC.1.TotalPayment1" />
			<text x="1.50in" y="10.40in" width="0.95in" height="0.1in" valueSource="IOC.1.BalanceDue1" />
			<text x="7.48in" y="10.40in" width="0.36in" height="0.1in" valueSource="IOC.1.PageNo1" />
			<text x="7.95in" y="10.40in" width="0.36in" height="0.1in" valueSource="IOC.1.ofPages1" />
		</g>
		
		<g id="dataLines">
			<g>
			<text x="0.5in" y="3.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID1" />
			<text x="1.25in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService1" />
			<text x="2.25in" y="3.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName1" />
			<text x="4.5in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode1" />
			<text x="6in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges1" />
			<text x="7in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments1" />
			</g><g>
			<text x="0.5in" y="3.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID2" />
			<text x="1.25in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService2" />
			<text x="2.25in" y="3.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName2" />
			<text x="4.5in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode2" />
			<text x="6in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges2" />
			<text x="7in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments2" />
			</g><g>
			<text x="0.5in" y="3.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID3" />
			<text x="1.25in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService3" />
			<text x="2.25in" y="3.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName3" />
			<text x="4.5in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode3" />
			<text x="6in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges3" />
			<text x="7in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments3" />
			</g><g>
			<text x="0.5in" y="3.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID4" />
			<text x="1.25in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService4" />
			<text x="2.25in" y="3.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName4" />
			<text x="4.5in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode4" />
			<text x="6in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges4" />
			<text x="7in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments4" />
			</g><g>
			<text x="0.5in" y="4.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID5" />
			<text x="1.25in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService5" />
			<text x="2.25in" y="4.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName5" />
			<text x="4.5in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode5" />
			<text x="6in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges5" />
			<text x="7in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments5" />
			</g><g>
			<text x="0.5in" y="4.18in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID6" />
			<text x="1.25in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService6" />
			<text x="2.25in" y="4.18in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName6" />
			<text x="4.5in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode6" />
			<text x="6in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges6" />
			<text x="7in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments6" />
			</g><g>
			<text x="0.5in" y="4.33in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID7" />
			<text x="1.25in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService7" />
			<text x="2.25in" y="4.33in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName7" />
			<text x="4.5in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode7" />
			<text x="6in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges7" />
			<text x="7in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments7" />
			</g><g>
			<text x="0.5in" y="4.48in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID8" />
			<text x="1.25in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService8" />
			<text x="2.25in" y="4.48in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName8" />
			<text x="4.5in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode8" />
			<text x="6in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges8" />
			<text x="7in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments8" />
			</g><g>
			<text x="0.5in" y="4.63in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID9" />
			<text x="1.25in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService9" />
			<text x="2.25in" y="4.63in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName9" />
			<text x="4.5in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode9" />
			<text x="6in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges9" />
			<text x="7in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments9" />
			</g><g>
			<text x="0.5in" y="4.78in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID10" />
			<text x="1.25in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService10" />
			<text x="2.25in" y="4.78in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName10" />
			<text x="4.5in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode10" />
			<text x="6in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges10" />
			<text x="7in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments10" />
			</g><g>
			<text x="0.5in" y="4.93in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID11" />
			<text x="1.25in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService11" />
			<text x="2.25in" y="4.93in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName11" />
			<text x="4.5in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode11" />
			<text x="6in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges11" />
			<text x="7in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments11" />
			</g><g>
			<text x="0.5in" y="5.08in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID12" />
			<text x="1.25in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService12" />
			<text x="2.25in" y="5.08in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName12" />
			<text x="4.5in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode12" />
			<text x="6in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges12" />
			<text x="7in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments12" />
			</g><g>
			<text x="0.5in" y="5.23in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID13" />
			<text x="1.25in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService13" />
			<text x="2.25in" y="5.23in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName13" />
			<text x="4.5in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode13" />
			<text x="6in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges13" />
			<text x="7in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments13" />
			</g><g>
			<text x="0.5in" y="5.38in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID14" />
			<text x="1.25in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService14" />
			<text x="2.25in" y="5.38in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName14" />
			<text x="4.5in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode14" />
			<text x="6in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges14" />
			<text x="7in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments14" />
			</g><g>
			<text x="0.5in" y="5.53in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID15" />
			<text x="1.25in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService15" />
			<text x="2.25in" y="5.53in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName15" />
			<text x="4.5in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode15" />
			<text x="6in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges15" />
			<text x="7in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments15" />
			</g><g>
			<text x="0.5in" y="5.68in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID16" />
			<text x="1.25in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService16" />
			<text x="2.25in" y="5.68in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName16" />
			<text x="4.5in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode16" />
			<text x="6in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges16" />
			<text x="7in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments16" />
			</g><g>
			<text x="0.5in" y="5.83in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID17" />
			<text x="1.25in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService17" />
			<text x="2.25in" y="5.83in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName17" />
			<text x="4.5in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode17" />
			<text x="6in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges17" />
			<text x="7in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments17" />
			</g><g>
			<text x="0.5in" y="5.98in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID18" />
			<text x="1.25in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService18" />
			<text x="2.25in" y="5.98in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName18" />
			<text x="4.5in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode18" />
			<text x="6in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges18" />
			<text x="7in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments18" />
			</g><g>
			<text x="0.5in" y="6.13in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID19" />
			<text x="1.25in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService19" />
			<text x="2.25in" y="6.13in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName19" />
			<text x="4.5in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode19" />
			<text x="6in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges19" />
			<text x="7in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments19" />
			</g><g>
			<text x="0.5in" y="6.28in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID20" />
			<text x="1.25in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService20" />
			<text x="2.25in" y="6.28in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName20" />
			<text x="4.5in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode20" />
			<text x="6in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges20" />
			<text x="7in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments20" />
			</g><g>
			<text x="0.5in" y="6.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID21" />
			<text x="1.25in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService21" />
			<text x="2.25in" y="6.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName21" />
			<text x="4.5in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode21" />
			<text x="6in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges21" />
			<text x="7in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments21" />
			</g><g>
			<text x="0.5in" y="6.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID22" />
			<text x="1.25in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService22" />
			<text x="2.25in" y="6.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName22" />
			<text x="4.5in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode22" />
			<text x="6in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges22" />
			<text x="7in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments22" />
			</g><g>
			<text x="0.5in" y="6.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID23" />
			<text x="1.25in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService23" />
			<text x="2.25in" y="6.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName23" />
			<text x="4.5in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode23" />
			<text x="6in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges23" />
			<text x="7in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments23" />
			</g><g>
			<text x="0.5in" y="6.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID24" />
			<text x="1.25in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService24" />
			<text x="2.25in" y="6.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName24" />
			<text x="4.5in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode24" />
			<text x="6in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges24" />
			<text x="7in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments24" />
			</g><g>
			<text x="0.5in" y="7.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID25" />
			<text x="1.25in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService25" />
			<text x="2.25in" y="7.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName25" />
			<text x="4.5in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode25" />
			<text x="6in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges25" />
			<text x="7in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments25" />
			</g><g>
			<text x="0.5in" y="7.18in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID26" />
			<text x="1.25in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService26" />
			<text x="2.25in" y="7.18in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName26" />
			<text x="4.5in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode26" />
			<text x="6in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges26" />
			<text x="7in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments26" />
			</g><g>
			<text x="0.5in" y="7.33in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID27" />
			<text x="1.25in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService27" />
			<text x="2.25in" y="7.33in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName27" />
			<text x="4.5in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode27" />
			<text x="6in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges27" />
			<text x="7in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments27" />
			</g><g>
			<text x="0.5in" y="7.48in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID28" />
			<text x="1.25in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService28" />
			<text x="2.25in" y="7.48in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName28" />
			<text x="4.5in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode28" />
			<text x="6in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges28" />
			<text x="7in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments28" />
			</g><g>
			<text x="0.5in" y="7.63in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID29" />
			<text x="1.25in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService29" />
			<text x="2.25in" y="7.63in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName29" />
			<text x="4.5in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode29" />
			<text x="6in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges29" />
			<text x="7in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments29" />
			</g><g>
			<text x="0.5in" y="7.78in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID30" />
			<text x="1.25in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService30" />
			<text x="2.25in" y="7.78in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName30" />
			<text x="4.5in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode30" />
			<text x="6in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges30" />
			<text x="7in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments30" />
			</g><g>
			<text x="0.5in" y="7.93in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID31" />
			<text x="1.25in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService31" />
			<text x="2.25in" y="7.93in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName31" />
			<text x="4.5in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode31" />
			<text x="6in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges31" />
			<text x="7in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments31" />
			</g><g>
			<text x="0.5in" y="8.08in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID32" />
			<text x="1.25in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService32" />
			<text x="2.25in" y="8.08in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName32" />
			<text x="4.5in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode32" />
			<text x="6in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges32" />
			<text x="7in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments32" />
			</g><g>
			<text x="0.5in" y="8.23in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID33" />
			<text x="1.25in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService33" />
			<text x="2.25in" y="8.23in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName33" />
			<text x="4.5in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode33" />
			<text x="6in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges33" />
			<text x="7in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments33" />
			</g><g>
			<text x="0.5in" y="8.38in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID34" />
			<text x="1.25in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService34" />
			<text x="2.25in" y="8.38in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName34" />
			<text x="4.5in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode34" />
			<text x="6in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges34" />
			<text x="7in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments34" />
			</g><g>
			<text x="0.5in" y="8.53in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID35" />
			<text x="1.25in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService35" />
			<text x="2.25in" y="8.53in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName35" />
			<text x="4.5in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode35" />
			<text x="6in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges35" />
			<text x="7in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments35" />
			</g><g>
			<text x="0.5in" y="8.68in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID36" />
			<text x="1.25in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService36" />
			<text x="2.25in" y="8.68in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName36" />
			<text x="4.5in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode36" />
			<text x="6in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges36" />
			<text x="7in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments36" />
			</g><g>
			<text x="0.5in" y="8.83in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID37" />
			<text x="1.25in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService37" />
			<text x="2.25in" y="8.83in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName37" />
			<text x="4.5in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode37" />
			<text x="6in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges37" />
			<text x="7in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments37" />
			</g><g>
			<text x="0.5in" y="8.98in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID38" />
			<text x="1.25in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService38" />
			<text x="2.25in" y="8.98in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName38" />
			<text x="4.5in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode38" />
			<text x="6in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges38" />
			<text x="7in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments38" />
			</g><g>
			<text x="0.5in" y="9.13in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID39" />
			<text x="1.25in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService39" />
			<text x="2.25in" y="9.13in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName39" />
			<text x="4.5in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode39" />
			<text x="6in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges39" />
			<text x="7in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments39" />
			</g><g>
			<text x="0.5in" y="9.28in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID40" />
			<text x="1.25in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService40" />
			<text x="2.25in" y="9.28in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName40" />
			<text x="4.5in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode40" />
			<text x="6in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges40" />
			<text x="7in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments40" />
			</g><g>
			<text x="0.5in" y="9.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID41" />
			<text x="1.25in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService41" />
			<text x="2.25in" y="9.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName41" />
			<text x="4.5in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode41" />
			<text x="6in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges41" />
			<text x="7in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments41" />
			</g><g>
			<text x="0.5in" y="9.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID42" />
			<text x="1.25in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService42" />
			<text x="2.25in" y="9.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName42" />
			<text x="4.5in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode42" />
			<text x="6in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges42" />
			<text x="7in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments42" />
			</g><g>
			<text x="0.5in" y="9.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID43" />
			<text x="1.25in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService43" />
			<text x="2.25in" y="9.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName43" />
			<text x="4.5in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode43" />
			<text x="6in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges43" />
			<text x="7in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments43" />
			</g><g>
			<text x="0.5in" y="9.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID44" />
			<text x="1.25in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService44" />
			<text x="2.25in" y="9.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName44" />
			<text x="4.5in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode44" />
			<text x="6in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges44" />
			<text x="7in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments44" />
			</g><g>
			<text x="0.5in" y="10.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID45" />
			<text x="1.25in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService45" />
			<text x="2.25in" y="10.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName45" />
			<text x="4.5in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode45" />
			<text x="6in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges45" />
			<text x="7in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments45" />

			</g>
		</g>
	
	</g>

</svg>'
	)

--------------------------------------------------------------------------------------
-- Add the IOC (First Page)
--------------------------------------------------------------------------------------

INSERT	PrintingFormDetails(
		PrintingFormDetailsID,
		PrintingFormID,
		SVGDefinitionID,
		Description,
		SVGDefinition
	)
VALUES	(	4,
		3,
		2,
		'IOC (First Page)', 
		'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="IOC" pageId="IOC.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css"><![CDATA[

			g {
				font-family: Times New Roman,Courier New;
				font-size: 10pt;
				font-style: normal;
				font-weight: normal;
				alignment-baseline: text-before-edge;
			}

			text
			{
				baseline-shift: -100%;
			}
			
			text.header
			{
				font-weight: bold;
				font-size: 14pt;
				text-anchor: middle;
			}
			
			rect.test
			{
				fill: black;
				opacity: 0.4;
			}
			
			g.lines
			{
				stroke: black;
				stroke-width: 0.01in;
			}
			
			g#formListFooter, g#formFooter
			{
				font-weight: bold;
			}
			
			
			g#data g#dataLines
			{
				font-size: 9pt;
			}

			]]>
		</style>
	</defs>
	
	<!-- This is the first page of the multi-page itemization of charges form -->

	<g id="formBackground">
	
		<g id="formTitle" >
			<text x="0.25in" y="0.5in" width="8.00in" height="0.2in" class="header">Itemization of Charges</text>	
		</g>
	
		<g id="formHeader">
			<text x="0.50in" y="1.00in" width="4.10in" height="0.1in">Clinic:</text>
			<text x="0.50in" y="1.15in" width="4.10in" height="0.1in">Address:</text>
			<text x="4.50in" y="1.00in" width="4.10in" height="0.1in">Phone:</text>
			<text x="4.50in" y="1.15in" width="4.10in" height="0.1in">Tax ID:</text>

			<text x="0.50in" y="1.70in" width="4.10in" height="0.1in">Adjuster:</text>
			<text x="0.50in" y="1.85in" width="4.10in" height="0.1in">Insurance:</text>
			
			<text x="4.50in" y="1.70in" width="4.10in" height="0.1in">Patient #:</text>
			<text x="4.50in" y="1.85in" width="4.10in" height="0.1in">Patient:</text>
			<text x="4.50in" y="2.00in" width="4.10in" height="0.1in">Date of Injury:</text>
			<text x="4.50in" y="2.15in" width="4.10in" height="0.1in">WCAB #:</text>


			<text x="0.50in" y="2.35in" width="4.10in" height="0.1in">Provider:</text>
			<text x="0.50in" y="2.50in" width="4.10in" height="0.1in">Employer:</text>

			<text x="0.50in" y="2.80in" width="4.10in" height="0.1in">Group Number:</text>
			<text x="4.50in" y="2.80in" width="4.10in" height="0.1in">Policy Number:</text>
		</g>
		
	
		<g id="formListHeader">
			<text x="0.50in" y="3.20in" width="0.70in" height="0.1in">Visit #</text>
			<text x="1.25in" y="3.20in" width="0.95in" height="0.1in">Date of Service</text>
			<text x="2.25in" y="3.20in" width="2.20in" height="0.1in">Procedure Description</text>
			<text x="4.50in" y="3.20in" width="0.95in" height="0.1in">Code</text>
			<text x="6.00in" y="3.20in" width="0.95in" height="0.1in">Charge</text>
			<text x="7.00in" y="3.20in" width="0.95in" height="0.1in">Payment</text>
			
			<g class="lines">
				<line x1="0.50in" y1="3.40in" x2="1.20in" y2="3.40in" />
				<line x1="1.25in" y1="3.40in" x2="2.20in" y2="3.40in" />
				<line x1="2.25in" y1="3.40in" x2="4.45in" y2="3.40in" />
				<line x1="4.50in" y1="3.40in" x2="5.95in" y2="3.40in" />
				<line x1="6.00in" y1="3.40in" x2="6.95in" y2="3.40in" />
				<line x1="7.00in" y1="3.40in" x2="7.95in" y2="3.40in" />
			</g>
		</g>
		

		<g id="formFooter">
			<text x="7.00in" y="10.40in" width="0.5in" height="0.1in">Page #:</text>
			<text x="7.8in" y="10.40in" width="0.2in" height="0.1in">of</text>
		</g>
	</g>
	
	<g id="data">
	
		<g id="dataHeader">
			<text x="1.5in" y="1.00in" width="3.00in" height="0.1in" valueSource="IOC.1.Clinic1" />
			<text x="1.5in" y="1.15in" width="3.00in" height="0.1in" valueSource="IOC.1.Street1" />
			<text x="1.5in" y="1.30in" width="3.00in" height="0.1in" valueSource="IOC.1.CityStateZip1" />
			<text x="5.5in" y="1.00in" width="3.00in" height="0.1in" valueSource="IOC.1.Phone1" />
			<text x="5.5in" y="1.15in" width="3.00in" height="0.1in" valueSource="IOC.1.TaxID1" />

			<text x="1.5in" y="1.70in" width="3.00in" height="0.1in" valueSource="IOC.1.Adjuster1" />
			<text x="1.5in" y="1.85in" width="3.00in" height="0.1in" valueSource="IOC.1.InsuranceName1" />
			<text x="1.5in" y="2.00in" width="3.00in" height="0.1in" valueSource="IOC.1.InsuranceStreet1" />
			<text x="1.5in" y="2.15in" width="3.00in" height="0.1in" valueSource="IOC.1.InsuranceCityStateZip1" />
			
			<text x="5.5in" y="1.70in" width="3.00in" height="0.1in" valueSource="IOC.1.PatientID1" />
			<text x="5.5in" y="1.85in" width="3.00in" height="0.1in" valueSource="IOC.1.PatientName1" style="font-weight: bold;" />
			<text x="5.5in" y="2.00in" width="3.00in" height="0.1in" valueSource="IOC.1.DOI1" />
			<text x="5.5in" y="2.15in" width="3.00in" height="0.1in" valueSource="IOC.1.WCAB1" />
			
			<text x="1.5in" y="2.35in" width="3.00in" height="0.1in" valueSource="IOC.1.Provider1" />
			<text x="1.5in" y="2.50in" width="3.00in" height="0.1in" valueSource="IOC.1.Employer1" />

			<text x="1.5in" y="2.80in" width="3.00in" height="0.1in" valueSource="IOC.1.GroupNumber1" />
			<text x="5.5in" y="2.80in" width="3.00in" height="0.1in" valueSource="IOC.1.PolicyNumber1" />
		</g>
		
		<g id="dataFooter">
			<text x="7.48in" y="10.40in" width="0.36in" height="0.1in" valueSource="IOC.1.PageNo1" />
			<text x="7.95in" y="10.40in" width="0.36in" height="0.1in" valueSource="IOC.1.ofPages1" />
		</g>
		
		<g id="dataLines">
			<g>
			<text x="0.5in" y="3.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID1" />
			<text x="1.25in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService1" />
			<text x="2.25in" y="3.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName1" />
			<text x="4.5in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode1" />
			<text x="6in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges1" />
			<text x="7in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments1" />
			</g><g>
			<text x="0.5in" y="3.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID2" />
			<text x="1.25in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService2" />
			<text x="2.25in" y="3.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName2" />
			<text x="4.5in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode2" />
			<text x="6in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges2" />
			<text x="7in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments2" />
			</g><g>
			<text x="0.5in" y="3.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID3" />
			<text x="1.25in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService3" />
			<text x="2.25in" y="3.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName3" />
			<text x="4.5in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode3" />
			<text x="6in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges3" />
			<text x="7in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments3" />
			</g><g>
			<text x="0.5in" y="3.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID4" />
			<text x="1.25in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService4" />
			<text x="2.25in" y="3.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName4" />
			<text x="4.5in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode4" />
			<text x="6in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges4" />
			<text x="7in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments4" />
			</g><g>
			<text x="0.5in" y="4.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID5" />
			<text x="1.25in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService5" />
			<text x="2.25in" y="4.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName5" />
			<text x="4.5in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode5" />
			<text x="6in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges5" />
			<text x="7in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments5" />
			</g><g>
			<text x="0.5in" y="4.18in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID6" />
			<text x="1.25in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService6" />
			<text x="2.25in" y="4.18in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName6" />
			<text x="4.5in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode6" />
			<text x="6in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges6" />
			<text x="7in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments6" />
			</g><g>
			<text x="0.5in" y="4.33in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID7" />
			<text x="1.25in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService7" />
			<text x="2.25in" y="4.33in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName7" />
			<text x="4.5in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode7" />
			<text x="6in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges7" />
			<text x="7in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments7" />
			</g><g>
			<text x="0.5in" y="4.48in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID8" />
			<text x="1.25in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService8" />
			<text x="2.25in" y="4.48in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName8" />
			<text x="4.5in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode8" />
			<text x="6in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges8" />
			<text x="7in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments8" />
			</g><g>
			<text x="0.5in" y="4.63in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID9" />
			<text x="1.25in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService9" />
			<text x="2.25in" y="4.63in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName9" />
			<text x="4.5in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode9" />
			<text x="6in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges9" />
			<text x="7in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments9" />
			</g><g>
			<text x="0.5in" y="4.78in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID10" />
			<text x="1.25in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService10" />
			<text x="2.25in" y="4.78in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName10" />
			<text x="4.5in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode10" />
			<text x="6in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges10" />
			<text x="7in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments10" />
			</g><g>
			<text x="0.5in" y="4.93in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID11" />
			<text x="1.25in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService11" />
			<text x="2.25in" y="4.93in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName11" />
			<text x="4.5in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode11" />
			<text x="6in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges11" />
			<text x="7in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments11" />
			</g><g>
			<text x="0.5in" y="5.08in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID12" />
			<text x="1.25in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService12" />
			<text x="2.25in" y="5.08in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName12" />
			<text x="4.5in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode12" />
			<text x="6in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges12" />
			<text x="7in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments12" />
			</g><g>
			<text x="0.5in" y="5.23in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID13" />
			<text x="1.25in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService13" />
			<text x="2.25in" y="5.23in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName13" />
			<text x="4.5in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode13" />
			<text x="6in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges13" />
			<text x="7in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments13" />
			</g><g>
			<text x="0.5in" y="5.38in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID14" />
			<text x="1.25in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService14" />
			<text x="2.25in" y="5.38in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName14" />
			<text x="4.5in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode14" />
			<text x="6in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges14" />
			<text x="7in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments14" />
			</g><g>
			<text x="0.5in" y="5.53in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID15" />
			<text x="1.25in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService15" />
			<text x="2.25in" y="5.53in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName15" />
			<text x="4.5in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode15" />
			<text x="6in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges15" />
			<text x="7in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments15" />
			</g><g>
			<text x="0.5in" y="5.68in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID16" />
			<text x="1.25in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService16" />
			<text x="2.25in" y="5.68in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName16" />
			<text x="4.5in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode16" />
			<text x="6in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges16" />
			<text x="7in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments16" />
			</g><g>
			<text x="0.5in" y="5.83in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID17" />
			<text x="1.25in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService17" />
			<text x="2.25in" y="5.83in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName17" />
			<text x="4.5in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode17" />
			<text x="6in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges17" />
			<text x="7in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments17" />
			</g><g>
			<text x="0.5in" y="5.98in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID18" />
			<text x="1.25in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService18" />
			<text x="2.25in" y="5.98in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName18" />
			<text x="4.5in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode18" />
			<text x="6in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges18" />
			<text x="7in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments18" />
			</g><g>
			<text x="0.5in" y="6.13in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID19" />
			<text x="1.25in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService19" />
			<text x="2.25in" y="6.13in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName19" />
			<text x="4.5in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode19" />
			<text x="6in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges19" />
			<text x="7in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments19" />
			</g><g>
			<text x="0.5in" y="6.28in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID20" />
			<text x="1.25in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService20" />
			<text x="2.25in" y="6.28in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName20" />
			<text x="4.5in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode20" />
			<text x="6in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges20" />
			<text x="7in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments20" />
			</g><g>
			<text x="0.5in" y="6.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID21" />
			<text x="1.25in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService21" />
			<text x="2.25in" y="6.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName21" />
			<text x="4.5in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode21" />
			<text x="6in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges21" />
			<text x="7in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments21" />
			</g><g>
			<text x="0.5in" y="6.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID22" />
			<text x="1.25in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService22" />
			<text x="2.25in" y="6.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName22" />
			<text x="4.5in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode22" />
			<text x="6in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges22" />
			<text x="7in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments22" />
			</g><g>
			<text x="0.5in" y="6.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID23" />
			<text x="1.25in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService23" />
			<text x="2.25in" y="6.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName23" />
			<text x="4.5in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode23" />
			<text x="6in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges23" />
			<text x="7in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments23" />
			</g><g>
			<text x="0.5in" y="6.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID24" />
			<text x="1.25in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService24" />
			<text x="2.25in" y="6.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName24" />
			<text x="4.5in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode24" />
			<text x="6in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges24" />
			<text x="7in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments24" />
			</g><g>
			<text x="0.5in" y="7.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID25" />
			<text x="1.25in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService25" />
			<text x="2.25in" y="7.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName25" />
			<text x="4.5in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode25" />
			<text x="6in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges25" />
			<text x="7in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments25" />
			</g><g>
			<text x="0.5in" y="7.18in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID26" />
			<text x="1.25in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService26" />
			<text x="2.25in" y="7.18in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName26" />
			<text x="4.5in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode26" />
			<text x="6in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges26" />
			<text x="7in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments26" />
			</g><g>
			<text x="0.5in" y="7.33in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID27" />
			<text x="1.25in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService27" />
			<text x="2.25in" y="7.33in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName27" />
			<text x="4.5in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode27" />
			<text x="6in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges27" />
			<text x="7in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments27" />
			</g><g>
			<text x="0.5in" y="7.48in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID28" />
			<text x="1.25in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService28" />
			<text x="2.25in" y="7.48in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName28" />
			<text x="4.5in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode28" />
			<text x="6in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges28" />
			<text x="7in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments28" />
			</g><g>
			<text x="0.5in" y="7.63in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID29" />
			<text x="1.25in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService29" />
			<text x="2.25in" y="7.63in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName29" />
			<text x="4.5in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode29" />
			<text x="6in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges29" />
			<text x="7in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments29" />
			</g><g>
			<text x="0.5in" y="7.78in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID30" />
			<text x="1.25in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService30" />
			<text x="2.25in" y="7.78in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName30" />
			<text x="4.5in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode30" />
			<text x="6in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges30" />
			<text x="7in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments30" />
			</g><g>
			<text x="0.5in" y="7.93in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID31" />
			<text x="1.25in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService31" />
			<text x="2.25in" y="7.93in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName31" />
			<text x="4.5in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode31" />
			<text x="6in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges31" />
			<text x="7in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments31" />
			</g><g>
			<text x="0.5in" y="8.08in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID32" />
			<text x="1.25in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService32" />
			<text x="2.25in" y="8.08in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName32" />
			<text x="4.5in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode32" />
			<text x="6in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges32" />
			<text x="7in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments32" />
			</g><g>
			<text x="0.5in" y="8.23in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID33" />
			<text x="1.25in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService33" />
			<text x="2.25in" y="8.23in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName33" />
			<text x="4.5in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode33" />
			<text x="6in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges33" />
			<text x="7in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments33" />
			</g><g>
			<text x="0.5in" y="8.38in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID34" />
			<text x="1.25in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService34" />
			<text x="2.25in" y="8.38in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName34" />
			<text x="4.5in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode34" />
			<text x="6in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges34" />
			<text x="7in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments34" />
			</g><g>
			<text x="0.5in" y="8.53in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID35" />
			<text x="1.25in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService35" />
			<text x="2.25in" y="8.53in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName35" />
			<text x="4.5in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode35" />
			<text x="6in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges35" />
			<text x="7in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments35" />
			</g><g>
			<text x="0.5in" y="8.68in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID36" />
			<text x="1.25in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService36" />
			<text x="2.25in" y="8.68in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName36" />
			<text x="4.5in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode36" />
			<text x="6in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges36" />
			<text x="7in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments36" />
			</g><g>
			<text x="0.5in" y="8.83in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID37" />
			<text x="1.25in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService37" />
			<text x="2.25in" y="8.83in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName37" />
			<text x="4.5in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode37" />
			<text x="6in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges37" />
			<text x="7in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments37" />
			</g><g>
			<text x="0.5in" y="8.98in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID38" />
			<text x="1.25in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService38" />
			<text x="2.25in" y="8.98in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName38" />
			<text x="4.5in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode38" />
			<text x="6in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges38" />
			<text x="7in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments38" />
			</g><g>
			<text x="0.5in" y="9.13in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID39" />
			<text x="1.25in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService39" />
			<text x="2.25in" y="9.13in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName39" />
			<text x="4.5in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode39" />
			<text x="6in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges39" />
			<text x="7in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments39" />
			</g><g>
			<text x="0.5in" y="9.28in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID40" />
			<text x="1.25in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService40" />
			<text x="2.25in" y="9.28in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName40" />
			<text x="4.5in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode40" />
			<text x="6in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges40" />
			<text x="7in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments40" />
			</g><g>
			<text x="0.5in" y="9.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID41" />
			<text x="1.25in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService41" />
			<text x="2.25in" y="9.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName41" />
			<text x="4.5in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode41" />
			<text x="6in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges41" />
			<text x="7in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments41" />
			</g><g>
			<text x="0.5in" y="9.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID42" />
			<text x="1.25in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService42" />
			<text x="2.25in" y="9.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName42" />
			<text x="4.5in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode42" />
			<text x="6in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges42" />
			<text x="7in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments42" />
			</g><g>
			<text x="0.5in" y="9.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID43" />
			<text x="1.25in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService43" />
			<text x="2.25in" y="9.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName43" />
			<text x="4.5in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode43" />
			<text x="6in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges43" />
			<text x="7in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments43" />
			</g><g>
			<text x="0.5in" y="9.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID44" />
			<text x="1.25in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService44" />
			<text x="2.25in" y="9.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName44" />
			<text x="4.5in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode44" />
			<text x="6in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges44" />
			<text x="7in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments44" />
			</g><g>
			<text x="0.5in" y="10.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID45" />
			<text x="1.25in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService45" />
			<text x="2.25in" y="10.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName45" />
			<text x="4.5in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode45" />
			<text x="6in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges45" />
			<text x="7in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments45" />

			</g>
		</g>
	
	</g>

</svg>'
	)

--------------------------------------------------------------------------------------
-- Add the IOC (Middle Page)
--------------------------------------------------------------------------------------

INSERT	PrintingFormDetails(
		PrintingFormDetailsID,
		PrintingFormID,
		SVGDefinitionID,
		Description,
		SVGDefinition
	)
VALUES	(	5,
		3,
		3,
		'IOC (Middle Page)', 
		'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="IOC" pageId="IOC.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css"><![CDATA[

			g {
				font-family: Times New Roman,Courier New;
				font-size: 10pt;
				font-style: normal;
				font-weight: normal;
				alignment-baseline: text-before-edge;
			}

			text
			{
				baseline-shift: -100%;
			}
			
			text.header
			{
				font-weight: bold;
				font-size: 14pt;
				text-anchor: middle;
			}
			
			rect.test
			{
				fill: black;
				opacity: 0.4;
			}
			
			g.lines
			{
				stroke: black;
				stroke-width: 0.01in;
			}
			
			g#formListFooter, g#formFooter
			{
				font-weight: bold;
			}
			
			
			g#data g#dataLines
			{
				font-size: 9pt;
			}

			]]>
		</style>
	</defs>
	
	<!-- This is the one-page itemization of charges form -->

	<g id="formBackground">
	
		<g id="formListHeader">
			<text x="0.50in" y="0.50in" width="0.70in" height="0.1in">Visit #</text>
			<text x="1.25in" y="0.50in" width="0.95in" height="0.1in">Date of Service</text>
			<text x="2.25in" y="0.50in" width="2.20in" height="0.1in">Procedure Description</text>
			<text x="4.50in" y="0.50in" width="0.95in" height="0.1in">Code</text>
			<text x="6.00in" y="0.50in" width="0.95in" height="0.1in">Charge</text>
			<text x="7.00in" y="0.50in" width="0.95in" height="0.1in">Payment</text>
			
			<g class="lines">
				<line x1="0.50in" y1="0.70in" x2="1.20in" y2="0.70in" />
				<line x1="1.25in" y1="0.70in" x2="2.20in" y2="0.70in" />
				<line x1="2.25in" y1="0.70in" x2="4.45in" y2="0.70in" />
				<line x1="4.50in" y1="0.70in" x2="5.95in" y2="0.70in" />
				<line x1="6.00in" y1="0.70in" x2="6.95in" y2="0.70in" />
				<line x1="7.00in" y1="0.70in" x2="7.95in" y2="0.70in" />
			</g>
		</g>
		
		<g id="formFooter">
			<text x="7.00in" y="10.40in" width="0.5in" height="0.1in">Page #:</text>
			<text x="7.8in" y="10.40in" width="0.2in" height="0.1in">of</text>
		</g>
	</g>
	
	<g id="data">
	
		<g id="dataFooter">
			<text x="7.48in" y="10.40in" width="0.36in" height="0.1in" valueSource="IOC.1.PageNo1" />
			<text x="7.95in" y="10.40in" width="0.36in" height="0.1in" valueSource="IOC.1.ofPages1" />
		</g>
		
		<g id="dataLines">
			<g>
			<text x="0.5in" y="0.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID1" />
			<text x="1.25in" y="0.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService1" />
			<text x="2.25in" y="0.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName1" />
			<text x="4.5in" y="0.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode1" />
			<text x="6in" y="0.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges1" />
			<text x="7in" y="0.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments1" />
			</g><g>
			<text x="0.5in" y="0.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID2" />
			<text x="1.25in" y="0.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService2" />
			<text x="2.25in" y="0.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName2" />
			<text x="4.5in" y="0.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode2" />
			<text x="6in" y="0.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges2" />
			<text x="7in" y="0.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments2" />
			</g><g>
			<text x="0.5in" y="1.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID3" />
			<text x="1.25in" y="1.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService3" />
			<text x="2.25in" y="1.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName3" />
			<text x="4.5in" y="1.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode3" />
			<text x="6in" y="1.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges3" />
			<text x="7in" y="1.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments3" />
			</g><g>
			<text x="0.5in" y="1.18in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID4" />
			<text x="1.25in" y="1.18in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService4" />
			<text x="2.25in" y="1.18in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName4" />
			<text x="4.5in" y="1.18in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode4" />
			<text x="6in" y="1.18in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges4" />
			<text x="7in" y="1.18in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments4" />
			</g><g>
			<text x="0.5in" y="1.33in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID5" />
			<text x="1.25in" y="1.33in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService5" />
			<text x="2.25in" y="1.33in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName5" />
			<text x="4.5in" y="1.33in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode5" />
			<text x="6in" y="1.33in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges5" />
			<text x="7in" y="1.33in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments5" />
			</g><g>
			<text x="0.5in" y="1.48in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID6" />
			<text x="1.25in" y="1.48in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService6" />
			<text x="2.25in" y="1.48in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName6" />
			<text x="4.5in" y="1.48in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode6" />
			<text x="6in" y="1.48in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges6" />
			<text x="7in" y="1.48in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments6" />
			</g><g>
			<text x="0.5in" y="1.63in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID7" />
			<text x="1.25in" y="1.63in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService7" />
			<text x="2.25in" y="1.63in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName7" />
			<text x="4.5in" y="1.63in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode7" />
			<text x="6in" y="1.63in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges7" />
			<text x="7in" y="1.63in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments7" />
			</g><g>
			<text x="0.5in" y="1.78in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID8" />
			<text x="1.25in" y="1.78in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService8" />
			<text x="2.25in" y="1.78in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName8" />
			<text x="4.5in" y="1.78in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode8" />
			<text x="6in" y="1.78in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges8" />
			<text x="7in" y="1.78in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments8" />
			</g><g>
			<text x="0.5in" y="1.93in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID9" />
			<text x="1.25in" y="1.93in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService9" />
			<text x="2.25in" y="1.93in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName9" />
			<text x="4.5in" y="1.93in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode9" />
			<text x="6in" y="1.93in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges9" />
			<text x="7in" y="1.93in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments9" />
			</g><g>
			<text x="0.5in" y="2.08in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID10" />
			<text x="1.25in" y="2.08in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService10" />
			<text x="2.25in" y="2.08in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName10" />
			<text x="4.5in" y="2.08in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode10" />
			<text x="6in" y="2.08in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges10" />
			<text x="7in" y="2.08in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments10" />
			</g><g>
			<text x="0.5in" y="2.23in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID11" />
			<text x="1.25in" y="2.23in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService11" />
			<text x="2.25in" y="2.23in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName11" />
			<text x="4.5in" y="2.23in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode11" />
			<text x="6in" y="2.23in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges11" />
			<text x="7in" y="2.23in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments11" />
			</g><g>
			<text x="0.5in" y="2.38in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID12" />
			<text x="1.25in" y="2.38in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService12" />
			<text x="2.25in" y="2.38in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName12" />
			<text x="4.5in" y="2.38in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode12" />
			<text x="6in" y="2.38in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges12" />
			<text x="7in" y="2.38in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments12" />
			</g><g>
			<text x="0.5in" y="2.53in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID13" />
			<text x="1.25in" y="2.53in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService13" />
			<text x="2.25in" y="2.53in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName13" />
			<text x="4.5in" y="2.53in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode13" />
			<text x="6in" y="2.53in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges13" />
			<text x="7in" y="2.53in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments13" />
			</g><g>
			<text x="0.5in" y="2.68in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID14" />
			<text x="1.25in" y="2.68in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService14" />
			<text x="2.25in" y="2.68in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName14" />
			<text x="4.5in" y="2.68in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode14" />
			<text x="6in" y="2.68in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges14" />
			<text x="7in" y="2.68in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments14" />
			</g><g>
			<text x="0.5in" y="2.83in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID15" />
			<text x="1.25in" y="2.83in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService15" />
			<text x="2.25in" y="2.83in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName15" />
			<text x="4.5in" y="2.83in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode15" />
			<text x="6in" y="2.83in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges15" />
			<text x="7in" y="2.83in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments15" />
			</g><g>
			<text x="0.5in" y="2.98in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID16" />
			<text x="1.25in" y="2.98in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService16" />
			<text x="2.25in" y="2.98in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName16" />
			<text x="4.5in" y="2.98in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode16" />
			<text x="6in" y="2.98in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges16" />
			<text x="7in" y="2.98in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments16" />
			</g><g>
			<text x="0.5in" y="3.13in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID17" />
			<text x="1.25in" y="3.13in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService17" />
			<text x="2.25in" y="3.13in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName17" />
			<text x="4.5in" y="3.13in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode17" />
			<text x="6in" y="3.13in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges17" />
			<text x="7in" y="3.13in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments17" />
			</g><g>
			<text x="0.5in" y="3.28in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID18" />
			<text x="1.25in" y="3.28in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService18" />
			<text x="2.25in" y="3.28in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName18" />
			<text x="4.5in" y="3.28in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode18" />
			<text x="6in" y="3.28in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges18" />
			<text x="7in" y="3.28in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments18" />
			</g><g>
			<text x="0.5in" y="3.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID19" />
			<text x="1.25in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService19" />
			<text x="2.25in" y="3.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName19" />
			<text x="4.5in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode19" />
			<text x="6in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges19" />
			<text x="7in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments19" />
			</g><g>
			<text x="0.5in" y="3.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID20" />
			<text x="1.25in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService20" />
			<text x="2.25in" y="3.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName20" />
			<text x="4.5in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode20" />
			<text x="6in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges20" />
			<text x="7in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments20" />
			</g><g>
			<text x="0.5in" y="3.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID21" />
			<text x="1.25in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService21" />
			<text x="2.25in" y="3.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName21" />
			<text x="4.5in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode21" />
			<text x="6in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges21" />
			<text x="7in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments21" />
			</g><g>
			<text x="0.5in" y="3.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID22" />
			<text x="1.25in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService22" />
			<text x="2.25in" y="3.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName22" />
			<text x="4.5in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode22" />
			<text x="6in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges22" />
			<text x="7in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments22" />
			</g><g>
			<text x="0.5in" y="4.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID23" />
			<text x="1.25in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService23" />
			<text x="2.25in" y="4.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName23" />
			<text x="4.5in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode23" />
			<text x="6in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges23" />
			<text x="7in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments23" />
			</g><g>
			<text x="0.5in" y="4.18in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID24" />
			<text x="1.25in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService24" />
			<text x="2.25in" y="4.18in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName24" />
			<text x="4.5in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode24" />
			<text x="6in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges24" />
			<text x="7in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments24" />
			</g><g>
			<text x="0.5in" y="4.33in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID25" />
			<text x="1.25in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService25" />
			<text x="2.25in" y="4.33in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName25" />
			<text x="4.5in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode25" />
			<text x="6in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges25" />
			<text x="7in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments25" />
			</g><g>
			<text x="0.5in" y="4.48in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID26" />
			<text x="1.25in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService26" />
			<text x="2.25in" y="4.48in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName26" />
			<text x="4.5in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode26" />
			<text x="6in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges26" />
			<text x="7in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments26" />
			</g><g>
			<text x="0.5in" y="4.63in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID27" />
			<text x="1.25in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService27" />
			<text x="2.25in" y="4.63in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName27" />
			<text x="4.5in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode27" />
			<text x="6in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges27" />
			<text x="7in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments27" />
			</g><g>
			<text x="0.5in" y="4.78in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID28" />
			<text x="1.25in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService28" />
			<text x="2.25in" y="4.78in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName28" />
			<text x="4.5in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode28" />
			<text x="6in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges28" />
			<text x="7in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments28" />
			</g><g>
			<text x="0.5in" y="4.93in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID29" />
			<text x="1.25in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService29" />
			<text x="2.25in" y="4.93in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName29" />
			<text x="4.5in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode29" />
			<text x="6in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges29" />
			<text x="7in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments29" />
			</g><g>
			<text x="0.5in" y="5.08in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID30" />
			<text x="1.25in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService30" />
			<text x="2.25in" y="5.08in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName30" />
			<text x="4.5in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode30" />
			<text x="6in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges30" />
			<text x="7in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments30" />
			</g><g>
			<text x="0.5in" y="5.23in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID31" />
			<text x="1.25in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService31" />
			<text x="2.25in" y="5.23in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName31" />
			<text x="4.5in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode31" />
			<text x="6in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges31" />
			<text x="7in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments31" />
			</g><g>
			<text x="0.5in" y="5.38in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID32" />
			<text x="1.25in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService32" />
			<text x="2.25in" y="5.38in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName32" />
			<text x="4.5in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode32" />
			<text x="6in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges32" />
			<text x="7in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments32" />
			</g><g>
			<text x="0.5in" y="5.53in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID33" />
			<text x="1.25in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService33" />
			<text x="2.25in" y="5.53in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName33" />
			<text x="4.5in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode33" />
			<text x="6in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges33" />
			<text x="7in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments33" />
			</g><g>
			<text x="0.5in" y="5.68in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID34" />
			<text x="1.25in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService34" />
			<text x="2.25in" y="5.68in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName34" />
			<text x="4.5in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode34" />
			<text x="6in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges34" />
			<text x="7in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments34" />
			</g><g>
			<text x="0.5in" y="5.83in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID35" />
			<text x="1.25in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService35" />
			<text x="2.25in" y="5.83in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName35" />
			<text x="4.5in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode35" />
			<text x="6in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges35" />
			<text x="7in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments35" />
			</g><g>
			<text x="0.5in" y="5.98in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID36" />
			<text x="1.25in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService36" />
			<text x="2.25in" y="5.98in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName36" />
			<text x="4.5in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode36" />
			<text x="6in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges36" />
			<text x="7in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments36" />
			</g><g>
			<text x="0.5in" y="6.13in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID37" />
			<text x="1.25in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService37" />
			<text x="2.25in" y="6.13in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName37" />
			<text x="4.5in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode37" />
			<text x="6in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges37" />
			<text x="7in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments37" />
			</g><g>
			<text x="0.5in" y="6.28in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID38" />
			<text x="1.25in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService38" />
			<text x="2.25in" y="6.28in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName38" />
			<text x="4.5in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode38" />
			<text x="6in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges38" />
			<text x="7in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments38" />
			</g><g>
			<text x="0.5in" y="6.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID39" />
			<text x="1.25in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService39" />
			<text x="2.25in" y="6.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName39" />
			<text x="4.5in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode39" />
			<text x="6in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges39" />
			<text x="7in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments39" />
			</g><g>
			<text x="0.5in" y="6.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID40" />
			<text x="1.25in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService40" />
			<text x="2.25in" y="6.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName40" />
			<text x="4.5in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode40" />
			<text x="6in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges40" />
			<text x="7in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments40" />
			</g><g>
			<text x="0.5in" y="6.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID41" />
			<text x="1.25in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService41" />
			<text x="2.25in" y="6.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName41" />
			<text x="4.5in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode41" />
			<text x="6in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges41" />
			<text x="7in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments41" />
			</g><g>
			<text x="0.5in" y="6.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID42" />
			<text x="1.25in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService42" />
			<text x="2.25in" y="6.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName42" />
			<text x="4.5in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode42" />
			<text x="6in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges42" />
			<text x="7in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments42" />
			</g><g>
			<text x="0.5in" y="7.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID43" />
			<text x="1.25in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService43" />
			<text x="2.25in" y="7.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName43" />
			<text x="4.5in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode43" />
			<text x="6in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges43" />
			<text x="7in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments43" />
			</g><g>
			<text x="0.5in" y="7.18in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID44" />
			<text x="1.25in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService44" />
			<text x="2.25in" y="7.18in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName44" />
			<text x="4.5in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode44" />
			<text x="6in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges44" />
			<text x="7in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments44" />
			</g><g>
			<text x="0.5in" y="7.33in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID45" />
			<text x="1.25in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService45" />
			<text x="2.25in" y="7.33in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName45" />
			<text x="4.5in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode45" />
			<text x="6in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges45" />
			<text x="7in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments45" />
			</g><g>
			<text x="0.5in" y="7.48in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID46" />
			<text x="1.25in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService46" />
			<text x="2.25in" y="7.48in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName46" />
			<text x="4.5in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode46" />
			<text x="6in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges46" />
			<text x="7in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments46" />
			</g><g>
			<text x="0.5in" y="7.63in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID47" />
			<text x="1.25in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService47" />
			<text x="2.25in" y="7.63in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName47" />
			<text x="4.5in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode47" />
			<text x="6in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges47" />
			<text x="7in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments47" />
			</g><g>
			<text x="0.5in" y="7.78in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID48" />
			<text x="1.25in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService48" />
			<text x="2.25in" y="7.78in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName48" />
			<text x="4.5in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode48" />
			<text x="6in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges48" />
			<text x="7in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments48" />
			</g><g>
			<text x="0.5in" y="7.93in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID49" />
			<text x="1.25in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService49" />
			<text x="2.25in" y="7.93in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName49" />
			<text x="4.5in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode49" />
			<text x="6in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges49" />
			<text x="7in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments49" />
			</g><g>
			<text x="0.5in" y="8.08in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID50" />
			<text x="1.25in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService50" />
			<text x="2.25in" y="8.08in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName50" />
			<text x="4.5in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode50" />
			<text x="6in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges50" />
			<text x="7in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments50" />
			</g><g>
			<text x="0.5in" y="8.23in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID51" />
			<text x="1.25in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService51" />
			<text x="2.25in" y="8.23in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName51" />
			<text x="4.5in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode51" />
			<text x="6in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges51" />
			<text x="7in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments51" />
			</g><g>
			<text x="0.5in" y="8.38in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID52" />
			<text x="1.25in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService52" />
			<text x="2.25in" y="8.38in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName52" />
			<text x="4.5in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode52" />
			<text x="6in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges52" />
			<text x="7in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments52" />
			</g><g>
			<text x="0.5in" y="8.53in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID53" />
			<text x="1.25in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService53" />
			<text x="2.25in" y="8.53in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName53" />
			<text x="4.5in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode53" />
			<text x="6in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges53" />
			<text x="7in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments53" />
			</g><g>
			<text x="0.5in" y="8.68in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID54" />
			<text x="1.25in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService54" />
			<text x="2.25in" y="8.68in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName54" />
			<text x="4.5in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode54" />
			<text x="6in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges54" />
			<text x="7in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments54" />
			</g><g>
			<text x="0.5in" y="8.83in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID55" />
			<text x="1.25in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService55" />
			<text x="2.25in" y="8.83in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName55" />
			<text x="4.5in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode55" />
			<text x="6in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges55" />
			<text x="7in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments55" />
			</g><g>
			<text x="0.5in" y="8.98in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID56" />
			<text x="1.25in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService56" />
			<text x="2.25in" y="8.98in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName56" />
			<text x="4.5in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode56" />
			<text x="6in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges56" />
			<text x="7in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments56" />
			</g><g>
			<text x="0.5in" y="9.13in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID57" />
			<text x="1.25in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService57" />
			<text x="2.25in" y="9.13in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName57" />
			<text x="4.5in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode57" />
			<text x="6in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges57" />
			<text x="7in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments57" />
			</g><g>
			<text x="0.5in" y="9.28in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID58" />
			<text x="1.25in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService58" />
			<text x="2.25in" y="9.28in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName58" />
			<text x="4.5in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode58" />
			<text x="6in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges58" />
			<text x="7in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments58" />
			</g><g>
			<text x="0.5in" y="9.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID59" />
			<text x="1.25in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService59" />
			<text x="2.25in" y="9.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName59" />
			<text x="4.5in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode59" />
			<text x="6in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges59" />
			<text x="7in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments59" />
			</g><g>
			<text x="0.5in" y="9.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID60" />
			<text x="1.25in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService60" />
			<text x="2.25in" y="9.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName60" />
			<text x="4.5in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode60" />
			<text x="6in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges60" />
			<text x="7in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments60" />
			</g><g>
			<text x="0.5in" y="9.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID61" />
			<text x="1.25in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService61" />
			<text x="2.25in" y="9.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName61" />
			<text x="4.5in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode61" />
			<text x="6in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges61" />
			<text x="7in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments61" />
			</g><g>
			<text x="0.5in" y="9.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID62" />
			<text x="1.25in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService62" />
			<text x="2.25in" y="9.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName62" />
			<text x="4.5in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode62" />
			<text x="6in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges62" />
			<text x="7in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments62" />
			</g><g>
			<text x="0.5in" y="10.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID63" />
			<text x="1.25in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService63" />
			<text x="2.25in" y="10.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName63" />
			<text x="4.5in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode63" />
			<text x="6in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges63" />
			<text x="7in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments63" />

			</g>
		</g>
	
	</g>

</svg>'
	)

--------------------------------------------------------------------------------------
-- Add the IOC (Last Page)
--------------------------------------------------------------------------------------

INSERT	PrintingFormDetails(
		PrintingFormDetailsID,
		PrintingFormID,
		SVGDefinitionID,
		Description,
		SVGDefinition
	)
VALUES	(	6,
		3,
		4,
		'IOC (Last Page)', 
		'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="IOC" pageId="IOC.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css"><![CDATA[

			g {
				font-family: Times New Roman,Courier New;
				font-size: 10pt;
				font-style: normal;
				font-weight: normal;
				alignment-baseline: text-before-edge;
			}

			text
			{
				baseline-shift: -100%;
			}
			
			text.header
			{
				font-weight: bold;
				font-size: 14pt;
				text-anchor: middle;
			}
			
			rect.test
			{
				fill: black;
				opacity: 0.4;
			}
			
			g.lines
			{
				stroke: black;
				stroke-width: 0.01in;
			}
			
			g#formListFooter, g#formFooter
			{
				font-weight: bold;
			}
			
			
			g#data g#dataLines
			{
				font-size: 9pt;
			}

			]]>
		</style>
	</defs>
	
	<!-- This is the one-page itemization of charges form -->

	<g id="formBackground">
	
		<g id="formListHeader">
			<text x="0.50in" y="0.50in" width="0.70in" height="0.1in">Visit #</text>
			<text x="1.25in" y="0.50in" width="0.95in" height="0.1in">Date of Service</text>
			<text x="2.25in" y="0.50in" width="2.20in" height="0.1in">Procedure Description</text>
			<text x="4.50in" y="0.50in" width="0.95in" height="0.1in">Code</text>
			<text x="6.00in" y="0.50in" width="0.95in" height="0.1in">Charge</text>
			<text x="7.00in" y="0.50in" width="0.95in" height="0.1in">Payment</text>
			
			<g class="lines">
				<line x1="0.50in" y1="0.70in" x2="1.20in" y2="0.70in" />
				<line x1="1.25in" y1="0.70in" x2="2.20in" y2="0.70in" />
				<line x1="2.25in" y1="0.70in" x2="4.45in" y2="0.70in" />
				<line x1="4.50in" y1="0.70in" x2="5.95in" y2="0.70in" />
				<line x1="6.00in" y1="0.70in" x2="6.95in" y2="0.70in" />
				<line x1="7.00in" y1="0.70in" x2="7.95in" y2="0.70in" />
			</g>
		</g>
		
		<g id="formListFooter">
			<g class="lines">
				<line x1="0.50in" y1="10.20in" x2="1.20in" y2="10.20in" />
				<line x1="1.25in" y1="10.20in" x2="2.20in" y2="10.20in" />
				<line x1="2.25in" y1="10.20in" x2="4.45in" y2="10.20in" />
				<line x1="4.50in" y1="10.20in" x2="5.95in" y2="10.20in" />
				<line x1="6.00in" y1="10.20in" x2="6.95in" y2="10.20in" />
				<line x1="7.00in" y1="10.20in" x2="7.95in" y2="10.20in" />
			</g>
			
			<text x="0.50in" y="10.21in" width="1in" height="0.1in">TOTAL</text>
			
		</g>
		
		<g id="formFooter">
			<text x="0.50in" y="10.40in" width="1in" height="0.1in">Balance Due:</text>
			<text x="7.00in" y="10.40in" width="0.5in" height="0.1in">Page #:</text>
			<text x="7.8in" y="10.40in" width="0.2in" height="0.1in">of</text>
		</g>
	</g>
	
	<g id="data">
	
		<g id="dataFooter">
			<text x="6.00in" y="10.21in" width="0.95in" height="0.1in" valueSource="IOC.1.TotalAdjustedCharge1" />
			<text x="7.00in" y="10.21in" width="0.95in" height="0.1in" valueSource="IOC.1.TotalPayment1" />
			<text x="1.50in" y="10.40in" width="0.95in" height="0.1in" valueSource="IOC.1.BalanceDue1" />
			<text x="7.48in" y="10.40in" width="0.36in" height="0.1in" valueSource="IOC.1.PageNo1" />
			<text x="7.95in" y="10.40in" width="0.36in" height="0.1in" valueSource="IOC.1.ofPages1" />
		</g>
		
		<g id="dataLines">
			<g>
			<text x="0.5in" y="0.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID1" />
			<text x="1.25in" y="0.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService1" />
			<text x="2.25in" y="0.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName1" />
			<text x="4.5in" y="0.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode1" />
			<text x="6in" y="0.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges1" />
			<text x="7in" y="0.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments1" />
			</g><g>
			<text x="0.5in" y="0.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID2" />
			<text x="1.25in" y="0.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService2" />
			<text x="2.25in" y="0.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName2" />
			<text x="4.5in" y="0.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode2" />
			<text x="6in" y="0.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges2" />
			<text x="7in" y="0.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments2" />
			</g><g>
			<text x="0.5in" y="1.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID3" />
			<text x="1.25in" y="1.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService3" />
			<text x="2.25in" y="1.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName3" />
			<text x="4.5in" y="1.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode3" />
			<text x="6in" y="1.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges3" />
			<text x="7in" y="1.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments3" />
			</g><g>
			<text x="0.5in" y="1.18in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID4" />
			<text x="1.25in" y="1.18in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService4" />
			<text x="2.25in" y="1.18in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName4" />
			<text x="4.5in" y="1.18in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode4" />
			<text x="6in" y="1.18in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges4" />
			<text x="7in" y="1.18in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments4" />
			</g><g>
			<text x="0.5in" y="1.33in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID5" />
			<text x="1.25in" y="1.33in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService5" />
			<text x="2.25in" y="1.33in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName5" />
			<text x="4.5in" y="1.33in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode5" />
			<text x="6in" y="1.33in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges5" />
			<text x="7in" y="1.33in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments5" />
			</g><g>
			<text x="0.5in" y="1.48in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID6" />
			<text x="1.25in" y="1.48in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService6" />
			<text x="2.25in" y="1.48in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName6" />
			<text x="4.5in" y="1.48in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode6" />
			<text x="6in" y="1.48in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges6" />
			<text x="7in" y="1.48in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments6" />
			</g><g>
			<text x="0.5in" y="1.63in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID7" />
			<text x="1.25in" y="1.63in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService7" />
			<text x="2.25in" y="1.63in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName7" />
			<text x="4.5in" y="1.63in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode7" />
			<text x="6in" y="1.63in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges7" />
			<text x="7in" y="1.63in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments7" />
			</g><g>
			<text x="0.5in" y="1.78in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID8" />
			<text x="1.25in" y="1.78in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService8" />
			<text x="2.25in" y="1.78in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName8" />
			<text x="4.5in" y="1.78in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode8" />
			<text x="6in" y="1.78in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges8" />
			<text x="7in" y="1.78in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments8" />
			</g><g>
			<text x="0.5in" y="1.93in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID9" />
			<text x="1.25in" y="1.93in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService9" />
			<text x="2.25in" y="1.93in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName9" />
			<text x="4.5in" y="1.93in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode9" />
			<text x="6in" y="1.93in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges9" />
			<text x="7in" y="1.93in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments9" />
			</g><g>
			<text x="0.5in" y="2.08in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID10" />
			<text x="1.25in" y="2.08in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService10" />
			<text x="2.25in" y="2.08in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName10" />
			<text x="4.5in" y="2.08in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode10" />
			<text x="6in" y="2.08in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges10" />
			<text x="7in" y="2.08in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments10" />
			</g><g>
			<text x="0.5in" y="2.23in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID11" />
			<text x="1.25in" y="2.23in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService11" />
			<text x="2.25in" y="2.23in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName11" />
			<text x="4.5in" y="2.23in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode11" />
			<text x="6in" y="2.23in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges11" />
			<text x="7in" y="2.23in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments11" />
			</g><g>
			<text x="0.5in" y="2.38in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID12" />
			<text x="1.25in" y="2.38in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService12" />
			<text x="2.25in" y="2.38in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName12" />
			<text x="4.5in" y="2.38in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode12" />
			<text x="6in" y="2.38in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges12" />
			<text x="7in" y="2.38in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments12" />
			</g><g>
			<text x="0.5in" y="2.53in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID13" />
			<text x="1.25in" y="2.53in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService13" />
			<text x="2.25in" y="2.53in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName13" />
			<text x="4.5in" y="2.53in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode13" />
			<text x="6in" y="2.53in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges13" />
			<text x="7in" y="2.53in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments13" />
			</g><g>
			<text x="0.5in" y="2.68in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID14" />
			<text x="1.25in" y="2.68in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService14" />
			<text x="2.25in" y="2.68in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName14" />
			<text x="4.5in" y="2.68in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode14" />
			<text x="6in" y="2.68in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges14" />
			<text x="7in" y="2.68in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments14" />
			</g><g>
			<text x="0.5in" y="2.83in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID15" />
			<text x="1.25in" y="2.83in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService15" />
			<text x="2.25in" y="2.83in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName15" />
			<text x="4.5in" y="2.83in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode15" />
			<text x="6in" y="2.83in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges15" />
			<text x="7in" y="2.83in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments15" />
			</g><g>
			<text x="0.5in" y="2.98in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID16" />
			<text x="1.25in" y="2.98in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService16" />
			<text x="2.25in" y="2.98in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName16" />
			<text x="4.5in" y="2.98in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode16" />
			<text x="6in" y="2.98in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges16" />
			<text x="7in" y="2.98in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments16" />
			</g><g>
			<text x="0.5in" y="3.13in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID17" />
			<text x="1.25in" y="3.13in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService17" />
			<text x="2.25in" y="3.13in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName17" />
			<text x="4.5in" y="3.13in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode17" />
			<text x="6in" y="3.13in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges17" />
			<text x="7in" y="3.13in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments17" />
			</g><g>
			<text x="0.5in" y="3.28in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID18" />
			<text x="1.25in" y="3.28in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService18" />
			<text x="2.25in" y="3.28in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName18" />
			<text x="4.5in" y="3.28in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode18" />
			<text x="6in" y="3.28in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges18" />
			<text x="7in" y="3.28in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments18" />
			</g><g>
			<text x="0.5in" y="3.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID19" />
			<text x="1.25in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService19" />
			<text x="2.25in" y="3.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName19" />
			<text x="4.5in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode19" />
			<text x="6in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges19" />
			<text x="7in" y="3.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments19" />
			</g><g>
			<text x="0.5in" y="3.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID20" />
			<text x="1.25in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService20" />
			<text x="2.25in" y="3.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName20" />
			<text x="4.5in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode20" />
			<text x="6in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges20" />
			<text x="7in" y="3.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments20" />
			</g><g>
			<text x="0.5in" y="3.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID21" />
			<text x="1.25in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService21" />
			<text x="2.25in" y="3.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName21" />
			<text x="4.5in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode21" />
			<text x="6in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges21" />
			<text x="7in" y="3.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments21" />
			</g><g>
			<text x="0.5in" y="3.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID22" />
			<text x="1.25in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService22" />
			<text x="2.25in" y="3.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName22" />
			<text x="4.5in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode22" />
			<text x="6in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges22" />
			<text x="7in" y="3.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments22" />
			</g><g>
			<text x="0.5in" y="4.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID23" />
			<text x="1.25in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService23" />
			<text x="2.25in" y="4.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName23" />
			<text x="4.5in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode23" />
			<text x="6in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges23" />
			<text x="7in" y="4.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments23" />
			</g><g>
			<text x="0.5in" y="4.18in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID24" />
			<text x="1.25in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService24" />
			<text x="2.25in" y="4.18in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName24" />
			<text x="4.5in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode24" />
			<text x="6in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges24" />
			<text x="7in" y="4.18in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments24" />
			</g><g>
			<text x="0.5in" y="4.33in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID25" />
			<text x="1.25in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService25" />
			<text x="2.25in" y="4.33in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName25" />
			<text x="4.5in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode25" />
			<text x="6in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges25" />
			<text x="7in" y="4.33in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments25" />
			</g><g>
			<text x="0.5in" y="4.48in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID26" />
			<text x="1.25in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService26" />
			<text x="2.25in" y="4.48in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName26" />
			<text x="4.5in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode26" />
			<text x="6in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges26" />
			<text x="7in" y="4.48in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments26" />
			</g><g>
			<text x="0.5in" y="4.63in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID27" />
			<text x="1.25in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService27" />
			<text x="2.25in" y="4.63in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName27" />
			<text x="4.5in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode27" />
			<text x="6in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges27" />
			<text x="7in" y="4.63in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments27" />
			</g><g>
			<text x="0.5in" y="4.78in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID28" />
			<text x="1.25in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService28" />
			<text x="2.25in" y="4.78in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName28" />
			<text x="4.5in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode28" />
			<text x="6in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges28" />
			<text x="7in" y="4.78in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments28" />
			</g><g>
			<text x="0.5in" y="4.93in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID29" />
			<text x="1.25in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService29" />
			<text x="2.25in" y="4.93in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName29" />
			<text x="4.5in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode29" />
			<text x="6in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges29" />
			<text x="7in" y="4.93in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments29" />
			</g><g>
			<text x="0.5in" y="5.08in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID30" />
			<text x="1.25in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService30" />
			<text x="2.25in" y="5.08in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName30" />
			<text x="4.5in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode30" />
			<text x="6in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges30" />
			<text x="7in" y="5.08in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments30" />
			</g><g>
			<text x="0.5in" y="5.23in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID31" />
			<text x="1.25in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService31" />
			<text x="2.25in" y="5.23in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName31" />
			<text x="4.5in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode31" />
			<text x="6in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges31" />
			<text x="7in" y="5.23in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments31" />
			</g><g>
			<text x="0.5in" y="5.38in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID32" />
			<text x="1.25in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService32" />
			<text x="2.25in" y="5.38in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName32" />
			<text x="4.5in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode32" />
			<text x="6in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges32" />
			<text x="7in" y="5.38in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments32" />
			</g><g>
			<text x="0.5in" y="5.53in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID33" />
			<text x="1.25in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService33" />
			<text x="2.25in" y="5.53in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName33" />
			<text x="4.5in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode33" />
			<text x="6in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges33" />
			<text x="7in" y="5.53in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments33" />
			</g><g>
			<text x="0.5in" y="5.68in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID34" />
			<text x="1.25in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService34" />
			<text x="2.25in" y="5.68in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName34" />
			<text x="4.5in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode34" />
			<text x="6in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges34" />
			<text x="7in" y="5.68in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments34" />
			</g><g>
			<text x="0.5in" y="5.83in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID35" />
			<text x="1.25in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService35" />
			<text x="2.25in" y="5.83in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName35" />
			<text x="4.5in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode35" />
			<text x="6in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges35" />
			<text x="7in" y="5.83in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments35" />
			</g><g>
			<text x="0.5in" y="5.98in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID36" />
			<text x="1.25in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService36" />
			<text x="2.25in" y="5.98in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName36" />
			<text x="4.5in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode36" />
			<text x="6in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges36" />
			<text x="7in" y="5.98in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments36" />
			</g><g>
			<text x="0.5in" y="6.13in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID37" />
			<text x="1.25in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService37" />
			<text x="2.25in" y="6.13in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName37" />
			<text x="4.5in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode37" />
			<text x="6in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges37" />
			<text x="7in" y="6.13in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments37" />
			</g><g>
			<text x="0.5in" y="6.28in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID38" />
			<text x="1.25in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService38" />
			<text x="2.25in" y="6.28in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName38" />
			<text x="4.5in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode38" />
			<text x="6in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges38" />
			<text x="7in" y="6.28in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments38" />
			</g><g>
			<text x="0.5in" y="6.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID39" />
			<text x="1.25in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService39" />
			<text x="2.25in" y="6.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName39" />
			<text x="4.5in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode39" />
			<text x="6in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges39" />
			<text x="7in" y="6.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments39" />
			</g><g>
			<text x="0.5in" y="6.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID40" />
			<text x="1.25in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService40" />
			<text x="2.25in" y="6.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName40" />
			<text x="4.5in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode40" />
			<text x="6in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges40" />
			<text x="7in" y="6.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments40" />
			</g><g>
			<text x="0.5in" y="6.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID41" />
			<text x="1.25in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService41" />
			<text x="2.25in" y="6.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName41" />
			<text x="4.5in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode41" />
			<text x="6in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges41" />
			<text x="7in" y="6.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments41" />
			</g><g>
			<text x="0.5in" y="6.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID42" />
			<text x="1.25in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService42" />
			<text x="2.25in" y="6.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName42" />
			<text x="4.5in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode42" />
			<text x="6in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges42" />
			<text x="7in" y="6.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments42" />
			</g><g>
			<text x="0.5in" y="7.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID43" />
			<text x="1.25in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService43" />
			<text x="2.25in" y="7.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName43" />
			<text x="4.5in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode43" />
			<text x="6in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges43" />
			<text x="7in" y="7.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments43" />
			</g><g>
			<text x="0.5in" y="7.18in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID44" />
			<text x="1.25in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService44" />
			<text x="2.25in" y="7.18in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName44" />
			<text x="4.5in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode44" />
			<text x="6in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges44" />
			<text x="7in" y="7.18in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments44" />
			</g><g>
			<text x="0.5in" y="7.33in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID45" />
			<text x="1.25in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService45" />
			<text x="2.25in" y="7.33in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName45" />
			<text x="4.5in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode45" />
			<text x="6in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges45" />
			<text x="7in" y="7.33in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments45" />
			</g><g>
			<text x="0.5in" y="7.48in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID46" />
			<text x="1.25in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService46" />
			<text x="2.25in" y="7.48in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName46" />
			<text x="4.5in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode46" />
			<text x="6in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges46" />
			<text x="7in" y="7.48in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments46" />
			</g><g>
			<text x="0.5in" y="7.63in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID47" />
			<text x="1.25in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService47" />
			<text x="2.25in" y="7.63in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName47" />
			<text x="4.5in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode47" />
			<text x="6in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges47" />
			<text x="7in" y="7.63in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments47" />
			</g><g>
			<text x="0.5in" y="7.78in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID48" />
			<text x="1.25in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService48" />
			<text x="2.25in" y="7.78in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName48" />
			<text x="4.5in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode48" />
			<text x="6in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges48" />
			<text x="7in" y="7.78in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments48" />
			</g><g>
			<text x="0.5in" y="7.93in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID49" />
			<text x="1.25in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService49" />
			<text x="2.25in" y="7.93in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName49" />
			<text x="4.5in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode49" />
			<text x="6in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges49" />
			<text x="7in" y="7.93in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments49" />
			</g><g>
			<text x="0.5in" y="8.08in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID50" />
			<text x="1.25in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService50" />
			<text x="2.25in" y="8.08in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName50" />
			<text x="4.5in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode50" />
			<text x="6in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges50" />
			<text x="7in" y="8.08in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments50" />
			</g><g>
			<text x="0.5in" y="8.23in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID51" />
			<text x="1.25in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService51" />
			<text x="2.25in" y="8.23in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName51" />
			<text x="4.5in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode51" />
			<text x="6in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges51" />
			<text x="7in" y="8.23in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments51" />
			</g><g>
			<text x="0.5in" y="8.38in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID52" />
			<text x="1.25in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService52" />
			<text x="2.25in" y="8.38in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName52" />
			<text x="4.5in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode52" />
			<text x="6in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges52" />
			<text x="7in" y="8.38in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments52" />
			</g><g>
			<text x="0.5in" y="8.53in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID53" />
			<text x="1.25in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService53" />
			<text x="2.25in" y="8.53in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName53" />
			<text x="4.5in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode53" />
			<text x="6in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges53" />
			<text x="7in" y="8.53in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments53" />
			</g><g>
			<text x="0.5in" y="8.68in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID54" />
			<text x="1.25in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService54" />
			<text x="2.25in" y="8.68in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName54" />
			<text x="4.5in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode54" />
			<text x="6in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges54" />
			<text x="7in" y="8.68in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments54" />
			</g><g>
			<text x="0.5in" y="8.83in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID55" />
			<text x="1.25in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService55" />
			<text x="2.25in" y="8.83in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName55" />
			<text x="4.5in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode55" />
			<text x="6in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges55" />
			<text x="7in" y="8.83in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments55" />
			</g><g>
			<text x="0.5in" y="8.98in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID56" />
			<text x="1.25in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService56" />
			<text x="2.25in" y="8.98in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName56" />
			<text x="4.5in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode56" />
			<text x="6in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges56" />
			<text x="7in" y="8.98in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments56" />
			</g><g>
			<text x="0.5in" y="9.13in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID57" />
			<text x="1.25in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService57" />
			<text x="2.25in" y="9.13in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName57" />
			<text x="4.5in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode57" />
			<text x="6in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges57" />
			<text x="7in" y="9.13in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments57" />
			</g><g>
			<text x="0.5in" y="9.28in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID58" />
			<text x="1.25in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService58" />
			<text x="2.25in" y="9.28in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName58" />
			<text x="4.5in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode58" />
			<text x="6in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges58" />
			<text x="7in" y="9.28in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments58" />
			</g><g>
			<text x="0.5in" y="9.43in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID59" />
			<text x="1.25in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService59" />
			<text x="2.25in" y="9.43in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName59" />
			<text x="4.5in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode59" />
			<text x="6in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges59" />
			<text x="7in" y="9.43in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments59" />
			</g><g>
			<text x="0.5in" y="9.58in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID60" />
			<text x="1.25in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService60" />
			<text x="2.25in" y="9.58in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName60" />
			<text x="4.5in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode60" />
			<text x="6in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges60" />
			<text x="7in" y="9.58in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments60" />
			</g><g>
			<text x="0.5in" y="9.73in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID61" />
			<text x="1.25in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService61" />
			<text x="2.25in" y="9.73in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName61" />
			<text x="4.5in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode61" />
			<text x="6in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges61" />
			<text x="7in" y="9.73in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments61" />
			</g><g>
			<text x="0.5in" y="9.88in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID62" />
			<text x="1.25in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService62" />
			<text x="2.25in" y="9.88in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName62" />
			<text x="4.5in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode62" />
			<text x="6in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges62" />
			<text x="7in" y="9.88in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments62" />
			</g><g>
			<text x="0.5in" y="10.03in" width="0.73in" height="0.1in" valueSource="IOC.1.EncounterID63" />
			<text x="1.25in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.DateOfService63" />
			<text x="2.25in" y="10.03in" width="2.2in" height="0.1in" valueSource="IOC.1.ProcedureName63" />
			<text x="4.5in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.ProcedureCode63" />
			<text x="6in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.AdjustedCharges63" />
			<text x="7in" y="10.03in" width="0.95in" height="0.1in" valueSource="IOC.1.Payments63" />

			</g>
		</g>
	
	</g>

</svg>'
	)

--------------------------------------------------------------------------------------
-- Add the NOR
--------------------------------------------------------------------------------------

INSERT	PrintingFormDetails(
		PrintingFormDetailsID,
		PrintingFormID,
		SVGDefinitionID,
		Description,
		SVGDefinition
	)
VALUES	(	7,
		4,
		1,
		'NOR', 
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

	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://da7ec664-b4bf-4dd2-b487-0480a69c0a4f"></image>
	
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
		<text x="1.90in" 	y="5.78in" width="1.33in" height="0.1in" valueSource="NOR.1.BILLINGCO_PHONE" />
		<text x="3.76in" 	y="5.78in" width="1.33in" height="0.1in" valueSource="NOR.1.BILLINGCO_FAX" />
	</g>
	

</svg>'
	)


--------------------------------------------------------------------------------------
-- Add the PR2
--------------------------------------------------------------------------------------

INSERT	PrintingFormDetails(
		PrintingFormDetailsID,
		PrintingFormID,
		SVGDefinitionID,
		Description,
		SVGDefinition
	)
VALUES	(	8,
		5,
		1,
		'PR2', 
		'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="PR2" pageId="PR2.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css"><![CDATA[
		
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
		
	    	]]></style>
	</defs>

	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://fc888a1f-27e0-40e4-8f61-a0f0b5ea935c"></image>

	<!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="./PR2.1.jpg"></image>
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
			<text x="1.44in" 	y="9.93in" width="2.86in" height="0.1in" valueSource="PR2.1.PROVIDER_STREET1" />
			<text x="4.75in" 	y="9.93in" width="2.22in" height="0.1in" valueSource="PR2.1.PROVIDER_PHONE1" />
		</g>
	</g>
	
</svg>'
	)

--------------------------------------------------------------------------------------
-- Add the POS
--------------------------------------------------------------------------------------

INSERT	PrintingFormDetails(
		PrintingFormDetailsID,
		PrintingFormID,
		SVGDefinitionID,
		Description,
		SVGDefinition
	)
VALUES	(	9,
		6,
		1,
		'POS', 
		'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="POS" pageId="POS.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css"><![CDATA[
		
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
		
	    	]]></style>
	</defs>

	
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://84a61169-1888-4c04-98dc-494b2feddb71"></image>
	
	<!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="./POS.1.jpg"></image>
	-->
	
	<g id="prologue">
		<text x="0.72in" 	y="1.62in" width="7.90in" height="0.1in" valueSource="POS.1.ADDRESS1" />
		<text x="1.01in" 	y="1.97in" width="1.3in" height="0.1in" valueSource="POS.1.DATE1" />
		<text x="0.72in" 	y="2.32in" width="7.90in" height="0.1in" valueSource="POS.1.PRACTICE_NAME1" />
		<text x="1.66in" 	y="2.77in" width="2.68in" height="0.1in" valueSource="POS.1.CITYSTATE1" />
	</g>
	
	<g id="checkboxes">
		<text x="6.37in" 	y="3.26in" width="1.3in" height="0.1in" valueSource="POS.1.DOS1" />

		<text x="0.87in" 	y="3.44in" width="0.09in" height="0.1in" valueSource="POS.1.INCLUDE_IOC1" />
		<text x="2.89in" 	y="3.43in" width="1.3in" height="0.1in" valueSource="POS.1.TOTAL_CHARGE1" />

		<text x="0.87in" 	y="4.08in" width="0.09in" height="0.1in" valueSource="POS.1.INCLUDE_NOR1" />
		<text x="4.65in"	y="4.08in" width="2.3in" height="0.1in"  valueSource="POS.1.DATE1" />		
	</g>
	
	<g class="recipients">
	
		<g id="recepient1">
			<text x="0.87in" 	y="5.29in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME1" />
			<text x="0.87in" 	y="5.45in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET1" />
			<text x="0.87in" 	y="5.61in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP1" />
		</g>

		<g id="recepient2">
			<text x="0.87in" 	y="5.99in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME2" />
			<text x="0.87in" 	y="6.15in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET2" />
			<text x="0.87in" 	y="6.30in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP2" />
		</g>

		<g id="recepient3">
			<text x="0.87in" 	y="6.66in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME3" />
			<text x="0.87in" 	y="6.81in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET3" />
			<text x="0.87in" 	y="6.97in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP3" />
		</g>

		<g id="recepient4">
			<text x="4.71in" 	y="5.29in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME4" />
			<text x="4.71in" 	y="5.45in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET4" />
			<text x="4.71in" 	y="5.61in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP4" />
		</g>

		<g id="recepient5">
			<text x="4.71in" 	y="5.99in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME5" />
			<text x="4.71in" 	y="6.15in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET5" />
			<text x="4.71in" 	y="6.30in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP5" />
		</g>

		<g id="recepient6">
			<text x="4.71in" 	y="6.66in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_NAME6" />
			<text x="4.71in" 	y="6.81in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_STREET6" />
			<text x="4.71in" 	y="6.97in" width="3.17in" height="0.1in" valueSource="POS.1.RECIPIENT_CITYSTATEZIP6" />
		</g>
	</g>
	
	<g id="epilogue">
		<text x="1.75in" 	y="8.67in" width="4.90in" height="0.1in" valueSource="POS.1.DATE1" />

		<text x="1.75in" 	y="9.16in" width="4.90in" height="0.1in" valueSource="POS.1.PATIENT_NAME1" />
		<text x="1.75in" 	y="9.32in" width="4.90in" height="0.1in" valueSource="POS.1.EMP_NAME1" />
		<text x="1.75in" 	y="9.48in" width="4.90in" height="0.1in" valueSource="POS.1.DOI_LIST1" />
		<text x="1.75in" 	y="9.63in" width="4.90in" height="0.1in" valueSource="POS.1.CLAIMNO_LIST1" />
		<text x="1.75in" 	y="9.80in" width="4.90in" height="0.1in" valueSource="POS.1.WCAB_NO_LIST1" />
	</g>
</svg>'
	)

--------------------------------------------------------------------------------------
-- Add the Label
--------------------------------------------------------------------------------------

INSERT	PrintingFormDetails(
		PrintingFormDetailsID,
		PrintingFormID,
		SVGDefinitionID,
		Description,
		SVGDefinition
	)
VALUES	(	10,
		7,
		1,
		'Label', 
		'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="LABEL" pageId="LABEL.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
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

	<g id="address">
		<text x="1in" 	y="2.60in" width="4.90in" height="0.1in" valueSource="LABEL.1.NAME1" />
		<text x="1in" 	y="2.79in" width="4.90in" height="0.1in" valueSource="LABEL.1.STREET1" />
		<text x="1in" 	y="2.98in" width="4.90in" height="0.1in" valueSource="LABEL.1.STREET21" />
		<text x="1in" 	y="3.17in" width="4.90in" height="0.1in" valueSource="LABEL.1.CITYSTATEZIP1" />
	</g>

</svg>'
	)

--------------------------------------------------------------------------------------
-- Add the Lien
--------------------------------------------------------------------------------------

INSERT INTO PrintingFormDetails(
	PrintingFormDetailsID,
	PrintingFormID,
	SVGDefinitionID,
	Description,
	SVGDefinition,
	SVGTransform)
VALUES(	15,
	10,
	1,
	'Lien',
	'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="Lien" pageId="Lien.1." width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="300">
	<defs>
		<style type="text/css"><![CDATA[
		
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
		
	    	]]></style>
	</defs>

	
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://90f99e9b-ef55-4b99-997d-b7a9dccbc300"></image>
	
	<!--
	<image x="0" y="0" width="8.5in" height="11in" xlink:href="./Lien.1.jpg"></image>
	-->

	<g id="header">
		<text x="6.62in" 	y="1.12in" width="1.90in" height="0.1in" valueSource="Lien.1.WORKERS_COMP_CASE_NUMBER1" />
	</g>
	
	<g id="line1">
		<text x="0.50in" 	y="1.51in" width="3.35in" height="0.1in" valueSource="Lien.1.PATIENT_NAME1" />

		<text x="4.20in" 	y="1.51in" width="3.35in" height="0.1in" valueSource="Lien.1.PATIENT_ADDRESS1" />
	</g>
	
	<g id="line2">
		<text x="0.50in" 	y="1.92in" width="1.05in" height="0.1in" valueSource="Lien.1.DATE_OF_INJURY_START1" />
		<text x="1.65in" 	y="1.92in" width="1.05in" height="0.1in" valueSource="Lien.1.DATE_OF_INJURY_END1" />

		<text x="3.22in" 	y="1.92in" width="1.90in" height="0.1in" valueSource="Lien.1.PATIENT_SSN1" />

		<text x="5.72in" 	y="1.92in" width="1.90in" height="0.1in" valueSource="Lien.1.PATIENT_DOB1" />
	</g>

	<g id="line3">
		<text x="0.50in" 	y="2.32in" width="3.35in" height="0.1in" valueSource="Lien.1.APPLICANT_ATTORNEY_NAME1" />

		<text x="4.20in" 	y="2.32in" width="3.35in" height="0.1in" valueSource="Lien.1.APPLICANT_ATTORNEY_ADDRESS1" />
	</g>

	<g id="line4">
		<text x="0.50in" 	y="2.70in" width="3.35in" height="0.1in" valueSource="Lien.1.EMPLOYER_NAME1" />

		<text x="4.20in" 	y="2.70in" width="3.35in" height="0.1in" valueSource="Lien.1.EMPLOYER_ADDRESS1" />
	</g>

	<g id="line5">
		<text x="0.50in" 	y="3.09in" width="2.00in" height="0.1in" valueSource="Lien.1.INSPLAN_NAME1" />
		<text x="2.55in" 	y="3.09in" width="1.30in" height="0.1in" valueSource="Lien.1.INSPLAN_POLICY_NUMBER1" />

		<text x="4.20in" 	y="3.09in" width="3.35in" height="0.1in" valueSource="Lien.1.INSPLAN_ADDRESS1" />
	</g>

	<g id="line6">
		<!-- ignore this line, nothing is printed -->
	</g>

	<g id="line7">
		<text x="0.50in" 	y="3.89in" width="3.35in" height="0.1in" valueSource="Lien.1.DEFENSE_ATTORNEY_NAME1" />

		<text x="4.20in" 	y="3.89in" width="3.35in" height="0.1in" valueSource="Lien.1.DEFENSE_ATTORNEY_ADDRESS1" />
	</g>

	<g id="line8">
		<text x="0.50in" 	y="4.28in" width="3.35in" height="0.1in" valueSource="Lien.1.PRACTICE_NAME1" />

		<text x="4.20in" 	y="4.28in" width="3.35in" height="0.1in" valueSource="Lien.1.PRACTICE_ADDRESS1" />
		<text x="5.55in" 	y="4.45in" width="2.15in" height="0.1in" valueSource="Lien.1.PRACTICE_PHONE1" />
	</g>

	<g id="line9">
		<text x="0.50in" 	y="4.75in" width="3.35in" height="0.1in" valueSource="Lien.1.BILLINGCO_NAME1" />

		<text x="4.20in" 	y="4.75in" width="3.35in" height="0.1in" valueSource="Lien.1.BILLINGCO_ADDRESS1" />
		<text x="5.55in" 	y="4.92in" width="2.15in" height="0.1in" valueSource="Lien.1.BILLINGCO_PHONE1" />
	</g>


	<g id="sums">
		<text x="0.90in" 	y="5.28in" width="1.20in" height="0.1in" valueSource="Lien.1.BALACEN_TEXT1" />

		<text x="2.65in" 	y="5.28in" width="0.8in" height="0.1in" valueSource="Lien.1.BALANCE1" />
	</g>

	<g id="signatures">
		<text x="0.50in" 	y="8.62in" width="1.90in" height="0.1in" valueSource="Lien.1.BILLINGCO_NAME1" />

		<text x="3.42in" 	y="8.62in" width="1.90in" height="0.1in" valueSource="Lien.1.PRACTICE_NAME1" />

		<text x="6.15in" 	y="8.62in" width="1.10in" height="0.1in" valueSource="Lien.1.DATE1" />
	</g>
	
</svg>',
	0)
