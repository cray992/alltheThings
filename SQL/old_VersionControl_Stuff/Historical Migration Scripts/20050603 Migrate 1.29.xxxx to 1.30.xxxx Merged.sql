/*

DATABASE UPDATE SCRIPT

v1.29.xxxx to v1.30.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------


---------------------------------------------------------------------------------------
--case 5348 - Move the Patient selector to the main screen from the Customize task for Patient Details report.

update	Report
set	ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please select a Patient to display a report." 

refreshOnParameterChange="true">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
	        <basicParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	</basicParameters>
</parameters>'
where	Name = 'Patient Detail'


---------------------------------------------------------------------------------------
--case 5446 - Modify data model to include InsuranceCompany table

--Create InsuranceCompany Table:
CREATE TABLE InsuranceCompany (
	-- fields that fundamentally belong to this table:
	[InsuranceCompanyID] [int] IDENTITY (1, 1) NOT NULL,
	[InsuranceCompanyName] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	-- fields that are describing the Company in better detail:
	[AddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Country] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactPrefix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactFirstName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactMiddleName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactLastName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactSuffix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FaxExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	-- HCFA and EClaims properties:
	[BillSecondaryInsurance] [bit] NOT NULL ,
	[EClaimsAccepts] [bit] NOT NULL ,
	[BillingFormID] INT NOT NULL,
	[InsuranceProgramCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HCFADiagnosisReferenceFormatCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HCFASameAsInsuredFormatCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LocalUseFieldTypeCode] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ReviewCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ProviderNumberTypeID] [int] NULL ,
	[GroupNumberTypeID] [int] NULL ,
	[LocalUseProviderNumberTypeID] [int] NULL ,

	-- migration convenience fields:
	[CompanyTextID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	-- linkage:
	[ClearinghousePayerID] [int] NULL ,

	-- service fields:
	[CreatedPracticeID] [int] NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[KareoInsuranceCompanyID] [int] NULL ,
	[KareoLastModifiedDate] [datetime] NULL ,
	[RecordTimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InsuranceCompany] ADD 
	CONSTRAINT [DF_InsuranceCompany_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_InsuranceCompany_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_InsuranceCompany_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_InsuranceCompany_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID],
	CONSTRAINT [DF_InsuranceCompany_InsuranceProgramCode] DEFAULT ('09') FOR [InsuranceProgramCode],
	CONSTRAINT [DF_InsuranceCompany_HCFADiagnosisReferenceFormatCode] DEFAULT ('C') FOR [HCFADiagnosisReferenceFormatCode],
	CONSTRAINT [DF_InsuranceCompany_HCFASameAsInsuredFormatCode] DEFAULT ('D') FOR [HCFASameAsInsuredFormatCode],
	CONSTRAINT [DF_InsuranceCompany_ReviewCode] DEFAULT ('') FOR [ReviewCode],
	CONSTRAINT [DF_InsuranceCompany_BillingFormID] DEFAULT (1) FOR [BillingFormID],
	CONSTRAINT [DF_InsuranceCompany_EClaimsAccepts] DEFAULT (0) FOR [EClaimsAccepts],
	CONSTRAINT [DF_InsuranceCompany_BillSecondaryInsurance] DEFAULT (0) FOR [BillSecondaryInsurance],
	CONSTRAINT [PK_InsuranceCompany] PRIMARY KEY  CLUSTERED 
	(
		[InsuranceCompanyID]
	)  ON [PRIMARY] 
GO

ALTER TABLE InsuranceCompany ADD
	CONSTRAINT [FK_InsuranceCompany_ClearinghousePayersList] FOREIGN KEY 
	(
		[ClearinghousePayerID]
	) REFERENCES [ClearinghousePayersList] (
		[ClearinghousePayerID]
	),
	CONSTRAINT [FK_InsuranceCompany_GroupNumberType] FOREIGN KEY 
	(
		[GroupNumberTypeID]
	) REFERENCES [dbo].[GroupNumberType] (
		[GroupNumberTypeID]
	),
	CONSTRAINT [FK_InsuranceCompany_HCFADiagnosisReferenceFormat] FOREIGN KEY 
	(
		[HCFADiagnosisReferenceFormatCode]
	) REFERENCES [dbo].[HCFADiagnosisReferenceFormat] (
		[HCFADiagnosisReferenceFormatCode]
	),
	CONSTRAINT [FK_InsuranceCompany_HCFASameAsInsuredFormat] FOREIGN KEY 
	(
		[HCFASameAsInsuredFormatCode]
	) REFERENCES [dbo].[HCFASameAsInsuredFormat] (
		[HCFASameAsInsuredFormatCode]
	),
	CONSTRAINT [FK_InsuranceCompany_InsuranceProgram] FOREIGN KEY 
	(
		[InsuranceProgramCode]
	) REFERENCES [dbo].[InsuranceProgram] (
		[InsuranceProgramCode]
	),
	CONSTRAINT [FK_InsuranceCompany_ProviderNumberType] FOREIGN KEY 
	(
		[ProviderNumberTypeID]
	) REFERENCES [dbo].[ProviderNumberType] (
		[ProviderNumberTypeID]
	),
	CONSTRAINT [FK_InsuranceCompany_ProviderNumberType_LocalUse] FOREIGN KEY 
	(
		[LocalUseProviderNumberTypeID]
	) REFERENCES [dbo].[ProviderNumberType] (
		[ProviderNumberTypeID]
	)
GO

ALTER TABLE [InsuranceCompanyPlan] ADD 
	[InsuranceCompanyID] [int] NULL,
	CONSTRAINT [FK_InsuranceCompanyPlan_InsuranceCompany] FOREIGN KEY 
	(
		[InsuranceCompanyID]
	) REFERENCES [InsuranceCompany] (
		[InsuranceCompanyID]
	)
GO


/*
ALTER TABLE [PracticeToInsuranceCompany] DROP PK_PracticeToInsuranceCompany
ALTER TABLE [PracticeToInsuranceCompany] DROP FK_PracticeToInsuranceCompany_InsuranceCompany
ALTER TABLE [PracticeToInsuranceCompany] DROP DF_PracticeToInsuranceCompany_CreatedDate
ALTER TABLE [PracticeToInsuranceCompany] DROP DF_PracticeToInsuranceCompany_CreatedUserID
ALTER TABLE [PracticeToInsuranceCompany] DROP DF_PracticeToInsuranceCompany_ModifiedDate
ALTER TABLE [PracticeToInsuranceCompany] DROP DF_PracticeToInsuranceCompany_ModifiedUserID
ALTER TABLE [PracticeToInsuranceCompany] DROP DF_PracticeToInsuranceCompany_EClaimsDisable
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PracticeToInsuranceCompany]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PracticeToInsuranceCompany]
*/
GO

-- now make PracticeToInsuranceCompany table:

CREATE TABLE [dbo].[PracticeToInsuranceCompany] (
	[PK_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[PracticeID] [int] NOT NULL ,
	[InsuranceCompanyID] [int] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[CreatedUserID] [int] NOT NULL ,
	[ModifiedDate] [datetime] NOT NULL ,
	[ModifiedUserID] [int] NOT NULL ,
	[RecordTimestamp] [timestamp] NOT NULL ,
	[EClaimsProviderID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EClaimsEnrollmentStatusID] [int] NULL ,
	[EClaimsDisable] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PracticeToInsuranceCompany] ADD 
	CONSTRAINT [DF_PracticeToInsuranceCompany_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
	CONSTRAINT [DF_PracticeToInsuranceCompany_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
	CONSTRAINT [DF_PracticeToInsuranceCompany_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
	CONSTRAINT [DF_PracticeToInsuranceCompany_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID],
	CONSTRAINT [DF_PracticeToInsuranceCompany_EClaimsDisable] DEFAULT (0) FOR [EClaimsDisable],
	CONSTRAINT [PK_PracticeToInsuranceCompany] PRIMARY KEY  CLUSTERED 
	(
		[PracticeID],
		[InsuranceCompanyID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PracticeToInsuranceCompany] ADD 
	CONSTRAINT [FK_PracticeToInsuranceCompany_InsuranceCompany] FOREIGN KEY 
	(
		[InsuranceCompanyID]
	) REFERENCES [dbo].[InsuranceCompany] (
		[InsuranceCompanyID]
	)
GO

-- hack to ensure the ADS_CompanyID exists in debugging. It should be there in production after ADS data migration: 
IF NOT EXISTS (
	SELECT	id
	FROM	SYSCOLUMNS
	WHERE	Name = 'ADS_CompanyID'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'InsuranceCompanyPlan'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.InsuranceCompanyPlan
	ADD ADS_CompanyID VARCHAR(10) NULL
END
GO


-- Fill in the InsuranceCompany table based on nPlanName in InsuranceCompanyPlan:
DECLARE icp_cursor CURSOR
READ_ONLY
FOR 
	SELECT     InsuranceCompanyPlanID, PlanName,
			AddressLine1, AddressLine2, City, State, Country, ZipCode,
			ContactPrefix, ContactFirstName, ContactMiddleName, ContactLastName, ContactSuffix, Phone, PhoneExt, Fax, FaxExt,
			MM_CompanyID, ADS_CompanyID, ClearinghousePayerID, CreatedPracticeID,
			InsuranceProgramCode, BillSecondaryInsurance, BillingFormID,
			EClaimsAccepts, HCFADiagnosisReferenceFormatCode, HCFASameAsInsuredFormatCode, LocalUseFieldTypeCode,
			ReviewCode, ProviderNumberTypeID, GroupNumberTypeID, LocalUseProviderNumberTypeID,
			CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID
	FROM       InsuranceCompanyPlan
	ORDER BY PlanName, ModifiedDate DESC

DECLARE @InsuranceCompanyID int
DECLARE @InsuranceCompanyPlanID int
DECLARE @InsuranceCompanyName varchar(128)
--DECLARE @Notes text
DECLARE @AddressLine1 varchar(256)
DECLARE @AddressLine2 varchar(256)
DECLARE @City varchar(128)
DECLARE @State varchar(2)
DECLARE @Country varchar(32)
DECLARE @ZipCode varchar(9)
DECLARE @ContactPrefix varchar(16)
DECLARE @ContactFirstName varchar(64)
DECLARE @ContactMiddleName varchar(64)
DECLARE @ContactLastName varchar(64)
DECLARE @ContactSuffix varchar(16)
DECLARE @Phone varchar(10)
DECLARE @PhoneExt varchar(10)
DECLARE @Fax varchar(10)
DECLARE @FaxExt varchar(10)
DECLARE @MM_CompanyID varchar(10)
DECLARE @ADS_CompanyID varchar(10)
DECLARE @ClearinghousePayerID int
DECLARE @CreatedPracticeID int
DECLARE @InsuranceProgramCode varchar(128)
DECLARE @BillSecondaryInsurance bit
DECLARE @BillingFormID int
DECLARE @EClaimsAccepts bit
DECLARE @HCFADiagnosisReferenceFormatCode char (1)
DECLARE @HCFASameAsInsuredFormatCode char (1)
DECLARE @LocalUseFieldTypeCode char (5)
DECLARE @ReviewCode char (1)
DECLARE @ProviderNumberTypeID int
DECLARE @GroupNumberTypeID int
DECLARE @LocalUseProviderNumberTypeID int
DECLARE @CreatedDate datetime
DECLARE @CreatedUserID int
DECLARE @ModifiedDate datetime
DECLARE @ModifiedUserID int

OPEN icp_cursor

FETCH NEXT FROM icp_cursor INTO @InsuranceCompanyPlanID, @InsuranceCompanyName,
				@AddressLine1, @AddressLine2, @City, @State, @Country, @ZipCode,
				@ContactPrefix, @ContactFirstName, @ContactMiddleName, @ContactLastName, @ContactSuffix, @Phone, @PhoneExt, @Fax, @FaxExt,
				@MM_CompanyID, @ADS_CompanyID, @ClearinghousePayerID, @CreatedPracticeID,
				@InsuranceProgramCode, @BillSecondaryInsurance, @BillingFormID,
				@EClaimsAccepts, @HCFADiagnosisReferenceFormatCode, @HCFASameAsInsuredFormatCode, @LocalUseFieldTypeCode,
				@ReviewCode, @ProviderNumberTypeID, @GroupNumberTypeID, @LocalUseProviderNumberTypeID,
				@CreatedDate, @CreatedUserID, @ModifiedDate, @ModifiedUserID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		IF NOT EXISTS(SELECT * FROM InsuranceCompany WHERE InsuranceCompanyName = @InsuranceCompanyName)
		BEGIN
			PRINT 'Creating Company ' + @InsuranceCompanyName
			INSERT INTO InsuranceCompany (InsuranceCompanyName,
					AddressLine1, AddressLine2, City, State, Country, ZipCode,
					ContactPrefix, ContactFirstName, ContactMiddleName, ContactLastName, ContactSuffix, Phone, PhoneExt, Fax, FaxExt,
					CompanyTextID, ClearinghousePayerID, CreatedPracticeID,
					InsuranceProgramCode, BillSecondaryInsurance, BillingFormID,
					EClaimsAccepts, HCFADiagnosisReferenceFormatCode, HCFASameAsInsuredFormatCode, LocalUseFieldTypeCode,
					ReviewCode, ProviderNumberTypeID, GroupNumberTypeID, LocalUseProviderNumberTypeID,
					CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID)
				 VALUES (@InsuranceCompanyName,
					@AddressLine1, @AddressLine2, @City, @State, @Country, @ZipCode,
					@ContactPrefix, @ContactFirstName, @ContactMiddleName, @ContactLastName, @ContactSuffix, @Phone, @PhoneExt, @Fax, @FaxExt,
					ISNULL(@MM_CompanyID, @ADS_CompanyID), @ClearinghousePayerID, @CreatedPracticeID, 
					@InsuranceProgramCode, @BillSecondaryInsurance, @BillingFormID,
					@EClaimsAccepts, @HCFADiagnosisReferenceFormatCode, @HCFASameAsInsuredFormatCode, @LocalUseFieldTypeCode,
					@ReviewCode, @ProviderNumberTypeID, @GroupNumberTypeID, @LocalUseProviderNumberTypeID,
					@CreatedDate, @CreatedUserID, @ModifiedDate, @ModifiedUserID)
		END

		-- relate the plan to insurance company
		SELECT @InsuranceCompanyID=InsuranceCompanyID FROM InsuranceCompany WHERE InsuranceCompanyName = @InsuranceCompanyName
		PRINT 'Relating Plan ' + CAST(@InsuranceCompanyPlanID AS varchar) + ' to Company ' + @InsuranceCompanyName
		UPDATE InsuranceCompanyPlan SET InsuranceCompanyID = @InsuranceCompanyID WHERE InsuranceCompanyPlanID = @InsuranceCompanyPlanID

		-- make sure that EClaimsAccepts field really is set when any of the related plans accepts:
		IF (@EClaimsAccepts = 1)
		BEGIN
			UPDATE InsuranceCompany SET EClaimsAccepts = 1 WHERE InsuranceCompanyID = @InsuranceCompanyID
		END

		INSERT PracticeToInsuranceCompany 
		SELECT NI.PracticeID, NI.InsuranceCompanyID, NI.CreatedDate, NI.CreatedUserID, NI.ModifiedDate, 
		       NI.ModifiedUserID, NULL, NI.EClaimsProviderID, NI.EClaimsEnrollmentStatusID, NI.EClaimsDisable
		FROM (
		select 
			PTICP.[PracticeID],
			ICP.InsuranceCompanyID,		--	PTICP.[InsuranceCompanyPlanID],
			PTICP.[CreatedDate],
			PTICP.[CreatedUserID],
			PTICP.[ModifiedDate],
			PTICP.[ModifiedUserID],
			--NULL,				--	PTICP.[RecordTimestamp],
			PTICP.[EClaimsProviderID],
			PTICP.[EClaimsEnrollmentStatusID],
			PTICP.[EClaimsDisable]
		    FROM PracticeToInsuranceCompanyPlan PTICP
		    INNER JOIN InsuranceCompanyPlan ICP ON ICP.InsuranceCompanyPlanID = PTICP.InsuranceCompanyPlanID
		WHERE ICP.InsuranceCompanyPlanID = @InsuranceCompanyPlanID) NI LEFT JOIN 
		PracticeToInsuranceCompany PTIC ON NI.PracticeID=PTIC.PracticeID AND NI.InsuranceCompanyID=PTIC.InsuranceCompanyID
		WHERE PTIC.PracticeID IS NULL

	END
	FETCH NEXT FROM icp_cursor INTO @InsuranceCompanyPlanID, @InsuranceCompanyName,
				@AddressLine1, @AddressLine2, @City, @State, @Country, @ZipCode,
				@ContactPrefix, @ContactFirstName, @ContactMiddleName, @ContactLastName, @ContactSuffix, @Phone, @PhoneExt, @Fax, @FaxExt,
				@MM_CompanyID, @ADS_CompanyID, @ClearinghousePayerID, @CreatedPracticeID,
				@InsuranceProgramCode, @BillSecondaryInsurance, @BillingFormID,
				@EClaimsAccepts, @HCFADiagnosisReferenceFormatCode, @HCFASameAsInsuredFormatCode, @LocalUseFieldTypeCode,
				@ReviewCode, @ProviderNumberTypeID, @GroupNumberTypeID, @LocalUseProviderNumberTypeID,
				@CreatedDate, @CreatedUserID, @ModifiedDate, @ModifiedUserID
END

CLOSE icp_cursor
DEALLOCATE icp_cursor
GO


--DISABLE ALL TRIGGERS ON AFFECTED TABLES
ALTER TABLE Claim DISABLE TRIGGER ALL
ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL

ALTER TABLE ENCOUNTER DISABLE TRIGGER ALL
ALTER TABLE ENCOUNTERPROCEDURE DISABLE TRIGGER ALL

GO

---------------------------------------------------------------------------------------
-- case 6102:   EClaims: implement search for payer number in Claim Browser

-- Add Column to Claim - [ClearinghousePayerReported]:
ALTER TABLE Claim ADD [ClearinghousePayerReported] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
PRINT '-- Add Column to Claim [ClearinghousePayerReported]'
GO

-- Migrate data to the new field:
UPDATE Claim SET [ClearinghousePayerReported] = [ClearinghousePayer] WHERE LEN(ClearinghousePayer) > 10
GO

-- Now restore original [ClearinghousePayer] value, before report has come in: 
CREATE TABLE #t_cclaims(
		ClaimID int,
		ClearinghousePayer varchar(128),
		PayerNumber varchar(128)
	)

-- what we will modify goes into temp table:
INSERT #t_cclaims
	SELECT     C.ClaimID, C.ClearinghousePayer, CPL.PayerNumber
	FROM         Claim C INNER JOIN
                      ClaimPayer CP INNER JOIN
                      PatientInsurance PI ON PI.PatientInsuranceID = CP.PatientInsuranceID INNER JOIN
                      InsuranceCompanyPlan ICP LEFT OUTER JOIN
                      ClearinghousePayersList CPL ON ICP.ClearinghousePayerID = CPL.ClearinghousePayerID ON 
                      ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID ON CP.ClaimID = C.ClaimID
	WHERE     (LEN(C.ClearinghousePayer) > 10) AND CPL.PayerNumber IS NOT NULL AND CP.Precedence = 1

DECLARE claim_temp_cursor CURSOR
READ_ONLY
FOR 
	SELECT     ClaimID, PayerNumber
	FROM       #t_cclaims

OPEN claim_temp_cursor

DECLARE @ClaimID INT
DECLARE @PayerNumber varchar(128)

-- apply the temp table to Claim, row by row:
FETCH NEXT FROM claim_temp_cursor INTO @ClaimID, @PayerNumber
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		UPDATE Claim SET ClearinghousePayer = @PayerNumber WHERE ClaimID = @ClaimID
	END
FETCH NEXT FROM claim_temp_cursor INTO @ClaimID, @PayerNumber
END

CLOSE claim_temp_cursor
DEALLOCATE claim_temp_cursor
DROP TABLE #t_cclaims
GO

---------------------------------------------------------------------------------------
--case 5892:   EClaims: insurance plan names are taken from the wrong record 

ALTER TABLE ClearinghousePayersList ADD [NameTransmitted] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

-- Migrate data to the new field:
UPDATE ClearinghousePayersList SET [NameTransmitted] = UPPER(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Name],'+',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' '),1,35))
GO

---------------------------------------------------------------------------------------
--case 5390 - Migrate existing patients to case model

--CREATE SOME INDEXES TO SPEED THINGS UP
CREATE NONCLUSTERED INDEX IX_Encounter_PatientID_PatientAuthorizationID
ON Encounter (PatientID,PatientAuthorizationID)

CREATE NONCLUSTERED INDEX IX_PatientAuthorization_PatientID_PatientAuthorizationID
ON PatientAuthorization (PatientID, PatientAuthorizationID)

--ý Add new Columns to EncounterProcedure & Claim for migration of Diagnosis Codes
ALTER TABLE EncounterProcedure ADD EncounterDiagnosisID1 INT NULL,
EncounterDiagnosisID2 INT NULL, EncounterDiagnosisID3 INT NULL,
EncounterDiagnosisID4 INT NULL, EncounterDiagnosisID5 INT NULL,
EncounterDiagnosisID6 INT NULL, EncounterDiagnosisID7 INT NULL,
EncounterDiagnosisID8 INT NULL, ServiceEndDate DATETIME NULL

ALTER TABLE Claim ADD D1 VARCHAR(30) NULL,
D2 VARCHAR(30) NULL, D3 VARCHAR(30) NULL, D4 VARCHAR(30) NULL

--Drop Indexes to allow for faster updates
DROP INDEX Claim.IX_Claim_DiagnosisPointer1
DROP INDEX Claim.IX_Claim_DiagnosisPointer2
DROP INDEX Claim.IX_Claim_DiagnosisPointer3
DROP INDEX Claim.IX_Claim_DiagnosisPointer4

--ý Add new Columns to EncounterProcedure & Claim for migration of Diagnosis Codes

GO

--ý Migrate DiagnosisCode1-8 to EncounterDiagnosisID1-8, where 1-4 EncounterDiagnosisID order is determined by DiagnosisPointer1-4
UPDATE Claim SET DiagnosisPointer2= CASE WHEN DiagnosisPointer1=DiagnosisPointer2 THEN NULL ELSE DiagnosisPointer2 END,
DiagnosisPointer3=CASE WHEN DiagnosisPointer1=DiagnosisPointer3 THEN NULL ELSE DiagnosisPointer3 END,
DiagnosisPointer4=CASE WHEN DiagnosisPointer1=DiagnosisPointer4 THEN NULL ELSE DiagnosisPointer4 END

UPDATE Claim SET DiagnosisPointer3= CASE WHEN DiagnosisPointer2=DiagnosisPointer3 THEN NULL ELSE DiagnosisPointer3 END,
DiagnosisPointer4=CASE WHEN DiagnosisPointer2=DiagnosisPointer4 THEN NULL ELSE DiagnosisPointer4 END

UPDATE Claim SET DiagnosisPointer4= CASE WHEN DiagnosisPointer3=DiagnosisPointer4 THEN NULL ELSE DiagnosisPointer4 END

UPDATE Claim SET DiagnosisPointer1=CASE WHEN DiagnosisPointer1 IS NULL AND DiagnosisPointer2 IS NOT NULL THEN DiagnosisPointer2
				       WHEN DiagnosisPointer1 IS NULL AND DiagnosisPointer3 IS NOT NULL THEN DiagnosisPointer3
				       WHEN DiagnosisPointer1 IS NULL AND DiagnosisPointer4 IS NOT NULL THEN DiagnosisPointer4
				       ELSE DiagnosisPointer1 END

UPDATE Claim SET DiagnosisPointer2=CASE WHEN DiagnosisPointer2 IS NULL AND DiagnosisPointer3 IS NOT NULL THEN DiagnosisPointer3
				       WHEN DiagnosisPointer2 IS NULL AND DiagnosisPointer4 IS NOT NULL THEN DiagnosisPointer4
				       ELSE DiagnosisPointer2 END

UPDATE Claim SET DiagnosisPointer3=CASE WHEN DiagnosisPointer3 IS NULL AND DiagnosisPointer4 IS NOT NULL THEN DiagnosisPointer4
				       ELSE DiagnosisPointer3 END

UPDATE Claim SET D1=CASE WHEN DiagnosisPointer1=1 THEN DiagnosisCode1
			 WHEN DiagnosisPointer1=2 THEN DiagnosisCode2
			 WHEN DiagnosisPointer1=3 THEN DiagnosisCode3
			 WHEN DiagnosisPointer1=4 THEN DiagnosisCode4
			 WHEN DiagnosisPointer1=5 THEN DiagnosisCode5 END,
D2=CASE WHEN DiagnosisPointer2=1 THEN DiagnosisCode1
			 WHEN DiagnosisPointer2=2 THEN DiagnosisCode2
			 WHEN DiagnosisPointer2=3 THEN DiagnosisCode3
			 WHEN DiagnosisPointer2=4 THEN DiagnosisCode4
			 WHEN DiagnosisPointer2=5 THEN DiagnosisCode5 END,
D3=CASE WHEN DiagnosisPointer3=1 THEN DiagnosisCode1
			 WHEN DiagnosisPointer3=2 THEN DiagnosisCode2
			 WHEN DiagnosisPointer3=3 THEN DiagnosisCode3
			 WHEN DiagnosisPointer3=4 THEN DiagnosisCode4
			 WHEN DiagnosisPointer3=5 THEN DiagnosisCode5 END,
D4=CASE WHEN DiagnosisPointer4=1 THEN DiagnosisCode1
			 WHEN DiagnosisPointer4=2 THEN DiagnosisCode2
			 WHEN DiagnosisPointer4=3 THEN DiagnosisCode3
			 WHEN DiagnosisPointer4=4 THEN DiagnosisCode4
			 WHEN DiagnosisPointer4=5 THEN DiagnosisCode5 END

UPDATE EP SET EncounterDiagnosisID1=DiagnosisCodeDictionaryID
FROM Claim C INNER JOIN DiagnosisCodeDictionary DCD
ON C.D1=DCD.DiagnosisCode
INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID

UPDATE EP SET EncounterDiagnosisID2=DiagnosisCodeDictionaryID
FROM Claim C INNER JOIN DiagnosisCodeDictionary DCD
ON C.D2=DCD.DiagnosisCode
INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID

UPDATE EP SET EncounterDiagnosisID3=DiagnosisCodeDictionaryID
FROM Claim C INNER JOIN DiagnosisCodeDictionary DCD
ON C.D3=DCD.DiagnosisCode
INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID

UPDATE EP SET EncounterDiagnosisID4=DiagnosisCodeDictionaryID
FROM Claim C INNER JOIN DiagnosisCodeDictionary DCD
ON C.D4=DCD.DiagnosisCode
INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID

--Insert Missing EncounterDiagnosis Records before associating to EncounterProcedure
INSERT INTO EncounterDiagnosis(EncounterID, DiagnosisCodeDictionaryID, ListSequence, PracticeID)
SELECT DISTINCT EP.EncounterID, EncounterDiagnosisID1, 0, EP.PracticeID
FROM EncounterProcedure EP LEFT JOIN EncounterDiagnosis ED ON EP.EncounterID=ED.EncounterID
AND EP.EncounterDiagnosisID1=ED.DiagnosisCodeDictionaryID
WHERE EncounterDiagnosisID IS NULL AND EP.EncounterDiagnosisID1 IS NOT NULL

INSERT INTO EncounterDiagnosis(EncounterID, DiagnosisCodeDictionaryID, ListSequence, PracticeID)
SELECT DISTINCT EP.EncounterID, EncounterDiagnosisID2, 0, EP.PracticeID
FROM EncounterProcedure EP LEFT JOIN EncounterDiagnosis ED ON EP.EncounterID=ED.EncounterID
AND EP.EncounterDiagnosisID2=ED.DiagnosisCodeDictionaryID
WHERE EncounterDiagnosisID IS NULL AND EP.EncounterDiagnosisID2 IS NOT NULL

INSERT INTO EncounterDiagnosis(EncounterID, DiagnosisCodeDictionaryID, ListSequence, PracticeID)
SELECT DISTINCT EP.EncounterID, EncounterDiagnosisID3, 0, EP.PracticeID
FROM EncounterProcedure EP LEFT JOIN EncounterDiagnosis ED ON EP.EncounterID=ED.EncounterID
AND EP.EncounterDiagnosisID3=ED.DiagnosisCodeDictionaryID
WHERE EncounterDiagnosisID IS NULL AND EP.EncounterDiagnosisID3 IS NOT NULL

INSERT INTO EncounterDiagnosis(EncounterID, DiagnosisCodeDictionaryID, ListSequence, PracticeID)
SELECT DISTINCT EP.EncounterID, EncounterDiagnosisID4, 0, EP.PracticeID
FROM EncounterProcedure EP LEFT JOIN EncounterDiagnosis ED ON EP.EncounterID=ED.EncounterID
AND EP.EncounterDiagnosisID4=ED.DiagnosisCodeDictionaryID
WHERE EncounterDiagnosisID IS NULL AND EP.EncounterDiagnosisID4 IS NOT NULL

--Associate to EncounterProcedure
UPDATE EP SET EncounterDiagnosisID1=EncounterDiagnosisID
FROM EncounterProcedure EP INNER JOIN EncounterDiagnosis ED ON EP.EncounterID=ED.EncounterID
AND EP.EncounterDiagnosisID1=ED.DiagnosisCodeDictionaryID

UPDATE EP SET EncounterDiagnosisID2=EncounterDiagnosisID
FROM EncounterProcedure EP INNER JOIN EncounterDiagnosis ED ON EP.EncounterID=ED.EncounterID
AND EP.EncounterDiagnosisID2=ED.DiagnosisCodeDictionaryID

UPDATE EP SET EncounterDiagnosisID3=EncounterDiagnosisID
FROM EncounterProcedure EP INNER JOIN EncounterDiagnosis ED ON EP.EncounterID=ED.EncounterID
AND EP.EncounterDiagnosisID3=ED.DiagnosisCodeDictionaryID

UPDATE EP SET EncounterDiagnosisID4=EncounterDiagnosisID
FROM EncounterProcedure EP INNER JOIN EncounterDiagnosis ED ON EP.EncounterID=ED.EncounterID
AND EP.EncounterDiagnosisID4=ED.DiagnosisCodeDictionaryID
--ý Migrate DiagnosisCode1-8 to EncounterDiagnosisID1-8, where 1-4 EncounterDiagnosisID order is determined by DiagnosisPointer1-4

--ý Migrate ServiceBeginDate and ServiceEndDate to EntounterProcedure
UPDATE EP SET ProcedureDateOfService=ServiceBeginDate, ServiceEndDate=C.ServiceEndDate
FROM Claim C INNER JOIN EncounterProcedure EP
ON C.EncounterProcedureID=EP.EncounterProcedureID
LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
WHERE VC.ClaimID IS NULL
--ý Migrate ServiceBeginDate and ServiceEndDate to EntounterProcedure

GO

--ý Migrate Encounter's DateOfService to EntounterProcedure.ProcedureDateOfService for any that are null
UPDATE EP SET ProcedureDateOfService=DateOfService
FROM EncounterProcedure EP
INNER JOIN Encounter E
ON E.EncounterID=EP.EncounterID
WHERE EP.ProcedureDateOfService IS NULL
--ý Migrate Encounter's DateOfService to EntounterProcedure.ProcedureDateOfService for any that are null

GO

--ý Don't allow nulls into ProcedureDateOfService
ALTER TABLE EncounterProcedure
ALTER COLUMN ProcedureDateOfService DATETIME NOT NULL
--ý Don't allow nulls into ProcedureDateOfService

GO

--ý Create PatientCase Table
CREATE TABLE PatientCase(
	PatientCaseID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_PatientCase_PatientCaseID 
		PRIMARY KEY NONCLUSTERED,
	PatientID INT NOT NULL,
	Name VARCHAR(128) NOT NULL,
	Active BIT NOT NULL CONSTRAINT DF_PatientCase_Active DEFAULT (1),
	PayerScenarioID INT NOT NULL,
	ReferringPhysicianID INT NULL,
	InitialTreatmentDate DATETIME NULL,
	CurrentIllnessDate DATETIME NULL,
	SimilarIllnessDate DATETIME NULL,
	EmploymentRelatedFlag BIT NOT NULL CONSTRAINT DF_PatientCase_EmploymentRelatedFlag DEFAULT (0),
	AutoAccidentRelatedFlag BIT NOT NULL CONSTRAINT DF_PatientCase_AutoAccidentRelatedFlag DEFAULT (0),
	OtherAccidentRelatedFlag BIT NOT NULL CONSTRAINT DF_PatientCase_OtherAccidentRelatedFlag DEFAULT (0),
	AbuseRelatedFlag BIT NOT NULL CONSTRAINT DF_PatientCase_AbuseRelatedFlag DEFAULT (0),
	AutoAccidentRelatedState CHAR(2) NULL,
	LastWorkedDate DATETIME NULL,
	ReturnToWorkDate DATETIME NULL,
	DisabilityBeginDate DATETIME NULL,
	DisabilityEndDate DATETIME NULL,
	HospitalizationBeginDate DATETIME NULL,
	HospitalizationEndDate DATETIME NULL,
	Notes TEXT NULL,
	ShowExpiredInsurancePolicies BIT NOT NULL CONSTRAINT DF_PatientCase_ShowExpiredInsurancePolicies DEFAULT (0),
	CreatedDate DATETIME NOT NULL CONSTRAINT DF_PatientCase_CreatedDate DEFAULT (GETDATE()),
	CreatedUserID INT NOT NULL CONSTRAINT DF_PatientCase_CreatedUserID DEFAULT (0),
	ModifiedDate DATETIME NOT NULL CONSTRAINT DF_PatientCase_ModifiedDate DEFAULT (GETDATE()),
	ModifiedUserID INT NOT NULL CONSTRAINT DF_PatientCase_ModifiedUserID DEFAULT (0)
			)
--ý Create PatientCase Table

GO

--ý Add related FKs to PatientCase Table
ALTER TABLE PatientCase ADD CONSTRAINT FK_PatientCase_PatientID 
FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
ON DELETE NO ACTION ON UPDATE NO ACTION

ALTER TABLE PatientCase ADD CONSTRAINT FK_PatientCase_ReferringPhysicianID 
FOREIGN KEY (ReferringPhysicianID) REFERENCES ReferringPhysician (ReferringPhysicianID)
ON DELETE NO ACTION ON UPDATE NO ACTION
--ý Add related FK to PatientCase Table

GO

--ý Create PayerSituation Table
CREATE TABLE PayerScenario(
	PayerScenarioID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_PayerScenario_PayerScenarioID
		PRIMARY KEY CLUSTERED,
	Name VARCHAR(128) NOT NULL,
	Description VARCHAR(256) NULL
			   )
--ý Create PayerSituation Table

GO

--ý Add dummy record to PayerScenario
	INSERT PayerScenario(Name, Description)
	VALUES('Attorney Lien',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('Auto Insurance',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('BC/BS',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('BC/BS HMO',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('Commercial',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('HMO',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('Medicare',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('Medicaid',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('Medicaid HMO',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('PPO',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('Self Pay',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('Tricare',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('Workers Comp',NULL)

	INSERT PayerScenario(Name, Description)
	VALUES('VA',NULL)
--ý Add dummy record to PayerScenario

GO

--ý Add related FK to PatientCase
ALTER TABLE PatientCase ADD CONSTRAINT FK_PatientCase_PayerScenarioID 
FOREIGN KEY (PayerScenarioID) REFERENCES PayerScenario(PayerScenarioID)
ON DELETE NO ACTION ON UPDATE NO ACTION
--ý Add related FK to PatientCase

GO

--ý Create InsurancePolicy Table
CREATE TABLE [InsurancePolicy] (
	[InsurancePolicyID] [int] IDENTITY (1, 1) NOT NULL ,
	PatientCaseID INT NOT NULL,
	[InsuranceCompanyPlanID] [int] NOT NULL ,
	[Precedence] [int] NOT NULL CONSTRAINT [DF_InsurancePolicy_Precedence] DEFAULT (1),
	[PolicyNumber] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[GroupNumber] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PolicyStartDate] [datetime] NULL ,
	[PolicyEndDate] [datetime] NULL ,
	[CardOnFile] [bit] NOT NULL CONSTRAINT [DF_InsurancePolicy_CardOnFile] DEFAULT (0),
	[HolderDifferentThanPatient] [bit] NOT NULL CONSTRAINT [DF_InsurancePolicy_HolderDifferentThanPatient] DEFAULT (0),
	[PatientRelationshipToInsured] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HolderPrefix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderFirstName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderMiddleName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderLastName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderSuffix] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderDOB] [datetime] NULL ,
	[HolderSSN] [char] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderThroughEmployer] [bit] NOT NULL CONSTRAINT [DF_InsurancePolicy_HolderThroughEmployer] DEFAULT (0),
	[HolderEmployerName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PatientInsuranceStatusID] [int] NOT NULL CONSTRAINT [DF_InsurancePolicy_PatientInsuranceStatusID] DEFAULT (0),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_InsurancePolicy_CreatedDate] DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_InsurancePolicy_CreatedUserID] DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_InsurancePolicy_ModifiedDate] DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_InsurancePolicy_ModifiedUserID] DEFAULT (0),
	[RecordTimeStamp] [timestamp] NOT NULL ,
	[HolderGender] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderAddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderAddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderCity] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderCountry] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HolderPhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DependentPolicyNumber] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FaxExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	Copay MONEY NOT NULL CONSTRAINT [DF_InsurancePolicy_Copay] DEFAULT (0),
	Deductible MONEY NOT NULL CONSTRAINT [DF_InsurancePolicy_Deductible] DEFAULT (0),
	PatientInsuranceNumber VARCHAR(32) NULL,
	Active Bit NOT NULL CONSTRAINT [DF_InsurancePolicy_Active] DEFAULT (1),
	PrevPatientInsuranceID INT NULL,
	CONSTRAINT [PK_InsurancePolicy] PRIMARY KEY  NONCLUSTERED 
	(
		[InsurancePolicyID]
	)  
)
--ý Create InsurancePolicy Table

GO

--ý Add FK to PatienctCase on InsurancePolicy
ALTER TABLE InsurancePolicy ADD CONSTRAINT FK_InsurancePolicy_PatientCaseID 
FOREIGN KEY (PatientCaseID) REFERENCES PatientCase (PatientCaseID)
ON DELETE NO ACTION ON UPDATE NO ACTION
--ý Add FK to PatienctCase on InsurancePolicy

GO

--ý Create InsurancePolicyAuthorization
CREATE TABLE InsurancePolicyAuthorization (
	 InsurancePolicyAuthorizationID INT IDENTITY (1, 1) NOT NULL
		CONSTRAINT PK_InsurancePolicyAuthorization_InsurancePolicyAuthorizationID
			PRIMARY KEY CLUSTERED,
	 InsurancePolicyID INT NOT NULL ,
	[AuthorizationNumber] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AuthorizedNumberOfVisits] [int] NOT NULL ,
	[StartDate] [datetime] NULL ,
	[EndDate] [datetime] NULL ,
	[ContactFullname] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactPhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AuthorizationStatusID] [int] NOT NULL CONSTRAINT DF_InsurancePolicyAuthorization_AuthorizationStatusID DEFAULT (1),
	[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT DF_InsurancePolicyAuthorization_CreatedDate DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL CONSTRAINT DF_InsurancePolicyAuthorization_CreatedUserID DEFAULT (0),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT DF_InsurancePolicyAuthorization_ModifiedDate DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL CONSTRAINT DF_InsurancePolicyAuthorization_ModifiedUserID DEFAULT (0),
	[RecordTimeStamp] [timestamp] NOT NULL,
	 PreviousAuthID INT NULL 
					   ) 
--ý Create InsurancePolicyAuthorization

GO

--ý Add FK to InsurancePolicy on InsurancePolicyAuthorization
ALTER TABLE InsurancePolicyAuthorization ADD CONSTRAINT FK_InsurancePolicyAuthorization_InsurancePolicyID 
FOREIGN KEY (InsurancePolicyID) REFERENCES InsurancePolicy (InsurancePolicyID)
ON DELETE NO ACTION ON UPDATE NO ACTION
--ý Add FK to InsurancePolicy on InsurancePolicyAuthorization

GO

--ý Add Encounter Columns PatientCaseID
ALTER TABLE Encounter ADD PatientCaseID INT

CREATE NONCLUSTERED INDEX IX_Encounter_PatientCaseID
ON Encounter (PatientCaseID)
--ý Add Encounter Columns PatientCaseID

GO

--ý Modify Claim and Encounter to allow for pre analysis to determine case creation

UPDATE Claim SET AutoAccidentRelatedState='00'
WHERE AutoAccidentRelatedState IS NULL

UPDATE Encounter SET AutoAccidentRelatedState='00'
WHERE AutoAccidentRelatedState IS NULL

ALTER TABLE Claim ADD CI DECIMAL(18,12), RPI INT,  IT DECIMAL(18,12), SI DECIMAL(18,12), LW DECIMAL(18,12), RW DECIMAL(18,12), 
DB DECIMAL(18,12), DE DECIMAL(18,12), HB DECIMAL(18,12), HE DECIMAL(18,12)
GO

ALTER TABLE Encounter ADD CI DECIMAL(18,12), RPI INT, IT DECIMAL(18,12), SI DECIMAL(18,12), LW DECIMAL(18,12), RW DECIMAL(18,12), 
DB DECIMAL(18,12), DE DECIMAL(18,12), HB DECIMAL(18,12), HE DECIMAL(18,12)
GO

UPDATE Claim SET CI=ISNULL(CAST(CurrentIllnessDate AS DECIMAL(18,12)),0),
RPI=ISNULL(ReferringProviderID,0),
IT=ISNULL(CAST(InitialTreatmentDate AS DECIMAL(18,12)),0),
SI=ISNULL(CAST(SimilarIllnessDate AS DECIMAL(18,12)),0),
LW=ISNULL(CAST(LastWorkedDate AS DECIMAL(18,12)),0),
RW=ISNULL(CAST(ReturnToWorkDate AS DECIMAL(18,12)),0),
DB=ISNULL(CAST(DisabilityBeginDate AS DECIMAL(18,12)),0),
DE=ISNULL(CAST(DisabilityEndDate AS DECIMAL(18,12)),0),
HB=ISNULL(CAST(HospitalizationBeginDate AS DECIMAL(18,12)),0),
HE=ISNULL(CAST(HospitalizationEndDate AS DECIMAL(18,12)),0)

UPDATE Encounter SET CI=ISNULL(CAST(DateOfInjury AS DECIMAL(18,12)),0),
RPI=ISNULL(ReferringPhysicianID,0),
IT=ISNULL(CAST(InitialTreatmentDate AS DECIMAL(18,12)),0),
SI=ISNULL(CAST(SimilarIllnessDate AS DECIMAL(18,12)),0),
LW=ISNULL(CAST(LastWorkedDate AS DECIMAL(18,12)),0),
RW=ISNULL(CAST(ReturnToWorkDate AS DECIMAL(18,12)),0),
DB=ISNULL(CAST(DisabilityBeginDate AS DECIMAL(18,12)),0),
DE=ISNULL(CAST(DisabilityEndDate AS DECIMAL(18,12)),0),
HB=ISNULL(CAST(HospitalizationBeginDate AS DECIMAL(18,12)),0),
HE=ISNULL(CAST(HospitalizationEndDate AS DECIMAL(18,12)),0)

GO

ALTER TABLE Encounter ADD PI1 INT, PI2 INT, PI3 INT, PI4 INT

ALTER TABLE Claim ADD CP1 INT, CP2 INT, CP3 INT, CP4 INT, CP5 INT

GO

UPDATE E SET PI1=0, PI2=0, PI3=0, PI4=0
FROM Encounter E LEFT JOIN EncounterToPatientInsurance ETPI
ON E.EncounterID=ETPI.EncounterID

UPDATE E SET PI1=CASE WHEN Precedence=1 THEN ETPI.PatientInsuranceID ELSE 0 END
FROM Encounter E INNER JOIN EncounterToPatientInsurance ETPI
ON E.EncounterID=ETPI.EncounterID
WHERE Precedence=1

UPDATE E SET PI2=CASE WHEN Precedence=2  THEN ETPI.PatientInsuranceID ELSE 0 END
FROM Encounter E INNER JOIN EncounterToPatientInsurance ETPI
ON E.EncounterID=ETPI.EncounterID
WHERE Precedence=2

UPDATE E SET PI3=CASE WHEN Precedence=3  THEN ETPI.PatientInsuranceID ELSE 0 END
FROM Encounter E INNER JOIN EncounterToPatientInsurance ETPI
ON E.EncounterID=ETPI.EncounterID
WHERE Precedence=3

UPDATE E SET PI4=CASE WHEN Precedence=4  THEN ETPI.PatientInsuranceID ELSE 0 END
FROM Encounter E INNER JOIN EncounterToPatientInsurance ETPI
ON E.EncounterID=ETPI.EncounterID
WHERE Precedence=4

UPDATE C SET CP1=0, CP2=0, CP3=0, CP4=0, CP5=0
FROM Claim C LEFT JOIN ClaimPayer CP ON C.ClaimID=CP.ClaimID

UPDATE C SET CP1=CASE WHEN Precedence=1 THEN CP.PatientInsuranceID ELSE 0 END
FROM Claim C INNER JOIN ClaimPayer CP ON C.ClaimID=CP.ClaimID
WHERE Precedence=1

UPDATE C SET CP2=CASE WHEN Precedence=2 THEN CP.PatientInsuranceID ELSE 0 END
FROM Claim C INNER JOIN ClaimPayer CP ON C.ClaimID=CP.ClaimID
WHERE Precedence=2

UPDATE C SET CP3=CASE WHEN Precedence=3 THEN CP.PatientInsuranceID ELSE 0 END
FROM Claim C INNER JOIN ClaimPayer CP ON C.ClaimID=CP.ClaimID
WHERE Precedence=3

UPDATE C SET CP4=CASE WHEN Precedence=4 THEN CP.PatientInsuranceID ELSE 0 END
FROM Claim C INNER JOIN ClaimPayer CP ON C.ClaimID=CP.ClaimID
WHERE Precedence=4

UPDATE C SET CP5=CASE WHEN Precedence=5 THEN CP.PatientInsuranceID ELSE 0 END
FROM Claim C INNER JOIN ClaimPayer CP ON C.ClaimID=CP.ClaimID
WHERE Precedence=5

--DROP hindering indexes for migration
DROP INDEX Encounter.CI_Encounter_PracticeID_EncounterID
DROP INDEX Claim.CI_Claim_PracticeID_ClaimID
GO

--Add Migration Indexes
CREATE CLUSTERED INDEX IX_Claim_Migration
ON Claim (PatientID,CI,RPI,IT,SI,LW,RW,DB,DE,HB,HE,CP1,CP2,CP3,CP4,CP5)
GO

CREATE CLUSTERED INDEX IX_Encounter_Migration
ON Encounter (PatientID,CI,RPI,IT,SI,LW,RW,DB,DE,HB,HE,PI1,PI2,PI3,PI4)
GO

--Perform DBCC_DBREINDEX
DBCC DBREINDEX(Claim)
DBCC DBREINDEX(Encounter)

UPDATE STATISTICS Claim
UPDATE STATISTICS Encounter

--ý Modify Claim and Encounter to allow for pre analysis to determine case creation

--ý Recreate Encounter Procedures for those that are missing for claim records

INSERT INTO EncounterProcedure(EncounterID, ProcedureCodeDictionaryID, ServiceChargeAmount, ServiceUnitCount, 
				 ProcedureModifier1, ProcedureModifier2, ProcedureModifier3, ProcedureModifier4,
				 DiagnosisID1, DiagnosisID2, DiagnosisID3, DiagnosisID4, ProcedureDateOfService, PracticeID)
SELECT C.EncounterID, PCD.ProcedureCodeDictionaryID, C.ServiceChargeAmount, C.ServiceUnitCount, C.ProcedureModifier1, C.ProcedureModifier2, 
C.ProcedureModifier3, C.ProcedureModifier4, DCDI.DiagnosisCodeDictionaryID, DCDII.DiagnosisCodeDictionaryID, 
DCDIII.DiagnosisCodeDictionaryID, DCDIV.DiagnosisCodeDictionaryID, ServiceBeginDate, C.PracticeID
FROM Claim C LEFT JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN ProcedureCodeDictionary PCD ON C.ProcedureCode=PCD.ProcedureCode
LEFT JOIN DiagnosisCodeDictionary DCDI ON C.DiagnosisCode1=DCDI.DiagnosisCode
LEFT JOIN DiagnosisCodeDictionary DCDII ON C.DiagnosisCode2=DCDII.DiagnosisCode
LEFT JOIN DiagnosisCodeDictionary DCDIII ON C.DiagnosisCode3=DCDIII.DiagnosisCode
LEFT JOIN DiagnosisCodeDictionary DCDIV ON C.DiagnosisCode4=DCDIV.DiagnosisCode
INNER JOIN Encounter E ON C.EncounterID=E.EncounterID
WHERE EP.EncounterProcedureID IS NULL

PRINT '--ý Recreate Encounter Procedures for those that are missing for claim records'
--ý Recreate Encounter Procedures for those that are missing for claim records

--ý Create Cases
--Get All Claim based Case Scenarious with less than 5 claim payers
CREATE TABLE #CPNot5(PatientID INT, CI DECIMAL(18,12), RPI INT, IT DECIMAL(18,12), SI DECIMAL(18,12), ERF INT, AARF INT, OA INT, ARF INT, AARS CHAR(2), 
LW DECIMAL(18,12), RW DECIMAL(18,12), DB DECIMAL(18,12), DE DECIMAL(18,12), HB DECIMAL(18,12), HE DECIMAL(18,12), CP1 INT, CP2 INT, CP3 INT, CP4 INT, CP5 INT, Items INT)
INSERT INTO #CPNot5(PatientID, CI, RPI, IT, SI, ERF, AARF, OA, ARF, AARS, LW, RW, DB, DE, HB, HE, CP1, CP2, CP3, CP4, CP5, Items)
SELECT PatientID, CI, RPI, IT, SI, EmploymentRelatedFlag, AutoAccidentRelatedFlag, OtherAccidentRelatedFlag,
AbuseRelatedFlag, AutoAccidentRelatedState, LW, RW, DB, DE, HB, HE, CP1, CP2, CP3, CP4, CP5, COUNT(ClaimID) Items
FROM Claim
WHERE CP5=0
GROUP BY PatientID, CI, RPI, IT, SI, EmploymentRelatedFlag, AutoAccidentRelatedFlag, OtherAccidentRelatedFlag,
AbuseRelatedFlag, AutoAccidentRelatedState, LW, RW, DB, DE, HB, HE, CP1, CP2, CP3, CP4, CP5

--Get all Claim based Case Scenarios with that have 5 claim payers per claim
CREATE TABLE #CP5(PatientID INT, CI DECIMAL(18,12), RPI INT, IT DECIMAL(18,12), SI DECIMAL(18,12), ERF INT, AARF INT, OA INT, ARF INT, AARS CHAR(2),
LW DECIMAL(18,12), RW DECIMAL(18,12), DB DECIMAL(18,12), DE DECIMAL(18,12), HB DECIMAL(18,12), HE DECIMAL(18,12), CP1 INT, CP2 INT, CP3 INT, CP4 INT, CP5 INT, Items INT)
INSERT INTO #CP5(PatientID, CI, RPI, IT, SI, ERF, AARF, OA, ARF, AARS, LW, RW, DB, DE, HB, HE, CP1, CP2, CP3, CP4, CP5, Items)
SELECT PatientID, CI, RPI, IT, SI, EmploymentRelatedFlag, AutoAccidentRelatedFlag, OtherAccidentRelatedFlag,
AbuseRelatedFlag, AutoAccidentRelatedState, LW, RW, DB, DE, HB, HE, CP1, CP2, CP3, CP4, CP5, COUNT(ClaimID) Items
FROM Claim
WHERE CP5<>0
GROUP BY PatientID, CI, RPI, IT, SI, EmploymentRelatedFlag, AutoAccidentRelatedFlag, OtherAccidentRelatedFlag,
AbuseRelatedFlag, AutoAccidentRelatedState, LW, RW, DB, DE, HB, HE, CP1, CP2, CP3, CP4, CP5

--Get all Unapproved Encounter based Case Scenarious 
CREATE TABLE #Encounters(PatientID INT, CI DECIMAL(18,12), RPI INT, IT DECIMAL(18,12), SI DECIMAL(18,12), ERF INT, AARF INT, OA INT, ARF INT, AARS CHAR(2), LW DECIMAL(18,12), RW DECIMAL(18,12), DB DECIMAL(18,12), 
DE DECIMAL(18,12), HB DECIMAL(18,12), HE DECIMAL(18,12), PI1 INT, PI2 INT, PI3 INT, PI4 INT, Items INT)
INSERT #Encounters(PatientID, CI, RPI, IT, SI, ERF, AARF, OA, ARF, AARS, LW, RW, DB, DE, HB, HE, PI1, PI2, PI3, PI4, Items)
SELECT E.PatientID, E.CI, E.RPI, E.IT, E.SI, E.EmploymentRelatedFlag, E.AutoAccidentRelatedFlag, E.OtherAccidentRelatedFlag,
E.AbuseRelatedFlag, E.AutoAccidentRelatedState, E.LW, E.RW, E.DB, E.DE, E.HB, E.HE, E.PI1, E.PI2, E.PI3, E.PI4, COUNT(E.EncounterID) Items
FROM Encounter E LEFT JOIN Claim C ON E.EncounterID=C.EncounterID
WHERE C.EncounterID IS NULL
GROUP BY E.PatientID, E.CI, E.RPI, E.IT, E.SI, E.EmploymentRelatedFlag, E.AutoAccidentRelatedFlag, E.OtherAccidentRelatedFlag,
E.AbuseRelatedFlag, E.AutoAccidentRelatedState, E.LW, E.RW, E.DB, E.DE, E.HB, E.HE, E.PI1, E.PI2, E.PI3, E.PI4

--Get all Case scenarious that are the same for Claim based (less than 5 claim payers)
--and Unapproved Encounters
CREATE TABLE #Common(PatientID INT, CI DECIMAL(18,12), RPI INT, IT DECIMAL(18,12), SI DECIMAL(18,12), ERF INT, AARF INT, OA INT, ARF INT, AARS CHAR(2), LW DECIMAL(18,12), RW DECIMAL(18,12) , DB DECIMAL(18,12),
DE DECIMAL(18,12), HB DECIMAL(18,12), HE DECIMAL(18,12), I1 INT, I2 INT, I3 INT, I4 INT)
INSERT INTO #Common(PatientID, CI, RPI, IT, SI, ERF, AARF, OA, ARF, AARS, LW, RW, DB, DE, HB, HE, I1, I2, I3, I4)
SELECT E.PatientID, E.CI, E.RPI, E.IT, E.SI, E.ERF, E.AARF, E.OA, E.ARF, E.AARS, E.LW, E.RW, E.DB, E.DE, E.HB, E.HE, E.PI1, E.PI2,
E.PI3, E.PI4
FROM #Encounters E INNER JOIN #CPNot5 C ON E.Patientid=C.PatientID AND E.CI=C.CI AND E.RPI=C.RPI AND E.IT=C.IT AND E.SI=C.SI AND
E.LW=C.LW AND E.RW=C.RW AND E.DB=C.DB AND E.DE=C.DE AND E.HB=C.HB AND E.HE=C.HE AND E.PI1=C.CP1 AND E.PI2=C.CP2 AND E.PI3=C.CP3
AND E.PI4=C.CP4

--Delete all Case scenarious for unapproved encounters that are included in common set
DELETE E
FROM #Encounters E INNER JOIN #Common C ON E.Patientid=C.PatientID AND E.CI=C.CI AND E.RPI=C.RPI AND E.IT=C.IT AND E.SI=C.SI AND
E.ERF=C.ERF AND E.AARF=C.AARF AND E.OA=C.OA AND E.ARF=C.ARF AND E.AARS=C.AARS AND
E.LW=C.LW AND E.RW=C.RW AND E.DB=C.DB AND E.DE=C.DE AND E.HB=C.HB AND E.HE=C.HE AND E.PI1=C.I1 AND E.PI2=C.I2 AND E.PI3=C.I3
AND E.PI4=C.I4

--Delete all Case scenarious for claim that are included in common set
DELETE CPN5
FROM #CPNot5 CPN5 INNER JOIN #Common C ON CPN5.Patientid=C.PatientID AND CPN5.CI=C.CI AND CPN5.RPI=C.RPI AND CPN5.IT=C.IT AND CPN5.SI=C.SI AND
CPN5.ERF=C.ERF AND CPN5.AARF=C.AARF AND CPN5.OA=C.OA AND CPN5.ARF=C.ARF AND CPN5.AARS=C.AARS AND
CPN5.LW=C.LW AND CPN5.RW=C.RW AND CPN5.DB=C.DB AND CPN5.DE=C.DE AND CPN5.HB=C.HB AND CPN5.HE=C.HE AND CPN5.CP1=C.I1 AND CPN5.CP2=C.I2 AND CPN5.CP3=C.I3
AND CPN5.CP4=C.I4

CREATE TABLE #Cases(PatientCaseID INT IDENTITY(2,1), PatientID INT, CI DECIMAL(18,12), RPI INT, IT DECIMAL(18,12), SI DECIMAL(18,12), ERF INT, AARF INT, OA INT, ARF INT, AARS CHAR(2), 
LW DECIMAL(18,12), RW DECIMAL(18,12) , DB DECIMAL(18,12), DE DECIMAL(18,12), HB DECIMAL(18,12), HE DECIMAL(18,12), I1 INT, I2 INT, I3 INT, I4 INT, Type CHAR(1))
INSERT #Cases(PatientID, CI, RPI, IT, SI, ERF, AARF, OA, ARF, AARS, LW, RW, DB, DE, HB, HE, I1, I2, I3, I4, Type)
SELECT PatientID, CI, RPI, IT, SI, ERF, AARF, OA, ARF, AARS, LW, RW, DB, DE, HB, HE, CP1, CP2, CP3, CP4, 'C'
FROM #CPNot5
WHERE PatientID NOT IN (199866,196389,202111)

INSERT #Cases(PatientID, CI, RPI, IT, SI, ERF, AARF, OA, ARF, AARS, LW, RW, DB, DE, HB, HE, I1, I2, I3, I4, Type)
SELECT PatientID, CI, RPI, IT, SI, ERF, AARF, OA, ARF, AARS, LW, RW, DB, DE, HB, HE, PI1, PI2, PI3, PI4, 'E'
FROM #Encounters
WHERE PatientID NOT IN (199866,196389,202111)

INSERT #Cases(PatientID, CI, RPI, IT, SI, ERF, AARF, OA, ARF, AARS, LW, RW, DB, DE, HB, HE, I1, I2, I3, I4, Type)
SELECT PatientID, CI, RPI, IT, SI, ERF, AARF, OA, ARF, AARS, LW, RW, DB, DE, HB, HE, I1, I2, I3, I4, 'B'
FROM #Common
WHERE PatientID NOT IN (199866,196389,202111)

--Get a unique list of the encounters related to patientcase scenarios
CREATE TABLE #DupEncountersI(PatientCaseID INT, PatientID INT, EncounterID INT)
INSERT INTO #DupEncountersI(PatientCaseID, PatientID, EncounterID)
SELECT DISTINCT C.PatientCaseID, C.PatientID, EncounterID
FROM Claim Clm INNER JOIN #Cases C ON Clm.Patientid=C.PatientID AND Clm.CI=C.CI AND Clm.RPI=C.RPI AND Clm.IT=C.IT AND Clm.SI=C.SI AND
Clm.EmploymentRelatedFlag=C.ERF AND Clm.AutoAccidentRelatedFlag=C.AARF AND Clm.OtherAccidentRelatedFlag=C.OA AND Clm.AbuseRelatedFlag=C.ARF AND Clm.AutoAccidentRelatedState=C.AARS AND
Clm.LW=C.LW AND Clm.RW=C.RW AND Clm.DB=C.DB AND Clm.DE=C.DE AND Clm.HB=C.HB AND Clm.HE=C.HE AND Clm.CP1=C.I1 AND Clm.CP2=C.I2 AND Clm.CP3=C.I3
AND Clm.CP4=C.I4
WHERE C.Type IN ('C','B')

--Determine those encounters whose claims span more than 1 case scenario
CREATE TABLE #DupEncountersII(EncounterID INT, PatientID INT, Cases INT)
INSERT INTO #DupEncountersII(EncounterID, PatientID, Cases)
SELECT EncounterID, PatientID, COUNT(PatientCaseID) Cases
FROM #DupEncountersI
GROUP BY EncounterID, PatientID
HAVING COUNT(PatientCaseID)>1

--Use the previous list to determine exactly how many cases scenarios
--are in those encounters to determine how many clones and claim reassignment
--is needed
--This will be the driving table of cloning encounters
CREATE TABLE #DupEncountersIII(EncounterID INT, PatientID INT, PatientCaseID INT)
INSERT INTO #DupEncountersIII(EncounterID, PatientID, PatientCaseID)
SELECT II.EncounterID, II.PatientID, I.PatientCaseID
FROM #DupEncountersII II INNER JOIN #DupEncountersI I ON II.EncounterID=I.EncounterID
AND II.PatientID=I.PatientID

--Remove the patient case with the lowest patientcaseid, these will be left to point
--to the original encounter
CREATE TABLE #DupEncountersIV(EncounterID INT, PatientID INT, MINCaseID INT)
INSERT INTO #DupEncountersIV(EncounterID, PatientID, MINCaseID)
SELECT EncounterID, PatientID, MIN(PatientCaseID) MINCaseID
FROM #DupEncountersIII
GROUP BY EncounterID, PatientID

DELETE III
FROM #DupEncountersIII III INNER JOIN #DupEncountersIV IV
ON III.EncounterID=IV.EncounterID AND III.PatientID=IV.PatientID
AND III.PatientCaseID=IV.MINCaseID

--Get a complete list of encounter and related EncounterProcedures for Dupes
CREATE TABLE #EncountersList(PatientCaseID INT, PatientID INT, EncounterID INT, EncounterProcedureID INT)
INSERT INTO #EncountersList(PatientCaseID, PatientID, EncounterID, EncounterProcedureID)
SELECT C.PatientCaseID, C.PatientID, EncounterID, EncounterProcedureID
FROM Claim Clm INNER JOIN #Cases C ON Clm.Patientid=C.PatientID AND Clm.CI=C.CI AND Clm.RPI=C.RPI AND Clm.IT=C.IT AND Clm.SI=C.SI AND
Clm.EmploymentRelatedFlag=C.ERF AND Clm.AutoAccidentRelatedFlag=C.AARF AND Clm.OtherAccidentRelatedFlag=C.OA AND Clm.AbuseRelatedFlag=C.ARF AND Clm.AutoAccidentRelatedState=C.AARS AND
Clm.LW=C.LW AND Clm.RW=C.RW AND Clm.DB=C.DB AND Clm.DE=C.DE AND Clm.HB=C.HB AND Clm.HE=C.HE AND Clm.CP1=C.I1 AND Clm.CP2=C.I2 AND Clm.CP3=C.I3
AND Clm.CP4=C.I4
WHERE C.Type IN ('C','B')

--Final Tables for use in Encounter Duplication
CREATE TABLE #DupProcedures(PatientCaseID INT, PatientID INT, EncounterID INT, EncounterProcedureID INT)
INSERT INTO #DupProcedures(PatientCaseID, PatientID, EncounterID, EncounterProcedureID)
SELECT E.PatientCaseID, E.PatientID, E.EncounterID, E.EncounterProcedureID
FROM #EncountersList E INNER JOIN #DupEncountersIII D ON E.PatientCaseID=D.PatientCaseID
AND E.PatientID=D.PatientID AND E.EncounterID=D.EncounterID

CREATE TABLE #DupEncounters(TID INT IDENTITY(1,1),PatientCaseID INT, PatientID INT, EncounterID INT)
INSERT INTO #DupEncounters(PatientCaseID, PatientID, EncounterID)
SELECT PatientCaseID, PatientID, EncounterID
FROM #DupEncountersIII

DECLARE @Loop INT
DECLARE @Counter INT
DECLARE @CurrentEncounterID INT
DECLARE @NewEncounterID INT
DECLARE @PatientCaseID INT

SELECT @Loop=COUNT(TID) FROM #DupEncounters
SET @Counter=0

WHILE @Counter<@Loop
BEGIN
	SET @Counter=@Counter+1
	SELECT @CurrentEncounterID=EncounterID, @PatientCaseID=PatientCaseID
	FROM #DupEncounters
	WHERE TID=@Counter

	INSERT INTO Encounter(PracticeID, PatientID, DoctorID, AppointmentID, LocationID, PatientAuthorizationID, DatePosted,
			      DateOfService, DateCreated, PatientConditionType, PatientConditionOtherDescription, Notes, EncounterStatusID,
			      AdminNotes, AmountPaid, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, MedicareAssignmentCode,
			      AssignmentOfBenefitsFlag, ReleaseOfInformationCode, ReleaseSignatureSourceCode, PlaceOfServiceCode, 
			      ConditionNotes, PatientCaseID)
	SELECT PracticeID, PatientID, DoctorID, AppointmentID, LocationID, PatientAuthorizationID, DatePosted,
			      DateOfService, DateCreated, PatientConditionType, PatientConditionOtherDescription, Notes, EncounterStatusID,
			      AdminNotes, AmountPaid, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, MedicareAssignmentCode,
			      AssignmentOfBenefitsFlag, ReleaseOfInformationCode, ReleaseSignatureSourceCode, PlaceOfServiceCode, 
			      ConditionNotes, @PatientCaseID
	FROM Encounter
	WHERE EncounterID=@CurrentEncounterID

	SET @NewEncounterID=@@IDENTITY

	--reassign encounter procedures to new encounter
 	UPDATE EP SET EncounterID=@NewEncounterID
	FROM EncounterProcedure EP INNER JOIN #DupProcedures DP
	ON EP.EncounterProcedureID=DP.EncounterProcedureID
	WHERE DP.EncounterID=@CurrentEncounterID AND PatientCaseID=@PatientCaseID

	--update claim's encounterid's
	UPDATE C SET EncounterID=@NewEncounterID
	FROM Claim C INNER JOIN #DupProcedures DP
	ON C.EncounterProcedureID=DP.EncounterProcedureID
	WHERE DP.EncounterID=@CurrentEncounterID AND PatientCaseID=@PatientCaseID	
END

UPDATE E SET PatientCaseID=1
FROM #CP5 CPN5 INNER JOIN Claim C ON CPN5.Patientid=C.PatientID AND CPN5.CI=C.CI AND CPN5.RPI=C.RPI AND CPN5.IT=C.IT AND CPN5.SI=C.SI AND
CPN5.ERF=C.EmploymentRelatedFlag AND CPN5.AARF=C.AutoAccidentRelatedFlag AND CPN5.OA=C.OtherAccidentRelatedFlag AND CPN5.ARF=C.AbuseRelatedFlag AND CPN5.AARS=C.AutoAccidentRelatedState AND
CPN5.LW=C.LW AND CPN5.RW=C.RW AND CPN5.DB=C.DB AND CPN5.DE=C.DE AND CPN5.HB=C.HB AND CPN5.HE=C.HE AND CPN5.CP1=C.CP1 AND CPN5.CP2=C.CP2 AND CPN5.CP3=C.CP3
AND CPN5.CP4=C.CP4 AND CPN5.CP5=C.CP5
INNER JOIN Encounter E ON C.EncounterID=E.EncounterID

CREATE TABLE #UpdateList(PatientCaseID INT, PatientID INT, EncounterID INT)
INSERT INTO #UpdateList(PatientCaseID, PatientID, EncounterID)
SELECT DISTINCT C.PatientCaseID, C.PatientID, EncounterID
FROM Claim Clm INNER JOIN #Cases C ON Clm.Patientid=C.PatientID AND Clm.CI=C.CI AND Clm.RPI=C.RPI AND Clm.IT=C.IT AND Clm.SI=C.SI AND
Clm.EmploymentRelatedFlag=C.ERF AND Clm.AutoAccidentRelatedFlag=C.AARF AND Clm.OtherAccidentRelatedFlag=C.OA AND Clm.AbuseRelatedFlag=C.ARF AND Clm.AutoAccidentRelatedState=C.AARS AND
Clm.LW=C.LW AND Clm.RW=C.RW AND Clm.DB=C.DB AND Clm.DE=C.DE AND Clm.HB=C.HB AND Clm.HE=C.HE AND Clm.CP1=C.I1 AND Clm.CP2=C.I2 AND Clm.CP3=C.I3
AND Clm.CP4=C.I4
WHERE C.Type IN ('C','B')

UPDATE E SET PatientCaseID=UL.PatientCaseID
FROM Encounter E INNER JOIN #UpdateList UL ON E.EncounterID=UL.EncounterID
WHERE E.PatientCaseID IS NULL

UPDATE E SET PatientCaseID=C.PatientCaseID
FROM Encounter E INNER JOIN #Cases C ON E.Patientid=C.PatientID AND E.CI=C.CI AND E.RPI=C.RPI AND E.IT=C.IT AND E.SI=C.SI AND
E.EmploymentRelatedFlag=C.ERF AND E.AutoAccidentRelatedFlag=C.AARF AND E.OtherAccidentRelatedFlag=C.OA AND E.AbuseRelatedFlag=C.ARF AND E.AutoAccidentRelatedState=C.AARS AND
E.LW=C.LW AND E.RW=C.RW AND E.DB=C.DB AND E.DE=C.DE AND E.HB=C.HB AND E.HE=C.HE AND E.PI1=C.I1 AND E.PI2=C.I2 AND E.PI3=C.I3
AND E.PI4=C.I4
WHERE C.Type IN ('E','B') AND E.PatientCaseID IS NULL

INSERT INTO PatientCase(PatientID, Name, Active, PayerScenarioID, ReferringPhysicianID, InitialTreatmentDate, CurrentIllnessDate,
			SimilarIllnessDate, EmploymentRelatedFlag, AutoAccidentRelatedFlag, OtherAccidentRelatedFlag, 
			AbuseRelatedFlag, AutoAccidentRelatedState, LastWorkedDate, ReturnToWorkDate, DisabilityBeginDate, 
			DisabilityEndDate, HospitalizationBeginDate, HospitalizationEndDate)
SELECT PatientID, 'Case', 1, 5, CASE WHEN RPI=0 THEN NULL ELSE RPI END,
       CASE WHEN IT=0 THEN NULL ELSE CAST(IT AS DATETIME) END, 
       CASE WHEN CI=0 THEN NULL ELSE CAST(CI AS DATETIME) END,
       CASE WHEN SI=0 THEN NULL ELSE CAST(SI AS DATETIME) END,
       ERF, AARF, OA, ARF , CASE WHEN AARS='00' THEN NULL ELSE AARS END,
       CASE WHEN LW=0 THEN NULL ELSE CAST(LW AS DATETIME) END,
       CASE WHEN RW=0 THEN NULL ELSE CAST(RW AS DATETIME) END,
       CASE WHEN DB=0 THEN NULL ELSE CAST(DB AS DATETIME) END,
       CASE WHEN DE=0 THEN NULL ELSE CAST(DE AS DATETIME) END,
       CASE WHEN HB=0 THEN NULL ELSE CAST(HB AS DATETIME) END,
       CASE WHEN HE=0 THEN NULL ELSE CAST(HE AS DATETIME) END
FROM #CP5

--Add insurance policies for claim with 5 payers
	--Update Prec1 Insurances
	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
	SELECT 1, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, 1, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, CP1
	FROM PatientInsurance PatI INNER JOIN #CP5 C ON PatI.PatientInsuranceID=C.CP1

	--Update Prec2 Insurances
	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
	SELECT 1, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, 2, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, CP2
	FROM PatientInsurance PatI INNER JOIN #CP5 C ON PatI.PatientInsuranceID=C.CP2

	--Update Prec3 Insurances
	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
	SELECT 1, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, 3, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, CP3
	FROM PatientInsurance PatI INNER JOIN #CP5 C ON PatI.PatientInsuranceID=C.CP3

	--Update Prec4 Insurances
	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
	SELECT 1, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, 4, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, CP4
	FROM PatientInsurance PatI INNER JOIN #CP5 C ON PatI.PatientInsuranceID=C.CP4

	--Update Prec5 Insurances
	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
	SELECT 1, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, 4, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, CP5
	FROM PatientInsurance PatI INNER JOIN #CP5 C ON PatI.PatientInsuranceID=C.CP5

INSERT INTO PatientCase(PatientID, Name, Active, PayerScenarioID, ReferringPhysicianID, InitialTreatmentDate, CurrentIllnessDate,
			SimilarIllnessDate, EmploymentRelatedFlag, AutoAccidentRelatedFlag, OtherAccidentRelatedFlag, 
			AbuseRelatedFlag, AutoAccidentRelatedState, LastWorkedDate, ReturnToWorkDate, DisabilityBeginDate, 
			DisabilityEndDate, HospitalizationBeginDate, HospitalizationEndDate)
SELECT PatientID, 'Case', 1, 5, CASE WHEN RPI=0 THEN NULL ELSE RPI END,
       CASE WHEN IT=0 THEN NULL ELSE CAST(IT AS DATETIME) END, 
       CASE WHEN CI=0 THEN NULL ELSE CAST(CI AS DATETIME) END,
       CASE WHEN SI=0 THEN NULL ELSE CAST(SI AS DATETIME) END,
       ERF, AARF, OA, ARF , CASE WHEN AARS='00' THEN NULL ELSE AARS END,
       CASE WHEN LW=0 THEN NULL ELSE CAST(LW AS DATETIME) END,
       CASE WHEN RW=0 THEN NULL ELSE CAST(RW AS DATETIME) END,
       CASE WHEN DB=0 THEN NULL ELSE CAST(DB AS DATETIME) END,
       CASE WHEN DE=0 THEN NULL ELSE CAST(DE AS DATETIME) END,
       CASE WHEN HB=0 THEN NULL ELSE CAST(HB AS DATETIME) END,
       CASE WHEN HE=0 THEN NULL ELSE CAST(HE AS DATETIME) END
FROM #Cases
ORDER BY PatientCaseID

--Create Insurances and related Authorization records for cases
CREATE TABLE #UpdateAuth_All(PatientCaseID INT, PatientID INT, EncounterID INT, PatientAuthorizationID INT,
I1 INT, I2 INT, I3 INT, I4 INT)
INSERT INTO #UpdateAuth_All(PatientCaseID, PatientID, EncounterID, PatientAuthorizationID, I1, I2, I3, I4)
SELECT C.PatientCaseID, C.PatientID, EncounterID, PatientAuthorizationID, I1, I2, I3, I4
FROM Encounter E INNER JOIN #Cases C ON E.Patientid=C.PatientID AND E.CI=C.CI AND E.RPI=C.RPI AND E.IT=C.IT AND E.SI=C.SI AND
E.EmploymentRelatedFlag=C.ERF AND E.AutoAccidentRelatedFlag=C.AARF AND E.OtherAccidentRelatedFlag=C.OA AND E.AbuseRelatedFlag=C.ARF AND E.AutoAccidentRelatedState=C.AARS AND
E.LW=C.LW AND E.RW=C.RW AND E.DB=C.DB AND E.DE=C.DE AND E.HB=C.HB AND E.HE=C.HE AND E.PI1=C.I1 AND E.PI2=C.I2 AND E.PI3=C.I3
AND E.PI4=C.I4
WHERE C.Type IN ('E','B') AND PatientAuthorizationID IS NOT NULL AND PatientAuthorizationID<>0

INSERT INTO #UpdateAuth_All(PatientCaseID, PatientID, EncounterID, PatientAuthorizationID, I1, I2, I3, I4)
SELECT DISTINCT C.PatientCaseID, C.PatientID, Clm.EncounterID, PatientAuthorizationID, I1, I2, I3, I4
FROM Claim Clm INNER JOIN #Cases C ON Clm.Patientid=C.PatientID AND Clm.CI=C.CI AND Clm.RPI=C.RPI AND Clm.IT=C.IT AND Clm.SI=C.SI AND
Clm.EmploymentRelatedFlag=C.ERF AND Clm.AutoAccidentRelatedFlag=C.AARF AND Clm.OtherAccidentRelatedFlag=C.OA AND Clm.AbuseRelatedFlag=C.ARF AND Clm.AutoAccidentRelatedState=C.AARS AND
Clm.LW=C.LW AND Clm.RW=C.RW AND Clm.DB=C.DB AND Clm.DE=C.DE AND Clm.HB=C.HB AND Clm.HE=C.HE AND Clm.CP1=C.I1 AND Clm.CP2=C.I2 AND Clm.CP3=C.I3
AND Clm.CP4=C.I4 INNER JOIN Encounter E ON Clm.EncounterID=E.EncounterID
WHERE C.Type IN ('C') AND PatientAuthorizationID IS NOT NULL AND PatientAuthorizationID<>0

CREATE TABLE #UpdateAuth(PatientCaseID INT, PatientID INT, PatientAuthorizationID INT,
I1 INT, I2 INT, I3 INT, I4 INT, R1 INT, R2 INT, R3 INT, R4 INT)
INSERT INTO #UpdateAuth(PatientCaseID, PatientID, PatientAuthorizationID, I1, I2, I3, I4)
SELECT DISTINCT PatientCaseID, PatientID, PatientAuthorizationID, I1, I2, I3, I4
FROM #UpdateAuth_All

UPDATE #UpdateAuth SET R1=I1
FROM #UpdateAuth UA INNER JOIN PatientAuthorization PA
ON UA.PatientAuthorizationID=PA.PatientAuthorizationID AND
UA.I1=PatientInsuranceID

UPDATE #UpdateAuth SET R2=I2
FROM #UpdateAuth UA INNER JOIN PatientAuthorization PA
ON UA.PatientAuthorizationID=PA.PatientAuthorizationID AND
UA.I2=PatientInsuranceID

UPDATE #UpdateAuth SET R3=I3
FROM #UpdateAuth UA INNER JOIN PatientAuthorization PA
ON UA.PatientAuthorizationID=PA.PatientAuthorizationID AND
UA.I3=PatientInsuranceID

UPDATE #UpdateAuth SET R4=I4
FROM #UpdateAuth UA INNER JOIN PatientAuthorization PA
ON UA.PatientAuthorizationID=PA.PatientAuthorizationID AND
UA.I4=PatientInsuranceID

UPDATE #UpdateAuth SET R1=PatientInsuranceID
FROM #UpdateAuth UA INNER JOIN PatientAuthorization PA
ON UA.PatientAuthorizationID=PA.PatientAuthorizationID
WHERE I1=0 AND I2=0 AND I3=0 AND I4=0

DECLARE @AuthLoop INT
DECLARE @AuthCounter INT
DECLARE @NewInsurancePolicyID INT

IF DB_NAME()='superbill_0001_dev'
BEGIN
	SELECT @AuthLoop=COUNT(PatientCaseID)+1 FROM #Cases
END
ELSE
BEGIN
	SELECT @AuthLoop=COUNT(PatientCaseID) FROM #Cases
END

SET @AuthCounter=0

WHILE @AuthCounter<@AuthLoop
BEGIN
	
	SET @AuthCounter=@AuthCounter+1
	
	--Update Prec1 Insurances
	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
	SELECT PatientCaseID, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, 1, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, I1
	FROM PatientInsurance PatI INNER JOIN #Cases C ON PatI.PatientInsuranceID=C.I1
	WHERE PatientCaseID=@AuthCounter 

	SET @NewInsurancePolicyID=@@IDENTITY

	INSERT INTO InsurancePolicyAuthorization(InsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
						 ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, Notes, PreviousAuthID)
	SELECT @NewInsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
	       ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, PA.Notes, PA.PatientAuthorizationID
	FROM PatientAuthorization PA INNER JOIN #UpdateAuth UA ON PA.PatientAuthorizationID=UA.PatientAuthorizationID
	AND PA.PatientInsuranceID=UA.R1
	WHERE PatientCaseID=@AuthCounter AND I1<>0 OR PatientCaseID=@AuthCounter AND I2<>0 OR
	      PatientCaseID=@AuthCounter AND I3<>0 OR PatientCaseID=@AuthCounter AND I4<>0

	--Update Prec2 Insurances
	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
	SELECT PatientCaseID, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, 2, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, I2
	FROM PatientInsurance PatI INNER JOIN #Cases C ON PatI.PatientInsuranceID=C.I2
	WHERE PatientCaseID=@AuthCounter 

	SET @NewInsurancePolicyID=@@IDENTITY

	INSERT INTO InsurancePolicyAuthorization(InsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
						 ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, Notes, PreviousAuthID)
	SELECT @NewInsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
	       ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, PA.Notes, PA.PatientAuthorizationID
	FROM PatientAuthorization PA INNER JOIN #UpdateAuth UA ON PA.PatientAuthorizationID=UA.PatientAuthorizationID
	AND PA.PatientInsuranceID=UA.R2
	WHERE PatientCaseID=@AuthCounter AND I1<>0 OR PatientCaseID=@AuthCounter AND I2<>0 OR
	      PatientCaseID=@AuthCounter AND I3<>0 OR PatientCaseID=@AuthCounter AND I4<>0

	--Update Prec3 Insurances
	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
	SELECT PatientCaseID, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, 3, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, I3
	FROM PatientInsurance PatI INNER JOIN #Cases C ON PatI.PatientInsuranceID=C.I3
	WHERE PatientCaseID=@AuthCounter 

	SET @NewInsurancePolicyID=@@IDENTITY

	INSERT INTO InsurancePolicyAuthorization(InsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
						 ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, Notes, PreviousAuthID)
	SELECT @NewInsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
	       ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, PA.Notes, PA.PatientAuthorizationID
	FROM PatientAuthorization PA INNER JOIN #UpdateAuth UA ON PA.PatientAuthorizationID=UA.PatientAuthorizationID
	AND PA.PatientInsuranceID=UA.R3
	WHERE PatientCaseID=@AuthCounter AND I1<>0 OR PatientCaseID=@AuthCounter AND I2<>0 OR
	      PatientCaseID=@AuthCounter AND I3<>0 OR PatientCaseID=@AuthCounter AND I4<>0

	--Update Prec4 Insurances
	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
	SELECT PatientCaseID, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, 4, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, I4
	FROM PatientInsurance PatI INNER JOIN #Cases C ON PatI.PatientInsuranceID=C.I4
	WHERE PatientCaseID=@AuthCounter 

	SET @NewInsurancePolicyID=@@IDENTITY

	INSERT INTO InsurancePolicyAuthorization(InsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
						 ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, Notes, PreviousAuthID)
	SELECT @NewInsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
	       ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, PA.Notes, PA.PatientAuthorizationID
	FROM PatientAuthorization PA INNER JOIN #UpdateAuth UA ON PA.PatientAuthorizationID=UA.PatientAuthorizationID
	AND PA.PatientInsuranceID=UA.R4
	WHERE PatientCaseID=@AuthCounter AND I1<>0 OR PatientCaseID=@AuthCounter AND I2<>0 OR
	      PatientCaseID=@AuthCounter AND I3<>0 OR PatientCaseID=@AuthCounter AND I4<>0

	--handle those authorizations with no active insurance policy set in case
	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt)
	SELECT PatientCaseID, 1 Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, 1, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt
	FROM PatientInsurance PatI INNER JOIN #UpdateAuth UA ON PatI.PatientInsuranceID=UA.R1
	WHERE PatientCaseID=@AuthCounter AND I1=0 AND I2=0 AND I3=0 AND I4=0

	SET @NewInsurancePolicyID=@@IDENTITY

	INSERT INTO InsurancePolicyAuthorization(InsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
						 ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, Notes, PreviousAuthID)
	SELECT @NewInsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
	       ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, PA.Notes, PA.PatientAuthorizationID
	FROM PatientAuthorization PA INNER JOIN #UpdateAuth UA ON PA.PatientAuthorizationID=UA.PatientAuthorizationID
	AND PA.PatientInsuranceID=UA.R1
	WHERE PatientCaseID=@AuthCounter AND I1=0 AND I2=0 AND I3=0 AND I4=0
END

--Delete already populated patient authos
DELETE PA
FROM PatientAuthorization PA INNER  JOIN #UpdateAuth UA
ON PA.PatientAuthorizationID=UA.PatientAuthorizationID

--Start the process of populating cases for unassigned patientinsurances
CREATE TABLE #CasesBasedOnInsA(TID INT IDENTITY(1,1), PatientID INT, PatientInsuranceID INT, PatientAuthorizationID INT, PatientCaseID INT)
INSERT INTO #CasesBasedOnInsA(PatientID, PatientInsuranceID, PatientAuthorizationID)
SELECT PatientID, PatientInsuranceID, PatientAuthorizationID
FROM PatientAuthorization

CREATE TABLE #CasesBasedOnInsB(PatientID INT, PatientInsuranceID INT, PatientCaseID INT)
INSERT INTO #CasesBasedOnInsB(PatientID, PatientInsuranceID)
SELECT PatientID, PatI.PatientInsuranceID
FROM PatientInsurance PatI LEFT JOIN (SELECT DISTINCT PatientInsuranceID FROM #CasesBasedOnInsA) UI
ON PatI.PatientInsuranceID=UI.PatientInsuranceID
WHERE UI.PatientInsuranceID IS NULL

--Delete previously assigned insurances starting with case with 5 claim payers
--So only unassigned are included in this new generic claim
DELETE CBOIB
FROM #CasesBasedOnInsB CBOIB INNER JOIN #CP5 C ON CBOIB.PatientInsuranceID=C.CP1

DELETE CBOIB
FROM #CasesBasedOnInsB CBOIB INNER JOIN #CP5 C ON CBOIB.PatientInsuranceID=C.CP2

DELETE CBOIB
FROM #CasesBasedOnInsB CBOIB INNER JOIN #CP5 C ON CBOIB.PatientInsuranceID=C.CP3

DELETE CBOIB
FROM #CasesBasedOnInsB CBOIB INNER JOIN #CP5 C ON CBOIB.PatientInsuranceID=C.CP4

DELETE CBOIB
FROM #CasesBasedOnInsB CBOIB INNER JOIN #CP5 C ON CBOIB.PatientInsuranceID=C.CP5

--Delete the previously assigned insurances aside from case with 5 claim payers
DELETE CBOIB
FROM #CasesBasedOnInsB CBOIB INNER JOIN #Cases C ON CBOIB.PatientInsuranceID=C.I1

DELETE CBOIB
FROM #CasesBasedOnInsB CBOIB INNER JOIN #Cases C ON CBOIB.PatientInsuranceID=C.I2

DELETE CBOIB
FROM #CasesBasedOnInsB CBOIB INNER JOIN #Cases C ON CBOIB.PatientInsuranceID=C.I3

DELETE CBOIB
FROM #CasesBasedOnInsB CBOIB INNER JOIN #Cases C ON CBOIB.PatientInsuranceID=C.I4

--Populate last generic cases
DECLARE @RCLoop INT
DECLARE @RCCounter INT
DECLARE @RCPatientID INT
DECLARE @RCaseID INT

CREATE TABLE #RemainingCases(TID INT IDENTITY(1,1), PatientID INT)
INSERT INTO #RemainingCases(PatientID)
SELECT DISTINCT PatientID
FROM #CasesBasedOnInsA
UNION ALL
SELECT DISTINCT PatientID
FROM #CasesBasedOnInsB
ORDER BY PatientID

SET @RCLoop=@@ROWCOUNT
SET @RCCounter=0

WHILE @RCCounter<@RCLoop
BEGIN
	SET @RCCounter=@RCCounter+1
	SELECT @RCPatientID=PatientID FROM #RemainingCases WHERE TID=@RCCounter

	INSERT INTO PatientCase(PatientID, Name, Active, PayerScenarioID, ReferringPhysicianID, InitialTreatmentDate, CurrentIllnessDate,
			SimilarIllnessDate, EmploymentRelatedFlag, AutoAccidentRelatedFlag, OtherAccidentRelatedFlag, 
			AbuseRelatedFlag, AutoAccidentRelatedState, LastWorkedDate, ReturnToWorkDate, DisabilityBeginDate, 
			DisabilityEndDate, HospitalizationBeginDate, HospitalizationEndDate)
	VALUES(@RCPatientID, 'Case Ins NA',1,5,NULL,NULL,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL)

	SET @RCaseID=@@IDENTITY

	--Upate Case ID's for next step
	UPDATE #CasesBasedOnInsA SET PatientCaseID=@RCaseID
	WHERE PatientID=@RCPatientID

	UPDATE #CasesBasedOnInsB SET PatientCaseID=@RCaseID
	WHERE PatientID=@RCPatientID
END

DECLARE @IALoop INT
DECLARE @IACounter INT
DECLARE @IANewInsID INT
DECLARE @IACurrPatientInsuranceID INT
DECLARE @IACurrAuthoID INT

SELECT @IALoop=COUNT(TID) FROM #CasesBasedOnInsA
SET @IACounter=0

WHILE @IACounter<@IALoop
BEGIN
	SET @IACounter=@IACounter+1
	SELECT @IACurrPatientInsuranceID=PatientInsuranceID
	FROM #CasesBasedOnInsA
	WHERE TID=@IACounter

	INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
	SELECT PatientCaseID, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
				    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
				    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
				    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
				    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
				    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
				    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
				    Notes, Phone, PhoneExt, Fax, FaxExt, PatI.PatientInsuranceID
	FROM PatientInsurance PatI INNER JOIN #CasesBasedOnInsA C ON PatI.PatientInsuranceID=C.PatientInsuranceID
	WHERE TID=@IACounter

	SET @IANewInsID=@@IDENTITY

	INSERT INTO InsurancePolicyAuthorization(InsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
						 ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, Notes, PreviousAuthID)
	SELECT @IANewInsID, AuthorizationNumber, AuthorizedNumberOfVisits, StartDate, EndDate,
	       ContactFullname, ContactPhone, ContactPhoneExt, AuthorizationStatusID, PA.Notes, PA.PatientAuthorizationID
	FROM PatientAuthorization PA INNER JOIN #CasesBasedOnInsA C ON PA.PatientAuthorizationID=C.PatientAuthorizationID
	WHERE PA.PatientInsuranceID=@IACurrPatientInsuranceID

	DELETE #CasesBasedOnInsA WHERE PatientInsuranceID=@IACurrPatientInsuranceID	
END

--Populate Remaining Insurances into InsurancePolicy
INSERT INTO InsurancePolicy(PatientCaseID, Active, Copay, Deductible, PatientInsuranceNumber,
			    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
			    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
			    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
			    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
			    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
			    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
			    Notes, Phone, PhoneExt, Fax, FaxExt, PrevPatientInsuranceID)
SELECT PatientCaseID, CASE WHEN Deleted=1 THEN 0 ELSE 1 END Active, 0 Copay, 0 Deductible, NULL PatientInsuranceNumber,
			    InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber,
			    PolicyStartDate, PolicyEndDate, CardOnFile, HolderDifferentThanPatient,
			    PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, HolderLastName,
			    HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName,
			    PatientInsuranceStatusID, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, 
			    HolderState, HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber,
			    Notes, Phone, PhoneExt, Fax, FaxExt, PatI.PatientInsuranceID
FROM PatientInsurance PatI INNER JOIN #CasesBasedOnInsB C ON PatI.PatientInsuranceID=C.PatientInsuranceID

DROP TABLE #CP5
DROP TABLE #CPNot5
DROP TABLE #Encounters
DROP TABLE #Common
DROP TABLE #Cases
DROP TABLE #DupEncountersI
DROP TABLE #DupEncountersII
DROP TABLE #DupEncountersIII
DROP TABLE #DupEncountersIV
DROP TABLE #EncountersList
DROP TABLE #DupProcedures
DROP TABLE #DupEncounters
DROP TABLE #UpdateList
DROP TABLE #UpdateAuth_All
DROP TABLE #UpdateAuth
DROP TABLE #CasesBasedOnInsA
DROP TABLE #CasesBasedOnInsB
DROP TABLE #RemainingCases
PRINT '--ý Create Cases'

--ý Remove Modifications to Claim and Encounter used for migration purposes
--Drop Migration Indexes
DROP INDEX Claim.IX_Claim_Migration
DROP INDEX Encounter.IX_Encounter_Migration

--Put back deleted clustered indexes that where removed for case migration
CREATE CLUSTERED INDEX CI_Encounter_PracticeID_EncounterID
ON Encounter (PracticeID, EncounterID)

CREATE CLUSTERED INDEX CI_Claim_PracticeID_ClaimID
ON Claim (PracticeID, ClaimID)

--Remove comparison columns
ALTER TABLE Claim DROP COLUMN CI, RPI, IT, SI, LW, RW, 
DB, DE, HB, HE, CP1, CP2, CP3, CP4, CP5
GO

ALTER TABLE Encounter DROP COLUMN CI, RPI, IT, SI, LW, RW, 
DB, DE, HB, HE, PI1, PI2, PI3, PI4
GO

PRINT '--ý Remove Modifications to Claim and Encounter used for migration purposes'

--ý Add FK to PatientCase on Encounter
ALTER TABLE Encounter ADD CONSTRAINT FK_PatientCase_PatientCaseID
FOREIGN KEY (PatientCaseID) REFERENCES PatientCase (PatientCaseID)
ON DELETE NO ACTION ON UPDATE NO ACTION
PRINT '--ý Add FK to PatientCase on Encounter'

GO

--ý Add Column to Claim AssignedInsurancePolicyID
ALTER TABLE Claim ADD AssignedInsurancePolicyID INT NULL
PRINT '--ý Add Column to Claim AssignedInsurancePolicyID'

GO

--ý Correct affected table column as a result of PatientAuthorizationID being renamed to InsurancePolicyAuthorizationID
ALTER TABLE Appointment ADD InsurancePolicyAuthorizationID INT

ALTER TABLE Encounter ADD InsurancePolicyAuthorizationID INT

GO

UPDATE A SET InsurancePolicyAuthorizationID=IPA.InsurancePolicyAuthorizationID
FROM Appointment A INNER JOIN InsurancePolicyAuthorization IPA ON A.PatientAuthorizationID=IPA.PreviousAuthID

UPDATE E SET InsurancePolicyAuthorizationID=IPA.InsurancePolicyAuthorizationID
FROM Encounter E INNER JOIN InsurancePolicyAuthorization IPA ON E.PatientAuthorizationID=IPA.PreviousAuthID

--Remove migration helper column in InsurancePolicyAuthorization
ALTER TABLE InsurancePolicyAuthorization DROP COLUMN PreviousAuthID

GO
PRINT '--ý Correct affected table column as a result of PatientAuthorizationID being renamed to InsurancePolicyAuthorizationID'

--ý Add PatientCaseID to Appointment Table

ALTER TABLE Appointment ADD PatientCaseID INT

--ý Add PatientCaseID to Appointment Table

---------------------------------------------------------------------------------------
--case 6066 - Bill_EDI and Bill_HCFA need to have their PatientInsuranceIDs migrated

ALTER TABLE Bill_EDI ADD PayerInsurancePolicyID INT NULL, OtherPayerInsurancePolicyID INT NULL
GO

ALTER TABLE Bill_HCFA ADD PayerInsurancePolicyID INT NULL, OtherPayerInsurancePolicyID INT NULL
GO

--ADD INDEXES TO Speed UP joins for updates

CREATE NONCLUSTERED INDEX IX_Bill_EDI_RepresentativeClaimID_PayerPatientInsuranceID
ON Bill_EDI(RepresentativeClaimID, PayerPatientInsuranceID)
GO

CREATE NONCLUSTERED INDEX IX_Bill_HCFA_RepresentativeClaimID_PayerPatientInsuranceID_OtherPayerPatientInsuranceID
ON Bill_HCFA(RepresentativeClaimID, PayerPatientInsuranceID, OtherPayerPatientInsuranceID)
GO

CREATE NONCLUSTERED INDEX IX_InsurancePolicy_PrevPatientInsuranceID
ON InsurancePolicy (PrevPatientInsuranceID)
GO

UPDATE BEDI SET PayerInsurancePolicyID=InsurancePolicyID
FROM Bill_EDI BEDI INNER JOIN Claim C ON BEDI.RepresentativeClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN Encounter E ON EP.EncounterID=E.EncounterID
INNER JOIN InsurancePolicy IP ON E.PatientCaseID=IP.PatientCaseID 
AND BEDI.PayerPatientInsuranceID=IP.PrevPatientInsuranceID

UPDATE BHCFA SET PayerInsurancePolicyID=InsurancePolicyID
FROM Bill_HCFA BHCFA INNER JOIN Claim C ON BHCFA.RepresentativeClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN Encounter E ON EP.EncounterID=E.EncounterID
INNER JOIN InsurancePolicy IP ON E.PatientCaseID=IP.PatientCaseID 
AND BHCFA.PayerPatientInsuranceID=IP.PrevPatientInsuranceID

UPDATE BHCFA SET OtherPayerInsurancePolicyID=InsurancePolicyID
FROM Bill_HCFA BHCFA INNER JOIN Claim C ON BHCFA.RepresentativeClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN Encounter E ON EP.EncounterID=E.EncounterID
INNER JOIN InsurancePolicy IP ON E.PatientCaseID=IP.PatientCaseID 
AND BHCFA.OtherPayerPatientInsuranceID=IP.PrevPatientInsuranceID

--DROP unneccesary columns and indexes
DROP INDEX Bill_EDI.IX_Bill_EDI_RepresentativeClaimID_PayerPatientInsuranceID

DROP INDEX Bill_HCFA.IX_Bill_HCFA_RepresentativeClaimID_PayerPatientInsuranceID_OtherPayerPatientInsuranceID

DROP INDEX InsurancePolicy.IX_InsurancePolicy_PrevPatientInsuranceID

ALTER TABLE InsurancePolicy DROP COLUMN PrevPatientInsuranceID

GO

PRINT '--case 6066 - Bill_EDI and Bill_HCFA need to have their PatientInsuranceIDs migrated'

---------------------------------------------------------------------------------------
--case 5373 - Decouple the maintenance of claim metrics from claimtransaction

--ý Create New Tables and indexes

IF EXISTS(SELECT * FROM sysobjects WHERE Name='ClaimAccounting')
BEGIN
	DROP TABLE ClaimAccounting
	DROP TABLE ClaimAccounting_Assignments
	DROP TABLE ClaimAccounting_Billings
END
GO

CREATE TABLE ClaimAccounting(PracticeID INT NOT NULL, TransactionDate SMALLDATETIME NOT NULL, 
PaymentDate SMALLDATETIME NULL, ClaimID INT NOT NULL,
ProviderID INT NOT NULL, PatientID INT NOT NULL, ClaimTransactionID INT NOT NULL, ClaimTransactionTypeCode CHAR(3), 
Status BIT NOT NULL CONSTRAINT  DF_ClaimAccounting_Status DEFAULT 0,
ProcedureCount INT NULL CONSTRAINT DF_ClaimAccounting_ProcedureCount DEFAULT 0,
Amount MONEY, ARAmount MONEY)

CREATE UNIQUE CLUSTERED INDEX CI_ClaimAccounting_PracticeID_TransactionDate_ClaimTransactionID
ON ClaimAccounting (PracticeID, TransactionDate, ClaimTransactionID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_PaymentDate
ON ClaimAccounting (PaymentDate)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_ClaimID
ON ClaimAccounting (ClaimID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_ProviderID
ON ClaimAccounting (ProviderID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_PatientID
ON ClaimAccounting (PatientID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_ClaimTransactionTypeCode
ON ClaimAccounting (ClaimTransactionTypeCode)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Status
ON ClaimAccounting (Status)
GO

CREATE TABLE ClaimAccounting_Assignments(PracticeID INT, TransactionDate SMALLDATETIME, ClaimID INT, ClaimTransactionID INT,
InsurancePolicyID INT, InsuranceCompanyPlanID INT, PatientID INT, LastAssignment BIT CONSTRAINT DF_ClaimAccounting_Assignments_LastAssignment DEFAULT 0,
Status BIT CONSTRAINT DF_ClaimAccounting_Assigments_Status DEFAULT 0)

CREATE UNIQUE CLUSTERED INDEX CI_ClaimAccounting_Assignments_PracticeID_TransactionDate_ClaimTransactionID
ON ClaimAccounting_Assignments (PracticeID, TransactionDate, ClaimTransactionID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Assignments_ClaimID
ON ClaimAccounting_Assignments (ClaimID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Assignments_InsurancePolicyID
ON ClaimAccounting_Assignments (InsurancePolicyID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Assignments_InsuranceCompanyPlanID
ON ClaimAccounting_Assignments (InsuranceCompanyPlanID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Assignments_PatientID
ON ClaimAccounting_Assignments (PatientID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Assignments_LastAssignment
ON ClaimAccounting_Assignments (LastAssignment)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Assignments_Status
ON ClaimAccounting_Assignments (Status)
GO

--BLLs

CREATE TABLE ClaimAccounting_Billings(PracticeID INT, TransactionDate SMALLDATETIME, ClaimID INT, ClaimTransactionID INT,
Status BIT CONSTRAINT DF_ClaimAccounting_Billings_Status DEFAULT 0)

CREATE UNIQUE CLUSTERED INDEX CI_ClaimAccounting_Billings_PracticeID_TransactionDate_ClaimTransactionID
ON ClaimAccounting_Billings (PracticeID, TransactionDate, ClaimTransactionID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Billings_ClaimID
ON ClaimAccounting_Billings (ClaimID)

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_Billings_Status
ON ClaimAccounting_Billings (Status)
GO


--ý Create New Tables and indexes

--ý Populate ClaimAccounting

--Insert all transactions including all BLL trans, the next step will delete all but the 1st BLL in the insert batch
INSERT INTO ClaimAccounting(PracticeID, TransactionDate, ClaimID, ProviderID, PatientID,  ClaimTransactionID,
			    ClaimTransactionTypeCode, Status, ProcedureCount, Amount, ARAmount)
SELECT PracticeID, CAST(CONVERT(CHAR(10),TransactionDate,110) AS SMALLDATETIME) TransactionDate, ClaimID, Claim_ProviderID,
       PatientID, ClaimTransactionID, ClaimTransactionTypeCode,
       CASE WHEN ClaimTransactionTypeCode='END' THEN 1 ELSE 0 END Status, 0 ProcedureCount,
       CASE WHEN ClaimTransactionTypeCode='BLL' THEN 0 ELSE Amount END Amount,
       0 ARAmount
FROM ClaimTransaction
WHERE ClaimTransactionTypeCode IN ('CST','BLL','PAY','ADJ','END')
ORDER BY PracticeID, CAST(CONVERT(CHAR(10),TransactionDate,110) AS SMALLDATETIME), Claim_ProviderID, PatientID,
	 ClaimID, CASE WHEN ClaimTransactionTypeCode='CST' THEN 0
		       WHEN ClaimTransactionTypeCode='BLL' THEN 1
		       WHEN ClaimTransactionTypeCode='PAY' THEN 2
		       WHEN ClaimTransactionTypeCode='ADJ' THEN 3
		       WHEN ClaimTransactionTypeCode='END' THEN 4 END

--Delete Voided Claims
DELETE CA
FROM ClaimAccounting CA INNER JOIN VoidedClaims VC 
ON CA.ClaimID=VC.ClaimID

--Delete all but the first BLL transaction per claim
CREATE TABLE #FirstBLLs  (ClaimID INT, ClaimTransactionID INT)
INSERT #FirstBLLs(ClaimID, ClaimTransactionID)
SELECT ClaimID, MIN(ClaimTransactionID) ClaimTransactionID
FROM ClaimTransaction
WHERE ClaimTransactionTypeCode='BLL'
GROUP BY ClaimID

DELETE CA
FROM ClaimAccounting CA INNER JOIN #FirstBLLs FB ON CA.ClaimID=FB.ClaimID
AND CA.ClaimTransactionTypeCode='BLL'
WHERE CA.ClaimTransactionID<>FB.ClaimTransactionID

--Use @FirstBLLs result to set ARAmounts
CREATE TABLE #ClaimAmounts(ClaimID INT, Amount MONEY)
INSERT #ClaimAmounts(ClaimID, Amount)
SELECT ClaimID, Amount
FROM ClaimAccounting
WHERE ClaimTransactionTypeCode='CST'

UPDATE CA SET ARAmount=ClmA.Amount
FROM ClaimAccounting CA INNER JOIN #FirstBLLs FB ON CA.ClaimTransactionID=FB.ClaimTransactionID
INNER JOIN #ClaimAmounts ClmA ON FB.ClaimID=ClmA.ClaimID

--SET PAY, ADJ, and END ARAmounts
UPDATE CA SET ARAmount=-1*Amount
FROM ClaimAccounting CA INNER JOIN #FirstBLLs FB ON CA.ClaimID=FB.ClaimID
WHERE ClaimTransactionTypeCode NOT IN ('CST','BLL')

--Update all records with a Status of 1 if claim has been closed
UPDATE CA SET Status=1
FROM ClaimAccounting CA INNER JOIN Claim C ON CA.ClaimID=C.ClaimID
WHERE ClaimStatusCode='C'

--Update ProcedureCount
UPDATE CA SET ProcedureCount=ISNULL(EP.ServiceUnitCount,0)
FROM ClaimAccounting CA INNER JOIN Claim C ON CA.ClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
WHERE CA.ClaimTransactionTypeCode='CST'

--Update PaymentDate
UPDATE CA SET PaymentDate=CAST(CONVERT(CHAR(10),ISNULL(P.PaymentDate,CA.TransactionDate),110) AS SMALLDATETIME)
FROM ClaimAccounting CA LEFT JOIN PaymentClaimTransaction PCT ON CA.ClaimTransactionID=PCT.ClaimTransactionID
LEFT JOIN Payment P ON PCT.PaymentID=P.PaymentID
WHERE ClaimTransactionTypeCode='PAY'

DROP TABLE #FirstBLLs
DROP TABLE #ClaimAmounts
GO

PRINT '--ý Populate ClaimAccounting'

--ý Populate ClaimAccounting_Assignments

INSERT INTO ClaimAccounting_Assignments(PracticeID, TransactionDate, ClaimID, ClaimTransactionID, PatientID)
SELECT CT.PracticeID, CAST(CONVERT(CHAR(10),CT.TransactionDate,110) AS SMALLDATETIME) TransactionDate, CT.ClaimID, CT.ClaimTransactionID, 
PatientID
FROM ClaimTransaction CT
WHERE ClaimTransactionTypeCode='ASN'
ORDER BY CT.PracticeID, CAST(CONVERT(CHAR(10),CT.TransactionDate,110) AS SMALLDATETIME), CT.ClaimID

DELETE CAA
FROM ClaimAccounting_Assignments CAA INNER JOIN  VoidedClaims VC ON CAA.ClaimID=VC.ClaimID

UPDATE CAA SET Status=1
FROM ClaimAccounting_Assignments CAA INNER JOIN Claim C ON CAA.ClaimID=C.ClaimID
WHERE ClaimStatusCode='C'

CREATE TABLE #MaxIDs(ClaimID INT, ClaimTransactionID INT)
INSERT #MaxIDs(ClaimID, ClaimTransactionID)
SELECT ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
FROM ClaimAccounting_Assignments
GROUP BY ClaimID

UPDATE CAA SET LastAssignment=1
FROM ClaimAccounting_Assignments CAA INNER JOIN #MaxIDs MI ON
CAA.ClaimTransactionID=MI.ClaimTransactionID

DROP TABLE #MaxIDs
GO

PRINT '--ý Populate ClaimAccounting_Assignments'

--ý UPDATE InsurancePolicyID in ClaimAccounting_Assignments & ReferenceID IN ClaimTransaction

CREATE TABLE #ASN(ClaimTransactionID INT, ClaimID INT, Precedence INT, PatientCaseID INT, InsurancePolicyID INT, InsuranceCompanyPlanID INT)
INSERT INTO #ASN(ClaimTransactionID, ClaimID, Precedence)
SELECT ClaimTransactionID, CT.ClaimID, CAST(Code AS INT) Precedence
FROM ClaimTransaction CT LEFT JOIN VoidedClaims VC ON CT.ClaimID=VC.ClaimID
WHERE ClaimTransactionTypeCode='ASN' AND ISNUMERIC(Code)=1 AND VC.ClaimID IS NULL

UPDATE A SET PatientCaseID=E.PatientCaseID
FROM #ASN A INNER JOIN Claim C ON A.ClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN Encounter E ON EP.EncounterID=E.EncounterID

UPDATE A SET InsurancePolicyID=IP.InsurancePolicyID, InsuranceCompanyPlanID=IP.InsuranceCompanyPlanID
FROM #ASN A INNER JOIN InsurancePolicy IP ON A.PatientCaseID=IP.PatientCaseID
AND A.Precedence=IP.Precedence

DECLARE @ASNExceptions TABLE(PatientCaseID INT, MinPrec INT, MinInsurancePolicyID INT, MinInsuranceCompanyPlanID INT)
INSERT @ASNExceptions(PatientCaseID)
SELECT DISTINCT PatientCaseID
FROM #ASN
WHERE PatientCaseID IS NOT NULL AND InsurancePolicyID IS NULL

UPDATE AE SET MinPrec=PS.MinPrec
FROM @ASNExceptions AE INNER JOIN (
SELECT AE.PatientCaseID, MIN(Precedence) MinPrec
FROM InsurancePolicy IP INNER JOIN @ASNExceptions AE ON IP.PatientCaseID=AE.PatientCaseID
GROUP BY AE.PatientCaseID) PS ON AE.PatientCaseID=PS.PatientCaseID

UPDATE AE SET MinInsurancePolicyID=PS.MinInsurancePolicyID, MinInsuranceCompanyPlanID=PS.MinInsuranceCompanyPlanID
FROM @ASNExceptions AE INNER JOIN (
SELECT AE.PatientCaseID, MIN(InsurancePolicyID) MinInsurancePolicyID, MIN(InsuranceCompanyPlanID) MinInsuranceCompanyPlanID
FROM InsurancePolicy IP INNER JOIN @ASNExceptions AE ON IP.PatientCaseID=AE.PatientCaseID
AND IP.Precedence=AE.MinPrec
GROUP BY AE.PatientCaseID) PS ON AE.PatientCaseID=PS.PatientCaseID

UPDATE A SET InsurancePolicyID=MinInsurancePolicyID, InsuranceCompanyPlanID=MinInsuranceCompanyPlanID
FROM #ASN A INNER JOIN @ASNExceptions AE ON A.PatientCaseID=AE.PatientCaseID
WHERE A.InsurancePolicyID IS NULL

UPDATE CAA SET InsurancePolicyID=ASN.InsurancePolicyID, InsuranceCompanyPlanID=ASN.InsuranceCompanyPlanID
FROM ClaimAccounting_Assignments CAA INNER JOIN #ASN ASN ON CAA.ClaimTransactionID=ASN.ClaimTransactionID

UPDATE CT SET ReferenceID=ASN.InsurancePolicyID
FROM ClaimTransaction CT INNER JOIN #ASN ASN ON CT.ClaimTransactionID=ASN.ClaimTransactionID

DROP TABLE #ASN
GO

PRINT '--ý UPDATE InsurancePolicyID in ClaimAccounting_Assignments & ReferenceID IN ClaimTransaction'

--ý Populate ClaimAccounting_Billings

INSERT INTO ClaimAccounting_Billings(PracticeID, TransactionDate, ClaimID, ClaimTransactionID)
SELECT CT.PracticeID, CAST(CONVERT(CHAR(10),CT.TransactionDate,110) AS SMALLDATETIME) TransactionDate, CT.ClaimID, CT.ClaimTransactionID
FROM ClaimTransaction CT 
WHERE ClaimTransactionTypeCode='BLL'
ORDER BY CT.PracticeID, CAST(CONVERT(CHAR(10),CT.TransactionDate,110) AS SMALLDATETIME), CT.ClaimID

DELETE CAB
FROM ClaimAccounting_Billings CAB INNER JOIN  VoidedClaims VC ON CAB.ClaimID=VC.ClaimID

UPDATE CAB SET Status=1
FROM ClaimAccounting_Billings CAB INNER JOIN Claim C ON CAB.ClaimID=C.ClaimID
WHERE ClaimStatusCode='C'
GO

PRINT '--ý Populate ClaimAccounting_Billings'

UPDATE STATISTICS ClaimAccounting
UPDATE STATISTICS ClaimAccounting_Billings
UPDATE STATISTICS ClaimAccounting_Assignments
GO

DBCC DBREINDEX(ClaimAccounting)
DBCC DBREINDEX(ClaimAccounting_Billings)
DBCC DBREINDEX(ClaimAccounting_Assignments)
GO

PRINT '--case 5373 - Decouple the maintenance of claim metrics from claimtransaction'

--ý Clear Code Column values for ASN, RAS, AND BLL ClaimTransactions

UPDATE CT SET Code=NULL
FROM ClaimTransaction CT
WHERE ClaimTransactionTypeCode IN ('ASN','RAS','BLL')

GO

PRINT '--ý Clear Code Column values for ASN, RAS, AND BLL ClaimTransactions'

--ý Add Performance boosting Indexes to InsurancePolicy

CREATE NONCLUSTERED INDEX IX_InsurancePolicy_PatientCaseID
ON InsurancePolicy(PatientCaseID)

CREATE NONCLUSTERED INDEX IX_InsurancePolicy_InsuranceCompanyPlanID
ON InsurancePolicy(InsuranceCompanyPlanID)

ALTER TABLE PatientCase ADD PracticeID INT NULL
GO

UPDATE PC SET PracticeID=P.PracticeID
FROM PatientCase PC INNER JOIN Patient P ON PC.PatientID=P.PatientID
GO

ALTER TABLE InsurancePolicy ADD PracticeID INT NULL
GO

UPDATE IP SET PracticeID=PC.PracticeID
FROM InsurancePolicy IP INNER JOIN PatientCase PC ON IP.PatientCaseID=PC.PatientCaseID
GO

ALTER TABLE InsurancePolicy ALTER COLUMN PracticeID INT NOT NULL
GO

ALTER TABLE PatientCase ALTER COLUMN PracticeID INT NOT NULL
GO

CREATE CLUSTERED INDEX CI_PatientCase_PracticeID_PatientCaseID
ON PatientCase (PracticeID, PatientCaseID)

CREATE CLUSTERED INDEX CI_InsurancePolicy_PracticeID_InsurancePolicyID
ON InsurancePolicy (PracticeID, InsurancePolicyID)

DBCC DBREINDEX(PatientCase)

DBCC DBREINDEX(InsurancePolicy)
GO

--ý Add Performance boosting Indexes to InsurancePolicy

---------------------------------------------------------------------------------------
--case 5383 - Added CopayAmount and Deductible fields to the InsuranceCompanyPlan

ALTER TABLE [InsuranceCompanyPlan] 
DROP
	DF_InsuranceCompanyPlan_CoPay,
	COLUMN Copay

ALTER TABLE [InsuranceCompanyPlan]
ADD 
	Copay MONEY NOT NULL CONSTRAINT [DF_InsuranceCompanyPlan_Copay] DEFAULT (0),
	Deductible MONEY NOT NULL CONSTRAINT [DF_InsuranceCompanyPlan_Deductible] DEFAULT (0)

GO

---------------------------------------------------------------------------------------
--case 5986 - Determine method for naming cases during migration process

ALTER TABLE PatientCase ADD Changed INT
GO

CREATE NONCLUSTERED INDEX IX_PatientCase_Change
ON PatientCase (Changed)
GO

DECLARE @RowsToUpdate INT
DECLARE @Count INT

SET @Count=1

CREATE TABLE #PCases(TID INT IDENTITY(1,1), PatientID INT, PatientCaseID INT)
INSERT INTO #PCases(PatientID, PatientCaseID)
SELECT PatientID, MIN(PatientCaseID) PatientCaseID
FROM PatientCase
GROUP BY PatientID

SET @RowsToUpdate=@@ROWCOUNT

WHILE @RowsToUpdate<>0
BEGIN
	UPDATE PC SET Name='CASE '+CAST(@Count AS VARCHAR(4)), Changed=1
	FROM PatientCase PC INNER JOIN #PCases P ON PC.PatientCaseID=P.PatientCaseID
	
	SET @Count=@Count+1	

	DELETE #PCases

	INSERT INTO #PCases(PatientID, PatientCaseID)
	SELECT PatientID, MIN(PatientCaseID) PatientCaseID
	FROM PatientCase
	WHERE Changed IS NULL
	GROUP BY PatientID
	
	SET @RowsToUpdate=@@ROWCOUNT
END

DROP TABLE #PCases

GO

DROP INDEX PatientCase.IX_PatientCase_Change
GO

ALTER TABLE PatientCase DROP COLUMN Changed
GO


--UPDATE Appointments with PatientCaseID if only one PatientCaseID exists for patient

CREATE TABLE #PatientCases(PatientID INT, PatientCaseID INT)
INSERT INTO #PatientCases(PatientID, PatientCaseID)
SELECT PC.PatientID, MIN(PatientCaseID) PatientCaseID
FROM PatientCase PC INNER JOIN (Select DISTINCT PatientID FROM Appointment) A
ON PC.PatientID=A.PatientID
GROUP BY PC.PatientID
HAVING COUNT(PatientCaseID)=1

UPDATE A SET PatientCaseID=PC.PatientCaseID
FROM Appointment A INNER JOIN #PatientCases PC ON A.PatientID=PC.PatientID

DROP TABLE #PatientCases

GO

--Add Foreign Key to InsurancePolicy for Both Bill_EDI & Bill_HCFA

ALTER TABLE Bill_EDI ADD CONSTRAINT FK_Bill_EDI_PayerInsurancePolicyID 
FOREIGN KEY (PayerInsurancePolicyID) REFERENCES InsurancePolicy (InsurancePolicyID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE Bill_HCFA ADD CONSTRAINT FK_Bill_HCFA_PayerInsurancePolicyID 
FOREIGN KEY (PayerInsurancePolicyID) REFERENCES InsurancePolicy (InsurancePolicyID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE Bill_HCFA ADD CONSTRAINT FK_Bill_HCFA_OtherPayerInsurancePolicyID 
FOREIGN KEY (OtherPayerInsurancePolicyID) REFERENCES InsurancePolicy (InsurancePolicyID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

---------------------------------------------------------------------------------------
--case 6241  EClaims: disable processing of monthly reports (no ClaimTransaction records needed)    

-- cleaning out all transactions resulted from previously processed monthly files, about 86,500 rows:
DELETE   ClaimTransaction
WHERE    ClaimTransactionTypeCode = 'EDI' AND (Notes LIKE '%Billing Invoice Confirmation Listing%')
GO

---------------------------------------------------------------------------------------
-- cleaning out all duplicate transactions resulted from previously processed daily files, many, many rows:

	DECLARE @ct_id int,
	        @claim_id int,
	        @practice_id int,
		@patient_id int,
		@provider_id int,
		@reference_date DateTime,
		@ClearinghouseProcessingStatus varchar(2),
		@Notes varchar(1000)

	DECLARE ct_cursor CURSOR READ_ONLY
	FOR	
		SELECT  ClaimTransactionID, ClaimID, PracticeID, PatientID, Claim_ProviderID, ReferenceDate, Code, CONVERT(VARCHAR(1000), Notes)
		FROM    ClaimTransaction
		WHERE   ClaimTransactionTypeCode = 'EDI'

	OPEN ct_cursor

	FETCH NEXT FROM ct_cursor
	INTO	@ct_id, @claim_id, @practice_id, @patient_id, @provider_id, @reference_date, @ClearinghouseProcessingStatus, @Notes

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT 'ct_id ' + CAST(@ct_id AS varchar)

		-- mark duplicate records:
			UPDATE ClaimTransaction
		SET Notes = NULL
			WHERE ClaimTransactionTypeCode = 'EDI'
			AND ClaimID = @claim_id AND ReferenceDate = @reference_date
			AND Code = @ClearinghouseProcessingStatus
			AND CONVERT(VARCHAR(1000), Notes) = @Notes
			AND PracticeID = @practice_id AND PatientID = @patient_id
			AND Claim_ProviderID = @provider_id
			AND ClaimTransactionID <> @ct_id

		FETCH NEXT FROM ct_cursor
		INTO	@ct_id, @claim_id, @practice_id, @patient_id, @provider_id, @reference_date, @ClearinghouseProcessingStatus, @Notes
	END

	CLOSE ct_cursor
	DEALLOCATE ct_cursor
GO

-- now delete transactions that were marked as duplicates above:
DELETE ClaimTransaction
WHERE     (Notes IS NULL) AND (ClaimTransactionTypeCode = 'EDI')
GO

-- correct the ClearinghouseProcessingStatus status wrongly set when EFT checks came, should be "C" for Completed
-- not that it is used anywhere though.
UPDATE  Claim
SET ClearinghouseProcessingStatus = 'C', PayerProcessingStatus = 'EFT Check issued'
WHERE     (ClearinghouseProcessingStatus = 'E')
GO

--This corrects EncounterProcedure records whose ServiceUnitCount AND ServiceChargeAmount
--are not in sync with Claim record
UPDATE EP SET ServiceUnitCount=C.ServiceUnitCount, ServiceChargeAmount=C.ServiceChargeAmount
FROM EncounterProcedure EP INNER JOIN Claim C ON EP.EncounterProcedureID=C.EncounterProcedureID
GO

ALTER TABLE Claim ENABLE TRIGGER ALL
ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL
ALTER TABLE ENCOUNTER ENABLE TRIGGER ALL
ALTER TABLE ENCOUNTERPROCEDURE ENABLE TRIGGER ALL

GO

--Deactivate Patient Cases that have more than one insurancepolicy and all policies are expired
DECLARE @EndDate DATETIME
SET @EndDate=GETDATE()

CREATE TABLE #CasesToDeactivate(PatientCaseID INT, Items INT, Expired INT)
INSERT INTO #CasesToDeactivate(PatientCaseID, Items, Expired)
SELECT PatientCaseID, COUNT(InsurancePolicyID) Items, COUNT(CASE WHEN PolicyEndDate<@EndDate THEN 1 ELSE NULL END) Expired
FROM InsurancePolicy
GROUP BY PatientCaseID
HAVING COUNT(InsurancePolicyID)>1 AND COUNT(InsurancePolicyID)=COUNT(CASE WHEN PolicyEndDate<@EndDate THEN 1 ELSE NULL END)

UPDATE PC SET Active=0
FROM PatientCase PC INNER JOIN #CasesToDeactivate CTD ON PC.PatientCaseID=CTD.PatientCaseID

DROP TABLE #CasesToDeactivate

GO
---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT

/*

DATABASE UPDATE SCRIPT Removal of Schema Section

v1.29.xxxx to v1.30.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------


---------------------------------------------------------------------------------------
--case 5446 - Modify data model to include InsuranceCompany table

IF DB_NAME()='superbill_0001_dev'
BEGIN
-- get rid of obsolete fields that were moved to InsuranceCompany:
 ALTER TABLE InsuranceCompanyPlan DROP CONSTRAINT DF_InsuranceCompanyPlan_InsuranceProgramCode,
 FK_InsuranceCompanyPlan_InsuranceProgram,DF__Insurance__BillS__49659AB2,DF__Insurance__Billi__09EBCAC9,
 DF__Insurance__HCFAD__3E53DAB9,DF__Insurance__HCFAS__3F47FEF2,DF__Insurance__EClai__7798DBBB,
 FK_InsuranceCompanyPlan_HCFADiagnosisReferenceFormat,
 FK_InsuranceCompanyPlan_HCFASameAsInsuredFormat,
 FK_InsuranceCompanyPlan_ProviderNumberType_LocalUse,
 FK_InsuranceCompanyPlan_ProviderNumberType, FK_InsuranceCompanyPlan_GroupNumberType,
 FK_InsuranceCompanyPlan_ClearinghousePayersList
 
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN InsuranceProgramCode
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN HCFADiagnosisReferenceFormatCode
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN HCFASameAsInsuredFormatCode
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN LocalUseFieldTypeCode
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN ProviderNumberTypeID
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN GroupNumberTypeID
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN LocalUseProviderNumberTypeID
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN BillingFormID
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN EClaimsAccepts
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN BillSecondaryInsurance
 ALTER TABLE [InsuranceCompanyPlan] DROP COLUMN ClearinghousePayerID
END
 GO

-- the info in PracticeToInsuranceCompanyPlan has been migrated to PracticeToInsuranceCompany:
DROP TABLE PracticeToInsuranceCompanyPlan

---------------------------------------------------------------------------------------
--case 0000 - Transition to Kareo ProxyMed account

-- this table is obsolete, login info comes from shared - ClearinghouseConnection
DROP TABLE PracticeClearinghouseInfo

GO

---------------------------------------------------------------------------------------
--case 5390 - Migrate existing patients to case model

--ý Drop Claim Column AssignmentIndicator
DROP INDEX Claim.IX_Claim_AssignmentIndicator

ALTER TABLE Claim DROP CONSTRAINT CK_Claim_AssignmentIndicator

ALTER TABLE Claim DROP COLUMN AssignmentIndicator
--ý Drop Claim Column AssignmentIndicator

GO

--ý Drop Claim Columns that will not be moved
DROP INDEX Claim.IX_Claim_FacilityID	
ALTER TABLE Claim DROP COLUMN FacilityID

DROP INDEX Claim.IX_Claim_ReferringProviderID
ALTER TABLE Claim DROP CONSTRAINT FK_Claim_ReferringPhysician
ALTER TABLE Claim DROP COLUMN ReferringProviderID

DROP INDEX Claim.IX_Claim_AuthorizationID
ALTER TABLE Claim DROP COLUMN AuthorizationID

DROP INDEX Claim.IX_Claim_EncounterID
ALTER TABLE Claim DROP COLUMN EncounterID

DROP INDEX Claim.IX_Claim_ReferralDate
DROP INDEX Claim.IX_Claim_LastSeenDate
DROP INDEX Claim.IX_Claim_AcuteManifestationDate
DROP INDEX Claim.IX_Claim_LastXrayDate
DROP INDEX Claim.IX_Claim_SpecialProgramCode
DROP INDEX Claim.IX_Claim_PropertyCasualtyClaimNumber
DROP INDEX Claim.IX_Claim_PlaceOfServiceCode
DROP INDEX Claim.IX_Claim_ProcedureCode
DROP INDEX Claim.IX_Claim_ServiceBeginDate
DROP INDEX Claim.IX_Claim_DiagnosisCode1
DROP INDEX Claim.IX_Claim_DiagnosisCode2
DROP INDEX Claim.IX_Claim_DiagnosisCode3
DROP INDEX Claim.IX_Claim_DiagnosisCode4
DROP INDEX Claim.IX_Claim_DiagnosisCode5
DROP INDEX Claim.IX_Claim_DiagnosisCode6
DROP INDEX Claim.IX_Claim_DiagnosisCode7
DROP INDEX Claim.IX_Claim_DiagnosisCode8
ALTER TABLE Claim DROP CONSTRAINT DF_Claim_AmbulanceTransportFlag
ALTER TABLE Claim DROP CONSTRAINT DF_Claim_SpineTreatmentFlag
ALTER TABLE Claim DROP CONSTRAINT DF_Claim_VisionReplacementFlag
--Added

IF DB_NAME()='superbill_0001_dev'
BEGIN

	ALTER TABLE ClaimTransaction DROP CONSTRAINT DF_ClaimTransaction_IsFirstBill
	ALTER TABLE ClaimTransaction DROP CONSTRAINT DF_ClaimTransaction_Claim_TotalBalance
	ALTER TABLE ClaimTransaction DROP CONSTRAINT DF_ClaimTransaction_Claim_Amount
	ALTER TABLE ClaimTransaction DROP CONSTRAINT DF_ClaimTransaction_Claim_TotalAdjustments
	ALTER TABLE ClaimTransaction DROP CONSTRAINT DF_ClaimTransaction_Claim_TotalPayments
	DROP STATISTICS ClaimTransaction.hind_750625717_3A_16A_27A_1A_18A
	
	ALTER TABLE ClaimTransaction DROP COLUMN Claim_TotalBalance,Claim_ARBalance,Claim_PatientBalance,Claim_Amount,
	Claim_TotalAdjustments,Claim_TotalPayments,IsFirstBill
END

ALTER TABLE Claim DROP COLUMN OrderDate, ReferralDate, LastSeenDate, AcuteManifestationDate,
LastMenstrualDate, LastXrayDate, EstimatedBirthDate,
HearingVisionPrescriptionDate, ProviderSignatureOnFileFlag,
MedicareAssignmentCode, ReleaseOfInformationCode, SpecialProgramCode,
PropertyCasualtyClaimNumber, ServiceAuthorizationExceptionCode,
MammographyCertificationNumber, CLIANumber, APGNumber, IDENumber,
AmbulanceTransportFlag, AmbulanceCode, AmbulanceReasonCode,
AmbulanceDistance, AmbulanceCertificationCode1,
AmbulanceCertificationCode2, AmbulanceCertificationCode3,
AmbulanceCertificationCode4, AmbulanceCertificationCode5,
SpineTreatmentFlag, SpineTreatmentNumber, SpineTreatmentCount,
SpineSubluxationLevelCode, SpineSubluxationLevelEndCode,
SpineTreatmentPeriodCount, SpineTreatmentMonthlyCount,
SpinePatientConditionCode, SpineComplicationFlag, SpineXrayAvailableFlag,
VisionReplacementFlag, VisionReplacementTypeCode, VisionReplacementConditionCode,
PatientPaidAmount, PlaceOfServiceCode, ProcedureCode, TypeOfServiceCode,
ServiceBeginDate, ServiceChargeAmount, ServiceUnitCount, 
ProcedureModifier1, ProcedureModifier2, ProcedureModifier3,
ProcedureModifier4, DiagnosisPointer1, DiagnosisPointer2,
DiagnosisPointer3, DiagnosisPointer4, D1, D2, D3, D4, AssignedInsurancePolicyID


--ý Drop Claim Columns that will not be moved

GO

--ý Drop Claim Columns that will be moved to PatientCase
DROP INDEX Claim.IX_Claim_RenderingProviderID
ALTER TABLE Claim DROP COLUMN RenderingProviderID

DROP INDEX Claim.IX_Claim_InitialTreatmentDate
ALTER TABLE Claim DROP COLUMN InitialTreatmentDate

DROP INDEX Claim.IX_Claim_CurrentIllnessDate
ALTER TABLE Claim DROP COLUMN CurrentIllnessDate

DROP INDEX Claim.IX_Claim_SimilarIllnessDate
ALTER TABLE Claim DROP COLUMN SimilarIllnessDate

DROP INDEX Claim.IX_Claim_DisabilityBeginDate
ALTER TABLE Claim DROP COLUMN DisabilityBeginDate

DROP INDEX Claim.IX_Claim_DisabilityEndDate
ALTER TABLE Claim DROP COLUMN DisabilityEndDate

DROP INDEX Claim.IX_Claim_LastWorkedDate
ALTER TABLE Claim DROP COLUMN LastWorkedDate

DROP INDEX Claim.IX_Claim_ReturnToWorkDate
ALTER TABLE Claim DROP COLUMN ReturnToWorkDate

DROP INDEX Claim.IX_Claim_HospitalizationBeginDate
ALTER TABLE Claim DROP COLUMN HospitalizationBeginDate

DROP INDEX Claim.IX_Claim_HospitalizationEndDate
ALTER TABLE Claim DROP COLUMN HospitalizationEndDate

DROP INDEX Claim.IX_Claim_AutoAccidentRelatedFlag
ALTER TABLE Claim DROP COLUMN AutoAccidentRelatedFlag

DROP INDEX Claim.IX_Claim_AutoAccidentRelatedState
ALTER TABLE Claim DROP COLUMN AutoAccidentRelatedState

DROP INDEX Claim.IX_Claim_AbuseRelatedFlag
ALTER TABLE Claim DROP COLUMN AbuseRelatedFlag

DROP INDEX Claim.IX_Claim_EmploymentRelatedFlag
ALTER TABLE Claim DROP COLUMN EmploymentRelatedFlag

DROP INDEX Claim.IX_Claim_OtherAccidentRelatedFlag
ALTER TABLE Claim DROP COLUMN OtherAccidentRelatedFlag
--ý Drop Claim Columns that will be moved to PatientCase

GO

ALTER TABLE ClaimTransaction DROP CONSTRAINT CK_ClaimTransaction_AssignedToType
GO

ALTER TABLE ClaimTransaction DROP COLUMN AssignedToType,AssignedToID
GO

--ý Drop migrated EncounterProcedure Columns
ALTER TABLE EncounterProcedure DROP COLUMN DiagnosisID1,
DiagnosisID2, DiagnosisID3, DiagnosisID4
--ý Drop migrated EncounterProcedure Columns

GO

--ý Drop Claim Columns that will be moved to EncounterProcedure
ALTER TABLE Claim DROP COLUMN DiagnosisCode1,
DiagnosisCode2, DiagnosisCode3, DiagnosisCode4,
DiagnosisCode5, DiagnosisCode6, DiagnosisCode7,
DiagnosisCode8

ALTER TABLE Claim DROP COLUMN ServiceEndDate
--ý Drop Claim Columns that will be moved to EncounterProcedure

GO

--ý Drop Encounter Columns that will not be moved anywhere
ALTER TABLE Encounter DROP CONSTRAINT DF_Encounter_PaymentMethodType
ALTER TABLE Encounter DROP COLUMN PaymentMethodType

ALTER TABLE Encounter DROP CONSTRAINT DF_Encounter_DoctorSignature
ALTER TABLE Encounter DROP COLUMN DoctorSignature
--ý Drop Encounter Columns that will not be moved anywhere

GO

--ý Drop Encounter Columns that will be moved to PatientCase
ALTER TABLE Encounter DROP CONSTRAINT FK_Encounter_ReferringPhysician
DROP INDEX Encounter.IX_Encounter_PracticeID_RefPhyID
ALTER TABLE Encounter DROP COLUMN ReferringPhysicianID

ALTER TABLE Encounter DROP CONSTRAINT DF__Encounter__AutoA__16700691
ALTER TABLE Encounter DROP COLUMN AutoAccidentRelatedFlag

ALTER TABLE Encounter DROP CONSTRAINT DF__Encounter__Abuse__17642ACA
ALTER TABLE Encounter DROP COLUMN AbuseRelatedFlag

ALTER TABLE Encounter DROP CONSTRAINT DF__Encounter__Emplo__18584F03
ALTER TABLE Encounter DROP COLUMN EmploymentRelatedFlag

ALTER TABLE Encounter DROP CONSTRAINT DF__Encounter__Other__194C733C
ALTER TABLE Encounter DROP COLUMN OtherAccidentRelatedFlag

ALTER TABLE Encounter DROP COLUMN DateOfInjury, SimilarIllnessDate,
LastWorkedDate, ReturnToWorkDate, DisabilityBeginDate,
DisabilityEndDate, HospitalizationBeginDate, HospitalizationEndDate,
InitialTreatmentDate, AutoAccidentRelatedState,
PatientConditionType, PatientConditionOtherDescription
--ý Drop Encounter Columns that will be moved to PatientCase

GO

--ý Drop ClaimPayer and EncounterToPatientInsurance
DROP TABLE ClaimPayer
DROP TABLE EncounterToPatientInsurance
--ý Drop ClaimPayer and EncounterToPatientInsurance
GO

--ý Drop PatientAuthorization Table which was converted to InsurancePolicyAuthos
DROP TABLE PatientAuthorization
--ý Drop PatientAuthorization Table which was converted to InsurancePolicyAuthos

GO

--ý Drop PatientInsurance Table which was converted to InsurancePolicy
DROP TABLE PatientInsurance
--ý Drop PatientInsurance Table which was converted to InsurancePolicy

GO

ALTER TABLE Appointment DROP COLUMN PatientAuthorizationID

DROP INDEX Encounter.IX_Encounter_PatientID_PatientAuthorizationID

ALTER TABLE Encounter DROP COLUMN PatientAuthorizationID

GO

---------------------------------------------------------------------------------------
--case 6066 - Bill_EDI and Bill_HCFA need to have their PatientInsuranceIDs migrated
ALTER TABLE Bill_EDI DROP COLUMN PayerPatientInsuranceID
GO

ALTER TABLE Bill_HCFA DROP COLUMN PayerPatientInsuranceID, OtherPayerPatientInsuranceID
GO

--Remove Obsolete DashBoard Summarization Support Tables
DROP TABLE DashBoardARAgingDisplay
DROP TABLE DashBoardARAgingVolatile
DROP TABLE DashBoardReceiptsDisplay
DROP TABLE DashBoardReceiptsVolatile
DROP TABLE SummaryTransactionByProviderPerDay
GO

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
