-- SF 83362, 83691, 83980 - Reassign fax number for practices moved to different customers

begin tran

-- Insert the DNIS we are about to reassign to the history table
INSERT INTO FaxDNISHistory (DateDeleted, DNIS, CustomerID, PracticeID)
SELECT getdate(), DNIS, CustomerID, PracticeID
FROM FaxDNISCustomerPractice
WHERE DNIS in ('9499556294', '9498622810', '9498622936', '9499557035')

-- Reassign the DNIS to the new customer
UPDATE FaxDNISCustomerPractice
SET CustomerID = 1993, PracticeID=1, CreatedDate=getdate()
WHERE DNIS = '9499556294'

UPDATE FaxDNISCustomerPractice
SET CustomerID = 1998, PracticeID=1, CreatedDate=getdate()
WHERE DNIS = '9498622810'

UPDATE FaxDNISCustomerPractice
SET CustomerID = 2154, PracticeID=30, CreatedDate=getdate()
WHERE DNIS = '9498622936'

UPDATE FaxDNISCustomerPractice
SET CustomerID = 2173, PracticeID=22, CreatedDate=getdate()
WHERE DNIS = '9499557035'

-- Associate the k-fax account with the new customer
INSERT INTO CustomerUsers (CustomerID, UserID)
SELECT CustomerID, 1526 as UserID
FROM Customer
WHERE CustomerID IN (1998, 2154, 1993, 2173)

commit tran