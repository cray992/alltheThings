
DECLARE @Par XML
SET @Par = 
'<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="SupervisingProviderID" text="Supervising Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />
  </extendedParameters>
</parameters>
'


DECLARE @ProviderNumbersRptID INT 

IF  exists( select * from report where Name = 'Settled Charges Summary' )
BEGIN

	update Report
	SET  ReportParameters = @Par, ModifiedDate = getdate(), ReportCategoryID=10, DisplayOrder=22
	WHERE Name='Settled Charges Summary'

END
ELSE BEGIN

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
		10, 
		22, 
		'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
		'Settled Charges Summary', 
		'This report shows a summary of transactions on charges settled over a period of time.',
		'Report V2 Viewer',
		'/BusinessManagerReports/rptSettledChargesSummary',
		@Par,
		'Se&ttled Charges Summary',
		'ReadChargesSummaryReport',
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
END
GO
