
update report 
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="PreviousMonth" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="ProcedureCodeCategory" parameterName="RevenueCategoryID" text="Procedure Category:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />
    <extendedParameter type="ComboBox" parameterName="Metric" text="Metric:" description="Filter by Mertric."    default="A">
      <value displayText="All" value="A" />
      <value displayText="Expected Allowed" value="EA" />
      <value displayText="Average Allowed" value="AA" />
      <value displayText="Expected Payment" value="EP" />
      <value displayText="Average Payment" value="AP" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="4">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Service Location" value="2" />
      <value displayText="Department" value="3" />
      <value displayText="Insurance Company" value="4" />
      <value displayText="Insurance Plan" value="5" />
      <value displayText="Payer Scenario" value="6" />
      <value displayText="Batch #" value="7" />
      <value displayText="Procedure" value="9" />
      <value displayText="Procedure Category" value="8" />
      <value displayText="Metric" value="10" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="9">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Service Location" value="2" />
      <value displayText="Department" value="3" />
      <value displayText="Insurance Company" value="4" />
      <value displayText="Insurance Plan" value="5" />
      <value displayText="Payer Scenario" value="6" />
      <value displayText="Batch #" value="7" />
      <value displayText="Procedure" value="9" />
      <value displayText="Procedure Category" value="8" />
      <value displayText="Metric" value="10" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="5">
      <value displayText="Metrics" value="5" />
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
where Name = 'Contract Management Summary'