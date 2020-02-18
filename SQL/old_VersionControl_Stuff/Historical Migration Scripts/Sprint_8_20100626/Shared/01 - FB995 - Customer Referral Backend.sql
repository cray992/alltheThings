IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CustomerReferral')
BEGIN
	CREATE TABLE [dbo].[CustomerReferral](
		[UserID] [int] NOT NULL,
		[RefereeFirst] [varchar](100) NOT NULL,
		[RefereeLast] [varchar](100) NOT NULL,
		[RefereeEmail] [varchar](320) NOT NULL,
		[ReferralType] [char](1) NOT NULL,
		[ReferralCode] [varchar](50) NOT NULL,
		[DateTime] [datetime] NOT NULL
	) ON [PRIMARY]

	ALTER TABLE [dbo].[CustomerReferral]  WITH CHECK ADD  CONSTRAINT [FK_CustomerReferral_User] FOREIGN KEY([UserID])
	REFERENCES [dbo].[Users] ([UserID])

	ALTER TABLE [dbo].[CustomerReferral] CHECK CONSTRAINT [FK_CustomerReferral_User]
END