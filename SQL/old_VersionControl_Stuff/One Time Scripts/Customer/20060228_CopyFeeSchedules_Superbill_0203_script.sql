		
		
-- USE superbill_0203_prod
-- Copy Contract, ContractFeeSchedule and ContractToServiceLocation from Practice 1 to Practice 2

--BEGIN TRANSACTION

CREATE TABLE #C (
	ContractID int,
	PracticeID int,
	ContractName varchar(128),
	Description text,
	ContractType char (1),
	EffectiveStartDate datetime,
	EffectiveEndDate datetime,
	PolicyValidator varchar (64),
	NoResponseTriggerPaper int,
	NoResponseTriggerElectronic int,
	Notes text
	) 

INSERT INTO #C (
	ContractID,
	PracticeID,
	ContractName,
	Description,
	ContractType,
	EffectiveStartDate,
	EffectiveEndDate,
	PolicyValidator,
	NoResponseTriggerPaper,
	NoResponseTriggerElectronic,
	Notes
	)
	SELECT 	ContractID,
		PracticeID,
		ContractName,
		Description,
		ContractType,
		EffectiveStartDate,
		EffectiveEndDate,
		PolicyValidator,
		NoResponseTriggerPaper,
		NoResponseTriggerElectronic,
		Notes 
	FROM Contract 
	WHERE PracticeID = 1

INSERT INTO Contract(
	PracticeID,
	ContractName,
	Description,
	ContractType,
	EffectiveStartDate,
	EffectiveEndDate,
	PolicyValidator,
	NoResponseTriggerPaper,
	NoResponseTriggerElectronic,
	Notes)
	SELECT 	
	2, 			-- PracticeID = 2,
	ContractName,
	Description,
	ContractType,
	EffectiveStartDate,
	EffectiveEndDate,
	PolicyValidator,
	NoResponseTriggerPaper,
	NoResponseTriggerElectronic,
	Notes 
	FROM #C
	ORDER BY ContractID

-- SELECT * FROM Contract 

-- GET generated id's of practice 2 contracts corresponding to contract 1 and contract 2 in practice 1

DECLARE @CONTRACT1_2 INT
DECLARE @CONTRACT2_2 INT

SELECT @CONTRACT1_2 = ContractID FROM Contract WHERE ContractName = 'Hospital  fee schedule' AND PracticeID = 2	-- Contract 1 in practice 1
SELECT @CONTRACT2_2 = ContractID FROM Contract WHERE ContractName = 'Office fee schedule' AND PracticeID = 2	-- Contract 2 in practice 2 
Print @contract1_2
print @contract2_2
CREATE TABLE #CFS(
	ContractFeeScheduleID int,
	ContractID int,
	Modifier varchar(16),
	Gender char(1),
	StandardFee money,
	Allowable money,
	ExpectedReimbursement money,
	RVU decimal,
	ProcedureCodeDictionaryID int
	)
	
INSERT INTO #CFS(
	ContractFeeScheduleID,
	ContractID,
	Modifier,
	Gender,
	StandardFee,
	Allowable,
	ExpectedReimbursement,
	RVU,
	ProcedureCodeDictionaryID)
	SELECT
		ContractFeeScheduleID,
		CASE WHEN ContractID = 1 THEN @CONTRACT1_2 ELSE @CONTRACT2_2 END,
		Modifier,
		Gender,
		StandardFee,
		Allowable,
		ExpectedReimbursement,
		RVU,
		ProcedureCodeDictionaryID
	FROM ContractFeeSchedule
	WHERE ContractID IN (1, 2)
	ORDER BY ContractFeeScheduleID

-- SELECT * FROM #CFS

INSERT INTO ContractFeeSchedule(
	ContractID,
	Modifier,
	Gender,
	StandardFee,
	Allowable,
	ExpectedReimbursement,
	RVU,
	ProcedureCodeDictionaryID)
	SELECT
		ContractID,
		Modifier,
		Gender,
		StandardFee,
		Allowable,
		ExpectedReimbursement,
		RVU,
		ProcedureCodeDictionaryID
	FROM #CFS
	ORDER BY ContractFeeScheduleID

-- SELECT * FROM ContractFeeSchedule		
		
-- ContractToServiceLocation

CREATE TABLE #CTSL(
	ContractToServiceLocationID int,
	ContractID int,
	ServiceLocationID int
)


INSERT INTO #CTSL(
	ContractToServiceLocationID,
	ContractID, 
	ServiceLocationID
	)
	SELECT
		ContractToServiceLocationID,
		CASE WHEN ContractID = 1 THEN @CONTRACT1_2 ELSE @CONTRACT2_2 END, -- Map contract id's
		ServiceLocationID
	FROM ContractToServiceLocation
	WHERE ContractID IN (1, 2)
	ORDER BY ContractToServiceLocationID

INSERT INTO ContractToServiceLocation(
	ContractID,
	ServiceLocationID)
	SELECT ContractID, ServiceLocationID FROM #CTSL
	ORDER BY ContractToServiceLocationID 

-- SELECT * FROM ContractToServiceLocation

DROP TABLE #C
DROP TABLE #CFS
DROP TABLE #CTSL

-- ROLLBACK
-- COMMIT
		
