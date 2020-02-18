IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Doctor]') AND name = N'IX_Doctor_PracticeIDDoctorID')
	DROP INDEX [IX_Doctor_PracticeIDDoctorID] ON [dbo].[Doctor] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Doctor]') AND name = N'IX_Doctor_PracticeID_DoctorID')
	DROP INDEX [IX_Doctor_PracticeID_DoctorID] ON [dbo].[Doctor] WITH ( ONLINE = OFF )
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Doctor_PracticeID_DoctorID] ON [dbo].[Doctor] 
([PracticeID], [DoctorID], [External])
INCLUDE ([Degree], [FirstName], [LastName], [MiddleName], [Prefix], [Suffix])
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Encounter]') AND name = N'IX_Encounter_PracticeID_DateOfService')
	DROP INDEX [IX_Encounter_PracticeID_DateOfService] ON [dbo].[Encounter] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Encounter]') AND name = N'IX_Encounter_PracticeID_DateOfService_EncounterStatusID')
	DROP INDEX [IX_Encounter_PracticeID_DateOfService_EncounterStatusID] ON [dbo].[Encounter] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_Encounter_PracticeID_DateOfService_EncounterStatusID] ON [dbo].[Encounter] 
([PracticeID], [DateOfService], [EncounterStatusID])
INCLUDE ([BatchID], [DoctorID], [EncounterID], [PatientID])
GO