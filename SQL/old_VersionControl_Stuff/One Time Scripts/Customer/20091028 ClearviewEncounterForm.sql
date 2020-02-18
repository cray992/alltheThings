--select * from PrintingForm where PrintingFormID=9
--select * from PrintingFormDetails where PrintingFormID=9 order by PrintingFOrmDetailsID
--select * from EncounterFormType order by EncounterFormTypeID


--delete encountertemplate where EncounterformTypeID=60
--select * from sys.tables where name like '%encounter%'



declare 
	@FormName varchar(128),
	@PrintingFormDetailsID int,
	@EncounterFormTypeID int
	
set @FormName='Pacific Phys. Lab'
set @PrintingFormDetailsID=88
set @EncounterFormTypeID=60

delete PrintingFormDetails where PrintingFormDetailsID=@PrintingFormDetailsID
delete EncounterFormType where EncounterFormTypeID=@EncounterFormTypeID

insert into PrintingFormDetails (PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, [Description], SVGDefinition, SVGTransform)
values (@PrintingFormDetailsID, 9, 75, @FormName, '', 1)

insert into EncounterFormType (
	EncounterFormTypeID, 
	Name, 
	[Description],	
	SortOrder, 
	NumberOfPages, 
	PageOneDetailsID,	
	PageTwoDetailsID, 
	ShowProcedures, 
	ShowDiagnoses, 
	ShowMostRecentDiagnoses, 
	ShowAccountStatus, 
	ShowReferralSource, 
	ShowTertiaryInsurance, 
	ShowLastVisitDate, 
	ShowAcceptAssignment, 
	ShowLastInsurancePaymentDate, 
	ShowInsuranceBalance, 
	ShowLastPatientPaymentDate, 
	ShowPatientBalance)
values (
	@EncounterFormTypeID,
	@FormName,
	@FormName,
	100, 
	1,
	@PrintingFormDetailsID,
	NULL,
	1,	1,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1)



update PrintingFOrmDetails 
set SVGDefinition=
'<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
<xsl:decimal-format name="default-format" NaN="0.00" />

<xsl:template match="/formData/page">

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
			<defs>
				<style type="text/css">
					g
					{
					font-family: Arial,Arial Narrow,Helvetica;
					font-size: 10pt;
					font-style: Normal;
					font-weight: Normal;
					alignment-baseline: text-before-edge;
					}

					text.small
					{
					font-family: Arial,Arial Narrow,Helvetica;
					font-size: 8pt;
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

					text
					{
					baseline-shift: -100%;
					}

					g#ProceduresGrid line
					{
					stroke: black;
					stroke-dasharray: 2, 2;
					stroke-width: 0.0069in;
					}

					text.centeredtext
					{
					font-size: 9pt;
					text-anchor: middle;
					}

					text.ralignedtext
					{
					text-anchor: end;
					}

					text.header
					{
					font-weight: bold;
					font-size: 12pt;
					text-anchor: middle;
					}

				</style>
			</defs>
			
<g id="PatientBox">

<text x="0.25in" y="1.758in" width="1in" valueSource="EncounterForm.1.PatientLastName1"/>
<text x="2.00in" y="1.758in" width="1in" valueSource="EncounterForm.1.PatientFirstName1"/>
<text x="3.25in" y="1.758in" width="1in" valueSource="EncounterForm.1.PatientMiddleName1"/>

<text x="0.25in" y="2.125in" width="1in" valueSource="EncounterForm.1.AddressLine11"/>
<text x="0.25in" y="2.5in" width="1in" valueSource="EncounterForm.1.CityStateZip1"/>

<text x="0.25in" y="2.8in" width="1in" valueSource="EncounterForm.1.SSN1"/>
<text x="2in" y="2.800in" width="1in" valueSource="EncounterForm.1.PatientID1"/>

<text x="0.25in" y="3.130in" width="1in" valueSource="EncounterForm.1.HomePhone1"/>
<xsl:variable name="GenderDisplay" select="substring (data[@id=''EncounterForm.1.Gender1''], 1 ,1)"/>

<!--
<text x="1.9in" y="3.13in" width="1in" valueSource="EncounterForm.1.Gender1"/>
-->
<text x="2.00in" y="3.13in" width="1in"><xsl:value-of select="$GenderDisplay"/></text>

<text x="2.3in" y="3.13in" width="1in" valueSource="EncounterForm.1.DOBAge1"/>

<!-- COLLECTION Date/TIME -->
<text x="0.50in" y="3.45in" width="1in" valueSource="EncounterForm.1.AppDateTime1"/>

</g>

<g id="Billing">

<text x="2in" y="3.95in" width="1.7in" font-family="Arial Narrow" font-size="9pt" valueSource="EncounterForm.1.PrimaryIns1"/>
<text x="0.4in" y="4.058in" width="1.7in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PrimaryAddressLine11"/>
<text x="0.45in" y="4.16in" width="1.7in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PrimaryCity1"/>
<text x="2.12in" y="4.16in" width="1.7in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PrimaryState1"/>
<text x="3.30in" y="4.16in" width="1.7in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PrimaryZip1"/>

<text x="0.25in" y="4.450in" width="1in" valueSource="EncounterForm.1.PolicyNumber1"/>
<text x="2.00in" y="4.450in" width="1in" valueSource="EncounterForm.1.ResponsiblePerson1"/>
<text x="0.25in" y="4.75in" width="1in" valueSource="EncounterForm.1.GroupNumber1"/>

<text x="0.7in" y="4.94in" width="1.25in" font-size="9pt" font-family="Arial Narrow" valueSource="EncounterForm.1.Employer1"/>
<text x="0.25in" y="5.06in" width="1.25in" font-size="8pt" font-family="Arial Narrow" valueSource="EncounterForm.1.EmployerAddressLine11"/>
<text x="0.45in" y="5.150in" width="0.70in" font-size="8pt" font-family="Arial Narrow" valueSource="EncounterForm.1.EmployerCity1"/>
<text x="1.31in" y="5.150in" width="1.25in" font-size="8pt" font-family="Arial Narrow" valueSource="EncounterForm.1.EmployerState1"/>
<text x="1.76in" y="5.160in" width="1.25in" font-size="7pt" font-family="Arial Narrow" valueSource="EncounterForm.1.EmployerZIP1"/>

</g>

</svg>
</xsl:template>
</xsl:stylesheet>
'
where PrintingFormDetailsID=88--@PrintingFormDetailsID
