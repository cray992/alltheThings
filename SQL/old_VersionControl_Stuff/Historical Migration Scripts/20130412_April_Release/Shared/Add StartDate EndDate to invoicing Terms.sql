IF NOT EXISTS(SELECT * FROM sys.columns WHERE NAME = N'StartDate' and Object_ID = Object_ID(N'invoicing.DiscountTerms'))    
BEGIN

ALTER TABLE
invoicing.DiscountTerms
ADD StartDate DATETIME NULL,
EndDate DATETIME NULL

ALTER TABLE
invoicing.TransactionTerms
ADD StartDate DATETIME NULL,
EndDate DATETIME NULL

ALTER TABLE
invoicing.RcmTerms
ADD StartDate DATETIME NULL,
EndDate DATETIME NULL

END