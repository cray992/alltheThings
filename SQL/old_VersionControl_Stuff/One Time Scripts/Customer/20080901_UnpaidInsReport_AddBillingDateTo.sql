



update dbo.Report
SET modifiedDate=getdate(),
ReportParameters='<parameters defaultMessage="Please select custom criteria to display a report." refreshOnParameterChange="true" paging="true" pageColumnCount="0" pageCharacterCount="650000" headerExtractCharacterCount="100000" newPageDelimiter="&lt;/TR&gt;&lt;TR VALIGN=&quot;top&quot;&gt;&lt;TD COLSPAN=&quot;9&quot;&gt;" csv="false">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Insurance" parameterName="PayerID" text="Insurance:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
		<extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="ComboBox" parameterName="Balance" text="Balance:" description="Limits the report by service line balances due." default="All">
			<value displayText="All" value="All" />
			<value displayText="$10.00+" value="$10.00+" />
			<value displayText="$15.00+" value="$15.00+" />
			<value displayText="$20.00+" value="$20.00+" />
			<value displayText="$50.00+" value="$50.00+" />
			<value displayText="$100.00+" value="$100.00+" />
			<value displayText="$500.00+" value="$500.00+" />
			<value displayText="$1,000.00+" value="$1,000.00+" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="DOSRange" text="Date Of Service Age:" description="Limits the report by age of service lines." default="0-15 days">
			<value displayText="0-15 days" value="0-15 days" />
			<value displayText="16-30 days" value="16-30 days" />
			<value displayText="31-45 days" value="31-45 days" />
			<value displayText="46-60 days" value="46-60 days" />
			<value displayText="61-90 days" value="61-90 days" />
			<value displayText="91+ days" value="91+ days" />
                        <value displayText="All" value="All" />
		</extendedParameter>
                <extendedParameter type="Date" parameterName="beginBillingDate" text="Begin Billing Date:" default="None" />
		<extendedParameter type="Date" parameterName="endBillingDate" text="End Billing Date:" default="None" />
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
	</extendedParameters>
</parameters>'
WHERE Name = 'Unpaid Insurance Claims'



update dbo.Report
SET modifiedDate=getdate(),
ReportParameters='<parameters defaultMessage="Please select custom criteria to export." print="false" pdf="false" csv="true">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="ExportType" parameterName="ExportType" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Insurance" parameterName="PayerID" text="Insurance:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="Balance" text="Balance:" description="Limits the report by service line balances due." default="All">
      <value displayText="All" value="All" />
      <value displayText="$10.00+" value="$10.00+" />
      <value displayText="$15.00+" value="$15.00+" />
      <value displayText="$20.00+" value="$20.00+" />
      <value displayText="$50.00+" value="$50.00+" />
      <value displayText="$100.00+" value="$100.00+" />
      <value displayText="$500.00+" value="$500.00+" />
      <value displayText="$1,000.00+" value="$1,000.00+" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="DOSRange" text="Date Of Service Age:" description="Limits the report by age of service lines." default="0-15 days">
      <value displayText="0-15 days" value="0-15 days" />
      <value displayText="16-30 days" value="16-30 days" />
      <value displayText="31-45 days" value="31-45 days" />
      <value displayText="46-60 days" value="46-60 days" />
      <value displayText="61-90 days" value="61-90 days" />
      <value displayText="91+ days" value="91+ days" />
      <value displayText="All" value="All" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
        <extendedParameter type="Date" parameterName="beginBillingDate" text="Begin Billing Date:" default="None" />
        <extendedParameter type="Date" parameterName="endBillingDate" text="End Billing Date:" default="None" />
  </extendedParameters>
</parameters>'
where Name = 'Unpaid Insurance Claims Export'
