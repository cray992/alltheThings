


select distinct sgp.SecurityGroupID
INTO #permNewPrace
from SecurityGroupPermissions sgp
inner join SecurityGroup sg ON sg.SecurityGroupID = sgp.SecurityGroupID 
INNER join Permissions newPrac ON newPrac.PermissionID = sgp.PermissionID 
where allowed=1 and denied=0
AND  ( newPrac.name =  'new Practice' )



select sgp.SecurityGroupID
INTO #permKax
from 
#permNewPrace np
INNER join SecurityGroupPermissions sgp on np.SecurityGroupID = sgp.SecurityGroupID
INNER join Permissions kfax ON kfax.PermissionID = sgp.PermissionID and ( kfax.name like '%kfax%' )

declare @modifiedDate datetime
set @modifiedDate = getdate()

INSERT INTO [Superbill_Shared].[dbo].[SecurityGroupPermissions]
           ([SecurityGroupID]
           ,[PermissionID]
           ,[Allowed]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[Denied])
select p.[SecurityGroupID], kfax.[PermissionID], 1, @modifiedDate, 0, @modifiedDate, 0, 0
from #permNewPrace p
LEFT JOIN #permKax k ON p.SecurityGroupID = k.SecurityGroupID
INNER JOIN SecurityGroup sg ON sg.SecurityGroupID = p.SecurityGroupID
INNER JOIN Customer c ON sg.CustomerID = c.CUstomerID
INNER join Permissions kfax ON ( kfax.name like '%kfax%' )
where k.SecurityGroupID is null



drop table #permKax
drop table #permNewPrace

