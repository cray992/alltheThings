DECLARE 
       @srcCustomerID INT,
       @destCustomerID INT
       
SET @srcCustomerID= XXXXX
SET @destCustomerID= XXXXX

USE superbill_shared


--BEGIN TRAN
----DELETE dbo.UsersSecurityGroup WHERE SecurityGroupID IN (SELECT SecurityGroupID FROM dbo.SecurityGroup WHERE CustomerID=@destCustomerID)
----DELETE dbo.SecurityGroup WHERE CustomerID=@destCustomerID

--UPDATE dbo.SecurityGroup SET SecurityGroupName='[new] ' + SecurityGroupName WHERE CustomerID=@destCustomerID AND NOT SecurityGroupName LIKE '%new%'




--INSERT INTO dbo.SecurityGroup
--        ( CustomerID ,
--          SecurityGroupName ,
--          SecurityGroupDescription ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          ViewInServiceManager ,
--          ViewInKareo
--        )
--select   @destCustomerID , -- CustomerID - int
--          SecurityGroupName , -- SecurityGroupName - varchar(32)
--         SecurityGroupDescription , -- SecurityGroupDescription - varchar(500)
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          ViewInServiceManager , -- ViewInServiceManager - bit
--          ViewInKareo  -- ViewInKareo - bit
--FROM dbo.SecurityGroup 
--WHERE CustomerID=@srcCustomerID
--And SecurityGroupName not in (Select SecurityGroupName from securitygroup where customerId=@destCustomerID)

--Count =


--DISABLE TRIGGER dbo.tr_KareoAdmin_Added_Insert on dbo.UsersSecurityGroup
--INSERT INTO dbo.UsersSecurityGroup
--        ( UserID ,
--          SecurityGroupID ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID 
--        )
--select    SSG.UserID , -- UserID - int
--          TargSG.SecurityGroupID , -- SecurityGroupID - int
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0  -- ModifiedUserID - int
--FROM dbo.UsersSecurityGroup SSG
--       JOIN dbo.SecurityGroup SrcSG ON SrcSG.SecurityGroupID=SSG.SecurityGroupID
--       JOIN dbo.SecurityGroup TargSG ON TargSG.CustomerID=@destCustomerID AND TargSG.SecurityGroupName=SrcSG.SecurityGroupName
--       JOIN [SourceServer].[superbill_XXXXX_prod].[dbo].[UserPractices] UP ON SSG.UserID = UP.UserID AND UP.PracticeID = X
--        Join Users U on up.userid=u.userId and Accountlocked=0
--WHERE SSG.SecurityGroupID IN (SELECT SecurityGroupID FROM dbo.SecurityGroup WHERE CustomerID=@srcCustomerID)
--ENABLE TRIGGER dbo.tr_KareoAdmin_Added_Insert on dbo.UsersSecurityGroup
--Count =

---SECURITY GROUP PERMISSIONS
--INSERT INTO dbo.SecurityGroupPermissions
--        ( SecurityGroupID ,
--          PermissionID ,
--          Allowed ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          Denied
--        )
--SELECT TargSG.SecurityGroupID , -- SecurityGroupID - int
--          SGP.PermissionID , -- PermissionID - int
--          SGP.Allowed , -- Allowed - bit
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          SGP.Denied  -- Denied - bit
--FROM dbo.SecurityGroupPermissions SGP
--       JOIN dbo.SecurityGroup SrcSG ON SrcSG.SecurityGroupID=SGP.SecurityGroupID
--       JOIN dbo.SecurityGroup TargSG ON TargSG.CustomerID=@destCustomerID AND TargSG.SecurityGroupName=SrcSG.SecurityGroupName
--WHERE SGP.SecurityGroupID IN (SELECT SecurityGroupID FROM dbo.SecurityGroup WHERE CustomerID=@srcCustomerID) 
----5072




--DELETE dbo.CustomerUsers WHERE CustomerID=@destCustomerID AND UserID<>41924
----
--INSERT INTO dbo.CustomerUsers
--        ( CustomerID, UserID, UserRoleID )
--select   @destCustomerID, -- CustomerID - int
--          CU.UserID, -- UserID - int
--          CU.UserRoleID -- UserRoleID - int
--FROM dbo.CustomerUsers CU
--       inner JOIN dbo.Users U ON CU.UserID=U.UserID AND U.UserID NOT IN (519)AND AccountLocked=0
--       inner JOIN  [SourceServer].[superbill_XXXX_prod].dbo.UserPractices UP ON CU.UserID = UP.UserID AND UP.PracticeID = X
--WHERE CU.CustomerID=@srcCustomerID
--196

/*
Declare @CustomerID int
SET @CustomerID = XXX

            DECLARE @UnMappedSecurityGroups TABLE(OldSecurityGroupID INT, RoleID INT)

            INSERT INTO dbo.UserAccount_Roles
                  ( CustomerID ,
                    Name ,
                    Description ,
                    CreatedDate ,
                    ModifiedDate ,
                    ViewInKareo,
                    OldSecurityGroupID
                  )
                  OUTPUT INSERTED.OldSecurityGroupID, INSERTED.RoleID
                  INTO @UnmappedSecurityGroups
            SELECT sg.CustomerID, sg.SecurityGroupName, sg.SecurityGroupDescription, sg.CreatedDate, sg.ModifiedDate, sg.ViewInKareo, sg.SecurityGroupID
            FROM dbo.SecurityGroup AS sg
            LEFT JOIN dbo.UserAccount_RoleToSecurityGroupMap AS uartsgm ON sg.SecurityGroupID = uartsgm.SecurityGroupID
            WHERE uartsgm.SecurityGroupID IS NULL
            AND ViewInKareo = 1 AND ViewInServiceManager = 0 AND ( sg.CustomerID = @CustomerID OR @CustomerID IS NULL )


       

            INSERT INTO dbo.UserAccount_RoleToSecurityGroupMap
                  ( RoleID, SecurityGroupID )
            SELECT UMSG.RoleID, UMSG.OldSecurityGroupID
            FROM @UnmappedSecurityGroups AS UMSG

            INSERT INTO dbo.UserAccount_RolePermissions
                  ( RoleID, PermissionID )
            SELECT DISTINCT uar.RoleID, UANOPM.NewPermissionID 
            FROM @UnmappedSecurityGroups AS UMSG 
            INNER JOIN dbo.UserAccount_Roles AS UAR ON UAR.RoleID = UMSG.RoleID
            INNER JOIN dbo.UserAccount_RoleToSecurityGroupMap AS UARTSGM ON UAR.RoleID = UARTSGM.RoleID
            INNER JOIN dbo.SecurityGroupPermissions AS SGP ON UARTSGM.SecurityGroupID = SGP.SecurityGroupID
            INNER JOIN dbo.UserAccount_NewOldPermissionMap AS UANOPM ON UANOPM.OldPermissionID = sgp.PermissionID
            WHERE Allowed = 1



            INSERT INTO dbo.[UserAccount_UserRoles]
            (UserID, RoleID)
            SELECT USG.UserID, UMSG.RoleID
            FROM @UnmappedSecurityGroups AS UMSG
            INNER JOIN dbo.UsersSecurityGroup AS USG ON UMSG.OldSecurityGroupID = USG.SecurityGroupID


*/

