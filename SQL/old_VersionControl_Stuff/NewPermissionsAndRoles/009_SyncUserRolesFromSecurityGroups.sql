USE Superbill_Shared

insert into [Superbill_Shared].[dbo].[UserAccount_UserRoles] (UserID, RoleID)
select usr.UserID, rtsgm.RoleID
from [Superbill_Shared].[dbo].[Users] as usr JOIN [Superbill_Shared].[dbo].[UsersSecurityGroup] as usg ON usr.UserID = usg.UserID 
JOIN [Superbill_Shared].[dbo].[UserAccount_RoleToSecurityGroupMap] as rtsgm ON usg.SecurityGroupID = rtsgm.SecurityGroupID
order by rtsgm.SecurityGroupID asc