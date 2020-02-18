BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

/*
-- kprod-db18
USE superbill_0644_dev;
GO
USE superbill_0644_prod;
GO
*/

DECLARE @printing_form_details_id AS INT;
SELECT TOP 1
        @printing_form_details_id = PFD.PrintingFormDetailsID
FROM    dbo.PrintingFormDetails AS PFD
WHERE   PFD.Description = 'One Page No Grid - Extended';

IF @printing_form_details_id IS NOT NULL 
    BEGIN
        UPDATE  dbo.PrintingFormDetails
        SET     SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg" version="1.0">
  <xsl:decimal-format name="default-format" NaN="0.00" />
  <xsl:template match="/formData/page">
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
      <defs>
        <style type="text/css">
          g
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 9pt;
          font-style: Normal;
          font-weight: Normal;
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
        </style>
      </defs>
      <image x="0.50in" y="0.35in" width="7.52in" height="2.64in" xlink:href="kareodms://8a468efb-e2af-4a91-99ab-a3546acd4b91?type=global" />
      <g id="PracticeInformation">
        <xsl:variable name="PracticeNameAndAddress" select="concat(data[@id=''EncounterForm.1.PracticeName1''], '' '', data[@id=''EncounterForm.1.PracticeAddress1''])" />
        <text x="0.49in" y="0.20in">
          <xsl:value-of select="$PracticeNameAndAddress" />
        </text>
        <text x="6.81in" y="0.20in" valueSource="EncounterForm.1.PracticeTaxID1" />
      </g>
      <g id="PatientInformation">
        <text x="0.53in" y="0.50in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.53in" y="0.63in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) &gt; 0">
            <text x="0.53in" y="0.76in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine21" />
            <text x="0.53in" y="0.89in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.53in" y="1.02in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" font-size="8pt" />
            <text x="0.53in" y="1.02in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" font-size="8pt" />
          </xsl:when>
          <xsl:otherwise>
            <text x="0.53in" y="0.76in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.53in" y="0.89in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" font-size="8pt" />
          </xsl:otherwise>
        </xsl:choose>
        <text x="0.53in" y="1.45in" width="1.19in" height="0.1in" valueSource="EncounterForm.1.PatientID1" />
        <text x="1.77in" y="1.45in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.DOBAge1" />
        <text x="0.53in" y="1.80in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.MedicalRecordNumber1" />
        <text x="0.53in" y="2.12in" width="7.25in" height="0.1in" valueSource="EncounterForm.1.AppointmentNotes1" />
      </g>
      <g id="InsuranceCoverage">
        <text x="3.04in" y="0.50in" width="2.49in" height="0.1in" valueSource="EncounterForm.1.PrimaryIns1" font-size="8pt" />
        <text x="3.04in" y="0.82in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PolicyNumber1" font-size="8pt" />
        <text x="4.30in" y="0.82in" width="0.99in" height="0.1in" valueSource="EncounterForm.1.GroupNumber1" font-size="8pt" />
        <text x="3.04in" y="1.16in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Copay1" />
        <text x="4.30in" y="1.16in" width="1.18in" height="0.1in" valueSource="EncounterForm.1.Deductible1" />
        <text x="3.04in" y="1.45in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.SecondaryIns1" font-size="8pt" />
        <text x="3.04in" y="1.80in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.SecondaryPolicyNumber1" font-size="8pt" />
        <text x="4.30in" y="2.25in" width="0.99in" height="0.1in" valueSource="EncounterForm.1.SecondaryGroupNumber1" font-size="8pt" />
      </g>
      <g id="EncounterInformation">
        <text x="5.55in" y="0.50in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="6.85in" y="0.50in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.TicketNumber1" />
        <text x="5.55in" y="0.82in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.POS1" />
        <text x="6.85in" y="0.82in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.Reason1" />
        <text x="5.55in" y="1.16in" width="2.40in" height="0.1in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.55in" y="1.45in" width="2.40in" height="0.1in" valueSource="EncounterForm.1.RefProvider1" />
        <text x="5.55in" y="1.80in" width="2.40in" height="0.1in" valueSource="EncounterForm.1.AppointmentResource1" />
      </g>
      <g id="PreviousAccountBalance">
        <text x="0.85in" y="2.52in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.95in" y="2.65in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientBalance1" font-size="12pt" />
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>'
        WHERE   PrintingFormDetailsID = @printing_form_details_id;
    END

/*
SELECT  CAST(PFD.SVGDefinition AS XML) AS SVGDefinitionXML ,
        PFD.*
FROM    dbo.PrintingFormDetails AS PFD
WHERE   PFD.Description = 'One Page No Grid - Extended';

SELECT  EFT.*
FROM    dbo.EncounterFormType AS EFT
WHERE   EFT.Name = 'One Page No Grid Extended';
*/
