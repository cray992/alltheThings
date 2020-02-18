/*-----------------------------------------------------------------------------
Case 12242:   Implement new Missed Encounter report 
-----------------------------------------------------------------------------*/

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
	PermissionValue
	)

VALUES(
	10, 
	20, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Missed Encounters', 
	'This report shows a summary of appointments with no matching encounter, over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptMissedEncounters',
	'<?xml version="1.0" encoding="utf-8" ?>
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
			<extendedParameter type="Separator" text="Filter" />
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
		</parameters>',
	'&Missed Encounters', -- Why are "&" used in the value???
	'PrintAppointments')

 

SET @ProviderNumbersRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@ProviderNumbersRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@ProviderNumbersRptID,
	'M',
	GETDATE()
	)


GO
