-- CREATE TABLE #Dups(FeeID VARCHAR(10), PracticeID CHAR(2), Items INT)
-- INSERT INTO #Dups(FeeID, PracticeID, Items)
-- SELECT FeeID, PracticeID, COUNT(DISTINCT CAST(FeeAmount AS MONEY))
-- FROM [new-fee-schedule]
-- WHERE CAST(FeeAmount AS MONEY)<>0.00
-- GROUP BY FeeID, PracticeID
-- HAVING COUNT(DISTINCT CAST(FeeAmount AS MONEY))>1
-- 
-- UPDATE nf SET FeeAmount=0
-- FROM [new-fee-schedule] nf INNER JOIN #Dups d
-- on nf.FeeID=d.FeeID and nf.PracticeID = d.PracticeID
-- 
-- DROP TABLE #Dups

DECLARE @ContractID INT
SET @ContractID=2

CREATE TABLE #CF(ContractID INT, Gender CHAR(1), StandardFee MONEY, Allowable MONEY, ExpectedReimbursement MONEY, RVU INT, ProcedureCodeDictionaryID INT)

INSERT INTO #CF(ContractID, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
SELECT  @ContractID, 'B', SUM(DISTINCT CAST(FeeAmount AS MONEY)), 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM [new-fee-schedule] nf INNER JOIN ProcedureCodeDictionary PCD
ON nf.FeeID=PCD.ProcedureCode
WHERE PracticeID='00' 
GROUP BY PCD.ProcedureCodeDictionaryID


INSERT INTO #CF(ContractID, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
SELECT  1, 'B', SUM(DISTINCT CAST(FeeAmount AS MONEY)), 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM [new-fee-schedule] nf INNER JOIN ProcedureCodeDictionary PCD
ON nf.FeeID=PCD.ProcedureCode
WHERE PracticeID='01' 
GROUP BY PCD.ProcedureCodeDictionaryID

--INSERT INTO ContractFeeSchedule(ContractID, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
-- SELECT CF.ContractID, CF.Gender, CF.StandardFee, CF.Allowable, CF.ExpectedReimbursement, CF.RVU, CF.ProcedureCodeDictionaryID
-- FROM #CF CF LEFT JOIN ContractFeeSchedule CFS
-- ON CF.ContractID=CFS.ContractID AND CF.ProcedureCodeDictionaryID=CFS.ProcedureCodeDictionaryID
-- WHERE CFS.ProcedureCodeDictionaryID IS NULL

UPDATE CFS SET StandardFee=CF.StandardFee
--SELECT CFS.*, CF.StandardFee
FROM #CF CF LEFT JOIN ContractFeeSchedule CFS
ON CF.ContractID=CFS.ContractID AND CF.ProcedureCodeDictionaryID=CFS.ProcedureCodeDictionaryID
WHERE CF.StandardFee<>0
--ORDER BY CFS.ContractID, CFS.ProcedureCodeDictionaryID, CF.StandardFee
--WHERE CFS.ProcedureCodeDictionaryID IS NULL

DROP TABLE #CF