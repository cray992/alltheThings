/*-----------------------------------------------------------------------------
 Case 21749:   Customer account center: customer account summary report 
-----------------------------------------------------------------------------*/

DECLARE @ReportID INT

INSERT INTO Report(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportPath, ReportParameters,
				   MenuName, PermissionValue, PracticeSpecific)
VALUES(8,10,'[[image[Practice.ReportsV2.Images.reports.gif]]]','Customer Account Summary','This report shows a summary of a Kareo customer’s account.',
	   'Report V2 Viewer','/BusinessManagerReports/rptCustomerAccountSummary',
'<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
	<basicParameter type="CompanyName" parameterName="rpmCompanyName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="PreviousMonth" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Practice" parameterName="PracticeID" text="Practice:" default="-1" ignore="-1" />
	<extendedParameter type="ProviderAllPractices" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" filterBasedOnParameter="PracticeID" filterDataValueName="PracticeID"/>
  </extendedParameters>
</parameters>','Customer &Account Summary','ReadCustomerAccountSummary',0)

SET @ReportID=@@IDENTITY

INSERT INTO ReportToSoftwareApplication(ReportID, SoftwareApplicationID, ModifiedDate)
VALUES(@ReportID, 'K', GETDATE())


