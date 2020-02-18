/*
Update edition types to new style
*/
UPDATE	EditionType SET SortOrder = 1 WHERE EditionTypeID = 3
UPDATE	EditionType SET EditionTypeName = 'Plus', SortOrder = 2 WHERE EditionTypeID = 2
UPDATE	EditionType SET EditionTypeName = 'Complete', SortOrder = 3 WHERE EditionTypeID = 1

IF NOT EXISTS(SELECT * FROM EditionType WHERE EditionTypeID = 7)
BEGIN
	INSERT	EditionType (EditionTypeName, SortOrder, Active, EditionTypeID)
	VALUES	('Max', 4, 1, 7)
END