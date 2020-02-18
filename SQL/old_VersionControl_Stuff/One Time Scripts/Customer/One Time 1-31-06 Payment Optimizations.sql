CREATE NONCLUSTERED INDEX IX_RefundToPayments_PaymentID
ON RefundToPayments (PaymentID)

CREATE NONCLUSTERED INDEX IX_InsuranceCompanyPlan_PlanName
ON InsuranceCompanyPlan (PlanName)

CREATE NONCLUSTERED INDEX IX_Payment_PayerTypeCode_PayerID
ON Payment (PayerTypeCode, PayerID)

CREATE NONCLUSTERED INDEX IX_Payment_PaymentNumber
ON Payment (PaymentNumber)

DROP INDEX PaymentClaimTransaction.IX_PaymentClaimTransaction_ClaimID
DROP INDEX PaymentClaimTransaction.IX_PaymentClaimTransaction_ClaimTransactionID
DROP INDEX PaymentClaimTransaction.IX_PaymentClaimTransaction_PaymentID

DROP INDEX PaymentClaimTransaction.CI_PaymentClaimTransaction_PracticeID_PaymentClaimTransactionID_ClaimID
GO

CREATE UNIQUE CLUSTERED INDEX CI_PaymentClaimTransaction_PracticeID_PaymentID_ClaimID_ClaimTransactionID
ON PaymentClaimTransaction (PracticeID, PaymentID, ClaimID, ClaimTransactionID)
GO
