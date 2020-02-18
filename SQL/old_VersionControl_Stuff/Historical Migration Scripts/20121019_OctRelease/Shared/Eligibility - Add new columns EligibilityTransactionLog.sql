--EligibilityTransaction Log new columns

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'EligibilityTransactionLog' 
           AND  COLUMN_NAME = 'EligibilityTransportID')
BEGIN

	ALTER TABLE dbo.EligibilityTransactionLog
	ADD EligibilityTransportID INT NULL
   
END



IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'EligibilityTransactionLog' 
           AND  COLUMN_NAME = 'Fallback')
BEGIN

	ALTER TABLE dbo.EligibilityTransactionLog
	ADD Fallback INT NULL
   
END


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'EligibilityTransactionLog' 
           AND  COLUMN_NAME = 'DurationInMs')
BEGIN

	ALTER TABLE dbo.EligibilityTransactionLog
	ADD DurationInMs int NULL
   
END


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'EligibilityTransactionLog' 
           AND  COLUMN_NAME = 'RequestData')
BEGIN

	ALTER TABLE dbo.EligibilityTransactionLog
	ADD RequestData VARCHAR(MAX) NULL
END


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'EligibilityTransactionLog' 
           AND  COLUMN_NAME = 'ResponseData')
BEGIN

	ALTER TABLE dbo.EligibilityTransactionLog
	ADD ResponseData VARCHAR(MAX) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'EligibilityTransactionLog' 
           AND  COLUMN_NAME = 'ErrorTrace')
BEGIN

	ALTER TABLE dbo.EligibilityTransactionLog
	ADD ErrorTrace VARCHAR(MAX) NULL
END