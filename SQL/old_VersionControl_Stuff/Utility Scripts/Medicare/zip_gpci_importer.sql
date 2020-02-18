DECLARE @BATCH_DATE DATETIME

SET @BATCH_DATE = '2013/1/1'

DECLARE @BATCH_ID INT

CREATE TABLE [dbo].[tmp_ZIP_GPCI]
(
	[ZipCode] VARCHAR(5) NOT NULL,
	[Carrier] INT NOT NULL, 
	[Locality] INT NOT NULL
)

BULK INSERT
	[dbo].[tmp_ZIP_GPCI]
FROM
	'C:\FilesForBulkInsert\_ZIP5_JAN13_formatted.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)

INSERT INTO [dbo].[MedicareFeeScheduleZipGPCILinkBatch]
(
	[EffectiveStart]
)
VALUES
(
	@BATCH_DATE
)

SET @BATCH_ID = SCOPE_IDENTITY()

INSERT INTO [dbo].[MedicareFeeScheduleZipGPCILink]
(
	[MedicareFeeScheduleZipGPCILinkBatchID],
	[ZipCode],
	[Carrier],
	[Locality]
)
SELECT
	@BATCH_ID,
	[ZIP].[ZipCode],
	[ZIP].[Carrier],
	[ZIP].[Locality]
FROM
	[dbo].[tmp_ZIP_GPCI] [ZIP]

-- insert into medicare batch table
-- insert into medicare RVU table

DROP TABLE [dbo].[tmp_ZIP_GPCI]