
-- ---
-- Replace the 'Clinic' entry with 'Clinic or Physician's Office'
UPDATE [dbo].[PointOfOriginCode]
SET
	Name = 'Clinic or Physician''s Office'
WHERE
	Code = '2'