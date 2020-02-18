IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Patient]') AND name = N'IX_Patient_LastName')
	DROP INDEX [IX_Patient_LastName] ON [dbo].[Patient] WITH ( ONLINE = OFF )
GO
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Patient]') AND name = N'IX_Patient_PracticeID_Active_FOR_GetPatients')
	DROP INDEX [IX_Patient_PracticeID_Active_FOR_GetPatients] ON [dbo].[Patient] WITH ( ONLINE = OFF )
GO
	
CREATE NONCLUSTERED INDEX [IX_Patient_PracticeID_Active_FOR_GetPatients] ON [dbo].[Patient] 
(
	[PracticeID] ASC,
	[Active] ASC,
	[LastName] ASC,
	[FirstName] ASC,
	[MiddleName] ASC
)
INCLUDE
(
	[PatientID],
	[AddressLine1],
	[AddressLine2],
	[City],
	[State],
	[ZipCode],
	[HomePhone],
	[SSN],
	[ResponsibleFirstName],
	[ResponsibleLastName],
	[MedicalRecordNumber],
	[DOB]
)
GO