DECLARE @BATCH_DATE DATETIME
DECLARE @BATCH_BUDGET_NEUTRALITY_ADJUSTOR FLOAT
DECLARE @BATCH_CONVERSION_FACTOR FLOAT

SET @BATCH_DATE = '2013/1/1'
SET @BATCH_BUDGET_NEUTRALITY_ADJUSTOR = 1.0
SET @BATCH_CONVERSION_FACTOR = 34.0230

DECLARE @BATCH_ID INT

CREATE TABLE [dbo].[tmp_RVU]
(
	[HCPCS] VARCHAR(5),
	[MOD] VARCHAR(2),
	[WorkRVU] FLOAT,
	[FacilityPracticeExpenseRVU] FLOAT,
	[NonFacilityPracticeExpenseRVU] FLOAT,
	[MalpracticeExpenseRVU] FLOAT
)

BULK INSERT
	[dbo].[tmp_RVU]
FROM
	'C:\FilesForBulkInsert\_PPRRVU13_formatted.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)

INSERT INTO [dbo].[MedicareFeeScheduleRVUBatch]
(
	[ConversionFactor],
	[BudgetNeutralityAdjustor],
	[EffectiveStart]
)
VALUES
(
	@BATCH_CONVERSION_FACTOR,
	@BATCH_BUDGET_NEUTRALITY_ADJUSTOR,
	@BATCH_DATE
)

SET @BATCH_ID = SCOPE_IDENTITY()

INSERT INTO [dbo].[MedicareFeeScheduleRVU]
(
	[MedicareFeeScheduleRVUBatchID],
	[ProcedureCode],
	[Modifier],
	[WorkRVU],
	[FacilityPracticeExpenseRVU],
	[NonFacilityPracticeExpenseRVU],
	[MalpracticeExpenseRVU]
)
SELECT
	@BATCH_ID,
	[RVU].[HCPCS],
	[RVU].[MOD],
	[RVU].[WorkRVU],
	[RVU].[FacilityPracticeExpenseRVU],
	[RVU].[NonFacilityPracticeExpenseRVU],
	[RVU].[MalpracticeExpenseRVU]
FROM
	[dbo].[tmp_RVU] [RVU]
WHERE
	[RVU].[WorkRVU] <> 0.0 
	OR 
	[RVU].[FacilityPracticeExpenseRVU] <> 0.0 
	OR 
	[RVU].[NonFacilityPracticeExpenseRVU] <> 0.0
	OR
	[RVU].[MalpracticeExpenseRVU] <> 0.0

DROP TABLE [dbo].[tmp_RVU]