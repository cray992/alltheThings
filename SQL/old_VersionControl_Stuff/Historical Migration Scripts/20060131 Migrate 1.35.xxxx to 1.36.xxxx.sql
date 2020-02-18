/*----------------------------------

DATABASE UPDATE SCRIPT

v1.35.xxxx to v1.36.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------

-------------------------------------------------------------------------------
-- Case 8601: Change DB schema on SQL server for the "Practitioner" Changes 
-------------------------------------------------------------------------------

CREATE TABLE [dbo].[HandheldEncounterDetail](
	[HandheldEncounterDetailID] [int] IDENTITY(1,1) NOT NULL,
	[HandheldEncounterID] [int] NOT NULL,
	[ProcedureCodeDictionaryID] [int] NULL,
	[DiagnosisCodeDictionaryID1] [int] NULL,
	[DiagnosisCodeDictionaryID2] [int] NULL,
	[DiagnosisCodeDictionaryID3] [int] NULL,
	[DiagnosisCodeDictionaryID4] [int] NULL,
 CONSTRAINT [PK_dbo.HandheldEncounterDetail] PRIMARY KEY CLUSTERED 
(
	[HandheldEncounterDetailID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
-- contraint to the header table
ALTER TABLE dbo.HandheldEncounterDetail
	ADD CONSTRAINT FK_HandheldEncounterDetail_To_HandheldEncounter FOREIGN KEY
	(
		HandheldEncounterID
	) 
	REFERENCES dbo.HandheldEncounter (HandheldEncounterID)

GO

-- Migration script
truncate table dbo.HandheldEncounterDetail
GO
set nocount on

declare
	cur8601 cursor static forward_only for 
		SELECT  HandheldEncounterID, 
				ProcedureCodeDictionaryID1, 
				ProcedureCodeDictionaryID2, 
				ProcedureCodeDictionaryID3, 
				ProcedureCodeDictionaryID4, 
				ProcedureCodeDictionaryID5, 
				ProcedureCodeDictionaryID6,
 
				DiagnosisCodeDictionaryID1, 
				DiagnosisCodeDictionaryID2, 
				DiagnosisCodeDictionaryID3, 
				DiagnosisCodeDictionaryID4
		FROM dbo.HandheldEncounter
		ORDER BY HandheldEncounterID

declare
	@HandheldEncounterID_8601 int, 
	@ProcedureCodeDictionaryID1_8601 int, 
	@ProcedureCodeDictionaryID2_8601 int, 
	@ProcedureCodeDictionaryID3_8601 int, 
	@ProcedureCodeDictionaryID4_8601 int, 
	@ProcedureCodeDictionaryID5_8601 int, 
	@ProcedureCodeDictionaryID6_8601 int,
 
	@DiagnosisCodeDictionaryID1_8601 int, 
	@DiagnosisCodeDictionaryID2_8601 int, 
	@DiagnosisCodeDictionaryID3_8601 int, 
	@DiagnosisCodeDictionaryID4_8601 int


open cur8601
fetch next from cur8601 into 
	@HandheldEncounterID_8601, 
	@ProcedureCodeDictionaryID1_8601, 
	@ProcedureCodeDictionaryID2_8601, 
	@ProcedureCodeDictionaryID3_8601, 
	@ProcedureCodeDictionaryID4_8601, 
	@ProcedureCodeDictionaryID5_8601, 
	@ProcedureCodeDictionaryID6_8601,
 
	@DiagnosisCodeDictionaryID1_8601, 
	@DiagnosisCodeDictionaryID2_8601, 
	@DiagnosisCodeDictionaryID3_8601, 
	@DiagnosisCodeDictionaryID4_8601
while @@Fetch_Status=0
begin
	if @ProcedureCodeDictionaryID1_8601 is not null
		INSERT INTO dbo.HandheldEncounterDetail (
			HandheldEncounterID, 
			ProcedureCodeDictionaryID, 
			DiagnosisCodeDictionaryID1, 
			DiagnosisCodeDictionaryID2,
			DiagnosisCodeDictionaryID3,
			DiagnosisCodeDictionaryID4)
		VALUES (
			@HandheldEncounterID_8601,
			@ProcedureCodeDictionaryID1_8601,
			
			@DiagnosisCodeDictionaryID1_8601, 
			@DiagnosisCodeDictionaryID2_8601, 
			@DiagnosisCodeDictionaryID3_8601, 
			@DiagnosisCodeDictionaryID4_8601)

	if @ProcedureCodeDictionaryID2_8601 is not null
		INSERT INTO dbo.HandheldEncounterDetail (
			HandheldEncounterID, 
			ProcedureCodeDictionaryID, 
			DiagnosisCodeDictionaryID1, 
			DiagnosisCodeDictionaryID2,
			DiagnosisCodeDictionaryID3,
			DiagnosisCodeDictionaryID4)
		VALUES (
			@HandheldEncounterID_8601,
			@ProcedureCodeDictionaryID2_8601,
			
			@DiagnosisCodeDictionaryID1_8601, 
			@DiagnosisCodeDictionaryID2_8601, 
			@DiagnosisCodeDictionaryID3_8601, 
			@DiagnosisCodeDictionaryID4_8601)

	if @ProcedureCodeDictionaryID3_8601 is not null
		INSERT INTO dbo.HandheldEncounterDetail (
			HandheldEncounterID, 
			ProcedureCodeDictionaryID, 
			DiagnosisCodeDictionaryID1, 
			DiagnosisCodeDictionaryID2,
			DiagnosisCodeDictionaryID3,
			DiagnosisCodeDictionaryID4)
		VALUES (
			@HandheldEncounterID_8601,
			@ProcedureCodeDictionaryID3_8601,
			
			@DiagnosisCodeDictionaryID1_8601, 
			@DiagnosisCodeDictionaryID2_8601, 
			@DiagnosisCodeDictionaryID3_8601, 
			@DiagnosisCodeDictionaryID4_8601)

	if @ProcedureCodeDictionaryID4_8601 is not null
		INSERT INTO dbo.HandheldEncounterDetail(
			HandheldEncounterID, 
			ProcedureCodeDictionaryID, 
			DiagnosisCodeDictionaryID1, 
			DiagnosisCodeDictionaryID2,
			DiagnosisCodeDictionaryID3,
			DiagnosisCodeDictionaryID4)
		VALUES (
			@HandheldEncounterID_8601,
			@ProcedureCodeDictionaryID4_8601,
			
			@DiagnosisCodeDictionaryID1_8601, 
			@DiagnosisCodeDictionaryID2_8601, 
			@DiagnosisCodeDictionaryID3_8601, 
			@DiagnosisCodeDictionaryID4_8601)


		fetch next from cur8601 into 
			@HandheldEncounterID_8601, 
			@ProcedureCodeDictionaryID1_8601, 
			@ProcedureCodeDictionaryID2_8601, 
			@ProcedureCodeDictionaryID3_8601, 
			@ProcedureCodeDictionaryID4_8601, 
			@ProcedureCodeDictionaryID5_8601, 
			@ProcedureCodeDictionaryID6_8601,
		 
			@DiagnosisCodeDictionaryID1_8601, 
			@DiagnosisCodeDictionaryID2_8601, 
			@DiagnosisCodeDictionaryID3_8601, 
			@DiagnosisCodeDictionaryID4_8601
end

close cur8601
deallocate cur8601

-------------------------------------------------------------------------------
-- Case 8808: Add new fields for patient detail
-------------------------------------------------------------------------------

-- Add new columns to the patient table
ALTER TABLE dbo.Patient ADD
	EmployerID INT NULL,
	MedicalRecordNumber VARCHAR(128) NULL,
	MobilePhone VARCHAR(10) NULL,
	MobilePhoneExt VARCHAR(10) NULL,
	PrimaryCarePhysicianID INT NULL	

GO	

-- Add foreign key constraint to employer
ALTER TABLE [dbo].[Patient] ADD
	CONSTRAINT [FK_Patient_Employers] FOREIGN KEY 
	(
		[EmployerID]
	) REFERENCES [Employers] (
		[EmployerID]
	)
GO

-- Add foreign key constraint to referring physician
ALTER TABLE [dbo].[Patient] ADD
	CONSTRAINT [FK_Patient_PrimaryCarePhysicianID] FOREIGN KEY 
	(
		[PrimaryCarePhysicianID]
	) REFERENCES [ReferringPhysician] (
		[ReferringPhysicianID]
	)
GO

-- Update the patients with only one employer
UPDATE	Patient
SET		EmployerID = PE.EmployerID
FROM	Patient P
INNER JOIN
		PatientEmployer PE
ON		   PE.PatientID = P.PatientID
WHERE	PE.PatientID IN (
							SELECT	PatientID
							FROM	PatientEmployer
							GROUP BY
									PatientID
							HAVING	COUNT(PatientEmployerID) = 1)

-- Add additional employers to the patient's notes
DECLARE @curr8808 INT
DECLARE @max8808 INT
DECLARE @length8808 INT
DECLARE @employer8808 VARCHAR(128)
DECLARE @ptr8808 binary(16)

CREATE TABLE #AdditionalEmployers
(
	ID int identity(1,1), 
	PatientID int,
	EmployerID int,
	EmployerName varchar(128)
)

INSERT INTO #AdditionalEmployers(
		PatientID,
		EmployerID,
		EmployerName)
SELECT	PE.PatientID,
		PE.EmployerID,
		E.EmployerName
FROM	PatientEmployer PE
INNER JOIN
		Employers E
ON		   E.EmployerID = PE.EmployerID
WHERE	PE.Precedence > 1
AND		PE.PatientID IN(
							SELECT	PatientID
							FROM	PatientEmployer
							GROUP BY
									PatientID
							HAVING	COUNT(PatientEmployerID) > 1
						)
ORDER BY
		PE.Precedence

SELECT	@max8808 = @@rowcount
SET		@curr8808 = 1

UPDATE P SET Notes=''
FROM	Patient P
INNER JOIN
		#AdditionalEmployers AE
ON		   AE.PatientID = P.PatientID
WHERE Notes IS NULL

WHILE	@curr8808 <= @max8808
BEGIN
	-- Loop through each additional employer record and add it to the end of the notes

	-- Get the text pointer
	SELECT	@ptr8808 = TEXTPTR(P.Notes),
			@length8808 = DATALENGTH(P.Notes),
			@employer8808 = 
			CASE WHEN DATALENGTH(P.Notes) = 0 THEN
				'Employer: ' + AE.EmployerName
			ELSE
				char(13) + char(10) + 'Employer: ' + AE.EmployerName
			END
	FROM	Patient P
	INNER JOIN
			#AdditionalEmployers AE
	ON		   AE.PatientID = P.PatientID
	AND		   AE.ID = @curr8808

	-- Update the text
	UPDATETEXT Patient.Notes @ptr8808 @length8808 0 @employer8808

	SET @curr8808 = @curr8808 + 1
END

DROP TABLE #AdditionalEmployers
GO

-- Drop the Patient Employer table
ALTER TABLE Encounter
	DROP FK_Encounter_PatientEmployer

ALTER TABLE PatientEmployer
	DROP FK_PatientEmployer_Employers

ALTER TABLE PatientEmployer
	DROP FK_PatientEmployer_Patient

ALTER TABLE PatientEmployer
	DROP CONSTRAINT PK_PatientEmployer

DROP TABLE PatientEmployer

GO

/*------------------------------------------------------------------------------- 
Case 8551:   Change Encounter details to enter payment type (copay, normal) 
-------------------------------------------------------------------------------*/

/* Create PaymentType table */

CREATE TABLE [dbo].[PaymentType](
	[PaymentTypeID] [int] NOT NULL,
	[Name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortOrder] [int] NOT NULL,
	[PayerTypeCode] [char](1),
 CONSTRAINT [PK_PaymentType] PRIMARY KEY CLUSTERED 
(
	[PaymentTypeID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO [dbo].[PaymentType]
           ([PaymentTypeID]
		   ,[Name]
           ,[Description]
           ,[SortOrder]
           ,[PayerTypeCode])
VALUES
           (0
           ,'None'
           ,'None'
           ,0
           ,'P')

INSERT INTO [dbo].[PaymentType]
           ([PaymentTypeID]
		   ,[Name]
           ,[Description]
           ,[SortOrder]
           ,[PayerTypeCode])
VALUES
           (1
           ,'Copay'
           ,'Copay'
           ,1
           ,'P')

INSERT INTO [dbo].[PaymentType]
           ([PaymentTypeID]
		   ,[Name]
           ,[Description]
           ,[SortOrder]
           ,[PayerTypeCode])
VALUES
           (2
           ,'Patient Payment on Account'
           ,'Patient Payment on Account'
           ,2
           ,'P')

INSERT INTO [dbo].[PaymentType]
           ([PaymentTypeID]
		   ,[Name]
           ,[Description]
           ,[SortOrder]
           ,[PayerTypeCode])
VALUES
           (3
           ,'Insurance Payment'
           ,'Insurance Payment'
           ,3
           ,'I')

INSERT INTO [dbo].[PaymentType]
           ([PaymentTypeID]
		   ,[Name]
           ,[Description]
           ,[SortOrder]
           ,[PayerTypeCode])
VALUES
           (4
           ,'Other'
           ,'Other'
           ,4
           ,'O')

GO

/* Add PaymentTypeID column to Payment table */

ALTER TABLE dbo.Payment ADD
	PaymentTypeID int NULL
GO

ALTER TABLE dbo.Payment ADD CONSTRAINT
	FK_Payment_PaymentType FOREIGN KEY
	(
	PaymentTypeID
	) REFERENCES dbo.PaymentType
	(
	PaymentTypeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

ALTER TABLE dbo.Encounter ADD
	PaymentTypeID int NULL,
	PaymentDescription varchar(250) NULL
GO

ALTER TABLE dbo.Encounter ADD CONSTRAINT
	FK_Encounter_PaymentType FOREIGN KEY
	(
	PaymentTypeID
	) REFERENCES dbo.PaymentType
	(
	PaymentTypeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

DISABLE TRIGGER [tr_Encounter_MaintainPaymentsOnEncounterApproved] ON Encounter
GO

DECLARE @PaymentTypeID INT

SELECT	@PaymentTypeID = PaymentTypeID
FROM	PaymentType
WHERE	[Name] = 'Copay'

/* Default existing encounter-related payments to patient copay */
UPDATE	Encounter
SET		PaymentTypeID = @PaymentTypeID
WHERE	AmountPaid IS NOT NULL

SELECT	@PaymentTypeID = PaymentTypeID
FROM	PaymentType
WHERE	[Name] = 'None'

/* Default existing encounter-related payments to patient copay */
UPDATE	Encounter
SET		PaymentTypeID = @PaymentTypeID
WHERE	AmountPaid IS NULL

GO

ENABLE TRIGGER [tr_Encounter_MaintainPaymentsOnEncounterApproved] ON Encounter
GO

DISABLE TRIGGER [tr_IU_Payment_ChangeTime] ON Payment
GO

/* Update patient copay payments... */
UPDATE	Payment
SET		PaymentTypeID = PT.PaymentTypeID
FROM Payment AS P
JOIN PaymentType AS PT
	ON PT.PayerTypeCode = P.PayerTypeCode
WHERE
	P.SourceEncounterID IS NOT NULL
	AND P.PayerTypeCode = 'P'
	AND PT.[Name] = 'Copay'

/* Update non-copay patient payments... */
UPDATE	Payment
SET		PaymentTypeID = PT.PaymentTypeID
FROM Payment AS P
JOIN PaymentType AS PT
	ON PT.PayerTypeCode = P.PayerTypeCode
WHERE
	P.SourceEncounterID IS NULL
	AND P.PayerTypeCode = 'P'
	AND PT.[Name] = 'Patient Payment on Account'

/* Update non-patient payments... */
UPDATE	Payment
SET		PaymentTypeID = PT.PaymentTypeID
FROM Payment AS P
JOIN PaymentType AS PT
	ON PT.PayerTypeCode = P.PayerTypeCode
WHERE
	P.SourceEncounterID IS NULL
	AND P.PayerTypeCode <> 'P'

GO

ENABLE TRIGGER [tr_IU_Payment_ChangeTime] ON Payment
GO

-------------------------------------------------------------------------------
-- Case 8550: Add option to A/R Aging by Patient to list by ultimate patient responsibility 
-------------------------------------------------------------------------------
UPDATE ReportHyperlink SET ReportParameters='<?xml version="1.0" encoding="utf-8" ?>
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
				</object>
			</methodParam>
		</method>
	</object>
</task>
',
ModifiedDate=GETDATE()
WHERE ReportHyperlinkID=1

UPDATE Report SET ReportParameters='<?xml version="1.0" encoding="utf-8" ?>
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
		<extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range."
			default="Current+">
			<value displayText="Current+" value="Current+" />
			<value displayText="30+" value="Age31_60" />
			<value displayText="60+" value="Age61_90" />
			<value displayText="90+" value="Age91_120" />
			<value displayText="120+" value="AgeOver120" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range."
			default="All">
			<value displayText="All" value="All" />
			<value displayText="$10+" value="$10+" />
			<value displayText="$50+" value="$50+" />
			<value displayText="$100+" value="$100+" />
			<value displayText="$1,000+" value="$1000+" />
			<value displayText="$5,000+" value="$5000+" />
			<value displayText="$10,000+" value="$10000+" />
			<value displayText="$100,000+" value="$100000+" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field."
			default="true">
			<value displayText="Resp Name" value="false" />
			<value displayText="Open Balance" value="true" />
		</extendedParameter>
	</extendedParameters>
</parameters>
',
ModifiedDate=GETDATE()
WHERE ReportID=24

UPDATE Report SET ReportParameters='<?xml version="1.0" encoding="utf-8" ?>
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
		<extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range."
			default="Current+">
			<value displayText="Current+" value="Current+" />
			<value displayText="30+" value="Age31_60" />
			<value displayText="60+" value="Age61_90" />
			<value displayText="90+" value="Age91_120" />
			<value displayText="120+" value="AgeOver120" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="BalanceRange" text="Balance:" description="Limits the report by the balance range."
			default="All">
			<value displayText="All" value="All" />
			<value displayText="$10+" value="$10+" />
			<value displayText="$50+" value="$50+" />
			<value displayText="$100+" value="$100+" />
			<value displayText="$1,000+" value="$1000+" />
			<value displayText="$5,000+" value="$5000+" />
			<value displayText="$10,000+" value="$10000+" />
			<value displayText="$100,000+" value="$100000+" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="VelocitySort" text="Sort By:" description="Sorts the report by field."
			default="true">
			<value displayText="Resp Name" value="false" />
			<value displayText="Open Balance" value="true" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="Responsibility" text="Responsibility:" description="Limits by currently assigned or ultimate responsibility."
			default="false">
			<value displayText="Currently Assigned" value="false" />
			<value displayText="Ultimate Responsibility" value="true" />
		</extendedParameter>
	</extendedParameters>
</parameters>
',
ModifiedDate=GETDATE()
WHERE ReportID=25

UPDATE Report SET ReportParameters='<?xml version="1.0" encoding="utf-8"?>
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
		<extendedParameter type="ComboBox" parameterName="AgeRange" text="A/R Age:" description="Limits the report by the A/R age range." default="All">
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
	</extendedParameters>
</parameters>',
ModifiedDate=GETDATE()
WHERE ReportID=17

GO

DECLARE @AcctActivityRptID INT

INSERT INTO Report(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportPath, ReportParameters, MenuName, PermissionValue)
VALUES(4, 8, '[[image[Practice.ReportsV2.Images.reports.gif]]]', 'Account Activity Report', 'This is a productivity report that shows a list of transactions for a period of time.',
'Report V2 Viewer','/BusinessManagerReports/rptAcctActivitySummary','<?xml version="1.0" encoding="utf-8" ?>
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
		<extendedParameter type="ServiceLocation" parameterName="LocationID" text="Service Location:" default="-1" ignore="-1" />
		<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
	</extendedParameters>
</parameters>','&Account Activity Report','ReadAccountActivityReport')

SET @AcctActivityRptID=@@IDENTITY

INSERT INTO ReportToSoftwareApplication(ReportID, SoftwareApplicationID, ModifiedDate)
VALUES(@AcctActivityRptID,'B',GETDATE())
INSERT INTO ReportToSoftwareApplication(ReportID, SoftwareApplicationID, ModifiedDate)
VALUES(@AcctActivityRptID,'M',GETDATE())

GO

DECLARE @MissedCopaysRptID INT

INSERT INTO Report(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportPath, ReportParameters, MenuName, PermissionValue)
VALUES(2, 15, '[[image[Practice.ReportsV2.Images.reports.gif]]]', 'Missed Copays', 'This report shows a list of encounters for which the patient did not pay the copay required by the primary insurance',
'Report V2 Viewer','/BusinessManagerReports/rptMissedCopays','<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="StartDate" toDateParameter="EndDate" text="Dates:"
			default="Today" forceDefault="true" />
		<basicParameter type="Date" parameterName="StartDate" text="From:" overrideMaxDate="true" />
		<basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="DateType" text="Date Type:" description="Limits the report by date type."
			default="D">
			<value displayText="Posting Date" value="P" />
			<value displayText="Date of Service" value="D" />
		</extendedParameter>
		<extendedParameter type="ComboBox" parameterName="EncounterStatusID" text="Encounter Status:" description="Limits the report by Encounter Status." default="-1">
			<value displayText="All" value="-1" />
			<value displayText="Approved" value="3" />
			<value displayText="Billed" value="5" />
			<value displayText="Collected" value="6" />
			<value displayText="Draft" value="1" />
			<value displayText="Submitted" value="2" />
			<value displayText="Rejected" value="4" />
		</extendedParameter>
	</extendedParameters>
</parameters>','&Missed Copays','ReadMissedCopays')

SET @MissedCopaysRptID=@@IDENTITY

INSERT INTO ReportToSoftwareApplication(ReportID, SoftwareApplicationID, ModifiedDate)
VALUES(@MissedCopaysRptID,'B',GETDATE())
INSERT INTO ReportToSoftwareApplication(ReportID, SoftwareApplicationID, ModifiedDate)
VALUES(@MissedCopaysRptID,'M',GETDATE())

GO

DECLARE @UnpaidInsuranceClaimsRptID INT

INSERT INTO Report(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportPath, ReportParameters, MenuName, PermissionValue)
VALUES(3, 21, '[[image[Practice.ReportsV2.Images.reports.gif]]]', 'Unpaid Insurance Claims', 'This report shows a list of unpaid insurance claims grouped by payer.',
'Report V2 Viewer','/BusinessManagerReports/rptUnpaidInsuranceClaims','<?xml version="1.0" encoding="utf-8" ?>
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
	</extendedParameters>
</parameters>','&Unpaid Insurance Claims','ReadUnpaidInsuranceClaimsReport')

SET @UnpaidInsuranceClaimsRptID=@@IDENTITY

INSERT INTO ReportToSoftwareApplication(ReportID, SoftwareApplicationID, ModifiedDate)
VALUES(@UnpaidInsuranceClaimsRptID,'B',GETDATE())
INSERT INTO ReportToSoftwareApplication(ReportID, SoftwareApplicationID, ModifiedDate)
VALUES(@UnpaidInsuranceClaimsRptID,'M',GETDATE())

GO

--Reorder Patient Reports
UPDATE Report SET DisplayOrder=5
WHERE Name='Patient Transactions Summary'
UPDATE Report SET DisplayOrder=10
WHERE Name='Patient Transactions Detail'
UPDATE Report SET DisplayOrder=15
WHERE Name='Patient Balance Summary'
UPDATE Report SET DisplayOrder=20
WHERE Name='Patient Balance Detail'
UPDATE Report SET DisplayOrder=25
WHERE Name='Patient History'
UPDATE Report SET DisplayOrder=30
WHERE Name='Patient Financial History'
UPDATE Report SET DisplayOrder=35
WHERE Name='Patient Detail'
UPDATE Report SET DisplayOrder=40
WHERE Name='Patient Referrals Summary'
UPDATE Report SET DisplayOrder=45
WHERE Name='Patient Referrals Detail'
GO

-------------------------------------------------------------------------------
-- Case 8805: DME billing 
-------------------------------------------------------------------------------
IF(NOT EXISTS(SELECT ProviderNumberTypeID FROM ProviderNumberType WHERE ANSIReferenceIdentificationQualifier = 'U3'))
BEGIN
    INSERT ProviderNumberType (ProviderNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder)
		VALUES (37, 'Unique Supplier Identification Number (USIN)', 'U3', 170)
END
GO
--------------------------------------------------------------
-- AMBULANCE SUPPORT
--------------------------------------------------------------
-- CREATE AmbulanceTransportReasonCode
CREATE TABLE [dbo].[AmbulanceTransportReasonCode](
	[Code] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Definition] [nchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_AmbulanceTransportReasonCode] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
--POPULATE AmbulanceTransportReasonCode
INSERT INTO [dbo].[AmbulanceTransportReasonCode]
           ([Code]
           ,[Definition])
     VALUES
           (
'A','Patient was transported to nearest facility for care of symptoms, complaints, or both. Can be used to indicate that the patient was transferred to a residential facility')
INSERT INTO [dbo].[AmbulanceTransportReasonCode]
           ([Code]
           ,[Definition])
     VALUES
           (
'B','Patient was transported for the benefit of a preferred physician')
INSERT INTO [dbo].[AmbulanceTransportReasonCode]
           ([Code]
           ,[Definition])
     VALUES
           (
'C','Patient was transported for the nearness of family members')
INSERT INTO [dbo].[AmbulanceTransportReasonCode]
           ([Code]
           ,[Definition])
     VALUES
           (
'D','Patient was transported for the care of a specialist or for availability of specialized equipment')
INSERT INTO [dbo].[AmbulanceTransportReasonCode]
           ([Code]
           ,[Definition])
     VALUES
           (
'E','Patient transferred to rehabilitation facility' )
GO

--CREATE AmbulanceTransportCode
CREATE TABLE [dbo].[AmbulanceTransportCode](
	[Code] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Definition] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_AmbulanceTransportCode] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

--POPULATE AmbulanceTransportCode
INSERT INTO [dbo].[AmbulanceTransportCode]
           ([Code]
           ,[Definition])
     VALUES
           (
'I','Initial Trip')
INSERT INTO [dbo].[AmbulanceTransportCode]
           ([Code]
           ,[Definition])
     VALUES
           (
'R','Return Trip')
INSERT INTO [dbo].[AmbulanceTransportCode]
           ([Code]
           ,[Definition])
     VALUES
           (
'T','Transfer Trip')
INSERT INTO [dbo].[AmbulanceTransportCode]
           ([Code]
           ,[Definition])
     VALUES
           (
'X','Round Trip')
GO
-- CREATE AmbulanceTransportInformation
CREATE TABLE [dbo].[AmbulanceTransportInformation](
	[TransportRecordID] [int] IDENTITY(1,1) NOT NULL,
	[Weight] DECIMAL(18,2) NULL,
	[AmbulanceTransportCode] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmbulanceTransportReasonCode] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Miles] DECIMAL(18,2) NULL,
	[RoundTripPurposeDescription] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StretcherPurposeDescription] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PickUp] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DropOff] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EncounterID] [int] NOT NULL,
 CONSTRAINT [PK_AmbulanceTransportInformation] PRIMARY KEY CLUSTERED 
(
	[TransportRecordID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AmbulanceTransportInformation]  WITH CHECK ADD  CONSTRAINT [FK_AmbulanceTransportInformation_Encounter] FOREIGN KEY([EncounterID])
REFERENCES [dbo].[Encounter] ([EncounterID])


----- CREATE TABLE AmbulanceCertificationCode
CREATE TABLE [dbo].[AmbulanceCertificationCode](
	[Code] [nchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Definition] [nchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NSFReference] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_AmbulanceCertficationCode] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

--- POPULATE  AmbulanceCertificationCode
INSERT INTO [dbo].[AmbulanceCertificationCode]
           ([Code]
           ,[Definition]
           ,[NSFReference])
     VALUES ('01',
           'Patient was admitted to a hospital', 'GA0-06.0')  

INSERT INTO [dbo].[AmbulanceCertificationCode]
           ([Code]
           ,[Definition]
           ,[NSFReference])
     VALUES
           (     '02',
'Patient was bed confined before the ambulance service', 'GA0-08.0')     

INSERT INTO [dbo].[AmbulanceCertificationCode]
           ([Code]
           ,[Definition]
           ,[NSFReference])
     VALUES
           (    '03',
'Patient was bed confined after the ambulance service', 'GA0-09.0')   
INSERT INTO [dbo].[AmbulanceCertificationCode]
           ([Code]
           ,[Definition]
           ,[NSFReference])
     VALUES
           ( '04',
'Patient was moved by stretcher', 'GA0-10.0')  
INSERT INTO [dbo].[AmbulanceCertificationCode]
           ([Code]
           ,[Definition]
           ,[NSFReference])
     VALUES
           (     '05',
'Patient was unconscious or in shock', 'GA0-11.0')        
INSERT INTO [dbo].[AmbulanceCertificationCode]
           ([Code]
           ,[Definition]
           ,[NSFReference])
     VALUES
           ('06',
'Patient was transported in an emergency situation', 'GA0-12.0')  
INSERT INTO [dbo].[AmbulanceCertificationCode]
           ([Code]
           ,[Definition]
           ,[NSFReference])
     VALUES
           ( '07',
'Patient had to be physically restrained', 'GA0-13.0')   
INSERT INTO [dbo].[AmbulanceCertificationCode]
           ([Code]
           ,[Definition]
           ,[NSFReference])
     VALUES
           ('08',
'Patient had visible hemorrhaging', 'GA0-14.0')   
INSERT INTO [dbo].[AmbulanceCertificationCode]
           ([Code]
           ,[Definition]
           ,[NSFReference])
     VALUES
           ('09',
'Ambulance service was medically necessary', 'GA0-16.0')   
INSERT INTO [dbo].[AmbulanceCertificationCode]
           ([Code]
           ,[Definition]
           ,[NSFReference])
     VALUES
           ('60', 
'Transportation Was To the Nearest Facility', 'GA0-24.0')
GO

-- CREATE AmbulanceCertificationInformation
CREATE TABLE [dbo].[AmbulanceCertificationInformation](
	[CertificationRecordID] [int] IDENTITY(1,1) NOT NULL,
	[AmbulanceCertificationCode] [nchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EncounterID] [int] NOT NULL,
 CONSTRAINT [PK_AmbulanceCertificationInformation] PRIMARY KEY CLUSTERED 
(
	[CertificationRecordID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AmbulanceCertificationInformation]  WITH CHECK ADD  CONSTRAINT [FK_AmbulanceCertificationInformation_AmbulanceCertficationCode] FOREIGN KEY([AmbulanceCertificationCode])
REFERENCES [dbo].[AmbulanceCertificationCode] ([Code])
GO
ALTER TABLE [dbo].[AmbulanceCertificationInformation]  WITH CHECK ADD  CONSTRAINT [FK_AmbulanceCertificationInformation_Encounter] FOREIGN KEY([EncounterID])
REFERENCES [dbo].[Encounter] ([EncounterID])
GO

-------------------------------------------------------------------------------
-- Case 8565: Add department table
-------------------------------------------------------------------------------
CREATE TABLE Department(
	DepartmentID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Department_DepartmentID
		PRIMARY KEY NONCLUSTERED,
	PracticeID INT NOT NULL,
	Name VARCHAR(125) NOT NULL, 
	Description VARCHAR(MAX) NULL, 
	CreatedDate datetime NOT NULL,
	CreatedUserID int NOT NULL,
	ModifiedDate datetime NOT NULL,
	ModifiedUserID int NOT NULL
	)
GO

ALTER TABLE [dbo].[Department] ADD 
	CONSTRAINT [DF_Department_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_Department_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_Department_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_Department_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO

-- Add foreign key to practice table
ALTER TABLE dbo.Department
	ADD CONSTRAINT FK_Department_Practice FOREIGN KEY
	(
		PracticeID
	) 
	REFERENCES dbo.Practice (PracticeID)

GO

-- Add new columns to the provider table
ALTER TABLE dbo.Doctor ADD
	DepartmentID INT NULL
GO	

-- Add foreign key to doctor table
ALTER TABLE dbo.Doctor
	ADD CONSTRAINT FK_Doctor_Department FOREIGN KEY
	(
		DepartmentID
	) 
	REFERENCES dbo.Department (DepartmentID)

GO


-------------------------------------------------------------------------------
-- Case 8978: Retrofit system to remove traces of old DiagnosisCodeDictionaryToEncounterTemplate table
-------------------------------------------------------------------------------

DROP TABLE DiagnosisCodeDictionaryToEncounterTemplate

GO

-------------------------------------------------------------------------------
-- Case 8989: Add support for EDI Claim Notes to Encounters
-------------------------------------------------------------------------------

--create the table
CREATE TABLE EDINoteReferenceCode
(Code char(3) not null PRIMARY KEY, Definition varchar(64) not null, ClaimOnly bit not null)

GO

--then insert all valid codes (from NTE Definition, page 247 of spec, page 488 for service line level - a subset)
INSERT INTO EDINoteReferenceCode VALUES ('ADD', 'Additional Information', 0)
INSERT INTO EDINoteReferenceCode VALUES ('CER', 'Certification Narrative', 1)		-- claim only
INSERT INTO EDINoteReferenceCode VALUES ('DCP', 'Goals, Rehabilitation Potential, or Discharge Plans', 0)
INSERT INTO EDINoteReferenceCode VALUES ('DGN', 'Diagnosis Description', 1)
INSERT INTO EDINoteReferenceCode VALUES ('PMT', 'Payment', 0)
INSERT INTO EDINoteReferenceCode VALUES ('TPO', 'Third Party Organization Notes', 0)

GO

--change encounter table to have new columns and to reference this new table
ALTER TABLE Encounter ADD EDIClaimNoteReferenceCode char(3) NULL
CONSTRAINT FK_Encounter_EDINoteReferenceCode FOREIGN KEY (EDIClaimNoteReferenceCode)
REFERENCES EDINoteReferenceCode(Code)
GO

ALTER TABLE Encounter ADD EDIClaimNote varchar(1600) NULL 
GO


--change claim table to have new columns and to reference this new table
ALTER TABLE Claim ADD EDIServiceNoteReferenceCode char(3) NULL
CONSTRAINT FK_ClaimService_EDINoteReferenceCode FOREIGN KEY (EDIServiceNoteReferenceCode)
REFERENCES EDINoteReferenceCode(Code)
GO

ALTER TABLE Claim ADD EDIServiceNote varchar(80) NULL 
GO

-------------------------------------------------------------------------------
-- Case 9006: Add Payment Method type of Credit Card
-------------------------------------------------------------------------------

INSERT INTO PaymentMethodCode (PaymentMethodCode, Description)
VALUES ('R','Credit Card')
GO

---------------------------------------------------------------------------------------------
---- BILLING FORM  HCFA WITH AMBULANCE SUPPORT
----------------------------------------------------------------------------------------------
UPDATE BillingForm
   SET [FormType] = 'HCFA'
      ,[FormName] = 'Standard'
      ,[Transform] = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500">
			<page pageId="CMS1500.1">
				<BillID>
					<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
				</BillID>
				<data id="CMS1500.1.1_Medicare">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Medicaid">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Champus">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''CH''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Champva">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''VA''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_GroupHealthPlan"></data>
				<data id="CMS1500.1.1_Feca"></data>
				<data id="CMS1500.1.1_Other">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MB'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MC'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''CH'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''VA''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_aIDNumber">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
							<xsl:choose>
								<!-- For non-worker''s comp cases the DependentPolicyNumber is printed if the Policy Number is blank -->
								<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!-- For worker''s comp cases the patient SSN is printed if the Policy Number is blank -->
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSSN1'']" />
								</xsl:otherwise>
							</xsl:choose>
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
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
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
				<xsl:choose>
					<xsl:when test="not(data[@id=''CMS1500.1.IsWorkersComp1''] = 1 and data[@id=''CMS1500.1.HolderThroughEmployer1''] = 1)">
						<!-- If not worker''s comp OR is worker''s comp and holder through employer is not set -->
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
					</xsl:when>
					<xsl:otherwise>
						<!-- If this is worker''s comp and the holder through employer is checked automatically select other -->
						<data id="CMS1500.1.6_Self" />
						<data id="CMS1500.1.6_Spouse" />
						<data id="CMS1500.1.6_Child" />
						<data id="CMS1500.1.6_Other">X</data>
					</xsl:otherwise>
				</xsl:choose>
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
									<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
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
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
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
				<data id="CMS1500.1.1_9Local">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
							<!-- Not worker''s comp -->
							<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
						</xsl:when>
						<xsl:otherwise>
							<!-- Worker''s comp will display the adjuster''s name if the local use data isn''t available -->
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.LocalUseData1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterLastName1'']) > 0 or string-length(data[@id=''CMS1500.1.AdjusterFirstName1'']) > 0">
										<xsl:text>ATTN: </xsl:text>
										<xsl:value-of select="data[@id=''CMS1500.1.AdjusterFirstName1'']" />
										<xsl:text xml:space="preserve"> </xsl:text>
										<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterMiddleName1'']) > 0">
											<xsl:value-of select="substring(data[@id=''CMS1500.1.AdjusterMiddleName1''],1,1)" />
											<xsl:text>. </xsl:text>
										</xsl:if>
										<xsl:value-of select="data[@id=''CMS1500.1.AdjusterLastName1'']" />
										<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterSuffix1'']) > 0">
											<xsl:text xml:space="preserve"> </xsl:text>
											<xsl:value-of select="data[@id=''CMS1500.1.AdjusterSuffix1'']" />
										</xsl:if>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</data>
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
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB'' or data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityCLIANumber1'']) > 0 and (//data[@id=''CMS1500.1.TypeOfServiceCode1''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode2''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode3''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode4''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode5''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode6''] = ''5'')">
									<xsl:value-of select="data[@id=''CMS1500.1.FacilityCLIANumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				</data>
				<data id="CMS1500.1.3_1ProviderName">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.HasSupervisingProvider1''] != 1">
							<!-- When there isn''t a supervising provider display the rendering provider -->
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<!-- Show the supervising provider display -->
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SupervisingProviderMiddleName1''], 1, 1)" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SupervisingProviderDegree1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderDegree1'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_1Date">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.3_2Name">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>FROM: </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PickUp1'']" />
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2Street">
				<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>TO: </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DropOff1'']" />
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2CityStateZip">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
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
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2FacilityInfo"></data>
				<data id="CMS1500.1.3_3Provider">
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
				<data id="CMS1500.1.dExtra1">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier21'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier31'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier41'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount1'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT1"> </data>
				<data id="CMS1500.1.iEMG1"> </data>
				<data id="CMS1500.1.jCOB1"> </data>
				<data id="CMS1500.1.kLocal1">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				<data id="CMS1500.1.dExtra2">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier22'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier32'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier42'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount2'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT2"> </data>
				<data id="CMS1500.1.iEMG2"> </data>
				<data id="CMS1500.1.jCOB2"> </data>
				<data id="CMS1500.1.kLocal2">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				<data id="CMS1500.1.dExtra3">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier23'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier33'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier43'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount3'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT3"> </data>
				<data id="CMS1500.1.iEMG3"> </data>
				<data id="CMS1500.1.jCOB3"> </data>
				<data id="CMS1500.1.kLocal3">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				<data id="CMS1500.1.dExtra4">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier24'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier34'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier44'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount4'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT4"> </data>
				<data id="CMS1500.1.iEMG4"> </data>
				<data id="CMS1500.1.jCOB4"> </data>
				<data id="CMS1500.1.kLocal4">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				<data id="CMS1500.1.dExtra5">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier25'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier35'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier45'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount5'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT5"> </data>
				<data id="CMS1500.1.iEMG5"> </data>
				<data id="CMS1500.1.jCOB5"> </data>
				<data id="CMS1500.1.kLocal5">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				<data id="CMS1500.1.dExtra6">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier26'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier36'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier46'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount6'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT6"> </data>
				<data id="CMS1500.1.iEMG6"> </data>
				<data id="CMS1500.1.jCOB6"> </data>
				<data id="CMS1500.1.kLocal6">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
      ,[PrintingFormID] = 1
      ,[MaxProcedures] = 6
      ,[MaxDiagnosis] = 4
 WHERE BillingFormID = 1

---------------------------
UPDATE BillingForm
   SET [FormType] = 'HCFA'
      ,[FormName] = 'Standard (with Facility ID Box 32)'
      ,[Transform] = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500">
			<page pageId="CMS1500.1">
				<BillID>
					<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
				</BillID>
				<data id="CMS1500.1.1_Medicare">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Medicaid">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Champus">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''CH''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_Champva">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''VA''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_GroupHealthPlan"></data>
				<data id="CMS1500.1.1_Feca"></data>
				<data id="CMS1500.1.1_Other">
					<xsl:if test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MB'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''MC'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''CH'' and data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] != ''VA''">
						<xsl:text>X</xsl:text>
					</xsl:if>
				</data>
				<data id="CMS1500.1.1_aIDNumber">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
							<xsl:choose>
								<!-- For non-worker''s comp cases the DependentPolicyNumber is printed if the Policy Number is blank -->
								<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!-- For worker''s comp cases the patient SSN is printed if the Policy Number is blank -->
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSSN1'']" />
								</xsl:otherwise>
							</xsl:choose>
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
					<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
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
				<xsl:choose>
					<xsl:when test="not(data[@id=''CMS1500.1.IsWorkersComp1''] = 1 and data[@id=''CMS1500.1.HolderThroughEmployer1''] = 1)">
						<!-- If not worker''s comp OR is worker''s comp and holder through employer is not set -->
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
					</xsl:when>
					<xsl:otherwise>
						<!-- If this is worker''s comp and the holder through employer is checked automatically select other -->
						<data id="CMS1500.1.6_Self" />
						<data id="CMS1500.1.6_Spouse" />
						<data id="CMS1500.1.6_Child" />
						<data id="CMS1500.1.6_Other">X</data>
					</xsl:otherwise>
				</xsl:choose>
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
									<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
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
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
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
				<data id="CMS1500.1.1_9Local">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.IsWorkersComp1''] != 1">
							<!-- Not worker''s comp -->
							<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
						</xsl:when>
						<xsl:otherwise>
							<!-- Worker''s comp will display the adjuster''s name if the local use data isn''t available -->
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.LocalUseData1'']) > 0">
									<xsl:value-of select="data[@id=''CMS1500.1.LocalUseData1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterLastName1'']) > 0 or string-length(data[@id=''CMS1500.1.AdjusterFirstName1'']) > 0">
										<xsl:text>ATTN: </xsl:text>
										<xsl:value-of select="data[@id=''CMS1500.1.AdjusterFirstName1'']" />
										<xsl:text xml:space="preserve"> </xsl:text>
										<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterMiddleName1'']) > 0">
											<xsl:value-of select="substring(data[@id=''CMS1500.1.AdjusterMiddleName1''],1,1)" />
											<xsl:text>. </xsl:text>
										</xsl:if>
										<xsl:value-of select="data[@id=''CMS1500.1.AdjusterLastName1'']" />
										<xsl:if test="string-length(data[@id=''CMS1500.1.AdjusterSuffix1'']) > 0">
											<xsl:text xml:space="preserve"> </xsl:text>
											<xsl:value-of select="data[@id=''CMS1500.1.AdjusterSuffix1'']" />
										</xsl:if>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</data>
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
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MB'' or data[@id=''CMS1500.1.PayerInsuranceProgramCode1''] = ''MC''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityCLIANumber1'']) > 0 and (//data[@id=''CMS1500.1.TypeOfServiceCode1''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode2''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode3''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode4''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode5''] = ''5'' or //data[@id=''CMS1500.1.TypeOfServiceCode6''] = ''5'')">
									<xsl:value-of select="data[@id=''CMS1500.1.FacilityCLIANumber1'']" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				</data>
				<data id="CMS1500.1.3_1ProviderName">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.HasSupervisingProvider1''] != 1">
							<!-- When there isn''t a supervising provider display the rendering provider -->
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<!-- Show the supervising provider display -->
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SupervisingProviderMiddleName1''], 1, 1)" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SupervisingProviderDegree1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderDegree1'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_1Date">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
				</data>
				<data id="CMS1500.1.3_2Name">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>FROM: </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PickUp1'']" />
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2Street">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>TO: </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.DropOff1'']" />
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2CityStateZip">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.AddOns1''] = 4">
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:otherwise>
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
						</xsl:otherwise>
					</xsl:choose>
				</data>
				<data id="CMS1500.1.3_2FacilityInfo"></data>
				<data id="CMS1500.1.3_3Provider">
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
				<data id="CMS1500.1.dExtra1">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier21'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier31'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier41'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount1'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT1"> </data>
				<data id="CMS1500.1.iEMG1"> </data>
				<data id="CMS1500.1.jCOB1"> </data>
				<data id="CMS1500.1.kLocal1">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				<data id="CMS1500.1.dExtra2">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier22'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier32'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier42'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount2'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT2"> </data>
				<data id="CMS1500.1.iEMG2"> </data>
				<data id="CMS1500.1.jCOB2"> </data>
				<data id="CMS1500.1.kLocal2">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier2'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				<data id="CMS1500.1.dExtra3">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier23'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier33'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier43'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount3'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT3"> </data>
				<data id="CMS1500.1.iEMG3"> </data>
				<data id="CMS1500.1.jCOB3"> </data>
				<data id="CMS1500.1.kLocal3">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier3'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				<data id="CMS1500.1.dExtra4">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier24'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier34'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier44'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount4'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT4"> </data>
				<data id="CMS1500.1.iEMG4"> </data>
				<data id="CMS1500.1.jCOB4"> </data>
				<data id="CMS1500.1.kLocal4">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier4'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				<data id="CMS1500.1.dExtra5">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier25'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier35'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier45'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount5'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT5"> </data>
				<data id="CMS1500.1.iEMG5"> </data>
				<data id="CMS1500.1.jCOB5"> </data>
				<data id="CMS1500.1.kLocal5">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier5'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
						</xsl:otherwise>
					</xsl:choose>
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
				<data id="CMS1500.1.dExtra6">
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier26'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier36'']" />
					<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier46'']" />
				</data>
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
						<xsl:value-of select="data[@id=''CMS1500.1.ServiceUnitCount6'']" />
					</data>
				</xsl:if>
				<data id="CMS1500.1.hEPSDT6"> </data>
				<data id="CMS1500.1.iEMG6"> </data>
				<data id="CMS1500.1.jCOB6"> </data>
				<data id="CMS1500.1.kLocal6">
					<xsl:choose>
						<xsl:when test="string-length(data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']) > 0">
							<xsl:value-of select="data[@id=''CMS1500.1.SupervisingProviderLocalIdentifier6'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
						</xsl:otherwise>
					</xsl:choose>
				</data>
			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
      ,[PrintingFormID] = 1
      ,[MaxProcedures] = 6
      ,[MaxDiagnosis] = 4
 WHERE BillingFormID = 5

GO

--Add Import Table and Column MetaData to Tables
-- Run this one time script on all superbill_0xxx databases, with the exception of superbill_0001_prod 
-- (These tables and columns have been added to both superbill_0001_dev and superbill_0001_prod databases before ActionPMR import)
-- 02202306

--DECLARE @DB char(100)
--SET @DB = DB_NAME()
--
--IF (@DB <> 'Superbill_0001_prod' AND @DB <> 'Superbill_0001_dev')
--	BEGIN
			-- Create VendorImport table to keep track of imported data

			IF (OBJECT_ID('dbo.VendorImport') IS NOT NULL) AND
			(OBJECTPROPERTY(OBJECT_ID('dbo.VendorImport'),'IsTable')=1) 
				PRINT 'VendorImport table exists'
			ELSE
				BEGIN
					EXEC('
					CREATE TABLE VendorImport
					(
						VendorImportID int IDENTITY(1,1)	NOT NULL,
						VendorName varchar(100)			NOT NULL,
						VendorFormat varchar(50)		NOT NULL,		-- e.g. MediEMR, MedicalManager
						DateCreated datetime			NOT NULL 
							DEFAULT GETDATE(),
						Notes varchar(100)			NULL
					)
					')
					PRINT 'Created VendorImport table'


				END



			--Create new table to keep track of VendorImportStatus for each imported record

			IF (OBJECT_ID('dbo.VendorImportStatus') IS NOT NULL) AND
			(OBJECTPROPERTY(OBJECT_ID('dbo.VendorImportStatus'),'IsTable')=1) 
				PRINT 'VendorImportStatus table exists'
			ELSE
				BEGIN
					EXEC('
					CREATE TABLE VendorImportStatus
					(
						VendorImportStatusID int IDENTITY(1,1)	NOT NULL,
						VendorImportID 		int		NOT NULL,	-- VendorImportID in VendorImport table
						VendorID		varchar(50)	NOT NULL,		-- record id, e.g. TrackID in Medi-EMR
						Status 			int		NOT NULL,		-- 1 - success; 0 - failure;
						DateCreated		datetime	NOT NULL
							DEFAULT GETDATE()
					)
					')
					PRINT 'Created VendorImportStatus table'

				END


			-- Add VendorID (if it does not exist) and VendorImportID columns to Patient, PatientCase, InsuranceCompany, InsuranceCompanyPlan, InsurancePolicy,
			-- ReferringPhysician, Doctor, Encounter, EncounterDiagnosis, and EncounterProcedure tables


			-- Patient

			IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='Patient')
			BEGIN
				IF NOT EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				where so.xtype='U' AND sc.name='VendorImportID' AND so.name='Patient')
				EXEC ('ALTER TABLE Patient 
				ADD VendorImportID int NULL')
			END
			ELSE
			BEGIN
				EXEC('ALTER TABLE Patient 
				ADD VendorID varchar(50) NULL, 
				VendorImportID int NULL')
			END



			-- PatientCase

			IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='PatientCase')
			BEGIN
				IF NOT EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				where so.xtype='U' AND sc.name='VendorImportID' AND so.name='PatientCase')
				EXEC('ALTER TABLE PatientCase 
				ADD VendorImportID int NULL')
			END
			ELSE
			BEGIN
				EXEC('ALTER TABLE PatientCase 
				ADD VendorID varchar(50) NULL, 
				VendorImportID int NULL')
			END



			-- InsuranceCompany

			IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='InsuranceCompany')
			BEGIN
				IF NOT EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				where so.xtype='U' AND sc.name='VendorImportID' AND so.name='InsuranceCompany')
				EXEC('ALTER TABLE InsuranceCompany 
				ADD VendorImportID int NULL')
			END
			ELSE
			BEGIN
				EXEC('ALTER TABLE InsuranceCompany 
				ADD VendorID varchar(50) NULL, 
				VendorImportID int NULL')
			END



			-- InsuranceCompanyPlan

			IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='InsuranceCompanyPlan ')
			BEGIN
				IF NOT EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				where so.xtype='U' AND sc.name='VendorImportID' AND so.name='InsuranceCompanyPlan')
				EXEC('ALTER TABLE InsuranceCompanyPlan 
				ADD VendorImportID int NULL')
			END
			ELSE
			BEGIN
				EXEC('ALTER TABLE InsuranceCompanyPlan  
				ADD VendorID varchar(50) NULL, 
				VendorImportID int NULL')
			END



			-- InsurancePolicy

			IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='InsurancePolicy')
			BEGIN
				IF NOT EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				where so.xtype='U' AND sc.name='VendorImportID' AND so.name='InsurancePolicy')
				EXEC('ALTER TABLE InsurancePolicy 
				ADD VendorImportID int NULL')
			END
			ELSE
			BEGIN
				EXEC('ALTER TABLE InsurancePolicy 
				ADD VendorID varchar(50) NULL, 
				VendorImportID int NULL')
			END



			-- ReferringPhysician

			IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='ReferringPhysician')
			BEGIN
				IF NOT EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				where so.xtype='U' AND sc.name='VendorImportID' AND so.name='ReferringPhysician')
				EXEC('ALTER TABLE ReferringPhysician 
				ADD VendorImportID int NULL')
			END
			ELSE
			BEGIN
				EXEC('ALTER TABLE ReferringPhysician
				ADD VendorID varchar(50) NULL, 
				VendorImportID int NULL')
			END



			-- Doctor

			IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='Doctor')
			BEGIN
				IF NOT EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				where so.xtype='U' AND sc.name='VendorImportID' AND so.name='Doctor')
				EXEC('ALTER TABLE Doctor 
				ADD VendorImportID int NULL')
			END
			ELSE
			BEGIN
				EXEC('ALTER TABLE Doctor 
				ADD VendorID varchar(50) NULL, 
				VendorImportID int NULL')
			END



			-- Encounter

			IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='Encounter')
			BEGIN
				IF NOT EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				where so.xtype='U' AND sc.name='VendorImportID' AND so.name='Encounter')
				EXEC('ALTER TABLE Encounter
				ADD VendorImportID int NULL')
			END
			ELSE
			BEGIN
				EXEC('ALTER TABLE Encounter 
				ADD VendorID varchar(50) NULL, 
				VendorImportID int NULL')
			END



			-- EncounterDiagnosis

			IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='EncounterDiagnosis')

			BEGIN
				IF NOT EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				where so.xtype='U' AND sc.name='VendorImportID' AND so.name='EncounterDiagnosis')
				EXEC('ALTER TABLE EncounterDiagnosis
				ADD VendorImportID int NULL')
			END
			ELSE
			BEGIN
				EXEC('ALTER TABLE EncounterDiagnosis 
				ADD VendorID varchar(50) NULL, 
				VendorImportID int NULL')
			END



			-- EncounterProcedure

			IF EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				WHERE so.xtype='U' AND sc.name='VendorID' AND so.name='EncounterProcedure')
			BEGIN
				IF NOT EXISTS(SELECT * FROM sysobjects so inner join syscolumns sc
				on so.id=sc.id
				where so.xtype='U' AND sc.name='VendorImportID' AND so.name='EncounterProcedure')
				EXEC('ALTER TABLE EncounterProcedure 
				ADD VendorImportID int NULL')
			END
			ELSE
			BEGIN
				EXEC('ALTER TABLE EncounterProcedure 
				ADD VendorID varchar(50) NULL, 
				VendorImportID int NULL')
			END
--
--	END
GO

--CASE 2080
ALTER TABLE Doctor ADD [FaxNumber] VARCHAR(10), [FaxNumberExt] VARCHAR(10)
GO

/*=============================================================================	
	Case 9029 - Merge Provider and Referring Provider tables
=============================================================================*/

ALTER TABLE dbo.Doctor ADD
	OrigReferringPhysicianID int NULL,
	[External] bit NULL
GO

ALTER TABLE dbo.Doctor 
	ALTER COLUMN [TaxonomyCode] CHAR(10) NULL
GO

/* Update existing doctor's external flag to "0" or "Internal"... */

UPDATE	dbo.Doctor
SET		[External] = 0

GO

/* Create a table for logging the ReferringPhysician to Doctor table migration... */

CREATE TABLE dbo.ReferringPhysicianToDoctorMigrationLog
	(
	LogEntryID int NOT NULL IDENTITY (1, 1),
	SrcReferringPhysicianID int NULL,
	TrgtDoctorID int NULL,
	SrcUPIN varchar(50) NULL,
	TrgtUPINProviderNumberID int NULL,
	SrcOtherID varchar(50) NULL,
	TrgtOtherProviderNumberID int NULL
	)  ON [PRIMARY]
GO

ALTER TABLE dbo.ReferringPhysicianToDoctorMigrationLog ADD CONSTRAINT
	PK_Table_1 PRIMARY KEY CLUSTERED 
	(
	LogEntryID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

/* Copy existing referring physicians into the Doctor table... */

	INSERT INTO [dbo].[Doctor]
           ([PracticeID]
           ,[Prefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[SSN]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[HomePhone]
           ,[HomePhoneExt]
           ,[WorkPhone]
           ,[WorkPhoneExt]
           ,[PagerPhone]
           ,[PagerPhoneExt]
           ,[MobilePhone]
           ,[MobilePhoneExt]
           ,[FaxNumber]
           ,[FaxNumberExt]
           ,[DOB]
           ,[EmailAddress]
           ,[Notes]
           ,[ActiveDoctor]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[UserID]
           ,[Degree]
           ,[DefaultEncounterTemplateID]
           ,[TaxonomyCode]
           ,[VendorID]
           ,[VendorImportID]
           ,[DepartmentID]
           ,[OrigReferringPhysicianID]
		   ,[External])
    SELECT
           RP.[PracticeID]
           , RP.[Prefix]
           , RP.[FirstName]
           , RP.[MiddleName]
           , RP.[LastName]
           , RP.[Suffix]
           , NULL
           , RP.[AddressLine1]
           , RP.[AddressLine2]
           , RP.[City]
           , RP.[State]
           , RP.[Country]
           , RP.[ZipCode]
           , NULL
           , NULL
           , RP.[WorkPhone]
           , RP.[WorkPhoneExt]
           , NULL
           , NULL
           , NULL 
           , NULL
           , RP.[FaxPhone]
           , RP.[FaxPhoneExt]
           , NULL
           , NULL
           , CASE 
				WHEN ((RP.OtherID IS NOT NULL) AND (RP.OtherID <> '')) THEN 'Additional provider information: ' + RP.OtherID
				ELSE NULL
			 END
           , 1
           , RP.[CreatedDate]
           , RP.[CreatedUserID]
           , RP.[ModifiedDate]
           , RP.[ModifiedUserID]
           , NULL
           , RP.[Degree]
           , NULL
           , '0000000001'
           , RP.[VendorID]
           , RP.[VendorImportID]
           , NULL
           , RP.[ReferringPhysicianID]
		   , 1
	FROM
			ReferringPhysician RP
GO

/* Update ReferringPhysicianToDoctorMigrationLog... */

INSERT INTO [dbo].[ReferringPhysicianToDoctorMigrationLog]
           ([SrcReferringPhysicianID]
           ,[TrgtDoctorID])
SELECT
		RP.ReferringPhysicianID
		, D.DoctorID
FROM
		Doctor D
		JOIN ReferringPhysician RP ON RP.ReferringPhysicianID = D.OrigReferringPhysicianID
GO

/* Create UPIN provider numbers from the UPIN field on ReferringPhysician... */

INSERT INTO dbo.[ProviderNumber]
	( DoctorID
	, ProviderNumberTypeID
	, ProviderNumber
	, AttachConditionsTypeID )
SELECT
	D.DoctorID
	, 25
	, RP.UPIN
	, 1
FROM
	Doctor D
	JOIN ReferringPhysician RP ON RP.ReferringPhysicianID = D.OrigReferringPhysicianID
WHERE
	RP.UPIN IS NOT NULL
	AND RP.UPIN <> ''

GO

/* Update ReferringPhysicianToDoctorMigrationLog... Record UPIN migration... */

UPDATE [dbo].[ReferringPhysicianToDoctorMigrationLog]
SET		SrcUPIN = RP.UPIN
        , TrgtUPINProviderNumberID = UPIN.ProviderNumberID
FROM
		[ReferringPhysicianToDoctorMigrationLog] L
		INNER JOIN ReferringPhysician RP 
			ON RP.ReferringPhysicianID = L.SrcReferringPhysicianID
		LEFT OUTER JOIN ProviderNumber UPIN 
			ON UPIN.DoctorID = L.TrgtDoctorID
			AND UPIN.ProviderNumberTypeID = 25 --> UPIN
GO

/* Create Medicaid Provider Number from the OtherID field on ReferringPhysician... */

INSERT INTO dbo.[ProviderNumber]
	( DoctorID
	, ProviderNumberTypeID
	, ProviderNumber
	, AttachConditionsTypeID )
SELECT
	D.DoctorID
	, 24
	, REVERSE(LEFT(REVERSE(RP.OtherID), CHARINDEX(' ', REVERSE(RP.OtherID))))
	, 1
FROM
	Doctor D
	JOIN ReferringPhysician RP ON RP.ReferringPhysicianID = D.OrigReferringPhysicianID
WHERE
	((RP.OtherID LIKE '%medicaid%') OR (RP.OtherID LIKE '%MCD%') OR (RP.OtherID LIKE '%mediciad%'))
	AND REVERSE(LEFT(REVERSE(RP.OtherID), CHARINDEX(' ', REVERSE(RP.OtherID)))) <> ''
GO

/* Update ReferringPhysicianToDoctorMigrationLog... Record "OtherID" migration... */

UPDATE [dbo].[ReferringPhysicianToDoctorMigrationLog]
SET		SrcOtherID = RP.OtherID
        , TrgtOtherProviderNumberID = PN.ProviderNumberID
FROM
		[ReferringPhysicianToDoctorMigrationLog] L
		INNER JOIN ReferringPhysician RP 
			ON RP.ReferringPhysicianID = L.SrcReferringPhysicianID
		LEFT OUTER JOIN ProviderNumber PN 
			ON PN.DoctorID = L.TrgtDoctorID
			AND PN.ProviderNumberTypeID <> 25 --> Other than UPIN
GO

/* Update the ReferringPhysicianID column on Encounter to point to the referring physicians in Doctor... */

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Encounter_ReferringPhysician]') AND parent_object_id = OBJECT_ID(N'[dbo].[Encounter]'))
ALTER TABLE [dbo].[Encounter] DROP CONSTRAINT [FK_Encounter_ReferringPhysician]
GO

DISABLE TRIGGER [tr_Encounter_MaintainPaymentsOnEncounterApproved] ON Encounter
GO

UPDATE	[dbo].[Encounter]
SET		ReferringPhysicianID = D.DoctorID
FROM	[dbo].[Encounter] E
		JOIN Doctor D ON D.OrigReferringPhysicianID = E.ReferringPhysicianID
GO

ENABLE TRIGGER [tr_Encounter_MaintainPaymentsOnEncounterApproved] ON Encounter
GO

ALTER TABLE [dbo].[Encounter]  WITH CHECK ADD  CONSTRAINT [FK_Encounter_ReferringPhysician] FOREIGN KEY([ReferringPhysicianID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO

/* Update the ReferringPhysicianID column on Patient to point to the referring physicians in Doctor... */

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Patient_ReferringPhysician]') AND parent_object_id = OBJECT_ID(N'[dbo].[Patient]'))
ALTER TABLE [dbo].[Patient] DROP CONSTRAINT [FK_Patient_ReferringPhysician]
GO

UPDATE	[dbo].[Patient]
SET		ReferringPhysicianID = D.DoctorID
FROM	[dbo].[Patient] P
		JOIN Doctor D ON D.OrigReferringPhysicianID = P.ReferringPhysicianID
GO

ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_ReferringPhysician] FOREIGN KEY([ReferringPhysicianID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO

/* Update the PrimaryCarePhysicianID column on Patient to point to the physicians in Doctor... */

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Patient_PrimaryCarePhysicianID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Patient]'))
ALTER TABLE [dbo].[Patient] DROP CONSTRAINT [FK_Patient_PrimaryCarePhysicianID]
GO

UPDATE	[dbo].[Patient]
SET		PrimaryCarePhysicianID = D.DoctorID
FROM	[dbo].[Patient] P
		JOIN Doctor D ON D.OrigReferringPhysicianID = P.PrimaryCarePhysicianID
GO

ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_PrimaryCarePhysicianID] FOREIGN KEY([PrimaryCarePhysicianID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO

/* Update the ReferringPhysicianID column on PatientCase to point to the referring physicians in Doctor... */

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PatientCase_ReferringPhysicianID]') AND parent_object_id = OBJECT_ID(N'[dbo].[PatientCase]'))
ALTER TABLE [dbo].[PatientCase] DROP CONSTRAINT [FK_PatientCase_ReferringPhysicianID]
GO

UPDATE	dbo.PatientCase
SET		ReferringPhysicianID = D.DoctorID
FROM	[dbo].PatientCase PC
		JOIN Doctor D ON D.OrigReferringPhysicianID = PC.ReferringPhysicianID
GO

ALTER TABLE [dbo].[PatientCase]  WITH CHECK ADD  CONSTRAINT [FK_PatientCase_ReferringPhysicianID] FOREIGN KEY([ReferringPhysicianID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO

/* Drop the ReferringPhysician table... */
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReferringPhysician_Practice]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReferringPhysician]'))
ALTER TABLE [dbo].[ReferringPhysician] DROP CONSTRAINT [FK_ReferringPhysician_Practice]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReferringPhysician]') AND type in (N'U'))
DROP TABLE [dbo].[ReferringPhysician]
GO

/*=============================================================================	
	Case 8554 - Adding default adjustment code to the insurance company
=============================================================================*/
ALTER TABLE InsuranceCompany add DefaultAdjustmentCode varchar(10) null
GO
ALTER TABLE InsuranceCompany 
	ADD CONSTRAINT FK_InsuranceCompanyToAdjustment 
FOREIGN KEY (DefaultAdjustmentCode)
REFERENCES adjustment(AdjustmentCode)
GO

ALTER TABLE Payment ADD DefaultAdjustmentCode varchar(10)
GO
ALTER TABLE Payment ADD CONSTRAINT FK_PaymentToAdjustment 
FOREIGN KEY (DefaultAdjustmentCode)
REFERENCES Adjustment(AdjustmentCode)
GO


/*=============================================================================	
	Case 9089 - Add Modifiers to the handheld encounter
=============================================================================*/
ALTER TABLE handheldencounterdetail 
	ADD Modifier1 varchar(16) null,
	 Modifier2 varchar(16) null,
	 Modifier3 varchar(16) null,
	 Modifier4 varchar(16) null


ALTER TABLE dbo.HandheldEncounterDetail
	ADD CONSTRAINT FK_HandheldEncounterDetail_To_ProcedureModifier1 FOREIGN KEY
	(
		Modifier1
	) 
	REFERENCES dbo.ProcedureModifier (ProcedureModifierCode)

GO
ALTER TABLE dbo.HandheldEncounterDetail
	ADD CONSTRAINT FK_HandheldEncounterDetail_To_ProcedureModifier2 FOREIGN KEY
	(
		Modifier2
	) 
	REFERENCES dbo.ProcedureModifier (ProcedureModifierCode)

GO

ALTER TABLE dbo.HandheldEncounterDetail
	ADD CONSTRAINT FK_HandheldEncounterDetail_To_ProcedureModifier3 FOREIGN KEY
	(
		Modifier3
	) 
	REFERENCES dbo.ProcedureModifier (ProcedureModifierCode)
GO

ALTER TABLE dbo.HandheldEncounterDetail
	ADD CONSTRAINT FK_HandheldEncounterDetail_To_ProcedureModifier4 FOREIGN KEY
	(
		Modifier4
	) 
	REFERENCES dbo.ProcedureModifier (ProcedureModifierCode)
GO


--ROLLBACK
--COMMIT
