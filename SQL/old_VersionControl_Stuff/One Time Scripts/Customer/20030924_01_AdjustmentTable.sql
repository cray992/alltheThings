--===========================================================================
-- ADD: ADJUSTMENT TABLE
--===========================================================================

IF NOT EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Adjustment'
	AND	TYPE = 'U'
)
BEGIN
	CREATE TABLE dbo.Adjustment (
		AdjustmentCode VARCHAR(10) NOT NULL,
		Description VARCHAR(250) NOT NULL,

		TIMESTAMP
	)

	ALTER TABLE dbo.Adjustment
	ADD CONSTRAINT PK_Adjustment
	PRIMARY KEY (AdjustmentCode)
END

--===========================================================================
-- POP: ADJUSTMENT TABLE
--===========================================================================

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '01'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('01', 'General Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '02'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('02', 'General Write Off')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '03'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('03', 'Medicare Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '04'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('04', 'Medicare Write Off')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '05'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('05', 'Collection Account Placement')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '06'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('06', 'HMO Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '07'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('07', 'Capitation Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '08'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('08', 'Small Balance Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '09'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('09', 'Medicaid Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '10'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('10', 'PPO Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '11'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('11', 'Bad Debt Write Off')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '12'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('12', 'Work Comp Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '13'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('13', 'BC/BS Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '14'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('14', 'Courtesy/Charity Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '15'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('15', 'Payment Correction')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '16'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('16', 'Refund Patient')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '17'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('17', 'Medicare B Interest')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '18'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('18', 'Debit Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '19'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('19', 'Credit Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '20'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('20', 'Tricare Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '21'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('21', 'Refund Medicare')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '22'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('22', 'Refund Insurance Company')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '23'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('23', 'Error Adjustment')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '24'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('24', 'Reverse Collection Write Off')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '25'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('25', 'Reverse Bad Debt Write Off')

IF NOT EXISTS (
	SELECT	*
	FROM	Adjustment
	WHERE	AdjustmentCode = '26'
)
	INSERT 	Adjustment (AdjustmentCode, Description)
	VALUES	('26', 'VA Adjustment')



