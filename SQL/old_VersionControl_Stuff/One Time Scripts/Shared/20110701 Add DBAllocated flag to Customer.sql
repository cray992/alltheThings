ALTER TABLE dbo.Customer ADD [DBAllocated] [bit]
GO

UPDATE dbo.Customer SET DBAllocated = 1
GO

--ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_DBAllocated]  DEFAULT ((1)) FOR [DBAllocated]
ALTER TABLE dbo.Customer ALTER COLUMN DBAllocated BIT NOT NULL
GO

