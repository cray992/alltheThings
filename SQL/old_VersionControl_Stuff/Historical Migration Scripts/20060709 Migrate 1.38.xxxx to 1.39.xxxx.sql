/*----------------------------------

DATABASE UPDATE SCRIPT

v1.38.xxxx to v1.39.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------


--------------------------------------------------------------------------------
-- CASE 12316 - Add ability to choose which line of service to apply copay
--------------------------------------------------------------------------------
ALTER TABLE EncounterProcedure
ADD ApplyCopay bit not null default 0
GO

-- set ApplyCopay=1 in the first procedures for each encounter
UPDATE encounterprocedure SET ApplyCopay=0
UPDATE encounterprocedure SET ApplyCopay=1 
WHERE  encounterprocedureID in 
	(SELECT MIN(encounterprocedureID) FROM encounterprocedure 
	GROUP BY encounterid )


--------------------------------------------------------------------------------
-- CASE 12300 - Add additional fields for full timeblock details implementation
--------------------------------------------------------------------------------

-- Modify the timeblock table
ALTER TABLE Timeblock ADD 
	DoNotSchedule bit not null CONSTRAINT DF_Timeblock_DoNotSchedule DEFAULT (0),
	AllowOverbooking bit not null CONSTRAINT DF_Timeblock_AllowOverbooking DEFAULT (0),
	LimitTo bit not null CONSTRAINT DF_Timeblock_LimitTo DEFAULT (0),
	LimitToAmount int null,
	DisplayDenialExplanation bit not null CONSTRAINT DF_Timeblock_DisplayDenialExplanation DEFAULT (0),
	DenialExplanation varchar(4096) null,
	-- A = Allow All, S = Specific
	PermittedLocationsType char(1) not null CONSTRAINT DF_Timeblock_PermittedLocationsType DEFAULT('A'),
	-- A = Allow All, S = Allow Specific, D = Deny Specific, O = Allow Some, Deny Others
	PermittedReasonsType char(1) not null CONSTRAINT DF_Timeblock_ReasonsLocationsType DEFAULT('A')	

GO

-- Add timeblock to service location table
CREATE TABLE TimeblockToServiceLocation(
	TimeblockToServiceLocationID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_TimeblockToServiceLocation_TimeblockToServiceLocationID
		PRIMARY KEY NONCLUSTERED,
	PracticeID INT NOT NULL,
	TimeblockID INT NOT NULL,
	ServiceLocationID INT NOT NULL,
	CreatedDate DATETIME NOT NULL CONSTRAINT DF_TimeblockToServiceLocation_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_TimeblockToServiceLocation_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_TimeblockToServiceLocation_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_TimeblockToServiceLocation_ModifiedUserID DEFAULT (0)
			)

GO

-- Add a foreign key for the practice table
ALTER TABLE [dbo].[TimeblockToServiceLocation] ADD
	CONSTRAINT [FK_TimeblockToServiceLocation_Practice] FOREIGN KEY 
	(
		[PracticeID]
	) REFERENCES [Practice] (
		[PracticeID]
	)
GO

-- Add a foreign key for the timeblock table
ALTER TABLE [dbo].[TimeblockToServiceLocation] ADD
	CONSTRAINT [FK_TimeblockToServiceLocation_Timeblock] FOREIGN KEY 
	(
		[TimeblockID]
	) REFERENCES [Timeblock] (
		[TimeblockID]
	)
GO

-- Add a foreign key for the service location table
ALTER TABLE [dbo].[TimeblockToServiceLocation] ADD
	CONSTRAINT [FK_TimeblockToServiceLocation_ServiceLocation] FOREIGN KEY 
	(
		[ServiceLocationID]
	) REFERENCES [ServiceLocation] (
		[ServiceLocationID]
	)
GO

-- Add timeblock to appointment reason table
CREATE TABLE TimeblockToAppointmentReason(
	TimeblockToAppointmentReasonID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_TimeblockToAppointmentReason_TimeblockToAppointmentReasonID
		PRIMARY KEY NONCLUSTERED,
	PracticeID INT NOT NULL,
	TimeblockID INT NOT NULL,
	AppointmentReasonID INT NOT NULL,
	Allowed BIT NOT NULL,
	LimitPerTimeblock INT,
	CreatedDate DATETIME NOT NULL CONSTRAINT DF_TimeblockToAppointmentReason_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_TimeblockToAppointmentReason_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_TimeblockToAppointmentReason_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_TimeblockToAppointmentReason_ModifiedUserID DEFAULT (0)
			)

GO

-- Add a foreign key for the practice table
ALTER TABLE [dbo].[TimeblockToAppointmentReason] ADD
	CONSTRAINT [FK_TimeblockToAppointmentReason_Practice] FOREIGN KEY 
	(
		[PracticeID]
	) REFERENCES [Practice] (
		[PracticeID]
	)
GO

-- Add a foreign key for the timeblock table
ALTER TABLE [dbo].[TimeblockToAppointmentReason] ADD
	CONSTRAINT [FK_TimeblockToAppointmentReason_Timeblock] FOREIGN KEY 
	(
		[TimeblockID]
	) REFERENCES [Timeblock] (
		[TimeblockID]
	)
GO

-- Add a foreign key for the appointment reason table
ALTER TABLE [dbo].[TimeblockToAppointmentReason] ADD
	CONSTRAINT [FK_TimeblockToAppointmentReason_AppointmentReason] FOREIGN KEY 
	(
		[AppointmentReasonID]
	) REFERENCES [AppointmentReason] (
		[AppointmentReasonID]
	)
GO

----------------------------------------
-- CASE 12423 - patient statements for Accro/Health with Bridgestone, flexible formatting
---------------------------------------

ALTER TABLE dbo.Practice ADD
	[EStatementsPreferredPrintFormatId] int NULL,
	[EStatementsPreferredElectronicFormatId] int NULL,
	EStatementsCustomText1 text null,
	EStatementsCustomText2 text null

GO

UPDATE Practice SET EStatementsPreferredPrintFormatId = 1 WHERE EStatementsVendorId = 1
UPDATE Practice SET EStatementsPreferredPrintFormatId = 2 WHERE EStatementsVendorId = 2
UPDATE Practice SET EStatementsPreferredPrintFormatId = 3 WHERE EStatementsVendorId = 3
UPDATE Practice SET EStatementsPreferredPrintFormatId = 4 WHERE EStatementsVendorId = 4
UPDATE Practice SET EStatementsPreferredPrintFormatId = 7 WHERE EStatementsVendorId = 5
GO

UPDATE Practice SET EStatementsPreferredElectronicFormatId = 1 WHERE EStatementsVendorId = 1
UPDATE Practice SET EStatementsPreferredElectronicFormatId = 2 WHERE EStatementsVendorId = 2
UPDATE Practice SET EStatementsPreferredElectronicFormatId = 3 WHERE EStatementsVendorId = 3
UPDATE Practice SET EStatementsPreferredElectronicFormatId = 4 WHERE EStatementsVendorId = 4
UPDATE Practice SET EStatementsPreferredElectronicFormatId = 6 WHERE EStatementsVendorId = 5
GO

ALTER TABLE dbo.BillBatch ADD
	[FormatId] int NULL
GO

	DECLARE @practice_id INT
	DECLARE @format_id INT

	DECLARE practice_cursor CURSOR READ_ONLY
	FOR
		SELECT PracticeID, EStatementsPreferredElectronicFormatId FROM Practice
	OPEN practice_cursor

	FETCH NEXT FROM practice_cursor
	INTO	@practice_id, @format_id
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		UPDATE dbo.BillBatch SET FormatId = @format_id
		WHERE PracticeId = @practice_id AND BillBatchTypeCode = 'S'

		FETCH NEXT FROM practice_cursor
		INTO	@practice_id, @format_id
	END

	CLOSE practice_cursor
	DEALLOCATE practice_cursor
GO

----------------------------------------
-- Case 12732  Discrepancy between number of Clearinghouse reports shown on the dashboard and numbers shown
--             in the ClearingHouse reports browser
---------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClearinghouseResponseType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClearinghouseResponseType]
GO

CREATE TABLE ClearinghouseResponseType (
	ClearinghouseResponseType INT NOT NULL CONSTRAINT PK_ClearinghouseResponseType_ClearinghouseResponseTypeID
		PRIMARY KEY NONCLUSTERED,
	[Name] varchar(64) NOT NULL,
	Description varchar(512)
)
GO

-- see PayerGatewayBase.cs
INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (0, 'Unknown')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (1, 'All')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name], Description)
   VALUES (2, 'Etf', 'tilde-separated format; can be a mix')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (10, 'UnknownClaim')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (11, 'AllClaim')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (12, 'ClaimPayerResponseReport')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (13, 'ClaimDailyClaimsVerificationStatement')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (14, 'ClaimBillingInvoiceConfirmationListing')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (15, 'ClaimBillingInvoiceConfirmationStats')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name], Description)
   VALUES (16, 'ClaimFileProcessingStatement', 'like what OfficeAlly sends back in email')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name], Description)
   VALUES (17, 'ClaimGeneratedStatement', 'some report generated internally here, for example from ETF')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (18, 'ClaimEdiStatusStatement')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (20, 'UnknownPatientStatement')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (21, 'AllPatientStatement')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (22, 'PatientStatementBatchReport')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (30, 'UnknownERA')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (31, 'AllERA')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (32, 'ERAExplanationOfProviderPaymentImage')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (33, 'ERAExplanationOfProviderPaymentANSI')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (34, 'ERAExplanationOfProviderPaymentNSF')

INSERT INTO ClearinghouseResponseType (ClearinghouseResponseType, [Name])
   VALUES (35, 'ERAProviderPaymentEFT')

GO

-- Add a foreign key for the ClearinghouseResponse table
ALTER TABLE [dbo].ClearinghouseResponse ADD
	CONSTRAINT [FK_ClearinghouseResponse_ClearinghouseResponseType] FOREIGN KEY 
	(
		[ResponseType]
	) REFERENCES [ClearinghouseResponseType] (
		[ClearinghouseResponseType]
	)
GO

----------------------------------------
-- CASE 8571 - Modify payment summary & detail reports to break out copays 
---------------------------------------
	Update r
	set ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
	<task name="Report V2 Viewer">
		<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
			<method name="" />
			<method name="Add">
				<methodParam param="ReportName" />
				<methodParam param="Payments Detail" />
				<methodParam param="true" type="System.Boolean" />
			</method>
			<method name="Add">
				<methodParam param="ReportOverrideParameters" />
				<methodParam>
					<object type="System.Collections.Hashtable">
						<method name="" />
						<method name="Add">
							<methodParam param="PaymentTypeID" />
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
							<methodParam param="BatchID" />
							<methodParam param="{3}" />
						</method>
					</object>
				</methodParam>
			</method>
		</object>
	</task>',
	ModifiedDate = getdate()
	from reporthyperlink r
	where ReportHyperLinkID = 8


	Update r
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
			<extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Method:" default="0" ignore="0"/>
			<extendedParameter type="ComboBox" parameterName="PaymentTypeID" text="Payment Type:" description="Limits the report by payment type."     default="-1">
			  <value displayText="All" value="-1" />
			  <value displayText="Copay" value="1" />
			  <value displayText="Patient Payment on Account" value="2" />
			  <value displayText="Insurance Payment" value="3" />
			  <value displayText="Other" value="4" />
			</extendedParameter>
			<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
			<extendedParameter type="ComboBox" parameterName="ReportType" text="Show Balance:"     default="A">
			  <value displayText="All" value="A" />
			  <value displayText="Unapplied Balance" value="U" />
			</extendedParameter>
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
		  </extendedParameters>
		</parameters>'
	from report r
	where Name = 'Payments Detail'

	Update r
	set ReportParameters = 
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
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
			<extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Method:" default="0" ignore="0"/>
			<extendedParameter type="ComboBox" parameterName="PaymentTypeID" text="Payment Type:" description="Limits the report by payment type."     default="-1">
			  <value displayText="All" value="-1" />
			  <value displayText="Copay" value="1" />
			  <value displayText="Patient Payment on Account" value="2" />
			  <value displayText="Insurance Payment" value="3" />
			  <value displayText="Other" value="4" />
			</extendedParameter>
		  </extendedParameters>
		</parameters>'
	from report r
	where Name = 'Payments Summary'

GO




---------------------------------------------------------------------------
-- Case 10593:   Added department filter to Account Activity Summary report
---------------------------------------------------------------------------
----------------------------------------
-- Case 12542:   Add Patient and Provider info to the Activity report 
---------------------------------------
UPDATE R
SET ReportParameters = 
	'<?xml version="1.0" encoding="utf-8" ?>
	<parameters>
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
FROM REPORT R
where Name = 'Account Activity Report'
GO


----------------------------------------
-- Case 12317:   Contract Filter for AR Reports
-- Case 10590:   Add new customization options for A/R Aging by Insurance report 
---------------------------------------
UPDATE report
SET ReportParameters = 
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
where NAme = 'A/R Aging by Insurance'

UPDATE R
set ReportParameters = 
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
	<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
	<extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
    <extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" permission="FindContract"/>
  </extendedParameters>
</parameters>'
from report r
where name = 'A/R Aging Summary'



Update rh
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
            <methodParam param="ContractID" />
            <methodParam param="{5}" />
          </method>          
          <method name="Add">
            <methodParam param="DateType" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{7}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
from reportHyperlink rh
where ReportHyperlinkID = 11




Update rh
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
            <methodParam param="ContractID" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="DateType" />
            <methodParam param="{6}" />
          </method>
          <method name="Add">
            <methodParam param="BatchID" />
            <methodParam param="{7}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
from reportHyperlink rh
where ReportHyperlinkID = 12

GO




/*-----------------------------------------------------------------------------
Case 12323:   Create Patient Volume by PCP by Payer report 
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
	5, 
	3, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Patients Summary', 
	'This report shows a summary of patients over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPatientsSummary',
	'<?xml version="1.0" encoding="utf-8" ?>  
		<parameters>   
			<basicParameters>
				<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />    
				<basicParameter type="PracticeID" parameterName="PracticeID" />    				
				<basicParameter type="PracticeName" parameterName="rpmPracticeName" />   
				<basicParameter type="ClientTime" parameterName="ClientTime" />   
				<basicParameter type="ExportType" parameterName="ExportType" />   
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
				<extendedParameter type="Contract" parameterName="ContractID" text="Contract:" default="-1" ignore="-1" />
				<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
				<extendedParameter type="ComboBox" parameterName="PatientType" text="Patient Type:" description="Select the Patient Type"    default="A">    
					<value displayText="All" value="A" />    
					<value displayText="Existing" value="E" />  
					<value displayText="New" value="N" />  
				</extendedParameter>   
				<extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select the grouping option."    default="1">    
					<value displayText="Provider" value="1" />    
					<value displayText="Referring Provider" value="2" />  
					<value displayText="Primary Care Physician" value="3" />  
					<value displayText="Service Location" value="4" />    
					<value displayText="Department" value="5" />    
				</extendedParameter>   
				<extendedParameter type="ComboBox" parameterName="Group2by" text="Subgroup by:" description="Select the subgrouping option."    default="8">    
					<value displayText="Provider" value="1" />    
					<value displayText="Referring Provider" value="2" />  
					<value displayText="Primary Care Physician" value="3" />  
					<value displayText="Service Location" value="4" />    
					<value displayText="Department" value="5" />    
					<value displayText="Insurance Company" value="6" />   
					<value displayText="Insurance Plan" value="7" />   
					<value displayText="Payer Scenario" value="8" />   
					<value displayText="Contract Type" value="9" />   
				</extendedParameter>
				<extendedParameter type="ComboBox" parameterName="ColumnTotal" text="Columns:" description="Select the summarization method."    default="1">    
					<value displayText="Total Only" value="1" />    
					<value displayText="Month" value="2" />  
					<value displayText="Quarter" value="3" />  
					<value displayText="Year" value="4" />  
				</extendedParameter> 
			</extendedParameters>  
		</parameters>',
	'Patients S&ummary', -- Why are "&" used in the value???
	'ReadPatientsSummaryReport')

 

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
Case 12731:   Modify Encounter Reports to show charges for non-approved 
-----------------------------------------------------------------------------*/
Update report
set reportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
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

where Name = 'Encounters Detail'

Update report
SET ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<parameters >
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" />
    <basicParameter type="Date" parameterName="EndDate" text="To:"  />
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
    <extendedParameter type="ComboBox" parameterName="Group1by" text="Group by:" description="Select to group by Status, Provider, Service location, or Department"    default="Status">
      <value displayText="Status" value="Status" />
      <value displayText="Provider" value="Provider" />
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Department" value="Department" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="Group2by" text="Subgroup by:" description="Select to sub group by Status, Provider, Service location, or Department"    default="Provider">
      <value displayText="Provider" value="Provider" />
      <value displayText="Status" value="Status" />
      <value displayText="Service Location" value="Service Location" />
      <value displayText="Department" value="Department" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchNumberID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
where Name = 'Encounters Summary'

GO






/*-----------------------------------------------------------------------------
Case 10592:		Add new customization options for Missed Copays report 
-----------------------------------------------------------------------------*/
UPDATE  report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="CustomDateRange" fromDateParameter="StartDate" toDateParameter="EndDate" text="Dates:"     default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="StartDate" text="From:" overrideMaxDate="true" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type."     default="D">
      <value displayText="Posting Date" value="P" />
      <value displayText="Date of Service" value="D" />
    </extendedParameter>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="Department" parameterName="DepartmentID" text="Department:" default="-1" ignore="-1" />
    <extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />    
	<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1"     permission="FindPatient" />
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" description="Limits the report by batch #."/>
    <extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Encounter Status:" description="Limits the report by Encounter Status." default="3">
      <value displayText="All" value="-1" />
      <value displayText="Approved" value="3" />
      <value displayText="Draft" value="1" />
      <value displayText="Submitted" value="2" />
      <value displayText="Rejected" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
where Name = 'Missed Copays'
GO


/*-----------------------------------------------------------------------------
Case 12799:   Patient not showing on "pat. balance summary report" 
-----------------------------------------------------------------------------*/

-- Add document reprint table
CREATE TABLE DocumentReprint(
	DocumentID INT NOT NULL CONSTRAINT PK_DocumentReprint_DocumentID
		PRIMARY KEY NONCLUSTERED,
	Data VARBINARY(MAX), 
	UncompressedLength INT, 
	Confirmed BIT not null CONSTRAINT DF_DocumentReprint_Confirmed DEFAULT (0),
	CreatedDate DATETIME NOT NULL CONSTRAINT DF_DocumentReprint_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_DocumentReprint_CreatedUserID DEFAULT (0)
			)

GO

-- Add a foreign key for the document table
ALTER TABLE [dbo].[DocumentReprint] ADD
	CONSTRAINT [FK_DocumentReprint_Document] FOREIGN KEY 
	(
		[DocumentID]
	) REFERENCES [Document] (
		[DocumentID]
	)
GO

/*---------------------------------------------------------------------------------------------
Case 12599:   Added the option to display unapplied payments on the "Patient Statement" report.
---------------------------------------------------------------------------------------------*/

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please click on Customize and select a Patient to display a report.">
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
    <extendedParameter type="ComboBox" parameterName="IncludeUnappliedPayments" text="Unapplied payments:" description="Select to include, or not to include unapplied payments."    default="0">
      <value displayText="Do not include unapplied payments" value="false" />
      <value displayText="Include unapplied payments" value="true" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE [Name] = 'Patient Statement'

GO

--------------------------------------------------------------------------------
-- CASE 12302 - Appointment Details and Appointment Calendar: Enforce timeblock rules 
--------------------------------------------------------------------------------

ALTER TABLE Appointment ADD StartTm SMALLINT, EndTm SMALLINT
GO

DROP INDEX Appointment.CI_Appointment
GO

UPDATE Appointment SET StartTm=DATEPART(HH,StartDate)*100+DATEPART(MI,StartDate),
EndTm=DATEPART(HH,EndDate)*100+DATEPART(MI,EndDate)
GO

CREATE UNIQUE CLUSTERED INDEX CI_Appointment
ON Appointment 
(PracticeID ASC,
 StartDKPracticeID ASC,
 EndDKPracticeID ASC,
 StartTm ASC,
 EndTm ASC,
 AppointmentConfirmationStatusCode ASC,
 ServiceLocationID ASC,
 PatientID ASC,
 AppointmentID ASC)
GO

ALTER TABLE Timeblock ADD StartTm SMALLINT, EndTm SMALLINT
GO

UPDATE Timeblock SET StartTm=DATEPART(HH,StartDate)*100+DATEPART(MI,StartDate),
EndTm=DATEPART(HH,EndDate)*100+DATEPART(MI,EndDate)
GO

DROP INDEX Timeblock.CI_Timeblock
GO

CREATE UNIQUE CLUSTERED INDEX CI_Timeblock
ON Timeblock 
(PracticeID ASC,
 StartDKPracticeID ASC,
 EndDKPracticeID ASC,
 StartTm ASC,
 EndTm ASC,
 AppointmentResourceTypeID ASC, 
 ResourceID ASC,
 TimeblockID ASC)
GO

UPDATE STATISTICS Appointment
GO
DBCC DBREINDEX(Appointment)
GO

UPDATE STATISTICS Timeblock
GO
DBCC DBREINDEX(Timeblock)
GO

CREATE INDEX IX_TimeblockToServiceLocation_TimeblockID
ON TimeblockToServiceLocation (TimeblockID)
GO

CREATE INDEX IX_TimeblockToServiceLocation_ServiceLocationID
ON TimeblockToServiceLocation (ServiceLocationID)
GO

CREATE INDEX IX_TimeblockToAppointmentReason_TimeblockID
ON TimeblockToAppointmentReason (TimeblockID)
GO

CREATE INDEX IX_TimeblockToAppointmentReason_AppointmentReasonID
ON TimeblockToAppointmentReason (AppointmentReasonID)
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AppointmentRecurrenceException]') AND name = N'IX_AppointmentRecurrenceException_ExceptionDate')
DROP INDEX [IX_AppointmentRecurrenceException_ExceptionDate] ON [dbo].[AppointmentRecurrenceException] WITH ( ONLINE = OFF )

GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AppointmentRecurrenceException]') AND name = N'IX_AppointmentRecurrenceException_AppointmentID')
DROP INDEX [IX_AppointmentRecurrenceException_AppointmentID] ON [dbo].[AppointmentRecurrenceException] WITH ( ONLINE = OFF )

GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AppointmentRecurrenceException]') AND name = N'IX_AppointmentRecurrenceException_AppointmentID_ExceptionDate')
DROP INDEX AppointmentRecurrenceException.IX_AppointmentRecurrenceException_AppointmentID_ExceptionDate

GO

CREATE NONCLUSTERED INDEX IX_AppointmentRecurrenceException_AppointmentID_ExceptionDate 
ON AppointmentRecurrenceException
(
	AppointmentID, ExceptionDate
)

GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TimeblockRecurrenceException]') AND name = N'IX_TimeblockRecurrenceException_ExceptionDate')
DROP INDEX [IX_TimeblockRecurrenceException_ExceptionDate] ON [dbo].[TimeblockRecurrenceException] WITH ( ONLINE = OFF )

GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TimeblockRecurrenceException]') AND name = N'IX_TimeblockRecurrenceException_TimeblockID')
DROP INDEX [IX_TimeblockRecurrenceException_TimeblockID] ON [dbo].[TimeblockRecurrenceException] WITH ( ONLINE = OFF )

GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TimeblockRecurrenceException]') AND name = N'IX_TimeblockRecurrenceException_TimeblockID_ExceptionDate')
DROP INDEX [IX_TimeblockRecurrenceException_TimeblockID_ExceptionDate] ON [dbo].[TimeblockRecurrenceException] WITH ( ONLINE = OFF )

GO

CREATE NONCLUSTERED INDEX [IX_TimeblockRecurrenceException_TimeblockID_ExceptionDate] ON [dbo].[TimeblockRecurrenceException] 
(
	TimeblockID, ExceptionDate
)

GO

/*---------------------------------------------------------------------------------------------
Case 12892: Patient History Task table structure and hyperlink information
---------------------------------------------------------------------------------------------*/

-- Add Patient History Setup table
CREATE TABLE PatientHistorySetup(
	PatientHistorySetupID INT NOT NULL CONSTRAINT PK_PatientHistorySetup_PatientHistorySetupID
		PRIMARY KEY NONCLUSTERED,
	Name varchar(128),
	Configuration XML,
	Sort int, 
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_PatientHistorySetup_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_PatientHistorySetup_ModifiedUserID DEFAULT (0)
			)

GO

-- Add some report hyperlink records used in the View Patient History task
INSERT INTO ReportHyperlink (ReportHyperlinkID, Description, ReportParameters, ModifiedDate)
VALUES (
34,
'Receive Payment Task',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Receive Payment">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="Editing" />
			<methodParam param="true" type="System.Boolean" />
		</method>
		<method name="Add">
			<methodParam param="PaymentID" />
			<methodParam param="{0}" type="System.Int32" />
			<methodParam param="true" type="System.Boolean" />
		</method>
	</object>
</task>',
getdate())

INSERT INTO ReportHyperlink (ReportHyperlinkID, Description, ReportParameters, ModifiedDate)
VALUES (
35,
'Patient Statement Detail Task',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Patient Statement Detail">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.SimpleDetailParameters">
		<method name="">
			<methodParam param="{0}" type="System.Int32" />
			<methodParam param="true" type="System.Boolean"/>
		</method>
	</object>
</task>',
getdate())

INSERT INTO ReportHyperlink (ReportHyperlinkID, Description, ReportParameters, ModifiedDate)
VALUES (
36,
'Appointment Detail Task',
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Appointment Details">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="AppointmentID" />
			<methodParam param="{0}" type="System.Int32" />
			<methodParam param="true" type="System.Boolean" />
		</method>
		<method name="Add">
			<methodParam param="Editing" />
			<methodParam param="true" type="System.Boolean" />
		</method>
		<method name="Add">
			<methodParam param="Recurring" />
			<methodParam param="false" type="System.Boolean" />
		</method>
	</object>
</task>',
getdate())

-- Charges Summary setup
INSERT INTO PatientHistorySetup
VALUES(
1,
'Charges Summary',
'<?xml version="1.0" encoding="utf-8" ?>
<patientHistory type="Charges Summary" storedProcedure="PatientDataProvider_GetActivities_ChargeSummary">
	<!-- Section to determine which parameters are available to this report -->
	<parameters>
		<parameter type="PracticeID"/>
		<parameter type="PatientID"/>
		<parameter type="PatientCaseID"/>
		<parameter type="BeginDate" />
		<parameter type="EndDate" />
		<parameter type="ProviderID" />
		<parameter type="Status" parameter="ReportType" value="O"/>
		<parameter type="UnappliedAmount"/>
	</parameters>
	<!-- Section to determine which actions (buttons) are available to this report -->
	<actions>
		<action type="Open" hyperlinkField="HyperlinkID" hyperlinkIDField="RefID" />
		<action type="Print" reportPath="/BusinessManagerReports/rptGetActivities_TransactionSummary"/>
	</actions>
	<!-- Section to determine the column structure for the report -->
	<columns>
		<column field="ProcedureDateOfService" name="Service Date" width="75" datatype="ShortDateTime" columntype="Label" summaryType="Text" summaryText="TOTALS"/>
		<column field="Description" name="Description" width="163" datatype="String" columntype="Label"/>
		<column field="ExpectedReimbursement" name="Expected" width="75" datatype="Money" columntype="Label" summaryType="Sum"/>
		<column field="Charges" name="Charges" width="75" datatype="Money" columntype="Label" summaryType="Sum"/>
		<column field="Adjustments" name="Adjustments" width="75" datatype="Money" columntype="Label" summaryType="Sum"/>
		<column field="Receipts" name="Receipts" width="75" datatype="Money" columntype="Label" summaryType="Sum"/>
		<column field="PendingPat" name="Pat. Balance" width="75" datatype="Money" columntype="Label" summaryType="SumSubtractLastValue" summarySubtractField="UnappliedAmount"/>
		<column field="PendingIns" name="Ins. Balance" width="75" datatype="Money" columntype="Label" summaryType="Sum"/>
		<column field="Totalbalance" name="Total Balance" width="77" datatype="Money" columntype="Label" summaryType="SumSubtractLastValue" summarySubtractField="UnappliedAmount"/>
		<column field="UnappliedAmount" name="" width="0" datatype="Money" columntype="Label" visible="false"/>
	</columns>
</patientHistory>',
1,
getdate(),
0)

-- Transactions Detail setup
INSERT INTO PatientHistorySetup
VALUES(
2,
'Transactions Detail',
'<?xml version="1.0" encoding="utf-8" ?>
<patientHistory type="Transactions Detail" storedProcedure="PatientDataProvider_GetActivities_TransactionDetail">
	<!-- Section to determine which parameters are available to this report -->
	<parameters>
		<parameter type="PracticeID"/>
		<parameter type="PatientID"/>
		<parameter type="PatientCaseID"/>
		<parameter type="BeginDate" />
		<parameter type="EndDate" />
		<parameter type="ProviderID" />
		<parameter type="Transaction" value=""/>
	</parameters>
	<!-- Section to determine which actions (buttons) are available to this report -->
	<actions>
		<action type="Open" hyperlinkField="HyperlinkID" hyperlinkIDField="RefID" />
		<action type="Print" reportPath="/BusinessManagerReports/rptGetActivities_TransactionDetail"/>
		<action type="Reprint" reprintField="HCFA_DocumentID" />
	</actions>
	<!-- Section to determine the column structure for the report -->
	<columns>
		<column field="TransactionDate" name="Post/Tx Date" width="75" datatype="ShortDateTime" columntype="Label" summaryType="Text" summaryText="BALANCE"/>
		<column field="DateOfService" name="Service Date" width="75" datatype="ShortDateTime" columntype="Label"/>
		<column field="Description" name="Description" width="238" datatype="String" columntype="Label"/>
		<column field="Amount" name="Amount" width="75" datatype="Money" columntype="Label"/>
		<column field="PatientBalance" name="Pat. Balance" width="75" datatype="Money" columntype="Label" summaryType="Balance"/>
		<column field="InsuranceBalance" name="Ins. Balance" width="75" datatype="Money" columntype="Label" summaryType="Balance"/>
		<column field="TotalBalance" name="Total Balance" width="77" datatype="Money" columntype="Label" summaryType="Balance"/>
		<column field="Unapplied" name="Unapplied" width="75" datatype="Money" columntype="Label" summaryType="Balance"/>
	</columns>
</patientHistory>',
2,
getdate(),
0)

-- Recent Payments setup
INSERT INTO PatientHistorySetup
VALUES(
3,
'Recent Payments',
'<?xml version="1.0" encoding="utf-8" ?>
<patientHistory type="Recent Payments" storedProcedure="PatientDataProvider_GetActivities_RecentPayments">
	<!-- Section to determine which parameters are available to this report -->
	<parameters>
		<parameter type="PatientID"/>
		<parameter type="PatientCaseID"/>
		<parameter type="BeginDate" />
		<parameter type="EndDate" />
	</parameters>
	<!-- Section to determine which actions (buttons) are available to this report -->
	<actions>
		<action type="Open" hyperlinkField="HyperlinkID" hyperlinkIDField="RefID" />
	</actions>
	<!-- Section to determine the column structure for the report -->
	<columns>
		<column field="DepositDate" name="Deposit Date" width="75" datatype="ShortDateTime" columntype="Label" />
		<column field="Type" name="Type" width="155" datatype="String" columntype="Label" />
		<column field="Payer" name="Payer" width="155" datatype="String" columntype="Label" />
		<column field="Description" name="Description" width="155" datatype="String" columntype="Label" />
		<column field="Payment" name="Payment" width="75" datatype="Money" columntype="Label" />
		<column field="Unapplied" name="Unapplied" width="75" datatype="Money" columntype="Label" />
		<column field="Refund" name="Refunded" width="75" datatype="Money" columntype="Label" />
	</columns>
</patientHistory>',
3,
getdate(),
0)

-- Recent Statements setup
INSERT INTO PatientHistorySetup
VALUES(
4,
'Recent Statements',
'<?xml version="1.0" encoding="utf-8" ?>
<patientHistory type="Recent Statements" storedProcedure="PatientDataProvider_GetActivities_Statements">
	<!-- Section to determine which parameters are available to this report -->
	<parameters>
		<parameter type="PatientID"/>
		<parameter type="BeginDate" />
		<parameter type="EndDate" />
	</parameters>
	<!-- Section to determine which actions (buttons) are available to this report -->
	<actions>
		<action type="Open" hyperlinkField="HyperlinkID" hyperlinkIDField="RefID" />
	</actions>
	<!-- Section to determine the column structure for the report -->
	<columns>
		<column field="Date" name="Date Sent" width="75" datatype="ShortDateTime" columntype="Label" />
		<column field="SentTo" name="Sent To" width="615" datatype="String" columntype="Label" />
		<column field="AmountDue" name="Amount Due" width="75" datatype="Money" columntype="Label" />
	</columns>
</patientHistory>',
4,
getdate(),
0)

-- Recent Appointments setup
INSERT INTO PatientHistorySetup
VALUES(
5,
'Recent Appointments',
'<?xml version="1.0" encoding="utf-8" ?>
<patientHistory type="Recent Appointments" storedProcedure="PatientDataProvider_GetActivities_Appointments">
	<!-- Section to determine which parameters are available to this report -->
	<parameters>
		<parameter type="PatientID"/>
		<parameter type="PatientCaseID"/>
		<parameter type="BeginDate" />
		<parameter type="EndDate" />
		<parameter type="ProviderID" />
	</parameters>
	<!-- Section to determine which actions (buttons) are available to this report -->
	<actions>
		<action type="Open" hyperlinkField="HyperlinkID" hyperlinkIDField="RefID" />
	</actions>
	<!-- Section to determine the column structure for the report -->
	<columns>
		<column field="StartDate" name="Start" width="115" datatype="ShortDateTime" columntype="Label" />
		<column field="EndDate" name="End" width="115" datatype="ShortDateTime" columntype="Label" />
		<column field="Resources" name="Resources" width="175" datatype="String" columntype="Label" />
		<column field="PrimaryReason" name="Primary Reason" width="120" datatype="String" columntype="Label" />
		<column field="ServiceLocation" name="Location" width="120" datatype="String" columntype="Label" />
		<column field="Status" name="Status" width="120" datatype="String" columntype="Label" />
	</columns>
</patientHistory>',
5,
getdate(),
0)

-- Recent Recent Encounters setup
INSERT INTO PatientHistorySetup
VALUES(
6,
'Recent Encounters',
'<?xml version="1.0" encoding="utf-8" ?>
<patientHistory type="Recent Encounters" storedProcedure="PatientDataProvider_GetActivities_RecentEncounters">
	<!-- Section to determine which parameters are available to this report -->
	<parameters>
		<parameter type="PatientID"/>
		<parameter type="PatientCaseID"/>
		<parameter type="BeginDate" />
		<parameter type="EndDate" />
		<parameter type="ProviderID" />
	</parameters>
	<!-- Section to determine which actions (buttons) are available to this report -->
	<actions>
		<action type="Open" hyperlinkField="HyperlinkID" hyperlinkIDField="RefID" />
	</actions>
	<!-- Section to determine the column structure for the report -->
	<columns>
		<column field="Date" name="Service Date" width="75" datatype="ShortDateTime" columntype="Label" />
		<column field="Provider" name="Provider" width="200" datatype="String" columntype="Label" />
		<column field="AmountPaid" name="Amount Paid" width="150" datatype="Money" columntype="Label" />
		<column field="Status" name="Status" width="340" datatype="String" columntype="Label" />
	</columns>
</patientHistory>',
6,
getdate(),
0)

/*----------------------------------------------------------------------
Case 12318:   Added a contract filter to the "Payer Mix Summary" report.
----------------------------------------------------------------------*/

UPDATE Report
SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
  </extendedParameters>
</parameters>'
WHERE [Name] = 'Payer Mix Summary'

GO


/*----------------------------------------------------------------------
Case 12322:   Modify Appointment Summary report to show info about timeblocks    
----------------------------------------------------------------------*/
UPDATE R
set reportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="TimeOffset" parameterName="TimeOffset" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" overrideMaxDate="true" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="AppointmentResourceTypeID" text="Type:" description="Limits the report by resource type."     default="A" ignore="A">
      <value displayText="All" value="A" />
      <value displayText="Practice Resource" value="2" />
      <value displayText="Provider" value="1" />
    </extendedParameter>
    <extendedParameter type="PracticeResources" parameterName="ResourceID" text="Practice Resource:" default="-1"     ignore="-1" enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="2" />
    <extendedParameter type="Provider" parameterName="ResourceID" text="Provider:" default="-1" ignore="-1"     enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="1" />
    <extendedParameter type="AppointmentStatus" parameterName="Status" text="Status:" default="Z" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="StartTime" text="Start Time:"  default="08:00:00" >
      <value displayText="12:00 AM"  value="00:00:00" />
      <value displayText="12:15 AM"  value="00:15:00" />
      <value displayText="12:30 AM"  value="00:30:00" />
      <value displayText="12:45 AM"  value="00:45:00" />
      <value displayText="01:00 AM"  value="01:00:00" />
      <value displayText="01:15 AM"  value="01:15:00" />
      <value displayText="01:30 AM"  value="01:30:00" />
      <value displayText="01:45 AM"  value="01:45:00" />
      <value displayText="02:00 AM"  value="02:00:00" />
      <value displayText="02:15 AM"  value="02:15:00" />
      <value displayText="02:30 AM"  value="02:30:00" />
      <value displayText="02:45 AM"  value="02:45:00" />
      <value displayText="03:00 AM"  value="03:00:00" />
      <value displayText="03:15 AM"  value="03:15:00" />
      <value displayText="03:30 AM"  value="03:30:00" />
      <value displayText="03:45 AM"  value="03:45:00" />
      <value displayText="04:00 AM"  value="04:00:00" />
      <value displayText="04:15 AM"  value="04:15:00" />
      <value displayText="04:30 AM"  value="04:30:00" />
      <value displayText="04:45 AM"  value="04:45:00" />
      <value displayText="05:00 AM"  value="05:00:00" />
      <value displayText="05:15 AM"  value="05:15:00" />
      <value displayText="05:30 AM"  value="05:30:00" />
      <value displayText="05:45 AM"  value="05:45:00" />
      <value displayText="06:00 AM"  value="06:00:00" />
      <value displayText="06:15 AM"  value="06:15:00" />
      <value displayText="06:30 AM"  value="06:30:00" />
      <value displayText="06:45 AM"  value="06:45:00" />
      <value displayText="07:00 AM"  value="07:00:00" />
      <value displayText="07:15 AM"  value="07:15:00" />
      <value displayText="07:30 AM"  value="07:30:00" />
      <value displayText="07:45 AM"  value="07:45:00" />
      <value displayText="08:00 AM"  value="08:00:00" />
      <value displayText="08:15 AM"  value="08:15:00" />
      <value displayText="08:30 AM"  value="08:30:00" />
      <value displayText="08:45 AM"  value="08:45:00" />
      <value displayText="09:00 AM"  value="09:00:00" />
      <value displayText="09:15 AM"  value="09:15:00" />
      <value displayText="09:30 AM"  value="09:30:00" />
      <value displayText="09:45 AM"  value="09:45:00" />
      <value displayText="10:00 AM"  value="10:00:00" />
      <value displayText="10:15 AM"  value="10:15:00" />
      <value displayText="10:30 AM"  value="10:30:00" />
      <value displayText="10:45 AM"  value="10:45:00" />
      <value displayText="11:00 AM"  value="11:00:00" />
      <value displayText="11:15 AM"  value="11:15:00" />
      <value displayText="11:30 AM"  value="11:30:00" />
      <value displayText="11:45 AM"  value="11:45:00" />
      <value displayText="12:00 AM"  value="12:00:00" />
      <value displayText="12:15 AM"  value="12:15:00" />
      <value displayText="12:30 AM"  value="12:30:00" />
      <value displayText="12:45 AM"  value="12:45:00" />
      <value displayText="01:00 PM"  value="13:00:00" />
      <value displayText="01:15 PM"  value="13:15:00" />
      <value displayText="01:30 PM"  value="13:30:00" />
      <value displayText="01:45 PM"  value="13:45:00" />
      <value displayText="02:00 PM"  value="14:00:00" />
      <value displayText="02:15 PM"  value="14:15:00" />
      <value displayText="02:30 PM"  value="14:30:00" />
      <value displayText="02:45 PM"  value="14:45:00" />
      <value displayText="03:00 PM"  value="15:00:00" />
      <value displayText="03:15 PM"  value="15:15:00" />
      <value displayText="03:30 PM"  value="15:30:00" />
      <value displayText="03:45 PM"  value="15:45:00" />
      <value displayText="04:00 PM"  value="16:00:00" />
      <value displayText="04:15 PM"  value="16:15:00" />
      <value displayText="04:30 PM"  value="16:30:00" />
      <value displayText="04:45 PM"  value="16:45:00" />
      <value displayText="05:00 PM"  value="17:00:00" />
      <value displayText="05:15 PM"  value="17:15:00" />
      <value displayText="05:30 PM"  value="17:30:00" />
      <value displayText="05:45 PM"  value="17:45:00" />
      <value displayText="06:00 PM"  value="18:00:00" />
      <value displayText="06:15 PM"  value="18:15:00" />
      <value displayText="06:30 PM"  value="18:30:00" />
      <value displayText="06:45 PM"  value="18:45:00" />
      <value displayText="07:00 PM"  value="19:00:00" />
      <value displayText="07:15 PM"  value="19:15:00" />
      <value displayText="07:30 PM"  value="19:30:00" />
      <value displayText="07:45 PM"  value="19:45:00" />
      <value displayText="08:00 PM"  value="20:00:00" />
      <value displayText="08:15 PM"  value="20:15:00" />
      <value displayText="08:30 PM"  value="20:30:00" />
      <value displayText="08:45 PM"  value="20:45:00" />
      <value displayText="09:00 PM"  value="21:00:00" />
      <value displayText="09:15 PM"  value="21:15:00" />
      <value displayText="09:30 PM"  value="21:30:00" />
      <value displayText="09:45 PM"  value="21:45:00" />
      <value displayText="10:00 PM"  value="22:00:00" />
      <value displayText="10:15 PM"  value="22:15:00" />
      <value displayText="10:30 PM"  value="22:30:00" />
      <value displayText="10:45 PM"  value="22:45:00" />
      <value displayText="11:00 PM"  value="23:00:00" />
      <value displayText="11:15 PM"  value="23:15:00" />
      <value displayText="11:30 PM"  value="23:30:00" />
      <value displayText="11:45 PM"  value="23:45:00" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="EndTime" text="End Time:"     default="18:00:00" >
      <value displayText="12:00 AM"  value="00:00:00" />
      <value displayText="12:15 AM"  value="00:15:00" />
      <value displayText="12:30 AM"  value="00:30:00" />
      <value displayText="12:45 AM"  value="00:45:00" />
      <value displayText="01:00 AM"  value="01:00:00" />
      <value displayText="01:15 AM"  value="01:15:00" />
      <value displayText="01:30 AM"  value="01:30:00" />
      <value displayText="01:45 AM"  value="01:45:00" />
      <value displayText="02:00 AM"  value="02:00:00" />
      <value displayText="02:15 AM"  value="02:15:00" />
      <value displayText="02:30 AM"  value="02:30:00" />
      <value displayText="02:45 AM"  value="02:45:00" />
      <value displayText="03:00 AM"  value="03:00:00" />
      <value displayText="03:15 AM"  value="03:15:00" />
      <value displayText="03:30 AM"  value="03:30:00" />
      <value displayText="03:45 AM"  value="03:45:00" />
      <value displayText="04:00 AM"  value="04:00:00" />
      <value displayText="04:15 AM"  value="04:15:00" />
      <value displayText="04:30 AM"  value="04:30:00" />
      <value displayText="04:45 AM"  value="04:45:00" />
      <value displayText="05:00 AM"  value="05:00:00" />
      <value displayText="05:15 AM"  value="05:15:00" />
      <value displayText="05:30 AM"  value="05:30:00" />
      <value displayText="05:45 AM"  value="05:45:00" />
      <value displayText="06:00 AM"  value="06:00:00" />
      <value displayText="06:15 AM"  value="06:15:00" />
      <value displayText="06:30 AM"  value="06:30:00" />
      <value displayText="06:45 AM"  value="06:45:00" />
      <value displayText="07:00 AM"  value="07:00:00" />
      <value displayText="07:15 AM"  value="07:15:00" />
      <value displayText="07:30 AM"  value="07:30:00" />
      <value displayText="07:45 AM"  value="07:45:00" />
      <value displayText="08:00 AM"  value="08:00:00" />
      <value displayText="08:15 AM"  value="08:15:00" />
      <value displayText="08:30 AM"  value="08:30:00" />
      <value displayText="08:45 AM"  value="08:45:00" />
      <value displayText="09:00 AM"  value="09:00:00" />
      <value displayText="09:15 AM"  value="09:15:00" />
      <value displayText="09:30 AM"  value="09:30:00" />
      <value displayText="09:45 AM"  value="09:45:00" />
      <value displayText="10:00 AM"  value="10:00:00" />
      <value displayText="10:15 AM"  value="10:15:00" />
      <value displayText="10:30 AM"  value="10:30:00" />
      <value displayText="10:45 AM"  value="10:45:00" />
      <value displayText="11:00 AM"  value="11:00:00" />
      <value displayText="11:15 AM"  value="11:15:00" />
      <value displayText="11:30 AM"  value="11:30:00" />
      <value displayText="11:45 AM"  value="11:45:00" />
      <value displayText="12:00 AM"  value="12:00:00" />
      <value displayText="12:15 AM"  value="12:15:00" />
      <value displayText="12:30 AM"  value="12:30:00" />
      <value displayText="12:45 AM"  value="12:45:00" />
      <value displayText="01:00 PM"  value="13:00:00" />
      <value displayText="01:15 PM"  value="13:15:00" />
      <value displayText="01:30 PM"  value="13:30:00" />
      <value displayText="01:45 PM"  value="13:45:00" />
      <value displayText="02:00 PM"  value="14:00:00" />
      <value displayText="02:15 PM"  value="14:15:00" />
      <value displayText="02:30 PM"  value="14:30:00" />
      <value displayText="02:45 PM"  value="14:45:00" />
      <value displayText="03:00 PM"  value="15:00:00" />
      <value displayText="03:15 PM"  value="15:15:00" />
      <value displayText="03:30 PM"  value="15:30:00" />
      <value displayText="03:45 PM"  value="15:45:00" />
      <value displayText="04:00 PM"  value="16:00:00" />
      <value displayText="04:15 PM"  value="16:15:00" />
      <value displayText="04:30 PM"  value="16:30:00" />
      <value displayText="04:45 PM"  value="16:45:00" />
      <value displayText="05:00 PM"  value="17:00:00" />
      <value displayText="05:15 PM"  value="17:15:00" />
      <value displayText="05:30 PM"  value="17:30:00" />
      <value displayText="05:45 PM"  value="17:45:00" />
      <value displayText="06:00 PM"  value="18:00:00" />
      <value displayText="06:15 PM"  value="18:15:00" />
      <value displayText="06:30 PM"  value="18:30:00" />
      <value displayText="06:45 PM"  value="18:45:00" />
      <value displayText="07:00 PM"  value="19:00:00" />
      <value displayText="07:15 PM"  value="19:15:00" />
      <value displayText="07:30 PM"  value="19:30:00" />
      <value displayText="07:45 PM"  value="19:45:00" />
      <value displayText="08:00 PM"  value="20:00:00" />
      <value displayText="08:15 PM"  value="20:15:00" />
      <value displayText="08:30 PM"  value="20:30:00" />
      <value displayText="08:45 PM"  value="20:45:00" />
      <value displayText="09:00 PM"  value="21:00:00" />
      <value displayText="09:15 PM"  value="21:15:00" />
      <value displayText="09:30 PM"  value="21:30:00" />
      <value displayText="09:45 PM"  value="21:45:00" />
      <value displayText="10:00 PM"  value="22:00:00" />
      <value displayText="10:15 PM"  value="22:15:00" />
      <value displayText="10:30 PM"  value="22:30:00" />
      <value displayText="10:45 PM"  value="22:45:00" />
      <value displayText="11:00 PM"  value="23:00:00" />
      <value displayText="11:15 PM"  value="23:15:00" />
      <value displayText="11:30 PM"  value="23:30:00" />
      <value displayText="11:45 PM"  value="23:45:00" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="MinuteInterval" text="Time Increments:" description="Set the time increments for displaying appointments."     default="30" >
      <value displayText="1 minute" value="1" />
      <value displayText="2 minute" value="2" />
      <value displayText="3 minute" value="3" />
      <value displayText="4 minute" value="4" />
      <value displayText="5 minute" value="5" />
      <value displayText="6 minute" value="6" />
      <value displayText="10 minute" value="10" />
      <value displayText="12 minute" value="12" />
      <value displayText="15 minute" value="15" />
      <value displayText="20 minute" value="20" />
      <value displayText="30 minute" value="30" />
      <value displayText="60 minute" value="60" />
    </extendedParameter>   
     <extendedParameter type="ComboBox" parameterName="ScheduleStyle" text="Schedule Style:" description="Select the style for printing appointments."     default="1">
      <value displayText="Normal" value="1" />
      <value displayText="Fixed Time Slots" value="2" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
from report r
where Name = 'Appointments Summary'

GO

/*----------------------------------------------------------------------
Case 6887:   Add customoziation option to Payment Detail report to filter by unapplied payments 
----------------------------------------------------------------------*/
Update R
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
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Method:" default="0" ignore="0"/>
    <extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Show Balance:"     default="A">
      <value displayText="All" value="A" />
      <value displayText="Unapplied Balance" value="U" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
FROM Report r
Where Name = 'Payments Detail'

GO

/*----------------------------------------------------------------------
Case 12321: Add units in the Practitioner
----------------------------------------------------------------------*/
alter table HANDHELDENCOUNTERDETAIL
	add Units int not null default 1


/*----------------------------------------------------------------------
Case 12893:   Dataprovider for Patient Activities v2.0 
----------------------------------------------------------------------*/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[BillTransmission]') AND name = N'IX_BillTransmission_PracticeIDPatientID')
DROP INDEX [IX_BillTransmission_PracticeIDPatientID] ON [dbo].[BillTransmission] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_BillTransmission_PracticeIDPatientID] ON [dbo].[BillTransmission] 
(
	[PracticeID] ASC,
	[PatientID] ASC
)WITH (PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO

/*----------------------------------------------------------------------
Case 12738:	Add field to enforce timeblocks
----------------------------------------------------------------------*/

-- Modify the timeblock table
ALTER TABLE Practice ADD 
	EnforceTimeblockRules bit not null CONSTRAINT DF_Practice_EnforceTimeblockRules DEFAULT (0)

GO


/*----------------------------------------------------------------------
Case 11794:	Add option for enable/disable statements for specific patiens
----------------------------------------------------------------------*/
ALTER TABLE PATIENTCASE ADD
	StatementActive bit not null default 1

GO

/*----------------------------------------------------------------------
Case 11793:	Add option for enable/disable statements for specific payer scenarios
----------------------------------------------------------------------*/
ALTER TABLE PayerScenario ADD
	StatementActive bit not null CONSTRAINT DF_PayerScenario_StatementActive DEFAULT (1)


/*-----------------------------------------------------------------------------
Case 12319: Payments Application Summary
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
	25, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Payments Application Summary', 
	'This report shows a summary of payment application over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPaymentsApplicationSummary',
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
		</parameters>',
	'Payments Appli&cation Summary', -- Why are "&" used in the value???
	'ReadPaymentsApplicationSummaryReport')

 

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
Case 5214: Clearinghouse Reports
-----------------------------------------------------------------------------*/

CREATE TABLE ClearinghouseResponseSourceType 
	(ClearinghouseResponseSourceTypeID int identity(1,1) NOT NULL PRIMARY KEY,
	SourceTypeName varchar(50))
GO

INSERT INTO ClearinghouseResponseSourceType (SourceTypeName) VALUES ('Internal')
INSERT INTO ClearinghouseResponseSourceType (SourceTypeName) VALUES ('Clearinghouse')
INSERT INTO ClearinghouseResponseSourceType (SourceTypeName) VALUES ('Payer')
INSERT INTO ClearinghouseResponseSourceType (SourceTypeName) VALUES ('Printer')
GO

CREATE TABLE ClearinghouseResponseReportType
	(ClearinghouseResponseReportTypeID int identity(1,1) NOT NULL PRIMARY KEY,
	ReportTypeName varchar(50))
GO

INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('EFT Check')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('ERA')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('Processing')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('EOB')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('Monthly')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('Statement')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('Other')
GO

ALTER TABLE ClearinghouseResponse
ADD
ClearinghouseResponseReportTypeID int,
ClearinghouseResponseSourceTypeID int,
SourceName varchar(128),
Notes varchar(256),
TotalAmount money,
ItemCount int,
Rejected int,
Denied int,
CheckList varchar(2048)
GO

ALTER TABLE [dbo].[ClearinghouseResponse]  WITH CHECK ADD CONSTRAINT [FK_ClearinghouseResponse_ClearinghouseResponseReportType] FOREIGN KEY([ClearinghouseResponseReportTypeID])
REFERENCES [dbo].[ClearinghouseResponseReportType] ([ClearinghouseResponseReportTypeID])
GO

ALTER TABLE [dbo].[ClearinghouseResponse]  WITH CHECK ADD CONSTRAINT [FK_ClearinghouseResponse_ClearinghouseResponseSourceType] FOREIGN KEY([ClearinghouseResponseSourceTypeID])
REFERENCES [dbo].[ClearinghouseResponseSourceType] ([ClearinghouseResponseSourceTypeID])
GO

-- migrate obvious data pieces into the new fields (case 13027):

-- EFT Checks
UPDATE ClearinghouseResponse SET 
ClearinghouseResponseReportTypeID = 1, ClearinghouseResponseSourceTypeID = 3		-- Payer
WHERE ResponseType = 35

-- ERA processable
UPDATE ClearinghouseResponse SET 
ClearinghouseResponseReportTypeID = 2, ClearinghouseResponseSourceTypeID = 3
WHERE ResponseType = 33

-- Processing
UPDATE ClearinghouseResponse SET 
ClearinghouseResponseReportTypeID = 3, ClearinghouseResponseSourceTypeID = 1		-- Internal
WHERE ResponseType = 17

-- EOB
UPDATE ClearinghouseResponse SET 
ClearinghouseResponseReportTypeID = 4, ClearinghouseResponseSourceTypeID = 3
WHERE ResponseType = 32

-- Monthly
UPDATE ClearinghouseResponse SET 
ClearinghouseResponseReportTypeID = 5, ClearinghouseResponseSourceTypeID = 2		-- Clearinghouse
WHERE ResponseType IN (14, 15)

-- Statement (like Daily)
UPDATE ClearinghouseResponse SET 
ClearinghouseResponseReportTypeID = 6, ClearinghouseResponseSourceTypeID = 2
WHERE ResponseType IN (13, 16, 18)

-- Statement (like Daily)
UPDATE ClearinghouseResponse SET 
ClearinghouseResponseReportTypeID = 6, ClearinghouseResponseSourceTypeID = 3
WHERE ResponseType = 12

-- Patient Statement Report
UPDATE ClearinghouseResponse SET 
ClearinghouseResponseReportTypeID = 6, ClearinghouseResponseSourceTypeID = 4
WHERE ResponseType = 22

-- Source Name can be also filled here:
-- OfficeAlly
UPDATE ClearinghouseResponse SET 
SourceName = 'Office Ally'
WHERE Title LIKE '%Office Ally%' OR Title LIKE '%OfficeAlly%'
GO

-- MedAvant
UPDATE ClearinghouseResponse SET 
SourceName = 'MedAvant'
WHERE Title LIKE '%MedAvant%' OR Title LIKE '%ProxyMed%'
GO

-- Kareo
UPDATE ClearinghouseResponse SET 
SourceName = 'Kareo'
WHERE Title LIKE '%Kareo%' AND NOT Title LIKE '%_KAREO%' AND NOT Title LIKE '%KAREO_%' ESCAPE('_')
GO

-- PSC
UPDATE ClearinghouseResponse SET 
SourceName = 'PSC Info Group'
WHERE Title LIKE '%PSC %' OR ( Title LIKE '%_KAREO%' AND Title LIKE '%_Stats%' ESCAPE('_') )
GO

-- Payer Name
UPDATE ClearinghouseResponse SET 
SourceName = REPLACE(Title, ' ELECTRONIC RESPONSE REPORT', '')
WHERE Title LIKE '% ELECTRONIC RESPONSE REPORT%' AND ResponseType = 12
GO

-- Payer Name for EOBs
UPDATE ClearinghouseResponse SET 
SourceName = SUBSTRING(Title,CHARINDEX(') - ',Title)+4,100)
WHERE Title LIKE '%) - %' AND ResponseType IN (32, 33, 34, 35)
GO

-- Payer Name for ERAs
UPDATE ClearinghouseResponse SET 
SourceName = SUBSTRING(Title,CHARINDEX('*** ',Title)+5,100)
WHERE Title LIKE '%*** %' AND ResponseType IN (32, 33, 34, 35)
GO

-- EFT Checks 
UPDATE ClearinghouseResponse SET 
CheckList = REPLACE(SUBSTRING(Title,CHARINDEX('(',Title)+1,255),')','') 
WHERE Title LIKE '%EFT Check %' AND ResponseType IN (35)
GO

-- ERA-related Checks 
UPDATE ClearinghouseResponse SET 
CheckList = REPLACE(SUBSTRING(Title,CHARINDEX('X12/835 (',Title)+9,255),')','') 
WHERE Title LIKE '%X12/835 (%' AND ResponseType = 33
GO

UPDATE ClearinghouseResponse SET 
CheckList = SUBSTRING(CheckList,1,CHARINDEX('**',CheckList)-1) 
WHERE Title LIKE '%X12/835 (%' AND ResponseType = 33
GO

-- EOB-related Checks 
UPDATE ClearinghouseResponse SET 
CheckList = SUBSTRING(Title,CHARINDEX('Explanation of Provider Payment (',Title)+33,255) 
WHERE Title LIKE '%Explanation of Provider Payment (%' AND ResponseType = 32
GO

UPDATE ClearinghouseResponse SET 
CheckList = REPLACE(SUBSTRING(CheckList,1,CHARINDEX(')',CheckList)),')','') 
WHERE Title LIKE '%Explanation of Provider Payment (%' AND ResponseType = 32
GO

-- All claim counters - parse Title to get information
UPDATE ClearinghouseResponse SET ItemCount =
CONVERT(INT,SUBSTRING(Title,CHARINDEX(' P:',Title)+3,CHARINDEX(' / ',Title)-CHARINDEX(' P:',Title)-3))
WHERE Title LIKE '% P:%/%'
GO

UPDATE ClearinghouseResponse SET Rejected =
CONVERT(INT,REPLACE(SUBSTRING(Title,CHARINDEX(' R:',Title)+3,4),'/',''))
WHERE Title LIKE '% R:%' AND Title NOT LIKE '% Validation %'
GO

UPDATE ClearinghouseResponse SET Rejected =
CONVERT(INT,SUBSTRING(Title,CHARINDEX(' R:',Title)+3,10))
WHERE Title LIKE '% Validation %' AND Title LIKE '% R:%'
GO

UPDATE ClearinghouseResponse SET ItemCount = ISNULL(ItemCount,0) + ISNULL(Rejected,0)
WHERE ItemCount IS NOT NULL OR Rejected IS NOT NULL
GO

-- Patient Statements item counters 
UPDATE ClearinghouseResponse SET ItemCount =
CONVERT(INT,REPLACE(SUBSTRING(Title,CHARINDEX(' (',Title)+2,100),' each)',''))
WHERE Title LIKE '%PSC Patient Statement Batch%(%' 
GO

UPDATE ClearinghouseResponse SET TotalAmount =
CONVERT(MONEY,CONVERT(FLOAT,REPLACE(REPLACE(SUBSTRING(Title,CHARINDEX(' $',Title)+2,LEN(Title)-CHARINDEX('(',Title)+3),' ',''),',','')))
WHERE Title LIKE '%PSC Patient Statement Batch %.%(%' ESCAPE('$')
GO

-------------------------------------------
--Case 13330:   Payment Details report has a filter by provider --> but that doesn't make sense 
-------------------------------------------
UPDATE Report
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
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Method:" default="0" ignore="0"/>
    <extendedParameter type="ComboBox" parameterName="PaymentTypeID" text="Payment Type:" description="Limits the report by payment type."     default="-1">
      <value displayText="All" value="-1" />
      <value displayText="Copay" value="1" />
      <value displayText="Patient Payment on Account" value="2" />
      <value displayText="Insurance Payment" value="3" />
      <value displayText="Other" value="4" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ReportType" text="Show Balance:"     default="A">
      <value displayText="All" value="A" />
      <value displayText="Unapplied Balance" value="U" />
    </extendedParameter>
    <extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
  </extendedParameters>
</parameters>'
WHERE Name = 'Payments Detail'
GO

/*-----------------------------------------------------------------------------
Case 12252 - Check to make sure we are tracking users that create & modify 
             records  
-----------------------------------------------------------------------------*/

/* Add CreatedUserID and ModifiedUserID columns ... */

BEGIN TRANSACTION
ALTER TABLE dbo.Claim ADD
	CreatedUserID int NULL,
	ModifiedUserID int NULL
COMMIT
GO

/* Add CreatedUserID and ModifiedUserID columns ... */
BEGIN TRANSACTION
ALTER TABLE dbo.ClaimTransaction ADD
	CreatedUserID int NULL,
	ModifiedUserID int NULL
COMMIT
GO

/* Add CreatedUserID and ModifiedUserID columns ... */
BEGIN TRANSACTION
ALTER TABLE dbo.Payment ADD
	CreatedUserID int NULL,
	ModifiedUserID int NULL
COMMIT
GO

--------------------------------------------------------------------------------
-- CASE 12425 - Create a new stored procedure that will prepare data for the Accro/Health printing vendor
--------------------------------------------------------------------------------

ALTER TABLE Bill_Statement ADD InternalBillTemplateID BIGINT

GO

CREATE INDEX IX_Bill_Statement_BillBatchID_PatientID
ON Bill_Statement (BillBatchID, PatientID)

GO

ALTER TABLE BillClaim ADD ClaimTransactionID INT

GO

ALTER TABLE BillClaim ADD CONSTRAINT DF_BillClaim_ClaimTransactionID DEFAULT 0 FOR ClaimTransactionID

GO

UPDATE BillClaim SET ClaimTransactionID=0
WHERE ClaimTransactionID IS NULL

GO

ALTER TABLE BillClaim ALTER COLUMN ClaimTransactionID INT NOT NULL

GO

ALTER TABLE BillClaim DROP CONSTRAINT PK_BillClaim

GO

ALTER TABLE BillClaim ADD  CONSTRAINT PK_BillClaim PRIMARY KEY CLUSTERED 
(BillID, BillBatchTypeCode, ClaimID, ClaimTransactionID)

GO

CREATE INDEX IX_BillClaim_ClaimTransactionID
ON BillClaim (ClaimTransactionID)

GO


------------------------------------------------------------------
--Case 5637:   Patient Details: Add "Retired" to Employment status 
------------------------------------------------------------------
INSERT INTO EmploymentStatus (EmploymentStatusCode, StatusName) VALUES ('R', 'Retired')


GO


------------------------------------------------------------------
--Case 13316:   Patient Contact Report: Add new option "ALL" to the patient 
------------------------------------------------------------------
UPDATE Report 
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
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
WHERE Name = 'Patient Contact List'
GO


------------------------------------------------------------------
--Case 12855:   Add insurance and contract filters to A/R by Patient report 
------------------------------------------------------------------
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
</parameters>',
ReportPath = '/BusinessManagerReports/rptARAging_Patient',
ModifiedDate = getdate()
where name = 'A/R Aging by Patient'
GO



------------------------------------------------------------------
--Case SF1616: Add 2 new fields for the patient case
------------------------------------------------------------------
ALTER TABLE patientcase ADD 
	EPSDT bit not null default 0,
	FamilyPlanning  bit not null default 0
GO

/*=============================================================================
Case 13182 - Performance Improvement - Reduce time to display practice 
             dashboard
=============================================================================*/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EncounterProcedure]') AND name = N'IX_PracticeID_EncounterProcedureID')
DROP INDEX [IX_PracticeID_EncounterProcedureID] ON [dbo].[EncounterProcedure] WITH ( ONLINE = OFF )

GO

CREATE NONCLUSTERED INDEX [IX_PracticeID_EncounterProcedureID] ON [dbo].[EncounterProcedure] 
(
	[PracticeID] ASC,
	[EncounterProcedureID] ASC
)
INCLUDE ( [EncounterID]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

GO

--ROLLBACK
--COMMIT

