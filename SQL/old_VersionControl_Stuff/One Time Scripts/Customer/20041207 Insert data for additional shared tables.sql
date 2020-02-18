/* ------------------------------------------------------------
   FILE:         C:\Documents and Settings\rolland\Desktop\kareo_data\shared_data_inserts.sql
   
   DESCRIPTION:  Insert scripts for the following table(s)/view(s):

     [dbo].[BillingForm], [dbo].[GroupNumberType], [dbo].[HCFADiagnosisReferenceFormat]
     [dbo].[HCFASameAsInsuredFormat], [dbo].[InsuranceProgram], [dbo].[ProviderNumberType]
     [dbo].[TypeOfService]
   
   AUTHOR:       Rolland Zeleznik                                       
   
   CREATED:      12/7/2004 11:33:54                                     
   ------------------------------------------------------------ */
   
SET NOCOUNT ON
/*
PRINT 'Deleting from table: [dbo].[TypeOfService]'
DELETE FROM [dbo].[TypeOfService]

PRINT 'Deleting from table: [dbo].[ProviderNumberType]'
DELETE FROM [dbo].[ProviderNumberType]

PRINT 'Deleting from table: [dbo].[InsuranceProgram]'
DELETE FROM [dbo].[InsuranceProgram]

PRINT 'Deleting from table: [dbo].[HCFASameAsInsuredFormat]'
DELETE FROM [dbo].[HCFASameAsInsuredFormat]

PRINT 'Deleting from table: [dbo].[HCFADiagnosisReferenceFormat]'
DELETE FROM [dbo].[HCFADiagnosisReferenceFormat]

PRINT 'Deleting from table: [dbo].[GroupNumberType]'
DELETE FROM [dbo].[GroupNumberType]

PRINT 'Deleting from table: [dbo].[BillingForm]'
DELETE FROM [dbo].[BillingForm]
*/
/* Insert scripts for table: [dbo].[BillingForm] */
PRINT 'Inserting rows into table: [dbo].[BillingForm]'

SET IDENTITY_INSERT [dbo].[BillingForm] ON

/* Warning - TIMESTAMP datatype not supported for Insert scripts */
INSERT INTO [dbo].[BillingForm] ([BillingFormID], [FormType], [FormName], [Transform]) VALUES (1, 'HCFA', 'Standard', '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<!--
	===========================================================================
		BILL DETAIL
	===========================================================================
	-->
	<xsl:template match="/">
		
		<xsl:apply-templates />

	</xsl:template>

	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>

	<!--
	===========================================================================
		BILL
	===========================================================================
	-->
	<xsl:template match="BILL">

		<BILL>
			<BillID>
				<xsl:value-of select="BillID" />
			</BillID>
			<_x0031_Medicare></_x0031_Medicare>
			<_x0031_Medicaid></_x0031_Medicaid>
			<_x0031_Champus></_x0031_Champus>
			<_x0031_Champva></_x0031_Champva>
			<_x0031_GroupHealthPlan></_x0031_GroupHealthPlan>
			<_x0031_Feca></_x0031_Feca>
			<_x0031_Other></_x0031_Other>
			<_x0031_aIDNumber>
				<xsl:choose>
					<xsl:when test="string-length(PolicyNumber) > 0">
						<xsl:value-of select="PolicyNumber" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="DependentPolicyNumber" />
					</xsl:otherwise>
				</xsl:choose>
			</_x0031_aIDNumber>
			<_x0032_PatientName>
				<xsl:value-of select="PatientLastName" />
				<xsl:if test="string-length(PatientSuffix) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="PatientSuffix" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="PatientFirstName" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(PatientMiddleName, 1, 1)" />
			</_x0032_PatientName>
			<_x0033_MM>
				<xsl:value-of select="substring(PatientBirthDate, 6, 2)" />
			</_x0033_MM>
			<_x0033_DD>
				<xsl:value-of select="substring(PatientBirthDate, 9, 2)" />
			</_x0033_DD>
			<_x0033_YY>
				<xsl:value-of select="substring(PatientBirthDate, 1, 4)" />
			</_x0033_YY>
			<_x0033_M>
				<xsl:if test="PatientGender = ''M''">X</xsl:if>
			</_x0033_M>
			<_x0033_F>
				<xsl:if test="PatientGender = ''F''">X</xsl:if>	
			</_x0033_F>
			<_x0034_InsuredName>
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:value-of select="SubscriberLastName" />
							<xsl:if test="string-length(SubscriberSuffix) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="SubscriberSuffix" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="SubscriberFirstName" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(SubscriberMiddleName, 1, 1)" />
						</xsl:when>
						<xsl:when test="SubscriberDifferentFlag = ''false'' and HCFASameAsInsuredFormatCode = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="PatientLastName" />
							<xsl:if test="string-length(PatientSuffix) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="PatientSuffix" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="PatientFirstName" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(PatientMiddleName, 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0034_InsuredName>
			<_x0035_PatientAddress>
				<xsl:value-of select="PatientStreet1" />
				<xsl:if test="string-length(PatientStreet2) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="PatientStreet2" />
				</xsl:if>
			</_x0035_PatientAddress>
			<_x0035_City>
				<xsl:value-of select="PatientCity" />	
			</_x0035_City>
			<_x0035_State>
				<xsl:value-of select="PatientState" />	
			</_x0035_State>
			<_x0035_Zip>
				<xsl:choose>
					<xsl:when test="string-length(PatientZip) = 9">
						<xsl:value-of select="substring(PatientZip, 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(PatientZip, 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="PatientZip" />
					</xsl:otherwise>
				</xsl:choose>
			</_x0035_Zip>
			<_x0035_Area>
				<xsl:value-of select="substring(PatientPhone, 1, 3)" />	
			</_x0035_Area>
			<_x0035_Phone>
				<xsl:value-of select="substring(PatientPhone, 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(PatientPhone, 7, 4)" />
			</_x0035_Phone>
			<_x0036_Self>
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:if test="SubscriberDifferentFlag = ''false''">X</xsl:if>
				</xsl:if>
			</_x0036_Self>
			<_x0036_Spouse>
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:if test="PatientRelationshipToSubscriber = ''U''">X</xsl:if>
				</xsl:if>
			</_x0036_Spouse>
			<_x0036_Child>
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:if test="PatientRelationshipToSubscriber = ''C''">X</xsl:if>
				</xsl:if>
			</_x0036_Child>
			<_x0036_Other>
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:if test="PatientRelationshipToSubscriber = ''O''">X</xsl:if>
				</xsl:if>
			</_x0036_Other>
			<_x0037_InsuredAddress>
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:value-of select="SubscriberStreet1" />
							<xsl:if test="string-length(SubscriberStreet2) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="SubscriberStreet2" />
							</xsl:if>
						</xsl:when>
						<xsl:when test="SubscriberDifferentFlag = ''false'' and HCFASameAsInsuredFormatCode = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="PatientStreet1" />
							<xsl:if test="string-length(PatientStreet2) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="PatientStreet2" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0037_InsuredAddress>
			<_x0037_City> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:value-of select="SubscriberCity" />
						</xsl:when>
						<xsl:when test="SubscriberDifferentFlag = ''false'' and HCFASameAsInsuredFormatCode = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="PatientCity" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0037_City>
			<_x0037_State> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:value-of select="SubscriberState" />
						</xsl:when>
						<xsl:when test="SubscriberDifferentFlag = ''false'' and HCFASameAsInsuredFormatCode = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="PatientState" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0037_State>
			<_x0037_Zip> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:choose>
								<xsl:when test="string-length(SubscriberZip) = 9">
									<xsl:value-of select="substring(SubscriberZip, 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(SubscriberZip, 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="SubscriberZip" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="SubscriberDifferentFlag = ''false'' and HCFASameAsInsuredFormatCode = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="string-length(PatientZip) = 9">
									<xsl:value-of select="substring(PatientZip, 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(PatientZip, 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="PatientZip" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0037_Zip>
			<_x0037_Area> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:value-of select="substring(SubscriberPhone, 1, 3)" />
						</xsl:when>
						<xsl:when test="SubscriberDifferentFlag = ''false'' and HCFASameAsInsuredFormatCode = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(PatientPhone, 1, 3)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0037_Area>
			<_x0037_Phone> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:value-of select="substring(SubscriberPhone, 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(SubscriberPhone, 7, 4)" />
						</xsl:when>
						<xsl:when test="SubscriberDifferentFlag = ''false'' and HCFASameAsInsuredFormatCode = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(PatientPhone, 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(PatientPhone, 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0037_Phone>
			<_x0038_Single> 
				<xsl:if test="PatientMaritalStatus = ''S''">X</xsl:if>
			</_x0038_Single>
			<_x0038_Married> 
				<xsl:if test="PatientMaritalStatus = ''M''">X</xsl:if>
			</_x0038_Married>
			<_x0038_Other> 
				<xsl:if test="PatientMaritalStatus != ''M'' and PatientMaritalStatus != ''S''">X</xsl:if>
			</_x0038_Other>
			<_x0038_Employed> 
				<xsl:if test="PatientEmploymentStatus = ''E''">X</xsl:if>
			</_x0038_Employed>
			<_x0038_FTStud> 
				<xsl:if test="PatientEmploymentStatus = ''S''">X</xsl:if>
			</_x0038_FTStud>
			<_x0038_PTStud> 
				<xsl:if test="PatientEmploymentStatus = ''T''">X</xsl:if>
			</_x0038_PTStud>
			<_x0039_OtherName> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:value-of select="OtherSubscriberLastName" />
								<xsl:if test="string-length(OtherSubscriberSuffix) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="OtherSubscriberSuffix" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="OtherSubscriberFirstName" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(OtherSubscriberMiddleName, 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientLastName" />
								<xsl:if test="string-length(PatientSuffix) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="PatientSuffix" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="PatientFirstName" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(PatientMiddleName, 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_OtherName>
			<_x0039_aGrpNumber> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:value-of select="OtherPayerPolicyNumber" />
				</xsl:if>
			</_x0039_aGrpNumber>
			<_x0039_bMM> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:value-of select="substring(OtherSubscriberBirthDate, 6, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(PatientBirthDate, 6, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_bMM>
			<_x0039_bDD> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:value-of select="substring(OtherSubscriberBirthDate, 9, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(PatientBirthDate, 9, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_bDD>
			<_x0039_bYYYY> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:value-of select="substring(OtherSubscriberBirthDate, 1, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(PatientBirthDate, 1, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_bYYYY>
			<_x0039_bM> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:if test="OtherSubscriberGender = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="PatientGender = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_bM>
			<_x0039_bF> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:if test="OtherSubscriberGender = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="PatientGender = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_bF>
			<_x0039_cEmployer> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_cEmployer>
			<_x0039_dPlanName> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:value-of select="OtherPayerName" />
				</xsl:if>
			</_x0039_dPlanName>
			<_x0031_0aYes> 
				<xsl:if test="EmploymentRelatedFlag = ''true''">X</xsl:if>
			</_x0031_0aYes>
			<_x0031_0aNo> 
				<xsl:if test="EmploymentRelatedFlag != ''true''">X</xsl:if>
			</_x0031_0aNo>
			<_x0031_0bYes> 
				<xsl:if test="AutoAccidentRelatedFlag = ''true''">X</xsl:if>
			</_x0031_0bYes>
			<_x0031_0bNo> 
				<xsl:if test="AutoAccidentRelatedFlag != ''true''">X</xsl:if>
			</_x0031_0bNo>
			<_x0031_0bState>
				<xsl:value-of select="AutoAccidentRelatedState" />
			</_x0031_0bState>
			<_x0031_0cYes> 
				<xsl:if test="OtherAccidentRelatedFlag = ''true''">X</xsl:if>
			</_x0031_0cYes>
			<_x0031_0cNo> 
				<xsl:if test="OtherAccidentRelatedFlag != ''true''">X</xsl:if>
			</_x0031_0cNo>
			<_x0031_0dLocal> </_x0031_0dLocal>
			<_x0031_1GroupNumber> 
				<xsl:choose>
					<xsl:when test="HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1">
						<xsl:text>NONE</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="GroupNumber" />
					</xsl:otherwise>
				</xsl:choose>
			</_x0031_1GroupNumber>
			<_x0031_1aMM> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:value-of select="substring(SubscriberBirthDate, 6, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(PatientBirthDate, 6, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0031_1aMM>
			<_x0031_1aDD> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:value-of select="substring(SubscriberBirthDate, 9, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(PatientBirthDate, 9, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0031_1aDD>
			<_x0031_1aYYYY> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:value-of select="substring(SubscriberBirthDate, 1, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(PatientBirthDate, 1, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0031_1aYYYY>
			<_x0031_1aM> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:if test="SubscriberGender = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="PatientGender = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0031_1aM>
			<_x0031_1aF> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:if test="SubscriberGender = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="PatientGender = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0031_1aF>
			<_x0031_1bEmployer> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:choose>
						<xsl:when test="SubscriberDifferentFlag = ''true''">
							<xsl:value-of select="SubscriberEmployerName" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="PatientEmployerName" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</_x0031_1bEmployer>
			<_x0031_1cPlanName> 
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:value-of select="PayerName" />
				</xsl:if>
			</_x0031_1cPlanName>
			<_x0031_1dYes> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">X</xsl:if>
				</xsl:if>
			</_x0031_1dYes>
			<_x0031_1dNo> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag != ''true''">X</xsl:if>
				</xsl:if>
			</_x0031_1dNo>
			<_x0031_2Signature>Signature on File</_x0031_2Signature>
			<_x0031_2Date>
				<xsl:value-of select="substring(CurrentDate, 6, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(CurrentDate, 9, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(CurrentDate, 3, 2)" />
			</_x0031_2Date>
			<_x0031_3Signature>Signature on File</_x0031_3Signature>
			<_x0031_4MM>
				<xsl:value-of select="substring(CurrentIllnessDate, 6, 2)" />
			</_x0031_4MM>
			<_x0031_4DD>
				<xsl:value-of select="substring(CurrentIllnessDate, 9, 2)" />
			</_x0031_4DD>
			<_x0031_4YY> 
				<xsl:value-of select="substring(CurrentIllnessDate, 3, 2)" />
			</_x0031_4YY>
			<_x0031_5MM> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:value-of select="substring(SimilarIllnessDate, 6, 2)" />
				</xsl:if>
			</_x0031_5MM>
			<_x0031_5DD>
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:value-of select="substring(SimilarIllnessDate, 9, 2)" />
				</xsl:if>
			</_x0031_5DD>
			<_x0031_5YY> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:value-of select="substring(SimilarIllnessDate, 3, 2)" />
				</xsl:if>
			</_x0031_5YY>
			<_x0031_6StartMM>
				<xsl:value-of select="substring(DisabilityBeginDate, 6, 2)" />
			</_x0031_6StartMM>
			<_x0031_6StartDD>
				<xsl:value-of select="substring(DisabilityBeginDate, 9, 2)" />
			</_x0031_6StartDD>
			<_x0031_6StartYY> 
				<xsl:value-of select="substring(DisabilityBeginDate, 3, 2)" />
			</_x0031_6StartYY>
			<_x0031_6EndMM>
				<xsl:value-of select="substring(DisabilityEndDate, 6, 2)" />
			</_x0031_6EndMM>
			<_x0031_6EndDD>
				<xsl:value-of select="substring(DisabilityEndDate, 9, 2)" />
			</_x0031_6EndDD>
			<_x0031_6EndYY> 
				<xsl:value-of select="substring(DisabilityEndDate, 3, 2)" />
			</_x0031_6EndYY>
			<_x0031_7Referring>
				<xsl:value-of select="ReferringProviderFirstName" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(ReferringProviderMiddleName) > 0">
					<xsl:value-of select="substring(ReferringProviderMiddleName,1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="ReferringProviderLastName" />
				<xsl:if test="string-length(ReferringProviderDegree) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="ReferringProviderDegree" />
				</xsl:if>
			</_x0031_7Referring>
			<_x0031_7aID> 
				<xsl:value-of select="ReferringProviderIDNumber" />
			</_x0031_7aID>
			<_x0031_8StartMM> 
				<xsl:value-of select="substring(HospitalizationBeginDate, 6, 2)" />
			</_x0031_8StartMM>
			<_x0031_8StartDD> 
				<xsl:value-of select="substring(HospitalizationBeginDate, 9, 2)" />
			</_x0031_8StartDD>
			<_x0031_8StartYY> 
				<xsl:value-of select="substring(HospitalizationBeginDate, 3, 2)" />
			</_x0031_8StartYY>
			<_x0031_8EndMM> 
				<xsl:value-of select="substring(HospitalizationEndDate, 6, 2)" />
			</_x0031_8EndMM>
			<_x0031_8EndDD> 
				<xsl:value-of select="substring(HospitalizationEndDate, 9, 2)" />
			</_x0031_8EndDD>
			<_x0031_8EndYY> 
				<xsl:value-of select="substring(HospitalizationEndDate, 3, 2)" />
			</_x0031_8EndYY>
			<_x0031_9Local> </_x0031_9Local>
			<_x0032_0Yes> </_x0032_0Yes>
			<_x0032_0No>X</_x0032_0No>
			<_x0032_0Dollars>      0</_x0032_0Dollars>
			<_x0032_0Cents>.00</_x0032_0Cents>
			<_x0032_1Diag1>
				<xsl:value-of select="DiagnosisCode1" />
			</_x0032_1Diag1>
			<_x0032_1Diag2>
				<xsl:value-of select="DiagnosisCode2" />
			</_x0032_1Diag2>
			<_x0032_1Diag3>
				<xsl:value-of select="DiagnosisCode3" />
			</_x0032_1Diag3>
			<_x0032_1Diag4>
				<xsl:value-of select="DiagnosisCode4" />
			</_x0032_1Diag4>
			<_x0032_2Code> </_x0032_2Code>
			<_x0032_2Number> </_x0032_2Number>
			<_x0032_3PriorAuth>
				<xsl:value-of select="AuthorizationNumber" />
			</_x0032_3PriorAuth>
			<_x0032_5ID>
				<xsl:value-of select="PracticeEIN" />
			</_x0032_5ID>
			<_x0032_5SSN> </_x0032_5SSN>
			<_x0032_5EIN>X</_x0032_5EIN>
			<_x0032_6Account> 
				<xsl:value-of select="PatientID" />
			</_x0032_6Account>
			<_x0032_7Yes>X</_x0032_7Yes>
			<_x0032_7No> </_x0032_7No>
			<_x0032_8Dollars>
				<xsl:variable name="charges-dollars" select="substring-before(format-number(TotalChargeAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</_x0032_8Dollars>
			<_x0032_8Cents> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(TotalChargeAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</_x0032_8Cents>
			<_x0032_9Dollars> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(TotalPaidAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</_x0032_9Dollars>
			<_x0032_9Cents> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(TotalPaidAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</_x0032_9Cents>
			<_x0033_0Dollars> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(TotalBalanceAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</_x0033_0Dollars>
			<_x0033_0Cents> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(TotalBalanceAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</_x0033_0Cents>
			<_x0033_1Signature> 
				<xsl:text>Signature on File&#xD;&#xA;</xsl:text>
				<xsl:value-of select="RenderingProviderFirstName" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(RenderingProviderMiddleName, 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="RenderingProviderLastName" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="RenderingProviderDegree" />
			</_x0033_1Signature>
			<_x0033_1Date>
				<xsl:value-of select="substring(CurrentDate, 6, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(CurrentDate, 9, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(CurrentDate, 3, 2)" />
			</_x0033_1Date>
			<_x0033_2Address> 
				<xsl:value-of select="FacilityName" />
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="FacilityStreet1" />
				<xsl:if test="string-length(FacilityStreet2) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="FacilityStreet2" />
				</xsl:if>
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="FacilityCity" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="FacilityState" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(FacilityZip) = 9">
						<xsl:value-of select="substring(FacilityZip, 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(FacilityZip, 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="FacilityZip" />
					</xsl:otherwise>
				</xsl:choose>
			</_x0033_2Address>
			<_x0033_3Address> 
				<xsl:value-of select="substring(PracticePhone, 1, 3)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(PracticePhone, 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(PracticePhone, 7, 4)" />
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="PracticeName" />
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="PracticeStreet1" />
				<xsl:if test="string-length(PracticeStreet2) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="PracticeStreet2" />
				</xsl:if>
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="PracticeCity" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="PracticeState" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(PracticeZip) = 9">
						<xsl:value-of select="substring(PracticeZip, 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(PracticeZip, 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="PracticeZip" />
					</xsl:otherwise>
				</xsl:choose>
			</_x0033_3Address>
			<_x0033_3PIN>
				<xsl:value-of select="RenderingProviderIndividualNumber" />
			</_x0033_3PIN>
			<_x0033_3GRP>
				<xsl:value-of select="RenderingProviderGroupNumber" />
			</_x0033_3GRP>
			<Carrier> 
				<xsl:value-of select="PayerName" />
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="PayerStreet1" />
				<xsl:if test="string-length(PayerStreet1) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="PayerStreet2" />
				</xsl:if>
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="PayerCity" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="PayerState" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(PayerZip) = 9">
						<xsl:value-of select="substring(PayerZip, 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(PayerZip, 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="PayerZip" />
					</xsl:otherwise>
				</xsl:choose>
			</Carrier>
		</BILL>
	</xsl:template>

	<!--
	===========================================================================
		BILL PROCEDURES
	===========================================================================
	-->
	<xsl:template match="BILLPROCEDURES">
		<BILLPROCEDURES>
			<ClaimID>
				<xsl:value-of select="ClaimID" />
			</ClaimID>
			<aStartMM>
				<xsl:value-of select="substring(ServiceBeginDate, 6, 2)" />
			</aStartMM>
			<aStartDD>
				<xsl:value-of select="substring(ServiceBeginDate, 9, 2)" />
			</aStartDD>
			<aStartYY>
				<xsl:value-of select="substring(ServiceBeginDate, 3, 2)" />
			</aStartYY>
			<aEndMM>
				<xsl:value-of select="substring(ServiceEndDate, 6, 2)" />
			</aEndMM>
			<aEndDD>
				<xsl:value-of select="substring(ServiceEndDate, 9, 2)" />
			</aEndDD>
			<aEndYY>
				<xsl:value-of select="substring(ServiceEndDate, 3, 2)" />
			</aEndYY>
			<bPOS>
				<xsl:value-of select="PlaceOfServiceCode" />
			</bPOS>
			<cTOS>
				<xsl:value-of select="TypeOfServiceCode" />
			</cTOS>
			<dCPT>
				<xsl:value-of select="ProcedureCode" />
			</dCPT>
			<dModifier>
				<xsl:value-of select="ProcedureModifier1" />
			</dModifier>
			<dExtra> </dExtra>
			<eDiag>
				<xsl:value-of select="DiagnosisPointer1" />
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="string-length(DiagnosisPointer2) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="DiagnosisPointer2" />
					</xsl:if>
					<xsl:if test="string-length(DiagnosisPointer3) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="DiagnosisPointer3" />
					</xsl:if>
					<xsl:if test="string-length(DiagnosisPointer4) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="DiagnosisPointer4" />
					</xsl:if>
				</xsl:if>
			</eDiag>
			<fDollars>
				<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(ChargeAmount, ''#0.00'', ''default-format''), ''.''), ''. '')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
				<xsl:value-of select="$charge-dollars" />
			</fDollars>
			<fCents>
				<xsl:variable name="charge-cents" select="substring-after(format-number(ChargeAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="$charge-cents" />
			</fCents>
			<gUnits>
				<xsl:value-of select="format-number(ServiceUnitCount, ''0.0'', ''default-format'')" />
			</gUnits>
			<hEPSDT> </hEPSDT>
			<iEMG>N</iEMG>
			<jCOB> </jCOB>
			<kLocal>
				<xsl:value-of select="RenderingProviderLocalIdentifier" />
			</kLocal>
		</BILLPROCEDURES>
	</xsl:template>

</xsl:stylesheet>
')
INSERT INTO [dbo].[BillingForm] ([BillingFormID], [FormType], [FormName], [Transform]) VALUES (2, 'HCFA', 'Medicaid of Ohio', '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<!--
	===========================================================================
		BILL DETAIL
	===========================================================================
	-->
	<xsl:template match="/">
		
		<xsl:apply-templates />

	</xsl:template>

	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>

	<!--
	===========================================================================
		BILL
	===========================================================================
	-->
	<xsl:template match="BILL">

		<BILL>
			<BillID>
				<xsl:value-of select="BillID" />
			</BillID>
			<_x0031_Medicare></_x0031_Medicare>
			<_x0031_Medicaid>X</_x0031_Medicaid>
			<_x0031_Champus></_x0031_Champus>
			<_x0031_Champva></_x0031_Champva>
			<_x0031_GroupHealthPlan></_x0031_GroupHealthPlan>
			<_x0031_Feca></_x0031_Feca>
			<_x0031_Other></_x0031_Other>
			<_x0031_aIDNumber>
				<xsl:choose>
					<xsl:when test="string-length(PolicyNumber) > 0">
						<xsl:value-of select="PolicyNumber" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="DependentPolicyNumber" />
					</xsl:otherwise>
				</xsl:choose>
			</_x0031_aIDNumber>
			<_x0032_PatientName>
				<xsl:value-of select="PatientLastName" />
				<xsl:if test="string-length(PatientSuffix) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="PatientSuffix" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="PatientFirstName" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(PatientMiddleName, 1, 1)" />
			</_x0032_PatientName>
			<_x0033_MM></_x0033_MM>
			<_x0033_DD></_x0033_DD>
			<_x0033_YY></_x0033_YY>
			<_x0033_M></_x0033_M>
			<_x0033_F></_x0033_F>
			<_x0034_InsuredName></_x0034_InsuredName>
			<_x0035_PatientAddress></_x0035_PatientAddress>
			<_x0035_City></_x0035_City>
			<_x0035_State></_x0035_State>
			<_x0035_Zip></_x0035_Zip>
			<_x0035_Area></_x0035_Area>
			<_x0035_Phone></_x0035_Phone>
			<_x0036_Self>
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:if test="SubscriberDifferentFlag = ''false''">X</xsl:if>
				</xsl:if>
			</_x0036_Self>
			<_x0036_Spouse>
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:if test="PatientRelationshipToSubscriber = ''U''">X</xsl:if>
				</xsl:if>
			</_x0036_Spouse>
			<_x0036_Child>
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:if test="PatientRelationshipToSubscriber = ''C''">X</xsl:if>
				</xsl:if>
			</_x0036_Child>
			<_x0036_Other>
				<xsl:if test="not(HCFASameAsInsuredFormatCode = ''M'' and PayerPrecedence = 1)">
					<xsl:if test="PatientRelationshipToSubscriber = ''O''">X</xsl:if>
				</xsl:if>
			</_x0036_Other>
			<_x0037_InsuredAddress></_x0037_InsuredAddress>
			<_x0037_City></_x0037_City>
			<_x0037_State></_x0037_State>
			<_x0037_Zip></_x0037_Zip>
			<_x0037_Area></_x0037_Area>
			<_x0037_Phone></_x0037_Phone>
			<_x0038_Single></_x0038_Single>
			<_x0038_Married></_x0038_Married>
			<_x0038_Other></_x0038_Other>
			<_x0038_Employed></_x0038_Employed>
			<_x0038_FTStud></_x0038_FTStud>
			<_x0038_PTStud></_x0038_PTStud>
			<_x0039_OtherName> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:value-of select="OtherSubscriberLastName" />
								<xsl:if test="string-length(OtherSubscriberSuffix) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="OtherSubscriberSuffix" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="OtherSubscriberFirstName" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(OtherSubscriberMiddleName, 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientLastName" />
								<xsl:if test="string-length(PatientSuffix) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="PatientSuffix" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="PatientFirstName" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(PatientMiddleName, 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_OtherName>
			<_x0039_aGrpNumber> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:value-of select="OtherPayerPolicyNumber" />
				</xsl:if>
			</_x0039_aGrpNumber>
			<_x0039_bMM> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:value-of select="substring(OtherSubscriberBirthDate, 6, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(PatientBirthDate, 6, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_bMM>
			<_x0039_bDD> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:value-of select="substring(OtherSubscriberBirthDate, 9, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(PatientBirthDate, 9, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_bDD>
			<_x0039_bYYYY> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:value-of select="substring(OtherSubscriberBirthDate, 1, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(PatientBirthDate, 1, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_bYYYY>
			<_x0039_bM> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:if test="OtherSubscriberGender = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="PatientGender = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_bM>
			<_x0039_bF> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:if test="OtherSubscriberGender = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="PatientGender = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_bF>
			<_x0039_cEmployer> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">
						<xsl:choose>
							<xsl:when test="OtherSubscriberDifferentFlag = ''true''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</_x0039_cEmployer>
			<_x0039_dPlanName> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:value-of select="OtherPayerName" />
				</xsl:if>
			</_x0039_dPlanName>
			<_x0031_0aYes> 
				<xsl:if test="EmploymentRelatedFlag = ''true''">X</xsl:if>
			</_x0031_0aYes>
			<_x0031_0aNo> 
				<xsl:if test="EmploymentRelatedFlag != ''true''">X</xsl:if>
			</_x0031_0aNo>
			<_x0031_0bYes> 
				<xsl:if test="AutoAccidentRelatedFlag = ''true''">X</xsl:if>
			</_x0031_0bYes>
			<_x0031_0bNo> 
				<xsl:if test="AutoAccidentRelatedFlag != ''true''">X</xsl:if>
			</_x0031_0bNo>
			<_x0031_0bState>
				<xsl:value-of select="AutoAccidentRelatedState" />
			</_x0031_0bState>
			<_x0031_0cYes> 
				<xsl:if test="OtherAccidentRelatedFlag = ''true''">X</xsl:if>
			</_x0031_0cYes>
			<_x0031_0cNo> 
				<xsl:if test="OtherAccidentRelatedFlag != ''true''">X</xsl:if>
			</_x0031_0cNo>
			<_x0031_0dLocal><xsl:value-of select="LocalUseData" /></_x0031_0dLocal>
			<_x0031_1GroupNumber></_x0031_1GroupNumber>
			<_x0031_1aMM></_x0031_1aMM>
			<_x0031_1aDD></_x0031_1aDD>
			<_x0031_1aYYYY></_x0031_1aYYYY>
			<_x0031_1aM></_x0031_1aM>
			<_x0031_1aF></_x0031_1aF>
			<_x0031_1bEmployer></_x0031_1bEmployer>
			<_x0031_1cPlanName></_x0031_1cPlanName>
			<_x0031_1dYes> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag = ''true''">X</xsl:if>
				</xsl:if>
			</_x0031_1dYes>
			<_x0031_1dNo> 
				<xsl:if test="HCFASameAsInsuredFormatCode != ''M''">
					<xsl:if test="OtherPayerFlag != ''true''">X</xsl:if>
				</xsl:if>
			</_x0031_1dNo>
			<_x0031_2Signature></_x0031_2Signature>
			<_x0031_2Date></_x0031_2Date>
			<_x0031_3Signature></_x0031_3Signature>
			<_x0031_4MM>
				<xsl:value-of select="substring(CurrentIllnessDate, 6, 2)" />
			</_x0031_4MM>
			<_x0031_4DD>
				<xsl:value-of select="substring(CurrentIllnessDate, 9, 2)" />
			</_x0031_4DD>
			<_x0031_4YY> 
				<xsl:value-of select="substring(CurrentIllnessDate, 3, 2)" />
			</_x0031_4YY>
			<_x0031_5MM></_x0031_5MM>
			<_x0031_5DD></_x0031_5DD>
			<_x0031_5YY></_x0031_5YY>
			<_x0031_6StartMM></_x0031_6StartMM>
			<_x0031_6StartDD></_x0031_6StartDD>
			<_x0031_6StartYY></_x0031_6StartYY>
			<_x0031_6EndMM></_x0031_6EndMM>
			<_x0031_6EndDD></_x0031_6EndDD>
			<_x0031_6EndYY></_x0031_6EndYY>
			<_x0031_7Referring>
				<xsl:value-of select="ReferringProviderFirstName" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="ReferringProviderLastName" />
			</_x0031_7Referring>
			<_x0031_7aID>
				<xsl:choose>
					<xsl:when test="string-length(ReferringProviderIDNumber) &lt; 1">
						<xsl:text>9111115</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ReferringProviderIDNumber" />
					</xsl:otherwise>
				</xsl:choose>
			</_x0031_7aID>
			<_x0031_8StartMM></_x0031_8StartMM>
			<_x0031_8StartDD></_x0031_8StartDD>
			<_x0031_8StartYY></_x0031_8StartYY>
			<_x0031_8EndMM></_x0031_8EndMM>
			<_x0031_8EndDD></_x0031_8EndDD>
			<_x0031_8EndYY></_x0031_8EndYY>
			<_x0031_9Local> </_x0031_9Local>
			<_x0032_0Yes> </_x0032_0Yes>
			<_x0032_0No> </_x0032_0No>
			<_x0032_0Dollars>       </_x0032_0Dollars>
			<_x0032_0Cents> </_x0032_0Cents>
			<_x0032_1Diag1>
				<xsl:value-of select="DiagnosisCode1" />
			</_x0032_1Diag1>
			<_x0032_1Diag2>
				<xsl:value-of select="DiagnosisCode2" />
			</_x0032_1Diag2>
			<_x0032_1Diag3>
				<xsl:value-of select="DiagnosisCode3" />
			</_x0032_1Diag3>
			<_x0032_1Diag4>
				<xsl:value-of select="DiagnosisCode4" />
			</_x0032_1Diag4>
			<_x0032_2Code> </_x0032_2Code>
			<_x0032_2Number> </_x0032_2Number>
			<_x0032_3PriorAuth>
				<xsl:value-of select="AuthorizationNumber" />
			</_x0032_3PriorAuth>
			<_x0032_5ID></_x0032_5ID>
			<_x0032_5SSN> </_x0032_5SSN>
			<_x0032_5EIN> </_x0032_5EIN>
			<_x0032_6Account> 
				<xsl:value-of select="PatientID" />
			</_x0032_6Account>
			<_x0032_7Yes> </_x0032_7Yes>
			<_x0032_7No> </_x0032_7No>
			<_x0032_8Dollars>
				<xsl:variable name="charges-dollars" select="substring-before(format-number(TotalChargeAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</_x0032_8Dollars>
			<_x0032_8Cents> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(TotalChargeAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</_x0032_8Cents>
			<_x0032_9Dollars> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(TotalPaidAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</_x0032_9Dollars>
			<_x0032_9Cents> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(TotalPaidAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</_x0032_9Cents>
			<_x0033_0Dollars> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(TotalBalanceAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</_x0033_0Dollars>
			<_x0033_0Cents> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(TotalBalanceAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</_x0033_0Cents>
			<_x0033_1Signature> 
				<xsl:text>Signature on File&#xD;&#xA;</xsl:text>
				<xsl:value-of select="RenderingProviderFirstName" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(RenderingProviderMiddleName, 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="RenderingProviderLastName" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="RenderingProviderDegree" />
			</_x0033_1Signature>
			<_x0033_1Date>
				<xsl:value-of select="substring(CurrentDate, 6, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(CurrentDate, 9, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(CurrentDate, 3, 2)" />
			</_x0033_1Date>
			<_x0033_2Address></_x0033_2Address>
			<_x0033_3Address> 
				<xsl:value-of select="substring(PracticePhone, 1, 3)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(PracticePhone, 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(PracticePhone, 7, 4)" />
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="RenderingProviderPrefix" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="RenderingProviderFirstName" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="RenderingProviderMiddleName" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="RenderingProviderLastName" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="RenderingProviderDegree" />
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="PracticeStreet1" />
				<xsl:if test="string-length(PracticeStreet2) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="PracticeStreet2" />
				</xsl:if>
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="PracticeCity" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="PracticeState" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(PracticeZip) = 9">
						<xsl:value-of select="substring(PracticeZip, 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(PracticeZip, 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="PracticeZip" />
					</xsl:otherwise>
				</xsl:choose>
			</_x0033_3Address>
			<_x0033_3PIN>
				<xsl:value-of select="RenderingProviderIndividualNumber" />
			</_x0033_3PIN>
			<_x0033_3GRP>
				<xsl:value-of select="RenderingProviderGroupNumber" />
			</_x0033_3GRP>
			<Carrier> 
				<xsl:value-of select="PayerName" />
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="PayerStreet1" />
				<xsl:if test="string-length(PayerStreet1) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="PayerStreet2" />
				</xsl:if>
				<xsl:text xml:space="preserve">&#xD;&#xA;</xsl:text>
				<xsl:value-of select="PayerCity" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="PayerState" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(PayerZip) = 9">
						<xsl:value-of select="substring(PayerZip, 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(PayerZip, 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="PayerZip" />
					</xsl:otherwise>
				</xsl:choose>
			</Carrier>
		</BILL>
	</xsl:template>

	<!--
	===========================================================================
		BILL PROCEDURES
	===========================================================================
	-->
	<xsl:template match="BILLPROCEDURES">
		<BILLPROCEDURES>
			<ClaimID>
				<xsl:value-of select="ClaimID" />
			</ClaimID>
			<aStartMM>
				<xsl:value-of select="substring(ServiceBeginDate, 6, 2)" />
			</aStartMM>
			<aStartDD>
				<xsl:value-of select="substring(ServiceBeginDate, 9, 2)" />
			</aStartDD>
			<aStartYY>
				<xsl:value-of select="substring(ServiceBeginDate, 3, 2)" />
			</aStartYY>
			<aEndMM>
				<xsl:value-of select="substring(ServiceEndDate, 6, 2)" />
			</aEndMM>
			<aEndDD>
				<xsl:value-of select="substring(ServiceEndDate, 9, 2)" />
			</aEndDD>
			<aEndYY>
				<xsl:value-of select="substring(ServiceEndDate, 3, 2)" />
			</aEndYY>
			<bPOS>
				<xsl:value-of select="PlaceOfServiceCode" />
			</bPOS>
			<cTOS></cTOS>
			<dCPT>
				<xsl:value-of select="ProcedureCode" />
			</dCPT>
			<dModifier>
				<xsl:value-of select="ProcedureModifier1" />
			</dModifier>
			<dExtra> </dExtra>
			<eDiag></eDiag>
			<fDollars>
				<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(ChargeAmount, ''#0.00'', ''default-format''), ''.''), ''. '')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
				<xsl:value-of select="$charge-dollars" />
			</fDollars>
			<fCents>
				<xsl:variable name="charge-cents" select="substring-after(format-number(ChargeAmount, ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="$charge-cents" />
			</fCents>
			<gUnits>
				<xsl:value-of select="format-number(ServiceUnitCount, ''0.0'', ''default-format'')" />
			</gUnits>
			<hEPSDT> </hEPSDT>
			<iEMG> </iEMG>
			<jCOB> </jCOB>
			<kLocal></kLocal>
		</BILLPROCEDURES>
	</xsl:template>

</xsl:stylesheet>
')

SET IDENTITY_INSERT [dbo].[BillingForm] OFF


/* Insert scripts for table: [dbo].[GroupNumberType] */
PRINT 'Inserting rows into table: [dbo].[GroupNumberType]'

SET IDENTITY_INSERT [dbo].[GroupNumberType] ON

INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (1, 'Insurance Plan Specific', NULL)
INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (2, 'BC/BS Group Number', NULL)
INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (3, 'Medicare Group Provider Number', NULL)
INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (4, 'State License Number (electronic)', '0B')
INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (5, 'Blue Cross Provider Number (electronic)', '1A')
INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (6, 'Blue Shield Provider Number (electronic)', '1B')
INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (7, 'Medicare Provider Number (electronic)', '1C')
INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (8, 'Medicaid Provider Number (electronic)', '1D')
INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (9, 'CHAMPUS Identification Number (electronic)', '1H')
INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (10, 'Provider Commercial Number (electronic)', 'G2')
INSERT INTO [dbo].[GroupNumberType] ([GroupNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (11, 'State Industrial Accident Provider # (electronic)', 'X5')

SET IDENTITY_INSERT [dbo].[GroupNumberType] OFF


/* Insert scripts for table: [dbo].[HCFADiagnosisReferenceFormat] */
PRINT 'Inserting rows into table: [dbo].[HCFADiagnosisReferenceFormat]'

/* Warning - TIMESTAMP datatype not supported for Insert scripts */
INSERT INTO [dbo].[HCFADiagnosisReferenceFormat] ([HCFADiagnosisReferenceFormatCode], [FormatName]) VALUES ('C', 'Diagnosis Code in Box 21')
INSERT INTO [dbo].[HCFADiagnosisReferenceFormat] ([HCFADiagnosisReferenceFormatCode], [FormatName]) VALUES ('R', 'Reference Number in Box 21')

/* Insert scripts for table: [dbo].[HCFASameAsInsuredFormat] */
PRINT 'Inserting rows into table: [dbo].[HCFASameAsInsuredFormat]'

/* Warning - TIMESTAMP datatype not supported for Insert scripts */
INSERT INTO [dbo].[HCFASameAsInsuredFormat] ([HCFASameAsInsuredFormatCode], [FormatName]) VALUES ('D', 'Default')
INSERT INTO [dbo].[HCFASameAsInsuredFormat] ([HCFASameAsInsuredFormatCode], [FormatName]) VALUES ('M', 'Medicare style')

/* Insert scripts for table: [dbo].[InsuranceProgram] */
PRINT 'Inserting rows into table: [dbo].[InsuranceProgram]'

/* Warning - TIMESTAMP datatype not supported for Insert scripts */
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName]) VALUES ('C', 'Champus')
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName]) VALUES ('D', 'Medicaid')
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName]) VALUES ('F', 'FECA')
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName]) VALUES ('M', 'Medicare')
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName]) VALUES ('O', 'Other')
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName]) VALUES ('V', 'Champva')

/* Insert scripts for table: [dbo].[ProviderNumberType] */
PRINT 'Inserting rows into table: [dbo].[ProviderNumberType]'

SET IDENTITY_INSERT [dbo].[ProviderNumberType] ON

INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (1, 'Insurance Plan Specific', 'G2')
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (2, 'UPIN', NULL)
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (3, 'BC/BS Individual Number', NULL)
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (4, 'Medicaid Number', NULL)
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (5, 'Medicare Individual Provider Number', NULL)
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (6, 'Medicare Railroad Number', NULL)
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (7, 'Medical License Number', NULL)
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (8, 'National Provider Number', NULL)
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (9, 'State License Number (electronic)', '0B')
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (10, 'Blue Cross Provider Number (electronic)', '1A')
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (11, 'Blue Shield Provider Number (electronic)', '1B')
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (12, 'Medicare Provider Number (electronic)', '1C')
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (13, 'Medicaid Provider Number (electronic)', '1D')
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (14, 'CHAMPUS Identification Number (electronic)', '1H')
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (15, 'Provider Commercial Number (electronic)', 'G2')
INSERT INTO [dbo].[ProviderNumberType] ([ProviderNumberTypeID], [TypeName], [ANSIReferenceIdentificationQualifier]) VALUES (16, 'State Industrial Accident Provider# (electronic)', 'X5')

SET IDENTITY_INSERT [dbo].[ProviderNumberType] OFF


/* Insert scripts for table: [dbo].[TypeOfService] */
PRINT 'Inserting rows into table: [dbo].[TypeOfService]'

/* Warning - TIMESTAMP datatype not supported for Insert scripts */
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('01', 'Medical Care and Injections')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('02', 'Surgery and Maternity')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('03', 'Consultation')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('04', 'Diagnostic X-Ray - Total Component')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('05', 'Diagnostic Laboratory - Total Component')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('06', 'Radiation Therapy')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('07', 'Anesthesia')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('08', 'Surgical Assistance')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('09', 'Other Medical')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('10', 'Blood Charges')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('11', 'Used DME')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('12', 'DME (Purchase)')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('13', 'ASC Facility')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('14', 'Renal Supplies in the Home')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('15', 'Alternate Method Dialysis Payment')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('16', 'CRD Equipment')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('17', 'Pre-Admission Testing')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('18', 'DME (Rental')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('19', 'Pneumonia Vaccine')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('20', 'Second Surgical Opinion')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('21', 'Third Surgical Opinion')
INSERT INTO [dbo].[TypeOfService] ([TypeOfServiceCode], [Description]) VALUES ('99', 'Other')


