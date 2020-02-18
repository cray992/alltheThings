SELECT *
FROM dbo.BillingInvoicing_InvoiceRun

SELECT *
FROM dbo.BillingInvoicing_CustomerProviders
WHERE PracticeID=24 AND CustomerID=122

SELECT *
FROM dbo.BillingInvoicing_KareoProviders
WHERE InvoiceRunID=2 AND KareoProviderID=265

SELECT *
FROM dbo.BillingInvoicing_KareoProductRule

SELECT *
FROM dbo.BillingInvoicing_KareoProductRuleLineItem

SELECT *
FROM dbo.BillingInvoicing_InvoicingInputs 
WHERE PracticeID=24 AND CustomerID=122 AND InvoicingInputItemID=4

SELECT *
FROM dbo.BillingInvoicing_Practices

SELECT *
FROM InvoicingInputItem



SELECT *
FROM SupportType


SELECT *
FROM BillingInvoicing_InvoiceDetail
WHERE Posted=1
