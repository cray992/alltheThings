declare @xml xml
SET @xml = '<parameters paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000" csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables." default="B">
      <value displayText="First Billed Date" value="B" />
      <value displayText="Last Billed Date" value="C" />
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="ComboBox" parameterName="AssignedType" text="Responsibility:" description="Limits by patient, insurance or all responsibility." default="P">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range." default="Current+">
      <value displayText="Current+" value="Current+" />
      <value displayText="30+" value="Age31_60" />
      <value displayText="60+" value="Age61_90" />
      <value displayText="90+" value="Age91_120" />
      <value displayText="120+" value="AgeOver120" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range." default="All">
      <value displayText="All" value="All" />
      <value displayText="Less than $0" value="$0-" />
      <value displayText="Greater than $0" value="$0+" />
      <value displayText="$0-$10" value="$0-10" />
      <value displayText="$10+" value="$10+" />
      <value displayText="$50+" value="$50+" />
      <value displayText="$100+" value="$100+" />
      <value displayText="$1,000+" value="$1000+" />
      <value displayText="$5,000+" value="$5000+" />
      <value displayText="$10,000+" value="$10000+" />
      <value displayText="$100,000+" value="$100000+" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field." default="false">
      <value displayText="Resp Name" value="false" />
      <value displayText="Open Balance" value="true" />
    </extendedParameter>
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
  </extendedParameters>
</parameters>'

update report
set reportParameters = @xml
	,ModifiedDate=getdate()
where name = 'A/R Aging by Patient'




GO





declare @xml XML
SET @xml = '
<parameters paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000" csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="String" parameterName="PayerTypeCode" default="1" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables." default="B">
      <value displayText="First Billed Date" value="B" />
      <value displayText="Last Billed Date" value="C" />
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range." default="Current+">
      <value displayText="Current+" value="Current+" />
      <value displayText="30+" value="Age31_60" />
      <value displayText="60+" value="Age61_90" />
      <value displayText="90+" value="Age91_120" />
      <value displayText="120+" value="AgeOver120" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range." default="All">
      <value displayText="All" value="All" />
      <value displayText="Less than $0" value="$0-" />
      <value displayText="Greater than $0" value="$0+" />
      <value displayText="$0-$10" value="$0-10" />
      <value displayText="$10+" value="$10+" />
      <value displayText="$50+" value="$50+" />
      <value displayText="$100+" value="$100+" />
      <value displayText="$1,000+" value="$1000+" />
      <value displayText="$5,000+" value="$5000+" />
      <value displayText="$10,000+" value="$10000+" />
      <value displayText="$100,000+" value="$100000+" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field." default="false">
      <value displayText="Resp Name" value="false" />
      <value displayText="Open Balance" value="true" />
    </extendedParameter>
  </extendedParameters>
</parameters>'

update report
SET reportParameters = @xml
	,ModifiedDate=getdate()
where name = 'A/R Aging by Insurance'


GO


declare @xml xml;
SET @xml = '<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables." default="B">
      <value displayText="First Billed Date" value="B" />
      <value displayText="Last Billed Date" value="C" />
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" description="Limits the report by scheduling provider" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract" />
  </extendedParameters>
</parameters>'


Update report
SET ReportParameters = @xml
where name = 'A/R Aging Summary'