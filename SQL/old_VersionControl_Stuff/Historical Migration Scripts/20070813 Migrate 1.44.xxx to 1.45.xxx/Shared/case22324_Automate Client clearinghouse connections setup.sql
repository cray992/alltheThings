
update customer
SET clearinghouseconnectionid = 0
WHERE clearinghouseconnectionid IS NULL


alter table customer  alter column clearinghouseconnectionid INT not null


-- to do: Default column 
ALTER TABLE [dbo].[Customer] ADD  
CONSTRAINT [DF_Customer_ClearinghouseConnectionID] 
DEFAULT (0) FOR ClearinghouseConnectionID


DECLARE @BizClaimsUserId int

select @BizClaimsUserId = UserId from users where emailaddress = 'bizclaims@kareo.com'

INSERT INTO [Superbill_Shared].[dbo].[CustomerUsers]
          ([CustomerID]
          ,[UserID]
          ,[UserRoleID])
SELECT CustomerID, @BizClaimsUserId, NULL
FROM Customer 
WHERE  ISNULL(DatabaseName, '') <> ''  AND Metrics = 1 AND AccountLocked = 0 AND CustomerType = 'N'
    AND CustomerId NOT IN ( select CustomerId from customerusers where userid = @BizClaimsUserId  )

