-- Insert data into ProcedureCodeDictionary, Contract, ContractFeeSchedule
-- Chuck B.
-- 11/6/06

DECLARE @ScopeID INT
DECLARE @PracticeID INT

-- INSERT missing values into ProcedureCodeDictionary that are in imported data
INSERT INTO ProcedureCodeDictionary
(ProcedureCode, OfficialName)
SELECT     dbo.Imp_15352_20061106_ContractFeeSchedule.HCPCS AS ProcedureCode, 
           dbo.Imp_15352_20061106_ContractFeeSchedule.Description AS OfficalName
FROM dbo.Imp_15352_20061106_ContractFeeSchedule 
LEFT OUTER JOIN  dbo.ProcedureCodeDictionary 
ON dbo.Imp_15352_20061106_ContractFeeSchedule.HCPCS = dbo.ProcedureCodeDictionary.ProcedureCode
WHERE     (dbo.ProcedureCodeDictionary.ProcedureCode IS NULL)

SELECT @PracticeID = PracticeID
FROM dbo.Practice
WHERE (Name = 'Williamsburg O & P')

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
SELECT DISTINCT @ScopeID AS ContractID, 
dbo.ProcedureCodeDictionary.ProcedureCodeDictionaryID, 
ROUND(CONVERT(money, dbo.Imp_15352_20061106_ContractFeeSchedule.[VI*1 15]), 2) AS StandardFee, 
dbo.Imp_15352_20061106_ContractFeeSchedule.Mod AS Modifier,       
'B' AS Gender, 
0 AS RVU
FROM dbo.ProcedureCodeDictionary 
INNER JOIN dbo.Imp_15352_20061106_ContractFeeSchedule 
ON dbo.ProcedureCodeDictionary.ProcedureCode = dbo.Imp_15352_20061106_ContractFeeSchedule.HCPCS
