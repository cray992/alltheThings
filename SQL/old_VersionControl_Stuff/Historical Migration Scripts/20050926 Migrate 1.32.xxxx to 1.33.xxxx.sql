/*

DATABASE UPDATE SCRIPT

v1.32.xxxx to v1.33.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 6914 - Add table for Attorney

CREATE TABLE Attorney(
	AttorneyID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_Attorney_AttorneyID 
		PRIMARY KEY NONCLUSTERED,
	PatientCaseID INT NOT NULL,
	Type CHAR(1) NOT NULL,
	InsurancePolicyID INT,
	CompanyName VARCHAR(128), 
	Prefix VARCHAR(16) NOT NULL,
	FirstName VARCHAR(64) NOT NULL,
	MiddleName VARCHAR(64) NOT NULL,
	LastName VARCHAR(64) NOT NULL,
	Suffix VARCHAR(16) NOT NULL, 
	AddressLine1 VARCHAR(256),
	AddressLine2 VARCHAR(256),
	City VARCHAR(128),
	State VARCHAR(2),
	Country VARCHAR(32),
	ZipCode VARCHAR(9),
	WorkPhone VARCHAR(10),
	WorkPhoneExt VARCHAR(10),
	FaxPhone VARCHAR(10),
	FaxPhoneExt VARCHAR(10),
	Notes TEXT,
	CreatedDate DATETIME NOT NULL CONSTRAINT DF_Attorney_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_Attorney_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_Attorney_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_Attorney_ModifiedUserID DEFAULT (0)
			)

GO

-- Add a foreign key for the patient case id
ALTER TABLE [dbo].[Attorney] ADD
	CONSTRAINT [FK_Attorney_PatientCase] FOREIGN KEY 
	(
		[PatientCaseID]
	) REFERENCES [PatientCase] (
		[PatientCaseID]
	)
GO

-- Add a foreign key for the insurance policy id
ALTER TABLE [dbo].[Attorney] ADD
	CONSTRAINT [FK_Attorney_InsurancePolicyID] FOREIGN KEY 
	(
		[InsurancePolicyID]
	) REFERENCES [InsurancePolicy] (
		[InsurancePolicyID]
	)
GO
	
---------------------------------------------------------------------------------------
--case 6899 - Add table for WorkersCompContactInfo

CREATE TABLE WorkersCompContactInfo(
	WorkersCompContactInfoID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_WorkersCompContactInfo_WorkersCompContactInfoID 
		PRIMARY KEY NONCLUSTERED,
	PatientCaseID INT NOT NULL,
	OfficeName VARCHAR(128), 
	CaseNumber VARCHAR(128), 
	AddressLine1 VARCHAR(256),
	AddressLine2 VARCHAR(256),
	City VARCHAR(128),
	State VARCHAR(2),
	Country VARCHAR(32),
	ZipCode VARCHAR(9),
	WorkPhone VARCHAR(10),
	WorkPhoneExt VARCHAR(10),
	FaxPhone VARCHAR(10),
	FaxPhoneExt VARCHAR(10),
	CreatedDate DATETIME NOT NULL CONSTRAINT DF_WorkersCompContactInfo_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_WorkersCompContactInfo_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_WorkersCompContactInfo_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_WorkersCompContactInfo_ModifiedUserID DEFAULT (0)
			)

GO

-- Add a foreign key for the patient case id
ALTER TABLE [dbo].[WorkersCompContactInfo] ADD
	CONSTRAINT [FK_WorkersCompContactInfo_PatientCase] FOREIGN KEY 
	(
		[PatientCaseID]
	) REFERENCES [PatientCase] (
		[PatientCaseID]
	)
GO

---------------------------------------------------------------------------------------
--case 6893 - Add report hyperlink information for AR Aging Detail report to Claim Detail task

INSERT INTO ReportHyperlink(
	ReportHyperlinkID,
	Description,
	ReportParameters)
VALUES(	10,
	'Claim Detail Task',
	'<?xml version="1.0" encoding="utf-8" ?>
<task name="Claim Detail">
 <object type="Kareo.Superbill.Windows.Tasks.Domain.SimpleDetailParameters">
   <method name="">
     <methodParam param="{0}" type="System.Int32" />
     <methodParam param="true" type="System.Boolean"/>
   </method>
 </object>
</task>')

-- Update old hyperlinks to explicitly call constructor
UPDATE	ReportHyperlink
SET	ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?> 
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="A/R Aging Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
	  <method name="" />
          <method name="Add">
            <methodParam param="RespType" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="RespID" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="Date" />
            <methodParam param="{2}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE	ReportHyperlinkID = 1

UPDATE	ReportHyperlink
SET	ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Referrals Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="ProviderID" />
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
            <methodParam param="ServiceLocationID" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="ReferringProviderID" />
            <methodParam param="{4}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE	ReportHyperlinkID = 2

UPDATE	ReportHyperlink
SET	ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Referrals Detail" />
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
            <methodParam param="ServiceLocationID" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="ReferringProviderID" />
            <methodParam param="{3}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE	ReportHyperlinkID = 3

UPDATE	ReportHyperlink
SET	ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Referrals Detail" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="ProviderID" />
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
            <methodParam param="ReferringProviderID" />
            <methodParam param="{3}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE	ReportHyperlinkID = 4

UPDATE	ReportHyperlink
SET	ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Referrals Detail" />
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
            <methodParam param="ReferringProviderID" />
            <methodParam param="{2}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE	ReportHyperlinkID = 5

UPDATE	ReportHyperlink
SET	ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Patient Transactions Detail" />
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
            <methodParam param="BeginDate" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{2}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE	ReportHyperlinkID = 6

UPDATE	ReportHyperlink
SET	ReportParameters =
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
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE	ReportHyperlinkID = 7

UPDATE	ReportHyperlink
SET	ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Payments Detail" />
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
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE	ReportHyperlinkID = 8

UPDATE	ReportHyperlink
SET	ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Payments Application" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="PaymentID" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPayerName" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPaymentNumber" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPaymentAmount" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPaymentDate" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="rpmUnappliedAmount" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="rpmRefundAmount" />
            <methodParam param="{6}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>'
WHERE	ReportHyperlinkID = 9

--Update the A/R Aging Detail parameters to include the software application id parameter
UPDATE	Report
SET	ReportParameters = 
'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="RespType" text="Type:" description="Limits the report by payer." default="I">
			<value displayText="Patient" value="P" />
			<value displayText="Insurance" value="I" />
		</extendedParameter>
		<extendedParameter type="Patient" parameterName="RespID" text="Patient:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="P" permission="FindPatient" />
		<extendedParameter type="Insurance" parameterName="RespID" text="Insurance:" default="-1" ignore="-1" enabledBasedOnParameter="RespType" enabledBasedOnValue="I" permission="FindInsurancePlan" />
	</extendedParameters>
</parameters>'
WHERE	Name = 'A/R Aging Detail'

---------------------------------------------------------------------------------------

--case 7108 - Contract Browser
---------------------------------------------------------------------------------------
CREATE TABLE dbo.[Contract] (
	-- standard fields
	[ContractID] [int] IDENTITY (1, 1) NOT NULL ,
	[PracticeID] [int] NOT NULL ,
	RecordTimeStamp timestamp,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL DEFAULT (0),

	-- contract specific
	[ContractName] varchar(128) not null,
	[Description] text null,
	[ContractType] char not null default 'S',	-- S - standard for practice, P - payer specific
							-- we can have multiple contracts, but with no overlaps (effectiveStartDate, enddate)
	[EffectiveStartDate] DateTime null,
	[EffectiveEndDate] DateTime null,
	PolicyValidator varchar(64) null,	
	NoResponseTriggerPaper int not null,
	NoResponseTriggerElectronic int not null,
	Notes text null

	CONSTRAINT [PK_Contract] PRIMARY KEY  NONCLUSTERED 
	(
		[ContractID]
	)  ON [PRIMARY] 
)
GO

CREATE CLUSTERED
  INDEX [Cl_Contract_PracticeID_ContractID] ON [dbo].[Contract] ([ContractID], [PracticeID])
GO

CREATE 
  INDEX [IX_Contract_ContractType] ON [dbo].[Contract] ([ContractType])
GO

CREATE 
  INDEX [IX_Contract_EffectiveStartDate] ON [dbo].[Contract] ([EffectiveStartDate])
GO

CREATE 
  INDEX [IX_Contract_EffectiveEndDate] ON [dbo].[Contract] ([EffectiveEndDate])
GO

/*---------------------------------------------------------------------------------------
	Case 6896:   Add adjuster's name, phone, fax to Insurance Policy details  
---------------------------------------------------------------------------------------*/

ALTER TABLE dbo.InsurancePolicy ADD
	AdjusterPrefix varchar(16) NULL,
	AdjusterFirstName varchar(64) NULL,
	AdjusterMiddleName varchar(64) NULL,
	AdjusterLastName varchar(64) NULL,
	AdjusterSuffix varchar(16) NULL
GO


/*---------------------------------------------------------------------------------------
	Case 6489:   Remove Null option for "Patient Relationship" 
---------------------------------------------------------------------------------------*/

DELETE FROM relationship
WHERE relationship = ''

GO

/*---------------------------------------------------------------------------------------
	Case 6912:   create core web services for BizClaims 
---------------------------------------------------------------------------------------*/

-- first, some housekeeping around bill tables:
-- Bill is obsolete, let's get rid of it:
DROP TABLE [dbo].[Bill]
GO

-- Add a missing foreign key for the BillClaim
ALTER TABLE [dbo].[BillClaim] ADD
	CONSTRAINT [FK_BillClaim_BillBatchType] FOREIGN KEY 
	(
		[BillBatchTypeCode]
	) REFERENCES [BillBatchType] (
		[BillBatchTypeCode]
	)
GO

-- now to the business:

CREATE TABLE [dbo].[BillState] (
	[BillStateCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL PRIMARY KEY NONCLUSTERED,
	[StateName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[TIMESTAMP] [timestamp] NULL
) ON [PRIMARY]
GO

INSERT INTO BillState (BillStateCode, StateName) VALUES('R', 'Ready')
INSERT INTO BillState (BillStateCode, StateName) VALUES('P', 'In Process')
INSERT INTO BillState (BillStateCode, StateName) VALUES('E', 'In Error')
INSERT INTO BillState (BillStateCode, StateName) VALUES('S', 'Sent OK')
INSERT INTO BillState (BillStateCode, StateName) VALUES('C', 'Complete')
GO

ALTER TABLE dbo.Bill_EDI ADD
	[BillStateCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('R'),
	[BillStateModifiedDate] [datetime] NOT NULL DEFAULT (getdate())
GO

-- Add a foreign key for the BillState
ALTER TABLE [dbo].[Bill_EDI] ADD
	CONSTRAINT [FK_Bill_EDI_BillState] FOREIGN KEY 
	(
		[BillStateCode]
	) REFERENCES [BillState] (
		[BillStateCode]
	)
GO

-- mark all existing bills as Complete:
UPDATE dbo.Bill_EDI SET BillStateCode = 'C'
GO

/*---------------------------------------------------------------------------------------
	Case 7178 - Add tables for business rule engine
---------------------------------------------------------------------------------------*/

-- Update the existing Workers Comp payer scenario and add a new one
INSERT INTO PayerScenario(
		Name)
VALUES	('Workers Comp - Applicant')

INSERT INTO PayerScenario(
		Name)
VALUES	('Workers Comp - Defense')

-- Business Rule Processing Type table
CREATE TABLE BusinessRuleProcessingType(
	BusinessRuleProcessingTypeID INT NOT NULL CONSTRAINT PK_BusinessRuleProcessingType_BusinessRuleProcessingTypeID
		PRIMARY KEY NONCLUSTERED,
	Name VARCHAR(128) NOT NULL
	)
GO

-- Business Rule table
CREATE TABLE BusinessRule(
	BusinessRuleID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_BusinessRule_BusinessRuleID
		PRIMARY KEY NONCLUSTERED,
	PracticeID INT NOT NULL,
	BusinessRuleProcessingTypeID INT NOT NULL,
	Name VARCHAR(128) NOT NULL,
	BusinessRuleXML TEXT NOT NULL,
	SortOrder INT NOT NULL,
	ContinueProcessing BIT NOT NULL CONSTRAINT DF_BusinessRule_ContinueProcessing DEFAULT 0, 
	CreatedDate DATETIME NOT NULL CONSTRAINT DF_BusinessRule_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_BusinessRule_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_BusinessRule_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_BusinessRule_ModifiedUserID DEFAULT (0)
	)
GO

-- Add a foreign key
ALTER TABLE [dbo].[BusinessRule] ADD
	CONSTRAINT [FK_BusinessRule_Practice] FOREIGN KEY 
	(
		[PracticeID]
	) REFERENCES [Practice] (
		[PracticeID]
	)
GO

ALTER TABLE [dbo].[BusinessRule] ADD
	CONSTRAINT [FK_BusinessRule_BusinessRuleProcessingType] FOREIGN KEY 
	(
		[BusinessRuleProcessingTypeID]
	) REFERENCES [BusinessRuleProcessingType] (
		[BusinessRuleProcessingTypeID]
	)
GO

-- Printing Form table
CREATE TABLE PrintingForm(
	PrintingFormID INT NOT NULL CONSTRAINT PK_PrintingForm_PrintingFormID
		PRIMARY KEY NONCLUSTERED,
	Name VARCHAR(64) NOT NULL,
	Description VARCHAR(128) NULL, 
	StoredProcedureName VARCHAR(128) NOT NULL,
	RecipientSpecific BIT  NOT NULL CONSTRAINT DF_PrintingForm_RecipientSpecific DEFAULT 0
	)
GO

-- Printing Form Details table
CREATE TABLE PrintingFormDetails(
	PrintingFormDetailsID INT NOT NULL CONSTRAINT PK_PrintingFormDetails_PrintingFormDetailsID
		PRIMARY KEY NONCLUSTERED,
	PrintingFormID INT NOT NULL,
	SVGDefinitionID INT NOT NULL,
	Description VARCHAR(128), 
	SVGDefinition TEXT, 
	CONSTRAINT UX_PrintingFormDetails_PrintingFormID_SVGDefinitionID UNIQUE NONCLUSTERED 
		(
			PrintingFormID, 
			SVGDefinitionID
		)
	)
GO

-- Add foreign key constraint for printing form details
ALTER TABLE [dbo].[PrintingFormDetails] ADD
	CONSTRAINT [FK_PrintingFormDetails_PrintingForm] FOREIGN KEY 
	(
		[PrintingFormID]
	) REFERENCES [PrintingForm] (
		[PrintingFormID]
	)
GO

-- Printing Form Recipient table
CREATE TABLE PrintingFormRecipient(
	PrintingFormRecipientID INT NOT NULL CONSTRAINT PK_PrintingFormRecipient_PrintingFormRecipientID
		PRIMARY KEY NONCLUSTERED,
	Name VARCHAR(64) NOT NULL,
	Description VARCHAR(128) NULL, 
	StoredProcedureName VARCHAR(128) NOT NULL
	)
GO


INSERT	PrintingForm(
		PrintingFormID,
		Name,
		Description, 
		StoredProcedureName
	)
VALUES	(	1,
		'CMS1500', 
		'CMS 1500 Form',
		'BillDataProvider_GetHCFADocumentData'
	)

-- Details for HCFA
INSERT	PrintingFormDetails(
		PrintingFormDetailsID, 
		PrintingFormID,
		SVGDefinitionID,
		Description, 
		SVGDefinition
	)
VALUES	(	1,
		1,
		1,
		'HCFA no background', 
		'<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="CMS1500" pageId="CMS1500.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
	<defs>
		<style type="text/css"><![CDATA[
		
		g {
			font-family: Times New Roman,Courier New;
			font-size: 11pt;
			font-style: normal;
			font-weight: normal;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
	    	]]></style>
	</defs>

  <g id="carrier">
    <text x="4.04in" y="0.28in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierName" />
    <text x="4.04in" y="0.44in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierStreet" />
    <text x="4.04in" y="0.6in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierCityStateZip" />
  </g>
  <g id="line1">
    <text x="0.31in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Medicare" />
    <text x="1in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Medicaid" />
    <text x="1.71in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Champus" />
    <text x="2.59in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Champva" />
    <text x="3.28in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_GroupHealthPlan" />
    <text x="4.09in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Feca" />
    <text x="4.7in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Other" />
    <text x="5.19in" y="1.38in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_aIDNumber" />
  </g>
  <g id="line2">
    <text x="0.31in" y="1.71in" width="2.79in" height="0.1in" valueSource="CMS1500.1.2_PatientName" />
    <text x="3.27in" y="1.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_MM" />
    <text x="3.58in" y="1.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_DD" />
    <text x="3.86in" y="1.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_YY" />
    <text x="4.39in" y="1.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.3_M" />
    <text x="4.9in" y="1.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.3_F" />
    <text x="5.19in" y="1.72in" width="2.93in" height="0.1in" valueSource="CMS1500.1.4_InsuredName" />
  </g>
  <g id="line3">
    <text x="0.31in" y="2.04in" width="2.79in" height="0.1in" valueSource="CMS1500.1.5_PatientAddress" />
    <text x="3.48in" y="2.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Self" />
    <text x="3.99in" y="2.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Spouse" />
    <text x="4.39in" y="2.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Child" />
    <text x="4.9in" y="2.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Other" />
    <text x="5.19in" y="2.04in" width="2.93in" height="0.1in" valueSource="CMS1500.1.7_InsuredAddress" />
  </g>
  <g id="line4">
    <text x="0.31in" y="2.38in" width="2.42in" height="0.1in" valueSource="CMS1500.1.5_City" />
    <text x="2.84in" y="2.38in" width="0.3in" height="0.1in" valueSource="CMS1500.1.5_State" />
    <text x="5.19in" y="2.38in" width="2.28in" height="0.1in" valueSource="CMS1500.1.7_City" />
    <text x="7.54in" y="2.38in" width="0.3in" height="0.1in" valueSource="CMS1500.1.7_State" />
  </g>
  <g id="box8">
    <text x="3.69in" y="2.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Single" />
    <text x="4.28in" y="2.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Married" />
    <text x="4.89in" y="2.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Other" />
    <text x="3.69in" y="2.68in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Employed" />
    <text x="4.28in" y="2.68in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_FTStud" />
    <text x="4.89in" y="2.68in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_PTStud" />
  </g>
  <g id="line5">
    <text x="0.31in" y="2.7in" width="1.19in" height="0.1in" valueSource="CMS1500.1.5_Zip" />
    <text x="1.69in" y="2.7in" width="0.4in" height="0.1in" valueSource="CMS1500.1.5_Area" />
    <text x="2.08in" y="2.7in" width="1.1in" height="0.1in" valueSource="CMS1500.1.5_Phone" />
    <text x="5.19in" y="2.7in" width="1.23in" height="0.1in" valueSource="CMS1500.1.7_Zip" />
    <text x="6.67in" y="2.7in" width="0.4in" height="0.1in" valueSource="CMS1500.1.7_Area" />
    <text x="7.1in" y="2.7in" width="1.1in" height="0.1in" valueSource="CMS1500.1.7_Phone" />
  </g>
  <g id="line6">
    <text x="0.31in" y="3.03in" width="2.42in" height="0.1in" valueSource="CMS1500.1.9_OtherName" />
    <text x="5.19in" y="3.03in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1GroupNumber" />
  </g>
  <g id="box10">
    <text x="3.69in" y="3.36in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0aYes" />
    <text x="4.29in" y="3.36in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0aNo" />
    <text x="3.69in" y="3.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0bYes" />
    <text x="4.29in" y="3.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0bNo" />
    <text x="4.75in" y="3.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_0bState" />
    <text x="3.69in" y="4.03in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0cYes" />
    <text x="4.29in" y="4.03in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0cNo" />
  </g>
  <g id="line7">
    <text x="0.31in" y="3.38in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_aGrpNumber" />
    <text x="5.57in" y="3.38in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aMM" />
    <text x="5.88in" y="3.38in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aDD" />
    <text x="6.17in" y="3.38in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aYY" />
    <text x="6.98in" y="3.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1aM" />
    <text x="7.7in" y="3.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1aF" />
  </g>
  <g id="line8">
    <text x="0.39in" y="3.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bMM" />
    <text x="0.69in" y="3.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bDD" />
    <text x="0.98in" y="3.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bYYYY" />
    <text x="1.99in" y="3.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.9_bM" />
    <text x="2.59in" y="3.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.9_bF" />
    <text x="5.19in" y="3.72in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1bEmployer" />
  </g>
  <g id="line9">
    <text x="0.31in" y="4.03in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_cEmployer" />
    <text x="5.19in" y="4.03in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1cPlanName" />
  </g>
  <g id="line10">
    <text x="0.31in" y="4.37in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_dPlanName" />
    <text x="3.18in" y="4.37in" width="1.85in" height="0.1in" valueSource="CMS1500.1.1_0dLocal" />
    <text x="5.38in" y="4.37in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1dYes" />
    <text x="5.88in" y="4.37in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1dNo" />
  </g>
  <g id="line11">
    <text x="0.79in" y="5.03in" width="2.2in" height="0.1in" valueSource="CMS1500.1.1_2Signature" />
    <text x="3.79in" y="5.03in" width="1.3in" height="0.1in" valueSource="CMS1500.1.1_2Date" />
    <text x="5.84in" y="5.03in" width="2in" height="0.1in" valueSource="CMS1500.1.1_3Signature" />
  </g>
  <g id="line12">
    <text x="0.41in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4MM" />
    <text x="0.72in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4DD" />
    <text x="1.02in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4YY" />
    <text x="3.92in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5MM" />
    <text x="4.23in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5DD" />
    <text x="4.5in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5YY" />
    <text x="5.58in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartMM" />
    <text x="5.87in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartDD" />
    <text x="6.18in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartYY" />
    <text x="6.99in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndMM" />
    <text x="7.31in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndDD" />
    <text x="7.6in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndYY" />
  </g>
  <g id="line13">
    <text x="0.31in" y="5.7in" width="2.61in" height="0.1in" valueSource="CMS1500.1.1_7Referring" />
    <text x="3.17in" y="5.7in" width="1.92in" height="0.1in" valueSource="CMS1500.1.1_7aID" />
    <text x="5.58in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartMM" />
    <text x="5.87in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartDD" />
    <text x="6.19in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartYY" />
    <text x="6.99in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndMM" />
    <text x="7.31in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndDD" />
    <text x="7.6in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndYY" />
  </g>
  <g id="line14">
    <text x="0.31in" y="6.04in" width="4.78in" height="0.1in" valueSource="CMS1500.1.1_9Local" />
    <text x="5.37in" y="6.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.2_0Yes" />
    <text x="5.88in" y="6.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.2_0No" />
    <text x="6.55in" y="6.04in" width="0.8in" height="0.1in" valueSource="CMS1500.1.2_0Dollars" />
    <text x="7.32in" y="6.04in" width="0.3in" height="0.1in" valueSource="CMS1500.1.2_0Cents" />
  </g>
  <g id="box21">
    <text x="0.49in" y="6.43in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag1" />
    <text x="0.49in" y="6.74in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag2" />
    <text x="3.23in" y="6.43in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag3" />
    <text x="3.23in" y="6.74in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag4" />
  </g>
  <g id="line15">
    <text x="5.19in" y="6.38in" width="1.1in" height="0.1in" valueSource="CMS1500.1.2_2Code" />
    <text x="6.31in" y="6.38in" width="1.86in" height="0.1in" valueSource="CMS1500.1.2_2Number" />
  </g>
  <g id="line16">
    <text x="5.19in" y="6.69in" width="2.93in" height="0.1in" valueSource="CMS1500.1.2_3PriorAuth" />
  </g>
  <g id="box24_1">
    <text x="0.31in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM1" />
    <text x="0.62in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD1" />
    <text x="0.94in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY1" />
    <text x="1.2in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM1" />
    <text x="1.5in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD1" />
    <text x="1.82in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY1" />
    <text x="2.11in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS1" />
    <text x="2.38in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS1" />
    <text x="2.74in" y="7.34in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT1" />
    <text x="3.4in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier1" />
    <text x="3.71in" y="7.34in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra1" />
    <text x="4.44in" y="7.34in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag1" />
    <text x="5.25in" y="7.34in" width="0.6in" height="0.1in" valueSource="CMS1500.1.fDollars1" />
    <text x="5.77in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents1" />
    <text x="6.1in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.gUnits1" />
    <text x="6.41in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT1" />
    <text x="6.69in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG1" />
    <text x="6.99in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB1" />
    <text x="7.27in" y="7.34in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal1" />
  </g>
  <g id="box24_2">
    <text x="0.31in" y="7.64in" width="0.3in" height="0.11in" valueSource="CMS1500.1.aStartMM2" />
    <text x="0.62in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD2" />
    <text x="0.94in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY2" />
    <text x="1.2in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM2" />
    <text x="1.5in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD2" />
    <text x="1.82in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY2" />
    <text x="2.11in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS2" />
    <text x="2.38in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS2" />
    <text x="2.74in" y="7.64in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT2" />
    <text x="3.4in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier2" />
    <text x="3.71in" y="7.64in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra2" />
    <text x="4.44in" y="7.64in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag2" />
    <text x="5.25in" y="7.64in" width="0.6in" height="0.1in" valueSource="CMS1500.1.fDollars2" />
    <text x="5.77in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents2" />
    <text x="6.1in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.gUnits2" />
    <text x="6.41in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT2" />
    <text x="6.69in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG2" />
    <text x="6.99in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB2" />
    <text x="7.27in" y="7.64in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal2" />
  </g>
  <g id="box24_3">
    <text x="0.31in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM3" />
    <text x="0.62in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD3" />
    <text x="0.94in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY3" />
    <text x="1.2in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM3" />
    <text x="1.5in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD3" />
    <text x="1.82in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY3" />
    <text x="2.11in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS3" />
    <text x="2.38in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS3" />
    <text x="2.74in" y="7.98in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT3" />
    <text x="3.4in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier3" />
    <text x="3.71in" y="7.98in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra3" />
    <text x="4.44in" y="7.98in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag3" />
    <text x="5.25in" y="7.98in" width="0.6in" height="0.1in" valueSource="CMS1500.1.fDollars3" />
    <text x="5.77in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents3" />
    <text x="6.1in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.gUnits3" />
    <text x="6.41in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT3" />
    <text x="6.69in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG3" />
    <text x="6.99in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB3" />
    <text x="7.27in" y="7.98in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal3" />
  </g>
  <g id="box24_4">
    <text x="0.31in" y="8.31in" width="0.3in" height="0.11in" valueSource="CMS1500.1.aStartMM4" />
    <text x="0.62in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD4" />
    <text x="0.94in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY4" />
    <text x="1.2in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM4" />
    <text x="1.5in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD4" />
    <text x="1.82in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY4" />
    <text x="2.11in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS4" />
    <text x="2.38in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS4" />
    <text x="2.74in" y="8.31in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT4" />
    <text x="3.4in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier4" />
    <text x="3.71in" y="8.31in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra4" />
    <text x="4.44in" y="8.31in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag4" />
    <text x="5.25in" y="8.31in" width="0.6in" height="0.1in" valueSource="CMS1500.1.fDollars4" />
    <text x="5.77in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents4" />
    <text x="6.1in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.gUnits4" />
    <text x="6.41in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT4" />
    <text x="6.69in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG4" />
    <text x="6.99in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB4" />
    <text x="7.27in" y="8.31in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal4" />
  </g>
  <g id="box24_5">
    <text x="0.31in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM5" />
    <text x="0.62in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD5" />
    <text x="0.94in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY5" />
    <text x="1.2in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM5" />
    <text x="1.5in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD5" />
    <text x="1.82in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY5" />
    <text x="2.11in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS5" />
    <text x="2.38in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS5" />
    <text x="2.74in" y="8.65in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT5" />
    <text x="3.4in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier5" />
    <text x="3.71in" y="8.65in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra5" />
    <text x="4.44in" y="8.65in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag5" />
    <text x="5.25in" y="8.65in" width="0.6in" height="0.1in" valueSource="CMS1500.1.fDollars5" />
    <text x="5.77in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents5" />
    <text x="6.1in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.gUnits5" />
    <text x="6.41in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT5" />
    <text x="6.69in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG5" />
    <text x="6.99in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB5" />
    <text x="7.27in" y="8.65in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal5" />
  </g>
  <g id="box24_6">
    <text x="0.31in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM6" />
    <text x="0.62in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD6" />
    <text x="0.94in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY6" />
    <text x="1.2in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM6" />
    <text x="1.5in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD6" />
    <text x="1.82in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY6" />
    <text x="2.11in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS6" />
    <text x="2.38in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS6" />
    <text x="2.74in" y="8.98in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT6" />
    <text x="3.4in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier6" />
    <text x="3.71in" y="8.98in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra6" />
    <text x="4.44in" y="8.98in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag6" />
    <text x="5.25in" y="8.98in" width="0.6in" height="0.1in" valueSource="CMS1500.1.fDollars6" />
    <text x="5.77in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents6" />
    <text x="6.1in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.gUnits6" />
    <text x="6.41in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT6" />
    <text x="6.69in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG6" />
    <text x="6.99in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB6" />
    <text x="7.27in" y="8.98in" width="0.94in" height="0.1in" valueSource="CMS1500.1.kLocal6" />
  </g>
  <g id="line17">
    <text x="0.37in" y="9.37in" width="1.31in" height="0.1in" valueSource="CMS1500.1.2_5ID " />
    <text x="1.9in" y="9.37in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_5SSN" />
    <text x="2.09in" y="9.37in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_5EIN" />
    <text x="2.45in" y="9.37in" width="1.41in" height="0.1in" valueSource="CMS1500.1.2_6Account" />
    <text x="3.97in" y="9.37in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_7Yes" />
    <text x="4.47in" y="9.37in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_7No" />
    <text x="5.29in" y="9.37in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_8Dollars" />
    <text x="5.98in" y="9.37in" width="0.3in" height="0.1in" valueSource="CMS1500.1.2_8Cents" />
    <text x="6.39in" y="9.37in" width="0.62in" height="0.1in" valueSource="CMS1500.1.2_9Dollars" />
    <text x="6.97in" y="9.37in" width="0.3in" height="0.1in" valueSource="CMS1500.1.2_9Cents" />
    <text x="7.34in" y="9.37in" width="0.60in" height="0.1in" valueSource="CMS1500.1.3_0Dollars" />
    <text x="7.9in" y="9.37in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_0Cents" />
  </g>
  <g id="box31">
    <text x="0.79in" y="10.23in" width="1.0in" height="0.1in" valueSource="CMS1500.1.3_1Date" />
    <text x="0.31in" y="9.98in" width="1.7in" height="0.1in" valueSource="CMS1500.1.3_1Signature" />
  </g>
  <g id="box32">
    <text x="2.46in" y="9.77in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Name" />
    <text x="2.46in" y="9.93in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Street" />
    <text x="2.46in" y="10.09in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2CityStateZip" />
    <text x="2.46in" y="10.25in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2FacilityInfo" />
  </g>
  <g id="box33">
    <text x="5.89in" y="9.65in" width="2.30in" height="0.1in" valueSource="CMS1500.1.3_3Name" />
    <text x="5.2in" y="9.77in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Street" />
    <text x="5.2in" y="9.93in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3CityStateZip" />
    <text x="5.2in" y="10.09in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Phone" />
    <text x="5.38in" y="10.25in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3PIN" />
    <text x="6.86in" y="10.25in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3GRP" />
  </g>

</svg>'
	)

INSERT	PrintingFormRecipient(
		PrintingFormRecipientID,
		Name,
		StoredProcedureName
	)
VALUES	(	1,
		'Practice',
		'BillDataProvider_BusinessRuleRecipients_Practice'
	)

INSERT	PrintingFormRecipient(
		PrintingFormRecipientID,
		Name,
		StoredProcedureName
	)
VALUES	(	2,
		'Assigned Insurance',
		'BillDataProvider_BusinessRuleRecipients_Insurance'
	)

INSERT	PrintingFormRecipient(
		PrintingFormRecipientID,
		Name,
		StoredProcedureName
	)
VALUES	(	3,
		'Applicant Attorney',
		'BillDataProvider_BusinessRuleRecipients_ApplicantAttorney'
	)

INSERT	PrintingFormRecipient(
		PrintingFormRecipientID,
		Name,
		StoredProcedureName
	)
VALUES	(	4,
		'Defense Attorney',
		'BillDataProvider_BusinessRuleRecipients_DefenseAttorney'
	)

INSERT	PrintingFormRecipient(
		PrintingFormRecipientID,
		Name,
		StoredProcedureName
	)
VALUES	(	5,
		'Referring Physician',
		'BillDataProvider_BusinessRuleRecipients_ReferringPhysician'
	)

INSERT	PrintingFormRecipient(
		PrintingFormRecipientID,
		Name,
		StoredProcedureName
	)
VALUES	(	6,
		'Employer',
		'BillDataProvider_BusinessRuleRecipients_Employer'
	)

INSERT	PrintingFormRecipient(
		PrintingFormRecipientID,
		Name,
		StoredProcedureName
	)
VALUES	(	7,
		'Doctor',
		'AppointmentDataProvider_BusinessRuleRecipients_Doctor'
	)

/*---------------------------------------------------------------------------------------
	Case 5479:   Alerts needed to flag patients with warnings
---------------------------------------------------------------------------------------*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PatientAlert]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PatientAlert]
GO

CREATE TABLE [dbo].[PatientAlert] (
	[PatientAlertID] [int] IDENTITY (1, 1) NOT NULL ,
	[PatientID] [int] NOT NULL ,
	[AlertMessage] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ShowInPatientFlag] [bit] NOT NULL ,
	[ShowInAppointmentFlag] [bit] NOT NULL ,
	[ShowInEncounterFlag] [bit] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PatientAlert] WITH NOCHECK ADD 
	CONSTRAINT [PK_PatientAlert] PRIMARY KEY  CLUSTERED 
	(
		[PatientAlertID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PatientAlert] ADD 
	CONSTRAINT [DF_PatientAlert_ShowInPatientFlag] DEFAULT (0) FOR [ShowInPatientFlag],
	CONSTRAINT [DF_PatientAlert_ShowInAppointmentFlag] DEFAULT (0) FOR [ShowInAppointmentFlag],
	CONSTRAINT [DF_PatientAlert_ShowInEncounterFlag] DEFAULT (0) FOR [ShowInEncounterFlag],
	CONSTRAINT [DF_PatientAlert_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_PatientAlert_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_PatientAlert_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_PatientAlert_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

CREATE  INDEX [IX_PatientAlert_PatientID] ON [dbo].[PatientAlert]([PatientID]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PatientAlert] ADD 
	CONSTRAINT [FK_PatientAlert_Patient] FOREIGN KEY 
	(
		[PatientID]
	) REFERENCES [dbo].[Patient] (
		[PatientID]
	)
GO


/*---------------------------------------------------------------------------------------
	Case 7133:   Contracts implementation
---------------------------------------------------------------------------------------*/
CREATE TABLE dbo.[ContractToInsurancePlan] (
	ContractToInsurancePlanID int not null identity(1,1),
	[RecordTimeStamp] [timestamp] NULL ,
	[CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL DEFAULT (0),
	[ContractID] [int] NOT NULL ,
	[PlanID] [int] NOT NULL ,
	CONSTRAINT [FK_ContractToInsurancePlan_Contract] FOREIGN KEY 
	(
		[ContractID]
	) REFERENCES [Contract] (
		[ContractID]
	),
	CONSTRAINT [FK_ContractToInsurancePlan_InsurancePlan] FOREIGN KEY 
	(
		[PlanID]
	) REFERENCES [InsuranceCompanyPlan] (
		[InsuranceCompanyPlanID]
	)
) ON [PRIMARY]
GO


CREATE  CLUSTERED  INDEX [Cl_ContractToInsurancePlan] ON [dbo].[ContractToInsurancePlan]([ContractID]) ON [PRIMARY]
GO

/*-----------------------------------------------------------------------------
Case 6940 - Create data model, migration script and make HCFA changes to 
support multiple case dates
-----------------------------------------------------------------------------*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PatientCaseDateType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PatientCaseDateType]
GO

CREATE TABLE [dbo].[PatientCaseDateType] (
	[PatientCaseDateTypeID] [int] NOT NULL ,
	[Name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AllowDateRange] [bit] NOT NULL ,
	[AllowMultipleDates] [bit] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PatientCaseDateType] WITH NOCHECK ADD 
	CONSTRAINT [PK_PatientCaseDateType] PRIMARY KEY  CLUSTERED 
	(
		[PatientCaseDateTypeID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PatientCaseDateType] ADD 
	CONSTRAINT [DF_PatientCaseDateType_AllowDateRange] DEFAULT (0) FOR [AllowDateRange],
	CONSTRAINT [DF_PatientCaseDateType_AllowMultipleDates] DEFAULT (0) FOR [AllowMultipleDates]
GO

INSERT INTO PatientCaseDateType(PatientCaseDateTypeID, [Name], AllowDateRange, AllowMultipleDates)
VALUES(1, 'Initial Treatment Date', 0, 0)

INSERT INTO PatientCaseDateType(PatientCaseDateTypeID, [Name], AllowDateRange, AllowMultipleDates)
VALUES(2, 'Date of Injury',1, 1)

INSERT INTO PatientCaseDateType(PatientCaseDateTypeID, [Name], AllowDateRange, AllowMultipleDates)
VALUES(3, 'Date of Similar Injury', 1, 0)

INSERT INTO PatientCaseDateType(PatientCaseDateTypeID, [Name], AllowDateRange, AllowMultipleDates)
VALUES(4, 'Unable to Work in Current Occupation', 1, 0)

INSERT INTO PatientCaseDateType(PatientCaseDateTypeID, [Name], AllowDateRange, AllowMultipleDates)
VALUES(5, 'Disability Related to Condition', 1, 0)

INSERT INTO PatientCaseDateType(PatientCaseDateTypeID, [Name], AllowDateRange, AllowMultipleDates)
VALUES(6, 'Hospitalization Related to Condition', 1, 0)

GO

CREATE TABLE PatientCaseDate (
	PatientCaseDateID INT NOT NULL IDENTITY(1,1)CONSTRAINT PK_PatientCaseDate PRIMARY KEY NONCLUSTERED, 
	PracticeID INT NOT NULL, 
	PatientCaseID INT NOT NULL,
	PatientCaseDateTypeID INT NOT NULL, 
	StartDate DATETIME NULL, 
	EndDate DATETIME NULL,
	CreatedDate DATETIME NOT NULL CONSTRAINT DF_PatientCaseDate_CreatedDate DEFAULT GETDATE(),
	CreatedUserID INT NOT NULL CONSTRAINT DF_PatientCaseDate_CreatedUserID DEFAULT 0,
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_PatientCaseDate_ModifiedDate DEFAULT GETDATE(),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_PatientCaseDate_ModifiedUserID DEFAULT 0 )

GO

DECLARE @InitialTreatmentDateTypeID INT
DECLARE @DateOfInjuryDateTypeID INT
DECLARE @DateOfSimilarInjuryDateTypeID INT
DECLARE @UnableToWorkDateTypeID INT
DECLARE @DisabilityDateTypeID INT
DECLARE @HospitalizationDateTypeID INT

/* Get PatientCaseDateType IDs */
SELECT @InitialTreatmentDateTypeID = PatientCaseDateTypeID
FROM PatientCaseDateType
WHERE [Name] = 'Initial Treatment Date'

SELECT @DateOfInjuryDateTypeID = PatientCaseDateTypeID
FROM PatientCaseDateType
WHERE [Name] = 'Date of Injury'

SELECT @DateOfSimilarInjuryDateTypeID = PatientCaseDateTypeID
FROM PatientCaseDateType
WHERE [Name] = 'Date of Similar Injury'

SELECT @UnableToWorkDateTypeID = PatientCaseDateTypeID
FROM PatientCaseDateType
WHERE [Name] = 'Unable to Work in Current Occupation'

SELECT @DisabilityDateTypeID = PatientCaseDateTypeID
FROM PatientCaseDateType
WHERE [Name] = 'Disability Related to Condition'

SELECT @HospitalizationDateTypeID = PatientCaseDateTypeID
FROM PatientCaseDateType
WHERE [Name] = 'Hospitalization Related to Condition'

--Migrate PatientCase Dates into PatientCaseDate table
CREATE TABLE #PatientCaseDates ( 
	PracticeID INT, 
	PatientCaseID INT, 
	PatientCaseDateTypeID INT, 
	StartDate DATETIME, 
	EndDate DATETIME ) 

--Insert All InitialTreatmentDate containing records
INSERT INTO #PatientCaseDates ( 
	PracticeID, 
	PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate, 
	EndDate )
SELECT 	PracticeID, 
	PatientCaseID, 
	@InitialTreatmentDateTypeID, 
	InitialTreatmentDate, 
	NULL
FROM 	PatientCase
WHERE 	InitialTreatmentDate IS NOT NULL

--Insert All ConditionDate containing records
INSERT INTO #PatientCaseDates(
	PracticeID, 
	PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate, 
	EndDate )
SELECT 	PracticeID, 
	PatientCaseID, 
	@DateOfInjuryDateTypeID, 
	CurrentIllnessDate, 
	NULL
FROM 	PatientCase
WHERE 	CurrentIllnessDate IS NOT NULL

--Insert All SimilarIllnessDate containing records
INSERT INTO #PatientCaseDates(
	PracticeID, 
	PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate, 
	EndDate)
SELECT 	PracticeID, 
	PatientCaseID, 
	@DateOfSimilarInjuryDateTypeID, 
	SimilarIllnessDate, 
	NULL
FROM 	PatientCase
WHERE 	SimilarIllnessDate IS NOT NULL

--Insert All LastWorkedDate or ReturnToWorkDate containing records
INSERT INTO #PatientCaseDates( 
	PracticeID, 
	PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate, 
	EndDate)
SELECT 	PracticeID, 
	PatientCaseID, 
	@UnableToWorkDateTypeID, 
	LastWorkedDate, 
	NULL
FROM 	PatientCase
WHERE 	LastWorkedDate IS NOT NULL

UPDATE 	PCD 
SET 	EndDate = ReturnToWorkDate
FROM 	#PatientCaseDates PCD 
	INNER JOIN PatientCase PC
		ON PCD.PracticeID = PC.PracticeID 
		AND PCD.PatientCaseID = PC.PatientCaseID
		AND PCD.PatientCaseDateTypeID = @UnableToWorkDateTypeID

--Insert All DisabilityDate containing records
INSERT INTO #PatientCaseDates(
	PracticeID, 
	PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate, 
	EndDate)
SELECT 	PracticeID, 
	PatientCaseID, 
	@DisabilityDateTypeID, 
	DisabilityBeginDate, 
	NULL
FROM 	PatientCase
WHERE 	DisabilityBeginDate IS NOT NULL

UPDATE 	PCD 
SET 	EndDate = DisabilityEndDate
FROM 	#PatientCaseDates PCD 
	INNER JOIN PatientCase PC
		ON PCD.PracticeID = PC.PracticeID 
		AND PCD.PatientCaseID = PC.PatientCaseID
		AND PCD.PatientCaseDateTypeID = @DisabilityDateTypeID

--Insert All HospitalizationDate containing records
INSERT INTO #PatientCaseDates(
	PracticeID, 
	PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate, 
	EndDate)
SELECT 	PracticeID, 
	PatientCaseID, 
	@HospitalizationDateTypeID, 
	HospitalizationBeginDate, 
	NULL
FROM 	PatientCase
WHERE 	HospitalizationBeginDate IS NOT NULL

UPDATE 	PCD 
SET 	EndDate = HospitalizationEndDate
FROM 	#PatientCaseDates PCD 
	INNER JOIN PatientCase PC
	ON PCD.PracticeID = PC.PracticeID 
	AND PCD.PatientCaseID = PC.PatientCaseID
	AND PCD.PatientCaseDateTypeID = @HospitalizationDateTypeID

INSERT INTO PatientCaseDate(
	PracticeID, 
	PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate, 
	EndDate)
SELECT 	PracticeID, 
	PatientCaseID, 
	PatientCaseDateTypeID, 
	StartDate, 
	EndDate
FROM 	#PatientCaseDates
ORDER BY PracticeID, PatientCaseID, PatientCaseDateTypeID

DROP TABLE #PatientCaseDates
GO

CREATE UNIQUE CLUSTERED INDEX CI_PatientCaseDate_PracticeID_PatientCaseID_PatientCaseDateID
ON PatientCaseDate (PracticeID, PatientCaseID, PatientCaseDateID)

CREATE NONCLUSTERED INDEX IX_PatientCaseDate_PatientCaseDateTypeID
ON PatientCaseDate (PatientCaseDateTypeID)

GO

ALTER TABLE PatientCaseDate ADD CONSTRAINT FK_PatientCaseDate_PatientCaseDateType
FOREIGN KEY (PatientCaseDateTypeID) REFERENCES PatientCaseDateType (PatientCaseDateTypeID)
ON DELETE NO ACTION ON UPDATE NO ACTION

GO

ALTER TABLE PatientCase DROP COLUMN InitialTreatmentDate, CurrentIllnessDate, SimilarIllnessDate,
LastWorkedDate, ReturnToWorkDate, DisabilityBeginDate, DisabilityEndDate, HospitalizationBeginDate,
HospitalizationEndDate

ALTER TABLE PatientCaseDate ADD CONSTRAINT FK_PatientCaseDate_PatientCaseID
FOREIGN KEY (PatientCaseID) REFERENCES PatientCase (PatientCaseID)
ON DELETE NO ACTION ON UPDATE NO ACTION

GO

/*---------------------------------------------------------------------------------------
	Case 7081:   missing constraint that should be there
---------------------------------------------------------------------------------------*/

ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Patient_Practice] FOREIGN KEY 
	(
		[PracticeID]
	) REFERENCES [Practice] (
		[PracticeID]
	)
GO

/*---------------------------------------------------------------------------------------
	Case 7228:   contract locations
---------------------------------------------------------------------------------------*/
CREATE TABLE DBO.[ContractToServiceLocation] (
	ContractToServiceLocationID int not null identity(1,1),
	[RecordTimeStamp] [timestamp] NULL ,
	[CreatedDate] [datetime] NOT NULL  DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL  DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL DEFAULT (0),
	[ContractID] [int] NOT NULL ,
	[ServiceLocationID] [int] NOT NULL ,
	CONSTRAINT [FK_ContractToServiceLocation_Contract] FOREIGN KEY 
	(
		[ContractID]
	) REFERENCES [Contract] (
		[ContractID]
	),
	CONSTRAINT [FK_ContractToServiceLocation_ServiceLocation] FOREIGN KEY 
	(
		[ServiceLocationID]
	) REFERENCES [ServiceLocation] (
		[ServiceLocationID]
	)
)

CREATE  CLUSTERED  INDEX [Cl_ContractToServiceLocation] ON [dbo].[ContractToServiceLocation]([ContractID]) ON [PRIMARY]

GO


---------------------------------------------------------------------------------------
--case 7185 - Integrate svg printing engine into our system

SET IDENTITY_INSERT DMSRecordType ON

INSERT INTO DMSRecordType (RecordTypeID, TableName) VALUES (7, 'PrintingFormDetails')

SET IDENTITY_INSERT DMSRecordType OFF


GO


/*---------------------------------------------------------------------------------------
	Case 6906:   Add column to patient case to denote a parent case if any
---------------------------------------------------------------------------------------*/

-- ALTER TABLE dbo.PatientCase ADD
-- 	ParentPatientCaseID int NULL
-- 
-- GO
-- 
-- ALTER TABLE [dbo].[PatientCase] ADD CONSTRAINT [FK_PatientCase_PatientCase] FOREIGN KEY 
-- 	(
-- 		[ParentPatientCaseID]
-- 	) REFERENCES [PatientCase] (
-- 		[PatientCaseID]
-- 	)
-- GO

---------------------------------------------------------------------------------------

--Case 7182:   Modify/Create tables to accommodate new grouping method for claims and bills 

--Add a BIGINT mask key table for use in grouping

CREATE TABLE BigIntMap(TID INT NOT NULL IDENTITY(1,1), BigInteger BIGINT)
INSERT INTO BigIntMap(BigInteger)
VALUES(1)
INSERT INTO BigIntMap(BigInteger)
VALUES(2)
INSERT INTO BigIntMap(BigInteger)
VALUES(4)
INSERT INTO BigIntMap(BigInteger)
VALUES(8)
INSERT INTO BigIntMap(BigInteger)
VALUES(16)
INSERT INTO BigIntMap(BigInteger)
VALUES(32)
INSERT INTO BigIntMap(BigInteger)
VALUES(64)
INSERT INTO BigIntMap(BigInteger)
VALUES(128)
INSERT INTO BigIntMap(BigInteger)
VALUES(256)
INSERT INTO BigIntMap(BigInteger)
VALUES(512)
INSERT INTO BigIntMap(BigInteger)
VALUES(1024)
INSERT INTO BigIntMap(BigInteger)
VALUES(2048)
INSERT INTO BigIntMap(BigInteger)
VALUES(4096)
INSERT INTO BigIntMap(BigInteger)
VALUES(8192)
INSERT INTO BigIntMap(BigInteger)
VALUES(16384)
INSERT INTO BigIntMap(BigInteger)
VALUES(32768)
INSERT INTO BigIntMap(BigInteger)
VALUES(65536)
INSERT INTO BigIntMap(BigInteger)
VALUES(131072)
INSERT INTO BigIntMap(BigInteger)
VALUES(262144)
INSERT INTO BigIntMap(BigInteger)
VALUES(524288)
INSERT INTO BigIntMap(BigInteger)
VALUES(1048576)
INSERT INTO BigIntMap(BigInteger)
VALUES(2097152)
INSERT INTO BigIntMap(BigInteger)
VALUES(4194304)
INSERT INTO BigIntMap(BigInteger)
VALUES(8388608)
INSERT INTO BigIntMap(BigInteger)
VALUES(16777216)
INSERT INTO BigIntMap(BigInteger)
VALUES(33554432)
INSERT INTO BigIntMap(BigInteger)
VALUES(67108864)
INSERT INTO BigIntMap(BigInteger)
VALUES(134217728)
INSERT INTO BigIntMap(BigInteger)
VALUES(268435456)
INSERT INTO BigIntMap(BigInteger)
VALUES(536870912)

CREATE TABLE DocumentBatch(DocumentBatchID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_DocumentBatch PRIMARY KEY,
PracticeID INT NOT NULL, BusinessRuleProcessingTypeID INT NOT NULL, CreatedDate DATETIME NOT NULL, ConfirmedDate DATETIME NULL)

GO

CREATE TABLE DocumentBatch_RuleActions(DocumentBatchID INT NOT NULL, BusinessRuleID INT NOT NULL, PrintingFormRecipientID INT NOT NULL,
PrintingFormID INT NOT NULL, RuleSort INT)

ALTER TABLE DocumentBatch_RuleActions ADD CONSTRAINT PK_DocumentBatch_RuleActions
PRIMARY KEY (DocumentBatchID, BusinessRuleID, PrintingFormRecipientID, PrintingFormID)

GO

ALTER TABLE DocumentBatch_RuleActions ADD CONSTRAINT FK_DocumentBatch_RuleActions_DocumentBatchID
FOREIGN KEY (DocumentBatchID) REFERENCES DocumentBatch (DocumentBatchID)
ON DELETE NO ACTION ON UPDATE NO ACTION

GO

CREATE TABLE Document(DocumentID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_Document PRIMARY KEY NONCLUSTERED, 
PatientID INT NOT NULL, DocumentBatchID INT NOT NULL, PracticeID INT, DocumentLevelID INT, InternalDocumentTemplateID INT)

GO

CREATE UNIQUE CLUSTERED INDEX IX_Document_PracticeID_DocumentBatchID_PatientID_DocumentID
ON Document (PracticeID, DocumentBatchID, PatientID, DocumentID)

GO

ALTER TABLE Document ADD CONSTRAINT FK_DocumentBatch_DocumentBatchID
FOREIGN KEY (DocumentBatchID) REFERENCES DocumentBatch (DocumentBatchID)
ON DELETE NO ACTION ON UPDATE NO ACTION

GO

CREATE TABLE Document_BusinessRules(Document_BusinessRulesID INT NOT NULL IDENTITY(1,1),
DocumentID INT NOT NULL, DocumentBatchID INT NOT NULL, BusinessRuleID INT NOT NULL
CONSTRAINT PK_Document_BusinessRules PRIMARY KEY (DocumentID, DocumentBatchID, BusinessRuleID))

GO

ALTER TABLE Document_BusinessRules ADD CONSTRAINT FK_Document_BusinessRules_DocumentID
FOREIGN KEY (DocumentID) REFERENCES Document (DocumentID)
ON DELETE NO ACTION ON UPDATE NO ACTION

GO

CREATE TABLE Document_HCFA(Document_HCFAID INT NOT NULL IDENTITY(1,1)
CONSTRAINT PK_Document_HCFA PRIMARY KEY NONCLUSTERED, PracticeID INT NOT NULL, DocumentID INT NOT NULL, RepresentativeClaimID INT NOT NULL,
PayerInsurancePolicyID INT NULL, OtherPayerInsurancePolicyID INT NULL)

GO

CREATE UNIQUE CLUSTERED INDEX CI_Document_HCFA_PracticeID_DocumentID_HCFAID
ON Document_HCFA (PracticeID, DocumentID, Document_HCFAID)

GO

CREATE NONCLUSTERED INDEX IX_Document_HCFA_RepresentativeClaimID
ON Document_HCFA (RepresentativeClaimID)

CREATE NONCLUSTERED INDEX IX_Document_HCFA_PayerInsurancePolicyID
ON Document_HCFA (PayerInsurancePolicyID)

CREATE NONCLUSTERED INDEX IX_Document_HCFA_OtherPayerInsurancePolicyID
ON Document_HCFA (OtherPayerInsurancePolicyID)

GO

ALTER TABLE Document_HCFA ADD CONSTRAINT FK_Document_HCFA_DocumentID
FOREIGN KEY (DocumentID) REFERENCES Document (DocumentID)
ON DELETE NO ACTION ON UPDATE NO ACTION

GO


CREATE TABLE Document_HCFAClaim(PracticeID INT NOT NULL, Document_HCFAID INT NOT NULL, ClaimID INT NOT NULL
CONSTRAINT PK_Document_HCFAClaim PRIMARY KEY (PracticeID, Document_HCFAID, ClaimID))

GO

--Turn BillBatchID Into Document BatchID, generate Document IDs for HCFA's by PatientIDs in batches
--Populate DocumentBatch_RuleActions with generic row for existing batches
--(batchid, 0 (businessruleid), 0 (printingformrecipientid), 1 (printingformid))
--Populate Document_BusinessRules with documentid, 0 (businessrule) for existing HCFA data

CREATE TABLE #Batches(BillBatchID INT, PracticeID INT, CreatedDate DATETIME, ConfirmedDate DATETIME)
INSERT INTO #Batches(BillBatchID, PracticeID, CreatedDate, ConfirmedDate)
SELECT BillBatchID, PracticeID, CreatedDate, ConfirmedDate
FROM BillBatch
WHERE BillBatchTypeCode='P' AND CreatedDate IS NOT NULL AND ConfirmedDate IS NOT NULL

SET IDENTITY_INSERT DocumentBatch ON

INSERT INTO DocumentBatch(DocumentBatchID, PracticeID, BusinessRuleProcessingTypeID, CreatedDate, ConfirmedDate)
SELECT BillBatchID, PracticeID, 1, CreatedDate, ConfirmedDate
FROM #Batches
ORDER BY PracticeID, CreatedDate

SET IDENTITY_INSERT DocumentBatch OFF

GO

INSERT INTO DocumentBatch_RuleActions(DocumentBatchID, BusinessRuleID, PrintingFormRecipientID, PrintingFormID)
SELECT BillBatchID, 0, 1, 1
FROM #Batches
ORDER BY PracticeID, CreatedDate

CREATE TABLE #Bills(PatientID INT, BillBatchID INT, BillID INT, PracticeID INT, CreatedDate DATETIME, 
PayerInsurancePolicyID INT, OtherPayerInsurancePolicyID INT, DocID INT)
INSERT INTO #Bills(PatientID, BilLBatchID, BillID, PracticeID, CreatedDate, PayerInsurancePolicyID, OtherPayerInsurancePolicyID)
SELECT C.PatientID, BH.BillBatchID, BillID, B.PracticeID, B.CreatedDate, ISNULL(BH.PayerInsurancePolicyID,0), ISNULL(BH.OtherPayerInsurancePolicyID,0)
FROM Bill_HCFA BH INNER JOIN #Batches B
ON BH.BillBatchID=B.BillBatchID
INNER JOIN Claim C ON BH.RepresentativeClaimID=C.ClaimID

CREATE TABLE #Docs(DocumentID INT IDENTITY(1,1), PracticeID INT, CreatedDate DATETIME, PatientID INT, DocumentBatchID INT, PayerInsurancePolicyID INT, OtherPayerInsurancePolicyID INT)
INSERT INTO #Docs(PracticeID, CreatedDate, PatientID, DocumentBatchID, PayerInsurancePolicyID, OtherPayerInsurancePolicyID)
SELECT DISTINCT PracticeID, CreatedDate, PatientID, BillBatchID, PayerInsurancePolicyID, OtherPayerInsurancePolicyID
FROM #Bills
GROUP BY PracticeID, CreatedDate, PatientID, BillBatchID, PayerInsurancePolicyID, OtherPayerInsurancePolicyID
ORDER BY PracticeID, CreatedDate, PatientID

INSERT INTO Document(PatientID, DocumentBatchID, PracticeID)
SELECT PatientID, DocumentBatchID, PracticeID
FROM #Docs D
ORDER BY D.DocumentID

INSERT INTO Document_BusinessRules(DocumentID, DocumentBatchID, BusinessRuleID)
SELECT DocumentID, DocumentBatchID, 0
FROM Document

UPDATE B SET DocID=DocumentID
FROM #Bills B INNER JOIN #Docs D
ON B.PracticeID=D.PracticeID AND B.BillBatchID=D.DocumentBatchID AND B.PatientID=D.PatientID
AND B.PayerInsurancePolicyID=D.PayerInsurancePolicyID AND B.OtherPayerInsurancePolicyID=D.OtherPayerInsurancePolicyID

SET IDENTITY_INSERT Document_HCFA ON

INSERT INTO Document_HCFA(Document_HCFAID, PracticeID, DocumentID, RepresentativeClaimID, PayerInsurancePolicyID,
OtherPayerInsurancePolicyID)
SELECT B.BillID, PracticeID, B.DocID, BH.RepresentativeClaimID, B.PayerInsurancePolicyID,
B.OtherPayerInsurancePolicyID
FROM #Bills B INNER JOIN Bill_HCFA BH
ON B.BillID=BH.BillID
ORDER BY PracticeID, CreatedDate, B.DocID

SET IDENTITY_INSERT Document_HCFA OFF

INSERT INTO Document_HCFAClaim(PracticeID, Document_HCFAID, ClaimID)
SELECT DH.PracticeID, DH.Document_HCFAID, BC.ClaimID
FROM Document_HCFA DH INNER JOIN BillClaim BC
ON DH.Document_HCFAID=BC.BillID AND 'P'=BC.BillBatchTypeCode

DROP TABLE #Batches
DROP TABLE #Bills
DROP TABLE #Docs

ALTER TABLE Document_HCFAClaim ADD CONSTRAINT FK_Document_HCFAClaim_Document_HCFAID
FOREIGN KEY (Document_HCFAID) REFERENCES Document_HCFA (Document_HCFAID)

GO

/*---------------------------------------------------------------------------------------
Case 7222:   Fee Schedule on contracts 
---------------------------------------------------------------------------------------*/

CREATE TABLE dbo.[ContractFeeSchedule] (
	[ContractFeeScheduleID] [int] IDENTITY (1, 1) NOT NULL ,
	[RecordTimeStamp] [timestamp] NULL ,
	[CreatedDate] [datetime] NOT NULL  DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL  DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL  DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL  DEFAULT (0),
	[ContractID] [int] NOT NULL ,
	[Modifier] [varchar] (16) NULL ,
	[Gender] [char] (1)  NULL ,
	[StandardFee] [money] NULL DEFAULT (0),
	[Allowable] [money] NULL  DEFAULT (0),
	[ExpectedReimbursement] [money] NULL  DEFAULT (0),
	[RVU] [decimal](18, 0) NULL ,
	[ProcedureCodeDictionaryID] [int] NULL 
) ON [PRIMARY]

-- TODO: add indexed
GO



---------------------------------------------------------------------------------------
--case 3627 - Added new field to track how many authorizations are used

-- Add the column
ALTER TABLE dbo.InsurancePolicyAuthorization ADD
	AuthorizedNumberOfVisitsUsed int NULL CONSTRAINT DF_InsurancePolicyAuthorization_AuthorizedNumberOfVisitsUsed DEFAULT (0)
GO

-- Update the count for authorizations that are used
UPDATE	InsurancePolicyAuthorization
SET	AuthorizedNumberOfVisitsUsed = C.Count
FROM	InsurancePolicyAuthorization I
INNER JOIN
	(
	SELECT	E.InsurancePolicyAuthorizationID,
		COUNT(E.InsurancePolicyAuthorizationID) as Count
	FROM	Encounter E
	INNER JOIN
		InsurancePolicyAuthorization IPA
	ON	   IPA.InsurancePolicyAuthorizationID = E.InsurancePolicyAuthorizationID
	GROUP BY
		E.InsurancePolicyAuthorizationID
	) C
ON	I.InsurancePolicyAuthorizationID = C.InsurancePolicyAuthorizationID

-- Update the rest of the authorization count to 0
UPDATE	InsurancePolicyAuthorization
SET	AuthorizedNumberOfVisitsUsed = 0
WHERE	AuthorizedNumberOfVisitsUsed IS NULL


---------------------------------------------------------------------------------------
--case 7259 - Add new transforms for the various HCFA forms

-- Standard HCFA
UPDATE	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid"></data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
							</xsl:if>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 9, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 9, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1">
						<xsl:text>NONE</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 9, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 9, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local"> </data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No">X</data>
			<data id="CMS1500.1.2_0Dollars">      0</data>
			<data id="CMS1500.1.2_0Cents">.00</data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeEIN1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN">X</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes">X</data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityInfo1'']" />
			</data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>
			
			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>

			
			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
			</data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode2''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
			</data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode3''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
			</data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode4''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
			</data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode5''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
			</data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode6''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
			</data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	BillingFormID = 1

-- Medicaid of Ohio
UPDATE	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid">X</data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM"></data>
			<data id="CMS1500.1.3_DD"></data>
			<data id="CMS1500.1.3_YY"></data>
			<data id="CMS1500.1.3_M"></data>
			<data id="CMS1500.1.3_F"></data>
			<data id="CMS1500.1.4_InsuredName"></data>
			<data id="CMS1500.1.5_PatientAddress"></data>
			<data id="CMS1500.1.5_City"></data>
			<data id="CMS1500.1.5_State"></data>
			<data id="CMS1500.1.5_Zip"></data>
			<data id="CMS1500.1.5_Area"></data>
			<data id="CMS1500.1.5_Phone"></data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress"></data>
			<data id="CMS1500.1.7_City"></data>
			<data id="CMS1500.1.7_State"></data>
			<data id="CMS1500.1.7_Zip"></data>
			<data id="CMS1500.1.7_Area"></data>
			<data id="CMS1500.1.7_Phone"></data>
			<data id="CMS1500.1.8_Single"></data>
			<data id="CMS1500.1.8_Married"></data>
			<data id="CMS1500.1.8_Other"></data>
			<data id="CMS1500.1.8_Employed"></data>
			<data id="CMS1500.1.8_FTStud"></data>
			<data id="CMS1500.1.8_PTStud"></data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"></data>
			<data id="CMS1500.1.1_1GroupNumber"></data>
			<data id="CMS1500.1.1_1aMM"></data>
			<data id="CMS1500.1.1_1aDD"></data>
			<data id="CMS1500.1.1_1aYY"></data>
			<data id="CMS1500.1.1_1aM"></data>
			<data id="CMS1500.1.1_1aF"></data>
			<data id="CMS1500.1.1_1bEmployer"></data>
			<data id="CMS1500.1.1_1cPlanName"></data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature"></data>
			<data id="CMS1500.1.1_2Date"></data>
			<data id="CMS1500.1.1_3Signature"></data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"></data>
			<data id="CMS1500.1.1_5DD"></data>
			<data id="CMS1500.1.1_5YY"></data>
			<data id="CMS1500.1.1_6StartMM"></data>
			<data id="CMS1500.1.1_6StartDD"></data>
			<data id="CMS1500.1.1_6StartYY"></data>
			<data id="CMS1500.1.1_6EndMM"></data>
			<data id="CMS1500.1.1_6EndDD"></data>
			<data id="CMS1500.1.1_6EndYY"></data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ReferringProviderIDNumber1'']) &lt; 1">
						<xsl:text>9111115</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_8StartMM"></data>
			<data id="CMS1500.1.1_8StartDD"></data>
			<data id="CMS1500.1.1_8StartYY"></data>
			<data id="CMS1500.1.1_8EndMM"></data>
			<data id="CMS1500.1.1_8EndDD"></data>
			<data id="CMS1500.1.1_8EndYY"></data>
			<data id="CMS1500.1.1_9Local"> </data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No"> </data>
			<data id="CMS1500.1.2_0Dollars">       </data>
			<data id="CMS1500.1.2_0Cents"> </data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID"></data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN"> </data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes"> </data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Address"></data>
			<data id="CMS1500.1.3_3Name">
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderPrefix1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderPrefix1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderMiddleName1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderMiddleName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1"></data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1"></data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2"></data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2"></data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3"></data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3"></data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4"></data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4"></data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5"></data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5"></data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6"></data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6"></data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	BillingFormID = 2

-- Medicaid of Michigan
UPDATE	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid">X</data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
						<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
						</xsl:if>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
						<xsl:text xml:space="preserve"> </xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>SAME</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
						<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>SAME</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 9, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 9, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="OtherSubscriberEmployerName" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="PatientEmployerName" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ReferringProviderIDNumber1'']) &lt; 1">
						<xsl:text>9111115</xsl:text>
					</xsl:when>
					<xsl:otherwise>		 
						<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>			
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local"> </data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No"> </data>
			<data id="CMS1500.1.2_0Dollars"> </data>
			<data id="CMS1500.1.2_0Cents"> </data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeEIN1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN">X</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes"> </data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityInfo1'']" />
			</data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
			</data>
			<data id="CMS1500.1.aStartYY1">
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD1">
			</data>
			<data id="CMS1500.1.aEndYY1">
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1"> </data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
			</data>
			<data id="CMS1500.1.aStartYY2">
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD2">
			</data>
			<data id="CMS1500.1.aEndYY2">
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2"> </data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
			</data>
			<data id="CMS1500.1.aStartYY3">
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD3">
			</data>
			<data id="CMS1500.1.aEndYY3">
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3"> </data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
			</data>
			<data id="CMS1500.1.aStartYY4">
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD4">
			</data>
			<data id="CMS1500.1.aEndYY4">
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4"> </data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
			</data>
			<data id="CMS1500.1.aStartYY5">
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD5">
			</data>
			<data id="CMS1500.1.aEndYY5">
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5"> </data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
			</data>
			<data id="CMS1500.1.aStartYY6">
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD6">
			</data>
			<data id="CMS1500.1.aEndYY6">
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6"> </data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	BillingFormID = 3

GO

---------------------------------------------------------------------------------------
-- Case 7445: Add transform for HCFA Medicare of Florida
---------------------------------------------------------------------------------------

INSERT INTO BillingForm
	(BillingFormID,
	FormType,
	FormName,
	Transform)
VALUES	(4,
	'HCFA',
	'Medicaid of Florida',
	'<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid"></data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
							</xsl:if>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 9, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 9, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1">
						<xsl:text>NONE</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 9, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 9, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderOtherID'']" />
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local"> </data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No">X</data>
			<data id="CMS1500.1.2_0Dollars">      0</data>
			<data id="CMS1500.1.2_0Cents">.00</data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeEIN1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN">X</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes">X</data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityInfo1'']" />
			</data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
			</data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode2''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
			</data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode3''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
			</data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode4''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
			</data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode5''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
			</data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode6''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
			</data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>')

UPDATE	InsuranceCompany
SET	BillingFormID = 4
WHERE	InsuranceCompanyName = 'Medicaid of Florida'

GO

/*---------------------------------------------------------------------------------------
Case 6886:   Reorganize claims list to more logical buckets and names
---------------------------------------------------------------------------------------*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClaimStatusMenuItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClaimStatusMenuItem]
GO

CREATE TABLE [dbo].[ClaimStatusMenuItem] (
	[ClaimStatusMenuItemID] [int] NOT NULL ,
	[ParentMenuItemID] [int] NOT NULL ,
	[Rank] [int] NOT NULL ,
	[MenuItemText] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ClaimStatusQueryFilter] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClaimStatusMenuItem] WITH NOCHECK ADD 
	CONSTRAINT [PK_ClaimStatusMenuItem] PRIMARY KEY  CLUSTERED 
	(
		[ClaimStatusMenuItemID]
	)  ON [PRIMARY] 
GO


/* Create the first level claim status menu */

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	1, 
	0,
	1,
	'All',
	'All' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	2, 
	0,
	2,
	'Ready',
	'Ready' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	3, 
	0,
	3,
	'Errors',
	'Errors' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	4, 
	0,
	4,
	'Pending',
	'Pending' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	5, 
	0,
	5,
	'Completed',
	'Completed' )


/* Create the second level claim status menu for 'Ready' claims */

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	6, 
	2,
	1,
	'All',
	'Ready' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	7, 
	2,
	2,
	'Paper Claims to Print',
	'ReadyPaperClaimsToPrint' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	8, 
	2,
	3,
	'Electronic Claims to Submit',
	'ReadyElectronicClaimsToSubmit' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	9, 
	2,
	4,
	'Patient Statements to Send',
	'ReadyPatientStatementsToSend' )


/* Create the second level claim status menu for 'Errors' claims */

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	10, 
	3,
	1,
	'All',
	'Errors' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	11, 
	3,
	2,
	'No Response',
	'ErrorsNoResponse' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	12, 
	3,
	3,
	'Rejections',
	'ErrorsRejections' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	13, 
	3,
	4,
	'Denials',
	'ErrorsDenials' )


/* Create the second level claim status menu for 'Pending' claims */

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	14, 
	4,
	1,
	'All',
	'Pending' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	15, 
	4,
	2,
	'Insurance',
	'PendingInsurance' )

INSERT INTO ClaimStatusMenuItem ( 
	[ClaimStatusMenuItemID],
	[ParentMenuItemID],
	[Rank],
	[MenuItemText],
	[ClaimStatusQueryFilter] )
VALUES (
	16, 
	4,
	3,
	'Patient',
	'PendingPatient' )

GO

------------------------------------------------------------------------------
--Create Performance enhancement schema changes to ClaimTransaction and ClaimAccounting_Billings to allow for quick lookup of BLL Batch Type
--Migrate existing data to reflect Batch Type
ALTER TABLE ClaimAccounting_Billings ADD BatchType CHAR(1) NULL
GO

CREATE TABLE #ConfirmedBills(Billid INT, ClaimID INT, Confirmed DATETIME, BatchType CHAR(1))
INSERT INTO #ConfirmedBills(BillID, ClaimID, Confirmed, BatchType)
SELECT BH.BillID, ClaimID, CAST(CONVERT(CHAR(10),BB.CreatedDate,110) AS DATETIME), BB.BillBatchTypeCode
FROM BillBatch BB INNER JOIN Bill_HCFA BH ON BB.BillBatchID=BH.BillBatchID
INNER JOIN BillClaim BC ON BH.BillID=BC.BillID AND 'P'=BC.BillBatchTypeCode

INSERT INTO #ConfirmedBills(BillID, ClaimID, Confirmed, BatchType)
SELECT BE.BillID, ClaimID, CAST(CONVERT(CHAR(10),CreatedDate,110) AS DATETIME), BB.BillBatchTypeCode
FROM BillBatch BB INNER JOIN Bill_EDI BE ON BB.BillBatchID=BE.BillBatchID
INNER JOIN BillClaim BC ON BE.BillID=BC.BillID AND 'E'=BC.BillBatchTypeCode

INSERT INTO #ConfirmedBills(BillID, ClaimID, Confirmed, BatchType)
SELECT BS.BillID, ClaimID, CAST(CONVERT(CHAR(10),CreatedDate,110) AS DATETIME), BB.BillBatchTypeCode
FROM BillBatch BB INNER JOIN Bill_Statement BS ON BB.BillBatchID=BS.BillBatchID
INNER JOIN BillClaim BC ON BS.BillID=BC.BillID AND 'S'=BC.BillBatchTypeCode

ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL

UPDATE CT SET Code=BatchType
FROM ClaimTransaction CT INNER JOIN #ConfirmedBills CB
ON CT.ClaimID=CB.ClaimID AND CT.ReferenceID=CB.BillID AND CAST(CONVERT(CHAR(10),CT.CreatedDate,110) AS DATETIME)=CB.Confirmed
WHERE CT.ClaimTransactionTypeCode='BLL'

UPDATE CAB SET BatchType=CT.Code
FROM ClaimAccounting_Billings CAB INNER JOIN ClaimTransaction CT
ON CAB.ClaimTransactionID=CT.ClaimTransactionID
WHERE CT.ClaimTransactionTypeCode='BLL'

ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL

DROP TABLE #ConfirmedBills

DELETE BillClaim WHERE BillBatchTypeCode='P'

DROP TABLE Bill_HCFA

DELETE BillBatch WHERE BillBatchTypeCode='P'
GO

/*---------------------------------------------------------------------------------------
Case 6886:   Reorganize claims list to more logical buckets and names
---------------------------------------------------------------------------------------*/

CREATE TABLE dbo.PayerProcessingStatusType
	(
	PayerProcessingStatusTypeCode char(3) NOT NULL,
	PayerProcessingStatusTypeDesc varchar(50) NOT NULL,
	SortOrder int NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE dbo.PayerProcessingStatusType ADD CONSTRAINT
	PK_PayerProcessingStatusType PRIMARY KEY CLUSTERED 
	(
	PayerProcessingStatusTypeCode
	) ON [PRIMARY]

GO

INSERT INTO PayerProcessingStatusType (
	PayerProcessingStatusTypeCode,
	PayerProcessingStatusTypeDesc,
	SortOrder )
VALUES (
	'A00',
	'Claim Accepted',
	1 )

INSERT INTO PayerProcessingStatusType (
	PayerProcessingStatusTypeCode,
	PayerProcessingStatusTypeDesc,
	SortOrder )
VALUES (
	'F00',
	'Claim Forwarded',
	2 )

INSERT INTO PayerProcessingStatusType (
	PayerProcessingStatusTypeCode,
	PayerProcessingStatusTypeDesc,
	SortOrder )
VALUES (
	'R00',
	'Claim Rejected',
	3 )

INSERT INTO PayerProcessingStatusType (
	PayerProcessingStatusTypeCode,
	PayerProcessingStatusTypeDesc,
	SortOrder )
VALUES (
	'DP0',
	'Claim Denied',
	4 )

GO


ALTER TABLE dbo.Claim ADD
	PayerProcessingStatusTypeCode char(3) NULL
GO

ALTER TABLE dbo.Claim ADD
	CurrentPayerProcessingStatusTypeCode char(3) NULL
GO

/* Update PayerProcessingStatusTypeCode based on existing payer response messages */

/* REJECTIONS */

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%missing%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%invalid%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%incorrect%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%must be%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%unable%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%claim deleted%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%cannot%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%could not%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%not accept%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%not a valid%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%not valid%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%not eligible%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%not in%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%not on%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%not found%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%notfound%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%not in effect%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%do not %'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%incorrect%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%requires%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%required%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%resubmit%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%inactive%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%mismatched%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%rejected%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%canceled%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%cancelled%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%returned%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%unprocessable%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%additional information requested%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%error%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%loop:%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%terminated%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%data element%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%duplicate%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%explanation%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%pending for further%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%requested%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%pending:%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%inv format%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%qualifier is not%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%does not match%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%not a mem%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%rejection%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%rejected%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%requests for %'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%in err:%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%ended prior%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%duplicate to receipt date%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%statement from-through dates%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%diagnosis code%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%length of medical necessity%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'R00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%incorrect%'

/* POSSIBLE DENIALS */

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'DP0'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%denial%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'DP0'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%denied%'

/* FORWARDS / ACCEPTANCES */

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'F00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%forwarded to%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'F00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%forwarded for%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'F00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%claim was forwarded%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%claim adjudication process has been completed%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%has been paid%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%carrier acknowledges receipt%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%claim sent to payer%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%at least one valid claim%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%accepted for processing%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%accepted%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%acknowledge%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%approved%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%claim sent to payer%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%successfully received%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%claim/line has been paid%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%completed: payment made%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%completed: payment reflects%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%payment reflects usual%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%payment reflects plan%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'A00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus LIKE '%eft check issued%'

UPDATE 	Claim
SET 	PayerProcessingStatusTypeCode = 'I00'
WHERE 	PayerProcessingStatusTypeCode IS NULL
	AND PayerProcessingStatus IS NOT NULL

UPDATE 	Claim
SET 	CurrentPayerProcessingStatusTypeCode = PayerProcessingStatusTypeCode

UPDATE	C
SET 	C.CurrentPayerProcessingStatusTypeCode = NULL
FROM 	Claim C
	LEFT JOIN (	SELECT CT.ClaimID, 
			MAX(CT.ClaimTransactionID) AS 'ClaimTransactionID'
		FROM 	ClaimTransaction CT 
		WHERE	CT.ClaimTransactionTypeCode = 'EDI'
		GROUP BY CT.ClaimID) EDI ON EDI.ClaimID = C.ClaimID
	LEFT JOIN (	SELECT CT.ClaimID, 
			MAX(CT.ClaimTransactionID) AS 'ClaimTransactionID'
		FROM ClaimTransaction CT 
		WHERE	CT.ClaimTransactionTypeCode = 'RAS'
		GROUP BY CT.ClaimID) RAS ON RAS.ClaimID = C.ClaimID

WHERE 	C.CurrentPayerProcessingStatusTypeCode IS NOT NULL
	AND RAS.ClaimTransactionID > EDI.ClaimTransactionID

GO


/*---------------------------------------------------------------------------------------
Case 7233:   Create migration script for fee schedule to contract migration
---------------------------------------------------------------------------------------*/

ALTER TABLE Contract ADD FSID int
GO

INSERT INTO Contract 
(PracticeID, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, ContractName,Description, ContractType, EffectiveStartDate, EffectiveEndDate, FSID, NoResponseTriggerElectronic, NoResponseTriggerPaper)
SELECT PracticeID, GETDATE(), 0, GETDATE(), 0, ScheduleName, Description, 'S', GETDATE() - 365, GETDATE() + 365, PracticeFeeScheduleID,45,45 FROM PracticeFeeSchedule
GO

INSERT INTO ContractFeeSchedule
(CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, ProcedureCodeDictionaryID, StandardFee, ContractID, Gender, RVU)
SELECT GETDATE(),0,GETDATE(),0, F.ProcedureCodeDictionaryID, F.ChargeAmount, C.ContractID, 'B', 0
FROM PracticeFee F INNER JOIN Contract C ON C.FSID = F.PracticeFeeScheduleID
WHERE F.ExpirationDate IS NULL
GO

INSERT INTO ContractToServiceLocation
(ContractID, ServiceLocationID, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID)
SELECT C.ContractID, S.ServiceLocationID, GETDATE(),0,GETDATE(),0 
FROM ServiceLocationFeeSchedule S INNER JOIN Contract C ON S.PracticeFeeScheduleID = C.FSID
WHERE S.ExpirationDate IS NULL
GO

ALTER TABLE Contract DROP COLUMN FSID
GO

---------------------------------------------------------------------------------------
--case 3842:  Add records for the Daily report

declare @ReportCategoryId int
declare @ReportId int

SELECT 	@ReportCategoryId = ReportCategoryID
FROM 	ReportCategory 
WHERE 	Name = 'Productivity & Analysis'

INSERT INTO Report (
	ReportCategoryID,
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	ReportPath,
	ReportParameters,
	MenuName,
	PermissionValue)
VALUES (
	@ReportCategoryId,
	7,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'Daily Report',
	'This report provides an analysis of daily transaction activity including charges, adjustments, and payments.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptDailyReport',
	'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="TimeOffset" parameterName="TimeOffset" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateTypeID" text="Date Type:" description="Limits the report by date type." default="P" ignore="P">
			<value displayText="Posting Date" value="P" />
			<value displayText="Date of Service" value="S" />
		</extendedParameter>
	</extendedParameters>
</parameters>',
	'&Daily Report',
	'ReadDailyReport')

set @ReportId = @@identity

INSERT INTO ReportToSoftwareApplication
VALUES (
	@ReportID,
	'B')

INSERT INTO ReportToSoftwareApplication
VALUES (
	@ReportID,
	'M')

GO

---------------------------------------------------------------------------------------
--case:  Move Key Indicators Detail to the bottom of the menu

UPDATE	Report
SET	DisplayOrder = 20
WHERE	Name = 'Key Indicators Detail'

GO

---------------------------------------------------------------------------------------
--case 7445:  Add support for Medipath numbers for Referring Physicians

ALTER TABLE ReferringPhysician
ADD OtherID varchar(32)
GO



-----------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------
--case 7234: Remove Standallone fee schedule concept from the application

drop table ServiceLocationFeeSchedule
GO
drop table practicefee
GO
drop table practicefeeschedule
GO

---------------------------------------------------------------------------------------
--casE 5268 Load all Provider taxonomy codes
---------------------------------------------------------------------------------------


IF EXISTS(SELECT * FROM sysobjects WHERE xtype='U' AND name='TaxonomyCode')
	DROP TABLE TaxonomyCode

CREATE TABLE TaxonomyCode(TaxonomyCode CHAR(10) NOT NULL, TaxonomyTypeCode VARCHAR(4) NOT NULL, TaxonomySpecialtyCode VARCHAR(4) NOT NULL, TaxonomyCodeClassification VARCHAR(256), TaxonomyCodeDesc TEXT
			  CONSTRAINT PK_TaxonomyCode_TaxonomyCode PRIMARY KEY CLUSTERED (TaxonomyCode))

IF EXISTS(SELECT * FROM sysobjects WHERE xtype='U' AND name='TaxonomySpecialty')
	DROP TABLE TaxonomySpecialty

CREATE TABLE TaxonomySpecialty(TaxonomySpecialtyCode VARCHAR(4) NOT NULL, TaxonomyTypeCode VARCHAR(4) NOT NULL, TaxonomySpecialtyName VARCHAR(256), TaxonomySpecialtyDesc TEXT
			       CONSTRAINT PK_TaxonomySpecialty_TaxonomySpecialtyCode PRIMARY KEY CLUSTERED (TaxonomyTypeCode,TaxonomySpecialtyCode))

GO

IF EXISTS(SELECT * FROM sysobjects WHERE xtype='U' AND name='TaxonomyType')
	DROP TABLE TaxonomyType

CREATE TABLE TaxonomyType(TaxonomyTypeCode VARCHAR(4) NOT NULL, TaxonomyTypeName VARCHAR(256), TaxonomyTypeDesc TEXT
	                  CONSTRAINT PK_TaxonomyType_TaxonomyTypeCode PRIMARY KEY CLUSTERED (TaxonomyTypeCode))

GO

CREATE NONCLUSTERED INDEX IX_TaxonomyCode_TaxonomyTypeCode
ON TaxonomyCode (TaxonomyTypeCode)

CREATE NONCLUSTERED INDEX IX_TaxonomyCode_TaxonomySpecialtyCode
ON TaxonomyCode (TaxonomySpecialtyCode)

GO

ALTER TABLE TaxonomyCode ADD CONSTRAINT FK_TaxonomyCode_TaxonomyType FOREIGN KEY
(TaxonomyTypeCode) REFERENCES TaxonomyType (TaxonomyTypeCode)
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE TaxonomyCode ADD CONSTRAINT FK_TaxonomyCode_TaxonomySpecialty FOREIGN KEY
(TaxonomyTypeCode,TaxonomySpecialtyCode) REFERENCES TaxonomySpecialty (TaxonomyTypeCode,TaxonomySpecialtyCode)
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE TaxonomySpecialty ADD CONSTRAINT FK_TaxonomySpecialty_TaxonomyType FOREIGN KEY
(TaxonomyTypeCode) REFERENCES TaxonomyType (TaxonomyTypeCode)
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE Doctor DROP CONSTRAINT FK_Doctor_ProviderSpecialty

UPDATE Doctor SET ProviderSpecialtyCode='207R00000X'
WHERE ProviderSpecialtyCode='203BI0300X'

UPDATE Doctor SET ProviderSpecialtyCode='208100000X'
WHERE ProviderSpecialtyCode='203BP0400X'

UPDATE Doctor SET ProviderSpecialtyCode='2081P0010X'
WHERE ProviderSpecialtyCode='203BP0010X'

UPDATE Doctor SET ProviderSpecialtyCode='2081P2900X'
WHERE ProviderSpecialtyCode='203BP0009X'

UPDATE Doctor SET ProviderSpecialtyCode='2081P0004X'
WHERE ProviderSpecialtyCode='203BP0004X'

DELETE ProviderSpecialty
WHERE ProviderSpecialtyCode IN ('203BI0300X','203BP0400X','203BP0010X','203BP0009X','203BP0004X')

ALTER TABLE Doctor ADD TaxonomyCode CHAR(10)

GO

UPDATE Doctor SET TaxonomyCode=ProviderSpecialtyCode

ALTER TABLE Doctor ALTER COLUMN TaxonomyCode CHAR(10) NOT NULL

INSERT INTO TaxonomyType
SELECT * FROM superbill_shared..TaxonomyType

INSERT INTO TaxonomySpecialty
SELECT * FROM superbill_shared..TaxonomySpecialty

INSERT INTO TaxonomyCode
SELECT * FROM superbill_shared..TaxonomyCode

ALTER TABLE Doctor ADD CONSTRAINT FK_Doctor_TaxonomyCode
FOREIGN KEY (TaxonomyCode) REFERENCES TaxonomyCode (TaxonomyCode)
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE Doctor DROP CONSTRAINT DF__Doctor__Provider__56AA8737

ALTER TABLE Doctor DROP CONSTRAINT DF__Doctor__HipaaPro__6FF7B9F3

ALTER TABLE Doctor DROP COLUMN ProviderSpecialtyCode, HipaaProviderTaxonomyCode
GO

---------------------------------------------------------------------------------------
--casE 5269 Load CPT codes
---------------------------------------------------------------------------------------

DECLARE @CurrentDB VARCHAR(50)
DECLARE @SyncProcedure BIT
SET @CurrentDB=DB_NAME()

SELECT @SyncProcedure=SyncProcedure
FROM superbill_shared..Customer
WHERE DatabaseName=@CurrentDB

IF @SyncProcedure=1 OR @CurrentDB='CustomerModel' OR @CurrentDB='CustomerModelPrepopulated'
BEGIN

	IF @CurrentDB<>'superbill_0001_prod'
	BEGIN
		UPDATE PCD SET ProcedureName=LEFT(ShortDesc,100)
		FROM ProcedureCodeDictionary PCD INNER JOIN superbill_shared..HCPCSCodes H
		ON PCD.ProcedureCode=H.HCPCSCode
	END

	INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode)
	SELECT HCPCSCode, LEFT(ShortDesc,100), '01'
	FROM superbill_shared..HCPCSCodes H LEFT JOIN ProcedureCodeDictionary PCD
	ON H.HCPCSCode=PCD.ProcedureCode
	WHERE PCD.ProcedureCode IS NULL
	
	IF @CurrentDB<>'superbill_0001_prod'
	BEGIN
		UPDATE PCD SET ProcedureName=LEFT(CPTName,100)
		FROM ProcedureCodeDictionary PCD INNER JOIN superbill_shared..CPTDATA C
		ON PCD.ProcedureCode=C.CPTCode
	END

	INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode)
	SELECT CPTCode, LEFT(CPTName,100), '01'
	FROM superbill_shared..CPTDATA C LEFT JOIN ProcedureCodeDictionary PCD
	ON C.CPTCode=PCD.ProcedureCode
	WHERE PCD.ProcedureCode IS NULL

END

GO

--Claim Buckets optimization - Flag Last billed BLL transaction
ALTER TABLE ClaimAccounting_Billings ADD LastBilled BIT NULL

GO

CREATE TABLE #MaxBills(ClaimID INT, MaxBillID INT)
INSERT INTO #MaxBills(ClaimID, MaxBillID)
SELECT ClaimID, MAX(ClaimTransactionID) MaxBillID
FROM ClaimAccounting_Billings
GROUP BY ClaimID

UPDATE CAB SET LastBilled=1
FROM ClaimAccounting_Billings CAB INNER JOIN #MaxBills MB
ON CAB.ClaimID=MB.ClaimID AND CAB.ClaimTransactionID=MB.MaxBillID

UPDATE ClaimAccounting_Billings SET LastBilled=0
WHERE LastBilled IS NULL

DROP TABLE #MaxBills

ALTER TABLE ClaimAccounting_Billings ALTER Column LastBilled BIT NOT NULL

GO

ALTER TABLE ClaimAccounting_Billings ADD CONSTRAINT DF_ClaimAccounting_Billings_LastBilled
DEFAULT 0 FOR LastBilled

GO

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Billings_BatchType
ON ClaimAccounting_Billings (BatchType)

GO

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Billings_LastBilled
ON ClaimAccounting_Billings (LastBilled)
GO

--Finish Migrating BatchTypes for those bills that where autobilled
CREATE TABLE #NullBatchType(PracticeID INT, ClaimID INT, ClaimTransactionID INT)
INSERT INTO #NullBatchType(PracticeID, ClaimID, ClaimTransactionID)
SELECT PracticeID, ClaimID, ClaimTransactionID
FROM ClaimAccounting_Billings
WHERE BatchType IS NULL

CREATE TABLE #MaxNonNullIDs(PracticeID INT, ClaimID INT, NBID INT, CABID INT)
INSERT INTO #MaxNonNullIDs(PracticeID, ClaimID, NBID, CABID)
SELECT CAB.PracticeID, CAB.ClaimID, NB.ClaimTransactionID NBID, MAX(CAB.ClaimTransactionID) CABID
FROM ClaimAccounting_Billings CAB INNER JOIN #NullBatchType NB
ON CAB.PracticeID=NB.PracticeID AND CAB.ClaimID=NB.ClaimID
AND CAB.ClaimTransactionID<NB.ClaimTransactionID
WHERE CAB.BatchType IS NOT NULL
GROUP BY CAB.PracticeID, CAB.ClaimID, NB.ClaimTransactionID

CREATE TABLE #UpdateTable(PracticeID INT, ClaimID INT, ClaimTransactionID INT, BatchType CHAR(1))
INSERT INTO #UpdateTable(PracticeID, ClaimID, ClaimTransactionID, BatchType)
SELECT CAB.PracticeID, CAB.ClaimID, NBID ClaimTransactionID, BatchType
FROM #MaxNonNullIDs MNN INNER JOIN ClaimAccounting_Billings CAB
ON MNN.PracticeID=CAB.PracticeID AND MNN.ClaimID=CAB.ClaimID
AND MNN.CABID=CAB.ClaimtransactionID

UPDATE CAB SET BatchType=UT.BatchType
FROM ClaimAccounting_Billings CAB INNER JOIN #UpdateTable UT
ON CAB.PracticeID=UT.PracticeID AND CAB.ClaimID=UT.ClaimID
AND CAB.ClaimTransactionID=UT.ClaimTransactionID

ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL

UPDATE CT SET Code=BatchType
FROM ClaimTransaction CT INNER JOIN #UpdateTable UT
ON CT.PracticeID=UT.PracticeID AND CT.ClaimID=UT.ClaimID
AND CT.ClaimTransactionID=UT.ClaimTransactionID

ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL

DROP TABLE #NullBatchType
DROP TABLE #MaxNonNullIDs
DROP TABLE #UpdateTable

GO

--case 7637 - Add diagnoses groups to Encounter Forms 

CREATE TABLE [DiagnosisCategory] (
	[DiagnosisCategoryID] [int] IDENTITY (1, 1) NOT NULL ,
	[EncounterTemplateID] [int] NOT NULL ,
	[Name] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_DiagnosisCategory_CreatedDate] DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_DiagnosisCategory_CreatedUserID] DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_DiagnosisCategory_ModifiedDate] DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_DiagnosisCategory_ModifiedUserID] DEFAULT (0),
	[RecordTimeStamp] [timestamp] NOT NULL ,
	CONSTRAINT [PK_DiagnosisCategory] PRIMARY KEY  CLUSTERED 
	(
		[DiagnosisCategoryID]
	)  ON [PRIMARY] ,
	CONSTRAINT [FK_DiagnosisCategory_EncounterTemplate] FOREIGN KEY 
	(
		[EncounterTemplateID]
	) REFERENCES [EncounterTemplate] (
		[EncounterTemplateID]
	)
) ON [PRIMARY]
GO


CREATE TABLE [DiagnosisCategoryToDiagnosisCodeDictionary] (
	[ID_PK] [int] IDENTITY (1, 1) NOT NULL ,
	[DiagnosisCategoryID] [int] NOT NULL ,
	[DiagnosisCodeDictionaryID] [int] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_DiagnosisCategoryToDiagnosisCodeDictionary_CreatedDate] DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_CategoryToDiagnosis_CreatedUserID] DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_DiagnosisCategoryToDiagnosisCodeDictionary_ModifiedDate] DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_CategoryToDiagnosis_ModifiedUserID] DEFAULT (0),
	[RecordTimeStamp] [timestamp] NOT NULL ,
	CONSTRAINT [PK_DiagnosisCategoryToDiagnosisCodeDictionary] PRIMARY KEY  CLUSTERED 
	(
		[ID_PK]
	)  ON [PRIMARY] ,
	CONSTRAINT [FK_DiagnosisCategoryToDiagnosisCodeDictionary_DiagnosisCategory] FOREIGN KEY 
	(
		[DiagnosisCategoryID]
	) REFERENCES [DiagnosisCategory] (
		[DiagnosisCategoryID]
	),
	CONSTRAINT [FK_DiagnosisCategoryToDiagnosisCodeDictionary_DiagnosisCodeDictionary] FOREIGN KEY 
	(
		[DiagnosisCodeDictionaryID]
	) REFERENCES [DiagnosisCodeDictionary] (
		[DiagnosisCodeDictionaryID]
	)
) ON [PRIMARY]
GO

--ROLLBACK
--COMMIT
