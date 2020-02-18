IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='CollectionStartDate' AND COLUMNS.TABLE_NAME='RcmTerms')
BEGIN

	ALTER TABLE invoicing.RcmTerms
	ADD CollectionStartDate DATETIME NOT NULL DEFAULT(GETDATE())

	UPDATE invoicing.RcmTerms
	SET CollectionStartDate = '1/1/2012'

END