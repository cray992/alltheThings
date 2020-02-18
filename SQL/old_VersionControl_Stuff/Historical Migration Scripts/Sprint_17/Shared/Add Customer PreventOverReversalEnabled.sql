ALTER TABLE dbo.Customer
ADD PreventOverReversalsEnabled BIT NOT NULL
CONSTRAINT DF_Customer_PreventOverReversalsEnabled DEFAULT CAST(1 AS BIT)