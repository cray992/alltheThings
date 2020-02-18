
-- Create contracts

--BEGIN TRANSACTION

INSERT INTO ProcedureModifier(ProcedureModifierCode, ModifierName)
VALUES('53', 'Unknown Modifier')

INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode, Active)
VALUES ('G0101', 'Cervical or vaginal cancer screening; pelvic and clinical breast exam', '1', 1)

INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode, Active)
VALUES ('G0102', 'Prostate cancer screening; digital rectal examination', '1', 1)

INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode, Active)
VALUES ('G0104', 'Colorectal cancer screening, flexible sigmoidoscopy', '2', 1)


INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode, Active)
VALUES ('G0105', 'Colorectal cancer screening; colonoscopy of individual at high risk', '2', 1)

INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode, Active)
VALUES ('G0341', 'Hospice evaluation and counseling services, pre-election infusion', '2', 1)

INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode, Active)
VALUES ('G0344', 'Init preventive physical exam; visit, service limited to new beneficiary of Medicare enrollment', '1', 1)

INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode, Active)
VALUES ('G0364', 'Bone marrow aspiration performed with bone marrow biopsy through the same incision on the same date', '2', 1)

INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode, Active)
VALUES ('M0064', 'Office visit for monitoring or changing Rx treating mental psychoneurotic and personality disorders', '1', 1)

INSERT INTO ProcedureCodeDictionary(ProcedureCode, ProcedureName, TypeOfServiceCode, Active)
VALUES ('Q0091', 'Screening Papanicolaou smear; obtaining, preparing and conveyance of cervical or vaginal smear', '1', 1)



-- Medicare Fee Schedule for practiceID = 2 (Sanchez)

DECLARE @CONTRACTID INT
DECLARE @PRACTICEID INT

SET @PRACTICEID = 2

INSERT INTO CONTRACT(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, NoResponseTriggerPaper, NoResponseTriggerElectronic) 
VALUES(@PRACTICEID, 'Medicare Outpatient Fee Schedule','S', '1-6-2006', '1-6-2007', 45, 45)

SET @CONTRACTID = @@IDENTITY




-- Import fees

INSERT INTO ContractFeeSchedule (ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
SELECT @CONTRACTID, Modifier, 'B' Gender, ROUND(CAST(Fee as money), 2) StandardFee, 
ROUND(CAST(Fee as money), 2) Allowable, 0 ExpectedReimbursement, 0 RVU, ProcedureCodeDictionaryID
from cf_sanchez$ cf
inner join procedurecodedictionary pcd on cf.procedurecode = pcd.procedurecode
WHERE CID IN (0,1)


INSERT INTO CONTRACT(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, NoResponseTriggerPaper, NoResponseTriggerElectronic) 
VALUES(@PRACTICEID, 'Medicare Inpatient Fee Schedule','S', '1-6-2006', '1-6-2007', 45, 45)

SET @CONTRACTID = @@IDENTITY




-- Import fees

INSERT INTO ContractFeeSchedule (ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
SELECT @CONTRACTID, Modifier, 'B' Gender, ROUND(CAST(Fee as money), 2) StandardFee, 
ROUND(CAST(Fee as money), 2) Allowable, 0 ExpectedReimbursement, 0 RVU, ProcedureCodeDictionaryID
from cf_sanchez$ cf
inner join procedurecodedictionary pcd on cf.procedurecode = pcd.procedurecode
WHERE CID IN (0,2)



-- Medicare Fee Schedule for practiceID = 4 (Frontline)

SET @PRACTICEID = 4

INSERT INTO CONTRACT(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, NoResponseTriggerPaper, NoResponseTriggerElectronic) 
VALUES(@PRACTICEID, 'Medicare Outpatient Fee Schedule','S', '1-6-2006', '1-6-2007', 45, 45)

SET @CONTRACTID = @@IDENTITY


-- Import fees

INSERT INTO ContractFeeSchedule (ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
SELECT @CONTRACTID, Modifier, 'B' Gender, ROUND(CAST(Fee as money), 2) StandardFee, 
ROUND(CAST(Fee as money), 2) Allowable, 0 ExpectedReimbursement, 0 RVU, ProcedureCodeDictionaryID
from cf_frontline$ cf
inner join procedurecodedictionary pcd on cf.procedurecode = pcd.procedurecode
WHERE CID IN (0,1)


INSERT INTO CONTRACT(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, NoResponseTriggerPaper, NoResponseTriggerElectronic) 
VALUES(@PRACTICEID, 'Medicare Inpatient Fee Schedule','S', '1-6-2006', '1-6-2007', 45, 45)

SET @CONTRACTID = @@IDENTITY


-- Import fees

INSERT INTO ContractFeeSchedule (ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
SELECT @CONTRACTID, Modifier, 'B' Gender, ROUND(CAST(Fee as money), 2) StandardFee, 
ROUND(CAST(Fee as money), 2) Allowable, 0 ExpectedReimbursement, 0 RVU, ProcedureCodeDictionaryID
from cf_frontline$ cf
inner join procedurecodedictionary pcd on cf.procedurecode = pcd.procedurecode
WHERE CID IN (0,2)


-- Workers' Compensation Fee Schedule for practiceID = 3 (Phillips)

SET @PRACTICEID = 3

INSERT INTO CONTRACT(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, NoResponseTriggerPaper, NoResponseTriggerElectronic) 
VALUES(@PRACTICEID, 'Workers Compensation Outpatient Fee Schedule','S', '1-6-2006', '1-6-2007', 45, 45)

SET @CONTRACTID = @@IDENTITY


-- Import fees

INSERT INTO ContractFeeSchedule (ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
select  @CONTRACTID, Modifier, 'B' Gender, ROUND(CAST(Fee as money), 2) StandardFee, 
ROUND(CAST(Fee as money), 2) Allowable, 0, 0, ProcedureCodeDictionaryID
from cf_phillips$ cf
inner join procedurecodedictionary pcd on CASE WHEN LEN(cf.procedurecode) < 5 THEN REPLICATE('0', 5 - LEN(cf.procedurecode)) + cf.procedurecode
ELSE cf.procedurecode END = pcd.procedurecode
WHERE CID IN (0,1)

INSERT INTO CONTRACT(PracticeID, ContractName, ContractType, EffectiveStartDate, EffectiveEndDate, NoResponseTriggerPaper, NoResponseTriggerElectronic) 
VALUES(@PRACTICEID, 'Workers Compensation Inpatient Fee Schedule','S', '1-6-2006', '1-6-2007', 45, 45)

SET @CONTRACTID = @@IDENTITY


-- Import fees

INSERT INTO ContractFeeSchedule (ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
select  @CONTRACTID, Modifier, 'B' Gender, ROUND(CAST(Fee as money), 2) StandardFee, 
ROUND(CAST(Fee as money), 2) Allowable, 0, 0, ProcedureCodeDictionaryID
from cf_phillips$ cf
inner join procedurecodedictionary pcd on CASE WHEN LEN(cf.procedurecode) < 5 THEN REPLICATE('0', 5 - LEN(cf.procedurecode)) + cf.procedurecode
ELSE cf.procedurecode END = pcd.procedurecode
WHERE CID IN (0,2)


--ROLLBACK
-- COMMIT