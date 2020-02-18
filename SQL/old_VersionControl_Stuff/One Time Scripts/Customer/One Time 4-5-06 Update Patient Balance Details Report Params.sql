UPDATE Report SET ReportParameters='<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Patient to display a report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1"
			permission="FindPatient" />
		<extendedParameter type="ComboBox" parameterName="ReportType" text="Balances to show:" description="Select to show only Open, or All balances."
		default="O">
		<value displayText="Open Only" value="O" />
		<value displayText="All" value="A" />
		</extendedParameter>
	</extendedParameters>
</parameters>'
WHERE ReportID=27