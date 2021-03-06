USE [Superbill_Shared]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[Shared_CustomerDataProvider_CreateCustomer]
		@ClearinghouseConnectionID = default,
		@CompanyName = N'Rolland Test Customer 2',
		@AddressLine1 = NULL,
		@AddressLine2 = NULL,
		@City = NULL,
		@State = NULL,
		@ZipCode = NULL,
		@NumOfEmployeesID = NULL,
		@NumOfUsersID = NULL,
		@NumOfPhysiciansID = NULL,
		@AnnualCompanyRevenueID = NULL,
		@ContactPrefix = NULL,
		@ContactFirstName = N'Rolland',
		@ContactMiddleName = NULL,
		@ContactLastName = N'Zeleznik',
		@ContactSuffix = NULL,
		@ContactTitle = NULL,
		@ContactPhone = NULL,
		@ContactPhoneExt = NULL,
		@ContactEmail = N'sales5@cyprin.com',
		@MarketingSourceID = NULL,
		@CustomerType = N'T',
		@AccountLocked = 0,
		@DatabaseServerName = NULL,
		@DatabaseName = NULL,
		@DatabaseUsername = NULL,
		@DatabasePassword = NULL,
		@Notes = NULL,
		@Comments = NULL,
		@Prepopulated = 0,
		@SendNewsletter = 0,
		@SubscriptionExpirationDate = '8/1/08',
		@SubscriptionNextCheckDate = '8/1/08',
		@SubscriptionExpirationLastWarningOffset = 30,
		@LicenseCount = 10,
		@CustomerTypeTransitionPending = 1,
		@ModifiedUserID = 406

SELECT	'Return Value' = @return_value

GO

EXEC dbo.Shared_CustomerDataProvider_CreateCustomerDatabase
	@CustomerID = 1047,
	@NewPasswordHash = '',
	@ModifiedUserID = 406,
	@AllowExistingEmail = 0