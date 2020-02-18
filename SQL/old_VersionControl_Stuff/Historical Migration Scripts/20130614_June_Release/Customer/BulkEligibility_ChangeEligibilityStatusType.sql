IF EXISTS 
(
	SELECT * 
	FROM INFORMATION_SCHEMA.Columns
	WHERE TABLE_NAME = 'EligibilityHistory'
	AND COLUMN_NAME = 'EligibilityStatus'
	AND DATA_TYPE = 'BIT'
)
BEGIN
	PRINT 'Updating EligibilityHistory.EligibilityStatus from bit to int... '

	ALTER TABLE EligibilityHistory
	ALTER COLUMN EligibilityStatus INT;

	--We don't know the EligibilityStatus for old records, since this column was always set to a constant 1 / true.
	UPDATE EligibilityHistory
	SET EligibilityStatus = 0 --Unknown

	PRINT 'Done.'
END
ELSE
BEGIN
	PRINT 'EligibilityHistory.EligibilityStatus is already any int.  Skipping...'
END