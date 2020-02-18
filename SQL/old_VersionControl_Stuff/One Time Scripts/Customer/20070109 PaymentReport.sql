
update ReportHyperlink
Set reportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Payments Detail" />
      <methodParam param="true" type="System.Boolean" />
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="PayerTypeCode" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="BeginDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{3}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
where ReportHyperlinkID = 8

update Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Method:" default="A" ignore="A"/>
    <extendedParameter type="ComboBox" parameterName="PayerTypeCode" text="Payer Type:" description="Limits the report by payer type."     default="-1">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
      <value displayText="Other" value="O" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE Name = 'Payments Summary'



update Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Method:" default="A" ignore="A"/>
    <extendedParameter type="ComboBox" parameterName="PayerTypeCode" text="Payer Type:" description="Limits the report by payer type."     default="A">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
      <value displayText="Other" value="O" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Show Balance:"     default="A">
      <value displayText="All" value="A" />
      <value displayText="Unapplied Balance" value="U" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
where Name = 'Payments Detail'