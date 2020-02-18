update r
set ReportParameters = 
'<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
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
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1" />
	<extendedParameter type="Provider" parameterName="SupervisingProviderID" text="Supervising Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />
    <extendedParameter type="ComboBox" parameterName="RevenueCategoryID" text="Revenue Category:" description="Limits the report by Revenue Category" default="-1" ignore="-1">
      <value displayText="ALL" value="-1" />
      <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24" />
      <value displayText="Anesthesia (00100-01999)" value="1" />
      <value displayText="Category II Codes (0001F-6999F)" value="46" />
      <value displayText="Category III Codes (0001T-0999T)" value="47" />
      <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25" />
      <value displayText="Dental Procedures (D0120-D9999)" value="26" />
      <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27" />
      <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28" />
      <value displayText="Durable Medical Equipment (E0100-E9999)" value="29" />
      <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30" />
      <value displayText="Evaluation and Management (99201-99499)" value="2" />
      <value displayText="Hearing Services (V5008-V5364)" value="31" />
      <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32" />
      <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33" />
      <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34" />
      <value displayText="Medical Services (M0064-M0302)" value="35" />
      <value displayText="Medicine (90281-99199)" value="3" />
      <value displayText="Medicine (99500-99602)" value="4" />
      <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36" />
      <value displayText="Orthotic Procedures (L0100-L4398)" value="37" />
      <value displayText="Pathology and Laboratory (80048-89399)" value="5" />
      <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38" />
      <value displayText="Private Payer Codes (S0009-S9999)" value="39" />
      <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40" />
      <value displayText="Prosthetic Procedures (L5000-L9900)" value="41" />
      <value displayText="Radiology (70010-79999)" value="6" />
      <value displayText="Rehabilitative Services (H0001-H2037)" value="42" />
      <value displayText="Surgery - Auditory System (69000-69979)" value="7" />
      <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8" />
      <value displayText="Surgery - Digestive System (40490-49999)" value="9" />
      <value displayText="Surgery - Endocrine System (60000-60699)" value="10" />
      <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11" />
      <value displayText="Surgery - Female Genital System (56405-58999)" value="12" />
      <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13" />
      <value displayText="Surgery - Integumentary System (10040-19499)" value="14" />
      <value displayText="Surgery - Intersex (55970-55980)" value="15" />
      <value displayText="Surgery - Male Genital System (54000-55899)" value="16" />
      <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17" />
      <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18" />
      <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19" />
      <value displayText="Surgery - Nervous System (61000-64999)" value="20" />
      <value displayText="Surgery - Operating Microscope (69990-69990)" value="21" />
      <value displayText="Surgery - Respiratory System (30000-32999)" value="22" />
      <value displayText="Surgery - Urinary System (50010-53899)" value="23" />
      <value displayText="Temporary Codes (Q0034-Q9999)" value="43" />
      <value displayText="Transportation Services (A0080-A0999)" value="44" />
      <value displayText="Vision Services (V2020-V2799)" value="45" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option." default="1">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Code" value="2" />
      <value displayText="Revenue Category" value="6" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Payer Scenario" value="7" />
      <value displayText="Batch #" value="5" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Default Rendering Provider" value="9" />
	  <value displayText="Supervising Provider" value="10" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
from report r
where name = 'Charges Detail'


update r
SET reportParameters =
'<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
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
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1" />
	<extendedParameter type="Provider" parameterName="SupervisingProviderID" text="Supervising Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
    <extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" description="Limits the report by procedure code" />
    <extendedParameter type="ComboBox" parameterName="RevenueCategoryID" text="Revenue Category:" description="Limits the report by Revenue Category" default="-1" ignore="-1">
      <value displayText="ALL" value="-1" />
      <value displayText="Administrative, Miscellaneous and Investigational (A9150-A9999)" value="24" />
      <value displayText="Anesthesia (00100-01999)" value="1" />
      <value displayText="Category II Codes (0001F-6999F)" value="46" />
      <value displayText="Category III Codes (0001T-0999T)" value="47" />
      <value displayText="Chemotherapy Drugs (J9000-J9999)" value="25" />
      <value displayText="Dental Procedures (D0120-D9999)" value="26" />
      <value displayText="Diagnostic Radiology Services (R0000-R5999)" value="27" />
      <value displayText="Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs) (J0120-J9999)" value="28" />
      <value displayText="Durable Medical Equipment (E0100-E9999)" value="29" />
      <value displayText="Enteral and Parenteral Therapy (B4034-B9999)" value="30" />
      <value displayText="Evaluation and Management (99201-99499)" value="2" />
      <value displayText="Hearing Services (V5008-V5364)" value="31" />
      <value displayText="Hospital Outpatient PPS Codes (C1000-C9999)" value="32" />
      <value displayText="K-Codes: For DMERC Use Only (K0001-K9999)" value="33" />
      <value displayText="Medical and Surgical Supplies (A4206-A7526)" value="34" />
      <value displayText="Medical Services (M0064-M0302)" value="35" />
      <value displayText="Medicine (90281-99199)" value="3" />
      <value displayText="Medicine (99500-99602)" value="4" />
      <value displayText="National T-Codes Established for State Medicaid Agencies (T1000-T5999)" value="36" />
      <value displayText="Orthotic Procedures (L0100-L4398)" value="37" />
      <value displayText="Pathology and Laboratory (80048-89399)" value="5" />
      <value displayText="Pathology and Laboratory Services (P2028-P9615)" value="38" />
      <value displayText="Private Payer Codes (S0009-S9999)" value="39" />
      <value displayText="Procedures &amp; Professional Services (G0001-G9999)" value="40" />
      <value displayText="Prosthetic Procedures (L5000-L9900)" value="41" />
      <value displayText="Radiology (70010-79999)" value="6" />
      <value displayText="Rehabilitative Services (H0001-H2037)" value="42" />
      <value displayText="Surgery - Auditory System (69000-69979)" value="7" />
      <value displayText="Surgery - Cardiovascular System (33010-37799)" value="8" />
      <value displayText="Surgery - Digestive System (40490-49999)" value="9" />
      <value displayText="Surgery - Endocrine System (60000-60699)" value="10" />
      <value displayText="Surgery - Eye and Ocular Adnexa (65091-68899)" value="11" />
      <value displayText="Surgery - Female Genital System (56405-58999)" value="12" />
      <value displayText="Surgery - Hemic and Lymphatic Systems (38100-38999)" value="13" />
      <value displayText="Surgery - Integumentary System (10040-19499)" value="14" />
      <value displayText="Surgery - Intersex (55970-55980)" value="15" />
      <value displayText="Surgery - Male Genital System (54000-55899)" value="16" />
      <value displayText="Surgery - Maternity Care and Delivery (59000-59899)" value="17" />
      <value displayText="Surgery - Mediastinum and Diaphragm (39000-39599)" value="18" />
      <value displayText="Surgery - Musculoskeletal System (20000-29999)" value="19" />
      <value displayText="Surgery - Nervous System (61000-64999)" value="20" />
      <value displayText="Surgery - Operating Microscope (69990-69990)" value="21" />
      <value displayText="Surgery - Respiratory System (30000-32999)" value="22" />
      <value displayText="Surgery - Urinary System (50010-53899)" value="23" />
      <value displayText="Temporary Codes (Q0034-Q9999)" value="43" />
      <value displayText="Transportation Services (A0080-A0999)" value="44" />
      <value displayText="Vision Services (V2020-V2799)" value="45" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select the grouping option." default="1">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Code" value="2" />
      <value displayText="Revenue Category" value="6" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Payer Scenario" value="7" />
      <value displayText="Batch #" value="5" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Default Rendering Provider" value="9" />
      <value displayText="Supervising Provider" value="10" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option." default="2">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Code" value="2" />
      <value displayText="Revenue Category" value="6" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Batch #" value="5" />
      <value displayText="Payer Scenario #" value="7" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Default Rendering Provider" value="9" />
      <value displayText="Supervising Provider" value="10" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method." default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
from report r
where name = 'Charges Summary'


update reporthyperlink
set ReportParameters =
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
          <method name="Add">
            <methodParam param="SchedulingProviderID" />
            <methodParam param="{12}" />
          </method>
          <method name="Add">
            <methodParam param="PrimaryProviderID" />
            <methodParam param="{13}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyID" />
            <methodParam param="{14}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyPlanID" />
            <methodParam param="{15}" />
          </method>          
          <method name="Add">
            <methodParam param="SupervisingProviderID" />
            <methodParam param="{16}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
where ReportHyperlinkID = 38