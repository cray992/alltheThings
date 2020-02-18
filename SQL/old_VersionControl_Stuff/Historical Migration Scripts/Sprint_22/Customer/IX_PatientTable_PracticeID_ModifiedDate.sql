IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Patient]') AND name = N'IX_Patient_PracticeID_ModifiedDate')
BEGIN
	DROP INDEX [IX_Patient_PracticeID_ModifiedDate] ON dbo.Patient
END


CREATE NONCLUSTERED INDEX [IX_Patient_PracticeID_ModifiedDate] ON [dbo].[Patient]
(
	[PracticeId], [ModifiedDate] DESC
)

