


----------------------------------------
-- Case 10582:   Add new customization options for Key Indicators reports 
---------------------------------------
UPDATE REPORT
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
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Group report by:"     default="P">
			<value displayText="Provider" value="P" />
			<value displayText="Service Location" value="S" />
			<value displayText="Department" value="D" />
		</extendedParameter>
	</extendedParameters>
</parameters>'
WHERE Name = 'Key Indicators Summary'




UPDATE Report 
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
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Group report by:"     default="P">
			<value displayText="Provider" value="P" />
			<value displayText="Service Location" value="S" />
			<value displayText="Department" value="D" />
		</extendedParameter>
	</extendedParameters>
</parameters>'
where Name = 'Key Indicators Summary Compare Previous Year'

UPDATE Report
SET ReportParameters = 
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
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Group report by:"     default="P">
			<value displayText="Provider" value="P" />
			<value displayText="Service Location" value="S" />
			<value displayText="Department" value="D" />
		</extendedParameter>
	</extendedParameters>
</parameters>'
where Name = 'Key Indicators Summary YTD Review'


Update r
SET reportParameters = 
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
			<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Group report by:"     default="P">
				<value displayText="Provider" value="P" />
				<value displayText="Service Location" value="S" />
				<value displayText="Department" value="D" />
			</extendedParameter>
		</extendedParameters>
	</parameters>'
from Report r
where name = 'Key Indicators Detail'

GO
