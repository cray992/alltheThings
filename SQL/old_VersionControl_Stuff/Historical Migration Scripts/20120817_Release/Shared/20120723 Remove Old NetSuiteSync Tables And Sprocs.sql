USE Superbill_Shared

GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_InvoicingIntegration_PopulateCustomerOutstandingInvoices'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_InvoicingIntegration_PopulateCustomerOutstandingInvoices
    
GO

IF EXISTS ( 
    SELECT * 
    FROM information_schema.tables 
    WHERE table_name='CustomerOutstandingInvoices'
)
    DROP TABLE dbo.CustomerOutstandingInvoices
    
GO
