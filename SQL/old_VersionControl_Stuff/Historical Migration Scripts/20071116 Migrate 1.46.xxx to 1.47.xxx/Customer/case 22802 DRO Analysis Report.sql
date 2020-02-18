

DECLARE @ProviderNumbersRptID INT 

INSERT INTO Report(
	ReportCategoryID, 
	DisplayOrder, 
	Image, 
	Name, 
	Description, 
	TaskName, 
	ReportPath, 
	ReportParameters, 
	MenuName, 
	PermissionValue,
	PracticeSpecific
	)

VALUES(
	1, 
	30, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Day Revenue Outstanding Analysis', 
	'This report provides a detail list of payments that affect days revenue outstanding.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptDaysRevenueOutstandingAnalysis',
	'<parameters paging="true" pageColumnCount="14" extraHeaderLength="1251" pageCharacterCount="650000" headerExtractCharacterCount="100000" csv="false">
	  <basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	  </basicParameters>
	  <extendedParameters>
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Set the date range type for the report." default="P">
		  <value displayText="Post Date" value="P" />
		  <value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
		<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
                <extendedParameter type="TextBox" parameterName="DiagnosisCodeStr" text="Diagnose(s):" description="Filter by diagnosis code or range." />
                <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
		<extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
		  <value displayText="Rendering Provider" value="1" />
		  <value displayText="Scheduling Provider" value="2" />
		  <value displayText="Service Location" value="3" />
		  <value displayText="Department" value="4" />
		  <value displayText="Payer Scenario" value="7" />
		  <value displayText="Batch #" value="8" />
		</extendedParameter>
	  </extendedParameters>
	</parameters>',
	'Days &Revenue Outstanding Analysis',
	'ReadDaysRevenueOutstandingAnalysisReport',
	1)

 

SET @ProviderNumbersRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@ProviderNumbersRptID,
	'K',
	GETDATE()
	)

GO




/*

update report
set ReportParameters = '<parameters csv="false">
	  <basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	  </basicParameters>
	  <extendedParameters>
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Set the date range type for the report." default="P">
		  <value displayText="Post Date" value="P" />
		  <value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
		<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
                <extendedParameter type="TextBox" parameterName="DiagnosisCodeStr" text="Diagnose(s):" description="Filter by diagnosis code or range." />
                <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
		<extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
		  <value displayText="Rendering Provider" value="1" />
		  <value displayText="Scheduling Provider" value="2" />
		  <value displayText="Service Location" value="3" />
		  <value displayText="Department" value="4" />
		  <value displayText="Payer Scenario" value="7" />
		  <value displayText="Batch #" value="8" />
		</extendedParameter>
	  </extendedParameters>
	</parameters>',
        modifiedDate = getdate()
WHERE Name = 'Day Revenue Outstanding Analysis'
        

*/

