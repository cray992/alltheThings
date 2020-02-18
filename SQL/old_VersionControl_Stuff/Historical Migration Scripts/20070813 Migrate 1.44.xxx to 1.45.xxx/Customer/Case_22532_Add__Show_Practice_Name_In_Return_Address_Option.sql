/*-----------------------------------------------------------------------------
Case 22532 - Remove practice name from patient statement return address for 
Medical Recovery Services (801)  
-----------------------------------------------------------------------------*/

ALTER TABLE dbo.Practice ADD
	EStatementsShowPracticeNameInReturnAddress bit NULL
GO

ALTER TABLE dbo.Practice ADD CONSTRAINT
	DF_Practice_EStatementsShowPracticeNameInReturnAddress DEFAULT 1 FOR EStatementsShowPracticeNameInReturnAddress
GO

/* Default existing practices to show the practice name in return address ... */
UPDATE dbo.Practice SET
	EStatementsShowPracticeNameInReturnAddress = 1
GO

UPDATE dbo.Practice SET
	EStatementsShowPracticeNameInReturnAddress = 0
WHERE DB_NAME() LIKE 'superbill_0801_%' AND PracticeID IN (3, 5, 7)
GO