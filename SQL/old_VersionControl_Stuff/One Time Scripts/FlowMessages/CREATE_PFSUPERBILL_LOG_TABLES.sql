-- ---
-- Request log
IF NOT EXISTS
(
	SELECT 1 
	FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_TYPE='BASE TABLE' 
	AND TABLE_NAME='PFSuperbillRequestLog'
)
BEGIN
	CREATE TABLE PFSuperbillRequestLog
	(
		[Id] int IDENTITY(1,1) PRIMARY KEY,
		[SuperbillGuid] UNIQUEIDENTIFIER NULL,
		[RequestDate] DATETIME NOT NULL,
		[Uri] VARCHAR(256) NOT NULL,
		[CustomerId] INT NULL,
		[PracticeId] INT NULL,
		[EncounterId] INT NULL,
		[ProcessedDate] DATETIME NULL,
		[SuperbillData] VARCHAR(max)
	)
END

-- ---
-- Error log
IF NOT EXISTS
(
	SELECT 1 
	FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_TYPE='BASE TABLE' 
	AND TABLE_NAME='PFSuperbillErrorLog'
)
BEGIN
	CREATE TABLE PFSuperbillErrorLog
	(
		[Id] int IDENTITY(1,1) PRIMARY KEY,
		[SuperbillGuid] UNIQUEIDENTIFIER NOT NULL,
		[Error] VARCHAR(max),
		[ErrorDate] DATETIME NOT NULL
	)
END

-- ---
-- Event log
IF NOT EXISTS
(
	SELECT 1 
	FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_TYPE='BASE TABLE' 
	AND TABLE_NAME='PFSuperbillEventLog'
)
BEGIN
	CREATE TABLE PFSuperbillEventLog
	(
		[Id] INT IDENTITY(1,1) PRIMARY KEY,
		[SuperbillGuid] UNIQUEIDENTIFIER NOT NULL,
		[EventType] VARCHAR(32) NOT NULL,
		[EventMessage] VARCHAR(max) NOT NULL,		
		[EventDate] DATETIME NOT NULL,
		[Error] VARCHAR(MAX) NULL
	)
END

