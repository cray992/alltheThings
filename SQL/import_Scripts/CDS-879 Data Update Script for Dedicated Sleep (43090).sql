USE superbill_43090_prod
GO

SET XACT_ABORT ON 

BEGIN TRANSACTION

SET NOCOUNT ON 

UPDATE PatientJournalNote 
	SET Hidden = 1 
FROM dbo.PatientJournalNote spjn
LEFT JOIN (
		SELECT pjn.patientid, pjn.patientjournalnoteid , ROW_NUMBER() OVER(PARTITION BY pjn.PatientID ORDER BY pjn.PatientJournalNoteID DESC) AS rownum
	    FROM dbo.PatientJournalNote pjn
		  ) AS pjnnum ON spjn.PatientJournalNoteID = pjnnum.PatientJournalNoteID
INNER JOIN dbo.Patient p ON 
		spjn.PatientID = p.PatientID AND 
		p.PracticeID = 1
WHERE pjnnum.rownum > 10
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Journal Note records updated'


--ROLLBACK
--COMMIT
