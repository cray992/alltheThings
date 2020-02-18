
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_AuthenticationDataProvider_SetPassword'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_AuthenticationDataProvider_SetPassword
GO

CREATE PROCEDURE dbo.Shared_AuthenticationDataProvider_SetPassword
	@UserID int,
	@PasswordHash varchar(40),
	@Expired bit = 1
AS
BEGIN
	--get old password
	
	DECLARE @UserPasswordID int
	
	SET @UserPasswordID = 
		(
			SELECT 
				UserPasswordID
			FROM 
				Users 
			WHERE
				UserID = @UserID
		)

	
	--check password for similarity to old passwords

	DECLARE @PasswordRequireDifferentPassword bit
	DECLARE @PasswordRequireDifferentPasswordCount int

	SELECT 
		@PasswordRequireDifferentPassword = MAX(CAST(PasswordRequireDifferentPassword AS int)), 
		@PasswordRequireDifferentPasswordCount = MAX(PasswordRequireDifferentPasswordCount)
	FROM 
		dbo.SecuritySetting SS
		INNER JOIN dbo.CustomerUsers CU
		ON SS.CustomerID = CU.CustomerID
	WHERE CU.UserID = @UserID
	
	IF @PasswordRequireDifferentPassword = 1
	BEGIN
		DECLARE @ExistingPassword varchar(40)
		DECLARE @MaxCount int
		DECLARE @CurrentCount int
		DECLARE @MatchFound bit
		SET @MaxCount = @PasswordRequireDifferentPasswordCount
		SET @CurrentCount = 0
		SET @MatchFound = 0

		DECLARE password_cursor CURSOR READ_ONLY
		FOR
			SELECT	
				[Password]
			FROM	
				UserPassword
			WHERE
				UserID = @UserID
			ORDER BY
				CreatedDate DESC

		OPEN password_cursor

		FETCH NEXT FROM password_cursor
		INTO	@ExistingPassword

		WHILE (@@FETCH_STATUS = 0 AND @CurrentCount < @MaxCount AND @MatchFound = 0)
		BEGIN

			SET @CurrentCount = @CurrentCount + 1

			--SELECT @FirstName 

			IF (@ExistingPassword = @PasswordHash) 
			BEGIN
				SET @MatchFound = 1
			END

			FETCH NEXT FROM password_cursor
			INTO	@ExistingPassword
		END

		CLOSE password_cursor
		DEALLOCATE password_cursor

		IF (@MatchFound = 1)
		BEGIN
			SELECT 'PasswordMatch'
			RETURN
		END
	END
	
	--create new password

	IF @PasswordHash IS NULL
	BEGIN
		SELECT 'BadPassword'
		RETURN
	END
	
	INSERT INTO 
		UserPassword
		(
			UserID,
			Password,
			CreatedDate,
			Expired
		)
		VALUES
		(
			@UserID,
			@PasswordHash,
			GETDATE(),
			@Expired
		)
	
	DECLARE @NewUserPasswordID int
	SET @NewUserPasswordID = SCOPE_IDENTITY()

	IF @NewUserPasswordID IS NULL
	BEGIN
		SELECT 'BadPassword'
		RETURN
	END

	--expire old password and update user record with the new one
	
	IF @UserPasswordID IS NOT NULL
	BEGIN
		UPDATE UserPassword SET Expired = 1 WHERE UserPasswordID = @UserPasswordID
	END

	
	UPDATE
		Users
	SET
		UserPasswordID = @NewUserPasswordID
	WHERE
		UserID = @UserID

	--reset lockout counter
	
	UPDATE Users SET AccountLockCounter = 0 WHERE UserID = @UserID

	
	--if we got this far, we've correctly changed the password
	
	SELECT 'OK'

END
GO

---------------------------------------------------------------------

--Parameters - These will be passed INTO the procedure, but are here so the script can be run interactively
--DECLARE @CustomerID int
--DECLARE @ModifiedUserID int
--DECLARE @NewPassword varchar(40)
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_CreateCustomerDatabase'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomerDatabase
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomerDatabase
	@CustomerID int,
	@NewPasswordHash varchar(40),
	@ModifiedUserID int,
	@AllowExistingEmail bit
AS
BEGIN
	/*********************************************************************************
	This must be executed BY a login that has SA priveledges
	*********************************************************************************/
	/*
	The procedure should take in the CustomerID and new user password.  
	Step performed by the procedure:
	1. Identify whether the customer wants an empty or prepopulated database
	2. Determine the new database name.
	3. Backup the current database of the selected type and restore with the new name.  Grant the dev db user permission in the new 
	database.
	4. Update Customer record with the database name information.
	5. Associate the user with the customer, give them admin rights in the db, associate them with a Doctor if they get a 
	prepopulated database.
	5a. Create user, set given password
	5b. SecuritySettings row needs to be created
	5c. Create customer security group, add user to that group
	6. Update the logshipping process to include the new database.
	7. Set the database active in the shared database.
	8. Return to the calling procedure success/failure. 
	*/
	
	--Local Variables
	DECLARE @NewDBName varchar(128)
	DECLARE @BackupFilename varchar(255) -- Unique file name for backup
	DECLARE @ContactPrefix varchar(16)
	DECLARE @ContactFirstName varchar(64)
	DECLARE @ContactMiddleName varchar(64)
	DECLARE @ContactLastName varchar(64)
	DECLARE @ContactSuffix varchar(16)
	DECLARE @ContactPhone varchar(10)
	DECLARE @ContactPhoneExt varchar(10)
	DECLARE @ContactEmail varchar(128)
	DECLARE @Address1 varchar(256)
	DECLARE @Address2 varchar(256)
	DECLARE @City varchar(30)
	DECLARE @State varchar(2)
	DECLARE @Zip varchar(9)
	DECLARE @NewUserID int
	DECLARE @ReturnUserID int
	DECLARE @NewSecurityGroupID int
	DECLARE @Prepopulated bit
	DECLARE @DBToBackup varchar(128)
	DECLARE @sql varchar(8000)
	DECLARE @ReportLogin varchar(20)
	
	--Constants
	DECLARE @PADLEN int
	DECLARE @PADCHAR char(1)
	DECLARE @TEMP_PATH varchar(8000)
	DECLARE @DATABASE_PATH varchar(8000)
	DECLARE @LOG_PATH VARCHAR(200)
	DECLARE @DBNAME_EMPTY varchar(128)
	DECLARE @DBNAME_PREPOPULATED varchar(128)
	DECLARE @LOGICAL_FILE_DATA varchar(128)
	DECLARE @LOGICAL_FILE_LOG varchar(128)
	DECLARE @DBSUFFIX varchar(10)
	DECLARE @DB_SERVER_NAME varchar(128)
	DECLARE @DB_USER varchar(128)
	DECLARE @DB_PASSWORD varchar(128)
	
	SET @PADLEN = 4
	SET @PADCHAR = '0'
	SET @TEMP_PATH = dbo.Shared_GeneralDataProvider_GetPropertyValue('TEMP_PATH')
	SET @DATABASE_PATH = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_DatabasePath')
	SET @LOG_PATH = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_LogPath')
	SET @DBNAME_EMPTY = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_EmptyDBName ')
	SET @DBNAME_PREPOPULATED = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_PrepopulatedDBName')
	SET @LOGICAL_FILE_DATA = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_LogicalFileData')
	SET @LOGICAL_FILE_LOG = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_LogicalFileLog')
	SET @DBSUFFIX = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_DBSuffix')
	SET @DB_SERVER_NAME = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_DBServerName')
	SET @DB_USER = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_DBUserName')
	SET @DB_PASSWORD = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_DBPassword')
	
	--Variable Initialization
	SET @NewDBName = dbo.Shared_GeneralDataProvider_GetPropertyValue('DefaultNewCustomer_NewDBNameFormat')
	SET @NewDBName = REPLACE(@NewDBName,'{0}',REPLICATE(@PADCHAR, @PADLEN - DATALENGTH(CAST(@CustomerID AS varchar(10))))+CAST(@CustomerID AS varchar(10)))  
	SET @NewDBName = REPLACE(@NewDBName,'{1}',@DBSuffix)
	SET @BackupFilename = @TEMP_PATH + REPLACE(REPLACE(REPLACE(CAST(NEWID() AS varchar(40)),'-','_'),'{',''),'}','')

	SELECT 
		@Prepopulated = C.Prepopulated,
		@Address1 = C.AddressLine1,
		@Address2 = C.AddressLine2,
		@City = C.City,
		@State = C.State,
		@Zip = C.Zip,
		@ContactPrefix = C.ContactPrefix,
		@ContactFirstName = C.ContactFirstName,
		@ContactMiddleName = C.ContactMiddleName,
		@ContactLastName = C.ContactLastName,
		@ContactSuffix = C.ContactSuffix,
		@ContactPhone = C.ContactPhone,
		@ContactPhoneExt = C.ContactPhoneExt,
		@ContactEmail = C.ContactEmail
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID 
	
	IF @Prepopulated = 1
		SET @DBToBackup = @DBNAME_PREPOPULATED
	ELSE
		SET @DBToBackup = @DBNAME_EMPTY
	
	--Update the Customer record in shared WITH database name
	UPDATE dbo.Customer
		SET DatabaseName = @NewDBName,
			DatabaseServerName = @DB_SERVER_NAME,
			DatabaseUsername = @DB_USER,
			DatabasePassword = @DB_PASSWORD
	WHERE CustomerID = @CustomerID 	
	
	--Backup the CustomerModel database
	SET @sql =	'BACKUP DATABASE {0} TO 
				DISK = N''{1}''
				WITH NOUNLOAD,
				NAME = N''{0} backup'',
				NOSKIP,
				STATS = 10'
				
	SET @sql = REPLACE(@sql,'{0}',@DBToBackup)
	SET @sql = REPLACE(@sql,'{1}',@BackupFilename)
	EXEC(@sql)
	
	--Restore AS the new database
	SET @sql =	'RESTORE DATABASE {0} FROM 
				DISK = N''{1}''
				WITH NOUNLOAD
				, MOVE ''{2}'' TO ''{3}{0}.mdf''
				, MOVE ''{4}'' TO ''{5}{0}_log.ldf''
				,STATS = 10'
	
	SET @sql = REPLACE(@sql,'{0}',@NewDBName)
	SET @sql = REPLACE(@sql,'{1}',@BackupFilename)
	SET @sql = REPLACE(@sql,'{2}',@LOGICAL_FILE_DATA)
	SET @sql = REPLACE(@sql,'{3}',@DATABASE_PATH)
	SET @sql = REPLACE(@sql,'{4}',@LOGICAL_FILE_LOG)
	SET @sql = REPLACE(@sql,'{5}',@LOG_PATH)
	EXEC(@sql)
	
	--Remove the backup file
	SET @sql = 'del ' + @BackupFilename
	EXEC master..xp_cmdshell @sql
	
	--Grant the user db permissions
	SET @sql = 'EXEC {0}..sp_grantdbaccess @loginame = ''{1}'', @name_in_db = ''{1}'''
	SET @sql = REPLACE(@sql,'{0}',@NewDBName)
	SET @sql = REPLACE(@sql,'{1}',@DB_USER)
	EXEC(@sql)
	
	
	SET @sql = 'EXEC {0}..sp_addrolemember @rolename = ''db_owner'', @membername = ''{1}'''
	SET @sql = REPLACE(@sql,'{0}',@NewDBName)
	SET @sql = REPLACE(@sql,'{1}',@DB_USER)
	EXEC(@sql)

	--Check Server name, grant appropriate reportuser login reporting permissions
	IF @@SERVERNAME='KDEV01'
		SET @ReportLogin='KAREO0\reportuser'
	ELSE
		SET @ReportLogin='KAREOPROD\reportuser'

	SET @sql = 'EXEC {0}..sp_grantdbaccess @loginame = ''{1}'', @name_in_db = ''{1}'''
	SET @sql = REPLACE(@sql,'{0}',@NewDBName)
	SET @sql = REPLACE(@sql,'{1}',@ReportLogin)
	EXEC(@sql)
	
	
	SET @sql = 'EXEC {0}..sp_addrolemember @rolename = ''db_owner'', @membername = ''{1}'''
	SET @sql = REPLACE(@sql,'{0}',@NewDBName)
	SET @sql = REPLACE(@sql,'{1}',@ReportLogin)
	EXEC(@sql)

	------------------------------------------------------------------------------------------------------------------
	-- Create Trial User Security Group
	------------------------------------------------------------------------------------------------------------------

	-- Add the default trial user group
	EXEC @NewSecurityGroupID = dbo.Shared_AuthenticationDataProvider_CreateSecurityGroup 
		@CustomerID = @CustomerID, 
		@SecurityGroupName = 'Trial User', 
		@SecurityGroupDescription = 'Denies trial user access to certain features', 
		@ViewInMedicalOffice = 0,
		@ViewInBusinessManager = 0,
		@ViewInAdministrator = 0,
		@ViewInServiceManager = 0,
		@ModifiedUserID = @ModifiedUserID

	--Give the security GROUP the same permissions AS the first trial group
	INSERT INTO [dbo].[SecurityGroupPermissions] (
		[SecurityGroupID],
		[PermissionID],
		[Allowed],
		[CreatedUserID],
		[ModifiedUserID],
		[Denied])
	SELECT 
		@NewSecurityGroupID,
		[PermissionID],
		[Allowed],
		@ModifiedUserID,
		@ModifiedUserID,
		[Denied]
	FROM dbo.SecurityGroupPermissions
	WHERE SecurityGroupID = 7

	-- Add an association with the new security group with the customer
	INSERT INTO [dbo].[TrialSecurityGroup] (
		[CustomerID],
		[TrialSecurityGroupID],
		[ModifiedUserID])
	VALUES	(
		@CustomerID,
		@NewSecurityGroupID,
		@ModifiedUserID)

	------------------------------------------------------------------------------------------------------------------
	-- Create default security settings
	------------------------------------------------------------------------------------------------------------------
	
	--Create default security settings for Customer
	INSERT INTO [dbo].[SecuritySetting] (
		[CustomerID],
		[PasswordMinimumLength],
		[PasswordRequireAlphaNumeric],
		[PasswordRequireMixedCase],
		[PasswordRequireNonAlphaNumeric],
		[PasswordRequireDifferentPassword],
		[PasswordRequireDifferentPasswordCount],
		[PasswordExpiration],
		[PasswordExpirationDays],
		[LockoutAttempts],
		[LockoutPhone],
		[LockoutEmail],
		[UILockMinutesAdministrator],
		[UILockMinutesBusinessManager],
		[UILockMinutesMedicalOffice],
		[UILockMinutesPractitioner],
		[UILockMinutesServiceManager])
	SELECT 	@CustomerID,
		[PasswordMinimumLength],
		[PasswordRequireAlphaNumeric],
		[PasswordRequireMixedCase],
		[PasswordRequireNonAlphaNumeric],
		[PasswordRequireDifferentPassword],
		[PasswordRequireDifferentPasswordCount],
		[PasswordExpiration],
		[PasswordExpirationDays],
		[LockoutAttempts],
		[LockoutPhone],
		[LockoutEmail],
		[UILockMinutesAdministrator],
		[UILockMinutesBusinessManager],
		[UILockMinutesMedicalOffice],
		[UILockMinutesPractitioner],
		[UILockMinutesServiceManager]
	FROM dbo.SecuritySetting SS
	WHERE SS.CustomerID IS NULL

	--Check to see if the user already exists
	SELECT	@NewUserID = UserID
	FROM	USERS
	WHERE	EmailAddress = @ContactEmail

	-- If the user is found set the return value to -1
	IF NOT @NewUserID is null
	BEGIN
		SET @ReturnUserID = -1

		IF @AllowExistingEmail = 0
			RETURN @ReturnUserID
	END
	
	--Create the user if the user doesn't exist and set the password
	IF @NewUserID is null
	BEGIN
		EXEC @NewUserID = dbo.Shared_AuthenticationDataProvider_CreateUser 
			@CustomerID = @CustomerID, 
			@prefix = @ContactPrefix, 
			@first_name = @ContactFirstName, 
			@middle_name = @ContactMiddleName, 
			@last_name = @ContactLastName, 
			@suffix = @ContactSuffix, 
			@AccountLocked = 0, 
			@address_1 = @Address1, 
			@address_2 = @Address2, 
			@city = @City, 
			@state = @State, 
			@country = 'USA', 
			@zip = @Zip, 
			@work_phone = @ContactPhone, 
			@work_phone_x = @ContactPhoneExt, 
			@alternative_phone = NULL, 
			@alternative_phone_x = NULL, 
			@EmailAddress = @ContactEmail, 
			@notes = NULL, 
			@ModifiedUserID = @ModifiedUserID

		EXEC dbo.Shared_AuthenticationDataProvider_SetPassword 
			@UserID = @NewUserID,
			@PasswordHash = @NewPasswordHash,
			@Expired = 0

		SET @ReturnUserID = @NewUserID
	END
	
	------------------------------------------------------------------------------------------------------------------
	-- Create System Administrator Security Group
	------------------------------------------------------------------------------------------------------------------

	-- Add the default system admin group
	EXEC @NewSecurityGroupID = dbo.Shared_AuthenticationDataProvider_CreateSecurityGroup 
		@CustomerID = @CustomerID, 
		@SecurityGroupName = 'System Administrator', 
		@SecurityGroupDescription = NULL, 
		@ViewInMedicalOffice = 1,
		@ViewInBusinessManager = 1,
		@ViewInAdministrator = 1,
		@ViewInServiceManager = 0,
		@ModifiedUserID = @ModifiedUserID
	
	--Give the security GROUP the same permissions AS the first administrator group
	INSERT INTO [dbo].[SecurityGroupPermissions] (
		[SecurityGroupID],
		[PermissionID],
		[Allowed],
		[CreatedUserID],
		[ModifiedUserID],
		[Denied])
	SELECT 
		@NewSecurityGroupID,
		[PermissionID],
		[Allowed],
		@ModifiedUserID,
		@ModifiedUserID,
		[Denied]
	FROM dbo.SecurityGroupPermissions
	WHERE SecurityGroupID = 1
	
	EXEC dbo.Shared_AuthenticationDataProvider_SetUserSecurityGroup 
		@UserID = @NewUserID,
		@SecurityGroupID = @NewSecurityGroupID,
		@ModifiedUserID = @ModifiedUserID
	
	-- Associate the user with the customer
	EXEC dbo.Shared_AuthenticationDataProvider_SetUserCustomer 
		@UserID =  @NewUserID, 
		@CustomerID = @CustomerID	
	
	IF @Prepopulated = 1
	BEGIN
		--PRINT 'NEED TO SET User_Practice!!!'
		SET @sql = 'EXEC {0}..AuthenticationDataProvider_SetUserPractice @user_id = {1}, @practice_id = 1'
		SET @sql = REPLACE(@sql,'{0}',@NewDBName)
		SET @sql = REPLACE(@sql,'{1}',@NewUserID)
		EXEC(@sql)
	
		--PRINT 'NEED TO SET User_Doctor!!!'
		
		SET @sql = 'UPDATE {0}..Doctor
						SET UserID = {1}
					WHERE DoctorID IN
						(SELECT TOP 1 DoctorID
						FROM {0}..Doctor)'
	
		SET @sql = REPLACE(@sql,'{0}',@NewDBName)
		SET @sql = REPLACE(@sql,'{1}',@NewUserID)
		EXEC(@sql)
		
	END
	
	/*********************************************************************************
	UPDATE the LOGSHIPPING
	*********************************************************************************/
		
	--Last Step IS to SET the db active
	UPDATE dbo.Customer
		SET DBActive = 1,
			DatabaseStatusID = 1
	WHERE CustomerID = @CustomerID 	

	-- Returns -1 if the user wasn't created
	RETURN @ReturnUserID
END 

GO

/*


SYNC STRUCTURE


*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Dropping foreign keys from [dbo].[Customer]'
GO
ALTER TABLE [dbo].[Customer] DROP
CONSTRAINT [FK_Customer_DemographicNumOfEmployees],
CONSTRAINT [FK_CustomerDemographicNumOfUsers],
CONSTRAINT [FK_Customer_DemographicNumOfPhysicians],
CONSTRAINT [FK_Customer_DemographicAnnualCompanyRevenue],
CONSTRAINT [FK_Customer_DemographicMarketingSource]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [dbo].[Customer]'
GO
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_NumOfEmployeesID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [dbo].[Customer]'
GO
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_NumOfUsersID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [dbo].[Customer]'
GO
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_NumOfPhysiciansID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [dbo].[Customer]'
GO
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_AnnualCompanyRevenueID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [dbo].[Customer]'
GO
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [DF_Customer_MarketingSourceID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CustomerOrderSupport]'
GO
CREATE TABLE [dbo].[CustomerOrderSupport]
(
[CustomerOrderSupportID] [int] NOT NULL IDENTITY(1, 1),
[CustomerOrderID] [int] NOT NULL,
[SupportTypeID] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_CustomerOrderSupport] on [dbo].[CustomerOrderSupport]'
GO
ALTER TABLE [dbo].[CustomerOrderSupport] ADD CONSTRAINT [PK_CustomerOrderSupport] PRIMARY KEY CLUSTERED  ([CustomerOrderSupportID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_CreateCustomerOrderSupport]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_CreateCustomerOrderSupport'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomerOrderSupport
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomerOrderSupport(
	@CustomerOrderID int,
	@SupportTypeID int
)
AS
BEGIN
	INSERT INTO dbo.CustomerOrderSupport(
		CustomerOrderID,
		SupportTypeID
	) VALUES (
		@CustomerOrderID,
		@SupportTypeID
	)

	RETURN SCOPE_IDENTITY()
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CustomerOrderEdition]'
GO
CREATE TABLE [dbo].[CustomerOrderEdition]
(
[CustomerOrderEditionID] [int] NOT NULL IDENTITY(1, 1),
[CustomerOrderID] [int] NOT NULL,
[EditionTypeID] [int] NOT NULL,
[NumOfProviderLicenses] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_CustomerOrderSubscription] on [dbo].[CustomerOrderEdition]'
GO
ALTER TABLE [dbo].[CustomerOrderEdition] ADD CONSTRAINT [PK_CustomerOrderSubscription] PRIMARY KEY CLUSTERED  ([CustomerOrderEditionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_GetCustomerOrderEdition]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_GetCustomerOrderEdition'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerOrderEdition
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerOrderEdition(
	@CustomerOrderEditionID int
)
AS
BEGIN
	SELECT
		C.CustomerOrderEditionID,
		C.CustomerOrderID,
		C.EditionTypeID,
		C.NumOfProviderLicenses
	FROM
		dbo.CustomerOrderEdition C
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CustomerOrderBilling]'
GO
CREATE TABLE [dbo].[CustomerOrderBilling]
(
[CustomerOrderBillingID] [int] NOT NULL IDENTITY(1, 1),
[CustomerOrderID] [int] NOT NULL,
[PayByCreditCard] [bit] NOT NULL,
[NameOnCard] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentTypeID] [int] NULL,
[BankName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentDetails] [xml] NULL,
[LastFour] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_CustomerOrderBilling] on [dbo].[CustomerOrderBilling]'
GO
ALTER TABLE [dbo].[CustomerOrderBilling] ADD CONSTRAINT [PK_CustomerOrderBilling] PRIMARY KEY CLUSTERED  ([CustomerOrderBillingID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_CreateCustomerBilling]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_CreateCustomerBilling'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomerBilling
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomerBilling(
	@CustomerOrderID int,
	@PayByCreditCard bit,
	@NameOnCard varchar(60),
	@PaymentTypeID int,
	@BankName varchar(50),
	@AccountName varchar(30),
	@AddressLine1 varchar(256),
	@AddressLine2 varchar(256),
	@City varchar(128),
	@State varchar(2),
	@Zip varchar(9),
	@PaymentDetails xml,
	@LastFour varchar(4)
)
AS
BEGIN
	INSERT INTO dbo.CustomerOrderBilling(
		CustomerOrderID,
		PayByCreditCard,
		NameOnCard,
		PaymentTypeID,
		BankName,
		AccountName,
		AddressLine1,
		AddressLine2,
		City,
		State,
		Zip,
		PaymentDetails,
		LastFour
	) VALUES (
		@CustomerOrderID,
		@PayByCreditCard,
		@NameOnCard,
		@PaymentTypeID,
		@BankName,
		@AccountName,
		@AddressLine1,
		@AddressLine2,
		@City,
		@State,
		@Zip,
		@PaymentDetails,
		@LastFour
	)

	RETURN SCOPE_IDENTITY()
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[EditionType]'
GO
CREATE TABLE [dbo].[EditionType]
(
[EditionTypeId] [int] NOT NULL IDENTITY(1, 1),
[EditionTypeCaption] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_SubscriptionType] on [dbo].[EditionType]'
GO
ALTER TABLE [dbo].[EditionType] ADD CONSTRAINT [PK_SubscriptionType] PRIMARY KEY CLUSTERED  ([EditionTypeId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_GetCustomerOrderBilling]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_GetCustomerOrderBilling'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerOrderBilling
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerOrderBilling(
	@CustomerOrderBillingID int
)
AS
BEGIN
	SELECT
		C.CustomerOrderBillingID,
		C.CustomerOrderID,
		C.PayByCreditCard,
		C.NameOnCard,
		C.PaymentTypeID,
		C.BankName,
		C.AccountName,
		C.AddressLine1,
		C.AddressLine2,
		C.City,
		C.State,
		C.Zip,
		C.PaymentDetails,
		C.LastFour
	FROM
		dbo.CustomerOrderBilling C
	WHERE
		C.CustomerOrderBillingID = @CustomerOrderBillingID
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PaymentType]'
GO
CREATE TABLE [dbo].[PaymentType]
(
[PaymentTypeId] [int] NOT NULL IDENTITY(1, 1),
[PaymentTypeCaption] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PaymentType] on [dbo].[PaymentType]'
GO
ALTER TABLE [dbo].[PaymentType] ADD CONSTRAINT [PK_PaymentType] PRIMARY KEY CLUSTERED  ([PaymentTypeId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_GetPaymentType]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_GetPaymentType'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_GetPaymentType
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetPaymentType
AS
BEGIN
	SELECT 
		PaymentTypeId,
		PaymentTypeCaption 
	FROM dbo.PaymentType P
	ORDER BY P.PaymentTypeId

	RETURN
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_UpdateCustomerOrderSupport]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_UpdateCustomerOrderSupport'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_UpdateCustomerOrderSupport
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_UpdateCustomerOrderSupport(
	@CustomerOrderSupportID int,
	@CustomerOrderID int,
	@SupportTypeID int
)
AS
BEGIN
	UPDATE dbo.CustomerOrderSupport
	SET
		CustomerOrderID = @CustomerOrderID,
		SupportTypeID = @SupportTypeID
	WHERE
		CustomerOrderSupportID = @CustomerOrderSupportID
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_GetCustomerOrderSupport]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_GetCustomerOrderSupport'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerOrderSupport
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerOrderSupport(
	@CustomerOrderSupportID int
)
AS
BEGIN
	SELECT
		C.CustomerOrderSupportID,
		C.CustomerOrderID,
		C.SupportTypeID
	FROM
		dbo.CustomerOrderSupport C
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_UpdateCustomerOrderEdition]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_UpdateCustomerOrderEdition'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_UpdateCustomerOrderEdition
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_UpdateCustomerOrderEdition(
	@CustomerOrderEditionID int,
	@CustomerOrderID int,
	@EditionTypeID int,
	@NumOfProviderLicenses int
)
AS
BEGIN
	UPDATE dbo.CustomerOrderEdition
	SET
		CustomerOrderID = @CustomerOrderEditionID,
		EditionTypeID = @EditionTypeID,
		NumOfProviderLicenses = @NumOfProviderLicenses
	WHERE
		CustomerOrderEditionID = @CustomerOrderEditionID
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SupportType]'
GO
CREATE TABLE [dbo].[SupportType]
(
[SupportTypeId] [int] NOT NULL IDENTITY(1, 1),
[SupportTypeCaption] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_SupportType] on [dbo].[SupportType]'
GO
ALTER TABLE [dbo].[SupportType] ADD CONSTRAINT [PK_SupportType] PRIMARY KEY CLUSTERED  ([SupportTypeId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_CreateCustomerOrderEdition]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_CreateCustomerOrderEdition'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomerOrderEdition
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomerOrderEdition(
	@CustomerOrderID int,
	@EditionTypeID int,
	@NumOfProviderLicenses int
)
AS
BEGIN
	INSERT INTO dbo.CustomerOrderEdition(
		CustomerOrderID,
		EditionTypeID,
		NumOfProviderLicenses
	) VALUES (
		@CustomerOrderID,
		@EditionTypeID,
		@NumOfProviderLicenses
	)

	RETURN SCOPE_IDENTITY()
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [dbo].[Customer]'
GO
ALTER TABLE [dbo].[Customer] ALTER COLUMN [NumOfEmployeesID] [int] NULL
ALTER TABLE [dbo].[Customer] ALTER COLUMN [NumOfUsersID] [int] NULL
ALTER TABLE [dbo].[Customer] ALTER COLUMN [NumOfPhysiciansID] [int] NULL
ALTER TABLE [dbo].[Customer] ALTER COLUMN [AnnualCompanyRevenueID] [int] NULL
ALTER TABLE [dbo].[Customer] ALTER COLUMN [ContactPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
ALTER TABLE [dbo].[Customer] ALTER COLUMN [MarketingSourceID] [int] NULL

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[CustomerOrder]'
GO
CREATE TABLE [dbo].[CustomerOrder]
(
[CustomerOrderID] [int] NOT NULL IDENTITY(1, 1),
[CustomerID] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_CustomerOrder_CreatedDate] DEFAULT (getdate())
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_CustomerOrder] on [dbo].[CustomerOrder]'
GO
ALTER TABLE [dbo].[CustomerOrder] ADD CONSTRAINT [PK_CustomerOrder] PRIMARY KEY CLUSTERED  ([CustomerOrderID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_GetCustomerOrder]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_GetCustomerOrder'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerOrder
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetCustomerOrder(
	@CustomerOrderID int
)
AS
BEGIN
	SELECT
		C.CustomerOrderID,
		C.CustomerID,
		C.CreatedDate
	FROM
		dbo.CustomerOrder C
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_GetStates]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_GetStates'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_GetStates
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_GetStates
AS
BEGIN
	SELECT
		State,
		LongName
	FROM
		State
	WHERE 
		State != '' -- Don't Return <All States>
	ORDER BY
		State

	RETURN
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [dbo].[Shared_CustomerDataProvider_UpdateCustomer]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_UpdateCustomer'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_UpdateCustomer
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_UpdateCustomer
	@CustomerID int, 
	@ClearinghouseConnectionID int,		
	@CompanyName varchar(128), 
	@AddressLine1 varchar(256),
	@AddressLine2 varchar(256),
	@City varchar(128), 
	@State varchar(2), 
	@ZipCode varchar(9), 
	@NumOfEmployeesID int, 
	@NumOfUsersID int, 
	@NumOfPhysiciansID int, 
	@AnnualCompanyRevenueID int, 
	@ContactPrefix varchar(16), 
	@ContactFirstName varchar(64), 
	@ContactMiddleName varchar(64), 
	@ContactLastName varchar(64), 
	@ContactSuffix varchar(16), 
	@ContactTitle varchar(65), 
	@ContactPhone varchar(20), 
	@ContactPhoneExt varchar(10), 
	@ContactEmail varchar(128), 
	@MarketingSourceID int, 
	@CustomerType char(1), 
	@AccountLocked bit, 
	@DatabaseServerName varchar(50), 
	@DatabaseName varchar(50), 
	@DatabaseUsername varchar(50), 
	@DatabasePassword varchar(50), 
	@Notes text, 
	@Comments text,
	@Prepopulated bit,
	@SendNewsletter bit,
	@SubscriptionExpirationDate datetime,
	@SubscriptionNextCheckDate datetime,
	@SubscriptionExpirationLastWarningOffset int,
	@LicenseCount int,
	@CustomerTypeTransitionPending bit,
	@ModifiedUserID int
AS
BEGIN

	UPDATE 
		Customer
	SET
		ClearinghouseConnectionID = @ClearinghouseConnectionID,
		CompanyName = @CompanyName, 
		AddressLine1 = @AddressLine1,
		AddressLine2 = @AddressLine2,
		City = @City, 
		State = @State, 
		Zip = @ZipCode, 
		NumOfEmployeesID = @NumOfEmployeesID, 
		NumOfUsersID = @NumOfUsersID, 
		NumOfPhysiciansID = @NumOfPhysiciansID, 
		AnnualCompanyRevenueID = @AnnualCompanyRevenueID, 
		ContactPrefix = @ContactPrefix, 
		ContactFirstName = @ContactFirstName, 
		ContactMiddleName = @ContactMiddleName, 
		ContactLastName = @ContactLastName, 
		ContactSuffix = @ContactSuffix, 
		ContactTitle = @ContactTitle, 
		ContactPhone = @ContactPhone, 
		ContactPhoneExt = @ContactPhoneExt, 
		ContactEmail = @ContactEmail, 
		MarketingSourceID = @MarketingSourceID, 
		CustomerType = @CustomerType, 
		AccountLocked = @AccountLocked, 
		DatabaseServerName = @DatabaseServerName, 
		DatabaseName = @DatabaseName, 
		DatabaseUsername = @DatabaseUsername, 
		DatabasePassword = @DatabasePassword, 
		ModifiedDate = GETDATE(),
		ModifiedUserID = @ModifiedUserID,
		Notes = @Notes, 
		Comments = @Comments,
		Prepopulated = @Prepopulated,
		SendNewsletter = @SendNewsletter,
		SubscriptionExpirationDate = @SubscriptionExpirationDate,
		SubscriptionNextCheckDate = @SubscriptionNextCheckDate,
		SubscriptionExpirationLastWarningOffset = @SubscriptionExpirationLastWarningOffset,
		LicenseCount = @LicenseCount,
		CustomerTypeTransitionPending = @CustomerTypeTransitionPending
    	WHERE
    		CustomerID = @CustomerID


END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [dbo].[Shared_CustomerDataProvider_CreateCustomer]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_CreateCustomer'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomer
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomer
	@ClearinghouseConnectionID int = -1,
	@CompanyName varchar(128), 
	@AddressLine1 varchar(256),
	@AddressLine2 varchar(256),
	@City varchar(128), 
	@State varchar(2), 
	@ZipCode varchar(9), 
	@NumOfEmployeesID int, 
	@NumOfUsersID int, 
	@NumOfPhysiciansID int, 
	@AnnualCompanyRevenueID int, 
	@ContactPrefix varchar(16), 
	@ContactFirstName varchar(64), 
	@ContactMiddleName varchar(64), 
	@ContactLastName varchar(64), 
	@ContactSuffix varchar(16), 
	@ContactTitle varchar(65), 
	@ContactPhone varchar(20), 
	@ContactPhoneExt varchar(10), 
	@ContactEmail varchar(128), 
	@MarketingSourceID int, 
	@CustomerType char(1), 
	@AccountLocked bit, 
	@DatabaseServerName varchar(50), 
	@DatabaseName varchar(50), 
	@DatabaseUsername varchar(50), 
	@DatabasePassword varchar(50), 
	@Notes text, 
	@Comments text, 
	@Prepopulated bit, 
	@SendNewsletter bit,
	@SubscriptionExpirationDate datetime,
	@SubscriptionNextCheckDate datetime,
	@SubscriptionExpirationLastWarningOffset int,
	@LicenseCount int,
	@CustomerTypeTransitionPending bit,
	@ModifiedUserID int
AS
BEGIN

	INSERT
		Customer 
		(
		ClearinghouseConnectionID,
		CompanyName, 
		AddressLine1,
		AddressLine2,
		City, 
		State, 
		Zip, 
		NumOfEmployeesID, 
		NumOfUsersID, 
		NumOfPhysiciansID, 
		AnnualCompanyRevenueID, 
		ContactPrefix, 
		ContactFirstName, 
		ContactMiddleName, 
		ContactLastName, 
		ContactSuffix, 
		ContactTitle, 
		ContactPhone, 
		ContactPhoneExt, 
		ContactEmail, 
		MarketingSourceID, 
		CustomerType, 
		AccountLocked, 
		DatabaseServerName, 
		DatabaseName, 
		DatabaseUsername, 
		DatabasePassword, 
		Notes, 
		Comments,
		Prepopulated,
		SendNewsletter,
		SubscriptionExpirationDate, 
		SubscriptionNextCheckDate,
		SubscriptionExpirationLastWarningOffset,
		LicenseCount,
		CustomerTypeTransitionPending,
		CreatedDate, 
		CreatedUserID, 
		ModifiedUserID)
	VALUES
		(
		@ClearinghouseConnectionID,
		@CompanyName, 
		@AddressLine1,
		@AddressLine2,
		@City, 
		@State, 
		@ZipCode, 
		@NumOfEmployeesID, 
		@NumOfUsersID, 
		@NumOfPhysiciansID, 
		@AnnualCompanyRevenueID, 
		@ContactPrefix, 
		@ContactFirstName, 
		@ContactMiddleName, 
		@ContactLastName, 
		@ContactSuffix, 
		@ContactTitle, 
		@ContactPhone, 
		@ContactPhoneExt, 
		@ContactEmail, 
		@MarketingSourceID, 
		@CustomerType, 
		@AccountLocked, 
		@DatabaseServerName, 
		@DatabaseName, 
		@DatabaseUsername, 
		@DatabasePassword, 
		@Notes, 
		@Comments, 
		@Prepopulated,
		@SendNewsletter,
		@SubscriptionExpirationDate,
		@SubscriptionNextCheckDate,
		@SubscriptionExpirationLastWarningOffset,
		@LicenseCount,
		@CustomerTypeTransitionPending,
		getdate(), 
		@ModifiedUserID, 
		@ModifiedUserID)

	RETURN SCOPE_IDENTITY()

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Shared_CustomerDataProvider_CreateCustomerOrder]'
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Shared_CustomerDataProvider_CreateCustomerOrder'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomerOrder
GO

CREATE PROCEDURE dbo.Shared_CustomerDataProvider_CreateCustomerOrder(
	@CustomerID int
)
AS
BEGIN
	INSERT INTO dbo.CustomerOrder(
		CustomerID
	) VALUES (
		@CustomerID
	)

	RETURN SCOPE_IDENTITY()
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [dbo].[Customer]'
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_NumOfEmployeesID] DEFAULT ((0)) FOR [NumOfEmployeesID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_NumOfUsersID] DEFAULT ((0)) FOR [NumOfUsersID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_NumOfPhysiciansID] DEFAULT ((0)) FOR [NumOfPhysiciansID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_AnnualCompanyRevenueID] DEFAULT ((0)) FOR [AnnualCompanyRevenueID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [DF_Customer_MarketingSourceID] DEFAULT ((0)) FOR [MarketingSourceID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[Customer]'
GO
ALTER TABLE [dbo].[Customer] ADD
CONSTRAINT [FK_Customer_DemographicNumOfEmployees] FOREIGN KEY ([NumOfEmployeesID]) REFERENCES [dbo].[DemographicNumOfEmployees] ([NumOfEmployeesID]),
CONSTRAINT [FK_CustomerDemographicNumOfUsers] FOREIGN KEY ([NumOfUsersID]) REFERENCES [dbo].[DemographicNumOfUsers] ([NumOfUsersID]),
CONSTRAINT [FK_Customer_DemographicNumOfPhysicians] FOREIGN KEY ([NumOfPhysiciansID]) REFERENCES [dbo].[DemographicNumOfPhysicians] ([NumOfPhysiciansID]),
CONSTRAINT [FK_Customer_DemographicAnnualCompanyRevenue] FOREIGN KEY ([AnnualCompanyRevenueID]) REFERENCES [dbo].[DemographicAnnualCompanyRevenue] ([AnnualCompanyRevenueID]),
CONSTRAINT [FK_Customer_DemographicMarketingSource] FOREIGN KEY ([MarketingSourceID]) REFERENCES [dbo].[DemographicMarketingSource] ([MarketingSourceID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[CustomerOrderEdition]'
GO
ALTER TABLE [dbo].[CustomerOrderEdition] ADD
CONSTRAINT [FK_CustomerOrderSubscription_CustomerOrder] FOREIGN KEY ([CustomerOrderID]) REFERENCES [dbo].[CustomerOrder] ([CustomerOrderID]),
CONSTRAINT [FK_CustomerOrderEdition_EditionType] FOREIGN KEY ([EditionTypeID]) REFERENCES [dbo].[EditionType] ([EditionTypeId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[CustomerOrderSupport]'
GO
ALTER TABLE [dbo].[CustomerOrderSupport] ADD
CONSTRAINT [FK_CustomerOrderSupport_CustomerOrder] FOREIGN KEY ([CustomerOrderID]) REFERENCES [dbo].[CustomerOrder] ([CustomerOrderID]),
CONSTRAINT [FK_CustomerOrderSupport_SupportType] FOREIGN KEY ([SupportTypeID]) REFERENCES [dbo].[SupportType] ([SupportTypeId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[CustomerOrderBilling]'
GO
ALTER TABLE [dbo].[CustomerOrderBilling] ADD
CONSTRAINT [FK_CustomerOrderBilling_CustomerOrder] FOREIGN KEY ([CustomerOrderID]) REFERENCES [dbo].[CustomerOrder] ([CustomerOrderID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[CustomerOrder]'
GO
ALTER TABLE [dbo].[CustomerOrder] ADD
CONSTRAINT [FK_CustomerOrder_CustomerID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer] ([CustomerID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[EditionType]'
GO
ALTER TABLE [dbo].[EditionType] ADD
CONSTRAINT [FK_EditionType_EditionType] FOREIGN KEY ([EditionTypeId]) REFERENCES [dbo].[EditionType] ([EditionTypeId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering trigger [dbo].[tr_Customer_TrialSecurity] on [dbo].[Customer]'
GO
--===========================================================================
-- Handle the trial/non-trial security for users associated with customers
--===========================================================================
ALTER TRIGGER dbo.tr_Customer_TrialSecurity
ON	dbo.Customer
FOR	INSERT, UPDATE
AS
BEGIN

	DECLARE @CustomerID int

	SELECT	@CustomerID = CustomerID
	FROM	inserted I
	
	-- Update the current list of customers to force the update trigger to execute
	UPDATE 	CustomerUsers 
	SET 	CustomerID = @CustomerID
	WHERE	CustomerID = @CustomerID
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO








/*



SYNC DATA


*/
SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- Pointer used for text / image updates. This might not be needed, but is declared here just in case
DECLARE @pv binary(16)

BEGIN TRANSACTION
ALTER TABLE [dbo].[EditionType] DROP CONSTRAINT [FK_EditionType_EditionType]
SET IDENTITY_INSERT [dbo].[PaymentType] ON
INSERT INTO [dbo].[PaymentType] ([PaymentTypeId], [PaymentTypeCaption]) VALUES (1, N'Visa')
INSERT INTO [dbo].[PaymentType] ([PaymentTypeId], [PaymentTypeCaption]) VALUES (2, N'Mastercard')
INSERT INTO [dbo].[PaymentType] ([PaymentTypeId], [PaymentTypeCaption]) VALUES (3, N'American Express')
INSERT INTO [dbo].[PaymentType] ([PaymentTypeId], [PaymentTypeCaption]) VALUES (4, N'Discover')
SET IDENTITY_INSERT [dbo].[PaymentType] OFF
SET IDENTITY_INSERT [dbo].[SupportType] ON
INSERT INTO [dbo].[SupportType] ([SupportTypeId], [SupportTypeCaption]) VALUES (1, N'Platnum')
INSERT INTO [dbo].[SupportType] ([SupportTypeId], [SupportTypeCaption]) VALUES (2, N'Gold')
INSERT INTO [dbo].[SupportType] ([SupportTypeId], [SupportTypeCaption]) VALUES (3, N'Standard')
INSERT INTO [dbo].[SupportType] ([SupportTypeId], [SupportTypeCaption]) VALUES (4, N'None')
SET IDENTITY_INSERT [dbo].[SupportType] OFF
SET IDENTITY_INSERT [dbo].[EditionType] ON
INSERT INTO [dbo].[EditionType] ([EditionTypeId], [EditionTypeCaption]) VALUES (1, N'Enterprise')
INSERT INTO [dbo].[EditionType] ([EditionTypeId], [EditionTypeCaption]) VALUES (2, N'Team')
INSERT INTO [dbo].[EditionType] ([EditionTypeId], [EditionTypeCaption]) VALUES (3, N'Basic')
INSERT INTO [dbo].[EditionType] ([EditionTypeId], [EditionTypeCaption]) VALUES (4, N'Solo')
INSERT INTO [dbo].[EditionType] ([EditionTypeId], [EditionTypeCaption]) VALUES (5, N'Trial')
SET IDENTITY_INSERT [dbo].[EditionType] OFF
ALTER TABLE [dbo].[EditionType] ADD CONSTRAINT [FK_EditionType_EditionType] FOREIGN KEY ([EditionTypeId]) REFERENCES [dbo].[EditionType] ([EditionTypeId])
COMMIT TRANSACTION