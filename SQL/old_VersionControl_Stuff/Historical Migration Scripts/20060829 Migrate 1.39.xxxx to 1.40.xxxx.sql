/*----------------------------------

DATABASE UPDATE SCRIPT

v1.39.xxxx to v1.40.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------


--------------------------------------------------------------------------------
-- CASE 12316 - Add ability to choose which line of service to apply copay
--------------------------------------------------------------------------------


UPDATE R
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please select custom criteria to display a report." refreshOnParameterChange="true">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Insurance" parameterName="PayerID" text="Insurance:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="Balance" text="Balance:" description="Limits the report by service line balances due." default="All">
      <value displayText="All" value="All" />
      <value displayText="$10.00+" value="$10.00+" />
      <value displayText="$15.00+" value="$15.00+" />
      <value displayText="$20.00+" value="$20.00+" />
      <value displayText="$50.00+" value="$50.00+" />
      <value displayText="$100.00+" value="$100.00+" />
      <value displayText="$500.00+" value="$500.00+" />
      <value displayText="$1,000.00+" value="$1,000.00+" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="DOSRange" text="Date Of Service Age:" description="Limits the report by age of service lines." default="0-15 days">
      <value displayText="0-15 days" value="0-15 days" />
      <value displayText="16-30 days" value="16-30 days" />
      <value displayText="31-45 days" value="31-45 days" />
      <value displayText="46-60 days" value="46-60 days" />
      <value displayText="61-90 days" value="61-90 days" />
      <value displayText="91+ days" value="91+ days" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
from report r
where Name = 'Unpaid Insurance Claims'

GO 

--------------------------------------------------------------------------------
-- Case 14066:   Add patient alerts to claims, payments, and patient statements  
--------------------------------------------------------------------------------
ALTER TABLE dbo.PatientAlert ADD
	[ShowInClaimFlag] bit NOT NULL CONSTRAINT DF_PatientAlert_ShowInClaimFlag DEFAULT 0,
	[ShowInPaymentFlag] bit NOT NULL CONSTRAINT DF_PatientAlert_ShowInPaymentFlag  DEFAULT 0,
	[ShowInPatientStatementFlag] bit NOT NULL CONSTRAINT DF_PatientAlert_ShowInPatientStatementFlag  DEFAULT 0


--------------------------------------------------------------------------------
-- Case 11972:   Reports Menu: Payer Mix Summary missing mnemonic 
--------------------------------------------------------------------------------
update report
set MenuName = 'Pa&yer Mix Summary',
	ModifiedDate = getdate()
where name = 'Payer Mix Summary'
GO






/*-----------------------------------------------------------------------------
Case 14030:   Implement new Adjustments Detail report 
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
	2, 
	80, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Adjustments Detail', 
	'This report shows a list of adjustments over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptAdjustmentsDetail',
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
				<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />			
				<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" /> 	
				<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
				<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
				<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
				<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
				<extendedParameter type="Adjustment" parameterName="AdjustmentReasonID" text="Adjustment Code:" default="-1" ignore="-1" />
				<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option."    default="1">    
					<value displayText="Provider" value="1" />    
					<value displayText="Adjustment Codes" value="2" />  
					<value displayText="Service Location" value="3" />  
					<value displayText="Department" value="4" />    
					<value displayText="Batch #" value="5" />    
				</extendedParameter>    
			</extendedParameters>  
		</parameters>',
	'A&djustments Detail', -- Why are "&" used in the value???
	'ReadAdjustmentsDetailReport')

 

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





/*-----------------------------------------------------------------------------
Case 14029:   Implement new Adjustments Summary report 
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
	2, 
	75, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Adjustments Summary', 
	'This report shows a summary of adjustments over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptAdjustmentsSummary',
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
			<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
			<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="ComboBox" parameterName="PaymentTypeID" text="Payment Type:" description="Limits the report by payer type."     default="-1">
			  <value displayText="All" value="-1" />
			  <value displayText="Copay" value="1" />
			  <value displayText="Patient Payment on Account" value="2" />
			  <value displayText="Insurance Payment" value="3" />
			  <value displayText="Other" value="4" />
			</extendedParameter>
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="Adjustment" parameterName="AdjustmentReasonID" text="Adjustment Code:" default="-1" ignore="-1" />
			<extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
			  <value displayText="Provider" value="1" />
			  <value displayText="Adjustment Codes" value="2" />
			  <value displayText="Service Location" value="3" />
			  <value displayText="Department" value="4" />
			  <value displayText="Batch #" value="5" />
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="2">
			  <value displayText="Provider" value="1" />
			  <value displayText="Adjustment Codes" value="2" />
			  <value displayText="Service Location" value="3" />
			  <value displayText="Department" value="4" />
			  <value displayText="Batch #" value="5" />
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
			  <value displayText="Total Only" value="1" />
			  <value displayText="Month" value="2" />
			  <value displayText="Quarter" value="3" />
			  <value displayText="Year" value="4" />
			</extendedParameter>
		  </extendedParameters>
		</parameters>',
	'Ad&justments Summary', -- Why are "&" used in the value???
	'ReadAdjustmentsSummaryReport')

 

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

-- Creating Hpyperlink to te Adjustment Detail Report
Insert INTO Reporthyperlink (ReportHyperLinkID, Description, ReportParameters)
select
	37,
	'Adjustments Detail Report',
	'<?xml version="1.0" encoding="utf-8" ?>
		<task name="Report V2 Viewer">
		  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
			<method name="" />
			<method name="Add">
			  <methodParam param="ReportName" />
			  <methodParam param="Adjustments Detail" />
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
					<methodParam param="PatientID" />
					<methodParam param="{6}" />
				  </method>
				  <method name="Add">
					<methodParam param="AdjustmentReasonID" />
					<methodParam param="{7}" />
				  </method>
				  <method name="Add">
					<methodParam param="GroupBy" />
					<methodParam param="{8}" />
				  </method>
				  <method name="Add">
					<methodParam param="InsuranceCompanyPlanID" />
					<methodParam param="{9}" />
				  </method>
				  <method name="Add">
					<methodParam param="InsuranceCompanyID" />
					<methodParam param="{10}" />
				  </method>
				  <method name="Add">
					<methodParam param="BatchID" />
					<methodParam param="{11}" />
				  </method>
				</object>
			  </methodParam>
			</method>
		  </object>
		</task>'

GO




/*-----------------------------------------------------------------------------
Case 14366:   Add Created User ID for Refuned Table 
-----------------------------------------------------------------------------*/
ALTER TABLE Refund ADD CreatedUserID INT NULL, ModifiedUserID INT NULL
GO




/*-----------------------------------------------------------------------------
Case 14038:   Implement new User Productivity report 
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
	4, 
	15, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'User Productivity', 
	'This report shows productivity metrics by user.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptUserProductivity',
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
				<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
				  <value displayText="Posting Date" value="P" />
				  <value displayText="Service Date" value="S" />
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
	'&User Productivity', -- Why are "&" used in the value???
	'ReadUserProductivityReport')

 

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

/*=============================================================================
Case 14011 - Merge Business Manager, Medical Office, and Administrator
=============================================================================*/

-- Add new software application "Kareo"
INSERT INTO [dbo].[SoftwareApplication] (
	[SoftwareApplicationID]
	,[Name] )
VALUES (
	'K'
	,'Kareo' )
GO

-- Link report categories to "Kareo"
INSERT INTO [dbo].[ReportCategoryToSoftwareApplication] (
	[ReportCategoryID]
	, [SoftwareApplicationID]
	, [ModifiedDate] )
SELECT 
	DISTINCT ReportCategoryID
	, 'K'
	, GETDATE()
FROM
	ReportCategoryToSoftwareApplication
WHERE
	SoftwareApplicationID IN ( 'A', 'B', 'M' )
ORDER BY
	ReportCategoryID
GO

-- Link reports to "Kareo"
INSERT INTO [dbo].[ReportToSoftwareApplication] (
	[ReportID]
	, [SoftwareApplicationID]
	, [ModifiedDate] )
SELECT 
	DISTINCT ReportID
	, 'K'
	, GETDATE()
FROM
	ReportToSoftwareApplication
WHERE
	SoftwareApplicationID IN ( 'A', 'B', 'M' )
ORDER BY
	ReportID
GO

-- Link patient journal note entries to "Kareo"
UPDATE [dbo].[PatientJournalNote]
	SET [SoftwareApplicationID] = 'K'
WHERE 
	[SoftwareApplicationID] IN ( 'A', 'B', 'M' )
GO

-- Remove report categories linked to Administrator, Business Manager, and Medical Office
DELETE FROM [dbo].[ReportCategoryToSoftwareApplication]
WHERE
	SoftwareApplicationID IN ( 'A', 'B', 'M' )
GO

-- Remove reports linked to Administrator, Business Manager, and Medical Office
DELETE FROM [dbo].[ReportToSoftwareApplication]
WHERE
	SoftwareApplicationID IN ( 'A', 'B', 'M' )
GO

-- Remove obsolete software application IDs
DELETE FROM [dbo].[SoftwareApplication]
WHERE 
	[SoftwareApplicationID] IN ( 'A', 'B', 'M' )
GO

-- Rename report category, 'Company Indicators', to 'Company'
UPDATE dbo.ReportCategory
SET [Name] = 'Company',
	Description = 'Company',
	MenuName = '&Company',
	ModifiedDate = GETDATE()
WHERE [Name] = 'Company Indicators'
GO

-- Add new column to indicate whether a report is practice-specific
ALTER TABLE dbo.Report ADD
	PracticeSpecific bit NOT NULL CONSTRAINT DF_Report_PracticeSpecific DEFAULT 0
GO

UPDATE dbo.Report
SET PracticeSpecific = 1,
	ModifiedDate = GETDATE()
GO

UPDATE dbo.Report
SET PracticeSpecific = 0,
	ModifiedDate = GETDATE()
WHERE [Name] = 'Company Indicators Summary'
GO

-- Add new column to indicate whether a report category is practice-specific
ALTER TABLE dbo.ReportCategory ADD
	PracticeSpecific bit NOT NULL CONSTRAINT DF_ReportCategory_PracticeSpecific DEFAULT 0
GO

UPDATE dbo.ReportCategory
SET PracticeSpecific = 1,
	ModifiedDate = GETDATE()
GO

UPDATE dbo.ReportCategory
SET MenuName = 'Co&mpany',
	PracticeSpecific = 0,
	ModifiedDate = GETDATE()
WHERE [Name] = 'Company'
GO

-- Re-order report menu categories ...
UPDATE	ReportCategory
SET		DisplayOrder = 5,
		ModifiedDate = GETDATE()
WHERE	[Name] = 'Accounts Receivable'

UPDATE	ReportCategory
SET		DisplayOrder = 10,
		ModifiedDate = GETDATE()
WHERE	[Name] = 'Productivity & Analysis'

UPDATE	ReportCategory
SET		DisplayOrder = 15,
		ModifiedDate = GETDATE()
WHERE	[Name] = 'Patients'

UPDATE	ReportCategory
SET		DisplayOrder = 20,
		ModifiedDate = GETDATE()
WHERE	[Name] = 'Appointments'

UPDATE	ReportCategory
SET		DisplayOrder = 25,
		ModifiedDate = GETDATE()
WHERE	[Name] = 'Encounters'

UPDATE	ReportCategory
SET		DisplayOrder = 30,
		ModifiedDate = GETDATE()
WHERE	[Name] = 'Payments'

UPDATE	ReportCategory
SET		DisplayOrder = 35,
		ModifiedDate = GETDATE()
WHERE	[Name] = 'Refunds'

UPDATE	ReportCategory
SET		DisplayOrder = 40,
		ModifiedDate = GETDATE()
WHERE	[Name] = 'Settings'

UPDATE	ReportCategory
SET		DisplayOrder = 45,
		ModifiedDate = GETDATE()
WHERE	[Name] = 'Company'

GO

--Add VendorImportID To ServiceLocation where it doesn't exist - for use by new copying procedures involving servicelocation table
IF NOT EXISTS(SELECT * FROM sys.objects so inner join sys.columns sc on so.object_id=sc.object_id 
		  WHERE so.Name='ServiceLocation' AND so.type='U' AND sc.Name='VendorImportID')
BEGIN
	ALTER TABLE ServiceLocation ADD VendorImportID INT, VendorID INT
END


----------------------------------------------------------------------------------------------------
-- CASE 14446
----------------------------------------------------------------------------------------------------
CREATE TABLE EligibilityHistory(
	RequestID int IDENTITY(1,1) NOT NULL
	,RequestDate datetime NOT NULL
	,InsurancePolicyID int NOT NULL
	,EligibilityStatus bit NOT NULL
	,Request xml NULL
	,Response text NULL
	,ResponseXML text NULL
	,CreatedDate datetime NOT NULL DEFAULT (getdate())
	,CreatedUserID int NOT NULL  DEFAULT (0)
	,RecordTimeStamp timestamp NOT NULL
CONSTRAINT PK_EligibilityHistory 
PRIMARY KEY 
(
	RequestID 
),
CONSTRAINT FK_EligibilityHistory_InsurancePolicy FOREIGN KEY(InsurancePolicyID)
REFERENCES InsurancePolicy (InsurancePolicyID))

GO

/*=============================================================================
Case 14010 - Add paging for some reports
=============================================================================*/
-- Account Activity Report
-- Large amounts of data causes remoting to timeout
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="0" pageCharacterCount="650000" headerExtractCharacterCount="100000">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="StartDate" toDateParameter="EndDate" text="Dates:" default="Today" forceDefault="true" />
		<basicParameter type="Date" parameterName="StartDate" text="From:"  />
		<basicParameter type="Date" parameterName="EndDate" text="To:"  />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type." default="P">
			<value displayText="Posting Date" value="P" />
			<value displayText="Date of Service" value="D" />
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
		<extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
		<extendedParameter type="ComboBox" parameterName="RevenueCategoryID" text="Revenue Category:" description="Limits the report by Revenue Category." default="-1" ignore="-1">
			<value displayText="ALL" value="-1" />
			<value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24"/>
			<value displayText="Anesthesia (00100-01999)" value="1"/>
			<value displayText="Category II Codes (0001F-6999F)" value="46"/>
			<value displayText="Category III Codes (0001T-0999T)" value="47"/>
			<value displayText="Chemotherapy Drugs (J9000-J9999)" value="25"/>
			<value displayText="Dental Procedures (D0120-D9999)" value="26"/>
			<value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27"/>
			<value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28"/>
			<value displayText="Durable Medical Equipment (E0100-E9999)" value="29"/>
			<value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30"/>
			<value displayText="Evaluation and Management (99201-99499)" value="2"/>
			<value displayText="Hearing Services (V5008-V5364)" value="31"/>
			<value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32"/>
			<value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33"/>
			<value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34"/>
			<value displayText="Medical Services (M0064-M0302)" value="35"/>
			<value displayText="Medicine (90281-99199)" value="3"/>
			<value displayText="Medicine (99500-99602)" value="4"/>
			<value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36"/>
			<value displayText="Orthotic Procedures (L0100-L4398)" value="37"/>
			<value displayText="Pathology and Laboratory (80048-89399)" value="5"/>
			<value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38"/>
			<value displayText="Private Payer Codes (S0009-S9999)" value="39"/>
			<value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40"/>
			<value displayText="Prosthetic Procedures (L5000-L9900)" value="41"/>
			<value displayText="Radiology (70010-79999)" value="6"/>
			<value displayText="Rehabilitative Services (H0001-H2037)" value="42"/>
			<value displayText="Surgery - Auditory System (69000-69979)" value="7"/>
			<value displayText="Surgery - Cardiovascular System (33010-37799)" value="8"/>
			<value displayText="Surgery - Digestive System (40490-49999)" value="9"/>
			<value displayText="Surgery - Endocrine System (60000-60699)" value="10"/>
			<value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11"/>
			<value displayText="Surgery - Female Genital System (56405-58999)" value="12"/>
			<value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13"/>
			<value displayText="Surgery - Integumentary System (10040-19499)" value="14"/>
			<value displayText="Surgery - Intersex (55970-55980)" value="15"/>
			<value displayText="Surgery - Male Genital System (54000-55899)" value="16"/>
			<value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17"/>
			<value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18"/>
			<value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19"/>
			<value displayText="Surgery - Nervous System (61000-64999)" value="20"/>
			<value displayText="Surgery - Operating Microscope (69990-69990)" value="21"/>
			<value displayText="Surgery - Respiratory System (30000-32999)" value="22"/>
			<value displayText="Surgery - Urinary System (50010-53899)" value="23"/>
			<value displayText="Temporary Codes (Q0034-Q9999)" value="43"/>
			<value displayText="Transportation Services (A0080-A0999)" value="44"/>
			<value displayText="Vision Services (V2020-V2799)" value="45"/>
		</extendedParameter>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
		<extendedParameter type="ComboBox" parameterName="Groupby" text="Group By:" description="Select the grouping." default="1">
			<value displayText="Provider" value="1" />
			<value displayText="Service Location" value="2" />
			<value displayText="Department" value="3" />
			<value displayText="Revenue Category" value="4" />
		</extendedParameter>
	</extendedParameters>
</parameters>'
WHERE	Name = 'Account Activity Report'

-- Encounters Detail
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="15" pageCharacterCount="650000" headerExtractCharacterCount="100000">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:"/>
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
		<basicParameter type="ClientTime" parameterName="ClientTime" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
			<value displayText="Posting Date" value="P" />
			<value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Status:" description="Select Encounter Status"    default="3">
			<value displayText="All" value="-1" />
			<value displayText="Approved" value="3" />
			<value displayText="Drafts" value="1" />
			<value displayText="Submitted" value="2" />
			<value displayText="Rejected" value="4" />
			<value displayText="Unpayable" value="7" />
		</extendedParameter>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="ProviderNumberID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group report by:" description="Select to group by Status, Provider, Service location, or Department"    default="Status">
			<value displayText="Status" value="Status" />
			<value displayText="Provider" value="Provider" />
			<value displayText="Service Location" value="Service Location" />
			<value displayText="Department" value="Department" />
		</extendedParameter>
		<extendedParameter type="TextBox" parameterName="BatchNumberID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE	Name = 'Encounters Detail'

-- Unpaid Insurance Claims
-- The totals at the end don't look right
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please select custom criteria to display a report." refreshOnParameterChange="true" paging="true" pageColumnCount="0" pageCharacterCount="650000" headerExtractCharacterCount="100000" newPageDelimiter="&lt;/TR&gt;&lt;TR VALIGN=&quot;top&quot;&gt;&lt;TD COLSPAN=&quot;9&quot;&gt;">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Insurance" parameterName="PayerID" text="Insurance:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
		<extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="ComboBox" parameterName="Balance" text="Balance:" description="Limits the report by service line balances due." default="All">
			<value displayText="All" value="All" />
			<value displayText="$10.00+" value="$10.00+" />
			<value displayText="$15.00+" value="$15.00+" />
			<value displayText="$20.00+" value="$20.00+" />
			<value displayText="$50.00+" value="$50.00+" />
			<value displayText="$100.00+" value="$100.00+" />
			<value displayText="$500.00+" value="$500.00+" />
			<value displayText="$1,000.00+" value="$1,000.00+" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="DOSRange" text="Date Of Service Age:" description="Limits the report by age of service lines." default="0-15 days">
			<value displayText="0-15 days" value="0-15 days" />
			<value displayText="16-30 days" value="16-30 days" />
			<value displayText="31-45 days" value="31-45 days" />
			<value displayText="46-60 days" value="46-60 days" />
			<value displayText="61-90 days" value="61-90 days" />
			<value displayText="91+ days" value="91+ days" />
		</extendedParameter>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE	Name = 'Unpaid Insurance Claims'

-- A/R Aging Detail
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report." paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="RespType" text="Payer Type:" description="Limits the report by the payer type." default="I">
			<value displayText="Patient" value="P" />
			<value displayText="Insurance" value="I" />
		</extendedParameter>
		<extendedParameter type="Patient" parameterName="RespID" text="Patient:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="P" permission="FindPatient" />
		<extendedParameter type="Insurance" parameterName="RespID" text="Insurance:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="I" permission="FindInsurancePlan" />
		<extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range." default="Current+">
			<value displayText="Current+" value="Current+" />
			<value displayText="30+" value="Age31_60" />
			<value displayText="60+" value="Age61_90" />
			<value displayText="90+" value="Age91_120" />
			<value displayText="120+" value="AgeOver120" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range." default="All">
			<value displayText="All" value="All" />
			<value displayText="$10+" value="$10+" />
			<value displayText="$50+" value="$50+" />
			<value displayText="$100+" value="$100+" />
			<value displayText="$1,000+" value="$1000+" />
			<value displayText="$5,000+" value="$5000+" />
			<value displayText="$10,000+" value="$10000+" />
			<value displayText="$100,000+" value="$100000+" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field." default="false">
			<value displayText="Resp Name" value="false" />
			<value displayText="Open Balance" value="true" />
		</extendedParameter>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE	Name = 'A/R Aging Detail'

-- A/R Aging by Patient
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
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
		<extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables."    default="B">
			<value displayText="Last Billed Date" value="B" />
			<value displayText="Posting Date" value="P" />
			<value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
		<extendedParameter type="ComboBox" parameterName="AssignedType" text="Responsibility:" description="Limits by patient, insurance or all responsibility."    default="P">
			<value displayText="All" value="A" />
			<value displayText="Patient" value="P" />
			<value displayText="Insurance" value="I" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range."     default="Current+">
			<value displayText="Current+" value="Current+" />
			<value displayText="30+" value="Age31_60" />
			<value displayText="60+" value="Age61_90" />
			<value displayText="90+" value="Age91_120" />
			<value displayText="120+" value="AgeOver120" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range."     default="All">
			<value displayText="All" value="All" />
			<value displayText="$10+" value="$10+" />
			<value displayText="$50+" value="$50+" />
			<value displayText="$100+" value="$100+" />
			<value displayText="$1,000+" value="$1000+" />
			<value displayText="$5,000+" value="$5000+" />
			<value displayText="$10,000+" value="$10000+" />
			<value displayText="$100,000+" value="$100000+" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field."     default="false">
			<value displayText="Resp Name" value="false" />
			<value displayText="Open Balance" value="true" />
		</extendedParameter>
		<extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract"/>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE	Name = 'A/R Aging by Patient'

-- A/R Aging by Insurance
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
		<basicParameter type="String" parameterName="PayerTypeCode" default="1" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
		<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
		<extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract"/>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables."    default="B">
			<value displayText="Last Billed Date" value="B" />
			<value displayText="Posting Date" value="P" />
			<value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range."     default="Current+">
			<value displayText="Current+" value="Current+" />
			<value displayText="30+" value="Age31_60" />
			<value displayText="60+" value="Age61_90" />
			<value displayText="90+" value="Age91_120" />
			<value displayText="120+" value="AgeOver120" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range."     default="All">
			<value displayText="All" value="All" />
			<value displayText="$10+" value="$10+" />
			<value displayText="$50+" value="$50+" />
			<value displayText="$100+" value="$100+" />
			<value displayText="$1,000+" value="$1000+" />
			<value displayText="$5,000+" value="$5000+" />
			<value displayText="$10,000+" value="$10000+" />
			<value displayText="$100,000+" value="$100000+" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field."     default="false">
			<value displayText="Resp Name" value="false" />
			<value displayText="Open Balance" value="true" />
		</extendedParameter>
	</extendedParameters>
</parameters>'
WHERE	Name = 'A/R Aging by Insurance'

-- Patient Transactions Detail
-- This doesn't seem to work with large reports, takes more than 10 minutes
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Click refresh for all Patients (this may take some time) otherwise click on Customize and select a Patient." paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	</extendedParameters>
</parameters>'
WHERE	Name = 'Patient Transactions Detail'

-- Patient Balance Detail
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Patient to display a report." paging="true" pageColumnCount="1" pageCharacterCount="650000" headerExtractCharacterCount="100000">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1"     permission="FindPatient" />
		<extendedParameter type="ComboBox" parameterName="ReportType" text="Balances to show:" description="Select to show only Open, or All balances."    default="O">
			<value displayText="Open Only" value="O" />
			<value displayText="All" value="A" />
		</extendedParameter>
	</extendedParameters>
</parameters>'
WHERE	Name = 'Patient Balance Detail'

-- Patient History
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Patient for this report." paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	</extendedParameters>
</parameters>'
WHERE	Name = 'Patient History'

-- Patient Financial History
-- This doesn't even work because there is only a <table> <table> and some <tr>'s
/*
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Patient for this report." paging="true" pageColumnCount="0" pageCharacterCount="650000" headerExtractCharacterCount="100000">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="CustomDateRange" fromDateParameter="StartingDate" toDateParameter="EndingDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="StartingDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndingDate" text="To:" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	</extendedParameters>
</parameters>'
WHERE	Name = 'Patient Financial History'
*/

-- Patient Contact List
UPDATE	Report
SET		ModifiedDate = getdate(),
		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="8" pageCharacterCount="650000" headerExtractCharacterCount="100000">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="Activity" text="Activity:" description="Limits the report by patients with activity within specified time frame." default="30 days">
			<value displayText="30 days" value="30 days" />
			<value displayText="90 days" value="90 days" />
			<value displayText="180 days" value="180 days" />
			<value displayText="1 year" value="1 year" />
			<value displayText="All" value="All" />
		</extendedParameter>
	</extendedParameters>
</parameters>'
WHERE	Name = 'Patient Contact List'
GO




-----------------------------------------------------------------------
-- Case 14690:   Implement new User Productivity report for all practices
-----------------------------------------------------------------------
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
	8, 
	10, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Company User Productivity', 
	'This report shows productivity metrics by user.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptUserProductivity',
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
				<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
				  <value displayText="Posting Date" value="P" />
				  <value displayText="Service Date" value="S" />
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
	'Company &User Productivity', -- Why are "&" used in the value???
	'ReadCompanyUserProductivityReport',
	0)

 

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
 Case 14031:   Implement new Charges Summary report
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
	10, 
	15, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Charges Summary', 
	'This report shows a summary of charges over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptChargesSummary',
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
			<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />
			<extendedParameter type="ComboBox" parameterName="RevenueCategoryID" text="Revenue Category:" description="Limits the report by Revenue Category"     default="-1" ignore="-1">
			  <value displayText="ALL" value="-1" />
			  <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24"/>
			  <value displayText="Anesthesia (00100-01999)" value="1"/>
			  <value displayText="Category II Codes (0001F-6999F)" value="46"/>
			  <value displayText="Category III Codes (0001T-0999T)" value="47"/>
			  <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25"/>
			  <value displayText="Dental Procedures (D0120-D9999)" value="26"/>
			  <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27"/>
			  <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28"/>
			  <value displayText="Durable Medical Equipment (E0100-E9999)" value="29"/>
			  <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30"/>
			  <value displayText="Evaluation and Management (99201-99499)" value="2"/>
			  <value displayText="Hearing Services (V5008-V5364)" value="31"/>
			  <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32"/>
			  <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33"/>
			  <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34"/>
			  <value displayText="Medical Services (M0064-M0302)" value="35"/>
			  <value displayText="Medicine (90281-99199)" value="3"/>
			  <value displayText="Medicine (99500-99602)" value="4"/>
			  <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36"/>
			  <value displayText="Orthotic Procedures (L0100-L4398)" value="37"/>
			  <value displayText="Pathology and Laboratory (80048-89399)" value="5"/>
			  <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38"/>
			  <value displayText="Private Payer Codes (S0009-S9999)" value="39"/>
			  <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40"/>
			  <value displayText="Prosthetic Procedures (L5000-L9900)" value="41"/>
			  <value displayText="Radiology (70010-79999)" value="6"/>
			  <value displayText="Rehabilitative Services (H0001-H2037)" value="42"/>
			  <value displayText="Surgery - Auditory System (69000-69979)" value="7"/>
			  <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8"/>
			  <value displayText="Surgery - Digestive System (40490-49999)" value="9"/>
			  <value displayText="Surgery - Endocrine System (60000-60699)" value="10"/>
			  <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11"/>
			  <value displayText="Surgery - Female Genital System (56405-58999)" value="12"/>
			  <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13"/>
			  <value displayText="Surgery - Integumentary System (10040-19499)" value="14"/>
			  <value displayText="Surgery - Intersex (55970-55980)" value="15"/>
			  <value displayText="Surgery - Male Genital System (54000-55899)" value="16"/>
			  <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17"/>
			  <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18"/>
			  <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19"/>
			  <value displayText="Surgery - Nervous System (61000-64999)" value="20"/>
			  <value displayText="Surgery - Operating Microscope (69990-69990)" value="21"/>
			  <value displayText="Surgery - Respiratory System (30000-32999)" value="22"/>
			  <value displayText="Surgery - Urinary System (50010-53899)" value="23"/>
			  <value displayText="Temporary Codes (Q0034-Q9999)" value="43"/>
			  <value displayText="Transportation Services (A0080-A0999)" value="44"/>
			  <value displayText="Vision Services (V2020-V2799)" value="45"/>
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
			  <value displayText="Provider" value="1" />
			  <value displayText="Code" value="2" />
			  <value displayText="Revenue Category" value="6" />
			  <value displayText="Service Location" value="3" />
			  <value displayText="Department" value="4" />
			  <value displayText="Payer Scenario" value="7" />
			  <value displayText="Batch #" value="5" />
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="2">
			  <value displayText="Provider" value="1" />
			  <value displayText="Code" value="2" />
			  <value displayText="Revenue Category" value="6" />
			  <value displayText="Service Location" value="3" />
			  <value displayText="Department" value="4" />
			  <value displayText="Batch #" value="5" />
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
			  <value displayText="Total Only" value="1" />
			  <value displayText="Month" value="2" />
			  <value displayText="Quarter" value="3" />
			  <value displayText="Year" value="4" />
			</extendedParameter>
		  </extendedParameters>
		</parameters>',
	'&Charges Summary', -- Why are "&" used in the value???
	'ReadChargesSummaryReport',
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
 Case 14032:   Implement new Charges Detail report
-----------------------------------------------------------------------------*/
Update R
SET DisplayOrder = 25
FROM REPORT R
WHERE Name = 'Missed Encounters'

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
	10, 
	20, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Charges Detail', 
	'This report shows a list of charges over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptChargesDetail',
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
			<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />
			<extendedParameter type="ComboBox" parameterName="RevenueCategoryID" text="Revenue Category:" description="Limits the report by Revenue Category"     default="-1" ignore="-1">
			  <value displayText="ALL" value="-1" />
			  <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24"/>
			  <value displayText="Anesthesia (00100-01999)" value="1"/>
			  <value displayText="Category II Codes (0001F-6999F)" value="46"/>
			  <value displayText="Category III Codes (0001T-0999T)" value="47"/>
			  <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25"/>
			  <value displayText="Dental Procedures (D0120-D9999)" value="26"/>
			  <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27"/>
			  <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28"/>
			  <value displayText="Durable Medical Equipment (E0100-E9999)" value="29"/>
			  <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30"/>
			  <value displayText="Evaluation and Management (99201-99499)" value="2"/>
			  <value displayText="Hearing Services (V5008-V5364)" value="31"/>
			  <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32"/>
			  <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33"/>
			  <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34"/>
			  <value displayText="Medical Services (M0064-M0302)" value="35"/>
			  <value displayText="Medicine (90281-99199)" value="3"/>
			  <value displayText="Medicine (99500-99602)" value="4"/>
			  <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36"/>
			  <value displayText="Orthotic Procedures (L0100-L4398)" value="37"/>
			  <value displayText="Pathology and Laboratory (80048-89399)" value="5"/>
			  <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38"/>
			  <value displayText="Private Payer Codes (S0009-S9999)" value="39"/>
			  <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40"/>
			  <value displayText="Prosthetic Procedures (L5000-L9900)" value="41"/>
			  <value displayText="Radiology (70010-79999)" value="6"/>
			  <value displayText="Rehabilitative Services (H0001-H2037)" value="42"/>
			  <value displayText="Surgery - Auditory System (69000-69979)" value="7"/>
			  <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8"/>
			  <value displayText="Surgery - Digestive System (40490-49999)" value="9"/>
			  <value displayText="Surgery - Endocrine System (60000-60699)" value="10"/>
			  <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11"/>
			  <value displayText="Surgery - Female Genital System (56405-58999)" value="12"/>
			  <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13"/>
			  <value displayText="Surgery - Integumentary System (10040-19499)" value="14"/>
			  <value displayText="Surgery - Intersex (55970-55980)" value="15"/>
			  <value displayText="Surgery - Male Genital System (54000-55899)" value="16"/>
			  <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17"/>
			  <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18"/>
			  <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19"/>
			  <value displayText="Surgery - Nervous System (61000-64999)" value="20"/>
			  <value displayText="Surgery - Operating Microscope (69990-69990)" value="21"/>
			  <value displayText="Surgery - Respiratory System (30000-32999)" value="22"/>
			  <value displayText="Surgery - Urinary System (50010-53899)" value="23"/>
			  <value displayText="Temporary Codes (Q0034-Q9999)" value="43"/>
			  <value displayText="Transportation Services (A0080-A0999)" value="44"/>
			  <value displayText="Vision Services (V2020-V2799)" value="45"/>
			</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
			  <value displayText="Provider" value="1" />
			  <value displayText="Code" value="2" />
			  <value displayText="Revenue Category" value="6" />
			  <value displayText="Service Location" value="3" />
			  <value displayText="Department" value="4" />
			  <value displayText="Payer Scenario" value="7" />
			  <value displayText="Batch #" value="5" />
			</extendedParameter>
		  </extendedParameters>
		</parameters>',
	'Cha&rges Detail', -- Why are "&" used in the value???
	'ReadChargesDetailReport',
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


-- Inserts new Hyperlink
insert into reporthyperlink( ReportHyperlinkID, Description, Reportparameters )
SELECT
38,
'Charges Detail Report',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Charges Detail" />
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
            <methodParam param="ProcedureCodeStr" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="ServiceLocationID" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="DepartmentID" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="RevenueCategoryID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="PatientID" />
            <methodParam param="{9}" />
          </method>
          <method name="Add">
            <methodParam param="GroupBy1" />
            <methodParam param="{10}" />
          </method>
          <method name="Add">
            <methodParam param="PayerScenarioID" />
            <methodParam param="{11}" />
          </method>
        </object>
  </methodParam>
  </method>
  </object>
</task>'
GO


ALTER TABLE dbo.ClearinghousePayersList ADD
	SupportsPatientEligibilityRequests bit NOT NULL DEFAULT 0


GO

/*-----------------------------------------------------------------------------
 Case 14696:   Implement new Charges Summary report
-----------------------------------------------------------------------------*/
IF NOT EXISTS(SELECT sc.* 
			  FROM sys.objects so INNER JOIN sys.columns sc ON so.object_id=sc.object_id
			  WHERE so.name='ClaimAccounting' AND so.type='U' AND sc.name='CreatedUserID')
	ALTER TABLE ClaimAccounting ADD CreatedUserID INT
GO

ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL

UPDATE CT SET PostingDate=CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(CT.PostingDate) AS DATETIME),110) AS DATETIME)
FROM ClaimTransaction CT INNER JOIN ClaimAccounting CA
ON CT.ClaimTransactionID=CA.ClaimTransactionID
WHERE CT.ClaimTransactionTypeCode IN ('ADJ','PAY','END') AND
CT.PostingDate<>CA.PostingDate

UPDATE CA SET PostingDate=CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(CT.PostingDate) AS DATETIME),110) AS DATETIME)
FROM ClaimTransaction CT INNER JOIN ClaimAccounting CA
ON CT.ClaimTransactionID=CA.ClaimTransactionID
WHERE CT.ClaimTransactionTypeCode IN ('ADJ','PAY','END') AND
CT.PostingDate<>CA.PostingDate


ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL

GO


/*---------------------------------------------------------------------------------
 Case 13853:   Restructure EncounterFormType table with encounter form setup flags.
---------------------------------------------------------------------------------*/

ALTER TABLE EncounterFormType ADD
	NumberOfPages INT NOT NULL CONSTRAINT DF_EncounterFormType_NumberOfPages DEFAULT (1),
	PageOneDetailsID INT NOT NULL CONSTRAINT DF_EncounterFormType_PageOneDetailsID DEFAULT (0),
	PageTwoDetailsID INT NULL,
	ShowProcedures BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowProcedures DEFAULT (1),
	ShowDiagnoses BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowDiagnoses DEFAULT (1),
	ShowMostRecentDiagnoses BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowMostRecentDiagnoses DEFAULT (0),
	ShowAccountStatus BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowAccountStatus DEFAULT (0),
	ShowReferralSource BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowReferralSource DEFAULT (0),
	ShowTertiaryInsurance BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowTertiaryInsurance DEFAULT (0),
	ShowLastVisitDate BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowLastVisitDate DEFAULT (0),
	ShowAcceptAssignment BIT NOT NULL CONSTRAINT DF_EncounterFormType_ShowAcceptAssignment DEFAULT (0)

GO

/*--------------------------------------------------------------------------------
 Case 13853:   Update EncounterFormType table with encounter form setup data.
--------------------------------------------------------------------------------*/

-- One Page
UPDATE EncounterFormType
SET PageOneDetailsID = 12
WHERE EncounterFormTypeID = 1

-- Two Page
UPDATE EncounterFormType
SET NumberOfPages = 2,
	PageOneDetailsID = 13,
	PageTwoDetailsID = 14
WHERE EncounterFormTypeID = 2

-- Two Page (First Page Only)
UPDATE EncounterFormType
SET PageOneDetailsID = 13
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
SET PageOneDetailsID = 22
WHERE EncounterFormTypeID = 8

-- One Page Version 2
UPDATE EncounterFormType
SET PageOneDetailsID = 23
WHERE EncounterFormTypeID = 9

-- One Page Scanned Version 2
UPDATE EncounterFormType
SET PageOneDetailsID = 25,
	ShowProcedures = 0,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 10

-- One Page No Grid
UPDATE EncounterFormType
SET PageOneDetailsID = 26,
	ShowProcedures = 0,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 11

-- Two Page Four Column Grid
UPDATE EncounterFormType
SET NumberOfPages = 2,
	PageOneDetailsID = 27,
	PageTwoDetailsID = 28
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
SET PageOneDetailsID = 34
WHERE EncounterFormTypeID = 16

-- One Page Pacheco
UPDATE EncounterFormType
SET PageOneDetailsID = 35
WHERE EncounterFormTypeID = 17

-- One Page Choi
UPDATE EncounterFormType
SET PageOneDetailsID = 36
WHERE EncounterFormTypeID = 18

-- One Page Jacinto
UPDATE EncounterFormType
SET PageOneDetailsID = 37
WHERE EncounterFormTypeID = 19

-- One Page Four Column
UPDATE EncounterFormType
SET PageOneDetailsID = 38,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 20

-- One Page More Diagnoses
UPDATE EncounterFormType
SET PageOneDetailsID = 39
WHERE EncounterFormTypeID = 21

-- One Page Blank Fourth Columns
UPDATE EncounterFormType
SET PageOneDetailsID = 40
WHERE EncounterFormTypeID = 22

-- 1-Page, 2-Column Procedures
UPDATE EncounterFormType
SET PageOneDetailsID = 41
WHERE EncounterFormTypeID = 23

-- One Page Scanned Version 2 with Insurances
UPDATE EncounterFormType
SET PageOneDetailsID = 24,
	ShowProcedures = 0,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 24

-- One Page Dr. Marino
UPDATE EncounterFormType
SET PageOneDetailsID = 29,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 25

-- One Page Equal Spacing
UPDATE EncounterFormType
SET PageOneDetailsID = 42,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 26

-- One Page ASF Ortho
UPDATE EncounterFormType
SET PageOneDetailsID = 43
WHERE EncounterFormTypeID = 27

-- One Page TIOPASM Lab
UPDATE EncounterFormType
SET PageOneDetailsID = 44,
	ShowProcedures = 0
WHERE EncounterFormTypeID = 28

-- One Page Caduceus OB
UPDATE EncounterFormType
SET PageOneDetailsID = 45,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 29

-- One Page Caduceus Laguna
UPDATE EncounterFormType
SET PageOneDetailsID = 46,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 30

-- One Page Caduceus Peds
UPDATE EncounterFormType
SET PageOneDetailsID = 47,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
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
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 33

-- One Page Caduceus Ortho
UPDATE EncounterFormType
SET PageOneDetailsID = 50,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 34

-- One Page Caduceus Podiatry
UPDATE EncounterFormType
SET PageOneDetailsID = 51,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 35

-- One Page Caduceus Psychology
UPDATE EncounterFormType
SET PageOneDetailsID = 52,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 36

-- One Page No Grid Lines
UPDATE EncounterFormType
SET PageOneDetailsID = 53
WHERE EncounterFormTypeID = 37

-- 1-Page, No Grid Lines with More Diagnoses
UPDATE EncounterFormType
SET PageOneDetailsID = 54
WHERE EncounterFormTypeID = 38

-- One Page Dr. Carden
UPDATE EncounterFormType
SET PageOneDetailsID = 55,
	ShowProcedures = 0,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 39

-- One Page Dr. McNeill
UPDATE EncounterFormType
SET PageOneDetailsID = 56
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
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 42

-- One Page Caduceus Urology
UPDATE EncounterFormType
SET PageOneDetailsID = 59,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 43

-- One Page Caduceus ENT
UPDATE EncounterFormType
SET PageOneDetailsID = 60,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 44

-- One Page Caduceus Cardiology
UPDATE EncounterFormType
SET PageOneDetailsID = 61,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 45

-- One Page Dr. Bastidas
UPDATE EncounterFormType
SET PageOneDetailsID = 62
WHERE EncounterFormTypeID = 46

-- One Page Caduceus Ancillary
UPDATE EncounterFormType
SET PageOneDetailsID = 63,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 47

-- One Page Caduceus YLFP
UPDATE EncounterFormType
SET PageOneDetailsID = 64,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
WHERE EncounterFormTypeID = 48

-- One Page Caduceus FP Laguna Combined
UPDATE EncounterFormType
SET PageOneDetailsID = 65,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowAccountStatus = 1
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
	ShowLastVisitDate = 1
WHERE EncounterFormTypeID = 52

-- One Page TXGAPA
UPDATE EncounterFormType
SET PageOneDetailsID = 70,
	ShowProcedures = 0,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 53

-- One Page Dr. Rechner
UPDATE EncounterFormType
SET PageOneDetailsID = 75,
	ShowProcedures = 0,
	ShowDiagnoses = 0,
	ShowMostRecentDiagnoses = 1,
	ShowAcceptAssignment = 1
WHERE EncounterFormTypeID = 54

-- One Page Dr. De La Llana
UPDATE EncounterFormType
SET PageOneDetailsID = 79,
	ShowProcedures = 0,
	ShowDiagnoses = 0
WHERE EncounterFormTypeID = 55

-- 1-Page, 3-Column with Equal Spacing
UPDATE EncounterFormType
SET PageOneDetailsID = 81
WHERE EncounterFormTypeID = 56

GO

--------------------------------------------------------------------------------------------
-- Case 14929: Anesthesia: Retrofit financial calculations to accomodate decimal units
--------------------------------------------------------------------------------------------

	Alter Table EncounterProcedure alter column ServiceUnitCount decimal(19, 4)
	GO

	-- Changes the ClaimAccounting Table
	ALTER TABLE [dbo].[ClaimAccounting] DROP CONSTRAINT [DF_ClaimAccounting_ProcedureCount]
	GO
	Alter Table ClaimAccounting alter column ProcedureCount decimal(19, 4)
	GO
	ALTER TABLE [dbo].[ClaimAccounting] ADD  CONSTRAINT [DF_ClaimAccounting_ProcedureCount]  DEFAULT (0) FOR [ProcedureCount]
	GO


	-- Changes the ClaimTransaction Table
	ALTER TABLE ClaimTransaction ALTER COLUMN Quantity DECIMAL(19,4)
	GO

	-- Changes the [HandheldEncounterDetail] Table
	DECLARE @defaultObjectName varchar(128)

	select @defaultObjectName = def.Name 
	from sys.all_columns col
		INNER JOIN sys.objects tbl ON tbl.Object_id = col.object_id
		INNER JOIN sys.objects def ON def.Object_id = col.default_object_id
	where tbl.Name =  'HandheldEncounterDetail'
		AND col.Name = 'Units'

	IF @defaultObjectName IS NOT NULL
		exec ('ALTER TABLE [dbo].[HandheldEncounterDetail] DROP CONSTRAINT ' + @defaultObjectName)

	GO

	Alter Table [HandheldEncounterDetail] alter column Units decimal(19, 4)
	GO
	ALTER TABLE [dbo].[HandheldEncounterDetail] ADD  CONSTRAINT [DF_HandheldEncounterDetail_Units]  DEFAULT (0) FOR Units
	GO

	-- Changes the ProcedureCodeDictionary
	Alter table ProcedureCodeDictionary ALTER COLUMN DefaultUnits decimal(19, 4)
	GO



-- Change RVU field to hold 2 digits afer coma
ALTER TABLE CONTRACTFEESCHEDULE ALTER COLUMN RVU DECIMAL(18, 2)  
GO



------------------------------------------------------------------
--  Case 14067:   Add procedure code and procedure code range filter to several
------------------------------------------------------------------
	Update Report
	SET ReportParameters = 
	'<?xml version="1.0" encoding="utf-8" ?>
	<parameters>
	  <basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" forceDefault="true" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"  />
	  </basicParameters>
	  <extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
		  <value displayText="Posting Date" value="P" />
		  <value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="ComboBox" parameterName="RevenueCategory" text="Revenue Category:" description="Limits the report by Revenue Category"     default="-1" ignore="-1">
		  <value displayText="ALL" value="-1" />
		  <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24"/>
		  <value displayText="Anesthesia (00100-01999)" value="1"/>
		  <value displayText="Category II Codes (0001F-6999F)" value="46"/>
		  <value displayText="Category III Codes (0001T-0999T)" value="47"/>
		  <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25"/>
		  <value displayText="Dental Procedures (D0120-D9999)" value="26"/>
		  <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27"/>
		  <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28"/>
		  <value displayText="Durable Medical Equipment (E0100-E9999)" value="29"/>
		  <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30"/>
		  <value displayText="Evaluation and Management (99201-99499)" value="2"/>
		  <value displayText="Hearing Services (V5008-V5364)" value="31"/>
		  <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32"/>
		  <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33"/>
		  <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34"/>
		  <value displayText="Medical Services (M0064-M0302)" value="35"/>
		  <value displayText="Medicine (90281-99199)" value="3"/>
		  <value displayText="Medicine (99500-99602)" value="4"/>
		  <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36"/>
		  <value displayText="Orthotic Procedures (L0100-L4398)" value="37"/>
		  <value displayText="Pathology and Laboratory (80048-89399)" value="5"/>
		  <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38"/>
		  <value displayText="Private Payer Codes (S0009-S9999)" value="39"/>
		  <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40"/>
		  <value displayText="Prosthetic Procedures (L5000-L9900)" value="41"/>
		  <value displayText="Radiology (70010-79999)" value="6"/>
		  <value displayText="Rehabilitative Services (H0001-H2037)" value="42"/>
		  <value displayText="Surgery - Auditory System (69000-69979)" value="7"/>
		  <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8"/>
		  <value displayText="Surgery - Digestive System (40490-49999)" value="9"/>
		  <value displayText="Surgery - Endocrine System (60000-60699)" value="10"/>
		  <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11"/>
		  <value displayText="Surgery - Female Genital System (56405-58999)" value="12"/>
		  <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13"/>
		  <value displayText="Surgery - Integumentary System (10040-19499)" value="14"/>
		  <value displayText="Surgery - Intersex (55970-55980)" value="15"/>
		  <value displayText="Surgery - Male Genital System (54000-55899)" value="16"/>
		  <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17"/>
		  <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18"/>
		  <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19"/>
		  <value displayText="Surgery - Nervous System (61000-64999)" value="20"/>
		  <value displayText="Surgery - Operating Microscope (69990-69990)" value="21"/>
		  <value displayText="Surgery - Respiratory System (30000-32999)" value="22"/>
		  <value displayText="Surgery - Urinary System (50010-53899)" value="23"/>
		  <value displayText="Temporary Codes (Q0034-Q9999)" value="43"/>
		  <value displayText="Transportation Services (A0080-A0999)" value="44"/>
		  <value displayText="Vision Services (V2020-V2799)" value="45"/>
		</extendedParameter>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
		<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
		<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option"    default="1">
		  <value displayText="Revenue Category" value="Revenue Category" />
		  <value displayText="Provider" value="Provider" />
		  <value displayText="Service Location" value="Service Location" />
		  <value displayText="Department" value="Department" />
		</extendedParameter>
	  </extendedParameters>
	</parameters>'
	WHERE Name = 'Payment by Procedure'



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
		<basicParameter type="ExportType" parameterName="ExportType" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"    default="MonthToDate" forceDefault="true" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:"/>
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	  </basicParameters>
	  <extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" description="Filter by provider."  default="-1" ignore="-1" />
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" description="Filter by service location." default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" description="Filter by department." default="-1" ignore="-1" />
		<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" description="Filter by insurance plan." default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="I" permission="FindInsurancePlan" />
		<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" description="Filter by payer scenario." default="-1" ignore="-1" />
		<extendedParameter type="ComboBox" parameterName="PayerTypeID" text="Payment Type:" description="Filter by payer type."     default="-1">
		  <value displayText="All" value="-1" />
		  <value displayText="Copay" value="1" />
		  <value displayText="Patient Payment on Account" value="2" />
		  <value displayText="Insurance Payment" value="3" />
		  <value displayText="Other" value="4" />
		</extendedParameter>
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" description="Filter by patient." default="-1" ignore="-1" permission="FindPatient" />
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" description="Filter by batch #."/>
		<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
		<extendedParameter type="ComboBox" parameterName="ShowUnapplied" text="Show Unapplied?:" description="Show unapplied analysis."    default="TRUE">
		  <value displayText="Yes" value="TRUE" />
		  <value displayText="No" value="FALSE" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
		  <value displayText="Provider" value="1" />
		  <value displayText="Referring Provider" value="2" />
		  <value displayText="Primary Care Physician" value="3" />
		  <value displayText="Service Location" value="4" />
		  <value displayText="Department" value="5" />
		  <value displayText="Contract Type" value="6" />
		  <value displayText="Payer Type" value="7" />
		  <value displayText="Payment Method" value="8" />
		  <value displayText="Batch #" value="9" />
		  <value displayText="Payer Scenario" value="10" />
		  <value displayText="Insurance Company" value="11" />
		  <value displayText="Insurance Plan" value="12" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="7">
		  <value displayText="Provider" value="1" />
		  <value displayText="Referring Provider" value="2" />
		  <value displayText="Primary Care Physician" value="3" />
		  <value displayText="Service Location" value="4" />
		  <value displayText="Department" value="5" />
		  <value displayText="Contract Type" value="6" />
		  <value displayText="Payer Type" value="7" />
		  <value displayText="Payment Method" value="8" />
		  <value displayText="Batch #" value="9" />
		  <value displayText="Payer Scenario" value="10" />
		  <value displayText="Insurance Company" value="11" />
		  <value displayText="Insurance Plan" value="12" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="ColumnTotal" text="Columns:" description="Select the summarization method."    default="1">
		  <value displayText="Total Only" value="1" />
		  <value displayText="Month" value="2" />
		  <value displayText="Quarter" value="3" />
		  <value displayText="Year" value="4" />
		</extendedParameter>
	  </extendedParameters>
	</parameters>'
	WHERE Name = 'Payments Application Summary'


update Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type."     default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Date of Service" value="D" />
    </extendedParameter>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:"     default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
where Name = 'Provider Productivity'


Update Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="0" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="StartDate" toDateParameter="EndDate" text="Dates:" default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="StartDate" text="From:"  />
    <basicParameter type="Date" parameterName="EndDate" text="To:"  />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type." default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Date of Service" value="D" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="RevenueCategoryID" text="Revenue Category:" description="Limits the report by Revenue Category." default="-1" ignore="-1">
      <value displayText="ALL" value="-1" />
      <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24"/>
      <value displayText="Anesthesia (00100-01999)" value="1"/>
      <value displayText="Category II Codes (0001F-6999F)" value="46"/>
      <value displayText="Category III Codes (0001T-0999T)" value="47"/>
      <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25"/>
      <value displayText="Dental Procedures (D0120-D9999)" value="26"/>
      <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27"/>
      <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28"/>
      <value displayText="Durable Medical Equipment (E0100-E9999)" value="29"/>
      <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30"/>
      <value displayText="Evaluation and Management (99201-99499)" value="2"/>
      <value displayText="Hearing Services (V5008-V5364)" value="31"/>
      <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32"/>
      <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33"/>
      <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34"/>
      <value displayText="Medical Services (M0064-M0302)" value="35"/>
      <value displayText="Medicine (90281-99199)" value="3"/>
      <value displayText="Medicine (99500-99602)" value="4"/>
      <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36"/>
      <value displayText="Orthotic Procedures (L0100-L4398)" value="37"/>
      <value displayText="Pathology and Laboratory (80048-89399)" value="5"/>
      <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38"/>
      <value displayText="Private Payer Codes (S0009-S9999)" value="39"/>
      <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40"/>
      <value displayText="Prosthetic Procedures (L5000-L9900)" value="41"/>
      <value displayText="Radiology (70010-79999)" value="6"/>
      <value displayText="Rehabilitative Services (H0001-H2037)" value="42"/>
      <value displayText="Surgery - Auditory System (69000-69979)" value="7"/>
      <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8"/>
      <value displayText="Surgery - Digestive System (40490-49999)" value="9"/>
      <value displayText="Surgery - Endocrine System (60000-60699)" value="10"/>
      <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11"/>
      <value displayText="Surgery - Female Genital System (56405-58999)" value="12"/>
      <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13"/>
      <value displayText="Surgery - Integumentary System (10040-19499)" value="14"/>
      <value displayText="Surgery - Intersex (55970-55980)" value="15"/>
      <value displayText="Surgery - Male Genital System (54000-55899)" value="16"/>
      <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17"/>
      <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18"/>
      <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19"/>
      <value displayText="Surgery - Nervous System (61000-64999)" value="20"/>
      <value displayText="Surgery - Operating Microscope (69990-69990)" value="21"/>
      <value displayText="Surgery - Respiratory System (30000-32999)" value="22"/>
      <value displayText="Surgery - Urinary System (50010-53899)" value="23"/>
      <value displayText="Temporary Codes (Q0034-Q9999)" value="43"/>
      <value displayText="Transportation Services (A0080-A0999)" value="44"/>
      <value displayText="Vision Services (V2020-V2799)" value="45"/>
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
    <extendedParameter type="ComboBox" parameterName="Groupby" text="Group By:" description="Select the grouping." default="1">
      <value displayText="Provider" value="1" />
      <value displayText="Service Location" value="2" />
      <value displayText="Department" value="3" />
      <value displayText="Revenue Category" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE Name = 'Account Activity Report'



Update Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report." paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract"/>
    <extendedParameter type="ComboBox" parameterName="RespType" text="Payer Type:" description="Limits the report by the payer type." default="I">
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
    </extendedParameter>
    <extendedParameter type="Patient" parameterName="RespID" text="Patient:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="P" permission="FindPatient" />
    <extendedParameter type="Insurance" parameterName="RespID" text="Insurance:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="I" permission="FindInsurancePlan" />
    <extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range." default="Current+">
      <value displayText="Current+" value="Current+" />
      <value displayText="30+" value="Age31_60" />
      <value displayText="60+" value="Age61_90" />
      <value displayText="90+" value="Age91_120" />
      <value displayText="120+" value="AgeOver120" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range." default="All">
      <value displayText="All" value="All" />
      <value displayText="$10+" value="$10+" />
      <value displayText="$50+" value="$50+" />
      <value displayText="$100+" value="$100+" />
      <value displayText="$1,000+" value="$1000+" />
      <value displayText="$5,000+" value="$5000+" />
      <value displayText="$10,000+" value="$10000+" />
      <value displayText="$100,000+" value="$100000+" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field." default="false">
      <value displayText="Resp Name" value="false" />
      <value displayText="Open Balance" value="true" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE Name = 'A/R Aging Detail'

UPdate report
set ReportParameters = 
'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Click refresh for all Patients (this may take some time) otherwise click on Customize and select a Patient." paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
where name= 'Patient Transactions Detail'


UPdate Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"  />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="PayerMetric" text="Payer Metric:" description="Select the Payer Metric option"    default="0">
      <value displayText="All" value="0" />
      <value displayText="Payer Mix by Patients" value="1" />
      <value displayText="Payer Mix by Encounters" value="2" />
      <value displayText="Payer Mix by Procedures" value="3" />
      <value displayText="Payer Mix by Charges" value="4" />
      <value displayText="Payer Mix by Receipts" value="5" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="EncounterStatus" text="Status:" description="Select Encounter Status"    default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Approved" value="3" />
      <value displayText="Drafts" value="1" />
      <value displayText="Submitted" value="2" />
      <value displayText="Rejected" value="4" />
      <value displayText="Unpayable" value="7" />
    </extendedParameter>
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option"    default="Provider">
      <value displayText="Revenue Category" value="Revenue Category" />
      <value displayText="Provider" value="Provider" />
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Department" value="Department" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the grouping option"    default="Insurance Company">
      <value displayText="Payer Scenario" value="Payer Scenario" />
      <value displayText="Insurance Company" value="Insurance Company" />
      <value displayText="Insurance Plan" value="Insurance Plan" />
      <value displayText="Contract" value="Contract Name" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE Name = 'Payer Mix Summary'





UPdate Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Patient to display a report." paging="true" pageColumnCount="1" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1"     permission="FindPatient" />
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Balances to show:" description="Select to show only Open, or All balances."    default="O">
      <value displayText="Open Only" value="O" />
      <value displayText="All" value="A" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE Name = 'Patient Balance Detail'


UPdate Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Patient for this report." paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE Name = 'Patient History'



Update Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Patient for this report." paging="false" pageColumnCount="0" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="CustomDateRange" fromDateParameter="StartingDate" toDateParameter="EndingDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="StartingDate" text="From:" default="OneYearAgo" />
    <basicParameter type="Date" parameterName="EndingDate" text="To:" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
  </extendedParameters>
</parameters>'
WHERE Name = 'Patient Financial History'

GO

---------------------------------------------------------------------------
-- Adds clustered index to the ContractToInsurancePlan(ContractID, PlanID )
---------------------------------------------------------------------------
Delete cip
FROM ContractToInsurancePlan cip 
	INNER JOIN 
		( SELECT ContractID, PlanID, MIN(ModifiedDate) as ModifiedDate
		FROM ContractToInsurancePlan
		GROUP BY ContractID, PlanID
		having count(*) >1 
		) as v ON cip.ContractID = v.ContractID AND cip.PlanID = v.PlanID AND cip.ModifiedDate = v.ModifiedDate


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ContractToInsurancePlan]') AND name = N'Cl_ContractToInsurancePlan')
DROP INDEX [Cl_ContractToInsurancePlan] ON [dbo].[ContractToInsurancePlan] WITH ( ONLINE = OFF )

CREATE CLUSTERED INDEX [Cl_ContractToInsurancePlan_ContractIDPlanID] ON [dbo].[ContractToInsurancePlan] 
(
	[ContractID] ASC,
	PlanID ASC
)WITH (PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]


GO

--------------------------------------------------------------------------
-- Case 14920 - Anesthesia Billing
--------------------------------------------------------------------------
ALTER TABLE EncounterProcedure ADD AnesthesiaTime INT NOT NULL DEFAULT 0


GO




/*-----------------------------------------------------------------------------
Case 14039:   Implement new Denials Summary report
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
	85, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Denials Summary', 
	'This report shows a summary of denials over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptDenialsSummary',
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
			<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
			<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="Adjustment" parameterName="AdjustmentReasonCode" text="Adjustment Code:" default="-1" ignore="-1" />
			<extendedParameter type="AdjustmentCode" parameterName="PaymentDenialReasonCode" text="Denial Reason:" default="-1" ignore="-1" />
				<extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option."    default="1">
				  <value displayText="Adjustment Code" value="1" />
				  <value displayText="Denial Reason Code" value="2" />
				  <value displayText="Provider" value="3" />
				  <value displayText="Service Location" value="4" />
				  <value displayText="Department" value="5" />
				  <value displayText="Batch #" value="6" />
				  <value displayText="Insurance Companies" value="7" />
				  <value displayText="Insurance Plans" value="8" />
				  <value displayText="Payer Scenario" value="9" />  
				</extendedParameter>
				<extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="2">
				  <value displayText="Adjustment Code" value="1" />
				  <value displayText="Denial Reason Code" value="2" />
				  <value displayText="Provider" value="3" />
				  <value displayText="Service Location" value="4" />
				  <value displayText="Department" value="5" />
				  <value displayText="Batch #" value="6" />
				  <value displayText="Insurance Companies" value="7" />
				  <value displayText="Insurance Plans" value="8" />
				  <value displayText="Payer Scenario" value="9" />
				</extendedParameter>
			<extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
			  <value displayText="Total Only" value="1" />
			  <value displayText="Month" value="2" />
			  <value displayText="Quarter" value="3" />
			  <value displayText="Year" value="4" />
			</extendedParameter>
		  </extendedParameters>
		</parameters>',
	'D&enials Summary', 
	'ReadDenialsSummaryReport',
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
 Case 14040:   Implement new Denials Detail report
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
	90, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Denials Detail', 
	'This report shows a list of denials over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptDenialsDetail',
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
			<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
			<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="Adjustment" parameterName="AdjustmentCode" text="Adjustment Code:" default="-1" ignore="-1" />
			<extendedParameter type="AdjustmentCode" parameterName="PaymentDenialReasonCode" text="Denial Reason:" default="-1" ignore="-1" />
				<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option."    default="1">
				  <value displayText="Adjustment Discription" value="1" />
				  <value displayText="Denial Reason Code" value="2" />
				  <value displayText="Provider" value="3" />
				  <value displayText="Service Location" value="4" />
				  <value displayText="Department" value="5" />
				  <value displayText="Batch #" value="6" />
				  <value displayText="Insurance Companies" value="7" />
				  <value displayText="Insurance Plans" value="8" />
				  <value displayText="Payer Scenario" value="9" />  
				</extendedParameter>
		  </extendedParameters>
		</parameters>',
	'De&nials Detail', 
	'ReadDenialsDetailReport',
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



-- Creating Hpyperlink to the Denail Report
Insert INTO Reporthyperlink (ReportHyperLinkID, Description, ReportParameters)
select
	39,
	'Denials Detail Report',
	'<?xml version="1.0" encoding="utf-8" ?>
		<task name="Report V2 Viewer">
		  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
			<method name="" />
			<method name="Add">
			  <methodParam param="ReportName" />
			  <methodParam param="Denials Detail" />
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
					<methodParam param="AdjustmentCode" />
					<methodParam param="{3}" />
				  </method>
				  <method name="Add">
					<methodParam param="PaymentDenialReasonCode" />
					<methodParam param="{4}" />
				  </method>
				  <method name="Add">
					<methodParam param="ProviderID" />
					<methodParam param="{5}" />
				  </method>
				  <method name="Add">
					<methodParam param="ServiceLocationID" />
					<methodParam param="{6}" />
				  </method>
				  <method name="Add">
					<methodParam param="DepartmentID" />
					<methodParam param="{7}" />
				  </method>
				  <method name="Add">
					<methodParam param="BatchID" />
					<methodParam param="{8}" />
				  </method>
				  <method name="Add">
					<methodParam param="InsuranceCompanyID" />
					<methodParam param="{9}" />
				  </method>
				  <method name="Add">
					<methodParam param="InsuranceCompanyPlanID" />
					<methodParam param="{10}" />
				  </method>
				  <method name="Add">
					<methodParam param="PayerScenarioID" />
					<methodParam param="{11}" />
				  </method>
				  <method name="Add">
					<methodParam param="PatientID" />
					<methodParam param="{12}" />
				  </method>
				  <method name="Add">
					<methodParam param="GroupBy" />
					<methodParam param="{13}" />
				  </method>
				</object>
			  </methodParam>
			</method>
		  </object>
		</task>'

GO

/*--------------------------------------------------------------------------------
 Case 14471, 14468, 14469
--------------------------------------------------------------------------------*/

ALTER TABLE EncounterProcedure ADD CopayAmount MONEY NOT NULL CONSTRAINT DF_EncounterProcedure_CopayAmount DEFAULT 0
WITH VALUES

ALTER TABLE ClaimTransaction ADD PaymentID INT, AdjustmentGroupID TINYINT, AdjustmentReasonCode VARCHAR(5), AdjustmentCode VARCHAR(10), 
								 Reversible BIT CONSTRAINT DF_ClaimTransaction_Reversible DEFAULT 0 WITH VALUES

ALTER TABLE ClaimAccounting ADD PaymentID INT

CREATE TABLE AdjustmentGroup(AdjustmentGroupID TINYINT IDENTITY(1,1) CONSTRAINT PK_AdjustmentGroup PRIMARY KEY, 
							AdjustmentGroupCode VARCHAR(10), AdjustmentGroupDescription VARCHAR(128)
							CONSTRAINT U_AdjustmentGroup UNIQUE (AdjustmentGroupCode))

INSERT INTO AdjustmentGroup(AdjustmentGroupCode, AdjustmentGroupDescription)
VALUES('CO', 'Contractural Obligations')

INSERT INTO AdjustmentGroup(AdjustmentGroupCode, AdjustmentGroupDescription)
VALUES('OA', 'Other Adjustments')

INSERT INTO AdjustmentGroup(AdjustmentGroupCode, AdjustmentGroupDescription)
VALUES('PR', 'Patient Responsibility')

INSERT INTO AdjustmentGroup(AdjustmentGroupCode, AdjustmentGroupDescription)
VALUES('CR', 'Correction and Reversals')

INSERT INTO AdjustmentGroup(AdjustmentGroupCode, AdjustmentGroupDescription)
VALUES('PI', 'Patient Initiated Reductions')

--Add new ClaimTransactionType
INSERT INTO ClaimTransactionType(ClaimTransactionTypeCode, TypeName)
VALUES('RES', 'Response')

CREATE TABLE PaymentEncounter(PaymentEncounterID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PaymentEncounter PRIMARY KEY NONCLUSTERED,
PaymentID INT NOT NULL, PracticeID INT NOT NULL, PatientID INT NOT NULL, EncounterID INT NOT NULL, EOBXml XML, RawEOBXml XML
CONSTRAINT U_PaymentEncounter UNIQUE (PaymentID, EncounterID))

CREATE TABLE PaymentClaim(PaymentClaimID INT IDENTITY(1,1) NOT NULL,
PaymentID INT NOT NULL, PracticeID INT NOT NULL, PatientID INT NOT NULL, EncounterID INT NOT NULL, ClaimID INT NOT NULL, EOBXml XML, RawEOBXml XML, Notes VARCHAR(MAX),
Reversed BIT CONSTRAINT DF_PaymentClaim_Reversed DEFAULT 0, Draft BIT CONSTRAINT DF_PaymentClaim_Draft DEFAULT 0 ,
HasError BIT CONSTRAINT DF_PaymentClaim_HasError DEFAULT 0, ErrorMsg VARCHAR(500))


ALTER TABLE [dbo].[PaymentClaim] ADD  CONSTRAINT [PK_PaymentClaim] PRIMARY KEY CLUSTERED 
(
	[PracticeID] ASC,
	[PaymentID] ASC,
	[ClaimID] ASC
)WITH (PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF ) ON [PRIMARY]
GO

ALTER TABLE ClaimTransaction ADD CONSTRAINT FK_ClaimTransaction_PaymentID
FOREIGN KEY (PaymentID) REFERENCES Payment (PaymentID)

ALTER TABLE ClaimTransaction ADD CONSTRAINT FK_ClaimTransaction_AdjustmentGroupID
FOREIGN KEY (AdjustmentGroupID) REFERENCES AdjustmentGroup (AdjustmentGroupID)

ALTER TABLE ClaimTransaction ADD CONSTRAINT FK_ClaimTransaction_AdjustmentCode
FOREIGN KEY (AdjustmentCode) REFERENCES Adjustment (AdjustmentCode)

ALTER TABLE ClaimTransaction ADD CONSTRAINT FK_ClaimTransaction_AdjustmentReasonCode
FOREIGN KEY (AdjustmentReasonCode) REFERENCES AdjustmentReason (AdjustmentReasonCode)

ALTER TABLE PaymentEncounter ADD CONSTRAINT FK_PaymentEncounter_PaymentID
FOREIGN KEY (PaymentID) REFERENCES Payment (PaymentID)

ALTER TABLE PaymentClaim ADD CONSTRAINT FK_PaymentClaim_PaymentID
FOREIGN KEY (PaymentID) REFERENCES Payment (PaymentID)

ALTER TABLE Adjustment ADD DefaultAdjustmentReasonCode VARCHAR(5)
GO

ALTER TABLE Adjustment ADD SystemCode bit NOT NULL DEFAULT(0)
GO

ALTER TABLE Payment ADD SourceAppointmentID INT, EOBEditable BIT CONSTRAINT DF_Payment_EOBEditable DEFAULT 1 WITH VALUES,
AdjudicationDate DATETIME, ClearinghouseResponseID INT, ERAErrors XML
GO

--Mark all existing Payment records as EOBEditable = false (0)
UPDATE Payment SET EOBEditable=0
GO

-- Add a default adjustment and adjustment reason
INSERT INTO Adjustment (AdjustmentCode, Description, SystemCode)
VALUES('0', 'Default', 1)

GO

--Denormalization changes

IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  Name = N'fn_GetDate_FromDateKeySelectivityID')
	DROP FUNCTION fn_GetDate_FromDateKeySelectivityID
GO

CREATE FUNCTION dbo.fn_GetDate_FromDateKeySelectivityID(@PracticeID INT, @DateKeyID INT)
RETURNS DATETIME
AS  

/*=============================================================================
Purpose:  Get the corresponding Date Value from the calculated DateKeySelectivityID
=============================================================================*/

BEGIN 
	DECLARE @result DATETIME

	DECLARE @StartDt DATETIME
	DECLARE @EndDt DATETIME
	SET @StartDt='1-1-2000'
	SET @EndDt='12-31-2100'

	DECLARE @StartID INT
	DECLARE @EndID INT
	
	SET @StartID=1
	SET @EndID=DATEDIFF(D,@StartDt,@EndDt)+1

	SET @result=DateAdd(D,@DateKeyID-(@EndID*(@PracticeID-1))-1,@StartDt)

	RETURN @result
END

GO

IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  Name = N'fn_GetDateKeySelectivityID')
	DROP FUNCTION fn_GetDateKeySelectivityID
GO

CREATE FUNCTION dbo.fn_GetDateKeySelectivityID(@PracticeID INT, @Dt DATETIME, @GetLowerBound BIT, @GetUpperBound BIT)
RETURNS INT
AS  

/*=============================================================================
Purpose:  To calculate a more selective ID based upon the DateKey Date code file table
		  and a corresponding PracticeID
=============================================================================*/

BEGIN 
	DECLARE @result INT

	IF @PracticeID IS NULL OR @Dt IS NULL
		RETURN NULL

	SET @Dt=CAST(CONVERT(CHAR(10),@Dt,110) AS DATETIME)

	DECLARE @StartDt DATETIME
	DECLARE @EndDt DATETIME
	SET @StartDt='1-1-2000'
	SET @EndDt='12-31-2100'

	DECLARE @StartID INT
	DECLARE @EndID INT
	
	SET @StartID=1
	SET @EndID=DATEDIFF(D,@StartDt,@EndDt)+1

	SET @result=(DATEDIFF(D,@StartDt,@Dt)+1)+(@EndID*(@PracticeID-1))

	IF @GetLowerBound=1
		SET @result=@StartID+(@EndID*(@PracticeID-1))

	IF @GetUpperBound=1
		SET @result=@EndID*@PracticeID

	RETURN @result
END

GO

--fix inconsistent data due to prod bug allowing for encounter level data changes after approval
UPDATE CA SET ProviderID=CT.Claim_ProviderID
FROM ClaimTransaction CT INNER JOIN ClaimAccounting CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimTransactionID=CA.ClaimTransactionID
WHERE CT.Claim_ProviderID<>CA.ProviderID

ALTER TABLE ClaimAccounting ADD EncounterProcedureID INT
GO

ALTER TABLE ClaimAccounting_Assignments ADD EndPostingDate DATETIME, LastAssignmentOfEndPostingDate BIT,
EndClaimTransactionID INT, DKPostingDateID INT, DKEndPostingDateID INT

GO

ALTER TABLE ClaimAccounting_Billings ADD EndPostingDate DATETIME, LastBilledOfEndPostingDate BIT,
EndClaimTransactionID INT, DKPostingDateID INT, DKEndPostingDateID INT

GO

ALTER TABLE ClaimAccounting_Billings ADD  
CONSTRAINT DF_ClaimAccounting_Billings_LastBilledOfEndPostingDate  
DEFAULT (0) FOR LastBilledOfEndPostingDate

GO

ALTER TABLE ClaimAccounting_Assignments ADD  
CONSTRAINT DF_ClaimAccounting_Assignments_LastAssignmentOfEndPostingDate  
DEFAULT (0) FOR LastAssignmentOfEndPostingDate

GO

CREATE TABLE ClaimAccounting_ClaimPeriod (ProviderID INT, PatientID INT, ClaimID INT, 
DKInitialPostingDateID INT, DKEndPostingDateID INT)

GO

ALTER TABLE Claim DROP COLUMN Summary_ClaimFirstBilledDate, Summary_ClaimFirstPayDate

GO

ALTER TABLE Claim ADD DKProcedureDateOfServiceID INT

GO

--Migration Script For Denormalization and New Claim, ClaimAccounting Indexing
DROP INDEX Claim.CI_Claim

GO

UPDATE C SET DKProcedureDateOfServiceID=dbo.fn_GetDateKeySelectivityID(EP.PracticeID,EP.ProcedureDateOfService,0,0)
FROM Claim C INNER JOIN EncounterProcedure EP
ON C.EncounterProcedureID=EP.EncounterProcedureID

GO

CREATE UNIQUE CLUSTERED INDEX CI_Claim ON Claim
(
	PracticeID ASC,
	DKProcedureDateOfServiceID DESC,
	EncounterProcedureID DESC,
	ClaimID DESC
)

GO

--Update other Denormalized Data
UPDATE CA SET EncounterProcedureID=EP.EncounterProcedureID
FROM ClaimAccounting CA INNER JOIN Claim C
ON CA.ClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP
ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID

GO

INSERT INTO ClaimAccounting_ClaimPeriod(ProviderID, PatientID, ClaimID, DKInitialPostingDateID, DKEndPostingDateID)
SELECT ProviderID, PatientID, ClaimID, 
MIN(CASE WHEN ClaimTransactionTypeCode='CST' THEN dbo.fn_GetDateKeySelectivityID(CA.PracticeID,CA.PostingDate,0,0) ELSE NULL END),
MAX(CASE WHEN ClaimTransactionTypeCode='END' THEN dbo.fn_GetDateKeySelectivityID(CA.PracticeID,CA.PostingDate,0,0) ELSE NULL END)
FROM ClaimAccounting CA
GROUP BY ProviderID, PatientID, ClaimID

GO

CREATE CLUSTERED INDEX CI_ClaimAccounting_ClaimPeriod 
ON ClaimAccounting_ClaimPeriod
(
	DKInitialPostingDateID DESC, 
	DKEndPostingDateID DESC,
	ClaimID DESC
)

GO

DROP INDEX ClaimAccounting_Assignments.CI_ClaimAccounting_Assignments_PracticeID_PostingDate_ClaimTransactionID

GO

CREATE TABLE #ASNTrans(TID INT IDENTITY(1,1), PracticeID INT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME, EndPostingDate DATETIME, LastAssignmentOfEndPostingDate BIT, LastAssignment BIT,
					   EndClaimTransactionID INT)
INSERT INTO #ASNTrans(PracticeID, ClaimID, ClaimTransactionID, PostingDate, LastAssignmentOfEndPostingDate, LastAssignment)
SELECT CAA.PracticeID, CAA.ClaimID, CAA.ClaimTransactionID, CAST(CONVERT(CHAR(10),CAA.PostingDate,110) AS SMALLDATETIME), 0, 0
FROM ClaimAccounting_Assignments CAA
ORDER BY CAA.ClaimID, CAST(CONVERT(CHAR(10),CAA.PostingDate,110) AS SMALLDATETIME) DESC, CAA.ClaimTransactionID DESC

UPDATE AT1 SET EndPostingDate=AT2.PostingDate, EndClaimTransactionID=AT2.ClaimTransactionID
FROM #ASNTrans AT1 INNER JOIN  #ASNTrans AT2
ON AT1.ClaimID=AT2.ClaimID AND AT1.TID=AT2.TID+1

CREATE TABLE #ASN_FlagsToUpdate(ClaimID INT, EndPostingDate DATETIME, CTIDToUpdate INT)
INSERT INTO #ASN_FlagsToUpdate(ClaimID, EndPostingDate, CTIDToUpdate)
SELECT ClaimID, EndPostingDate, MAX(ClaimTransactionID) CTIDToUpdate
FROM #ASNTrans
GROUP BY ClaimID, EndPostingDate

UPDATE AT SET LastAssignmentOfEndPostingDate=1
FROM #ASNTrans AT INNER JOIN #ASN_FlagsToUpdate ATU
ON AT.ClaimID=ATU.ClaimID AND AT.ClaimTransactionID=ATU.CTIDToUpdate

UPDATE #ASNTrans SET LastAssignment=1
WHERE EndPostingDate IS NULL

UPDATE CAA SET LastAssignment=AT.LastAssignment, EndPostingDate=AT.EndPostingDate, 
EndClaimTransactionID=AT.EndClaimTransactionID,
DKPostingDateID=dbo.fn_GetDateKeySelectivityID(CAA.PracticeID,CAA.PostingDate,0,0),
DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(AT.PracticeID,AT.EndPostingDate,0,0),
LastAssignmentOfEndPostingDate=AT.LastAssignmentOfEndPostingDate
FROM #ASNTrans AT INNER JOIN ClaimAccounting_Assignments CAA
ON AT.ClaimID=CAA.ClaimID AND AT.ClaimTransactionID=CAA.ClaimTransactionID

DROP TABLE #ASNTrans 
DROP TABLE #ASN_FlagsToUpdate
GO

CREATE CLUSTERED INDEX CI_ClaimAccounting_Assignments 
ON ClaimAccounting_Assignments
(
	PracticeID ASC,
	DKPostingDateID DESC,
	DKEndPostingDateID DESC,
	ClaimTransactionID DESC
)

GO

--Update ClaimAccounting_Billings

DROP INDEX ClaimAccounting_Billings.CI_ClaimAccounting_Billings_PracticeID_PostingDate_ClaimTransactionID

GO

CREATE TABLE #BLLTrans(TID INT IDENTITY(1,1), PracticeID INT, NewFlag BIT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME, EndPostingDate DATETIME, LastBillOfEndPostingDate BIT, LastBilled BIT, FirstBilled BIT, EndClaimTransactionID INT)
INSERT INTO #BLLTrans(PracticeID, ClaimID, ClaimTransactionID, PostingDate, LastBillOfEndPostingDate, LastBilled, FirstBilled)
SELECT PracticeID, ClaimID, ClaimTransactionID, PostingDate, 0, 0, 0 
FROM ClaimAccounting_Billings CAB
ORDER BY ClaimID, PostingDate DESC, ClaimTransactionID DESC

UPDATE BT1 SET EndPostingDate=BT2.PostingDate, EndClaimTransactionID=BT2.ClaimTransactionID
FROM #BLLTrans BT1 INNER JOIN  #BLLTrans BT2
ON BT1.ClaimID=BT2.ClaimID AND BT1.TID=BT2.TID+1

CREATE TABLE #BLL_FlagsToUpdate(ClaimID INT, EndPostingDate DATETIME, CTIDToUpdate INT)
INSERT INTO #BLL_FlagsToUpdate(ClaimID, EndPostingDate, CTIDToUpdate)
SELECT ClaimID, EndPostingDate, MAX(ClaimTransactionID) CTIDToUpdate
FROM #BLLTrans
GROUP BY ClaimID, EndPostingDate

UPDATE BT SET LastBillOfEndPostingDate=1
FROM #BLLTrans BT INNER JOIN #BLL_FlagsToUpdate BTU
ON BT.ClaimID=BTU.ClaimID AND BT.ClaimTransactionID=BTU.CTIDToUpdate

UPDATE #BLLTrans SET LastBilled=1
WHERE EndPostingDate IS NULL

UPDATE BT SET FirstBilled=1
FROM #BLLTrans BT INNER JOIN (SELECT ClaimID, MIN(ClaimTransactionID) FBID FROM #BLLTrans GROUP BY ClaimID) FBT
ON BT.ClaimID=FBT.ClaimID AND BT.ClaimTransactionID=FBT.FBID

UPDATE CAB SET LastBilled=BT.LastBilled, 
EndPostingDate=BT.EndPostingDate, EndClaimTransactionID=BT.EndClaimTransactionID,
DKPostingDateID=dbo.fn_GetDateKeySelectivityID(CAB.PracticeID,CAB.PostingDate,0,0),
DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(BT.PracticeID,BT.EndPostingDate,0,0),
LastBilledOfEndPostingDate=BT.LastBillOfEndPostingDate
FROM #BLLTrans BT INNER JOIN ClaimAccounting_Billings CAB
ON BT.ClaimID=CAB.ClaimID AND BT.ClaimTransactionID=CAB.ClaimTransactionID

DROP TABLE #BLLTrans
DROP TABLE #BLL_FlagsToUpdate

GO

CREATE CLUSTERED INDEX CI_ClaimAccounting_Billings 
ON ClaimAccounting_Billings
(
	PracticeID ASC,
	DKPostingDateID DESC,
	DKEndPostingDateID DESC,
	ClaimTransactionID DESC
)

GO

-- Fix CreatedUserID and PaymentID values
UPDATE CA SET CreatedUserID=CT.CreatedUserID
FROM ClaimTransaction CT INNER JOIN ClaimAccounting CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimTransactionID=CA.ClaimTransactionID
WHERE CT.ClaimTransactionTypeCode IN ('CST','ADJ','PAY','END') AND CT.CreatedUserID IS NOT NULL

DECLARE @CO_AdjustmentGroupID INT
DECLARE @OA_AdjustmentGroupID INT

SELECT @CO_AdjustmentGroupID=AdjustmentGroupID
FROM AdjustmentGroup
WHERE AdjustmentGroupCode='CO'

SELECT @OA_AdjustmentGroupID=AdjustmentGroupID
FROM AdjustmentGroup
WHERE AdjustmentGroupCode='OA'

ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL

UPDATE CT SET PaymentID=PCT.PaymentID, 
AdjustmentGroupID=CASE WHEN ClaimTransactionTypeCode='ADJ' AND PCT.IsOtherAdjustment=1 THEN @OA_AdjustmentGroupID
WHEN ClaimTransactionTypeCode='ADJ' AND PCT.IsOtherAdjustment=0 THEN @CO_AdjustmentGroupID  ELSE NULL END,
AdjustmentReasonCode=CASE WHEN ClaimTransactionTypeCode='ADJ' AND AR.AdjustmentReasonCode IS NOT NULL THEN AR.AdjustmentReasonCode
ELSE NULL END,
AdjustmentCode=CASE WHEN ClaimTransactionTypeCode='ADJ' AND A.AdjustmentCode IS NOT NULL THEN A.AdjustmentCode 
ELSE NULL END,
Code=CASE WHEN ClaimTransactionTypeCode IN ('ADJ','PAY') THEN NULL ELSE Code END, 
ReferenceID=CASE WHEN ClaimTransactionTypeCode IN ('ADJ','PAY') THEN NULL ELSE ReferenceID END, 
ReferenceData=CASE WHEN ClaimTransactionTypeCode IN ('ADJ','PAY') THEN NULL ELSE ReferenceData END
FROM PaymentClaimTransaction PCT INNER JOIN ClaimTransaction CT
ON PCT.PracticeID=CT.PracticeID AND PCT.ClaimTransactionID=CT.ClaimTransactionID
LEFT JOIN AdjustmentReason AR
ON LTRIM(RTRIM(CT.ReferenceData))=AR.AdjustmentReasonCode AND CT.ClaimTransactionTypeCode='ADJ'
LEFT JOIN Adjustment A
ON LTRIM(RTRIM(CT.Code))=A.AdjustmentCode AND CT.ClaimTransactionTypeCode='ADJ'
WHERE ClaimTransactionTypeCode NOT IN ('ALW','MEM')

UPDATE CT SET 
AdjustmentReasonCode=CASE WHEN ClaimTransactionTypeCode='ADJ' AND AR.AdjustmentReasonCode IS NOT NULL THEN AR.AdjustmentReasonCode
ELSE NULL END,
AdjustmentCode=CASE WHEN ClaimTransactionTypeCode='ADJ' AND A.AdjustmentCode IS NOT NULL THEN A.AdjustmentCode 
ELSE NULL END,
Code=CASE WHEN ClaimTransactionTypeCode IN ('ADJ','PAY') THEN NULL ELSE Code END, 
ReferenceID=CASE WHEN ClaimTransactionTypeCode IN ('ADJ','PAY') THEN NULL ELSE ReferenceID END, 
ReferenceData=CASE WHEN ClaimTransactionTypeCode IN ('ADJ','PAY') THEN NULL ELSE ReferenceData END
FROM ClaimTransaction CT
LEFT JOIN AdjustmentReason AR
ON LTRIM(RTRIM(CT.ReferenceData))=AR.AdjustmentReasonCode AND CT.ClaimTransactionTypeCode='ADJ'
LEFT JOIN Adjustment A
ON LTRIM(RTRIM(CT.Code))=A.AdjustmentCode AND CT.ClaimTransactionTypeCode='ADJ'
LEFT JOIN PaymentClaimTransaction PCT
ON CT.PracticeID=PCT.PracticeID AND CT.ClaimTransactionID=PCT.ClaimTransactionID
WHERE ClaimTransactionTypeCode='ADJ' AND PCT.ClaimTransactionID IS NULL

ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL

CREATE INDEX IX_ClaimTransaction_PaymentID
ON ClaimTransaction (PaymentID)
GO

UPDATE CA SET PaymentID=CT.PaymentID
FROM ClaimTransaction CT INNER JOIN ClaimAccounting CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimTransactionID=CA.ClaimTransactionID
WHERE CT.PaymentID IS NOT NULL

GO

CREATE INDEX IX_ClaimAccounting_PaymentID
ON ClaimAccounting (PaymentID)

GO

-- Get rid of the Denial Reason table
DROP TABLE PaymentDenialReason

GO

---=================================
/*--------------------------------------------------------------------------------
 Case 14471, 14468, 14469
--------------------------------------------------------------------------------*/
ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL

CREATE TABLE #PayClaims(PaymentID INT, PracticeID INT, PatientID INT, EncounterID INT, ClaimID INT, EOBXml XML, Notes VARCHAR(MAX), Charge MONEY, ClaimTransactionID INT, InsurancePolicyID INT, Precedence INT,
						ADJAmount MONEY, ADJ_Code VARCHAR(10))
INSERT INTO #PayClaims(PaymentID, PracticeID, PatientID, EncounterID, ClaimID, Charge)
SELECT DISTINCT PCT.PaymentID, PCT.PracticeID, C.PatientID, EP.EncounterID, C.ClaimID, 
CEILING((ISNULL(EP.ServiceUnitCount,0)*ISNULL(EP.ServiceChargeAmount,0))*100)/100 Charge
FROM PaymentClaimTransaction PCT INNER JOIN Claim C
ON PCT.PracticeID=C.PracticeID AND PCT.ClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP
ON C.EncounterProcedureID=EP.EncounterProcedureID

CREATE TABLE #PayClaims_FirstADJ(PaymentID INT, ClaimID INT, ClaimTransactionID INT, Code VARCHAR(10), Amount MONEY)
INSERT INTO #PayClaims_FirstADJ(PaymentID, ClaimID, ClaimTransactionID, Code, Amount)
SELECT PC.PaymentID, CT.ClaimID, CT.ClaimTransactionID, CT.Code, CT.Amount
FROM #PayClaims PC INNER JOIN ClaimTransaction CT
ON PC.PracticeID=CT.PracticeID AND PC.ClaimiD=CT.ClaimID AND PC.PaymentID=CT.ReferenceID 
AND CT.ClaimTransactionTypeCode='ADJ'

CREATE TABLE #PC_FirstADJ_ID(PaymentID INT, ClaimID INT, ClaimTransactionID INT)
INSERT INTO #PC_FirstADJ_ID(PaymentID, ClaimID, ClaimTransactionID)
SELECT PaymentID, ClaimID, MIN(ClaimTransactionID)
FROM #PayClaims_FirstADJ
GROUP BY PaymentID, ClaimID

UPDATE PC SET ADJAmount=PCFA.Amount, ADJ_Code=PCFA.Code
FROM #PayClaims PC INNER JOIN #PC_FirstADJ_ID PCFAID
ON PC.PaymentID=PCFAID.PaymentID AND PC.ClaimID=PCFAID.ClaimID
INNER JOIN #PayClaims_FirstADJ PCFA
ON PCFAID.PaymentID=PCFA.PaymentID AND PCFAID.ClaimID=PCFA.ClaimID AND PCFAID.ClaimTransactionID=PCFA.ClaimTransactionID

UPDATE PC SET ClaimTransactionID=CT.ClaimTransactionID
FROM PaymentClaimTransaction PCT INNER JOIN ClaimTransaction CT
ON PCT.PracticeID=CT.PracticeID AND PCT.ClaimTransactionID=CT.ClaimTransactionID
INNER JOIN #PayClaims PC
ON CT.ClaimID=PC.ClaimID AND CT.ReferenceID=PC.PaymentID
WHERE CT.ClaimTransactionTypeCode='ALW'

UPDATE PC SET InsurancePolicyID=CAA.InsurancePolicyID
FROM #PayClaims PC INNER JOIN ClaimAccounting_Assignments CAA
ON PC.PracticeID=CAA.PracticeID AND PC.ClaimID=CAA.ClaimID
AND ((PC.ClaimTransactionID BETWEEN CAA.ClaimTransactionID AND CAA.EndClaimTransactionID)
	 OR (PC.ClaimTransactionID>CAA.ClaimTransactionID AND CAA.EndClaimTransactionID IS NULL))

UPDATE PC SET Precedence=IP.Precedence
FROM #PayClaims PC INNER JOIN InsurancePolicy IP
ON PC.PracticeID=IP.PracticeID AND PC.InsurancePolicyID=IP.InsurancePolicyID

UPDATE PC SET Notes=CT.Notes
FROM PaymentClaimTransaction PCT INNER JOIN ClaimTransaction CT
ON PCT.PracticeID=CT.PracticeID AND PCT.ClaimTransactionID=CT.ClaimTransactionID
INNER JOIN #PayClaims PC
ON CT.ClaimID=PC.ClaimID AND CT.ReferenceID=PC.PaymentID
WHERE CT.ClaimTransactionTypeCode='MEM'

UPDATE PC SET EOBXml='<eob xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <items>
	 <stage>'+CAST(CASE WHEN PC.Precedence IS NULL THEN 0 ELSE PC.Precedence END AS VARCHAR)+'</stage>
	 <insurancePolicyID>'+CAST(CASE WHEN PC.InsurancePolicyID IS NULL THEN 0 ELSE PC.InsurancePolicyID END AS VARCHAR)+'</insurancePolicyID>
	 <denial>false</denial>
     <item type="Allowed" amount="'+CAST(CT.Amount AS VARCHAR(15))+'" units="1" category="" code="" description="" />
	 <item type="Reason" amount="'+CAST(ISNULL(PC.ADJAmount,0) AS VARCHAR(15))+'" units="1" category="CO" code="'+PC.ADJ_Code+'" description="A2" />
  </items>
</eob>'
FROM ClaimTransaction CT INNER JOIN #PayClaims PC
ON CT.PracticeID=PC.PracticeID AND CT.ClaimID=PC.ClaimID AND CT.ClaimTransactionID=PC.ClaimTransactionID
WHERE CT.Amount<>0

UPDATE PC SET EOBXml='<eob xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <items>
	 <stage>'+CAST(CASE WHEN PC.Precedence IS NULL THEN 0 ELSE PC.Precedence END AS VARCHAR)+'</stage>
	 <insurancePolicyID>'+CAST(CASE WHEN PC.InsurancePolicyID IS NULL THEN 0 ELSE PC.InsurancePolicyID END AS VARCHAR)+'</insurancePolicyID>
	 <denial>true</denial>
	 <item type="Denial" amount="0" category="" description="" />
     <item type="Reason" amount="'+CAST(PC.Charge AS VARCHAR(15))+'" units="1" category="CO" code="" description="'+CAST(CT.Code AS VARCHAR)+'" />
  </items>
</eob>'
FROM ClaimTransaction CT INNER JOIN #PayClaims PC
ON CT.PracticeID=PC.PracticeID AND CT.ClaimID=PC.ClaimID AND CT.ClaimTransactionID=PC.ClaimTransactionID
WHERE CT.Amount=0

CREATE TABLE #PayEncounters(PaymentID INT, PracticeID INT, PatientID INT, EncounterID INT)
INSERT INTO #PayEncounters(PaymentID, PracticeID, PatientID, EncounterID)
SELECT DISTINCT PaymentID, PracticeID, PatientID, EncounterID
FROM #PayClaims

CREATE TABLE #PayPatient(PaymentID INT, PracticeID INT, PatientID INT)
INSERT INTO #PayPatient(PaymentID, PracticeID, PatientID)
SELECT DISTINCT PaymentID, PracticeID, PatientID
FROM #PayEncounters

INSERT INTO PaymentPatient(PaymentID, PracticeID, PatientID)
SELECT PP.PaymentID, PP.PracticeID, PP.PatientID 
FROM #PayPatient PP LEFT JOIN PaymentPatient PayP
ON PP.PaymentID=PayP.PaymentID AND PP.PatientID=PayP.PatientID
WHERE PayP.PatientID IS NULL

INSERT INTO PaymentEncounter(PaymentID, PracticeID, PatientID, EncounterID)
SELECT PaymentID, PracticeID, PatientID, EncounterID
FROM #PayEncounters

INSERT INTO PaymentClaim(PaymentID, PracticeID, PatientID, EncounterID, ClaimID, EOBXML, Notes)
SELECT PaymentID, PracticeID, PatientID, EncounterID, ClaimID, EOBXML, Notes
FROM #PayClaims

-- Indexes for the eobXML
SET ARITHABORT ON
GO
SET CONCAT_NULL_YIELDS_NULL ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET ANSI_PADDING ON
GO
SET ANSI_WARNINGS ON
GO
SET NUMERIC_ROUNDABORT OFF
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PaymentClaim]') AND name = N'IX_PaymentClaim_eobXML')
DROP INDEX [IX_PaymentClaim_eobXML] ON [dbo].[PaymentClaim]
GO

CREATE PRIMARY XML INDEX [IX_PaymentClaim_eobXML] ON [dbo].[PaymentClaim] 
(
	[EOBXml]
)WITH (PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF)
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PaymentClaim]') AND name = N'IX_PaymentClaim_eobXML_Path')
DROP INDEX [IX_PaymentClaim_eobXML_Path] ON [dbo].[PaymentClaim]
GO

CREATE XML INDEX [IX_PaymentClaim_eobXML_Path] ON [dbo].[PaymentClaim] (eobXML)
USING XML INDEX [IX_PaymentClaim_eobXML]
FOR PATH
GO

DELETE PCT
FROM ClaimTransaction CT INNER JOIN PaymentClaimTransaction PCT
ON CT.PracticeID=PCT.PracticeID AND CT.ClaimTransactionID=PCT.ClaimTransactionID
WHERE ClaimTransactionTypeCode='ALW'

--Get Rid of ALWs
DELETE ClaimTransaction
WHERE ClaimTransactionTypeCode='ALW'

DELETE PCT
FROM ClaimTransaction CT INNER JOIN PaymentClaimTransaction PCT
ON CT.PracticeID=PCT.PracticeID AND CT.ClaimTransactionID=PCT.ClaimTransactionID
WHERE ClaimTransactionTypeCode='MEM'

--Get Rid of Payment related Claim Memo
DELETE CT
FROM PaymentClaimTransaction PCT INNER JOIN ClaimTransaction CT
ON PCT.PracticeID=CT.PracticeID AND PCT.ClaimTransactionID=CT.ClaimTransactionID
WHERE CT.ClaimTransactionTypeCode='MEM'

DROP TABLE #PayClaims
DROP TABLE #PayClaims_FirstADJ
DROP TABLE #PC_FirstADJ_ID
DROP TABLE #PayEncounters
DROP TABLE #PayPatient

ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL

DROP TABLE PaymentClaimTransaction

INSERT INTO ClaimTransactionType(ClaimTransactionTypeCode, TypeName)
VALUES('PRC','Patient Responsibility - Copay')

INSERT INTO ClaimTransactionType(ClaimTransactionTypeCode, TypeName)
VALUES('REO','Reopen Claim')

INSERT INTO ClaimTransactionType(ClaimTransactionTypeCode, TypeName)
VALUES('CLS','Prior Settle Transaction Notation')

GO

/*---------------------------------------------------------------------------------
 Case 15753:	Add NPI and facility ID type to the ServiceLocation table.
---------------------------------------------------------------------------------*/

ALTER TABLE ServiceLocation
	ADD	NPI VARCHAR(10),
		FacilityIDType INT NOT NULL CONSTRAINT DF_ServiceLocation_FacilityIDType DEFAULT 28 WITH VALUES

ALTER TABLE ServiceLocation
	ADD CONSTRAINT FK_ServiceLocation_FacilityIDType FOREIGN KEY (FacilityIDType) REFERENCES GroupNumberType (GroupNumberTypeID)

GO

/*--------------------------------------------------------------------------------------------
 Case 14920: 	Anesthesia: Add "Anesthesia time increment" field to Contract details screen 
--------------------------------------------------------------------------------------------*/

ALTER TABLE dbo.[Contract] ADD AnesthesiaTimeIncrement INT NOT NULL DEFAULT 0
GO

/*--------------------------------------------------------------------------------------------
 Case 14533:	Add new "scheduling provider" field to encounter details to track mid-levels 
---------------------------------------------------------------------------------------------*/
ALTER TABLE dbo.Encounter
	ADD SchedulingProviderID INT NULL,
	CONSTRAINT FK_Encounter_SchedulingProviderID_Doctor_DoctorID 
	FOREIGN KEY (SchedulingProviderID) REFERENCES Doctor (DoctorID)
GO
UPDATE dbo.Encounter
SET SchedulingProviderID = Doctor.DoctorID
FROM Encounter, Doctor 
WHERE Encounter.DoctorID = Doctor.DoctorID
GO

/*--------------------------------------------------------------------------------------------
 Case 15815:	Rework Relationship table to add standard codes and missing
---------------------------------------------------------------------------------------------*/
ALTER TABLE Relationship ADD IndividualRelationshipCode char(2)
GO

UPDATE Relationship SET IndividualRelationshipCode = '19' WHERE Relationship = 'C'
UPDATE Relationship SET IndividualRelationshipCode = 'G8' WHERE Relationship = 'O'
UPDATE Relationship SET IndividualRelationshipCode = '18' WHERE Relationship = 'S'
UPDATE Relationship SET IndividualRelationshipCode = '01' WHERE Relationship = 'U'
GO

ALTER TABLE Relationship ALTER COLUMN IndividualRelationshipCode  char(2) NOT NULL
GO



/*---------------------------------------------------------------------------------------------------
CASE 14529
----------------------------------------------------------------------------------------------------*/
CREATE TABLE dbo.ProcedureCodeCategory(
	ProcedureCodeCategoryID int IDENTITY(1,1) NOT NULL,
	ProcedureCodeCategoryName varchar(128)  NOT NULL,
	Description varchar(500) NULL,
	Notes text NULL,
	CreatedDate DateTime,
	CreatedUserID int,
	ModifiedDate DateTime,
	ModifiedUserID int,
	RecordTimeStamp timestamp
 CONSTRAINT PK_ProcedureCodeCategory PRIMARY KEY NONCLUSTERED 
(
	ProcedureCodeCategoryID 
)) 
GO


ALTER TABLE dbo.ProcedureCodeDictionary  ADD  
ProcedureCodeCategoryID INT NULL, 
CONSTRAINT FK_ProcedureCodeDictionary_ProcedureCodeCategory FOREIGN KEY(ProcedureCodeCategoryID)
REFERENCES dbo.ProcedureCodeCategory (ProcedureCodeCategoryID)
GO






---------------------------------------------------------------------------------
-- Case 15539:   Develop Migrate script for copay
---------------------------------------------------------------------------------

--Add New Triggers via migration to allow the script below to properly work

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_RoundUpToPenny]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_RoundUpToPenny]
GO

CREATE FUNCTION [dbo].[fn_RoundUpToPenny](@amount decimal(23, 8) )
RETURNS MONEY AS
BEGIN

    RETURN CEILING( @amount * 100 ) / 100
END

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'tr_ClaimTransaction_MaintainClaimAccounting_Update'
	AND	TYPE = 'TR'
)
	DROP TRIGGER dbo.tr_ClaimTransaction_MaintainClaimAccounting_Update
GO

CREATE TRIGGER tr_ClaimTransaction_MaintainClaimAccounting_Update
ON ClaimTransaction
FOR UPDATE

AS

BEGIN
	IF EXISTS(SELECT * FROM Inserted WHERE ClaimTransactionTypeCode='CLS')
	BEGIN
		DECLARE @EndTrans TABLE (ClaimID INT)
		INSERT INTO @EndTrans(ClaimID)
		SELECT ClaimID
		FROM Inserted 
		WHERE ClaimTransactionTypeCode='CLS'

		DELETE CA
		FROM Inserted I INNER JOIN ClaimAccounting CA
		ON I.ClaimTransactionID=CA.ClaimTransactionID
		WHERE I.ClaimTransactionTypeCode='CLS'

		UPDATE CA SET Status=0
		FROM ClaimAccounting CA INNER JOIN @EndTrans ET
		ON CA.ClaimID=ET.ClaimID
	
		UPDATE CAB SET Status=0
		FROM ClaimAccounting_Billings CAB INNER JOIN @EndTrans ET
		ON CAB.ClaimID=ET.ClaimID

		UPDATE CAA SET Status=0
		FROM ClaimAccounting_Assignments CAA INNER JOIN @EndTrans ET
		ON CAA.ClaimID=ET.ClaimID

		UPDATE CAP SET DKEndPostingDateID=NULL
		FROM ClaimAccounting_ClaimPeriod CAP INNER JOIN @EndTrans ET
		ON CAP.ClaimID=ET.ClaimID
	END

	--Single record update
	IF (SELECT COUNT(*) FROM Inserted)=1
	BEGIN
		DECLARE @ClaimTransactionTypeCode VARCHAR(3)
		DECLARE @PracticeID INT
		DECLARE @PostingDate DATETIME
		DECLARE @ClaimID INT
		DECLARE @Claim_ProviderID INT
		DECLARE @ClaimTransactionID INT
		DECLARE @ProcedureCount DECIMAL(19,4)
		DECLARE @Amount MONEY
		DECLARE @CreatedUserID INT
		DECLARE @PaymentID INT
		
		--CST transactions are never modified unless the claims ServiceUnitCount or 
		--ServiceChargeAmount's are modified
		--In this case update ClaimAccounting ProcedureCount and Amount for CST
		--and update first BLL transaction's ARAmount if billed
		SELECT @ClaimTransactionTypeCode=ClaimTransactionTypeCode,
		@PracticeID=PracticeID, 
		@ClaimID=ClaimID,
		@Claim_ProviderID=Claim_ProviderID,
		@ClaimTransactionID=ClaimTransactionID,
		@Amount=Amount,
		@PostingDate=CAST(CONVERT(CHAR(10),PostingDate, 110) AS SMALLDATETIME),
		@CreatedUserID=CreatedUserID,
		@PaymentID=PaymentID
		FROM Inserted

		IF @ClaimTransactionTypeCode='CST'
		BEGIN
			SELECT @ProcedureCount=EP.ServiceUnitCount
			FROM EncounterProcedure EP INNER JOIN Claim C ON EP.EncounterProcedureID=C.EncounterProcedureID
			WHERE EP.PracticeID=@PracticeID AND ClaimID=@ClaimID

			UPDATE ClaimAccounting SET ProcedureCount=@ProcedureCount, Amount=@Amount, ProviderID=@Claim_ProviderID,
			PostingDate=@PostingDate, CreatedUserID=@CreatedUserID
			WHERE PracticeID=@PracticeID AND ClaimID=@ClaimID 
			      AND ClaimTransactionID=@ClaimTransactionID

			UPDATE ClaimAccounting SET ARAmount=@Amount
			WHERE PracticeID=@PracticeID AND ClaimID=@ClaimID AND ClaimTransactionTypeCode='BLL'

			UPDATE ClaimAccounting_ClaimPeriod SET DKInitialPostingDateID=dbo.fn_GetDateKeySelectivityID(@PracticeID,@PostingDate,0,0)
			WHERE ClaimID=@ClaimID
		END

		--IF transaction updated is PAY, ADJ, or END, then
		--check if Amount was updated and update related ClaimAccounting record
		IF EXISTS (SELECT *
				FROM Inserted
				WHERE ClaimTransactionTypeCode IN ('PAY','ADJ','END'))
		BEGIN
			IF UPDATE(Amount)
			BEGIN
				UPDATE CA SET Amount=I.Amount, ARAmount=CASE WHEN ARAmount<>0 THEN -1*I.Amount ELSE 0 END,
				ProviderID=@Claim_ProviderID, PostingDate=@PostingDate, CreatedUserID=@CreatedUserID,
				PaymentID=@PaymentID
				FROM ClaimAccounting CA INNER JOIN Inserted I
				ON CA.PracticeID=I.PracticeID AND CA.ClaimTransactionID=I.ClaimTransactionID

				UPDATE CAP SET DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(I.PracticeID,I.PostingDate,0,0)
				FROM ClaimAccounting_ClaimPeriod CAP INNER JOIN Inserted I
				ON CAP.ClaimID=I.ClaimID
				WHERE I.ClaimTransactionTypeCode='END'
			END
			ELSE
			BEGIN
				RETURN
			END
		END

		IF @ClaimTransactionTypeCode='ASN'
		BEGIN
			IF UPDATE(ReferenceID)
			BEGIN
				UPDATE CAA SET InsurancePolicyID=ReferenceID, InsuranceCompanyPlanID=IP.InsuranceCompanyPlanID
				FROM ClaimAccounting_Assignments CAA INNER JOIN Inserted I
				ON CAA.PracticeID=I.PracticeID AND CAA.ClaimTransactionID=I.ClaimTransactionID
				LEFT JOIN InsurancePolicy IP ON I.ReferenceID=IP.InsurancePolicyID
			END
			ELSE
			BEGIN
				RETURN
			END
		END
	END

-- 	--If multiple rows updated
	ELSE
	BEGIN
		--IF transaction updated is PAY, ADJ, or END, then
		--check if Amount was updated and update related ClaimAccounting record
		UPDATE CA SET Amount=I.Amount, ARAmount=CASE WHEN ARAmount<>0 THEN -1*I.Amount ELSE 0 END,
		ProviderID=I.Claim_ProviderID, PostingDate=CAST(CONVERT(CHAR(10),I.PostingDate, 110) AS SMALLDATETIME),
		CreatedUserID=I.CreatedUserID, PaymentID=I.PaymentID
		FROM ClaimAccounting CA INNER JOIN Inserted I
		ON CA.PracticeID=I.PracticeID AND CA.ClaimTransactionID=I.ClaimTransactionID
		WHERE CA.ClaimTransactionTypeCode IN ('PAY','ADJ','END')

		--Assignment's Update
		UPDATE CAA SET InsurancePolicyID=ReferenceID, InsuranceCompanyPlanID=IP.InsuranceCompanyPlanID
		FROM ClaimAccounting_Assignments CAA INNER JOIN Inserted I
		ON CAA.PracticeID=I.PracticeID AND CAA.ClaimTransactionID=I.ClaimTransactionID
		LEFT JOIN InsurancePolicy IP ON I.ReferenceID=IP.InsurancePolicyID
		WHERE I.ClaimTransactionTypeCode='ASN'

		--Update CST and first BLL transacion amounts
		DECLARE @CSTS TABLE(PracticeID INT, PostingDate DATETIME, ClaimID INT, ProviderID INT, ClaimTransactionID INT, Amount MONEY, ProcedureCount DECIMAL(19,4),
							CreatedUserID INT)
		INSERT @CSTS(PracticeID, PostingDate, ClaimID, ProviderID, ClaimTransactionID, Amount, CreatedUserID)
		SELECT PracticeID, PostingDate, ClaimID, Claim_ProviderID ProviderID, ClaimTransactionID, Amount, CreatedUserID
		FROM Inserted
		WHERE ClaimTransactionTypeCode='CST'

		UPDATE @CSTS SET ProcedureCount=EP.ServiceUnitCount
		FROM EncounterProcedure EP INNER JOIN Claim C ON EP.EncounterProcedureID=C.EncounterProcedureID
		INNER JOIN @CSTS CST ON C.ClaimID=CST.ClaimID

		UPDATE CA SET Amount=CST.Amount, ProcedureCount=CST.ProcedureCount, ProviderID=CST.ProviderID,
		PostingDate=CST.PostingDate, CreatedUserID=CST.CreatedUserID
		FROM ClaimAccounting CA INNER JOIN @CSTS CST ON CA.PracticeID=CST.PracticeID
		AND CA.ClaimID=CST.ClaimID AND CA.ClaimTransactionID=CST.ClaimTransactionID

		UPDATE CA SET ARAmount=CST.Amount
		FROM ClaimAccounting CA INNER JOIN @CSTS CST ON CA.PracticeID=CST.PracticeID
		AND CA.ClaimID=CST.ClaimID
		WHERE ClaimTransactionTypeCode='BLL'

		UPDATE CAP SET DKInitialPostingDateID=dbo.fn_GetDateKeySelectivityID(CST.PracticeID,CST.PostingDate,0,0)
		FROM @CSTS CST INNER JOIN ClaimAccounting_ClaimPeriod CAP
		ON CST.ClaimID=CAP.ClaimID
	END

END

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'tr_ClaimTransaction_MaintainClaimAccounting_Delete'
	AND	TYPE = 'TR'
)
	DROP TRIGGER dbo.tr_ClaimTransaction_MaintainClaimAccounting_Delete
GO

CREATE TRIGGER tr_ClaimTransaction_MaintainClaimAccounting_Delete
ON ClaimTransaction
FOR DELETE

AS

BEGIN
	IF EXISTS (SELECT * FROM Deleted WHERE ClaimTransactionTypeCode='XXX')
	BEGIN
		DECLARE @Voids TABLE(ClaimID INT)
		INSERT @Voids(ClaimID)
		SELECT ClaimID
		FROM Deleted 
		WHERE ClaimTransactionTypeCode='XXX'

		CREATE TABLE #OrderedList(PracticeID INT, PostingDate SMALLDATETIME, ClaimID INT, ProviderID INT, PatientID INT,
					  ClaimTransactionID INT, ClaimTransactionTypeCode CHAR(3), Status BIT, ProcedureCount DECIMAL(19,4),
					  Amount MONEY, ARAmount MONEY, Code CHAR(1), CreatedUserID INT, PaymentID INT, FirstBilled BIT)
		INSERT INTO #OrderedList(PracticeID, PostingDate, ClaimID, ProviderID, PatientID,  ClaimTransactionID,
					 ClaimTransactionTypeCode, Status, ProcedureCount, Amount, ARAmount, Code, CreatedUserID,
					 PaymentID)
		SELECT PracticeID, CAST(CONVERT(CHAR(10),PostingDate,110) AS SMALLDATETIME) PostingDate, CT.ClaimID, Claim_ProviderID,
		       PatientID, ClaimTransactionID, ClaimTransactionTypeCode,
		       CASE WHEN ClaimTransactionTypeCode='END' THEN 1 ELSE 0 END Status, 0 ProcedureCount,
		       CASE WHEN ClaimTransactionTypeCode='BLL' THEN 0 ELSE Amount END Amount,
		       0 ARAmount, CASE WHEN ClaimTransactionTypeCode='BLL' THEN Code ELSE NULL END Code, CreatedUserID,
			   PaymentID
		FROM ClaimTransaction CT INNER JOIN @Voids V ON CT.ClaimID=V.ClaimID
		WHERE ClaimTransactionTypeCode IN ('CST','ASN','BLL','PAY','ADJ','END','PRC')
		ORDER BY PracticeID, CAST(CONVERT(CHAR(10),PostingDate,110) AS SMALLDATETIME), Claim_ProviderID, PatientID,
			 CT.ClaimID, CASE WHEN ClaimTransactionTypeCode IN ('CST','ASN') THEN 0
				       WHEN ClaimTransactionTypeCode='PRC' THEN 1
				       WHEN ClaimTransactionTypeCode='BLL' THEN 2
				       WHEN ClaimTransactionTypeCode='PAY' THEN 3
				       WHEN ClaimTransactionTypeCode='ADJ' THEN 4
				       WHEN ClaimTransactionTypeCode='END' THEN 5 END
	
		CREATE TABLE #OLClaims(PracticeID INT, ClaimID INT)
		INSERT INTO #OLClaims(PracticeID, ClaimID)
		SELECT DISTINCT PracticeID, ClaimID
		FROM #OrderedList

		IF EXISTS(SELECT * FROM #OrderedList WHERE ClaimTransactionTypeCode='ASN')
		BEGIN
			DECLARE @ASNClaims TABLE(PracticeID INT, ClaimID INT)
			INSERT @ASNClaims(PracticeID, ClaimID)
			SELECT PracticeID, ClaimID
			FROM #OrderedList
			WHERE ClaimTransactionTypeCode='ASN'

			DECLARE @ASNTrans TABLE(TID INT IDENTITY(1,1), PracticeID INT, NewFlag BIT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME, EndPostingDate DATETIME, LastAssignmentOfEndPostingDate BIT, LastAssignment BIT, EndClaimTransactionID INT)
			INSERT @ASNTrans(PracticeID, NewFlag, ClaimID, ClaimTransactionID, PostingDate, LastAssignmentOfEndPostingDate, LastAssignment)
			SELECT PracticeID, 1, ClaimID, ClaimTransactionID, CAST(CONVERT(CHAR(10),PostingDate,110) AS SMALLDATETIME), 0, 0
			FROM #OrderedList I
			WHERE ClaimTransactionTypeCode='ASN'
			ORDER BY ClaimID, CAST(CONVERT(CHAR(10),PostingDate,110) AS SMALLDATETIME) DESC, ClaimTransactionID DESC

			UPDATE AT1 SET EndPostingDate=AT2.PostingDate, EndClaimTransactionID=AT2.ClaimTransactionID
			FROM @ASNTrans AT1 INNER JOIN  @ASNTrans AT2
			ON AT1.ClaimID=AT2.ClaimID AND AT1.TID=AT2.TID+1

			DECLARE @ASN_FlagsToUpdate TABLE(ClaimID INT, EndPostingDate DATETIME, CTIDToUpdate INT)
			INSERT @ASN_FlagsToUpdate(ClaimID, EndPostingDate, CTIDToUpdate)
			SELECT ClaimID, EndPostingDate, MAX(ClaimTransactionID) CTIDToUpdate
			FROM @ASNTrans
			GROUP BY ClaimID, EndPostingDate

			UPDATE AT SET LastAssignmentOfEndPostingDate=1
			FROM @ASNTrans AT INNER JOIN @ASN_FlagsToUpdate ATU
			ON AT.ClaimID=ATU.ClaimID AND AT.ClaimTransactionID=ATU.CTIDToUpdate

			UPDATE @ASNTrans SET LastAssignment=1
			WHERE EndPostingDate IS NULL

			--Insert Assignments
			INSERT INTO ClaimAccounting_Assignments(PracticeID, PostingDate, ClaimID, ClaimTransactionID, 
													InsurancePolicyID, InsuranceCompanyPlanID, PatientID,
													LastAssignment, EndPostingDate, DKPostingDateID, 
												    DKEndPostingDateID, LastAssignmentOfEndPostingDate, Status, EndClaimTransactionID)
			SELECT CT.PracticeID, CAST(CONVERT(CHAR(10),CT.PostingDate,110) AS SMALLDATETIME), CT.ClaimID, CT.ClaimTransactionID, CT.ReferenceID, IP.InsuranceCompanyPlanID, CT.PatientID, AT.LastAssignment, AT.EndPostingDate, 
			dbo.fn_GetDateKeySelectivityID(CT.PracticeID,CT.PostingDate,0,0), dbo.fn_GetDateKeySelectivityID(AT.PracticeID,AT.EndPostingDate,0,0), AT.LastAssignmentOfEndPostingDate, 0,
			AT.EndClaimTransactionID
			FROM @ASNTrans AT INNER JOIN ClaimTransaction CT 
			ON AT.PracticeID=CT.PracticeID AND AT.ClaimID=CT.ClaimID AND AT.ClaimTransactionID=CT.ClaimTransactionID
			LEFT JOIN InsurancePolicy IP
			ON CT.PracticeID=IP.PracticeID AND CT.ReferenceID=IP.InsurancePolicyID

			UPDATE CAA SET LastAssignment=AT.LastAssignment, EndPostingDate=AT.EndPostingDate, EndClaimTransactionID=AT.EndClaimTransactionID,
			DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(AT.PracticeID,AT.EndPostingDate,0,0),
			LastAssignmentOfEndPostingDate=AT.LastAssignmentOfEndPostingDate
			FROM @ASNTrans AT INNER JOIN ClaimAccounting_Assignments CAA
			ON AT.ClaimID=CAA.ClaimID AND AT.ClaimTransactionID=CAA.ClaimTransactionID
			WHERE NewFlag=0
		END

		CREATE TABLE #OLClaims_BLL(PracticeID INT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME)
		INSERT INTO #OLClaims_BLL(PracticeID, ClaimID, ClaimTransactionID, PostingDate)
		SELECT PracticeID, ClaimID, ClaimTransactionID, PostingDate
		FROM #OrderedList
		WHERE ClaimTransactionTypeCode='BLL'

		CREATE TABLE #OLDenormalizedData(ClaimID INT, EncounterProcedureID INT, ProcedureCount INT)
		INSERT INTO #OLDenormalizedData(ClaimID, EncounterProcedureID, ProcedureCount)
		SELECT OL.ClaimID, EP.EncounterProcedureID, ISNULL(EP.ServiceUnitCount,0) ProcedureCount 
		FROM #OLClaims OL INNER JOIN Claim C
		ON OL.PracticeID=C.PracticeID AND OL.ClaimID=C.ClaimID
		INNER JOIN EncounterProcedure EP
		ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID

		--Update all records with a Status of 1 if claim has been closed
		DECLARE @ClosedItems TABLE(PracticeID INT, ClaimID INT, PostingDate DATETIME)
		INSERT @ClosedItems(PracticeID, ClaimID, PostingDate)
		SELECT PracticeID, ClaimID, PostingDate
		FROM #OrderedList 
		WHERE ClaimTransactionTypeCode='END'

		--Flag those items closed in the insert list
		UPDATE OL SET Status=1
		FROM #OrderedList OL INNER JOIN @ClosedItems CI ON OL.ClaimID=CI.ClaimID

		DECLARE @BLLTrans TABLE(TID INT IDENTITY(1,1), PracticeID INT, NewFlag BIT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME, EndPostingDate DATETIME, 
								LastBilledOfEndPostingDate BIT, LastBilled BIT, FirstBilled BIT, EndClaimTransactionID INT)

		IF EXISTS(SELECT * FROM #OLClaims_BLL)
		BEGIN
			INSERT @BLLTrans(PracticeID, NewFlag, ClaimID, ClaimTransactionID, PostingDate, LastBilledOfEndPostingDate, LastBilled, FirstBilled)
			SELECT C.PracticeID, 0,C.ClaimID, ClaimTransactionID, PostingDate, 0, 0, 0 
			FROM #OLClaims C INNER JOIN ClaimAccounting_Billings CAB
			ON C.PracticeID=CAB.PracticeID AND C.ClaimID=CAB.ClaimID
			UNION
			SELECT OCB.PracticeID, 1, OCB.ClaimID, OCB.ClaimTransactionID, OCB.PostingDate, 0, 0, 0
			FROM #OLClaims_BLL OCB
			ORDER BY ClaimID, PostingDate DESC, ClaimTransactionID DESC

			UPDATE BT1 SET EndPostingDate=BT2.PostingDate, EndClaimTransactionID=BT2.ClaimTransactionID
			FROM @BLLTrans BT1 INNER JOIN  @BLLTrans BT2
			ON BT1.ClaimID=BT2.ClaimID AND BT1.TID=BT2.TID+1

			DECLARE @BLL_FlagsToUpdate TABLE(ClaimID INT, EndPostingDate DATETIME, CTIDToUpdate INT)
			INSERT @BLL_FlagsToUpdate(ClaimID, EndPostingDate, CTIDToUpdate)
			SELECT ClaimID, EndPostingDate, MAX(ClaimTransactionID) CTIDToUpdate
			FROM @BLLTrans
			GROUP BY ClaimID, EndPostingDate

			UPDATE BT SET LastBilledOfEndPostingDate=1
			FROM @BLLTrans BT INNER JOIN @BLL_FlagsToUpdate BTU
			ON BT.ClaimID=BTU.ClaimID AND BT.ClaimTransactionID=BTU.CTIDToUpdate

			UPDATE @BLLTrans SET LastBilled=1
			WHERE EndPostingDate IS NULL

			UPDATE BT SET FirstBilled=1
			FROM @BLLTrans BT INNER JOIN (SELECT ClaimID, MIN(ClaimTransactionID) FBID FROM @BLLTrans GROUP BY ClaimID) FBT
			ON BT.ClaimID=FBT.ClaimID AND BT.ClaimTransactionID=FBT.FBID

			UPDATE OL SET FirstBilled=1
			FROM #OrderedList OL INNER JOIN @BLLTrans BT
			ON OL.ClaimTransactionID=BT.ClaimTransactionID

			UPDATE CAB SET LastBilled=BT.LastBilled, EndPostingDate=BT.EndPostingDate, EndClaimTransactionID=BT.EndClaimTransactionID,
			DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(BT.PracticeID,BT.EndPostingDate,0,0),
			LastBilledOfEndPostingDate=BT.LastBilledOfEndPostingDate
			FROM @BLLTrans BT INNER JOIN ClaimAccounting_Billings CAB
			ON BT.ClaimID=CAB.ClaimID AND BT.ClaimTransactionID=CAB.ClaimTransactionID
			WHERE NewFlag=0

			INSERT INTO ClaimAccounting_Billings(PracticeID, PostingDate, ClaimID, ClaimTransactionID, Batchtype, LastBilled, EndPostingDate, DKPostingDateID, 
												 DKEndPostingDateID, LastBilledOfEndPostingDate, Status, EndClaimTransactionID)
			SELECT OL.PracticeID, OL.PostingDate, OL.ClaimID, OL.ClaimTransactionID, OL.Code, BT.LastBilled, BT.EndPostingDate, 
			dbo.fn_GetDateKeySelectivityID(OL.PracticeID,OL.PostingDate,0,0), dbo.fn_GetDateKeySelectivityID(BT.PracticeID,BT.EndPostingDate,0,0), BT.LastBilledOfEndPostingDate,
			OL.Status, BT.EndClaimTransactionID
			FROM #OrderedList OL INNER JOIN @BLLTrans BT
			ON OL.ClaimID=BT.ClaimID AND OL.ClaimTransactionID=BT.ClaimTransactionID
			WHERE BT.NewFlag=1
		END

		--Delete Voided Claims
		DELETE OL
		FROM #OrderedList OL INNER JOIN VoidedClaims VC 
		ON OL.ClaimID=VC.ClaimID

		--After determining the first bills, check if other claims are in the billing cycle
		--for proper updating of ADJ, PAY, and END transaction amount into ClaimAccounting
		DECLARE @PrevBLLs TABLE (ClaimID INT)
		INSERT @PrevBLLs(ClaimID)
		SELECT DISTINCT ClaimID
		FROM @BLLTrans
		WHERE NewFlag=0 AND FirstBilled=1

		--Delete all BLL except those flagged as First Billing for Claim
		DELETE OL
		FROM #OrderedList OL INNER JOIN @BLLTrans BT
		ON OL.ClaimID=BT.ClaimID AND OL.ClaimTransactionID=BT.ClaimTransactionID
		WHERE BT.FirstBilled<>1	

		--Get Previous Claim transactions pre first bill that lower the AR Amount upon
		--first bill
		DECLARE @AdjToAR TABLE (ClaimID INT, Amount MONEY)
		INSERT @AdjToAR(ClaimID, Amount)
		SELECT CT.ClaimID, SUM(CT.Amount) Amount
		FROM ClaimTransaction CT INNER JOIN #OrderedList FB ON CT.ClaimID=FB.ClaimID AND FB.FirstBilled=1
		AND CT.ClaimTransactionTypeCode IN ('PAY','ADJ') 
		      AND CT.ClaimTransactionID<FB.ClaimTransactionID
		GROUP BY CT.ClaimID
		
		--Use @FirstBLLs result to set ARAmounts
		DECLARE @ClaimAmounts TABLE(ClaimID INT, Amount MONEY)
		INSERT @ClaimAmounts(ClaimID, Amount)
		SELECT CT.ClaimID, CT.Amount
		FROM ClaimTransaction CT INNER JOIN #OrderedList FB ON CT.ClaimID=FB.ClaimID AND FirstBilled=1
		AND CT.ClaimTransactionTypeCode='CST'
		
		UPDATE OL SET ARAmount=ClmA.Amount
		FROM #OrderedList OL INNER JOIN #OrderedList FB ON OL.ClaimTransactionID=FB.ClaimTransactionID  AND FB.FirstBilled=1
		INNER JOIN @ClaimAmounts ClmA ON FB.ClaimID=ClmA.ClaimID

		--Adjust ARAmounts by any ADJ or Payments which occured pre first billing
		UPDATE OL SET ARAmount=OL.ARAmount-ISNULL(ATA.Amount,0)
		FROM #OrderedList OL INNER JOIN #OrderedList FB ON OL.ClaimTransactionID=FB.ClaimTransactionID  AND FB.FirstBilled=1
		INNER JOIN @AdjToAR ATA ON FB.ClaimID=ATA.ClaimID
		
		--SET PAY, ADJ, END ARAmounts
		--Take into Consideration only trans after first bill
		UPDATE OL SET ARAmount=-1*OL.Amount
		FROM #OrderedList OL INNER JOIN #OrderedList FB ON OL.ClaimID=FB.ClaimID AND FB.FirstBilled=1
		WHERE OL.ClaimTransactionTypeCode NOT IN ('CST','BLL','PRC')
		      AND OL.ClaimTransactionID>FB.ClaimTransactionID

		--set those trans previously billed
		UPDATE OL SET ARAmount=-1*Amount
		FROM #OrderedList OL INNER JOIN @PrevBLLs PB ON OL.ClaimID=PB.ClaimID
		WHERE ClaimTransactionTypeCode NOT IN ('CST','BLL','PRC')  

		--Insert ClaimAccounting Records
		INSERT INTO ClaimAccounting(PracticeID, ClaimID, ProviderID, PatientID,  ClaimTransactionID,
					    ClaimTransactionTypeCode, Status, ProcedureCount, Amount, ARAmount, PostingDate,
						CreatedUserID, PaymentID, EncounterProcedureID) 
		SELECT OL.PracticeID, OL.ClaimID, OL.ProviderID, OL.PatientID,  OL.ClaimTransactionID,
		       OL.ClaimTransactionTypeCode, OL.Status, DD.ProcedureCount, OL.Amount, OL.ARAmount, OL.PostingDate,
			   OL.CreatedUserID, OL.PaymentID, DD.EncounterProcedureID
		FROM #OrderedList OL INNER JOIN #OLDenormalizedData DD
		ON OL.ClaimID=DD.ClaimID

		--Update/Insert ClaimAccounting_ClaimPeriod Records
		UPDATE CP SET DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(CI.PracticeID,CI.PostingDate,0,0)
		FROM @ClosedItems CI INNER JOIN ClaimAccounting_ClaimPeriod CP
		ON CI.ClaimID=CP.ClaimID

		INSERT INTO ClaimAccounting_ClaimPeriod(ProviderID, PatientID, ClaimID, DKInitialPostingDateID)
		SELECT OL.ProviderID, OL.PatientID, OL.ClaimID, dbo.fn_GetDateKeySelectivityID(OL.PracticeID,OL.PostingDate,0,0)
		FROM #OrderedList OL
		WHERE ClaimTransactionTypeCode='CST'

		--Flag those items closed in the table that also need updating
		UPDATE CA SET Status=1
		FROM ClaimAccounting CA INNER JOIN @ClosedItems CI ON CA.ClaimID=CI.ClaimID

		UPDATE CAA SET Status=1
		FROM ClaimAccounting_Assignments CAA INNER JOIN @ClosedItems CI ON CAA.ClaimID=CI.ClaimID

		UPDATE CAB SET Status=1
		FROM ClaimAccounting_Billings CAB INNER JOIN @ClosedItems CI ON CAB.ClaimID=CI.ClaimID

		DROP TABLE #OrderedList
		DROP TABLE #OLClaims
		DROP TABLE #OLClaims_BLL
		DROP TABLE #OLDenormalizedData
	END

	--CASE 7301 Deleting END Transaction does not reset Status Field on ClaimAccounting Tables
	IF EXISTS(SELECT * FROM Deleted WHERE ClaimTransactionTypeCode='END')
	BEGIN
		DECLARE @EndTrans TABLE (ClaimID INT)
		INSERT INTO @EndTrans(ClaimID)
		SELECT ClaimID
		FROM Deleted 
		WHERE ClaimTransactionTypeCode='END'

		UPDATE CA SET Status=0
		FROM ClaimAccounting CA INNER JOIN @EndTrans ET
		ON CA.ClaimID=ET.ClaimID
	
		UPDATE CAB SET Status=0
		FROM ClaimAccounting_Billings CAB INNER JOIN @EndTrans ET
		ON CAB.ClaimID=ET.ClaimID

		UPDATE CAA SET Status=0
		FROM ClaimAccounting_Assignments CAA INNER JOIN @EndTrans ET
		ON CAA.ClaimID=ET.ClaimID

		UPDATE CAP SET DKEndPostingDateID=NULL
		FROM ClaimAccounting_ClaimPeriod CAP INNER JOIN @EndTrans ET
		ON CAP.ClaimID=ET.ClaimID
		
	END

	DELETE CA
	FROM ClaimAccounting CA INNER JOIN Deleted D ON
	CA.PracticeID=D.PracticeID AND CA.ClaimTransactionID=D.ClaimTransactionID

	IF EXISTS (SELECT * FROM Deleted WHERE ClaimTransactionTypeCode='ASN')
	BEGIN
		DECLARE @ASNClaimIDs TABLE(PracticeID INT, ClaimID INT)
		INSERT @ASNClaimIDs(PracticeID, ClaimID)
		SELECT DISTINCT PracticeID, ClaimID
		FROM Deleted

		DELETE CAA
		FROM ClaimAccounting_Assignments CAA INNER JOIN Deleted D ON
		CAA.PracticeID=D.PracticeID AND CAA.ClaimTransactionID=D.ClaimTransactionID

		DECLARE @LASTASNs TABLE(PracticeID INT, ClaimID INT, ClaimTransactionID INT)
		INSERT @LASTASNs(PracticeID, ClaimID, ClaimTransactionID)
		SELECT CAA.PracticeID, CAA.ClaimID, MAX(CAA.ClaimTransactionID) ClaimTransactionID
		FROM @ASNClaimIDs AC INNER JOIN ClaimAccounting_Assignments CAA
		ON AC.PracticeID=CAA.PracticeID AND AC.ClaimID=CAA.ClaimID
		GROUP BY CAA.PracticeID, CAA.ClaimID

		UPDATE CAA SET LastAssignment=1, LastAssignmentOfEndPostingDate=1, EndPostingDate=NULL, DKEndPostingDateID=NULL,
					   EndClaimTransactionID=NULL
		FROM @LASTASNs LA INNER JOIN ClaimAccounting_Assignments CAA
		ON LA.PracticeID=CAA.PracticeID AND LA.ClaimID=CAA.ClaimID AND LA.ClaimTransactionID=CAA.ClaimTransactionID
	END

	IF EXISTS (SELECT * FROM Deleted WHERE ClaimTransactionTypeCode='BLL')
	BEGIN
		DECLARE @BLLClaims TABLE(PracticeID INT, ClaimID INT)
		INSERT @BLLClaims(PracticeID, ClaimID)
		SELECT DISTINCT PracticeID, ClaimID
		FROM Deleted

		DELETE CAB
		FROM ClaimAccounting_Billings CAB INNER JOIN Deleted D ON
		CAB.PracticeID=D.PracticeID AND CAB.ClaimTransactionID=D.ClaimTransactionID

		DECLARE @LASTBLLs TABLE(PracticeID INT, ClaimID INT, ClaimTransactionID INT)
		INSERT @LASTBLLs(PracticeID, ClaimID, ClaimTransactionID)
		SELECT CAB.PracticeID, CAB.ClaimID, MAX(CAB.ClaimTransactionID) ClaimTransactionID
		FROM @BLLClaims BC INNER JOIN ClaimAccounting_Billings CAB
		ON BC.PracticeID=CAB.PracticeID AND BC.ClaimID=CAB.ClaimID
		GROUP BY CAB.PracticeID, CAB.ClaimID

		UPDATE CAB SET LastBilled=1, LastBilledOfEndPostingDate=1, EndPostingDate=NULL, DKEndPostingDateID=NULL,
					   EndClaimTransactionID=NULL
		FROM @LASTBLLs LB INNER JOIN ClaimAccounting_Billings CAB
		ON LB.PracticeID=CAB.PracticeID AND LB.ClaimID=CAB.ClaimID AND LB.ClaimTransactionID=CAB.ClaimTransactionID
	END

	IF EXISTS (SELECT * FROM Deleted WHERE ClaimTransactionTypeCode='RES')
	BEGIN
		DELETE PC
		FROM Deleted D INNER JOIN PaymentClaim PC
		ON D.PaymentID=PC.PaymentID AND D.ClaimID=PC.ClaimID
		WHERE D.ClaimTransactionTypeCode='RES'
	END

	IF EXISTS(SELECT * FROM Deleted WHERE ClaimTransactionTypeCode='PRC')
	BEGIN
		DECLARE @PRC_Changes TABLE(PracticeID INT, EncounterProcedureID INT, CopayAmountDelta MONEY)
		INSERT @PRC_Changes(PracticeID, EncounterProcedureID, CopayAmountDelta)
		SELECT D.PracticeID, C.EncounterProcedureID, SUM(Amount) CopayAmountDelta
		FROM Deleted D INNER JOIN Claim C
		ON D.PracticeID=C.PracticeID AND D.ClaimID=C.ClaimID
		WHERE ClaimTransactionTypeCode='PRC'
		GROUP BY D.PracticeID, C.EncounterProcedureID

		UPDATE EP SET CopayAmount=CopayAmount-CopayAmountDelta
		FROM @PRC_Changes PC INNER JOIN EncounterProcedure EP
		ON PC.PracticeID=EP.PracticeID AND PC.EncounterProcedureID=EP.EncounterProcedureID
		
	END

	--CASE 14541
	INSERT INTO CT_Deletions(ClaimTransactionID, ClaimTransactionTypeCode, ClaimID, Amount, Quantity, Code, ReferenceID,
						 ReferenceData, CreatedDate, ModifiedDate, PatientID, PracticeID, BatchKey, Original_ClaimTransactionID,
						 Claim_ProviderID, PostingDate, CreatedUserID, ModifiedUserID)
	SELECT ClaimTransactionID, ClaimTransactionTypeCode, ClaimID, Amount, Quantity, Code, ReferenceID,
	ReferenceData, CreatedDate, ModifiedDate, PatientID, PracticeID, BatchKey, Original_ClaimTransactionID,
	Claim_ProviderID, PostingDate, CreatedUserID, ModifiedUserID
	FROM Deleted
END

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'tr_ClaimTransaction_MaintainClaimAccounting_Insert'
	AND	TYPE = 'TR'
)
	DROP TRIGGER dbo.tr_ClaimTransaction_MaintainClaimAccounting_Insert
GO

CREATE TRIGGER tr_ClaimTransaction_MaintainClaimAccounting_Insert
ON ClaimTransaction
FOR INSERT

AS

BEGIN
	IF (SELECT COUNT(*) FROM Inserted)=1
	BEGIN
		DECLARE @ClaimTransactionTypeCode CHAR(3)
		DECLARE @PracticeID INT
		DECLARE @PostingDate SMALLDATETIME
		DECLARE @ClaimID INT
		DECLARE @ProviderID INT
		DECLARE @PatientID INT
		DECLARE @ClaimTransactionID INT
		DECLARE @InsurancePolicyID INT
		DECLARE @InsuranceCompanyPlanID INT
		DECLARE @Status BIT
		DECLARE @ProcedureCount DECIMAL(19,4)
		DECLARE @Amount MONEY
		DECLARE @ARAmount MONEY
		DECLARE @Code CHAR(1)
		DECLARE @CreatedUserID INT
		DECLARE @PaymentID INT

		DECLARE @EncounterProcedureID INT

		IF EXISTS(SELECT * FROM Inserted WHERE ClaimTransactionTypeCode IN ('CST','BLL','PAY','ADJ','END','PRC'))
		BEGIN
			SELECT @ClaimTransactionTypeCode=ClaimTransactionTypeCode,
			@PracticeID=PracticeID, @PostingDate=CAST(CONVERT(CHAR(10),PostingDate, 110) AS SMALLDATETIME),
			@ClaimID=ClaimID, @ProviderID=Claim_ProviderID, @PatientID=PatientID,
			@ClaimTransactionID=ClaimTransactionID, 
			@Status=CASE WHEN ClaimTransactionTypeCode='END' THEN 1 ELSE 0 END,
			@Amount=Amount, @ARAmount=Amount,
			@Code=CASE WHEN ClaimTransactionTypeCode='BLL' THEN Code ELSE NULL END,
			@CreatedUserID=CreatedUserID,
			@PaymentID=PaymentID
			FROM Inserted

			IF @ClaimTransactionTypeCode='CST'
			BEGIN
				SELECT @ProcedureCount=EP.ServiceUnitCount, @EncounterProcedureID=EP.EncounterProcedureID
				FROM EncounterProcedure EP INNER JOIN Claim C ON EP.EncounterProcedureID=C.EncounterProcedureID
				WHERE EP.PracticeID=@PracticeID AND ClaimID=@ClaimID

				INSERT INTO ClaimAccounting(PracticeID, PostingDate, ClaimID, ProviderID, PatientID, 
							    ClaimTransactionID, ClaimTransactionTypeCode, 
							    Status, ProcedureCount, Amount, ARAmount, CreatedUserID, EncounterProcedureID)
				VALUES(@PracticeID, @PostingDate, @ClaimID, @ProviderID, @PatientID, @ClaimTransactionID,
				       @ClaimTransactionTypeCode, @Status, @ProcedureCount, @Amount, 0, @CreatedUserID, @EncounterProcedureID)
			END

			IF EXISTS(SELECT * FROM Inserted WHERE ClaimTransactionTypeCode IN ('PAY','ADJ','END','PRC'))
			BEGIN
				IF NOT EXISTS(SELECT * FROM ClaimTransaction WHERE ClaimID=@ClaimID AND ClaimTransactionID<@ClaimTransactionID
						   AND ClaimTransactionTypeCode='BLL')
				BEGIN
					SET @ARAmount=0
				END

				SELECT @EncounterProcedureID=EP.EncounterProcedureID
				FROM EncounterProcedure EP INNER JOIN Claim C ON EP.EncounterProcedureID=C.EncounterProcedureID
				WHERE EP.PracticeID=@PracticeID AND ClaimID=@ClaimID
				
				INSERT INTO ClaimAccounting(PracticeID, PostingDate, ClaimID, ProviderID, PatientID, 
							    ClaimTransactionID, ClaimTransactionTypeCode,
							    Status, ProcedureCount, Amount, ARAmount, CreatedUserID, PaymentID, EncounterProcedureID)
				VALUES(@PracticeID, @PostingDate, @ClaimID, @ProviderID, @PatientID, @ClaimTransactionID,
				       @ClaimTransactionTypeCode, @Status, @ProcedureCount, @Amount, 
					   CASE WHEN @ClaimTransactionTypeCode='PRC' THEN 0 ELSE -1*@ARAmount END, @CreatedUserID,
					   @PaymentID, @EncounterProcedureID)
				
				IF @Status=1
				BEGIN
					UPDATE ClaimAccounting SET Status=@Status
					WHERE ClaimID=@ClaimID

					UPDATE ClaimAccounting_Assignments SET Status=@Status
					WHERE ClaimID=@ClaimID
	
					UPDATE ClaimAccounting_Billings SET Status=@Status
					WHERE ClaimID=@ClaimID
				END
				
			END

			IF @ClaimTransactionTypeCode='BLL'
			BEGIN
				SELECT @EncounterProcedureID=EP.EncounterProcedureID
				FROM EncounterProcedure EP INNER JOIN Claim C ON EP.EncounterProcedureID=C.EncounterProcedureID
				WHERE EP.PracticeID=@PracticeID AND ClaimID=@ClaimID

				DECLARE @SetLastBilledEnd BIT

				SET @SetLastBilledEnd=0
	
				IF EXISTS(SELECT * FROM ClaimAccounting_Billings WHERE ClaimID=@ClaimID AND EndPostingDate=@PostingDate)
					SET @SetLastBilledEnd=1

				--Update past transaction LastBilled indicator to 0 (false) because new 
				--billing is new LastBilled
				UPDATE ClaimAccounting_Billings 
				SET EndPostingDate=CASE WHEN LastBilled=1 THEN @PostingDate ELSE EndPostingDate END,
				EndClaimTransactionID=CASE WHEN LastBilled=1 THEN @ClaimTransactionID ELSE EndClaimTransactionID END,
				DKEndPostingDateID=CASE WHEN LastBilled=1 THEN dbo.fn_GetDateKeySelectivityID(@PracticeID,@PostingDate,0,0) ELSE DKEndPostingDateID END,
				LastBilledOfEndPostingDate=
				CASE WHEN EndPostingDate=@PostingDate AND @SetLastBilledEnd=1 AND LastBilled=1 THEN 0 
				ELSE LastBilledOfEndPostingDate END,
				LastBilled=0
				WHERE ClaimID=@ClaimID	

				--Insert into ClaimAccounting_Billings
				INSERT INTO ClaimAccounting_Billings(PracticeID, PostingDate, ClaimID, ClaimTransactionID, BatchType, LastBilled,
													 DKPostingDateID, LastBilledOfEndPostingDate)
				VALUES(@PracticeID, @PostingDate, @ClaimID, @ClaimTransactionID, @Code, 1, dbo.fn_GetDateKeySelectivityID(@PracticeID,@PostingDate,0,0), 1)

				IF NOT EXISTS(SELECT * FROM ClaimAccounting WHERE ClaimID=@ClaimID AND ClaimTransactionID<@ClaimTransactionID
										   AND ClaimTransactionTypeCode='BLL')
				BEGIN
					--Some Claims can get payments and adjustments before ever being billed
					--AR Amount at time of bill should account for this.
					IF EXISTS(SELECT * 
						  FROM ClaimAccounting 
						  WHERE ClaimID=@ClaimID AND ClaimTransactionID<@ClaimTransactionID AND
						  ClaimTransactionTypeCode IN ('PAY','ADJ'))
					BEGIN
						INSERT INTO ClaimAccounting(PracticeID, PostingDate, ClaimID, ProviderID, PatientID, 
									    ClaimTransactionID, ClaimTransactionTypeCode,
									    Status, ProcedureCount, Amount, ARAmount, CreatedUserID, EncounterProcedureID)
						SELECT @PracticeID, @PostingDate, @ClaimID, @ProviderID, @PatientID, @ClaimTransactionID,
						@ClaimTransactionTypeCode, @Status, @ProcedureCount, 0 Amount,
						SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)-SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount ELSE 0 END) ARAmount,
						@CreatedUserID, @EncounterProcedureID
						FROM ClaimAccounting
						WHERE PracticeID=@PracticeID AND ClaimID=@ClaimID
					END
					ELSE
					BEGIN
						INSERT INTO ClaimAccounting(PracticeID, PostingDate, ClaimID, ProviderID, PatientID, 
									    ClaimTransactionID, ClaimTransactionTypeCode,
									    Status, ProcedureCount, Amount, ARAmount, CreatedUserID, EncounterProcedureID)
						SELECT @PracticeID, @PostingDate, @ClaimID, @ProviderID, @PatientID, @ClaimTransactionID,
						@ClaimTransactionTypeCode, @Status, @ProcedureCount, 0 Amount, Amount, @CreatedUserID, @EncounterProcedureID
						FROM ClaimAccounting
						WHERE PracticeID=@PracticeID AND ClaimID=@ClaimID AND ClaimTransactionTypeCode='CST'
					END					

				END
			END
		END
		ELSE
		BEGIN
			IF EXISTS(SELECT * FROM Inserted WHERE ClaimTransactionTypeCode='ASN')
			BEGIN
				--Get Values to Copy To ClaimAccounting_Assignments
				SELECT @PracticeID=PracticeID, @PostingDate=CAST(CONVERT(CHAR(10),PostingDate, 110) AS SMALLDATETIME),
				@ClaimID=ClaimID, @ClaimTransactionID=ClaimTransactionID, @InsurancePolicyID=ReferenceID, @PatientID=PatientID
				FROM Inserted

				DECLARE @SetLastAssignedEnd BIT

				SET @SetLastAssignedEnd=0
	
				IF EXISTS(SELECT * FROM ClaimAccounting_Assignments WHERE ClaimID=@ClaimID AND EndPostingDate=@PostingDate)
					SET @SetLastAssignedEnd=1

				--Update past transaction LastAssigment indicator to 0 (false) because new 
				--assigment is last assigned
				UPDATE ClaimAccounting_Assignments 
				SET EndPostingDate=CASE WHEN LastAssignment=1 THEN @PostingDate ELSE EndPostingDate END,
				EndClaimTransactionID=CASE WHEN LastAssignment=1 THEN @ClaimTransactionID ELSE EndClaimTransactionID END,
				DKEndPostingDateID=CASE WHEN LastAssignment=1 THEN dbo.fn_GetDateKeySelectivityID(@PracticeID,@PostingDate,0,0) ELSE DKEndPostingDateID END,
				LastAssignmentOfEndPostingDate=
				CASE WHEN EndPostingDate=@PostingDate AND @SetLastAssignedEnd=1 AND LastAssignment=1 THEN 0 
				ELSE LastAssignmentOfEndPostingDate END,
				LastAssignment=0
				WHERE ClaimID=@ClaimID					
		
				--Populate InsuranceCompanyPlanID if this assignment is to Insurance
				SELECT @InsuranceCompanyPlanID=InsuranceCompanyPlanID
				FROM InsurancePolicy IP
				WHERE InsurancePolicyID=@InsurancePolicyID

				--Insert New Record
				INSERT INTO ClaimAccounting_Assignments(PracticeID, PostingDate, ClaimID, ClaimTransactionID, InsurancePolicyID,
								        InsuranceCompanyPlanID, PatientID, LastAssignment, DKPostingDateID, LastAssignmentOfEndPostingDate)
				VALUES(@PracticeID, @PostingDate, @ClaimID, @ClaimTransactionID, @InsurancePolicyID, @InsuranceCompanyPlanID, @PatientID, 1,
					   dbo.fn_GetDateKeySelectivityID(@PracticeID,@PostingDate,0,0), 1)
			
			END

			IF EXISTS(SELECT * FROM Inserted WHERE ClaimTransactionTypeCode='XXX')
			BEGIN
				--Delete all records for this claim in the ClaimAccounting Tables
				--The table will be repopulated with these records if the Void
				--XXX transaction is deleted

				DELETE CA
				FROM ClaimAccounting CA INNER JOIN Inserted I 
				ON CA.ClaimID=I.ClaimID

				DELETE CAB
				FROM ClaimAccounting_Billings CAB INNER JOIN Inserted I 
				ON CAB.ClaimID=I.ClaimID

				DELETE CAA
				FROM ClaimAccounting_Assignments CAA INNER JOIN Inserted I 
				ON CAA.ClaimID=I.ClaimID

				DELETE CACP
				FROM ClaimAccounting_ClaimPeriod CACP INNER JOIN Inserted I
				ON CACP.ClaimID=I.ClaimID
			END
		END
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT * FROM Inserted WHERE ClaimTransactionTypeCode IN ('CST','BLL','PAY','ADJ','END','PRC','ASN'))
		BEGIN
			CREATE TABLE #OrderedList(PracticeID INT, PostingDate SMALLDATETIME, ClaimID INT, ProviderID INT, PatientID INT,
						  ClaimTransactionID INT, ClaimTransactionTypeCode CHAR(3), Status BIT, ProcedureCount DECIMAL(19,4),
						  Amount MONEY, ARAmount MONEY, Code CHAR(1), CreatedUserID INT, PaymentID INT, FirstBilled BIT)
			INSERT INTO #OrderedList(PracticeID, PostingDate, ClaimID, ProviderID, PatientID,  ClaimTransactionID,
						 ClaimTransactionTypeCode, Status, ProcedureCount, Amount, ARAmount, Code, CreatedUserID, PaymentID)
			SELECT PracticeID, CAST(CONVERT(CHAR(10),PostingDate,110) AS SMALLDATETIME) PostingDate, ClaimID, Claim_ProviderID,
			       PatientID, ClaimTransactionID, ClaimTransactionTypeCode,
			       CASE WHEN ClaimTransactionTypeCode='END' THEN 1 ELSE 0 END Status, 0 ProcedureCount,
			       CASE WHEN ClaimTransactionTypeCode='BLL' THEN 0 ELSE Amount END Amount,
			       0 ARAmount, CASE WHEN ClaimTransactionTypeCode='BLL' THEN Code ELSE NULL END Code, CreatedUserID,
				   PaymentID
			FROM Inserted
			WHERE ClaimTransactionTypeCode IN ('CST','BLL','PAY','ADJ','END','PRC')
			ORDER BY PracticeID, CAST(CONVERT(CHAR(10),PostingDate,110) AS SMALLDATETIME), Claim_ProviderID, PatientID,
				 ClaimID, CASE WHEN ClaimTransactionTypeCode='CST' THEN 0
					       WHEN ClaimTransactionTypeCode='PRC' THEN 1
					       WHEN ClaimTransactionTypeCode='BLL' THEN 2
					       WHEN ClaimTransactionTypeCode='PAY' THEN 3
					       WHEN ClaimTransactionTypeCode='ADJ' THEN 4
					       WHEN ClaimTransactionTypeCode='END' THEN 5 END
	
			CREATE TABLE #OLClaims(PracticeID INT, ClaimID INT)
			INSERT INTO #OLClaims(PracticeID, ClaimID)
			SELECT DISTINCT PracticeID, ClaimID
			FROM #OrderedList

			IF EXISTS(SELECT * FROM Inserted WHERE ClaimTransactionTypeCode='ASN')
			BEGIN
				DECLARE @ASNClaims TABLE(PracticeID INT, ClaimID INT)
				INSERT @ASNClaims(PracticeID, ClaimID)
				SELECT PracticeID, ClaimID
				FROM Inserted
				WHERE ClaimTransactionTypeCode='ASN'

				DECLARE @ASNTrans TABLE(TID INT IDENTITY(1,1), PracticeID INT, NewFlag BIT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME, EndPostingDate DATETIME, LastAssignmentOfEndPostingDate BIT, LastAssignment BIT, EndClaimTransactionID INT)
				INSERT @ASNTrans(PracticeID, NewFlag, ClaimID, ClaimTransactionID, PostingDate, LastAssignmentOfEndPostingDate, LastAssignment)
				SELECT C.PracticeID, 0, C.ClaimID, CAA.ClaimTransactionID, CAST(CONVERT(CHAR(10),CAA.PostingDate,110) AS SMALLDATETIME), 0, 0
				FROM @ASNClaims C INNER JOIN ClaimAccounting_Assignments CAA
				ON C.PracticeID=CAA.PracticeID AND C.ClaimID=CAA.ClaimID
				UNION
				SELECT PracticeID, 1, ClaimID, ClaimTransactionID, CAST(CONVERT(CHAR(10),PostingDate,110) AS SMALLDATETIME), 0, 0
				FROM Inserted I
				WHERE ClaimTransactionTypeCode='ASN'
				ORDER BY ClaimID, CAST(CONVERT(CHAR(10),PostingDate,110) AS SMALLDATETIME) DESC, ClaimTransactionID DESC

				UPDATE AT1 SET EndPostingDate=AT2.PostingDate, EndClaimTransactionID=AT2.ClaimTransactionID
				FROM @ASNTrans AT1 INNER JOIN  @ASNTrans AT2
				ON AT1.ClaimID=AT2.ClaimID AND AT1.TID=AT2.TID+1

				DECLARE @ASN_FlagsToUpdate TABLE(ClaimID INT, EndPostingDate DATETIME, CTIDToUpdate INT)
				INSERT @ASN_FlagsToUpdate(ClaimID, EndPostingDate, CTIDToUpdate)
				SELECT ClaimID, EndPostingDate, MAX(ClaimTransactionID) CTIDToUpdate
				FROM @ASNTrans
				GROUP BY ClaimID, EndPostingDate

				UPDATE AT SET LastAssignmentOfEndPostingDate=1
				FROM @ASNTrans AT INNER JOIN @ASN_FlagsToUpdate ATU
				ON AT.ClaimID=ATU.ClaimID AND AT.ClaimTransactionID=ATU.CTIDToUpdate

				UPDATE @ASNTrans SET LastAssignment=1
				WHERE EndPostingDate IS NULL

				UPDATE CAA SET LastAssignment=AT.LastAssignment, EndPostingDate=AT.EndPostingDate, EndClaimTransactionID=AT.EndClaimTransactionID,
				DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(AT.PracticeID,AT.EndPostingDate,0,0),
				LastAssignmentOfEndPostingDate=AT.LastAssignmentOfEndPostingDate
				FROM @ASNTrans AT INNER JOIN ClaimAccounting_Assignments CAA
				ON AT.ClaimID=CAA.ClaimID AND AT.ClaimTransactionID=CAA.ClaimTransactionID
				WHERE NewFlag=0

				--Insert Assignments
				INSERT INTO ClaimAccounting_Assignments(PracticeID, PostingDate, ClaimID, ClaimTransactionID, 
														InsurancePolicyID, InsuranceCompanyPlanID, PatientID,
														LastAssignment, EndPostingDate, DKPostingDateID, 
													    DKEndPostingDateID, LastAssignmentOfEndPostingDate, Status, EndClaimTransactionID)
				SELECT I.PracticeID, CAST(CONVERT(CHAR(10),I.PostingDate,110) AS SMALLDATETIME), I.ClaimID, I.ClaimTransactionID, I.ReferenceID, IP.InsuranceCompanyPlanID, I.PatientID, AT.LastAssignment, AT.EndPostingDate, 
				dbo.fn_GetDateKeySelectivityID(I.PracticeID,I.PostingDate,0,0), dbo.fn_GetDateKeySelectivityID(AT.PracticeID,AT.EndPostingDate,0,0), AT.LastAssignmentOfEndPostingDate, 0,
				AT.EndClaimTransactionID
				FROM Inserted I INNER JOIN @ASNTrans AT
				ON I.ClaimID=AT.ClaimID AND I.ClaimTransactionID=AT.ClaimTransactionID
				LEFT JOIN InsurancePolicy IP
				ON I.PracticeID=IP.PracticeID AND I.ReferenceID=IP.InsurancePolicyID
				WHERE AT.NewFlag=1
			END

			CREATE TABLE #OLClaims_BLL(PracticeID INT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME)
			INSERT INTO #OLClaims_BLL(PracticeID, ClaimID, ClaimTransactionID, PostingDate)
			SELECT PracticeID, ClaimID, ClaimTransactionID, PostingDate
			FROM #OrderedList
			WHERE ClaimTransactionTypeCode='BLL'

			CREATE TABLE #OLDenormalizedData(ClaimID INT, EncounterProcedureID INT, ProcedureCount INT)
			INSERT INTO #OLDenormalizedData(ClaimID, EncounterProcedureID, ProcedureCount)
			SELECT OL.ClaimID, EP.EncounterProcedureID, ISNULL(EP.ServiceUnitCount,0) ProcedureCount 
			FROM #OLClaims OL INNER JOIN Claim C
			ON OL.PracticeID=C.PracticeID AND OL.ClaimID=C.ClaimID
			INNER JOIN EncounterProcedure EP
			ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID

			--Update all records with a Status of 1 if claim has been closed
			DECLARE @ClosedItems TABLE(PracticeID INT, ClaimID INT, PostingDate DATETIME)
			INSERT @ClosedItems(PracticeID, ClaimID, PostingDate)
			SELECT PracticeID, ClaimID, PostingDate
			FROM #OrderedList 
			WHERE ClaimTransactionTypeCode='END'
	
			--Flag those items closed in the insert list
			UPDATE OL SET Status=1
			FROM #OrderedList OL INNER JOIN @ClosedItems CI ON OL.ClaimID=CI.ClaimID

			DECLARE @BLLTrans TABLE(TID INT IDENTITY(1,1), PracticeID INT, NewFlag BIT, ClaimID INT, ClaimTransactionID INT, PostingDate DATETIME, EndPostingDate DATETIME, 
									LastBilledOfEndPostingDate BIT, LastBilled BIT, FirstBilled BIT, EndClaimTransactionID INT)

			IF EXISTS(SELECT * FROM #OLClaims_BLL)
			BEGIN
				INSERT @BLLTrans(PracticeID, NewFlag, ClaimID, ClaimTransactionID, PostingDate, LastBilledOfEndPostingDate, LastBilled, FirstBilled)
				SELECT C.PracticeID, 0,C.ClaimID, ClaimTransactionID, PostingDate, 0, 0, 0 
				FROM #OLClaims C INNER JOIN ClaimAccounting_Billings CAB
				ON C.PracticeID=CAB.PracticeID AND C.ClaimID=CAB.ClaimID
				UNION
				SELECT OCB.PracticeID, 1, OCB.ClaimID, OCB.ClaimTransactionID, OCB.PostingDate, 0, 0, 0
				FROM #OLClaims_BLL OCB
				ORDER BY ClaimID, PostingDate DESC, ClaimTransactionID DESC

				UPDATE BT1 SET EndPostingDate=BT2.PostingDate, EndClaimTransactionID=BT2.ClaimTransactionID
				FROM @BLLTrans BT1 INNER JOIN  @BLLTrans BT2
				ON BT1.ClaimID=BT2.ClaimID AND BT1.TID=BT2.TID+1

				DECLARE @BLL_FlagsToUpdate TABLE(ClaimID INT, EndPostingDate DATETIME, CTIDToUpdate INT)
				INSERT @BLL_FlagsToUpdate(ClaimID, EndPostingDate, CTIDToUpdate)
				SELECT ClaimID, EndPostingDate, MAX(ClaimTransactionID) CTIDToUpdate
				FROM @BLLTrans
				GROUP BY ClaimID, EndPostingDate

				UPDATE BT SET LastBilledOfEndPostingDate=1
				FROM @BLLTrans BT INNER JOIN @BLL_FlagsToUpdate BTU
				ON BT.ClaimID=BTU.ClaimID AND BT.ClaimTransactionID=BTU.CTIDToUpdate

				UPDATE @BLLTrans SET LastBilled=1
				WHERE EndPostingDate IS NULL

				UPDATE BT SET FirstBilled=1
				FROM @BLLTrans BT INNER JOIN (SELECT ClaimID, MIN(ClaimTransactionID) FBID FROM @BLLTrans GROUP BY ClaimID) FBT
				ON BT.ClaimID=FBT.ClaimID AND BT.ClaimTransactionID=FBT.FBID

				UPDATE OL SET FirstBilled=1
				FROM #OrderedList OL INNER JOIN @BLLTrans BT
				ON OL.ClaimTransactionID=BT.ClaimTransactionID

				UPDATE CAB SET LastBilled=BT.LastBilled, EndPostingDate=BT.EndPostingDate, EndClaimTransactionID=BT.EndClaimTransactionID,
				DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(BT.PracticeID,BT.EndPostingDate,0,0),
				LastBilledOfEndPostingDate=BT.LastBilledOfEndPostingDate
				FROM @BLLTrans BT INNER JOIN ClaimAccounting_Billings CAB
				ON BT.ClaimID=CAB.ClaimID AND BT.ClaimTransactionID=CAB.ClaimTransactionID
				WHERE NewFlag=0

				INSERT INTO ClaimAccounting_Billings(PracticeID, PostingDate, ClaimID, ClaimTransactionID, Batchtype, LastBilled, EndPostingDate, DKPostingDateID, 
													 DKEndPostingDateID, LastBilledOfEndPostingDate, Status, EndClaimTransactionID)
				SELECT OL.PracticeID, OL.PostingDate, OL.ClaimID, OL.ClaimTransactionID, OL.Code, BT.LastBilled, BT.EndPostingDate, 
				dbo.fn_GetDateKeySelectivityID(OL.PracticeID,OL.PostingDate,0,0), dbo.fn_GetDateKeySelectivityID(BT.PracticeID,BT.EndPostingDate,0,0), BT.LastBilledOfEndPostingDate,
				OL.Status, BT.EndClaimTransactionID
				FROM #OrderedList OL INNER JOIN @BLLTrans BT
				ON OL.ClaimID=BT.ClaimID AND OL.ClaimTransactionID=BT.ClaimTransactionID
				WHERE BT.NewFlag=1
			END

			--Delete Voided Claims
			DELETE OL
			FROM #OrderedList OL INNER JOIN VoidedClaims VC 
			ON OL.ClaimID=VC.ClaimID

			--After determining the first bills, check if other claims are in the billing cycle
			--for proper updating of ADJ, PAY, and END transaction amount into ClaimAccounting
			DECLARE @PrevBLLs TABLE (ClaimID INT)
			INSERT @PrevBLLs(ClaimID)
			SELECT DISTINCT ClaimID
			FROM @BLLTrans
			WHERE NewFlag=0 AND FirstBilled=1

			--Delete all BLL except those flagged as First Billing for Claim
			DELETE OL
			FROM #OrderedList OL INNER JOIN @BLLTrans BT
			ON OL.ClaimID=BT.ClaimID AND OL.ClaimTransactionID=BT.ClaimTransactionID
			WHERE NewFlag<>1 AND BT.FirstBilled<>1	

			--Get Previous Claim transactions pre first bill that lower the AR Amount upon
			--first bill
			DECLARE @AdjToAR TABLE (ClaimID INT, Amount MONEY)
			INSERT @AdjToAR(ClaimID, Amount)
			SELECT CT.ClaimID, SUM(CT.Amount) Amount
			FROM ClaimTransaction CT INNER JOIN #OrderedList FB ON CT.ClaimID=FB.ClaimID AND FB.FirstBilled=1
			AND CT.ClaimTransactionTypeCode IN ('PAY','ADJ') 
			      AND CT.ClaimTransactionID<FB.ClaimTransactionID
			GROUP BY CT.ClaimID
			
			--Use @FirstBLLs result to set ARAmounts
			DECLARE @ClaimAmounts TABLE(ClaimID INT, Amount MONEY)
			INSERT @ClaimAmounts(ClaimID, Amount)
			SELECT CT.ClaimID, CT.Amount
			FROM ClaimTransaction CT INNER JOIN #OrderedList FB ON CT.ClaimID=FB.ClaimID AND FirstBilled=1
			AND CT.ClaimTransactionTypeCode='CST'
			
			UPDATE OL SET ARAmount=ClmA.Amount
			FROM #OrderedList OL INNER JOIN #OrderedList FB ON OL.ClaimTransactionID=FB.ClaimTransactionID  AND FB.FirstBilled=1
			INNER JOIN @ClaimAmounts ClmA ON FB.ClaimID=ClmA.ClaimID

			--Adjust ARAmounts by any ADJ or Payments which occured pre first billing
			UPDATE OL SET ARAmount=OL.ARAmount-ISNULL(ATA.Amount,0)
			FROM #OrderedList OL INNER JOIN #OrderedList FB ON OL.ClaimTransactionID=FB.ClaimTransactionID  AND FB.FirstBilled=1
			INNER JOIN @AdjToAR ATA ON FB.ClaimID=ATA.ClaimID
			
			--SET PAY, ADJ, END ARAmounts
			--Take into Consideration only trans after first bill
			UPDATE OL SET ARAmount=-1*OL.Amount
			FROM #OrderedList OL INNER JOIN #OrderedList FB ON OL.ClaimID=FB.ClaimID AND FB.FirstBilled=1
			WHERE OL.ClaimTransactionTypeCode NOT IN ('CST','BLL','PRC')
			      AND OL.ClaimTransactionID>FB.ClaimTransactionID

			--set those trans previously billed
			UPDATE OL SET ARAmount=-1*Amount
			FROM #OrderedList OL INNER JOIN @PrevBLLs PB ON OL.ClaimID=PB.ClaimID
			WHERE ClaimTransactionTypeCode NOT IN ('CST','BLL','PRC')  

			--Insert ClaimAccounting Records
			INSERT INTO ClaimAccounting(PracticeID, ClaimID, ProviderID, PatientID,  ClaimTransactionID,
						    ClaimTransactionTypeCode, Status, ProcedureCount, Amount, ARAmount, PostingDate,
							CreatedUserID, PaymentID, EncounterProcedureID) 
			SELECT OL.PracticeID, OL.ClaimID, OL.ProviderID, OL.PatientID,  OL.ClaimTransactionID,
			       OL.ClaimTransactionTypeCode, OL.Status, DD.ProcedureCount, OL.Amount, OL.ARAmount, OL.PostingDate,
				   OL.CreatedUserID, OL.PaymentID, DD.EncounterProcedureID
			FROM #OrderedList OL INNER JOIN #OLDenormalizedData DD
			ON OL.ClaimID=DD.ClaimID
	
			--Update/Insert ClaimAccounting_ClaimPeriod Records
			UPDATE CP SET DKEndPostingDateID=dbo.fn_GetDateKeySelectivityID(CI.PracticeID,CI.PostingDate,0,0)
			FROM @ClosedItems CI INNER JOIN ClaimAccounting_ClaimPeriod CP
			ON CI.ClaimID=CP.ClaimID

			INSERT INTO ClaimAccounting_ClaimPeriod(ProviderID, PatientID, ClaimID, DKInitialPostingDateID)
			SELECT OL.ProviderID, OL.PatientID, OL.ClaimID, dbo.fn_GetDateKeySelectivityID(OL.PracticeID,OL.PostingDate,0,0)
			FROM #OrderedList OL
			WHERE ClaimTransactionTypeCode='CST'
	
			--Flag those items closed in the table that also need updating
			UPDATE CA SET Status=1
			FROM ClaimAccounting CA INNER JOIN @ClosedItems CI ON CA.ClaimID=CI.ClaimID

			UPDATE CAA SET Status=1
			FROM ClaimAccounting_Assignments CAA INNER JOIN @ClosedItems CI ON CAA.ClaimID=CI.ClaimID

			UPDATE CAB SET Status=1
			FROM ClaimAccounting_Billings CAB INNER JOIN @ClosedItems CI ON CAB.ClaimID=CI.ClaimID

			DROP TABLE #OrderedList
			DROP TABLE #OLClaims
			DROP TABLE #OLClaims_BLL
			DROP TABLE #OLDenormalizedData
		END

		IF EXISTS(SELECT * FROM Inserted WHERE ClaimTransactionTypeCode='XXX')
		BEGIN
			--Delete all records for this claim in the ClaimAccounting Tables
			--The table will be repopulated with these records if the Void
			--XXX transaction is deleted

			DELETE CA
			FROM ClaimAccounting CA INNER JOIN Inserted I 
			ON CA.ClaimID=I.ClaimID

			DELETE CAB
			FROM ClaimAccounting_Billings CAB INNER JOIN Inserted I 
			ON CAB.ClaimID=I.ClaimID

			DELETE CAA
			FROM ClaimAccounting_Assignments CAA INNER JOIN Inserted I 
			ON CAA.ClaimID=I.ClaimID

			DELETE CACP
			FROM ClaimAccounting_ClaimPeriod CACP INNER JOIN Inserted I
			ON CACP.ClaimID=I.ClaimID
			WHERE I.ClaimTransactionTypeCode='XXX'
		END
	END
END

GO


		CREATE TABLE #FirstASN(EncounterID INT, ClaimID INT, ClaimTransactionID INT, EncounterProcedureID INT)
		INSERT INTO #FirstASN(EncounterID, ClaimID, ClaimTransactionID, EncounterProcedureID)
		SELECT EP.EncounterID, C.ClaimID, MIN(CAA.ClaimTransactionID) ClaimTransactionID, MIN(ep.EncounterProcedureID)
		FROM Encounter E 
			INNER JOIN EncounterProcedure EP ON E.EncounterID=EP.EncounterID
			INNER JOIN Claim C ON EP.PracticeID=C.PracticeID AND EP.EncounterProcedureID=C.EncounterProcedureID
			INNER JOIN ClaimAccounting_Assignments CAA ON C.PracticeID=CAA.PracticeID AND C.ClaimID=CAA.ClaimID
			LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
		WHERE 
			InsurancePolicyID IS NOT NULL AND 
--			C.ClaimStatusCode<>'C' AND 
			VC.ClaimID IS NULL
		GROUP BY EP.EncounterID, C.ClaimID


		-- List of Approved Encounters that are in need of copay
		CREATE TABLE #MissedCoPays(EncounterID INT, EncounterProcedureID INT, CopayDue MONEY, AmountPaid MONEY default 0)
		INSERT INTO #MissedCopays(EncounterID, EncounterProcedureID, CopayDue)
		SELECT FA.EncounterID, Min(EncounterProcedureID), IP.Copay
		FROM #FirstASN FA 
			INNER JOIN ClaimAccounting_Assignments CAA ON FA.ClaimTransactionID=CAA.ClaimTransactionID
			INNER JOIN InsurancePolicy IP ON CAA.InsurancePolicyID=IP.InsurancePolicyID
			INNER JOIN InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
			INNER JOIN Encounter E ON FA.EncounterID=E.EncounterID
			LEFT JOIN PatientCase PC ON E.PatientCaseID=PC.PatientCaseID
		WHERE
			isnull(IP.Copay, 0) <> 0
		GROUP BY FA.EncounterID, IP.Copay



		INSERT INTO #MissedCopays(EncounterID, EncounterProcedureID, CopayDue)
		SELECT e.EncounterID, Min(ep.EncounterProcedureID), IP.Copay
		FROM Encounter E
			INNER JOIN PatientCase PC ON E.PatientCaseID=PC.PatientCaseID
			INNER JOIN InsurancePolicy IP ON PC.PracticeID=IP.PracticeID AND PC.PatientCaseID=IP.PatientCaseID AND IP.Precedence=dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(E.PatientCaseID,E.DateOfService,0)		
			INNER JOIN EncounterProcedure ep ON ep.PracticeID = e.PracticeID AND e.EncounterID = ep.EncounterID
			LEFT JOIN #MissedCopays mc ON mc.EncounterID = e.EncounterID
		WHERE
			mc.EncounterID IS NULL AND
			isnull(IP.Copay, 0) <> 0
		GROUP BY e.EncounterID, IP.Copay



				select  
				getdate() [CreatedDate]
			   ,getdate() [ModifiedDate]
			   ,ca.[CreatedUserID] [CreatedUserID]
			   ,caa.[PostingDate] [PostingDate]

				,'PRC' [ClaimTransactionTypeCode]
				,c.ClaimID	 [ClaimID]
				,mp.CopayDue [Amount]

				,c.PracticeID [PracticeID]
				,ca.PatientID [PatientID]
				,ca.ProviderID [Claim_ProviderID]
				,'Migration of copay' [Notes]
				,c.EncounterProcedureID
		INTO #ClaimTransaction
		From #MissedCoPays mp
			INNER JOIN ( select EncounterID, EncounterProcedureID=min(EncounterProcedureID) from #FirstASN GROUP BY encounterID) fa
				ON fa.EncounterID = mp.EncounterID
			INNER JOIN Claim c ON c.EncounterProcedureID = fa.EncounterProcedureID
			INNER JOIN (SELECT PracticeID, ClaimID, min(PostingDate) as PostingDate FROM ClaimAccounting_Assignments GROUP BY PracticeID, ClaimID ) caa ON caa.PracticeID = c.PracticeID AND  caa.ClaimID = c.ClaimID 
			INNER JOIN ClaimAccounting ca ON ca.PracticeID = c.PracticeID AND  ca.ClaimID = c.ClaimID AND ca.ClaimTransactionTypeCode = 'CST'




		-- Update the new field with the copay amount
		update ep
		Set CopayAmount = copayDue,
			ApplyCopay = case when e.AmountPaid > 0 AND e.paymentTypeID = 1 THEN 1 ELSE 0 END
		FROM EncounterProcedure ep 
			INNER JOIN Encounter e ON e.PracticeID = ep.PracticeID AND e.EncounterID = ep.EncounterID
			INNER JOIN #MissedCopays ct ON ct.EncounterProcedureID = ep.EncounterProcedureID
		WHERE copayDue <> 0


		-- Generates the PRC Transaction
		INSERT INTO [ClaimTransaction] 
			(
				   [CreatedDate]
				   ,[ModifiedDate]
				   ,[CreatedUserID]
				   ,[PostingDate]

					,[ClaimTransactionTypeCode]
				   ,[ClaimID]
				   ,[Amount]

				   ,[PracticeID]
				   ,[PatientID]
				   ,[Claim_ProviderID]

				   ,[Notes]

			)

		select
				   [CreatedDate]
				   ,[ModifiedDate]
				   ,[CreatedUserID]
				   ,[PostingDate]

					,[ClaimTransactionTypeCode]
				   ,[ClaimID]
				   ,[Amount]

				   ,[PracticeID]
				   ,[PatientID]
				   ,[Claim_ProviderID]

				   ,[Notes]
		from #ClaimTransaction

		drop table #ClaimTransaction, #FirstASN





drop table #MissedCoPays



GO


---------------------------------------------------------------------------------
-- Case 14495:   Payment Business Rules: Create storage for the rules
---------------------------------------------------------------------------------


--Create base table for storing schema information

CREATE TABLE XmlSchemaCollection
(
	XmlSchemaCollectionName varchar(128) NOT NULL,
	Definition xml NOT NULL,
	Version rowversion
	CONSTRAINT [PK_XmlSchemaCollection_XmlSchemaCollectionName] 
		PRIMARY KEY NONCLUSTERED ([XmlSchemaCollectionName] ASC)
)
GO

--Insert schema for client business rules

INSERT INTO XmlSchemaCollection (XmlSchemaCollectionName, Definition) VALUES 
(
'Schema_ClientBusinessRule_Rule',
'<?xml version="1.0" encoding="utf-8"?>
<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="snippet">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="code" type="xs:string" maxOccurs="1" minOccurs="1"/>
        <xs:element name="references" minOccurs="0" maxOccurs="1">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="reference">
                <xs:complexType>
                  <xs:attribute name="strongname" type="xs:string" use="required" />
                </xs:complexType>
              </xs:element>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="imports" minOccurs="0" maxOccurs="1">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="import">
                <xs:complexType>
                  <xs:attribute name="namespace" type="xs:string" use="required" />
                </xs:complexType>
              </xs:element>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'
)
GO

--create xml schema collection for the above schema

DECLARE @schema_rule xml
SET @schema_rule = (SELECT Definition FROM XmlSchemaCollection WHERE XmlSchemaCollectionName = 'Schema_ClientBusinessRule_Rule')
CREATE XML SCHEMA COLLECTION Schema_ClientBusinessRule_Rule AS @schema_rule
GO

--Insert schema for client business rule sets

INSERT INTO XmlSchemaCollection (XmlSchemaCollectionName, Definition) VALUES 
(
'Schema_ClientBusinessRule_Set',
'<?xml version="1.0" encoding="utf-8"?>
<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="ruleset">
    <xs:complexType>
      <xs:choice maxOccurs="unbounded">
          <xs:element maxOccurs="unbounded" name="decision">
            <xs:complexType>
              <xs:attribute name="id" type="xs:string" use="required" />
              <xs:attribute name="src" type="xs:string" use="required" />
              <xs:attribute name="successRef" type="xs:string" use="required" />
              <xs:attribute name="failRef" type="xs:string" use="required" />
            </xs:complexType>
          </xs:element>
          <xs:element maxOccurs="unbounded" name="action">
            <xs:complexType>
              <xs:attribute name="id" type="xs:string" use="required" />
              <xs:attribute name="src" type="xs:string" use="required" />
              <xs:attribute name="nextRef" type="xs:string" use="required" />
            </xs:complexType>
          </xs:element>
          <xs:element maxOccurs="unbounded" name="terminateAction">
            <xs:complexType>
              <xs:attribute name="id" type="xs:string" use="required" />
              <xs:attribute name="src" type="xs:string" use="required" />
            </xs:complexType>
          </xs:element>
      </xs:choice>
      <xs:attribute name="startRef" type="xs:string" use="required" />
    </xs:complexType>
  </xs:element>
</xs:schema>'
)
GO

--create xml schema collection for the above schema

DECLARE @schema_ruleset xml
SET @schema_ruleset = (SELECT Definition FROM XmlSchemaCollection WHERE XmlSchemaCollectionName = 'Schema_ClientBusinessRule_Set')
CREATE XML SCHEMA COLLECTION Schema_ClientBusinessRule_Set AS @schema_ruleset
GO

--create table for client business rule sets

CREATE TABLE ClientBusinessRuleSet
(
	ClientBusinessRuleSetID int IDENTITY(1,1) NOT NULL,
	Name varchar(100) NOT NULL,
	RuleSet xml (DOCUMENT Schema_ClientBusinessRule_Set) NOT NULL,
	ValidatingXmlSchemaCollectionName varchar(128) NOT NULL,
	CreatedDate datetime NOT NULL CONSTRAINT [DF_ClientBusinessRuleSet_CreatedDate]  DEFAULT (getdate()),
	CreatedUserID int NOT NULL CONSTRAINT [DF_ClientBusinessRuleSet_CreatedUserID]  DEFAULT (0),
	ModifiedDate datetime NOT NULL CONSTRAINT [DF_ClientBusinessRuleSet_ModifiedDate]  DEFAULT (getdate()),
	ModifiedUserID int NOT NULL CONSTRAINT [DF_ClientBusinessRuleSet_ModifiedUserID]  DEFAULT (0),
	Version rowversion,
	CONSTRAINT [PK_ClientBusinessRuleSet_ClientBusinessRuleSetID] 
		PRIMARY KEY NONCLUSTERED ([ClientBusinessRuleSetID] ASC),
	CONSTRAINT [FK_ClientBusinessRuleSET_XmlSchemaCollection] 
		FOREIGN KEY([ValidatingXmlSchemaCollectionName]) 
		REFERENCES [dbo].[XmlSchemaCollection] ([XmlSchemaCollectionName])
)
GO



--create table for client business rules

CREATE TABLE ClientBusinessRule
(
	ClientBusinessRuleID int IDENTITY(1,1) NOT NULL,
	ClientBusinessRuleSetID int NOT NULL,
	RuleName varchar(100) NOT NULL,
	Definition xml (DOCUMENT Schema_ClientBusinessRule_Rule) NOT NULL,
	ValidatingXmlSchemaCollectionName varchar(128) NOT NULL,
	CreatedDate datetime NOT NULL CONSTRAINT [DF_ClientBusinessRule_CreatedDate]  DEFAULT (getdate()),
	CreatedUserID int NOT NULL CONSTRAINT [DF_ClientBusinessRule_CreatedUserID]  DEFAULT (0),
	ModifiedDate datetime NOT NULL CONSTRAINT [DF_ClientBusinessRule_ModifiedDate]  DEFAULT (getdate()),
	ModifiedUserID int NOT NULL CONSTRAINT [DF_ClientBusinessRule_ModifiedUserID]  DEFAULT (0),
	Version rowversion,
	CONSTRAINT [PK_ClientBusinessRule_ClientBusinessRuleID] 
		PRIMARY KEY NONCLUSTERED ([ClientBusinessRuleID] ASC),
	CONSTRAINT [FK_ClientBusinessRule_ClientBusinessRuleSet] 
		FOREIGN KEY([ClientBusinessRuleSetID]) 
		REFERENCES [dbo].[ClientBusinessRuleSet] ([ClientBusinessRuleSetID]),
	CONSTRAINT [FK_ClientBusinessRule_XmlSchemaCollection] 
		FOREIGN KEY([ValidatingXmlSchemaCollectionName]) 
		REFERENCES [dbo].[XmlSchemaCollection] ([XmlSchemaCollectionName])
)
GO

---------------------------------------------------------------------------------
-- Case 14531:   Add new notes, display existing notes from patient activities 
---------------------------------------------------------------------------------
UPDATE PatientHistorySetup
SET Configuration = 
'<patientHistory type="Charges Summary" storedProcedure="PatientDataProvider_GetActivities_ChargeSummary">
  <!-- Section to determine which parameters are available to this report -->
  <parameters>
    <parameter type="PracticeID" />
    <parameter type="PatientID" />
    <parameter type="PatientCaseID" />
    <parameter type="BeginDate" />
    <parameter type="EndDate" />
    <parameter type="ProviderID" />
    <parameter type="Status" parameter="ReportType" value="O" />
    <parameter type="UnappliedAmount" />
  </parameters>
  <!-- Section to determine which actions (buttons) are available to this report -->
  <actions>
    <action type="Open" hyperlinkField="HyperlinkID" hyperlinkIDField="RefID" />
    <action type="AddNote"/>
   <action type="Print" reportPath="/BusinessManagerReports/rptGetActivities_TransactionSummary" />
  </actions>
  <!-- Section to determine the column structure for the report -->
  <columns>
    <column field="ClaimHasNotes" name="Notes" width="70" datatype="Bool" columntype="Check"  />
    <column field="ProcedureDateOfService" name="Service Date" width="75" datatype="ShortDateTime" columntype="Label" summaryType="Text" summaryText="TOTALS" />
    <column field="Description" name="Description" width="163" datatype="String" columntype="Label" />
    <column field="ExpectedReimbursement" name="Expected" width="75" datatype="Money" columntype="Label" summaryType="Sum" />
    <column field="Charges" name="Charges" width="75" datatype="Money" columntype="Label" summaryType="Sum" />
    <column field="Adjustments" name="Adjustments" width="75" datatype="Money" columntype="Label" summaryType="Sum" />
    <column field="Receipts" name="Receipts" width="75" datatype="Money" columntype="Label" summaryType="Sum" />
    <column field="PendingPat" name="Pat. Balance" width="75" datatype="Money" columntype="Label" summaryType="SumSubtractLastValue" summarySubtractField="UnappliedAmount" />
    <column field="PendingIns" name="Ins. Balance" width="75" datatype="Money" columntype="Label" summaryType="Sum" />
    <column field="Totalbalance" name="Total Balance" width="77" datatype="Money" columntype="Label" summaryType="SumSubtractLastValue" summarySubtractField="UnappliedAmount" />
    <column field="UnappliedAmount" name="" width="0" datatype="Money" columntype="Label" visible="false" />
  </columns>
</patientHistory>'
WHERE PatientHistorySetupID=1

UPDATE PatientHistorySetup
SET Configuration = 
'<patientHistory type="Transactions Detail" storedProcedure="PatientDataProvider_GetActivities_TransactionDetail">
  <!-- Section to determine which parameters are available to this report -->
  <parameters>
    <parameter type="PracticeID" />
    <parameter type="PatientID" />
    <parameter type="PatientCaseID" />
    <parameter type="BeginDate" />
    <parameter type="EndDate" />
    <parameter type="ProviderID" />
    <parameter type="Transaction" value="" />
  </parameters>
  <!-- Section to determine which actions (buttons) are available to this report -->
  <actions>
    <action type="Open" hyperlinkField="HyperlinkID" hyperlinkIDField="RefID" />
    <action type="AddNote"/>
    <action type="Print" reportPath="/BusinessManagerReports/rptGetActivities_TransactionDetail" />
    <action type="Reprint" reprintField="HCFA_DocumentID" />
  </actions>
  <!-- Section to determine the column structure for the report -->
  <columns>
    <column field="TransactionDate" name="Post/Tx Date" width="75" datatype="ShortDateTime" columntype="Label" summaryType="Text" summaryText="BALANCE" />
    <column field="DateOfService" name="Service Date" width="75" datatype="ShortDateTime" columntype="Label" />
    <column field="Description" name="Description" width="238" datatype="String" columntype="Label" />
    <column field="Amount" name="Amount" width="75" datatype="Money" columntype="Label" />
    <column field="PatientBalance" name="Pat. Balance" width="75" datatype="Money" columntype="Label" summaryType="Balance" />
    <column field="InsuranceBalance" name="Ins. Balance" width="75" datatype="Money" columntype="Label" summaryType="Balance" />
    <column field="TotalBalance" name="Total Balance" width="77" datatype="Money" columntype="Label" summaryType="Balance" />
    <column field="Unapplied" name="Unapplied" width="75" datatype="Money" columntype="Label" summaryType="Balance" />
  </columns>
</patientHistory>'
WHERE PatientHistorySetupID=2


---------------------------------------------------------------------------------
-- Case 14020: Allow Capture of payments from the appointment screen
---------------------------------------------------------------------------------
ALTER TABLE Payment ADD 
	AppointmentID INT NULL,
	AppointmentStartDate Datetime NULL
GO

ALTER TABLE Payment ADD CONSTRAINT FK_Payment_Appointment FOREIGN KEY(AppointmentID)
REFERENCES Appointment (AppointmentID)
GO

---------------------------------------------------------------------------------
--  Case 16402:   Remove Patient Histor Report.
---------------------------------------------------------------------------------
delete ReportToSoftwareApplication
FROM report r
WHERE ReportToSoftwareApplication.ReportID = r.ReportID
AND name = 'Patient History'


delete report
where name = 'Patient History'

update report
set ModifiedDate = getdate()
where name = 'Daily Report'


---------------------------------------------------------------------------------
-- Case SF326:   Add POS 13 = Assisted Living Center
---------------------------------------------------------------------------------
-- add new places of service

select PlaceOfServiceCode, Description into #loc_tmp from PlaceOfService
delete #loc_tmp

insert into #loc_tmp(PlaceOfServiceCode, Description) values ('03', 'School')
insert into #loc_tmp(PlaceOfServiceCode, Description) values ('04', 'Homeless Shelter')
insert into #loc_tmp(PlaceOfServiceCode, Description) values ('05', 'Indian Health Service Free-standing Facility')
insert into #loc_tmp(PlaceOfServiceCode, Description) values ('06', 'Indian Helath Service Provider-based Facility')
insert into #loc_tmp(PlaceOfServiceCode, Description) values ('07', 'Tribal 638 Free-Standing Facility')
insert into #loc_tmp(PlaceOfServiceCode, Description) values ('08', 'Tribal 638 Provider-Based Facility')
insert into #loc_tmp(PlaceOfServiceCode, Description) values ('13', 'Assisted Living Facility')
insert into #loc_tmp(PlaceOfServiceCode, Description) values ('14', 'Group Home')
insert into #loc_tmp(PlaceOfServiceCode, Description) values ('15', 'Mobile Unit')
insert into #loc_tmp(PlaceOfServiceCode, Description) values ('20', 'Urgent Care Facility')
insert into #loc_tmp(PlaceOfServiceCode, Description) values ('49', 'Independent Clinic')

insert into PlaceOfService (PlaceOfServiceCode, Description) select PlaceOfServiceCode, Description 
from #loc_tmp f
where f.PlaceOfServiceCode not in (select PlaceOfServiceCode from PlaceOfService)

drop table #loc_tmp
GO

---------------------------------------------------------------------------------
-- Case 15842:   Add field required for COB to Insurance Policy
---------------------------------------------------------------------------------

CREATE TABLE InsuranceProgramType
(
	InsuranceProgramTypeID int IDENTITY(1,1) NOT NULL, 
	InsuranceProgramTypeCode char(2) NOT NULL, 
	InsuranceProgramCode char(2) NOT NULL, 
	TypeName varchar(200) NOT NULL,
	SortOrder int NOT NULL,
	TIMESTAMP timestamp,
	CONSTRAINT [PK_InsuranceProgramType_InsuranceProgramTypeID]
		PRIMARY KEY NONCLUSTERED ([InsuranceProgramTypeID] ASC),
	CONSTRAINT [UN_InsuranceProgramType_InsuranceProgramTypeCode_InsuranceProgramCode]
		UNIQUE NONCLUSTERED ([InsuranceProgramCode], [InsuranceProgramTypeCode]),
	CONSTRAINT [FK_InsuranceProgramType_InsuranceProgram]
		FOREIGN KEY([InsuranceProgramCode])
		REFERENCES [dbo].[InsuranceProgram] ([InsuranceProgramCode])
)
GO

INSERT INTO InsuranceProgramType (InsuranceProgramCode, SortOrder, InsuranceProgramTypeCode, TypeName) VALUES ('MB',10,'12','Medicare Secondary Working Aged Beneficiary or Spouse with Employer Group Health Plan')
INSERT INTO InsuranceProgramType (InsuranceProgramCode, SortOrder, InsuranceProgramTypeCode, TypeName) VALUES ('MB',20,'13','Medicare Secondary End-Stage Renal Disease Beneficiary in the Mandated Coordination Period with an Employer’s Group Health Plan')
INSERT INTO InsuranceProgramType (InsuranceProgramCode, SortOrder, InsuranceProgramTypeCode, TypeName) VALUES ('MB',30,'14','Medicare Secondary, No-fault Insurance including Auto is Primary')
INSERT INTO InsuranceProgramType (InsuranceProgramCode, SortOrder, InsuranceProgramTypeCode, TypeName) VALUES ('MB',40,'15','Medicare Secondary Worker’s Compensation')
INSERT INTO InsuranceProgramType (InsuranceProgramCode, SortOrder, InsuranceProgramTypeCode, TypeName) VALUES ('MB',50,'16','Medicare Secondary Public Health Service (PHS) or Other Federal Agency')
INSERT INTO InsuranceProgramType (InsuranceProgramCode, SortOrder, InsuranceProgramTypeCode, TypeName) VALUES ('MB',60,'41','Medicare Secondary Black Lung')
INSERT INTO InsuranceProgramType (InsuranceProgramCode, SortOrder, InsuranceProgramTypeCode, TypeName) VALUES ('MB',70,'42','Medicare Secondary Veteran’s Administration')
INSERT INTO InsuranceProgramType (InsuranceProgramCode, SortOrder, InsuranceProgramTypeCode, TypeName) VALUES ('MB',80,'43','Medicare Secondary Disabled Beneficiary Under Age 65 with Large Group Health Plan (LGHP)')
INSERT INTO InsuranceProgramType (InsuranceProgramCode, SortOrder, InsuranceProgramTypeCode, TypeName) VALUES ('MB',90,'47','Medicare Secondary, Other Liability Insurance is Primary')
GO

ALTER TABLE InsurancePolicy ADD 
	InsuranceProgramTypeID int NULL
GO

ALTER TABLE InsurancePolicy ADD CONSTRAINT FK_InsurancePolicy_InsuranceProgramType
	FOREIGN KEY(InsuranceProgramTypeID)
	REFERENCES InsuranceProgramType (InsuranceProgramTypeID)
GO

---------------------------------------------------------------------------------
-- Case 14026:   Investigate and add NPI numbers
---------------------------------------------------------------------------------

ALTER TABLE Practice ADD
	NPI varchar(10) NULL
GO

ALTER TABLE Doctor ADD
	NPI varchar(10) NULL
GO

---------------------------------------------------------------------------------
-- Case 16568:   Add COB options to application
---------------------------------------------------------------------------------

ALTER TABLE ClearinghousePayersList ADD
	SupportsSecondaryElectronicBilling bit NOT NULL DEFAULT 0,
	SupportsCoordinationOfBenefits bit NOT NULL DEFAULT 1
GO

ALTER TABLE PracticeToInsuranceCompany ADD
	UseSecondaryElectronicBilling bit NOT NULL DEFAULT 0,
	UseCoordinationOfBenefits bit NOT NULL DEFAULT 1
GO

ALTER TABLE Encounter ADD
	DoNotSendElectronicSecondary bit NOT NULL DEFAULT 0
GO

---------------------------------------------------------------------------------
-- Case 14474:   Payment Details: Server support for ERA integration with new Receive Payment Task 
---------------------------------------------------------------------------------
--Add New indexing for optimizations
CREATE INDEX IX_EncounterProcedure_ProcedureCodeDictionaryID
ON EncounterProcedure (ProcedureCodeDictionaryID)

CREATE INDEX IX_EncounterProcedure_EncounterID
ON EncounterProcedure (EncounterID)

CREATE INDEX IX_ProcedureCodeDictionary_ProcedureCode
ON ProcedureCodeDictionary (ProcedureCode)

GO

---------------------------------------------------------------------------------
-- Case 14502:   Patient Copay: Modify Patient Statements to handle copay logic
---------------------------------------------------------------------------------
--New index to speed up related patient statement sprocs
CREATE INDEX IX_ClaimAccounting_EncounterProcedureID 
ON ClaimAccounting (EncounterProcedureID)

GO

---------------------------------------------------------------------------------
-- Case 17036:  Payment Retrieve - Add Draft bit to result set 
---------------------------------------------------------------------------------
CREATE INDEX IX_PaymentClaim_PaymentID
ON PaymentClaim (PaymentID)

CREATE INDEX IX_PaymentClaim_ClaimID
ON PaymentClaim (ClaimID)

CREATE INDEX IX_PaymentClaim_EncounterID
ON PaymentClaim (EncounterID)

CREATE INDEX IX_PaymentPatient_PaymentID
ON PaymentPatient (PaymentID)


GO
---------------------------------------------------------------------------------
-- Case 14502:   Patient Copay: Modify Patient Statements to handle copay logic
---------------------------------------------------------------------------------
-- Add copay bit to BillClaim Schema
	ALTER TABLE BillClaim add isCopay BIT
	GO


	Update BillClaim
	SET isCopay = 0
	WHERE isCopay IS NULL

	ALTER TABLE [dbo].BillClaim ADD  CONSTRAINT [DF_BillClaim_isCopay]  DEFAULT ((0)) FOR isCopay
	GO


	ALTER TABLE Bill_Statement Add hasUnappliedAmount BIT
	GO

	Update Bill_Statement
	SET hasUnappliedAmount = 0
	WHERE hasUnappliedAmount IS NULL

	ALTER TABLE [dbo].[Bill_Statement] ADD  CONSTRAINT [DF_Bill_Statements_hasUnappliedAmount]  DEFAULT ((0)) FOR [hasUnappliedAmount]
	GO


---------------------------------------------------------------------------------
-- Case 14022:   Add decimal units to practitioner
---------------------------------------------------------------------------------
ALTER TABLE ProcedureMacroDetail ALTER COLUMN Units decimal(19, 4) 
GO

---------------------------------------------------------------------------------
-- Case 14090:   Eligibility
---------------------------------------------------------------------------------
INSERT AttachConditionsType (AttachConditionsTypeID, AttachConditionsTypeName) VALUES (4, 'Eligibility Checks Only')
GO

---------------------------------------------------------------------------------
-- Case 00000:   Name of case
---------------------------------------------------------------------------------
/****** Object:  Table [dbo].[EligibilityPayersList]    Script Date: 12/20/2006 16:37:50 ******/

IF EXISTS(SELECT * FROM sys.objects WHERE name='B2BPayersList' AND type='U')
BEGIN
	IF EXISTS(SELECT * FROM sys.objects so INNER JOIN sys.columns sc
					   ON so.Object_id=sc.Object_id
					   WHERE so.name='ClearinghousePayersList' AND so.type='U' AND sc.name='B2BPayerID')
	BEGIN
		ALTER TABLE ClearinghousePayersList DROP CONSTRAINT [FK_ClearinghousePayersList_B2BPayersList]
		ALTER TABLE ClearinghousePayersList DROP COLUMN B2BPayerID	
	END	

	DROP TABLE B2BPayersList
END

CREATE TABLE B2BPayersList(
	B2BPayerID INT NOT NULL,
	B2BPayerName VARCHAR(1000),
	B2BPayerNumber VARCHAR(32),
	ProviderCode VARCHAR(2),
	KareoLastModifiedDate DATETIME,
	CreatedDate DATETIME,
	CreatedUserID INT,
	ModifiedDate DATETIME,
	ModifiedUserID INT
 CONSTRAINT [PK_EligibilityPayersList] PRIMARY KEY  
(
	[B2bPayerID] 
))
GO

INSERT INTO B2BPayersList(B2BPayerID, B2BPayerName, B2BPayerNumber, ProviderCode, 
						  KareoLastModifiedDate, CreatedDate, ModifiedDate)
SELECT B2BPayerID, B2BPayerName, B2BPayerNumber, ProviderCode, GETDATE(), GETDATE(), GETDATE()
FROM superbill_shared..B2BPayersList

ALTER TABLE ClearinghousePayersList ADD B2BPayerID INT
GO

UPDATE CPL SET B2BPayerID=SCPL.B2BPayerID
FROM ClearinghousePayersList CPL INNER JOIN superbill_shared..ClearinghousePayersList SCPL
ON CPL.ClearinghousePayerID=SCPL.ClearinghousePayerID
WHERE SCPL.B2BPayerID IS NOT NULL

ALTER TABLE [ClearinghousePayersList]  ADD  CONSTRAINT [FK_ClearinghousePayersList_B2BPayersList] FOREIGN KEY([B2BPayerID])
REFERENCES [B2BPayersList] ([B2bPayerID])
GO

ALTER TABLE GroupNumberType ADD B2BIdentificationQualifier CHAR(2)

GO

UPDATE GNT SET B2BIdentificationQualifier=SGNT.B2BIdentificationQualifier
FROM GroupNumberType GNT INNER JOIN superbill_shared..GroupNumberType SGNT
ON GNT.GroupNumberTypeID=SGNT.GroupNumberTypeID

GO



---------------------------------------------------------------------------------
-- Case 14503:   Patient Copay: Modify reports to support accounts
---------------------------------------------------------------------------------
Update r
set ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Balance Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="PatientID" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="ReportType" />
            <methodParam param="{2}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
from reporthyperlink r
where ReportHyperlinkID = 13

---------------------------------------------------------------------------------
-- Case 15237:   Bold patient name and increase font size by 1.
---------------------------------------------------------------------------------

UPDATE PrintingFormDetails
SET SVGDefinition = '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<!--  
        Takes in the number of rows to draw the dotted horizontal lines for.
        
        Parameters:
        maximumRows - max number of rows allowed in a column
        currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)   
  -->

	<xsl:template name="CreateProceduresGridLines">

		<xsl:param name="maximumRows"/>
		<xsl:param name="currentRow"/>

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="yTopOffset" select="2.48"/>
		<xsl:variable name="yOffset" select="0.13625"/>
		<xsl:variable name="lineWidth" select="7.50"/>
		<xsl:variable name="headerYOffset" select="0.01"/>
		<xsl:variable name="codeXOffset" select="0.02"/>
		<xsl:variable name="descriptionXOffset" select="0.27"/>

		<xsl:if test="$maximumRows >= $currentRow">
			<!-- Creates the actual horizontal line for the row -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Calls the same template recursively -->
			<xsl:call-template name="CreateProceduresGridLines">
				<xsl:with-param name="maximumRows" select="$maximumRows"/>
				<xsl:with-param name="currentRow" select="$currentRow + 1"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$maximumRows = $currentRow">
			<!-- Print the top horizontal dotted line -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset - $yOffset}in" />

			<!-- Print the vertical lines -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 0.25}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.25}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 1.875}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 1.875}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.125}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.125}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 3.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 3.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.0}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.0}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.625}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.625}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.875}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.875}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" font-family="Arial" font-weight="bold">PROCEDURES</text>

		</xsl:if>
	</xsl:template>

	<!--  
        Takes in the number of rows allowed per column and the number of columns to process.
        Loops through each detail element to print.
        If this is a new category print the category in addition to the detail element.
        Keep track of how many rows have been printed.
        Once the row meets the total number of rows for a column move to the next column.
        Don''t print a category on the last row in a column.
        
        Parameters:
        maximumRowsInColumn - max number of rows allowed in a column
        maximumColumns - max number of columns to process
        totalElements - total number of elements to process
        currentElement - index of current element being processed
        currentRow - index of current printed row being processed (not necessarily the same as the element due to headers)
        currentColumn - 1 based index of current column being processed (mainly used for offsetting x location)
        currentCategory - index of the current category being processed (once this changes we print out the category again)
  -->

	<xsl:template name="CreateProceduresColumnLayout">

		<xsl:param name="maximumRowsInColumn"/>
		<xsl:param name="maximumColumns"/>
		<xsl:param name="totalElements"/>
		<xsl:param name="currentElement"/>
		<xsl:param name="currentRow"/>
		<xsl:param name="currentColumn"/>
		<xsl:param name="currentCategory" select="0"/>

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="xOffset" select="1.875"/>
		<xsl:variable name="yTopOffset" select="1.90"/>
		<xsl:variable name="yOffset" select="0.13625"/>
		<xsl:variable name="codeXOffset" select="0.01"/>
		<xsl:variable name="descriptionXOffset" select="0.27"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeWidth" select="0.27"/>
		<xsl:variable name="descriptionWidth" select="1.64"/>

		<xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
			<xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.ProcedureCategory'', $currentElement)]"/>

			<xsl:choose>
				<xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
					<!-- There isn''t enough room to print on this column -->

					<!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
					<xsl:call-template name="CreateProceduresColumnLayout">
						<xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
						<xsl:with-param name="maximumColumns" select="$maximumColumns"/>
						<xsl:with-param name="totalElements" select="$totalElements"/>
						<xsl:with-param name="currentElement" select="$currentElement"/>
						<xsl:with-param name="currentRow" select="1"/>
						<xsl:with-param name="currentColumn" select="$currentColumn + 1"/>
						<xsl:with-param name="currentCategory" select="0"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$currentCategory != $CurrentCategoryIndex">
					<!-- The category is not the same but there is enough room on this column so print out the category -->

					<!-- Creates the actual category line -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" class="bold" />

					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

					<!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
					<xsl:call-template name="CreateProceduresColumnLayout">
						<xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
						<xsl:with-param name="maximumColumns" select="$maximumColumns"/>
						<xsl:with-param name="totalElements" select="$totalElements"/>
						<xsl:with-param name="currentElement" select="$currentElement + 1"/>
						<xsl:with-param name="currentRow" select="$currentRow + 2"/>
						<xsl:with-param name="currentColumn" select="$currentColumn"/>
						<xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- The category is the same and there is enough room on this column so print out the detail -->

					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" />

					<!-- Calls the same template recursively -->
					<xsl:call-template name="CreateProceduresColumnLayout">
						<xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
						<xsl:with-param name="maximumColumns" select="$maximumColumns"/>
						<xsl:with-param name="totalElements" select="$totalElements"/>
						<xsl:with-param name="currentElement" select="$currentElement + 1"/>
						<xsl:with-param name="currentRow" select="$currentRow + 1"/>
						<xsl:with-param name="currentColumn" select="$currentColumn"/>
						<xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>
	</xsl:template>

	<xsl:template name="CreateDiagnosesGridLines">

		<xsl:param name="maximumRows"/>
		<xsl:param name="currentRow"/>
		<xsl:param name="sectionHeader"/>

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="yTopOffset" select="6.33"/>
		<xsl:variable name="yOffset" select="0.13625"/>
		<xsl:variable name="lineWidth" select="7.50"/>
		<xsl:variable name="headerYOffset" select="0.01"/>
		<xsl:variable name="codeXOffset" select="0.02"/>
		<xsl:variable name="descriptionXOffset" select="0.29"/>

		<xsl:if test="$maximumRows >= $currentRow">
			<!-- Creates the actual horizontal line for the row -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset + $yOffset * ($currentRow - 1)}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Calls the same template recursively -->
			<xsl:call-template name="CreateDiagnosesGridLines">
				<xsl:with-param name="maximumRows" select="$maximumRows"/>
				<xsl:with-param name="currentRow" select="$currentRow + 1"/>
				<xsl:with-param name="sectionHeader" select="$sectionHeader"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$maximumRows = $currentRow">
			<!-- Print the top horizontal dotted line -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset}in" x2="{$xLeftOffset + $lineWidth}in" y2="{$yTopOffset - $yOffset}in" />

			<!-- Print the vertical lines -->
			<line x1="{$xLeftOffset}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 0.275}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 0.275}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 1.875}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 1.875}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 2.15}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 2.15}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 3.75}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 3.75}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 4.025}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 4.025}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.625}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.625}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 5.90}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 5.90}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />
			<line x1="{$xLeftOffset + 7.50}in" y1="{$yTopOffset - $yOffset * 2}in" x2="{$xLeftOffset + 7.50}in" y2="{$yTopOffset + $yOffset * ($currentRow - 1)}in" />

			<!-- Add procedure header -->
			<rect x="{$xLeftOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" width="{$lineWidth}in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt" />
			<text x="{$xLeftOffset + $codeXOffset}in" y="{$yTopOffset + $headerYOffset + 0.009 - $yOffset * 3}in" font-family="Arial" font-weight="bold">DIAGNOSES</text>

		</xsl:if>
	</xsl:template>

	<xsl:template name="CreateDiagnosesColumnLayout">

		<xsl:param name="maximumRowsInColumn"/>
		<xsl:param name="maximumColumns"/>
		<xsl:param name="totalElements"/>
		<xsl:param name="currentElement"/>
		<xsl:param name="currentRow"/>
		<xsl:param name="currentColumn"/>
		<xsl:param name="currentCategory" select="0"/>

		<xsl:variable name="xLeftOffset" select="0.50"/>
		<xsl:variable name="xOffset" select="1.875"/>
		<xsl:variable name="yTopOffset" select="5.75"/>
		<xsl:variable name="yOffset" select="0.13625"/>
		<xsl:variable name="codeXOffset" select="0.01"/>
		<xsl:variable name="descriptionXOffset" select="0.29"/>
		<xsl:variable name="codeYOffset" select="0.04"/>
		<xsl:variable name="descriptionYOffset" select="0.028"/>
		<xsl:variable name="codeWidth" select="0.30"/>
		<xsl:variable name="descriptionWidth" select="1.61"/>

		<xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
			<xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.DiagnosisCategory'', $currentElement)]"/>

			<xsl:choose>
				<xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
					<!-- There isn''t enough room to print on this column -->

					<!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
					<xsl:call-template name="CreateDiagnosesColumnLayout">
						<xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
						<xsl:with-param name="maximumColumns" select="$maximumColumns"/>
						<xsl:with-param name="totalElements" select="$totalElements"/>
						<xsl:with-param name="currentElement" select="$currentElement"/>
						<xsl:with-param name="currentRow" select="1"/>
						<xsl:with-param name="currentColumn" select="$currentColumn + 1"/>
						<xsl:with-param name="currentCategory" select="0"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$currentCategory != $CurrentCategoryIndex">
					<!-- category is not the same but there is enough room on this column so print out the category -->

					<!-- Creates the actual category line -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $descriptionYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" class="bold" />

					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 2)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

					<!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
					<xsl:call-template name="CreateDiagnosesColumnLayout">
						<xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
						<xsl:with-param name="maximumColumns" select="$maximumColumns"/>
						<xsl:with-param name="totalElements" select="$totalElements"/>
						<xsl:with-param name="currentElement" select="$currentElement + 1"/>
						<xsl:with-param name="currentRow" select="$currentRow + 2"/>
						<xsl:with-param name="currentColumn" select="$currentColumn"/>
						<xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- The category is the same and there is enough room on this column so print out the detail -->

					<!-- Creates the detail lines -->
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$codeWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" />
					<text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $codeYOffset + $yOffset * ($currentRow + 1)}in" width="{$descriptionWidth}in" height="0.10in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" />

					<!-- Calls the same template recursively -->
					<xsl:call-template name="CreateDiagnosesColumnLayout">
						<xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
						<xsl:with-param name="maximumColumns" select="$maximumColumns"/>
						<xsl:with-param name="totalElements" select="$totalElements"/>
						<xsl:with-param name="currentElement" select="$currentElement + 1"/>
						<xsl:with-param name="currentRow" select="$currentRow + 1"/>
						<xsl:with-param name="currentColumn" select="$currentColumn"/>
						<xsl:with-param name="currentCategory" select="$CurrentCategoryIndex"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>
	</xsl:template>

	<xsl:template match="/formData/page">
		<xsl:variable name="DiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])"/>
		<xsl:variable name="ProceduresCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])"/>
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="300">
			<defs>
				<style type="text/css">
					g
					{
					font-family: Arial Narrow,Arial,Helvetica;
					font-size: 7pt;
					font-style: Normal;
					font-weight: Normal;
					alignment-baseline: text-before-edge;
					}

					text.bold
					{
					font-family: Arial,Arial Narrow,Helvetica;
					font-size: 8pt;
					font-style: Normal;
					font-weight: bold;
					alignment-baseline: text-before-edge;
					}

					text
					{
					baseline-shift: -100%;
					}

					g#DiagnosisGrid line
					{
					stroke: black;
					}

					g#ProceduresGrid line
					{
					stroke: black;
					}
          
          g line
          {
          stroke: black;
          }

				</style>
			</defs>

			<!-- Practice Information -->
		  <g id ="PracticeInformation">
        <xsl:variable name="practiceAddress" select="concat(data[@id=''EncounterForm.1.FullPracticeName1''], '' '', data[@id=''EncounterForm.1.FullPracticeAddress1''])"/>

        <text x="0.54in" y="0.45in" width="7.50in" height="0.10in" font-size="8pt">
          <xsl:value-of select="$practiceAddress"/>
        </text>
			</g>

			<g id="PatientInformation">
				<rect x="0.50in" y="0.62in" width="7.50in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
				<text x="0.52in" y="0.62in" font-weight="bold">PATIENT INFORMATION</text>
				<line x1="3.0in" y1="0.745in" x2="3.0in" y2="2.0366in" stroke="black"></line>
			  <text x="0.51in" y="0.775in" font-size="5pt">PATIENT CONTACT</text>
        <text x="0.54in" y="0.855in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.PatientName1" class="bold"/>
        <text x="0.54in" y="0.985in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.AddressLine11"/>
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.54in" y="1.115in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.AddressLine21"/>
            <text x="0.54in" y="1.245in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1"/>
            <text x="0.54in" y="1.375in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.FullPhone1"/>
          </xsl:when>
          <xsl:otherwise>
            <text x="0.54in" y="1.115in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.CityStateZip1"/>
            <text x="0.54in" y="1.245in" width="2.47in" height="0.10in" valueSource="EncounterForm.1.FullPhone1"/>
          </xsl:otherwise>
        </xsl:choose>
        <line x1="0.50in" y1="1.7783in" x2="8.0in" y2="1.7783in" stroke="black"></line>
				<text x="0.51in" y="1.8083in" font-size="5pt">PATIENT ID</text>
				<text x="0.54in" y="1.8883in" width="1.21in" height="0.10in" valueSource="EncounterForm.1.PatientID1"/>
				<text x="1.76in" y="1.8083in" font-size="5pt">DATE OF BIRTH</text>
			  <text x="1.79in" y="1.8883in" width="1.21in" height="0.10in" valueSource="EncounterForm.1.DOBAge1"/>
        <line x1="0.50in" y1="2.0366in" x2="8.0in" y2="2.0366in" stroke="black"></line>
		  </g>

      <g id="AppointmentInformation">
        <text x="3.02in" y="0.62in" font-weight="bold">APPOINTMENT INFORMATION</text>
        <line x1="4.50in" y1="0.745in" x2="4.50in" y2="2.0366in" stroke="black"></line>
        <text x="3.01in" y="0.775in" font-size="5pt">DATE/TIME</text>
        <text x="3.04in" y="0.855in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.AppDateTime1"/>
        <line x1="3.0in" y1="1.0033in" x2="6.0in" y2="1.0033in" stroke="black"></line>
        <text x="3.01in" y="1.0333in" font-size="5pt">DATE OF LAST PCP VISIT</text>
        <line x1="3.0in" y1="1.2616in" x2="8.0in" y2="1.2616in" stroke="black"></line>
        <text x="3.01in" y="1.2916in" font-size="5pt">PCP</text>
        <text x="3.04in" y="1.3716in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.PCP1"/>
        <line x1="3.0in" y1="1.52in" x2="8.0in" y2="1.52in" stroke="black"></line>
        <text x="3.01in" y="1.55in" font-size="5pt">REFERRING PHYSICIAN</text>
        <text x="3.04in" y="1.63in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.RefProvider1"/>
        <text x="3.01in" y="1.8083in" font-size="5pt">TREATING PHYSICIAN</text>
        <text x="3.04in" y="1.8883in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.Provider1"/>
      </g>

      <g id="InsuranceCoverage">
        <text x="4.52in" y="0.62in" font-weight="bold">INSURANCE COVERAGE</text>
        <line x1="6.0in" y1="0.745in" x2="6.0in" y2="1.7783in" stroke="black"></line>
        <text x="4.51in" y="0.775in" font-size="5pt">PRIMARY INSURANCE</text>
        <text x="4.54in" y="0.855in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.PrimaryIns1"/>
        <text x="4.51in" y="1.0333in" font-size="5pt">SECONDARY INSURANCE</text>
        <text x="4.54in" y="1.1133in" width="1.47in" height="0.10in" valueSource="EncounterForm.1.SecondaryIns1"/>
        <text x="4.51in" y="1.2916in" font-size="5pt">COPAY</text>
        <text x="4.54in" y="1.3716in" width="0.73in" height="0.10in" valueSource="EncounterForm.1.Copay1"/>
        <line x1="5.25in" y1="1.2616in" x2="5.25in" y2="2.0366in" stroke="black"></line>
        <text x="5.26in" y="1.2916in" font-size="5pt">DEDUCTIBLE</text>
        <text x="5.29in" y="1.3716in" width="0.73in" height="0.10in" valueSource="EncounterForm.1.Deductible1"/>
        <text x="4.51in" y="1.55in" font-size="5pt">REFERRAL #</text>
        <text x="4.54in" y="1.63in" width="0.73in" height="0.10in" valueSource="EncounterForm.1.AuthNumber1"/>
        <text x="5.26in" y="1.55in" font-size="5pt">REFERRAL SOURCE</text>
        <text x="5.29in" y="1.63in" width="0.73in" height="0.10in" valueSource="EncounterForm.1.ReferringSource1"/>
      </g>

      <g id="PaymentOnAccount">
        <text x="6.02in" y="0.62in" font-weight="bold">PAYMENT ON ACCOUNT</text>
        <text x="6.01in" y="0.775in" font-size="5pt">PAYMENT METHOD</text>
        <circle cx="6.12in" cy="0.9258in" r="0.04in" fill="none" stroke="black"/>
        <text x="6.32in" y="0.8858in" font-size="5pt" >CASH</text>
        <circle cx="6.12in" cy="1.0658in" r="0.04in" fill="none" stroke="black"/>
        <text x="6.32in" y="1.0258in" font-size="5pt" >CREDIT CARD</text>
        <circle cx="6.12in" cy="1.2058in" r="0.04in" fill="none" stroke="black"/>
        <text x="6.32in" y="1.1658in" font-size="5pt" >CHECK #</text>
        <line x1="7.0in" y1="0.745in" x2="7.0in" y2="1.2616in" stroke="black"></line>
        <text x="7.01in" y="0.775in" font-size="5pt">BALANCE DUE</text>
        <line x1="7.0in" y1="1.0033in" x2="8.0in" y2="1.0033in" stroke="black"></line>
        <text x="7.01in" y="1.0333in" font-size="5pt">TODAY''S PAYMENT</text>
      </g>

      <g id="Notes">
        <text x="6.01in" y="1.2916in" font-size="5pt">NOTES</text>
      </g>

			<g id="ReturnSchedule">
				<text x="6.01in" y="1.55in" font-size="5pt">RETURN SCHEDULE:</text>
			  <text x="6.08in" y="1.66in" font-size="5pt">_____        D                W                  M                Y               PRN_____</text>
		  </g>

      <g id="GlobalEnds">
        <text x="4.51in" y="1.8083in" font-size="5pt">GLOBAL ENDS</text>
      </g>

      <g id="Modifiers">
        <text x="5.26in" y="1.8083in" font-size="5pt">MODIFIERS:</text>
        <text x="5.29in" y="1.8883in" font-size="5pt">LT         1         2         3         4         5         RT         1         2         3         4         5</text>
        <text x="5.49in" y="1.9483in" font-size="5pt">TA       T1       T2       T3       T4                    T5       T6       T7       T8       T9</text>
      </g>

			<g id="ProceduresGrid">
				<xsl:call-template name="CreateProceduresGridLines">
					<xsl:with-param name="maximumRows" select="26"/>
					<xsl:with-param name="currentRow" select="1"/>
				</xsl:call-template>
			</g>

			<g id="ProceduresDetails">
				<xsl:call-template name="CreateProceduresColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="27"/>
					<xsl:with-param name="maximumColumns" select="4"/>
					<xsl:with-param name="totalElements" select="$ProceduresCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>

			<g id="DiagnosisGrid">
				<xsl:call-template name="CreateDiagnosesGridLines">
					<xsl:with-param name="maximumRows" select="29"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="sectionHeader" select="1"/>
				</xsl:call-template>
			</g>

			<g id="DiagnosisDetails">
				<xsl:call-template name="CreateDiagnosesColumnLayout">
					<xsl:with-param name="maximumRowsInColumn" select="30"/>
					<xsl:with-param name="maximumColumns" select="4"/>
					<xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
					<xsl:with-param name="currentElement" select="1"/>
					<xsl:with-param name="currentRow" select="1"/>
					<xsl:with-param name="currentColumn" select="1"/>
					<xsl:with-param name="currentCategory" select="0"/>
				</xsl:call-template>
			</g>

      <g id="Signature">
        <text x="0.50in" y="10.23in" font-weight="bold">I hereby certify that I have rendered the above services.</text>
        <text x="0.50in" y="10.53in" font-weight="bold">PHYSICIAN''S SIGNATURE</text>
        <line x1="1.57in" y1="10.63in" x2="5.50in" y2="10.63in" />
        <text x="5.60in" y="10.53in" font-weight="bold">DATE</text>
        <line x1="5.88in" y1="10.63in" x2="8.0in" y2="10.63in" />
      </g>

		</svg>
	</xsl:template>
</xsl:stylesheet>'
WHERE PrintingFormDetailsID = 66


GO


---------------------------------------------------------------------------------
-- Case 16616:   Account Activity Report Modifications
---------------------------------------------------------------------------------
update report
set reportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters paging="true" pageColumnCount="0" pageCharacterCount="650000" headerExtractCharacterCount="100000">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="StartDate" toDateParameter="EndDate" text="Dates:" default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="StartDate" text="From:"  />
    <basicParameter type="Date" parameterName="EndDate" text="To:"  />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type." default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Date of Service" value="D" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="RevenueCategoryID" text="Revenue Category:" description="Limits the report by Revenue Category." default="-1" ignore="-1">
      <value displayText="ALL" value="-1" />
      <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24"/>
      <value displayText="Anesthesia (00100-01999)" value="1"/>
      <value displayText="Category II Codes (0001F-6999F)" value="46"/>
      <value displayText="Category III Codes (0001T-0999T)" value="47"/>
      <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25"/>
      <value displayText="Dental Procedures (D0120-D9999)" value="26"/>
      <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27"/>
      <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28"/>
      <value displayText="Durable Medical Equipment (E0100-E9999)" value="29"/>
      <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30"/>
      <value displayText="Evaluation and Management (99201-99499)" value="2"/>
      <value displayText="Hearing Services (V5008-V5364)" value="31"/>
      <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32"/>
      <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33"/>
      <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34"/>
      <value displayText="Medical Services (M0064-M0302)" value="35"/>
      <value displayText="Medicine (90281-99199)" value="3"/>
      <value displayText="Medicine (99500-99602)" value="4"/>
      <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36"/>
      <value displayText="Orthotic Procedures (L0100-L4398)" value="37"/>
      <value displayText="Pathology and Laboratory (80048-89399)" value="5"/>
      <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38"/>
      <value displayText="Private Payer Codes (S0009-S9999)" value="39"/>
      <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40"/>
      <value displayText="Prosthetic Procedures (L5000-L9900)" value="41"/>
      <value displayText="Radiology (70010-79999)" value="6"/>
      <value displayText="Rehabilitative Services (H0001-H2037)" value="42"/>
      <value displayText="Surgery - Auditory System (69000-69979)" value="7"/>
      <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8"/>
      <value displayText="Surgery - Digestive System (40490-49999)" value="9"/>
      <value displayText="Surgery - Endocrine System (60000-60699)" value="10"/>
      <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11"/>
      <value displayText="Surgery - Female Genital System (56405-58999)" value="12"/>
      <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13"/>
      <value displayText="Surgery - Integumentary System (10040-19499)" value="14"/>
      <value displayText="Surgery - Intersex (55970-55980)" value="15"/>
      <value displayText="Surgery - Male Genital System (54000-55899)" value="16"/>
      <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17"/>
      <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18"/>
      <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19"/>
      <value displayText="Surgery - Nervous System (61000-64999)" value="20"/>
      <value displayText="Surgery - Operating Microscope (69990-69990)" value="21"/>
      <value displayText="Surgery - Respiratory System (30000-32999)" value="22"/>
      <value displayText="Surgery - Urinary System (50010-53899)" value="23"/>
      <value displayText="Temporary Codes (Q0034-Q9999)" value="43"/>
      <value displayText="Transportation Services (A0080-A0999)" value="44"/>
      <value displayText="Vision Services (V2020-V2799)" value="45"/>
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="RevenueProcedureCodeType" text="Rev. Category Code:" description="Limit the Revenue Category filter by code type." default="P">
      <value displayText="Procedure Code" value="P" />
      <value displayText="Billing Code" value="B" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):"/>
    <extendedParameter type="ComboBox" parameterName="Groupby" text="Group By:" description="Select the grouping." default="1">
      <value displayText="Provider" value="1" />
      <value displayText="Service Location" value="2" />
      <value displayText="Department" value="3" />
      <value displayText="Revenue Category" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
where Name = 'Account Activity Report'
GO

---------------------------------------------------------------------------------
-- Persist RawEOBXml when ERA parsing occurs
---------------------------------------------------------------------------------
CREATE TABLE PaymentRawEOB(PaymentRawEOBID INT IDENTITY(1,1), PracticeID INT, ClearinghouseResponseID INT, 
ParseType CHAR(1), EncounterID INT, ClaimID INT, RawEOBXML XML CONSTRAINT PK_PaymentRawEOB PRIMARY KEY NONCLUSTERED (PaymentRawEOBID))
GO

CREATE UNIQUE CLUSTERED INDEX CI_PaymentRawEOB
ON PaymentRawEOB(PracticeID, ClearinghouseResponseID, EncounterID, ClaimID, ParseType)

GO

ALTER TABLE PaymentEncounter ADD PaymentRawEOBID INT

GO

ALTER TABLE PaymentClaim ADD PaymentRawEOBID INT

GO

---------------------------------------------------------------------------------
-- Case 17654:   RecordEDITransmission must be adapted to handle Z-number types PCNs 
---------------------------------------------------------------------------------

ALTER TABLE BillTransmission ADD
	ClaimPcn varchar(64) NULL
GO

---------------------------------------------------------------------------------
-- Case 14534:   Add new "Encounter Options" task, to setup defaults and other options for charge entry 
---------------------------------------------------------------------------------
ALTER TABLE Practice ADD 
	EOSchedulingProviderID INT NULL,
	EORenderingProviderID INT NULL,
	EOSupervisingProviderID INT NULL,
	EOServiceLocationID INT NULL,
	EOShowProcedureDescription bit NOT NULL DEFAULT 1,
	EOShowDiagnosisDescription bit NOT NULL DEFAULT 1,
	EOPopulateCopay bit NOT NULL DEFAULT 1

GO

ALTER TABLE [Practice]  ADD  CONSTRAINT [FK_Practice_SchedulingDoctor] FOREIGN KEY([EOSchedulingProviderID])
REFERENCES [Doctor] ([DoctorID])
GO

ALTER TABLE [Practice]  ADD  CONSTRAINT [FK_Practice_RenderingDoctor] FOREIGN KEY([EORenderingProviderID])
REFERENCES [Doctor] ([DoctorID])
GO

ALTER TABLE [Practice]  ADD  CONSTRAINT [FK_Practice_SupervisingDoctor] FOREIGN KEY([EOSupervisingProviderID])
REFERENCES [Doctor] ([DoctorID])
GO

ALTER TABLE [Practice]  ADD  CONSTRAINT [FK_Practice_ServiceLocation] FOREIGN KEY([EOServiceLocationID])
REFERENCES [ServiceLocation] ([ServiceLocationID])
GO



/*-----------------------------------------------------------------------------
 Case 17917:   Create receipt report
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
	95, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Payment Receipt', 
	'Receipt for payment made.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPaymentReceipt',
	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters defaultMessage="Please click on Customize and select a Payment to display a report.">
		  <basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="ClientTime" parameterName="ClientTime" />
			<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
		  </basicParameters>
		  <extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="Payment" parameterName="PaymentID" text="Payment:"/>
			<extendedParameter type="ComboBox" parameterName="ReportType" text="Balance:" description="Select from either Open balance or All"    default="O">
			  <value displayText="Open" value="O" />
			  <value displayText="All" value="A" />
			</extendedParameter>
		  </extendedParameters>
		</parameters>',
	'Payment &Receipt', 
	'ReadPaymentReceiptReport',
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
 Case 14530:   Create new "itemization of charges" report using existing SP
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
	5, 
	55, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Itemization of Charges', 
	'This report shows a summary of charges over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptItemizationOfCharges',
	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters defaultMessage="Please click on Customize and select a Patient to display a report.">
		  <basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="ClientTime" parameterName="ClientTime" />
			<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
			<basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
			<basicParameter type="Date" parameterName="EndDate" text="As Of:"/>
		  </basicParameters>
		  <extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
			  <value displayText="Posting Date" value="P" />
			  <value displayText="Service Date" value="S" />
			</extendedParameter>
			<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="0" ignore="0" />
		  </extendedParameters>
		</parameters>',
	'&Itemization of Charges', 
	'ReadItemizationOfChargesReport',
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

-- Remittance Remark Creation Script
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('RemittanceRemark') AND type in ('U'))
BEGIN 
	CREATE TABLE RemittanceRemark(
		[RemittanceRemarkID] [int] IDENTITY(1,1) NOT NULL,
		[RemittanceCode] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RemittanceDescription] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RemittanceNotes] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_RemittanceRemarks_CreatedDate]  DEFAULT (getdate()),
		[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_RemittanceRemarks_CreatedUserID]  DEFAULT ((0)),
		[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_RemittanceRemarks_ModifiedDate]  DEFAULT (getdate()),
		[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_RemittanceRemarks_ModifiedUserID]  DEFAULT ((0)),
		[KareoLastModifiedDate] [datetime] NULL
	) 
END
GO

INSERT INTO RemittanceRemark(
							RemittanceCode,
							RemittanceDescription,
							RemittanceNotes)
						SELECT 
							RemittanceCode,
							RemittanceDescription,
							RemittanceNotes
						FROM MigrationX_Dev..RemittanceRemark


---------------------------------------------------------------------------------
-- Case 17966:   Fix report hyperlink to use new receive payment task.
---------------------------------------------------------------------------------
UPDATE ReportHyperlink
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>  <task name="Receive Payment New">   <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">    <method name="" />    <method name="Add">     <methodParam param="Editing" />     <methodParam param="true" type="System.Boolean" />    </method>    <method name="Add">     <methodParam param="PaymentID" />     <methodParam param="{0}" type="System.Int32" />     <methodParam param="true" type="System.Boolean" />    </method>   </object>  </task>'
WHERE Description = 'Receive Payment Task'

---------------------------------------------------------------------------------
-- Case 18116:   Update description of links on various section homepages
---------------------------------------------------------------------------------

UPDATE RC
SET Description = CASE 
	WHEN RC.[Name] = 'Key Indicators' THEN 'View a list of reports with summary information on the key performance indicators for the practice.'
	WHEN RC.[Name] = 'Payments' THEN 'View a list of reports with summary and detail information about payments, adjustments, denials, and more.'
	WHEN RC.[Name] = 'Accounts Receivable' THEN 'View a list of reports with summary and detail information about your accounts receivable.'
	WHEN RC.[Name] = 'Productivity & Analysis' THEN 'View a list of reports with information about user, provider, and practice productivity and activity.'
	WHEN RC.[Name] = 'Patients' THEN 'View a list of reports with information about patients and their account activity.'
	WHEN RC.[Name] = 'Refunds' THEN 'View a list of reports with summary and detail information about refunds.'
	WHEN RC.[Name] = 'Appointments' THEN 'View a list of reports with summary and detail information about appointments.'
	WHEN RC.[Name] = 'Company' THEN 'View a list of reports with information that spans your entire organization.'
	WHEN RC.[Name] = 'Settings' THEN 'View a list of reports with detail information about practice settings.'
	WHEN RC.[Name] = 'Encounters' THEN 'View a list of reports with summary and detail information about encounters and charges.'
	ELSE RC.[Description] END
FROM ReportCategory RC

---------------------------------------------------------------------------------
-- Case 00000:   Name of case
---------------------------------------------------------------------------------

--ROLLBACK
--COMMIT

