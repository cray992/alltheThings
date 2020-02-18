/*

DATABASE UPDATE SCRIPT

v1.21.1769 to v1.22.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 2877 -  Modify permission model to be two-tiered, with allow/deny on groups or items   


/* NOT necessary now

CREATE TABLE
	PermissionGroup
	(
		PermissionGroupID int IDENTITY NOT NULL PRIMARY KEY,
		Name varchar(50),
		Description varchar(250),
	)
GO


ALTER TABLE
	Permissions
ADD
	PermissionValue varchar(128) NOT NULL DEFAULT '',
	ViewInMedicalOffice bit NOT NULL DEFAULT 1,
	ViewInBusinessManager bit NOT NULL DEFAULT 1,
	ViewInAdministrator bit NOT NULL DEFAULT 1,
	ViewInServiceManager bit NOT NULL DEFAULT 1,
	PermissionGroupID int
		CONSTRAINT FK_Permission_PermissionGroup
			FOREIGN KEY REFERENCES PermissionGroup(PermissionGroupID)
GO

ALTER TABLE
	[Groups]
ADD
	ViewInMedicalOffice bit NOT NULL DEFAULT 1,
	ViewInBusinessManager bit NOT NULL DEFAULT 1,
	ViewInAdministrator bit NOT NULL DEFAULT 1,
	ViewInServiceManager bit NOT NULL DEFAULT 1
GO

ALTER TABLE
	[GroupPermissions]
ADD
	Denied bit NOT NULL DEFAULT 0

ALTER TABLE
	[GroupPermissions]
ALTER COLUMN
	Allowed bit NOT NULL 
GO

ALTER TABLE
	[GroupPermissions]
ADD CONSTRAINT
	DF_GroupPermissions_Allowed
	DEFAULT (0) FOR Allowed
GO

*/

---------------------------------------------------------------------------------------
--case 3004 - Remove the All option for the A/R Aging Detail report

update report
set ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="RespType" text="Type:" description="Limits the report by payer." default="I">
			<value displayText="Patient" value="P" />
			<value displayText="Insurance" value="I" />
		</extendedParameter>
	        <extendedParameter type="Patient" parameterName="RespID" text="Patient:" default="-1" ignore="-1"  enabledBasedOnParameter="RespType" enabledBasedOnValue="P"/>
		<extendedParameter type="Insurance" parameterName="RespID" text="Insurance:" default="-1" ignore="-1"  enabledBasedOnParameter="RespType" enabledBasedOnValue="I"/>
	</extendedParameters>
</parameters>'
where Name = 'A/R Aging Detail'


---------------------------------------------------------------------------------------
--case 2998 -  Remove UPIN and MedicareIndividualProviderNumber from table Doctor

ALTER TABLE Doctor DROP COLUMN UPIN, MedicareIndividualProviderNumber

---------------------------------------------------------------------------------------
--case 3007 - Add column to Report for PermissionValue

ALTER TABLE dbo.Report
ADD PermissionValue varchar(128) NULL
GO

UPDATE 	Report
SET	PermissionValue = 'ReadKeyIndicatorsSummary'
where	Name = 'Key Indicators Summary'

UPDATE 	Report
SET	PermissionValue = 'ReadKeyIndicatorsDetail'
where	Name = 'Key Indicators Detail'

UPDATE 	Report
SET	PermissionValue = 'ReadKeyIndicatorsSummaryComparePrevYear'
where	Name = 'Key Indicators Summary Compare Previous Year'

UPDATE 	Report
SET	PermissionValue = 'ReadKeyIndicatorsSummaryYTDReview'
where	Name = 'Key Indicators Summary YTD Review'

UPDATE 	Report
SET	PermissionValue = 'ReadPaymentsSummary'
where	Name = 'Payments Summary'

UPDATE 	Report
SET	PermissionValue = 'ReadPaymentsDetail'
where	Name = 'Payments Detail'

UPDATE 	Report
SET	PermissionValue = 'ReadPaymentApplication'
where	Name = 'Payments Application'

UPDATE 	Report
SET	PermissionValue = 'ReadARAgingSummary'
where	Name = 'A/R Aging Summary'

UPDATE 	Report
SET	PermissionValue = 'ReadARAgingDetail'
where	Name = 'A/R Aging Detail'

UPDATE 	Report
SET	PermissionValue = 'ReadProviderProductivity'
where	Name = 'Provider Productivity'

UPDATE 	Report
SET	PermissionValue = 'ReadPatientHistory'
where	Name = 'Patient History'

UPDATE 	Report
SET	PermissionValue = 'ReadPatientTransactionsSummary'
where	Name = 'Patient Transactions Summary'

UPDATE 	Report
SET	PermissionValue = 'ReadPatientTransactionsDetail'
where	Name = 'Patient Transactions Detail'

UPDATE 	Report
SET	PermissionValue = 'ReadPatientReferralsSummary'
where	Name = 'Patient Referrals Summary'

UPDATE 	Report
SET	PermissionValue = 'ReadPatientReferralsDetail'
where	Name = 'Patient Referrals Detail'

UPDATE 	Report
SET	PermissionValue = 'ReadRefundSummary'
where	Name = 'Refunds Summary'

UPDATE 	Report
SET	PermissionValue = 'ReadRefundDetail'
where	Name = 'Refunds Detail'

UPDATE 	Report
SET	PermissionValue = 'PrintAppointments'
where	Name = 'Appointments Summary'

UPDATE 	Report
SET	PermissionValue = 'ReadPatient'
where	Name = 'Patient Detail'
GO

ALTER TABLE dbo.Report
ALTER COLUMN PermissionValue varchar(128) NOT NULL
GO

---------------------------------------------------------------------------------------
--case 3007 - Add permission to selectors

update 	report
set 	ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please select a Payment to display a report." refreshOnParameterChange="true">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="Payment" parameterName="PaymentID" text="Payment:" default="-1" ignore="-1" permission="FindPayment" />
		<basicParameter type="SelectorResult" parameterName="rpmPayerName" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="PayerName" />
		<basicParameter type="SelectorResult" parameterName="rpmPaymentNumber" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="PaymentNumber" />
		<basicParameter type="SelectorResult" parameterName="rpmPaymentAmount" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="PaymentAmount" />
		<basicParameter type="SelectorResult" parameterName="rpmPaymentDate" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="PaymentDate" />
		<basicParameter type="SelectorResult" parameterName="rpmUnappliedAmount" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="UNAPPLIEDAMOUNT" />
		<basicParameter type="SelectorResult" parameterName="rpmRefundAmount" selector="Kareo.Superbill.Windows.Tasks.Practice.Claims.PaymentSelectorTask" field="RefundsTotal" />
	</basicParameters>
</parameters>'
where 	name = 'Payments Application'


update 	report
set 	ReportParameters = 
'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="RespType" text="Type:" description="Limits the report by payer." default="I">
			<value displayText="Patient" value="P" />
			<value displayText="Insurance" value="I" />
		</extendedParameter>
		<extendedParameter type="Patient" parameterName="RespID" text="Patient:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="P" permission="FindPatient" />
		<extendedParameter type="Insurance" parameterName="RespID" text="Insurance:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="I" permission="FindInsurancePlan" />
	</extendedParameters>
</parameters>'
where	Name = 'A/R Aging Detail'


update 	report
set 	ReportParameters = 
'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Patient for this report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	</extendedParameters>
</parameters>'
where	Name = 'Patient History'


update 	report
set 	ReportParameters = 
'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Click refresh for all Patients (this may take some time) otherwise click on Customize and select a Patient.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	</extendedParameters>
</parameters>'
where	Name = 'Patient Transactions Detail'


update 	report
set 	ReportParameters = 
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
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
		<extendedParameter type="ReferringPhysician" parameterName="ReferringProviderID" text="Referring Physician..." default="-1" ignore="-1" permission="FindReferringPhysician" />
	</extendedParameters>
</parameters>'
where	Name = 'Patient Referrals Detail'


update 	report
set 	ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Patient for this report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
	        <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	</extendedParameters>
</parameters>'
where	Name = 'Patient Detail'

---------------------------------------------------------------------------------------
-- case 2848

ALTER TABLE
	Bill_Statement
ADD
	Active bit NOT NULL
		CONSTRAINT
			DF_Bill_Statements_Active
			DEFAULT (1)
	WITH VALUES
GO

---------------------------------------------------------------------------------------
--case 3103 - Modify ProcedureModifier foreign keys to match the new varchar(16) size

ALTER TABLE
	EncounterProcedure
ALTER COLUMN
	ProcedureModifier1 varchar(16)
GO

ALTER TABLE
	EncounterProcedure
ALTER COLUMN
	ProcedureModifier2 varchar(16)
GO

ALTER TABLE
	EncounterProcedure
ALTER COLUMN
	ProcedureModifier3 varchar(16)
GO

ALTER TABLE
	EncounterProcedure
ALTER COLUMN
	ProcedureModifier4 varchar(16)
GO

ALTER TABLE
	Claim
ALTER COLUMN
	ProcedureModifier1 varchar(16)
GO

ALTER TABLE
	Claim
ALTER COLUMN
	ProcedureModifier2 varchar(16)
GO

ALTER TABLE
	Claim
ALTER COLUMN
	ProcedureModifier3 varchar(16)
GO

ALTER TABLE
	Claim
ALTER COLUMN
	ProcedureModifier4 varchar(16)
GO

---------------------------------------------------------------------------------------
--case 3003 - Description

ALTER TABLE
	Practice
ADD
	Active bit NOT NULL
		CONSTRAINT
			DF_Practice_Active
			DEFAULT (1)
	WITH VALUES
GO

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
