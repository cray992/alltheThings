-- SELECT * FROM dbo.EligibilityHistory AS eh

DECLARE @first_name VARCHAR(MAX), @last_name VARCHAR(MAX), @dob DATETIME, @gender VARCHAR(MAX), @addressline1 VARCHAR(MAX), @city VARCHAR(MAX), @state VARCHAR(MAX), @zip VARCHAR(MAX)
DECLARE @payer_name VARCHAR(MAX), @payer_id VARCHAR(MAX), @provider_first VARCHAR(MAX), @provider_last VARCHAR(MAX), @provider_npi VARCHAR(MAX), @member_id VARCHAR(MAX), @group_number VARCHAR(MAX), @doctor_id INT, @policy_id INT

DECLARE policy_cursor CURSOR FAST_FORWARD FOR
SELECT p.FirstName, p.LastName, p.DOB, p.Gender, p.AddressLine1, p.City, p.State, p.ZipCode, ic.InsuranceCompanyName, cpl.PayerNumber, d.FirstName, d.LastName, d.NPI, ip.PolicyNumber, ip.GroupNumber, d.DoctorID, ip.InsurancePolicyID
FROM dbo.Patient AS p
INNER JOIN dbo.PatientCase AS pc ON p.PatientID = pc.PatientID
INNER JOIN dbo.InsurancePolicy AS ip ON pc.PatientCaseID = ip.PatientCaseID
INNER JOIN dbo.InsuranceCompanyPlan AS icp ON ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
INNER JOIN dbo.InsuranceCompany AS ic ON icp.InsuranceCompanyID = ic.InsuranceCompanyID
INNER JOIN SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList AS cpl ON ic.ClearinghousePayerID = cpl.ClearinghousePayerID
INNER JOIN dbo.Doctor AS d ON p.PrimaryProviderID = d.DoctorID


DECLARE @responseTemplate VARCHAR(MAX) = '

<html>
  <head>
    <META http-equiv="Content-Type" content="text/html; charset=utf-16">
    <style>
                                                                                BODY
                                                                                {
                                                                                background: #E7ECF3;
                                                                                }

                                                                                .txt-header-big
                                                                                {
                                                                                color: #4271B6;
                                                                                font-family: tahoma, trebuchet, verdana, arial;
                                                                                font-size: 14pt;
                                                                                font-weight: bold;
                                                                                text-decoration: none;
                                                                                line-height : 21px;
                                                                                padding-left: 20px;
                                                                                padding-top: 10px;
                                                                                }

                                                                                .txt-header-med
                                                                                {
                                                                                color: #000000;
                                                                                font-family: tahoma, trebuchet, verdana, arial;
                                                                                font-size: 11pt;
                                                                                text-decoration: none;
                                                                                font-weight: bold;
                                                                                line-height : 21px;
                                                                                padding-left: 20px;
                                                                                padding-top: 10px;
                                                                                }

                                                                                .segment
                                                                                {
                                                                                color: #000000;
                                                                                font-family: tahoma, trebuchet, verdana, arial;
                                                                                font-size: 9pt;
                                                                                text-decoration: none;
                                                                                line-height : 21px;
                                                                                padding-left: 0px;
                                                                                }



                                                                                .valuelabel
                                                                                {
                                                                                color: #330099;
                                                                                font-family: tahoma, trebuchet, verdana, arial;
                                                                                font-size: 11pt;
                                                                                font-weight: bold;
                                                                                text-decoration: none;
                                                                                padding-left: 10px;
                                                                                text-align: right;
                                                                                width: 20%;
                                                                                }

                                                                                .valuelabel2
                                                                                {
                                                                                color: #4271B6;
                                                                                font-family: tahoma, trebuchet, verdana, arial;
                                                                                font-size: 9pt;
                                                                                text-decoration: none;
                                                                                padding-left: 10px;
                                                                                text-align: right;
                                                                                width: 20%;
                                                                                }
                                                                                .valuelabel3
                                                                                {
                                                                                color: #cc3333;
                                                                                font-family: tahoma, trebuchet, verdana, arial;
                                                                                font-size: 9pt;
                                                                                text-decoration: none;
                                                                                padding-left: 10px;
                                                                                text-align: right;
                                                                                width: 20%;
                                                                                }
                                                                                .valuelabel4
                                                                                {
                                                                                color: #ff9933;
                                                                                font-family: tahoma, trebuchet, verdana, arial;
                                                                                font-size: 9pt;
                                                                                text-decoration: none;
                                                                                padding-left: 10px;
                                                                                text-align: right;
                                                                                width: 20%;
                                                                                }
                                                                                .valuelabel5
                                                                                {
                                                                                color: #cc3333;
                                                                                font-family: tahoma, trebuchet, verdana, arial;
                                                                                font-size: 9pt;
                                                                                text-decoration: none;
                                                                                padding-left: 10px;
                                                                                text-align: left;
                                                                                width: 20%;
                                                                                }

                                                                                .valuelabel6
                                                                                {
                                                                                color: #4271B6;
                                                                                font-family: tahoma, trebuchet, verdana, arial;
                                                                                font-size: 11pt;
                                                                                font-weight: bold;
                                                                                text-decoration: none;
                                                                                padding-left: 10px;
                                                                                text-align: right;
                                                                                width: 20%;
                                                                                }
                                                                                .textvalue2
                                                                                {
                                                                                color: #000000;
                                                                                font-family: tahoma, trebuchet, verdana, arial;
                                                                                font-size: 9pt;
                                                                                text-decoration: none;
                                                                                padding-left: 10px;
                                                                                nowrap="false";
                                                                                align="left";
                                                                                width=80%;
                                                                                }


                                                                                table
                                                                                {
                                                                                width: 100%;
                                                                                }


                                                                                table.no-width
                                                                                {
                                                                                width: 30%;
                                                                                }

                                                                                td
                                                                                {
                                                                                padding-left: 3px;
                                                                                padding-right: 3px;
                                                                                background: #E7ECF3;
                                                                                vertical-align: top;
                                                                                }



                                                                </style>
  </head>


  <body topmargin="0" leftmargin="0" bgcolor="beige" onselectstart="return false" oncontextmenu="return false">
    <p class="txt-header-big">Patient Eligibility Report</p>
    <p>
      <table class="txt-header-med">
        <tr>
          <td class="valuelabel" nowrap>Payer</td>
        </tr>
        <tr>
          <td class="valuelabel2" nowrap>Name:</td>
          <td class="textvalue2"><%PAYER_NAME%></td>
        </tr>
        <tr>
          <td class="valuelabel2" nowrap>Payor Identification:
                                                </td>
          <td class="textvalue2"><%PAYER_ID%></td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #4271B6;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel">Information Receiver</td>
        </tr>
        <tr>
          <td class="valuelabel2">Type:</td>
          <td class="textvalue2" nowrap>Provider</td>
        </tr>
        <tr>
          <td class="valuelabel2">Name:</td>
          <td class="textvalue2"><%PROVIDER_FIRST%>&nbsp;<%PROVIDER_LAST%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr>
          <td class="valuelabel2" nowrap>National Provider Identifier (NPI):

                                                                </td>
          <td class="textvalue2"><%PROVIDER_NPI%></td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #4271B6;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel" nowrap span="2">Insured or Subscriber</td>
        </tr>
        <tr>
          <td class="valuelabel2" nowrap>Name:</td>
          <td class="textvalue2"><%PATIENT_FIRST%>&nbsp;<%PATIENT_LAST%>&nbsp;F&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr>
          <td class="valuelabel2" nowrap>Member Identification Number:

                                                                </td>
          <td class="textvalue2"><%MEMBER_ID%></td>
        </tr>
        <tr>
          <td class="valuelabel2" nowrap>Group Number:
                                                                </td>
          <td class="textvalue2"><%GROUP_NUMBER%></td>
        </tr>
          <tr>
          <td class="valuelabel2"></td>
          <td class="textvalue2">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" nowrap>Plan Number:
                                                                </td>
          <td class="textvalue2">0800432</td>
        </tr>
        <tr>
          <td class="valuelabel2" nowrap>Address:</td>
          <td class="textvalue2"><%PATIENT_ADDRESS_LINE_1%>,&nbsp;<%PATIENT_CITY%>&nbsp;<%PATIENT_STATE%>&nbsp;<%PATIENT_ZIP%>&nbsp;</td>
        </tr>
        <tr>
          <td class="valuelabel2" nowrap>Date of Birth:</td>
          <td class="textvalue2"><%PATIENT_DOB%></td>
        </tr>
        <tr>
          <td class="valuelabel2" nowrap>Gender:</td>
          <td class="textvalue2"><%PATIENT_GENDER%></td>
        </tr>
        <tr>
          <td class="valuelabel2">Plan Begin:
                                                                </td>
          <td class="textvalue2">01/01/2014</td>
        </tr>
        <tr>
          <td class="valuelabel2">Service:
                                                                </td>
          <td class="textvalue2">12/05/2013</td>
        </tr>
        <tr>
          <td class="valuelabel2">Unknown Code (L2100D-DTP01-356):
                                                                </td>
          <td class="textvalue2">01/01/2002</td>
       </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #4271B6;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel">
                                                                Eligibility or Benefit Information
                                                </td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Active Coverage
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Insurance Type:</td>
          <td class="textvalue2" align="left">Point of Service (POS)</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Plan Coverage Description:</td>
          <td class="textvalue2" align="left">Choice POS II</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Active Coverage
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Plan Coverage Description:</td>
          <td class="textvalue2" align="left">Choice POS II</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Chiropractic</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">0%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
       <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Chiropractic</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">10%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Hospital - Inpatient</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">10%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Hospital - Outpatient</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">10%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
       </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
       <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">0%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Professional (Physician) Visit - Office</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">0%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Professional (Physician) Visit - Office</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">10%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">0%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">10%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">0%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
       <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">10%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Emergency Services</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">10%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Non Emergency use of Emergency Room,COINS APPLIES TO OUT OF POCKET</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Chiropractic</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">30%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Visit or Evaluation by Chiropractor,COINS APPLIES TO OUT OF POCKET</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Hospital - Inpatient</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">30%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Medical Ancillary,COINS APPLIES TO OUT OF POCKET</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">30%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">COINS APPLIES TO OUT OF POCKET</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Emergency Services</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">30%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Urgent Care,COINS APPLIES TO OUT OF POCKET</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Insurance
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Professional (Physician) Visit - Office</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Percent:</td>
          <td class="textvalue2" align="left">30%
                                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">GYN Visit,COINS APPLIES TO OUT OF POCKET</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Chiropractic</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $30</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Hospital - Outpatient</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Emergency Services</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $100</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $20</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Professional (Physician) Visit - Office</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $30</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $30</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $20</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Professional (Physician) Visit - Office</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $20</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Patient''s Primary Care Physician</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $20</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $30</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Chiropractic</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Required Authorization or Certification</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Visit or Evaluation by Chiropractor</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Hospital - Inpatient</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Room and Board</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Hospital - Outpatient</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Outpatient Surgery Facility</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Emergency Services</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Emergency Room Physician</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Professional (Physician) Visit - Office</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Required Authorization or Certification</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">GYN Visit</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Specialist Visit or Evaluation</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Physician Xray and Lab</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Co-Payment
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Urgent Care</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Calendar Year</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $750</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">Eligibility</td>
          <td class="textvalue2">01/01/2013</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent,In-Network Providers,DED NOT INCL IN OOP,Visit or Evaluation by Chiropractor,Manipulation by Chiropractor,Emergency use of Emergency Room,Outpatient Surgery Facility,Outpatient Medical Ancillary,Ambulatory Medical Ancillary,Inpatient Xray and Lab</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Remaining</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $264.61</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Calendar Year</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $750</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">Eligibility</td>
          <td class="textvalue2">01/01/2013</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent,In-Network Providers,DED NOT INCL IN OOP,Inpatient Xray and Lab</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
         <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Remaining</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $264.61</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Calendar Year</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $250</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">Eligibility</td>
          <td class="textvalue2">01/01/2013</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent,In-Network Providers,DED NOT INCL IN OOP,Visit or Evaluation by Chiropractor,Manipulation by Chiropractor,Emergency use of Emergency Room,Outpatient Surgery Facility,Outpatient Medical Ancillary,Ambulatory Medical Ancillary,Inpatient Xray and Lab</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Remaining</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Calendar Year</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $250</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">Eligibility</td>
          <td class="textvalue2">01/01/2013</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent,In-Network Providers,DED NOT INCL IN OOP,Inpatient Xray and Lab</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Remaining</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Calendar Year</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $1200</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">Eligibility</td>
          <td class="textvalue2">01/01/2013</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent,DED NOT INCL IN OOP,Visit or Evaluation by Chiropractor,Manipulation by Chiropractor,Emergency use of Emergency Room,Outpatient Surgery Facility,Medical Ancillary,Inpatient Xray and Lab,Room and Board,Intensive Care Room and Board</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Remaining</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $714.61</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
         <td class="textvalue2" align="left">Calendar Year</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $1200</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">Eligibility</td>
          <td class="textvalue2">01/01/2013</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent,DED NOT INCL IN OOP,Medical Ancillary,Inpatient Xray and Lab,Room and Board,Intensive Care Room and Board</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Remaining</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $714.61</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Calendar Year</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $400</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">Eligibility</td>
          <td class="textvalue2">01/01/2013</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent,DED NOT INCL IN OOP,Visit or Evaluation by Chiropractor,Manipulation by Chiropractor,Emergency use of Emergency Room,Outpatient Surgery Facility,Medical Ancillary,Inpatient Xray and Lab,Room and Board,Intensive Care Room and Board</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Remaining</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Calendar Year</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $400</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">Eligibility</td>
          <td class="textvalue2">01/01/2013</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Med Dent,DED NOT INCL IN OOP,Medical Ancillary,Inpatient Xray and Lab,Room and Board,Intensive Care Room and Board</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Remaining</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $0</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Deductible
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Emergency Services</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $100</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Required Authorization or Certification</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Non Emergency use of Emergency Room,DED NOT INCL IN OOP</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Plan Requires PreCert</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Self Funded</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Lifetime</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Unlimited Lifetime Benefits</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Chiropractic</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Hospital - Inpatient</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Professional (Physician) Visit - Office</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Chiropractic</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">CHIROPRACTOR,Visit or Evaluation by Chiropractor,Manipulation by Chiropractor</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Chiropractic</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">CHIROPRACTOR</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Limitations
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Plan includes NAP</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Out of Pocket (Stop Loss)
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $1500</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">In-Network Providers</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Out of Pocket (Stop Loss)
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Remaining</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $768.81</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                Yes
                                                                                                </td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Out of Pocket (Stop Loss)
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $3000</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Out of Pocket (Stop Loss)
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Individual
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Time Period:</td>
          <td class="textvalue2" align="left">Remaining</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Monetary Amount:</td>
          <td class="textvalue2" align="left">
                                                                                                                                $2268.81</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left">
                                                                                                                No
                                                                                                </td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Non-Covered
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">In-Plan-Network</td>
          <td class="textvalue2" align="left"></td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">Non Urgent Services at an Urgent Care Facility/EXCLUSION</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Primary Care Provider
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Coverage</td>
          <td class="textvalue2" align="left">
                                                                                                                Family
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Service Type:</td>
          <td class="textvalue2" align="left">Health Benefit Plan Coverage</td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Insurance Type:</td>
          <td class="textvalue2" align="left">Point of Service (POS)</td>
        </tr>
        <tr>
          <td class="valuelabel2">
                                                                                                Message:
                                                                                </td>
          <td class="textvalue2">PCP SELECTION NOT REQUIRED</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Prior or Additional Payor
                                                                                                </td>
        </tr>
        <tr>
          <td class="valuelabel2">Coordination of Benefits</td>
          <td class="textvalue2">01/01/2002</td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
        <tr>
          <td class="valuelabel2" align="right">Eligibility or Benefit</td>
          <td class="textvalue2" align="left">
                                                                                                                Other Source of Data
                                                                                                </td>
        </tr>
        <tr>
          <td colSpan="2">
            <hr style="color: #e9967a;">
          </td>
        </tr>
      </table>
    </p>
  </body>
</html>'

OPEN policy_cursor

--TRUNCATE TABLE dbo.EligibilityHistory

FETCH NEXT FROM policy_cursor
INTO @first_name, @last_name, @dob, @gender, @addressline1, @city, @state, @zip, @payer_name, @payer_id, @provider_first, @provider_last, @provider_npi, @member_id, @group_number, @doctor_id, @policy_id

WHILE @@FETCH_STATUS = 0
BEGIN
	--SELECT  @first_name, @last_name, @dob, @gender, @addressline1, @city, @state, @zip, @payer_name, @payer_id, @provider_first, @provider_last, @provider_npi, @member_id, @group_number, @@doctor_id, @policy_id
	
	DECLARE @response VARCHAR(MAX) = @responseTemplate

	SET @response = REPLACE(@response, '<%PAYER_NAME%>', ISNULL(@payer_name,''))
	SET @response = REPLACE(@response, '<%PAYER_ID%>', ISNULL(@payer_id,''))

	SET @response = REPLACE(@response, '<%PROVIDER_FIRST%>', ISNULL(@provider_first,''))
	SET @response = REPLACE(@response, '<%PROVIDER_LAST%>', ISNULL(@provider_last,''))
	SET @response = REPLACE(@response, '<%PROVIDER_NPI%>', ISNULL(@provider_npi,''))

	SET @response = REPLACE(@response, '<%MEMBER_ID%>', ISNULL(@member_id,''))
	SET @response = REPLACE(@response, '<%GROUP_NUMBER%>', ISNULL(@group_number,''))

	SET @response = REPLACE(@response, '<%PATIENT_FIRST%>', ISNULL(@first_name,''))
	SET @response = REPLACE(@response, '<%PATIENT_LAST%>', ISNULL(@last_name,''))
	SET @response = REPLACE(@response, '<%PATIENT_DOB%>', ISNULL(@dob,''))
	SET @response = REPLACE(@response, '<%PATIENT_GENDER%>', ISNULL(@gender,''))

	SET @response = REPLACE(@response, '<%PATIENT_ADDRESS_LINE_1%>', ISNULL(@addressline1,''))
	SET @response = REPLACE(@response, '<%PATIENT_CITY%>', ISNULL(@city,''))
	SET @response = REPLACE(@response, '<%PATIENT_STATE%>', ISNULL(@state,''))
	SET @response = REPLACE(@response, '<%PATIENT_ZIP%>', ISNULL(@zip,''))
	
	INSERT dbo.EligibilityHistory
			(RequestDate,
			 InsurancePolicyID,
			 EligibilityStatus,
			 Request,
			 Response,
			 ResponseXML,
			 CreatedDate,
			 CreatedUserID,
		 
			 DoctorID,
			 ServiceTypeCode)
	VALUES	('2014-06-06 23:36:15', -- RequestDate - datetime
			 @policy_id, -- InsurancePolicyID - int
			 1, -- EligibilityStatus - int
			 NULL, -- Request - xml
			 @response, -- Response - text

			 --** This can PROBABLY be empty/null. Otherwise we'll need to template out the ResponseXML **--
			 '', -- ResponseXML - text
			 '2014-06-06 23:36:15', -- CreatedDate - datetime
			 0, -- CreatedUserID - int
			 @doctor_id, -- DoctorID - int
			 '30'  -- ServiceTypeCode - varchar(2)
			 )

	FETCH NEXT FROM policy_cursor
	INTO @first_name, @last_name, @dob, @gender, @addressline1, @city, @state, @zip, @payer_name, @payer_id, @provider_first, @provider_last, @provider_npi, @member_id, @group_number, @doctor_id, @policy_id
END

CLOSE policy_cursor
DEALLOCATE policy_cursor



