/*
-- TODO: create CreatePractice and DeactivatePractice permissions, assign those to users with ManagePractice permissions
declare @GroupID int
DECLARE @PermissionID INT

DECLARE @PermissionName VARCHAR(128)
DECLARE @PermissionDescription VARCHAR(500)
DECLARE @PermissionValue VARCHAR(128)

SET  @GroupID=12 -- Managing practices including adding and updating practice information.

SET @PermissionName='Create Practice'
SET @PermissionDescription='Create a new Practice.'
SET @PermissionValue='CreatePractice'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ManagePractice',
@PermissionToApplyID=@PermissionID


SET @PermissionName='Deactivate Practice'
SET @PermissionDescription='Deactivate Practice.'
SET @PermissionValue='DeactivatePractice'

EXEC @PermissionID=dbo.Shared_AuthenticationDataProvider_CreatePermission @Name=@PermissionName,
@Description=@PermissionDescription, @ViewInKareo=1, @ViewInServiceManager=1, 
@PermissionGroupID=@GroupID, @PermissionValue=@PermissionValue

EXEC Shared_AuthenticationDataProvider_CreateSecurityGroupPermission
@CheckPermissionValue='ManagePractice',
@PermissionToApplyID=@PermissionID

*/

DECLARE
	@QuestAdminSecGrp INT,
	@QuestUserSecGrp INT
	
	
---------------------------------------- QUEST ADMIN -------------------------------------
 
INSERT INTO dbo.SecurityGroup 
         ( CustomerID ,
           SecurityGroupName ,
           SecurityGroupDescription ,
           ViewInServiceManager ,
           ViewInKareo
         )
VALUES  ( NULL , -- CustomerID - int
           'Quest Admin' , -- SecurityGroupName - varchar(32)
           'Quest Admin Group' , -- SecurityGroupDescription - varchar(500)
           1 , -- ViewInServiceManager - bit
           0  -- ViewInKareo - bit
         )
SET @QuestAdminSecGrp=SCOPE_IDENTITY()

-- copy permissions that currently assigned to Standard 'Administrator' canned group
INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed ,
          Denied
        )
select 
		@QuestAdminSecGrp , -- SecurityGroupID - int
        GP.PermissionID , -- PermissionID - int
        CASE GP.PermissionID WHEN 498 THEN 1 WHEN 463 THEN 1 ELSE GP.Allowed END, -- Allowed - allow Access to all practices (463) and Edit Provider Type for Provider (498)
        GP.Denied 
FROM dbo.SecurityGroupPermissions GP 
	JOIN SecurityGroup SG ON SG.SecurityGroupID=GP.SecurityGroupID AND CustomerID IS NULL AND ViewInKareo=0 AND ViewInServiceManager=0 AND SG.SecurityGroupName='Administrator'


-- allow Access to all practices (463), Edit Provider Type for Provider (498) and EditSubscriptionEdition (505)

INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed 
        )
VALUES  ( @QuestAdminSecGrp , -- SecurityGroupID - int
          498 , -- PermissionID - int
          1 -- Allowed - bit
        )
        
INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed 
        )
VALUES  ( @QuestAdminSecGrp , -- SecurityGroupID - int
          463 , -- PermissionID - int
          1 -- Allowed - bit
        )

INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed 
        )
VALUES  ( @QuestAdminSecGrp , -- SecurityGroupID - int
          505 , -- PermissionID - int
          1 -- Allowed - bit
        )


INSERT INTO dbo.SharedSystemPropertiesAndValues
        ( PropertyName ,
          Value ,
          PropertyDescription 
        )
VALUES  ( 'QuestAdminUserSecurityGroupID' , -- PropertyName - varchar(128)
          @QuestAdminSecGrp , -- Value - varchar(max)
          'This is the key value of the SecurityGroup record for the Quest Admin security group'  -- PropertyDescription - varchar(500)
        )

---------------------------------------- QUEST USER -------------------------------------

INSERT INTO dbo.SecurityGroup 
         ( CustomerID ,
           SecurityGroupName ,
           SecurityGroupDescription ,
           ViewInServiceManager ,
           ViewInKareo
         )
VALUES  ( NULL , -- CustomerID - int
           'Quest User' , -- SecurityGroupName - varchar(32)
           'Quest User Group' , -- SecurityGroupDescription - varchar(500)
           1 , -- ViewInServiceManager - bit
           0  -- ViewInKareo - bit
         )
SET @QuestUserSecGrp=SCOPE_IDENTITY()



-- copy permissions that currently assigned to Kareo User
INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed ,
          Denied
        )
select 
		@QuestUserSecGrp, -- SecurityGroupID - int
        GP.PermissionID, -- PermissionID - int
        GP.Allowed,
        GP.Denied -- 
FROM dbo.SecurityGroupPermissions GP 
	JOIN dbo.SecurityGroup SG ON SG.SecurityGroupID=GP.SecurityGroupID AND SG.SecurityGroupName='Kareo User' AND CustomerID IS NULL AND ViewInKareo=0 AND ViewInServiceManager=1

INSERT INTO dbo.SharedSystemPropertiesAndValues
        ( PropertyName ,
          Value ,
          PropertyDescription 
        )
VALUES  ( 'QuestDefaultUserSecurityGroupID' , -- PropertyName - varchar(128)
          @QuestUserSecGrp , -- Value - varchar(max)
          'This is the key value of the SecurityGroup record for the Default Quest User security group'  -- PropertyDescription - varchar(500)
        )

-- deny some permissions for Quest Users
INSERT INTO SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed, Denied) VALUES (@QuestUserSecGrp, 243, 0, 1) -- Manage Practices
INSERT INTO SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed, Denied) VALUES (@QuestUserSecGrp, 512, 0, 1) -- Manage Account
INSERT INTO SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed, Denied) VALUES (@QuestUserSecGrp, 181, 0, 1) -- Manage Providers
INSERT INTO SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed, Denied) VALUES (@QuestUserSecGrp, 556, 0, 1) -- Integration Options
INSERT INTO SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed, Denied) VALUES (@QuestUserSecGrp, 505, 0, 1) -- Edit Subscription Edition


-- give EditSubscriptionEdition to Kareo User
INSERT INTO SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed, Denied) VALUES (27, 505, 1, 0) -- Edit Subscription Edition