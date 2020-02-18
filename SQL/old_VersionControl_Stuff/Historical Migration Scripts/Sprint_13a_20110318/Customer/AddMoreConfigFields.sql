ALTER TABLE dbo.MerchantAccountConfig DROP COLUMN InstamedAccountID
GO

ALTER TABLE dbo.MerchantAccountConfig ADD 
	UserID VARCHAR(50) NULL,
	[Password] VARCHAR(50) NULL,
	
	CPMerchantID VARCHAR(50) NULL,
	CPStoreID VARCHAR(50) NULL,
	CPTerminalID VARCHAR(50) NULL,

	CNPMerchantID VARCHAR(50) NULL,
	CNPStoreID VARCHAR(50) NULL,
	CNPTerminalID VARCHAR(50) NULL
GO	

IF dbo.fn_GetCustomerID()=14
BEGIN
	UPDATE dbo.MerchantAccountConfig SET 

	UserID='kareo.inc@instamed.net',
	[Password]='y5Q@y-vB',

	CPMerchantID = '1017500001001',
	CPStoreID='0001',
	CPTerminalID='0001',
	
	CNPMerchantID = '1017500001001',
	CNPStoreID='0001',
	CNPTerminalID='0001'
	
END


--SELECT * FROM dbo.MerchantAccountConfig
