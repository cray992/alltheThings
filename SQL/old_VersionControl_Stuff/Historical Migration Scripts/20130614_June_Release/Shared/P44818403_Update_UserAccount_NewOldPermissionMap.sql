BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

USE Superbill_Shared;
GO

IF NOT EXISTS ( SELECT  *
                FROM    dbo.UserAccount_NewOldPermissionMap AS UANOPM
                WHERE   NewPermissionID = ( SELECT TOP 1
                                                    UAP.PermissionID
                                            FROM    dbo.UserAccount_Permissions
                                                    AS UAP
                                            WHERE   UAP.PermissionValue = 'edit_Patient'
                                          )
                        AND OldPermissionID = ( SELECT TOP 1
                                                        P.PermissionID
                                                FROM    dbo.Permissions AS P
                                                WHERE   P.PermissionValue IN (
                                                        'EditCollectionCategory' )
                                              ) ) 
    BEGIN
        UPDATE  dbo.UserAccount_NewOldPermissionMap
        SET     NewPermissionID = ( SELECT TOP 1
                                            UAP.PermissionID
                                    FROM    dbo.UserAccount_Permissions AS UAP
                                    WHERE   UAP.PermissionValue = 'edit_Patient'
                                  )
        WHERE   OldPermissionID = ( SELECT TOP 1
                                            P.PermissionID
                                    FROM    dbo.Permissions AS P
                                    WHERE   P.PermissionValue IN (
                                            'EditCollectionCategory' )
                                  );
    END
	
IF NOT EXISTS ( SELECT  *
                FROM    dbo.UserAccount_NewOldPermissionMap AS UANOPM
                WHERE   NewPermissionID = ( SELECT TOP 1
                                                    UAP.PermissionID
                                            FROM    dbo.UserAccount_Permissions
                                                    AS UAP
                                            WHERE   UAP.PermissionValue = 'delete_Patient'
                                          )
                        AND OldPermissionID = ( SELECT TOP 1
                                                        P.PermissionID
                                                FROM    dbo.Permissions AS P
                                                WHERE   P.PermissionValue IN (
                                                        'DeleteCollectionCategory' )
                                              ) ) 
    BEGIN
        UPDATE  dbo.UserAccount_NewOldPermissionMap
        SET     NewPermissionID = ( SELECT TOP 1
                                            UAP.PermissionID
                                    FROM    dbo.UserAccount_Permissions AS UAP
                                    WHERE   UAP.PermissionValue = 'delete_Patient'
                                  )
        WHERE   OldPermissionID = ( SELECT TOP 1
                                            P.PermissionID
                                    FROM    dbo.Permissions AS P
                                    WHERE   P.PermissionValue IN (
                                            'DeleteCollectionCategory' )
                                  );
    END

/*
SELECT  UANOPM.* ,
        UAP.PermissionValue AS NewPermissionValue ,
        P.PermissionValue AS OldPermissionValue
FROM    dbo.UserAccount_NewOldPermissionMap AS UANOPM
        INNER JOIN dbo.UserAccount_Permissions AS UAP ON UANOPM.NewPermissionID = UAP.PermissionID
        INNER JOIN dbo.Permissions AS P ON UANOPM.OldPermissionID = P.PermissionID
WHERE   UANOPM.OldPermissionID IN (
        SELECT  P.PermissionID
        FROM    dbo.Permissions AS P
        WHERE   P.PermissionValue IN ( 'NewCollectionCategory',
                                       'DeleteCollectionCategory',
                                       'EditCollectionCategory',
                                       'ReadCollectionCategory',
                                       'FindCollectionCategory' ) );
*/
