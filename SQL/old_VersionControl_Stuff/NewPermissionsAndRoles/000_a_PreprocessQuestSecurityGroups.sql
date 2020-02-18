/*****************************************/
/*Create Table UserAccount_PermissionType*/
/*****************************************/

USE [Superbill_Shared]
GO

--Copy templates from current security group templates but prepend 'Care360'
INSERT INTO [SecurityGroup]
      ([CustomerID],
      [SecurityGroupName],
      [SecurityGroupDescription],
      [CreatedDate],
      [CreatedUserID],
      [ModifiedDate],
      [ModifiedUserID],
      [ViewInServiceManager],
      [ViewInKareo])
      SELECT 
            [CustomerID], 
            'Care360 ' + [SecurityGroupName],
            [SecurityGroupDescription],
            [CreatedDate],
            [CreatedUserID],
            [ModifiedDate],
            [ModifiedUserID],
            [ViewInServiceManager],
            [ViewInKareo]
      FROM [SecurityGroup]
      WHERE [CustomerID] IS NULL and [ViewInServiceManager] = 0 and [ViewInKareo] = 0;

--Copy all permissions from the old security groups into the new ones
INSERT INTO SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed, Denied, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID)   
SELECT NSG.SecurityGroupID, SGP.PermissionID, Allowed, Denied, GetDate(), 0, GetDate(), 0
FROM SecurityGroupPermissions SGP 
      JOIN SecurityGroup SG ON SG.CustomerID IS NULL AND ViewInServiceManager=0 AND ViewInKareo=0 AND SG.SecurityGroupID=SGP.SecurityGroupID
      JOIN SecurityGroup NSG ON ('Care360 ' + SG.SecurityGroupName) = NSG.SecurityGroupName AND NSG.CustomerID IS NULL;

      
--Delete all permissions that are denied to group 21334 (Quest User).
DELETE FROM SecurityGroupPermissions
WHERE [PermissionID] 
      IN (
            SELECT sgp.[PermissionID] 
                  FROM [SecurityGroupPermissions] sgp
                  where sgp.SecurityGroupID = 21334 AND sgp.Denied=1)
      AND [SecurityGroupID]
      IN (
            SELECT SecurityGroupID
                  FROM SecurityGroup sg
                  WHERE sg.CustomerID IS NULL AND sg.ViewInKareo = 0 AND sg.ViewInServiceManager = 0 AND sg.SecurityGroupName LIKE 'Care360%')
