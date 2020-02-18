UPDATE dbo.Report
SET ReportParameters = 
'<parameters defaultMessage="Please click on Customize and select a Patient to display a report." csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Balances to show:" description="Select to show only Open, or All balances." default="A">
      <value displayText="All" value="A" />
      <value displayText="Open Only" value="O" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="IncludeUnappliedPayments" text="Unapplied payments:" description="Select to include, or not to include unapplied payments." default="0">
      <value displayText="Do not include unapplied payments" value="false" />
      <value displayText="Include unapplied payments" value="true" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="IncludeSuppressedStatement" text="Include all Patient Cases:" description="Select to include, or not to include all patient cases." default="0">
      <value displayText="Include only cases set to print patient statement" value="false" />
      <value displayText="Include all patient cases" value="true" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 33