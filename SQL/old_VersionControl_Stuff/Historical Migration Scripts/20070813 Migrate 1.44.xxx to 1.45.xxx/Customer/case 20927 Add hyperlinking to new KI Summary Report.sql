

delete reportHyperlink where reportHyperlinkID = 44

-- Adjustment Summary
insert into reportHyperlink( ReportHyperlinkID, Description, ReportParameters )
values( 44,
'KI Summary to Adjustment Summary Report',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Adjustments Summary" />
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
            <methodParam param="SchedulingProviderID" />
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
            <methodParam param="InsuranceCompanyID" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyPlanID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="PayerScenarioID" />
            <methodParam param="{9}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{10}" />
          </method>
          <method name="Add">
            <methodParam param="GroupBy1" />
            <methodParam param="{11}" />
          </method>
          <method name="Add">
            <methodParam param="ColumnType" />
            <methodParam param="{12}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
)

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
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
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
      <value displayText="Payer Scenario" value="6" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="2">
      <value displayText="Provider" value="1" />
      <value displayText="Adjustment Codes" value="2" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Batch #" value="5" />
      <value displayText="Payer Scenario" value="6" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>',
ModifiedDate = getdate()
where Name = 'Adjustments Summary'



update report
set ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
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
      <value displayText="Payer Scenario" value="6" />
    </extendedParameter>
  </extendedParameters>
</parameters>',
modifiedDate = getdate()
where Name = 'Adjustments Detail'



Update ReportHyperLink
SET ReportParameters = 
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
          <method name="Add">
            <methodParam param="PayerScenarioID" />
            <methodParam param="{12}" />
          </method>
          <method name="Add">
            <methodParam param="PayerCategoryID" />
            <methodParam param="{13}" />
          </method>
          <method name="Add">
            <methodParam param="SchedulingProviderID" />
            <methodParam param="{14}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
where ReportHyperlinkID = 37

-- Charges Summary
delete reportHyperlink where reportHyperlinkID = 45

insert into reportHyperlink( ReportHyperlinkID, Description, ReportParameters )
values( 45,
'KI Summary to Charges Summary Report',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Charges Summary" />
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
            <methodParam param="SchedulingProviderID" />
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
            <methodParam param="InsuranceCompanyID" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyPlanID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="PayerScenarioID" />
            <methodParam param="{9}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{10}" />
          </method>
          <method name="Add">
            <methodParam param="GroupBy1" />
            <methodParam param="{11}" />
          </method>
          <method name="Add">
            <methodParam param="ColumnType" />
            <methodParam param="{12}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
)



update report
set ModifiedDate = getdate(),
ReportParameters = 
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
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
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
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Code" value="2" />
      <value displayText="Revenue Category" value="6" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Payer Scenario" value="7" />
      <value displayText="Batch #" value="5" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Default Rendering Provider" value="9" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="2">
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Code" value="2" />
      <value displayText="Revenue Category" value="6" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Batch #" value="5" />
      <value displayText="Payer Scenario #" value="7" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Default Rendering Provider" value="9" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
where name = 'Charges Summary'



UPdate reportHyperlink
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
        </object>
      </methodParam>
    </method>
  </object>
</task>'
where ReportHyperlinkID = 38


update report
set reportparameters = 
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
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
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
      <value displayText="Rendering Provider" value="1" />
      <value displayText="Code" value="2" />
      <value displayText="Revenue Category" value="6" />
      <value displayText="Service Location" value="3" />
      <value displayText="Department" value="4" />
      <value displayText="Payer Scenario" value="7" />
      <value displayText="Batch #" value="5" />
      <value displayText="Scheduling Provider" value="8" />
      <value displayText="Default Rendering Provider" value="9" />
    </extendedParameter>
  </extendedParameters>
</parameters>',
ModifiedDate = getdate()
where Name = 'Charges Detail'


delete reportHyperlink where ReportHyperlinkID = 46

-- Payment Application Summary
insert into reportHyperlink( ReportHyperlinkID, Description, ReportParameters )
values( 46,
'KI Summary to Payment Application Summary Report',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Payments Application Summary" />
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
            <methodParam param="SchedulingProviderID" />
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
            <methodParam param="InsuranceCompanyID" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyPlanID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="PayerScenarioID" />
            <methodParam param="{9}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{10}" />
          </method>
          <method name="Add">
            <methodParam param="GroupBy1" />
            <methodParam param="{11}" />
          </method>
          <method name="Add">
            <methodParam param="ColumnTotal" />
            <methodParam param="{12}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
)


Update Report 
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>  <parameters>
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
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting Date or Service Date"    default="P">
      <value displayText="Posting Date" value="P" />
      <value displayText="Service Date" value="S" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" description="Filter by scheduling provider."  default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" description="Filter by rendering provider."  default="-1" ignore="-1" />
    <extendedParameter type="Provider" parameterName="PrimaryProviderID" text="Default Rendering Provider:" description="Filter by default rendering provider."  default="-1" ignore="-1" />
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
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Select the subgrouping option."    default="8">
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
    <extendedParameter type="ComboBox" parameterName="ColumnTotal" text="Columns:" description="Select the summarization method."    default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
where Name = 'Payments Application Summary'





-- Unapplied Analysis
delete reportHyperlink where ReportHyperlinkID = 47

insert into reportHyperlink( ReportHyperlinkID, Description, ReportParameters )
values( 47,
'KI Summary to Unapplied Analysis Report',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Unapplied Analysis" />
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
            <methodParam param="SchedulingProviderID" />
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
            <methodParam param="InsuranceCompanyID" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyPlanID" />
            <methodParam param="{8}" />
          </method>
          <method name="Add">
            <methodParam param="PayerScenarioID" />
            <methodParam param="{9}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{10}" />
          </method>
          <method name="Add">
            <methodParam param="GroupBy1" />
            <methodParam param="{11}" />
          </method>
          <method name="Add">
            <methodParam param="ColumnTotal" />
            <methodParam param="{12}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
)


-- AR Summary
delete reportHyperlink where ReportHyperlinkID = 48

insert into reportHyperlink( ReportHyperlinkID, Description, ReportParameters )
values( 48,
'KI Summary to A/R Aging Summary Report',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="A/R Aging Summary" />
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
            <methodParam param="SchedulingProviderID" />
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
        </object>
      </methodParam>
    </method>
  </object>
</task>'
)


update Report
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
    <extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="Provider" parameterName="SchedulingProviderID" text="Scheduling Provider:" default="-1" ignore="-1" description="Limits the report by scheduling provider"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract"/>
  </extendedParameters>
</parameters>',
ModifiedDate = getdate()
where Name = 'A/R Aging Summary'




--- Refund
Update Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="RefundStatusCode" text="Refund Status:" description="Select the refund status."    default="A">
      <value displayText="All" value="A" />
      <value displayText="Issued" value="I" />
      <value displayText="Draft" value="D" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="recipientTypeCode" text="Recipient Type:" description="Select the recipient type."    default="A" ignore="A">
	  <value displayText="All" value="A" />
      <value displayText="Insurance" value="I" />
      <value displayText="Patient" value="P" />
    </extendedParameter>
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" default="-1" enabledBasedOnParameter="recipientTypeCode" enabledBasedOnValue="I" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" enabledBasedOnParameter="recipientTypeCode" enabledBasedOnValue="I"  />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" enabledBasedOnParameter="recipientTypeCode" enabledBasedOnValue="P"  />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>',
ModifiedDate = getdate()
WHERE Name = 'Refunds Summary'


Update Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"/>
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Type:" default="0" ignore="0"/>
    <extendedParameter type="ComboBox" parameterName="RefundStatusCode" text="Refund Status:" description="Select the refund status."    default="A">
      <value displayText="All" value="A" />
      <value displayText="Issued" value="I" />
      <value displayText="Draft" value="D" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="recipientTypeCode" text="Recipient Type:" description="Select the recipient type."    default="A" ignore="A">
	  <value displayText="All" value="A" />
      <value displayText="Insurance" value="I" />
      <value displayText="Patient" value="P" />
    </extendedParameter>
    <extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" default="-1" enabledBasedOnParameter="recipientTypeCode" enabledBasedOnValue="I" ignore="-1" />
    <extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" enabledBasedOnParameter="recipientTypeCode" enabledBasedOnValue="I"  />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" enabledBasedOnParameter="recipientTypeCode" enabledBasedOnValue="P"  />
     <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>',
ModifiedDate = getdate()
WHERE Name = 'Refunds Detail'




update ReportHyperlink
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Refunds Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="PaymentMethodCode" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="BeginDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="RefundStatusCode" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyID" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyPlanID" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="recipientTypeCode" />
            <methodParam param="{7}" />
          </method>
          <method name="Add">
            <methodParam param="PatientID" />
            <methodParam param="{8}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE ReportHyperLinkID = 7




delete reportHyperlink where ReportHyperlinkID = 49

insert into reportHyperlink( ReportHyperlinkID, Description, ReportParameters )
values( 49,
'KI Summary to Refund Summary Report',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Refunds Summary" />
      <methodParam param="true" type="System.Boolean"/>
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
            <methodParam param="InsuranceCompanyID" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="InsuranceCompanyPlanID" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{4}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
)


