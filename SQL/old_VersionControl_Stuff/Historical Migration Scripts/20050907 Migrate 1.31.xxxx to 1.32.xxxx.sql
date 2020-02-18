--Migrate ClaimTransaction
ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL
GO

ALTER TABLE ClaimTransaction ADD PostingDate DATETIME
GO

UPDATE ClaimTransaction SET PostingDate=ISNULL(ReferenceDate,TransactionDate)
GO

ALTER TABLE ClaimTransaction ALTER COLUMN PostingDate DATETIME NOT NULL

CREATE NONCLUSTERED INDEX IX_ClaimTransaction_Practice_PostingDate
ON ClaimTransaction (PracticeID, PostingDate)
GO

DROP INDEX ClaimTransaction.IX_ClaimTransaction_Provider_Practice_Date_Type_Amount

ALTER TABLE ClaimTransaction DROP COLUMN ReferenceDate, TransactionDate
GO

ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL
GO


--Migrate ClaimAccounting
UPDATE CA SET PostingDate=CAST(CONVERT(CHAR(10),CT.PostingDate,110) AS SMALLDATETIME)
FROM ClaimAccounting CA INNER JOIN ClaimTransaction CT
ON CA.ClaimTransactionID=CT.ClaimTransactionID
GO

DROP INDEX ClaimAccounting.IX_ClaimAccounting_PostingDate
GO

ALTER TABLE ClaimAccounting ALTER COLUMN PostingDate DATETIME NOT NULL
GO

DROP INDEX ClaimAccounting.CI_ClaimAccounting_PracticeID_TransactionDate_ClaimTransactionID
GO

ALTER TABLE ClaimAccounting DROP COLUMN TransactionDate
GO

CREATE CLUSTERED INDEX CI_ClaimAccounting_PracticeID_PostingDate_ClaimTransactionID
ON ClaimAccounting(PracticeID, PostingDate, ClaimTransactionID)
GO

--Migrate ClaimAccounting_Assignments
ALTER TABLE ClaimAccounting_Assignments ADD PostingDate DATETIME
GO

UPDATE ClaimAccounting_Assignments SET PostingDate=TransactionDate
GO

ALTER TABLE ClaimAccounting_Assignments ALTER COLUMN PostingDate DATETIME NOT NULL
GO

DROP INDEX ClaimAccounting_Assignments.CI_ClaimAccounting_Assignments_PracticeID_TransactionDate_ClaimTransactionID
GO

ALTER TABLE ClaimAccounting_Assignments DROP COLUMN TransactionDate
GO

CREATE CLUSTERED INDEX CI_ClaimAccounting_Assignments_PracticeID_PostingDate_ClaimTransactionID
ON ClaimAccounting_Assignments(PracticeID, PostingDate, ClaimTransactionID)
GO

--Migrate ClaimAccounting_Billings
ALTER TABLE ClaimAccounting_Billings ADD PostingDate DATETIME
GO

UPDATE ClaimAccounting_Billings SET PostingDate=TransactionDate
GO

ALTER TABLE ClaimAccounting_Billings ALTER COLUMN PostingDate DATETIME NOT NULL
GO

DROP INDEX ClaimAccounting_Billings.CI_ClaimAccounting_Billings_PracticeID_TransactionDate_ClaimTransactionID
GO

ALTER TABLE ClaimAccounting_Billings DROP COLUMN TransactionDate
GO

CREATE CLUSTERED INDEX CI_ClaimAccounting_Billings_PracticeID_PostingDate_ClaimTransactionID
ON ClaimAccounting_Billings(PracticeID, PostingDate, ClaimTransactionID)
GO


--Add PostingDate to Refund
ALTER TABLE Refund ADD PostingDate DATETIME
GO

UPDATE Refund SET PostingDate=RefundDate
GO

ALTER TABLE Refund ALTER COLUMN PostingDate DATETIME NOT NULL
GO

DECLARE @DFName VARCHAR(500)
SET @DFName=''

DECLARE @SQL VARCHAR(1000)
SET @SQL='ALTER TABLE Refund DROP CONSTRAINT {0}'

SELECT @DFName=name FROM sysobjects 
WHERE xtype='D' 
AND parent_obj=(SELECT id FROM sysobjects WHERE xtype='U' and name='Refund')
AND name LIKE 'DF__Refund__RefundD%'

SET @SQL = REPLACE(@SQL,'{0}',@DFName)

EXEC(@SQL)
GO

ALTER TABLE Refund ADD CONSTRAINT DF_Refund_PostingDate  DEFAULT GETDATE() FOR PostingDate
GO

ALTER TABLE Refund DROP COLUMN RefundDate
GO

--Add PostingDate to RefundToPayments
ALTER TABLE RefundToPayments ADD PostingDate DATETIME
GO

UPDATE RTP SET PostingDate=R.PostingDate
FROM RefundToPayments RTP INNER JOIN Refund R
ON R.RefundID=RTP.RefundID
GO

ALTER TABLE RefundToPayments ALTER COLUMN PostingDate DATETIME NOT NULL
GO

--=======
alter table dbo.practice add ProcedureModifiersNumber int not null default 1
go

---------------------------------------------------------------------------------------
--case 6736 - Remove the PaymentDate field from the Payment table

DROP INDEX Payment.IX_Payment_PaymentDate  
GO

DROP TRIGGER dbo.tr_IU_Payment_ChangeTime
GO

ALTER TABLE Payment DROP COLUMN PaymentDate
GO

--Truncate Time From PostingDate for ClaimTransaction, Payment, RefundDate
ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL

UPDATE ClaimTransaction SET PostingDate=CAST(CONVERT(CHAR(10),PostingDate,110) AS DATETIME)

ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL
GO

UPDATE Payment SET PostingDate=CAST(CONVERT(CHAR(10),PostingDate,110) AS DATETIME)

UPDATE Refund SET PostingDate=CAST(CONVERT(CHAR(10),PostingDate,110) AS DATETIME)

UPDATE RefundToPayments SET PostingDate=CAST(CONVERT(CHAR(10),PostingDate,110) AS DATETIME)
GO

--Split up END transactions with amounts into END and ADJ transactions
ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL
CREATE TABLE #EndsToAdj(ClaimTransactionID INT, ClaimTransactionTypeCode CHAR(3), ClaimID INT, Amount MONEY, Code VARCHAR(50),
		        Notes TEXT, CreatedDate DATETIME, ModifiedDate DATETIME, PatientID INT, PracticeID INT, BatchKey UNIQUEIDENTIFIER,
			Original_ClaimTransactionID INT, Claim_ProviderID INT, PostingDate DATETIME)
INSERT INTO #EndsToAdj(ClaimTransactionID, ClaimTransactionTypeCode,ClaimID,Amount, Code, Notes, CreatedDate, ModifiedDate, PatientID, PracticeID, BatchKey, Original_ClaimTransactionID, Claim_ProviderID, PostingDate)
SELECT ClaimTransactionID, 'ADJ' ClaimTransactionTypeCode, ClaimID,Amount, Code, Notes, CreatedDate, ModifiedDate, PatientID, PracticeID, BatchKey, Original_ClaimTransactionID, Claim_ProviderID, PostingDate 
FROM ClaimTransaction 
WHERE ClaimTransactionTypeCode='END' and Amount<>0

INSERT INTO ClaimTransaction(ClaimTransactionTypeCode,ClaimID,Amount, Code, Notes, CreatedDate, ModifiedDate, PatientID, PracticeID, BatchKey, Original_ClaimTransactionID, Claim_ProviderID, PostingDate)
SELECT ClaimTransactionTypeCode,ClaimID,Amount, Code, Notes, CreatedDate, ModifiedDate, PatientID, PracticeID, BatchKey, Original_ClaimTransactionID, Claim_ProviderID, PostingDate
FROM #EndsToAdj

UPDATE CT SET Amount=0, Code=NULL, Notes=NULL
FROM ClaimTransaction CT INNER JOIN #EndsToAdj ETA
ON CT.ClaimTransactionID=ETA.ClaimTransactionID

DROP TABLE #EndsToAdj

ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL
GO

---------------------------------------------------------------------------------------
--case 6287:  Add records for the Patient Financial History report

declare @ReportCategoryId int
declare @ReportId int

SELECT 	@ReportCategoryId = ReportCategoryID
FROM 	ReportCategory 
WHERE 	Name = 'Patients'

INSERT INTO Report (
	ReportCategoryID,
	DisplayOrder,
	Image,
	Name,
	Description,
	TaskName,
	ReportPath,
	ReportParameters,
	MenuName,
	PermissionValue)
VALUES (
	@ReportCategoryId,
	30,
	'[[image[Practice.ReportsV2.Images.reports.gif]]]',
	'Patient Financial History',
	'This report provides a financial history of the patient.',
	'Report V2 Viewer',
	'/BusinessManagerReports/rptPatientFinancialHistory',
	'<?xml version="1.0" encoding="utf-8"?>
<parameters defaultMessage="Please click on Customize and select a Patient for this report.">
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="CustomDateRange" fromDateParameter="StartingDate" toDateParameter="EndingDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="StartingDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndingDate" text="To:" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	</extendedParameters>
</parameters>',
	'Patient &Financial History',
	'ReadPatientFinancialHistory')

set @ReportId = @@identity

INSERT INTO ReportToSoftwareApplication
VALUES (
	@ReportID,
	'B')

INSERT INTO ReportToSoftwareApplication
VALUES (
	@ReportID,
	'M')

GO

---------------------------------------------------------------------------------------
--case XXXX:
