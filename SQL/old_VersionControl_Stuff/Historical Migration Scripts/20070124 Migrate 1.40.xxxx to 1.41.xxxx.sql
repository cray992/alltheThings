/*----------------------------------

DATABASE UPDATE SCRIPT

v1.40.xxxx to v1.41.xxxx
----------------------------------*/

/*----------------------------------------------------------------------------- 
Case 19200 - Practice Details: Add Subscription Edition, Support Plan dropdowns  
-----------------------------------------------------------------------------*/

/* Create Subscription Edition types table ... */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EditionType]') AND type in (N'U'))
DROP TABLE [dbo].[EditionType]
GO

CREATE TABLE [dbo].[EditionType](
	[EditionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[EditionTypeName] [varchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SortOrder] [smallint],
	[Active] [bit],
 CONSTRAINT [PK_SubscriptionType] PRIMARY KEY CLUSTERED 
(
	[EditionTypeID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

/*
Insert the following known editions:
	Enterprise
	Team
	Basic
*/

INSERT INTO dbo.[EditionType] (
	EditionTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Enterprise',
	10,
	1 )
GO

INSERT INTO dbo.[EditionType] (
	EditionTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Team',
	20,
	1 )
GO

INSERT INTO dbo.[EditionType] (
	EditionTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Basic',
	30,
	1 )
GO

/* Create Support Plan types table ... */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SupportType]') AND type in (N'U'))
DROP TABLE [dbo].[SupportType]
GO

CREATE TABLE [dbo].[SupportType](
	[SupportTypeID] [int] IDENTITY(1,1) NOT NULL,
	[SupportTypeName] [varchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SortOrder] [smallint],
	[Active] [bit],
 CONSTRAINT [PK_SupportType] PRIMARY KEY CLUSTERED 
(
	[SupportTypeID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

/*
Insert the following known support plans:
	Platinum
	Gold
	Standard
*/

INSERT INTO dbo.[SupportType] (
	SupportTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Platinum',
	10,
	1 )
GO

INSERT INTO dbo.[SupportType] (
	SupportTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Gold',
	20,
	1 )
GO

INSERT INTO dbo.[SupportType] (
	SupportTypeName, 
	SortOrder, 
	Active ) 
VALUES (
	'Standard',
	30,
	1 )
GO

/* Add columns EditionTypeID, SupportTypeID to practice ... */
ALTER TABLE dbo.Practice ADD
	EditionTypeID INT NULL,
	SupportTypeID INT NULL
GO

--------------------------------------------------------------------------------
-- CASE 19453
--------------------------------------------------------------------------------
-- Add DMS Record Type to all Customers
INSERT INTO DMSRecordType
			(TableName
			,Name
			,Description
			,SortOrder
			,Visible)
     VALUES
           ('PatientEncounterAppointment'
           ,'Patient Encounter Appointment Record'
           ,'Patient Encounter Appointment Record'
           ,8
           ,0)


GO

--------------------------------------------------------------------------------
-- Case 17089 - Add table for Payment Business Rule Log
--------------------------------------------------------------------------------
CREATE TABLE PaymentBusinessRuleLog(
	PaymentBusinessRuleLogID INT IDENTITY(1,1) NOT NULL,
	PaymentID INT NOT NULL, 
	PracticeID INT NOT NULL, 
	BusinessRuleLog VARBINARY(MAX),
	CreatedDate datetime NOT NULL CONSTRAINT [DF_PaymentBusinessRuleLog_CreatedDate]  DEFAULT (getdate()), 
	CreatedUserID int NOT NULL CONSTRAINT [DF_PaymentBusinessRuleLog_CreatedUserID]  DEFAULT (0)
	CONSTRAINT PK_PaymentBusinessRuleLog PRIMARY KEY NONCLUSTERED 
	(
		PaymentBusinessRuleLogID 
	)
) 

ALTER TABLE Payment ADD CONSTRAINT FK_Payment_PaymentBusinessRuleLog
FOREIGN KEY (PaymentID) REFERENCES Payment (PaymentID)

ALTER TABLE Practice ADD CONSTRAINT FK_Practice_PaymentBusinessRuleLog
FOREIGN KEY (PracticeID) REFERENCES Practice (PracticeID)

------------------------------------------------------------------------------------------------
-- CASE 7952 - Add foreign key constraint on PayerProcessingStatusTypeCode column in Claim table
------------------------------------------------------------------------------------------------

INSERT INTO PayerProcessingStatusType VALUES('P00', 'Paid', 5)
INSERT INTO PayerProcessingStatusType VALUES('AC0', 'Claim Completed', 6)
INSERT INTO PayerProcessingStatusType VALUES('I00', 'Inconclusive', 10)

ALTER TABLE Claim WITH NOCHECK ADD CONSTRAINT FK_Claim_PayerProcessingStatusType
FOREIGN KEY (PayerProcessingStatusTypeCode) REFERENCES PayerProcessingStatusType (PayerProcessingStatusTypeCode)
ALTER TABLE Claim CHECK CONSTRAINT FK_Claim_PayerProcessingStatusType
GO

-----------------------------------------------------------------------------------------------------
-- Case 14531:   Add new notes, display existing notes from patient activities 
-----------------------------------------------------------------------------------------------------
UPDATE PatientHistorySetup SET Configuration=
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
		<action type="AddNote" />
		<action type="Print" reportPath="/BusinessManagerReports/rptGetActivities_TransactionSummary" />
	</actions>
	<!-- Section to determine the column structure for the report -->
	<columns>
		<column field="ClaimHasNotes" name="Notes" width="40" datatype="Bool" columntype="Check" />
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
WHERE PatientHistorySetupID = 1

---------------------------------------------------------------------------------
-- Case 17654:   RecordEDITransmission must be adapted to handle Z-number types PCNs 
---------------------------------------------------------------------------------

ALTER TABLE BillTransmission ADD
	ClaimPcnSV varchar(64) NULL
GO

UPDATE BillTransmission SET ClaimPcnSV = ClaimPcn
GO 

---------------------------------------------------------------------------------
-- Case 18780:   Add support to exclude patient payment amounts for claims 
---------------------------------------------------------------------------------

ALTER TABLE PracticeToInsuranceCompany ADD ExcludePatientPayment BIT NOT NULL DEFAULT 0

GO


/*-----------------------------------------------------------------------------
-- Case 19950:   Create support for record-specific Categories
-----------------------------------------------------------------------------*/

CREATE TABLE [CategoryRecordType]
(
	[CategoryRecordTypeID] [int] NOT NULL,
	[TableName] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT [PK_CategoryRecordType] PRIMARY KEY CLUSTERED 
	(
		[CategoryRecordTypeID] ASC
	),
	CONSTRAINT [UX_CategoryRecordType_TableName] UNIQUE NONCLUSTERED 
	(
		[TableName] ASC
	)
)
GO

CREATE TABLE Category
(
	[CategoryID] int IDENTITY(1,1) NOT NULL,
	[Name] varchar(200) NOT NULL,
	Description varchar(1000),
	CategoryRecordTypeID int NOT NULL,
	PracticeID int NOT NULL,
	CreatedDate datetime NOT NULL CONSTRAINT [DF_Category_CreatedDate]  DEFAULT (getdate()), 
	CreatedUserID int NOT NULL CONSTRAINT [DF_Category_CreatedUserID]  DEFAULT (0),
	ModifiedDate datetime NOT NULL CONSTRAINT [DF_Category_ModifiedDate]  DEFAULT (getdate()), 
	ModifiedUserID int NOT NULL CONSTRAINT [DF_Category_ModifiedUserID]  DEFAULT (0),
	CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED
	(
		[CategoryID] ASC
	),
	CONSTRAINT [FK_Category_CategoryRecordType] FOREIGN KEY (CategoryRecordTypeID)
		REFERENCES CategoryRecordType ( [CategoryRecordTypeID] ),
	CONSTRAINT [FK_Category_Practice] FOREIGN KEY (PracticeID)
		REFERENCES Practice ( [PracticeID] )
)
GO

--insert some data now

INSERT INTO CategoryRecordType
	(CategoryRecordTypeID, TableName, Name)
VALUES
	(1,'Payment','Payment Record')
GO

-------------------------------------------------------------
-- Add grouping to payment report
--------------------------------------------------------------
update reportHyperLink
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
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
            <methodParam param="PayerTypeCode" />
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
          <method name="Add">
            <methodParam param="PaymentMethodCode" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="PaymentTypeID" />
            <methodParam param="{5}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE ReportHyperlinkID = 8


update report
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
    <extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Method:" default="A" ignore="A"/>
    <extendedParameter type="ComboBox" parameterName="PayerTypeCode" text="Payer Type:" description="Limits the report by payer type."     default="-1">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
      <value displayText="Insurance" value="I" />
      <value displayText="Other" value="O" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Select to group by"     default="1">
      <value displayText="Payer Type" value="1" />
      <value displayText="Payment Method" value="2" />
      <value displayText="Payment Type" value="3" />
		<value displayText="User Role" value="4" />
		<value displayText="Category" value="5" />
    </extendedParameter>
  </extendedParameters>
</parameters>'
WHERE ReportID = 5
GO





-------------------------------------------------------------
-- Case 18031:   If time allows, re-order list of reports in menu Reports -> Payments    	  
--------------------------------------------------------------
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



update Report
set MenuName = 'Adj&ustments Detail',
	ModifiedDate = getDate()
where Name = 'Adjustments Detail'
GO


/*-----------------------------------------------------------------------------
Case 19167 - Recommend some quick changes to avoid customer confusion on new 
copay logic
-----------------------------------------------------------------------------*/

/* Add new PaymentCategoryID column to Encounter ... */
ALTER TABLE dbo.Encounter ADD
	PaymentCategoryID int NULL
GO

ALTER TABLE dbo.Encounter ADD CONSTRAINT
	FK_Encounter_PaymentCategoryID FOREIGN KEY
	(
	PaymentCategoryID
	) REFERENCES dbo.Category
	(
	CategoryID
	) ON UPDATE  NO ACTION 
	 ON DELETE  SET NULL 
	
GO

/* Add new PaymentCategoryID column to Payment ... */
ALTER TABLE dbo.Payment ADD
	PaymentCategoryID int NULL
GO

ALTER TABLE dbo.Payment ADD CONSTRAINT
	FK_Payment_PaymentCategoryID FOREIGN KEY
	(
	PaymentCategoryID
	) REFERENCES dbo.Category
	(
	CategoryID
	) ON UPDATE  NO ACTION 
	 ON DELETE  SET NULL
	
GO

/* Add new columns ... */
ALTER TABLE dbo.EncounterProcedure ADD
	ApplyPayment money NULL,
	PatientResp money NULL
GO

/* Update new columns ... */

/* Update patient responsibility column with copay due amount ... */
UPDATE EP
SET
	PatientResp = CopayAmount
FROM dbo.EncounterProcedure EP
GO

/* Update payment application amount of encounter procedures that are at least 'Approved' ... */
UPDATE EP
SET
	ApplyPayment =	CASE 
						WHEN ApplyCopay = 1 THEN COALESCE(
							( SELECT TOP 1 CA.Amount 
							FROM ClaimAccounting CA 
							WHERE CA.EncounterProcedureID = EP.EncounterProcedureID
								AND CA.PaymentID = P.PaymentID
								AND CA.ClaimTransactionTypeCode = 'PAY'
							ORDER BY CA.ClaimTransactionID ), 0)
						ELSE 0 
					END
FROM dbo.EncounterProcedure EP
	JOIN dbo.Encounter E ON E.EncounterID = EP.EncounterID
	LEFT JOIN dbo.Payment P ON P.SourceEncounterID = EP.EncounterID
WHERE E.EncounterStatusID >= 3 
GO

/* Update 'Draft' or 'Submitted' encounter procedures ... */

DECLARE @EncounterID INT,
	@PaymentAmount MONEY,
	@EncounterProcedureID INT,
	@ApplyCopay BIT,
	@CopayAmount MONEY,
	@ApplyPayment MONEY

DECLARE Encounter_Cursor CURSOR FORWARD_ONLY FOR
	SELECT E.EncounterID, ISNULL(E.AmountPaid, 0)
	FROM dbo.Encounter E
	WHERE E.EncounterStatusID <= 2

OPEN Encounter_Cursor

FETCH NEXT FROM Encounter_Cursor
INTO @EncounterID, @PaymentAmount

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE EncounterProcedure_Cursor CURSOR FORWARD_ONLY FOR
		SELECT EP.EncounterProcedureID, 
			ISNULL(EP.ApplyCopay, 0), 
			ISNULL(EP.PatientResp, 0)
		FROM dbo.EncounterProcedure EP
		WHERE EP.EncounterID = @EncounterID
		ORDER BY EP.EncounterProcedureID ASC

	OPEN EncounterProcedure_Cursor

	IF (@PaymentAmount > 0) 
	BEGIN
		/* Allocate the payment ... */
		FETCH NEXT FROM EncounterProcedure_Cursor
		INTO @EncounterProcedureID, @ApplyCopay, @CopayAmount
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (@ApplyCopay = 1) AND (@PaymentAmount > 0)
			BEGIN
				/* Determine the amount of payment to apply ... */
				IF (@PaymentAmount > @CopayAmount)
					SET @ApplyPayment = @CopayAmount
				ELSE
					SET @ApplyPayment = @PaymentAmount
				
				/* Apply payment to procedure ... */
				UPDATE dbo.EncounterProcedure 
				SET	ApplyPayment = @ApplyPayment
				WHERE EncounterProcedureID = @EncounterProcedureID

				/* Reduce encounter payment amount by the amount applied ... */
				SET @PaymentAmount = @PaymentAmount - @ApplyPayment
			END
			ELSE
			BEGIN
				/* Apply "$0.00" payment to procedure ... */
				UPDATE dbo.EncounterProcedure 
				SET	ApplyPayment = 0
				WHERE EncounterProcedureID = @EncounterProcedureID
			END

			FETCH NEXT FROM EncounterProcedure_Cursor
			INTO @EncounterProcedureID, @ApplyCopay, @CopayAmount
		END
	END 
	ELSE 
	BEGIN
		/* No payment to allocate ... */
		FETCH NEXT FROM EncounterProcedure_Cursor
		INTO @EncounterProcedureID, @ApplyCopay, @CopayAmount

		WHILE @@FETCH_STATUS = 0
		BEGIN
			/* Apply "$0.00" payment to procedure ... */
			UPDATE dbo.EncounterProcedure 
			SET	ApplyPayment = 0
			WHERE EncounterProcedureID = @EncounterProcedureID

			FETCH NEXT FROM EncounterProcedure_Cursor
			INTO @EncounterProcedureID, @ApplyCopay, @CopayAmount
		END
	END
	
	CLOSE EncounterProcedure_Cursor
	DEALLOCATE EncounterProcedure_Cursor

	FETCH NEXT FROM Encounter_Cursor
	INTO @EncounterID, @PaymentAmount
END

CLOSE Encounter_Cursor
DEALLOCATE Encounter_Cursor
GO

/* Drop any default constraint on the 'ApplyCopay' column ... */
declare @drop_constraint_sql varchar(200)

select @drop_constraint_sql = 'ALTER TABLE dbo.EncounterProcedure DROP CONSTRAINT ' + dc.[name]
from sys.objects o
	join sys.columns c on c.[object_id] = o.[object_id]
	join sys.default_constraints dc on dc.parent_object_id = o.[object_id]
		and dc.parent_column_id = c.column_id
where o.[name] = 'EncounterProcedure' 
	and c.[name] = 'ApplyCopay'

if (@drop_constraint_sql is not null)
	exec(@drop_constraint_sql)

go

ALTER TABLE dbo.EncounterProcedure
	DROP CONSTRAINT DF_EncounterProcedure_CopayAmount
GO

/* Drop old columns ... */

ALTER TABLE dbo.EncounterProcedure
	DROP COLUMN ApplyCopay
GO

ALTER TABLE dbo.EncounterProcedure
	DROP COLUMN CopayAmount
GO

/* Add default constraints ... */
ALTER TABLE [dbo].[EncounterProcedure] ADD  CONSTRAINT [DF_EncounterProcedure_ApplyPayment]  DEFAULT ((0)) FOR [ApplyPayment]
GO

ALTER TABLE [dbo].[EncounterProcedure] ADD  CONSTRAINT [DF_EncounterProcedure_PatientResp]  DEFAULT ((0)) FOR [PatientResp]
GO

/* Change default value for auto-populate copay option ... */
declare @drop_constraint_sql2 varchar(200)

select @drop_constraint_sql2 = 'ALTER TABLE dbo.Practice DROP CONSTRAINT ' + dc.[name]
from sys.objects o
	join sys.columns c on c.[object_id] = o.[object_id]
	join sys.default_constraints dc on dc.parent_object_id = o.[object_id]
		and dc.parent_column_id = c.column_id
where o.[name] = 'Practice' 
	and c.[name] = 'EOPopulateCopay'

if (@drop_constraint_sql2 is not null)
	exec(@drop_constraint_sql2)

go

ALTER TABLE dbo.Practice ADD CONSTRAINT
	DF_Practice_EOPopulateCopay DEFAULT ((0)) FOR EOPopulateCopay
GO

/* Migrate payment type data for DepartmentB, Physical Medicine Associates ... */
IF (DB_NAME() = 'superbill_0001_prod')
BEGIN

	DECLARE @PracticeID INT, @CopayCategoryID INT, @PatientAccountCategoryID INT

	SET @PracticeID = 65 

	/* Create new payment categories ... */
	INSERT INTO dbo.Category (
		[Name], 
		Description, 
		CategoryRecordTypeID, 
		PracticeID )
	VALUES (
		'Copay',
		'Copay',
		1,
		@PracticeID )

	SET @CopayCategoryID = SCOPE_IDENTITY()

	INSERT INTO dbo.Category (
		[Name], 
		Description, 
		CategoryRecordTypeID, 
		PracticeID )
	VALUES (
		'Patient Payment on Account',
		'Patient Payment on Account',
		1,
		@PracticeID )

	SET @PatientAccountCategoryID = SCOPE_IDENTITY()

	/* Populate encounter PaymentCategoryID ... */
	UPDATE	E
	SET		E.PaymentCategoryID =	CASE 
									WHEN E.PaymentTypeID = 1 THEN @CopayCategoryID
									WHEN E.PaymentTypeID = 2 THEN @PatientAccountCategoryID
									ELSE NULL
								END
	FROM	dbo.Encounter E
	WHERE	E.PracticeID = @PracticeID

	/* Populate payment PaymentCategoryID ... */
	UPDATE	P
	SET		P.PaymentCategoryID =	CASE 
									WHEN P.PaymentTypeID = 1 THEN @CopayCategoryID
									WHEN P.PaymentTypeID = 2 THEN @PatientAccountCategoryID
									ELSE NULL
								END
	FROM	dbo.Payment P
	WHERE	P.PracticeID = @PracticeID
END
GO
----------------------------------------------------------------------------------
-- CASE ELIGIBILITY
----------------------------------------------------------------------------------
DECLARE @B2BPayerID INT
SET @B2BPayerID = (SELECT MAX(B2BPayerID) + 1 FROM B2BPayersList)

INSERT INTO dbo.B2BPayersList
           (B2BPayerID
           ,B2BPayerName
           ,B2BPayerNumber
           ,ProviderCode
           ,KareoLastModifiedDate
           ,CreatedDate
           ,CreatedUserID
           ,ModifiedDate
           ,ModifiedUserID)
     VALUES
           (@B2BPayerID ,	'Aetna',	'60054',	NULL,	NULL,	GetDate(),	NULL,	NULL,	NULL)
GO

UPDATE    CHPL
SET              B2BPayerID = 343, SupportsPatientEligibilityRequests = 1
FROM         ClearinghousePayersList AS CHPL 
INNER JOIN InsuranceCompany AS IC 
ON CHPL.ClearinghousePayerID = IC.ClearinghousePayerID
WHERE     (IC.InsuranceCompanyName LIKE '%AETNA%')
GO
/*-----------------------------------------------------------------------------
-- Case XXXXX:   
-----------------------------------------------------------------------------*/