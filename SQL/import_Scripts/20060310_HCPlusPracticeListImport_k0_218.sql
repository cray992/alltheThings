select * from HCPlusImport_PracticeList
select * from practice

BEGIN TRANSACTION

INSERT INTO Practice (Name, AddressLine1, AddressLine2, City, State, ZipCode)
 SELECT Name, AddressLine1, AddressLine2, City, State, ZipCode
FROM HCPlusImport_PracticeList

-- ROLLBACK
-- COMMIT