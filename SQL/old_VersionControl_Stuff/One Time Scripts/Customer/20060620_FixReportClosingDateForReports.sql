-- Case 8547 - Removed override for report closing date for Missed Copays
UPDATE	Report
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="StartDate" toDateParameter="EndDate" text="Dates:" default="Today" />
		<basicParameter type="Date" parameterName="StartDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type." default="D">
			<value displayText="Posting Date" value="P" />
			<value displayText="Date of Service" value="D" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Encounter Status:" description="Limits the report by Encounter Status." default="3">
			<value displayText="All" value="-1" />
			<value displayText="Approved" value="3" />
			<value displayText="Draft" value="1" />
			<value displayText="Submitted" value="2" />
			<value displayText="Rejected" value="4" />
		</extendedParameter>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE	Name = 'Missed Copays'

-- Case 8546 - Removed override for report closing date for Account Activity Report
UPDATE	Report
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="Today" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:"  />
		<basicParameter type="Date" parameterName="EndDate" text="To:"  />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type."     default="P">
			<value displayText="Posting Date" value="P" />
			<value displayText="Date of Service" value="D" />
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
		<extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
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
	</extendedParameters>
</parameters>'
WHERE	Name = 'Account Activity Report'