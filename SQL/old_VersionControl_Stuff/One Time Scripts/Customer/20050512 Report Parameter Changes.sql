update report
set ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
			<value displayText="Posting Date" value="P" />
			<value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Status:" description="Select Encounter Status"    default="-1">
			<value displayText="All" value="-1" />
			<value displayText="Approved" value="3" />
			<value displayText="Drafts" value="1" />
			<value displayText="Submitted" value="2" />
			<value displayText="Rejected" value="4" />
			<value displayText="Unpayable" value="7" />
		</extendedParameter>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="ProviderNumberID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select to group by Status, Provider, Service location, or Department"    default="Status">
			<value displayText="Status" value="Status" />
			<value displayText="Provider" value="Provider" />
			<value displayText="Service Location" value="Service Location" />
			<value displayText="Department" value="Department" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="Group2by" text="Subgroup by:" description="Select to sub group by Status, Provider, Service location, or Department"    default="Provider">
			<value displayText="Provider" value="Provider" />
			<value displayText="Status" value="Status" />
			<value displayText="Service Location" value="Service Location" />
			<value displayText="Department" value="Department" />
		</extendedParameter>
		<extendedParameter type="TextBox" parameterName="BatchNumberID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
where name= 'Encounters Summary'


Update report 
set reportParameters = 
	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters>
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
				<extendedParameter type="Separator" text="Filter" />
				<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
					<value displayText="Posting Date" value="P" />
					<value displayText="Service Date" value="S" />
				</extendedParameter>
				<extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Status:" description="Select Encounter Status"    default="-1">
					<value displayText="All" value="-1" />
					<value displayText="Approved" value="3" />
					<value displayText="Drafts" value="1" />
					<value displayText="Submitted" value="2" />
					<value displayText="Rejected" value="4" />
					<value displayText="Unpayable" value="7" />
				</extendedParameter>
				<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
				<extendedParameter type="Provider" parameterName="ProviderNumberID" text="Provider:" default="-1" ignore="-1"/>
				<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
				<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
				<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group report by:" description="Select to group by Status, Provider, Service location, or Department"    default="Status">
					<value displayText="Status" value="Status" />
					<value displayText="Provider" value="Provider" />
					<value displayText="Service Location" value="Service Location" />
					<value displayText="Department" value="Department" />
				</extendedParameter>
				<extendedParameter type="TextBox" parameterName="BatchNumberID" text="Batch #:"/>
			</extendedParameters>
		</parameters>'
where name='Encounters Detail'

-- Case 9440 Support BatchID
UPDATE REPORT
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
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
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type."     default="D">
			<value displayText="Posting Date" value="P" />
			<value displayText="Date of Service" value="D" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Encounter Status:" description="Limits the report by Encounter Status." default="3">
			<value displayText="All" value="-1" />
			<value displayText="Approved" value="3" />
			<value displayText="Draft" value="1" />
			<value displayText="Submitted" value="2" />
			<value displayText="Rejected" value="4" />
		</extendedParameter>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE Name = 'Missed Copays'
