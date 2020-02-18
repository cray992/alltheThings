IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='MinimumCharge' AND COLUMNS.TABLE_NAME='RcmTerms')
BEGIN

	ALTER TABLE invoicing.RcmTerms
	ADD MinimumCharge DECIMAL(9,2) NOT NULL DEFAULT(299.0)

END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='MinimumCharge' AND COLUMNS.TABLE_NAME='BillingInvoicing_RcmTerms')
BEGIN

	ALTER TABLE BillingInvoicing_RcmTerms
	ADD MinimumCharge DECIMAL(9,2) NOT NULL DEFAULT(299.0)
END
