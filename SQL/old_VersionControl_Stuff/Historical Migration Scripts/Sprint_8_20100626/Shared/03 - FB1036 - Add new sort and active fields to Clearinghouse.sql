-- FB 1036 - Add sort order and active flag to Clearinghouse drop down
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Clearinghouse' AND COLUMN_NAME = 'Active')
BEGIN
	ALTER TABLE dbo.Clearinghouse ADD SortOrder int null
	ALTER TABLE dbo.Clearinghouse ADD Active bit null
END
GO
	
UPDATE Clearinghouse SET SortOrder=1, Active=1 WHERE ClearinghouseID=1
UPDATE Clearinghouse SET SortOrder=2, Active=1 WHERE ClearinghouseID=3
UPDATE Clearinghouse SET SortOrder=3, Active=1 WHERE ClearinghouseID=2