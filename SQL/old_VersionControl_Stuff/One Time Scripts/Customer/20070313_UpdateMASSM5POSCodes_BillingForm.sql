/*
-----------------------------------------------------------------------------------------------------
CASE 21024 - Update Massachusetts Medicaid Form 5 Billing Form place of service codes
-----------------------------------------------------------------------------------------------------
*/

UPDATE BillingForm
SET TransForm = '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" />
  <xsl:decimal-format name="default-format" NaN="0.00" />
  <xsl:template match="/formData/page">
    <formData formId="MASSM5">
      <page pageId="MASSM5.1">
        <BillID>
          <xsl:value-of select="data[@id=''MASSM5.1.BillID1'']" />
        </BillID>
        <data id="MASSM5.1.1_MemberName">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientFirstName1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientMiddleName1''], 1, 1)" />
            <xsl:text xml:space="preserve"> </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''MASSM5.1.PatientLastName1'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientSuffix1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.PatientSuffix1'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.2_PatientBirthDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientBirthDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientBirthDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientBirthDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientBirthDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.3_InsuredName">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberFirstName1'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:if test="string-length(data[@id=''MASSM5.1.SubscriberMiddleName1'']) &gt; 0">
                <xsl:value-of select="substring(data[@id=''MASSM5.1.SubscriberMiddleName1''], 1, 1)" />
                <xsl:text xml:space="preserve"> </xsl:text>
              </xsl:if>
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberLastName1'']" />
              <xsl:if test="string-length(data[@id=''MASSM5.1.SubscriberSuffix1'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.SubscriberSuffix1'']" />
              </xsl:if>
            </xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''MASSM5.1.HCFASameAsInsuredFormatCode1''] = ''M''">
              <xsl:text>SAME</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientFirstName1'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:if test="string-length(data[@id=''MASSM5.1.PatientMiddleName1'']) &gt; 0">
                <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientMiddleName1''], 1, 1)" />
                <xsl:text xml:space="preserve"> </xsl:text>
              </xsl:if>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientLastName1'']" />
              <xsl:if test="string-length(data[@id=''MASSM5.1.PatientSuffix1'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.PatientSuffix1'']" />
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.4_MemberAddress_Street">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet11'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet21'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.4_MemberAddress_CityStateZip">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientCity1'']" />
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.PatientState1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM5.1.PatientZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 1, 5)" />
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 6, 4)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientZip1'']" />
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.4_MemberTelephone">
          <xsl:if test="string-length(data[@id=''MASSM5.1.PatientPhone1'']) &gt; 0">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientPhone1''], 1, 3)" />
            <xsl:text>) </xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientPhone1''], 4, 3)" />
            <xsl:text>-</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientPhone1''], 7, 4)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.5_PatientGender_Male">
          <xsl:if test="data[@id=''MASSM5.1.PatientGender1''] = ''M''">X</xsl:if>
        </data>
        <data id="MASSM5.1.5_PatientGender_Female">
          <xsl:if test="data[@id=''MASSM5.1.PatientGender1''] = ''F''">X</xsl:if>
        </data>
        <data id="MASSM5.1.6_PolicyNumber">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM5.1.PolicyNumber1'']) &gt; 0">
              <xsl:value-of select="data[@id=''MASSM5.1.PolicyNumber1'']" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.DependentPolicyNumber1'']" />
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.7_MemberRelationshipToInsured_Self">
          <xsl:if test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
        </data>
        <data id="MASSM5.1.7_MemberRelationshipToInsured_Spouse">
          <xsl:if test="data[@id=''MASSM5.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
        </data>
        <data id="MASSM5.1.7_MemberRelationshipToInsured_Child">
          <xsl:if test="data[@id=''MASSM5.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
        </data>
        <data id="MASSM5.1.7_MemberRelationshipToInsured_Other">
          <xsl:if test="data[@id=''MASSM5.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
        </data>
        <data id="MASSM5.1.8_GroupNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.GroupNumber1'']" />
        </data>
        <data id="MASSM5.1.9_MemberOtherHealthIns_YES" />
        <data id="MASSM5.1.9_MemberOtherHealthIns_NO">
          X
        </data>
        <data id="MASSM5.1.9_MemberOtherHealthIns_AddressStreet" />
        <data id="MASSM5.1.9_MemberOtherHealthIns_AddressCityStateZip" />
        <data id="MASSM5.1.10_MemberCondition_Employment_YES">
          <xsl:if test="data[@id=''MASSM5.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="MASSM5.1.10_MemberCondition_Employment_NO">
          <xsl:if test="data[@id=''MASSM5.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
        </data>
        <data id="MASSM5.1.10_MemberCondition_Accident_Auto">
          <xsl:if test="data[@id=''MASSM5.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="MASSM5.1.10_MemberCondition_Accident_Other">
          <xsl:if test="data[@id=''MASSM5.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
        </data>
        <data id="MASSM5.1.11_InsuredAddress_Street">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberStreet11'']" />
              <xsl:if test="string-length(data[@id=''MASSM5.1.SubscriberStreet21'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.SubscriberStreet21'']" />
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet11'']" />
              <xsl:if test="string-length(data[@id=''MASSM5.1.PatientStreet21'']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="data[@id=''MASSM5.1.PatientStreet21'']" />
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.11_InsuredAddress_CityStateZip">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.SubscriberDifferentFlag1''] = ''1''">
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberCity1'']" />
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''MASSM5.1.SubscriberState1'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:choose>
                <xsl:when test="string-length(data[@id=''MASSM5.1.SubscriberZip1'']) = 9">
                  <xsl:value-of select="substring(data[@id=''MASSM5.1.SubscriberZip1''], 1, 5)" />
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="substring(data[@id=''MASSM5.1.SubscriberZip1''], 6, 4)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="data[@id=''MASSM5.1.SubscriberZip1'']" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientCity1'']" />
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''MASSM5.1.PatientState1'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:choose>
                <xsl:when test="string-length(data[@id=''MASSM5.1.PatientZip1'']) = 9">
                  <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 1, 5)" />
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="substring(data[@id=''MASSM5.1.PatientZip1''], 6, 4)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="data[@id=''MASSM5.1.PatientZip1'']" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.12_Signature">
        	Signature on File
        </data>
        <data id="MASSM5.1.12_Date">
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 1, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 4, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 9, 2)" />
        </data>
        <data id="MASSM5.1.13_Signature">
        	Signature on File
        </data>
        <data id="MASSM5.1.13_Date">
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 1, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 4, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 9, 2)" />
        </data>
        <data id="MASSM5.1.14_CurrentIllnessDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.CurrentIllnessDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentIllnessDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentIllnessDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentIllnessDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.15_FirstConsultationDate" />
        <data id="MASSM5.1.16_SimilarSymptoms_YES" />
        <data id="MASSM5.1.16_SimilarSymptoms_NO" />
        <data id="MASSM5.1.16a_Emergency" />
        <data id="MASSM5.1.17_ReturnToWorkDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.DisabilityEndDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.18_TotalDisabilityBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.DisabilityBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityBeginDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityBeginDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityBeginDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.18_TotalDisabilityEndDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.DisabilityEndDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.DisabilityEndDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.18_PartialDisabilityBeginDate" />
        <data id="MASSM5.1.18_PartialDisabilityEndDate" />
        <data id="MASSM5.1.19a_ReferringPhyscianName">
          <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderFirstName1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:if test="string-length(data[@id=''MASSM5.1.ReferringProviderMiddleName1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ReferringProviderMiddleName1''],1,1)" />
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderLastName1'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.ReferringProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderDegree1'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.19b_ReferringProviderNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.ReferringProviderIDNumber1'']" />
        </data>
        <data id="MASSM5.1.20_HospitalizationBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.HospitalizationBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationBeginDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationBeginDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationBeginDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.20_HospitalizationEndDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.HospitalizationEndDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationEndDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationEndDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.HospitalizationEndDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.21_FacilityName">
          <xsl:if test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''99'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''99''">
            <xsl:value-of select="data[@id=''MASSM5.1.FacilityName1'']" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.FacilityStreet11'']" />
            <xsl:if test="string-length(data[@id=''MASSM5.1.FacilityStreet21'']) &gt; 0">
              <xsl:text>, </xsl:text>
              <xsl:value-of select="data[@id=''MASSM5.1.FacilityStreet21'']" />
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.FacilityCity1'']" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.FacilityState1'']" />
            <xsl:text xml:space="preserve"> </xsl:text>
            <xsl:choose>
              <xsl:when test="string-length(data[@id=''MASSM5.1.FacilityZip1'']) = 9">
                <xsl:value-of select="substring(data[@id=''MASSM5.1.FacilityZip1''], 1, 5)" />
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(data[@id=''MASSM5.1.FacilityZip1''], 6, 4)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="data[@id=''MASSM5.1.FacilityZip1'']" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </data>
        <data id="MASSM5.1.22_LabWork_External_YES" />
        <data id="MASSM5.1.22_LabWork_External_NO" />
        <data id="MASSM5.1.22_LabWork_External_Charges" />
        <data id="MASSM5.1.23a_Diagnosis1">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode11'']" />
        </data>
        <data id="MASSM5.1.23a_Diagnosis2">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode21'']" />
        </data>
        <data id="MASSM5.1.23a_Diagnosis3">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode31'']" />
        </data>
        <data id="MASSM5.1.23a_Diagnosis4">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisCode41'']" />
        </data>
        <data id="MASSM5.1.23b_Screen" />
        <data id="MASSM5.1.23b_Referral" />
        <data id="MASSM5.1.23c_FamilyPlanning" />
        <data id="MASSM5.1.23d_AuthorizationNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.AuthorizationNumber1'']" />
        </data>
        <data id="MASSM5.1.25_PhysicianSignature">
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderFirstName1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.RenderingProviderMiddleName1''], 1, 1)" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderLastName1'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderDegree1'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.25_PhysicianSignatureCurrentDate">
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 1, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 4, 2)" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.CurrentDate1''], 9, 2)" />
        </data>
        <data id="MASSM5.1.26_Accept_YES" />
        <data id="MASSM5.1.26_Accept_NO" />
        <data id="MASSM5.1.27_TotalCharge_Dollars">
          <xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''MASSM5.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
          <xsl:value-of select="$charges-dollars" />
        </data>
        <data id="MASSM5.1.27_TotalCharge_Cents">
          <xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''MASSM5.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$charges-cents" />
        </data>
        <data id="MASSM5.1.28_TotalPaid_Dollars">
          <xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''MASSM5.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
          <xsl:value-of select="$paid-dollars" />
        </data>
        <data id="MASSM5.1.28_TotalPaid_Cents">
          <xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''MASSM5.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$paid-cents" />
        </data>
        <data id="MASSM5.1.29_TotalBalance_Dollars">
          <xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''MASSM5.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
          <xsl:value-of select="$balance-dollars" />
        </data>
        <data id="MASSM5.1.29_TotalBalance_Cents">
          <xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''MASSM5.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$balance-cents" />
        </data>
        <data id="MASSM5.1.30_ServicingProviderNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderIndividualNumber1'']" />
        </data>
        <data id="MASSM5.1.31_PhysicianName">
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderFirstName1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.RenderingProviderMiddleName1''], 1, 1)" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderLastName1'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.RenderingProviderDegree1'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderDegree1'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.31_PhysicianAddress">
          <xsl:value-of select="data[@id=''MASSM5.1.PracticeStreet11'']" />
          <xsl:if test="string-length(data[@id=''MASSM5.1.PracticeStreet21'']) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="data[@id=''MASSM5.1.PracticeStreet21'']" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.31_PhysicianCityStateZip">
          <xsl:value-of select="data[@id=''MASSM5.1.PracticeCity1'']" />
          <xsl:text>, </xsl:text>
          <xsl:value-of select="data[@id=''MASSM5.1.PracticeState1'']" />
          <xsl:text xml:space="preserve"> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM5.1.PracticeZip1'']) = 9">
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticeZip1''], 1, 5)" />
              <xsl:text>-</xsl:text>
              <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticeZip1''], 6, 4)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.PracticeZip1'']" />
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.31_PhysicianTelephone">
          <xsl:text>(</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticePhone1''], 1, 3)" />
          <xsl:text xml:space="preserve">) </xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticePhone1''], 4, 3)" />
          <xsl:text>-</xsl:text>
          <xsl:value-of select="substring(data[@id=''MASSM5.1.PracticePhone1''], 7, 4)" />
        </data>
        <data id="MASSM5.1.31_PhysicianProviderNo">
          <xsl:choose>
            <xsl:when test="string-length(data[@id=''MASSM5.1.RenderingProviderGroupNumber1'']) &gt; 0">
              <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderGroupNumber1'']" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="data[@id=''MASSM5.1.RenderingProviderIndividualNumber1'']" />
            </xsl:otherwise>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.32_PatientAccountNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.PatientAccountNumber1'']" />
        </data>
        <data id="MASSM5.1.33_BillingAgentNumber">
          <xsl:value-of select="data[@id=''MASSM5.1.BillingAgentNumber1'']" />
        </data>
        
        <!-- Procedure 1 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID1'']" />
        </ClaimID>
        <data id="MASSM5.1.24a_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate1'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24a_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate1''] = data[@id=''MASSM5.1.ServiceEndDate1'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate1'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate1''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate1''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate1''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24a_bPlaceOfServiceCode">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''03''">10</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''04''">09</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''05'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''06'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''07'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''08'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''11'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''20'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''26'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''49'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''50'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''53'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''57'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''60'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''65'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''71'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''72'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''81''">01</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''12'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''13'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''14'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''34'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''54''">02</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''15'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''25'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''41'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''42'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''55'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''56'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''99''">99</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''21'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''51'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''61''">03</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''22'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''52'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''62''">04</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''23''">05</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''24''">08</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''31'' or data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''32''">06</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode1''] = ''33''">07</xsl:when>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.24a_cTypeOfServiceCode" />
        <data id="MASSM5.1.24a_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode1'']" />
        </data>
        <data id="MASSM5.1.24a_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier11'']" />
        </data>
        <data id="MASSM5.1.24a_cProcedureExplanation" />
        <data id="MASSM5.1.24a_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code1'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount1''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24a_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24a_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24a_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount1'']" />
          </data>
          <data id="MASSM5.1.24a_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24a_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        
        <!-- Procedure 2 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID2'']" />
        </ClaimID>
        <data id="MASSM5.1.24b_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate2'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate2''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate2''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate2''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24b_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate2''] = data[@id=''MASSM5.1.ServiceEndDate2'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate2'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate2''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate2''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate2''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24b_bPlaceOfServiceCode">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''03''">10</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''04''">09</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''05'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''06'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''07'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''08'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''11'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''20'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''26'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''49'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''50'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''53'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''57'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''60'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''65'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''71'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''72'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''81''">01</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''12'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''13'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''14'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''34'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''54''">02</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''15'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''25'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''41'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''42'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''55'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''56'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''99''">99</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''21'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''51'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''61''">03</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''22'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''52'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''62''">04</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''23''">05</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''24''">08</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''31'' or data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''32''">06</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode2''] = ''33''">07</xsl:when>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.24b_cTypeOfServiceCode" />
        <data id="MASSM5.1.24b_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode2'']" />
        </data>
        <data id="MASSM5.1.24b_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier12'']" />
        </data>
        <data id="MASSM5.1.24b_cProcedureExplanation" />
        <data id="MASSM5.1.24b_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code2'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount2''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24b_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24b_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24b_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount2'']" />
          </data>
          <data id="MASSM5.1.24b_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24b_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount2''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        
        <!-- Procedure 3 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID3'']" />
        </ClaimID>
        <data id="MASSM5.1.24c_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate3'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate3''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate3''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate3''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24c_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate3''] = data[@id=''MASSM5.1.ServiceEndDate3'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate3'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate3''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate3''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate3''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24c_bPlaceOfServiceCode">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''03''">10</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''04''">09</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''05'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''06'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''07'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''08'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''11'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''20'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''26'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''49'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''50'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''53'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''57'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''60'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''65'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''71'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''72'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''81''">01</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''12'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''13'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''14'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''34'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''54''">02</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''15'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''25'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''41'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''42'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''55'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''56'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''99''">99</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''21'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''51'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''61''">03</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''22'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''52'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''62''">04</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''23''">05</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''24''">08</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''31'' or data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''32''">06</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode3''] = ''33''">07</xsl:when>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.24c_cTypeOfServiceCode" />
        <data id="MASSM5.1.24c_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode3'']" />
        </data>
        <data id="MASSM5.1.24c_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier13'']" />
        </data>
        <data id="MASSM5.1.24c_cProcedureExplanation" />
        <data id="MASSM5.1.24c_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code3'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount3''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24c_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24c_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24c_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount3'']" />
          </data>
          <data id="MASSM5.1.24c_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24c_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount3''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        
        <!-- Procedure 4 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID4'']" />
        </ClaimID>
        <data id="MASSM5.1.24d_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate4'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate4''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate4''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate4''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24d_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate4''] = data[@id=''MASSM5.1.ServiceEndDate4'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate4'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate4''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate4''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate4''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24d_bPlaceOfServiceCode">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''03''">10</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''04''">09</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''05'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''06'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''07'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''08'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''11'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''20'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''26'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''49'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''50'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''53'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''57'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''60'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''65'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''71'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''72'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''81''">01</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''12'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''13'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''14'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''34'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''54''">02</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''15'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''25'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''41'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''42'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''55'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''56'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''99''">99</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''21'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''51'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''61''">03</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''22'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''52'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''62''">04</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''23''">05</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''24''">08</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''31'' or data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''32''">06</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode4''] = ''33''">07</xsl:when>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.24d_cTypeOfServiceCode" />
        <data id="MASSM5.1.24d_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode4'']" />
        </data>
        <data id="MASSM5.1.24d_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier14'']" />
        </data>
        <data id="MASSM5.1.24d_cProcedureExplanation" />
        <data id="MASSM5.1.24d_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code4'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount4''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24d_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24d_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24d_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount4'']" />
          </data>
          <data id="MASSM5.1.24d_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24d_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount4''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        
        <!-- Procedure 5 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID5'']" />
        </ClaimID>
        <data id="MASSM5.1.24e_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate5'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate5''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate5''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate5''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24e_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate5''] = data[@id=''MASSM5.1.ServiceEndDate5'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate5'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate5''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate5''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate5''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24e_bPlaceOfServiceCode">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''03''">10</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''04''">09</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''05'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''06'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''07'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''08'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''11'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''20'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''26'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''49'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''50'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''53'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''57'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''60'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''65'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''71'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''72'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''81''">01</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''12'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''13'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''14'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''34'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''54''">02</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''15'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''25'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''41'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''42'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''55'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''56'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''99''">99</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''21'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''51'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''61''">03</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''22'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''52'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''62''">04</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''23''">05</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''24''">08</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''31'' or data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''32''">06</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode5''] = ''33''">07</xsl:when>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.24e_cTypeOfServiceCode" />
        <data id="MASSM5.1.24e_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode5'']" />
        </data>
        <data id="MASSM5.1.24e_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier15'']" />
        </data>
        <data id="MASSM5.1.24e_cProcedureExplanation" />
        <data id="MASSM5.1.24e_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code5'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount5''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24e_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24e_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24e_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount5'']" />
          </data>
          <data id="MASSM5.1.24e_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24e_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount5''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        
        <!-- Procedure 6 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID6'']" />
        </ClaimID>
        <data id="MASSM5.1.24f_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate6'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate6''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate6''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate6''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24f_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate6''] = data[@id=''MASSM5.1.ServiceEndDate6'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate6'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate6''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate6''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate6''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24f_bPlaceOfServiceCode">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''03''">10</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''04''">09</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''05'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''06'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''07'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''08'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''11'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''20'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''26'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''49'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''50'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''53'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''57'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''60'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''65'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''71'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''72'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''81''">01</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''12'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''13'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''14'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''34'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''54''">02</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''15'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''25'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''41'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''42'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''55'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''56'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''99''">99</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''21'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''51'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''61''">03</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''22'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''52'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''62''">04</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''23''">05</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''24''">08</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''31'' or data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''32''">06</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode6''] = ''33''">07</xsl:when>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.24f_cTypeOfServiceCode" />
        <data id="MASSM5.1.24f_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode6'']" />
        </data>
        <data id="MASSM5.1.24f_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier16'']" />
        </data>
        <data id="MASSM5.1.24f_cProcedureExplanation" />
        <data id="MASSM5.1.24f_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code6'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount6''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24f_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24f_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24f_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount6'']" />
          </data>
          <data id="MASSM5.1.24f_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24f_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount6''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        
        <!-- Procedure 7 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID7'']" />
        </ClaimID>
        <data id="MASSM5.1.24g_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate7'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate7''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate7''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate7''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24g_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate7''] = data[@id=''MASSM5.1.ServiceEndDate7'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate7'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate7''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate7''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate7''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24g_bPlaceOfServiceCode">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''03''">10</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''04''">09</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''05'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''06'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''07'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''08'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''11'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''20'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''26'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''49'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''50'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''53'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''57'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''60'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''65'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''71'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''72'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''81''">01</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''12'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''13'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''14'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''34'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''54''">02</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''15'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''25'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''41'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''42'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''55'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''56'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''99''">99</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''21'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''51'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''61''">03</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''22'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''52'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''62''">04</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''23''">05</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''24''">08</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''31'' or data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''32''">06</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode7''] = ''33''">07</xsl:when>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.24g_cTypeOfServiceCode" />
        <data id="MASSM5.1.24g_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode7'']" />
        </data>
        <data id="MASSM5.1.24g_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier17'']" />
        </data>
        <data id="MASSM5.1.24g_cProcedureExplanation" />
        <data id="MASSM5.1.24g_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code7'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount7''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24g_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount7''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24g_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount7''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24g_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount7'']" />
          </data>
          <data id="MASSM5.1.24g_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount7''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24g_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount7''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
        
        <!-- Procedure 8 -->
        
        <ClaimID>
          <xsl:value-of select="data[@id=''MASSM5.1.ClaimID8'']" />
        </ClaimID>
        <data id="MASSM5.1.24h_aServiceBeginDate">
          <xsl:if test="string-length(data[@id=''MASSM5.1.ServiceBeginDate8'']) &gt; 0">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate8''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate8''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceBeginDate8''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24h_aServiceEndDate">
          <xsl:if test="not(data[@id=''MASSM5.1.ServiceBeginDate8''] = data[@id=''MASSM5.1.ServiceEndDate8'']) and (string-length(data[@id=''MASSM5.1.ServiceEndDate8'']) &gt; 0)">
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate8''], 1, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate8''], 4, 2)" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring(data[@id=''MASSM5.1.ServiceEndDate8''], 9, 2)" />
          </xsl:if>
        </data>
        <data id="MASSM5.1.24h_bPlaceOfServiceCode">
          <xsl:choose>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''03''">10</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''04''">09</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''05'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''06'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''07'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''08'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''11'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''20'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''26'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''49'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''50'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''53'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''57'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''60'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''65'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''71'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''72'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''81''">01</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''12'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''13'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''14'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''34'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''54''">02</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''15'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''25'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''41'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''42'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''55'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''56'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''99''">99</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''21'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''51'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''61''">03</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''22'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''52'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''62''">04</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''23''">05</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''24''">08</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''31'' or data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''32''">06</xsl:when>
            <xsl:when test="data[@id=''MASSM5.1.PlaceOfServiceCode8''] = ''33''">07</xsl:when>
          </xsl:choose>
        </data>
        <data id="MASSM5.1.24h_cTypeOfServiceCode" />
        <data id="MASSM5.1.24h_cProcedureCode">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureCode8'']" />
        </data>
        <data id="MASSM5.1.24h_cProcedureModifier1">
          <xsl:value-of select="data[@id=''MASSM5.1.ProcedureModifier18'']" />
        </data>
        <data id="MASSM5.1.24h_cProcedureExplanation" />
        <data id="MASSM5.1.24h_dDiagnosisPointer1Code">
          <xsl:value-of select="data[@id=''MASSM5.1.DiagnosisPointer1Code8'']" />
        </data>
        <xsl:if test="format-number(data[@id=''MASSM5.1.ServiceUnitCount8''], ''0.0'', ''default-format'') &gt; 0">
          <data id="MASSM5.1.24h_eCharges_Dollars">
            <xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.ChargeAmount8''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
            <xsl:value-of select="$charge-dollars" />
          </data>
          <data id="MASSM5.1.24h_eCharges_Cents">
            <xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''MASSM5.1.ChargeAmount8''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$charge-cents" />
          </data>
          <data id="MASSM5.1.24h_fServiceUnitCount">
            <xsl:value-of select="data[@id=''MASSM5.1.ServiceUnitCount8'']" />
          </data>
          <data id="MASSM5.1.24h_gPaid_Dollars">
            <xsl:variable name="pay-dollars" select="concat(substring-before(format-number(data[@id=''MASSM5.1.PaidAmount8''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
            <xsl:value-of select="substring(''       '', 1, 7 - string-length($pay-dollars))" />
            <xsl:value-of select="$pay-dollars" />
          </data>
          <data id="MASSM5.1.24h_gPaid_Cents">
            <xsl:variable name="pay-cents" select="substring-after(format-number(data[@id=''MASSM5.1.PaidAmount8''], ''#0.00'', ''default-format''), ''.'')" />
            <xsl:value-of select="$pay-cents" />
          </data>
        </xsl:if>
      </page>
    </formData>
  </xsl:template>
</xsl:stylesheet>'
WHERE BillingFormID = 10