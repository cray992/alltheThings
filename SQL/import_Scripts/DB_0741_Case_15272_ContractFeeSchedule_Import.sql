-- Insert data into ProcedureCodeDictionary, Contract, ContractFeeSchedule
-- Chuck B.
-- 11/6/06

DECLARE @ScopeID INT
DECLARE @PracticeID INT


-- INSERT missing values into ProcedureCodeDictionary that are in imported data
INSERT INTO ProcedureCodeDictionary
(ProcedureCode, OfficialName)
SELECT DISTINCT 
CONVERT(varchar(16), dbo.Imp_741_FeeSchedule_15272.[Column 9]) AS ProcedureCode, 
CONVERT(varchar(300), dbo.Imp_741_FeeSchedule_15272.[Column 10]) AS OfficialName
FROM dbo.Imp_741_FeeSchedule_15272 
LEFT OUTER JOIN dbo.ProcedureCodeDictionary 
ON dbo.Imp_741_FeeSchedule_15272.[Column 9] = dbo.ProcedureCodeDictionary.ProcedureCode
WHERE (dbo.ProcedureCodeDictionary.ProcedureCode IS NULL)


SELECT @PracticeID = PracticeID
FROM dbo.Practice
WHERE (Name = 'Test Flatirons2')

--Create new record in Contract Table
INSERT INTO dbo.[Contract]
(PracticeID, ContractName, Description, ContractType, NoResponseTriggerPaper, NoResponseTriggerElectronic,
EffectiveStartDate, EffectiveEndDate)
VALUES(@PracticeID, 'Standard', 'Standard Imported', 'S', 45, 45, '11/1/2006', '10/31/2007')

SET @ScopeID = SCOPE_IDENTITY()

--Insert data into ContractFeeSchedule
INSERT INTO ContractFeeSchedule
(ContractID, 
ProcedureCodeDictionaryID, 
StandardFee, 
Modifier, 
Gender, 
RVU)
SELECT DISTINCT 
@ScopeID AS ContractID, 
dbo.ProcedureCodeDictionary.ProcedureCodeDictionaryID,
Imp_741_Fee.StandardFee,
NULL AS Modifier, 
'B' AS Gender, 
0 AS RVU 
FROM (SELECT 0 AS PracticeID, CONVERT(varchar(16), [Column 9]) AS ProcedureCode, 
CONVERT(varchar(300), [Column 10]) AS OfficialName, ROUND(CONVERT(money, [Column 13]), 2) AS StandardFee 
FROM dbo.Imp_741_FeeSchedule_15272) AS Imp_741_Fee 
INNER JOIN dbo.ProcedureCodeDictionary 
ON Imp_741_Fee.ProcedureCode = dbo.ProcedureCodeDictionary.ProcedureCode

--INNER JOIN
--  (SELECT     ContractID, PracticeID
--    FROM          dbo.Contract
--    WHERE      (CreatedDate > DATEADD(s, - 500, GETDATE()))) AS Contract_Derived 
--ON dbo.Imp_741_Fee_File.PracticeID = Contract_Derived.PracticeID