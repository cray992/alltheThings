
ALTER TABLE
	Customer
ADD 
	SubscriptionExpirationDate datetime NOT NULL DEFAULT DATEADD(day, 30, GETDATE())
GO

ALTER TABLE
	Customer
ADD
	SubscriptionNextCheckDate datetime NOT NULL DEFAULT GETDATE()
GO
