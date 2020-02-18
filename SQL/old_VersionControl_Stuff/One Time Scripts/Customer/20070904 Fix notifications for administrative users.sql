select 
	NotificationOptionTypeID = case when PermissionGroupID = 13  then 1
		WHEN PermissionGroupID = 9 THEN 2
		END,
	PermissionGroupID, count(*) as PermissionCount 
INTO #SecGroup
from Permissions p WHERE p.PermissionGroupID in (13, 9) AND p.ViewInKareo = 1 group by PermissionGroupID

--select * from #SecGroup


-- PermissionGroupID  9=Managing the Billing Process, 13= Administrator
select usg.UserID, p.PermissionGroupID, NotificationOptionTypeID
into #Admins
from SecurityGroupPermissions sgp
	INNER JOIN Permissions p ON p.PermissionID = sgp.PermissionID
	INNER JOIN UsersSecurityGroup usg on usg.SecurityGroupID= sgp.SecurityGroupID
	INNER JOIN #SecGroup sg on sg.PermissionGroupID = p.PermissionGroupID
	INNER JOIN Users U ON U.UserID = usg.UserID
	INNER JOIN CustomerUsers CU ON CU.UserID = U.UserID
	INNER JOIN Customer C ON C.CustomerID = CU.CustomerID
WHERE p.PermissionGroupID in (13) --, 9)
AND U.AccountLocked = 0
group by usg.UserID, p.PermissionGroupID, PermissionCount, NotificationOptionTypeID, C.AccountLocked, C.DBActive
having sum( cast(Allowed as int) )  >= PermissionCount AND C.AccountLocked = 0 AND C.DBActive = 1
order by usg.UserID

select EmailAddress, usg.UserID, p.PermissionGroupID, NotificationOptionTypeID
from SecurityGroupPermissions sgp
	INNER JOIN Permissions p ON p.PermissionID = sgp.PermissionID
	INNER JOIN UsersSecurityGroup usg on usg.SecurityGroupID= sgp.SecurityGroupID
	INNER JOIN #SecGroup sg on sg.PermissionGroupID = p.PermissionGroupID
	INNER JOIN Users U ON U.UserID = usg.UserID
	INNER JOIN CustomerUsers CU ON CU.UserID = U.UserID
	INNER JOIN Customer C ON C.CustomerID = CU.CustomerID
WHERE p.PermissionGroupID in (13)--, 9)
AND U.AccountLocked = 0
group by usg.UserID, p.PermissionGroupID, PermissionCount, NotificationOptionTypeID, u.EmailAddress, C.AccountLocked, C.DBActive
having sum( cast(Allowed as int) )  >= PermissionCount AND C.AccountLocked = 0 AND C.DBActive = 1
order by EmailAddress --usg.UserID

BEGIN TRAN

UPDATE
	UserNotification
SET
	Checked = 1
--SELECT * 
FROM
	UserNotification UN
	INNER JOIN #Admins A ON A.UserID = UN.UserID AND UN.NotificationOptionTypeID = 1

COMMIT

drop table #Admins, #SecGroup
GO
