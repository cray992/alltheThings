/*
Case 22278 - Add table for Notification Option Types and a way to associate the option types to a user
*/

CREATE TABLE dbo.NotificationOptionType(
	NotificationOptionTypeID int IDENTITY(1,1) NOT NULL,
	Description varchar(256) NULL,
	SortOrder int NULL, 
 CONSTRAINT PK_NotificationOptionType PRIMARY KEY(NotificationOptionTypeID ASC)
)

INSERT INTO NotificationOptionType 
(Description, SortOrder)
VALUES ('Company administrator notifications', 1)

INSERT INTO NotificationOptionType 
(Description, SortOrder)
VALUES ('Clearinghouse notifications', 2)

INSERT INTO NotificationOptionType 
(Description, SortOrder)
VALUES ('General notifications', 3)
GO



CREATE TABLE [dbo].[UserNotification](
	[UserNotificationID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[NotificationOptionTypeID] [int] NOT NULL,
	[Checked] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_UserNotification_CreatedDate]  DEFAULT (getdate()),
	[CreatedUserID] [int] NOT NULL CONSTRAINT [DF_UserNotification_CreatedUserID]  DEFAULT ((0)),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_UserNotification_ModifiedDate]  DEFAULT (getdate()),
	[ModifiedUserID] [int] NOT NULL CONSTRAINT [DF_UserNotification_ModifiedUserID]  DEFAULT ((0)),
 CONSTRAINT [PK_UserNotification] PRIMARY KEY NONCLUSTERED 
(
	[UserNotificationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[UserNotification]  WITH CHECK ADD  CONSTRAINT [FK_UserNotification_NotificationOptionType] FOREIGN KEY([NotificationOptionTypeID])
REFERENCES [dbo].[NotificationOptionType] ([NotificationOptionTypeID])
GO
ALTER TABLE [dbo].[UserNotification] CHECK CONSTRAINT [FK_UserNotification_NotificationOptionType]
GO
ALTER TABLE [dbo].[UserNotification]  WITH CHECK ADD  CONSTRAINT [FK_UserNotification_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[UserNotification] CHECK CONSTRAINT [FK_UserNotification_Users]
GO

CREATE UNIQUE CLUSTERED INDEX [CI_UserNotification_UserIDNotificationOptionTypeID] ON [dbo].[UserNotification] 
(
	[UserID] ASC,
	[NotificationOptionTypeID] ASC
) ON [PRIMARY]
GO



select 
	NotificationOptionTypeID = case when PermissionGroupID = 13  then 1
		WHEN PermissionGroupID = 9 THEN 2
		END,
	PermissionGroupID, count(*) as PermissionCount 
INTO #SecGroup
from Permissions p WHERE p.PermissionGroupID in (13, 9) group by PermissionGroupID


-- PermissionGroupID  9=Managing the Billing Process, 13= Administrator
select UserID, p.PermissionGroupID, NotificationOptionTypeID
into #Admins
from SecurityGroupPermissions sgp
	INNER JOIN Permissions p ON p.PermissionID = sgp.PermissionID
	INNER JOIN UsersSecurityGroup usg on usg.SecurityGroupID= sgp.SecurityGroupID
	INNER JOIN #SecGroup sg on sg.PermissionGroupID = p.PermissionGroupID
WHERE p.PermissionGroupID in (13, 9)
group by UserID, p.PermissionGroupID, PermissionCount, NotificationOptionTypeID
having sum( cast(Allowed as int) )  = PermissionCount
order by UserID

-- administrator should get whatever billing process gets.
insert into #admins( UserID, PermissionGroupID, NotificationOptionTypeID)
select a1.UserID, 9, 2
from #Admins a1
	INNER JOIN #Admins a2 on a2.UserID = a1.UserID AND a2.PermissionGroupID = 9
where a1.PermissionGroupID = 13
	AND a2.UserID IS NULL
	
	

INSERT INTO [UserNotification]
           ([UserID]
           ,[NotificationOptionTypeID]
           ,[Checked]
			)
select u.UserID, nt.NotificationOptionTypeID, 
	case when nt.NotificationOptionTypeID = 3 THEN 1
		WHEN exists( select * from #admins a where u.UserID = a.UserID AND a.NotificationOptionTypeID = nt.NotificationOptionTypeID) THEN 1
		ELSE 0 END
from Users u
	CROSS JOIN NotificationOptionType nt
	LEFT JOIN [UserNotification] un on un.UserID = u.UserID AND nt.[NotificationOptionTypeID] = un.[NotificationOptionTypeID]
WHERE un.UserID IS NULL


drop table #Admins, #SecGroup
GO