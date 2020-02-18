/*

DATABASE UPDATE SCRIPT

v1.30.xxxx to v1.31.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 6555 - Change Schema to Accomodate Accounting system dates 

ALTER TABLE Payment ADD PostingDate DATETIME NULL

GO

UPDATE Payment SET PostingDate=PaymentDate

GO

ALTER TABLE Payment ALTER COLUMN PostingDate DATETIME NOT NULL

GO

CREATE TABLE PracticeToClosingDate(PracticeToClosingDateID INT IDENTITY(1,1), PracticeID INT NOT NULL,
ClosingDate DATETIME NULL, LastAssignment BIT NOT NULL CONSTRAINT DF_PracticeToClosingDate_LastAssignment DEFAULT 1,
UserID INT NOT NULL, CreatedDate DATETIME NOT NULL CONSTRAINT DF_PracticeToClosingDate_CreatedDate DEFAULT GETDATE()
CONSTRAINT PK_PracticeID_PracticeToClosingDateID PRIMARY KEY CLUSTERED (PracticeID, PracticeToClosingDateID))

GO

--Update ClaimAccounting Schema to optimize use of PostingDate in Reports instead of PaymentDate
ALTER TABLE ClaimAccounting ADD PostingDate SMALLDATETIME NULL

GO

UPDATE ClaimAccounting SET PostingDate=PaymentDate

GO

DROP INDEX ClaimAccounting.IX_ClaimAccounting_PaymentDate

ALTER TABLE ClaimAccounting DROP COLUMN PaymentDate

GO

CREATE NONCLUSTERED INDEX IX_ClaimAccounting_PostingDate
ON ClaimAccounting (PostingDate)

GO

--Add Indexes to Payment for Payment and PostingDate
CREATE NONCLUSTERED INDEX IX_Payment_PaymentDate
ON Payment (PaymentDate)

CREATE NONCLUSTERED INDEX IX_Payment_PostingDate
ON Payment (PostingDate)

GO

DBCC DBREINDEX(Payment)
DBCC DBREINDEX(ClaimAccounting)

UPDATE STATISTICS Payment
UPDATE STATISTICS ClaimAccounting

GO

---------------------------------------------------------------------------------------
--case 0000 - code 09 is actually self-pay, while CI relates more precisely to commercial insurances

UPDATE InsuranceCompany
SET InsuranceProgramCode = 'CI'
WHERE     (InsuranceProgramCode = '09')
GO


--ClaimAccounting Trigger Insert had an error - This will properly set the Status flag to 1 for those claimtransactions that reflect a closed claim

UPDATE CA SET Status=1
from ClaimAccounting CA INNER JOIN Claim C ON CA.ClaimID=C.ClaimID
WHERE ClaimStatusCode='C' AND Status=0

UPDATE CAA SET Status=1
from ClaimAccounting_Assignments CAA INNER JOIN Claim C ON CAA.ClaimID=C.ClaimID
WHERE ClaimStatusCode='C' AND Status=0


UPDATE CAB SET Status=1
FROM ClaimAccounting_Billings CAB INNER JOIN Claim C ON CAB.ClaimID=C.ClaimID
WHERE ClaimStatusCode='C' AND Status=0

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
