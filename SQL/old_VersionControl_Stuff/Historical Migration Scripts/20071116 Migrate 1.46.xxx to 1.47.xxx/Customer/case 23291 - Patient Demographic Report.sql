update report
SET ReportParameters = 
'<parameters defaultMessage="Please click on Customize to select export options" print="false" pdf="false">
  <basicParameters>
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="ExportType" parameterName="ExportType" />
    <basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="Balance" text="Balance:" description="Select the balance type" default="O">
      <value displayText="Open Balance" value="O" />
      <value displayText="All Balance" value="A" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date" default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Primary Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="RenderingProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="DefaultServiceLocationID" text="Default Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="ProcedureCodeCategory" parameterName="ProcedureCodeCategory" text="Procedure Category:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="Gender" text="Gender:" description="Limits the report by patient''s gender." default="A">
      <value displayText="Both" value="A" />
      <value displayText="Female" value="F" />
      <value displayText="Male" value="M" />
    </extendedParameter>
    <extendedParameter type="PatientReferralSource" parameterName="PatientReferralSourceID" text="Patient Referral Source:" description="Limits the report by referral source" default="-1" ignore="-1" />
    <extendedParameter type="ReferringPhysician" parameterName="ReferringProviderID" text="Referring Provider:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="DiagnosisCodeStr" text="Diagnoses:" description="Limits the report by diagnosis code" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
  </extendedParameters>
</parameters>',
modifiedDate = getdate()
where name = 'Patient Demographic Export'
