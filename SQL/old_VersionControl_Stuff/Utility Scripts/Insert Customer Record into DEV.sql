
declare @CustomerID INT, @DevDBServer varchar(50)
SET @CustomerID = 235
SET @DevDBServer = 'kdev-db03'


----------------------------------------------------------

delete customer where customerID = @CustomerID

SET IDENTITY_INSERT dbo.[Customer] ON


INSERT INTO [Customer]
           (CustomerID,
			[CompanyName]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Zip]
           ,[NumOfEmployeesID]
           ,[NumOfUsersID]
           ,[NumOfPhysiciansID]
           ,[AnnualCompanyRevenueID]
           ,[ContactPrefix]
           ,[ContactFirstName]
           ,[ContactMiddleName]
           ,[ContactLastName]
           ,[ContactSuffix]
           ,[ContactTitle]
           ,[ContactPhone]
           ,[ContactPhoneExt]
           ,[ContactEmail]
           ,[MarketingSourceID]
           ,[CustomerType]
           ,[Prepopulated]
           ,[AccountLocked]
           ,[DatabaseServerName]
           ,[DatabaseName]
           ,[DatabaseUsername]
           ,[DatabasePassword]
           ,[Notes]
           ,[DBActive]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[Comments]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[SendNewsletter]
           ,[SubscriptionExpirationDate]
           ,[SubscriptionNextCheckDate]
           ,[SubscriptionExpirationLastWarningOffset]
           ,[LicenseCount]
           ,[CustomerTypeTransitionPending]
           ,[DatabaseStatusID]
           ,[ClearinghouseConnectionID]
           ,[SyncProcedure]
           ,[SyncDiagnosis]
           ,[CustomizationDMSFile]
           ,[Metrics]
           ,[ReportingDatabaseServerName]
           ,[ReportingDatabaseName])


select CustomerID,
			[CompanyName]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Zip]
           ,[NumOfEmployeesID]
           ,[NumOfUsersID]
           ,[NumOfPhysiciansID]
           ,[AnnualCompanyRevenueID]
           ,[ContactPrefix]
           ,[ContactFirstName]
           ,[ContactMiddleName]
           ,[ContactLastName]
           ,[ContactSuffix]
           ,[ContactTitle]
           ,[ContactPhone]
           ,[ContactPhoneExt]
           ,[ContactEmail]
           ,[MarketingSourceID]
           ,[CustomerType]
           ,[Prepopulated]
           ,[AccountLocked]
           ,@DevDBServer
           ,replace( [DatabaseName], '_prod', '_dev' )
           ,[DatabaseUsername]
           ,NULL
           ,[Notes]
           ,[DBActive]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[Comments]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[SendNewsletter]
           ,[SubscriptionExpirationDate]
           ,[SubscriptionNextCheckDate]
           ,[SubscriptionExpirationLastWarningOffset]
           ,[LicenseCount]
           ,[CustomerTypeTransitionPending]
           ,[DatabaseStatusID]
           ,[ClearinghouseConnectionID]
           ,[SyncProcedure]
           ,[SyncDiagnosis]
           ,[CustomizationDMSFile]
           ,[Metrics]
           ,[ReportingDatabaseServerName]
           ,[ReportingDatabaseName] 
from [kprod-db07].superbill_shared.dbo.customer where customerID = @CustomerID


SET IDENTITY_INSERT dbo.[Customer] OFF
