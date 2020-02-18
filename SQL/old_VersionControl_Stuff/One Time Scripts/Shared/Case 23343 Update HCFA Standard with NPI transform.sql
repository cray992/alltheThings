/*
	Case 23343 - Update the HCFA Standard (with NPI Numbers) to include EMG data for a specific situation
*/
UPDATE	BillingForm
SET		Transform = '<?xml version="1.0" ?>
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
        <data id="CMS1500.1.1_0dLocal">
		  <xsl:value-of select="data[@id=''CMS1500.1.LocalUseDataBox10d1'']" />
		</data>
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
			<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
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
        <data id="CMS1500.1.1_7aQualifier">
          <xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderQualifier1'']" />
        </data>
        <data id="CMS1500.1.1_7aID">
          <xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
        </data>
        <data id="CMS1500.1.1_7bNPI">
          <xsl:value-of select="data[@id=''CMS1500.1.NewReferringProviderNPI1'']" />
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
            <xsl:when test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB'' and data[@id=''CMS1500.1.PlaceOfService1''] = 31">
              <xsl:value-of select="data[@id=''CMS1500.1.FacilityInfo1'']" />
            </xsl:when>
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
          <xsl:value-of select="data[@id=''CMS1500.1.PatientAccountNumber1'']" />
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
        <xsl:if test="(data[@id=''CMS1500.1.PlaceOfService1''] != 12) or 
				((data[@id=''CMS1500.1.PayerState1''] = ''NV'') and (data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''))">
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
          <data id="CMS1500.1.3_2aNPI">
            <xsl:value-of select="data[@id=''CMS1500.1.FacilityNPI1'']" />
          </data>
		  <data id="CMS1500.1.3_2bOtherID">
			<xsl:value-of select="data[@id=''CMS1500.1.FacilityOtherID1'']" />
		  </data>
        </xsl:if>
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
        <data id="CMS1500.1.3_3Area">
          <xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
        </data>
        <data id="CMS1500.1.3_3Phone">
          <xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
          <xsl:text>-</xsl:text>
          <xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
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
        <data id="CMS1500.1.3_3PIN">
          <xsl:value-of select="data[@id=''CMS1500.1.PracticeNPI1'']" />
        </data>
		<data id="CMS1500.1.3_3GRP">
		  <xsl:choose>
			<xsl:when test="data[@id=''CMS1500.1.UseProviderTaxonomyCodeForOtherID1''] = 1">
				<xsl:text>ZZ</xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderTaxonomyCode1'']" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumberQualifier1'']" />
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</xsl:otherwise>
		  </xsl:choose>
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
        <data id="CMS1500.1.cEMG1">
		  <xsl:value-of select="data[@id=''CMS1500.1.EMG1'']" />
		</data>
        <data id="CMS1500.1.dCPT1">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
        </data>
        <data id="CMS1500.1.dModifier11">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
        </data>
        <data id="CMS1500.1.dModifier21">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier21'']" />
        </data>
        <data id="CMS1500.1.dModifier31">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier31'']" />
        </data>
        <data id="CMS1500.1.dModifier41">
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
			  <xsl:choose>
				  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode1''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] = ''M''">
					  <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes1'']" />
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount1'']" />
				  </xsl:otherwise>
			  </xsl:choose>
          </data>
          <data id="CMS1500.1.hEPSDT1"> </data>
          <data id="CMS1500.1.iQualifier1">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderQualifier1'']" />
          </data>
          <data id="CMS1500.1.jID1">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderUPIN1'']" />
          </data>
          <data id="CMS1500.1.jNPI1">
            <xsl:value-of select="data[@id=''CMS1500.1.NewRenderingProviderNPI1'']" />
          </data>
        </xsl:if>
        <data id="CMS1500.1.SupplementalInfo1">
          <xsl:choose>
            <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode1''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] != ''M''">
              <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
              <xsl:text>Time </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes1'']" />
              <xsl:text> Minutes</xsl:text>
            </xsl:when>
            <xsl:when test="string-length(data[@id=''CMS1500.1.NDCNumber1'']) &gt; 0">
              <xsl:text>N4</xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.NDCNumber1'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.DrugName1'']" />
            </xsl:when>
          </xsl:choose>
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
        <data id="CMS1500.1.cEMG2">
			<xsl:value-of select="data[@id=''CMS1500.1.EMG2'']" />
		</data>
		<data id="CMS1500.1.dCPT2">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
        </data>
        <data id="CMS1500.1.dModifier12">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
        </data>
        <data id="CMS1500.1.dModifier22">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier22'']" />
        </data>
        <data id="CMS1500.1.dModifier32">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier32'']" />
        </data>
        <data id="CMS1500.1.dModifier42">
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
			  <xsl:choose>
				  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode2''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] = ''M''">
					  <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes2'']" />
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount2'']" />
				  </xsl:otherwise>
			  </xsl:choose>
		  </data>
          <data id="CMS1500.1.hEPSDT2"> </data>
          <data id="CMS1500.1.iQualifier2">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderQualifier1'']" />
          </data>
          <data id="CMS1500.1.jID2">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderUPIN1'']" />
          </data>
          <data id="CMS1500.1.jNPI2">
            <xsl:value-of select="data[@id=''CMS1500.1.NewRenderingProviderNPI1'']" />
          </data>
        </xsl:if>
        <data id="CMS1500.1.SupplementalInfo2">
          <xsl:choose>
			  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode2''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] != ''M''">
			  <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
              <xsl:text>Time </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes2'']" />
              <xsl:text> Minutes</xsl:text>
            </xsl:when>
            <xsl:when test="string-length(data[@id=''CMS1500.1.NDCNumber2'']) &gt; 0">
              <xsl:text>N4</xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.NDCNumber2'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.DrugName2'']" />
            </xsl:when>
          </xsl:choose>
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
        <data id="CMS1500.1.cEMG3">
			<xsl:value-of select="data[@id=''CMS1500.1.EMG3'']" />
		</data>
		<data id="CMS1500.1.dCPT3">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
        </data>
        <data id="CMS1500.1.dModifier13">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
        </data>
        <data id="CMS1500.1.dModifier23">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier23'']" />
        </data>
        <data id="CMS1500.1.dModifier33">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier33'']" />
        </data>
        <data id="CMS1500.1.dModifier43">
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
			  <xsl:choose>
				  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode3''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] = ''M''">
					  <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes3'']" />
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount3'']" />
				  </xsl:otherwise>
			  </xsl:choose>
		  </data>
          <data id="CMS1500.1.hEPSDT3"> </data>
          <data id="CMS1500.1.iQualifier3">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderQualifier1'']" />
          </data>
          <data id="CMS1500.1.jID3">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderUPIN1'']" />
          </data>
          <data id="CMS1500.1.jNPI3">
            <xsl:value-of select="data[@id=''CMS1500.1.NewRenderingProviderNPI1'']" />
          </data>
        </xsl:if>
        <data id="CMS1500.1.SupplementalInfo3">
          <xsl:choose>
			  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode3''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] != ''M''">
			  <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
              <xsl:text>Time </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes3'']" />
              <xsl:text> Minutes</xsl:text>
            </xsl:when>
            <xsl:when test="string-length(data[@id=''CMS1500.1.NDCNumber3'']) &gt; 0">
              <xsl:text>N4</xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.NDCNumber3'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.DrugName3'']" />
            </xsl:when>
          </xsl:choose>
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
        <data id="CMS1500.1.cEMG4">
			<xsl:value-of select="data[@id=''CMS1500.1.EMG4'']" />
		</data>
		<data id="CMS1500.1.dCPT4">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
        </data>
        <data id="CMS1500.1.dModifier14">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
        </data>
        <data id="CMS1500.1.dModifier24">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier24'']" />
        </data>
        <data id="CMS1500.1.dModifier34">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier34'']" />
        </data>
        <data id="CMS1500.1.dModifier44">
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
			  <xsl:choose>
				  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode4''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] = ''M''">
					  <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes4'']" />
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount4'']" />
				  </xsl:otherwise>
			  </xsl:choose>
		  </data>
          <data id="CMS1500.1.hEPSDT4"> </data>
          <data id="CMS1500.1.iQualifier4">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderQualifier1'']" />
          </data>
          <data id="CMS1500.1.jID4">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderUPIN1'']" />
          </data>
          <data id="CMS1500.1.jNPI4">
            <xsl:value-of select="data[@id=''CMS1500.1.NewRenderingProviderNPI1'']" />
          </data>
        </xsl:if>
        <data id="CMS1500.1.SupplementalInfo4">
          <xsl:choose>
			  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode4''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] != ''M''">
			  <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
              <xsl:text>Time </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes4'']" />
              <xsl:text> Minutes</xsl:text>
            </xsl:when>
            <xsl:when test="string-length(data[@id=''CMS1500.1.NDCNumber4'']) &gt; 0">
              <xsl:text>N4</xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.NDCNumber4'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.DrugName4'']" />
            </xsl:when>
          </xsl:choose>
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
        <data id="CMS1500.1.cEMG5">
			<xsl:value-of select="data[@id=''CMS1500.1.EMG5'']" />
		</data>
		<data id="CMS1500.1.dCPT5">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
        </data>
        <data id="CMS1500.1.dModifier15">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
        </data>
        <data id="CMS1500.1.dModifier25">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier25'']" />
        </data>
        <data id="CMS1500.1.dModifier35">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier35'']" />
        </data>
        <data id="CMS1500.1.dModifier45">
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
			  <xsl:choose>
				  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode5''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] = ''M''">
					  <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes5'']" />
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount5'']" />
				  </xsl:otherwise>
			  </xsl:choose>
		  </data>
          <data id="CMS1500.1.hEPSDT5"> </data>
          <data id="CMS1500.1.iQualifier5">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderQualifier1'']" />
          </data>
          <data id="CMS1500.1.jID5">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderUPIN1'']" />
          </data>
          <data id="CMS1500.1.jNPI5">
            <xsl:value-of select="data[@id=''CMS1500.1.NewRenderingProviderNPI1'']" />
          </data>
        </xsl:if>
        <data id="CMS1500.1.SupplementalInfo5">
          <xsl:choose>
			  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode5''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] != ''M''">
			  <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
              <xsl:text>Time </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes5'']" />
              <xsl:text> Minutes</xsl:text>
            </xsl:when>
            <xsl:when test="string-length(data[@id=''CMS1500.1.NDCNumber5'']) &gt; 0">
              <xsl:text>N4</xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.NDCNumber5'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.DrugName5'']" />
            </xsl:when>
          </xsl:choose>
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
        <data id="CMS1500.1.cEMG6">
			<xsl:value-of select="data[@id=''CMS1500.1.EMG6'']" />
		</data>
		<data id="CMS1500.1.dCPT6">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
        </data>
        <data id="CMS1500.1.dModifier16">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
        </data>
        <data id="CMS1500.1.dModifier26">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier26'']" />
        </data>
        <data id="CMS1500.1.dModifier36">
          <xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier36'']" />
        </data>
        <data id="CMS1500.1.dModifier46">
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
			  <xsl:choose>
				  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode6''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] = ''M''">
					  <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes6'']" />
				  </xsl:when>
				  <xsl:otherwise>
					  <xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount6'']" />
				  </xsl:otherwise>
			  </xsl:choose>
		  </data>
          <data id="CMS1500.1.hEPSDT6"> </data>
          <data id="CMS1500.1.iQualifier6">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderQualifier1'']" />
          </data>
          <data id="CMS1500.1.jID6">
            <xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderUPIN1'']" />
          </data>
          <data id="CMS1500.1.jNPI6">
            <xsl:value-of select="data[@id=''CMS1500.1.NewRenderingProviderNPI1'']" />
          </data>
        </xsl:if>
        <data id="CMS1500.1.SupplementalInfo6">
          <xsl:choose>
			  <xsl:when test="data[@id=''CMS1500.1.TypeOfServiceCode6''] = 7 and data[@id=''CMS1500.1.PayerAnesthesiaType1''] != ''M''">
			  <xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
              <xsl:text>Time </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.AnesthesiaMinutes6'']" />
              <xsl:text> Minutes</xsl:text>
            </xsl:when>
            <xsl:when test="string-length(data[@id=''CMS1500.1.NDCNumber6'']) &gt; 0">
              <xsl:text>N4</xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.NDCNumber6'']" />
              <xsl:text xml:space="preserve"> </xsl:text>
              <xsl:value-of select="data[@id=''CMS1500.1.DrugName6'']" />
            </xsl:when>
          </xsl:choose>
        </data>
      </page>
    </formData>
    
  </xsl:template>
  
</xsl:stylesheet>'
WHERE	BillingFormID = 13