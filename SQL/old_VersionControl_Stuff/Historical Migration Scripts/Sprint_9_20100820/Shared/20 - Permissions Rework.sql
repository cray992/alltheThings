-- create new permission groups
insert into PermissionGroup (Name, [Description]) values ('Clearinghouse Reports', 'Accessing, viewing, and printing claim processing reports, ERAs, and patient statement reports.')
insert into PermissionGroup (Name, [Description]) values ('Encounters & Claims', 'Entering encounters, creating claims, submitting claims and entering claim transactions.')
insert into PermissionGroup (Name, [Description]) values ('Other Company Settings',	'Managing other settings such as attorneys, employers, payer scenarios, collection categories and more.')
insert into PermissionGroup (Name, [Description]) values ('Patient Statements',	'Preparing and submitting patient statements for printing and mailing, and configuring statement options.')
insert into PermissionGroup (Name, [Description]) values ('Payments & Refunds',	'Posting payments and payment transactions, and issuing refunds.')
insert into PermissionGroup (Name, [Description]) values ('Practice Settings', 'Managing practice settings such as providers, referring physicians, service locations, contracts and more.')
insert into PermissionGroup (Name, [Description]) values ('Web Services API', 'Accessing Kareo data through the add-in for Microsoft Excel or the web services API.')

-- renaming existing permission groups
update PermissionGroup set [Name]='Accounting Options'				where PermissionGroupID=19
update PermissionGroup set [Name]='Appointments'					where PermissionGroupID=7
update PermissionGroup set [Name]='Clearinghouse'					where PermissionGroupID=17
update PermissionGroup set [Name]='Codes'							where PermissionGroupID=15
update PermissionGroup set [Name]='Customers'						where PermissionGroupID=16
update PermissionGroup set [Name]='Insurance Companies & Plans'		where PermissionGroupID=14
update PermissionGroup set [Name]='Internal Systems'				where PermissionGroupID=24
update PermissionGroup set [Name]='Patients'						where PermissionGroupID=6
update PermissionGroup set [Name]='Practices'						where PermissionGroupID=12
update PermissionGroup set [Name]='Products'						where PermissionGroupID=25
update PermissionGroup set [Name]='Reports'							where PermissionGroupID=10
update PermissionGroup set [Name]='Tasks'							where PermissionGroupID=27
update PermissionGroup set [Name]='Users & Security'				where PermissionGroupID=13
update PermissionGroup set [Name]='Documents'						where PermissionGroupID=18


-- move permissions from one grop to another
update [Permissions] set PermissionGroupID=28 where PermissionID in (238, 520, 240, 239, 241)

update [Permissions] set PermissionGroupID=29 where PermissionID in (144, 152, 557, 223, 485, 143, 151, 400, 222, 544, 547, 217,
141, 150, 399, 219, 138, 147, 396, 220, 148, 397, 442, 406, 227, 142, 225, 221, 218, 140, 149, 398, 146, 139, 145, 224, 305)

update [Permissions] set PermissionGroupID=30 where PermissionID in (378, 490, 389, 443, 395, 377, 487, 387, 444, 393,
374, 489, 384, 445, 390, 375, 486, 385, 446, 391, 388, 394, 376, 488, 386, 447, 392)

update [Permissions] set PermissionGroupID=31 where PermissionID in (226, 215, 216)

update [Permissions] set PermissionGroupID=32 where PermissionID in (422, 232, 237, 421, 231, 236, 418, 228, 233, 419, 229, 234, 420, 230, 235)

update [Permissions] set PermissionGroupID=33 where PermissionID in (483, 352, 405, 214, 199, 194, 184, 511, 514,
209, 189, 480, 351, 402, 213, 198, 193, 302, 183, 498, 208, 187, 482, 354, 404, 210, 195, 190, 180, 205, 185, 479,
353, 403,211,196, 191,181,206,186,481,355,401,212,197,192,182,207,188,506)

update [Permissions] set PermissionGroupID=34 where PermissionID in (523, 521, 543, 529, 530, 556, 542, 526, 524, 522, 532, 531, 554, 525, 553, 528, 541)

update [Permissions] set Name='New Procedure Macro' where PermissionID=397
-- hide Electronic Payer Connection related permissions from Kareo application
update [Permissions] set ViewInKareo=0 where PermissionID in (308, 309, 310)


-- move Patient Referral Source related permissions to Practice Settings group
update [Permissions] set PermissionGroupID=33  where  name like '%referral source%'

-- hide Claim Settings Edit Permission from Kareo application
update [Permissions] set ViewInKareo=0 where PermissionID in (544, 547) 

-- delete duplicatied permissions
delete SecurityGroupPermissions 
where PermissionID=547 
and SecurityGroupID in (
select SecurityGroupID 
from SecurityGroupPermissions 
where PermissionID IN (547, 544) 
group by SecurityGroupID
having count(*) > 1)

update SecurityGroupPermissions set PermissionID=544 where PermissionID=547

delete [Permissions] where PermissionID=547

