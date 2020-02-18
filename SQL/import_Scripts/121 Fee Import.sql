



CREATE NONCLUSTERED INDEX IX_ProcedureCodeDictionary_ProcedureCode
ON ProcedureCodeDictionary (ProcedureCode)
GO

CREATE NONCLUSTERED INDEX IX_nf_FeeID
ON [new-fee-schedule] (FeeID)
GO

CREATE NONCLUSTERED INDEX IX_nf_PracticeID
ON [new-fee-schedule] (PracticeID)
GO

DECLARE @ContractID INT

INSERT INTO Contract(PracticeID, ContractName, Description, EffectiveStartDate, EffectiveEndDate, NoResponseTriggerPaper,
NoResponseTriggerElectronic)
VALUES(1,'Standard Fees Schedule','Standard Fees',GETDATE(),DATEADD(YY,2,GETDATE()), 45,45)

SET @ContractID = @@IDENTITY

DELETE [new-fee-schedule] WHERE PracticeID='02'

CREATE TABLE #Dups(FeeID VARCHAR(10), Items INT)
INSERT INTO #Dups(FeeID, Items)
SELECT FeeID, COUNT(FeeID)
FROM [new-fee-schedule]
GROUP BY FeeID
HAVING COUNT(FeeID)>1

UPDATE nf SET FeeAmount=0
FROM [new-fee-schedule] nf INNER JOIN #Dups d
on nf.FeeID=d.FeeID

DROP TABLE #Dups

CREATE TABLE #CF(ContractID INT, Gender CHAR(1), StandardFee MONEY, Allowable MONEY, ExpectedReimbursement MONEY, RVU INT, ProcedureCodeDictionaryID INT)

INSERT INTO #CF(ContractID, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
SELECT DISTINCT @ContractID, 'B', CAST(FeeAmount AS MONEY), 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM [new-fee-schedule] nf INNER JOIN ProcedureCodeDictionary PCD
ON nf.FeeID=PCD.ProcedureCode
WHERE PracticeID='00'

INSERT INTO #CF(ContractID, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
SELECT DISTINCT 1, 'B', CAST(FeeAmount AS MONEY), 0, 0, 0, PCD.ProcedureCodeDictionaryID
FROM [new-fee-schedule] nf INNER JOIN ProcedureCodeDictionary PCD
ON nf.FeeID=PCD.ProcedureCode
WHERE PracticeID='01'

INSERT INTO ContractFeeSchedule(ContractID, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
SELECT CF.ContractID, CF.Gender, CF.StandardFee, CF.Allowable, CF.ExpectedReimbursement, CF.RVU, CF.ProcedureCodeDictionaryID
FROM #CF CF LEFT JOIN ContractFeeSchedule CFS
ON CF.ContractID=CFS.ContractID AND CF.ProcedureCodeDictionaryID=CFS.ProcedureCodeDictionaryID
WHERE CFS.ProcedureCodeDictionaryID IS NULL

DROP TABLE #CF