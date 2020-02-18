
Update Report
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
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="RefundStatusCode" text="Refund Status:" description="Select the refund status."    default="A">
      <value displayText="All" value="A" />
      <value displayText="Issued" value="I" />
      <value displayText="Draft" value="D" />
    </extendedParameter>
  </extendedParameters>
</parameters>',
modifiedDate = getdate()
where Name = 'Refunds Summary'



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
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Type:" default="0" ignore="0"/>
    <extendedParameter type="ComboBox" parameterName="RefundStatusCode" text="Refund Status:" description="Select the refund status."    default="A">
      <value displayText="All" value="A" />
      <value displayText="Issued" value="I" />
      <value displayText="Draft" value="D" />
    </extendedParameter>
  </extendedParameters>
</parameters>',
modifiedDate = getdate()
WHERE Name = 'Refunds Detail'



update ReportHyperlink
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Refunds Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="PaymentMethodCode" />
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
            <methodParam param="RefundStatusCode" />
            <methodParam param="{3}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>',
modifiedDate = getdate()
where ReportHyperlinkID = 7


/*


*/