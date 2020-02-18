ALTER TABLE dbo.Bill_Statement
ADD StatementType CHAR(1) NULL

go
UPDATE dbo.Bill_Statement
SET [StatementType] = 'P'
WHERE [StatementType] IS NULL
GO
ALTER TABLE dbo.Bill_Statement
ALTER COLUMN [StatementType] CHAR(1) NOT NULL