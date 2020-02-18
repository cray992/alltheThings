-- Add a new column to PracticeToInsuranceCompany to be defaulted to 1 

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS	WHERE TABLE_NAME = 'PracticeToInsuranceCompany'
	AND COLUMN_NAME = 'BalanceTransfer')
BEGIN
	ALTER TABLE dbo.PracticeToInsuranceCompany ADD BalanceTransfer BIT NULL DEFAULT(1)
END

