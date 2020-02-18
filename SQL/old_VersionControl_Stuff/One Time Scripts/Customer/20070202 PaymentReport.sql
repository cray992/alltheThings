
-------------------------------------------------------------
-- Add grouping to payment report
--------------------------------------------------------------
update reportHyperLink
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
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
          <method name="Add">
            <methodParam param="PaymentMethodCode" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="PaymentTypeID" />
            <methodParam param="{5}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE ReportHyperlinkID = 8


update report
set ReportParameters = 
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
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select to group by"     default="1">
      <value displayText="Payer Type" value="1" />
      <value displayText="Payment Method" value="2" />
      <value displayText="Payment Type" value="3" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 5
GO
