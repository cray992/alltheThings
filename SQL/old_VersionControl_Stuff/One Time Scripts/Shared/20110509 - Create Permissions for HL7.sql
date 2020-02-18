   USE superbill_shared
   
   IF NOT EXISTS ( SELECT   *
                   FROM     dbo.UsersSecurityGroup
                   WHERE    UserID = 21393 AND SecurityGroupID = 19751) 
    BEGIN
        INSERT  dbo.UsersSecurityGroup (UserID, SecurityGroupID, CreatedDate, CreatedUserID, ModifiedDate,
                                        ModifiedUserID)
        VALUES  (21393, -- UserID - int
                 19751, -- SecurityGroupID - int
                 '2011-05-09 15:16:57', -- CreatedDate - datetime
                 12308, -- CreatedUserID - int
                 '2011-05-09 15:16:57', -- ModifiedDate - datetime
                 12308 -- ModifiedUserID - int
                 )
    END

   
   DECLARE @ID INT
   SET @ID = -1


   IF NOT EXISTS ( SELECT   *
                   FROM     dbo.Permissions
                   WHERE    PermissionValue = 'ReadIntegrationEvent' ) 
    BEGIN
    
        EXEC @ID= Shared_AuthenticationDataProvider_CreatePermission @Name = 'Read Integration Options',
            @Description = 'Read the integration options.', @ViewInKareo = 0, @ViewInServiceManager = 1,
            @PermissionGroupID = 34, @PermissionValue = 'ReadIntegrationOptions'

        EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission @CheckPermissionValue = 'KareoAdminAccountManagement',
            @PermissionToApplyID = @ID
    END
	  
	  -- HL7 Group
   IF @ID <> -1
    AND NOT EXISTS ( SELECT *
                     FROM   dbo.SecurityGroupPermissions
                     WHERE  SecurityGroupID = 19751
                            AND PermissionID = @ID ) 
    BEGIN
        INSERT  SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed)
                SELECT  19751, @ID, 1 Allowed
    END
    
    DECLARE @ID INT
   SET @ID = -1
    
	SELECT * FROM dbo.Permissions WHERE PermissionValue ='NewIntegrationError'
	
   IF NOT EXISTS ( SELECT   *
                   FROM     dbo.Permissions
                   WHERE    PermissionValue = 'NewIntegrationError' ) 
    BEGIN
        EXEC @ID= Shared_AuthenticationDataProvider_CreatePermission @Name = 'New Integration Error',
            @Description = 'Create a new error from a third-party integrator', @ViewInKareo = 0, @ViewInServiceManager = 1,
            @PermissionGroupID = 34, @PermissionValue = 'NewIntegrationError'
	  
        EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission @CheckPermissionValue = 'KareoAdminAccountManagement',
            @PermissionToApplyID = @ID
    END
	  
	  SELECT * FROM dbo.Permissions WHERE PermissionValue = 'ReadIntegrationErrors'
	  
	  SELECT * FROM dbo.Permissions WHERE PermissionValue LIKE '%integ%'
	  UPDATE dbo.Permissions SET name = 'Read Integration Error', PermissionValue='ReadIntegrationError' WHERE PermissionID = 569
	  UPDATE dbo.Permissions SET name = 'Edit Integration Error', PermissionValue='EditIntegrationError' WHERE PermissionID = 570
	  
	  BEGIN TRAN
	  DELETE FROM dbo.SecurityGroupPermissions
	  WHERE PermissionID IN (571,572)
	  
	  DELETE FROM dbo.Permissions
	  WHERE PermissionID IN (571,572)
	  ROLLBACK
	  
	  BEGIN TRAN
	  UPDATE dbo.Permissions
	  SET Description = 'Show the details of an integration error record.' WHERE PermissionID= 569
	  UPDATE dbo.Permissions
	  SET Description = 'Modify the details of an integration error record.' WHERE PermissionID= 570
	  UPDATE dbo.Permissions
	  SET Description = 'Create an integration error record.' WHERE PermissionID= 573
	  ROLLBACK TRAN
	  
	  UPDATE dbo.Permissions SET PermissionValue = 'NewIntegrationError' WHERE PermissionID = 573
	  
	  -- HL7 Group
   IF @ID <> -1
    AND NOT EXISTS ( SELECT *
                     FROM   dbo.SecurityGroupPermissions
                     WHERE  SecurityGroupID = 19751
                            AND PermissionID = @ID ) 
    BEGIN
        INSERT  SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed)
                SELECT  19751, @ID, 1 Allowed
    END
	  
	  
   SET @ID = -1
	  
   IF NOT EXISTS ( SELECT   *
                   FROM     dbo.Permissions
                   WHERE    PermissionValue = 'EditIntegrationErrors' ) 
    BEGIN
        EXEC @ID= Shared_AuthenticationDataProvider_CreatePermission @Name = 'Edit Integration Errors',
            @Description = 'Edit errors from a thrid-party integrator', @ViewInKareo = 0, @ViewInServiceManager = 1,
            @PermissionGroupID = 34, @PermissionValue = 'EditIntegrationErrors'
	  
        EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission @CheckPermissionValue = 'KareoAdminAccountManagement',
            @PermissionToApplyID = @ID
    END
	  		  
	  -- HL7 Group
   IF @ID <> -1
    AND NOT EXISTS ( SELECT *
                     FROM   dbo.SecurityGroupPermissions
                     WHERE  SecurityGroupID = 19751
                            AND PermissionID = @ID ) 
    BEGIN
        INSERT  SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed)
                SELECT  19751, @ID, 1 Allowed
    END
    
    DECLARE @id int
    SET @ID = -1
	  
   IF NOT EXISTS ( SELECT   *
                   FROM     dbo.Permissions
                   WHERE    PermissionValue = 'ReadIntegrationEvent' ) 
    BEGIN
        EXEC @ID= Shared_AuthenticationDataProvider_CreatePermission @Name = 'Read Integration Events',
            @Description = 'Read integration events', @ViewInKareo = 0, @ViewInServiceManager = 1,
            @PermissionGroupID = 34, @PermissionValue = 'ReadIntegrationEvent'
	  
        EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission @CheckPermissionValue = 'KareoAdminAccountManagement',
            @PermissionToApplyID = @ID
    END
	  		  
	  -- HL7 Group
   IF @ID <> -1
    AND NOT EXISTS ( SELECT *
                     FROM   dbo.SecurityGroupPermissions
                     WHERE  SecurityGroupID = 19751
                            AND PermissionID = @ID ) 
    BEGIN
        INSERT  SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed)
                SELECT  19751, @ID, 1 Allowed
    END
    
    
    SET @ID = -1
	  
   IF NOT EXISTS ( SELECT   *
                   FROM     dbo.Permissions
                   WHERE    PermissionValue = 'EditIntegrationEvent' ) 
    BEGIN
        EXEC @ID= Shared_AuthenticationDataProvider_CreatePermission @Name = 'Edit Integration Events',
            @Description = 'Edit integration events', @ViewInKareo = 0, @ViewInServiceManager = 1,
            @PermissionGroupID = 34, @PermissionValue = 'EditIntegrationEvent'
	  
        EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission @CheckPermissionValue = 'KareoAdminAccountManagement',
            @PermissionToApplyID = @ID
    END
	  
	  SELECT * FROM dbo.Permissions WHERE PermissionValue LIKE '%inte%'
	  		  
	  		  UPDATE dbo.Permissions SET Description = 'Read Integration Events (HL7 Shard)' WHERE PermissionID = 574
	  		  UPDATE dbo.Permissions SET Description = 'Edit Integration Events (HL7 Shard)' WHERE PermissionID = 575
	  		  
	  -- HL7 Group
   IF @ID <> -1
    AND NOT EXISTS ( SELECT *
                     FROM   dbo.SecurityGroupPermissions
                     WHERE  SecurityGroupID = 19751
                            AND PermissionID = @ID ) 
    BEGIN
        INSERT  SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed)
                SELECT  19751, @ID, 1 Allowed
    END
    
    
    -- Add permissions to HL7 group
   SELECT   @ID = PermissionID
   FROM     dbo.Permissions
   WHERE    PermissionValue = 'ReadPatient'
    
   IF NOT EXISTS ( SELECT   *
                   FROM     dbo.SecurityGroupPermissions
                   WHERE    SecurityGroupID = 19751
                            AND PermissionID = @ID ) 
    BEGIN
        INSERT  SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed)
                SELECT  19751, @ID, 1 Allowed
    END
    
    
   SELECT   @ID = PermissionID
   FROM     dbo.Permissions
   WHERE    PermissionValue = 'ReadAppointment'
    
   IF NOT EXISTS ( SELECT   *
                   FROM     dbo.SecurityGroupPermissions
                   WHERE    SecurityGroupID = 19751
                            AND PermissionID = @ID ) 
    BEGIN
        INSERT  SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed)
                SELECT  19751, @ID, 1 Allowed
    END
    