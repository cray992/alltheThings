
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
	2, 
	35, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Unapplied Analysis', 
	'This report shows an analysis of the unapplied balance on payments.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptUnappliedAnalysis',
	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters paging="true" pageColumnCount="14" extraHeaderLength="1099" pageCharacterCount="650000" headerExtractCharacterCount="100000">
		  <basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="ClientTime" parameterName="ClientTime" />
			<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
			<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
			<basicParameter type="Date" parameterName="BeginDate" text="From:"/>
			<basicParameter type="Date" parameterName="EndDate" text="To:"/>
		  </basicParameters>
		  <extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="ComboBox" parameterName="PayerTypeCode" text="Payer Type:" description="Filter by payer type." default="A" ignore="A" >
			  <value displayText="All" value="A" />
			  <value displayText="Insurance" value="I" />
			  <value displayText="Patient" value="P" />
			</extendedParameter>
			<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
		    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="PaymentCategory" parameterName="PaymentCategoryID" text="Category:" default="-1" ignore="-1" />
			<extendedParameter type="Payment" parameterName="PaymentID" text="Payment:" default="-1" ignore="-1" permission="FindPayment" />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="ComboBox" parameterName="Style" text="Style:" description="Specify whether you want to show all payments, or only those payments that have a non-zero net impact on the unapplied balance over the period of the report." default="1" >
			  <value displayText="All" value="0" />
			  <value displayText="Changes Unapplied" value="1" />
			</extendedParameter>
		  </extendedParameters>
		</parameters>',
	'Unapp&lied Analysis',
	'ReadUnappliedAnalysisReport',
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

update Report
set ReportParameters = 	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters paging="true" htmlScrollbar="false" pageColumnCount="14" extraHeaderLength="1150" pageCharacterCount="650000" headerExtractCharacterCount="100000">
		  <basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="ClientTime" parameterName="ClientTime" />
			<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
			<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
			<basicParameter type="Date" parameterName="BeginDate" text="From:"/>
			<basicParameter type="Date" parameterName="EndDate" text="To:"/>
		  </basicParameters>
		  <extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="ComboBox" parameterName="PayerTypeCode" text="Payer Type:" description="Filter by payer type." default="A" ignore="A" >
			  <value displayText="All" value="A" />
			  <value displayText="Insurance" value="I" />
			  <value displayText="Patient" value="P" />
			</extendedParameter>
			<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
		    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="PaymentCategory" parameterName="PaymentCategoryID" text="Category:" default="-1" ignore="-1" />
			<extendedParameter type="Payment" parameterName="PaymentID" text="Payment:" default="-1" ignore="-1" permission="FindPayment" />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="ComboBox" parameterName="Style" text="Style:" description="Specify whether you want to show all payments, or only those payments that have a non-zero net impact on the unapplied balance over the period of the report." default="1" >
			  <value displayText="All" value="0" />
			  <value displayText="Changes Unapplied" value="1" />
			</extendedParameter>
		  </extendedParameters>
		</parameters>',
modifiedDate = getdate()
WHERE name = 'Unapplied Analysis'

*/