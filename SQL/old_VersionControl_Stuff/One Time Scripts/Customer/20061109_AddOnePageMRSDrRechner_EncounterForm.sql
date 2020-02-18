---------------------------------------------------------------------------------------------------------------------------------------------------
-- Case 15260: Implement a one page customized encounter form for Dr. Benjamin Rechner, a provider of Medical Reimbursement Services(Customer 203).
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 203
IF charindex('_0203_', db_name()) > 0
BEGIN
/*
INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (54, 'One Page Dr. Rechner', 'Encounter form that prints on a single page', 54)

INSERT INTO PrintingFormDetails (PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES (75, 9, 62, 'One Page Dr. Rechner', 1)
*/
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
        <xsl:variable name="practiceInfo" select="concat(data[@id=''EncounterForm.1.PracticeProviderName1''], '' - '', data[@id=''EncounterForm.1.PracticeAddress1''])"/>
          
        <text x="0.50in" y="0.50in" width="7.50in" height="0.10in" class="header">
          <xsl:value-of select="$practiceInfo"/>
        </text>
        
				<text x="0.50in" y="0.70in" width="7.50in" height="0.10in" font-weight="bold" font-size="8pt" valueSource="EncounterForm.1.PracticePhoneFaxBilling1" />
			</g>

      <!-- Patient Information -->
			<g id="PatientInfo">
				<rect x="0.50in" y="1.0in" width="7.50in" height="1.2in" fill="none" stroke="black"/>
        <line x1="4.50in" y1="1.0in" x2="4.50in" y2="2.20in"></line>
				<text x="0.57in" y="1.03in">Patient Information:</text>
        <text x="1.34in" y="1.03in" width="3.16in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.PatientName1" />
        <text x="1.34in" y="1.18in" width="3.16in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="1.34in" y="1.33in" width="3.16in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.AddressLine21" />
            <text x="1.34in" y="1.48in" width="3.16in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="1.34in" y="1.63in" width="3.16in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:when>
          <xsl:otherwise>
            <text x="1.34in" y="1.33in" width="3.16in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="1.34in" y="1.48in" width="3.16in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:otherwise>
        </xsl:choose>
        <text x="0.57in" y="2.05in">Pt #:</text>
        <text x="0.80in" y="2.05in" width="1.71in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.PatientID1" />
        <text x="2.50in" y="2.05in">DOB:</text>
        <text x="2.76in" y="2.05in" width="1.73in" height="0.10in" font-size="8pt" valueSource="EncounterForm.1.DOB1" />
      </g>

      <!-- Appointment Information -->
      <g id="AppointmentInfo">
        <text x="4.57in" y="1.03in">Date of Service:</text>
        <text x="5.21in" y="1.03in" width="2.78in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="4.57in" y="1.285in">Place of Service:</text>
        <text x="5.24in" y="1.285in" width="2.75in" height="0.10in" valueSource="EncounterForm.1.POS1" />
        <text x="4.57in" y="1.54in">Reason:</text>
        <text x="4.93in" y="1.54in" width="3.05in" height="0.10in" valueSource="EncounterForm.1.Reason1" />
        <text x="4.57in" y="1.795in">Provider:</text>
        <text x="4.96in" y="1.795in" width="3.03in" height="0.10in" valueSource="EncounterForm.1.Provider1" />
        <text x="4.57in" y="2.05in">Referring Doctor:</text>
        <text x="5.25in" y="2.05in" width="2.74in" height="0.10in" valueSource="EncounterForm.1.RefProvider1" />  
      </g>

      <!-- Insurance Information -->
      <g id="InsuranceInfo">
        <rect x="0.50in" y="2.33in" width="7.50in" height="0.56in" fill="none" stroke="black"/>
        <text x="0.57in" y="2.36in">Insurance:</text>
        <text x="1.01in" y="2.36in" width="2.0in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1"></text>
        <rect x="3.04in" y="2.39in" width="0.06in" height="0.07in" fill="none" stroke="black"/>
        <text x="3.13in" y="2.36in">Par</text>
        <rect x="3.30in" y="2.39in" width="0.06in" height="0.07in" fill="none" stroke="black"/>
        <text x="3.39in" y="2.36in">Non Par</text>
        <text x="4.40in" y="2.36in">Accept Assignment</text>
        <rect x="5.15in" y="2.39in" width="0.06in" height="0.07in" fill="none" stroke="black"/>
        <text x="5.24in" y="2.36in">Yes</text>
        <rect x="5.42in" y="2.39in" width="0.06in" height="0.07in" fill="none" stroke="black"/>
        <text x="5.51in" y="2.36in">No</text>
        <xsl:choose>
          <xsl:when test="data[@id=''EncounterForm.1.AcceptAssignment1''] = 1">
            <text x="5.1521in" y="2.3635in">X</text>
          </xsl:when>
          <xsl:otherwise>
            <text x="5.4221in" y="2.3635in">X</text>
          </xsl:otherwise>
        </xsl:choose>
        <text x="6.09in" y="2.36in">Copay:</text>
        <text x="6.40in" y="2.36in" width="1.59in" height="0.10in" valueSource="EncounterForm.1.Copay1"></text>
        <text x="0.57in" y="2.59in">Guarantor:</text>
        <text x="1.02in" y="2.59in" width="6.98in" height="0.10in" valueSource="EncounterForm.1.ResponsiblePerson1"></text>
      </g>

      <!-- Balance, Charges, and Payment Information -->
      <g id="MonetaryInfo">
        <text x="0.57in" y="2.74in">Previous Patient Balance:</text>
        <text x="1.57in" y="2.74in" width="1.03in" height="0.10in" valueSource="EncounterForm.1.PatientBalance1"/>
        <text x="2.60in" y="2.74in">Today''s Charges:</text>
        <text x="4.41in" y="2.74in">Today''s Payment:</text>
        <rect x="5.79in" y="2.77in" width="0.06in" height="0.07in" fill="none" stroke="black"/>
        <text x="5.88in" y="2.74in">cash</text>
        <rect x="6.15in" y="2.77in" width="0.06in" height="0.07in" fill="none" stroke="black"/>
        <text x="6.24in" y="2.74in">credit card</text>
        <rect x="6.70in" y="2.77in" width="0.06in" height="0.07in" fill="none" stroke="black"/>
        <text x="6.79in" y="2.74in">check #</text>
      </g>

      <!-- Recent Diagnoses -->
      <g id="PreviousDiagnoses">
        <text x="0.57in" y="2.91in" font-weight="bold">ICD</text>
        <text x="1.32in" y="2.91in" font-weight="bold">Previous Diagnosis</text>
        <text x="4.57in" y="2.91in" font-weight="bold">ICD</text>
        <text x="5.32in" y="2.91in" font-weight="bold">Current Diagnosis</text>
        <rect x="0.50in" y="3.09in" width="7.50in" height="0.60in" fill="none" stroke="black"/>
        <line x1="0.80in" y1="3.09in" x2="0.80in" y2="3.69in"></line>
        <line x1="4.50in" y1="3.09in" x2="4.50in" y2="3.69in"></line>
        <line x1="4.80in" y1="3.09in" x2="4.80in" y2="3.69in"></line>
        <text x="0.55in" y="3.09in" width="0.29in" height="0.1in" valueSource="EncounterForm.1.RecentDiagnosisCode{1}" />
        <text x="0.85in" y="3.09in" width="3.66in" height="0.1in" valueSource="EncounterForm.1.RecentDiagnosisName{1}" />
        <line x1="0.50in" y1="3.21in" x2="8.0in" y2="3.21in"></line>
        <text x="0.55in" y="3.21in" width="0.29in" height="0.1in" valueSource="EncounterForm.1.RecentDiagnosisCode{2}" />
        <text x="0.85in" y="3.21in" width="3.66in" height="0.1in" valueSource="EncounterForm.1.RecentDiagnosisName{2}" />
        <line x1="0.50in" y1="3.33in" x2="8.0in" y2="3.33in"></line>
        <text x="0.55in" y="3.33in" width="0.29in" height="0.1in" valueSource="EncounterForm.1.RecentDiagnosisCode{3}" />
        <text x="0.85in" y="3.33in" width="3.66in" height="0.1in" valueSource="EncounterForm.1.RecentDiagnosisName{3}" />
        <line x1="0.50in" y1="3.45in" x2="8.0in" y2="3.45in"></line>
        <text x="0.55in" y="3.45in" width="0.29in" height="0.1in" valueSource="EncounterForm.1.RecentDiagnosisCode{4}" />
        <text x="0.85in" y="3.45in" width="3.66in" height="0.1in" valueSource="EncounterForm.1.RecentDiagnosisName{4}" />
        <line x1="0.50in" y1="3.57in" x2="8.0in" y2="3.57in"></line>
        <text x="0.55in" y="3.57in" width="0.29in" height="0.1in" valueSource="EncounterForm.1.RecentDiagnosisCode{5}" />
        <text x="0.85in" y="3.57in" width="3.66in" height="0.1in" valueSource="EncounterForm.1.RecentDiagnosisName{5}" />
      </g>

      <!-- Office Visits -->
      <g id="OfficeVisitInfo">
        <text x="0.50in" y="3.80in" font-weight="bold" font-size="8pt">Office Visits</text>
        <rect x="0.50in" y="3.98in" width="7.50in" height="0.72in" fill="none" stroke="black"/>
        <line x1="0.80in" y1="3.98in" x2="0.80in" y2="4.70in"></line>
        <line x1="2.375in" y1="3.98in" x2="2.375in" y2="4.70in"></line>
        <line x1="2.675in" y1="3.98in" x2="2.675in" y2="4.70in"></line>
        <line x1="4.25in" y1="3.98in" x2="4.25in" y2="4.70in"></line>
        <line x1="4.55in" y1="3.98in" x2="4.55in" y2="4.70in"></line>
        <line x1="6.125in" y1="3.98in" x2="6.125in" y2="4.70in"></line>
        <line x1="6.425in" y1="3.98in" x2="6.425in" y2="4.70in"></line>
        <text x="0.55in" y="3.98in" font-weight="bold">CPT</text>
        <text x="0.85in" y="3.98in" font-weight="bold">Consultation</text>
        <text x="2.425in" y="3.98in" font-weight="bold">CPT</text>
        <text x="2.725in" y="3.98in" font-weight="bold">New Patient</text>
        <text x="4.30in" y="3.98in" font-weight="bold">CPT</text>
        <text x="4.60in" y="3.98in" font-weight="bold">Established Pt</text>
        <text x="6.175in" y="3.98in" font-weight="bold">CPT</text>
        <text x="6.475in" y="3.98in" font-weight="bold">Inpatient Consult</text>
        <line x1="0.50in" y1="4.10in" x2="8.0in" y2="4.10in"></line>
        <text x="0.55in" y="4.10in">99241</text>
        <text x="0.85in" y="4.10in">Low</text>
        <text x="2.425in" y="4.10in">99201</text>
        <text x="2.725in" y="4.10in">Low</text>
        <text x="4.30in" y="4.10in">99211</text>
        <text x="4.60in" y="4.10in">Nurse Visit</text>
        <text x="6.175in" y="4.10in">99251</text>
        <text x="6.475in" y="4.10in">Problem Focused</text>
        <line x1="0.50in" y1="4.22in" x2="8.0in" y2="4.22in"></line>
        <text x="0.55in" y="4.22in">99242</text>
        <text x="0.85in" y="4.22in">Expanded</text>
        <text x="2.425in" y="4.22in">99202</text>
        <text x="2.725in" y="4.22in">Expanded</text>
        <text x="4.30in" y="4.22in">99212</text>
        <text x="4.60in" y="4.22in">Low</text>
        <text x="6.175in" y="4.22in">99252</text>
        <text x="6.475in" y="4.22in">Expanded</text>
        <line x1="0.50in" y1="4.34in" x2="8.0in" y2="4.34in"></line>
        <text x="0.55in" y="4.34in">99243</text>
        <text x="0.85in" y="4.34in">Detailed</text>
        <text x="2.425in" y="4.34in">99203</text>
        <text x="2.725in" y="4.34in">Detailed</text>
        <text x="4.30in" y="4.34in">99213</text>
        <text x="4.60in" y="4.34in">Expanded</text>
        <text x="6.175in" y="4.34in">99253</text>
        <text x="6.475in" y="4.34in">Low Complexity</text>
        <line x1="0.50in" y1="4.46in" x2="8.0in" y2="4.46in"></line>
        <text x="0.55in" y="4.46in">99244</text>
        <text x="0.85in" y="4.46in">Comprehensive</text>
        <text x="2.425in" y="4.46in">99204</text>
        <text x="2.725in" y="4.46in">Comprehensive</text>
        <text x="4.30in" y="4.46in">99214</text>
        <text x="4.60in" y="4.46in">Detailed</text>
        <text x="6.175in" y="4.46in">99254</text>
        <text x="6.475in" y="4.46in">Mod Complexity</text>
        <line x1="0.50in" y1="4.58in" x2="8.0in" y2="4.58in"></line>
        <text x="0.55in" y="4.58in">99245</text>
        <text x="0.85in" y="4.58in">Consult comprec.</text>
        <text x="2.425in" y="4.58in">99205</text>
        <text x="2.725in" y="4.58in">Pre-op Visit</text>
        <text x="4.30in" y="4.58in">99215</text>
        <text x="4.60in" y="4.58in">Comprehensive</text>
        <text x="6.175in" y="4.58in">99255</text>
        <text x="6.475in" y="4.58in">Mod. Detailed</text>
        <rect x="2.33in" y="4.83in" width="0.06in" height="0.07in" fill="none" stroke="black"/>
        <text x="2.47in" y="4.80in" font-weight="bold">90001 Cosmetic Consult</text>
        <rect x="4.08in" y="4.83in" width="0.06in" height="0.07in" fill="none" stroke="black"/>
        <text x="4.22in" y="4.80in" font-weight="bold">99024 post op- no charge/global period</text>
        <text x="6.02in" y="4.80in" font-weight="bold">Surgery Date:</text>
        <line x1="6.58in" y1="4.92in" x2="8.0in" y2="4.92in"></line>
      </g>

      <!-- Office Procedures -->
      <g id="OfficeProcedureInfo">
        <text x="0.50in" y="4.90in" font-weight="bold" font-size="8pt">Office Procedures</text>
        <rect x="0.50in" y="5.08in" width="7.50in" height="0.60in" fill="none" stroke="black"/>
        <line x1="0.80in" y1="5.08in" x2="0.80in" y2="5.68in"></line>
        <line x1="2.375in" y1="5.08in" x2="2.375in" y2="5.68in"></line>
        <line x1="2.675in" y1="5.08in" x2="2.675in" y2="5.68in"></line>
        <line x1="4.25in" y1="5.08in" x2="4.25in" y2="5.68in"></line>
        <line x1="4.55in" y1="5.08in" x2="4.55in" y2="5.68in"></line>
        <line x1="6.125in" y1="5.08in" x2="6.125in" y2="5.68in"></line>
        <line x1="6.425in" y1="5.08in" x2="6.425in" y2="5.68in"></line>
        <line x1="0.50in" y1="5.08in" x2="8.0in" y2="5.08in"></line>
        <text x="0.55in" y="5.08in">11440</text>
        <text x="0.85in" y="5.08in">Lesion face .5</text>
        <text x="2.425in" y="5.08in">12051</text>
        <text x="2.725in" y="5.08in">Int closure 2.5</text>
        <text x="4.30in" y="5.08in">97605</text>
        <text x="4.60in" y="5.08in">VAC dressing</text>
        <text x="6.175in" y="5.08in">16020</text>
        <text x="6.475in" y="5.08in">Dressing change/burns</text>
        <line x1="0.50in" y1="5.20in" x2="8.0in" y2="5.20in"></line>
        <text x="0.55in" y="5.20in">11441</text>
        <text x="0.85in" y="5.20in">Lesion face .6-1</text>
        <text x="2.425in" y="5.20in">12052</text>
        <text x="2.725in" y="5.20in">Int closure 2.6-5</text>
        <text x="4.30in" y="5.20in">11200</text>
        <text x="4.60in" y="5.20in">Excision Skin tag</text>
        <text x="6.175in" y="5.20in">11900</text>
        <text x="6.475in" y="5.20in">Kenalog Injection</text>
        <line x1="0.50in" y1="5.32in" x2="8.0in" y2="5.32in"></line>
        <text x="0.55in" y="5.32in">11442</text>
        <text x="0.85in" y="5.32in">Lesion face 1-2</text>
        <text x="2.425in" y="5.32in">12053</text>
        <text x="2.725in" y="5.32in">Int closure 5.1-7.5</text>
        <text x="4.30in" y="5.32in">10140</text>
        <text x="4.60in" y="5.32in">I&amp;D seroma</text>
        <line x1="0.50in" y1="5.44in" x2="8.0in" y2="5.44in"></line>
        <text x="0.55in" y="5.44in">11443</text>
        <text x="0.85in" y="5.44in">Lesion face 2-3</text>
        <text x="2.425in" y="5.44in">11041</text>
        <text x="2.725in" y="5.44in">Debride-full thickness</text>
        <text x="4.30in" y="5.44in">10160</text>
        <text x="4.60in" y="5.44in">I&amp;D cyst</text>
        <line x1="0.50in" y1="5.56in" x2="8.0in" y2="5.56in"></line>
        <text x="0.55in" y="5.56in">11100</text>
        <text x="0.85in" y="5.56in">Punch biopsy</text>
        <text x="2.425in" y="5.56in">11040</text>
        <text x="2.725in" y="5.56in">Debride/PT</text>
        <text x="4.30in" y="5.56in">10180</text>
        <text x="4.60in" y="5.56in">I&amp;D PO wound infection</text>
      </g>

      <!-- Surgical Procedures and Other Charges -->
      <g id="SurgicalProcedureInfo">
        <text x="0.50in" y="5.88in" font-weight="bold" font-size="8pt">Surgical Procedures/Other Charges</text>
        <rect x="0.50in" y="6.06in" width="7.50in" height="1.75in" fill="none" stroke="black"/>
        <text x="0.74in" y="6.19in" font-weight="bold">ICD</text>
        <line x1="1.24in" y1="6.06in" x2="1.24in" y2="7.81in"></line>
        <text x="1.48in" y="6.19in" font-weight="bold">CPT</text>
        <line x1="1.98in" y1="6.06in" x2="1.98in" y2="7.81in"></line>
        <text x="4.40in" y="6.19in" font-weight="bold">Procedure</text>
        <line x1="0.50in" y1="6.31in" x2="8.0in" y2="6.31in"></line>
        <line x1="0.50in" y1="6.56in" x2="8.0in" y2="6.56in"></line>
        <line x1="0.50in" y1="6.81in" x2="8.0in" y2="6.81in"></line>
        <line x1="0.50in" y1="7.06in" x2="8.0in" y2="7.06in"></line>
        <line x1="0.50in" y1="7.31in" x2="8.0in" y2="7.31in"></line>
        <line x1="0.50in" y1="7.56in" x2="8.0in" y2="7.56in"></line>
      </g>

      <!-- Next Appointment Information -->
      <g id="NextAppointment">
        <rect x="0.50in" y="7.90in" width="7.50in" height="2.50in" fill="none" stroke="black"/>
        <text x="0.57in" y="7.93in" font-size="9pt">Instructions:</text>
        <line x1="0.50in" y1="9.90in" x2="8.0in" y2="9.90in"></line>
        <text x="0.57in" y="10.10in" font-size="9pt">Follow-up Visit:   _____Days   _____Weeks   _____Months   _____As Needed</text>
        <rect x="6.03in" y="9.98in" width="1.87in" height="0.32in" fill="none" stroke="black"/>
        <text x="6.10in" y="10.04in" font-size="9pt">Next Apt:</text>
      </g>
      
		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 75

END