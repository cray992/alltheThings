BEGIN TRANSACTION
GO
ALTER TABLE dbo.Customer ADD
	CustomerKey varchar(40) NULL
GO
COMMIT
GO