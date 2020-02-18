/*
-----------------------------------------------------------------------------------------------------
CASE 21173 - Removed the filter separators from all the report parameters.
-----------------------------------------------------------------------------------------------------
*/

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Total All Receipts By:" description="Select the method for calculating the receipts for all providers."     default="1">
      <value displayText="Payments Received" value="1" />
      <value displayText="Payments Applied" value="3" />
      <value displayText="Payments Received w/ Date Fix" value="2" />
      <value displayText="Payments Received w/ Date Fix (payment applied after creation of charges" value="4" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Style" text="Style:" description="Select the report style:"     default="0">
      <value displayText="Normal" value="0" />
      <value displayText="Hospital" value="1" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="4">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Scheduling Provider" value="2" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Insurance Company" value="5" />
      <value displayText="Insurance Plan" value="6" />
      <value displayText="Payer Scenario" value="7" />
      <value displayText="Batch #" value="8" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="5">
      <value displayText="Metrics" value="5" />
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 1

UPDATE Report
SET ReportParameters = '<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Total All Receipts By:" description="Select the method for calculating the receipts for all providers."     default="1">
      <value displayText="Payments Received" value="1" />
      <value displayText="Payments Applied" value="3" />
      <value displayText="Payments Received w/ Date Fix" value="2" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" description="Limits the report by scheduling provider." default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Group report by:"     default="P">
      <value displayText="Rendering Provider" value="P" />
      <value displayText="Service Location" value="S" />
      <value displayText="Department" value="D" />
      <value displayText="Scheduling Provider" value="C" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Style" text="Style:" description="Select the report style:"     default="0">
      <value displayText="Normal" value="0" />
      <value displayText="Hospital" value="1" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 2

UPDATE Report
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
WHERE ReportID = 6

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type."     default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Date of Service" value="D" />
    </extendedParameter>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:"     default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 9

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Click refresh for all Patients (this may take some time) otherwise click on Customize and select a Patient." paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 12

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8"?>
<parameters>
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
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ReferringPhysician" parameterName="ReferringProviderID" text="Referring Physician..." default="-1" ignore="-1" permission="FindReferringPhysician" />
  </extendedParameters>
</parameters>'
WHERE ReportID = 13

UPDATE Report
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
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 14

UPDATE Report
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
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Type:" default="0" ignore="0"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 16

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report." paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
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
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract"/>
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
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 17

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="TimeOffset" parameterName="TimeOffset" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" overrideMaxDate="true" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="AppointmentResourceTypeID" text="Type:" description="Limits the report by resource type."     default="A" ignore="A">
      <value displayText="All" value="A" />
      <value displayText="Practice Resource" value="2" />
      <value displayText="Provider" value="1" />
    </extendedParameter>
    <extendedParameter type="PracticeResources" parameterName="ResourceID" text="Practice Resource:" default="-1"     ignore="-1" enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="2" />
    <extendedParameter type="Provider" parameterName="ResourceID" text="Provider:" default="-1" ignore="-1"     enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="1" />
    <extendedParameter type="AppointmentStatus" parameterName="Status" text="Status:" default="Z" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="StartTime" text="Start Time:"  default="08:00:00" >
      <value displayText="12:00 AM"  value="00:00:00" />
      <value displayText="12:15 AM"  value="00:15:00" />
      <value displayText="12:30 AM"  value="00:30:00" />
      <value displayText="12:45 AM"  value="00:45:00" />
      <value displayText="01:00 AM"  value="01:00:00" />
      <value displayText="01:15 AM"  value="01:15:00" />
      <value displayText="01:30 AM"  value="01:30:00" />
      <value displayText="01:45 AM"  value="01:45:00" />
      <value displayText="02:00 AM"  value="02:00:00" />
      <value displayText="02:15 AM"  value="02:15:00" />
      <value displayText="02:30 AM"  value="02:30:00" />
      <value displayText="02:45 AM"  value="02:45:00" />
      <value displayText="03:00 AM"  value="03:00:00" />
      <value displayText="03:15 AM"  value="03:15:00" />
      <value displayText="03:30 AM"  value="03:30:00" />
      <value displayText="03:45 AM"  value="03:45:00" />
      <value displayText="04:00 AM"  value="04:00:00" />
      <value displayText="04:15 AM"  value="04:15:00" />
      <value displayText="04:30 AM"  value="04:30:00" />
      <value displayText="04:45 AM"  value="04:45:00" />
      <value displayText="05:00 AM"  value="05:00:00" />
      <value displayText="05:15 AM"  value="05:15:00" />
      <value displayText="05:30 AM"  value="05:30:00" />
      <value displayText="05:45 AM"  value="05:45:00" />
      <value displayText="06:00 AM"  value="06:00:00" />
      <value displayText="06:15 AM"  value="06:15:00" />
      <value displayText="06:30 AM"  value="06:30:00" />
      <value displayText="06:45 AM"  value="06:45:00" />
      <value displayText="07:00 AM"  value="07:00:00" />
      <value displayText="07:15 AM"  value="07:15:00" />
      <value displayText="07:30 AM"  value="07:30:00" />
      <value displayText="07:45 AM"  value="07:45:00" />
      <value displayText="08:00 AM"  value="08:00:00" />
      <value displayText="08:15 AM"  value="08:15:00" />
      <value displayText="08:30 AM"  value="08:30:00" />
      <value displayText="08:45 AM"  value="08:45:00" />
      <value displayText="09:00 AM"  value="09:00:00" />
      <value displayText="09:15 AM"  value="09:15:00" />
      <value displayText="09:30 AM"  value="09:30:00" />
      <value displayText="09:45 AM"  value="09:45:00" />
      <value displayText="10:00 AM"  value="10:00:00" />
      <value displayText="10:15 AM"  value="10:15:00" />
      <value displayText="10:30 AM"  value="10:30:00" />
      <value displayText="10:45 AM"  value="10:45:00" />
      <value displayText="11:00 AM"  value="11:00:00" />
      <value displayText="11:15 AM"  value="11:15:00" />
      <value displayText="11:30 AM"  value="11:30:00" />
      <value displayText="11:45 AM"  value="11:45:00" />
      <value displayText="12:00 AM"  value="12:00:00" />
      <value displayText="12:15 AM"  value="12:15:00" />
      <value displayText="12:30 AM"  value="12:30:00" />
      <value displayText="12:45 AM"  value="12:45:00" />
      <value displayText="01:00 PM"  value="13:00:00" />
      <value displayText="01:15 PM"  value="13:15:00" />
      <value displayText="01:30 PM"  value="13:30:00" />
      <value displayText="01:45 PM"  value="13:45:00" />
      <value displayText="02:00 PM"  value="14:00:00" />
      <value displayText="02:15 PM"  value="14:15:00" />
      <value displayText="02:30 PM"  value="14:30:00" />
      <value displayText="02:45 PM"  value="14:45:00" />
      <value displayText="03:00 PM"  value="15:00:00" />
      <value displayText="03:15 PM"  value="15:15:00" />
      <value displayText="03:30 PM"  value="15:30:00" />
      <value displayText="03:45 PM"  value="15:45:00" />
      <value displayText="04:00 PM"  value="16:00:00" />
      <value displayText="04:15 PM"  value="16:15:00" />
      <value displayText="04:30 PM"  value="16:30:00" />
      <value displayText="04:45 PM"  value="16:45:00" />
      <value displayText="05:00 PM"  value="17:00:00" />
      <value displayText="05:15 PM"  value="17:15:00" />
      <value displayText="05:30 PM"  value="17:30:00" />
      <value displayText="05:45 PM"  value="17:45:00" />
      <value displayText="06:00 PM"  value="18:00:00" />
      <value displayText="06:15 PM"  value="18:15:00" />
      <value displayText="06:30 PM"  value="18:30:00" />
      <value displayText="06:45 PM"  value="18:45:00" />
      <value displayText="07:00 PM"  value="19:00:00" />
      <value displayText="07:15 PM"  value="19:15:00" />
      <value displayText="07:30 PM"  value="19:30:00" />
      <value displayText="07:45 PM"  value="19:45:00" />
      <value displayText="08:00 PM"  value="20:00:00" />
      <value displayText="08:15 PM"  value="20:15:00" />
      <value displayText="08:30 PM"  value="20:30:00" />
      <value displayText="08:45 PM"  value="20:45:00" />
      <value displayText="09:00 PM"  value="21:00:00" />
      <value displayText="09:15 PM"  value="21:15:00" />
      <value displayText="09:30 PM"  value="21:30:00" />
      <value displayText="09:45 PM"  value="21:45:00" />
      <value displayText="10:00 PM"  value="22:00:00" />
      <value displayText="10:15 PM"  value="22:15:00" />
      <value displayText="10:30 PM"  value="22:30:00" />
      <value displayText="10:45 PM"  value="22:45:00" />
      <value displayText="11:00 PM"  value="23:00:00" />
      <value displayText="11:15 PM"  value="23:15:00" />
      <value displayText="11:30 PM"  value="23:30:00" />
      <value displayText="11:45 PM"  value="23:45:00" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="EndTime" text="End Time:"     default="18:00:00" >
      <value displayText="12:00 AM"  value="00:00:00" />
      <value displayText="12:15 AM"  value="00:15:00" />
      <value displayText="12:30 AM"  value="00:30:00" />
      <value displayText="12:45 AM"  value="00:45:00" />
      <value displayText="01:00 AM"  value="01:00:00" />
      <value displayText="01:15 AM"  value="01:15:00" />
      <value displayText="01:30 AM"  value="01:30:00" />
      <value displayText="01:45 AM"  value="01:45:00" />
      <value displayText="02:00 AM"  value="02:00:00" />
      <value displayText="02:15 AM"  value="02:15:00" />
      <value displayText="02:30 AM"  value="02:30:00" />
      <value displayText="02:45 AM"  value="02:45:00" />
      <value displayText="03:00 AM"  value="03:00:00" />
      <value displayText="03:15 AM"  value="03:15:00" />
      <value displayText="03:30 AM"  value="03:30:00" />
      <value displayText="03:45 AM"  value="03:45:00" />
      <value displayText="04:00 AM"  value="04:00:00" />
      <value displayText="04:15 AM"  value="04:15:00" />
      <value displayText="04:30 AM"  value="04:30:00" />
      <value displayText="04:45 AM"  value="04:45:00" />
      <value displayText="05:00 AM"  value="05:00:00" />
      <value displayText="05:15 AM"  value="05:15:00" />
      <value displayText="05:30 AM"  value="05:30:00" />
      <value displayText="05:45 AM"  value="05:45:00" />
      <value displayText="06:00 AM"  value="06:00:00" />
      <value displayText="06:15 AM"  value="06:15:00" />
      <value displayText="06:30 AM"  value="06:30:00" />
      <value displayText="06:45 AM"  value="06:45:00" />
      <value displayText="07:00 AM"  value="07:00:00" />
      <value displayText="07:15 AM"  value="07:15:00" />
      <value displayText="07:30 AM"  value="07:30:00" />
      <value displayText="07:45 AM"  value="07:45:00" />
      <value displayText="08:00 AM"  value="08:00:00" />
      <value displayText="08:15 AM"  value="08:15:00" />
      <value displayText="08:30 AM"  value="08:30:00" />
      <value displayText="08:45 AM"  value="08:45:00" />
      <value displayText="09:00 AM"  value="09:00:00" />
      <value displayText="09:15 AM"  value="09:15:00" />
      <value displayText="09:30 AM"  value="09:30:00" />
      <value displayText="09:45 AM"  value="09:45:00" />
      <value displayText="10:00 AM"  value="10:00:00" />
      <value displayText="10:15 AM"  value="10:15:00" />
      <value displayText="10:30 AM"  value="10:30:00" />
      <value displayText="10:45 AM"  value="10:45:00" />
      <value displayText="11:00 AM"  value="11:00:00" />
      <value displayText="11:15 AM"  value="11:15:00" />
      <value displayText="11:30 AM"  value="11:30:00" />
      <value displayText="11:45 AM"  value="11:45:00" />
      <value displayText="12:00 AM"  value="12:00:00" />
      <value displayText="12:15 AM"  value="12:15:00" />
      <value displayText="12:30 AM"  value="12:30:00" />
      <value displayText="12:45 AM"  value="12:45:00" />
      <value displayText="01:00 PM"  value="13:00:00" />
      <value displayText="01:15 PM"  value="13:15:00" />
      <value displayText="01:30 PM"  value="13:30:00" />
      <value displayText="01:45 PM"  value="13:45:00" />
      <value displayText="02:00 PM"  value="14:00:00" />
      <value displayText="02:15 PM"  value="14:15:00" />
      <value displayText="02:30 PM"  value="14:30:00" />
      <value displayText="02:45 PM"  value="14:45:00" />
      <value displayText="03:00 PM"  value="15:00:00" />
      <value displayText="03:15 PM"  value="15:15:00" />
      <value displayText="03:30 PM"  value="15:30:00" />
      <value displayText="03:45 PM"  value="15:45:00" />
      <value displayText="04:00 PM"  value="16:00:00" />
      <value displayText="04:15 PM"  value="16:15:00" />
      <value displayText="04:30 PM"  value="16:30:00" />
      <value displayText="04:45 PM"  value="16:45:00" />
      <value displayText="05:00 PM"  value="17:00:00" />
      <value displayText="05:15 PM"  value="17:15:00" />
      <value displayText="05:30 PM"  value="17:30:00" />
      <value displayText="05:45 PM"  value="17:45:00" />
      <value displayText="06:00 PM"  value="18:00:00" />
      <value displayText="06:15 PM"  value="18:15:00" />
      <value displayText="06:30 PM"  value="18:30:00" />
      <value displayText="06:45 PM"  value="18:45:00" />
      <value displayText="07:00 PM"  value="19:00:00" />
      <value displayText="07:15 PM"  value="19:15:00" />
      <value displayText="07:30 PM"  value="19:30:00" />
      <value displayText="07:45 PM"  value="19:45:00" />
      <value displayText="08:00 PM"  value="20:00:00" />
      <value displayText="08:15 PM"  value="20:15:00" />
      <value displayText="08:30 PM"  value="20:30:00" />
      <value displayText="08:45 PM"  value="20:45:00" />
      <value displayText="09:00 PM"  value="21:00:00" />
      <value displayText="09:15 PM"  value="21:15:00" />
      <value displayText="09:30 PM"  value="21:30:00" />
      <value displayText="09:45 PM"  value="21:45:00" />
      <value displayText="10:00 PM"  value="22:00:00" />
      <value displayText="10:15 PM"  value="22:15:00" />
      <value displayText="10:30 PM"  value="22:30:00" />
      <value displayText="10:45 PM"  value="22:45:00" />
      <value displayText="11:00 PM"  value="23:00:00" />
      <value displayText="11:15 PM"  value="23:15:00" />
      <value displayText="11:30 PM"  value="23:30:00" />
      <value displayText="11:45 PM"  value="23:45:00" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="MinuteInterval" text="Time Increments:" description="Set the time increments for displaying appointments."     default="30" >
      <value displayText="1 minute" value="1" />
      <value displayText="2 minute" value="2" />
      <value displayText="3 minute" value="3" />
      <value displayText="4 minute" value="4" />
      <value displayText="5 minute" value="5" />
      <value displayText="6 minute" value="6" />
      <value displayText="10 minute" value="10" />
      <value displayText="12 minute" value="12" />
      <value displayText="15 minute" value="15" />
      <value displayText="20 minute" value="20" />
      <value displayText="30 minute" value="30" />
      <value displayText="60 minute" value="60" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ScheduleStyle" text="Schedule Style:" description="Select the style for printing appointments."     default="1">
      <value displayText="Normal" value="1" />
      <value displayText="Fixed Time Slots" value="2" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 18

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8"?>
<parameters>
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
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ProcedureCode" parameterName="ProcedureCode" text="Procedure Code:" default="-1" ignore="-1" permission="FindProcedure" />
  </extendedParameters>
</parameters>'
WHERE ReportID = 21

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Patient for this report." paging="false" pageColumnCount="0" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="CustomDateRange" fromDateParameter="StartingDate" toDateParameter="EndingDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="StartingDate" text="From:" default="OneYearAgo" />
    <basicParameter type="Date" parameterName="EndingDate" text="To:" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 22

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="TimeOffset" parameterName="TimeOffset" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateTypeID" text="Date Type:" description="Limits the report by date type." default="P" ignore="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Date of Service" value="S" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 23

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="String" parameterName="PayerTypeCode" default="1" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract"/>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables."    default="B">
      <value displayText="Last Billed Date" value="B" />
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range."     default="Current+">
      <value displayText="Current+" value="Current+" />
      <value displayText="30+" value="Age31_60" />
      <value displayText="60+" value="Age61_90" />
      <value displayText="90+" value="Age91_120" />
      <value displayText="120+" value="AgeOver120" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range."     default="All">
      <value displayText="All" value="All" />
      <value displayText="$10+" value="$10+" />
      <value displayText="$50+" value="$50+" />
      <value displayText="$100+" value="$100+" />
      <value displayText="$1,000+" value="$1000+" />
      <value displayText="$5,000+" value="$5000+" />
      <value displayText="$10,000+" value="$10000+" />
      <value displayText="$100,000+" value="$100000+" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field."     default="false">
      <value displayText="Resp Name" value="false" />
      <value displayText="Open Balance" value="true" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 24

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables."    default="B">
      <value displayText="Last Billed Date" value="B" />
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="ComboBox" parameterName="AssignedType" text="Responsibility:" description="Limits by patient, insurance or all responsibility."    default="P">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range."     default="Current+">
      <value displayText="Current+" value="Current+" />
      <value displayText="30+" value="Age31_60" />
      <value displayText="60+" value="Age61_90" />
      <value displayText="90+" value="Age91_120" />
      <value displayText="120+" value="AgeOver120" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range."     default="All">
      <value displayText="All" value="All" />
      <value displayText="$10+" value="$10+" />
      <value displayText="$50+" value="$50+" />
      <value displayText="$100+" value="$100+" />
      <value displayText="$1,000+" value="$1000+" />
      <value displayText="$5,000+" value="$5000+" />
      <value displayText="$10,000+" value="$10000+" />
      <value displayText="$100,000+" value="$100000+" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field."     default="false">
      <value displayText="Resp Name" value="false" />
      <value displayText="Open Balance" value="true" />
    </extendedParameter>
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract"/>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 25

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="Assigned" text="Assigned to:" description="Show only patients with a balance assigned to all, patient, or insurance."    default="P">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 26

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Patient to display a report." paging="true" pageColumnCount="1" pageCharacterCount="650000" headerExtractCharacterCount="100000">
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
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1"     permission="FindPatient" />
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Balances to show:" description="Select to show only Open, or All balances."    default="O">
      <value displayText="Open Only" value="O" />
      <value displayText="All" value="A" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 27

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="0" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="StartDate" toDateParameter="EndDate" text="Dates:" default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="StartDate" text="From:"  />
    <basicParameter type="Date" parameterName="EndDate" text="To:"  />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type." default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Date of Service" value="D" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="RevenueCategoryID" text="Revenue Category:" description="Limits the report by Revenue Category." default="-1" ignore="-1">
      <value displayText="ALL" value="-1" />
      <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24"/>
      <value displayText="Anesthesia (00100-01999)" value="1"/>
      <value displayText="Category II Codes (0001F-6999F)" value="46"/>
      <value displayText="Category III Codes (0001T-0999T)" value="47"/>
      <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25"/>
      <value displayText="Dental Procedures (D0120-D9999)" value="26"/>
      <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27"/>
      <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28"/>
      <value displayText="Durable Medical Equipment (E0100-E9999)" value="29"/>
      <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30"/>
      <value displayText="Evaluation and Management (99201-99499)" value="2"/>
      <value displayText="Hearing Services (V5008-V5364)" value="31"/>
      <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32"/>
      <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33"/>
      <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34"/>
      <value displayText="Medical Services (M0064-M0302)" value="35"/>
      <value displayText="Medicine (90281-99199)" value="3"/>
      <value displayText="Medicine (99500-99602)" value="4"/>
      <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36"/>
      <value displayText="Orthotic Procedures (L0100-L4398)" value="37"/>
      <value displayText="Pathology and Laboratory (80048-89399)" value="5"/>
      <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38"/>
      <value displayText="Private Payer Codes (S0009-S9999)" value="39"/>
      <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40"/>
      <value displayText="Prosthetic Procedures (L5000-L9900)" value="41"/>
      <value displayText="Radiology (70010-79999)" value="6"/>
      <value displayText="Rehabilitative Services (H0001-H2037)" value="42"/>
      <value displayText="Surgery - Auditory System (69000-69979)" value="7"/>
      <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8"/>
      <value displayText="Surgery - Digestive System (40490-49999)" value="9"/>
      <value displayText="Surgery - Endocrine System (60000-60699)" value="10"/>
      <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11"/>
      <value displayText="Surgery - Female Genital System (56405-58999)" value="12"/>
      <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13"/>
      <value displayText="Surgery - Integumentary System (10040-19499)" value="14"/>
      <value displayText="Surgery - Intersex (55970-55980)" value="15"/>
      <value displayText="Surgery - Male Genital System (54000-55899)" value="16"/>
      <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17"/>
      <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18"/>
      <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19"/>
      <value displayText="Surgery - Nervous System (61000-64999)" value="20"/>
      <value displayText="Surgery - Operating Microscope (69990-69990)" value="21"/>
      <value displayText="Surgery - Respiratory System (30000-32999)" value="22"/>
      <value displayText="Surgery - Urinary System (50010-53899)" value="23"/>
      <value displayText="Temporary Codes (Q0034-Q9999)" value="43"/>
      <value displayText="Transportation Services (A0080-A0999)" value="44"/>
      <value displayText="Vision Services (V2020-V2799)" value="45"/>
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="RevenueProcedureCodeType" text="Rev. Category Code:" description="Limit the Revenue Category filter by code type." default="P">
      <value displayText="Procedure Code" value="P" />
      <value displayText="Billing Code" value="B" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
    <extendedParameter type="ComboBox" parameterName="TransactionType" text="Transaction Type:" description="Filter by transaction type." default="ALL">
      <value displayText="All" value="All" />
      <value displayText="Charges" value="CST" />
      <value displayText="Adjustments" value="ADJ" />
      <value displayText="Receipts" value="PAY" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="OptionalField" text="Optional Field:" description="Select the field to display." default="1">
      <value displayText="Exp Reimbursement" value="1" />
      <value displayText="Diagnosis #1" value="2" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Groupby" text="Group By:" description="Select the grouping." default="1">
      <value displayText="Provider" value="1" />
      <value displayText="Service Location" value="2" />
      <value displayText="Department" value="3" />
      <value displayText="Revenue Category" value="4" />
      <value displayText="Procedure Code" value="5" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="SortBy" text="Order By:" description="Select the ordering." default="P">
      <value displayText="Procedure Code" value="P" />
      <value displayText="Diagnosis #1" value="D" />
      <value displayText="Patient Name" value="Pat" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 29

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="StartDate" toDateParameter="EndDate" text="Dates:"     default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="StartDate" text="From:" overrideMaxDate="true" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type."     default="D">
      <value displayText="Posting Date" value="P" />
      <value displayText="Date of Service" value="D" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1"     permission="FindPatient" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" description="Limits the report by batch #."/>
    <extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Encounter Status:" description="Limits the report by Encounter Status." default="3">
      <value displayText="All" value="-1" />
      <value displayText="Approved" value="3" />
      <value displayText="Draft" value="1" />
      <value displayText="Submitted" value="2" />
      <value displayText="Rejected" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 30

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please select custom criteria to display a report." refreshOnParameterChange="true" paging="true" pageColumnCount="0" pageCharacterCount="650000" headerExtractCharacterCount="100000" newPageDelimiter="&lt;/TR&gt;&lt;TR VALIGN=&quot;top&quot;&gt;&lt;TD COLSPAN=&quot;9&quot;&gt;">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
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
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 31

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="8" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="Activity" text="Activity:" description="Limits the report by patients with activity within specified time frame." default="30 days">
      <value displayText="30 days" value="30 days" />
      <value displayText="90 days" value="90 days" />
      <value displayText="180 days" value="180 days" />
      <value displayText="1 year" value="1 year" />
      <value displayText="All" value="All" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 32

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1"     permission="FindPatient" />
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Balances to show:" description="Select to show only Open, or All balances."    default="O">
      <value displayText="Open Only" value="O" />
      <value displayText="All" value="A" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="IncludeUnappliedPayments" text="Unapplied payments:" description="Select to include, or not to include unapplied payments."    default="0">
      <value displayText="Do not include unapplied payments" value="false" />
      <value displayText="Include unapplied payments" value="true" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 33

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="15" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Status:" description="Select Encounter Status"    default="3">
      <value displayText="All" value="-1" />
      <value displayText="Approved" value="3" />
      <value displayText="Drafts" value="1" />
      <value displayText="Submitted" value="2" />
      <value displayText="Rejected" value="4" />
      <value displayText="Unpayable" value="7" />
    </extendedParameter>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="ProviderNumberID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group report by:" description="Select to group by Status, Rendering Provider, Service location, Department or Scheduling Provider"    default="Status">
      <value displayText="Status" value="Status" />
      <value displayText="Rendering Provider" value="Provider" />
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Department" value="Department" />
      <value displayText="Scheduling Provider" value="SchedulingProvider" />
      <value displayText="Default Rendering Provider" value="DefaultRenderingProvider" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchNumberID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 34

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters >
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"  />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Status:" description="Select Encounter Status"    default="3">
      <value displayText="All" value="-1" />
      <value displayText="Approved" value="3" />
      <value displayText="Drafts" value="1" />
      <value displayText="Submitted" value="2" />
      <value displayText="Rejected" value="4" />
      <value displayText="Unpayable" value="7" />
    </extendedParameter>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="ProviderNumberID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select to group by Status, Rendering Provider, Service location, or Department"    default="Status">
      <value displayText="Status" value="Status" />
      <value displayText="Rendering Provider" value="Provider" />
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Department" value="Department" />
      <value displayText="Scheduling Provider" value="SchedulingProvider" />
      <value displayText="Default Rendering Provider" value="DefaultRenderingProvider" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Group2by" text="Subgroup by:" description="Select to sub group by Status, Rendering Provider, Service location, or Department"    default="Provider">
      <value displayText="Rendering Provider" value="Provider" />
      <value displayText="Status" value="Status" />
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Department" value="Department" />
      <value displayText="Scheduling Provider" value="SchedulingProvider" />
      <value displayText="Default Rendering Provider" value="DefaultRenderingProvider" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchNumberID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 35

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceID" text="Insurance:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="groupby" text="Group by:" description="Select the grouping option"    default="1">
      <value displayText="Provider" value="1" />
      <value displayText="Service Location" value="2" />
      <value displayText="Department" value="3" />
      <value displayText="Insurance" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 36

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyID" text="Insurance:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select the grouping option"    default="Service Location">
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Insurance" value="Insurance" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 40

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
  </extendedParameters>
</parameters>'
WHERE ReportID = 41

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"  />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="RevenueCategory" text="Revenue Category:" description="Limits the report by Revenue Category"     default="-1" ignore="-1">
      <value displayText="ALL" value="-1" />
      <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24"/>
      <value displayText="Anesthesia (00100-01999)" value="1"/>
      <value displayText="Category II Codes (0001F-6999F)" value="46"/>
      <value displayText="Category III Codes (0001T-0999T)" value="47"/>
      <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25"/>
      <value displayText="Dental Procedures (D0120-D9999)" value="26"/>
      <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27"/>
      <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28"/>
      <value displayText="Durable Medical Equipment (E0100-E9999)" value="29"/>
      <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30"/>
      <value displayText="Evaluation and Management (99201-99499)" value="2"/>
      <value displayText="Hearing Services (V5008-V5364)" value="31"/>
      <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32"/>
      <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33"/>
      <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34"/>
      <value displayText="Medical Services (M0064-M0302)" value="35"/>
      <value displayText="Medicine (90281-99199)" value="3"/>
      <value displayText="Medicine (99500-99602)" value="4"/>
      <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36"/>
      <value displayText="Orthotic Procedures (L0100-L4398)" value="37"/>
      <value displayText="Pathology and Laboratory (80048-89399)" value="5"/>
      <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38"/>
      <value displayText="Private Payer Codes (S0009-S9999)" value="39"/>
      <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40"/>
      <value displayText="Prosthetic Procedures (L5000-L9900)" value="41"/>
      <value displayText="Radiology (70010-79999)" value="6"/>
      <value displayText="Rehabilitative Services (H0001-H2037)" value="42"/>
      <value displayText="Surgery - Auditory System (69000-69979)" value="7"/>
      <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8"/>
      <value displayText="Surgery - Digestive System (40490-49999)" value="9"/>
      <value displayText="Surgery - Endocrine System (60000-60699)" value="10"/>
      <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11"/>
      <value displayText="Surgery - Female Genital System (56405-58999)" value="12"/>
      <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13"/>
      <value displayText="Surgery - Integumentary System (10040-19499)" value="14"/>
      <value displayText="Surgery - Intersex (55970-55980)" value="15"/>
      <value displayText="Surgery - Male Genital System (54000-55899)" value="16"/>
      <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17"/>
      <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18"/>
      <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19"/>
      <value displayText="Surgery - Nervous System (61000-64999)" value="20"/>
      <value displayText="Surgery - Operating Microscope (69990-69990)" value="21"/>
      <value displayText="Surgery - Respiratory System (30000-32999)" value="22"/>
      <value displayText="Surgery - Urinary System (50010-53899)" value="23"/>
      <value displayText="Temporary Codes (Q0034-Q9999)" value="43"/>
      <value displayText="Transportation Services (A0080-A0999)" value="44"/>
      <value displayText="Vision Services (V2020-V2799)" value="45"/>
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option"    default="1">
      <value displayText="Revenue Category" value="Revenue Category" />
      <value displayText="Provider" value="Provider" />
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Department" value="Department" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 43

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"  />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="PayerMetric" text="Payer Metric:" description="Select the Payer Metric option"    default="0">
      <value displayText="All" value="0" />
      <value displayText="Payer Mix by Patients" value="1" />
      <value displayText="Payer Mix by Encounters" value="2" />
      <value displayText="Payer Mix by Procedures" value="3" />
      <value displayText="Payer Mix by Charges" value="4" />
      <value displayText="Payer Mix by Receipts" value="5" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="EncounterStatus" text="Status:" description="Select Encounter Status"    default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Approved" value="3" />
      <value displayText="Drafts" value="1" />
      <value displayText="Submitted" value="2" />
      <value displayText="Rejected" value="4" />
      <value displayText="Unpayable" value="7" />
    </extendedParameter>
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option"    default="Provider">
      <value displayText="Revenue Category" value="Revenue Category" />
      <value displayText="Provider" value="Provider" />
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Department" value="Department" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the grouping option"    default="Insurance Company">
      <value displayText="Payer Scenario" value="Payer Scenario" />
      <value displayText="Insurance Company" value="Insurance Company" />
      <value displayText="Insurance Plan" value="Insurance Plan" />
      <value displayText="Contract" value="Contract Name" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE ReportID = 44

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="ExportType" parameterName="ExportType" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="ComboBox" parameterName="PatientType" text="Patient Type:" description="Select the Patient Type"    default="A">
      <value displayText="All" value="A" />
      <value displayText="Existing" value="E" />
      <value displayText="New" value="N" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Provider" value="1" />
      <value displayText="Referring Provider" value="2" />
      <value displayText="Primary Care Physician" value="3" />
      <value displayText="Service Location" value="4" />
      <value displayText="Department" value="5" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Group2by" text="Subgroup by:" description="Select the subgrouping option."    default="8">
      <value displayText="Provider" value="1" />
      <value displayText="Referring Provider" value="2" />
      <value displayText="Primary Care Physician" value="3" />
      <value displayText="Service Location" value="4" />
      <value displayText="Department" value="5" />
      <value displayText="Insurance Company" value="6" />
      <value displayText="Insurance Plan" value="7" />
      <value displayText="Payer Scenario" value="8" />
      <value displayText="Contract Type" value="9" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnTotal" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 45

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="ExportType" parameterName="ExportType" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" description="Filter by scheduling provider."  default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" description="Filter by rendering provider."  default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" description="Filter by default rendering provider."  default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" description="Filter by service location." default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" description="Filter by department." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" description="Filter by insurance plan." default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="I" permission="FindInsurancePlan" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" description="Filter by payer scenario." default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PayerTypeID" text="Payment Type:" description="Filter by payer type."     default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Copay" value="1" />
      <value displayText="Patient Payment on Account" value="2" />
      <value displayText="Insurance Payment" value="3" />
      <value displayText="Other" value="4" />
    </extendedParameter>
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" description="Filter by patient." default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" description="Filter by batch #."/>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
    <extendedParameter type="ComboBox" parameterName="ShowUnapplied" text="Show Unapplied?:" description="Show unapplied analysis."    default="TRUE">
      <value displayText="Yes" value="TRUE" />
      <value displayText="No" value="FALSE" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Referring Provider" value="2" />
      <value displayText="Primary Care Physician" value="3" />
      <value displayText="Service Location" value="4" />
      <value displayText="Department" value="5" />
      <value displayText="Contract Type" value="6" />
      <value displayText="Payer Type" value="7" />
      <value displayText="Payment Method" value="8" />
      <value displayText="Batch #" value="9" />
      <value displayText="Payer Scenario" value="10" />
      <value displayText="Insurance Company" value="11" />
      <value displayText="Insurance Plan" value="12" />
      <value displayText="Scheduling Provider" value="13" />
      <value displayText="Default Rendering Provider" value="14" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="7">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Referring Provider" value="2" />
      <value displayText="Primary Care Physician" value="3" />
      <value displayText="Service Location" value="4" />
      <value displayText="Department" value="5" />
      <value displayText="Contract Type" value="6" />
      <value displayText="Payer Type" value="7" />
      <value displayText="Payment Method" value="8" />
      <value displayText="Batch #" value="9" />
      <value displayText="Payer Scenario" value="10" />
      <value displayText="Insurance Company" value="11" />
      <value displayText="Insurance Plan" value="12" />
      <value displayText="Scheduling Provider" value="13" />
      <value displayText="Default Rendering Provider" value="14" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnTotal" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 46

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="Today" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Provider" parameterName="ResourceID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:"  default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Provider" value="1" />
      <value displayText="Service Location" value="2" />
      <value displayText="Department" value="3" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 47

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="Adjustment" parameterName="AdjustmentReasonID" text="Adjustment Code:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Provider" value="1" />
      <value displayText="Adjustment Codes" value="2" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Batch #" value="5" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 49

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PaymentTypeID" text="Payment Type:" description="Limits the report by payer type."     default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Copay" value="1" />
      <value displayText="Patient Payment on Account" value="2" />
      <value displayText="Insurance Payment" value="3" />
      <value displayText="Other" value="4" />
    </extendedParameter>
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="Adjustment" parameterName="AdjustmentReasonID" text="Adjustment Code:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Provider" value="1" />
      <value displayText="Adjustment Codes" value="2" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Batch #" value="5" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="2">
      <value displayText="Provider" value="1" />
      <value displayText="Adjustment Codes" value="2" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Batch #" value="5" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 50

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select the date type."    default="C">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
      <value displayText="Entered Date" value="C" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" description="Filter by batch #"/>
    <extendedParameter type="ComboBox" parameterName="Metric" text="Metric:" description="Limits the report by Metric type."    default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Patients" value="1" />
      <value displayText="Appointments" value="2" />
      <value displayText="Encounters" value="3" />
      <value displayText="Procedures" value="4" />
      <value displayText="Charges" value="5" />
      <value displayText="Adjustments" value="6" />
      <value displayText="Receipts" value="7" />
      <value displayText="Refunds" value="8" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Metric" value="1" />
      <value displayText="User" value="2" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 51

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="String" parameterName="AllPracticeID" default="1" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select the date type."    default="C">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
      <value displayText="Entered Date" value="C" />
    </extendedParameter>
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" description="Filter by batch #"/>
    <extendedParameter type="ComboBox" parameterName="Metric" text="Metric:" description="Limits the report by Metric type."    default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Patients" value="1" />
      <value displayText="Appointments" value="2" />
      <value displayText="Encounters" value="3" />
      <value displayText="Procedures" value="4" />
      <value displayText="Charges" value="5" />
      <value displayText="Adjustments" value="6" />
      <value displayText="Receipts" value="7" />
      <value displayText="Refunds" value="8" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Metric" value="1" />
      <value displayText="User" value="2" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 52

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />
    <extendedParameter type="ComboBox" parameterName="RevenueCategoryID" text="Revenue Category:" description="Limits the report by Revenue Category"     default="-1" ignore="-1">
      <value displayText="ALL" value="-1" />
      <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24"/>
      <value displayText="Anesthesia (00100-01999)" value="1"/>
      <value displayText="Category II Codes (0001F-6999F)" value="46"/>
      <value displayText="Category III Codes (0001T-0999T)" value="47"/>
      <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25"/>
      <value displayText="Dental Procedures (D0120-D9999)" value="26"/>
      <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27"/>
      <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28"/>
      <value displayText="Durable Medical Equipment (E0100-E9999)" value="29"/>
      <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30"/>
      <value displayText="Evaluation and Management (99201-99499)" value="2"/>
      <value displayText="Hearing Services (V5008-V5364)" value="31"/>
      <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32"/>
      <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33"/>
      <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34"/>
      <value displayText="Medical Services (M0064-M0302)" value="35"/>
      <value displayText="Medicine (90281-99199)" value="3"/>
      <value displayText="Medicine (99500-99602)" value="4"/>
      <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36"/>
      <value displayText="Orthotic Procedures (L0100-L4398)" value="37"/>
      <value displayText="Pathology and Laboratory (80048-89399)" value="5"/>
      <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38"/>
      <value displayText="Private Payer Codes (S0009-S9999)" value="39"/>
      <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40"/>
      <value displayText="Prosthetic Procedures (L5000-L9900)" value="41"/>
      <value displayText="Radiology (70010-79999)" value="6"/>
      <value displayText="Rehabilitative Services (H0001-H2037)" value="42"/>
      <value displayText="Surgery - Auditory System (69000-69979)" value="7"/>
      <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8"/>
      <value displayText="Surgery - Digestive System (40490-49999)" value="9"/>
      <value displayText="Surgery - Endocrine System (60000-60699)" value="10"/>
      <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11"/>
      <value displayText="Surgery - Female Genital System (56405-58999)" value="12"/>
      <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13"/>
      <value displayText="Surgery - Integumentary System (10040-19499)" value="14"/>
      <value displayText="Surgery - Intersex (55970-55980)" value="15"/>
      <value displayText="Surgery - Male Genital System (54000-55899)" value="16"/>
      <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17"/>
      <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18"/>
      <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19"/>
      <value displayText="Surgery - Nervous System (61000-64999)" value="20"/>
      <value displayText="Surgery - Operating Microscope (69990-69990)" value="21"/>
      <value displayText="Surgery - Respiratory System (30000-32999)" value="22"/>
      <value displayText="Surgery - Urinary System (50010-53899)" value="23"/>
      <value displayText="Temporary Codes (Q0034-Q9999)" value="43"/>
      <value displayText="Transportation Services (A0080-A0999)" value="44"/>
      <value displayText="Vision Services (V2020-V2799)" value="45"/>
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Code" value="2" />
      <value displayText="Revenue Category" value="6" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Payer Scenario" value="7" />
      <value displayText="Batch #" value="5" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Default Rendering Provider" value="9" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="2">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Code" value="2" />
      <value displayText="Revenue Category" value="6" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Batch #" value="5" />
      <value displayText="Payer Scenario #" value="7" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Default Rendering Provider" value="9" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 53

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />
    <extendedParameter type="ComboBox" parameterName="RevenueCategoryID" text="Revenue Category:" description="Limits the report by Revenue Category"     default="-1" ignore="-1">
      <value displayText="ALL" value="-1" />
      <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24"/>
      <value displayText="Anesthesia (00100-01999)" value="1"/>
      <value displayText="Category II Codes (0001F-6999F)" value="46"/>
      <value displayText="Category III Codes (0001T-0999T)" value="47"/>
      <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25"/>
      <value displayText="Dental Procedures (D0120-D9999)" value="26"/>
      <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27"/>
      <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28"/>
      <value displayText="Durable Medical Equipment (E0100-E9999)" value="29"/>
      <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30"/>
      <value displayText="Evaluation and Management (99201-99499)" value="2"/>
      <value displayText="Hearing Services (V5008-V5364)" value="31"/>
      <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32"/>
      <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33"/>
      <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34"/>
      <value displayText="Medical Services (M0064-M0302)" value="35"/>
      <value displayText="Medicine (90281-99199)" value="3"/>
      <value displayText="Medicine (99500-99602)" value="4"/>
      <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36"/>
      <value displayText="Orthotic Procedures (L0100-L4398)" value="37"/>
      <value displayText="Pathology and Laboratory (80048-89399)" value="5"/>
      <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38"/>
      <value displayText="Private Payer Codes (S0009-S9999)" value="39"/>
      <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40"/>
      <value displayText="Prosthetic Procedures (L5000-L9900)" value="41"/>
      <value displayText="Radiology (70010-79999)" value="6"/>
      <value displayText="Rehabilitative Services (H0001-H2037)" value="42"/>
      <value displayText="Surgery - Auditory System (69000-69979)" value="7"/>
      <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8"/>
      <value displayText="Surgery - Digestive System (40490-49999)" value="9"/>
      <value displayText="Surgery - Endocrine System (60000-60699)" value="10"/>
      <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11"/>
      <value displayText="Surgery - Female Genital System (56405-58999)" value="12"/>
      <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13"/>
      <value displayText="Surgery - Integumentary System (10040-19499)" value="14"/>
      <value displayText="Surgery - Intersex (55970-55980)" value="15"/>
      <value displayText="Surgery - Male Genital System (54000-55899)" value="16"/>
      <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17"/>
      <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18"/>
      <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19"/>
      <value displayText="Surgery - Nervous System (61000-64999)" value="20"/>
      <value displayText="Surgery - Operating Microscope (69990-69990)" value="21"/>
      <value displayText="Surgery - Respiratory System (30000-32999)" value="22"/>
      <value displayText="Surgery - Urinary System (50010-53899)" value="23"/>
      <value displayText="Temporary Codes (Q0034-Q9999)" value="43"/>
      <value displayText="Transportation Services (A0080-A0999)" value="44"/>
      <value displayText="Vision Services (V2020-V2799)" value="45"/>
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Code" value="2" />
      <value displayText="Revenue Category" value="6" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Payer Scenario" value="7" />
      <value displayText="Batch #" value="5" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Default Rendering Provider" value="9" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 54

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="Adjustment" parameterName="AdjustmentCode" text="Adjustment Code:" default="-1" ignore="-1" />
    <extendedParameter type="AdjustmentCode" parameterName="PaymentDenialReasonCode" text="Denial Reason:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Adjustment Code" value="1" />
      <value displayText="Denial Reason Code" value="2" />
      <value displayText="Provider" value="3" />
      <value displayText="Service Location" value="4" />
      <value displayText="Department" value="5" />
      <value displayText="Batch #" value="6" />
      <value displayText="Insurance Companies" value="7" />
      <value displayText="Insurance Plans" value="8" />
      <value displayText="Payer Scenario" value="9" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="2">
      <value displayText="Adjustment Code" value="1" />
      <value displayText="Denial Reason Code" value="2" />
      <value displayText="Provider" value="3" />
      <value displayText="Service Location" value="4" />
      <value displayText="Department" value="5" />
      <value displayText="Batch #" value="6" />
      <value displayText="Insurance Companies" value="7" />
      <value displayText="Insurance Plans" value="8" />
      <value displayText="Payer Scenario" value="9" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 55

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="Adjustment" parameterName="AdjustmentCode" text="Adjustment Code:" default="-1" ignore="-1" />
    <extendedParameter type="AdjustmentCode" parameterName="PaymentDenialReasonCode" text="Denial Reason:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Adjustment Discription" value="1" />
      <value displayText="Denial Reason Code" value="2" />
      <value displayText="Provider" value="3" />
      <value displayText="Service Location" value="4" />
      <value displayText="Department" value="5" />
      <value displayText="Batch #" value="6" />
      <value displayText="Insurance Companies" value="7" />
      <value displayText="Insurance Plans" value="8" />
      <value displayText="Payer Scenario" value="9" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 56

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Payment to display a report.">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Payment" parameterName="PaymentID" text="Payment:"/>
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Balance:" description="Select from either Open balance or All"    default="O">
      <value displayText="Open" value="O" />
      <value displayText="All" value="A" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 57

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Patient to display a report.">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="EndDate" text="As Of:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="0" ignore="0" />
  </extendedParameters>
</parameters>'
WHERE ReportID = 58

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="PreviousMonth" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="ProcedureCodeCategory" parameterName="RevenueCategoryID" text="Procedure Category:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />
    <extendedParameter type="ComboBox" parameterName="Metric" text="Metric:" description="Filter by Mertric."    default="A">
      <value displayText="All" value="A" />
      <value displayText="Expected Allowed" value="EA" />
      <value displayText="Average Allowed" value="AA" />
      <value displayText="Expected Payment" value="EP" />
      <value displayText="Average Payment" value="AP" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="4">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Service Location" value="2" />
      <value displayText="Department" value="3" />
      <value displayText="Insurance Company" value="4" />
      <value displayText="Insurance Plan" value="5" />
      <value displayText="Payer Scenario" value="6" />
      <value displayText="Batch #" value="7" />
      <value displayText="Procedure" value="9" />
      <value displayText="Procedure Category" value="8" />
      <value displayText="Metric" value="10" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="9">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Service Location" value="2" />
      <value displayText="Department" value="3" />
      <value displayText="Insurance Company" value="4" />
      <value displayText="Insurance Plan" value="5" />
      <value displayText="Payer Scenario" value="6" />
      <value displayText="Batch #" value="7" />
      <value displayText="Procedure Category" value="8" />
      <value displayText="Procedure" value="9" />
      <value displayText="Metric" value="10" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="5">
      <value displayText="Metrics" value="5" />
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 59

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="ProcedureCodeCategory" parameterName="RevenueCategoryID" text="Procedure Category:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />
    <extendedParameter type="ComboBox" parameterName="Metric" text="Metric:" description="Filter by Mertric."    default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Expected Allowed" value="1" />
      <value displayText="Average Allowed" value="2" />
      <value displayText="Expected Payment" value="3" />
      <value displayText="Average Payment" value="4" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option."    default="9">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Service Location" value="2" />
      <value displayText="Department" value="3" />
      <value displayText="Insurance Company" value="4" />
      <value displayText="Insurance Plan" value="5" />
      <value displayText="Payer Scenario" value="6" />
      <value displayText="Batch #" value="7" />
      <value displayText="Procedure" value="9" />
      <value displayText="Procedure Category" value="8" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 60

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date to start aging from."    default="B">
      <value displayText="First Billed Date" value="B" />
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="CollectionCategory" parameterName="CollectionCategoryID" text="Collection Category:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="Metric" text="A/R Age:" description="Limits the report by the A/R age range."     default="1">
      <value displayText="Current+" value="1" />
      <value displayText="30+" value="2" />
      <value displayText="60+" value="3" />
      <value displayText="90+" value="4" />
      <value displayText="120+" value="5" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="ComboBox" parameterName="SortBy" text="Sort By:" description="Sorts the report by field."     default="1">
      <value displayText="Total Balance" value="1" />
      <value displayText="Patient Last Name" value="2" />
      <value displayText="Balance Over 90 Days" value="3" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 61

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date to start aging from."    default="B">
      <value displayText="First Billed Date" value="B" />
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="ComboBox" parameterName="SortBy" text="Sort By:" description="Sorts the report by field."     default="1">
      <value displayText="Collection Category" value="1" />
      <value displayText="Total Balance" value="2" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."     default="1">
      <value displayText="All" value="1" />
      <value displayText="Total Only" value="2" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 62