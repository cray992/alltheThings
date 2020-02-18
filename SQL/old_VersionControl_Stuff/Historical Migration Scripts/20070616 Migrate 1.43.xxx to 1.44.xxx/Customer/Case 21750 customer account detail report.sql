/*-----------------------------------------------------------------------------
 Case 21750 customer account detail report 
-----------------------------------------------------------------------------*/

DECLARE @ReportID INT

INSERT INTO Report(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportPath, ReportParameters,
				   MenuName, PermissionValue, PracticeSpecific)
VALUES(8,20,'[[image[Practice.ReportsV2.Images.reports.gif]]]','Customer Account Detail','This report shows a detailed analysis of a Kareo customer’s account.',
	   'Report V2 Viewer','/BusinessManagerReports/rptCustomerAccountDetail',
'<parameters defaultMessage="Click refresh for all Practices (this may take some time) otherwise click on Customize to narrow report scope." paging="true" pageColumnCount="12" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="CompanyName" parameterName="rpmCompanyName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="PreviousMonth" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Practice" parameterName="PracticeID" text="Practice:" default="-1" ignore="-1" />
	<extendedParameter type="ProviderAllPractices" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" filterBasedOnParameter="PracticeID" filterDataValueName="PracticeID"/>
    <extendedParameter type="ComboBox" parameterName="Category" text="Category:" description="Filter by transaction category." default="A">
      <value displayText="All" value="A" />
      <value displayText="Clearinghouse" value="CH" />
      <value displayText="Patient Statements" value="PS" />
	  <value displayText="Document Management" value="DM" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="TransactionType" text="Transaction:" description="Filter by transaction." default="A">
      <value displayText="All" value="A" />
      <value displayText="E-Claims" value="EC" />
      <value displayText="ERA" value="ER" />
	  <value displayText="Eligibility" value="E" />
	  <value displayText="Patient Statements – 1st Page" value="PS1" />
	  <value displayText="Patient Statement – Other Pages" value="PSO" />
	  <value displayText="Document Management" value="DM" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group By:" description="Filter by transaction." default="P">
      <value displayText="Practice" value="P" />
      <value displayText="Category" value="C" />
      <value displayText="Transaction" value="T" />
	  <value displayText="Transaction Date" value="D" />
	  <value displayText="Service Date" value="S" />
	  <value displayText="Rendering Provider" value="R" />
	  <value displayText="Patient" value="I" />
    </extendedParameter>
  </extendedParameters>
</parameters>','Customer Account &Detail','ReadCustomerAccountDetailReport',0)

SET @ReportID=@@IDENTITY

INSERT INTO ReportToSoftwareApplication(ReportID, SoftwareApplicationID, ModifiedDate)
VALUES(@ReportID, 'K', GETDATE())