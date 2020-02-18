SET identity_insert users off
INSERT INTO [dbo].[Users] (
	[UserID] /* Identity Field */ ,
	[NtlmName],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[Prefix],
	[FirstName],
	[MiddleName],
	[LastName],
	[Suffix],
	[AddressLine1],
	[AddressLine2],
	[City],
	[State],
	[Country],
	[ZipCode],
	[WorkPhone],
	[WorkPhoneExt],
	[AlternativePhone],
	[AlternativePhoneExt],
	[EmailAddress],
	[Notes],
	[AccountLockCounter],
	[AccountLocked],
	[UserPasswordID])
SELECT
	[UserID] /* Identity Field */ ,
	[NtlmName],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[Prefix],
	[FirstName],
	[MiddleName],
	[LastName],
	[Suffix],
	[AddressLine1],
	[AddressLine2],
	[City],
	[State],
	[Country],
	[ZipCode],
	[WorkPhone],
	[WorkPhoneExt],
	[AlternativePhone],
	[AlternativePhoneExt],
	[EmailAddress],
	[Notes],
	[AccountLockCounter],
	[AccountLocked],
	null
FROM superbill_0001_prod.dbo.Users

SET identity_insert userpassword on

INSERT INTO [dbo].[UserPassword] (
	[UserPasswordID] /* Identity Field */ ,
	[UserID],
	[Password],
	[SecretQuestion],
	[SecretAnswer],
	[CreatedDate],
	[Expired])
SELECT
	[UserPasswordID] /* Identity Field */ ,
	[UserID],
	[Password],
	[SecretQuestion],
	[SecretAnswer],
	[CreatedDate],
	[Expired]
FROM superbill_0001_prod.dbo.UserPassword


SET identity_insert userpassword off

UPDATE users
	SET UserPasswordID = UU.UserPasswordID
FROM Users U
INNER JOIN superbill_0001_prod.dbo.Users UU
ON U.UserID = UU.UserID

SET identity_insert SecurityGroup ON
INSERT INTO [dbo].[SecurityGroup] (
	[SecurityGroupID] /* Identity Field */ ,
	[CustomerID],
	[SecurityGroupName],
	[SecurityGroupDescription],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[ViewInMedicalOffice],
	[ViewInBusinessManager],
	[ViewInAdministrator],
	[ViewInServiceManager])
SELECT
	GG.GroupID /* Identity Field */ ,
	1,
	Name,
	Description,
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[ViewInMedicalOffice],
	[ViewInBusinessManager],
	[ViewInAdministrator],
	[ViewInServiceManager]
FROM superbill_0001_prod.dbo.Groups GG

SET identity_insert SecurityGroup off


INSERT INTO [dbo].[SecurityGroupPermissions] (
	[SecurityGroupID],
	[PermissionID],
	[Allowed],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[Denied])
SELECT
	GP.GroupID,
	[PermissionID],
	[Allowed],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[Denied]
FROM superbill_0001_prod.dbo.GroupPermissions GP

INSERT INTO [dbo].[UsersSecurityGroup] (
	[UserID],
	[SecurityGroupID],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID]
	)
select
	[UserID],
	[GroupID],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID]
FROM superbill_0001_prod.dbo.UserGroups

INSERT CustomerUsers(CustomerID, UserID)
SELECT 1, UserID
FROM dbo.Users


