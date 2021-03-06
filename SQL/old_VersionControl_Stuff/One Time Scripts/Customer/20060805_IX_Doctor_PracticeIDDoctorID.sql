
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Doctor]') AND name = N'ix_Doctor_PracticeIDDoctorID')
DROP INDEX [ix_Doctor_PracticeIDDoctorID] ON [dbo].[Doctor] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_Doctor_PracticeIDDoctorID] ON [dbo].[Doctor] 
(
	[PracticeID] ASC,
	[DoctorID] ASC,
	[External] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO