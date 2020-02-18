/*

SHARED DATABASE UPDATE SCRIPT

v1.23.1878 to v1.24.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 3550:  

ALTER TABLE
	Customer
ADD
	SubscriptionExpirationLastWarningOffset int NOT NULL CONSTRAINT [DF_KareoProduct_SubscriptionExpirationLastWarningOffset] DEFAULT (30)
GO

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
