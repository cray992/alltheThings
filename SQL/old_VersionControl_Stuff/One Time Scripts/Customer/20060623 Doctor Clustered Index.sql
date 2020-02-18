
------------DROP -----------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Encounter_Doctor_01]') AND parent_object_id = OBJECT_ID(N'[dbo].[Encounter]'))
ALTER TABLE [dbo].[Encounter] DROP CONSTRAINT [FK_Encounter_Doctor_01]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Patient_Doctor]') AND parent_object_id = OBJECT_ID(N'[dbo].[Patient]'))
ALTER TABLE [dbo].[Patient] DROP CONSTRAINT [FK_Patient_Doctor]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProviderNumber_Doctor]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProviderNumber]'))
ALTER TABLE [dbo].[ProviderNumber] DROP CONSTRAINT [FK_ProviderNumber_Doctor]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PatientCase_ReferringPhysicianID]') AND parent_object_id = OBJECT_ID(N'[dbo].[PatientCase]'))
ALTER TABLE [dbo].[PatientCase] DROP CONSTRAINT [FK_PatientCase_ReferringPhysicianID]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Patient_PrimaryCarePhysicianID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Patient]'))
ALTER TABLE [dbo].[Patient] DROP CONSTRAINT [FK_Patient_PrimaryCarePhysicianID]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Patient_ReferringPhysician]') AND parent_object_id = OBJECT_ID(N'[dbo].[Patient]'))
ALTER TABLE [dbo].[Patient] DROP CONSTRAINT [FK_Patient_ReferringPhysician]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Encounter_ReferringPhysician]') AND parent_object_id = OBJECT_ID(N'[dbo].[Encounter]'))
ALTER TABLE [dbo].[Encounter] DROP CONSTRAINT [FK_Encounter_ReferringPhysician]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractToDoctor_Doctor]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContractToDoctor]'))
ALTER TABLE [dbo].[ContractToDoctor] DROP CONSTRAINT [FK_ContractToDoctor_Doctor]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Encounter_Doctor]') AND parent_object_id = OBJECT_ID(N'[dbo].[Encounter]'))
ALTER TABLE [dbo].[Encounter] DROP CONSTRAINT [FK_Encounter_Doctor]


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Doctor]') AND name = N'PK_Doctor')
ALTER TABLE [dbo].[Doctor] DROP CONSTRAINT [PK_Doctor]





------------- CREATE --------------------

ALTER TABLE [dbo].[Doctor] ADD  CONSTRAINT [PK_Doctor] PRIMARY KEY NONCLUSTERED
(
	[DoctorID] ASC
)WITH (PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_Doctor] FOREIGN KEY([PrimaryProviderID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_Patient_Doctor]


ALTER TABLE [dbo].[Encounter]  WITH CHECK ADD  CONSTRAINT [FK_Encounter_Doctor_01] FOREIGN KEY([SupervisingProviderID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[Encounter] CHECK CONSTRAINT [FK_Encounter_Doctor_01]


ALTER TABLE [dbo].[ProviderNumber]  WITH CHECK ADD  CONSTRAINT [FK_ProviderNumber_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[ProviderNumber] CHECK CONSTRAINT [FK_ProviderNumber_Doctor]


ALTER TABLE [dbo].[PatientCase]  WITH CHECK ADD  CONSTRAINT [FK_PatientCase_ReferringPhysicianID] FOREIGN KEY([ReferringPhysicianID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[PatientCase] CHECK CONSTRAINT [FK_PatientCase_ReferringPhysicianID]



ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_PrimaryCarePhysicianID] FOREIGN KEY([PrimaryCarePhysicianID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_Patient_PrimaryCarePhysicianID]

ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_ReferringPhysician] FOREIGN KEY([ReferringPhysicianID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_Patient_ReferringPhysician]


ALTER TABLE [dbo].[Encounter]  WITH CHECK ADD  CONSTRAINT [FK_Encounter_ReferringPhysician] FOREIGN KEY([ReferringPhysicianID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[Encounter] CHECK CONSTRAINT [FK_Encounter_ReferringPhysician]


ALTER TABLE [dbo].[ContractToDoctor]  WITH CHECK ADD  CONSTRAINT [FK_ContractToDoctor_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[ContractToDoctor] CHECK CONSTRAINT [FK_ContractToDoctor_Doctor]


ALTER TABLE [dbo].[Encounter]  WITH CHECK ADD  CONSTRAINT [FK_Encounter_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])
GO
ALTER TABLE [dbo].[Encounter] CHECK CONSTRAINT [FK_Encounter_Doctor]


















/****** Object:  Index [ix_Doctor_PracticeIDDoctorID]    Script Date: 06/23/2006 12:20:30 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Doctor]') AND name = N'ix_Doctor_PracticeIDDoctorID')
DROP INDEX [ix_Doctor_PracticeIDDoctorID] ON [dbo].[Doctor] WITH ( ONLINE = OFF )



/****** Object:  Index [ix_Doctor_PracticeIDDoctorID]    Script Date: 06/23/2006 11:25:14 ******/
CREATE CLUSTERED INDEX [ix_Doctor_PracticeIDDoctorID] ON [dbo].[Doctor] 
(
	[PracticeID] ASC,
	[DoctorID] ASC
)WITH (PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]