IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Practice' AND COLUMN_NAME = 'EStatementsMaxStatementsSent')
BEGIN           
	ALTER TABLE dbo.Practice
	ADD EStatementsMaxStatementsSent INT NOT NULL DEFAULT (4)
END
