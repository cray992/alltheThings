--		
--select case when u.EmailAddress like '%@kareo.com' THEN 2		
--		WHEN u.EmailAddress like '%@deptb.com' THEN 1
--		when u.EmailAddress like '%@departmentb.com' THEN 1
--		ELSE 0
--		END,
--		u.EmailAddress, FirstName, LastName, 
--		[kprod-db08].superbill_0001_prod.dbo.fn_FormatPhone(WorkPhone) as workPhone, 
--		workPhoneExt,
--		[kprod-db08].superbill_0001_prod.dbo.fn_FormatPhone(AlternativePhone) as AlternativePhone,
--		AlternativePhoneExt,
--		p.Name, p.EmailAddress as PracticeEmailAddress
--from [kprod-db08].superbill_0001_prod.dbo.UserPractices up		
--	inner join superbill_shared.dbo.users u on u.UserID = up.UserID	
--	INNER JOIN [kprod-db08].superbill_0001_prod.dbo.Practice p ON up.PracticeID = p.PracticeID	
--where AccountLocked = 0		
--order by case when u.EmailAddress like '%@kareo.com' THEN 2		
--		WHEN u.EmailAddress like '%@deptb.com' THEN 1
--		when u.EmailAddress like '%@departmentb.com' THEN 1
--		ELSE 0
--		END,
--	u.EmailAddress,	
--	p.Name	
--
--
--


begin tran

begin try


-- Find Security Groups that have administrator's previlege set (Except for the 'System Administrator' group)
select sgp.* 
INTO #SecurityGroupPermissions
from SecurityGroup sg 
INNER JOIN SecurityGroupPermissions sgp ON sgp.SecurityGroupID = sg.SecurityGroupID
INNER JOIN Permissions p on p.PermissionID = sgp.PermissionID
INNER JOIN PermissionGroup pg ON pg.PermissionGroupID = p.PermissionGroupID
where sg.CustomerID = 1
AND pg.Name = 'Administering Security'
AND Denied <> 1
AND securityGroupName <> 'System Administrator'


-- Find Users who belong to the group "Security Administrator". All NON Kareo Users will be removed from this Group

select distinct usg.*
into #UsersSecurityGroup
from SecurityGroup sg 
INNER JOIN SecurityGroupPermissions sgp ON sgp.SecurityGroupID = sg.SecurityGroupID
INNER JOIN Permissions p on p.PermissionID = sgp.PermissionID
INNER JOIN PermissionGroup pg ON pg.PermissionGroupID = p.PermissionGroupID
INNER JOIN UsersSecurityGroup usg ON usg.SecurityGroupID = sg.SecurityGroupID
inner join users u on u.UserID = usg.UserID
where sg.CustomerID = 1
AND pg.Name = 'Administering Security'
AND securityGroupName = 'System Administrator'
AND u.emailAddress NOT IN (

	'shaun@kareo.com',
	'phong@kareo.com',
	'adren@kareo.com',
	'dan@kareo.com',
	'Fredrica@kareo.com',
	'jasonm@kareo.com',
	'joe@kareo.com',
	'lawrence@kareo.com',
	'mary@kareo.com',
	'rolland@kareo.com'
)


-- Save the User's Adminstrator's profile. This is to undo the changes at a later time
select * 
into superbill_0001_prod_UsersSecurityGroup_OrigSetting
from  #UsersSecurityGroup



select * 
into superbill_0001_prod_SecurityGroupPermissions_OrigSetting
from  #SecurityGroupPermissions





-- Disable Adminsitrator Priveliges for non-"System Administrator Group"
update sgp
SET Allowed = 0, Denied = 1
from SecurityGroupPermissions sgp
	INNER JOIN #SecurityGroupPermissions orig ON orig.SecurityGroupID = sgp.SecurityGroupID AND orig.PermissionID = sgp.PermissionID

-- Remove Users who are no longer part of the System Administrator's group
delete usg
from UsersSecurityGroup usg
	INNER JOIN #UsersSecurityGroup orig on orig.UserID = usg.UserID AND orig.SecurityGroupID = usg.SecurityGroupID





-- Find All Department B's & Users who has access to more then 50% of the practices. User to be locked out.

create table #Users ( UserID INT, eMailAddress varchar( max) )

insert into #Users
select UserID, emailAddress
from Users u
WHERE
	( u.EmailAddress like '%@dept.com'
	OR u.EmailAddress like '%@departmentb.com'
	OR u.EmailAddress like '%@pmandr.com'
	OR u.EmailAddress like '%@deptb.com'
	) 
	AND AccountLocked = 0



insert into #Users
select u.UserID,  u.EmailAddress
from [kprod-db08].superbill_0001_prod.dbo.UserPractices up		
	inner join superbill_shared.dbo.users u on u.UserID = up.UserID	
	INNER JOIN [kprod-db08].superbill_0001_prod.dbo.Practice p ON up.PracticeID = p.PracticeID	
	LEFT JOIN #Users orig on orig.UserID = u.UserID
where AccountLocked = 0	
	AND orig.UserID IS NULL
	AND NOT ( u.EmailAddress like '%@kareo.com%' )
GROUP BY u.UserID, u.EmailAddress
having count(Distinct p.PracticeID ) > 3
order by count(Distinct p.PracticeID )


-- Save the list of Department B users. This is to undo the changes at a later time
select * 
INTO superbill_0001_prod_Users_OrigSetting
from #Users





-- Lock out Department B's User.
Update U
SET AccountLocked = 1
FROM Users u
	INNER JOIN #Users orig ON u.UserID = orig.UserID





commit tran

end try

begin catch

				rollback tran

				DECLARE @ErrorMessage NVARCHAR(4000);
				DECLARE @ErrorSeverity INT;
				DECLARE @ErrorState INT;

				SELECT @ErrorMessage = ERROR_MESSAGE(),
					   @ErrorSeverity = ERROR_SEVERITY(),
					   @ErrorState = ERROR_STATE();

				-- Use RAISERROR inside the CATCH block to return 
				-- error information about the original error that 
				-- caused execution to jump to the CATCH block.
				RAISERROR (@ErrorMessage, -- Message text.
						   @ErrorSeverity, -- Severity.
						   @ErrorState -- State.
						   );

end catch


return

/*

drop table #UsersSecurityGroup
drop table #SecurityGroupPermissions
drop table #Users

drop table superbill_0001_prod_Users_OrigSetting
drop table superbill_0001_prod_UsersSecurityGroup_OrigSetting
drop table superbill_0001_prod_SecurityGroupPermissions_OrigSetting

*/

select * from superbill_0001_prod_Users_OrigSetting





