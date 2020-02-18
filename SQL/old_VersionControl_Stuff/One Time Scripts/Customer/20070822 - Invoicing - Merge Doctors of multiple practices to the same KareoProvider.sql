USE [Superbill_Shared]
Go


-- Merge Craig M. Chanin 
UPDATE kd
SET [KareoProviderID] = 125
FROM [KareoProviderToDoctor] kd
WHERE customerID = 108
AND doctorID IN ( 129)



-- Merge David Johnson
Update [KareoProviderToDoctor]
SET [KareoProviderID] = 131
WHERE customerID = 108
AND doctorID IN (2312)



--  MERGE alexander A Axelrod
Update [KareoProviderToDoctor]
SET [KareoProviderID] = 72
WHERE customerID = 1
AND doctorID IN (252)



--  MERGE Elean Polukin
Update [KareoProviderToDoctor]
SET [KareoProviderID] = 69
WHERE customerID = 1
AND doctorID IN (171)


-- MERGE Jacob L. Mirma
Update [KareoProviderToDoctor]
SET [KareoProviderID] = 71
WHERE customerID = 1
AND doctorID IN (173)


-- MERGE Lois Brisco
Update [KareoProviderToDoctor]
SET [KareoProviderID] = 70
WHERE customerID = 1
AND doctorID IN (175)

