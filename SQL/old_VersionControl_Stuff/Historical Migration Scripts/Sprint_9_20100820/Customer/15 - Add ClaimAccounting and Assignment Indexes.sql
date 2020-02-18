CREATE INDEX IX_ClaimAccounting_ClaimTransactionID
ON ClaimAccounting(ClaimTransactionID)

GO

CREATE INDEX IX_ClaimAccounting_Assignments_ClaimTransactionID
ON ClaimAccounting_Assignments(ClaimTransactionID)