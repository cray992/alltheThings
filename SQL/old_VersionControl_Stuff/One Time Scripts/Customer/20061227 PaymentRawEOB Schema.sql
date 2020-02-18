CREATE TABLE PaymentRawEOB(PaymentRawEOBID INT IDENTITY(1,1), PracticeID INT, ClearinghouseResponseID INT, 
ParseType CHAR(1), EncounterID INT, ClaimID INT, RawEOBXML XML CONSTRAINT PK_PaymentRawEOB PRIMARY KEY NONCLUSTERED (PaymentRawEOBID))
GO

CREATE UNIQUE CLUSTERED INDEX CI_PaymentRawEOB
ON PaymentRawEOB(PracticeID, ClearinghouseResponseID, EncounterID, ClaimID, ParseType)

GO

ALTER TABLE PaymentEncounter ADD PaymentRawEOBID INT

GO

ALTER TABLE PaymentClaim ADD PaymentRawEOBID INT

GO