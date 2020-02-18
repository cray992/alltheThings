DELETE dbo.PointOfOriginCode
WHERE Code = '7' OR Code = 'B' OR Code = 'C'

UPDATE dbo.PointOfOriginCode
SET [Name] = 'Clinic or Physician’s Office'
WHERE Code = '2'

