
--Custom Code is for entering in a procedure code that is longer than 5 varchar

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'ProcedureCodeDictionary' 
		AND COLUMN_NAME = 'CustomCode')
BEGIN 
	ALTER TABLE dbo.ProcedureCodeDictionary
	ADD CustomCode bit NOT NULL 
	DEFAULT(0) 
END
