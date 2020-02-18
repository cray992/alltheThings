-- Insert data into ProcedureCodeDictionary, Contract, ContractFeeSchedule
-- Chuck B.
-- 11/1/06

-- INSERT missing values into ProcedureCodeDictionary that are in imported data
create table #ProceduresToInsert (ProcedureCode varchar(100) null)

insert into #ProceduresToInsert (ProcedureCode) select distinct ProcedureCode from Fees1212 where ProcedureCode not in (select ProcedureCode from ProcedureCodeDictionary)

--select * from #proceduresToInsert order by procedureCode

insert into ProcedureCodeDictionary (ProcedureCode, OfficialName) 
select pti.ProcedureCode, (select top 1 description from fees1212 where pti.ProcedureCode=fees1212.ProcedureCode)
from #proceduresToInsert pti

drop table #ProceduresToInsert

/*
-- INSERT missing values into ProcedureCodeDictionary that are in imported data
INSERT INTO ProcedureCodeDictionary
(ProcedureCode, OfficialName)
SELECT DISTINCT dbo.Fees1212.ProcedureCode, dbo.Fees1212.[description] AS OfficialName
FROM dbo.Fees1212 
--INNER JOIN dbo.IMPPracticeMapping 
--ON dbo.Fees1212.Practice = dbo.IMPPracticeMapping.OldPracticeID 
LEFT OUTER JOIN dbo.ProcedureCodeDictionary 
ON dbo.Fees1212.ProcedureCode = dbo.ProcedureCodeDictionary.ProcedureCode
WHERE (dbo.ProcedureCodeDictionary.ProcedureCode IS NULL)

*/

--select top 600 * from ProcedureCodeDictionary order by ProcedureCodeDictionaryID desc

--select distinct procedureCode from procedureCodeDictionary group by procedureCode having count(*)>1
--select * from ProcedureCodeDictionary where ProcedureCode='17101'
--SELECT @PracticeID = PracticeID
--FROM dbo.Practice
--WHERE (Name = 'Orthotic Services, LLC')

--Create new records in Contract Table
INSERT INTO dbo.[Contract]
(PracticeID, ContractName, Description, ContractType, NoResponseTriggerPaper, NoResponseTriggerElectronic,
EffectiveStartDate, EffectiveEndDate)
SELECT DISTINCT  dbo.IMPPracticeMapping.PracticeID, 'Standard' AS ContractName, 
'Imported 12/12. Please review.' AS Description, 'S' AS ContractType, 
45 AS NoResponseTriggerPaper, 45 AS NoResponseTriggerElectronic, 
'12/1/2006' AS EffectiveStartDate, '11/30/2008' AS EffectiveEndDate
FROM dbo.Fees1212 
INNER JOIN dbo.IMPPracticeMapping 
ON dbo.Fees1212.Practice = dbo.IMPPracticeMapping.OldPracticeID


--SET @ScopeID = SCOPE_IDENTITY()

--Insert data into ContractFeeSchedule
INSERT INTO ContractFeeSchedule
(ContractID, 
ProcedureCodeDictionaryID, 
StandardFee, 
Gender, 
RVU)
SELECT DISTINCT Contract_Derived.ContractID, 
dbo.ProcedureCodeDictionary.ProcedureCodeDictionaryID, 
--CONVERT(numeric(18, 2), dbo.Fees1212.StdFee)  AS StandardFee,
case IsNumeric(Fees1212.StdFee) when 1 then Round(cast(dbo.Fees1212.StdFee as money), 2) else 0 end,
'B',
0
FROM dbo.IMPPracticeMapping 
INNER JOIN dbo.Fees1212 
ON dbo.IMPPracticeMapping.OldPracticeID = dbo.Fees1212.Practice 
INNER JOIN (SELECT ContractID, PracticeID
             FROM dbo.Contract
             WHERE (CreatedDate > DATEADD(s, - 500, GETDATE()))) AS Contract_Derived 
ON dbo.IMPPracticeMapping.PracticeID = Contract_Derived.PracticeID 
INNER JOIN dbo.ProcedureCodeDictionary 
ON dbo.Fees1212.ProcedureCode = dbo.ProcedureCodeDictionary.ProcedureCode


select * from Contract order by ContractID desc
select * from impPracticeMapping
contractID=22 src practice=140

select * from practice where PracticeID=21
-- TEST
select ProcedureCode, StandardFee 
from ContractFeeSchedule, ProcedureCodeDictionary  
where ContractID=22 and ProcedureCodeDictionary.ProcedureCodeDictionaryID=ContractFeeSchedule.ProcedureCodeDictionaryID
order by procedurecode

select * from Fees1212 where Practice='140' order by ProcedureCode


select * from ProcedureCodeDictionary where ProcedureCode ='90010'

select * from Fees1212 where ProcedureCode not in (select ProcedureCode from procedureCodeDictionary)
