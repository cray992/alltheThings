update Permissions
set description = 'Display and search a list of encounters.'
where permissionid = 138

update Permissions
set description = 'Remove kFax number from practice.'
where permissionid = 437

update Permissions
set description = 'Assign kFax number to practice.'
where permissionid = 436

update Permissions
set description = 'Request a patient eligibility report.'
where permissionid = 466

update Permissions
set description = 'Display a list of patient eligibility reports.'
where permissionid = 467

update Permissions
set description = 'Show the details of a patient eligibility report.'
where permissionid = 468

delete from SecurityGroupPermissions where permissionid = 388
delete from Permissions where permissionid = 388

delete from SecurityGroupPermissions where permissionid = 394
delete from Permissions where permissionid = 394