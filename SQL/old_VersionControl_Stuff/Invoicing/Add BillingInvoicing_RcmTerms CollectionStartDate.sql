IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='CollectionStartDate' AND COLUMNS.TABLE_NAME='BillingInvoicing_RcmTerms')
BEGIN

	ALTER TABLE BillingInvoicing_RcmTerms
	ADD CollectionStartDate DATETIME NOT NULL DEFAULT(GETDATE())
END