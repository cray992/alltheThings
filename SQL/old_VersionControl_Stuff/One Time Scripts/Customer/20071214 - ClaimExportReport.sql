IF  NOT exists( select * from report where Name = 'Charges Export' )
BEGIN
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
		10, 
		30, 
		'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
		'Charges Export', 
		'This exports the Charges Summary.',
		'Report V2 Viewer',
		'/BusinessManagerReports/rptClaimExport',
		'<parameters defaultMessage="Please click Customize to filter this export" print="false" pdf="false" csv="true">
		  <basicParameters>
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="ExportType" parameterName="ExportType" />
			<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" forceDefault="true" />
			<basicParameter type="Date" parameterName="BeginDate" text="From DOS:" />
			<basicParameter type="Date" parameterName="EndDate" text="To DOS:" />
		  </basicParameters>
		  <extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="Provider" parameterName="RenderingProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
			<extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="DiagnosisCodeStr" text="Diagnoses:" description="Limits the report by diagnosis code" />
			<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
		  </extendedParameters>
		</parameters>',
		'Charges E&xport',
		'ReadPatientDemographicExport',
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


RETURN

/*
update report 
SET 
	reportparameters = '<parameters defaultMessage="Please click Customize to filter this export" print="false" pdf="false" csv="true">
		  <basicParameters>
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="ExportType" parameterName="ExportType" />
			<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" forceDefault="true" />
			<basicParameter type="Date" parameterName="BeginDate" text="From DOS:" />
			<basicParameter type="Date" parameterName="EndDate" text="To DOS:" />
		  </basicParameters>
		  <extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="Provider" parameterName="RenderingProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
			<extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="DiagnosisCodeStr" text="Diagnoses:" description="Limits the report by diagnosis code" />
			<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
		  </extendedParameters>
		</parameters>',
	modifiedDate = getdate()
where Name = 'Charges Export'



*/