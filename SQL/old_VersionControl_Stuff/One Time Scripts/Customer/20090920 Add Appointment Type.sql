declare @xml xml
SET @xml='<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="TimeOffset" parameterName="TimeOffset" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From Date:" />
    <basicParameter type="Date" parameterName="EndDate" text="To Date:" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Provider" parameterName="ResourceID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Group by field:" description="Group by field" default="1">
      <value displayText="Timeblock Description" value="1" />
      <value displayText="Timeblock Name on Legend" value="2" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="IncludeAllDay" text="Include Appointment:" description="Choose to include all day appointments" default="0">
      <value displayText="Exclude All Day Apppointment" value="0" />
      <value displayText="Include All Day Appointment" value="1" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="AppointmentType" text="Appointment Type:" description="Choose to include type of appointment" default="A">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
		<value displayText="Other" value="O" />
    </extendedParameter>
  </extendedParameters>
</parameters>'

update report
set reportparameters = @xml
WHERE name='Provider Utilization'


GO


declare @xml xml
SET @xml='
<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="TimeOffset" parameterName="TimeOffset" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From Date:" />
    <basicParameter type="Date" parameterName="EndDate" text="To Date:" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Provider" parameterName="ResourceID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Group by field:" description="Group by field" default="1">
      <value displayText="Timeblock Description" value="1" />
      <value displayText="Timeblock Name on Legend" value="2" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="IncludeAllDay" text="Include Appointment:" description="Choose to include all day appointments" default="0">
      <value displayText="Exclude All Day Apppointment" value="0" />
      <value displayText="Include All Day Appointment" value="1" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="AppointmentType" text="Appointment Type:" description="Choose to include type of appointment" default="A">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
		<value displayText="Other" value="O" />
    </extendedParameter>
  </extendedParameters>
</parameters>'

update report
set reportparameters = @xml
WHERE name='Unscheduled Analysis'

