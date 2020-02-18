/*----------------------------------

DATABASE UPDATE SCRIPT

v1.36.xxxx to v1.37.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------


/*-----------------------------------------------------------------------------
Case 8841 - Add new columns to the encounter template table
-----------------------------------------------------------------------------*/
ALTER TABLE dbo.EncounterTemplate ADD
	ProcedureSortByCode BIT NULL
	CONSTRAINT DF_EncounterTemplate_ProcedureSortByCode
	DEFAULT 1 WITH VALUES,
	DiagnosisSortByCode BIT NULL
	CONSTRAINT DF_EncounterTemplate_DiagnosisSortByCode
	DEFAULT 0 WITH VALUES

GO	

---------------------------------------------------------------------------------------------
-- Case 9800: Change contracts to support capitated flag
---------------------------------------------------------------------------------------------
ALTER TABLE [Contract] ADD Capitated BIT NOT NULL DEFAULT 0

GO

-----------------------------------------------------------------------------
--Case 9799 Schedule enhancements - data portion
-----------------------------------------------------------------------------
--Schema Changes
CREATE TABLE [dbo].[Timeblock](
	[TimeblockID] [int] IDENTITY(1,1) NOT NULL,
	[PracticeID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[TimeblockName] VARCHAR(128) NOT NULL,
	[TimeblockDescription] VARCHAR(512) NULL,
	[TimeblockColor] INT NOT NULL,
	[Notes] [text] NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Timeblock_CreatedDate]  DEFAULT (getdate()),
	[CreatedUserID] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Timeblock_ModifiedDate]  DEFAULT (getdate()),
	[ModifiedUserID] [int] NULL,
	[RecordTimeStamp] [timestamp] NOT NULL,
	[AppointmentResourceTypeID] [int] NOT NULL CONSTRAINT DF_Timeblock_AppointmentResourceTypeID DEFAULT (1),
	[ResourceID] [int] NOT NULL,
	[AllDay] [bit] NOT NULL CONSTRAINT [DF_Timeblock_AllDay]  DEFAULT (0),
	[IsRecurring] [bit] NOT NULL CONSTRAINT [DF_Timeblock_IsRecurring] DEFAULT(0)
 CONSTRAINT [PK_Timeblock] PRIMARY KEY NONCLUSTERED 
(
	[TimeblockID] ASC
)
) 

GO

CREATE UNIQUE CLUSTERED INDEX [CI_Timeblock] ON [dbo].[Timeblock] 
(
	[StartDate] ASC,
	[EndDate] ASC,
	[PracticeID] ASC,
	[TimeblockID] ASC,
	[AppointmentResourceTypeID] ASC,
	[ResourceID] ASC
)

GO

CREATE TABLE TimeblockRecurrence(
	[TimeblockID] [int] NOT NULL,
	[Type] [char](1) NOT NULL,
	[WeeklyNumWeeks] [int] NULL,
	[WeeklyOnSunday] [bit] NULL,
	[WeeklyOnMonday] [bit] NULL,
	[WeeklyOnTuesday] [bit] NULL,
	[WeeklyOnWednesday] [bit] NULL,
	[WeeklyOnThursday] [bit] NULL,
	[WeeklyOnFriday] [bit] NULL,
	[WeeklyOnSaturday] [bit] NULL,
	[DailyType] [char](1) NULL,
	[DailyNumDays] [int] NULL,
	[MonthlyType] [char](1) NULL,
	[MonthlyNumMonths] [int] NULL,
	[MonthlyDayOfMonth] [int] NULL,
	[MonthlyWeekTypeOfMonth] [char](1) NULL,
	[MonthlyTypeOfDay] [char](1) NULL,
	[YearlyType] [char](1) NULL,
	[YearlyDayTypeOfMonth] [char](1) NULL,
	[YearlyTypeOfDay] [char](1) NULL,
	[YearlyDayOfMonth] [int] NULL,
	[YearlyMonth] [int] NULL,
	[RangeType] [char](1) NULL,
	[RangeEndOccurrences] [int] NULL,
	[RangeEndDate] [datetime] NULL,
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT DF_TimeblockRecurrence_ModifiedDate  DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL,
	[StartDate] [datetime] NULL,
 CONSTRAINT [PK_TimeblockRecurrence] PRIMARY KEY CLUSTERED 
(
	TimeblockID ASC
)
) 

GO

ALTER TABLE TimeblockRecurrence ADD  CONSTRAINT FK_TimeblockRecurrence_TimeblockID FOREIGN KEY([TimeblockID])
REFERENCES Timeblock (TimeblockID)
 
GO

CREATE UNIQUE NONCLUSTERED INDEX UI_TimeblockRecurrence ON TimeblockRecurrence
(
	[StartDate] ASC,
	[RangeEndDate] ASC,
	[RangeType] ASC,
	[TimeblockID] ASC
)

GO

CREATE TABLE [dbo].[TimeblockRecurrenceException](
	[TimeblockRecurrenceExceptionID] [int] IDENTITY(1,1) NOT NULL,
	[TimeblockID] [int] NOT NULL,
	[ExceptionDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_TimeblockRecurrenceException_ModifiedDate]  DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL,
 CONSTRAINT [PK_TimeblockRecurrenceException] PRIMARY KEY CLUSTERED 
(
	[TimeblockRecurrenceExceptionID] ASC
)
)

GO

ALTER TABLE TimeblockRecurrenceException 
ADD  CONSTRAINT FK_TimeblockRecurrenceException_TimeblockID 
FOREIGN KEY(TimeblockID)
REFERENCES Timeblock (TimeblockID)

GO


CREATE NONCLUSTERED INDEX IX_TimeblockRecurrenceException_TimeblockID 
ON TimeblockRecurrenceException
(
	TimeblockID ASC
)

GO

CREATE NONCLUSTERED INDEX IX_TimeblockRecurrenceException_ExceptionDate 
ON TimeblockRecurrenceException
(
	[ExceptionDate] ASC
)

GO

-----------------------------------------------------------------------------
--Case 9801: Change encounter screen to support captitated charges 
-----------------------------------------------------------------------------
ALTER TABLE EncounterProcedure
	ADD ContractID int null,
	Description varchar(80) null
GO

ALTER TABLE EncounterProcedure
	ADD CONSTRAINT FK_EncounterProcedureToContract 
		FOREIGN KEY (ContractID) REFERENCES [Contract] (ContractID)
GO

---------------------------------------------------------------------------
-- CASE 9796 Create modified payment posting process for capitated amounts 
------------------------------------------------------------------------------

CREATE TABLE [dbo].[CapitatedAccount](
	[CapitatedAccountID] [int] IDENTITY(10,10) NOT NULL,
	[PracticeID] [int] NOT NULL,
	[Name] [nchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [nchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Amount] [money] NOT NULL CONSTRAINT [DF_CapitatedAccount_Amount]  DEFAULT ((0)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CapitatedAccount_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_CapitatedAccount_ModifiedDate]  DEFAULT (getdate()),
	[TIMESTAMP] [timestamp] NULL,
 CONSTRAINT [PK_CapitatedAccount] PRIMARY KEY CLUSTERED 
(
	[CapitatedAccountID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CapitatedAccountToPayment](
	[PaymentID] [int] NOT NULL,
	[CapitatedAccountID] [int] NOT NULL,
	[Amount] [money] NOT NULL CONSTRAINT [DF_CapitatedAccountToPayment_Amount]  DEFAULT ((0)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CapitatedAccountToPayment_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_CapitatedAccountToPayment_ModifiedDate]  DEFAULT (getdate()),
	[TIMESTAMP] [timestamp] NULL,
	[PostingDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CapitatedAccountToPayment]  WITH CHECK ADD  CONSTRAINT [FK_CapitatedAccountToPayment_CapitatedAccount] FOREIGN KEY([CapitatedAccountID])
REFERENCES [dbo].[CapitatedAccount] ([CapitatedAccountID])
GO
ALTER TABLE [dbo].[CapitatedAccountToPayment]  WITH CHECK ADD  CONSTRAINT [FK_CapitatedAccountToPayment_Payment] FOREIGN KEY([PaymentID])
REFERENCES [dbo].[Payment] ([PaymentID])
GO


-----------------------------------------------------------------------------
-- CASE 9440
------------------------------------------------------------------------------
ALTER TABLE Payment ADD BatchID VARCHAR(50)
GO

UPDATE REPORT
SET REPORTPARAMETERS ='<?xml version="1.0" encoding="utf-8" ?>
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
	</extendedParameters>	
</parameters>'
WHERE REPORTID=5
GO

UPDATE REPORT
SET REPORTPARAMETERS ='<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	<basicParameter type="ClientTime" parameterName="ClientTime" /></basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Type:" default="0" ignore="0"/>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE REPORTID=6
GO


UPDATE REPORT
SET REPORTPARAMETERS ='<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"
			default="Today" forceDefault="true" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" overrideMaxDate="true" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type."
			default="P">
			<value displayText="Posting Date" value="P" />
			<value displayText="Date of Service" value="D" />
		</extendedParameter>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
		<extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
	</extendedParameters>
</parameters>'
WHERE REPORTID=29
GO

/*-----------------------------------------------------------------------------
Case 9410 - Use "ticket/appointment number" to auto-populate encounter details
-----------------------------------------------------------------------------*/

ALTER TABLE dbo.Encounter ADD
	AppointmentStartDate datetime NULL
GO

/*-----------------------------------------------------------------------------
Case 9440 - Payment BatchID support for browsers
-----------------------------------------------------------------------------*/

CREATE NONCLUSTERED INDEX IX_Payment_BatchID
ON Payment (BatchID)

GO

UPDATE ReportHyperLink SET ReportParameters='<?xml version="1.0" encoding="utf-8" ?>
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
					<method name="Add">
						<methodParam param="rpmBatchID" />
						<methodParam param="{7}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>'
WHERE ReportHyperLinkID=9
GO

/*-----------------------------------------------------------------------------
Case 9835 - Add new columns to the Practice table
-----------------------------------------------------------------------------*/
ALTER TABLE dbo.Practice ADD
	CalendarUseTimeblockColor BIT NOT NULL
	CONSTRAINT DF_Practice_CalendarUseTimeblockColor
	DEFAULT 1,
	CalendarShowTimeblockLegend BIT NOT NULL
	CONSTRAINT DF_Practice_CalendarShowTimeblockLegend
	DEFAULT 1
GO

---------------------------------------------------------------------------------------
-- CASE 9409
----------------------------------------------------------------------------------------
--Specific Provider
INSERT INTO [ReportHyperlink]
           ([ReportHyperlinkID]
           ,[Description]
           ,[ReportParameters])
     VALUES
           (15
           ,'Provider Productivity'
           ,'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="Provider Productivity" />
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
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
           ([ReportHyperlinkID]
           ,[Description]
           ,[ReportParameters])
     VALUES
           (16
           ,'Payments Detail'
           ,'<?xml version="1.0" encoding="utf-8" ?>
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
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
           ([ReportHyperlinkID]
           ,[Description]
           ,[ReportParameters])
     VALUES
           (17
           ,'Refunds Summary'
           ,'<?xml version="1.0" encoding="utf-8" ?>
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
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
           ([ReportHyperlinkID]
           ,[Description]
           ,[ReportParameters])
     VALUES
           (18
           ,'A/R Aging Summary'
           ,'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="A/R Aging Summary" />
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
						<methodParam param="Date" />
						<methodParam param="{1}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

--All Providers
INSERT INTO [ReportHyperlink]
           ([ReportHyperlinkID]
           ,[Description]
           ,[ReportParameters])
     VALUES
           (19
           ,'Provider Productivity (All Providers)'
           ,'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="Provider Productivity" />
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
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
           ([ReportHyperlinkID]
           ,[Description]
           ,[ReportParameters])
     VALUES
           (20
           ,'Payments Detail (All Providers)'
           ,'<?xml version="1.0" encoding="utf-8" ?>
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
						<methodParam param="BeginDate" />
						<methodParam param="{0}" />
					</method>
					<method name="Add">
						<methodParam param="EndDate" />
						<methodParam param="{1}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
           ([ReportHyperlinkID]
           ,[Description]
           ,[ReportParameters])
     VALUES
           (21
           ,'Refunds Summary (All Providers)'
           ,'<?xml version="1.0" encoding="utf-8" ?>
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
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
           ([ReportHyperlinkID]
           ,[Description]
           ,[ReportParameters])
     VALUES
           (22
           ,'A/R Aging Summary (All Providers)'
           ,'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="A/R Aging Summary" />
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
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

--Specific Provider for rptKeyIndicatorsSummaryYTDReview.rdl
INSERT INTO [ReportHyperlink]
([ReportHyperlinkID]
,[Description]
,[ReportParameters])
VALUES
(23
,'Provider Productivity (KeyIndicatorsSummaryYTDReview)'
,'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="Provider Productivity" />
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
						<methodParam param="EndDate" />
						<methodParam param="{1}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
([ReportHyperlinkID]
,[Description]
,[ReportParameters])
VALUES
(24
,'Payments Detail (KeyIndicatorsSummaryYTDReview)'
,'<?xml version="1.0" encoding="utf-8" ?>
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
						<methodParam param="ProviderID" />
						<methodParam param="{0}" />
					</method>
					<method name="Add">
						<methodParam param="EndDate" />
						<methodParam param="{1}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
([ReportHyperlinkID]
,[Description]
,[ReportParameters])
VALUES
(25
,'Refunds Summary (KeyIndicatorsSummaryYTDReview)'
,'<?xml version="1.0" encoding="utf-8" ?>
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
						<methodParam param="EndDate" />
						<methodParam param="{0}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
([ReportHyperlinkID]
,[Description]
,[ReportParameters])
VALUES
(26
,'A/R Aging Summary (KeyIndicatorsSummaryYTDReview)'
,'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="A/R Aging Summary" />
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
						<methodParam param="Date" />
						<methodParam param="{1}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

--All Providers
INSERT INTO [ReportHyperlink]
([ReportHyperlinkID]
,[Description]
,[ReportParameters])
VALUES
(27
,'Provider Productivity (KeyIndicatorsSummaryYTDReview All Providers)'
,'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="Provider Productivity" />
			<methodParam param="true" type="System.Boolean"/>
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
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
([ReportHyperlinkID]
,[Description]
,[ReportParameters])
VALUES
(28
,'Payments Detail (KeyIndicatorsSummaryYTDReview All Providers)'
,'<?xml version="1.0" encoding="utf-8" ?>
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
						<methodParam param="Date" />
						<methodParam param="{0}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
([ReportHyperlinkID]
,[Description]
,[ReportParameters])
VALUES
(29
,'Refunds Summary (KeyIndicatorsSummaryYTDReview All Providers)'
,'<?xml version="1.0" encoding="utf-8" ?>
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
						<methodParam param="EndDate" />
						<methodParam param="{0}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

INSERT INTO [ReportHyperlink]
([ReportHyperlinkID]
,[Description]
,[ReportParameters])
VALUES
(30
,'A/R Aging Summary (KeyIndicatorsSummaryYTDReview All Providers)'
,'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="A/R Aging Summary" />
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
				</object>
			</methodParam>
		</method>
	</object>
</task>')
GO

-----------------------------------------------------------------------------------
--Case 10182: Change Patient Case "Condition" tab to support billing for pregnancies
-----------------------------------------------------------------------------------

INSERT INTO PatientCaseDateType (PatientCaseDateTypeID, Name, AllowDateRange, AllowMultipleDates)
VALUES (7, 'Last Menstrual Period', 0, 0)
GO

/*-----------------------------------------------------------------------------
Case 10182 - Add PregnancyRelatedFlag column to the PatientCase table
-----------------------------------------------------------------------------*/

ALTER TABLE dbo.PatientCase ADD
	PregnancyRelatedFlag BIT NOT NULL
	CONSTRAINT DF_PatientCase_PregnancyRelatedFlag
	DEFAULT 0
GO


---------------------------------------------------------------------------------------------------
-- CASE 10134 Add ProviderID to PaymentsDetail and A/R Summary Reporst
---------------------------------------------------------------------------------------------------
UPDATE Report
SET ReportParameters='<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	<basicParameter type="ClientTime" parameterName="ClientTime" /></basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="PaymentType" parameterName="PaymentMethodCode" text="Payment Type:" default="0" ignore="0"/>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE ReportID = 6
GO

UPDATE Report
SET ReportParameters='<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
	<basicParameter type="ClientTime" parameterName="ClientTime" /></basicParameters>
	<extendedParameters>
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>'
WHERE ReportID = 8
GO
----------------------------------------------------------------------------------------------
-- CASE 9440
-----------------------------------------------------------------------------------------------
UPDATE Report SET ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
	<basicParameter type="ClientTime" parameterName="ClientTime" /></basicParameters>
	<extendedParameters>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>	
</parameters>'
WHERE ReportID=11
GO

/*-----------------------------------------------------------------------------
Case 10209 - Create support for unpayable encounters and modifiable payer scenarios
-----------------------------------------------------------------------------*/

CREATE TABLE PayerScenarioType
(
  PayerScenarioTypeID int identity(1,1) not null primary key,
  Name varchar(100)
)
GO

INSERT INTO PayerScenarioType (Name) VALUES ('Normal')
INSERT INTO PayerScenarioType (Name) VALUES ('Unpayable')
GO

ALTER TABLE PayerScenario ADD PayerScenarioTypeID int NOT NULL CONSTRAINT DF_PayerScenario_PayerScenarioTypeID DEFAULT 1 
GO

ALTER TABLE PayerScenario
ADD CONSTRAINT FK_PayerScenario_PayerScenarioTypeID
FOREIGN KEY(PayerScenarioTypeID)
REFERENCES PayerScenarioType (PayerScenarioTypeID)
GO


INSERT INTO EncounterStatus (EncounterStatusID, EncounterStatusDescription,CreatedUserID, ModifiedUserID, CreatedDate,ModifiedDate) VALUES (7, 'Unpayable', 0,0,GETDATE(),GETDATE())
GO

/*-----------------------------------------------------------------------------
Case 9576 - For customer 112 only, Removed Procedures and Diagnosis grids
-----------------------------------------------------------------------------*/

IF (select db_name()) in( 'superbill_0112_prod', 'superbill_0001_dev')
BEGIN
INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (11, 'One Page No Grid', 'Encounter form that prints on a single page without Procedures and Diagnosis grids', 9)

INSERT INTO PrintingFormDetails 
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform, SVGDefinition)
VALUES
	(26, 9, 12, 'One Page No Grid', 1,
	'<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="default-format" NaN="0.00" />
  
  <xsl:template match="/formData/page">
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
      <defs>
        <style type="text/css">
          g
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 9pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          g#Title
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 16pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          text
          {
          baseline-shift: -100%;
          }
        </style>
      </defs>
      
      <!--
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="C:\SVN\Kareo\ThirdParty\SharpVectorGraphics\SVGTester\EncounterForm.OnePage.NoGrid.Cust112.jpg"></image>
      -->
      <image x="0" y="0" width="8.5in" height="11in" xlink:href="kareodms://04f7ee5e-e725-45b3-8593-f47d151d16fb?type=global"></image>

      <g id="Title">
        <text x="0.49in" y=".42in" width="5in" height="0.1in" valueSource="EncounterForm.1.TemplateName1" />
      </g>
      <g id="PracticeInformation">
        <text x="0.49in" y=".7in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeName1" />
        <text x="0.49in" y=".85in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeAddress1" />
        <text x="0.49in" y="1in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticePhoneFax1" />
        <text x="0.49in" y="1.15in" width="5in" height="0.1in" valueSource="EncounterForm.1.PracticeTaxID1" />
      </g>
      <g id="PatientInformation">
        <text x="0.54in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.PatientName1" />
        <text x="0.54in" y="1.75in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine11" />
        <xsl:choose>
          <xsl:when test="string-length(data[@id=''EncounterForm.1.AddressLine21'']) > 0">
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.AddressLine21" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:when>
          <xsl:otherwise>
            <text x="0.54in" y="1.9in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.CityStateZip1" />
            <text x="0.54in" y="2.05in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.HomePhone1" />
          </xsl:otherwise>
        </xsl:choose>
        <text x="0.54in" y="2.52in" width="1.19in" height="0.1in" valueSource="EncounterForm.1.PatientID1" />
        <text x="2.28in" y="2.445in" width="1.0in" height="0.1in" font-family="Arial" font-size="5pt">, AGE</text>
        <text x="1.75in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.DOBAge1" />
      </g>
      <g id="InsuranceCoverage">
        <text x="3.052in" y="1.6in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.ResponsiblePerson1" />
        <text x="3.798in" y="1.819in" width="0.1in" height="0.1in" font-family="Arial" font-size="5pt">:</text>
        <text x="3.862in" y="1.797in" width="1.7in" height="0.1in" valueSource="EncounterForm.1.PrimaryIns1" font-size="8pt" />
        <text x="3.057in" y="1.985in" width="1.0in" height="0.1in" font-family="Arial" font-size="5pt">POL#:</text>
        <text x="3.312in" y="1.955in" width="0.99in" height="0.1in" valueSource="EncounterForm.1.PolicyNumber1" font-size="8pt" />
        <text x="4.302in" y="1.985in" width="1.0in" height="0.1in" font-family="Arial" font-size="5pt">GRP#:</text>
        <text x="4.562in" y="1.955in" width="0.99in" height="0.1in" valueSource="EncounterForm.1.GroupNumber1" font-size="8pt" />
        <text x="3.052in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.SecondaryIns1" />
        <text x="3.052in" y="2.52in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.Copay1" />
        <text x="4.34in" y="2.52in" width="1.18in" height="0.1in" valueSource="EncounterForm.1.Deductible1" />
      </g>
      <g id="EncounterInformation">
        <text x="5.565in" y="1.6in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.AppDateTime1" />
        <text x="6.937in" y="1.53in" width="1.0in" height="0.1in" font-size="5pt">TICKET</text>
        <text x="6.937in" y="1.6in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.TicketNumber1" />
        <text x="5.565in" y="1.9in" width="1.36in" height="0.1in" valueSource="EncounterForm.1.POS1" />
        <text x="6.937in" y="1.9in" width="1.13in" height="0.1in" valueSource="EncounterForm.1.Reason1" />
        <text x="5.565in" y="2.2in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.Provider1" />
        <text x="5.565in" y="2.52in" width="2.5in" height="0.1in" valueSource="EncounterForm.1.RefProvider1" />
      </g>
      <g id="PreviousAccountBalance">
        <text x="0.537in" y="3.02in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastInsPay1" />
        <text x="0.537in" y="3.32in" width="1.22in" height="0.1in" valueSource="EncounterForm.1.LastPatientPay1" />
        <text x="1.77in" y="3.02in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.InsBalance1" />
        <text x="1.77in" y="3.32in" width="1.25in" height="0.1in" valueSource="EncounterForm.1.PatientBalance1" />
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>')
END
GO

/*-----------------------------------------------------------------------------
Case 10169 - Make changes for receive payment
-----------------------------------------------------------------------------*/
-- Add new column to PaymentClaimTransaction table
ALTER TABLE dbo.PaymentClaimTransaction ADD
	IsOtherAdjustment BIT NULL
	CONSTRAINT DF_PaymentClaimTransaction_IsOtherAdjustment
	DEFAULT 0 WITH VALUES

GO	

-- Add new ClaimTransactionType
INSERT INTO ClaimTransactionType 
		(ClaimTransactionTypeCode, TypeName)
VALUES	('ALW', 'Payment allowed amount')

GO

-- Add table for Denial Reasons
CREATE TABLE [dbo].[PaymentDenialReason](
	[PaymentDenialReasonCode] varchar(5) NOT NULL,
	[Description] varchar(250) NOT NULL,
	[TimeStamp] timestamp NOT NULL,
 CONSTRAINT [PK_PaymentDenialReason] PRIMARY KEY CLUSTERED 
(
	[PaymentDenialReasonCode] ASC
)
)

GO

-- Add none record for denial reason
INSERT INTO PaymentDenialReason (PaymentDenialReasonCode, Description)
VALUES('0', 'None')

-- Populate the denial reasons from shared
INSERT INTO PaymentDenialReason (PaymentDenialReasonCode, Description)
SELECT	Code,
		Description
FROM	superbill_shared.dbo.Temp_DenialReason
WHERE	IsDenial = 'Yes' and Active = 'Yes'


-- Add table for Change Status Reasons
CREATE TABLE [dbo].[ChangeStatusReason](
	[ChangeStatusReasonCode] varchar(5) NOT NULL,
	[Description] varchar(250) NOT NULL,
	[TimeStamp] timestamp NOT NULL,
 CONSTRAINT [PK_ChangeStatusReason] PRIMARY KEY CLUSTERED 
(
	[ChangeStatusReasonCode] ASC
)
)

GO

INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('0', 'None')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('1', 'Charge applied to deductible amount')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('2', 'Coinsurance due from patient')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('3', 'Co-payment due from patient')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('4', 'Insurance coverage terminated')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('5', 'Patient not covered by insurance')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('6', 'Patient has other primary insurance')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('7', 'Patient has secondary insurance')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('8', 'Rebill after correcting patient information')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('9', 'Rebill after correcting insurance information')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('10', 'Rebill after correcting rendering provider information')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('11', 'Rebill after correcting referring provider information')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('12', 'Rebill after correcting encounter information')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('13', 'Rebill after correcting condition information')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('14', 'Rebill after correcting procedure')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('15', 'Rebill after correcting modifier')
INSERT INTO ChangeStatusReason (ChangeStatusReasonCode, Description)
VALUES ('16', 'Rebill after correcting diagnoses')

GO

---------------------------------------------------------------------------------------------
-- Case 10210: Implement a two page four column grid. 
---------------------------------------------------------------------------------------------

INSERT INTO EncounterFormType (EncounterFormTypeID, [Name], Description, SortOrder)
VALUES (12, 'Two Page Four Column Grid', 'Encounter form that prints on two pages', 12)

INSERT INTO PrintingFormDetails 
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform, SVGDefinition)
VALUES
	(27, 9, 13, 'Encounter Form Four Column (Two Page) - Page 1', 1, '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="default-format" NaN="0.00" />

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
  <xsl:template name="CreateProcedureColumnLayout">

    <xsl:param name="maximumRowsInColumn"/>
    <xsl:param name="maximumColumns"/>
    <xsl:param name="totalElements"/>
    <xsl:param name="currentElement"/>
    <xsl:param name="currentRow"/>
    <xsl:param name="currentColumn"/>
    <xsl:param name="currentCategory" select="0"/>

    <xsl:variable name="xLeftOffset" select="0.495"/>
    <xsl:variable name="xOffset" select="1.875"/>
    <xsl:variable name="yTopOffset" select="2.13"/>
    <xsl:variable name="yOffset" select=".140625"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".350"/>
    <xsl:variable name="rectangleYOffset" select="0.001"/>

    <xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.ProcedureCategory'', $currentElement)]"/>

      <xsl:choose>
        <xsl:when test="($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
                        ($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)">
          <!-- There isn''t enough room to print on this column -->

          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateProcedureColumnLayout">
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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.ProcedureCategoryName{$CurrentCategoryIndex}" style="fill:black" font-family="Arial" font-weight="bold" font-size="8pt" />

          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".30in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" font-family="Arial Narrow" font-size="7pt" />

          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateProcedureColumnLayout">
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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".30in" height="0.1in" valueSource="EncounterForm.1.ProcedureCode{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.ProcedureName{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>

          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateProcedureColumnLayout">
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

  <xsl:template name="DrawHorLines">
    <xsl:param name="yOffset"/>
    <xsl:param name="maximumRows"/>
    <xsl:param name="currentRow" select="1"/>

    <xsl:if test="$maximumRows >= $currentRow">

      <line x1="0.5in" y1="{$yOffset + .140625 * ($currentRow)}in"
          x2="8in" y2="{$yOffset + .140625 * ($currentRow)}in"
          style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>

      <xsl:call-template name="DrawHorLines">
        <xsl:with-param name="yOffset" select="$yOffset"/>
        <xsl:with-param name="maximumRows" select="$maximumRows"/>
        <xsl:with-param name="currentRow" select="$currentRow+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="DrawVertLines">
    <xsl:param name="xOffset"/>
    <xsl:param name="yOffset"/>
    <xsl:param name="height"/>
    <xsl:param name="maximumCols"/>
    <xsl:param name="currentCol" select="0"/>

    <xsl:if test="$maximumCols > $currentCol">

      <line x1="{$xOffset+($currentCol)*1.875}in" y1="{$yOffset}in"
          x2="{$xOffset+($currentCol)*1.875}in" y2="{$yOffset +$height}in"
          style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="$xOffset"/>
        <xsl:with-param name="yOffset" select="$yOffset"/>
        <xsl:with-param name="height" select="$height"/>
        <xsl:with-param name="maximumCols" select="$maximumCols"/>
        <xsl:with-param name="currentCol" select="$currentCol+1"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template match="/formData/page">
    <xsl:variable name="ProcedureCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.ProcedureName'')])"/>

    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
      <defs>
        <style type="text/css">
          g
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 9pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          g#Title
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 16pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          text
          {
          baseline-shift: -100%;
          }

          text.ralignedtext
          {
          text-anchor: end;
          }

          text.centeredtext
          {
          text-anchor: middle;
          }
        </style>
      </defs>

      <g id="PracticeInformation">
        <xsl:variable name="practiceName" select="concat(data[@id=''EncounterForm.1.Provider1''], '' - '', data[@id=''EncounterForm.1.PracticeName1''])"/>
        <xsl:variable name="fullAddress" select="concat(data[@id=''EncounterForm.1.PracticeAddress1''], '' '', data[@id=''EncounterForm.1.PracticeAddress2''], '' - '', data[@id=''EncounterForm.1.PracticeCityStateZip1''], '' '', data[@id=''EncounterForm.1.PracticePhoneFax1''])"/>

        <text x="4.25in" y="0.5in" font-family="Arial" font-weight="bold" font-size="12pt" class="centeredtext">
          <xsl:value-of select="$practiceName"/>
        </text>

        <text x="4.25in" y="0.7in" font-family="Arial Narrow" font-size="9pt" class="centeredtext">
          <xsl:value-of select="$fullAddress"/>
        </text>
      </g>

      <g id="PatientBox" transform="translate(100, 187)">
        <rect x="0.00in" y="0.000in" width="3.71875in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="3.71875in" height="1.01in" fill="none" stroke="black" stroke-width="0.5pt"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">PATIENT</text>

        <!-- Left captions -->
        <text x="0.57in" y="0.185in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">NAME:</text>
        <text x="0.57in" y="0.320in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">ADDRESS:</text>
        <text x="0.57in" y="0.455in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">HOME:</text>
        <text x="0.57in" y="0.590in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PRIMARY:</text>
        <text x="0.57in" y="0.725in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">COPAY/DED.:</text>
        <text x="0.57in" y="0.860in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">SECONDARY:</text>

        <!-- Right captions-->
        <text x="2.60in" y="0.455in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">WORK:</text>
        <text x="2.60in" y="0.590in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DOB/AGE:</text>
        <text x="2.60in" y="0.725in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">GENDER:</text>
        <text x="2.60in" y="0.860in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">GUARANTOR:</text>

        <!-- Fields -->
        <xsl:variable name="patNameID" select="concat(data[@id=''EncounterForm.1.PatientName1''], '' ('', data[@id=''EncounterForm.1.PatientID1''], '')'' )"/>
        <xsl:variable name="patFullAddress" select="concat(data[@id=''EncounterForm.1.AddressLine11''], '' '', data[@id=''EncounterForm.1.AddressLine21''], '', '', data[@id=''EncounterForm.1.CityStateZip1''])"/>
        <xsl:variable name="patCopayDed" select="concat(data[@id=''EncounterForm.1.Copay1''], '' / '', data[@id=''EncounterForm.1.Deductible1''])"/>
        <xsl:variable name="patDOBAge" select="data[@id=''EncounterForm.1.DOBAge1'']"/>

        <!-- Fields Left column -->
        <text x="0.60in" y="0.12in" width="3.0in" height="0.2in" font-family="Arial Narrow" font-weight="bold" font-size="11pt">
          <xsl:value-of select="$patNameID"/>
        </text>

        <text x="0.60in" y="0.300in" width="3.0in" height="0.15in" font-family="Arial Narrow" font-size="8pt">
          <xsl:value-of select="$patFullAddress"/>
        </text>

        <text x="0.60in" y="0.435in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.HomePhone1"/>

        <text x="0.60in" y="0.570in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PrimaryIns1"/>

        <text x="0.60in" y="0.705in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt">
          <xsl:value-of select="$patCopayDed"/>
        </text>

        <text x="0.60in" y="0.840in" width="1.36in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.SecondaryIns1"/>

        <!-- Fields Right column -->
        <text x="2.63in" y="0.435in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.WorkPhone1"/>

        <text x="2.63in" y="0.570in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt">
          <xsl:value-of select="$patDOBAge"/>
        </text>

        <text x="2.63in" y="0.705in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.Gender1"/>

        <text x="2.63in" y="0.840in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.ResponsiblePerson1"/>
      </g>

      <g id="VisitBox" transform="translate(856, 187)">
        <rect x="0.00in" y="0.000in" width="3.71875in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="3.71875in" height="1.01in" fill="none" stroke="black" stroke-width="0.5pt"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">VISIT</text>

        <!-- Left captions -->
        <text x="0.57in" y="0.185in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PROVIDER:</text>
        <text x="0.57in" y="0.320in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DATE/TIME:</text>
        <text x="0.57in" y="0.455in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">LOCATION:</text>
        <text x="0.57in" y="0.590in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">REFER.:</text>
        <text x="0.57in" y="0.725in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">CASE:</text>
        <text x="0.57in" y="0.860in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">SCENARIO:</text>

        <!-- Right captions-->
        <text x="2.60in" y="0.320in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">TICKET #:</text>
        <text x="2.60in" y="0.455in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">REASON:</text>
        <text x="2.60in" y="0.590in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PCP:</text>
        <text x="2.60in" y="0.725in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">INJURY DATE:</text>
        <text x="2.60in" y="0.860in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">INJURY PLACE:</text>

        <!-- Fields Left column -->
        <text x="0.60in" y="0.15in" width="3.0in" height="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="9pt" valueSource="EncounterForm.1.Provider1"/>
        <text x="0.60in" y="0.300in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.AppDateTime1"/>
        <text x="0.60in" y="0.435in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.POS1"/>
        <text x="0.60in" y="0.570in" width="1.5in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PatCaseRefPhys1"/>
        <text x="0.60in" y="0.705in" width="1.31in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PatientCase1"/>
        <text x="0.60in" y="0.840in" width="1.31in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PatientCaseScenario1"/>

        <!-- Fields Right column -->
        <text x="2.63in" y="0.300in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.TicketNumber1"/>
        <text x="2.63in" y="0.435in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.Reason1"/>
        <text x="2.63in" y="0.570in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.PCP1"/>
        <text x="2.63in" y="0.705in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.InjuryDate1"/>
        <text x="2.63in" y="0.840in" width="1.14in" height="0.15in" font-family="Arial Narrow" font-size="8pt" valueSource="EncounterForm.1.InjuryPlace1"/>
      </g>

      <g id="ProcedureDetails">
        <rect x="0.50in" y="2.000in" width="7.5in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <!-- <rect x="0.50in" y="2.000in" width="7.50in" height="1.01in" fill="none" stroke="black"/> -->
        <text x="0.55in" y="2.005in" font-family="Arial" font-weight="bold" font-size="7pt">PROCEDURES</text>

        <xsl:call-template name="CreateProcedureColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="55"/>
          <xsl:with-param name="maximumColumns" select="4"/>
          <xsl:with-param name="totalElements" select="$ProcedureCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>

      <!-- Draw the lines for Procedure Codes-->
      <xsl:call-template name="DrawHorLines">
        <xsl:with-param name="yOffset" select="2.125"/>
        <xsl:with-param name="maximumRows" select="55"/>
      </xsl:call-template>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="0.5"/>
        <xsl:with-param name="yOffset" select="2.125"/>
        <xsl:with-param name="height" select="7.736215"/>
        <xsl:with-param name="maximumCols" select="5"/>
      </xsl:call-template>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="0.8125"/>
        <xsl:with-param name="yOffset" select="2.125"/>
        <xsl:with-param name="height" select="7.736125"/>
        <xsl:with-param name="maximumCols" select="4"/>
      </xsl:call-template>

      <g id="ReturnScheduleBox" transform="translate(100, 1994)">
        <rect x="0.00in" y="0.000in" width="1.84375in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="1.84375in" height="0.500in" fill="none" stroke="black"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">RETURN SCHEDULE</text>

        <text x="0.16in" y="0.16in" width="1.751in" height="0.500in" font-family="Arial" font-weight="bold" font-size="7pt">1      2      3      4      5      6      7</text>
        <text x="0.16in" y="0.32in" width="1.751in" height="0.500in" font-family="Arial" font-weight="bold" font-size="7pt">D       W       M       Y    PRN_____</text>
      </g>

      <g id="AccountStatusBox" transform="translate(481, 1994)">
        <rect x="0.00in" y="0.000in" width="1.8125in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="1.8125in" height="0.500in" fill="none" stroke="black"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">ACCOUNT STATUS</text>

        <text x="0.16in" y="0.16in" width="1.751in" height="0.500in" font-family="Arial Narrow" font-size="7pt"></text>
      </g>

      <g id="AccountActivityBox" transform="translate(856, 1994)">
        <rect x="0.00in" y="0.000in" width="1.8125in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="1.8125in" height="0.500in" fill="none" stroke="black"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">ACCOUNT ACTIVITY</text>

        <text x="0.9in" y="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PRIOR BALANCE:</text>
        <text x="0.9in" y="0.30in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">TODAY''S CHARGES:</text>

        <text x="0.95in" y="0.13in" width="0.75in" height="0.1in"  font-family="Arial Narrow" font-weight="bold" font-size="8pt" valueSource="EncounterForm.1.PatientBalance1"/>
      </g>

      <g id="PaymentOnAccountBox" transform="translate(1231, 1994)">
        <rect x="0.00in" y="0.000in" width="1.84375in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <rect x="0.00in" y="0.000in" width="1.84375in" height="0.500in" fill="none" stroke="black"/>
        <text x="0.05in" y="0.005in" font-family="Arial" font-weight="bold" font-size="7pt">PAYMENT ON ACCOUNT</text>

        <circle cx="0.09in" cy="0.22in" r="0.03in" fill="none" stroke="black" />
        <circle cx="0.09in" cy="0.37in" r="0.03in" fill="none" stroke="black" />
        <circle cx="0.55in" cy="0.22in" r="0.03in" fill="none" stroke="black" />

        <text x="0.18in" y="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" >CHECK</text>
        <text x="0.18in" y="0.30in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" >CREDIT CARD</text>
        <text x="0.63in" y="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" >CASH</text>

        <line x1="0.875in" y1="0.125in" x2="0.8725in" y2="0.5in" stroke="black" stroke-width="0.5pt"/>

        <text x="1.35in" y="0.15in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">DUE:</text>
        <text x="1.35in" y="0.30in" font-family="Arial Narrow" font-weight="bold" font-size="7pt" class="ralignedtext">PAYMENT:</text>
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>')

INSERT INTO PrintingFormDetails 
	(PrintingFormDetailsID, PrintingFormID, SVGDefinitionID, Description, SVGTransform, SVGDefinition)
VALUES
	(28, 9, 14, 'Encounter Form Four Column (Two Page) - Page 2', 1, '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="default-format" NaN="0.00" />

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
  <xsl:template name="CreateDiagnosisColumnLayout">

    <xsl:param name="maximumRowsInColumn"/>
    <xsl:param name="maximumRowsInLastColumn"/>
    <xsl:param name="maximumColumns"/>
    <xsl:param name="totalElements"/>
    <xsl:param name="currentElement"/>
    <xsl:param name="currentRow"/>
    <xsl:param name="currentColumn"/>
    <xsl:param name="currentCategory" select="0"/>

    <xsl:variable name="xLeftOffset" select="0.495"/>
    <xsl:variable name="xOffset" select="1.875"/>
    <xsl:variable name="yTopOffset" select="0.625"/>
    <xsl:variable name="yOffset" select=".140625"/>
    <xsl:variable name="codeXOffset" select=".03"/>
    <xsl:variable name="descriptionXOffset" select=".35"/>
    <xsl:variable name="rectangleYOffset" select="0.001"/>

    <xsl:if test="$totalElements >= $currentElement and $maximumColumns >= $currentColumn">
      <xsl:variable name="CurrentCategoryIndex" select="data[@id=concat(''EncounterForm.1.DiagnosisCategory'', $currentElement)]"/>

      <xsl:choose>
        <xsl:when test="(($currentColumn != $maximumColumns) and
						(($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInColumn) or
						($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInColumn)) or
						($currentColumn = $maximumColumns) and 
						(($currentCategory != $CurrentCategoryIndex and $currentRow + 1 > $maximumRowsInLastColumn) or
						($currentCategory = $CurrentCategoryIndex and $currentRow > $maximumRowsInLastColumn)))">
          <!-- There isn''t enough room to print on this column -->

          <!-- Calls the same template recursively (sets current row to 1, increments the current column, and resets the current category so it will print) -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" 
            y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" 
            width="1.55in" height="0.1in" 
            valueSource="EncounterForm.1.DiagnosisCategoryName{$CurrentCategoryIndex}" style="fill:black" 
            font-family="Arial" font-weight="bold" font-size="8pt"/>
          <!-- Creates the detail lines -->
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width=".30in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * $currentRow}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>

          <!-- Calls the same template recursively (increments 2 to the current row for the category line) -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
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
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $codeXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width=".30in" height="0.1in" valueSource="EncounterForm.1.DiagnosisCode{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>
          <text x="{$xLeftOffset + $xOffset * ($currentColumn - 1) + $descriptionXOffset}in" y="{$yTopOffset + $yOffset * ($currentRow - 1)}in" width="1.55in" height="0.1in" valueSource="EncounterForm.1.DiagnosisName{$currentElement}" font-family="Arial Narrow" font-size="7pt"/>


          <!-- Calls the same template recursively -->
          <xsl:call-template name="CreateDiagnosisColumnLayout">
            <xsl:with-param name="maximumRowsInColumn" select="$maximumRowsInColumn"/>
            <xsl:with-param name="maximumRowsInLastColumn" select="$maximumRowsInLastColumn"/>
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

  <xsl:template name="DrawHorLines">
    <xsl:param name="yOffset"/>
    <xsl:param name="maximumRows"/>
    <xsl:param name="currentRow" select="1"/>

    <xsl:if test="$maximumRows >= $currentRow">

      <line x1="0.5in" y1="{$yOffset + .140625 * ($currentRow)}in"
          x2="8in" y2="{$yOffset + .140625 * ($currentRow)}in"
          style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>

      <xsl:call-template name="DrawHorLines">
        <xsl:with-param name="yOffset" select="$yOffset"/>
        <xsl:with-param name="maximumRows" select="$maximumRows"/>
        <xsl:with-param name="currentRow" select="$currentRow+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="DrawVertLines">
    <xsl:param name="xOffset"/>
    <xsl:param name="yOffset"/>
    <xsl:param name="height"/>
    <xsl:param name="maximumCols"/>
    <xsl:param name="currentCol" select="0"/>

    <xsl:if test="$maximumCols > $currentCol">

      <line x1="{$xOffset+($currentCol)*1.875}in" y1="{$yOffset}in"
          x2="{$xOffset+($currentCol)*1.875}in" y2="{$yOffset +$height}in"
          style="fill:none" stroke="black" stroke-width="0.5pt" stroke-dasharray="2, 2"/>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="$xOffset"/>
        <xsl:with-param name="yOffset" select="$yOffset"/>
        <xsl:with-param name="height" select="$height"/>
        <xsl:with-param name="maximumCols" select="$maximumCols"/>
        <xsl:with-param name="currentCol" select="$currentCol+1"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template match="/formData/page">
    <xsl:variable name="DiagnosisCategoryCount" select="count(data[starts-with(@id,''EncounterForm.1.DiagnosisName'')])"/>

    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" formId="EncounterForm" pageId="EncounterForm.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
      <defs>
        <style type="text/css">
          g
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 9pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          g#Title
          {
          font-family: Arial,Arial Narrow,Helvetica;
          font-size: 16pt;
          font-style: Normal;
          font-weight: Normal;
          alignment-baseline: text-before-edge;
          }

          text
          {
          baseline-shift: -100%;
          }

          text.ralignedtext
          {
          text-anchor: end;
          }

          text.centeredtext
          {
          text-anchor: middle;
          }

          line
          {
          stroke: black;
          stroke-width: 0.0069in;
          }
          
        </style>
      </defs>

      <g id="DiagnosisDetails">
        <rect x="0.50in" y="0.5in" width="7.5in" height="0.125in" fill="rgb(190, 190, 190)" stroke="black" stroke-width="0.5pt"/>
        <!-- <rect x="0.50in" y="2.000in" width="7.50in" height="1.01in" fill="none" stroke="black"/> -->
        <text x="0.55in" y="0.5in" font-family="Arial" font-weight="bold" font-size="7pt">DIAGNOSES</text>

        <xsl:call-template name="CreateDiagnosisColumnLayout">
          <xsl:with-param name="maximumRowsInColumn" select="65"/>
          <xsl:with-param name="maximumRowsInLastColumn" select="65"/>
          <xsl:with-param name="maximumColumns" select="4"/>
          <xsl:with-param name="totalElements" select="$DiagnosisCategoryCount"/>
          <xsl:with-param name="currentElement" select="1"/>
          <xsl:with-param name="currentRow" select="1"/>
          <xsl:with-param name="currentColumn" select="1"/>
          <xsl:with-param name="currentCategory" select="0"/>
        </xsl:call-template>
      </g>

      <!-- Draw the lines for Diagnosis Codes-->
      <xsl:call-template name="DrawHorLines">
        <xsl:with-param name="yOffset" select="0.625"/>
        <xsl:with-param name="maximumRows" select="65"/>
      </xsl:call-template>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="0.5"/>
        <xsl:with-param name="yOffset" select="0.625"/>
        <xsl:with-param name="height" select="9.142375"/>
        <xsl:with-param name="maximumCols" select="5"/>
      </xsl:call-template>

      <xsl:call-template name="DrawVertLines">
        <xsl:with-param name="xOffset" select="0.8125"/>
        <xsl:with-param name="yOffset" select="0.625"/>
        <xsl:with-param name="height" select="9.142375"/>
        <xsl:with-param name="maximumCols" select="4"/>
      </xsl:call-template>

      <g id="Signature">
        <text x="0.5in" y="9.825in" font-family="Arial" font-weight="bold" font-size="7pt">I hereby certify that I have rendered the above services.</text>
        <text x="0.5in" y="10.125in" font-family="Arial Narrow" font-weight="bold" font-size="7pt">PHYSICIAN''S SIGNATURE</text>
        <line x1="1.57in" y1="10.225in" x2="5.5in" y2="10.225in" />
        <text x="5.6in" y="10.125in" font-family="Arial Narrow" font-weight="bold" font-size="7pt">DATE</text>
        <line x1="5.88in" y1="10.225in" x2="8.0in" y2="10.225in" />
      </g>

    </svg>
  </xsl:template>
</xsl:stylesheet>')

GO





/*-----------------------------------------------------------------------------
Case 10231 - New Report: Patient Statement
-----------------------------------------------------------------------------*/

DECLARE @PatientStatementRptID INT 

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
	23,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Patient Statement', 
	'This report provides a current patient statement for a specific patient.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPatientStatement',
	'<?xml version="1.0" encoding="utf-8" ?>  
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
			</extendedParameters>  
		</parameters>',
	'Patient &Statement', -- Why are "&" used in the value???
	'ReadPatientStatementReport')

 

SET @PatientStatementRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@PatientStatementRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@PatientStatementRptID,
	'M',
	GETDATE()
	)

---------------------------------------------------------------------------------------------
-- Case 9881: Wrong referring provider number is printing on HCFA 
---------------------------------------------------------------------------------------------
ALTER TABLE InsuranceCompany ADD ReferringProviderNumberTypeID INT NULL DEFAULT 25
GO


---------------------------------------------------------------------------------------------
-- Case 6987: Add Journal Notes to the Patient
---------------------------------------------------------------------------------------------
CREATE TABLE dbo.PatientJournalNote
(
	PatientJournalNoteID int IDENTITY(1,1) not null,
	
	CreatedDate DateTime not null DEFAULT GetDate(),
	CreatedUserID int null,
	ModifiedDate DateTime not null DEFAULT GetDate(),
	ModifiedUserID int null,
	timestamp,
	
	PatientID int not null,
	UserName varchar(128) not null,
	SoftwareApplicationID char(1) not null DEFAULT 'B',
	Hidden bit not null DEFAULT 0,
	NoteMessage text null

	CONSTRAINT [PK_PatientJournalNote] PRIMARY KEY NONCLUSTERED 
	(
		[PatientJournalNoteID] ASC
	)
)
GO

ALTER TABLE PatientJournalNote
ADD  CONSTRAINT FK_PatientJournalNote_PatientID 
FOREIGN KEY(PatientID)
REFERENCES Patient (PatientID)
GO

ALTER TABLE PatientJournalNote
ADD CONSTRAINT FK_PatientJournalNote_SoftwareApplicationID
FOREIGN KEY (SoftwareApplicationID)
REFERENCES SoftwareApplication (SoftwareApplicationID)
GO

insert into PatientJournalNote(
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		PatientID,
		UserName,
		SoftwareApplicationID,
		Hidden,
		NoteMessage)
select	ModifiedDate,		-- CreatedDate
		0,				-- CreatedUserID
		ModifiedDate,		-- ModifiedDate
		0,				-- ModifiedUserID
		PatientID,		-- PatientID
		'System Conversion',-- UserName
		'B',			-- ApplicationID
		0,				-- Hidden
		Notes			-- NoteMessage 
from	Patient 
where	cast(Notes as varchar(max)) <> ''
and		Notes is not null

GO
--CASE 10282: Encounter PostingDate updates not propagating to ClaimTransaction/ClaimAccounting 
--Sync script
DISABLE TRIGGER ALL ON Encounter
GO
DISABLE TRIGGER ALL ON EncounterProcedure
GO
DISABLE TRIGGER ALL ON Claim
GO
DISABLE TRIGGER ALL ON ClaimTransaction
GO

UPDATE CT SET PostingDate=CAST(CONVERT(CHAR(10),E.PostingDate,110) AS DATETIME)
FROM Encounter E INNER JOIN EncounterProcedure EP
ON E.PracticeID=EP.PracticeID AND E.EncounterID=EP.EncounterID
INNER JOIN Claim C
ON EP.PracticeID=C.PracticeID AND EP.EncounterProcedureID=C.EncounterProcedureID
INNER JOIN ClaimTransaction CT
ON C.PracticeID=CT.PracticeID AND C.ClaimID=CT.ClaimID AND CT.ClaimTransactionTypeCode='CST'

UPDATE CA SET PostingDate=CAST(CONVERT(CHAR(10),CT.PostingDate,110) AS DATETIME)
FROM ClaimTransaction CT INNER JOIN ClaimAccounting CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimID=CA.ClaimID AND CT.ClaimTransactionID=CA.ClaimTransactionID
WHERE CT.ClaimTransactionTypeCode='CST'

GO
ENABLE TRIGGER ALL ON Encounter
GO
ENABLE TRIGGER ALL ON EncounterProcedure
GO
ENABLE TRIGGER ALL ON Claim
GO
ENABLE TRIGGER ALL ON ClaimTransaction
GO

--CASE 9409
UPDATE Report SET ReportParameters='<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"
			default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type."
			default="P">
			<value displayText="Posting Date" value="P" />
			<value displayText="Date of Service" value="D" />
		</extendedParameter>
		<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:"
			default="-1" ignore="-1" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1" />
	</extendedParameters>
</parameters>'
WHERE Name='Provider Productivity'

GO

/*-----------------------------------------------------------------------------
Case 10290 - New Report: Encounter Detail
-----------------------------------------------------------------------------*/
declare @ReportCategoryID int

INSERT INTO [ReportCategory](
			[DisplayOrder]
           ,[Image]
           ,[Name]
           ,[Description]
           ,[TaskName]
           ,[ModifiedDate]
           ,[MenuName])
select
		(select max(DisplayOrder) + 1 from reportCategory),
		'[[image[Practice.ReportsV2.Images.reports.gif]]]',
		'Encounters',
		'Encounters',
		'Report List',
		getdate(),
		'&Encounters'

set @ReportCategoryID = @@identity


INSERT INTO reportCategoryToSoftwareApplication(
	ReportCategoryID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@ReportCategoryID,
	'B',
	GETDATE()
	)

INSERT INTO reportCategoryToSoftwareApplication(
	ReportCategoryID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@ReportCategoryID,
	'M',
	GETDATE()
	)


DECLARE @EncountersDetailRptID INT 

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
	@ReportCategoryID,  
	5, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Encounters Detail', 
	'This report shows a detailed list of encounters over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptEncounterDetail',
	'<?xml version="1.0" encoding="utf-8" ?>  
		<parameters>   
			<basicParameters>
				<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" /> 
				<basicParameter type="PracticeID" parameterName="PracticeID" />
				<basicParameter type="PracticeName" parameterName="rpmPracticeName" />    

				<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="MonthToDate" forceDefault="true" />
				<basicParameter type="Date" parameterName="BeginDate" text="From:"/>    
				<basicParameter type="Date" parameterName="EndDate" text="To:"/>   

				<basicParameter type="ClientTime" parameterName="ClientTime" />   
				<basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />    
			</basicParameters>   
	
			<extendedParameters>    
				<extendedParameter type="Separator" text="Filter" />    
				<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting date or Procedure Service Date"    default="P">    
					<value displayText="Posting Date" value="P" />    
					<value displayText="Service Date" value="S" />    
				</extendedParameter>   
				<extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Status:" description="Select Encounter Status"    default="-1">    
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
		</parameters>',
	'Encounters &Detail',
	'ReadEncountersDetailReport')


SET @EncountersDetailRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@EncountersDetailRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@EncountersDetailRptID,
	'M',
	GETDATE()
	)



insert into reportHyperlink(
	ReportHyperlinkID,
	Description,
	ReportParameters,
	ModifiedDate
	)
select
	(select max(ReportHyperlinkID)+1 from reportHyperlink),
	'Encounter Detail Task',
	'<?xml version="1.0" encoding="utf-8" ?>
						<task name="Encounter Detail">
							<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
								<method name="" />
								<method name="Add">
									<methodParam param="EncounterCommand" />
									<methodParam param="Edit" type="Kareo.Superbill.Windows.Tasks.Practice.Encounters.EncounterCommand" />
									<methodParam param="true" type="System.Boolean" />
								</method>
								<method name="Add">
									<methodParam param="EncounterID" />
									<methodParam param="{0}" type="System.Int32" />
									<methodParam param="true" type="System.Boolean" />
								</method>
							</object>
						</task>',
	getdate()


CREATE NONCLUSTERED INDEX IX_PatientCase_PayerScenarioID
ON PatientCase (PayerScenarioID)
	
go






/*-----------------------------------------------------------------------------
Case 8547 - Make the status "Approved" as the defult filter in the Missed copay report
			- Added rpmSoftwareApplicationID as part of the encounter hyperlink
-----------------------------------------------------------------------------*/

update report
set ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
		<extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Encounter Status:" description="Limits the report by Encounter Status." default="3">
			<value displayText="All" value="-1" />
			<value displayText="Approved" value="3" />
			<value displayText="Draft" value="1" />
			<value displayText="Submitted" value="2" />
			<value displayText="Rejected" value="4" />
		</extendedParameter>
	</extendedParameters>
</parameters>'
where name = 'Missed Copays'

go

-----------------------------------------------------------------------------
-- Case 9439 - Add BatchID to Encounters
------------------------------------------------------------------------------
ALTER TABLE Encounter ADD BatchID VARCHAR(50)
GO

UPDATE	Report
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
	</extendedParameters>
</parameters>'
WHERE	Name = 'Provider Productivity'

UPDATE	Report
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
		<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
	</extendedParameters>
</parameters>'
WHERE	Name = 'A/R Aging Summary'

UPDATE	Report
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Payer and Payer Type for this report.">
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

UPDATE	Report
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
WHERE	Name='A/R Aging by Insurance'

UPDATE	Report
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
WHERE	Name='A/R Aging by Patient'

UPDATE	ReportHyperlink
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="A/R Aging Detail" />
			<methodParam param="true" type="System.Boolean" />
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
					<method name="Add">
						<methodParam param="Responsibility" />
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
WHERE	Description = 'A/R Aging Detail Report'

UPDATE	ReportHyperlink
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
						<methodParam param="BatchID" />
						<methodParam param="{1}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>'
WHERE	Description = 'A/R Aging by Insurance'

UPDATE	ReportHyperlink
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
						<methodParam param="BatchID" />
						<methodParam param="{1}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>'
WHERE	Description = 'A/R Aging by Patient'

GO


/*-----------------------------------------------------------------------------
Case 10292 - New Report: Encounter Summary
-----------------------------------------------------------------------------*/


DECLARE @EncountersSummaryRptID INT 

Declare @EncounterReportCagetoryID int
Select @EncounterReportCagetoryID = ReportCategoryID from ReportCategory where name = 'Encounters'


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
	@EncounterReportCagetoryID,  
	3, 
	'[[image[Practice.ReportsV2.Images.reports.gif]]]', 
	'Encounters Summary', 
	'This report shows a summary of encounters over a period of time.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptEncounterSummary',
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
				<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Select from either Posting date or Procedure Service Date"    default="P">
					<value displayText="Posting Date" value="P" />
					<value displayText="Service Date" value="S" />
				</extendedParameter>
				<extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Status:" description="Select Encounter Status"    default="-1">
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
		</parameters>',
	'Encounter &Summary',
	'ReadEncountersSummaryReport')


SET @EncountersSummaryRptID =@@IDENTITY

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate
	)

VALUES(
	@EncountersSummaryRptID,
	'B',
	GETDATE()
	)

INSERT INTO ReportToSoftwareApplication(
	ReportID, 
	SoftwareApplicationID, 
	ModifiedDate)

VALUES(
	@EncountersSummaryRptID,
	'M',
	GETDATE()
	)



declare @patientID int,
		@patientDisplayOrder int

select @patientID = ReportCategoryID,
		@patientDisplayOrder = DisplayOrder
from reportCategory
where name = 'Patients'


update dbo.reportCategory 
set DisplayOrder = (1+ DisplayOrder) * 10,
	ModifiedDate = getdate()
where reportCategoryID > @patientID


update reportCategory 
set DisplayOrder = @patientDisplayOrder + 5
where reportCategory.name = 'Encounters'

	
go

/*-----------------------------------------------------------------------------
Case 8546 - Added Revenue Center Filter, Create a revenue table
-----------------------------------------------------------------------------*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProcedureCodeRevenueCenterCategory ]') AND type in (N'U'))
DROP TABLE [dbo].[ProcedureCodeRevenueCenterCategory ]


CREATE TABLE [dbo].[ProcedureCodeRevenueCenterCategory ](
	[ProcedureCodeRevenueCenterCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ProcedureCodeStartRange] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ProcedureCodeEndRange] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RevenueCenterType] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Name] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_ProcedureCodeRevenueCenterCategory ] PRIMARY KEY CLUSTERED 
(
	[ProcedureCodeRevenueCenterCategoryID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_ProcedureCodeRevenueCenterCategory _ProcedureCodeStartRange_ProcedureCodeEndRange] UNIQUE NONCLUSTERED 
(
	[ProcedureCodeStartRange] ASC,
	[ProcedureCodeEndRange] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

go

declare @RevenueCenterType varchar(30)
set @RevenueCenterType = 'CPT'



		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values( '00100', '01999', @RevenueCenterType, 'Anesthesia')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values( '99201','99499', @RevenueCenterType, 'Evaluation and Management')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  '90281', '99199', @RevenueCenterType,  'Medicine') 
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  '99500', '99602', @RevenueCenterType, 'Medicine')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  '80048', '89399', @RevenueCenterType, 'Pathology and Laboratory')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  '70010', '79999', @RevenueCenterType, 'Radiology')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  69000, 69979, @RevenueCenterType, 'Surgery - Auditory System')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  33010, 37799, @RevenueCenterType, 'Surgery - Cardiovascular System')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  40490, 49999, @RevenueCenterType,'Surgery - Digestive System')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  60000, 60699, @RevenueCenterType,'Surgery - Endocrine System')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  65091, 68899, @RevenueCenterType, 'Surgery - Eye and Ocular Adnexa')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  56405, 58999, @RevenueCenterType, 'Surgery - Female Genital System')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  38100, 38999, @RevenueCenterType, 'Surgery - Hemic and Lymphatic Systems')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  10040, 19499, @RevenueCenterType,'Surgery - Integumentary System')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  55970, 55980, @RevenueCenterType, 'Surgery - Intersex')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  54000, 55899, @RevenueCenterType,'Surgery - Male Genital System')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values(  59000, 59899, @RevenueCenterType, 'Surgery - Maternity Care and Delivery')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType, 'Surgery - Mediastinum and Diaphragm', 39000, 39599)
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType, 'Surgery - Musculoskeletal System', 20000, 29999)
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType, 'Surgery - Nervous System', 61000, 64999)
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values( @RevenueCenterType,  'Surgery - Operating Microscope',  69990, 69990)
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values( @RevenueCenterType,  'Surgery - Respiratory System',  30000, 32999)
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values( @RevenueCenterType,  'Surgery - Urinary System', 50010, 53899)

		set @RevenueCenterType = 'HCPCS'
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values( @RevenueCenterType,  'Administrative, Miscellaneous and Investigational', 'A9150', 'A9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Chemotherapy Drugs', 'J9000', 'J9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Dental Procedures', 'D0120', 'D9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Diagnostic Radiology Services', 'R0000', 'R5999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Drugs Administered Other Than Oral Method (Exception: Oral Immunosuppressive Drugs)', 'J0120', 'J9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Durable Medical Equipment', 'E0100', 'E9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Enteral and Parenteral Therapy', 'B4034', 'B9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Hearing Services', 'V5008', 'V5364')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Hospital Outpatient PPS Codes', 'C1000', 'C9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'K-Codes: For DMERC Use Only', 'K0001', 'K9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Medical and Surgical Supplies', 'A4206', 'A7526')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Medical Services', 'M0064', 'M0302')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'National T-Codes Established for State Medicaid Agencies', 'T1000', 'T5999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Orthotic Procedures', 'L0100', 'L4398')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Pathology and Laboratory Services', 'P2028', 'P9615')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Private Payer Codes', 'S0009', 'S9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Procedures & Professional Services', 'G0001', 'G9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Prosthetic Procedures', 'L5000', 'L9900')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Rehabilitative Services', 'H0001', 'H2037')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Temporary Codes', 'Q0034', 'Q9999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Transportation Services', 'A0080', 'A0999')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [RevenueCenterType],[Name], [ProcedureCodeStartRange],[ProcedureCodeEndRange])
		values(  @RevenueCenterType,  'Vision Services', 'V2020', 'V2799') 

set @RevenueCenterType = 'CPT'
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values( '0001F', '6999F', @RevenueCenterType, 'Category II Codes')
		INSERT INTO [ProcedureCodeRevenueCenterCategory ] ( [ProcedureCodeStartRange],[ProcedureCodeEndRange],[RevenueCenterType],[Name])
		values( '0001T', '0999T', @RevenueCenterType, 'Category III Codes')
		go


-- Builds a static table of revenue centers. We may change to a dynamic list.
declare @RevCenterParameterList varchar(8000)
select @RevCenterParameterList = 
			(
			select name + ' (' + cast(ProcedureCodeStartRange as varchar) + '-' + cast(ProcedureCodeEndRange as varchar) + ')' as [displayText], ProcedureCodeRevenueCenterCategoryID as value
			from ProcedureCodeRevenueCenterCategory  as [value]
			order by name FOR XML auto
			)

update report
set reportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:"     default="Today" forceDefault="true" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" overrideMaxDate="true" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
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
			<value displayText="ALL" value="-1" />'
			+ @RevCenterParameterList +
		'</extendedParameter>
	</extendedParameters>
</parameters>'
where name = 'Account Activity Report'


go

/*-----------------------------------------------------------------------------
Case 9439 - Added BatchID to Unpaid Insurance report & Daily Report
-----------------------------------------------------------------------------*/


update report
set reportParameters = 
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
where name = 'Unpaid Insurance Claims'


update report
set ReportParameters = 
	'<?xml version="1.0" encoding="utf-8" ?>
	<parameters>
		<basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="TimeOffset" parameterName="TimeOffset" />
			<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
			<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
			<basicParameter type="ClientTime" parameterName="ClientTime" />
		</basicParameters>
		<extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="ComboBox" parameterName="DateTypeID" text="Date Type:" description="Limits the report by date type." default="P" ignore="P">
				<value displayText="Posting Date" value="P" />
				<value displayText="Date of Service" value="S" />
			</extendedParameter>
			<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:"/>
		</extendedParameters>
	</parameters>'
where name = 'Daily Report'
go

--CASE 8546
CREATE INDEX IX_Encounter_DoctorID
ON Encounter (DoctorID)

CREATE INDEX IX_Encounter_LocationID
ON Encounter (LocationID)

CREATE INDEX IX_Encounter_BatchID
ON Encounter (BatchID)

GO

--BatchID does not carry through from PaymentSummary to Payment Application Report, this should fix
UPDATE	ReportHyperlink
SET		ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
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
						<methodParam param="BatchID" />
						<methodParam param="{3}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>'
WHERE	ReportHyperLinkID=8
GO

--ROLLBACK
--COMMIT

