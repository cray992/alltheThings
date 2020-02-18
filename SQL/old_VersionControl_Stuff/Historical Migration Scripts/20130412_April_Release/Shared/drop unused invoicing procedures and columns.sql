IF EXISTS(SELECT * FROM sys.objects WHERE name='Shared_BillingInvoicing_GetLeadTypes' AND type='P')
BEGIN

	DROP PROCEDURE dbo.Shared_BillingInvoicing_GetLeadTypes
	DROP PROCEDURE dbo.Shared_BillingInvoicing_GetPricingCodes

	DROP PROCEDURE Shared_BillingInvoicing_GetCustomerPostedInvoices
	DROP PROCEDURE Shared_BillingInvoicing_GetInvoicePostingLog
	DROP PROCEDURE Shared_BillingInvoicing_GetKareoCustomerList
	DROP PROCEDURE Shared_BillingInvoicing_GetPostedInvoiceDetails
	DROP PROCEDURE Shared_BillingInvoicing_GetPostedInvoices
	DROP PROCEDURE Shared_BillingInvoicing_LogInvoicePostingErrors
	DROP PROCEDURE Shared_BillingInvoicing_PostInvoices
	DROP PROCEDURE Shared_BillingInvoicing_UnPostInvoices
	DROP PROCEDURE Shared_BillingInvoicing_UpdateQBOECustomerListIDs

	ALTER TABLE dbo.BillingInvoicing_Customer
	DROP CONSTRAINT [FK__BillingIn__Custo__04BC3601]

	ALTER TABLE dbo.BillingInvoicing_Customer
	DROP COLUMN CustomerPricingCodeID

	ALTER TABLE dbo.BillingInvoicing_Customer
	DROP COLUMN CustomerLeadTypeID

	SELECT * 
	INTO invoicing.CustomerSettings_April2013
	FROM invoicing.CustomerSettings AS CS

	ALTER TABLE invoicing.CustomerSettings
	DROP CONSTRAINT [FK__CustomerS__Custo__03C811C8]

	--Will wait to do this
	ALTER TABLE invoicing.CustomerSettings
	DROP COLUMN CustomerPricingCodeID

	ALTER TABLE invoicing.CustomerSettings
	DROP COLUMN CustomerLeadTypeID


	DROP TABLE invoicing.CustomerPricingCode
	DROP TABLE invoicing.CustomerLeadType

END