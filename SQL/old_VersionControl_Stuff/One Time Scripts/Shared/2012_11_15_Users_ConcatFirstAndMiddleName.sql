UPDATE 
      dbo.Users
SET 
      FirstName = FirstName + ' ' + MiddleName,
      MiddleName = '' --clear out the middle name
WHERE 
      MiddleName <> ''
