/*----------------------------------

DATABASE UPDATE SCRIPT

v1.37.xxxx to v1.38.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------


/*-----------------------------------------------------------------------------
Case 8841 - Add new columns to the encounter template table
-----------------------------------------------------------------------------*/



/*-----------------------------------------------------------------------------
Case 10604 - Add new report "Provider Number"
-----------------------------------------------------------------------------*/
INSERT INTO ReportCategoryToSoftwareApplication(
	ReportCategoryID, 
	SoftwareApplicationID, 
	ModifiedDate
	)
VALUES(
	9,
	'M',
	getdate())

DECLARE @ProviderNumbersRptID INT 

INSERT INTO Report(
	ReportCategoryID, 
	DisplayOrder, 
	Image, 
	Name, 
	Description, 
	TaskName, 
	ReportPath, 
	ReportParameters, 
	MenuName, 
	PermissionValue
	)

VALUES(
	9, 
	10, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Provider Numbers', 
	'This report shows the provider numbers for providers in the practice.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptProviderNumbers',
	'<?xml version="1.0" encoding="utf-8" ?>  
		<parameters>   
			<basicParameters>
				<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />    
				<basicParameter type="PracticeID" parameterName="PracticeID" />    				
				<basicParameter type="PracticeName" parameterName="rpmPracticeName" />   
				<basicParameter type="ClientTime" parameterName="ClientTime" />   
			</basicParameters>   
				<extendedParameters>    
				<extendedParameter type="Separator" text="Filter" />   
				<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" /> 
				<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />				
				<extendedParameter type="Insurance" parameterName="InsuranceID" text="Insurance:" default="-1" ignore="-1" />
				<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
				<extendedParameter type="ComboBox" parameterName="groupby" text="Group by:" description="Select the grouping option"    default="1">    
					<value displayText="Provider" value="1" />    
					<value displayText="Service Location" value="2" />    
					<value displayText="Department" value="3" />    
					<value displayText="Insurance" value="4" />  
				</extendedParameter>   
			</extendedParameters>  
		</parameters>',
	'Provider &Numbers', -- Why are "&" used in the value???
	'ReadProviderNumbersReport')

 

SET @ProviderNumbersRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@ProviderNumbersRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@ProviderNumbersRptID,
	'M',
	GETDATE()
	)


GO

------------------------------------------------------------------ 
-- CASE 9107 Implemment support for service-line notes
------------------------------------------------------------------

-- Add 2 columns to EncounterProcedure table

ALTER TABLE [dbo].[EncounterProcedure]
	ADD	[EDIServiceNoteReferenceCode] [char](3) NULL,
		[EDIServiceNote] [varchar](80)  NULL

GO

-- Add FK to EncounterProcedure

ALTER TABLE [dbo].[EncounterProcedure]  WITH CHECK 
	ADD  CONSTRAINT [FK_EncounterProcedure_EDIServiceNoteReferenceCode] 
	FOREIGN KEY([EDIServiceNoteReferenceCode])
	REFERENCES [dbo].[EDINoteReferenceCode] ([Code])

GO


-- Copy service note data from Claim table to EncounterProcedure 

UPDATE	ep 
	SET	EDIServiceNote = c.EDIServiceNote,
		EDIServiceNoteReferenceCode = c.EDIServiceNoteReferenceCode
	FROM	EncounterProcedure ep
	INNER JOIN Claim c ON  ep.EncounterProcedureID = c.EncounterProcedureID
	WHERE	c.EDIServiceNote IS NOT NULL OR c.EDIServiceNoteReferenceCode IS NOT NULL

GO

-- Drop FK from Claim table

ALTER TABLE dbo.Claim
	DROP CONSTRAINT [FK_ClaimService_EDINoteReferenceCode] 
GO


-- Delete 2 columns from Claim table
	

ALTER TABLE dbo.Claim
	DROP COLUMN [EDIServiceNoteReferenceCode],
	[EDIServiceNote]
GO


-- Add EDIServiceNoteReferenceCode and EDIServiceNote columns to ProcedureMacroDetail

ALTER TABLE [dbo].[ProcedureMacroDetail]
	ADD	[EDIServiceNoteReferenceCode] [char](3) NULL,
		[EDIServiceNote] [varchar](80)  NULL

GO

-- Add FK to ProcedureMacroDetail

ALTER TABLE [dbo].[ProcedureMacroDetail]  WITH CHECK 
	ADD  CONSTRAINT [FK_ProcedureMacroDetail_EDIServiceNoteReferenceCode] 
	FOREIGN KEY([EDIServiceNoteReferenceCode])
	REFERENCES [dbo].[EDINoteReferenceCode] ([Code])

GO


------------------------------------------------------------------ 
-- CASE 10180 Add column for AcceptAssignment in PracticeToInsuranceCompany table,
--			  modify billing form transforms to use this new field
------------------------------------------------------------------

ALTER TABLE dbo.PracticeToInsuranceCompany
	ADD [AcceptAssignment] [bit] NULL
	CONSTRAINT DF_PracticeToInsuranceCompany_AcceptAssignment
	DEFAULT 1 WITH VALUES
GO

UPDATE BillingForm
SET Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500">
			<page pageId="CMS1500.1">
				<BillID>
					<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
				</BillID>
				<data id="CMS1500.1.1_Medicare">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Medicaid">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Champus">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''CH''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Champva">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''VA''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_GroupHealthPlan"></data>
				<data id="CMS1500.1.1_Feca"></data>
				<data id="CMS1500.1.1_Other">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MB'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MC'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''CH'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''VA''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_aIDNumber">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
							<xsl:choose>
								<!-- For non-worker''s comp cases the DependentPolicyNumber is printed if the Policy Number is blank -->
								<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!-- For worker''s comp cases the patient SSN is printed if the Policy Number is blank -->
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSSN1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_PatientName">
					<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
					</xsl:if>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
				</data>
				<data id="CMS1500.1.3_MM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.3_DD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.3_YY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
				</data>
				<data id="CMS1500.1.3_M">
					<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
				</data>
				<data id="CMS1500.1.3_F">
					<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
				</data>
				<data id="CMS1500.1.4_InsuredName">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text>SAME</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.5_PatientAddress">
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
					</xsl:if>
				</data>
				<data id="CMS1500.1.5_City">
					<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
				</data>
				<data id="CMS1500.1.5_State">
					<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
				</data>
				<data id="CMS1500.1.5_Zip">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.5_Area">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
				</data>
				<data id="CMS1500.1.5_Phone">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
				</data>
				<xsl:choose>
					<xsl:when test="not(data[@id=''CMS1500.1.IsWorkersComp1''] = 1 and data[@id=''CMS1500.1.HolderThroughEmployer1''] = 1)">
						<!-- If not worker''s comp OR is worker''s comp and holder through employer is not set -->
						<data id="CMS1500.1.6_Self">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
						</data>
						<data id="CMS1500.1.6_Spouse">
							<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
						</data>
						<data id="CMS1500.1.6_Child">
							<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
						</data>
						<data id="CMS1500.1.6_Other">
							<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
						</data>
					</xsl:when>
					<xsl:otherwise>
						<!-- If this is worker''s comp and the holder through employer is checked automatically select other -->
						<data id="CMS1500.1.6_Self" />
						<data id="CMS1500.1.6_Spouse" />
						<data id="CMS1500.1.6_Child" />
						<data id="CMS1500.1.6_Other">X</data>
					</xsl:otherwise>
				</xsl:choose>
				<data id="CMS1500.1.7_InsuredAddress">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
								</xsl:if>
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text>SAME</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.7_City">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text xml:space="preserve"> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.7_State">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text xml:space="preserve"> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.7_Zip">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:choose>
									<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
										<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
										<xsl:text>-</xsl:text>
										<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text xml:space="preserve"> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
										<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
										<xsl:text>-</xsl:text>
										<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.7_Area">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text xml:space="preserve"> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.7_Phone">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text xml:space="preserve"> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.8_Single">
					<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
				</data>
				<data id="CMS1500.1.8_Married">
					<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
				</data>
				<data id="CMS1500.1.8_Other">
					<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
				</data>
				<data id="CMS1500.1.8_Employed">
					<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
				</data>
				<data id="CMS1500.1.8_FTStud">
					<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
				</data>
				<data id="CMS1500.1.8_PTStud">
					<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
				</data>
				<data id="CMS1500.1.9_OtherName">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_aGrpNumber">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPolicyNumber1'']" />
				</data>
				<data id="CMS1500.1.9_bMM">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_bDD">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_bYYYY">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_bM">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_bF">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_cEmployer">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberEmployerName1'']" />
							</xsl:when>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_dPlanName">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</data>
				<data id="CMS1500.1.1_0aYes">
					<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0aNo">
					<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0bYes">
					<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0bNo">
					<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0bState">
					<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
				</data>
				<data id="CMS1500.1.1_0cYes">
					<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0cNo">
					<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0dLocal"> </data>
				<data id="CMS1500.1.1_1GroupNumber">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1">
							<xsl:text>NONE</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.1_1aMM">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1aDD">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1aYY">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1aM">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1aF">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1bEmployer">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1cPlanName">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1dYes">
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
						<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1dNo">
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
						<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_2Signature">Signature on File</data>
				<data id="CMS1500.1.1_2Date">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_3Signature">Signature on File</data>
				<data id="CMS1500.1.1_4MM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_4DD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_4YY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_5MM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_5DD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_5YY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_6StartMM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_6StartDD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_6StartYY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_6EndMM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_6EndDD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_6EndYY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_7Referring">
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_7aID">
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
				</data>
				<data id="CMS1500.1.1_8StartMM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_8StartDD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_8StartYY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_8EndMM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_8EndDD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_8EndYY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_9Local">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
							<!-- Not worker''s comp -->
							<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
						</xsl:when>
						<xsl:otherwise>
							<!-- Worker''s comp will display the adjuster''s name if the local use data isn''t available -->
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.LocalUseData1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterLastName1'']) > 0 or string-length(data[@id=''CMS1500.1.AdjusterFirstName1'']) > 0">
										<xsl:text>ATTN: </xsl:text>
										<xsl:value-of select="data[@id=''CMS1500.1.AdjusterFirstName1'']" />
										<xsl:text xml:space="preserve"> </xsl:text>
										<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterMiddleName1'']) > 0">
											<xsl:value-of select="substring(data[@id=''CMS1500.1.AdjusterMiddleName1''],1,1)" />
											<xsl:text>. </xsl:text>
										</xsl:if>
										<xsl:value-of select="data[@id=''CMS1500.1.AdjusterLastName1'']" />
										<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterSuffix1'']) > 0">
											<xsl:text xml:space="preserve"> </xsl:text>
											<xsl:value-of select="data[@id=''CMS1500.1.AdjusterSuffix1'']" />
										</xsl:if>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_0Yes"> </data>
				<data id="CMS1500.1.2_0No">X</data>
				<data id="CMS1500.1.2_0Dollars">      0</data>
				<data id="CMS1500.1.2_0Cents">.00</data>
				<data id="CMS1500.1.2_1Diag1">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
				</data>
				<data id="CMS1500.1.2_1Diag2">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
				</data>
				<data id="CMS1500.1.2_1Diag3">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
				</data>
				<data id="CMS1500.1.2_1Diag4">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
				</data>
				<data id="CMS1500.1.2_2Code"> </data>
				<data id="CMS1500.1.2_2Number"> </data>
				<data id="CMS1500.1.2_3PriorAuth">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB'' or data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityCLIANumber1'']) > 0 and (//data[@id=''CMS1500.1.TypeOfServiceCode1''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode2''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode3''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode4''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode5''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode6''] = ''5'')">
									<xsl:value-of select="data[@id=''CMS1500.1.FacilityCLIANumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_5ID">
					<xsl:value-of select="data[@id=''CMS1500.1.FederalTaxID1'']" />
				</data>
				<data id="CMS1500.1.2_5SSN">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.FederalTaxIDType1''] = ''SSN''">X</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_5EIN">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.FederalTaxIDType1''] = ''EIN''">X</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_6Account">
					<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
				</data>
				<data id="CMS1500.1.2_7Yes">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AcceptAssignment1''] = 1">X</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_7No">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AcceptAssignment1''] = 0">X</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_8Dollars">
					<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
					<xsl:value-of select="$charges-dollars" />
				</data>
				<data id="CMS1500.1.2_8Cents">
					<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:text>.</xsl:text>
					<xsl:value-of select="$charges-cents" />
				</data>
				<data id="CMS1500.1.2_9Dollars">
					<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
					<xsl:value-of select="$paid-dollars" />
				</data>
				<data id="CMS1500.1.2_9Cents">
					<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:text>.</xsl:text>
					<xsl:value-of select="$paid-cents" />
				</data>
				<data id="CMS1500.1.3_0Dollars">
					<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
					<xsl:value-of select="$balance-dollars" />
				</data>
				<data id="CMS1500.1.3_0Cents">
					<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:text>.</xsl:text>
					<xsl:value-of select="$balance-cents" />
				</data>
				<data id="CMS1500.1.3_1Signature">
					<xsl:text xml:space="preserve">Signature on File </xsl:text>
				</data>
				<data id="CMS1500.1.3_1ProviderName">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.HasSupervisingProvider1''] != 1">
							<!-- When there isn''t a supervising provider display the rendering provider -->
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<!-- Show the supervising provider display -->
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SupervisingProviderMiddleName1''], 1, 1)" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SupervisingProviderDegree1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderDegree1'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_1Date">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.3_2Name">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>FROM: </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PickUp1'']" />
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2Street">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>TO: </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DropOff1'']" />
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2CityStateZip">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2FacilityInfo"></data>
				<data id="CMS1500.1.3_3Provider">
					<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderPrefix1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderPrefix1'']" />
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:if>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderMiddleName1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderMiddleName1'']" />
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:if>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
						<xsl:text xml:space="preserve"> </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
					</xsl:if>
				</data>
				<data id="CMS1500.1.3_3Name">
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
				</data>
				<data id="CMS1500.1.3_3Street">
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
					</xsl:if>
				</data>
				<data id="CMS1500.1.3_3CityStateZip">
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_3Phone">
					<xsl:text>(</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
					<xsl:text xml:space="preserve">) </xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
				</data>
				<data id="CMS1500.1.3_3PIN">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
				</data>
				<data id="CMS1500.1.3_3GRP">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
				</data>

				<data id="CMS1500.1.CarrierName">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</data>

				<data id="CMS1500.1.CarrierStreet">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
					</xsl:if>
				</data>

				<data id="CMS1500.1.CarrierCityStateZip">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>


				<!-- Procedure 1 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS1">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
				</data>
				<data id="CMS1500.1.cTOS1">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
				</data>
				<data id="CMS1500.1.dCPT1">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
				</data>
				<data id="CMS1500.1.dModifier1">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
				</data>
				<data id="CMS1500.1.dExtra1">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier21'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier31'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier41'']" />
				</data>
				<data id="CMS1500.1.eDiag1">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars1">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents1">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits1">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount1'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT1"> </data>
				<data id="CMS1500.1.iEMG1"> </data>
				<data id="CMS1500.1.jCOB1"> </data>
				<data id="CMS1500.1.kLocal1">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat1">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat1'']" />
				</data>
				<data id="CMS1500.1.NDC1">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC1'']" />
				</data>

				<!-- Procedure 2 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS2">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
				</data>
				<data id="CMS1500.1.cTOS2">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
				</data>
				<data id="CMS1500.1.dCPT2">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
				</data>
				<data id="CMS1500.1.dModifier2">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
				</data>
				<data id="CMS1500.1.dExtra2">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier22'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier32'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier42'']" />
				</data>
				<data id="CMS1500.1.eDiag2">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode2''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars2">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents2">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits2">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount2'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT2"> </data>
				<data id="CMS1500.1.iEMG2"> </data>
				<data id="CMS1500.1.jCOB2"> </data>
				<data id="CMS1500.1.kLocal2">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat2">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat2'']" />
				</data>
				<data id="CMS1500.1.NDC2">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC2'']" />
				</data>

				<!-- Procedure 3 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS3">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
				</data>
				<data id="CMS1500.1.cTOS3">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
				</data>
				<data id="CMS1500.1.dCPT3">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
				</data>
				<data id="CMS1500.1.dModifier3">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
				</data>
				<data id="CMS1500.1.dExtra3">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier23'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier33'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier43'']" />
				</data>
				<data id="CMS1500.1.eDiag3">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode3''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars3">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents3">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits3">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount3'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT3"> </data>
				<data id="CMS1500.1.iEMG3"> </data>
				<data id="CMS1500.1.jCOB3"> </data>
				<data id="CMS1500.1.kLocal3">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat3">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat3'']" />
				</data>
				<data id="CMS1500.1.NDC3">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC3'']" />
				</data>

				<!-- Procedure 4 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS4">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
				</data>
				<data id="CMS1500.1.cTOS4">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
				</data>
				<data id="CMS1500.1.dCPT4">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
				</data>
				<data id="CMS1500.1.dModifier4">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
				</data>
				<data id="CMS1500.1.dExtra4">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier24'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier34'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier44'']" />
				</data>
				<data id="CMS1500.1.eDiag4">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode4''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars4">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents4">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits4">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount4'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT4"> </data>
				<data id="CMS1500.1.iEMG4"> </data>
				<data id="CMS1500.1.jCOB4"> </data>
				<data id="CMS1500.1.kLocal4">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat4">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat4'']" />
				</data>
				<data id="CMS1500.1.NDC4">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC4'']" />
				</data>

				<!-- Procedure 5 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS5">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
				</data>
				<data id="CMS1500.1.cTOS5">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
				</data>
				<data id="CMS1500.1.dCPT5">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
				</data>
				<data id="CMS1500.1.dModifier5">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
				</data>
				<data id="CMS1500.1.dExtra5">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier25'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier35'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier45'']" />
				</data>
				<data id="CMS1500.1.eDiag5">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode5''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars5">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents5">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits5">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount5'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT5"> </data>
				<data id="CMS1500.1.iEMG5"> </data>
				<data id="CMS1500.1.jCOB5"> </data>
				<data id="CMS1500.1.kLocal5">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat5">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat5'']" />
				</data>
				<data id="CMS1500.1.NDC5">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC5'']" />
				</data>

				<!-- Procedure 6 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS6">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
				</data>
				<data id="CMS1500.1.cTOS6">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
				</data>
				<data id="CMS1500.1.dCPT6">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
				</data>
				<data id="CMS1500.1.dModifier6">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
				</data>
				<data id="CMS1500.1.dExtra6">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier26'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier36'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier46'']" />
				</data>
				<data id="CMS1500.1.eDiag6">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode6''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars6">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents6">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits6">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount6'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT6"> </data>
				<data id="CMS1500.1.iEMG6"> </data>
				<data id="CMS1500.1.jCOB6"> </data>
				<data id="CMS1500.1.kLocal6">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat6">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat6'']" />
				</data>
				<data id="CMS1500.1.NDC6">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC6'']" />
				</data>
			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE FormName = 'Standard'

UPDATE BillingForm
SET Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500">
			<page pageId="CMS1500.1">
				<BillID>
					<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
				</BillID>
				<data id="CMS1500.1.1_Medicare">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Medicaid">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Champus">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''CH''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Champva">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''VA''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_GroupHealthPlan"></data>
				<data id="CMS1500.1.1_Feca"></data>
				<data id="CMS1500.1.1_Other">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MB'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MC'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''CH'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''VA''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_aIDNumber">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
							<xsl:choose>
								<!-- For non-worker''s comp cases the DependentPolicyNumber is printed if the Policy Number is blank -->
								<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!-- For worker''s comp cases the patient SSN is printed if the Policy Number is blank -->
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSSN1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_PatientName">
					<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
					</xsl:if>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
				</data>
				<data id="CMS1500.1.3_MM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.3_DD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.3_YY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
				</data>
				<data id="CMS1500.1.3_M">
					<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
				</data>
				<data id="CMS1500.1.3_F">
					<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
				</data>
				<data id="CMS1500.1.4_InsuredName">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text>SAME</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.5_PatientAddress">
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
					</xsl:if>
				</data>
				<data id="CMS1500.1.5_City">
					<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
				</data>
				<data id="CMS1500.1.5_State">
					<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
				</data>
				<data id="CMS1500.1.5_Zip">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.5_Area">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
				</data>
				<data id="CMS1500.1.5_Phone">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
				</data>
				<xsl:choose>
					<xsl:when test="not(data[@id=''CMS1500.1.IsWorkersComp1''] = 1 and data[@id=''CMS1500.1.HolderThroughEmployer1''] = 1)">
						<!-- If not worker''s comp OR is worker''s comp and holder through employer is not set -->
						<data id="CMS1500.1.6_Self">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
						</data>
						<data id="CMS1500.1.6_Spouse">
							<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
						</data>
						<data id="CMS1500.1.6_Child">
							<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
						</data>
						<data id="CMS1500.1.6_Other">
							<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
						</data>
					</xsl:when>
					<xsl:otherwise>
						<!-- If this is worker''s comp and the holder through employer is checked automatically select other -->
						<data id="CMS1500.1.6_Self" />
						<data id="CMS1500.1.6_Spouse" />
						<data id="CMS1500.1.6_Child" />
						<data id="CMS1500.1.6_Other">X</data>
					</xsl:otherwise>
				</xsl:choose>
				<data id="CMS1500.1.7_InsuredAddress">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
								</xsl:if>
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text>SAME</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.7_City">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text xml:space="preserve"> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.7_State">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text xml:space="preserve"> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.7_Zip">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:choose>
									<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
										<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
										<xsl:text>-</xsl:text>
										<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text xml:space="preserve"> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
										<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
										<xsl:text>-</xsl:text>
										<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.7_Area">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text xml:space="preserve"> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.7_Phone">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
							</xsl:when>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
								<xsl:text xml:space="preserve"> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.8_Single">
					<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
				</data>
				<data id="CMS1500.1.8_Married">
					<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
				</data>
				<data id="CMS1500.1.8_Other">
					<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
				</data>
				<data id="CMS1500.1.8_Employed">
					<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
				</data>
				<data id="CMS1500.1.8_FTStud">
					<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
				</data>
				<data id="CMS1500.1.8_PTStud">
					<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
				</data>
				<data id="CMS1500.1.9_OtherName">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_aGrpNumber">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPolicyNumber1'']" />
				</data>
				<data id="CMS1500.1.9_bMM">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_bDD">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_bYYYY">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_bM">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_bF">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_cEmployer">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberEmployerName1'']" />
							</xsl:when>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.9_dPlanName">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</data>
				<data id="CMS1500.1.1_0aYes">
					<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0aNo">
					<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0bYes">
					<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0bNo">
					<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0bState">
					<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
				</data>
				<data id="CMS1500.1.1_0cYes">
					<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0cNo">
					<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
				</data>
				<data id="CMS1500.1.1_0dLocal"> </data>
				<data id="CMS1500.1.1_1GroupNumber">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1">
							<xsl:text>NONE</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.1_1aMM">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1aDD">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1aYY">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1aM">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1aF">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1bEmployer">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1cPlanName">
					<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
						<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1dYes">
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
						<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_1dNo">
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
						<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_2Signature">Signature on File</data>
				<data id="CMS1500.1.1_2Date">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_3Signature">Signature on File</data>
				<data id="CMS1500.1.1_4MM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_4DD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_4YY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_5MM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_5DD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_5YY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_6StartMM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_6StartDD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_6StartYY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_6EndMM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_6EndDD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_6EndYY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_7Referring">
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_7aID">
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
				</data>
				<data id="CMS1500.1.1_8StartMM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_8StartDD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_8StartYY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_8EndMM">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.1_8EndDD">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.1_8EndYY">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.1_9Local">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
							<!-- Not worker''s comp -->
							<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
						</xsl:when>
						<xsl:otherwise>
							<!-- Worker''s comp will display the adjuster''s name if the local use data isn''t available -->
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.LocalUseData1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterLastName1'']) > 0 or string-length(data[@id=''CMS1500.1.AdjusterFirstName1'']) > 0">
										<xsl:text>ATTN: </xsl:text>
										<xsl:value-of select="data[@id=''CMS1500.1.AdjusterFirstName1'']" />
										<xsl:text xml:space="preserve"> </xsl:text>
										<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterMiddleName1'']) > 0">
											<xsl:value-of select="substring(data[@id=''CMS1500.1.AdjusterMiddleName1''],1,1)" />
											<xsl:text>. </xsl:text>
										</xsl:if>
										<xsl:value-of select="data[@id=''CMS1500.1.AdjusterLastName1'']" />
										<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterSuffix1'']) > 0">
											<xsl:text xml:space="preserve"> </xsl:text>
											<xsl:value-of select="data[@id=''CMS1500.1.AdjusterSuffix1'']" />
										</xsl:if>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_0Yes"> </data>
				<data id="CMS1500.1.2_0No">X</data>
				<data id="CMS1500.1.2_0Dollars">      0</data>
				<data id="CMS1500.1.2_0Cents">.00</data>
				<data id="CMS1500.1.2_1Diag1">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
				</data>
				<data id="CMS1500.1.2_1Diag2">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
				</data>
				<data id="CMS1500.1.2_1Diag3">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
				</data>
				<data id="CMS1500.1.2_1Diag4">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
				</data>
				<data id="CMS1500.1.2_2Code"> </data>
				<data id="CMS1500.1.2_2Number"> </data>
				<data id="CMS1500.1.2_3PriorAuth">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB'' or data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityCLIANumber1'']) > 0 and (//data[@id=''CMS1500.1.TypeOfServiceCode1''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode2''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode3''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode4''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode5''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode6''] = ''5'')">
									<xsl:value-of select="data[@id=''CMS1500.1.FacilityCLIANumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_5ID">
					<xsl:value-of select="data[@id=''CMS1500.1.FederalTaxID1'']" />
				</data>
				<data id="CMS1500.1.2_5SSN">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.FederalTaxIDType1''] = ''SSN''">X</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_5EIN">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.FederalTaxIDType1''] = ''EIN''">X</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_6Account">
					<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
				</data>
				<data id="CMS1500.1.2_7Yes">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AcceptAssignment1''] = 1">X</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_7No">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AcceptAssignment1''] = 0">X</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.2_8Dollars">
					<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
					<xsl:value-of select="$charges-dollars" />
				</data>
				<data id="CMS1500.1.2_8Cents">
					<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:text>.</xsl:text>
					<xsl:value-of select="$charges-cents" />
				</data>
				<data id="CMS1500.1.2_9Dollars">
					<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
					<xsl:value-of select="$paid-dollars" />
				</data>
				<data id="CMS1500.1.2_9Cents">
					<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:text>.</xsl:text>
					<xsl:value-of select="$paid-cents" />
				</data>
				<data id="CMS1500.1.3_0Dollars">
					<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
					<xsl:value-of select="$balance-dollars" />
				</data>
				<data id="CMS1500.1.3_0Cents">
					<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:text>.</xsl:text>
					<xsl:value-of select="$balance-cents" />
				</data>
				<data id="CMS1500.1.3_1Signature">
					<xsl:text xml:space="preserve">Signature on File </xsl:text>
				</data>
				<data id="CMS1500.1.3_1ProviderName">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.HasSupervisingProvider1''] != 1">
							<!-- When there isn''t a supervising provider display the rendering provider -->
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<!-- Show the supervising provider display -->
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SupervisingProviderMiddleName1''], 1, 1)" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SupervisingProviderDegree1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderDegree1'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_1Date">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.3_2Name">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>FROM: </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PickUp1'']" />
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2Street">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>TO: </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DropOff1'']" />
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2CityStateZip">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2FacilityInfo">
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityInfo1'']" />
				</data>
				<data id="CMS1500.1.3_3Provider">
					<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderPrefix1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderPrefix1'']" />
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:if>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderMiddleName1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderMiddleName1'']" />
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:if>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
						<xsl:text xml:space="preserve"> </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
					</xsl:if>
				</data>
				<data id="CMS1500.1.3_3Name">
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
				</data>
				<data id="CMS1500.1.3_3Street">
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
					</xsl:if>
				</data>
				<data id="CMS1500.1.3_3CityStateZip">
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_3Phone">
					<xsl:text>(</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
					<xsl:text xml:space="preserve">) </xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
				</data>
				<data id="CMS1500.1.3_3PIN">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
				</data>
				<data id="CMS1500.1.3_3GRP">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
				</data>

				<data id="CMS1500.1.CarrierName">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</data>

				<data id="CMS1500.1.CarrierStreet">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
					<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
					</xsl:if>
				</data>

				<data id="CMS1500.1.CarrierCityStateZip">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>


				<!-- Procedure 1 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY1">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS1">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
				</data>
				<data id="CMS1500.1.cTOS1">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
				</data>
				<data id="CMS1500.1.dCPT1">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
				</data>
				<data id="CMS1500.1.dModifier1">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
				</data>
				<data id="CMS1500.1.dExtra1">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier21'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier31'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier41'']" />
				</data>
				<data id="CMS1500.1.eDiag1">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars1">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents1">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits1">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount1'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT1"> </data>
				<data id="CMS1500.1.iEMG1"> </data>
				<data id="CMS1500.1.jCOB1"> </data>
				<data id="CMS1500.1.kLocal1">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat1">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat1'']" />
				</data>
				<data id="CMS1500.1.NDC1">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC1'']" />
				</data>

				<!-- Procedure 2 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY2">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS2">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
				</data>
				<data id="CMS1500.1.cTOS2">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
				</data>
				<data id="CMS1500.1.dCPT2">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
				</data>
				<data id="CMS1500.1.dModifier2">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
				</data>
				<data id="CMS1500.1.dExtra2">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier22'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier32'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier42'']" />
				</data>
				<data id="CMS1500.1.eDiag2">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode2''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars2">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents2">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits2">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount2'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT2"> </data>
				<data id="CMS1500.1.iEMG2"> </data>
				<data id="CMS1500.1.jCOB2"> </data>
				<data id="CMS1500.1.kLocal2">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat2">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat2'']" />
				</data>
				<data id="CMS1500.1.NDC2">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC2'']" />
				</data>

				<!-- Procedure 3 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY3">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS3">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
				</data>
				<data id="CMS1500.1.cTOS3">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
				</data>
				<data id="CMS1500.1.dCPT3">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
				</data>
				<data id="CMS1500.1.dModifier3">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
				</data>
				<data id="CMS1500.1.dExtra3">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier23'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier33'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier43'']" />
				</data>
				<data id="CMS1500.1.eDiag3">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode3''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars3">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents3">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits3">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount3'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT3"> </data>
				<data id="CMS1500.1.iEMG3"> </data>
				<data id="CMS1500.1.jCOB3"> </data>
				<data id="CMS1500.1.kLocal3">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat3">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat3'']" />
				</data>
				<data id="CMS1500.1.NDC3">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC3'']" />
				</data>

				<!-- Procedure 4 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY4">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS4">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
				</data>
				<data id="CMS1500.1.cTOS4">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
				</data>
				<data id="CMS1500.1.dCPT4">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
				</data>
				<data id="CMS1500.1.dModifier4">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
				</data>
				<data id="CMS1500.1.dExtra4">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier24'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier34'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier44'']" />
				</data>
				<data id="CMS1500.1.eDiag4">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode4''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars4">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents4">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits4">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount4'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT4"> </data>
				<data id="CMS1500.1.iEMG4"> </data>
				<data id="CMS1500.1.jCOB4"> </data>
				<data id="CMS1500.1.kLocal4">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat4">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat4'']" />
				</data>
				<data id="CMS1500.1.NDC4">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC4'']" />
				</data>

				<!-- Procedure 5 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY5">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS5">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
				</data>
				<data id="CMS1500.1.cTOS5">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
				</data>
				<data id="CMS1500.1.dCPT5">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
				</data>
				<data id="CMS1500.1.dModifier5">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
				</data>
				<data id="CMS1500.1.dExtra5">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier25'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier35'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier45'']" />
				</data>
				<data id="CMS1500.1.eDiag5">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode5''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars5">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents5">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits5">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount5'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT5"> </data>
				<data id="CMS1500.1.iEMG5"> </data>
				<data id="CMS1500.1.jCOB5"> </data>
				<data id="CMS1500.1.kLocal5">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat5">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat5'']" />
				</data>
				<data id="CMS1500.1.NDC5">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC5'']" />
				</data>

				<!-- Procedure 6 -->
				<ClaimID>
					<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
				</ClaimID>
				<data id="CMS1500.1.aStartMM6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aStartDD6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aStartYY6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
				</data>
				<data id="CMS1500.1.aEndMM6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
				</data>
				<data id="CMS1500.1.aEndDD6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
				</data>
				<data id="CMS1500.1.aEndYY6">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
				</data>
				<data id="CMS1500.1.bPOS6">
					<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
				</data>
				<data id="CMS1500.1.cTOS6">
					<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
				</data>
				<data id="CMS1500.1.dCPT6">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
				</data>
				<data id="CMS1500.1.dModifier6">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
				</data>
				<data id="CMS1500.1.dExtra6">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier26'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier36'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier46'']" />
				</data>
				<data id="CMS1500.1.eDiag6">
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
					<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode6''] != ''M''">
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
						</xsl:if>
						<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
						</xsl:if>
					</xsl:if>
				</data>
				<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
					<data id="CMS1500.1.fDollars6">
						<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
						<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
						<xsl:value-of select="$charge-dollars" />
					</data>
					<data id="CMS1500.1.fCents6">
						<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
						<xsl:value-of select="$charge-cents" />
					</data>
					<data id="CMS1500.1.gUnits6">
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount6'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT6"> </data>
				<data id="CMS1500.1.iEMG6"> </data>
				<data id="CMS1500.1.jCOB6"> </data>
				<data id="CMS1500.1.kLocal6">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.NDCFormat6">
					<xsl:value-of select="data[@id=''CMS1500.1.NDCFormat6'']" />
				</data>
				<data id="CMS1500.1.NDC6">
					<xsl:value-of select="data[@id=''CMS1500.1.NDC6'']" />
				</data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE FormName = 'Standard (with Facility ID Box 32)'

UPDATE BillingForm
SET Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid">X</data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
          <xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
            <xsl:choose>
              <!-- For non-worker''s comp cases the DependentPolicyNumber is printed if the Policy Number is blank -->
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <!-- For worker''s comp cases the patient SSN is printed if the Policy Number is blank -->
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
                <xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''CMS1500.1.PatientSSN1'']" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
							</xsl:if>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1">
						<xsl:text>NONE</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderOtherID1'']" />
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local">
        <xsl:choose>
          <xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
            <!-- Not worker''s comp -->
				<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
          </xsl:when>
          <xsl:otherwise>
            <!-- Worker''s comp will display the adjuster''s name if the local use data isn''t available -->
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''CMS1500.1.LocalUseData1'']) > 0">
				<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterLastName1'']) > 0 or string-length(data[@id=''CMS1500.1.AdjusterFirstName1'']) > 0">
			<xsl:text>ATTN: </xsl:text>
			<xsl:value-of select="data[@id=''CMS1500.1.AdjusterFirstName1'']" />
			<xsl:text xml:space="preserve"> </xsl:text>
			<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterMiddleName1'']) > 0">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.AdjusterMiddleName1''],1,1)" />
				<xsl:text>. </xsl:text>
			</xsl:if>
			<xsl:value-of select="data[@id=''CMS1500.1.AdjusterLastName1'']" />
			<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterSuffix1'']) > 0">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.AdjusterSuffix1'']" />
			</xsl:if>
		</xsl:if>              
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
			</data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No">X</data>
			<data id="CMS1500.1.2_0Dollars">      0</data>
			<data id="CMS1500.1.2_0Cents">.00</data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.FederalTaxID1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.FederalTaxIDType1''] = ''SSN''">X</xsl:when>
					<xsl:otherwise> </xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_5EIN">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.FederalTaxIDType1''] = ''EIN''">X</xsl:when>
					<xsl:otherwise> </xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.AcceptAssignment1''] = 1">X</xsl:when>
					<xsl:otherwise> </xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_7No">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.AcceptAssignment1''] = 0">X</xsl:when>
					<xsl:otherwise> </xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
        <xsl:choose>
          <xsl:when test="data[@id=''CMS1500.1.HasSupervisingProvider1''] != 1">
            <!-- When there isn''t a supervising provider display the rendering provider -->
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <!-- Show the supervising provider display -->
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderFirstName1'']" />
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''CMS1500.1.SupervisingProviderMiddleName1''], 1, 1)" />
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLastName1'']" />
            <xsl:if test="string-length(data[@id=''CMS1500.1.SupervisingProviderDegree1'']) > 0">
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderDegree1'']" />
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"></data>
			<data id="CMS1500.1.3_3Provider"> 
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderPrefix1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderPrefix1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderMiddleName1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderMiddleName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier21'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier31'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier41'']" />
			</data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount1'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']" />
          </xsl:when>
          <xsl:otherwise>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
          </xsl:otherwise>
        </xsl:choose>
			</data>
      <data id="CMS1500.1.NDCFormat1">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat1'']" />
      </data>
      <data id="CMS1500.1.NDC1">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC1'']" />
      </data>

      <!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier22'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier32'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier42'']" />
			</data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode2''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount2'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']" />
          </xsl:when>
          <xsl:otherwise>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
          </xsl:otherwise>
        </xsl:choose>
			</data>
      <data id="CMS1500.1.NDCFormat2">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat2'']" />
      </data>
      <data id="CMS1500.1.NDC2">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC2'']" />
      </data>

      <!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier23'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier33'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier43'']" />
			</data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode3''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount3'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']" />
          </xsl:when>
          <xsl:otherwise>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
          </xsl:otherwise>
        </xsl:choose>
			</data>
      <data id="CMS1500.1.NDCFormat3">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat3'']" />
      </data>
      <data id="CMS1500.1.NDC3">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC3'']" />
      </data>

      <!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier24'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier34'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier44'']" />
			</data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode4''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount4'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']" />
          </xsl:when>
          <xsl:otherwise>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
          </xsl:otherwise>
        </xsl:choose>
			</data>
      <data id="CMS1500.1.NDCFormat4">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat4'']" />
      </data>
      <data id="CMS1500.1.NDC4">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC4'']" />
      </data>

      <!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier25'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier35'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier45'']" />
			</data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode5''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount5'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']" />
          </xsl:when>
          <xsl:otherwise>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
          </xsl:otherwise>
        </xsl:choose>
			</data>
      <data id="CMS1500.1.NDCFormat5">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat5'']" />
      </data>
      <data id="CMS1500.1.NDC5">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC5'']" />
      </data>

      <!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier26'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier36'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier46'']" />
			</data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode6''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount6'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']" />
          </xsl:when>
          <xsl:otherwise>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
          </xsl:otherwise>
        </xsl:choose>
			</data>
      <data id="CMS1500.1.NDCFormat6">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat6'']" />
      </data>
      <data id="CMS1500.1.NDC6">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC6'']" />
      </data>

    </page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE FormName = 'Medicaid of Florida'

GO


/*-----------------------------------------------------------------------------
Case 10681 - Add new report "Payment by Procedure"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptID INT 


-- Builds a static table of revenue centers. We may change to a dynamic list.
declare @RevCenterParameterList varchar(8000)
select @RevCenterParameterList = 
			(
			select name + ' (' + cast(ProcedureCodeStartRange as varchar) + '-' + cast(ProcedureCodeEndRange as varchar) + ')' as [displayText], ProcedureCodeRevenueCenterCategoryID as value
			from ProcedureCodeRevenueCenterCategory  as [value]
			order by name FOR XML auto
			)

INSERT INTO Report(
	ReportCategoryID, 
	DisplayOrder, 
	Image, 
	Name, 
	Description, 
	TaskName, 
	ReportPath, 
	ReportParameters, 
	MenuName, 
	PermissionValue
	)

VALUES(
	2, 
	10, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Payment by Procedure', 
	'This report shows the average reimbursement by procedure code over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPaymentByProcedure',
	'<?xml version="1.0" encoding="utf-8" ?>  
		<parameters>   
			<basicParameters>
				<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />    
				<basicParameter type="PracticeID" parameterName="PracticeID" />    				
				<basicParameter type="PracticeName" parameterName="rpmPracticeName" />   
				<basicParameter type="ClientTime" parameterName="ClientTime" /> 
				<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" forceDefault="true" />
				<basicParameter type="Date" parameterName="BeginDate" text="From:" />
				<basicParameter type="Date" parameterName="EndDate" text="To:"  />
			</basicParameters>   
				<extendedParameters>    
				<extendedParameter type="Separator" text="Filter" />   
				<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
					<value displayText="Posting Date" value="P" />
					<value displayText="Service Date" value="S" />
				</extendedParameter>
				<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" /> 
				<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />				
				<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
				<extendedParameter type="ComboBox" parameterName="RevenueCategory" text="Revenue Category:" description="Limits the report by Revenue Category"     default="-1" ignore="-1">
					<value displayText="ALL" value="-1" />'
					+ @RevCenterParameterList +
				'</extendedParameter> 
				<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
				<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option"    default="1">    
					<value displayText="Revenue Category" value="Revenue Category" />    
					<value displayText="Provider" value="Provider" />    
					<value displayText="Service Location" value="Service Location" />    
					<value displayText="Department" value="Department" />  
				</extendedParameter> 
			</extendedParameters>
		</parameters>',
	'Payment by &Procedure', 
	'ReadPaymentByProcedureReport')

 

SET @PaymentByProcedureRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@PaymentByProcedureRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@PaymentByProcedureRptID,
	'M',
	GETDATE()
	)


GO




/*-----------------------------------------------------------------------------
Case 10613 - Add new report "Payer Mix Summary"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptID INT 


INSERT INTO Report(
	ReportCategoryID, 
	DisplayOrder, 
	Image, 
	Name, 
	Description, 
	TaskName, 
	ReportPath, 
	ReportParameters, 
	MenuName, 
	PermissionValue
	)

VALUES(
	2, 
	25, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Payer Mix Summary', 
	'This report shows the payer mix over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPayerMixSummary',
	'<?xml version="1.0" encoding="utf-8" ?>
	<parameters>
		<basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="ClientTime" parameterName="ClientTime" />
			<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" forceDefault="true" />
			<basicParameter type="Date" parameterName="BeginDate" text="From:" />
			<basicParameter type="Date" parameterName="EndDate" text="To:"  />
		</basicParameters>
		<extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="ComboBox" parameterName="PayerMetric" text="Payer Metric:" description="Select the Payer Metric option"    default="0">
				<value displayText="All" value="0" />
				<value displayText="Payer Mix by Patients" value="1" />
				<value displayText="Payer Mix by Encounters" value="2" />
				<value displayText="Payer Mix by Procedures" value="3" />
				<value displayText="Payer Mix by Charges" value="4" />
				<value displayText="Payer Mix by Receipts" value="5" />
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
				<value displayText="Posting Date" value="P" />
				<value displayText="Service Date" value="S" />
			</extendedParameter>
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="ComboBox" parameterName="EncounterStatus" text="Status:" description="Select Encounter Status"    default="-1">
				<value displayText="All" value="-1" />
				<value displayText="Approved" value="3" />
				<value displayText="Drafts" value="1" />
				<value displayText="Submitted" value="2" />
				<value displayText="Rejected" value="4" />
				<value displayText="Unpayable" value="7" />
			</extendedParameter>
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option"    default="Provider">
				<value displayText="Revenue Category" value="Revenue Category" />
				<value displayText="Provider" value="Provider" />
				<value displayText="Service Location" value="Service Location" />
				<value displayText="Department" value="Department" />
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the grouping option"    default="Insurance Company">
				<value displayText="Payer Scenario" value="Payer Scenario" />
				<value displayText="Insurance Company" value="Insurance Company" />
				<value displayText="Insurance Plan" value="Insurance Plan" />
			</extendedParameter>
		</extendedParameters>
	</parameters>',
	'Payer Mix Summary', 
	'ReadPayerMixSummaryReport')

 

SET @PaymentByProcedureRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@PaymentByProcedureRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@PaymentByProcedureRptID,
	'M',
	GETDATE()
	)

------------------------------------------------------------------ 
-- CASE 10904 Remove AssignmentOfBenefitsFlag in Claim and Encounter
------------------------------------------------------------------

ALTER TABLE dbo.Claim
	DROP COLUMN [AssignmentOfBenefitsFlag]
GO

ALTER TABLE dbo.Encounter
	DROP CONSTRAINT [DF__Encounter__Assig__1A409775] 
GO

ALTER TABLE dbo.Encounter
	DROP COLUMN [AssignmentOfBenefitsFlag]
GO

------------------------------------------------------------------ 
-- CASE 10734 Backend changes to allow for overpayment of claims
------------------------------------------------------------------

------------------------------------------------------------------
-- Rename any multiple END transactions to MEM for a claim while
-- keeping the last END intact.
------------------------------------------------------------------
DECLARE @SettleClaimTransactions TABLE(
	ClaimID INT,
	ClaimTransactionID INT)

INSERT INTO @SettleClaimTransactions
-- Get the claim transactions for claims that have multiple END transactions
SELECT	ClaimID, ClaimTransactionID
FROM ClaimTransaction 
WHERE ClaimTransactionTypeCode = 'END'
AND ClaimID IN 
	(SELECT	ClaimID
	FROM ClaimTransaction
	WHERE ClaimTransactionTypeCode = 'END'
	GROUP BY ClaimID
	HAVING COUNT(ClaimTransactionID) > 1)

-- Remove the last END transaction for each claim
DELETE @SettleClaimTransactions
FROM @SettleClaimTransactions C
WHERE ClaimTransactionID = (
			SELECT MAX(ClaimTransactionID) 
			FROM @SettleClaimTransactions C2
			WHERE C2.ClaimID = C.ClaimID)

-- Update the END and change it to a Memo
UPDATE ClaimTransaction
SET ClaimTransactionTypeCode = 'MEM',
	Notes = 'END ' + cast(Notes as varchar(max))
WHERE ClaimTransactionID IN (SELECT ClaimTransactionID FROM @SettleClaimTransactions)


GO

------------------------------------------------------------------ 
-- CASE 10733 Implement proper TOS support for procedures
------------------------------------------------------------------

-- Add TOS column to EncounterProcedure table

ALTER TABLE [dbo].[EncounterProcedure]
	ADD	[TypeOfServiceCode] [char](1) NULL

GO

-- Add FK to EncounterProcedure

ALTER TABLE [dbo].[EncounterProcedure]  WITH CHECK 
	ADD  CONSTRAINT [FK_EncounterProcedure_TypeOfServiceCode] 
	FOREIGN KEY([TypeOfServiceCode])
	REFERENCES [dbo].[TypeOfService] ([TypeOfServiceCode])

GO

-- Add TOS column to ProcedureMacroDetail

ALTER TABLE [dbo].[ProcedureMacroDetail]
	ADD	[TypeOfServiceCode] [char](1) NULL

GO

-- Add FK to ProcedureMacroDetail

ALTER TABLE [dbo].[ProcedureMacroDetail]  WITH CHECK 
	ADD  CONSTRAINT [FK_ProcedureMacroDetail_TypeOfServiceCode] 
	FOREIGN KEY([TypeOfServiceCode])
	REFERENCES [dbo].[TypeOfService] ([TypeOfServiceCode])

GO

-- Update the encounter procedures to use the default TOS for the procedure
UPDATE EncounterProcedure
SET TypeOfServiceCode = PCD.TypeOfServiceCode
FROM EncounterProcedure EP
INNER JOIN ProcedureCodeDictionary PCD
ON PCD.ProcedureCodeDictionaryID = EP.ProcedureCodeDictionaryID

-- Update the macro's default TOS to be the default TOS for the procedure
UPDATE ProcedureMacroDetail
SET TypeOfServiceCode = PCD.TypeOfServiceCode
FROM ProcedureMacroDetail PMD
INNER JOIN ProcedureCodeDictionary PCD
ON PCD.ProcedureCodeDictionaryID = PMD.ProcedureCodeDictionaryID

------------------------------------------------------------------ 
-- CASE 10926: Remove old "NOTE" field from the Patient
------------------------------------------------------------------
ALTER TABLE dbo.Patient DROP COLUMN NOTES
GO

CREATE CLUSTERED INDEX [CI_Patient_PatientID] ON [dbo].[PatientJournalNote] 
(
	[PatientID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO

/*-----------------------------------------------------------------------------
Case 10610 - Add new report "Service Locations"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptID INT 


INSERT INTO Report(
	ReportCategoryID, 
	DisplayOrder, 
	Image, 
	Name, 
	Description, 
	TaskName, 
	ReportPath, 
	ReportParameters, 
	MenuName, 
	PermissionValue
	)

VALUES(
	9, 
	50, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Service Locations', 
	'This report shows a list of service locations entered for the practice.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptServiceLocations',
	'<?xml version="1.0" encoding="utf-8" ?>  
		<parameters>   
			<basicParameters>
				<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />    
				<basicParameter type="PracticeID" parameterName="PracticeID" />    				
				<basicParameter type="PracticeName" parameterName="rpmPracticeName" />   
				<basicParameter type="ClientTime" parameterName="ClientTime" /> 
				<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
			</basicParameters>   
		</parameters>',
	'Service &Locations', 
	'ReadServiceLocationsReport')

 

SET @PaymentByProcedureRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@PaymentByProcedureRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@PaymentByProcedureRptID,
	'M',
	GETDATE()
	)
GO


/*-----------------------------------------------------------------------------
Case 10605 - Add new report "Group Numbers"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptID INT 


INSERT INTO Report(
	ReportCategoryID, 
	DisplayOrder, 
	Image, 
	Name, 
	Description, 
	TaskName, 
	ReportPath, 
	ReportParameters, 
	MenuName, 
	PermissionValue
	)

VALUES(
	9, 
	5, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Group Numbers', 
	'This report shows the group numbers for providers in the practice.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptGroupNumbers',
	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters>
			<basicParameters>
				<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
				<basicParameter type="PracticeID" parameterName="PracticeID" />
				<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
				<basicParameter type="ClientTime" parameterName="ClientTime" />
				<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
			</basicParameters>
			<extendedParameters>
				<extendedParameter type="Separator" text="Filter" />
				<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
				<extendedParameter type="Insurance" parameterName="InsuranceCompanyID" text="Insurance:" default="-1" ignore="-1" />
				<extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select the grouping option"    default="Service Location">    
					<value displayText="Service Location" value="Service Location" />    
					<value displayText="Insurance" value="Insurance" />   
				</extendedParameter> 
			</extendedParameters>
		</parameters>',
	'&Group Numbers', 
	'ReadGroupNumbersReport')

 

SET @PaymentByProcedureRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@PaymentByProcedureRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@PaymentByProcedureRptID,
	'M',
	GETDATE()
	)
GO

/*-----------------------------------------------------------------------------
Case 10611 - Add new report "Providers"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptID INT 


INSERT INTO Report(
	ReportCategoryID, 
	DisplayOrder, 
	Image, 
	Name, 
	Description, 
	TaskName, 
	ReportPath, 
	ReportParameters, 
	MenuName, 
	PermissionValue
	)

VALUES(
	9, 
	7, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Providers', 
	'This report shows a list of providers associated with the practice.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptProviders',
	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters>
			<basicParameters>
				<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
				<basicParameter type="PracticeID" parameterName="PracticeID" />
				<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
				<basicParameter type="ClientTime" parameterName="ClientTime" />
				<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
			</basicParameters>
			<extendedParameters>
				<extendedParameter type="Separator" text="Filter" />
				<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			</extendedParameters>
		</parameters>',
	'&Providers', 
	'ReadProvidersReport')

 

SET @PaymentByProcedureRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@PaymentByProcedureRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@PaymentByProcedureRptID,
	'M',
	GETDATE()
	)
GO

-- MAKE Appoinment.PatientCaseID a foreing key to PatientCase table
-- first nullify  inconsistent Appointment.PatientCaseID that have no match in PatientCase table
UPDATE Appointment SET Appointment.PatientCaseID = NULL 
WHERE Appointment.PatientCaseID NOT IN (SELECT PC.PatientCaseID FROM PatientCase PC)
GO 

--then create the foreign key
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_PatientCase] FOREIGN KEY([PatientCaseID])
REFERENCES [dbo].[PatientCase] ([PatientCaseID])
GO

/*-----------------------------------------------------------------------------
Case 10996 - Add new columns to ProcedureCodeDictionary for NDC
-----------------------------------------------------------------------------*/

ALTER TABLE [dbo].[ProcedureCodeDictionary] ADD
	BillableCode varchar(128) NULL, 
	DefaultUnits int NULL,
	NDC varchar(300) NULL,
	DrugName varchar(300) NULL

GO

-- Make sure to only migrate the data when in customer 108
IF charindex('_0108_', db_name()) > 0
BEGIN
	UPDATE EP SET ServiceChargeAmount=ROUND(N.[Per Unit],2), ServiceUnitCount=N.Qty
	FROM EncounterProcedure EP INNER JOIN ProcedureCodeDictionary PCD
	ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	INNER JOIN NDCImport N
	ON PCD.ProcedureCode=N.[SPEED CODE]
	INNER JOIN Claim C
	ON EP.PracticeID=C.PracticeID AND EP.EncounterProcedureID=C.EncounterProcedureID
	WHERE EP.PracticeID=5 AND ServiceChargeAmount=0 AND ServiceUnitCount=1

	-- Update the speed codes with the additional data from NDCImport
	UPDATE	ProcedureCodeDictionary
	SET		ProcedureCode = NDC.[SPEED CODE],
			TypeOfServiceCode = '1',
			Active = 1,
			BillableCode = '99070',
			DefaultUnits = NDC.Qty,
			NDC = NDC.NDC,
			DrugName = NDC.Drug
	FROM	ProcedureCodeDictionary PCD
	INNER JOIN
			NDCImport NDC
	ON		   NDC.[SPEED CODE] = PCD.ProcedureCode

	DECLARE @ContractID INT

	-- Create a Contract Fee Schedule for the NDC related data for Practice 5
	INSERT INTO Contract(
			PracticeID,
			ContractName,
			ContractType,
			EffectiveStartDate,
			EffectiveEndDate,
			NoResponseTriggerPaper,
			NoResponseTriggerElectronic)
	VALUES	(5,
			'Master Fee Schedule',
			'S',
			'1/1/2006',
			'6/1/2007',
			45,
			45)
	
	SET @ContractID = scope_identity()

	-- Add NDC cost amounts (rounded) to the fee schedule
	INSERT INTO ContractFeeSchedule(
			ContractID,
			Gender,
			StandardFee,
			ProcedureCodeDictionaryID,
			RVU)
	SELECT	@ContractID,					-- ContractID
			'B',							-- Gender
			ROUND(NDC.[Per Unit], 2),		-- StandardFee
			PCD.ProcedureCodeDictionaryID,	-- ProcedureCodeDictionaryID
			0								-- RVU
	FROM	ProcedureCodeDictionary PCD
	INNER JOIN
			NDCImport NDC
	ON		   NDC.[SPEED CODE] = PCD.ProcedureCode

	-- Drop old tables for NDC
	DROP TABLE NDCImport
	DROP TABLE NDC$

	--Drop old business rule
	DELETE BusinessRule
	WHERE Name='Business Rule 39 NDC CMS1500 Printing'
END

/*-----------------------------------------------------------------------------
Case 11073 - Modify contracts to add a diagnosis column
-----------------------------------------------------------------------------*/
ALTER TABLE [ContractFeeSchedule]
	ADD DiagnosisCodeDictionaryID int null
GO

ALTER TABLE [ContractFeeSchedule] ADD CONSTRAINT FK_DiagnosisCodeDictionary_DiagnosisCodeDictionaryID FOREIGN KEY([DiagnosisCodeDictionaryID])
REFERENCES DiagnosisCodeDictionary (DiagnosisCodeDictionaryID)
GO	

-- clear records that don't have valid procedure code 
DELETE ContractFeeSchedule WHERE ProcedureCodeDictionaryID not in (SELECT ProcedureCodeDictionaryID FROM ProcedureCodeDictionary)

-- create the FK constraint for the ProcedureCodeDictionary - it should be created earlier, when table was created
ALTER TABLE [ContractFeeSchedule] ADD CONSTRAINT FK_ProcedureCodeDictionary_ProcedureCodeDictionaryID FOREIGN KEY([ProcedureCodeDictionaryID])
REFERENCES ProcedureCodeDictionary (ProcedureCodeDictionaryID)
GO

/*-----------------------------------------------------------------------------
Case 11073 - Modify contracts to add a Provider Tab
-----------------------------------------------------------------------------*/
CREATE TABLE [dbo].[ContractToDoctor](
	[ContractToDoctorID] [int] IDENTITY(1,1) NOT NULL,
	[RecordTimeStamp] [timestamp] NULL,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL DEFAULT (0),
	[ContractID] [int] NOT NULL,
	[DoctorID] [int] NOT NULL
) 
GO

ALTER TABLE [dbo].[ContractToDoctor]  WITH CHECK ADD  CONSTRAINT [FK_ContractToDoctor_Contract] FOREIGN KEY([ContractID])
REFERENCES [dbo].[Contract] ([ContractID])
GO

ALTER TABLE [dbo].[ContractToDoctor]  WITH CHECK ADD  CONSTRAINT [FK_ContractToDoctor_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO

-- assign for each contract all internal providers in the practice
DELETE ContractToDoctor
INSERT INTO ContractToDoctor (CreatedUserID, ModifiedUserID, ContractID, DoctorID)
SELECT 0, 0, C.ContractID, D.DoctorID FROM 
	[Contract] C, Doctor D
WHERE D.[External]=0 and C.PracticeID=D.PracticeID


/*-----------------------------------------------------------------------------
Case 11026 - Provider & Service Location HyperLink
-----------------------------------------------------------------------------*/
INSERT reportHyperlink (
	reportHyperlinkID,
	Description,
	ReportParameters,
	ModifiedDate)
Values(
	32,
	'Provider Detail Task',
	'<?xml version="1.0" encoding="utf-8" ?>
	<task name="Provider Detail">
		<object type="Kareo.Superbill.Windows.Tasks.Domain.SimpleDetailParameters">
			<method name="">
				<methodParam param="{0}" type="System.Int32" />
				<methodParam param="true" type="System.Boolean"/>
			</method>
		</object>
	</task>',
	getdate()
)


INSERT reportHyperlink (
	reportHyperlinkID,
	Description,
	ReportParameters,
	ModifiedDate)
Values(
	33,
	'Service Location Detail Task',
	'<?xml version="1.0" encoding="utf-8" ?>
	<task name="Service Location Detail">
		<object type="Kareo.Superbill.Windows.Tasks.Domain.SimpleDetailParameters">
			<method name="">
				<methodParam param="{0}" type="System.Int32" />
				<methodParam param="true" type="System.Boolean"/>
			</method>
		</object>
	</task>',
	getdate())

GO

/*-----------------------------------------------------------------------------
Case 11093 - Add column in PatientJournalNote to denote which note to display for account status
-----------------------------------------------------------------------------*/

ALTER TABLE [dbo].[PatientJournalNote]
	ADD	[AccountStatus] bit NULL
	CONSTRAINT DF_PatientJournalNote_AccountStatus
	DEFAULT 0 WITH VALUES
GO

ALTER TABLE [dbo].[PatientJournalNote]
	ALTER COLUMN NoteMessage varchar(max)

GO



/*-----------------------------------------------------------------------------
Case 10608 - Add new report "Referring Physicians Report"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptID INT 


INSERT INTO Report(
	ReportCategoryID, 
	DisplayOrder, 
	Image, 
	Name, 
	Description, 
	TaskName, 
	ReportPath, 
	ReportParameters, 
	MenuName, 
	PermissionValue
	)

VALUES(
	9, 
	25, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Referring Physicians', 
	'This report shows a list of referring physicians entered for the practice.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptReferringPhysicians',
	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters>
			<basicParameters>
				<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
				<basicParameter type="PracticeID" parameterName="PracticeID" />
				<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
				<basicParameter type="ClientTime" parameterName="ClientTime" />
				<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
			</basicParameters>
		</parameters>',
	'&Referring Physicians', 
	'ReadReferringPhysiciansReport')

 

SET @PaymentByProcedureRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@PaymentByProcedureRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@PaymentByProcedureRptID,
	'M',
	GETDATE()
	)
GO

--Case 11000
ALTER TABLE InsuranceCompany ADD NDCFormat INT NOT NULL CONSTRAINT DF_InsuranceCompany_NDCFormat DEFAULT 1
GO

UPDATE InsuranceCompany SET NDCFormat=1
GO

/*-----------------------------------------------------------------------------
Case 11151 - Remove restriction for Medicare Style for Box 15
-----------------------------------------------------------------------------*/

UPDATE BillingForm
SET Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid">X</data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
          <xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
            <xsl:choose>
              <!-- For non-worker''s comp cases the DependentPolicyNumber is printed if the Policy Number is blank -->
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <!-- For worker''s comp cases the patient SSN is printed if the Policy Number is blank -->
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
                <xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''CMS1500.1.PatientSSN1'']" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM"></data>
			<data id="CMS1500.1.3_DD"></data>
			<data id="CMS1500.1.3_YY"></data>
			<data id="CMS1500.1.3_M"></data>
			<data id="CMS1500.1.3_F"></data>
			<data id="CMS1500.1.4_InsuredName"></data>
			<data id="CMS1500.1.5_PatientAddress"></data>
			<data id="CMS1500.1.5_City"></data>
			<data id="CMS1500.1.5_State"></data>
			<data id="CMS1500.1.5_Zip"></data>
			<data id="CMS1500.1.5_Area"></data>
			<data id="CMS1500.1.5_Phone"></data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress"></data>
			<data id="CMS1500.1.7_City"></data>
			<data id="CMS1500.1.7_State"></data>
			<data id="CMS1500.1.7_Zip"></data>
			<data id="CMS1500.1.7_Area"></data>
			<data id="CMS1500.1.7_Phone"></data>
			<data id="CMS1500.1.8_Single"></data>
			<data id="CMS1500.1.8_Married"></data>
			<data id="CMS1500.1.8_Other"></data>
			<data id="CMS1500.1.8_Employed"></data>
			<data id="CMS1500.1.8_FTStud"></data>
			<data id="CMS1500.1.8_PTStud"></data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"></data>
			<data id="CMS1500.1.1_1GroupNumber"></data>
			<data id="CMS1500.1.1_1aMM"></data>
			<data id="CMS1500.1.1_1aDD"></data>
			<data id="CMS1500.1.1_1aYY"></data>
			<data id="CMS1500.1.1_1aM"></data>
			<data id="CMS1500.1.1_1aF"></data>
			<data id="CMS1500.1.1_1bEmployer"></data>
			<data id="CMS1500.1.1_1cPlanName"></data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature"></data>
			<data id="CMS1500.1.1_2Date"></data>
			<data id="CMS1500.1.1_3Signature"></data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_5YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartMM"></data>
			<data id="CMS1500.1.1_6StartDD"></data>
			<data id="CMS1500.1.1_6StartYY"></data>
			<data id="CMS1500.1.1_6EndMM"></data>
			<data id="CMS1500.1.1_6EndDD"></data>
			<data id="CMS1500.1.1_6EndYY"></data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ReferringProviderIDNumber1'']) &lt; 1">
						<xsl:text>9111115</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_8StartMM"></data>
			<data id="CMS1500.1.1_8StartDD"></data>
			<data id="CMS1500.1.1_8StartYY"></data>
			<data id="CMS1500.1.1_8EndMM"></data>
			<data id="CMS1500.1.1_8EndDD"></data>
			<data id="CMS1500.1.1_8EndYY"></data>
			<data id="CMS1500.1.1_9Local">
        <xsl:choose>
          <xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
            <!-- Not worker''s comp -->
            <xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
          </xsl:when>
          <xsl:otherwise>
            <!-- Worker''s comp will display the adjuster''s name if the local use data isn''t available -->
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''CMS1500.1.LocalUseData1'']) > 0">
                <xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterLastName1'']) > 0 or string-length(data[@id=''CMS1500.1.AdjusterFirstName1'']) > 0">
			<xsl:text>ATTN: </xsl:text>
			<xsl:value-of select="data[@id=''CMS1500.1.AdjusterFirstName1'']" />
			<xsl:text xml:space="preserve"> </xsl:text>
			<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterMiddleName1'']) > 0">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.AdjusterMiddleName1''],1,1)" />
				<xsl:text>. </xsl:text>
			</xsl:if>
			<xsl:value-of select="data[@id=''CMS1500.1.AdjusterLastName1'']" />
			<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterSuffix1'']) > 0">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.AdjusterSuffix1'']" />
			</xsl:if>
		</xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
			</data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No"> </data>
			<data id="CMS1500.1.2_0Dollars">       </data>
			<data id="CMS1500.1.2_0Cents"> </data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID"></data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN"> </data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes"> </data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
        <xsl:choose>
          <xsl:when test="data[@id=''CMS1500.1.HasSupervisingProvider1''] != 1">
            <!-- When there isn''t a supervising provider display the rendering provider -->
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
            <xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <!-- Show the supervising provider display -->
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderFirstName1'']" />
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''CMS1500.1.SupervisingProviderMiddleName1''], 1, 1)" />
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLastName1'']" />
            <xsl:if test="string-length(data[@id=''CMS1500.1.SupervisingProviderDegree1'']) > 0">
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderDegree1'']" />
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Address"></data>
			<data id="CMS1500.1.3_3Provider"> 
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderPrefix1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderPrefix1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderMiddleName1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderMiddleName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1"></data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier21'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier31'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier41'']" />
			</data>
			<data id="CMS1500.1.eDiag1"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount1'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
          </xsl:otherwise>
        </xsl:choose>
			</data>
      <data id="CMS1500.1.NDCFormat1">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat1'']" />
      </data>
      <data id="CMS1500.1.NDC1">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC1'']" />
      </data>

      <!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2"></data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier22'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier32'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier42'']" />
			</data>
			<data id="CMS1500.1.eDiag2"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount2'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
          </xsl:otherwise>
        </xsl:choose>
      </data>
      <data id="CMS1500.1.NDCFormat2">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat2'']" />
      </data>
      <data id="CMS1500.1.NDC2">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC2'']" />
      </data>

      <!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3"></data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier23'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier33'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier43'']" />
			</data>
			<data id="CMS1500.1.eDiag3"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount3'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
          </xsl:otherwise>
        </xsl:choose>
      </data>
      <data id="CMS1500.1.NDCFormat3">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat3'']" />
      </data>
      <data id="CMS1500.1.NDC3">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC3'']" />
      </data>

      <!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4"></data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier24'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier34'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier44'']" />
			</data>
			<data id="CMS1500.1.eDiag4"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount4'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
          </xsl:otherwise>
        </xsl:choose>
      </data>
      <data id="CMS1500.1.NDCFormat4">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat4'']" />
      </data>
      <data id="CMS1500.1.NDC4">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC4'']" />
      </data>

      <!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5"></data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier25'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier35'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier45'']" />
			</data>
			<data id="CMS1500.1.eDiag5"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount5'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
          </xsl:otherwise>
        </xsl:choose>
      </data>
      <data id="CMS1500.1.NDCFormat5">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat5'']" />
      </data>
      <data id="CMS1500.1.NDC5">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC5'']" />
      </data>

      <!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6"></data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier26'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier36'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier46'']" />
			</data>
			<data id="CMS1500.1.eDiag6"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount6'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
          </xsl:otherwise>
        </xsl:choose>
      </data>
      <data id="CMS1500.1.NDCFormat6">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat6'']" />
      </data>
      <data id="CMS1500.1.NDC6">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC6'']" />
      </data>

    </page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE FormName = 'Medicaid of Ohio'

/*-----------------------------------------------------------------------------
Case 11001 - Update HCFA svg to use a transform
-----------------------------------------------------------------------------*/

-- Remove HCFA with NDC printing form since it is obsolete
DELETE FROM PrintingFormDetails
WHERE PrintingFormDetailsID = 29

DELETE FROM PrintingForm
WHERE PrintingFormID = 12

-- Update the HCFA without Background
UPDATE PrintingFormDetails
SET SVGTransform = 1,
SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<!-- HCFA SVG Transform No Background -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<!-- Y Locations for each procedure line -->
	<xsl:variable name="yProcedure1">7.36</xsl:variable>
	<xsl:variable name="yProcedure2">7.66</xsl:variable>
	<xsl:variable name="yProcedure3">8</xsl:variable>
	<xsl:variable name="yProcedure4">8.33</xsl:variable>
	<xsl:variable name="yProcedure5">8.67</xsl:variable>
	<xsl:variable name="yProcedure6">9</xsl:variable>

	<xsl:variable name="NDCFirstLineOffset">-0.0797</xsl:variable>
	<xsl:variable name="NDCSecondLineOffset">0.0703</xsl:variable>

	<!--  
				Generates regular procedure SVG for one procedure
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation - y location for this procedure
        
  -->
	<xsl:template name="GenerateProcedureSVG">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation"/>

		<g id="box24_{$currentProcedure}">
			<text x="0.37in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
			<text x="1.00in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.26in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
			<text x="1.88in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.17in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" 	y="{$yProcedureLocation}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" 	y="{$yProcedureLocation}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" 	y="{$yProcedureLocation}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" 	y="{$yProcedureLocation}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.13in" 	y="{$yProcedureLocation}in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits{$currentProcedure}" />
			<text x="6.47in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" 	y="{$yProcedureLocation}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
		</g>

	</xsl:template>


	<!--  
				Generates NDC procedure SVG for one procedure. 
				This prints over one row doubling up the NDC text in the same row.
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation - y location for this procedure
        
  -->
	<xsl:template name="GenerateNDCProcedureSVGOneLine">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation"/>

		<g id="box24_{$currentProcedure}_NDC_1row">
			<text x="0.37in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
			<text x="1.00in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.26in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
			<text x="1.88in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.17in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.13in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits{$currentProcedure}" />
			<text x="6.47in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
			<text x="0.37in" 	y="{$yProcedureLocation + $NDCSecondLineOffset}in" width="2.37in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />
			<!--<text x="0.2.8in" y="{$yProcedureLocation + $NDCSecondLineOffset}in" width="2.4in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />-->
		</g>

	</xsl:template>


	<!--  
				Generates NDC procedure SVG for one procedure. 
				This prints over two rows so it requires two procedure locations
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation1 - y location for the first procedure line
        yProcedureLocation2 - y location for the second procedure line
        
  -->
	<xsl:template name="GenerateNDCProcedureSVGTwoLine">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation1"/>
		<xsl:param name="yProcedureLocation2"/>

		<g id="box24_{$currentProcedure}_NDC_2row">
			<text x="0.37in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
			<text x="1.00in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.26in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
			<text x="1.88in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.17in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" 	y="{$yProcedureLocation1}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" 	y="{$yProcedureLocation1}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" 	y="{$yProcedureLocation1}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" 	y="{$yProcedureLocation1}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.13in" 	y="{$yProcedureLocation1}in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits{$currentProcedure}" />
			<text x="6.47in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" 	y="{$yProcedureLocation1}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
			<text x="0.37in" 	y="{$yProcedureLocation2}in" width="2.37in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />
		</g>

	</xsl:template>

	<!--  
        Takes in the number procedures to process.
        Loops through each procedure to print.
        If this is a regular procedure print in one row, if it is an NDC procedure print in two rows.
        Keep track of how many rows have been printed.
        
        Parameters:
        totalProcedures - total number of procedures to display
        currentProcedure - index of the current procedure being processed
        currentProcedureLine - current procedure line to print out
        
  -->
	<xsl:template name="CreateProcedureLayout">
		<xsl:param name="totalProcedures"/>
		<xsl:param name="currentProcedure"/>
		<xsl:param name="currentProcedureLine"/>

		<xsl:if test="$totalProcedures >= $currentProcedure">
			<!-- Get the procedure type for this procedure -->
			<xsl:variable name="NDCFormat" select="data[@id=concat(''CMS1500.1.NDCFormat'', $currentProcedure)]"/>

			<xsl:choose>
				<!-- NDC (1 line not printing on line 1) -->
				<xsl:when test="$NDCFormat = 1">
					<!-- Print the procedure information on ONE procedure line -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<!-- Note that procedure 2 y location is passed in even though this is supposed to be the first line.
									 This is due to the fact that we can''t print a one line NDC in procedure line 1. -->
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<!-- Calls the same template recursively (hardcodes the procedure line to 3 since we skipped line 1 to print NDC on line 2) -->
							<xsl:call-template name="CreateProcedureLayout">
								<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
								<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
								<xsl:with-param name="currentProcedureLine" select="3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- Calls the same template recursively -->
							<xsl:call-template name="CreateProcedureLayout">
								<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
								<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
								<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 1"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<!-- NDC (2 lines) -->
				<xsl:when test="$NDCFormat = 2">
					<!-- Print the procedure information on TWO procedure lines -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure1"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure2"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure3"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure4"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure5"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- Note this should never happen because isn''t enough room for a two line NDC starting at line 6 -->
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure6"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>


					<!-- Calls the same template recursively (increments the procedure line by two since we used up two lines) -->
					<xsl:call-template name="CreateProcedureLayout">
						<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
						<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
						<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 2"/>
					</xsl:call-template>
				</xsl:when>

				<!-- Normal Procedure -->
				<xsl:otherwise>
					<!-- Print the procedure information on one procedure lines -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure1"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>


					<!-- Calls the same template recursively (increments the procedure line by one) -->
					<xsl:call-template name="CreateProcedureLayout">
						<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
						<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
						<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 1"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>
	</xsl:template>

	<xsl:template match="/formData/page">
		<!-- Procedure count to determine how many procedures we''ll need to loop through -->
		<xsl:variable name="ProcedureCount" select="count(data[starts-with(@id,''CMS1500.1.aStartMM'')])"/>

		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="CMS1500" pageId="CMS1500.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
			<defs>
				<style type="text/css">
					<![CDATA[
		
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
				
		
	    	]]>
				</style>
			</defs>

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

      <!-- Insert the procedure rows -->
      <xsl:call-template name="CreateProcedureLayout">
        <xsl:with-param name="totalProcedures" select="$ProcedureCount"/>
        <xsl:with-param name="currentProcedure" select="1"/>
        <xsl:with-param name="currentProcedureLine" select="1"/>
      </xsl:call-template>

      <g id="box31">
				<text x="0.37in" y="9.95in" width="2.2in" height="0.1in" valueSource="CMS1500.1.3_1Signature" />
				<text x="0.37in" y="10.10in" width="2.2in" height="0.1in" valueSource="CMS1500.1.3_1ProviderName" />
				<text x="1.25in" y="10.25in" width="1.0in" height="0.1in" valueSource="CMS1500.1.3_1Date" />
			</g>

			<g id="box32">
				<text x="2.52in" y="9.79in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Name" />
				<text x="2.52in" y="9.95in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Street" />
				<text x="2.52in" y="10.11in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2CityStateZip" />
				<text x="2.52in" y="10.27in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2FacilityInfo" />
			</g>

			<g id="box33">
				<text x="5.95in" y="9.67in" width="2.30in" height="0.1in" valueSource="CMS1500.1.3_3Provider" class="smaller" />
				<text x="5.26in" y="9.79in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Name" class="smaller" />
				<text x="5.26in" y="9.91in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Street" class="smaller" />
				<text x="5.26in" y="10.03in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3CityStateZip" class="smaller" />
				<text x="5.26in" y="10.15in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Phone" class="smaller" />
				<text x="5.44in" y="10.27in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3PIN" class="smaller" />
				<text x="6.92in" y="10.27in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3GRP" class="smaller" />
			</g>
		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 1

-- Update the HCFA with Background
UPDATE PrintingFormDetails
SET SVGTransform = 1,
SVGDefinition = '<?xml version="1.0" standalone="yes"?>
<!-- HCFA SVG Transform With Background -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<!-- Y Locations for each procedure line -->
	<xsl:variable name="yProcedure1">7.36</xsl:variable>
	<xsl:variable name="yProcedure2">7.66</xsl:variable>
	<xsl:variable name="yProcedure3">8</xsl:variable>
	<xsl:variable name="yProcedure4">8.33</xsl:variable>
	<xsl:variable name="yProcedure5">8.67</xsl:variable>
	<xsl:variable name="yProcedure6">9</xsl:variable>

	<xsl:variable name="NDCFirstLineOffset">-0.0797</xsl:variable>
	<xsl:variable name="NDCSecondLineOffset">0.0703</xsl:variable>

	<!--  
				Generates regular procedure SVG for one procedure
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation - y location for this procedure
        
  -->
	<xsl:template name="GenerateProcedureSVG">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation"/>

		<g id="box24_{$currentProcedure}">
			<text x="0.37in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
			<text x="1.00in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.26in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
			<text x="1.88in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.17in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" 	y="{$yProcedureLocation}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" 	y="{$yProcedureLocation}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" 	y="{$yProcedureLocation}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" 	y="{$yProcedureLocation}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.13in" 	y="{$yProcedureLocation}in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits{$currentProcedure}" />
			<text x="6.47in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" 	y="{$yProcedureLocation}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" 	y="{$yProcedureLocation}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
		</g>

	</xsl:template>


	<!--  
				Generates NDC procedure SVG for one procedure. 
				This prints over one row doubling up the NDC text in the same row.
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation - y location for this procedure
        
  -->
	<xsl:template name="GenerateNDCProcedureSVGOneLine">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation"/>

		<g id="box24_{$currentProcedure}_NDC_1row">
			<text x="0.37in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
			<text x="1.00in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.26in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
			<text x="1.88in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.17in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.13in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits{$currentProcedure}" />
			<text x="6.47in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" 	y="{$yProcedureLocation + $NDCFirstLineOffset}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
			<text x="0.37in" 	y="{$yProcedureLocation + $NDCSecondLineOffset}in" width="2.37in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />
			<!--<text x="0.2.8in" y="{$yProcedureLocation + $NDCSecondLineOffset}in" width="2.4in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />-->
		</g>

	</xsl:template>

	
	<!--  
				Generates NDC procedure SVG for one procedure. 
				This prints over two rows so it requires two procedure locations
        
        Parameters:
        currentProcedure - index of the current procedure being processed
        yProcedureLocation1 - y location for the first procedure line
        yProcedureLocation2 - y location for the second procedure line
        
  -->
	<xsl:template name="GenerateNDCProcedureSVGTwoLine">
		<xsl:param name="currentProcedure"/>
		<xsl:param name="yProcedureLocation1"/>
		<xsl:param name="yProcedureLocation2"/>

		<g id="box24_{$currentProcedure}_NDC_2row">
			<text x="0.37in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM{$currentProcedure}" />
			<text x="0.68in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD{$currentProcedure}" />
			<text x="1.00in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY{$currentProcedure}" />
			<text x="1.26in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM{$currentProcedure}" />
			<text x="1.56in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD{$currentProcedure}" />
			<text x="1.88in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY{$currentProcedure}" />
			<text x="2.17in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS{$currentProcedure}" />
			<text x="2.44in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS{$currentProcedure}" />
			<text x="2.8in" 	y="{$yProcedureLocation1}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT{$currentProcedure}" />
			<text x="3.46in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier{$currentProcedure}" />
			<text x="3.77in" 	y="{$yProcedureLocation1}in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra{$currentProcedure}" />
			<text x="4.5in" 	y="{$yProcedureLocation1}in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag{$currentProcedure}" />
			<text x="5.23in" 	y="{$yProcedureLocation1}in" width="0.55in" height="0.1in" valueSource="CMS1500.1.fDollars{$currentProcedure}" class="money" />
			<text x="5.83in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents{$currentProcedure}" />
			<text x="6.13in" 	y="{$yProcedureLocation1}in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits{$currentProcedure}" />
			<text x="6.47in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT{$currentProcedure}" />
			<text x="6.75in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG{$currentProcedure}" />
			<text x="7.05in" 	y="{$yProcedureLocation1}in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB{$currentProcedure}" />
			<text x="7.33in" 	y="{$yProcedureLocation1}in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal{$currentProcedure}" class="smaller" />
			<text x="0.37in" 	y="{$yProcedureLocation2}in" width="2.37in" height="0.1in" valueSource="CMS1500.1.NDC{$currentProcedure}" />
		</g>

	</xsl:template>

	<!--  
        Takes in the number procedures to process.
        Loops through each procedure to print.
        If this is a regular procedure print in one row, if it is an NDC procedure print in two rows.
        Keep track of how many rows have been printed.
        
        Parameters:
        totalProcedures - total number of procedures to display
        currentProcedure - index of the current procedure being processed
        currentProcedureLine - current procedure line to print out
        
  -->
	<xsl:template name="CreateProcedureLayout">
		<xsl:param name="totalProcedures"/>
		<xsl:param name="currentProcedure"/>
		<xsl:param name="currentProcedureLine"/>

		<xsl:if test="$totalProcedures >= $currentProcedure">
			<!-- Get the procedure type for this procedure -->
			<xsl:variable name="NDCFormat" select="data[@id=concat(''CMS1500.1.NDCFormat'', $currentProcedure)]"/>

			<xsl:choose>
				<!-- NDC (1 line not printing on line 1) -->
				<xsl:when test="$NDCFormat = 1">
					<!-- Print the procedure information on ONE procedure line -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<!-- Note that procedure 2 y location is passed in even though this is supposed to be the first line.
									 This is due to the fact that we can''t print a one line NDC in procedure line 1. -->
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="GenerateNDCProcedureSVGOneLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<!-- Calls the same template recursively (hardcodes the procedure line to 3 since we skipped line 1 to print NDC on line 2) -->
							<xsl:call-template name="CreateProcedureLayout">
								<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
								<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
								<xsl:with-param name="currentProcedureLine" select="3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- Calls the same template recursively -->
							<xsl:call-template name="CreateProcedureLayout">
								<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
								<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
								<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 1"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<!-- NDC (2 lines) -->
				<xsl:when test="$NDCFormat = 2">
					<!-- Print the procedure information on TWO procedure lines -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure1"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure2"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure3"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure4"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure5"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- Note this should never happen because isn''t enough room for a two line NDC starting at line 6 -->
							<xsl:call-template name="GenerateNDCProcedureSVGTwoLine">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation1" select="$yProcedure6"/>
								<xsl:with-param name="yProcedureLocation2" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>


					<!-- Calls the same template recursively (increments the procedure line by two since we used up two lines) -->
					<xsl:call-template name="CreateProcedureLayout">
						<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
						<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
						<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 2"/>
					</xsl:call-template>
				</xsl:when>

				<!-- Normal Procedure -->
				<xsl:otherwise>
					<!-- Print the procedure information on one procedure lines -->
					<xsl:choose>
						<xsl:when test="$currentProcedureLine = 1">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure1"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 2">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure2"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 3">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure3"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 4">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure4"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$currentProcedureLine = 5">
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure5"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="GenerateProcedureSVG">
								<xsl:with-param name="currentProcedure" select="$currentProcedure"/>
								<xsl:with-param name="yProcedureLocation" select="$yProcedure6"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					
					<!-- Calls the same template recursively (increments the procedure line by one) -->
					<xsl:call-template name="CreateProcedureLayout">
						<xsl:with-param name="totalProcedures" select="$totalProcedures"/>
						<xsl:with-param name="currentProcedure" select="$currentProcedure + 1"/>
						<xsl:with-param name="currentProcedureLine" select="$currentProcedureLine + 1"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>
	</xsl:template>

	<xsl:template match="/formData/page">
		<!-- Procedure count to determine how many procedures we''ll need to loop through -->
		<xsl:variable name="ProcedureCount" select="count(data[starts-with(@id,''CMS1500.1.aStartMM'')])"/>

		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="CMS1500" pageId="CMS1500.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
			<defs>
				<style type="text/css">
					<![CDATA[
		
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
				
		
	    	]]>
				</style>
			</defs>

			<image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://98291fd6-8a70-41ad-8469-65c4ee8ee8d4?type=global"></image>

			<!-- <image x="0" y="0" width="8.5in" height="11in" xlink:href="./CMS1500.1.jpg"></image> -->
	
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

      <!-- Insert the procedure rows -->
      <xsl:call-template name="CreateProcedureLayout">
        <xsl:with-param name="totalProcedures" select="$ProcedureCount"/>
        <xsl:with-param name="currentProcedure" select="1"/>
        <xsl:with-param name="currentProcedureLine" select="1"/>
      </xsl:call-template>

      <g id="box31">
				<text x="0.37in" y="9.95in" width="2.2in" height="0.1in" valueSource="CMS1500.1.3_1Signature" />
				<text x="0.37in" y="10.10in" width="2.2in" height="0.1in" valueSource="CMS1500.1.3_1ProviderName" />
				<text x="1.25in" y="10.25in" width="1.0in" height="0.1in" valueSource="CMS1500.1.3_1Date" />
			</g>

			<g id="box32">
				<text x="2.52in" y="9.79in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Name" />
				<text x="2.52in" y="9.95in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Street" />
				<text x="2.52in" y="10.11in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2CityStateZip" />
				<text x="2.52in" y="10.27in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2FacilityInfo" />
			</g>

			<g id="box33">
				<text x="5.95in" y="9.67in" width="2.30in" height="0.1in" valueSource="CMS1500.1.3_3Provider" class="smaller" />
				<text x="5.26in" y="9.79in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Name" class="smaller" />
				<text x="5.26in" y="9.91in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Street" class="smaller" />
				<text x="5.26in" y="10.03in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3CityStateZip" class="smaller" />
				<text x="5.26in" y="10.15in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Phone" class="smaller" />
				<text x="5.44in" y="10.27in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3PIN" class="smaller" />
				<text x="6.92in" y="10.27in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3GRP" class="smaller" />
			</g>
		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 16

-- Update billing form for Medicaid of Michigan to pass through the NDC fields (other billing forms are updated via other case scripts)
UPDATE BillingForm
SET Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid">X</data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
          <xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
            <xsl:choose>
              <!-- For non-worker''s comp cases the DependentPolicyNumber is printed if the Policy Number is blank -->
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <!-- For worker''s comp cases the patient SSN is printed if the Policy Number is blank -->
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
                <xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''CMS1500.1.PatientSSN1'']" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
						<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
						</xsl:if>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
						<xsl:text xml:space="preserve"> </xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>SAME</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
						<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>SAME</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="OtherSubscriberEmployerName" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="PatientEmployerName" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ReferringProviderIDNumber1'']) &lt; 1">
						<xsl:text>9111115</xsl:text>
					</xsl:when>
					<xsl:otherwise>		 
						<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>			
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local"> 
        <xsl:choose>
          <xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
            <!-- Not worker''s comp -->
				<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
          </xsl:when>
          <xsl:otherwise>
            <!-- Worker''s comp will display the adjuster''s name if the local use data isn''t available -->
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''CMS1500.1.LocalUseData1'']) > 0">
                <xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterLastName1'']) > 0 or string-length(data[@id=''CMS1500.1.AdjusterFirstName1'']) > 0">
			<xsl:text>ATTN: </xsl:text>
			<xsl:value-of select="data[@id=''CMS1500.1.AdjusterFirstName1'']" />
			<xsl:text xml:space="preserve"> </xsl:text>
			<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterMiddleName1'']) > 0">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.AdjusterMiddleName1''],1,1)" />
				<xsl:text>. </xsl:text>
			</xsl:if>
			<xsl:value-of select="data[@id=''CMS1500.1.AdjusterLastName1'']" />
			<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterSuffix1'']) > 0">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.AdjusterSuffix1'']" />
			</xsl:if>
		</xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
			</data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No"> </data>
			<data id="CMS1500.1.2_0Dollars"> </data>
			<data id="CMS1500.1.2_0Cents"> </data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.FederalTaxID1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.FederalTaxIDType1''] = ''SSN''">X</xsl:when>
					<xsl:otherwise> </xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_5EIN">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.FederalTaxIDType1''] = ''EIN''">X</xsl:when>
					<xsl:otherwise> </xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes"> </data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
        <xsl:choose>
          <xsl:when test="data[@id=''CMS1500.1.HasSupervisingProvider1''] != 1">
            <!-- When there isn''t a supervising provider display the rendering provider -->
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <!-- Show the supervising provider display -->
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderFirstName1'']" />
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="substring(data[@id=''CMS1500.1.SupervisingProviderMiddleName1''], 1, 1)" />
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLastName1'']" />
            <xsl:if test="string-length(data[@id=''CMS1500.1.SupervisingProviderDegree1'']) > 0">
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderDegree1'']" />
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"></data>
			<data id="CMS1500.1.3_3Provider"> 
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderPrefix1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderPrefix1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderMiddleName1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderMiddleName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
      <data id="CMS1500.1.cTOS1">
        <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
      </data>
      <data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier21'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier31'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier41'']" />
			</data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount1'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
          </xsl:otherwise>
        </xsl:choose>
			</data>
      <data id="CMS1500.1.NDCFormat1">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat1'']" />
      </data>
      <data id="CMS1500.1.NDC1">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC1'']" />
      </data>

      <!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
      <data id="CMS1500.1.cTOS2">
        <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
      </data>
      <data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier22'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier32'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier42'']" />
			</data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount2'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
          </xsl:otherwise>
        </xsl:choose>
      </data>
      <data id="CMS1500.1.NDCFormat2">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat2'']" />
      </data>
      <data id="CMS1500.1.NDC2">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC2'']" />
      </data>

      <!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
      <data id="CMS1500.1.cTOS3">
        <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
      </data>
      <data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier23'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier33'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier43'']" />
			</data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount3'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
          </xsl:otherwise>
        </xsl:choose>
      </data>
      <data id="CMS1500.1.NDCFormat3">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat3'']" />
      </data>
      <data id="CMS1500.1.NDC3">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC3'']" />
      </data>

      <!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
      <data id="CMS1500.1.cTOS4">
        <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
      </data>
      <data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier24'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier34'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier44'']" />
			</data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount4'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
          </xsl:otherwise>
        </xsl:choose>
      </data>
      <data id="CMS1500.1.NDCFormat4">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat4'']" />
      </data>
      <data id="CMS1500.1.NDC4">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC4'']" />
      </data>

      <!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
      <data id="CMS1500.1.cTOS5">
        <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
      </data>
      <data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier25'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier35'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier45'']" />
			</data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount5'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
          </xsl:otherwise>
        </xsl:choose>
      </data>
      <data id="CMS1500.1.NDCFormat5">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat5'']" />
      </data>
      <data id="CMS1500.1.NDC5">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC5'']" />
      </data>

      <!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
      <data id="CMS1500.1.cTOS6">
        <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
      </data>
      <data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier26'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier36'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier46'']" />
			</data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
          <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount6'']" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6">
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']) > 0">
            <xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
          </xsl:otherwise>
        </xsl:choose>
      </data>
      <data id="CMS1500.1.NDCFormat6">
        <xsl:value-of select="data[@id=''CMS1500.1.NDCFormat6'']" />
      </data>
      <data id="CMS1500.1.NDC6">
        <xsl:value-of select="data[@id=''CMS1500.1.NDC6'']" />
      </data>

    </page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE FormName = 'Medicaid of Michigan'

GO

/*-----------------------------------------------------------------------------
Case 10583 - Changed the label "Payment Type:" of the "Payments Detail" report to "Payment Method:"
-----------------------------------------------------------------------------*/
UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Method:" default="0" ignore="0"/>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
WHERE Name = 'Payments Detail'

GO


----------------------------------------------------
-- Case 11393:   Reorder menu items under Reports -> Settings menu
----------------------------------------------------
Update r 
SET DisplayOrder =
		case Name 
			when 'Providers' THEN 10
			when 'Service Locations' THEN 20
			when 'Provider Numbers' THEN 30
			when 'Group Numbers' THEN 40
			when 'Fee Schedule Detail' THEN 50
			when 'Referring Physicians' THEN 60
			else 90 END,
	modifiedDate = getdate()
from report r
where ReportCategoryID = 9

GO

----------------------------------------------------
-- Case 11394:   Reoder menu items under Reports -> Payments menu 
----------------------------------------------------
Update r
SET DisplayOrder = Case Name 
		when 'Payments Summary' THEN 10
		when 'Payments Detail' THEN 20
		when 'Payments Application' THEN 30
		when 'Missed Copays' THEN 40
		when 'Payer Mix Summary' THEN 50
		when 'Payment by Procedure' THEN 60
		ELSE 90 END,
	ModifiedDate = getdate()
from report r
where ReportCategoryID = 2 

GO







----------------------------------------------------
-- Case 10689:   Customization of hyperlink
----------------------------------------------------
-- New ReportHyperLink #11
update Reporthyperlink
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="A/R Aging by Insurance" />
			<methodParam param="true" type="System.Boolean"/>
		</method>
		<method name="Add">
			<methodParam param="ReportOverrideParameters" />
			<methodParam>
				<object type="System.Collections.Hashtable">
					<method name="" />
					<method name="Add">
						<methodParam param="Date" />
						<methodParam param="{0}" />
					</method>
					<method name="Add">
						<methodParam param="ProviderID" />
						<methodParam param="{1}" />
					</method>
					<method name="Add">
						<methodParam param="ServiceLocationID" />
						<methodParam param="{2}" />
					</method>
					<method name="Add">
						<methodParam param="DepartmentID" />
						<methodParam param="{3}" />
					</method>
					<method name="Add">
						<methodParam param="PayerScenarioID" />
						<methodParam param="{4}" />
					</method>
					<method name="Add">
						<methodParam param="BatchID" />
						<methodParam param="{5}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>'
WHERE ReportHyperLinkID = 11

Update r
SET ReportParameters = 
		'<?xml version="1.0" encoding="utf-8" ?>
		<task name="Report V2 Viewer">
			<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
				<method name="" />
				<method name="Add">
					<methodParam param="ReportName" />
					<methodParam param="A/R Aging by Patient" />
					<methodParam param="true" type="System.Boolean"/>
				</method>
				<method name="Add">
					<methodParam param="ReportOverrideParameters" />
					<methodParam>
						<object type="System.Collections.Hashtable">
							<method name="" />
							<method name="Add">
								<methodParam param="Date" />
								<methodParam param="{0}" />
							</method>
							<method name="Add">
								<methodParam param="ProviderID" />
								<methodParam param="{1}" />
							</method>
							<method name="Add">
								<methodParam param="ServiceLocationID" />
								<methodParam param="{2}" />
							</method>
							<method name="Add">
								<methodParam param="DepartmentID" />
								<methodParam param="{3}" />
							</method>
							<method name="Add">
								<methodParam param="PayerScenarioID" />
								<methodParam param="{4}" />
							</method>
							<method name="Add">
								<methodParam param="BatchID" />
								<methodParam param="{5}" />
							</method>
						</object>
					</methodParam>
				</method>
			</object>
		</task>'
from ReportHyperLink r
WHERE ReportHyperlinkID = 12


GO
--ROLLBACK
--COMMIT

