

Update Report
SET ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="8" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="Activity" text="Activity:" description="Limits the report by patients with activity within specified time frame." default="30 days">
      <value displayText="30 days" value="30 days" />
      <value displayText="90 days" value="90 days" />
      <value displayText="180 days" value="180 days" />
      <value displayText="1 year" value="1 year" />
      <value displayText="All" value="All" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="RenderingProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="TextBox" parameterName="DiagnosisCodeStr" text="Diagnoses:" description="Limits the report by diagnosis code" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />
    <extendedParameter type="ComboBox" parameterName="Gender" text="Gender:" description="Limits the report by patient''s gender." default="A">
      <value displayText="Both" value="A" />
      <value displayText="Female" value="F" />
      <value displayText="Male" value="M" />
    </extendedParameter>
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="PatientReferralSource" parameterName="PatientReferralSourceID" text="Patient Referral Source:" description="Limits the report by referral source" default ="-1" ignore="-1" />
    <extendedParameter type="ReferringPhysician" parameterName="ReferringProviderID" text="Referring Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Date" parameterName="DateOfBirth" text="Date of Birth:" default="None"/>
  </extendedParameters>
</parameters>',
ModifiedDate = getdate()
where Name = 'Patient Contact List'