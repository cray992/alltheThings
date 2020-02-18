HPI Full FinalStage


--DROP DATABASE [KMB_Full_1_22]

CREATE DATABASE [KMB_Full_1_22]

USE KareoDBA
GO 

 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Adjustment'
SELECT * 
INTO KMB_Full_1_22.dbo.Adjustment
FROM dbo.getAdjustment WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.AdjustmentGroup'
SELECT * 
INTO KMB_Full_1_22.dbo.AdjustmentGroup
FROM dbo.getAdjustmentGroup WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.AdjustmentReason'
SELECT * 
INTO KMB_Full_1_22.dbo.AdjustmentReason
FROM dbo.getAdjustmentReason WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Appointmentreason'
SELECT * 
INTO KMB_Full_1_22.dbo.Appointmentreason
FROM dbo.getAppointmentreason WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Appointments'
SELECT * 
INTO KMB_Full_1_22.dbo.Appointments
FROM dbo.getAppointment WITH (NOLOCK)
WHERE CreatedDate > GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Appointmenttoappointmentreason'
SELECT * 
INTO KMB_Full_1_22.dbo.Appointmenttoappointmentreason
FROM dbo.getAppointmenttoappointmentreason WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Appointmenttoresource'
SELECT *
INTO KMB_Full_1_22.dbo.Appointmenttoresource
FROM dbo.getAppointmenttoresource WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.AppointmentType'
SELECT *
INTO KMB_Full_1_22.dbo.AppointmentType
FROM dbo.getAppointmentType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.AppointmentConfirmationStatus'
SELECT *
INTO KMB_Full_1_22.dbo.AppointmentConfirmationStatus
FROM dbo.getAppointmentConfirmationStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.AppointmentResourceType'
SELECT *
INTO KMB_Full_1_22.dbo.AppointmentResourceType
FROM dbo.getAppointmentResourceType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.BillBatchType'
SELECT * 
INTO KMB_Full_1_22.dbo.BillBatchType
FROM dbo.getBillBatchType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.BillClaim'
SELECT * 
INTO KMB_Full_1_22.dbo.BillClaim
FROM dbo.getBillClaim WITH (NOLOCK)
WHERE c.CreatedDate > GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.BillingInvoicing_RcmTerms'
SELECT * 
INTO KMB_Full_1_22.dbo.BillingInvoicing_RcmTerms 
FROM  superbill_shared.dbo.BillingInvoicing_RcmTerms WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.BillingInvoicing_RcmTerms_PaymentCategoryTerms'
SELECT * 
INTO KMB_Full_1_22.dbo.BillingInvoicing_RcmTerms_PaymentCategoryTerms
FROM  superbill_shared.dbo.BillingInvoicing_RcmTerms_PaymentCategoryTerms (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.CapitatedAccount'
SELECT * 
INTO KMB_Full_1_22.dbo.CapitatedAccount
FROM dbo.getCapitatedAccount WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.CapitatedAccountToPayment'
SELECT * 
INTO KMB_Full_1_22.dbo.CapitatedAccountToPayment
FROM dbo.getCapitatedAccountToPayment WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Category'
SELECT * 
INTO KMB_Full_1_22.dbo.Category
FROM dbo.getCategory WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Claim'
SELECT * 
INTO KMB_Full_1_22.dbo.Claim
FROM dbo.getClaim WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimAccounting'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimAccounting
FROM dbo.getClaimAccounting WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimAccounting_Assignments'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimAccounting_Assignments
FROM dbo.getClaimAccounting_Assignments WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimAccounting_Billings'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimAccounting_Billings
FROM dbo.getClaimAccounting_Billings WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimAccounting_Errors'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimAccounting_Errors
FROM dbo.getClaimAccounting_Errors WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimAccounting_FollowUp'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimAccounting_FollowUp
FROM dbo.getClaimAccounting_FollowUp WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimResponseStatus'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimResponseStatus
FROM dbo.getClaimResponseStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimStatus'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimStatus
FROM dbo.getClaimStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimPaymentStatus'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimPaymentStatus
FROM dbo.getClaimPaymentStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimSettings'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimSettings
FROM dbo.getClaimSettings WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimStatusCode'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimStatusCode
FROM dbo.getClaimStatusCode WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimStateFollowUp'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimStateFollowUp
FROM dbo.getClaimStateFollowUp WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimTransaction'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimTransaction
FROM dbo.getClaimTransaction WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimTransactionType'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimTransactionType
FROM dbo.getClaimTransactionType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClaimTransactionTypeError'
SELECT * 
INTO KMB_Full_1_22.dbo.ClaimTransactionTypeError
FROM dbo.getClaimTransactionTypeError WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClearinghouseResponse'
SELECT * 
INTO KMB_Full_1_22.dbo.ClearinghouseResponse
FROM dbo.getClearinghouseResponse WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClearinghouseEnrollmentStatusType'
SELECT * 
INTO KMB_Full_1_22.dbo.ClearinghouseEnrollmentStatusTypesponse
FROM dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClearinghousePayersList'
SELECT * 
INTO KMB_Full_1_22.dbo.ClearinghousePayersList
FROM dbo.getClearinghousePayersList WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClearinghouseResponsePatientStatement'
SELECT * 
INTO KMB_Full_1_22.dbo.ClearinghouseResponsePatientStatement
FROM dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClearinghouseResponseReportType'
SELECT * 
INTO KMB_Full_1_22.dbo.ClearinghouseResponseReportType
FROM dbo.getClearinghouseResponseReportType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClearinghouseResponseType'
SELECT * 
INTO KMB_Full_1_22.dbo.ClearinghouseResponseType
FROM dbo.getClearinghouseResponseType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ClearinghouseResponseSourceType'
SELECT * 
INTO KMB_Full_1_22.dbo.ClearinghouseResponseSourceType
FROM dbo.getClearinghouseResponseSourceType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ContractsAndFees_ContractRate'
SELECT * 
INTO KMB_Full_1_22.dbo.ContractsAndFees_ContractRate
FROM dbo.getContractsAndFees_ContractRate WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ContractsAndFees_ContractRateSchedule'
SELECT * 
INTO KMB_Full_1_22.dbo.ContractsAndFees_ContractRateSchedule
FROM dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ContractsAndFees_ContractRateScheduleLink'
SELECT * 
INTO KMB_Full_1_22.dbo.ContractsAndFees_ContractRateScheduleLink
FROM dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ContractsAndFees_StandardFee'
SELECT * 
INTO KMB_Full_1_22.dbo.ContractsAndFees_StandardFee
FROM dbo.getContractsAndFees_StandardFee WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ContractsAndFees_StandardFeeSchedule'
SELECT * 
INTO KMB_Full_1_22.dbo.ContractsAndFees_StandardFeeSchedule
FROM dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ContractsAndFees_StandardFeeScheduleLink'
SELECT * 
INTO KMB_Full_1_22.dbo.ContractsAndFees_StandardFeeScheduleLink
FROM dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Doctor'
SELECT * 
INTO KMB_Full_1_22.dbo.Doctor
FROM dbo.getDoctor WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Encounter'
SELECT * 
INTO KMB_Full_1_22.dbo.Encounter
FROM dbo.getEncounter WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.EncounterProcedure'
SELECT * 
INTO KMB_Full_1_22.dbo.EncounterProcedure
FROM dbo.getEncounterProcedure WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.EncounterStatus'
SELECT * 
INTO KMB_Full_1_22.dbo.EncounterStatus
FROM dbo.getEncounterStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.EnrollmentPayer'
SELECT * 
INTO KMB_Full_1_22.dbo.EnrollmentPayer
FROM dbo.getEnrollmentPayer WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.GroupNumberType'
SELECT * 
INTO KMB_Full_1_22.dbo.GroupNumberType
FROM dbo.getGroupNumberType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.HCFADiagnosisReferenceFormat'
SELECT * 
INTO KMB_Full_1_22.dbo.HCFADiagnosisReferenceFormat
FROM dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.HCFASameAsInsuredFormat'
SELECT * 
INTO KMB_Full_1_22.dbo.HCFASameAsInsuredFormat
FROM dbo.getHCFASameAsInsuredFormat WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.InsuranceCompany'
SELECT * 
INTO KMB_Full_1_22.dbo.InsuranceCompany
FROM dbo.getInsuranceCompany WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.InsuranceCompanyPlan'
SELECT * 
INTO KMB_Full_1_22.dbo.InsuranceCompanyPlan
FROM dbo.getInsuranceCompanyPlan WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.InsurancePolicy'
SELECT * 
INTO KMB_Full_1_22.dbo.InsurancePolicy
FROM dbo.getInsurancePolicy WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.InsuranceProgram'
SELECT * 
INTO KMB_Full_1_22.dbo.InsuranceProgram
FROM dbo.getInsuranceProgram WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.InsuranceProgramType'
SELECT * 
INTO KMB_Full_1_22.dbo.InsuranceProgramType
FROM dbo.getInsuranceProgramType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Patient'
SELECT * 
INTO KMB_Full_1_22.dbo.Patient
FROM dbo.getPatient WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PatientCase'
SELECT * 
INTO KMB_Full_1_22.dbo.PatientCase
FROM dbo.getPatientCase WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PayerProcessingStatusType'
SELECT * 
INTO KMB_Full_1_22.dbo.PayerProcessingStatusType
FROM dbo.getPayerProcessingStatusType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PayerScenario'
SELECT * 
INTO KMB_Full_1_22.dbo.PayerScenario
FROM dbo.getPayerScenario WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Payment'
SELECT * 
INTO KMB_Full_1_22.dbo.Payment
FROM dbo.getPayment WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PaymentClaim'
SELECT * 
INTO KMB_Full_1_22.dbo.PaymentClaim
FROM dbo.getPaymentClaim WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
-- PRINT''
-- PRINT'Inserting INTO KMB_Full_1_22.dbo.Payment'
--SELECT PaymentID, PracticeID, PaymentAmount, PaymentMethodCode, PayerTypeCode, PayerID, PaymentNumber, Description, CreatedDate, ModifiedDate, TIMESTAMP, SourceEncounterID, PostingDate, PaymentTypeID, DefaultAdjustmentCode, BatchID, CreatedUserID, 
--ModifiedUserID, SourceAppointmentID, CONVERT(XML,EOBEditable)AS EOBEditable, AdjudicationDate, ClearinghouseResponseID, CONVERT(XML,ERAErrors)AS ERAErrors, AppointmentID, AppointmentStartDate, PaymentCateGOryID, overrideClosingDate, IsOnline 
--INTO KMB_Full_1_22.dbo.Payment
--FROM OPENQUERY (  [LAS-PDW-D005] ,'SELECT PaymentID, PracticeID, PaymentAmount, PaymentMethodCode, PayerTypeCode, PayerID, PaymentNumber, Description, CreatedDate, ModifiedDate, TIMESTAMP, SourceEncounterID, PostingDate, PaymentTypeID, DefaultAdjustmentCode, BatchID, CreatedUserID, 
--ModifiedUserID, SourceAppointmentID, CONVERT(nvarchar (MAX),EOBEditable)AS EOBEditable, AdjudicationDate, ClearinghouseResponseID, CONVERT(nvarchar (MAX),ERAErrors)as ERAErrors, AppointmentID, AppointmentStartDate, PaymentCateGOryID, overrideClosingDate, IsOnline 
--FROM dbo.getPayment WITH (NOLOCK)
----WHERE CreatedDate>GETDATE()-365' )  
-- PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
-- GO
-- PRINT''
-- PRINT'Inserting INTO KMB_Full_1_22.dbo.PaymentClaim'
-- SELECT PaymentClaimID, PaymentID, PracticeID, PatientID, EncounterID, ClaimID, CONVERT(XML,EOBXml)AS EOBXml, --CONVERT(XML,RawEOBXml0)AS RawEOBXml0, 
--Notes, Reversed, Draft, HasError, ErrorMsg, PaymentRawEOBID
--INTO KMB_Full_1_22.dbo.PaymentClaim
--FROM OPENQUERY( [LAS-PDW-D005] ,'SELECT pc.PaymentClaimID, pc.PaymentID, pc.PracticeID, pc.PatientID, pc.EncounterID, pc.ClaimID, convert(nvarchar (MAX),pc.EOBXml) as EOBXml, --convert(nvarchar (MAX),pc.RawEOBXml)as RawEOBXml, 
--pc.Notes, pc.Reversed, pc.Draft, pc.HasError, pc.ErrorMsg, pc.PaymentRawEOBID
--FROM dbo.getPaymentClaim pc with (nolock)
--	JOIN dbo.getPayment p with (nolock) ON p.PaymentID=pc.PaymentID')	
--GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PaymentAuthorization'
SELECT * 
INTO KMB_Full_1_22.dbo.PaymentAuthorization
FROM dbo.getPaymentAuthorization WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PaymentPatient'
SELECT * 
INTO KMB_Full_1_22.dbo.PaymentPatient
FROM dbo.getPaymentPatient WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PaymentMethod'
SELECT * 
INTO KMB_Full_1_22.dbo.PaymentMethod
FROM dbo.getPaymentMethodCode WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PaymentMethodCode'
SELECT * 
INTO KMB_Full_1_22.dbo.PaymentMethodCode
FROM dbo.getPaymentMethodCode WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PaymentMethodType'
SELECT * 
INTO KMB_Full_1_22.dbo.PaymentMethodType
FROM dbo.getPaymentMethodType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PayerTypeCode'
SELECT * 
INTO KMB_Full_1_22.dbo.PayerTypeCode
FROM dbo.getPayerTypeCode WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PaymentType'
SELECT * 
INTO KMB_Full_1_22.dbo.PaymentType
FROM dbo.getPaymentType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Practice'
SELECT * 
INTO KMB_Full_1_22.dbo.Practice
FROM dbo.getPractice WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PracticeInsuranceGroupNumber'
SELECT * 
INTO KMB_Full_1_22.dbo.PracticeInsuranceGroupNumber
FROM dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.PracticeToInsuranceCompany'
SELECT * 
INTO KMB_Full_1_22.dbo.PracticeToInsuranceCompany
FROM dbo.getPracticeToInsuranceCompany WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ProcedureCodeDictionary'
SELECT * 
INTO KMB_Full_1_22.dbo.ProcedureCodeDictionary
FROM dbo.getProcedureCodeDictionary WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ProductDomain_Product'
SELECT * 
INTO KMB_Full_1_22.dbo.ProductDomain_Product
FROM dbo.ProductDomain_Product WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ProductDomain_ProductSubscription'
SELECT * 
INTO KMB_Full_1_22.dbo.ProductDomain_ProductSubscription
FROM dbo.ProductDomain_ProductSubscription WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Provider'
SELECT * 
INTO KMB_Full_1_22.dbo.Provider
FROM dbo.getDoctor WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ProviderNumber'
SELECT * 
INTO KMB_Full_1_22.dbo.ProviderNumber
FROM dbo.getProviderNumber WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ProviderNumberType'
SELECT * 
INTO KMB_Full_1_22.dbo.ProviderNumberType
FROM dbo.getProviderNumberType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ProviderSpecialty'
SELECT * 
INTO KMB_Full_1_22.dbo.ProviderSpecialty
FROM dbo.getProviderSpecialty WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Refund'
SELECT * 
INTO KMB_Full_1_22.dbo.Refund
FROM dbo.getRefund WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.RefundStatusCode'
SELECT * 
INTO KMB_Full_1_22.dbo.RefundStatusCode
FROM dbo.getRefundStatusCode WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.RefundToPayments'
SELECT * 
INTO KMB_Full_1_22.dbo.RefundToPayments
FROM dbo.getRefundToPayments WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.ServiceLocation'
SELECT * 
INTO KMB_Full_1_22.dbo.ServiceLocation
FROM dbo.getServiceLocation WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Task'
SELECT * 
INTO KMB_Full_1_22.dbo.Task
FROM dbo.getTask WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.TaskStatus'
SELECT * 
INTO KMB_Full_1_22.dbo.TaskStatus
FROM dbo.getTaskStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.TaskType'
SELECT * 
INTO KMB_Full_1_22.dbo.TaskType
FROM dbo.getTaskType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.TypeOfService'
SELECT * 
INTO KMB_Full_1_22.dbo.TypeOfService
FROM dbo.getTypeOfService WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO KMB_Full_1_22.dbo.Users'
SELECT * 
INTO KMB_Full_1_22.dbo.Users
FROM dbo.getUsers WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
