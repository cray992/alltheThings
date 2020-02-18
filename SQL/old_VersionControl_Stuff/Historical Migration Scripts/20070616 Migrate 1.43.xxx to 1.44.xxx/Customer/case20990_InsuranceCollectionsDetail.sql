
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
	30, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Insurance Collections Detail', 
	'This report shows a detailed analysis of claims pending insurance payment.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptInsuranceCollectionsDetail',
	'<?xml version="1.0" encoding="utf-8" ?>
		<parameters paging="true" pageColumnCount="15" pageCharacterCount="650000" headerExtractCharacterCount="100000" defaultMessage="Please click on Customize and select an Insurance to display.">
		  <basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="ClientTime" parameterName="ClientTime" />
			<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
			<basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
		    <basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
		  </basicParameters>
		  <extendedParameters>
			<extendedParameter type="Separator" text="Filter" />

			<extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Set the date to start aging from." default="F" >
			  <value displayText="First Billed Date" value="F" />
			  <value displayText="Last Billed Date" value="L" />
			  <value displayText="Post Date" value="P" />
			  <value displayText="Service Date" value="S" />
			</extendedParameter>

			<extendedParameter type="Provider" parameterName="RenderingProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
			<extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />

			<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" default="-1" ignore="-1" />
			<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />

			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />

			<extendedParameter type="ComboBox" parameterName="Age" text="Age:" description="Filter by age." default="-1" >
			  <value displayText="All" value="-1" />
			  <value displayText="Current+" value="0" />
			  <value displayText="30+" value="30" />
			  <value displayText="60+" value="60" />
			  <value displayText="90+" value="90" />
			  <value displayText="120+" value="120" />
			</extendedParameter>


			<extendedParameter type="ComboBox" parameterName="Status" text="Status:" description="Filter by claim status." default="A" ignore="A" >
			  <value displayText="All" value="A" />
			  <value displayText="Ready" value="R" />
			  <value displayText="Pending" value="P" />
			  <value displayText="Errors" value="E" />
			</extendedParameter>


			<extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select the grouping option." default="1">
				<value displayText="Claim Status" value="1" />
				<value displayText="Error Reason" value="2" />
				<value displayText="Age" value="3" />
				<value displayText="Insurance Company" value="4" />
				<value displayText="Insurance Plan" value="5" />
				<value displayText="Payer Scenario" value="6" />
				<value displayText="Rendering Provider" value="7" />
				<value displayText="Scheduling Provider" value="8" />
				<value displayText="Patient" value="9" />
				<value displayText="Procedure" value="10" />
				<value displayText="Procedure Category" value="11" />
			</extendedParameter>


			<extendedParameter type="ComboBox" parameterName="Group2by" text="Subgroup by:" description="Select the subgrouping option." default="2">
				<value displayText="Claim Status" value="1" />
				<value displayText="Error Reason" value="2" />
				<value displayText="Age" value="3" />
				<value displayText="Insurance Company" value="4" />
				<value displayText="Insurance Plan" value="5" />
				<value displayText="Payer Scenario" value="6" />
				<value displayText="Rendering Provider" value="7" />
				<value displayText="Scheduling Provider" value="8" />
				<value displayText="Patient" value="9" />
				<value displayText="Procedure" value="10" />
				<value displayText="Procedure Category" value="11" />
			</extendedParameter>


			<extendedParameter type="ComboBox" parameterName="SortBy" text="SortBy:" description="Select the sorting option." default="V">
			  <value displayText="Value" value="V" />
			  <value displayText="Balance" value="B" />
			  <value displayText="Age" value="A" />
			</extendedParameter>

		  </extendedParameters>
		</parameters>',
	'Insurance Collections Detail',
	'ReadInsuranceCollectionsDetailReport',
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



Insert INto reporthyperlink( ReportHyperlinkID, Description, ReportParameters )
SELECT
42,
'Insurance Collections Detail Report',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Insurance Collections Detail" />
      <methodParam param="true" type="System.Boolean" />
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="DateType" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="RenderingProviderID" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="SchedulingProviderID" />
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
            <methodParam param="PayerScenarioID" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="PatientID" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="ProcedureCodeStr" />
            <methodParam param="{9}" />
          </method>
          <method name="Add">
            <methodParam param="Age" />
            <methodParam param="{10}" />
          </method>
          <method name="Add">
            <methodParam param="Status" />
            <methodParam param="{11}" />
          </method>
          <method name="Add">
            <methodParam param="Group1by" />
            <methodParam param="{12}" />
          </method>
          <method name="Add">
            <methodParam param="Group2by" />
            <methodParam param="{13}" />
          </method>
          <method name="Add">
            <methodParam param="SortBy" />
            <methodParam param="{14}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyID" />
            <methodParam param="{15}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyPlanID" />
            <methodParam param="{16}" />
          </method>
          <method name="Add">
            <methodParam param="ErrorReasonID" />
            <methodParam param="{17}" />
          </method>
          <method name="Add">
            <methodParam param="ProcedureCategoryID" />
            <methodParam param="{18}" />
          </method>
          <method name="Add">
            <methodParam param="AgeEnd" />
            <methodParam param="{19}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'

GO

/*
select * from Report

update Report
set ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
		<parameters paging="true" pageColumnCount="15" extraHeaderLength="1234" pageCharacterCount="650000" headerExtractCharacterCount="100000" defaultMessage="Please click on Customize and select an Insurance to display.">
		  <basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="ClientTime" parameterName="ClientTime" />
			<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
			<basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
		    <basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
		  </basicParameters>
		  <extendedParameters>
			<extendedParameter type="Separator" text="Filter" />

			<extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Set the date to start aging from." default="F" >
			  <value displayText="First Billed Date" value="F" />
			  <value displayText="Last Billed Date" value="L" />
			  <value displayText="Post Date" value="P" />
			  <value displayText="Service Date" value="S" />
			</extendedParameter>

			<extendedParameter type="Provider" parameterName="RenderingProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
			<extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
			<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
			<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
			<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
			<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />

			<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" default="-1" ignore="-1" />
			<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />

			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />

			<extendedParameter type="ComboBox" parameterName="Age" text="Age:" description="Filter by age." default="-1" >
			  <value displayText="All" value="-1" />
			  <value displayText="Current+" value="0" />
			  <value displayText="30+" value="30" />
			  <value displayText="60+" value="60" />
			  <value displayText="90+" value="90" />
			  <value displayText="120+" value="120" />
			</extendedParameter>


			<extendedParameter type="ComboBox" parameterName="Status" text="Status:" description="Filter by claim status." default="A" ignore="A" >
			  <value displayText="All" value="A" />
			  <value displayText="Ready" value="R" />
			  <value displayText="Pending" value="P" />
			  <value displayText="Errors" value="E" />
			</extendedParameter>


			<extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select the grouping option." default="1">
				<value displayText="Claim Status" value="1" />
				<value displayText="Error Reason" value="2" />
				<value displayText="Age" value="3" />
				<value displayText="Insurance Company" value="4" />
				<value displayText="Insurance Plan" value="5" />
				<value displayText="Payer Scenario" value="6" />
				<value displayText="Rendering Provider" value="7" />
				<value displayText="Scheduling Provider" value="8" />
				<value displayText="Patient" value="9" />
				<value displayText="Procedure" value="10" />
				<value displayText="Procedure Category" value="11" />
			</extendedParameter>


			<extendedParameter type="ComboBox" parameterName="Group2by" text="Subgroup by:" description="Select the subgrouping option." default="2">
				<value displayText="Claim Status" value="1" />
				<value displayText="Error Reason" value="2" />
				<value displayText="Age" value="3" />
				<value displayText="Insurance Company" value="4" />
				<value displayText="Insurance Plan" value="5" />
				<value displayText="Payer Scenario" value="6" />
				<value displayText="Rendering Provider" value="7" />
				<value displayText="Scheduling Provider" value="8" />
				<value displayText="Patient" value="9" />
				<value displayText="Procedure" value="10" />
				<value displayText="Procedure Category" value="11" />
			</extendedParameter>


			<extendedParameter type="ComboBox" parameterName="SortBy" text="SortBy:" description="Select the sorting option." default="V">
			  <value displayText="Value" value="V" />
			  <value displayText="Balance" value="B" />
			  <value displayText="Age" value="A" />
			</extendedParameter>

		  </extendedParameters>
		</parameters>'
where name = 'Insurance Collections Detail'



Update ReportHyperlink
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Insurance Collections Detail" />
      <methodParam param="true" type="System.Boolean" />
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="DateType" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="RenderingProviderID" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="SchedulingProviderID" />
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
            <methodParam param="PayerScenarioID" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="PatientID" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="ProcedureCodeStr" />
            <methodParam param="{9}" />
          </method>
          <method name="Add">
            <methodParam param="Age" />
            <methodParam param="{10}" />
          </method>
          <method name="Add">
            <methodParam param="Status" />
            <methodParam param="{11}" />
          </method>
          <method name="Add">
            <methodParam param="Group1by" />
            <methodParam param="{12}" />
          </method>
          <method name="Add">
            <methodParam param="Group2by" />
            <methodParam param="{13}" />
          </method>
          <method name="Add">
            <methodParam param="SortBy" />
            <methodParam param="{14}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyID" />
            <methodParam param="{15}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyPlanID" />
            <methodParam param="{16}" />
          </method>
          <method name="Add">
            <methodParam param="ErrorReasonID" />
            <methodParam param="{17}" />
          </method>
          <method name="Add">
            <methodParam param="ProcedureCategoryID" />
            <methodParam param="{18}" />
          </method>
          <method name="Add">
            <methodParam param="AgeEnd" />
            <methodParam param="{19}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>',
modifiedDate = getdate()
where ReportHyperlinkID = 42


*/

