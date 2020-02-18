/*----------------------------------

DATABASE UPDATE SCRIPT

v1.40.xxxx to v1.41.xxxx
----------------------------------*/

----------------------------------------------------------------------------
-- Case 19185 --Insurance Policy Details: Remove excessive space from policy numbers
----------------------------------------------------------------------------
update InsurancePolicy
SET PolicyNumber = ltrim(rtrim( PolicyNumber ))
GO


/*---------------------------------------------------------------------------------
 Case 18031:   script to reorder payment report based on case  
---------------------------------------------------------------------------------*/


Declare @ReportOrder Table( ReportID INT, DisplayOrder INT, Name varchar(128) )
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 5,	10,	'Payments Summary'		)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 6,	20,	'Payments Detail'		)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 46,	30,	'Payments Application Summary'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 50,	40,	'Adjustments Summary'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 49,	50,	'Adjustments Detail'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 55,	60,	'Denials Summary'		)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 56,	70,	'Denials Detail'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 44,	80,	'Payer Mix Summary'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 43,	90,	'Payment by Procedure'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 30,	100,	'Missed Copays'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 7,	110,	'Payments Application'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 57,	120,	'Payment Receipt'	)




update R
SET DisplayOrder = ro.DisplayOrder,
	ModifiedDate = getdate()
FROM @ReportOrder ro
	INNER JOIN Report R on ro.ReportID = r.ReportID

GO


/*---------------------------------------------------------------------------------
 Case 13853:   Restructure EncounterFormType table with encounter form setup flags.
---------------------------------------------------------------------------------*/

ALTER TABLE EncounterFormType ADD
	ShowLastInsurancePaymentDate BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowLastInsurancePaymentDate DEFAULT (0),
	ShowInsuranceBalance BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowInsuranceBalance DEFAULT (0),
	ShowLastPatientPaymentDate BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowLastPatientPaymentDate DEFAULT (0),
	ShowPatientBalance BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowPatientBalance DEFAULT (0)

GO

/*--------------------------------------------------------------------------------
 Case 13853:   Update EncounterFormType table with encounter form setup data.
--------------------------------------------------------------------------------*/

-- One Page
UPDATE EncounterFormType
SET PageOneDetailsID = 12,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 1

-- Two Page
UPDATE EncounterFormType
SET NumberOfPages = 2,
	PageOneDetailsID = 13,
	PageTwoDetailsID = 14,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 2

-- Two Page (First Page Only)
UPDATE EncounterFormType
SET PageOneDetailsID = 13,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 3

-- Two Page Version 2
UPDATE EncounterFormType
SET NumberOfPages = 2,
	PageOneDetailsID = 17,
	PageTwoDetailsID = 18
WHERE EncounterFormTypeID = 4

-- Two Page Version 2 (First Page Only)
UPDATE EncounterFormType
SET PageOneDetailsID = 17
WHERE EncounterFormTypeID = 5

-- Two Page Scanned
UPDATE EncounterFormType
SET NumberOfPages = 2,
	PageOneDetailsID = 19,
	PageTwoDetailsID = 20,
	ShowProcedures = 0,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 6

-- One Page (Large Font)
UPDATE EncounterFormType
SET PageOneDetailsID = 22,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 8

-- One Page Version 2
UPDATE EncounterFormType
SET PageOneDetailsID = 23,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 9

-- One Page Scanned Version 2
UPDATE EncounterFormType
SET PageOneDetailsID = 25,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 10

-- One Page No Grid
UPDATE EncounterFormType
SET PageOneDetailsID = 26,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 11

-- Two Page Four Column Grid
UPDATE EncounterFormType
SET NumberOfPages = 2,
	PageOneDetailsID = 27,
	PageTwoDetailsID = 28,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 12

-- Two Page with Recent Diagnoses
UPDATE EncounterFormType
SET NumberOfPages = 2,
	PageOneDetailsID = 30,
	PageTwoDetailsID = 31,
	ShowMostRecentDiagnoses = 1
WHERE EncounterFormTypeID = 13

-- 1-Page, 3-Column with Recent Diagnoses
UPDATE EncounterFormType
SET PageOneDetailsID = 32,
	ShowMostRecentDiagnoses = 1
WHERE EncounterFormTypeID = 14

-- 1-Page, 4-Column with Recent Diagnoses
UPDATE EncounterFormType
SET PageOneDetailsID = 33,
	ShowMostRecentDiagnoses = 1
WHERE EncounterFormTypeID = 15

-- One Page Uwaydah
UPDATE EncounterFormType
SET PageOneDetailsID = 34,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 16

-- One Page Pacheco
UPDATE EncounterFormType
SET PageOneDetailsID = 35,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 17

-- One Page Choi
UPDATE EncounterFormType
SET PageOneDetailsID = 36,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 18

-- One Page Jacinto
UPDATE EncounterFormType
SET PageOneDetailsID = 37,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 19

-- One Page Four Column
UPDATE EncounterFormType
SET PageOneDetailsID = 38,
	ShowAccountStatus = 1,
	ShowLastVisitDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 20

-- One Page More Diagnoses
UPDATE EncounterFormType
SET PageOneDetailsID = 39,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 21

-- One Page Blank Fourth Columns
UPDATE EncounterFormType
SET PageOneDetailsID = 40,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 22

-- 1-Page, 2-Column Procedures
UPDATE EncounterFormType
SET PageOneDetailsID = 41,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 23

-- One Page Scanned Version 2 with Insurances
UPDATE EncounterFormType
SET PageOneDetailsID = 24,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 24

-- One Page Dr. Marino
UPDATE EncounterFormType
SET PageOneDetailsID = 29,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 25

-- One Page Equal Spacing
UPDATE EncounterFormType
SET PageOneDetailsID = 42,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 26

-- One Page ASF Ortho
UPDATE EncounterFormType
SET PageOneDetailsID = 43,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 27

-- One Page TIOPASM Lab
UPDATE EncounterFormType
SET PageOneDetailsID = 44,
	ShowProcedures = 0,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 28

-- One Page Caduceus OB
UPDATE EncounterFormType
SET PageOneDetailsID = 45,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 29

-- One Page Caduceus Laguna
UPDATE EncounterFormType
SET PageOneDetailsID = 46,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 30

-- One Page Caduceus Peds
UPDATE EncounterFormType
SET PageOneDetailsID = 47,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 31

-- One Page Three Column
UPDATE EncounterFormType
SET PageOneDetailsID = 48
WHERE EncounterFormTypeID = 32

-- One Page Caduceus Family Practice
UPDATE EncounterFormType
SET PageOneDetailsID = 49,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 33

-- One Page Caduceus Ortho
UPDATE EncounterFormType
SET PageOneDetailsID = 50,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 34

-- One Page Caduceus Podiatry
UPDATE EncounterFormType
SET PageOneDetailsID = 51,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 35

-- One Page Caduceus Psychology
UPDATE EncounterFormType
SET PageOneDetailsID = 52,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 36

-- One Page No Grid Lines
UPDATE EncounterFormType
SET PageOneDetailsID = 53,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 37

-- 1-Page, No Grid Lines with More Diagnoses
UPDATE EncounterFormType
SET PageOneDetailsID = 54,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 38

-- One Page Dr. Carden
UPDATE EncounterFormType
SET PageOneDetailsID = 55,
	ShowProcedures = 0,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 39

-- One Page Dr. McNeill and One Page Codes with Circles
UPDATE EncounterFormType
SET PageOneDetailsID = 56,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 40

-- One Page No Grid Lines Version 2
UPDATE EncounterFormType
SET PageOneDetailsID = 57
WHERE EncounterFormTypeID = 41

-- One Page Caduceus GI
UPDATE EncounterFormType
SET PageOneDetailsID = 58,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 42

-- One Page Caduceus Urology
UPDATE EncounterFormType
SET PageOneDetailsID = 59,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 43

-- One Page Caduceus ENT
UPDATE EncounterFormType
SET PageOneDetailsID = 60,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 44

-- One Page Caduceus Cardiology
UPDATE EncounterFormType
SET PageOneDetailsID = 61,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 45

-- One Page Dr. Bastidas and 1-page, 2-Column Diagnoses
UPDATE EncounterFormType
SET PageOneDetailsID = 62,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 46

-- One Page Caduceus Ancillary
UPDATE EncounterFormType
SET PageOneDetailsID = 63,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 47

-- One Page Caduceus YLFP
UPDATE EncounterFormType
SET PageOneDetailsID = 64,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 48

-- One Page Caduceus FP Laguna Combined
UPDATE EncounterFormType
SET PageOneDetailsID = 65,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 49

-- 1-Page, 4-Column Version 2
UPDATE EncounterFormType
SET PageOneDetailsID = 66,
	ShowReferralSource = 1
WHERE EncounterFormTypeID = 50

-- One Page No Diagnoses Section
UPDATE EncounterFormType
SET PageOneDetailsID = 67,
	ShowDiagnoses = 0,
	ShowTertiaryInsurance = 1
WHERE EncounterFormTypeID = 51

-- 1-Page, 4-Column with 3 Insurances
UPDATE EncounterFormType
SET PageOneDetailsID = 68,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1,
	ShowTertiaryInsurance = 1,
	ShowLastVisitDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 52

-- One Page TXGAPA
UPDATE EncounterFormType
SET PageOneDetailsID = 70,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 53

-- One Page Dr. Rechner
UPDATE EncounterFormType
SET PageOneDetailsID = 75,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowMostRecentDiagnoses = 1,
	ShowAcceptAssignment = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 54

-- One Page Dr. De La Llana
UPDATE EncounterFormType
SET PageOneDetailsID = 79,
	ShowProcedures = 0,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 55

-- 1-Page, 3-Column with Equal Spacing
UPDATE EncounterFormType
SET PageOneDetailsID = 81,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 56

-- 1-Page, Original with More Diagnoses
UPDATE EncounterFormType
SET PageOneDetailsID = 82,
	ShowLastInsurancePaymentDate = 1,
	ShowInsuranceBalance = 1,
	ShowLastPatientPaymentDate = 1,
	ShowPatientBalance = 1
WHERE EncounterFormTypeID = 57

GO
-----------------------------------------------------------------
-- COLLECTION CATEGORY TABLE
-----------------------------------------------------------------


CREATE TABLE dbo.CollectionCategory(
	CollectionCategoryID int IDENTITY(1,1) NOT NULL,
	CollectionCategoryName nchar(200) NOT NULL,
	Description nchar(256) NULL,
	SendStatement bit NOT NULL    DEFAULT ((1)),
	IsDefaultCategory bit NOT NULL    DEFAULT ((0)),
	DunningMessage nchar(1500) NULL,
	Notes nchar(1000) NULL,
	CreatedDate datetime NOT NULL    DEFAULT (getdate()),
	CreatedUserID int NOT NULL    DEFAULT ((0)),
	ModifiedDate datetime NOT NULL    DEFAULT (getdate()),
	ModifiedUserID int NOT NULL    DEFAULT ((0)),
 CONSTRAINT PK_CollectionCategory PRIMARY KEY  
(
	CollectionCategoryID ASC
))
GO

ALTER TABLE dbo.Patient ADD
	CollectionCategoryID int NULL

GO

ALTER TABLE dbo.Patient ADD CONSTRAINT
	FK_Patient_CollectionCategory FOREIGN KEY
	(
	CollectionCategoryID
	) REFERENCES dbo.CollectionCategory
	(
	CollectionCategoryID
	) 
GO


DECLARE @CollectionCategoryID INT
INSERT INTO CollectionCategory
           (CollectionCategoryName
           ,SendStatement
           ,IsDefaultCategory
           ,CreatedDate
           ,CreatedUserID)
     VALUES
           ('Current'
           ,1
           ,1
           ,GetDate()
           ,0)
SET @CollectionCategoryID = @@IDENTITY

INSERT INTO CollectionCategory
           (CollectionCategoryName
           ,SendStatement
           ,IsDefaultCategory
           ,CreatedDate
           ,CreatedUserID)
     VALUES
           ('Collections'
           ,1
           ,0
           ,GetDate()
           ,0)

UPDATE Patient SET CollectionCategoryID = @CollectionCategoryID
GO

/*---------------------------------------------------------------------------------
 Case 21019: Add fields for patient statement options screen
---------------------------------------------------------------------------------*/

ALTER TABLE Practice ADD
	EStatementsMinimumAllowableBalance MONEY NOT NULL CONSTRAINT DF_Practice_EStatementsMinimumAllowableBalance DEFAULT (0),
	EStatementsDaysBetweenStatements INT NOT NULL CONSTRAINT DF_Practice_EStatementsDaysBetweenStatements DEFAULT (30)

GO



/*-----------------------------------------------------------------------------
Case 20921:   Implement new Contract Management Summary
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
	PermissionValue,
	PracticeSpecific
	)

VALUES(
	2, 
	73, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Contract Management Summary', 
	'This report shows an analysis of average and expected allowed and payment amounts by primary insurance.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptContractManagementSummary',
	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters>
		  <basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="ClientTime" parameterName="ClientTime" />
			<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
			<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="PreviousMonth" forceDefault="true" />
			<basicParameter type="Date" parameterName="BeginDate" text="From:"/>
			<basicParameter type="Date" parameterName="EndDate" text="To:"/>
		  </basicParameters>
		  <extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
			  <value displayText="Posting Date" value="P" />
			  <value displayText="Service Date" value="S" />
			</extendedParameter>
			<extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
		    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="ProcedureCodeCategory" parameterName="RevenueCategoryID" text="Procedure Category:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />
			<extendedParameter type="ComboBox" parameterName="Metric" text="Metric:" description="Filter by Mertric."    default="A">
			  <value displayText="All" value="A" />
			  <value displayText="Expected Allowed" value="EA" />
			  <value displayText="Average Allowed" value="AA" />
			  <value displayText="Expected Payment" value="EP" />
			  <value displayText="Average Payment" value="AP" />
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="4">
			  <value displayText="Rendering Provider" value="1" />
			  <value displayText="Service Location" value="2" />
			  <value displayText="Department" value="3" />
			  <value displayText="Insurance Company" value="4" />
			  <value displayText="Insurance Plan" value="5" />
			  <value displayText="Payer Scenario" value="6" />
			  <value displayText="Batch #" value="7" />
			  <value displayText="Procedure" value="9" />
			  <value displayText="Procedure Category" value="8" />
			  <value displayText="Metric" value="10" />
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="9">
			  <value displayText="Rendering Provider" value="1" />
			  <value displayText="Service Location" value="2" />
			  <value displayText="Department" value="3" />
			  <value displayText="Insurance Company" value="4" />
			  <value displayText="Insurance Plan" value="5" />
			  <value displayText="Payer Scenario" value="6" />
			  <value displayText="Batch #" value="7" />
			  <value displayText="Procedure Category" value="8" />
			  <value displayText="Procedure" value="9" />
			  <value displayText="Metric" value="10" />
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="5">
			  <value displayText="Metrics" value="5" />
			  <value displayText="Total Only" value="1" />
			  <value displayText="Month" value="2" />
			  <value displayText="Quarter" value="3" />
			  <value displayText="Year" value="4" />
			</extendedParameter>
		  </extendedParameters>
		</parameters>',
	'Con&tract Management Summary',
	'ReadContractManagementSummaryReport',
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



/*-----------------------------------------------------------------------------
Case 20922:   Implement new Contract Management Detail
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
	PermissionValue,
	PracticeSpecific
	)

VALUES(
	2, 
	77, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Contract Management Detail', 
	'This report shows a list of allowed and payment amounts by primary insurance.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptContractManagementDetail',
	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters>
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
			<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
			  <value displayText="Posting Date" value="P" />
			  <value displayText="Service Date" value="S" />
			</extendedParameter>
			<extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
		    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="ProcedureCodeCategory" parameterName="RevenueCategoryID" text="Procedure Category:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Filter by procedure code or range." />
			<extendedParameter type="ComboBox" parameterName="Metric" text="Metric:" description="Filter by Mertric."    default="-1">
			  <value displayText="All" value="-1" />
			  <value displayText="Expected Allowed" value="1" />
			  <value displayText="Average Allowed" value="2" />
			  <value displayText="Expected Payment" value="3" />
			  <value displayText="Average Payment" value="4" />
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option."    default="9">
			  <value displayText="Rendering Provider" value="1" />
			  <value displayText="Service Location" value="2" />
			  <value displayText="Department" value="3" />
			  <value displayText="Insurance Company" value="4" />
			  <value displayText="Insurance Plan" value="5" />
			  <value displayText="Payer Scenario" value="6" />
			  <value displayText="Batch #" value="7" />
			  <value displayText="Procedure" value="9" />
			  <value displayText="Procedure Category" value="8" />
			</extendedParameter>
		  </extendedParameters>
		</parameters>',
	'C&ontract Management Detail',
	'ReadContractManagementDetailReport',
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

insert INTO ReportHyperLink( ReportHyperLinkID, Description, ReportParameters )
VALUES(
		40,
		'Contract Management Detail Report',
		'<?xml version="1.0" encoding="utf-8" ?>
		<task name="Report V2 Viewer">
		  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
			<method name="" />
			<method name="Add">
			  <methodParam param="ReportName" />
			  <methodParam param="Contract Management Detail" />
			  <methodParam param="true" type="System.Boolean" />
			</method>
			<method name="Add">
			  <methodParam param="ReportOverrideParameters" />
			  <methodParam>
				<object type="System.Collections.Hashtable">
				  <method name="" />
				  <method name="Add">
					<methodParam param="BeginDate" />
					<methodParam param="{0}" />
				  </method>
				  <method name="Add">
					<methodParam param="EndDate" />
					<methodParam param="{1}" />
				  </method>
				  <method name="Add">
					<methodParam param="DateType" />
					<methodParam param="{2}" />
				  </method>
				  <method name="Add">
					<methodParam param="ProviderID" />
					<methodParam param="{3}" />
				  </method>
				  <method name="Add">
					<methodParam param="ServiceLocationID" />
					<methodParam param="{4}" />
				  </method>
				  <method name="Add">
					<methodParam param="DepartmentID" />
					<methodParam param="{5}" />
				  </method>
				  <method name="Add">
					<methodParam param="InsuranceCompanyID" />
					<methodParam param="{6}" />
				  </method>
				  <method name="Add">
					<methodParam param="InsuranceCompanyPlanID" />
					<methodParam param="{7}" />
				  </method>
				  <method name="Add">
					<methodParam param="PayerScenarioID" />
					<methodParam param="{8}" />
				  </method>
				  <method name="Add">
					<methodParam param="BatchID" />
					<methodParam param="{9}" />
				  </method>
				  <method name="Add">
					<methodParam param="RevenueCategoryID" />
					<methodParam param="{10}" />
				  </method>
				  <method name="Add">
					<methodParam param="ProcedureCodeStr" />
					<methodParam param="{11}" />
				  </method>
				  <method name="Add">
					<methodParam param="Metric" />
					<methodParam param="{12}" />
				  </method>
				  <method name="Add">
					<methodParam param="PatientID" />
					<methodParam param="{13}" />
				  </method>
				  <method name="Add">
					<methodParam param="GroupBy" />
					<methodParam param="{14}" />
				  </method>
				</object>
			  </methodParam>
			</method>
		  </object>
		</task>'
)
GO



/*-----------------------------------------------------------------------------
 Case 20985:   Implement new Patient Collections Detail report
-----------------------------------------------------------------------------*/
update report -- move an existing report to make room
set DisplayOrder = 60
where reportID = 31
GO

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
	3, 
	50, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Patient Collections Detail', 
	'This report shows a detailed analysis of patients by collection category.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPatientCollectionsDetail',
	'<?xml version="1.0" encoding="utf-8" ?>
	<parameters>
	<basicParameters>
	  <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
	  <basicParameter type="PracticeID" parameterName="PracticeID" />
	  <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
	  <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
	  <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	  <basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
	  <extendedParameter type="Separator" text="Filter" />
	  <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date to start aging from."    default="B">
		<value displayText="First Billed Date" value="B" />
		<value displayText="Posting Date" value="P" />
		<value displayText="Service Date" value="S" />
	  </extendedParameter>
	  <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
	  <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1"/>
	  <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
	  <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
	  <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
	  <extendedParameter type="CollectionCategory" parameterName="CollectionCategoryID" text="Collection Category:" default="-1" ignore="-1" />
	  <extendedParameter type="ComboBox" parameterName="Metric" text="A/R Age:" description="Limits the report by the A/R age range."     default="1">
		<value displayText="Current+" value="1" />
		<value displayText="30+" value="2" />
		<value displayText="60+" value="3" />
		<value displayText="90+" value="4" />
		<value displayText="120+" value="5" />
	  </extendedParameter>
	  <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	  <extendedParameter type="ComboBox" parameterName="SortBy" text="Sort By:" description="Sorts the report by field."     default="1">
		<value displayText="Total Balance" value="1" />
		<value displayText="Patient Last Name" value="2" />
		<value displayText="Balance Over 90 Days" value="3" />
	  </extendedParameter>
	</extendedParameters>
	</parameters>',
	'Patient C&ollections Detail',
	'ReadPatientCollectionsDetailReport',
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


/*-----------------------------------------------------------------------------
 Case 20984:   Implement new Patient Collections Summary report
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
	PermissionValue,
	PracticeSpecific
	)

VALUES(
	3, 
	45, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Patient Collections Summary', 
	'This report shows an accounts receivable patient aging summary by collection category.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPatientCollectionsSummary',
	'<?xml version="1.0" encoding="utf-8" ?>
	<parameters>
	<basicParameters>
	  <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
	  <basicParameter type="PracticeID" parameterName="PracticeID" />
	  <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
	  <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
	  <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	  <basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
	  <extendedParameter type="Separator" text="Filter" />
	  <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date to start aging from."    default="B">
		<value displayText="First Billed Date" value="B" />
		<value displayText="Posting Date" value="P" />
		<value displayText="Service Date" value="S" />
	  </extendedParameter>
	  <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
	  <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
	  <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
	  <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
	  <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	  <extendedParameter type="ComboBox" parameterName="SortBy" text="Sort By:" description="Sorts the report by field."     default="1">
		<value displayText="Collection Category" value="1" />
		<value displayText="Total Balance" value="2" />
	  </extendedParameter>
	  <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."     default="1">
		<value displayText="All" value="1" />
		<value displayText="Total Only" value="2" />
	  </extendedParameter>
	</extendedParameters>
	</parameters>',
	'Patient &Collections Summary',
	'ReadPatientCollectionsSummaryReport',
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


insert INTO ReportHyperlink (ReportHyperlinkID, Description, ReportParameters )
SELECT 41,
'Patient Collections Detail Report',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Collections Detail" />
      <methodParam param="true" type="System.Boolean" />
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="Date" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="DateType" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="ProviderID" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="ServiceLocationID" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="DepartmentID" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="PayerScenarioID" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="SortBy" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="CollectionCategoryID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="Metric" />
            <methodParam param="{9}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
GO

-----------------------------------------------------------
-- Case 21036
-- Create schema for Patient Statement
-----------------------------------------------------------
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NoteType]') AND type in (N'U'))
	DROP TABLE [dbo].[NoteType]
	GO

	Create Table NoteType (NoteTypeCode INT CONSTRAINT PK_NoteType PRIMARY KEY CLUSTERED , Description varchar(50), ClaimTransactionTypeCode varchar(3) )

	INSERT INTO NoteType( NoteTypeCode, Description, ClaimTransactionTypeCode )
	values( 1, 'Patient Note', 'PJN')
	INSERT INTO NoteType( NoteTypeCode, Description, ClaimTransactionTypeCode )
	values( 2, 'Statement Note', 'PSN')
	GO

	Alter Table PatientJournalNote add NoteTypeCode INT CONSTRAINT DF_PatientJournalNote_NoteTypeCode DEFAULT 1 with values
	Alter Table PatientJournalNote add LastNote bit CONSTRAINT DF_PatientJournalNote_LastNote DEFAULT 0 with values
	GO


/*-----------------------------------------------------------------------------
	Case 17933 - No permission for Patient Detail report
-----------------------------------------------------------------------------*/
Update Report
SET PermissionValue = 'ReadPatientDetailReport',
	modifiedDate = getdate()
where Name = 'Patient Detail'
GO

/*-----------------------------------------------------------------------------
	 Case 20923:   Add new date type to User Productivity report
-----------------------------------------------------------------------------*/
UPDATE REPORT
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select the date type."    default="C">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
      <value displayText="Entered Date" value="C" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" description="Filter by batch #"/>
    <extendedParameter type="ComboBox" parameterName="Metric" text="Metric:" description="Limits the report by Metric type."    default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Patients" value="1" />
      <value displayText="Appointments" value="2" />
      <value displayText="Encounters" value="3" />
      <value displayText="Procedures" value="4" />
      <value displayText="Charges" value="5" />
      <value displayText="Adjustments" value="6" />
      <value displayText="Receipts" value="7" />
      <value displayText="Refunds" value="8" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Metric" value="1" />
      <value displayText="User" value="2" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>',
modifiedDate=getdate()
WHERE Name = 'User Productivity'



Update Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:"/>
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="String" parameterName="AllPracticeID" default="1" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select the date type."    default="C">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
      <value displayText="Entered Date" value="C" />
    </extendedParameter>
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" description="Filter by batch #"/>
    <extendedParameter type="ComboBox" parameterName="Metric" text="Metric:" description="Limits the report by Metric type."    default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Patients" value="1" />
      <value displayText="Appointments" value="2" />
      <value displayText="Encounters" value="3" />
      <value displayText="Procedures" value="4" />
      <value displayText="Charges" value="5" />
      <value displayText="Adjustments" value="6" />
      <value displayText="Receipts" value="7" />
      <value displayText="Refunds" value="8" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
      <value displayText="Metric" value="1" />
      <value displayText="User" value="2" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>',
modifiedDate=getdate()
WHERE Name = 'Company User Productivity'

GO



