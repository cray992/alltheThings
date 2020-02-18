IF EXISTS (SELECT * FROM sys.objects WHERE name='LogingHistory' AND type='U')
	DROP TABLE LoginHistory
GO

CREATE TABLE LoginHistory(CustomerID INT, UserEmailAddress VARCHAR(256), LoginDate SMALLDATETIME NOT NULL 
CONSTRAINT DF_LoginHistory_LoginDate DEFAULT GETDATE())

GO