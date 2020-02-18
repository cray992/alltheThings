/*----------------------------------

DATABASE UPDATE SCRIPT

v1.41.xxxx to v1.42.xxxx
----------------------------------*/

--
--alter table customer add ReportingDatabaseServerName varchar(50), ReportingDatabaseName varchar(50)
--GO
--
--	Update customer
--	SET ReportingDatabaseServerName = 'kprod_db05',
--		ReportingDatabaseName = 'superbill_0001_repl'
--	WHERE CustomerID = 1
--GO
--

/*-----------------------------------------------------------------------------
	Case 20625 - Enforcing closing date
-----------------------------------------------------------------------------*/

/* Create new 'Override Delete Capitated Account Restrictions' permission ... */
DECLARE @NewOverridePermissionID INT

EXEC @NewOverridePermissionID = Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Override Delete Capitated Account Restrictions',
	@Description='Override restrictions on deleting capitated accounts, specifically related to closing the books date', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=19,
	@PermissionValue='OverrideDeleteCapitatedAccountRestrictions'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='OverrideDeleteRefundRestrictions',
	@PermissionToApplyID=@NewOverridePermissionID
GO

/* Create new 'Delete Claim Transaction' permission ... */
DECLARE @NewDeleteClaimTransactionPermissionID INT

EXEC @NewDeleteClaimTransactionPermissionID = Shared_AuthenticationDataProvider_CreatePermission 
	@Name='Delete Claim Transactions',
	@Description='Delete a transaction on a claim.', 
	@ViewInKareo=1,
	@ViewInServiceManager=1,
	@PermissionGroupID=9,
	@PermissionValue='DeleteClaimTransaction'
 

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
	@CheckPermissionValue='PostClaimTransactions',
	@PermissionToApplyID=@NewDeleteClaimTransactionPermissionID
GO

/* Rename Override permissions ... */
UPDATE dbo.[Permissions]  
SET [Name] = 'Override Payment Edit Restrictions',
    [Description] = 'Override restrictions on editing payments, specifically related to closing the books date',
	[PermissionValue] = 'OverridePaymentEditRestrictions'  
WHERE [Name] = 'Override Delete Payment Restrictions'  
GO    

UPDATE dbo.[Permissions]  
SET [Name] = 'Override Refund Edit Restrictions',
    [Description] = 'Override restrictions on editing refunds, specifically related to closing the books date',  
	[PermissionValue] = 'OverrideRefundEditRestrictions'  
WHERE [Name] = 'Override Delete Refund Restrictions'  
GO    

UPDATE dbo.[Permissions]  
SET [Name] = 'Override Capitated Account Edit Restrictions',
    [Description] = 'Override restrictions on editing capitated accounts, specifically related to closing the books date',  
	[PermissionValue] = 'OverrideCapitatedAccountEditRestrictions'  
WHERE [Name] = 'Override Delete Capitated Account Restrictions'  
GO




-- Merge Override Delete Last Claim Transaction Restrictions into Override Claim Charge Edit Restrictions
declare @Delete_PermissionID INT
declare @Replace_PermissionID INT

select @Delete_PermissionID = PermissionID from permissions where name = 'Override Delete Last Claim Transaction Restrictions'
select @Replace_PermissionID = PermissionID from permissions where name = 'Override Claim Charge Edit Restrictions'


update SecurityGroupPermissions
SET PermissionID = @Replace_PermissionID
where permissionID = @Delete_PermissionID
	AND SecurityGroupID NOT in (select SecurityGroupID from SecurityGroupPermissions where PermissionID = @Replace_PermissionID)


delete SecurityGroupPermissions
where permissionID = @Delete_PermissionID

delete permissions where permissionID = @Delete_PermissionID

GO   
-- Renaming it again. Should be in the first set, but too lazy to restage.
update [permissions]
SET [Name] = 'Override Closing Date for Capitated Account'
where permissionValue = 'OverrideCapitatedAccountEditRestrictions'


/* Rename Override permissions ... */
UPDATE dbo.[Permissions]  
SET [Name] = 'Override Closing Date for Payment'
WHERE [PermissionValue] = 'OverridePaymentEditRestrictions'  


UPDATE dbo.[Permissions]  
SET [Name] = 'Override Closing Date for Refund'
WHERE [PermissionValue] = 'OverrideRefundEditRestrictions'  


UPDATE dbo.[Permissions]  
SET [Name] = 'Override Closing Date for Claim'
WHERE [PermissionValue] = 'OverrideClaimChargeEditRestrictions'  
GO


/*-----------------------------------------------------------------------------
	Case 20529 - Implement system notifications from Kareo to all users
-----------------------------------------------------------------------------*/

INSERT INTO SharedSystemPropertiesAndValues(PropertyName,Value)
VALUES ('SystemMessageFeedRefreshMinutes','15')

INSERT INTO SharedSystemPropertiesAndValues(PropertyName,Value)
VALUES ('SystemMessageFeedUrl','http://feeds.kareo.com/Notification/rss.aspx')
GO

/*-----------------------------------------------------------------------------
	Case 20764:   User Role Browser: SqlException on delete 
-----------------------------------------------------------------------------*/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_UserRole]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [FK_Users_UserRole], COLUMN UserRoleID
GO





/*-----------------------------------------------------------------------------
	Case XXXXX - TITLE
-----------------------------------------------------------------------------*/
