
BEGIN TRAN

BEGIN TRY


		-- Save the User's Adminstrator's profile. This is to undo the changes at a later time
		select * 
		into  #UsersSecurityGroup
		from superbill_0001_prod_UsersSecurityGroup_OrigSetting


		select * 
		into  #SecurityGroupPermissions
		from superbill_0001_prod_SecurityGroupPermissions_OrigSetting



		-- Find All Department B's & Users who has access to more then 50% of the practices. User to be locked out.
		select * 
		INTO #Users
		from superbill_0001_prod_Users_OrigSetting 





		-- Disable Adminsitrator Priveliges for non-"System Administrator Group"
		update sgp
		SET Allowed = orig.Allowed, Denied = orig.Denied
		from SecurityGroupPermissions sgp
			INNER JOIN #SecurityGroupPermissions orig ON orig.SecurityGroupID = sgp.SecurityGroupID AND orig.PermissionID = sgp.PermissionID



		-- Remove Users who are no longer part of the System Administrator's group
		INSERT INTO [UsersSecurityGroup]
           ([UserID]
           ,[SecurityGroupID]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID])

		select [UserID]
           ,[SecurityGroupID]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID] 
		from  #UsersSecurityGroup orig








		-- Lock out Department B's User.
		Update U
		SET AccountLocked = 0
		FROM Users u
			INNER JOIN #Users orig ON u.UserID = orig.UserID

		drop table #Users, #UsersSecurityGroup, #SecurityGroupPermissions

		drop table 
				superbill_0001_prod_UsersSecurityGroup_OrigSetting, 
				superbill_0001_prod_Users_OrigSetting,
				superbill_0001_prod_SecurityGroupPermissions_OrigSetting

	Commit tran
end try

begin catch

	print 'rollback tran'
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










