IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'ProxymedResponse' 
           AND  COLUMN_NAME = 'ContainsMultipleAccounts')
BEGIN
	ALTER TABLE dbo.ProxymedResponse
	ADD ContainsMultipleAccounts BIT NULL
END
    
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'GatewayEDIResponse' 
           AND  COLUMN_NAME = 'ContainsMultipleAccounts')
BEGIN
	ALTER TABLE dbo.GatewayEDIResponse
	ADD ContainsMultipleAccounts BIT NULL
END    