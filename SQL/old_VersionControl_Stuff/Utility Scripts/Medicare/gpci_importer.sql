DECLARE @BATCH_DATE DATETIME

SET @BATCH_DATE = '2013/1/1'

DECLARE @BATCH_ID INT

CREATE TABLE [dbo].[tmp_GPCI]
(
	[Contractor] INT NOT NULL, 
	[Locality] INT NOT NULL,
	[LocalityName] VARCHAR(128) NOT NULL,
	[WorkGPCI] FLOAT NOT NULL,
	[PracticeExpenseGPCI] FLOAT NOT NULL,
	[MalpracticeExpenseGPCI] FLOAT NOT NULL
)

BULK INSERT
	[dbo].[tmp_GPCI]
FROM
	'C:\FilesForBulkInsert\_GPCI2013_formatted.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)

INSERT INTO [dbo].[MedicareFeeScheduleGPCIBatch]
(
	[EffectiveStart]
)
VALUES
(
	@BATCH_DATE
)

SET @BATCH_ID = SCOPE_IDENTITY()

INSERT INTO [dbo].[MedicareFeeScheduleGPCI]
(
	[MedicareFeeScheduleGPCIBatchID],
	[Carrier],
	[Locality],
	[LocalityName],
	[WorkGPCI],
	[PracticeExpenseGPCI],
	[MalpracticeExpenseGPCI]
)
SELECT
	@BATCH_ID,
	[GPCI].[Contractor],
	[GPCI].[Locality],
	[GPCI].[LocalityName],
	[GPCI].[WorkGPCI],
	[GPCI].[PracticeExpenseGPCI],
	[GPCI].[MalpracticeExpenseGPCI]
FROM
	[dbo].[tmp_GPCI] [GPCI]

-- insert into medicare batch table
-- insert into medicare RVU table

DROP TABLE [dbo].[tmp_GPCI]