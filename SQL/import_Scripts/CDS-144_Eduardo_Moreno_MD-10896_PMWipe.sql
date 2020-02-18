USE superbill_10896_dev
--USE superbill_10896_prod
GO


DELETE FROM dbo.PatientCase WHERE PracticeID = 1

DELETE FROM dbo.Patient WHERE PracticeID = 1