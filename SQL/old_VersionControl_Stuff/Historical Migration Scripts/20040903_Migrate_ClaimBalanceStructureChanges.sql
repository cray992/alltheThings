BEGIN TRAN 

IF NOT EXISTS(SELECT * FROM ClaimTransactionType CTT WHERE CTT.ClaimTransactionTypeCode = 'CST')
	INSERT INTO [dbo].[ClaimTransactionType] ([ClaimTransactionTypeCode], [TypeName]) 
	VALUES ('CST', 'Claim created')

IF NOT EXISTS(SELECT * FROM ClaimTransactionType CTT WHERE CTT.ClaimTransactionTypeCode = 'EDI')
	INSERT INTO [dbo].[ClaimTransactionType] ([ClaimTransactionTypeCode], [TypeName]) 
	VALUES ('EDI', 'PROXYMED Response')

/*
Script created by SQL Compare from Red Gate Software Ltd at 9/3/2004 13:37:21
Run this script on k0.kareo.ent.superbill_build to make [dbo].[fn_DateOnly] the same as on k0.kareo.ent.superbill_merge
Please back up your database before running this script
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
PRINT N'Creating [dbo].[fn_DateOnly]'
GO
CREATE FUNCTION dbo.fn_DateOnly(@dtDate datetime)
RETURNS datetime AS
BEGIN

    DECLARE @TempDate datetime;
    SELECT @TempDate = Cast(Convert(varchar(10), @dtDate,101) as datetime)
    RETURN @TempDate;
END

GO

/*
Script created by SQL Compare from Red Gate Software Ltd at 9/3/2004 13:31:59
Run this script on k0.kareo.ent.superbill_build to make [dbo].[Claim] the same as on k0.kareo.ent.superbill_merge
Please back up your database before running this script
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
PRINT N'Dropping statistics [hind_251968074_1A_2A] from [dbo].[Claim]'
GO
DROP STATISTICS [dbo].[Claim].[hind_251968074_1A_2A]
GO
PRINT N'Dropping statistics [hind_251968074_1A_2A_3A_4A_5A_7A_80A] from [dbo].[Claim]'
GO
DROP STATISTICS [dbo].[Claim].[hind_251968074_1A_2A_3A_4A_5A_7A_80A]
GO
PRINT N'Dropping statistics [hind_251968074_1A_3A_4A_5A_2A_7A_80A] from [dbo].[Claim]'
GO
DROP STATISTICS [dbo].[Claim].[hind_251968074_1A_3A_4A_5A_2A_7A_80A]
GO
PRINT N'Dropping statistics [hind_251968074_2A_1A] from [dbo].[Claim]'
GO
DROP STATISTICS [dbo].[Claim].[hind_251968074_2A_1A]
GO
PRINT N'Altering [dbo].[Claim]'
GO
ALTER TABLE [dbo].[Claim] ADD
[ClearinghouseTrackingNumber] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayerTrackingNumber] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClearinghouseProcessingStatus] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayerProcessingStatus] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClearinghousePayer] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
PRINT N'Creating index [IX_Claim_ClearinghouseTrackingNumber] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ClearinghouseTrackingNumber] ON [dbo].[Claim] ([ClearinghouseTrackingNumber])
GO
PRINT N'Creating index [IX_Claim_PayerTrackingNumber] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_PayerTrackingNumber] ON [dbo].[Claim] ([PayerTrackingNumber])
GO
PRINT N'Creating index [IX_Claim_ClearinghouseProcessingStatus] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ClearinghouseProcessingStatus] ON [dbo].[Claim] ([ClearinghouseProcessingStatus])
GO
PRINT N'Creating index [IX_Claim_PayerProcessingStatus] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_PayerProcessingStatus] ON [dbo].[Claim] ([PayerProcessingStatus])
GO
PRINT N'Creating index [IX_Claim_AbuseRelatedFlag] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_AbuseRelatedFlag] ON [dbo].[Claim] ([AbuseRelatedFlag])
GO
PRINT N'Creating index [IX_Claim_AcuteManifestationDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_AcuteManifestationDate] ON [dbo].[Claim] ([AcuteManifestationDate])
GO
PRINT N'Creating index [IX_Claim_AssignmentIndicator] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_AssignmentIndicator] ON [dbo].[Claim] ([AssignmentIndicator])
GO
PRINT N'Creating index [IX_Claim_AuthorizationID] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_AuthorizationID] ON [dbo].[Claim] ([AuthorizationID])
GO
PRINT N'Creating index [IX_Claim_AutoAccidentRelatedFlag] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_AutoAccidentRelatedFlag] ON [dbo].[Claim] ([AutoAccidentRelatedFlag])
GO
PRINT N'Creating index [IX_Claim_AutoAccidentRelatedState] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_AutoAccidentRelatedState] ON [dbo].[Claim] ([AutoAccidentRelatedState])
GO
PRINT N'Creating index [IX_Claim_CID_PID_StatusCode_AssignIndic_Patient_Rendering_ServiceBeginDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_CID_PID_StatusCode_AssignIndic_Patient_Rendering_ServiceBeginDate] ON [dbo].[Claim] ([ClaimID], [PracticeID], [ClaimStatusCode], [AssignmentIndicator], [PatientID], [RenderingProviderID], [ServiceBeginDate])
GO
PRINT N'Creating index [IX_Claim_CID_StatusCode_AssignIndic_Patient_Practice_Rendering_ServiceBeginDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_CID_StatusCode_AssignIndic_Patient_Practice_Rendering_ServiceBeginDate] ON [dbo].[Claim] ([ClaimID], [ClaimStatusCode], [AssignmentIndicator], [PatientID], [PracticeID], [RenderingProviderID], [ServiceBeginDate])
GO
PRINT N'Creating index [IX_Claim_ClaimID_PracticeID] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ClaimID_PracticeID] ON [dbo].[Claim] ([ClaimID], [PracticeID])
GO
PRINT N'Creating index [IX_Claim_ClaimStatusCode] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ClaimStatusCode] ON [dbo].[Claim] ([ClaimStatusCode])
GO
PRINT N'Creating index [IX_Claim_CreatedDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_CreatedDate] ON [dbo].[Claim] ([CreatedDate])
GO
PRINT N'Creating index [IX_Claim_CurrentIllnessDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_CurrentIllnessDate] ON [dbo].[Claim] ([CurrentIllnessDate])
GO
PRINT N'Creating index [IX_Claim_DiagnosisCode1] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisCode1] ON [dbo].[Claim] ([DiagnosisCode1])
GO
PRINT N'Creating index [IX_Claim_DiagnosisCode2] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisCode2] ON [dbo].[Claim] ([DiagnosisCode2])
GO
PRINT N'Creating index [IX_Claim_DiagnosisCode3] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisCode3] ON [dbo].[Claim] ([DiagnosisCode3])
GO
PRINT N'Creating index [IX_Claim_DiagnosisCode4] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisCode4] ON [dbo].[Claim] ([DiagnosisCode4])
GO
PRINT N'Creating index [IX_Claim_DiagnosisCode5] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisCode5] ON [dbo].[Claim] ([DiagnosisCode5])
GO
PRINT N'Creating index [IX_Claim_DiagnosisCode6] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisCode6] ON [dbo].[Claim] ([DiagnosisCode6])
GO
PRINT N'Creating index [IX_Claim_DiagnosisCode7] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisCode7] ON [dbo].[Claim] ([DiagnosisCode7])
GO
PRINT N'Creating index [IX_Claim_DiagnosisCode8] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisCode8] ON [dbo].[Claim] ([DiagnosisCode8])
GO
PRINT N'Creating index [IX_Claim_DiagnosisPointer1] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisPointer1] ON [dbo].[Claim] ([DiagnosisPointer1])
GO
PRINT N'Creating index [IX_Claim_DiagnosisPointer2] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisPointer2] ON [dbo].[Claim] ([DiagnosisPointer2])
GO
PRINT N'Creating index [IX_Claim_DiagnosisPointer3] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisPointer3] ON [dbo].[Claim] ([DiagnosisPointer3])
GO
PRINT N'Creating index [IX_Claim_DiagnosisPointer4] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DiagnosisPointer4] ON [dbo].[Claim] ([DiagnosisPointer4])
GO
PRINT N'Creating index [IX_Claim_DisabilityBeginDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DisabilityBeginDate] ON [dbo].[Claim] ([DisabilityBeginDate])
GO
PRINT N'Creating index [IX_Claim_DisabilityEndDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_DisabilityEndDate] ON [dbo].[Claim] ([DisabilityEndDate])
GO
PRINT N'Creating index [IX_Claim_EmploymentRelatedFlag] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_EmploymentRelatedFlag] ON [dbo].[Claim] ([EmploymentRelatedFlag])
GO
PRINT N'Creating index [IX_Claim_EncounterID] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_EncounterID] ON [dbo].[Claim] ([EncounterID])
GO
PRINT N'Creating index [IX_Claim_EncounterProcedureID] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_EncounterProcedureID] ON [dbo].[Claim] ([EncounterProcedureID])
GO
PRINT N'Creating index [IX_Claim_FacilityID] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_FacilityID] ON [dbo].[Claim] ([FacilityID])
GO
PRINT N'Creating index [IX_Claim_HospitalizationBeginDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_HospitalizationBeginDate] ON [dbo].[Claim] ([HospitalizationBeginDate])
GO
PRINT N'Creating index [IX_Claim_HospitalizationEndDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_HospitalizationEndDate] ON [dbo].[Claim] ([HospitalizationEndDate])
GO
PRINT N'Creating index [IX_Claim_InitialTreatmentDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_InitialTreatmentDate] ON [dbo].[Claim] ([InitialTreatmentDate])
GO
PRINT N'Creating index [IX_Claim_LastSeenDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_LastSeenDate] ON [dbo].[Claim] ([LastSeenDate])
GO
PRINT N'Creating index [IX_Claim_LastWorkedDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_LastWorkedDate] ON [dbo].[Claim] ([LastWorkedDate])
GO
PRINT N'Creating index [IX_Claim_LastXrayDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_LastXrayDate] ON [dbo].[Claim] ([LastXrayDate])
GO
PRINT N'Creating index [IX_Claim_LocalUseData] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_LocalUseData] ON [dbo].[Claim] ([LocalUseData])
GO
PRINT N'Creating index [IX_Claim_NonElectronicOverrideFlag] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_NonElectronicOverrideFlag] ON [dbo].[Claim] ([NonElectronicOverrideFlag])
GO
PRINT N'Creating index [IX_Claim_OtherAccidentRelatedFlag] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_OtherAccidentRelatedFlag] ON [dbo].[Claim] ([OtherAccidentRelatedFlag])
GO
PRINT N'Creating index [IX_Claim_PatientID] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_PatientID] ON [dbo].[Claim] ([PatientID])
GO
PRINT N'Creating index [IX_Claim_PlaceOfServiceCode] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_PlaceOfServiceCode] ON [dbo].[Claim] ([PlaceOfServiceCode])
GO
PRINT N'Creating index [IX_Claim_Pracice_ClaimID] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_Pracice_ClaimID] ON [dbo].[Claim] ([PracticeID], [ClaimID])
GO
PRINT N'Creating index [IX_Claim_ProcedureCode] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ProcedureCode] ON [dbo].[Claim] ([ProcedureCode])
GO
PRINT N'Creating index [IX_Claim_PropertyCasualtyClaimNumber] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_PropertyCasualtyClaimNumber] ON [dbo].[Claim] ([PropertyCasualtyClaimNumber])
GO
PRINT N'Creating index [IX_Claim_ReferralDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ReferralDate] ON [dbo].[Claim] ([ReferralDate])
GO
PRINT N'Creating index [IX_Claim_ReferringProviderID] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ReferringProviderID] ON [dbo].[Claim] ([ReferringProviderID])
GO
PRINT N'Creating index [IX_Claim_RenderingProviderID] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_RenderingProviderID] ON [dbo].[Claim] ([RenderingProviderID])
GO
PRINT N'Creating index [IX_Claim_ReturnToWorkDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ReturnToWorkDate] ON [dbo].[Claim] ([ReturnToWorkDate])
GO
PRINT N'Creating index [IX_Claim_ServiceBeginDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ServiceBeginDate] ON [dbo].[Claim] ([ServiceBeginDate])
GO
PRINT N'Creating index [IX_Claim_SimilarIllnessDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_SimilarIllnessDate] ON [dbo].[Claim] ([SimilarIllnessDate])
GO
PRINT N'Creating index [IX_Claim_SpecialProgramCode] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_SpecialProgramCode] ON [dbo].[Claim] ([SpecialProgramCode])
GO
PRINT N'Creating trigger [dbo].[tr_Claim_MaintainClaimAmountInClaimTransaction] on [dbo].[Claim]'
GO

--===========================================================================
-- Maintain Claim amount info in the ClaimTransaction table
--===========================================================================
CREATE TRIGGER dbo.tr_Claim_MaintainClaimAmountInClaimTransaction
ON	dbo.Claim
FOR	INSERT, UPDATE
AS
BEGIN
	IF UPDATE(ServiceChargeAmount) OR UPDATE(ServiceUnitCount)
	BEGIN 

		-- =============================================
		-- Declare and using a READ_ONLY cursor
		-- =============================================
		DECLARE claim_cursor CURSOR
		READ_ONLY
		FOR 
			SELECT I.ClaimID, 
				ISNULL(I.ServiceChargeAmount,0) * ISNULL(I.ServiceUnitCount,0) AS Amount,
				I.PatientID,
				I.PracticeID,
				I.CreatedDate
			FROM inserted I
		
		DECLARE @ClaimID int
		DECLARE @Amount money
		DECLARE @PatientID int
		DECLARE @PracticeID int
		DECLARE @ClaimCreatedDate datetime	
		
		OPEN claim_cursor
		
		FETCH NEXT FROM claim_cursor INTO @ClaimID, @Amount, @PatientID, @PracticeID, @ClaimCreatedDate
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
	
				IF NOT EXISTS(	SELECT *
							FROM dbo.ClaimTransaction CT
							WHERE CT.ClaimID = @ClaimID
								AND CT.ClaimTransactionTypeCode = 'CST'
							)
				BEGIN
					INSERT INTO [dbo].[ClaimTransaction] (
						[Amount],
						[ClaimID],
						[ClaimTransactionTypeCode],
						[Notes],
						[PatientID],
						[PracticeID],
						[TransactionDate],
						CreatedDate)
					VALUES (
						@Amount,
						@ClaimID,
						'CST',
						'Claim created for ' + STR(@Amount,15,2) + '  ',
						@PatientID,
						@PracticeID,
						GETDATE(),
						@ClaimCreatedDate)
				END
				ELSE
				BEGIN 
					--Update the claim start transaction amount
					UPDATE	[dbo].[ClaimTransaction]
						SET	[Amount] = @Amount,
							[ModifiedDate] = GETDATE(),
							[Notes] = CAST(Notes AS varchar(8000)) + 'Claim updated for ' + STR(@Amount,15,2) + '  '
						WHERE ClaimID = @ClaimID
							AND ClaimTransactionTypeCode = 'CST'
				END 
			END
			FETCH NEXT FROM claim_cursor INTO @ClaimID, @Amount, @PatientID, @PracticeID, @ClaimCreatedDate
		END
		
		CLOSE claim_cursor
		DEALLOCATE claim_cursor
	
	END

END

GO
--================================================================================ 

/*
Script created by SQL Compare from Red Gate Software Ltd at 9/3/2004 13:32:54
Run this script on k0.kareo.ent.superbill_build to make [dbo].[ClaimTransaction] the same as on k0.kareo.ent.superbill_merge
Please back up your database before running this script
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
PRINT N'Dropping constraints from [dbo].[ClaimTransaction]'
GO
ALTER TABLE [dbo].[ClaimTransaction] DROP CONSTRAINT [DF__ClaimTran__Creat__1D52D9A1]
GO
PRINT N'Dropping constraints from [dbo].[ClaimTransaction]'
GO
ALTER TABLE [dbo].[ClaimTransaction] DROP CONSTRAINT [DF__ClaimTran__Modif__1E46FDDA]
GO
PRINT N'Dropping statistics [hind_475968872_1A_3A] from [dbo].[ClaimTransaction]'
GO
DROP STATISTICS [dbo].[ClaimTransaction].[hind_475968872_1A_3A]
GO
PRINT N'Dropping statistics [hind_475968872_3A_1A] from [dbo].[ClaimTransaction]'
GO
DROP STATISTICS [dbo].[ClaimTransaction].[hind_475968872_3A_1A]
GO
PRINT N'Altering [dbo].[ClaimTransaction]'
GO
ALTER TABLE [dbo].[ClaimTransaction] ADD
[PatientID] [int] NULL,
[PracticeID] [int] NULL,
[Claim_TotalBalance] [money] NULL CONSTRAINT [DF_ClaimTransaction_Claim_TotalBalance] DEFAULT (0),
[Claim_ARBalance] [money] NULL,
[Claim_PatientBalance] [money] NULL,
[Claim_Amount] [money] NULL CONSTRAINT [DF_ClaimTransaction_Claim_Amount] DEFAULT (0),
[Claim_TotalAdjustments] [money] NULL CONSTRAINT [DF_ClaimTransaction_Claim_TotalAdjustments] DEFAULT (0),
[Claim_TotalPayments] [money] NULL CONSTRAINT [DF_ClaimTransaction_Claim_TotalPayments] DEFAULT (0),
[BatchKey] [uniqueidentifier] NULL,
[Original_ClaimTransactionID] [int] NULL,
[AssignedToType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssignedToID] [int] NULL
ALTER TABLE [dbo].[ClaimTransaction] ALTER COLUMN [CreatedDate] [datetime] NOT NULL
ALTER TABLE [dbo].[ClaimTransaction] ALTER COLUMN [ModifiedDate] [datetime] NOT NULL

GO
PRINT N'Creating index [IX_ClaimTransaction_Practice_CreatedDate_ClaimID] on [dbo].[ClaimTransaction]'
GO
CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_Practice_CreatedDate_ClaimID] ON [dbo].[ClaimTransaction] ([PracticeID], [CreatedDate], [ClaimID])
GO
PRINT N'Adding constraints to [dbo].[ClaimTransaction]'
GO
ALTER TABLE [dbo].[ClaimTransaction] ADD CONSTRAINT [CK_ClaimTransaction_AssignedToType] CHECK (([AssignedToType] = 'O' or ([AssignedToType] = 'P' or [AssignedToType] = 'I')))
GO
PRINT N'Adding constraints to [dbo].[ClaimTransaction]'
GO
ALTER TABLE [dbo].[ClaimTransaction] ADD CONSTRAINT [DF_ClaimTransaction_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ClaimTransaction] ADD CONSTRAINT [DF_ClaimTransaction_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate]
GO
PRINT N'Creating trigger [dbo].[tr_ClaimTransaction_MaintainClaimBalances] on [dbo].[ClaimTransaction]'
GO

--================================================================================ 
/*
Script created by SQL Compare from Red Gate Software Ltd at 9/3/2004 13:33:42
Run this script on k0.kareo.ent.superbill_build to make [dbo].[ClaimDataProvider_UpdateClaimTransactionBalances] the same as on k0.kareo.ent.superbill_merge
Please back up your database before running this script
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
PRINT N'Creating [dbo].[ClaimDataProvider_UpdateClaimTransactionBalances]'
GO

--====================================================================================
-- Used BY the trigger ON the ClaimTransaction INSERT/Update
--====================================================================================
CREATE PROCEDURE dbo.ClaimDataProvider_UpdateClaimTransactionBalances
	@ClaimTransactionID int,
	@BatchKey uniqueidentifier
AS
BEGIN 
	SET NOCOUNT ON
/*********************************************************************************

ClaimTransactionTypeCode	(No column name)
ADJ	646872
ASN	646500
BLL	646737
CST	646499
EDI	886710
END	647066
MEM	663892
PAY	647119
RAS	646873
XXX	648460
*********************************************************************************/ 
--SET @ClaimTransactionID = 646499 --CST
--SET @ClaimTransactionID = 646737 --BLL
--SET @ClaimTransactionID = 646500 --ASN
--SET @ClaimTransactionID = 646872 --ADJ
--SET @ClaimTransactionID = 647119 --PAY
--SET @ClaimTransactionID = 886710 --EDI
--SET @ClaimTransactionID = 663892 --MEM
--SET @ClaimTransactionID = 646873 --RAS
--SET @ClaimTransactionID = 647066 --END
--SET @ClaimTransactionID = 648460 --XXX
	DECLARE @ClaimID int
	DECLARE @Amount money
	DECLARE @ClaimTransactionTypeCode char(3)
	DECLARE @PatientID int
	DECLARE @PracticeID int
	DECLARE @Code varchar(50)
	
	DECLARE @Current_PatientBalance money
	
	--Used to store the code of the last transaction fitting the query
	DECLARE @Last_Code varchar(50)
	
	--Last Transaction for this claim
	DECLARE @Claim_TotalBalance money
	DECLARE @Claim_PatientBalance money
	DECLARE @Claim_ARBalance money
	DECLARE @Claim_Amount money
	DECLARE @Claim_TotalAdjustments money
	DECLARE @Claim_TotalPayments money
	DECLARE @Claim_AssignedToType char(1)
	DECLARE @Claim_AssignedToID int
	--DECLARE @Claim_Payments money
	
	--used to adjust patient balance
	--if the claim was NOT patient assigned at the
	--time of the transaction, then this amount should be SET to 0
	
	DECLARE @PatientAssigned_Amount money
	SET @PatientAssigned_Amount = 0
	
	--Get the info about the current trans to look up the last
	--trans for this patient
	SELECT 
		@ClaimID = CT1.ClaimID,
		@Amount = CT1.Amount,
		@ClaimTransactionTypeCode = CT1.ClaimTransactionTypeCode,
		@PatientID = CT1.PatientID,
		@PracticeID = CT1.PracticeID,
		@Code = CT1.Code
	FROM dbo.ClaimTransaction CT1
	WHERE CT1.ClaimTransactionID = @ClaimTransactionID
	
	--Check to make sure the existing record has the data necessary 
	--to lookup
	IF @PatientID IS NULL OR @PracticeID IS NULL
	BEGIN 
		SELECT 
			@PatientID = C.PatientID,
			@PracticeID = C.PracticeID
		FROM dbo.ClaimTransaction CT1
			INNER JOIN dbo.Claim C
			ON CT1.ClaimID = C.ClaimID
		WHERE CT1.ClaimTransactionID = @ClaimTransactionID
	
		UPDATE CT1
			SET PatientID = @PatientID,
				PracticeID = @PracticeID
		FROM dbo.ClaimTransaction CT1
		WHERE CT1.ClaimTransactionID = @ClaimTransactionID
	END
	
	--Lookup the last claim transaction less than the current transaction
	SELECT 
		@Claim_TotalBalance = CT1.Claim_TotalBalance,
		@Claim_ARBalance = CT1.Claim_ARBalance,
		@Claim_PatientBalance = CT1.Claim_PatientBalance,
		@Claim_Amount = CT1.Claim_Amount,
		@Claim_TotalAdjustments = CT1.Claim_TotalAdjustments,
		@Claim_TotalPayments = CT1.Claim_TotalPayments,
		@Claim_AssignedToType = CT1.AssignedToType,
		@Claim_AssignedToID = CT1.AssignedToID 
	FROM dbo.ClaimTransaction CT1
	WHERE 
		CT1.ClaimTransactionID = (
									SELECT MAX(CT2.ClaimTransactionID)
									FROM dbo.ClaimTransaction CT2
									WHERE CT2.ClaimID = @ClaimID
										AND CT2.ClaimTransactionID < @ClaimTransactionID
								)
	
	--Later, for particular typecodes, we will need the last
	--trans for this claimtransaction's claim
	
	DECLARE @Current_TypeCode char(3)
	SET @Current_TypeCode = @ClaimTransactionTypeCode
	
	--This could be the first transaction for a patient
	--so care should be taken to make sure the money VALUES
	--are non-null VALUES when updated.
	
	IF @Current_TypeCode IN ('EDI', 'END', 'MEM', 'RAS')
	BEGIN
		--PRINT @Current_TypeCode
	
		--Just bring the copy the balance FROM the last record
		UPDATE CT1
			SET Claim_TotalBalance = @Claim_TotalBalance,
				Claim_ARBalance = @Claim_ARBalance,
				Claim_PatientBalance = @Claim_PatientBalance,
				Claim_Amount = @Claim_Amount,
				Claim_TotalAdjustments = @Claim_TotalAdjustments,
				Claim_TotalPayments = @Claim_TotalPayments,
				BatchKey = @BatchKey,
				AssignedToType = @Claim_AssignedToType,
				AssignedToID = @Claim_AssignedToID
		FROM dbo.ClaimTransaction CT1
		WHERE CT1.ClaimTransactionID = @ClaimTransactionID
	END 
	ELSE IF @Current_TypeCode IN ('CST')
	BEGIN
		--Change add an charges
		--PRINT @Current_TypeCode
	
		UPDATE CT1
			SET Claim_TotalBalance = ISNULL(@Claim_TotalBalance,0) + ISNULL(@Amount,0),
				Claim_ARBalance = ISNULL(@Claim_ARBalance, 0),
				Claim_PatientBalance = ISNULL(@Claim_PatientBalance,0),
				Claim_Amount = ISNULL(@Amount,0),
				Claim_TotalAdjustments = ISNULL(@Claim_TotalAdjustments,0),
				Claim_TotalPayments = ISNULL(@Claim_TotalPayments,0),
				BatchKey = @BatchKey,
				AssignedToType = @Claim_AssignedToType,
				AssignedToID = @Claim_AssignedToID
		FROM dbo.ClaimTransaction CT1
		WHERE CT1.ClaimTransactionID = @ClaimTransactionID
	
	END 
	ELSE IF @Current_TypeCode IN ('ASN')
	BEGIN
		--TODO: Need to make sure that same assignment cannot be repeated
		--For example, IF the claim was assigned to the patient and then
		--another assignment occurs, it can't be to the patient again
		--otherwise the patient balance would be increased
	
		--This may NOT matter now, because the patient balance will be recalculated when a payment IS made	
		--Change assignment, could increase the PatientResponsibleBalance
		--PRINT @Current_TypeCode
		
		--If the patient IS being assigned the claim, then
		--the current claim balance goes to the patient
		IF @Code = 'P'
		BEGIN
			--Determine the current claim Balance
			SELECT @Current_PatientBalance = @Claim_Amount - (SUM(Amount))
			FROM dbo.ClaimTransaction CT
			WHERE CT.ClaimID = @ClaimID
				AND CT.ClaimTransactionTypeCode IN ('ADJ','PAY')
				AND CT.ClaimTransactionID < @ClaimTransactionID
		END
		ELSE
		BEGIN
			--Since the claim IS being assign to someone other than the patient
			--set the patientassignamount to 0
			SET @Current_PatientBalance = 0
		END 
	
		UPDATE CT1
			SET Claim_TotalBalance = ISNULL(@Claim_TotalBalance,0) ,
				Claim_ARBalance = ISNULL(@Claim_ARBalance, 0),
				Claim_PatientBalance = ISNULL(@Current_PatientBalance,0),
				Claim_Amount = ISNULL(@Claim_Amount,0),
				Claim_TotalAdjustments = ISNULL(@Claim_TotalAdjustments,0),
				Claim_TotalPayments = ISNULL(@Claim_TotalPayments,0),
				BatchKey = @BatchKey,
				AssignedToType = 	CASE 
									WHEN CT1.Code = 'P' THEN 'P'
									WHEN CT1.Code IN ('1','2','3') THEN 'I'
									ELSE 'O'
									END,
				AssignedToID = 		CASE 
									WHEN CT1.Code = 'P' THEN CT1.PatientID
									WHEN CT1.Code IN ('1','2','3') THEN NULL
									ELSE 0
									END
		FROM dbo.ClaimTransaction CT1
		WHERE CT1.ClaimTransactionID = @ClaimTransactionID
		
		
		IF @Code IN ('1','2','3')
		BEGIN
			UPDATE CT1
				SET AssignedToID = 	PI.InsuranceCompanyPlanID	
			FROM dbo.ClaimTransaction CT1
				INNER JOIN dbo.ClaimPayer CP
				ON CT1.ClaimID = CP.ClaimID
					AND CAST(CT1.Code AS int) = CP.Precedence
				INNER JOIN dbo.PatientInsurance PI
					ON PI.PatientInsuranceID = CP.PatientInsuranceID
			WHERE CT1.ClaimTransactionID = @ClaimTransactionID
		END
	END 
	ELSE IF @Current_TypeCode IN ('BLL')
	BEGIN
		--Increase the ARBalance
		--Check to make sure this IS the first time the claim was billed
		--PRINT @Current_TypeCode
		IF NOT EXISTS(	SELECT *
						FROM dbo.ClaimTransaction CT
						WHERE CT.ClaimID = @ClaimID
							AND CT.ClaimTransactionID < @ClaimTransactionID
							AND CT.ClaimTransactionTypeCode = 'BLL'
					)
		BEGIN
			--This IS the first bill so take the current total balance and assign it to ARBalance
			UPDATE CT1
				SET Claim_TotalBalance = ISNULL(@Claim_TotalBalance,0) ,
					Claim_ARBalance = ISNULL(@Claim_TotalBalance, 0),
					Claim_PatientBalance = ISNULL(@Claim_PatientBalance,0),
					Claim_Amount = ISNULL(@Claim_Amount,0),
					Claim_TotalAdjustments = ISNULL(@Claim_TotalAdjustments,0),
					Claim_TotalPayments = ISNULL(@Claim_TotalPayments,0),
					BatchKey = @BatchKey,
					AssignedToType = @Claim_AssignedToType,
					AssignedToID = @Claim_AssignedToID
			FROM dbo.ClaimTransaction CT1
			WHERE CT1.ClaimTransactionID = @ClaimTransactionID
		END
		ELSE
		BEGIN
			--Just carry the balances down
			UPDATE CT1
				SET Claim_TotalBalance = ISNULL(@Claim_TotalBalance,0) ,
					Claim_ARBalance = ISNULL(@Claim_ARBalance, 0),
					Claim_PatientBalance = ISNULL(@Claim_PatientBalance,0),
					Claim_Amount = ISNULL(@Claim_Amount,0),
					Claim_TotalAdjustments = ISNULL(@Claim_TotalAdjustments,0),
					Claim_TotalPayments = ISNULL(@Claim_TotalPayments,0),
					BatchKey = @BatchKey,
					AssignedToType = @Claim_AssignedToType,
					AssignedToID = @Claim_AssignedToID
			FROM dbo.ClaimTransaction CT1
			WHERE CT1.ClaimTransactionID = @ClaimTransactionID
		END
	END 
	ELSE IF @Current_TypeCode IN ('ADJ', 'PAY')
	BEGIN
		--Reduce the total balance, ARBalance and could patientResponsibleBalance
		--Find out IF this claim IS patient assigned
		--TODO
		--PRINT @Current_TypeCode
	
		--Determine the current claim Balance
		--Include this transaction
		SELECT @Claim_TotalBalance = @Claim_Amount - (SUM(Amount))
		FROM dbo.ClaimTransaction CT
		WHERE CT.ClaimID = @ClaimID
			AND CT.ClaimTransactionTypeCode IN ('ADJ','PAY')
			AND CT.ClaimTransactionID <= @ClaimTransactionID
	
		--Sum up the override adjustments
		SELECT @Claim_TotalAdjustments = (SUM(Amount))
		FROM dbo.ClaimTransaction CT
		WHERE CT.ClaimID = @ClaimID
			AND CT.ClaimTransactionTypeCode IN ('ADJ')
			AND CT.ClaimTransactionID <= @ClaimTransactionID
	
		--Sum up the override payments
		SELECT @Claim_TotalPayments = (SUM(Amount))
		FROM dbo.ClaimTransaction CT
		WHERE CT.ClaimID = @ClaimID
			AND CT.ClaimTransactionTypeCode IN ('PAY')
			AND CT.ClaimTransactionID <= @ClaimTransactionID
	
		IF EXISTS(	SELECT *
						FROM dbo.ClaimTransaction CT
						WHERE CT.ClaimID = @ClaimID
							AND CT.ClaimTransactionID < @ClaimTransactionID
							AND CT.ClaimTransactionTypeCode = 'BLL'
					)
		BEGIN
			--This claim has been billed
			SET @Claim_ARBalance = @Claim_TotalBalance
		END
		ELSE
		BEGIN
			--Since it hasn't been billed yet, the AR Balance IS 0
			SET @Claim_ARBalance = 0	
		END
		
		
		IF (SELECT TOP 1 CT.Code
			FROM dbo.ClaimTransaction CT 
			WHERE CT.ClaimID = @ClaimID	
				AND CT.ClaimTransactionID < @ClaimTransactionID
				AND CT.ClaimTransactionTypeCode = 'ASN'
			ORDER BY CT.ClaimTransactionID DESC) = 'P'
		BEGIN
			--Since the last assingment was to the patient the current balance should be the patient balance
			SET @Claim_PatientBalance = @Claim_TotalBalance
		END
		ELSE
		BEGIN
			--Since the last assignment wasn't to patient, make sure the PatientBalance IS 0
			SET @Claim_PatientBalance = 0
		END
		
		UPDATE CT1
			SET Claim_TotalBalance = ISNULL(@Claim_TotalBalance,0),
				Claim_ARBalance = ISNULL(@Claim_ARBalance, 0),
				Claim_PatientBalance = ISNULL(@Claim_PatientBalance,0),
				Claim_Amount = ISNULL(@Claim_Amount,0),
				Claim_TotalAdjustments = ISNULL(@Claim_TotalAdjustments,0),
				Claim_TotalPayments = ISNULL(@Claim_TotalPayments,0),
				BatchKey = @BatchKey,
				AssignedToType = @Claim_AssignedToType,
				AssignedToID = @Claim_AssignedToID
		FROM dbo.ClaimTransaction CT1
		WHERE CT1.ClaimTransactionID = @ClaimTransactionID
	END 
	ELSE IF @Current_TypeCode IN ('XXX')
	BEGIN
		--Decrease the ARBalance, Balance and maybe patient balance
		--PRINT @Current_TypeCode
	
		--Sum up the override adjustments
		SELECT @Claim_TotalAdjustments = (SUM(Amount))
		FROM dbo.ClaimTransaction CT
		WHERE CT.ClaimID = @ClaimID
			AND CT.ClaimTransactionTypeCode IN ('ADJ')
			AND CT.ClaimTransactionID <= @ClaimTransactionID
	
		--Sum up the override payments
		SELECT @Claim_TotalPayments = (SUM(Amount))
		FROM dbo.ClaimTransaction CT
		WHERE CT.ClaimID = @ClaimID
			AND CT.ClaimTransactionTypeCode IN ('PAY')
			AND CT.ClaimTransactionID <= @ClaimTransactionID
	
		UPDATE CT1
			SET Claim_TotalBalance = 0,
				Claim_ARBalance = 0,
				Claim_PatientBalance = 0,
				Claim_Amount = 0,
				Claim_TotalAdjustments = ISNULL(@Claim_TotalAdjustments,0),
				Claim_TotalPayments = ISNULL(@Claim_TotalPayments,0),
				BatchKey = @BatchKey,
				AssignedToType = @Claim_AssignedToType,
				AssignedToID = @Claim_AssignedToID
		FROM dbo.ClaimTransaction CT1
		WHERE CT1.ClaimTransactionID = @ClaimTransactionID
	END 
	ELSE
	BEGIN
		--Unhandled
		PRINT '!!!UNHANDLED CASE!!!'
		--PRINT @Current_TypeCode
	END 
END


GO



/*
Script created by SQL Compare from Red Gate Software Ltd at 9/3/2004 13:43:06
Run this script on k0.kareo.ent.superbill_build to make [dbo].[PaymentClaimTransaction] the same as on k0.kareo.ent.superbill_merge
Please back up your database before running this script
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
PRINT N'Creating index [IX_PaymentClaimTransaction_ClaimID] on [dbo].[PaymentClaimTransaction]'
GO
CREATE NONCLUSTERED INDEX [IX_PaymentClaimTransaction_ClaimID] ON [dbo].[PaymentClaimTransaction] ([ClaimID])
GO
PRINT N'Creating index [IX_PaymentClaimTransaction_ClaimTransactionID] on [dbo].[PaymentClaimTransaction]'
GO
CREATE NONCLUSTERED INDEX [IX_PaymentClaimTransaction_ClaimTransactionID] ON [dbo].[PaymentClaimTransaction] ([ClaimTransactionID])
GO
PRINT N'Creating index [IX_PaymentClaimTransaction_PaymentID] on [dbo].[PaymentClaimTransaction]'
GO
CREATE NONCLUSTERED INDEX [IX_PaymentClaimTransaction_PaymentID] ON [dbo].[PaymentClaimTransaction] ([PaymentID])
GO
PRINT N'Adding constraints to [dbo].[PaymentClaimTransaction]'
GO

--SELECT ClaimTransactionID, PaymentID, COUNT(*)
--FROM PaymentClaimTransaction
--GROUP BY ClaimTransactionID, PaymentID
--HAVING COUNT(*) > 1
--
--SELECT *
--FROM PaymentClaimTransaction
--WHERE ClaimID IN (42308,
--42308,
--49149)
--
--WHERE ClaimTransactionID IS NULL
--
--HAVING COUNT(*) > 1
SELECT @@TRANCOUNT
BEGIN TRAN 
DELETE PaymentClaimTransaction
WHERE ClaimTransactionID IS NULL
COMMIT
ALTER TABLE [dbo].[PaymentClaimTransaction] ADD CONSTRAINT [UX_PaymentClaimTransaction_ClaimTransactionID_PaymentID] UNIQUE NONCLUSTERED  ([ClaimTransactionID], [PaymentID])
GO

CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_ReferenceID_TypeCode] ON [dbo].[ClaimTransaction]
(	[ReferenceID],
	[ClaimTransactionTypeCode]
) ON [PRIMARY]

GO
--================================================================================ 
--================================================================================ 
--================================================================================
BEGIN TRAN 
DELETE CT
FROM dbo.ClaimTransaction CT
WHERE CT.ClaimTransactionTypeCode = 'CST'


IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.COLUMNS CL
	WHERE CL.COLUMN_NAME = 'Original_ClaimTransactionID'
		AND CL.TABLE_NAME = 'ClaimTransaction'
	)
	ALTER TABLE [dbo].[ClaimTransaction] DROP COLUMN
		[Original_ClaimTransactionID]

GO
--Add the column
ALTER TABLE [dbo].[ClaimTransaction] ADD
	[Original_ClaimTransactionID] int NULL
GO

SELECT @@TRANCOUNT
COMMIT
BEGIN TRAN 

PRINT 'Beginning COUNT'

SELECT COUNT(*)
FROM dbo.ClaimTransaction
--(No column name)
--239370
INSERT INTO [dbo].[ClaimTransaction] (
	[Amount],
	[ClaimID],
	[ClaimTransactionTypeCode],
	[Notes],
	[PatientID],
	[PracticeID],
	[TransactionDate],
	CreatedDate)
SELECT
	ISNULL(C.ServiceChargeAmount,0) * ISNULL(C.ServiceUnitCount,0) AS Amount,
	C.ClaimID,	
	'CST',
	'Claim created for ' + STR(ISNULL(C.ServiceChargeAmount,0) * ISNULL(C.ServiceUnitCount,0),15,2) + '  ',
	C.PatientID,
	C.PracticeID,
	C.CreatedDate,
	C.CreatedDate
FROM dbo.Claim C
--(No column name)
--198534					
--The trigger will fire and add a record for each claim in the claim table

INSERT ClaimTransaction(
	Original_ClaimTransactionID, 
	ClaimTransactionTypeCode, 
	ClaimID, 
	TransactionDate, 
	ReferenceDate, 
	Amount, 
	Quantity, 
	Code, 
	ReferenceID, 
	ReferenceData, 
	Notes, 
	CreatedDate, 
	ModifiedDate
)
SELECT 
	ClaimTransactionID, 
	ClaimTransactionTypeCode, 
	ClaimID, 
	TransactionDate, 
	ReferenceDate, 
	Amount, 
	Quantity, 
	Code, 
	ReferenceID, 
	ReferenceData, 
	Notes, 
	CreatedDate, 
	ModifiedDate
FROM dbo.ClaimTransaction CT
ORDER BY CT.CreatedDate ASC, CT.ClaimTransactionID DESC

/*********************************************************************************
287667
*********************************************************************************/ 

UPDATE PCT
	SET ClaimTransactionID = CT.ClaimTransactionID
FROM dbo.PaymentClaimTransaction PCT
	INNER JOIN dbo.ClaimTransaction CT
	ON PCT.ClaimTransactionID = CT.Original_ClaimTransactionID
--68914
	
DELETE CT
FROM dbo.ClaimTransaction CT
WHERE CT.Original_ClaimTransactionID IS NULL
--287667



PRINT 'Resulting COUNT'
SELECT COUNT(*)
FROM dbo.ClaimTransaction
WHERE ClaimTransactionTypeCode = 'CST'

-- Now re-enable the trigger
--===========================================================================
-- Maintain Claim amount info in the ClaimTransaction table
--===========================================================================
CREATE TRIGGER dbo.tr_ClaimTransaction_MaintainClaimBalances
ON	dbo.ClaimTransaction
FOR	INSERT, UPDATE
AS
BEGIN
	--IF UPDATE(ServiceChargeAmount) OR UPDATE(ServiceUnitCount)
	BEGIN 
		CREATE TABLE #ClaimTransList(ClaimTransactionID int PRIMARY KEY)
		
		-- =============================================
		-- Declare and using a READ_ONLY cursor
		-- =============================================
		DECLARE claimtrans_cursor CURSOR
		READ_ONLY
		FOR 
			SELECT I.ClaimTransactionID,
				I.ClaimID
			FROM inserted I
		
		DECLARE @ClaimTransactionID int
		DECLARE @InsideClaimTransactionID int
		DECLARE @ClaimID int
		
		DECLARE @BatchKey uniqueidentifier
		SET @BatchKey = NEWID()	
	
		OPEN claimtrans_cursor
		
		FETCH NEXT FROM claimtrans_cursor INTO @ClaimTransactionID, @ClaimID
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
				--Do NOT reprocess claimtransactionid's already processed in this group
				IF NOT EXISTS(SELECT * FROM #ClaimTransList WHERE ClaimTransactionID = @ClaimTransactionID)
				BEGIN
					--Update the currently affected transaction
					EXEC dbo.ClaimDataProvider_UpdateClaimTransactionBalances @ClaimTransactionID, @BatchKey
					
					-- =============================================
					-- Declare and using a READ_ONLY cursor
					-- =============================================
					
					--Any future transactions for this claim and UPDATE them AS well
					DECLARE inside_cursor CURSOR
					READ_ONLY
					FOR 
						SELECT ClaimTransactionID
						FROM dbo.ClaimTransaction CT
						WHERE CT.ClaimID = @ClaimID
							AND CT.ClaimTransactionID > @ClaimTransactionID	
					
					OPEN inside_cursor
					
					FETCH NEXT FROM inside_cursor INTO @InsideClaimTransactionID
					WHILE (@@fetch_status <> -1)
					BEGIN
						IF (@@fetch_status <> -2)
						BEGIN
							INSERT #ClaimTransList(ClaimTransactionID)
							VALUES(@InsideClaimTransactionID)
							
							EXEC dbo.ClaimDataProvider_UpdateClaimTransactionBalances @InsideClaimTransactionID, @BatchKey
						END
						FETCH NEXT FROM inside_cursor INTO @InsideClaimTransactionID
					END
					
					CLOSE inside_cursor
					DEALLOCATE inside_cursor
				END
			END
			FETCH NEXT FROM claimtrans_cursor INTO @ClaimTransactionID, @ClaimID
		END
		
		CLOSE claimtrans_cursor
		DEALLOCATE claimtrans_cursor
		
		DROP TABLE #ClaimTransList	
	END
END

GO


-- =============================================
-- Force ClaimTransaction Recalculations
-- =============================================
DECLARE test_cursor CURSOR
READ_ONLY
FOR SELECT MIN(ClaimTransactionID)
FROM claimTransaction
GROUP BY ClaimID

DECLARE @ClaimTransactionID int

OPEN test_cursor

FETCH NEXT FROM test_cursor INTO @ClaimTransactionID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		UPDATE Claimtransaction
			SET ClaimID = ClaimID
		WHERE ClaimTransactionID = @ClaimTransactionID
	END
	FETCH NEXT FROM test_cursor INTO @ClaimTransactionID
END

CLOSE test_cursor
DEALLOCATE test_cursor
GO
