Update r
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
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Method:" default="" ignore=""/>
    <extendedParameter type="ComboBox" parameterName="PaymentTypeID" text="Payment Type:" description="Limits the report by payment type."     default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Copay" value="1" />
      <value displayText="Patient Payment on Account" value="2" />
      <value displayText="Insurance Payment" value="3" />
      <value displayText="Other" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
from report r
WHERE Name = 'Payments Summary'
