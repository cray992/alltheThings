USE Superbill_Shared

IF NOT EXISTS ( SELECT * FROM information_schema.tables WHERE table_name='CustomerOutstandingInvoices' )
BEGIN

CREATE TABLE CustomerOutstandingInvoices
(
Id INT IDENTITY(1,1),
InternalId int,
CustomerId int,
AmountPaid money,
AmountRemaining money,
Total money,
CreatedDate datetime,
DueDate DATETIME,
CONSTRAINT PK_CustomerOutstandingInvoices PRIMARY KEY (Id)
)

END
