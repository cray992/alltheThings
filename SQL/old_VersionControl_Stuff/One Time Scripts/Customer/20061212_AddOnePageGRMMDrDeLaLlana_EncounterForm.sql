---------------------------------------------------------------------------------------------------------------------------------------------------
-- Case 15989: Implement a one page customized encounter form for Dr. Sylvia De La Llana, a provider of GR Medical Management(Customer 108).
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 108
IF charindex('_0108_', db_name()) > 0
BEGIN

INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (55, 'One Page Dr. De La Llana', 'Encounter form that prints on a single page', 55)

INSERT INTO PrintingFormDetails (PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES (79, 9, 66, 'One Page Dr. De La Llana', 1)

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="300">
			<defs>
				<style type="text/css">
					g
					{
					font-family: Arial Narrow,Arial,Helvetica;
					font-size: 7pt;
					font-style: Normal;
					font-weight: Normal;
					alignment-baseline: text-before-edge;
					}

					text
					{
					baseline-shift: -100%;
					}

					text.header
					{
					font-weight: bold;
					font-size: 9pt;
					}
          
          g line
          {
           stroke: black;
          }

				</style>
			</defs>

			<!-- Practice Information -->
			<g id="PracticeInfo">
        <rect x="0.50in" y="0.25in" width="7.50in" height="7.62in" fill="none" stroke="black" stroke-width="1.0pt"/>
        <rect x="0.50in" y="0.25in" width="7.50in" height="0.18in" fill="black" stroke="black"/>
        <text x="0.50in" y="0.25in" width="7.50in" height="0.10in" font-weight="bold" font-size="11pt" fill="white" text-anchor="middle" text-decoration="underline" valueSource="EncounterForm.1.PracticeProviderName1" />
        <text x="0.50in" y="0.55in" width="7.50in" height="0.10in" font-weight="bold" font-size="11pt" text-anchor="middle" valueSource="EncounterForm.1.PracticeName1" />
        <rect x="0.57in" y="0.95in" width="0.08in" height="0.08in" fill="none" stroke="black"/>
        <text x="0.69in" y="0.92in" font-weight="bold" font-size="8pt">San Fernando</text>
        <rect x="1.57in" y="0.95in" width="0.08in" height="0.08in" fill="none" stroke="black"/>
        <text x="1.69in" y="0.92in" font-weight="bold" font-size="8pt">Los Angeles</text>
        <rect x="5.47in" y="0.95in" width="0.07in" height="0.07in" fill="none" stroke="black"/>
        <text x="5.59in" y="0.92in" font-size="8pt">WC</text>
        <rect x="6.07in" y="0.95in" width="0.07in" height="0.07in" fill="none" stroke="black"/>
        <text x="6.19in" y="0.92in" font-size="8pt">PVT</text>
        <rect x="6.67in" y="0.95in" width="0.07in" height="0.07in" fill="none" stroke="black"/>
        <text x="6.79in" y="0.92in" font-size="8pt">MCRE</text>
        <rect x="0.57in" y="1.20in" width="0.08in" height="0.08in" fill="none" stroke="black"/>
        <text x="0.69in" y="1.17in" font-weight="bold" font-size="8pt">Long Beach</text>
        <rect x="1.57in" y="1.20in" width="0.08in" height="0.08in" fill="none" stroke="black"/>
        <text x="1.69in" y="1.17in" font-weight="bold" font-size="8pt">Rancho Cucamonga</text>
			</g>

      <!-- Patient Information -->
			<g id="PatientInfo">
        <text x="0.53in" y="1.49in" font-weight="bold" font-size="8pt">PATIENT''S NAME</text>
        <line x1="1.36in" y1="1.61in" x2="3.26in" y2="1.61in"></line>
        <text x="1.36in" y="1.49in" width="1.92in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.53in" y="1.77in" font-weight="bold" font-size="8pt">SS #</text>
        <line x1="0.78in" y1="1.89in" x2="2.68in" y2="1.89in"></line>
        <text x="0.78in" y="1.77in" width="1.92in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.SSN1" />
        <text x="5.44in" y="1.77in" font-weight="bold" font-size="8pt">D.O.B.</text>
        <line x1="5.76in" y1="1.89in" x2="7.51in" y2="1.89in"></line>
        <text x="5.76in" y="1.77in" width="1.77in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.DOB1" />
      </g>

      <!-- Appointment Information -->
      <g id="AppointmentInfo">
        <text x="5.44in" y="1.49in" font-weight="bold" font-size="8pt">DATE OF SERVICE</text>
        <line x1="6.34in" y1="1.61in" x2="7.74in" y2="1.61in"></line>
        <text x="6.34in" y="1.49in" width="1.42in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.AppDateTime1" />
      </g>

      <g id="Procedures">
        <rect x="0.50in" y="1.91in" width="7.50in" height="0.16in" fill="grey" stroke="black"/>
        <text x="0.50in" y="1.92in" width="7.50in" height="0.10in" font-weight="bold" font-size="8pt" text-anchor="middle">PROCEDURES</text>
        <line x1="0.80in" y1="2.07in" x2="0.80in" y2="4.71in"></line>
        <line x1="3.0in" y1="2.07in" x2="3.0in" y2="4.71in" stroke-width="1pt"></line>
        <line x1="3.30in" y1="2.07in" x2="3.30in" y2="4.71in"></line>
        <line x1="5.50in" y1="2.07in" x2="5.50in" y2="4.71in" stroke-width="1pt"></line>
        <line x1="5.80in" y1="2.07in" x2="5.80in" y2="4.71in"></line>
        <rect x="0.50in" y="2.07in" width="7.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="0.50in" y="2.07in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">OFFICE VISIT - NEW PATIENT</text>
        <text x="3.0in" y="2.07in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">MEDICAL LEGAL</text>
        <text x="5.50in" y="2.07in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">PROCEDURES</text>
        <text x="0.50in" y="2.19in" width="0.30in" height="0.10in" text-anchor="middle">99202</text>
        <text x="0.82in" y="2.19in">LIMITED EVALUATION</text>
        <text x="3.0in" y="2.19in" width="0.30in" height="0.10in" text-anchor="middle">ML102</text>
        <text x="3.32in" y="2.19in">AME / AME / ML</text>
        <text x="5.50in" y="2.19in" width="0.30in" height="0.10in" text-anchor="middle">95860</text>
        <text x="5.82in" y="2.19in">EMG,  1 LIMB</text>
        <line x1="0.50in" y1="2.31in" x2="8.0in" y2="2.31in"></line>
        <text x="0.50in" y="2.31in" width="0.30in" height="0.10in" text-anchor="middle">99203</text>
        <text x="0.82in" y="2.31in">INTERMEDIATE EVALUATION</text>
        <text x="3.0in" y="2.31in" width="0.30in" height="0.10in" text-anchor="middle">ML103</text>
        <text x="3.32in" y="2.31in">AME / AME / ML</text>
        <text x="5.50in" y="2.31in" width="0.30in" height="0.10in" text-anchor="middle">95861</text>
        <text x="5.82in" y="2.31in">EMG,  2 LIMBS</text>
        <line x1="0.50in" y1="2.43in" x2="8.0in" y2="2.43in"></line>
        <text x="0.50in" y="2.43in" width="0.30in" height="0.10in" text-anchor="middle">99204</text>
        <text x="0.82in" y="2.43in">EXTENDED EVALUATION</text>
        <text x="3.0in" y="2.43in" width="0.30in" height="0.10in" text-anchor="middle">ML104</text>
        <text x="3.32in" y="2.43in">AME / AME / ML x____</text>
        <text x="5.50in" y="2.43in" width="0.30in" height="0.10in" text-anchor="middle">95863</text>
        <text x="5.82in" y="2.43in">EMG,  3 LIMBS</text>
        <line x1="0.50in" y1="2.55in" x2="8.0in" y2="2.55in"></line>
        <text x="0.50in" y="2.55in" width="0.30in" height="0.10in" text-anchor="middle">99205</text>
        <text x="0.82in" y="2.55in">COMPREHENSIVE EVALUATION</text>
        <text x="3.0in" y="2.55in" width="0.30in" height="0.10in" text-anchor="middle">ML101</text>
        <text x="3.32in" y="2.55in">AME / AME / ML F/U x____</text>
        <text x="5.50in" y="2.55in" width="0.30in" height="0.10in" text-anchor="middle">95864</text>
        <text x="5.82in" y="2.55in">EMG,  4 LIMBS</text>
        <line x1="0.50in" y1="2.67in" x2="8.0in" y2="2.67in"></line>
        <text x="0.50in" y="2.67in" width="0.30in" height="0.10in" text-anchor="middle">99049</text>
        <text x="0.82in" y="2.67in">FAILED APPT IN EVAL</text>
        <text x="3.0in" y="2.67in" width="0.30in" height="0.10in" text-anchor="middle">ML100</text>
        <text x="3.32in" y="2.67in">FAILED MED - LEGAL</text>
        <rect x="5.50in" y="2.67in" width="2.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="5.50in" y="2.67in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">REPORT/SUPPLY CODES</text>
        <rect x="0.50in" y="2.79in" width="2.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="0.50in" y="2.79in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">OFFICE VISIT - ESTABLISHED PATIENT</text>
        <rect x="3.0in" y="2.79in" width="2.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="3.0in" y="2.79in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">PROLONGED PHYS SERV</text>
        <text x="5.50in" y="2.79in" width="0.30in" height="0.10in" text-anchor="middle">A4550</text>
        <text x="5.82in" y="2.79in">SURGICAL TRAY</text>
        <text x="0.50in" y="2.91in" width="0.30in" height="0.10in" text-anchor="middle">99211</text>
        <text x="0.82in" y="2.91in">OFFICE / OP VISIT</text>
        <text x="3.0in" y="2.91in" width="0.30in" height="0.10in" text-anchor="middle">99358</text>
        <text x="3.32in" y="2.91in">REC REV ____ HRS</text>
        <rect x="5.50in" y="2.91in" width="2.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="5.50in" y="2.91in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">NCV CODES</text>
        <line x1="0.50in" y1="3.03in" x2="8.0in" y2="3.03in"></line>
        <text x="0.50in" y="3.03in" width="0.30in" height="0.10in" text-anchor="middle">99212</text>
        <text x="0.82in" y="3.03in">LIMITED F/U</text>
        <text x="3.0in" y="3.03in" width="0.30in" height="0.10in" text-anchor="middle">99371</text>
        <text x="3.32in" y="3.03in">TELEPHONE CALL BRIEF</text>
        <text x="5.50in" y="3.03in" width="0.30in" height="0.10in" text-anchor="middle">95900</text>
        <text x="5.82in" y="3.03in">MOTOR NERVE CONDUCTION  w/o F.WAVE X_____</text>
        <line x1="0.50in" y1="3.15in" x2="8.0in" y2="3.15in"></line>
        <text x="0.50in" y="3.15in" width="0.30in" height="0.10in" text-anchor="middle">99213</text>
        <text x="0.82in" y="3.15in">INTERMEDIATE EVALUATION</text>
        <text x="3.0in" y="3.15in" width="0.30in" height="0.10in" text-anchor="middle">99372</text>
        <text x="3.32in" y="3.15in">TELEPHONE CALL INT</text>
        <text x="5.50in" y="3.15in" width="0.30in" height="0.10in" text-anchor="middle">95903</text>
        <text x="5.82in" y="3.15in">MOTOR NERVE CONDUCTION  w F.WAVE     X_____</text>
        <line x1="0.50in" y1="3.27in" x2="8.0in" y2="3.27in"></line>
        <text x="0.50in" y="3.27in" width="0.30in" height="0.10in" text-anchor="middle">99214</text>
        <text x="0.82in" y="3.27in">EXTENDED F/U</text>
        <text x="3.0in" y="3.27in" width="0.30in" height="0.10in" text-anchor="middle">99361</text>
        <text x="3.32in" y="3.27in">TEAM CONFERENCE</text>
        <text x="5.50in" y="3.27in" width="0.30in" height="0.10in" text-anchor="middle">95904</text>
        <text x="5.82in" y="3.27in">SENSORY NERVE COND STUDY X_______</text>
        <line x1="0.50in" y1="3.39in" x2="8.0in" y2="3.39in"></line>
        <text x="0.50in" y="3.39in" width="0.30in" height="0.10in" text-anchor="middle">99215</text>
        <text x="0.82in" y="3.39in">COMPREHENSIVE F/U</text>
        <text x="3.0in" y="3.39in" width="0.30in" height="0.10in" text-anchor="middle">95832</text>
        <text x="3.32in" y="3.39in">JAMAR</text>
        <text x="5.50in" y="3.39in" width="0.30in" height="0.10in" text-anchor="middle">95934</text>
        <text x="5.82in" y="3.39in">H-REFLEX AMP &amp; LATENCY STU X_______</text>
        <line x1="0.50in" y1="3.51in" x2="8.0in" y2="3.51in"></line>
        <text x="0.50in" y="3.51in" width="0.30in" height="0.10in" text-anchor="middle">99024</text>
        <text x="0.82in" y="3.51in">POST OP VISIT</text>
        <text x="3.0in" y="3.51in" width="0.30in" height="0.10in" text-anchor="middle">97612</text>
        <text x="3.32in" y="3.51in">INDIVIDUAL INSTRUCTION</text>
        <rect x="5.50in" y="3.51in" width="2.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="5.50in" y="3.51in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">OTHER</text>
        <line x1="0.50in" y1="3.63in" x2="8.0in" y2="3.63in"></line>
        <rect x="0.50in" y="3.63in" width="2.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="0.50in" y="3.63in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">CONSULTATIONS</text>
        <text x="3.0in" y="3.63in" width="0.30in" height="0.10in" text-anchor="middle">97700</text>
        <text x="3.32in" y="3.63in">ORTHOTIC CHECK</text>
        <line x1="0.50in" y1="3.75in" x2="8.0in" y2="3.75in"></line>
        <text x="0.50in" y="3.75in" width="0.30in" height="0.10in" text-anchor="middle">99241</text>
        <text x="0.82in" y="3.75in">OFFICE CONSULTATION</text>
        <text x="3.0in" y="3.75in" width="0.30in" height="0.10in" text-anchor="middle">97720</text>
        <text x="3.32in" y="3.75in">EXTREMITY TESTING</text>
        <line x1="0.50in" y1="3.87in" x2="8.0in" y2="3.87in"></line>
        <text x="0.50in" y="3.87in" width="0.30in" height="0.10in" text-anchor="middle">99242</text>
        <text x="0.82in" y="3.87in">OFFICE CONSULTATION</text>
        <text x="3.0in" y="3.87in" width="0.30in" height="0.10in" text-anchor="middle">97540</text>
        <text x="3.32in" y="3.87in">ACTIVITIES OF DAILY</text>
        <line x1="0.50in" y1="3.99in" x2="8.0in" y2="3.99in"></line>
        <text x="0.50in" y="3.99in" width="0.30in" height="0.10in" text-anchor="middle">99243</text>
        <text x="0.82in" y="3.99in">OFFICE CONSULTATION</text>
        <rect x="3.0in" y="3.99in" width="2.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="3.0in" y="3.99in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">PREPARATION OF REPORTS</text>
        <line x1="0.50in" y1="4.11in" x2="8.0in" y2="4.11in"></line>
        <text x="0.50in" y="4.11in" width="0.30in" height="0.10in" text-anchor="middle">99244</text>
        <text x="0.82in" y="4.11in">CONSULT COMPREH</text>
        <text x="3.0in" y="4.11in" width="0.30in" height="0.10in" text-anchor="middle">99080</text>
        <text x="3.32in" y="4.11in">INITIAL REPORT</text>
        <line x1="0.50in" y1="4.23in" x2="8.0in" y2="4.23in"></line>
        <text x="0.50in" y="4.23in" width="0.30in" height="0.10in" text-anchor="middle">99245</text>
        <text x="0.82in" y="4.23in">CONSULT COMPLEX</text>
        <text x="3.0in" y="4.23in" width="0.30in" height="0.10in" text-anchor="middle">99081</text>
        <text x="3.32in" y="4.23in">PR2</text>
        <line x1="0.50in" y1="4.35in" x2="8.0in" y2="4.35in"></line>
        <text x="0.50in" y="4.35in" width="0.30in" height="0.10in" text-anchor="middle">99274</text>
        <text x="0.82in" y="4.35in">COMPREH 2ND OPINION</text>
        <text x="3.0in" y="4.35in" width="0.30in" height="0.10in" text-anchor="middle">99080</text>
        <text x="3.32in" y="4.35in">SUPPLEMENTAL REPORT</text>
        <line x1="0.50in" y1="4.47in" x2="8.0in" y2="4.47in"></line>
        <text x="0.50in" y="4.47in" width="0.30in" height="0.10in" text-anchor="middle">99275</text>
        <text x="0.82in" y="4.47in">COMPREH 2ND OPINION</text>
        <text x="3.0in" y="4.47in" width="0.30in" height="0.10in" text-anchor="middle">99080</text>
        <text x="3.32in" y="4.47in">P&amp;S REPORT</text>
        <line x1="0.50in" y1="4.59in" x2="8.0in" y2="4.59in"></line>
      </g>

      <g id="Diagnoses">
        <rect x="0.50in" y="4.71in" width="7.50in" height="0.16in" fill="grey" stroke="black"/>
        <text x="0.50in" y="4.72in" width="7.50in" height="0.10in" font-weight="bold" font-size="8pt" text-anchor="middle">ICD - 9 - CM DIAGNOSIS</text>
        <line x1="3.30in" y1="4.87in" x2="3.30in" y2="7.87in" stroke-width="1pt"></line>
        <line x1="5.80in" y1="4.87in" x2="5.80in" y2="7.87in" stroke-width="1pt"></line>
        <rect x="0.50in" y="4.87in" width="7.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="0.50in" y="4.87in" width="2.80in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">WRIST/HAND</text>
        <text x="3.30in" y="4.87in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">LUMBAR SPINE</text>
        <text x="5.80in" y="4.87in" width="2.20in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">HIP/THIGH</text>
        <text x="0.52in" y="4.99in" width="2.20in" height="0.10in">CARPAL TUNNEL SYNDROME</text>
        <text x="2.70in" y="4.99in" width="0.30in" height="0.10in" text-anchor="end">354.0</text>
        <text x="3.32in" y="4.99in" width="1.90in" height="0.10in">DISC DISPLACEMENT NOS</text>
        <text x="5.20in" y="4.99in" width="0.30in" height="0.10in" text-anchor="end">722.2</text>
        <text x="5.82in" y="4.99in" width="1.80in" height="0.10in">CONTUSION OF HIP</text>
        <text x="7.60in" y="4.99in" width="0.30in" height="0.10in" text-anchor="start">924.01</text>
        <text x="0.52in" y="5.11in" width="2.20in" height="0.10in">FX CARPAL BONE NOS-CLOSE</text>
        <text x="2.70in" y="5.11in" width="0.30in" height="0.10in" text-anchor="end">814.00</text>
        <text x="3.32in" y="5.11in" width="1.90in" height="0.10in">LUMBAGO</text>
        <text x="5.20in" y="5.11in" width="0.30in" height="0.10in" text-anchor="end">724.2</text>
        <text x="5.82in" y="5.11in" width="1.80in" height="0.10in">CONTUSION OF THIGH</text>
        <text x="7.60in" y="5.11in" width="0.30in" height="0.10in" text-anchor="start">924.00</text>
        <text x="0.52in" y="5.23in" width="2.20in" height="0.10in">JOINT PAIN-FOREARM</text>
        <text x="2.70in" y="5.23in" width="0.30in" height="0.10in" text-anchor="end">719.43</text>
        <text x="3.32in" y="5.23in" width="1.90in" height="0.10in">LUMBOSACRAL NEURITIS NOS</text>
        <text x="5.20in" y="5.23in" width="0.30in" height="0.10in" text-anchor="end">724.4</text>
        <text x="5.82in" y="5.23in" width="1.80in" height="0.10in">JOINT PAIN-PELVIS</text>
        <text x="7.60in" y="5.23in" width="0.30in" height="0.10in" text-anchor="start">719.45</text>
        <text x="0.52in" y="5.35in" width="2.20in" height="0.10in">RADIAL STYLOID TENOSYNOV</text>
        <text x="2.70in" y="5.35in" width="0.30in" height="0.10in" text-anchor="end">727.04</text>
        <text x="3.32in" y="5.35in" width="1.90in" height="0.10in">LUMBOSACRAL PLEX LESION</text>
        <text x="5.20in" y="5.35in" width="0.30in" height="0.10in" text-anchor="end">353.1</text>
        <text x="5.82in" y="5.35in" width="1.80in" height="0.10in">SPRAIN HIP &amp; THIGH NOS</text>
        <text x="7.60in" y="5.35in" width="0.30in" height="0.10in" text-anchor="start">843.9</text>
        <text x="0.52in" y="5.47in" width="2.20in" height="0.10in">SPRAIN OF WRIST NOS</text>
        <text x="2.70in" y="5.47in" width="0.30in" height="0.10in" text-anchor="end">842.00</text>
        <text x="3.32in" y="5.47in" width="1.90in" height="0.10in">SPINAL STENOSIS-LUMBAR</text>
        <text x="5.20in" y="5.47in" width="0.30in" height="0.10in" text-anchor="end">724.02</text>
        <rect x="5.80in" y="5.47in" width="2.20in" height="0.12in" fill="black" stroke="black"/>
        <text x="5.80in" y="5.47in" width="2.20in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">KNEE</text>
        <text x="0.52in" y="5.59in" width="2.20in" height="0.10in">TENOSYNOV HAND/WRIST NEC</text>
        <text x="2.70in" y="5.59in" width="0.30in" height="0.10in" text-anchor="end">727.05</text>
        <text x="3.32in" y="5.59in" width="1.90in" height="0.10in">SPOND COMPR LUMB SP CORD</text>
        <text x="5.20in" y="5.59in" width="0.30in" height="0.10in" text-anchor="end">721.42</text>
        <text x="5.82in" y="5.59in" width="1.80in" height="0.10in">CHONDROMALACIA PATELLAE</text>
        <text x="7.60in" y="5.59in" width="0.30in" height="0.10in" text-anchor="start">717.7</text>
        <text x="0.52in" y="5.71in" width="2.20in" height="0.10in">TRIGGER FINGER</text>
        <text x="2.70in" y="5.71in" width="0.30in" height="0.10in" text-anchor="end">727.03</text>
        <text x="3.32in" y="5.71in" width="1.90in" height="0.10in">SPRAIN LUMBAR REGION</text>
        <text x="5.20in" y="5.71in" width="0.30in" height="0.10in" text-anchor="end">847.2</text>
        <text x="5.82in" y="5.71in" width="1.80in" height="0.10in">CONTUSION OF KNEE</text>
        <text x="7.60in" y="5.71in" width="0.30in" height="0.10in" text-anchor="start">924.11</text>
        <rect x="0.50in" y="5.83in" width="2.80in" height="0.12in" fill="black" stroke="black"/>
        <text x="0.50in" y="5.83in" width="2.80in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">CERVICAL SPINE</text>
        <rect x="3.30in" y="5.83in" width="2.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="3.30in" y="5.83in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">SHOULDER</text>
        <text x="5.82in" y="5.83in" width="1.80in" height="0.10in">INT DERANGEMENT KNEE NOS</text>
        <text x="7.60in" y="5.83in" width="0.30in" height="0.10in" text-anchor="start">717.9</text>
        <text x="0.52in" y="5.95in" width="2.20in" height="0.10in">BRACHIAL NEURITIS NOS</text>
        <text x="2.70in" y="5.95in" width="0.30in" height="0.10in" text-anchor="end">723.4</text>
        <text x="3.32in" y="5.95in" width="1.90in" height="0.10in">ADHESIVE CAPSULT SHLDR</text>
        <text x="5.20in" y="5.95in" width="0.30in" height="0.10in" text-anchor="end">726.0</text>
        <text x="5.82in" y="5.95in" width="1.80in" height="0.10in">JOINT PAIN-L/LEG</text>
        <text x="7.60in" y="5.95in" width="0.30in" height="0.10in" text-anchor="start">719.46</text>
        <text x="0.52in" y="6.07in" width="2.20in" height="0.10in">CERV SPONDYL W MYELOPATH</text>
        <text x="2.70in" y="6.07in" width="0.30in" height="0.10in" text-anchor="end">721.1</text>
        <text x="3.32in" y="6.07in" width="1.90in" height="0.10in">CONTUSION SHOULDER REG</text>
        <text x="5.20in" y="6.07in" width="0.30in" height="0.10in" text-anchor="end">923.00</text>
        <text x="5.82in" y="6.07in" width="1.80in" height="0.10in">SPRAIN CRUCIATE LIG KNEE</text>
        <text x="7.60in" y="6.07in" width="0.30in" height="0.10in" text-anchor="start">844.2</text>
        <text x="0.52in" y="6.19in" width="2.20in" height="0.10in">CERVICAL DISC DEGEN</text>
        <text x="2.70in" y="6.19in" width="0.30in" height="0.10in" text-anchor="end">722.4</text>
        <text x="3.32in" y="6.19in" width="1.90in" height="0.10in">DISLOC SHOULDER NOS-CLOS</text>
        <text x="5.20in" y="6.19in" width="0.30in" height="0.10in" text-anchor="end">831.00</text>
        <text x="5.82in" y="6.19in" width="1.80in" height="0.10in">SPRAIN OF KNEE &amp; LEG NOS</text>
        <text x="7.60in" y="6.19in" width="0.30in" height="0.10in" text-anchor="start">844.9</text>
        <text x="0.52in" y="6.31in" width="2.20in" height="0.10in">CERVICAL DISC DISPLACMNT</text>
        <text x="2.70in" y="6.31in" width="0.30in" height="0.10in" text-anchor="end">722.0</text>
        <text x="3.32in" y="6.31in" width="1.90in" height="0.10in">JOINT PAIN-SHLDR</text>
        <text x="5.20in" y="6.31in" width="0.30in" height="0.10in" text-anchor="end">719.41</text>
        <text x="5.82in" y="6.31in" width="1.80in" height="0.10in">TEAR LAT MENISC KNEE-CUR</text>
        <text x="7.60in" y="6.31in" width="0.30in" height="0.10in" text-anchor="start">836.1</text>
        <text x="0.52in" y="6.43in" width="2.20in" height="0.10in">CERVICAL SPONDYLOSIS</text>
        <text x="2.70in" y="6.43in" width="0.30in" height="0.10in" text-anchor="end">721.0</text>
        <text x="3.32in" y="6.43in" width="1.90in" height="0.10in">JT DEFRANGMENT NEC-SHLDR</text>
        <text x="5.20in" y="6.43in" width="0.30in" height="0.10in" text-anchor="end">718.81</text>
        <rect x="5.80in" y="6.43in" width="2.20in" height="0.12in" fill="black" stroke="black"/>
        <text x="5.80in" y="6.43in" width="2.20in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">ANKLE/FOOT</text>
        <text x="0.52in" y="6.55in" width="2.20in" height="0.10in">CERVICALGIA</text>
        <text x="2.70in" y="6.55in" width="0.30in" height="0.10in" text-anchor="end">723.1</text>
        <text x="3.32in" y="6.55in" width="1.90in" height="0.10in">SHOULDER REGION DIS NEC</text>
        <text x="5.20in" y="6.55in" width="0.30in" height="0.10in" text-anchor="end">726.2</text>
        <text x="5.82in" y="6.55in" width="1.80in" height="0.10in">CONTUSION OF ANKLE</text>
        <text x="7.60in" y="6.55in" width="0.30in" height="0.10in" text-anchor="start">924.21</text>
        <text x="0.52in" y="6.67in" width="2.20in" height="0.10in">RADICULOPATHY</text>
        <text x="2.70in" y="6.67in" width="0.30in" height="0.10in" text-anchor="end">728.81</text>
        <text x="3.32in" y="6.67in" width="1.90in" height="0.10in">SPRAIN ROTATOR CUFF</text>
        <text x="5.20in" y="6.67in" width="0.30in" height="0.10in" text-anchor="end">840.4</text>
        <text x="5.82in" y="6.67in" width="1.80in" height="0.10in">CONTUSION OF FOOT</text>
        <text x="7.60in" y="6.67in" width="0.30in" height="0.10in" text-anchor="start">924.20</text>
        <text x="0.52in" y="6.79in" width="2.20in" height="0.10in">SPRAIN OF NECK</text>
        <text x="2.70in" y="6.79in" width="0.30in" height="0.10in" text-anchor="end">847.0</text>
        <text x="3.32in" y="6.79in" width="1.90in" height="0.10in">SPRAIN SHOULDER/ARM NOS</text>
        <text x="5.20in" y="6.79in" width="0.30in" height="0.10in" text-anchor="end">840.9</text>
        <text x="5.82in" y="6.79in" width="1.80in" height="0.10in">JOINT PAIN-ANKLE</text>
        <text x="7.60in" y="6.79in" width="0.30in" height="0.10in" text-anchor="start">719.47</text>
        <rect x="0.50in" y="6.91in" width="2.80in" height="0.12in" fill="black" stroke="black"/>
        <text x="0.50in" y="6.91in" width="2.80in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">THORACIC SPINE</text>
        <rect x="3.30in" y="6.91in" width="2.50in" height="0.12in" fill="black" stroke="black"/>
        <text x="3.30in" y="6.91in" width="2.50in" height="0.10in" font-weight="bold" fill="white" text-anchor="middle">ELBOW/UPPER ARM</text>
        <text x="0.52in" y="7.03in" width="2.20in" height="0.10in">PAIN IN THORACIC SPINE</text>
        <text x="2.70in" y="7.03in" width="0.30in" height="0.10in" text-anchor="end">724.1</text>
        <text x="3.32in" y="7.03in" width="1.90in" height="0.10in">CARPAL TUNNEL SYNDROME</text>
        <text x="5.20in" y="7.03in" width="0.30in" height="0.10in" text-anchor="end">354.0</text>
        <text x="0.52in" y="7.15in" width="2.20in" height="0.10in">PATH FX VERTEBRAE</text>
        <text x="2.70in" y="7.15in" width="0.30in" height="0.10in" text-anchor="end">733.13</text>
        <text x="3.32in" y="7.15in" width="1.90in" height="0.10in">CONTUSION OF ELBOW</text>
        <text x="5.20in" y="7.15in" width="0.30in" height="0.10in" text-anchor="end">923.11</text>
        <text x="0.52in" y="7.27in" width="2.20in" height="0.10in">SPRAIN THORACIC REGION</text>
        <text x="2.70in" y="7.27in" width="0.30in" height="0.10in" text-anchor="end">847.1</text>
        <text x="3.32in" y="7.27in" width="1.90in" height="0.10in">JOINT PAIN-UP/ARM</text>
        <text x="5.20in" y="7.27in" width="0.30in" height="0.10in" text-anchor="end">719.42</text>
        <text x="0.52in" y="7.39in" width="2.20in" height="0.10in">THORACIC DISC DEGEN</text>
        <text x="2.70in" y="7.39in" width="0.30in" height="0.10in" text-anchor="end">722.51</text>
        <text x="3.32in" y="7.39in" width="1.90in" height="0.10in">LATERAL EPICONDYLITIS</text>
        <text x="5.20in" y="7.39in" width="0.30in" height="0.10in" text-anchor="end">726.32</text>
        <text x="0.52in" y="7.51in" width="2.20in" height="0.10in">THORACOGENIC SCOLIOSIS</text>
        <text x="2.70in" y="7.51in" width="0.30in" height="0.10in" text-anchor="end">737.34</text>
        <text x="3.32in" y="7.51in" width="1.90in" height="0.10in">MEDIAL EPICONDYLITIS</text>
        <text x="5.20in" y="7.51in" width="0.30in" height="0.10in" text-anchor="end">726.31</text>
        <text x="3.32in" y="7.63in" width="2.20in" height="0.10in">SPRAIN ELBOW/FOREARM NOS</text>
        <text x="5.20in" y="7.63in" width="0.30in" height="0.10in" text-anchor="end">841.9</text>
        <text x="3.32in" y="7.75in" width="2.20in" height="0.10in">ULNAR NERVE LESION</text>
        <text x="5.20in" y="7.75in" width="0.30in" height="0.10in" text-anchor="end">354.2</text>
      </g>

      <g id="Signature">
        <text x="0.52in" y="7.92in" font-size="6pt">I affirm that the medical information indicated on this form is derived from and supported by my clinical documentation in the medical record.  I direct that this information be</text>
        <text x="0.52in" y="8.10in" font-size="6pt">billed on my behalf.  I understand that if the information I have provided herewith is not supported by my entries in the medical record, I may incur liability.</text>
        <text x="0.52in" y="8.37in" font-size="8pt">PHYSICIAN''S SIGNATURE:</text>
        <line x1="1.74in" y1="8.49in" x2="5.32in" y2="8.49in"></line>
        <text x="5.37in" y="8.37in" font-size="8pt">DATE:</text>
        <line x1="5.68in" y1="8.49in" x2="7.60in" y2="8.49in"></line>
      </g>

		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 79

END