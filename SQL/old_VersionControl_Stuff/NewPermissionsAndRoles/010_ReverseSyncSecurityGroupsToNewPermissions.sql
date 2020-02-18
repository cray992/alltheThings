USE Superbill_Shared

DELETE FROM SecurityGroupPermissions 
WHERE Denied = 1 OR (Allowed = 0 AND Denied = 0)
GO

INSERT INTO SecurityGroupPermissions (SecurityGroupID, PermissionID, Allowed, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, Denied)
(SELECT  NewPermissions.SecurityGroupID,
        UANOPM.OldPermissionID, 1, current_timestamp, 0, current_timestamp, 0, 0
FROM    ( SELECT    SGP.SecurityGroupID,
                    UANOPM.NewPermissionID
          FROM      dbo.SecurityGroupPermissions AS SGP
                    INNER JOIN dbo.UserAccount_NewOldPermissionMap AS UANOPM ON SGP.PermissionID = UANOPM.OldPermissionID
          WHERE     SGP.Allowed = 1
          GROUP BY  sgp.SecurityGroupID,
                    UANOPM.NewPermissionID
        ) AS NewPermissions
        INNER JOIN dbo.UserAccount_NewOldPermissionMap AS UANOPM ON NewPermissions.NewPermissionID = UANOPM.NewPermissionID
        LEFT JOIN dbo.SecurityGroupPermissions AS SGP ON SGP.SecurityGroupID = NewPermissions.SecurityGroupID
                                                         AND UANOPM.OldPermissionID = SGP.PermissionID
WHERE   SGP.PermissionID IS NULL
group by NewPermissions.SecurityGroupID, UANOPM.OldPermissionID)

GO