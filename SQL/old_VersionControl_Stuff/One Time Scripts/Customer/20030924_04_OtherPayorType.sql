--===========================================================================
-- ADD: OTHER TABLE
--===========================================================================

IF NOT EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Other'
	AND	TYPE = 'U')
BEGIN
	CREATE TABLE dbo.Other (
		OtherID INT IDENTITY(1,1) NOT NULL,
		OtherName VARCHAR(250) NOT NULL,

		TIMESTAMP
	)

	ALTER TABLE dbo.Other
	ADD CONSTRAINT PK_Other
	PRIMARY KEY (OtherID)
END

--===========================================================================
-- POP: OTHER PAYER TYPE
--===========================================================================

IF NOT EXISTS (
	SELECT	*
	FROM	PayerTypeCode
	WHERE	PayerTypeCode = 'O'
)
	INSERT	PayerTypeCode (PayerTypeCode, Description)
	VALUES	('O', 'Other')

