UPDATE dbo.Report 
SET ReportParameters = N'<parameters defaultMessage="Please click on Customize and select a Payment to display a report." csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Payment" parameterName="PaymentID" text="Payment:" default="-1" ignore="-1"/>
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Balance:" description="Select from either Open balance or All" default="O">
      <value displayText="Open" value="O" />
      <value displayText="All" value="A" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE Name LIKE '%Payment Receipt%'