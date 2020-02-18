
DECLARE @FeeSch TABLE(HCPCS VARCHAR(16), Description VARCHAR(128), Allowable MONEY, Expected MONEY, StandardFee MONEY)
INSERT @FeeSch(HCPCS, Description, Allowable, Expected, StandardFee)
SELECT HCPCS, Description, ROUND(ISNULL(Allowable,0),2) Allowable, ROUND(ISNULL(Allowable,0),2) Expected, ROUND(ISNULL(StandardFee,0),2) StandardFee
FROM MSDMEPOS_FeeSch

--DECLARE @ToInsert TABLE(HCPCS VARCHAR(16), Description VARCHAR(128))
--INSERT @ToInsert(HCPCS, Description)
--SELECT DISTINCT HCPCS, Description
--FROM @FeeSch F LEFT JOIN ProcedureCodeDictionary PCD
--oN F.HCPCS=PCD.ProcedureCode
--WHERE PCD.ProcedureCode IS NULL
--
--INSERT INTO ProcedureCodeDictionary(ProcedureCode, TypeOfServiceCode, OfficialName, LocalName, Active)
--SELECT HCPCS, 1, Description OfficialName, Description LocalName, 1
--FROM @ToInsert
--
--DECLARE @Dups TABLE(HCPCS VARCHAR(16), Items INT)
--INSERT @Dups(HCPCS, Items)
--SELECT HCPCS, COUNT(HCPCS) Items
--FROM @FeeSch
--GROUP BY HCPCS
--HAVING COUNT(HCPCS)>1
--
--DELETE F
--FROM @FeeSch F INNER JOIN @Dups D
--ON F.HCPCS=D.HCPCS
--
--DECLARE @ContractID INT
--
--INSERT INTO Contract(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate,
--NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated)
--VALUES(2, 'Standard', 'S', GETDATE(), DATEADD(YY,1,GETDATE()), 45, 45, 0)
--
--SET @ContractID=@@IDENTITY
--
--INSERT INTO ContractFeeSchedule(ContractID, Gender, StandardFee, Allowable, ExpectedReimbursement, ProcedureCodeDictionaryID)
--SELECT @ContractID, 'B', F.StandardFee, F.Allowable, F.Expected, PCD.ProcedureCodeDictionaryID
--FROM ProcedureCodeDictionary PCD INNER JOIN @FeeSch F
--ON PCD.ProcedureCode=F.HCPCS

--DECLARE @ToUpdate TABLE(Allowable MONEY, Expected MONEY, ProcedureCodeDictionaryID INT)
--INSERT @ToUpdate(Allowable, Expected, ProcedureCodeDictionaryID)
--SELECT F.Allowable, F.Expected, PCD.ProcedureCodeDictionaryID
--FROM ProcedureCodeDictionary PCD INNER JOIN @FeeSch F
--ON PCD.ProcedureCode=F.HCPCS
--
--UPDATE C SET Allowable=TU.Allowable, ExpectedReimbursement=TU.Expected
--FROM ContractFeeSchedule C INNER JOIN @ToUpdate TU
--ON C.ContractID=2 AND C.ProcedureCodeDictionaryID=TU.ProcedureCodeDictionaryID
