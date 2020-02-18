/*


	Step 1. Must Create a new Group. Note that the name must be unique


*/

DECLARE @SourceGroupName VARCHAR(MAX)
DECLARE @TargetGroupName VARCHAR(MAX)


SET @SourceGroupName = 'System Administrator'
SET @TargetGroupName = 'Sr. Administrator'



begin tran

begin try


	-- Find Security Groups that have administrator's previlege set (Except for the 'System Administrator' group)
	select sgp.* 
	INTO #SecurityGroupPermissions
	from sharedserver.superbill_shared.dbo.SecurityGroup sg 
	INNER JOIN sharedserver.superbill_shared.dbo.SecurityGroupPermissions sgp ON sgp.SecurityGroupID = sg.SecurityGroupID
	INNER JOIN sharedserver.superbill_shared.dbo.Permissions p on p.PermissionID = sgp.PermissionID
	INNER JOIN sharedserver.superbill_shared.dbo.PermissionGroup pg ON pg.PermissionGroupID = p.PermissionGroupID
	where sg.CustomerID = 1
	AND pg.Name = 'Administering Security'
	AND Denied <> 1
	AND securityGroupName <> 'System Administrator'


	-- Find Users who belong to the group "Security Administrator". All NON Kareo Users will be removed from this Group
	select distinct usg.*
	into #UsersSecurityGroup
	from sharedserver.superbill_shared.dbo.SecurityGroup sg 
		INNER JOIN sharedserver.superbill_shared.dbo.SecurityGroupPermissions sgp ON sgp.SecurityGroupID = sg.SecurityGroupID
		INNER JOIN sharedserver.superbill_shared.dbo.Permissions p on p.PermissionID = sgp.PermissionID
		INNER JOIN sharedserver.superbill_shared.dbo.PermissionGroup pg ON pg.PermissionGroupID = p.PermissionGroupID
		INNER JOIN sharedserver.superbill_shared.dbo.UsersSecurityGroup usg ON usg.SecurityGroupID = sg.SecurityGroupID
		inner join sharedserver.superbill_shared.dbo.users u on u.UserID = usg.UserID
	where sg.CustomerID = 1
		AND pg.Name = 'Administering Security'
		AND securityGroupName = @SourceGroupName
		AND u.emailAddress NOT IN (

			'shaun@kareo.com',
			'phong@kareo.com',
			'adren@kareo.com',
			'dan@kareo.com',
			'Fredrica@kareo.com',
			'jasonm@kareo.com',
			'joe@kareo.com',
			'lawrence@kareo.com',
			'mary@kareo.com',
			'rolland@kareo.com'
		)


	-- Save the User's Adminstrator's profile. This is to undo the changes at a later time
	select * 
	into shared_UsersSecurityGroup_OrigSetting
	from  #UsersSecurityGroup



	select * 
	into shared_SecurityGroupPermissions_OrigSetting
	from  #SecurityGroupPermissions


	-- Disable Adminsitrator Priveliges for non-"System Administrator Group"
	update sgp
	SET Allowed = 0, Denied = 1
	from sharedserver.superbill_shared.dbo.SecurityGroupPermissions sgp
		INNER JOIN #SecurityGroupPermissions orig ON orig.SecurityGroupID = sgp.SecurityGroupID AND orig.PermissionID = sgp.PermissionID



	-- Add the users to the target Source
	DECLARE @TargetSecurityGroupID INT
	SELECT @TargetSecurityGroupID = SecurityGroupID
	FROM sharedserver.[Superbill_Shared].dbo.[SecurityGroup]
	WHERE
		[CustomerID] = 1
		AND [SecurityGroupName] = @TargetGroupName

	INSERT INTO sharedserver.superbill_shared.dbo.UsersSecurityGroup( UserID, SecurityGroupID, [CreatedUserID], [ModifiedUserID] )
	SELECT org.UserID, @TargetSecurityGroupID, 0, 0
	FROM #UsersSecurityGroup org
		LEFT JOIN sharedserver.superbill_shared.dbo.UsersSecurityGroup usg
			ON usg.UserID = org.UserID AND usg.SecurityGroupID  = @TargetSecurityGroupID
	WHERE usg.UserID IS NULL



	-- Remove Users who are no longer part of the System Administrator's group
	delete usg
	from sharedserver.superbill_shared.dbo.UsersSecurityGroup usg
		INNER JOIN #UsersSecurityGroup orig on orig.UserID = usg.UserID AND orig.SecurityGroupID = usg.SecurityGroupID






commit tran

end try

begin catch

				rollback tran

				DECLARE @ErrorMessage NVARCHAR(4000);
				DECLARE @ErrorSeverity INT;
				DECLARE @ErrorState INT;

				SELECT @ErrorMessage = ERROR_MESSAGE(),
					   @ErrorSeverity = ERROR_SEVERITY(),
					   @ErrorState = ERROR_STATE();

				-- Use RAISERROR inside the CATCH block to return 
				-- error information about the original error that 
				-- caused execution to jump to the CATCH block.
				RAISERROR (@ErrorMessage, -- Message text.
						   @ErrorSeverity, -- Severity.
						   @ErrorState -- State.
						   );

end catch


return

/*

drop table #UsersSecurityGroup
drop table #SecurityGroupPermissions
drop table #Users

drop table superbill_0001_prod_Users_OrigSetting
drop table superbill_0001_prod_UsersSecurityGroup_OrigSetting
drop table superbill_0001_prod_SecurityGroupPermissions_OrigSetting

*/

select * from superbill_0001_prod_Users_OrigSetting





