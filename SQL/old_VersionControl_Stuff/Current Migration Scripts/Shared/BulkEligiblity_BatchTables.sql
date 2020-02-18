IF EXISTS
(
	SELECT *
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'EligibilityBatch'
) 
BEGIN
	PRINT 'EligibilityBatch table already exists.  Skipping create...';
END
ELSE 
BEGIN
	CREATE TABLE EligibilityBatch
	(
		EligibilityBatchID INT NOT NULL IDENTITY(1,1),
		CustomerID INT NOT NULL,
		PracticeID INT NOT NULL,
		ServiceTypeCode VARCHAR(2) NOT NULL,
		CreateDate DATETIME NOT NULL,
		CompleteDate DATETIME NULL,
		CONSTRAINT PK_EligibilityBatch_EligibilityBatchID PRIMARY KEY CLUSTERED (EligibilityBatchID)
	);
	PRINT 'EligibilityBatch table created.';
END
GO


IF EXISTS
(
	SELECT *
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'EligibilityBatchItem'
)
BEGIN
	PRINT 'EligibilityBatchItem table already exists.  Skipping create...';
END
ELSE
BEGIN
	CREATE TABLE EligibilityBatchItem
	(
		EligibilityBatchItemID INT NOT NULL IDENTITY(1,1),
		EligibilityBatchID INT NOT NULL,
		DoctorID INT NOT NULL,
		InsurancePolicyID INT NOT NULL,
		EligibilityHistoryID INT NULL,
		CreateDate DATETIME NOT NULL,
		CompleteDate DATETIME NULL,
		ErrorMessage VARCHAR(MAX) NULL,
		CONSTRAINT PK_EligibilityBatchItem_EligibilityBatchItemID PRIMARY KEY CLUSTERED (EligibilityBatchItemID),
		CONSTRAINT FK_EligibilityBatch_EligibilityBatchID FOREIGN KEY (EligibilityBatchID) REFERENCES EligibilityBatch(EligibilityBatchID)
	);
	PRINT 'EligibilityBatchItem table created.';
END
GO
--DROP table eligibilitybatchitem
--drop table eligibilitybatch