/*

DATABASE UPDATE SCRIPT

v1.20.1749 to v1.20.1753
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 2794 - Update the report parameters for the Appointments Summary report to pass through a TimeOffset (TimeZone)

update 	report
set 	ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="TimeOffset" parameterName="TimeOffset" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="Today" forceDefault="true" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" overrideMaxDate="true" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="AppointmentResourceTypeID" text="Type:" description="Limits the report by resource type." default="A" ignore="A">
			<value displayText="All" value="A" />
			<value displayText="Practice Resource" value="2" />
			<value displayText="Provider" value="1" />
		</extendedParameter>
		<extendedParameter type="PracticeResources" parameterName="ResourceID" text="Practice Resource:" default="-1" ignore="-1"  enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="2" />
	        <extendedParameter type="Provider" parameterName="ResourceID" text="Provider:" default="-1" ignore="-1" enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="1" />
	</extendedParameters>
</parameters>'
where 	name = 'Appointments Summary'

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT

