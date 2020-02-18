


DECLARE @Par XML
SET @Par = 
'<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
	<basicParameter type="CustomDateRange" fromDateParameter="encounterDateOfPosting" toDateParameter="encounterEndDateOfPosting" text="Dates:" default="MonthToDate" forceDefault="true" />
	<basicParameter type="Date" parameterName="encounterDateOfPosting" text="From Post Date:" />
	<basicParameter type="Date" parameterName="encounterEndDateOfPosting" text="To Post Date:" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="useUnionAllLogic" text="Filter Logic" description="Switch from standard filter logic, to union logic" default="FALSE">
		<value displayText="Result must match all parameter(s)" value="FALSE" />		
		<value displayText="Result can match any parameter(s)" value="TRUE" />
    </extendedParameter>
    <extendedParameter type="Separator" text="" />
    <extendedParameter type="Date" parameterName="startDate" text="Begin Auth Date:" default="None"  />
	<extendedParameter type="Date" parameterName="EndDate" text="End Auth Date:" default="None" />
    <extendedParameter type="ComboBox" parameterName="numberOfSessionRemaining" text="Show number of visit(s) remaining" description="Select to filter the number of insurance authorizations remaining" default="-1">
		<value displayText="All" value="-1" />
		<value displayText="0" value="0" />
		<value displayText="1" value="1" />
		<value displayText="2" value="2" />
		<value displayText="3" value="3" />
		<value displayText="4" value="4" />
		<value displayText="5" value="5" />
		<value displayText="6" value="6" />
		<value displayText="7" value="7" />
		<value displayText="8" value="8" />
		<value displayText="9" value="9" />
		<value displayText="10" value="10" />
		<value displayText="15" value="15" />
		<value displayText="20" value="20" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="includeAllAuthorization" text="Show selected insurance authorizations " description="Select to include all patient authorizations" default="FALSE">
		<value displayText="Show selected insurance authorizations" value="FALSE" />		
		<value displayText="Show all insurance authorization for selected patient" value="TRUE" />
    </extendedParameter>
  </extendedParameters>
</parameters>'


DECLARE @ProviderNumbersRptID INT 

IF  exists( select * from report where Name = 'Patient Insurance Authorization' )
BEGIN

	update Report
	SET  ReportParameters = @Par, ModifiedDate = getdate()
	WHERE Name='Patient Insurance Authorization'

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
		5, 
		140, 
		'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
		'Patient Insurance Authorization', 
		'This reports on the number of insurance authorization.',
		'Report V2 Viewer',
		'/BusinessManagerReports/rptPatientAuthorization',
		@Par,
		'Patient Insurance Aut&horization',
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

IF NOT  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Encounter]') AND name = N'IX_Encounter_InsuranceAuthorization')
CREATE NONCLUSTERED INDEX [IX_Encounter_InsuranceAuthorization] ON [dbo].[Encounter] 
(
	[InsurancePolicyAuthorizationID] ASC
)
INCLUDE ( [PostingDate]) 
