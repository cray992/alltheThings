-- BILLING FORM DEPLOYMENT

-- 2: Ohio

UPDATE BILLINGFORM SET
Transform='<?xml version="1.0" ?>
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
<!--
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
-->
				<xsl:value-of select="data[@id=''CMS1500.1.K9Number1'']" />
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
where BillingFormID=2