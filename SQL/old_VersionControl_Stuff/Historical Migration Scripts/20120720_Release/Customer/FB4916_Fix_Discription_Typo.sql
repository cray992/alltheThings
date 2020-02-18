SET NOCOUNT ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET ANSI_NULLS ON;
GO

BEGIN TRANSACTION;

UPDATE dbo.Report
SET ReportParameters = '<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date" default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="Adjustment" parameterName="AdjustmentCode" text="Adjustment Code:" default="-1" ignore="-1" />
    <extendedParameter type="AdjustmentCode" parameterName="PaymentDenialReasonCode" text="Denial Reason:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option." default="1">
      <value displayText="Adjustment Description" value="1" />
      <value displayText="Denial Reason Code" value="2" />
      <value displayText="Provider" value="3" />
      <value displayText="Service Location" value="4" />
      <value displayText="Department" value="5" />
      <value displayText="Batch #" value="6" />
      <value displayText="Insurance Companies" value="7" />
      <value displayText="Insurance Plans" value="8" />
      <value displayText="Payer Scenario" value="9" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE   Name = 'Denials Detail';

COMMIT TRANSACTION;