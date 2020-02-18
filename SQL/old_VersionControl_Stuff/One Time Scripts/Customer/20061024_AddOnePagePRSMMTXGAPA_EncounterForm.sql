------------------------------------------------------------------------------------------------------------------------------------------------------
-- Case 14874: Implement a one page customized encounter form for TX Gastroenterology Associates PA, a practice of PRS Medical Managers(Customer 278).
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Make sure to only migrate the data when in customer 278
IF charindex('_0278_', db_name()) > 0
BEGIN

INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (53, 'One Page TXGAPA', 'Encounter form that prints on a single page', 53)

INSERT INTO PrintingFormDetails (PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform)
VALUES (70, 9, 57, 'One Page TXGAPA', 1)

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">
    <xsl:variable name="ProceduresCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])"/>
		<xsl:variable name="DiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])"/>
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="300">
			<defs>
				<style type="text/css">
          g
          {
          font-family: Arial Narrow,Arial,Helvetica;
          font-size: 9pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          text.bold
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 8pt;
          font-style: Normal;
          font-weight: bold;
          alignment-baseline: text-before-edge;
          }

          g#Title
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 16pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          text
          {
          baseline-shift: -100%;
          }

          text.centeredtext
          {
          font-size: 7pt;
          text-anchor: middle;
          }
          
          g#Procedures text
          {
          font-size: 7pt;
          }

        </style>
			</defs>

      <g id="Title">
        <text x="0.49in" y="0.43in" width="5in" height="0.1in" valueSource="EncounterForm.1.TemplateName1" />
      </g>
      
      <g id="PracticeInformation">
        <text x="0.49in" y="0.71in" width="5.0in" height="0.10in" valueSource="EncounterForm.1.PracticeName1" />
        <text x="0.49in" y="0.86in" width="5.0in" height="0.10in" valueSource="EncounterForm.1.PracticeAddress1" />
        <text x="0.49in" y="1.01in" width="5.0in" height="0.10in" valueSource="EncounterForm.1.PracticePhoneFax1" />
        <text x="0.49in" y="1.16in" width="5.0in" height="0.10in" valueSource="EncounterForm.1.PracticeTaxID1" />
      </g>
      
      <g id="PatientInformation">
        <rect x="0.50in" y="1.40in" width="7.50in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <text x="0.52in" y="1.41in" font-weight="bold" font-size="6pt">PATIENT INFORMATION</text>
        <line x1="3.0in" y1="1.40in" x2="3.0in" y2="2.68in" stroke="black"></line>
        <text x="0.52in" y="1.55in" font-size="6pt">PATIENT CONTACT</text>
        <text x="0.52in" y="1.62in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.52in" y="1.77in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.52in" y="1.92in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.AddressLine21" />
            <text x="0.52in" y="2.07in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.52in" y="2.22in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:when>
          <xsl:otherwise>
            <text x="0.52in" y="1.92in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.52in" y="2.07in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:otherwise>
        </xsl:choose>
        <line x1="0.50in" y1="2.39125in" x2="8.0in" y2="2.39125in" stroke="black"></line>
        <text x="0.52in" y="2.43in" font-size="6pt">PATIENT NUMBER</text>
        <text x="0.52in" y="2.50in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.PatientID1" />
        <line x1="1.75in" y1="2.39125in" x2="1.75in" y2="2.68in" stroke="black"></line>
        <text x="1.77in" y="2.43in" font-size="6pt">DATE OF BIRTH</text>
        <text x="1.77in" y="2.50in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.DOB1" />
        <line x1="0.50in" y1="2.68in" x2="8.0in" y2="2.68in" stroke="black"></line>
      </g>
      
      <g id="InsuranceCoverage">
        <text x="3.02in" y="1.41in" font-weight="bold" font-size="6pt">INSURANCE COVERAGE</text>
        <text x="3.02in" y="1.55in" font-size="6pt">GUARANTOR</text>
        <text x="3.02in" y="1.62in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        <line x1="3.0in" y1="1.81375in" x2="8.0in" y2="1.81375in" stroke="black"></line>
        <text x="3.02in" y="1.84375in" font-size="6pt">PRIMARY INSURANCE</text>
        <text x="3.02in" y="1.91375in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1" />
        <line x1="3.0in" y1="2.1025in" x2="8.0in" y2="2.1025in" stroke="black"></line>
        <text x="3.02in" y="2.1325in" font-size="6pt">SECONDARY INSURANCE</text>
        <text x="3.02in" y="2.2025in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.SecondaryIns1" />
        <text x="3.02in" y="2.42125in" font-size="6pt">COPAY</text>
        <text x="3.02in" y="2.49125in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.Copay1" />
        <line x1="4.25in" y1="2.39125in" x2="4.25in" y2="2.68in" stroke="black"></line>
        <text x="4.27in" y="2.42125in" font-size="6pt">DEDUCTIBLE</text>
        <text x="4.27in" y="2.49125in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.Deductible1" />
      </g>
      
      <g id="EncounterInformation">
        <text x="5.52in" y="1.41in" font-weight="bold" font-size="6pt">ENCOUNTER INFORMATION</text>
        <line x1="5.50in" y1="1.40in" x2="5.50in" y2="2.68in" stroke="black"></line>
        <text x="5.52in" y="1.55in" font-size="6pt">DATE/TIME</text>
        <text x="5.52in" y="1.62in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1" />
        <line x1="6.75in" y1="1.525in" x2="6.75in" y2="2.1025in" stroke="black"></line>
        <text x="6.77in" y="1.55in" font-size="6pt">TICKET NUMBER</text>
        <text x="6.77in" y="1.62in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.TicketNumber1" />
        <text x="5.52in" y="1.84375in" font-size="6pt">PLACE OF SERVICE</text>
        <text x="5.52in" y="1.91375in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.POS1" />
        <text x="6.77in" y="1.84375in" font-size="6pt">REASON</text>
        <text x="6.77in" y="1.91375in" width="1.25in" height="0.10in" valueSource="EncounterForm.1.Reason1" />
        <text x="5.52in" y="2.1325in" font-size="6pt">PROVIDER</text>
        <text x="5.52in" y="2.2025in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.52in" y="2.42125in" font-size="6pt">REFERRING PROVIDER</text>
        <text x="5.52in" y="2.49125in" width="2.50in" height="0.10in" valueSource="EncounterForm.1.RefProvider1" />
      </g>

      <g id="Procedures">
        <text x="0.55in" y="2.79in" width="1.825in">Office Visit Codes</text>
        <text x="2.425in" y="2.79in" width="1.825in">|   __  789.00  Abd Pain NOS</text>
        <text x="4.30in" y="2.79in" width="1.825in">__  787.2    Dysphagia</text>
        <text x="6.215in" y="2.79in" width="1.785in">__  008.45  Pseudo Colitis</text>
        <text x="2.425in" y="2.94in" width="1.825in">|   __  789.01  Abd Pain RUQ</text>
        <text x="4.30in" y="2.94in" width="1.825in">__  790.5    Elevated A/L</text>
        <text x="6.215in" y="2.94in" width="1.785in">__  569.3    Rectal Bleeding</text>
        <text x="0.55in" y="3.09in" width="1.825in">New Patient</text>
        <text x="2.425in" y="3.09in" width="1.825in">|   __  789.02  Abd Pain LUQ</text>
        <text x="4.30in" y="3.09in" width="1.825in">__  789.06  Epigastric Pain</text>
        <text x="6.215in" y="3.09in" width="1.785in">__  750.3    Schatzki''s Ring</text>
        <text x="2.425in" y="3.24in" width="1.825in">|   __  789.03  Abd Pain RLQ</text>
        <text x="4.30in" y="3.24in" width="1.825in">__  530.1    Esophagitis</text>
        <text x="6.215in" y="3.24in" width="1.785in">__  560.9    Sigmoid Stricture</text>
        <text x="0.55in" y="3.39in" width="1.825in">___  99201  NP/Level  1</text>
        <text x="2.425in" y="3.39in" width="1.825in">|   __  789.04  Abd Pain LLQ</text>
        <text x="4.30in" y="3.39in" width="1.825in">__  211.0    Esophageal Leimyome</text>
        <text x="6.215in" y="3.39in" width="1.785in">__  560.9    Small Bowel Obst</text>
        <text x="0.55in" y="3.54in" width="1.825in">___  99202  NP/Level  2</text>
        <text x="2.425in" y="3.54in" width="1.825in">|   __  787.3    Abd Distention</text>
        <text x="4.30in" y="3.54in" width="1.825in">__  750.3    Esophageal Ring</text>
        <text x="6.215in" y="3.54in" width="1.785in">__  556.9    Ulcerative Colitis</text>
        <text x="0.55in" y="3.69in" width="1.825in">___  99203  NP/Level  3</text>
        <text x="2.425in" y="3.69in" width="1.825in">|   __  794.8    Abnormal Liver Func</text>
        <text x="4.30in" y="3.69in" width="1.825in">__  530.3    Esophageal Stricture</text>
        <text x="6.215in" y="3.69in" width="1.785in">__  780.7    Weakness/Fatigue</text>
        <text x="0.55in" y="3.84in" width="1.825in">___  99204  NP/Level  4</text>
        <text x="2.425in" y="3.84in" width="1.825in">|   __  565.0    Anal Fissure</text>
        <text x="4.30in" y="3.84in" width="1.825in">__  530.2    Esophageal Ulcer</text>
        <text x="6.215in" y="3.84in" width="1.785in">__  783.2_  Weight Loss</text>
        <text x="0.55in" y="3.99in" width="1.825in">___  99205  NP/Level  5</text>
        <text x="2.425in" y="3.99in" width="1.825in">|   __  535.1    Anal Fistula</text>
        <text x="4.30in" y="3.99in" width="1.825in">__  456.2_  Esophageal Varacies</text>
        <text x="6.215in" y="3.99in" width="1.785in">__  530.6    Zankers Divertic</text>
        <text x="2.425in" y="4.14in" width="1.825in">|   __  285.9    Anemia NOS</text>
        <text x="4.30in" y="4.14in" width="1.825in">__  787.6    Fecal Incontinence</text>
        <text x="6.215in" y="4.14in" width="1.785in">__  V10.05  Hx Colon CA</text>
        <text x="0.55in" y="4.29in" width="1.825in">Established Patient</text>
        <text x="2.425in" y="4.29in" width="1.825in">|   __  747.61  Arteriovenus Malfor</text>
        <text x="4.30in" y="4.29in" width="1.825in">__  571.8    Fatty Liver</text>
        <text x="6.215in" y="4.29in" width="1.785in">__  V12.72  Hx Colon Polyps</text>
        <text x="2.425in" y="4.44in" width="1.825in">|   __  789.5    Ascites</text>
        <text x="4.30in" y="4.44in" width="1.825in">__  151.9    Gastric Cancer</text>
        <text x="6.215in" y="4.44in" width="1.785in">__  V16.0    FHx Colon CA</text>
        <text x="0.55in" y="4.59in" width="1.825in">___  99211  FU/Level  1</text>
        <text x="2.425in" y="4.59in" width="1.825in">|   __  530.2_  Barrett''s Esophagus</text>
        <text x="4.30in" y="4.59in" width="1.825in">__  537.0    Gastric Outlet Obst</text>
        <text x="6.215in" y="4.59in" width="1.785in">__  250.0_  Diabetes</text>
        <text x="0.55in" y="4.74in" width="1.825in">___  99212  FU/Level  2</text>
        <text x="2.425in" y="4.74in" width="1.825in">|   __  576.2    Bile Duct Obst/Stric</text>
        <text x="4.30in" y="4.74in" width="1.825in">__  211.1    Gastric Polyp</text>
        <text x="6.215in" y="4.74in" width="1.785in">__  V76.51  Colon CA Screening</text>
        <text x="0.55in" y="4.89in" width="1.825in">___  99213  FU/Level  3</text>
        <text x="2.425in" y="4.89in" width="1.825in">|   __  578.1    Blood in stool</text>
        <text x="4.30in" y="4.89in" width="1.825in">__  531.90  Gastric Ulcer</text>
        <text x="6.175in" y="4.89in" width="1.825in">|   Non-Inf.     Ent./Colitis</text>
        <text x="0.55in" y="5.04in" width="1.825in">___  99214  FU/Level  4</text>
        <text x="2.425in" y="5.04in" width="1.825in">|   __  787.99  Change in Bowel Habits</text>
        <text x="4.30in" y="5.04in" width="1.825in">__  558.9    Gastritis/Colitis/Illeitis</text>
        <text x="6.175in" y="5.04in" width="1.825in">| __  555.0  Small Intestine</text>
        <text x="0.55in" y="5.19in" width="1.825in">___  99215  FU/Level  5</text>
        <text x="2.425in" y="5.19in" width="1.825in">|   __  786.5_  Chest Pain</text>
        <text x="4.30in" y="5.19in" width="1.825in">__  578.9    GI Hemorrhage</text>
        <text x="6.175in" y="5.19in" width="1.825in">| __  555.1  Large Intestine</text>
        <text x="2.425in" y="5.34in" width="1.825in">|   __  574.5    Choledocholithiasis</text>
        <text x="4.30in" y="5.34in" width="1.825in">__  530.81  GERD</text>
        <text x="6.175in" y="5.34in" width="1.825in">| __  555.2  Small/Large Intestine</text>
        <text x="2.425in" y="5.49in" width="1.825in">|   __  574.2    Cholelithiasis</text>
        <text x="4.30in" y="5.49in" width="1.825in">__  787.1    Heartburn</text>
        <text x="6.175in" y="5.49in" width="1.825in">| __  555.9  Unsp. Site</text>
        <text x="2.425in" y="5.64in" width="1.825in">|   __  575.1    Cholecystitis</text>
        <text x="4.30in" y="5.64in" width="1.825in">__  455.6    Hemorrhoids NOS</text>
        <text x="6.175in" y="5.64in" width="1.825in">| __  556.0  Ulcer Ent.Colitis</text>
        <text x="2.425in" y="5.79in" width="1.825in">|   __  571.5    Cirrhosis</text>
        <text x="4.30in" y="5.79in" width="1.825in">__  070.51  Hepatitis C</text>
        <text x="6.175in" y="5.79in" width="1.825in">| __  556.1  Ulcer Ileocolitis</text>
        <text x="2.425in" y="5.94in" width="1.825in">|   __  558.9    Colitis</text>
        <text x="4.30in" y="5.94in" width="1.825in">__  572.8    Hepatic Failure</text>
        <text x="6.175in" y="5.94in" width="1.825in">| __  556.2  Ulcer Proctitis</text>
        <text x="2.425in" y="6.09in" width="1.825in">|   __  569.82  Colonic Ulcer</text>
        <text x="4.30in" y="6.09in" width="1.825in">__  226.02  Hepatic Hemang</text>
        <text x="6.175in" y="6.09in" width="1.825in">| __  556.3  Ulcer Proc.Sigmoiditi</text>
        <text x="2.425in" y="6.24in" width="1.825in">|   __  211.3    Colon Polyps</text>
        <text x="4.30in" y="6.24in" width="1.825in">__  553.3    Hiatial Hernia</text>
        <text x="6.175in" y="6.24in" width="1.825in">| __  556.8  Other Ulcer Colitis</text>
        <text x="2.425in" y="6.39in" width="1.825in">|   __  564.0    Constipation</text>
        <text x="4.30in" y="6.39in" width="1.825in">__  558.9    Illeitis</text>
        <text x="6.175in" y="6.39in" width="1.825in">| __  556.9  Ulcer Coilitis, Uns.</text>
        <text x="2.425in" y="6.54in" width="1.825in">|   __  555.9    Crohn''s Disease</text>
        <text x="4.30in" y="6.54in" width="1.825in">__  560.1    Illeus</text>
        <text x="6.175in" y="6.54in" width="1.825in">| __  558.2  Toxic Gastroent/colit</text>
        <text x="0.55in" y="6.69in" width="1.825in">Office/Output Consult</text>
        <text x="2.425in" y="6.69in" width="1.825in">|   __  564.5    Diarrhea</text>
        <text x="4.30in" y="6.69in" width="1.825in">__  280.9    Iron Def./Anemia</text>
        <text x="6.175in" y="6.69in" width="1.825in">| __  558.9  Oth/Uns. noninfec</text>
        <text x="2.425in" y="6.84in" width="1.825in">|   __  562.11  Diverticulitis</text>
        <text x="4.30in" y="6.84in" width="1.825in">__  530.7    Mallory-Weiss</text>
        <text x="6.175in" y="6.84in" width="1.825in">|                     g.interitis/colitis</text>
        <text x="0.55in" y="6.99in" width="1.825in">___  99241  Level  1</text>
        <text x="2.425in" y="6.99in" width="1.825in">|   __  562.10  Diverticulosis</text>
        <text x="4.30in" y="6.99in" width="1.825in">__  263.9    Malnutrition</text>
        <text x="6.175in" y="6.99in" width="1.825in">| __  V10.05Hx of malignant neo</text>
        <text x="0.55in" y="7.14in" width="1.825in">___  99242  Level  2</text>
        <text x="2.425in" y="7.14in" width="1.825in">|   __  211.2    Duodenal Polyp</text>
        <text x="4.30in" y="7.14in" width="1.825in">__  569.9    Melanosis Coli</text>
        <text x="6.175in" y="7.14in" width="1.825in">|                   of large intestine</text>
        <text x="0.55in" y="7.29in" width="1.825in">___  99243  Level  3</text>
        <text x="2.425in" y="7.29in" width="1.825in">|   __  532.30  Duodenal Ulcer,Acute</text>
        <text x="4.30in" y="7.29in" width="1.825in">__  787.01  Nausea Vomiting</text>
        <text x="6.175in" y="7.29in" width="1.825in">| __  V10.06Hx of malignant neo</text>
        <text x="0.55in" y="7.44in" width="1.825in">___  99244  Level  4</text>
        <text x="2.425in" y="7.44in" width="1.825in">|   __  535.60  Duodenitis</text>
        <text x="4.30in" y="7.44in" width="1.825in">__  577.0    Pancreatitis,Acute</text>
        <text x="6.175in" y="7.44in" width="1.825in">|                   rectum</text>
        <text x="0.55in" y="7.59in" width="1.825in">___  99245  Level  5</text>
        <text x="2.425in" y="7.59in" width="1.825in">|   __  536.8    Dyspepsia</text>
        <text x="4.30in" y="7.59in" width="1.825in">__  569.49  Proctitis NOS</text>
        <text x="6.175in" y="7.59in" width="1.825in">| __  V12.72Dz.dig.sys,colon poly</text>
        <text x="2.425in" y="7.74in" width="1.825in">|   __  535.40  Gastritis</text>
        <text x="4.30in" y="7.74in" width="1.825in">__  787.02  Nausea</text>
        <text x="6.175in" y="7.74in" width="1.825in">| __  V18.5  Fhx of dig.  disorders</text>
        <line x1="2.425in" y1="8.04in" x2="8.0in" y2="8.04in" style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>
        <text x="0.55in" y="8.34in">Other Procedures</text>
        <text x="0.55in" y="8.49in">___  91110 Capsule Endoscopy</text>
        <text x="0.55in" y="8.64in">___  G0120 Colorectal Cancer Screening (High Risk)</text>
        <text x="0.55in" y="8.79in">___  G0121 Colorectal Cancer Screening (Non High Risk)</text>
        <text x="0.55in" y="8.94in">DX:   _________________</text>
        <line x1="0.57in" y1="9.14in" x2="7.93in" y2="9.14in" style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>
        <line x1="0.50in" y1="9.29in" x2="8.0in" y2="9.29in" style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>
      </g>

      <g id="AccountBalance">
        <rect x="0.50in" y="9.39in" width="7.50in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <text x="0.54in" y="9.40in" font-weight="bold" font-size="6pt">PREVIOUS ACCOUNT BALANCE</text>
        <text x="0.54in" y="9.545in" font-size="6pt">LAST INSURANCE PAYMENT</text>
        <text x="0.57in" y="9.625in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.LastInsPay1" />
        <line x1="1.75in" y1="9.515in" x2="1.75in" y2="10.09in" stroke="black"></line>
        <text x="1.79in" y="9.545in" font-size="6pt">PREVIOUS INS BALANCE</text>
        <text x="1.82in" y="9.625in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.InsBalance1" />
        <line x1="0.50in" y1="9.8025in" x2="5.50in" y2="9.8025in" stroke="black"></line>
        <text x="0.54in" y="9.8325in" font-size="6pt">LAST PATIENT PAYMENT</text>
        <text x="0.57in" y="9.9125in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.79in" y="9.8325in" font-size="6pt">PREVIOUS PATIENT BALANCE</text>
        <text x="1.82in" y="9.9125in" width="1.22in" height="0.10in" valueSource="EncounterForm.1.PatientBalance1" />
        <line x1="0.50in" y1="10.09in" x2="8.0in" y2="10.09in" stroke="black"></line>
      </g>

      <g id="AccountActivity">
        <text x="3.04in" y="9.40in" font-weight="bold" font-size="6pt">TODAY''S ACCOUNT ACTIVITY</text>
        <line x1="3.0in" y1="9.515in" x2="3.0in" y2="10.09in" stroke="black"></line>
        <text x="3.04in" y="9.545in" font-size="6pt">TODAY''S CHARGES</text>
        <line x1="4.25in" y1="9.515in" x2="4.25in" y2="10.09in" stroke="black"></line>
        <text x="4.29in" y="9.545in" font-size="6pt">TODAY''S ADJUSTMENTS</text>
        <text x="3.04in" y="9.8325in" font-size="6pt">TODAY''S AMOUNT DUE</text>
        <text x="4.29in" y="9.8325in" font-size="6pt">NEXT APPOINTMENT</text>
        <line x1="5.50in" y1="9.515in" x2="5.50in" y2="10.09in" stroke="black"></line>
      </g>

      <g id="PaymentOnAccount">
        <text x="5.54in" y="9.40in" font-weight="bold" font-size="6pt">PAYMENT ON ACCOUNT</text>
        <text x="5.54in" y="9.545in" font-size="6pt">PAYMENT METHOD</text>
        <circle cx="5.65in" cy="9.725in" r="0.04in" fill="none" stroke="black"/>
        <text x="5.85in" y="9.685in" font-size="6pt" >CASH</text>
        <circle cx="5.65in" cy="9.875in" r="0.04in" fill="none" stroke="black"/>
        <text x="5.85in" y="9.835in" font-size="6pt" >CREDIT CARD</text>
        <circle cx="5.65in" cy="10.025in" r="0.04in" fill="none" stroke="black"/>
        <text x="5.85in" y="9.985in" font-size="6pt" >CHECK #</text>
        <line x1="6.75in" y1="9.515in" x2="6.75in" y2="10.09in" stroke="black"></line>
        <text x="6.79in" y="9.545in" font-size="6pt">TODAY''S PAYMENT</text>
        <line x1="6.75in" y1="9.8025in" x2="8.0in" y2="9.8025in" stroke="black"></line>
        <text x="6.79in" y="9.8325in" font-size="6pt">BALANCE DUE</text>
      </g>

		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 70

END