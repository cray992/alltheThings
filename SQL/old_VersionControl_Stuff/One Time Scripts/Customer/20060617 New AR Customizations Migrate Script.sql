/*-----------------------------------------------------------------------------
Case 10589 - Add new customization options for A/R Aging Summary report 
-----------------------------------------------------------------------------*/

UPDATE REPORT
SET ReportParameters =
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
		<extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables."    default="B">
			<value displayText="Last Billed Date" value="B" />
			<value displayText="Posting Date" value="P" />
			<value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
	</extendedParameters>
</parameters>'
WHERE Name = 'A/R Aging Summary'
GO




/*-----------------------------------------------------------------------------
Case 10590 - Add new customization options for A/R Aging by Insurance report  
-----------------------------------------------------------------------------*/
UPDATE REPORT
Set ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
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
		<extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables."    default="B">
			<value displayText="Last Billed Date" value="B" />
			<value displayText="Posting Date" value="P" />
			<value displayText="Service Date" value="S" />
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
		<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
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
		<extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field."     default="true">
			<value displayText="Resp Name" value="false" />
			<value displayText="Open Balance" value="true" />
		</extendedParameter>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE Name = 'A/R Aging by Insurance'


GO



/*-----------------------------------------------------------------------------
Case 10591 - Add new customization options for A/R Aging by Patient report  
-----------------------------------------------------------------------------*/
UPDATE REPORT
Set ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
		<basicParameter type="String" parameterName="PayerTypeCode" default="2" />
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
		<extendedParameter type="ComboBox" parameterName="Responsibility" text="Responsibility:" description="Limits by currently assigned or ultimate responsibility."    default="false">
			<value displayText="Currently Assigned" value="false" />
			<value displayText="Ultimate Responsibility" value="true" />
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
		<extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field."     default="true">
			<value displayText="Resp Name" value="false" />
			<value displayText="Open Balance" value="true" />
		</extendedParameter>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE Name = 'A/R Aging by Patient'

GO

/*-----------------------------------------------------------------------------
Case 10681 - Add new report "Payment by Procedure"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptID INT 


-- Builds a static table of revenue centers. We may change to a dynamic list.
declare @RevCenterParameterList varchar(8000)
select @RevCenterParameterList = 
			(
			select name + ' (' + cast(ProcedureCodeStartRange as varchar) + '-' + cast(ProcedureCodeEndRange as varchar) + ')' as [displayText], ProcedureCodeRevenueCenterCategoryID as value
			from ProcedureCodeRevenueCenterCategory  as [value]
			order by name FOR XML auto
			)

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
	10, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Payment by Procedure', 
	'This report shows the average reimbursement by procedure code over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPaymentByProcedure',
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
					<value displayText="ALL" value="-1" />'
					+ @RevCenterParameterList +
				'</extendedParameter> 
				<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
				<extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option"    default="1">    
					<value displayText="Revenue Category" value="Revenue Category" />    
					<value displayText="Provider" value="Provider" />    
					<value displayText="Service Location" value="Service Location" />    
					<value displayText="Department" value="Department" />  
				</extendedParameter> 
			</extendedParameters>
		</parameters>',
	'Payment by &Procedure', 
	'ReadPaymentByProcedureReport')

 

SET @PaymentByProcedureRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@PaymentByProcedureRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@PaymentByProcedureRptID,
	'M',
	GETDATE()
	)


GO




/*-----------------------------------------------------------------------------
Case 10613 - Add new report "Payer Mix Summary"
-----------------------------------------------------------------------------*/
DECLARE @PaymentByProcedureRptID INT 


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
	25, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Payer Mix Summary', 
	'This report shows the payer mix over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPayerMixSummary',
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
			</extendedParameter>
		</extendedParameters>
	</parameters>',
	'Payer Mix Summary', 
	'ReadPayerMixSummaryReport')

 

SET @PaymentByProcedureRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@PaymentByProcedureRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@PaymentByProcedureRptID,
	'M',
	GETDATE()
	)

GO


----------------------------------------------------
-- Case 10689:   Customization of hyperlink
----------------------------------------------------
-- New ReportHyperLink #11
update Reporthyperlink
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="A/R Aging by Insurance" />
			<methodParam param="true" type="System.Boolean"/>
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
						<methodParam param="ProviderID" />
						<methodParam param="{1}" />
					</method>
					<method name="Add">
						<methodParam param="ServiceLocationID" />
						<methodParam param="{2}" />
					</method>
					<method name="Add">
						<methodParam param="DepartmentID" />
						<methodParam param="{3}" />
					</method>
					<method name="Add">
						<methodParam param="PayerScenarioID" />
						<methodParam param="{4}" />
					</method>
					<method name="Add">
						<methodParam param="BatchID" />
						<methodParam param="{5}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>'
WHERE ReportHyperLinkID = 11

Update r
SET ReportParameters = 
		'<?xml version="1.0" encoding="utf-8" ?>
		<task name="Report V2 Viewer">
			<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
				<method name="" />
				<method name="Add">
					<methodParam param="ReportName" />
					<methodParam param="A/R Aging by Patient" />
					<methodParam param="true" type="System.Boolean"/>
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
								<methodParam param="ProviderID" />
								<methodParam param="{1}" />
							</method>
							<method name="Add">
								<methodParam param="ServiceLocationID" />
								<methodParam param="{2}" />
							</method>
							<method name="Add">
								<methodParam param="DepartmentID" />
								<methodParam param="{3}" />
							</method>
							<method name="Add">
								<methodParam param="PayerScenarioID" />
								<methodParam param="{4}" />
							</method>
							<method name="Add">
								<methodParam param="BatchID" />
								<methodParam param="{5}" />
							</method>
						</object>
					</methodParam>
				</method>
			</object>
		</task>'
from ReportHyperLink r
WHERE ReportHyperlinkID = 12


GO


-- Case 11393:   Reorder menu items under Reports -> Settings menu
----------------------------------------------------
Update r 
SET DisplayOrder =
		case Name 
			when 'Providers' THEN 10
			when 'Service Locations' THEN 20
			when 'Provider Numbers' THEN 30
			when 'Group Numbers' THEN 40
			when 'Fee Schedule Detail' THEN 50
			when 'Referring Physicians' THEN 60
			else 90 END,
	modifiedDate = getdate()
from report r
where ReportCategoryID = 9

GO

----------------------------------------------------
-- Case 11394:   Reoder menu items under Reports -> Payments menu 
----------------------------------------------------
Update r
SET DisplayOrder = Case Name 
		when 'Payments Summary' THEN 10
		when 'Payments Detail' THEN 20
		when 'Payments Application' THEN 30
		when 'Missed Copays' THEN 40
		when 'Payer Mix Summary' THEN 50
		when 'Payment by Procedure' THEN 60
		ELSE 90 END,
	ModifiedDate = getdate()
from report r
where ReportCategoryID = 2 

GO
