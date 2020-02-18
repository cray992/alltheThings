IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='PaymentAuthorization' AND column_name='TotalAmount' )
	ALTER TABLE dbo.PaymentAuthorization
	ADD TotalAmount MONEY NULL
	
GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='PaymentAuthorization' AND column_name='VoidedPaymentID' )
	ALTER TABLE dbo.PaymentAuthorization
	ADD VoidedPaymentID INT NULL

