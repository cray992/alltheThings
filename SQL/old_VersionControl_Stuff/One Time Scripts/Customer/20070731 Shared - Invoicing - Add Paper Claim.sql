
USE superbill_shared
GO


declare @UserID INT, @KareoProductLineItemID INT
select @UserID = UserID from users where emailAddress = 'phong@kareo.com'

if not exists( select * from [Superbill_Shared].[dbo].[KareoProductLineItem] WHERE KareoProductLineItemName = 'Paper Claims' )
BEGIN

	INSERT INTO [Superbill_Shared].[dbo].[KareoProductLineItem]
			   ([KareoProductLineItemName]
			   ,[Price]
			   ,[Active]
			   ,[KareoProductLineItemDesc]
			   ,[InvoicingInputItemID]
			   ,[CreatedDate]
			   ,[CreatedUserID]
			   ,[ModifiedDate]
			   ,[ModifiedUserID])
		 VALUES(
			   'Paper Claims'
			   ,0.26
			   ,1
			   ,'Paper Claim Processing'
			   ,8
			   ,getDate()
			   ,@UserID
			   ,getDate()
			   ,@UserID
				)
	SET @KareoProductLineItemID = @@Identity

	Update [Superbill_Shared].[dbo].ClearinghousePayersList
	SET isPaperOnly = 1
	WHERE PayerNumber = '00010'


	Update kpr
	SET  KareoProductRuleDef.modify('       
			insert  <KareoProductLineItem value="{sql:variable("@KareoProductLineItemID")}" />
			into (/kareoproductdef/productdef/lineitems)[1]') 
	from KareoProductRule kpr
	where KareoProductRuleDef.exist('/kareoproductdef/productdef/lineitems/KareoProductLineItem[@value = "5"]') = 1
		AND ( EffectiveStartDate <= '10/1/07' OR EffectiveStartDate IS NULL )
		AND ( EffectiveEndDate >= '10/1/07' OR EffectiveEndDate IS NULL )


END








return

/*
delete [KareoProductLineItem] where [KareoProductLineItemID] = 35

select sum(qty) from BillingInvoicing_InvoicingInputs where InvoicingInputItemID = 8 and invoiceRunID = 87


select * from BillingInvoicing_InvoicingInputs 
where InvoicingInputItemID = 8 and invoiceRunID = 76 
	AND CustomerID = 906
order by CustomerID, PracticeID

select sum(QTY) from BillingInvoicing_InvoiceDetail where InvoiceRunID = 79 and kareoProductLineItemID = 28

select * from [KareoProductLineItem]

select * from KareoProductRule

select * from KareoProductLineItem order by InvoicingInputItemID

    EXEC BIZCLAIMSDBSERVER.Kareobizclaims..BC_CompanyMetrics_Billing_EClaimsSubmissions '6/1/07', '6/30/07'

select * from BillingInvoicing_KareoProductRule where InvoiceRunID = 76 

select * from BillingInvoicing_InvoiceDetail where InvoiceRunID = 87
select * from BillingInvoicing_InvoicingInputs where invoiceRunID = 79 and invoicingInputItemID = 8


select * from KareoProductRule
select * from [KareoProductLineItem]


select * 
from [kprod-db07].superbill_shared.dbo.KareoProductRule


customer

*/


