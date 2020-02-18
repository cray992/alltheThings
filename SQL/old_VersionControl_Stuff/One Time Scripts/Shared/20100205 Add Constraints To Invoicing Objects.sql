
--Add New Defaults
ALTER TABLE dbo.BillingInvoicing_Customer 
ADD CONSTRAINT 
DF_BillingInvoicing_Customer_CustomerPriceModelID DEFAULT 2 FOR CustomerPriceModelID WITH VALUES

GO

ALTER TABLE invoicing.CustomerSettings
ADD CONSTRAINT 
DF_invoicingCustomerSettings_CustomerPriceModelID DEFAULT 2 FOR CustomerPriceModelID WITH VALUES

GO

ALTER TABLE dbo.BillingInvoicing_Customer 
ADD CONSTRAINT 
DF_BillingInvoicing_Customer_EmailInvoice DEFAULT 0 FOR EmailInvoice WITH VALUES

GO

ALTER TABLE invoicing.CustomerSettings
ADD CONSTRAINT 
DF_invoicingCustomerSettings_EmailInvoice DEFAULT 0 FOR EmailInvoice WITH VALUES

GO

ALTER TABLE dbo.BillingInvoicing_Customer 
ADD CONSTRAINT 
DF_BillingInvoicing_Customer_CustomerLeadTypeID DEFAULT 1 FOR CustomerLeadTypeID WITH VALUES

GO

ALTER TABLE invoicing.CustomerSettings
ADD CONSTRAINT 
DF_invoicingCustomerSettings_CustomerLeadTypeID DEFAULT 1 FOR CustomerLeadTypeID WITH VALUES

GO

--Add New Column with Default To PaymentTerms
--NewCustomerDefault - if set this will be the default applied to new Customer Records
--in invoicing.CustomerSettings table for the field PaymentTermsID
ALTER TABLE invoicing.PaymentTerms ADD NewCustomerDefault BIT NOT NULL
CONSTRAINT DF_invoicingPaymentTerms_NewCustomerDefault DEFAULT 0 WITH VALUES