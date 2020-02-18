/*

DATABASE UPDATE SCRIPT

v1.17.1648 to v.1.18.xxxx
*/
----------------------------------
--EXEC sp_change_users_login @Action = 'Update_One', @UserNamePattern = 'dev', @LoginName = 'dev'

--BEGIN TRAN 
--BEGIN REMOVE UNREFERENCED FUNCTIONS
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimInsuranceReceiptAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimInsuranceReceiptAmount
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimMedicareReceiptAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimMedicareReceiptAmount
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimPatientReceiptAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimPatientReceiptAmount
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorCollectionRateForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorCollectionRateForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorProcedureChargeAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorProcedureChargeAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorProcedureUnitCountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorProcedureUnitCountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorRefundsForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorRefundsForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_EDIBillTotalBalanceAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_EDIBillTotalBalanceAmount
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_EncounterDiagnosisCode'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_EncounterDiagnosisCode
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_EncounterDiagnosisIndex'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_EncounterDiagnosisIndex
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanCurrentBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanCurrentBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanNinetyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanNinetyDayBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanOneHundredTwentyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanOneHundredTwentyDayBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanOverpaidAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanOverpaidAmount
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanSixtyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanSixtyDayBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanThirtyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanThirtyDayBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanTotalBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanTotalBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientAssignedBalanceToDateHistorical'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientAssignedBalanceToDateHistorical
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientBalanceToDate'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientBalanceToDate
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientBalanceToDateHistorical'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientBalanceToDateHistorical
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientCurrentBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientCurrentBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientLastPaymentAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientLastPaymentAmount
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientNinetyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientNinetyDayBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientOneHundredTwentyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientOneHundredTwentyDayBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientSixtyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientSixtyDayBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientThirtyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientThirtyDayBalance
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientTotalBalanceForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientTotalBalanceForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PaymentPatientAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PaymentPatientAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PaymentUnappliedAmountToDate'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PaymentUnappliedAmountToDate
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeAdjustmentAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION BusinessRule_PracticeAdjustmentAmountForPeriod
	
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeCollectionRateForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeCollectionRateForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeInsuranceReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeInsuranceReceiptAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeMedicareReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeMedicareReceiptAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeNetAccountsReceivableAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeNetAccountsReceivableAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticePatientReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticePatientReceiptAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticePaymentMethodAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticePaymentMethodAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticePaymentsForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticePaymentsForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeProcedureCountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeProcedureCountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeTotalAdjustmentAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeTotalAdjustmentAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'GeneralDataProvider_GetRelatedCausesCodes'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.GeneralDataProvider_GetRelatedCausesCodes
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'GeneralDataProvider_GetReleaseOfInformationCodes'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.GeneralDataProvider_GetReleaseOfInformationCodes
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimDiagnosisPointerCode'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimDiagnosisPointerCode
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimPayerBalanceAmount'
	AND 	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimPayerBalanceAmount
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorAdjustmentAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorAdjustmentAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorInsuranceReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorInsuranceReceiptAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorMedicareReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorMedicareReceiptAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorNetAccountsReceivableForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorNetAccountsReceivableForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorPatientReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorPatientReceiptAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorTotalUnitsForPeriod'
	AND 	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorTotalUnitsForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_EDIBillTotalPaidAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_EDIBillTotalPaidAmount
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientAdjustmentsForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientAdjustmentsForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientChargesForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientChargesForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientLastPaymentDate'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientLastPaymentDate
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientReceiptsForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientReceiptsForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PaymentAppliedAmountToDate'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PaymentAppliedAmountToDate
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PaymentClaimAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PaymentClaimAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeTotalChargeAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeTotalChargeAmountForPeriod
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeTotalReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeTotalReceiptAmountForPeriod
GO

--END REMOVE UNREFERENCED FUNCTIONS

----------------------------------

-- Case 2089, 2207:

ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan] DROP CONSTRAINT [DF__PracticeT__EClai__25918339]
GO
ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan] DROP COLUMN [EClaimsPracticeIsEnrolled]
GO
ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan] DROP CONSTRAINT [DF__PracticeT__EStat__2685A772]
GO
ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan] DROP COLUMN [EStatementsPracticeIsEnrolled]
GO

ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan] ADD [EClaimsEnrollmentStatusID] [int] NULL
GO
ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan] ADD [EClaimsDisable] [int] NOT NULL DEFAULT 0 WITH VALUES
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD [CreatedPracticeID] [int] NULL
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD [Fax] [varchar] (10) NULL
GO
ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD [FaxExt] [varchar] (10) NULL
GO

IF NOT EXISTS (	SELECT * 
				FROM dbo.ClearinghouseEnrollmentStatusType 
				WHERE EnrollmentStatusID = 3)
BEGIN
	INSERT	ClearinghouseEnrollmentStatusType (EnrollmentStatusID, EnrollmentStatusName) 
	VALUES (3, 'Enrolled in test mode')
END

UPDATE dbo.ClearinghouseEnrollmentStatusType 
	SET EnrollmentStatusName='Enrolled in live mode' 
WHERE EnrollmentStatusID=2

DELETE FROM dbo.PracticeToInsuranceCompanyPlan

UPDATE dbo.ProviderNumberType 
	SET ANSIReferenceIdentificationQualifier = 'G2' 
WHERE ProviderNumberTypeID = 1

----------------------------------

-- case 2248

INSERT INTO 
	[Permissions]
	(
		[Name],
		[Description]
	)
VALUES
	(
		'FindPayer',
		'List or select insurance companies or other payers'
	)
GO

INSERT INTO 
	[Permissions]
	(
		[Name],
		[Description]
	)
VALUES
	(
		'ApprovePayer',
		'Toggle the approval status of a payer'
	)
GO

INSERT INTO 
	[Permissions]
	(
		[Name],
		[Description]
	)
VALUES
	(
		'EditPayer',
		'Modify a payer record'
	)
GO

INSERT INTO 
	[Permissions]
	(
		[Name],
		[Description]
	)
VALUES
	(
		'ViewPayer',
		'View the details of a payer record'
	)
GO

INSERT INTO 
	[Permissions]
	(
		[Name],
		[Description]
	)
VALUES
	(
		'MergePayer',
		'Merge multiple payer records into one record'
	)
GO

INSERT INTO 
	[Permissions]
	(
		[Name],
		[Description]
	)
VALUES
	(
		'CreatePayer',
		'Create a new payer'
	)
GO

INSERT INTO 
	[Permissions]
	(
		[Name],
		[Description]
	)
VALUES
	(
		'DeletePayer',
		'Delete an existing payer'
	)
GO

----------------------------------

-- case 2268

CREATE TABLE [dbo].[AppointmentReason] (
	[AppointmentReasonID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Reason] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PracticeID] [int] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE AppointmentReason
	ADD CONSTRAINT [FK_AppointmentReason_Practice] FOREIGN KEY 
	(
		[PracticeID]
	) REFERENCES [Practice] (
		[PracticeID]
	)
GO


ALTER TABLE Appointment
	ADD AppointmentReasonID INT
GO

ALTER TABLE Appointment
	ADD CONSTRAINT [FK_Appointment_AppointmentReason] FOREIGN KEY 
	(
		[AppointmentReasonID]
	) REFERENCES [AppointmentReason] (
		[AppointmentReasonID]
	)
GO


----------------------------------
--ROLLBACK
--COMMIT
