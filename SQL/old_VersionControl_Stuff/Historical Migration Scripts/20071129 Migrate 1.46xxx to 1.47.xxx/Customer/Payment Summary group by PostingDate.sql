
update report
SET ReportParameters =
'<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Method:" default="A" ignore="A" />
    <extendedParameter type="ComboBox" parameterName="PayerTypeCode" text="Payer Type:" description="Limits the report by payer type." default="-1">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
      <value displayText="Other" value="O" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select to group by" default="1">
      <value displayText="Payer Type" value="1" />
      <value displayText="Payment Method" value="2" />
      <value displayText="Payment Type" value="3" />
      <value displayText="User Role" value="4" />
      <value displayText="Category" value="5" />
		<value displayText="Post Date" value="7" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
where name = 'Payments Summary'