

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
	5, 
	130, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Patient Demographic Export', 
	'This exports the patient demographic.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPatientDemographicExport',
	'<parameters defaultMessage="Patient demographic information is ready for export" print="false" pdf="false" csv="true">
	  <basicParameters>
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="ExportType" parameterName="ExportType" />
		<basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
	  </basicParameters>
	  <extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="Balance" text="Balance:" description="Select the balance type" default="O">
			<value displayText="Open Balance" value="O" />      
			<value displayText="All Balance" value="A" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date" default="P">
		  <value displayText="Posting Date" value="P" />
		  <value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Primary Provider:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="RenderingProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
		<extendedParameter type="ServiceLocation" parameterName="DefaultServiceLocationID" text="Default Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
		<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />

    <extendedParameter type="ProcedureCodeCategory" parameterName="ProcedureCodeCategory" text="Procedure Category:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="Gender" text="Gender:" description="Limits the report by patient''s gender." default="A">
      <value displayText="Both" value="A" />
      <value displayText="Female" value="F" />
      <value displayText="Male" value="M" />
    </extendedParameter>
    <extendedParameter type="PatientReferralSource" parameterName="PatientReferralSourceID" text="Patient Referral Source:" description="Limits the report by referral source" default="-1" ignore="-1" />
    <extendedParameter type="ReferringPhysician" parameterName="ReferringProviderID" text="Referring Provider:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="DiagnosisCodeStr" text="Diagnoses:" description="Limits the report by diagnosis code" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />



		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
	  </extendedParameters>
	</parameters>',
	'Patient De&mographic Export',
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

GO


return


update report
set 
ReportParameters = 
'<parameters defaultMessage="Patient demographic information is ready for export" print="false" pdf="false" csv="true">
	  <basicParameters>
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="ExportType" parameterName="ExportType" />
		<basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
	  </basicParameters>
	  <extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="Balance" text="Balance:" description="Select the balance type" default="O">
			<value displayText="Open Balance" value="O" />      
			<value displayText="All Balance" value="A" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date" default="P">
		  <value displayText="Posting Date" value="P" />
		  <value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Primary Provider:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="RenderingProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
		<extendedParameter type="ServiceLocation" parameterName="DefaultServiceLocationID" text="Default Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
		<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />

    <extendedParameter type="ProcedureCodeCategory" parameterName="ProcedureCodeCategory" text="Procedure Category:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="Gender" text="Gender:" description="Limits the report by patient''s gender." default="A">
      <value displayText="Both" value="A" />
      <value displayText="Female" value="F" />
      <value displayText="Male" value="M" />
    </extendedParameter>
    <extendedParameter type="PatientReferralSource" parameterName="PatientReferralSourceID" text="Patient Referral Source:" description="Limits the report by referral source" default="-1" ignore="-1" />
    <extendedParameter type="ReferringPhysician" parameterName="ReferringProviderID" text="Referring Provider:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="DiagnosisCodeStr" text="Diagnoses:" description="Limits the report by diagnosis code" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />



		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
	  </extendedParameters>
	</parameters>',
modifiedDate = getdate()
where Name = 'Patient Demographic Export'

