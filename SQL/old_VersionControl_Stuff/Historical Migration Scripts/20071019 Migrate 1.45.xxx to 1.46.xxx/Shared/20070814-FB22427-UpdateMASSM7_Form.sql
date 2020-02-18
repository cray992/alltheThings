IF NOT EXISTS(SELECT BillingFormID FROM BillingForm WHERE BillingFormID = 17)
BEGIN
	INSERT INTO BillingForm (BillingFormID, FormType, FormName, PrintingFormID, MaxProcedures, MaxDiagnosis)
	VALUES(17, 'MASSM7', 'Massachusetss Medicaid Form 7', 24, 10, 0)
END

UPDATE BillingForm
SET Transform = '<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>
	<xsl:decimal-format name="default-format" NaN="0.00"/>

	<!--      
		Generates data for one procedure.                     

		Parameters:          
			currentProcedure - index of the current procedure being processed          
	-->
	<xsl:template name="GenerateProcedureData">
		<xsl:param name="currentProcedure"/>
		<ClaimID>
			<xsl:value-of select="data[@id=concat(''MASSM7.1.ClaimID'', $currentProcedure)]"/>
		</ClaimID>
		<!--    <text x="0.59in" y="5.15in" width="1.11in" height="0.10in" valueSource="MASSM7.1.17_ServiceBeginDate{$currentProcedure}"/>    <text x="1.78in" y="5.15in" width="1.59in" height="0.10in" valueSource="MASSM7.1.18_Description{$currentProcedure}"/>    <text x="3.50in" y="5.15in" width="1.00in" height="0.10in" valueSource="MASSM7.1.19_ProcedureCode_Modifier{$currentProcedure}"/>    <text x="4.57in" y="5.15in" width="0.57in" height="0.10in" valueSource="MASSM7.1.20_NumberOfMiles{$currentProcedure}"/>    <text x="5.20in" y="5.15in" width="0.69in" height="0.10in" valueSource="MASSM7.1.21_NumberOfMinutesWaiting{$currentProcedure}"/>    <text x="5.96in" y="5.15in" width="0.31in" height="0.10in" valueSource="MASSM7.1.22_PlaceOfService{$currentProcedure}"/>    <text x="6.33in" y="5.15in" width="0.59in" height="0.10in" valueSource="MASSM7.1.23_UsualFee_Dollars{$currentProcedure}" class="money"/>    <text x="7.05in" y="5.15in" width="0.31in" height="0.10in" valueSource="MASSM7.1.23_UsualFee_Cents{$currentProcedure}"/>    <text x="7.41in" y="5.15in" width="0.52in" height="0.10in" valueSource="MASSM7.1.24_OtherPaidAmount_Dollars{$currentProcedure}" class="money"/>    <text x="8.05in" y="5.15in" width="0.23in" height="0.10in" valueSource="MASSM7.1.24_OtherPaidAmount_Cents{$currentProcedure}"/>    -->
		<data id="MASSM7.1.17_ServiceBeginDate{$currentProcedure}">
			<xsl:if test="string-length(data[@id=concat(''MASSM7.1.ServiceBeginDate'', $currentProcedure)]) &gt; 0">
				<xsl:value-of select="substring(data[@id=concat(''MASSM7.1.ServiceBeginDate'', $currentProcedure)], 1, 1)"/>
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=concat(''MASSM7.1.ServiceBeginDate'', $currentProcedure)], 2, 1)"/>
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=concat(''MASSM7.1.ServiceBeginDate'', $currentProcedure)], 4, 1)"/>
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=concat(''MASSM7.1.ServiceBeginDate'', $currentProcedure)], 5, 1)"/>
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=concat(''MASSM7.1.ServiceBeginDate'', $currentProcedure)], 9, 1)"/>
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=concat(''MASSM7.1.ServiceBeginDate'', $currentProcedure)], 10, 1)"/>
			</xsl:if>
		</data>
		<data id="MASSM7.1.18_Description{$currentProcedure}">
			<xsl:value-of select="data[@id=concat(''MASSM7.1.Description'', $currentProcedure)]"/>
		</data>
		<data id="MASSM7.1.19_ProcedureCode_Modifier{$currentProcedure}">
			<xsl:if test="string-length(data[@id=concat(''MASSM7.1.ProcedureCode'', $currentProcedure)]) &gt; 0">
				<xsl:value-of select="data[@id=concat(''MASSM7.1.ProcedureCode'', $currentProcedure)]"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="data[@id=concat(''MASSM7.1.ProcedureModifier1'', $currentProcedure)]"/>
				<xsl:value-of select="data[@id=concat(''MASSM7.1.ProcedureModifier2'', $currentProcedure)]"/>
				<xsl:value-of select="data[@id=concat(''MASSM7.1.ProcedureModifier3'', $currentProcedure)]"/>
				<xsl:value-of select="data[@id=concat(''MASSM7.1.ProcedureModifier4'', $currentProcedure)]"/>
			</xsl:if>
		</data>
		<xsl:if test="data[@id=concat(''MASSM7.1.ServiceUnitCount'', $currentProcedure)] &gt; ''0''">
			<data id="MASSM7.1.20_NumberOfMiles{$currentProcedure}">
				<xsl:value-of select="data[@id=concat(''MASSM7.1.ServiceUnitCount'', $currentProcedure)]"/>
			</data>
			<!--This field is not tracked so nothing will ever print out-->
			<data id="MASSM7.1.21_NumberOfMinutesWaiting{$currentProcedure}">
				<xsl:value-of select="data[@id=concat(''MASSM7.1.NumberOfMinutesWaiting'', $currentProcedure)]"/>
			</data>
			<data id="MASSM7.1.22_PlaceOfService{$currentProcedure}">
				<xsl:choose>
					<xsl:when test="data[@id=concat(''MASSM7.1.PlaceOfServiceCode'', $currentProcedure)] = ''11''">01</xsl:when>
					<xsl:when test="data[@id=concat(''MASSM7.1.PlaceOfServiceCode'', $currentProcedure)] = ''12''">02</xsl:when>
					<xsl:when test="data[@id=concat(''MASSM7.1.PlaceOfServiceCode'', $currentProcedure)] = ''21''">03</xsl:when>
					<xsl:when test="data[@id=concat(''MASSM7.1.PlaceOfServiceCode'', $currentProcedure)] = ''22''">04</xsl:when>
					<xsl:when test="data[@id=concat(''MASSM7.1.PlaceOfServiceCode'', $currentProcedure)] = ''23''">05</xsl:when>
					<xsl:when test="data[@id=concat(''MASSM7.1.PlaceOfServiceCode'', $currentProcedure)] = ''31'' or data[@id=concat(''MASSM7.1.PlaceOfServiceCode'', $currentProcedure)] = ''32''">06</xsl:when>
					<xsl:when test="data[@id=concat(''MASSM7.1.PlaceOfServiceCode'', $currentProcedure)] = ''33''">07</xsl:when>
					<xsl:otherwise>99</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="MASSM7.1.23_UsualFee_Dollars{$currentProcedure}">
				<xsl:variable name="charge-dollars" select="substring-before(format-number(data[@id=concat(''MASSM7.1.ChargeAmount'', $currentProcedure)], ''#0.00'', ''default-format''), ''.'')"/>
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))"/>
				<xsl:value-of select="$charge-dollars"/>
			</data>
			<data id="MASSM7.1.23_UsualFee_Cents{$currentProcedure}">
				<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=concat(''MASSM7.1.ChargeAmount'', $currentProcedure)], ''#0.00'', ''default-format''), ''.'')"/>
				<xsl:value-of select="$charge-cents"/>
			</data>
			<data id="MASSM7.1.24_OtherPaidAmount_Dollars{$currentProcedure}">
				<xsl:variable name="pay-dollars" select="substring-before(format-number(data[@id=concat(''MASSM7.1.PaidAmount'', $currentProcedure)], ''#0.00'', ''default-format''), ''.'')"/>
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))"/>
				<xsl:value-of select="$pay-dollars"/>
			</data>
			<data id="MASSM7.1.24_OtherPaidAmount_Cents{$currentProcedure}">
				<xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=concat(''MASSM7.1.PaidAmount'', $currentProcedure)], ''#0.00'', ''default-format''), ''.'')"/>
				<xsl:value-of select="$pay-cents"/>
			</data>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/formData/page">
		<formData formId="MASSM7">
			<page pageId="MASSM7.1">
				<BillID>
					<xsl:value-of select="data[@id=''MASSM7.1.BillID1'']"/>
				</BillID>
				<!--    <text x="0.32in" y="1.81in" width="3.62in" height="0.10in" valueSource="MASSM7.1.1_ProviderName"/>    <text x="0.32in" y="2.05in" width="3.62in" height="0.10in" valueSource="MASSM7.1.1_ProviderAddress"/>    <text x="0.32in" y="2.28in" width="3.62in" height="0.10in" valueSource="MASSM7.1.1_ProviderCityStateZip"/>    <text x="0.32in" y="2.53in" width="3.62in" height="0.10in" valueSource="MASSM7.1.1_ProviderTelephone"/>    -->
				<data id="MASSM7.1.1_ProviderName">
					<xsl:value-of select="data[@id=''MASSM7.1.RenderingProviderFirstName1'']"/>
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="substring(data[@id=''MASSM7.1.RenderingProviderMiddleName1''], 1, 1)"/>
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="data[@id=''MASSM7.1.RenderingProviderLastName1'']"/>
					<xsl:if test="string-length(data[@id=''MASSM7.1.RenderingProviderDegree1'']) &gt; 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''MASSM7.1.RenderingProviderDegree1'']"/>
					</xsl:if>
				</data>
				<data id="MASSM7.1.1_ProviderAddress">
					<xsl:value-of select="data[@id=''MASSM7.1.PracticeStreet11'']"/>
					<xsl:if test="string-length(data[@id=''MASSM7.1.PracticeStreet21'']) &gt; 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''MASSM7.1.PracticeStreet21'']"/>
					</xsl:if>
				</data>
				<data id="MASSM7.1.1_ProviderCityStateZip">
					<xsl:value-of select="data[@id=''MASSM7.1.PracticeCity1'']"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''MASSM7.1.PracticeState1'']"/>
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''MASSM7.1.PracticeZip1'']) = 9">
							<xsl:value-of select="substring(data[@id=''MASSM7.1.PracticeZip1''], 1, 5)"/>
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''MASSM7.1.PracticeZip1''], 6, 4)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''MASSM7.1.PracticeZip1'']"/>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="MASSM7.1.1_ProviderTelephone">
					<xsl:text>(</xsl:text>
					<xsl:value-of select="substring(data[@id=''MASSM7.1.PracticePhone1''], 1, 3)"/>
					<xsl:text xml:space="preserve">) </xsl:text>
					<xsl:value-of select="substring(data[@id=''MASSM7.1.PracticePhone1''], 4, 3)"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="substring(data[@id=''MASSM7.1.PracticePhone1''], 7, 4)"/>
				</data>
				<!--     <text x="4.17in" y="1.81in" width="1.90in" height="0.10in" valueSource="MASSM7.1.1A_BillingProviderNPI"/>    <text x="4.17in" y="2.29in" width="1.90in" height="0.10in" valueSource="MASSM7.1.1B_BillingProviderTaxonomy"/>    <text x="4.17in" y="2.67in" width="1.31in" height="0.10in" valueSource="MASSM7.1.2_ProviderNumber"/>    <text x="5.69in" y="2.67in" width="1.31in" height="0.10in" valueSource="MASSM7.1.3_BillingAgentNumber"/>    -->
				<data id="MASSM7.1.1A_BillingProviderNPI">
					<xsl:value-of select="data[@id=''MASSM7.1.BillingProviderNPI1'']"/>
				</data>
				<data id="MASSM7.1.1B_BillingProviderTaxonomy">
					<xsl:value-of select="data[@id=''MASSM7.1.BillingProviderTaxonomy1'']"/>
				</data>
				<data id="MASSM7.1.2_ProviderNumber">
					<xsl:value-of select="data[@id=''MASSM7.1.RenderingProviderMedicaidID1'']"/>
				</data>
				<!--TODO: What is the billing agent number? -->
				<data id="MASSM7.1.3_BillingAgentNumber">
					<xsl:value-of select="data[@id=''MASSM7.1.BillingAgentNumber1'']"/>
				</data>
				<!--    <text x="0.32in" y="3.10in" width="2.33in" height="0.10in" valueSource="MASSM7.1.4_MemberName"/>    <text x="3.14in" y="3.10in" width="1.89in" height="0.10in" valueSource="MASSM7.1.5_MemberIDNumber"/>    <text x="5.17in" y="3.10in" width="1.40in" height="0.10in" valueSource="MASSM7.1.6_PatientAccountNumber"/>    <text x="6.76in" y="3.10in" width="1.39in" height="0.10in" valueSource="MASSM7.1.7_PriorAuthorizationNumber"/>    -->
				<data id="MASSM7.1.4_MemberName">
					<xsl:value-of select="data[@id=''MASSM7.1.PatientFirstName1'']"/>
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:if test="string-length(data[@id=''MASSM7.1.PatientMiddleName1'']) &gt; 0">
						<xsl:value-of select="substring(data[@id=''MASSM7.1.PatientMiddleName1''], 1, 1)"/>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:if>
					<xsl:value-of select="data[@id=''MASSM7.1.PatientLastName1'']"/>
					<xsl:if test="string-length(data[@id=''MASSM7.1.PatientSuffix1'']) &gt; 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''MASSM7.1.PatientSuffix1'']"/>
					</xsl:if>
				</data>
				<data id="MASSM7.1.5_MemberIDNumber">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''MASSM7.1.PolicyNumber1'']) &gt; 0">
							<xsl:value-of select="data[@id=''MASSM7.1.PolicyNumber1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''MASSM7.1.DependentPolicyNumber1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="MASSM7.1.6_PatientAccountNumber">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''MASSM7.1.PatientAccountNumber1'']) &gt; 0">
							<xsl:value-of select="data[@id=''MASSM7.1.PatientAccountNumber1'']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''MASSM7.1.PatientLastName1'']"/>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<!--TODO: PriorAuthorizationNumber is blank on customer sample-->
				<data id="MASSM7.1.7_PriorAuthorizationNumber">
					<xsl:value-of select="data[@id=''MASSM7.1.AuthorizationNumber1'']"/>
				</data>
				<!--TODO: These are blank in the sample provided by the customer    <text x="0.32in" y="3.50in" width="2.33in" height="0.10in" valueSource="MASSM7.1.8_PrescribingProviderName"/>    <text x="2.77in" y="3.50in" width="1.32in" height="0.10in" valueSource="MASSM7.1.9_PrescribingProviderNumber"/>    -->
				<!--    <text x="4.70in" y="3.50in" width="0.53in" height="0.10in" valueSource="MASSM7.1.10_StartTime"/>    <text x="5.29in" y="3.50in" width="0.11in" height="0.10in" valueSource="MASSM7.1.10_StartTimeAM"/>    <text x="5.76in" y="3.50in" width="0.11in" height="0.10in" valueSource="MASSM7.1.10_StartTimePM"/>    -->
				<xsl:if test="string-length(data[@id=''MASSM7.1.StartTimeHour1'']) &gt; 0">
					<data id="MASSM7.1.10_StartTime">
						<xsl:value-of select="format-number(data[@id=''MASSM7.1.StartTimeHour1''], ''00'')"/>:<xsl:value-of select="format-number(data[@id=''MASSM7.1.StartTimeMin1''], ''00'')"/>
					</data>
					<data id="MASSM7.1.10_StartTimeAM">
						<xsl:if test="data[@id=''MASSM7.1.StartTimeAmPm1''] = ''A''">X</xsl:if>
					</data>
					<data id="MASSM7.1.10_StartTimePM">
						<xsl:if test="data[@id=''MASSM7.1.StartTimeAmPm1''] = ''P''">X</xsl:if>
					</data>
				</xsl:if>
				<!--    <text x="6.70in" y="3.50in" width="0.53in" height="0.10in" valueSource="MASSM7.1.10_StopTime"/>    <text x="7.29in" y="3.50in" width="0.11in" height="0.10in" valueSource="MASSM7.1.10_StopTimeAM"/>    <text x="7.78in" y="3.50in" width="0.11in" height="0.10in" valueSource="MASSM7.1.10_StopTimePM"/>    -->
				<xsl:if test="string-length(data[@id=''MASSM7.1.StopTimeHour1'']) &gt; 0">
					<data id="MASSM7.1.10_StopTime">
						<xsl:value-of select="format-number(data[@id=''MASSM7.1.StopTimeHour1''], ''00'')"/>:<xsl:value-of select="format-number(data[@id=''MASSM7.1.StopTimeMin1''], ''00'')"/>
					</data>
					<data id="MASSM7.1.10_StopTimeAM">
						<xsl:if test="data[@id=''MASSM7.1.StopTimeAmPm1''] = ''A''">X</xsl:if>
					</data>
					<data id="MASSM7.1.10_StopTimePM">
						<xsl:if test="data[@id=''MASSM7.1.StopTimeAmPm1''] = ''P''">X</xsl:if>
					</data>
				</xsl:if>
				<!--    <text x="0.66in" y="3.95in" width="0.19in" height="0.10in" valueSource="MASSM7.1.11A_AccidentRelated_NO"/>    <text x="1.32in" y="3.95in" width="0.19in" height="0.10in" valueSource="MASSM7.1.11A_AccidentRelated_YES"/>    <text x="2.40in" y="3.95in" width="0.19in" height="0.10in" valueSource="MASSM7.1.11B_AccidentRelatedReason"/>    <text x="2.85in" y="3.95in" width="1.13in" height="0.10in" valueSource="MASSM7.1.11C_AccidentDate"/>    -->
				<data id="MASSM7.1.11A_AccidentRelated_NO">
					<xsl:if test="data[@id=''MASSM7.1.AutoAccidentRelatedFlag1''] != ''1'' and data[@id=''MASSM7.1.EmploymentRelatedFlag1''] != ''1'' and data[@id=''MASSM7.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
				</data>
				<data id="MASSM7.1.11A_AccidentRelated_YES">
					<xsl:if test="data[@id=''MASSM7.1.AutoAccidentRelatedFlag1''] = ''1'' or data[@id=''MASSM7.1.EmploymentRelatedFlag1''] = ''1'' or data[@id=''MASSM7.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
				</data>
				<data id="MASSM7.1.11B_AccidentRelatedReason">
					<xsl:choose>
						<xsl:when test="data[@id=''MASSM7.1.AutoAccidentRelatedFlag1''] = ''1''">1</xsl:when>
						<xsl:when test="data[@id=''MASSM7.1.EmploymentRelatedFlag1''] = ''1''">2</xsl:when>
						<xsl:when test="data[@id=''MASSM7.1.OtherAccidentRelatedFlag1''] = ''1''">3</xsl:when>
					</xsl:choose>
				</data>
				<data id="MASSM7.1.11C_AccidentDate">
					<xsl:if test="string-length(data[@id=''MASSM7.1.AccidentDate1'']) &gt; 0">
						<xsl:value-of select="substring(data[@id=''MASSM7.1.AccidentDate1''], 1, 1)"/>
						<xsl:text xml:space="preserve"> </xsl:text>
						<xsl:value-of select="substring(data[@id=''MASSM7.1.AccidentDate1''], 2, 1)"/>
						<xsl:text xml:space="preserve">  </xsl:text>
						<xsl:value-of select="substring(data[@id=''MASSM7.1.AccidentDate1''], 4, 1)"/>
						<xsl:text xml:space="preserve"> </xsl:text>
						<xsl:value-of select="substring(data[@id=''MASSM7.1.AccidentDate1''], 5, 1)"/>
						<xsl:text xml:space="preserve">  </xsl:text>
						<xsl:value-of select="substring(data[@id=''MASSM7.1.AccidentDate1''], 9, 1)"/>
						<xsl:text xml:space="preserve"> </xsl:text>
						<xsl:value-of select="substring(data[@id=''MASSM7.1.AccidentDate1''], 10, 1)"/>
					</xsl:if>
				</data>
				<!--    <text x="4.35in" y="3.95in" width="0.19in" height="0.10in" valueSource="MASSM7.1.12_Emergency_NO"/>    <text x="4.99in" y="3.95in" width="0.19in" height="0.10in" valueSource="MASSM7.1.12_Emergency_YES"/>    -->
				<data id="MASSM7.1.12_Emergency_NO">
					<xsl:if test="data[@id=''MASSM7.1.IsEmergency1''] = ''0''">X</xsl:if>
				</data>
				<data id="MASSM7.1.12_Emergency_YES">
					<xsl:if test="data[@id=''MASSM7.1.IsEmergency1''] = ''1''">X</xsl:if>
				</data>
				<!--    <text x="6.25in" y="3.95in" width="0.19in" height="0.10in" valueSource="MASSM7.1.13_TripIndicator_OneWay"/>    <text x="6.90in" y="3.95in" width="0.19in" height="0.10in" valueSource="MASSM7.1.13_TripIndicator_RoundTrip"/>    -->
				<data id="MASSM7.1.13_TripIndicator_OneWay">
					<xsl:if test="data[@id=''MASSM7.1.AmbulanceTransportCode1''] != ''X''">X</xsl:if>
				</data>
				<data id="MASSM7.1.13_TripIndicator_RoundTrip">
					<xsl:if test="data[@id=''MASSM7.1.AmbulanceTransportCode1''] = ''X''">X</xsl:if>
				</data>
				<!--    <text x="0.32in" y="4.35in" width="3.97in" height="0.10in" valueSource="MASSM7.1.14_OriginatingLocation"/>    <text x="4.51in" y="4.35in" width="3.72in" height="0.10in" valueSource="MASSM7.1.15_DestinationLocation"/>    -->
				<data id="MASSM7.1.14_OriginatingLocation">
					<xsl:value-of select="data[@id=''MASSM7.1.PickUp1'']"/>
				</data>
				<data id="MASSM7.1.15_DestinationLocation">
					<xsl:value-of select="data[@id=''MASSM7.1.DropOff1'']"/>
				</data>
				<!--    <text x="6.45in" y="8.49in" width="0.50in" height="0.10in" valueSource="MASSM7.1.26_TotalUsualFee_Dollars" class="money"/>    <text x="7.03in" y="8.49in" width="0.23in" height="0.10in" valueSource="MASSM7.1.26_TotalUsualFee_Cents"/>    <text x="7.44in" y="8.49in" width="0.50in" height="0.10in" valueSource="MASSM7.1.27_TotalOtherPaidAmount_Dollars" class="money"/>    <text x="8.03in" y="8.49in" width="0.23in" height="0.10in" valueSource="MASSM7.1.27_TotalOtherPaidAmount_Cents"/>    -->
				<data id="MASSM7.1.26_TotalUsualFee_Dollars">
					<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''MASSM7.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
					<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))"/>
					<xsl:value-of select="$charges-dollars"/>
				</data>
				<data id="MASSM7.1.26_TotalUsualFee_Cents">
					<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''MASSM7.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
					<xsl:value-of select="$charges-cents"/>
				</data>
				<data id="MASSM7.1.27_TotalOtherPaidAmount_Dollars">
					<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''MASSM7.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
					<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))"/>
					<xsl:value-of select="$paid-dollars"/>
				</data>
				<data id="MASSM7.1.27_TotalOtherPaidAmount_Cents">
					<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''MASSM7.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')"/>
					<xsl:value-of select="$paid-cents"/>
				</data>
				<!--    <text x="0.34in" y="10.47in" width="2.50in" height="0.10in" valueSource="MASSM7.1.28_PhysicianSignature"/>    <text x="3.01in" y="10.47in" width="1.15in" height="0.10in" valueSource="MASSM7.1.29_PhysicianSignatureCurrentDate"/>    -->
				<data id="MASSM7.1.28_PhysicianSignature">
					<xsl:text>Signature on File</xsl:text>
				</data>
				<data id="MASSM7.1.29_PhysicianSignatureCurrentDate">
					<xsl:value-of select="substring(data[@id=''MASSM7.1.CurrentDate1''], 1, 1)"/>
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="substring(data[@id=''MASSM7.1.CurrentDate1''], 2, 1)"/>
					<xsl:text xml:space="preserve">  </xsl:text>
					<xsl:value-of select="substring(data[@id=''MASSM7.1.CurrentDate1''], 4, 1)"/>
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="substring(data[@id=''MASSM7.1.CurrentDate1''], 5, 1)"/>
					<xsl:text xml:space="preserve">  </xsl:text>
					<xsl:value-of select="substring(data[@id=''MASSM7.1.CurrentDate1''], 9, 1)"/>
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="substring(data[@id=''MASSM7.1.CurrentDate1''], 10, 1)"/>
				</data>
				<!-- Procedure 1 -->
				<xsl:call-template name="GenerateProcedureData">
					<xsl:with-param name="currentProcedure" select="1"/>
				</xsl:call-template>
				<!-- Procedure 2 -->
				<xsl:call-template name="GenerateProcedureData">
					<xsl:with-param name="currentProcedure" select="2"/>
				</xsl:call-template>
				<!-- Procedure 3 -->
				<xsl:call-template name="GenerateProcedureData">
					<xsl:with-param name="currentProcedure" select="3"/>
				</xsl:call-template>
				<!-- Procedure 4 -->
				<xsl:call-template name="GenerateProcedureData">
					<xsl:with-param name="currentProcedure" select="4"/>
				</xsl:call-template>
				<!-- Procedure 5 -->
				<xsl:call-template name="GenerateProcedureData">
					<xsl:with-param name="currentProcedure" select="5"/>
				</xsl:call-template>
				<!-- Procedure 6 -->
				<xsl:call-template name="GenerateProcedureData">
					<xsl:with-param name="currentProcedure" select="6"/>
				</xsl:call-template>
				<!-- Procedure 7 -->
				<xsl:call-template name="GenerateProcedureData">
					<xsl:with-param name="currentProcedure" select="7"/>
				</xsl:call-template>
				<!-- Procedure 8 -->
				<xsl:call-template name="GenerateProcedureData">
					<xsl:with-param name="currentProcedure" select="8"/>
				</xsl:call-template>
				<!-- Procedure 9 -->
				<xsl:call-template name="GenerateProcedureData">
					<xsl:with-param name="currentProcedure" select="9"/>
				</xsl:call-template>
				<!-- Procedure 10 -->
				<xsl:call-template name="GenerateProcedureData">
					<xsl:with-param name="currentProcedure" select="10"/>
				</xsl:call-template>
			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE BillingFormID = 17