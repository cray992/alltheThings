USE Superbill_Shared

INSERT INTO dbo.UserAccount_Roles
        ( CustomerID,
          Name,
          Description,
          CreatedDate,
          ModifiedDate,
          ViewInKareo,
		  OldSecurityGroupID
        )
SELECT SG.CustomerID, SG.SecurityGroupName, sg.SecurityGroupDescription, GETDATE(), GETDATE(), sg.ViewInKareo, SG.SecurityGroupID 
FROM dbo.SecurityGroup AS SG;

INSERT INTO dbo.UserAccount_RoleToSecurityGroupMap
        ( RoleID, SecurityGroupID )
SELECT uar.RoleID, uar.OldSecurityGroupID
FROM dbo.UserAccount_Roles AS UAR;

--ALTER TABLE dbo.UserAccount_Roles
--DROP COLUMN OldID;

INSERT INTO dbo.UserAccount_RolePermissions
        ( RoleID, PermissionID )
SELECT DISTINCT uar.RoleID, UANOPM.NewPermissionID 
FROM dbo.UserAccount_Roles AS UAR
INNER JOIN dbo.UserAccount_RoleToSecurityGroupMap AS UARTSGM ON UAR.RoleID = UARTSGM.RoleID
INNER JOIN dbo.SecurityGroupPermissions AS SGP ON UARTSGM.SecurityGroupID = SGP.SecurityGroupID
INNER JOIN dbo.UserAccount_NewOldPermissionMap AS UANOPM ON UANOPM.OldPermissionID = sgp.PermissionID
WHERE Allowed = 1