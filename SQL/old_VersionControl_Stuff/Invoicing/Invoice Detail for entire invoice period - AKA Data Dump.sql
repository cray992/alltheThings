alter Proc Shared_BillingInvoicing_GetInvoiceDataExport
        @InvoiceDate Datetime = NULL,
        @PracticeID INT = 0, 
        @ProviderID INT = -1, 
        @TransactionType INT = -1
AS



DECLARE @InvoiceRunID INT, @CustomerID INT

IF isdate(@InvoiceDate) = 1
BEGIN
        select @InvoiceRunID = InvoiceRunID from BillingInvoicing_InvoiceRun where InvoiceDate = @InvoiceDate
END 
ELSE BEGIN
        -- if no date was spedified, then get current invoicing period
        select @InvoiceRunID = InvoiceRunID, @InvoiceDate = InvoiceDate from BillingInvoicing_InvoiceRun where month(InvoiceDate) = month(getdate() ) and year(InvoiceDate) = year(getdate())
END 


CREATE TABLE #InvoiceDetail(InvoiceDetailID INT, InvoiceRunID INT, CustomerID INT, PracticeID INT, KareoProviderID INT, KareoProductLineItemID INT, 
							StartDate DATETIME, EndDate DATETIME, ProRate DECIMAL(5,2), Qty DECIMAL(18,4), Allowance DECIMAL(18,4), 
							Price MONEY, Posted BIT, Deleted BIT, Comment VARCHAR(500), InternalComment BIT)
INSERT INTO #InvoiceDetail(InvoiceDetailID, InvoiceRunID, CustomerID, PracticeID, KareoProviderID, KareoProductLineItemID, StartDate, EndDate, ProRate, Qty, Allowance, Price, 
						   Posted, Deleted, Comment, InternalComment)
SELECT IE.InvoiceDetailID, IE.InvoiceRunID, ID.CustomerID, ID.PracticeID, ID.KareoProviderID, IE.KareoProductLineItemID, IE.StartDate, IE.EndDate, IE.ProRate, IE.Qty, IE.Allowance, IE.Price, 
	   ID.Posted, ID.Deleted, ID.Comment, ID.InternalComment
FROM BillingInvoicing_InvoiceEdits IE INNER JOIN BillingInvoicing_InvoiceDetail ID
ON IE.InvoiceDetailID=ID.InvoiceDetailID
WHERE IE.InvoiceRunID=@InvoiceRunID 
AND (@PracticeID=0 OR ID.PracticeID=@PracticeID OR @PracticeID=-1 AND ID.PracticeID IS NULL)
AND (@ProviderID=-1 OR ID.KareoProviderID=@ProviderID)
AND (@TransactionType=-1
	 OR @TransactionType=-1000 AND ID.Deleted=0
	 OR (@TransactionType=0 AND ID.Deleted=1)
	 OR (@TransactionType=100 AND ID.Deleted=0 AND (IE.ProRate IS NOT NULL AND IE.ProRate<>0))
	 OR (@TransactionType=1000 AND ID.Deleted=0 AND ID.Posted=1)
	 OR (@TransactionType=-10000 AND ID.Deleted=0 AND ID.Posted=0)
	 OR (@TransactionType=10000 AND ID.Deleted=0 AND ID.Inserted=1)
	 OR (@TransactionType=4111 AND ID.Deleted=0 AND ID.InternalComment=1)
	 OR (@TransactionType=411 AND ID.Deleted=0 AND (ID.Comment IS NOT NULL AND LTRIM(RTRIM(ID.Comment))<>''))
	 OR (IE.KareoProductLineItemID=@TransactionType AND ID.Deleted=0))

INSERT INTO #InvoiceDetail(InvoiceDetailID, InvoiceRunID, CustomerID, PracticeID, KareoProviderID, KareoProductLineItemID, StartDate, EndDate, ProRate, Qty, Allowance, Price, 
						   Posted, Deleted, Comment, InternalComment)
SELECT BID.InvoiceDetailID, BID.InvoiceRunID, BID.CustomerID, BID.PracticeID, BID.KareoProviderID, BID.KareoProductLineItemID, BID.StartDate, BID.EndDate, BID.ProRate, BID.Qty, BID.Allowance, BID.Price, 
	   BID.Posted, BID.Deleted, BID.Comment, BID.InternalComment
FROM BillingInvoicing_InvoiceDetail BID LEFT JOIN #InvoiceDetail ID
ON BID.InvoiceDetailID=ID.InvoiceDetailID 
WHERE BID.InvoiceRunID=@InvoiceRunID AND ID.InvoiceDetailID IS NULL 
AND (@PracticeID=0 OR BID.PracticeID=@PracticeID OR @PracticeID=-1 AND BID.PracticeID IS NULL)
AND (@ProviderID=-1 OR BID.KareoProviderID=@ProviderID)
AND (@TransactionType=-1 
	 OR (@TransactionType=0 AND BID.Deleted=1)
	 OR (@TransactionType=100 AND BID.Deleted=0 AND (BID.ProRate IS NOT NULL AND BID.ProRate<>0))
	 OR (@TransactionType=1000 AND BID.Deleted=0 AND BID.Posted=1)
	 OR (@TransactionType=-10000 AND BID.Deleted=0 AND BID.Posted=0)
	 OR (@TransactionType=10000 AND BID.Deleted=0 AND BID.Inserted=1)
	 OR (@TransactionType=4111 AND BID.Deleted=0 AND BID.InternalComment=1)
	 OR (@TransactionType=411 AND BID.Deleted=0 AND (BID.Comment IS NOT NULL AND LTRIM(RTRIM(BID.Comment))<>''))
	 OR (BID.KareoProductLineItemID=@TransactionType AND BID.Deleted=0))





SELECT  
        Invoice = CONVERT(CHAR(10),@InvoiceDate,110), 
        StartDate = convert(Varchar, ID.StartDate, 110),
        EndDate = convert(Varchar, ID.EndDate, 110),
        PriorMonth = case when month(id.startDate) < month(@InvoiceDate) THEN 'Yes' ELSE 'No' END,
        Category = case when fromDeptB.toCustomerID is null then 'Non-Department B' else 'Department B' end,
        CustID = C.CustomerID, 
        Customer = C.CompanyName, 
        Practice = ISNULL(P.PracticeName, 'Multiple Practices') , 
        Provider = CP.ProviderName,  
        PromoExpDate = convert( Varchar, C.SubscriptionExpirationDate,110),
        [Free-to-PayingConversion] = cast(null as Datetime),
        Account = CASE 
                WHEN KPRLI.KareoProductLineItemID IN (1,2,3) THEN 'Subscription'
                WHEN KPRLI.KareoProductLineItemID IN (10,11,12) THEN 'Support'
                WHEN KPRLI.KareoProductLineItemID IN (5,6,7) THEN 'Clearinghouse'
                WHEN KPRLI.KareoProductLineItemID IN (8,9) THEN 'Patient Statements'
                ELSE 'Other' END, 
        Product = KPRLI.KareoProductLineItemName, 
        [Type] = PT.ProviderTypeName, 
        NULL License,        
        [Pro-Rated] = CASE WHEN ID.ProRate IS NOT NULL THEN 'Yes' ELSE 'No' END, 
        [Pre-Paid] = '',
        [Memo/Description] = ID.Comment, 
        ProvCount = case when  month(id.startDate) >= month(@InvoiceDate) and KPRLI.KareoProductLineItemID IN (1,2,3) THEN ID.Qty else 0 end,
        ID.Qty, 
        TotalAmount = CAST(CASE 
                WHEN ID.KareoProductLineItemID=4 
                THEN CEILING((ISNULL(ID.ProRate,1)*(CASE WHEN (ID.Qty-ISNULL(ID.Allowance,0))<=0 THEN 0 ELSE (ID.Qty-ISNULL(ID.Allowance,0)) END))/100)
	        ELSE ISNULL(ID.ProRate,1)*(CASE WHEN (ID.Qty-ISNULL(ID.Allowance,0))<=0 THEN 0 ELSE (ID.Qty-ISNULL(ID.Allowance,0)) END) END*ID.Price AS MONEY), 
        ID.ProRate, 
        ID.Allowance,
        Posted, 
        Deleted,
        ID.Price,      
        ID.InternalComment
FROM #InvoiceDetail ID 
        LEFT JOIN BillingInvoicing_Practices P
                ON ID.InvoiceRunID=P.InvoiceRunID 
                AND ID.CustomerID=P.CustomerID 
                AND ID.PracticeID=P.PracticeID
        LEFT JOIN BillingInvoicing_KareoProviders KP
                ON ID.InvoiceRunID=KP.InvoiceRunID 
                AND ID.KareoProviderID=KP.KareoProviderID
        LEFT JOIN BillingInvoicing_CustomerProviders CP
                ON KP.InvoiceRunID=CP.InvoiceRunID 
                AND KP.KareoProviderID=CP.KareoProviderID 
                AND KP.RepresentativeDoctorID=CP.DoctorID
        LEFT JOIN ProviderType PT
                ON KP.ProviderTypeID=PT.ProviderTypeID
        INNER JOIN BillingInvoicing_KareoProductRuleLineItem KPRLI
                ON ID.InvoiceRunID=KPRLI.InvoiceRunID 
                AND ID.KareoProductLineItemID=KPRLI.KareoProductLineItemID
        INNER JOIN Customer C
                ON ID.CustomerID=C.CustomerID
        LEFT JOIN ( select distinct ToCustomerID from CustomerMapPractice where FromCustomerID = 1) as fromDeptB
                ON c.CustomerID = fromDeptB.ToCustomerID
ORDER BY ISNULL(P.PracticeName, 'Multiple Practices'), 
        CP.ProviderName, 
        KPRLI.KareoProductLineItemName

DROP TABLE #InvoiceDetail