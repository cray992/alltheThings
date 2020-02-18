----HPI Full FinalStage


----DROP DATABASE [HPI_30DayDelta]

--CREATE DATABASE [HPI_30DayDelta]

USE HPI_30DayDelta
GO 

 PRINT''
 PRINT'Inserting INTO Adjustment'
SELECT * 
INTO dbo.Adjustment
FROM dbo.getAdjustment WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO AdjustmentGroup'
SELECT * 
INTO dbo.AdjustmentGroup
FROM dbo.getAdjustmentGroup WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO AdjustmentReason'
SELECT * 
INTO dbo.AdjustmentReason
FROM dbo.getAdjustmentReason WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO Appointmentreason'
SELECT * 
INTO dbo.Appointmentreason
FROM dbo.getAppointmentreason WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO Appointments'
SELECT * 
INTO dbo.Appointments
FROM dbo.getAppointment WITH (NOLOCK)
WHERE CreatedDate > GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO Appointmenttoappointmentreason'
SELECT * 
INTO dbo.Appointmenttoappointmentreason
FROM dbo.getAppointmenttoappointmentreason WITH (NOLOCK)
WHERE ModifiedDate >GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO Appointmenttoresource'
SELECT *
INTO dbo.Appointmenttoresource
FROM dbo.getAppointmenttoresource WITH (NOLOCK)
WHERE ModifiedDate >GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO 
 PRINT''
 PRINT'Inserting INTO AppointmentType'
SELECT *
INTO dbo.AppointmentType
FROM dbo.getAppointmentType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO AppointmentConfirmationStatus'
SELECT *
INTO dbo.AppointmentConfirmationStatus
FROM dbo.getAppointmentConfirmationStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO AppointmentResourceType'
SELECT *
INTO dbo.AppointmentResourceType
FROM dbo.getAppointmentResourceType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
GO
 PRINT''
 PRINT'Inserting INTO BillBatchType'
SELECT * 
INTO dbo.BillBatchType
FROM dbo.getBillBatchType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO BillClaim'
SELECT bc.* 
INTO dbo.BillClaim
FROM dbo.getBillClaim bc WITH (NOLOCK)
	join getClaim c ON c.ClaimID = bc.ClaimID
WHERE c.CreatedDate > GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO BillingInvoicing_RcmTerms'
SELECT rcmt.* 
INTO dbo.BillingInvoicing_RcmTerms 
FROM  sharedserver.superbill_shared.dbo.BillingInvoicing_RcmTerms rcmt WITH (NOLOCK)
	JOIN SHAREDSERVER.DataCollection.dbo.[KMBCustList$] cl ON cl.customerid = rcmt.CustomerID
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO BillingInvoicing_RcmTerms_PaymentCategoryTerms'
SELECT ct.* 
INTO dbo.BillingInvoicing_RcmTerms_PaymentCategoryTerms
FROM  SHAREDSERVER.superbill_shared.dbo.BillingInvoicing_RcmTerms_PaymentCategoryTerms ct (NOLOCK)
	JOIN SHAREDSERVER.DataCollection.dbo.[KMBCustList$] cl ON cl.customerid = ct.CustomerID
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO CapitatedAccount'
SELECT * 
INTO dbo.CapitatedAccount
FROM dbo.getCapitatedAccount WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO CapitatedAccountToPayment'
SELECT * 
INTO dbo.CapitatedAccountToPayment
FROM dbo.getCapitatedAccountToPayment WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO Category'
SELECT * 
INTO dbo.Category
FROM dbo.getCategory WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO Claim'
SELECT * 
INTO dbo.Claim
FROM dbo.getClaim WITH (NOLOCK)
WHERE ModifiedDate > GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimAccounting'
SELECT * 
INTO dbo.ClaimAccounting
FROM dbo.getClaimAccounting WITH (NOLOCK)
WHERE PostingDate > GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimAccounting_Assignments'
SELECT * 
INTO dbo.ClaimAccounting_Assignments
FROM dbo.getClaimAccounting_Assignments WITH (NOLOCK)
WHERE PostingDate > GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimAccounting_Billings'
SELECT * 
INTO dbo.ClaimAccounting_Billings
FROM dbo.getClaimAccounting_Billings WITH (NOLOCK)
WHERE PostingDate > GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimAccounting_Errors'
SELECT * 
INTO dbo.ClaimAccounting_Errors
FROM dbo.getClaimAccounting_Errors WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimAccounting_FollowUp'
SELECT * 
INTO dbo.ClaimAccounting_FollowUp
FROM dbo.getClaimAccounting_FollowUp WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimResponseStatus'
SELECT * 
INTO dbo.ClaimResponseStatus
FROM dbo.getClaimResponseStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimStatus'
SELECT * 
INTO dbo.ClaimStatus
FROM dbo.getClaimStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimPaymentStatus'
SELECT * 
INTO dbo.ClaimPaymentStatus
FROM dbo.getClaimPaymentStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimSettings'
SELECT * 
INTO dbo.ClaimSettings
FROM dbo.getClaimSettings WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimStatusCode'
SELECT * 
INTO dbo.ClaimStatusCode
FROM dbo.getClaimStatusCode WITH (NOLOCK)
WHERE LastModifiedDate >GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimStateFollowUp'
SELECT * 
INTO dbo.ClaimStateFollowUp
FROM dbo.getClaimStateFollowUp WITH (NOLOCK)
WHERE ModifiedDate >GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimTransaction'
SELECT * 
INTO dbo.ClaimTransaction
FROM dbo.getClaimTransaction WITH (NOLOCK)
WHERE ModifiedDate > GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimTransactionType'
SELECT * 
INTO dbo.ClaimTransactionType
FROM dbo.getClaimTransactionType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClaimTransactionTypeError'
SELECT * 
INTO dbo.ClaimTransactionTypeError
FROM dbo.getClaimTransactionTypeError WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClearinghouseResponse'
SELECT * 
INTO dbo.ClearinghouseResponse
FROM dbo.getClearinghouseResponse WITH (NOLOCK)
WHERE FileReceiveDate > GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClearinghouseEnrollmentStatusType'
SELECT * 
INTO dbo.ClearinghouseEnrollmentStatusTypesponse
FROM dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClearinghousePayersList'
SELECT * 
INTO dbo.ClearinghousePayersList
FROM dbo.getClearinghousePayersList WITH (NOLOCK)
WHERE ModifiedDate >GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClearinghouseResponsePatientStatement'
SELECT * 
INTO dbo.ClearinghouseResponsePatientStatement
FROM dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClearinghouseResponseReportType'
SELECT * 
INTO dbo.ClearinghouseResponseReportType
FROM dbo.getClearinghouseResponseReportType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClearinghouseResponseType'
SELECT * 
INTO dbo.ClearinghouseResponseType
FROM dbo.getClearinghouseResponseType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ClearinghouseResponseSourceType'
SELECT * 
INTO dbo.ClearinghouseResponseSourceType
FROM dbo.getClearinghouseResponseSourceType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ContractsAndFees_ContractRate'
SELECT * 
INTO dbo.ContractsAndFees_ContractRate
FROM dbo.getContractsAndFees_ContractRate WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ContractsAndFees_ContractRateSchedule'
SELECT * 
INTO dbo.ContractsAndFees_ContractRateSchedule
FROM dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ContractsAndFees_ContractRateScheduleLink'
SELECT * 
INTO dbo.ContractsAndFees_ContractRateScheduleLink
FROM dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ContractsAndFees_StandardFee'
SELECT * 
INTO dbo.ContractsAndFees_StandardFee
FROM dbo.getContractsAndFees_StandardFee WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ContractsAndFees_StandardFeeSchedule'
SELECT * 
INTO dbo.ContractsAndFees_StandardFeeSchedule
FROM dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ContractsAndFees_StandardFeeScheduleLink'
SELECT * 
INTO dbo.ContractsAndFees_StandardFeeScheduleLink
FROM dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO Doctor'
SELECT * 
INTO dbo.Doctor
FROM dbo.getDoctor WITH (NOLOCK)
WHERE ModifiedDate >GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO Encounter'
SELECT * 
INTO dbo.Encounter
FROM dbo.getEncounter WITH (NOLOCK)
WHERE ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO EncounterProcedure'
SELECT * 
INTO dbo.EncounterProcedure
FROM dbo.getEncounterProcedure WITH (NOLOCK)
WHERE ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO EncounterStatus'
SELECT * 
INTO dbo.EncounterStatus
FROM dbo.getEncounterStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO EnrollmentPayer'
SELECT * 
INTO dbo.EnrollmentPayer
FROM dbo.getEnrollmentPayer WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO GroupNumberType'
SELECT * 
INTO dbo.GroupNumberType
FROM dbo.getGroupNumberType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO HCFADiagnosisReferenceFormat'
SELECT * 
INTO dbo.HCFADiagnosisReferenceFormat
FROM dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO HCFASameAsInsuredFormat'
SELECT * 
INTO dbo.HCFASameAsInsuredFormat
FROM dbo.getHCFASameAsInsuredFormat WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO InsuranceCompany'
SELECT * 
INTO dbo.InsuranceCompany
FROM dbo.getInsuranceCompany WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO InsuranceCompanyPlan'
SELECT * 
INTO dbo.InsuranceCompanyPlan
FROM dbo.getInsuranceCompanyPlan WITH (NOLOCK)
WHERE ModifiedDate >GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO InsurancePolicy'
SELECT * 
INTO dbo.InsurancePolicy
FROM dbo.getInsurancePolicy WITH (NOLOCK)
WHERE ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO InsuranceProgram'
SELECT * 
INTO dbo.InsuranceProgram
FROM dbo.getInsuranceProgram WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO InsuranceProgramType'
SELECT * 
INTO dbo.InsuranceProgramType
FROM dbo.getInsuranceProgramType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO Patient'
SELECT * 
INTO dbo.Patient
FROM dbo.getPatient WITH (NOLOCK)
WHERE ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO PatientCase'
SELECT * 
INTO dbo.PatientCase
FROM dbo.getPatientCase WITH (NOLOCK)
WHERE ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO PayerProcessingStatusType'
SELECT * 
INTO dbo.PayerProcessingStatusType
FROM dbo.getPayerProcessingStatusType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO PayerScenario'
SELECT * 
INTO dbo.PayerScenario
FROM dbo.getPayerScenario WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO Payment'
SELECT * 
INTO dbo.Payment
FROM dbo.getPayment WITH (NOLOCK)
WHERE ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO PaymentClaim'
SELECT pc.* 
INTO dbo.PaymentClaim
FROM dbo.getPaymentClaim pc WITH (NOLOCK)
JOIN dbo.getPayment p ON p.PaymentID = pc.PaymentID
WHERE p.ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
-- PRINT''
-- PRINT'Inserting INTO Payment'
--SELECT PaymentID, PracticeID, PaymentAmount, PaymentMethodCode, PayerTypeCode, PayerID, PaymentNumber, Description, CreatedDate, ModifiedDate, TIMESTAMP, SourceEncounterID, PostingDate, PaymentTypeID, DefaultAdjustmentCode, BatchID, CreatedUserID, 
--ModifiedUserID, SourceAppointmentID, CONVERT(XML,EOBEditable)AS EOBEditable, AdjudicationDate, ClearinghouseResponseID, CONVERT(XML,ERAErrors)AS ERAErrors, AppointmentID, AppointmentStartDate, PaymentCateGOryID, overrideClosingDate, IsOnline 
--INTO dbo.Payment
--FROM OPENQUERY (  [LAS-PDW-D005] ,'SELECT PaymentID, PracticeID, PaymentAmount, PaymentMethodCode, PayerTypeCode, PayerID, PaymentNumber, Description, CreatedDate, ModifiedDate, TIMESTAMP, SourceEncounterID, PostingDate, PaymentTypeID, DefaultAdjustmentCode, BatchID, CreatedUserID, 
--ModifiedUserID, SourceAppointmentID, CONVERT(nvarchar (MAX),EOBEditable)AS EOBEditable, AdjudicationDate, ClearinghouseResponseID, CONVERT(nvarchar (MAX),ERAErrors)as ERAErrors, AppointmentID, AppointmentStartDate, PaymentCateGOryID, overrideClosingDate, IsOnline 
--FROM dbo.getPayment WITH (NOLOCK)
----WHERE CreatedDate>GETDATE()-365' )  
-- PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
-- GO
-- PRINT''
-- PRINT'Inserting INTO PaymentClaim'
-- SELECT PaymentClaimID, PaymentID, PracticeID, PatientID, EncounterID, ClaimID, CONVERT(XML,EOBXml)AS EOBXml, --CONVERT(XML,RawEOBXml0)AS RawEOBXml0, 
--Notes, Reversed, Draft, HasError, ErrorMsg, PaymentRawEOBID
--INTO dbo.PaymentClaim
--FROM OPENQUERY( [LAS-PDW-D005] ,'SELECT pc.PaymentClaimID, pc.PaymentID, pc.PracticeID, pc.PatientID, pc.EncounterID, pc.ClaimID, convert(nvarchar (MAX),pc.EOBXml) as EOBXml, --convert(nvarchar (MAX),pc.RawEOBXml)as RawEOBXml, 
--pc.Notes, pc.Reversed, pc.Draft, pc.HasError, pc.ErrorMsg, pc.PaymentRawEOBID
--FROM dbo.getPaymentClaim pc with (nolock)
--	JOIN dbo.getPayment p with (nolock) ON p.PaymentID=pc.PaymentID')	
--GO
 PRINT''
 PRINT'Inserting INTO PaymentAuthorization'
SELECT * 
INTO dbo.PaymentAuthorization
FROM dbo.getPaymentAuthorization WITH (NOLOCK)
WHERE CreatedDateTime> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO PaymentPatient'
SELECT * 
INTO dbo.PaymentPatient
FROM dbo.getPaymentPatient WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO PaymentMethod'
SELECT * 
INTO dbo.PaymentMethod
FROM dbo.getPaymentMethodCode WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO PaymentMethodCode'
SELECT * 
INTO dbo.PaymentMethodCode
FROM dbo.getPaymentMethodCode WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO PaymentMethodType'
SELECT * 
INTO dbo.PaymentMethodType
FROM dbo.getPaymentMethodType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO PayerTypeCode'
SELECT * 
INTO dbo.PayerTypeCode
FROM dbo.getPayerTypeCode WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO PaymentType'
SELECT * 
INTO dbo.PaymentType
FROM dbo.getPaymentType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO Practice'
SELECT * 
INTO dbo.Practice
FROM dbo.getPractice WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO PracticeInsuranceGroupNumber'
SELECT * 
INTO dbo.PracticeInsuranceGroupNumber
FROM dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO PracticeToInsuranceCompany'
SELECT * 
INTO dbo.PracticeToInsuranceCompany
FROM dbo.getPracticeToInsuranceCompany WITH (NOLOCK)
WHERE ModifiedDate >GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ProcedureCodeDictionary'
SELECT * 
INTO dbo.ProcedureCodeDictionary
FROM dbo.getProcedureCodeDictionary WITH (NOLOCK)
WHERE ModifiedDate >GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ProductDomain_Product'
SELECT * 
INTO dbo.ProductDomain_Product
FROM sharedserver.superbill_shared.dbo.ProductDomain_Product WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ProductDomain_ProductSubscription'
SELECT * 
INTO dbo.ProductDomain_ProductSubscription
FROM sharedserver.superbill_shared.dbo.ProductDomain_ProductSubscription WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO Provider'
SELECT * 
INTO dbo.Provider
FROM dbo.getDoctor WITH (NOLOCK)
WHERE ModifiedDate >GETDATE()-30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ProviderNumber'
SELECT * 
INTO dbo.ProviderNumber
FROM dbo.getProviderNumber WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ProviderNumberType'
SELECT * 
INTO dbo.ProviderNumberType
FROM dbo.getProviderNumberType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ProviderSpecialty'
SELECT * 
INTO dbo.ProviderSpecialty
FROM dbo.getProviderSpecialty WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO Refund'
SELECT * 
INTO dbo.Refund
FROM dbo.getRefund WITH (NOLOCK)
WHERE ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO RefundStatusCode'
SELECT * 
INTO dbo.RefundStatusCode
FROM dbo.getRefundStatusCode WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO RefundToPayments'
SELECT * 
INTO dbo.RefundToPayments
FROM dbo.getRefundToPayments WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO ServiceLocation'
SELECT * 
INTO dbo.ServiceLocation
FROM dbo.getServiceLocation WITH (NOLOCK)
WHERE ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO Task'
SELECT * 
INTO dbo.Task
FROM dbo.getTask WITH (NOLOCK)
WHERE ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO TaskStatus'
SELECT * 
INTO dbo.TaskStatus
FROM dbo.getTaskStatus WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
 PRINT''
 PRINT'Inserting INTO TaskType'
SELECT * 
INTO dbo.TaskType
FROM dbo.getTaskType WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO TypeOfService'
SELECT * 
INTO dbo.TypeOfService
FROM dbo.getTypeOfService WITH (NOLOCK)
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO 
 PRINT''
 PRINT'Inserting INTO Users'
SELECT * 
INTO dbo.Users
FROM dbo.getUsers WITH (NOLOCK)
WHERE ModifiedDate> GETDATE()- 30
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 GO
