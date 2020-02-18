/* Rename existing Weekly related descriptions to include work week */
UPDATE dbo.Permissions 
SET Description = 'Display the workweek and weekly calendar of appointments.'
WHERE PermissionValue = 'ReadWeeklyCalendar'

/* Rename existing Weekly related descriptions to include work week in timeblock*/
UPDATE dbo.Permissions 
SET Description = 'Display the workweek and weekly calendar of timeblocks.'
WHERE PermissionValue = 'ReadWeeklyTimeblockCalendar'
