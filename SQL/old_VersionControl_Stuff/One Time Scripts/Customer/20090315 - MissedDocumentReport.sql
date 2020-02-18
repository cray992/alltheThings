
-- delete [ReportCategory] where name='Documents'
--update rc
--set displayorder=37, ModifiedDate=getdate()
--from [ReportCategory] rc
--where name = 'Documents'
--order by displayorder


DECLARE @ProviderNumbersRptID INT 
	,@reportCategoryID int

select @ReportCategoryID=ReportCategoryID
from ReportCategory
where name = 'Documents'



IF @ReportCategoryID IS NULL
BEGIN
	INSERT INTO [dbo].[ReportCategory]
		([DisplayOrder]
		,[Image]
		,[Name]
		,[Description]
		,[TaskName]
		,[ModifiedDate]
		,[MenuName]
		,[PracticeSpecific])
	VALUES
		(37
		,'[[image[Practice.ReportsV2.Images.reports.gif]]]'
		,'Documents'
		,'This report shows a list of records that do not have a corresponding document attached to it.'
		,'Report List'
		,getdate()
		,'&Documents'
		,1
		)
	SET @ReportCategoryID = scope_identity()

	insert into dbo.ReportCategoryToSoftwareApplication( reportCategoryID, SoftwareApplicationID, ModifiedDate ) 
	select @ReportCategoryID, 'K', getdate()

END





DECLARE @Par XML
SET @Par = 
'<parameters csv="false">
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
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Set the date range type for the report." default="S">
		<value displayText="Service Date" value="S" />
		<value displayText="Post Date" value="P" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="RecordType" text="Record Type:" description="Filter by type of record." default="All">
		<value displayText="All" value="All" />
		<value displayText="Appointments" value="Apt" />
		<value displayText="Encounters" value="Enc" />
		<value displayText="Patients" value="Pat" />
		<value displayText="Payments" value="Pay" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="DMSRecordType" text="Document Label:" description="Filter by document label" default="-1">
		<value displayText="All" value="-1" />
		<dataSetValue tableName="dbo.DocumentLabelType"/>
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="RenderingProvider" text="Rendering Provider:" default="-1" ignore="-1" />
	<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="AppointmentType" text="Appointment Type:" description="Filter by type of appointment" default="Pat">
		<value displayText="All" value="All" />
		<value displayText="Patient" value="Pat" />
		<value displayText="Other" value="Oth" />
    </extendedParameter>
  </extendedParameters>
</parameters>'



IF  exists( select * from report where Name = 'Missing Documents' )
BEGIN

	update Report
	SET  ReportParameters = @Par, ModifiedDate = getdate()
	WHERE Name='Missing Documents'

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
		@ReportCategoryID, 
		10, 
		'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
		'Missing Documents', 
		'This report shows a list of records that do not have a corresponding document attached to it.',
		'Report V2 Viewer',
		'/BusinessManagerReports/rptMissedDocument',
		@Par,
		'&Missing Documents',
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