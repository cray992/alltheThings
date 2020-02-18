--===========================================================================
-- ADD: NEW BILL TABLES
--===========================================================================

IF NOT EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Bill_HCFA'
	AND	TYPE = 'U'
)
BEGIN
	CREATE TABLE dbo.Bill_HCFA (
		BillID INT IDENTITY(1,1) NOT NULL,
		BillBatchID INT NOT NULL,
		RepresentativeClaimID INT,
		PayerPatientInsuranceID INT,
		OtherPayerPatientInsuranceID INT,

		TIMESTAMP
	)

	ALTER TABLE dbo.Bill_HCFA
	ADD CONSTRAINT PK_BillHCFA
	PRIMARY KEY (BillID)

	ALTER TABLE dbo.Bill_HCFA
	ADD CONSTRAINT FK_BillHCFA_BillBatch
	FOREIGN KEY (BillBatchID)
	REFERENCES BillBatch(BillBatchID)
END

--===========================================================================

IF NOT EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Bill_EDI'
	AND	TYPE = 'U'
)
BEGIN
	CREATE TABLE dbo.Bill_EDI (
		BillID INT IDENTITY(1,1) NOT NULL,
		BillBatchID INT NOT NULL,
		RepresentativeClaimID INT,
		PayerPatientInsuranceID INT,
		PayerResponsibilityCode CHAR(1),

		TIMESTAMP
	)

	ALTER TABLE dbo.Bill_EDI
	ADD CONSTRAINT PK_BillEDI
	PRIMARY KEY (BillID)

	ALTER TABLE dbo.Bill_EDI
	ADD CONSTRAINT FK_BillEDI_BillBatch
	FOREIGN KEY (BillBatchID)
	REFERENCES BillBatch(BillBatchID)
END

--===========================================================================

IF NOT EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Bill_Statement'
	AND	TYPE = 'U'
)
BEGIN
	CREATE TABLE dbo.Bill_Statement (
		BillID INT IDENTITY(1,1) NOT NULL,
		BillBatchID INT NOT NULL,
		PatientID INT,

		TIMESTAMP
	)

	ALTER TABLE dbo.Bill_Statement
	ADD CONSTRAINT PK_BillStatement
	PRIMARY KEY (BillID)

	ALTER TABLE dbo.Bill_Statement
	ADD CONSTRAINT FK_BillStatement_BillBatch
	FOREIGN KEY (BillBatchID)
	REFERENCES BillBatch(BillBatchID)
END

--===========================================================================
-- MOD: BILL CLAIM TABLE
--===========================================================================

SELECT	BC.BillID,
	BB.BillBatchTypeCode,
	BC.ClaimID
INTO	TEMP_NewBillClaim
FROM	BillBatch BB
	INNER JOIN Bill B
	ON 	B.BillBatchID = BB.BillBatchID
	INNER JOIN BillClaim BC
	ON	BC.BillID = B.BillID
	
--===========================================================================

DROP TABLE dbo.BillClaim

--===========================================================================

CREATE TABLE dbo.BillClaim (
	BillID INT NOT NULL,
	BillBatchTypeCode CHAR(1) NOT NULL,
	ClaimID INT NOT NULL,

	TIMESTAMP
)

ALTER TABLE dbo.BillClaim
ADD CONSTRAINT PK_BillClaim
PRIMARY KEY (BillID, BillBatchTypeCode, ClaimID)

ALTER TABLE dbo.BillClaim
ADD CONSTRAINT FK_BillClaim_Claim
FOREIGN KEY (ClaimID)
REFERENCES Claim(ClaimID)

--===========================================================================

INSERT	BillClaim (BillID, BillBatchTypeCode, ClaimID)
SELECT	BillID, BillBatchTypeCode, ClaimID
FROM	TEMP_NewBillClaim

