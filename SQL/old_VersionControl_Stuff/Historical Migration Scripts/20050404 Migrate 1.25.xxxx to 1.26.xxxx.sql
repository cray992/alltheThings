/*

DATABASE UPDATE SCRIPT

v1.24.1914 to v1.25.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 3643:  Add records for the Company Indicators Summary report

declare @ReportCategoryId int
declare @ReportId int

INSERT INTO ReportCategory (
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	MenuName)
VALUES (
	1,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'Company Indicators',
	'Company Indicators',
	'Report List',
	'&Company Indicators')

set @ReportCategoryId = @@identity

INSERT INTO Report (
	ReportCategoryID,
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	ReportPath,
	ReportParameters,
	MenuName,
	PermissionValue)
VALUES (
	@ReportCategoryId,
	1,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'Company Indicators Summary',
	'This report provides a summary list of the most important indicators associated with the financial performance of the practices over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptCompanyIndicatorsSummary',
	'<?xml version="1.0" encoding="utf-8"?>
	<parameters>
		<basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="CompanyName" parameterName="rpmCompanyName" />
			<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
			<basicParameter type="Date" parameterName="BeginDate" text="From:" />
			<basicParameter type="Date" parameterName="EndDate" text="To:" />
		</basicParameters>
	</parameters>',
	'&Company Indicators Summary',
	'ReadCompanyIndicatorsSummary')

set @ReportId = @@identity

INSERT INTO ReportCategoryToSoftwareApplication
VALUES (
	@ReportCategoryID,
	'A')

INSERT INTO ReportToSoftwareApplication
VALUES (
	@ReportID,
	'A')

---------------------------------------------------------------------------------------
--case 3675:  Add records for the Procedure Payments Summary report

select @ReportCategoryId = ReportCategoryId
from	ReportCategory
where	Name = 'Productivity & Analysis'

INSERT INTO Report (
	ReportCategoryID,
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	ReportPath,
	ReportParameters,
	MenuName,
	PermissionValue)
VALUES (
	@ReportCategoryId,
	10,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'Procedure Payments Summary',
	'This report provides an analysis of the average insurance payments and patient payments by procedure code.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptProcedurePaymentsSummary',
	'<?xml version="1.0" encoding="utf-8"?>
	<parameters>
		<basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
			<basicParameter type="Date" parameterName="BeginDate" text="From:" />
			<basicParameter type="Date" parameterName="EndDate" text="To:" />
		</basicParameters>
		<extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ProcedureCode" parameterName="ProcedureCode" text="Procedure Code:" default="-1" ignore="-1" permission="FindProcedure" />
		</extendedParameters>
	</parameters>',
	'Procedure Payments &Summary',
	'ReadProcedurePaymentsSummary')

set @ReportId = @@identity

INSERT INTO ReportToSoftwareApplication
VALUES (
	@ReportID,
	'B')

INSERT INTO ReportToSoftwareApplication
VALUES (
	@ReportID,
	'M')

---------------------------------------------------------------------------------------
--case 3644:  Remove the Appointments report from Business Manager

DECLARE @AppointmentReportCategoryID INT
DECLARE @AppointmentReportID INT

SELECT	@AppointmentReportCategoryID = ReportCategoryID
FROM	ReportCategory
WHERE	Name = 'Appointments'

SELECT	@AppointmentReportID = ReportID
FROM	Report
WHERE	Name = 'Appointments Summary'

DELETE	ReportCategoryToSoftwareApplication
WHERE	ReportCategoryID = @AppointmentReportCategoryID
AND	SoftwareApplicationID = 'B'

DELETE	ReportToSoftwareApplication
WHERE	ReportID = @AppointmentReportID
AND	SoftwareApplicationID = 'B'

---------------------------------------------------------------------------------------
--case 3295 - Print a facility number on HCFAs in box 32
-- deployed to production as hot fix Apr 8, 05

--ALTER TABLE
--	ServiceLocation
--ADD
--	HCFABox32FacilityID VARCHAR(50) NULL
--GO

---------------------------------------------------------------------------------------
--case 3246 - New claim form needed for Michigan Medicaid 

INSERT INTO BillingForm (BillingFormID, FormType, FormName, Transform) VALUES (3, 'HCFA', 'Medicaid of Michigan', '')
UPDATE InsuranceCompanyPlan SET BillingFormID = 3 WHERE (PlanName LIKE '%medicaid%') AND (PlanName LIKE '%michigan%')     -- plan 18409

/*
execute the following command from command prompt with appropriate server name and password:

textcopy /S k0.dc.kareo.com /U dev /P /D superbill_0001_dev /T BillingForm /C Transform /W "WHERE BillingFormID = 3" /F C:\kcvs\Superbill\Software\Library\BrokerServer.Implementation\Bill_RAW-HCFA-MedicaidMichigan.xsl /I
*/

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
