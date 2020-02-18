-- select * from report

update report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
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
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Total All Receipts By:" description="Select the method for calculating the receipts for all providers."     default="1">
      <value displayText="Payments Received" value="1" />
      <value displayText="Payments Applied" value="3" />
      <value displayText="Payments Received w/ Date Fix" value="2" />
      <value displayText="Payments Received w/ Date Fix (payment applied after creation of charges" value="4" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1"/>
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
WHERE Name = 'Key Indicators Summary'




Update Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
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
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1"/>
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
WHERE Name = 'Key Indicators Summary Compare Previous Year'



update report 
SET reportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
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
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Total All Receipts By:" description="Select the method for calculating the receipts for all providers."     default="1">
      <value displayText="Payments Received" value="1" />
      <value displayText="Payments Applied" value="3" />
      <value displayText="Payments Received w/ Date Fix" value="2" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1"/>
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
WHERE Name =  'Key Indicators Summary YTD Review'




UPDATE Report
SET ReportParameters = 
'<parameters>
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
    <extendedParameter type="Separator" text="Filter" />
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
WHERE Name = 'Key Indicators Detail'