--===========================================================================
-- MOD: PRACTICE FEE TABLE SCHEMA
--===========================================================================

SELECT	*
INTO	TEMP_PracticeFee
FROM	PracticeFee

--===========================================================================

DROP TABLE dbo.PracticeFee

--===========================================================================

CREATE TABLE PracticeFee (
	PracticeFeeID INT IDENTITY(1,1) NOT NULL,
	PracticeFeeScheduleID INT NOT NULL,
	ProcedureCodeDictionaryID INT NOT NULL,
	ChargeAmount MONEY NOT NULL 
		DEFAULT (0),
	Editable BIT NOT NULL,
	EffectiveDate DATETIME NOT NULL 
		DEFAULT (GETDATE()),
	ExpirationDate DATETIME,

	CreatedDate DATETIME DEFAULT (GETDATE()),
	ModifiedDate DATETIME DEFAULT (GETDATE()),

	TIMESTAMP
)

ALTER TABLE dbo.PracticeFee
ADD CONSTRAINT PK_PracticeFee
PRIMARY KEY (PracticeFeeID)

ALTER TABLE dbo.PracticeFee
ADD CONSTRAINT FK_PracticeFee_PracticeFeeSchedule
FOREIGN KEY (PracticeFeeScheduleID)
REFERENCES PracticeFeeSchedule(PracticeFeeScheduleID)

ALTER TABLE dbo.PracticeFee
ADD CONSTRAINT FK_PracticeFee_ProcedureCodeDictionary
FOREIGN KEY (ProcedureCodeDictionaryID)
REFERENCES ProcedureCodeDictionary(ProcedureCodeDictionaryID)

ALTER TABLE dbo.PracticeFee
ADD CONSTRAINT DF_PracticeFee_Editable
DEFAULT (0) FOR Editable

--===========================================================================

INSERT	PracticeFee (
	PracticeFeeScheduleID,
	ProcedureCodeDictionaryID,
	ChargeAmount,
	Editable,
	EffectiveDate,
	ExpirationDate,
	CreatedDate,
	ModifiedDate
)
SELECT	PracticeFeeScheduleID,
	ProcedureCodeDictionaryID,
	ChargeAmount,
	0,
	EffectiveDate,
	ExpirationDate,
	CreatedDate,
	ModifiedDate
FROM	TEMP_PracticeFee

