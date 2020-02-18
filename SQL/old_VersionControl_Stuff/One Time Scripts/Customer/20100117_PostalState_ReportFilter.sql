/****** Object:  Table [dbo].[PostalState]    Script Date: 01/17/2010 11:26:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PostalState]') AND type in (N'U'))
DROP TABLE [dbo].[PostalState]
GO



create table PostalState(
	PostalStateID int identity(1,1)
	, Name char(2) primary key clustered
	, LongName varchar(50) 
	)
	
GO


insert into PostalState( LongName, Name) values('ALABAMA', 'AL')
insert into PostalState( LongName, Name) values('ALASKA', 'AK')
insert into PostalState( LongName, Name) values('AMERICAN SAMOA', 'AS')
insert into PostalState( LongName, Name) values('ARIZONA', 'AZ')
insert into PostalState( LongName, Name) values('ARKANSAS', 'AR')
insert into PostalState( LongName, Name) values('CALIFORNIA', 'CA')
insert into PostalState( LongName, Name) values('COLORADO', 'CO')
insert into PostalState( LongName, Name) values('CONNECTICUT', 'CT')
insert into PostalState( LongName, Name) values('DELAWARE', 'DE')
insert into PostalState( LongName, Name) values('DISTRICT OF COLUMBIA', 'DC')
insert into PostalState( LongName, Name) values('FEDERATED STATES OF MICRONESIA', 'FM')
insert into PostalState( LongName, Name) values('FLORIDA', 'FL')
insert into PostalState( LongName, Name) values('GEORGIA', 'GA')
insert into PostalState( LongName, Name) values('GUAM', 'GU')
insert into PostalState( LongName, Name) values('HAWAII', 'HI')
insert into PostalState( LongName, Name) values('IDAHO', 'ID')
insert into PostalState( LongName, Name) values('ILLINOIS', 'IL')
insert into PostalState( LongName, Name) values('INDIANA', 'IN')
insert into PostalState( LongName, Name) values('IOWA', 'IA')
insert into PostalState( LongName, Name) values('KANSAS', 'KS')
insert into PostalState( LongName, Name) values('KENTUCKY', 'KY')
insert into PostalState( LongName, Name) values('LOUISIANA', 'LA')
insert into PostalState( LongName, Name) values('MAINE', 'ME')
insert into PostalState( LongName, Name) values('MARSHALL ISLANDS', 'MH')
insert into PostalState( LongName, Name) values('MARYLAND', 'MD')
insert into PostalState( LongName, Name) values('MASSACHUSETTS', 'MA')
insert into PostalState( LongName, Name) values('MICHIGAN', 'MI')
insert into PostalState( LongName, Name) values('MINNESOTA', 'MN')
insert into PostalState( LongName, Name) values('MISSISSIPPI', 'MS')
insert into PostalState( LongName, Name) values('MISSOURI', 'MO')
insert into PostalState( LongName, Name) values('MONTANA', 'MT')
insert into PostalState( LongName, Name) values('NEBRASKA', 'NE')
insert into PostalState( LongName, Name) values('NEVADA', 'NV')
insert into PostalState( LongName, Name) values('NEW HAMPSHIRE', 'NH')
insert into PostalState( LongName, Name) values('NEW JERSEY', 'NJ')
insert into PostalState( LongName, Name) values('NEW MEXICO', 'NM')
insert into PostalState( LongName, Name) values('NEW YORK', 'NY')
insert into PostalState( LongName, Name) values('NORTH CAROLINA', 'NC')
insert into PostalState( LongName, Name) values('NORTH DAKOTA', 'ND')
insert into PostalState( LongName, Name) values('NORTHERN MARIANA ISLANDS', 'MP')
insert into PostalState( LongName, Name) values('OHIO', 'OH')
insert into PostalState( LongName, Name) values('OKLAHOMA', 'OK')
insert into PostalState( LongName, Name) values('OREGON', 'OR')
insert into PostalState( LongName, Name) values('PALAU', 'PW')
insert into PostalState( LongName, Name) values('PENNSYLVANIA', 'PA')
insert into PostalState( LongName, Name) values('PUERTO RICO', 'PR')
insert into PostalState( LongName, Name) values('RHODE ISLAND', 'RI')
insert into PostalState( LongName, Name) values('SOUTH CAROLINA', 'SC')
insert into PostalState( LongName, Name) values('SOUTH DAKOTA', 'SD')
insert into PostalState( LongName, Name) values('TENNESSEE', 'TN')
insert into PostalState( LongName, Name) values('TEXAS', 'TX')
insert into PostalState( LongName, Name) values('UTAH', 'UT')
insert into PostalState( LongName, Name) values('VERMONT', 'VT')
insert into PostalState( LongName, Name) values('VIRGIN ISLANDS', 'VI')
insert into PostalState( LongName, Name) values('VIRGINIA', 'VA')
insert into PostalState( LongName, Name) values('WASHINGTON', 'WA')
insert into PostalState( LongName, Name) values('WEST VIRGINIA', 'WV')
insert into PostalState( LongName, Name) values('WISCONSIN', 'WI')
insert into PostalState( LongName, Name) values('WYOMING', 'WY')



update report
set reportparameters = 
'<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
    <basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables." default="B">
      <value displayText="First Billed Date" value="B" />
      <value displayText="Last Billed Date" value="C" />
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" description="Limits the report by scheduling provider" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
     <extendedParameter type="ComboBox" parameterName="PostalState" text="Postal State:" description="Filter by state" default="-1">
      <value displayText="ALL" value="-1" />
      <dataSetValue tableName="dbo.PostalState" />
    </extendedParameter>
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract" />
  </extendedParameters>
</parameters>'
where name = 'A/R Aging Summary'
GO


update report
set reportparameters =
'<parameters paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000" csv="false">
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
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PostalState" text="Postal State:" description="Filter by state" default="-1">
      <value displayText="ALL" value="-1" />
      <dataSetValue tableName="dbo.PostalState" />
    </extendedParameter>
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables." default="B">
      <value displayText="First Billed Date" value="B" />
      <value displayText="Last Billed Date" value="C" />
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range." default="Current+">
      <value displayText="Current+" value="Current+" />
      <value displayText="30+" value="Age31_60" />
      <value displayText="60+" value="Age61_90" />
      <value displayText="90+" value="Age91_120" />
      <value displayText="120+" value="AgeOver120" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range." default="All">
      <value displayText="All" value="All" />
      <value displayText="Less than $0" value="$0-" />
      <value displayText="Greater than $0" value="$0+" />
      <value displayText="$0-$10" value="$0-10" />
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
  </extendedParameters>
</parameters>'
where name = 'A/R Aging by Insurance'
GO

update report
set reportparameters=
'<parameters paging="true" pageColumnCount="14" pageCharacterCount="650000" headerExtractCharacterCount="100000" csv="false">
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
    <extendedParameter type="ComboBox" parameterName="DateType" text="Start Aging From:" description="Sets the date used for aging the receivables." default="B">
      <value displayText="First Billed Date" value="B" />
      <value displayText="Last Billed Date" value="C" />
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PostalState" text="Postal State:" description="Filter by state" default="-1">
      <value displayText="ALL" value="-1" />
      <dataSetValue tableName="dbo.PostalState" />
    </extendedParameter>
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="ComboBox" parameterName="AssignedType" text="Responsibility:" description="Limits by patient, insurance or all responsibility." default="P">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range." default="Current+">
      <value displayText="Current+" value="Current+" />
      <value displayText="30+" value="Age31_60" />
      <value displayText="60+" value="Age61_90" />
      <value displayText="90+" value="Age91_120" />
      <value displayText="120+" value="AgeOver120" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range." default="All">
      <value displayText="All" value="All" />
      <value displayText="Less than $0" value="$0-" />
      <value displayText="Greater than $0" value="$0+" />
      <value displayText="$0-$10" value="$0-10" />
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
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
  </extendedParameters>
</parameters>'
where name = 'A/R Aging by Patient'


GO





update reporthyperlink
set reportparameters = 
'<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="A/R Aging by Insurance" />
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
            <methodParam param="ContractID" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="DateType" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="PostalState" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{8}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
where ReportHyperlinkID = 11

GO

update reportHyperlink
set reportparameters = 
'<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="A/R Aging by Patient" />
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
            <methodParam param="ContractID" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="DateType" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="PostalState" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{8}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
where reporthyperlinkID=12


GO


update report
set reportparameters = 
'<parameters paging="true" pageColumnCount="15" pageCharacterCount="650000" headerExtractCharacterCount="100000" csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date" default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Status:" description="Select Encounter Status" default="3">
      <value displayText="All" value="-1" />
      <value displayText="Approved" value="3" />
      <value displayText="Drafts" value="1" />
      <value displayText="Submitted" value="2" />
      <value displayText="Rejected" value="4" />
      <value displayText="Unpayable" value="7" />
    </extendedParameter>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PostalState" text="Postal State:" description="Filter by state" default="-1">
      <value displayText="ALL" value="-1" />
      <dataSetValue tableName="dbo.PostalState" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderNumberID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group report by:" description="Select to group by Status, Rendering Provider, Service location, Department or Scheduling Provider" default="Status">
      <value displayText="Status" value="Status" />
      <value displayText="Rendering Provider" value="Provider" />
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Department" value="Department" />
      <value displayText="Scheduling Provider" value="SchedulingProvider" />
      <value displayText="Default Rendering Provider" value="DefaultRenderingProvider" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchNumberID" text="Batch #:" />
  </extendedParameters>
</parameters>'
where name = 'Encounters Detail'



GO


update report
set reportparameters = 
'<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="ExportType" parameterName="ExportType" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date" default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" description="Filter by scheduling provider." default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" description="Filter by rendering provider." default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" description="Filter by default rendering provider." default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" description="Filter by service location." default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PostalState" text="Postal State:" description="Filter by state" default="-1">
      <value displayText="ALL" value="-1" />
      <dataSetValue tableName="dbo.PostalState" />
    </extendedParameter>
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" description="Filter by department." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" description="Filter by insurance plan." default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="I" permission="FindInsurancePlan" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" description="Filter by payer scenario." default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PayerTypeID" text="Payment Type:" description="Filter by payer type." default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Copay" value="1" />
      <value displayText="Patient Payment on Account" value="2" />
      <value displayText="Insurance Payment" value="3" />
      <value displayText="Other" value="4" />
    </extendedParameter>
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" description="Filter by patient." default="-1" ignore="-1" permission="FindPatient" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" description="Filter by batch #." />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" />
    <extendedParameter type="ComboBox" parameterName="ShowUnapplied" text="Show Unapplied?:" description="Show unapplied analysis." default="TRUE">
      <value displayText="Yes" value="TRUE" />
      <value displayText="No" value="FALSE" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option." default="1">
      <value displayText="Rendering Provider" value="1" />
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
      <value displayText="Scheduling Provider" value="13" />
      <value displayText="Default Rendering Provider" value="14" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option." default="8">
      <value displayText="Rendering Provider" value="1" />
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
      <value displayText="Scheduling Provider" value="13" />
      <value displayText="Default Rendering Provider" value="14" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnTotal" text="Columns:" description="Select the summarization method." default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
where name = 'Payments Application Summary'

GO

update report
set reportParameters=
'<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="PayerMetric" text="Payer Metric:" description="Select the Payer Metric option" default="0">
      <value displayText="All" value="0" />
      <value displayText="Payer Mix by Patients" value="1" />
      <value displayText="Payer Mix by Encounters" value="2" />
      <value displayText="Payer Mix by Procedures" value="3" />
      <value displayText="Payer Mix by Charges" value="4" />
      <value displayText="Payer Mix by Receipts" value="5" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date" default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="PostalState" text="Postal State:" description="Filter by state" default="-1">
      <value displayText="ALL" value="-1" />
      <dataSetValue tableName="dbo.PostalState" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="EncounterStatus" text="Status:" description="Select Encounter Status" default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Approved" value="3" />
      <value displayText="Drafts" value="1" />
      <value displayText="Submitted" value="2" />
      <value displayText="Rejected" value="4" />
      <value displayText="Unpayable" value="7" />
    </extendedParameter>
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="ComboBox" parameterName="GroupBy" text="Group by:" description="Select the grouping option" default="Provider">
      <value displayText="Revenue Category" value="Revenue Category" />
      <value displayText="Provider" value="Provider" />
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Department" value="Department" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the grouping option" default="Insurance Company">
      <value displayText="Payer Scenario" value="Payer Scenario" />
      <value displayText="Insurance Company" value="Insurance Company" />
      <value displayText="Insurance Plan" value="Insurance Plan" />
      <value displayText="Contract" value="Contract Name" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" />
  </extendedParameters>
</parameters>'
where name='Payer Mix Summary'

GO