declare @category int
declare @server varchar(128)
set @server = 'k0'

BEGIN TRAN 

-- 'Key Indicators' --------------------------------------------------------------------
set @category = 1
delete from report where ReportCategoryID = @category

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 9, '[[image[Practice.Reports.Images.reports.gif]]]', 'Key Indicators Summary', 'This report provides a summary list of the most important indicators associated with the financial performance of the practice over a period of time.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptKeyIndicatorsSummary', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 0, '[[image[Practice.Reports.Images.reports.gif]]]', 'Key Indicators Detail', 'This report provides a detailed list of the most important indicators associated with the financial performance of the practice over a period of time.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptKeyIndicatorsDetail', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 11, '[[image[Practice.Reports.Images.reports.gif]]]', 'Key Indicators Summary Compare Previous Year', 'This report provides a summary list of the most important indicators compared with the previous year.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptKeyIndicatorsSummaryComparePreviousYear', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 12, '[[image[Practice.Reports.Images.reports.gif]]]', 'Key Indicators Summary YTD Review', 'This report provides a summary list for this year.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptKeyIndicatorsSummaryYTDReview', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )


---------------------------------------------------------------------------------------


-- 'Payments' --------------------------------------------------------------------
set @category = 2
delete from report where ReportCategoryID = @category

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 1, '[[image[Practice.Reports.Images.reports.gif]]]', 'Payments Summary', 'This report provides a summary of all payment, summed by payment type, received over a period of time.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptPaymentsSummary', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
</parameters>' )

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 2, '[[image[Practice.Reports.Images.reports.gif]]]', 'Payments Detail', 'This report provides a detailed list of payments, grouped by payment type, received over a period of time.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptPaymentsDetail', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Type:" default="0" ignore="0"/>
	</extendedParameters>
</parameters>' )

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 14, '[[image[Practice.Reports.Images.reports.gif]]]', 'Payments Application', 'This report shows detail information about how an individual payment from an insurance company, patient or other payer has been applied to charges.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptPaymentApplicationReport', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please select a Payment to display a report." refreshOnParameterChange="true">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="Payment" parameterName="PaymentID" text="Payment:" default="-1" ignore="-1" />
		<basicParameter type="SelectorResult" parameterName="rpmPayerName" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="PayerName" />
		<basicParameter type="SelectorResult" parameterName="rpmPaymentNumber" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="PaymentNumber" />
		<basicParameter type="SelectorResult" parameterName="rpmPaymentAmount" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="PaymentAmount" />
		<basicParameter type="SelectorResult" parameterName="rpmPaymentDate" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="PaymentDate" />
		<basicParameter type="SelectorResult" parameterName="rpmUnappliedAmount" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="UNAPPLIEDAMOUNT" />
		<basicParameter type="SelectorResult" parameterName="rpmRefundAmount" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="RefundsTotal" />
	</basicParameters>
</parameters>' )

---------------------------------------------------------------------------------------


-- 'Accounts Receivable' --------------------------------------------------------------------
set @category = 3
delete from report where ReportCategoryID = @category

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 13, '[[image[Practice.Reports.Images.reports.gif]]]', 'A/R Aging Summary', 'This report provides an accounts receivable aging schedule for every patient, insurance or other responsible party with an outstanding balance.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptARAgingSummary', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="PayerType" parameterName="PayerTypeCode" text="Payer:" default="A"/>
	</extendedParameters>
</parameters>' )

---------------------------------------------------------------------------------------


-- 'Productivity & Analysis' --------------------------------------------------------------------
set @category = 4
delete from report where ReportCategoryID = @category

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 5, '[[image[Practice.Reports.Images.reports.gif]]]', 'Provider Productivity', 'This report provides summary totals for all procedures rendered by a provider, grouped by provider, and sub-grouped by location, over a period of time.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptProviderProductivity', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1"/>
	        <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )


---------------------------------------------------------------------------------------


-- 'Patients' --------------------------------------------------------------------
set @category = 5
delete from report where ReportCategoryID = @category

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 6, '[[image[Practice.Reports.Images.reports.gif]]]', 'Patient History', 'This report shows a complete history of activities including all financial transactions corresponding with the patient account.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptPatientHistory', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Patient for this report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 7, '[[image[Practice.Reports.Images.reports.gif]]]', 'Patient Transactions Summary', 'This report shows a list of patients with summary transaction information for a period of time.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptPatientTransactionsSummary', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
</parameters>' )


insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 8, '[[image[Practice.Reports.Images.reports.gif]]]', 'Patient Transactions Detail', 'This report shows a list of patients with detailed transaction information for a period of time.', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptPatientTransactionsDetail', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Click refresh for all Patients (this may take some time) otherwise click on Customize and select a Patient.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 9, '[[image[Practice.Reports.Images.reports.gif]]]', 'Patient Referrals Detail', 'Test Patient Referrals Detail', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptPatientReferralsDetail', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1"/>
	        <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="ReferringPhysician" parameterName="ReferringProviderID" text="Referring Physician..." default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(@category, 10, '[[image[Practice.Reports.Images.reports.gif]]]', 'Patient Referrals Summary', 'Test Patient Referrals Summary', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptPatientReferralsSummary', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1"/>
	        <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )

---------------------------------------------------------------------------------------

/*

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(4, 11, '[[image[Practice.Reports.Images.reports.gif]]]', 'Procedure Analysis Summary', 'Stored procedure currently hardcodes date range and practice to Rehabilitation Consultants', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptProcedureAnalysisSummary', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="Insurance" parameterName="InsuranceID" text="Insurance:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(4, 11, '[[image[Practice.Reports.Images.reports.gif]]]', 'Procedure Analysis Detail', 'Stored procedure currently hardcodes date range and practice to Rehabilitation Consultants', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptProcedureAnalysisDetail', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="Insurance" parameterName="InsuranceID" text="Insurance:" default="-1" ignore="-1"/>
		<extendedParameter type="ProcedureCode" parameterName="ProcedureCodeID" text="Insurance:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )

select * from report where reportcategoryid = 3
delete report where reportid = 397
*/

/*
select * from reportcategory

insert into reportcategory
(DisplayOrder, Image, Name, Description, TaskName)
values
(2, '[[image[Practice.Reports.Images.reports.gif]]]', 'Almost ready for testing', 'These reports are almost ready for testing', 'Report List')

--used for testing
insert into report
(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportServer, ReportPath, ReportParameters)
values
(3, 3, '[[image[Practice.Reports.Images.reports.gif]]]', 'Patient Referrals Detail', 'Test Patient Referrals Detail', 'Report V2 Viewer', 
@server, '/BusinessManagerReports/rptPatientReferralsDetail', 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" align="right"/>
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1"/>
	        <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="ReferringPhysician" parameterName="ReferringProviderID" text="Referring Physician..." default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>' )
*/

COMMIT

select * from report