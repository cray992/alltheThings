
WHILE (SELECT  COUNT(SortOrder) FROM  GroupNumberType WHERE SortOrder = 0) > 0 
BEGIN
UPDATE    GroupNumberType
SET   SortOrder = (SELECT MAX(SortOrder) FROM  GroupNumberType) + 10 
WHERE GroupNumberTypeID = (SELECT TOP 1 GroupNumberTypeID FROM GroupNumberType WHERE SortOrder = 0)
END