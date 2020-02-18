-----------------------------------------------------------------
-- Case 20926: New KI Summary Format
-----------------------------------------------------------------
update report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Total All Receipts By:" description="Select the method for calculating the receipts for all providers."     default="1">
      <value displayText="Payments Received" value="1" />
      <value displayText="Payments Applied" value="3" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Style" text="Style:" description="Select the report style:"     default="1">
      <value displayText="Normal" value="1" />
      <value displayText="Hospital" value="2" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Scheduling Provider" value="2" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Payer Scenario" value="7" />
      <value displayText="Batch #" value="8" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="5">
      <value displayText="Metrics" value="5" />
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>',
ReportPath = '/BusinessManagerReports/rptKeyIndicatorsSummary_Pivot',
modifiedDate = getDate()
where Name = 'Key Indicators Summary'
GO