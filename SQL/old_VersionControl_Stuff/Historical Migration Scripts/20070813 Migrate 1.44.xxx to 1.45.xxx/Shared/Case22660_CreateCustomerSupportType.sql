/*
Case 22660 - Create a Support Plan association to the Customer table
*/

-- Update the SupportType with a sort column
ALTER TABLE dbo.SupportType
ADD Sort INT
GO

-- Update the SupportType table with the new types. Note the odd order in which these are updated is to try and correspond with the existing
-- SupportType levels of 1=Platinum, 2=Gold, 3=Standard, and 4=None
UPDATE	SupportType SET SupportTypeCaption = 'Level 3', Sort = 4 WHERE SupportTypeID = 1
UPDATE	SupportType SET SupportTypeCaption = 'Level 2', Sort = 3 WHERE SupportTypeID = 2
UPDATE	SupportType SET SupportTypeCaption = 'Level 1', Sort = 2 WHERE SupportTypeID = 3
UPDATE	SupportType SET SupportTypeCaption = 'Self-Service', Sort = 1 WHERE SupportTypeID = 4
INSERT INTO SupportType(SupportTypeCaption, Sort) VALUES ('Level 4', 5)

-- Update SupportType's sort column to not allow nulls
ALTER TABLE dbo.SupportType
ALTER COLUMN Sort INT NOT NULL

-- Add new field
ALTER TABLE dbo.Customer
ADD SupportTypeID INT
GO
alter table customer disable trigger all
-- Update existing customers with the lowest level of support
UPDATE Customer SET SupportTypeID = 4
alter table customer enable trigger all
-- Add foreign key constraints
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_SupportType] FOREIGN KEY([SupportTypeID])
REFERENCES [dbo].[SupportType] ([SupportTypeID])
GO

ALTER TABLE [dbo].[BillingInvoicing_Practices]  WITH CHECK ADD  CONSTRAINT [FK_BillingInvoicing_Practices_SupportType] FOREIGN KEY([SupportTypeID])
REFERENCES [dbo].[SupportType] ([SupportTypeID])
GO

-- Add default constraint
ALTER TABLE [dbo].[Customer] ADD  
CONSTRAINT [DF_Customer_SupportTypeID] 
DEFAULT (4) FOR SupportTypeID
GO

-- Don't allow nulls in new column
ALTER TABLE dbo.Customer
ALTER COLUMN SupportTypeID INT NOT NULL
GO

