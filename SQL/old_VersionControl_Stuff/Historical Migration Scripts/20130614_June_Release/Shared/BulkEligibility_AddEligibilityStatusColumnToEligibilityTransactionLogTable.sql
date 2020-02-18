IF EXISTS
(
	SELECT *
	FROM INFORMATION_SCHEMA.COLUMNS c
	WHERE c.TABLE_NAME = 'EligibilityTransactionLog'
	AND c.COLUMN_NAME = 'EligibilityStatus'
)
BEGIN
	PRINT 'Not adding EligibilityStatus column to EligibilityTransactionLog, since the column already exists.'
END
ELSE
BEGIN
	PRINT 'Adding EligibilityStatus column to EligibilityTransactionLog...'

	ALTER TABLE EligibilityTransactionLog
	ADD EligibilityStatus INT NOT NULL DEFAULT 0

	PRINT ' Done.'
END
GO
