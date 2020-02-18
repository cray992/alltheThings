-- Insert data into ProcedureCodeDictionary, Contract, ContractFeeSchedule
-- Chuck B.
-- 11/1/06

DECLARE @ScopeID INT
DECLARE @PracticeID INT

-- INSERT missing values into ProcedureCodeDictionary that are in imported data
INSERT INTO ProcedureCodeDictionary
(ProcedureCode, OfficialName)
SELECT dbo.ContractFeeSchedule_Import.HCPCS AS ProcedureCode, dbo.ContractFeeSchedule_Import.Description AS OfficalName
FROM dbo.ContractFeeSchedule_Import 
LEFT OUTER JOIN dbo.ProcedureCodeDictionary 
ON dbo.ContractFeeSchedule_Import.HCPCS = dbo.ProcedureCodeDictionary.ProcedureCode
WHERE (dbo.ProcedureCodeDictionary.ProcedureCode IS NULL)

SELECT @PracticeID = PracticeID
FROM dbo.Practice
WHERE (Name = 'Orthotic Services, LLC')

--Create new record in Contract Table
INSERT INTO dbo.[Contract]
(PracticeID, ContractName, Description, ContractType, NoResponseTriggerPaper, NoResponseTriggerElectronic,
EffectiveStartDate, EffectiveEndDate)
VALUES(@PracticeID, 'Standard', 'Standard Imported', 'S', 45, 45, '11/1/2006', '10/31/2007')


SET @ScopeID = SCOPE_IDENTITY()

--Insert data into ContractFeeSchedule
INSERT INTO ContractFeeSchedule
(ContractID, ProcedureCodeDictionaryID, StandardFee, Modifier, Gender, RVU)
SELECT DISTINCT @ScopeID AS ContractID, 
dbo.ProcedureCodeDictionary.ProcedureCodeDictionaryID, 
CONVERT(numeric(18, 2), dbo.ContractFeeSchedule_Import.[Use this Column])  AS StandardFee, 
dbo.ContractFeeSchedule_Import.Mod AS Modifier,
'B',
0
FROM dbo.ContractFeeSchedule_Import 
INNER JOIN dbo.ProcedureCodeDictionary 
ON dbo.ContractFeeSchedule_Import.HCPCS = dbo.ProcedureCodeDictionary.ProcedureCode
