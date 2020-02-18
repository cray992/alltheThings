UPDATE Report SET ReportParameters='<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report.">
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
	</extendedParameters>
</parameters>'
WHERE Name='A/R Aging Detail'