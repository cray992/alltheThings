IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomerHistory]') AND name = N'IX_CustomerHistory_CustomerID')
	DROP INDEX IX_CustomerHistory_CustomerID ON [dbo].CustomerHistory WITH ( ONLINE = OFF )
GO
	
CREATE NONCLUSTERED INDEX IX_CustomerHistory_CustomerID ON [dbo].CustomerHistory 
(
	CustomerID
)
GO
