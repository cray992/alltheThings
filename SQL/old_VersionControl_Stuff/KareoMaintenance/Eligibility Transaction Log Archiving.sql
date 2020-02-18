DECLARE @cutoffDate DATETIME
SET @cutoffDate = DATEADD(MONTH, 3, GETDATE())

WHILE EXISTS (SELECT TOP 1 * FROM dbo.EligibilityTransactionLog WHERE TransactionDate < @cutoffDate)
BEGIN

	;WITH EligiblityTransactionLogItemsToDelete AS
	(
		SELECT TOP 10000 *
		FROM dbo.EligibilityTransactionLog
		WHERE TransactionDate < @cutoffDate
	)
	DELETE EligiblityTransactionLogItemsToDelete 
	OUTPUT DELETED.* INTO dbo.EligibilityTransactionLog_history

END

SELECT COUNT(*) FROM dbo.EligibilityTransactionLog
