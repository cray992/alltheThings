IF EXISTS(SELECT 1 
		  FROM sys.objects so inner join sys.schemas sc
		  ON so.schema_id=sc.schema_id
		  WHERE so.name='EmailErrorsLog' AND sc.name='invoicing' and so.type='U')
	DROP TABLE invoicing.EmailErrorsLog
GO

CREATE TABLE invoicing.EmailErrorsLog(CustomerID INT NOT NULL, InvoiceID INT NOT NULL,
EmailRecipients VARCHAR(MAX) NULL, ErrorDate DATETIME NOT NULL CONSTRAINT DF_invoicing_EmailErrorsLog DEFAULT GETDATE(),
ErrorMessage VARCHAR(MAX) NOT NULL)

GO

CREATE CLUSTERED INDEX CI_invoicing_EmailErrorsLog ON invoicing.EmailErrorsLog (CustomerID, InvoiceID)