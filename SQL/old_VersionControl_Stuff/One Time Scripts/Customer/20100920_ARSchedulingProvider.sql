declare @x xml
set @x = '<parameters paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000" csv="false">
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
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PostalState" text="Postal State:" description="Filter by state" default="-1">
      <value displayText="ALL" value="-1" />
      <dataSetValue tableName="dbo.PostalState" />
    </extendedParameter>
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
set reportParameters=@x, ModifiedDate=getdate()
where Name='A/R Aging by Insurance'


GO



declare @x xml
set @x = '<parameters paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000" csv="false">
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
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PostalState" text="Postal State:" description="Filter by state" default="-1">
      <value displayText="ALL" value="-1" />
      <dataSetValue tableName="dbo.PostalState" />
    </extendedParameter>
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
set reportparameters=@x, modifiedDate=getdate()
where name='A/R Aging by Patient'


GO



declare @x xml
set @x = '<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report." paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000" csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PostalState" text="Postal State:" description="Filter by state" default="-1">
      <value displayText="ALL" value="-1" />
      <dataSetValue tableName="dbo.PostalState" />
    </extendedParameter>
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract" />
    <extendedParameter type="ComboBox" parameterName="RespType" text="Payer Type:" description="Limits the report by the payer type." default="I">
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
    </extendedParameter>
    <extendedParameter type="Patient" parameterName="RespID" text="Patient:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="P" permission="FindPatient" />
    <extendedParameter type="Insurance" parameterName="RespID" text="Insurance:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="I" permission="FindInsurancePlan" />
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
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" />
  </extendedParameters>
</parameters>'

update report
set ReportParameters=@x, modifiedDate=getdate()
where name='A/R Aging Detail'
GO




declare @x varchar(max)
set @x = '<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="A/R Aging by Insurance" />
      <methodParam param="true" type="System.Boolean" />
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="Date" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="ProviderID" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="ServiceLocationID" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="DepartmentID" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="PayerScenarioID" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="ContractID" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="DateType" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="PostalState" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="SchedulingProviderID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{9}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'

UPDATE reportHyperlink
set ReportParameters = @x
where reportHyperlinkId=11
GO



declare @x varchar(max)
set @x = '<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="A/R Aging by Patient" />
      <methodParam param="true" type="System.Boolean" />
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="Date" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="ProviderID" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="ServiceLocationID" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="DepartmentID" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="PayerScenarioID" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="ContractID" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="DateType" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="PostalState" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="SchedulingProviderID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{9}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'



UPDATE reportHyperlink
set ReportParameters = @x
where reportHyperlinkId=12
GO



declare @x varchar(max)
set @x = '<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="A/R Aging Detail" />
      <methodParam param="true" type="System.Boolean" />
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="RespType" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="RespID" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="Date" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="Responsibility" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="ProviderID" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="ServiceLocationID" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="DepartmentID" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="PayerScenarioID" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="PatientID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="ContractID" />
            <methodParam param="{9}" />
          </method>
          <method name="Add">
            <methodParam param="PostalState" />
            <methodParam param="{10}" />
          </method>
          <method name="Add">
            <methodParam param="DateType" />
            <methodParam param="{11}" />
          </method>
          <method name="Add">
            <methodParam param="SchedulingProviderID" />
            <methodParam param="{12}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{13}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'


UPDATE reportHyperlink
set ReportParameters = @x
where reportHyperlinkId=1