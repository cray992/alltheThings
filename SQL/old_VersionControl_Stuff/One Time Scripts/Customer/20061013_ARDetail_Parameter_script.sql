
/*-----------------------------------------------------------------------------
Case 14699:   A/R report customization not working
-----------------------------------------------------------------------------*/
Update r
set ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
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
            <methodParam param="BatchID" />
            <methodParam param="{10}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
from reportHyperlink r
Where ReportHyperlinkID = 1
GO



Update R
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report." paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
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
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract"/>
    <extendedParameter type="ComboBox" parameterName="RespType" text="Payer Type:" description="Limits the report by the payer type." default="I">
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
    </extendedParameter>
    <extendedParameter type="Patient" parameterName="RespID" text="Patient:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="P" permission="FindPatient" />
    <extendedParameter type="Insurance" parameterName="RespID" text="Insurance:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="I" permission="FindInsurancePlan" />
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
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
from Report r
WHERE Name = 'A/R Aging Detail'


