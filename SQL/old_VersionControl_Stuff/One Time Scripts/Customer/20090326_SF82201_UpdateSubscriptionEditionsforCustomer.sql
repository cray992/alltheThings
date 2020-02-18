-- SF 82201 - Update EditionTypes for Customer Model databases

-- Update text for existing editions, add new edition
if db_name() in( 'CustomerModel', 'CustomerModelPrepopulated', 'superbill_0108_dev')
begin
	UPDATE	EditionType SET SortOrder = 1 WHERE EditionTypeID = 3
	UPDATE	EditionType SET EditionTypeName = 'Plus', SortOrder = 2 WHERE EditionTypeID = 2
	UPDATE	EditionType SET EditionTypeName = 'Complete', SortOrder = 3 WHERE EditionTypeID = 1

	INSERT	EditionType (EditionTypeName, SortOrder, Active, EditionTypeID)
	VALUES	('Max', 4, 1, 7)
end

