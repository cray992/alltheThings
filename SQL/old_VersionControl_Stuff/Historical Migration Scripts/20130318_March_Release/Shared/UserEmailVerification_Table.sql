IF NOT EXISTS(SELECT  IST.* FROM    INFORMATION_SCHEMA.TABLES AS IST
	WHERE IST.TABLE_SCHEMA = 'dbo' AND IST.TABLE_NAME = 'UserEmailVerification') 
BEGIN
	CREATE TABLE UserEmailVerification
	(
		[UserEmailVerificationId]	INT IDENTITY(1,1) NOT NULL,
		[UserId]					INT NOT NULL,			-- what user to associate this request with
		[EmailAddress]				VARCHAR(128) NULL,		-- Optional email address - used for change of email
		[VerificationToken]			UNIQUEIDENTIFIER NOT NULL,			-- GUID to check against during verification
		[VerificationType]			INT NOT NULL,			-- Email verification, Change of email address
		[Expiration]				DATETIME NULL,			-- When will this token expire (Null = never expires)
		[Status]					INT NOT NULL,			-- Pending, Expired, Used
		
		CONSTRAINT [PK_UserEmailVerification] PRIMARY KEY CLUSTERED
			( [UserEmailVerificationId] ASC )
	)
END

If NOT Exists(Select * from sys.indexes where name='IX_UserEmailVerification_UserId') 
BEGIN
	Create Nonclustered Index IX_UserEmailVerification_UserId 
		ON UserEmailVerification([UserId])
END

If NOT Exists(Select * from sys.indexes where name='IX_UserEmailVerification_VerificationToken') 
BEGIN
	Create Nonclustered Index IX_UserEmailVerification_VerificationToken
		ON UserEmailVerification([VerificationToken])
END