DECLARE 
	@srcCustomerID INT,
	@destCustomerID INT
	
SET @srcCustomerID=5958
SET @destCustomerID=12296

BEGIN TRAN
--DELETE dbo.UsersSecurityGroup WHERE SecurityGroupID IN (SELECT SecurityGroupID FROM dbo.SecurityGroup WHERE CustomerID=@destCustomerID)
--DELETE dbo.SecurityGroup WHERE CustomerID=@destCustomerID

UPDATE dbo.SecurityGroup SET SecurityGroupName='[new] ' + SecurityGroupName WHERE CustomerID=@destCustomerID AND NOT SecurityGroupName LIKE '%new%'

INSERT INTO dbo.SecurityGroup
        ( CustomerID ,
          SecurityGroupName ,
          SecurityGroupDescription ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          ViewInServiceManager ,
          ViewInKareo
        )
select   @destCustomerID , -- CustomerID - int
          SecurityGroupName , -- SecurityGroupName - varchar(32)
          SecurityGroupDescription , -- SecurityGroupDescription - varchar(500)
          GETDATE() , -- CreatedDate - datetime
          390 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          390 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          ViewInServiceManager , -- ViewInServiceManager - bit
          ViewInKareo  -- ViewInKareo - bit
FROM dbo.SecurityGroup WHERE CustomerID=@srcCustomerID


INSERT INTO dbo.UsersSecurityGroup
        ( UserID ,
          SecurityGroupID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp
        )
select SSG.UserID , -- UserID - int
         -- TargSG.SecurityGroupID , -- SecurityGroupID - int
          GETDATE() , -- CreatedDate - datetime
          390 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          390 , -- ModifiedUserID - int
          NULL  -- RecordTimeStamp - timestamp
FROM dbo.UsersSecurityGroup SSG
	JOIN dbo.SecurityGroup SrcSG ON SrcSG.SecurityGroupID=SSG.SecurityGroupID
	--JOIN dbo.SecurityGroup TargSG ON TargSG.CustomerID=23489 AND TargSG.SecurityGroupName=SrcSG.SecurityGroupName
	JOIN [PDW-C07-DB052].[superbill_12388_prod].[dbo].[UserPractices] UP ON SSG.UserID = UP.UserID AND UP.PracticeID = 5
WHERE SSG.SecurityGroupID IN (SELECT SecurityGroupID FROM dbo.SecurityGroup WHERE CustomerID=12388)


-- SECURITY GROUP PERMISSIONS
INSERT INTO dbo.SecurityGroupPermissions
        ( SecurityGroupID ,
          PermissionID ,
          Allowed ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          Denied
        )
SELECT --TargSG.SecurityGroupID , -- SecurityGroupID - int
          SGP.PermissionID , -- PermissionID - int
          SGP.Allowed , -- Allowed - bit
          GETDATE() , -- CreatedDate - datetime
          390 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          390 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          SGP.Denied  -- Denied - bit
FROM dbo.SecurityGroupPermissions SGP
	JOIN dbo.SecurityGroup SrcSG ON SrcSG.SecurityGroupID=SGP.SecurityGroupID
	--JOIN dbo.SecurityGroup TargSG ON TargSG.CustomerID= AND TargSG.SecurityGroupName=SrcSG.SecurityGroupName
	JOIN [PDW-C07-DB052].[superbill_12388_prod].[dbo].[UserPractices] UP ON SGP.UserID = UP.UserID AND UP.PracticeID = 5
WHERE SGP.SecurityGroupID IN (SELECT SecurityGroupID FROM dbo.SecurityGroup WHERE CustomerID=12388)

--DELETE dbo.CustomerUsers WHERE CustomerID=@destCustomerID AND UserID<>41924

INSERT INTO dbo.CustomerUsers
        ( CustomerID, UserID, UserRoleID )
select   @destCustomerID, -- CustomerID - int
          CU.UserID, -- UserID - int
          CASE CU.UserRoleID WHEN 5201 THEN 18227 WHEN 5202 THEN 18228 ELSE NULL END  -- UserRoleID - int
FROM dbo.CustomerUsers CU
	JOIN dbo.Users U ON CU.UserID=U.UserID AND U.EmailAddress LIKE '%@sturgishospital.com' AND U.UserID NOT IN (519, 23135, 51949)
WHERE CU.CustomerID=@srcCustomerID


PRINT 'Validation:'

PRINT 'SecurityGroup:'
SELECT * FROM dbo.SecurityGroup WHERE CustomerID=@srcCustomerID
SELECT * FROM dbo.SecurityGroup WHERE CustomerID=@destCustomerID

PRINT 'UsersSecurityGroup:'
SELECT DISTINCT UserID, SecurityGroupID FROM dbo.UsersSecurityGroup WHERE SecurityGroupID IN (SELECT SecurityGroupID FROM dbo.SecurityGroup WHERE CustomerID=@srcCustomerID) ORDER BY UserID, SecurityGroupID
SELECT DISTINCT UserID, SecurityGroupID FROM dbo.UsersSecurityGroup WHERE SecurityGroupID IN (SELECT SecurityGroupID FROM dbo.SecurityGroup WHERE CustomerID=@destCustomerID) ORDER BY UserID, SecurityGroupID

PRINT 'SecurityGroupPermissions:'
SELECT * FROM dbo.SecurityGroupPermissions WHERE SecurityGroupID IN (SELECT SecurityGroupID FROM dbo.SecurityGroup WHERE CustomerID=@srcCustomerID) ORDER BY SecurityGroupID
SELECT * FROM dbo.SecurityGroupPermissions WHERE SecurityGroupID IN (SELECT SecurityGroupID FROM dbo.SecurityGroup WHERE CustomerID=@destCustomerID) ORDER BY SecurityGroupID

PRINT 'CustomerUsers:'
SELECT * FROM dbo.CustomerUsers CU
	JOIN dbo.Users U ON U.UserID=CU.UserID AND EmailAddress LIKE '%@sturgishospital.com'
WHERE CustomerID=@srcCustomerID

SELECT * FROM dbo.CustomerUsers CU
	JOIN dbo.Users U ON U.UserID=CU.UserID AND EmailAddress LIKE '%@sturgishospital.com'
WHERE CustomerID=@destCustomerID

--COMMIT TRAN
--ROLLBACK TRAN