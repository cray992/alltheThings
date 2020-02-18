update report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Set the date to start aging from." default="F" >
      <value displayText="First Billed Date" value="F" />
      <value displayText="Last Billed Date" value="L" />
      <value displayText="Post Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="RenderingProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />
    <extendedParameter type="ComboBox" parameterName="Age" text="Age:" description="Filter by age." default="-1" >
      <value displayText="All" value="-1" />
      <value displayText="Current+" value="0" />
      <value displayText="30+" value="30" />
      <value displayText="60+" value="60" />
      <value displayText="90+" value="90" />
      <value displayText="120+" value="120" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Status" text="Status:" description="Filter by claim status." default="A" ignore="A" >
      <value displayText="All" value="A.A" />
      <value displayText="Ready" value="R.A" />
      <value displayText="Pending" value="P.A" />
      <value displayText="Rejections" value="E.RJT" />
      <value displayText="Denials" value="E.DEN" />
      <value displayText="No Response" value="E.BLL" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select the grouping option." default="1">
      <value displayText="Claim Status" value="1" />
      <value displayText="Age" value="3" />
      <value displayText="Insurance Company" value="4" />
      <value displayText="Insurance Plan" value="5" />
      <value displayText="Payer Scenario" value="6" />
      <value displayText="Rendering Provider" value="7" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Patient" value="9" />
      <value displayText="Procedure" value="10" />
      <value displayText="Procedure Category" value="11" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Group2by" text="Subgroup by:" description="Select the subgrouping option." default="3">
      <value displayText="Claim Status" value="1" />
      <value displayText="Age" value="3" />
      <value displayText="Insurance Company" value="4" />
      <value displayText="Insurance Plan" value="5" />
      <value displayText="Payer Scenario" value="6" />
      <value displayText="Rendering Provider" value="7" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Patient" value="9" />
      <value displayText="Procedure" value="10" />
      <value displayText="Procedure Category" value="11" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="SortBy" text="SortBy:" description="Select the sorting option." default="V">
      <value displayText="Value" value="V" />
      <value displayText="Balance" value="B" />
      <value displayText="Age" value="A" />
    </extendedParameter>
  </extendedParameters>
</parameters>',
modifiedDate = getdate()
WHERE Name = 'Insurance Collections Summary'



update Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="15" pageCharacterCount="650000" headerExtractCharacterCount="100000" defaultMessage="Please click on Customize and select an Insurance to display.">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Set the date to start aging from." default="F" >
      <value displayText="First Billed Date" value="F" />
      <value displayText="Last Billed Date" value="L" />
      <value displayText="Post Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="RenderingProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />
    <extendedParameter type="ComboBox" parameterName="Age" text="Age:" description="Filter by age." default="-1" >
      <value displayText="All" value="-1" />
      <value displayText="Current+" value="0" />
      <value displayText="30+" value="30" />
      <value displayText="60+" value="60" />
      <value displayText="90+" value="90" />
      <value displayText="120+" value="120" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Status" text="Claim Status:" description="Filter by claim status." default="A" ignore="A" >
      <value displayText="All" value="A" />
      <value displayText="Ready" value="R" />
      <value displayText="Pending" value="P" />
      <value displayText="Rejections" value="E.RJT" />
      <value displayText="Denials" value="E.DEN" />
      <value displayText="No Response" value="E.BLL" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select the grouping option." default="1">
      <value displayText="Claim Status" value="1" />
      <value displayText="Age" value="3" />
      <value displayText="Insurance Company" value="4" />
      <value displayText="Insurance Plan" value="5" />
      <value displayText="Payer Scenario" value="6" />
      <value displayText="Rendering Provider" value="7" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Patient" value="9" />
      <value displayText="Procedure" value="10" />
      <value displayText="Procedure Category" value="11" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Group2by" text="Subgroup by:" description="Select the subgrouping option." default="3">
      <value displayText="Claim Status" value="1" />
      <value displayText="Age" value="3" />
      <value displayText="Insurance Company" value="4" />
      <value displayText="Insurance Plan" value="5" />
      <value displayText="Payer Scenario" value="6" />
      <value displayText="Rendering Provider" value="7" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Patient" value="9" />
      <value displayText="Procedure" value="10" />
      <value displayText="Procedure Category" value="11" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="SortBy" text="SortBy:" description="Select the sorting option." default="V">
      <value displayText="Value" value="V" />
      <value displayText="Balance" value="B" />
      <value displayText="Age" value="A" />
    </extendedParameter>
  </extendedParameters>
</parameters>',
modifiedDate = getdate()
WHERE Name = 'Insurance Collections Detail'


